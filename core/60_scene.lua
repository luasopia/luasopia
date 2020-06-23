print('Scene class')

local scenes = {}
local sceneIn = nil -- current (or scheduled to enter) scene in the screen
local Group = Group
local transitionTime = 300
local x0, y0, endx, endy = _luasopia.x0, _luasopia.y0, _luasopia.endx, _luasopia.endy

--------------------------------------------------------------------------------
-- private static methods
--------------------------------------------------------------------------------
local function create(scn)
    _luasopia.stage = scn.__stg__
    scn:create(scn.__stg__)
end

local function beforeshow(scn)
    _luasopia.stage = scn.__stg__
    scn:beforeshow(scn.__stg__)

    -- 이전에 hideout되면서 위치가 화면밖이거나 투명일 수 있으므로
    -- 다시 (표준위치로 )원위치 시켜야 한다.
    scn.__stg__:set{x=0,y=0,s=1,r=0,a=1}
    scn.__stg__:resumetouch()
    scn.__stg__:show()
end

local function aftershow(scn)
    _luasopia.stage = scn.__stg__
    scn:aftershow(scn.__stg__)
end

local function beforehide(scn)
    _luasopia.stage = scn.__stg__
    scn:beforehide(scn.__stg__)
end

local function afterhide(scn)
    print('scene hideout')
    scn.__stg__:stoptouch()
    scn.__stg__:hide()

    _luasopia.stage = scn.__stg__
    scn:afterhide(scn.__stg__)
end
--------------------------------------------------------------------------------
Scene = class()

function Scene:init()
    -- scene은 baselayer에 생성한다.
    -- self.__stg__ = Group(_luasopia.baselayer):xy(0,0)
    -- _luasopia.stage = self.__stg__
    
    self.__stg__ = Group():addto(_luasopia.baselayer):xy(0,0)
    _luasopia.stage = self.__stg__

end    

-- The following methods are optionally overridden.
function Scene:create() end -- 최초에 딱 한 번만 호출됨
function Scene:beforeshow() end -- called just before showing
function Scene:aftershow() end -- called just after showing
function Scene:beforehide() end -- called just before hiding
function Scene:afterhide() end -- called just after hiding
function Scene:destroy() end

--------------------------------------------------------------------------------
-- Scene.goto(url [,effect [,time] ])
-- effect = 'fade', 'slideRight'
--------------------------------------------------------------------------------
function Scene.goto(url, effect, time)
    effect = effect or 'none'
    time = time or transitionTime -- set given/default transition time

    -- 2020/05/29 직전 scene이 없다면 scene0로 설정한다.
    local pastScene = sceneIn or _luasopia.scene0
    -- 과거 scenes테이블을 뒤져서 한 번이라도 create()되었다면 그걸 사용
    -- scenes테이블에 없다면 create를 이용하여 새로 생성하고 scenes에 저장
    sceneIn = scenes[url]
    if sceneIn == nil then
        sceneIn = require(url) -- stage를 새로운 Scene 객체로 교체한다
        scenes[url] = sceneIn
        create(sceneIn)
    end
    
    beforeshow(sceneIn)
    beforehide(pastScene)

    if effect == 'slideRight' then
        
        sceneIn.__stg__:x(screen.endx+1)
        
        if pastScene then 
            pastScene.__stg__:shift{time=time, x=-screen.endx, onend = function()
                afterhide(pastScene)
            end}
        end
        
        sceneIn.__stg__:shift{time=time, x=0, onend = function()
            aftershow(sceneIn)
        end}

-- --[[
    elseif effect == 'rotateRight' then
        
        -- sceneIn.stage:x(screen.width)
        sceneIn.__stg__:set{r=-90}
        
        if pastScene then 
            pastScene.__stg__:shift{time=time, r=90, onend = function()
                afterhide(pastScene)
            end}
        end
        
        sceneIn.__stg__:shift{time=time, x=0, r=0, onend = function()
            aftershow(sceneIn)
        end}
        
--[[
    elseif effect == 'fade' then
        
        sceneIn.stage:setalpha(0)

        if pastScene then 
            pastScene.stage:shift{time=time, alpha = 0, onEnd = function()
                hideOut(pastScene.stage)
                pastScene:afterHide(pastScene.stage)
            end}
        end

        sceneIn.stage:shift{time=time, alpha=1}

 --]]
    else
        if pastScene then hide(pastScene) end
        aftershow(sceneIn)
    end

end

-- 2020/05/29 초기에 scene0를 생성한다
-- baselayer에는 screen(Rect객체)과 scene.__stg__ 만을 집어넣는다
_luasopia.scene0 = Scene()
_luasopia.stage = _luasopia.scene0.__stg__

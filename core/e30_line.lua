-- if not_required then return end -- This prevents auto-loading in Gideros
--------------------------------------------------------------------------------
local Disp = Display
Line = class(Disp)
--------------------------------------------------------------------------------
local WHITE = Color.WHITE

if _Gideros then

    print('core.Rect(gid)')

    local Shape = _Gideros.Shape
    local Sprtnew = _Gideros.Sprite.new
    
    function Line:__draw(x1,y1,x2,y2)
        local s = Shape.new()
        s:beginPath()
        s:setLineStyle(self.__strkw, self.__strkc.hex) -- width, color, alpha
        s:moveTo(x1, y1)
        s:lineTo(x2, y2)
        s:endPath()
        return s
    end

    function Line:init(x1,y1,x2,y2,opt)
        self.__pts = {x1, y1, x2, y2}
        local cx, cy = (x1+x2)/2, (y1+y2)/2
        self.__ptsm = {x1-cx, y1-cy, x2-cx, y2-cy}

        opt = opt or {}
        -------------------------------------------------------------------------
        self.__strkw = opt.width or 1
        self.__strkc = opt.color or WHITE -- stroke color

        self.__bd = Sprtnew()
        self.__sbd = self:__draw(unpack(self.__ptsm))
        self.__bd:addChild(self.__sbd)

        Disp.init(self)
        -- 2020/02/20: xy를 다시 정해진 위치로 맞추어야 한다
        self.__bd:setPosition(cx,cy)
    end

    function Line:width(w)
        self.__strkw = w
        self.__bd:removeChildAt(1)
        self.__bd:addChild(self:__draw(unpack(self.__ptsm)))
        return self
    end

    -- r,g,b는 0-255 범위의 정수
    function Line:color(r,g,b)
        self.__strkc = Color(r,g,b)
        self.__bd:removeChildAt(1)
        self.__bd:addChild(self:__draw(unpack(self.__ptsm)))
        return self
    end

elseif _Corona then --##################################################

    local newLine = _Corona.display.newLine
    local newGroup = _Corona.display.newGroup

    function Line:__draw()
        local s = newLine(unpack(self.__ptsm))
        s.strokeWidth = self.__strkw
        local c = self.__strkc
        s:setStrokeColor(c.r, c.g, c.b)
        return s
    end

    function Line:init(x1,y1,x2,y2,opt)
        local cx, cy = (x1+x2)/2, (y1+y2)/2
        self.__cntr = {cx, cy}
        self.__ptsm = {x1-cx, y1-cy, x2-cx, y2-cy}
        opt = opt or {}
        -------------------------------------------------------------------------

        self.__strkw = opt.width or 1
        self.__strkc = opt.color or WHITE -- line color

        self.__bd = newGroup()
        self.__sbd = self:__draw()
        self.__bd:insert(self.__sbd)
        Disp.init(self)
        -- 2020/02/20: xy를 다시 정해진 위치로 맞추어야 한다
        self.__bd.x, self.__bd.y = cx, cy
    end

    function Line:width(w)
        self.__strkw = w
        self.__sbd.strokeWidth = w
        return self
    end

    -- r,g,b는 0-255 범위의 정수
    -- 2020/02/22 : r 은 Color객체일 수도 있다.
    function Line:color(r, g, b)
        local c = Color(r,g,b)
        self.__sbd:setStrokeColor(c.r, c.g, c.b)
        self.__strkc = c
        return self
    end

end










--[[
if _Gideros then

    print('core.Rect(gid)')

    local Shape = _Gideros.Shape
    local Sprtnew = _Gideros.Sprite.new
    
    function Line:__draw(x1,y1,x2,y2)
        local s = Shape.new()
        s:beginPath()
        s:setLineStyle(self.__strkw, self.__strkc) -- width, color, alpha
        s:moveTo(x1, y1)
        s:lineTo(x2, y2)
        s:endPath()
        return s
    end

    function Line:init(x1,y1,x2,y2,parent)
        self.__pts = {x1, y1, x2, y2}
        local cx, cy = (x1+x2)/2, (y1+y2)/2
        self.__ptsm = {x1-cx, y1-cy, x2-cx, y2-cy}
        self.__strkw = 1
        self.__strkc = 0xffffff

        self.__bd = Sprtnew()
        self.__bd:addChild(self:__draw(unpack(self.__ptsm)))
        self.__pr = parent
        Disp.init(self)
        -- 2020/02/20: xy를 다시 정해진 위치로 맞추어야 한다
        self.__bd:setPosition(cx,cy)
    end

    function Line:width(w)
        self.__strkw = w
        self.__bd:removeChildAt(1)
        self.__bd:addChild(self:__draw(unpack(self.__ptsm)))
        return self
    end

    -- r,g,b는 0-255 범위의 정수
    function Line:color(r,g,b)
        self.__strkc = r*65536+g*256+b
        self.__bd:removeChildAt(1)
        self.__bd:addChild(self:__draw(unpack(self.__ptsm)))
        return self
    end

elseif _Corona then --##################################################

    function Line:__draw()
        local s = _Corona.display.newLine(unpack(self.__ptsm))
        s.strokeWidth = self.__strkw
        s:setStrokeColor(unpack(self.__strkc))
        return s
    end

    function Line:init(x1,y1,x2,y2,parent)
        local cx, cy = (x1+x2)/2, (y1+y2)/2
        self.__cntr = {cx, cy}
        self.__ptsm = {x1-cx, y1-cy, x2-cx, y2-cy}
        self.__strkw = 1
        self.__strkc = {1,1,1}

        self.__bd = _Corona.display.newGroup()
        self.__tbd = self:__draw()
        self.__bd:insert(self.__tbd)
        self.__pr = parent
        Disp.init(self)
        -- 2020/02/20: xy를 다시 정해진 위치로 맞추어야 한다
        self.__bd.x, self.__bd.y = cx, cy
    end

    function Line:width(w)
        self.__strkw = w
        self.__tbd.strokeWidth = w
        return self
    end

    -- r,g,b는 0-255 범위의 정수
    function Line:color(r,g,b)
        self.__strkc = {r/255,g/255,b/255}
        self.__tbd:setStrokeColor(unpack(self.__strkc))
        return self
    end

end
--]]
camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
camera.layers = {}

function camera:set()
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
    love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
    love.graphics.pop()
end

function camera:move(dx,dy)
    camera:setX(self.x + (dx or 0))
    camera:setY(self.y + (dy or 0))
end

function camera:rotate(dr)
    self.rotation = selft.rotation + dr
end

function camera:scale(sx, sy)
    sx = sx or 1
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPositionWithCerp(x,y)
    camera:setX(cerp(x,self.x,0.9))
    camera:setY(y)
end

function camera:setPosition(x,y)
    camera:setX(x)
    camera:setY(y)
end

function camera:setX(x)
    self.x = clamp(x, self.min_X, self.max_X)
end

function camera:setY(y)
    self.y = clamp(y, self.min_Y, self.max_Y)
end

function camera:setBounds(min_X, max_X, min_Y, max_Y)
    self.min_X = min_X
    self.max_X = max_X
    self.min_Y = min_Y
    self.max_Y = max_Y
end

function clamp(n, min, max)
    if min == nil or max == nil then return n end

    return n < min and min or (n > max and max or n)
end

function camera:newLayer(scale, func)
    table.insert(self.layers, {draw = func, scale = scale})
    table.sort(self.layers, function(a, b) return a.scale < b.scale end)
end

function camera:draw()
    local bx,by = self.x, self.y

    for _, v in ipairs(self.layers) do
        self.x = bx * v.scale
        self.y = by * v.scale
        camera:set()
        v.draw()
        camera:unset()
    end
end

function cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end

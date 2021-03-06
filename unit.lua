unit = class:new()

function unit:init()
    self.frame = 1
    self.anim_dt = 0
end

function unit:spawn(world, x, y, object_type, userdata)
    self.body = love.physics.newBody(world, x, y, object_type)
    self.shape = love.physics.newRectangleShape(24, 46)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setRestitution(0.0)
    self.fixture:setUserData(userdata)
    self.body:setFixedRotation(true)

    self.direction = 0
    self.lastx, self.lasty = x, y
end

function unit:update_unit(dt)
    self:update_direction()
end

function unit:update_direction()
    if self.body then
        local x, y = self.body:getPosition()
        if x > self.lastx then
            self.direction = 1
        elseif x < self.lastx then
            self.direction = -1
        elseif x == self.lastx then
            self.direction = 0
        end
        self.lastx, self.lasty = x, y
    end
end

function unit:die()

end

function unit:get_direction()
    return self.direction
end

function unit:compute_animation(animation, state, dt)
    if (self.anim_dt - dt) > 0.05 and state == "moving" then
        self.frame = self.frame + 1
        self.anim_dt = 0
        if self.frame > #animation then
            self.frame = 1
        end
    elseif state == "idle" then
        self.frame = 1
    end
    self.anim_dt = self.anim_dt + dt
    return self.frame
end

function unit:draw_unit(image, animation)
    love.graphics.draw(image, animation[self.frame], self.body:getX()-32, self.body:getY()-32)
end

--death
function unit:death()
    --some generic death stuff
end
--movment
function unit:moveRight(force)
    self.body:applyForce(force, 0)
    self.state = "moving"
end

function unit:moveLeft(force)
    self.body:applyForce(-force, 0)
    self.state = "moving"
end

function unit:moveUp(force)
    self.body:applyForce(0,-force)
end

function unit:moveDown(force)
    self.body:applyForce(0,force)
end


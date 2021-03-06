require 'gui'
require 'unit'
require 'character'
require 'basic_enemy'
require 'basic_ai'
require 'menu'
require 'world/switch_door'

game = {}

function game.load()
    scale=1
    brick = love.graphics.newImage("assets/img/bricks.jpg") -- store in table!!!
    scene = love.graphics.newImage("scene.jpg")
    text = ""
    love.physics.setMeter(64)

    world = love.physics.newWorld(0, 9.81*64, true)
    world:setCallbacks(beginContact, endContact)

    game.objects = {}
    game.objects = level.buildLevel(world)

    game.test = {}
    game.test.door = switch_door:new()
    game.test.door:spawn( world, 600, 540, 700, 500, 'testdoor' )

    units = {}

    player = character:new()
    player:spawn(world, level.charSpawnX-20/2, level.charSpawnY-20/2, 'dynamic', 'player')

--    for i = 1, 4 do
--        table.insert(units, basic_enemy:new())
--    end
--    for i, e in pairs(units) do
--        e:spawn(world, i*400, 600, 'dynamic', 'enemy'..i)
--    end

    --Camera stuff
    camera:newLayer(1, function()

        --add textbox
        love.graphics.setColor(0,0,0, 150)
--        love.graphics.rectangle("fill",camera.x , camera.y, 300, 300)
--        love.graphics.setColor(255, 255, 255)
--        love.graphics.print(text, camera.x, camera.y)

        --add world objects to layer
        for _, object in ipairs( game.objects ) do
            object:draw()
        end

        for _, object in pairs( game.test ) do
            object:draw()
        end

        --add player to layer
        love.graphics.setColor(255, 255, 255)
        player:draw()
        for i, e in pairs(units) do
            e:draw()
        end
    end)
    --add background
    camera:newLayer(0.5, function()
        love.graphics.setColor(255,255,255)
        love.graphics.draw(scene, 0, -200)
    end)
    camera:setBounds(0,level.width-(love.graphics.getWidth()*scale)+20,0,level.height-(love.graphics.getHeight()*scale)+20)
end

function game.update(dt)
    world:update(dt) --this puts the world into motion
    basic_ai.check_proximity(player, units)
    for _, object in pairs( game.test ) do
        object:calculate_distance( player.body:getX(), player.body:getY() )
    end

    player:update(dt)

    for i, e in pairs(units) do
        e:update(dt)
    end

    if string.len(text) > 500 then
        text = ""
    end
     --camera movment
    local screen_width = love.graphics.getWidth()
    local screen_height = love.graphics.getHeight()

    local charX, charY = player.body:getPosition()
    --fixed on player

    local cameraXPoint = charX-((screen_width/2)*scale)+player.look*100
    local cameraYPoint = charY-((screen_height/2)*scale)
    camera:setPositionWithCerp(cameraXPoint, cameraYPoint)
end

function game.keypressed(key)
    player:keypressed(key)
    gui.keypressed(key)
    for _, object in pairs( game.test ) do
        object:keypressed(key)
    end
end

function game.keyreleased(key)
    player:keyreleased(key)
end

function beginContact(a, b, coll)
    player:beginContact(a, b, coll)
    local x, y = coll:getNormal()
    text = text .. "\n" .. a:getUserData() .. " " .. b:getUserData()
end

function endContact(a, b, coll)
end

function game.set_level_objects(objects)
    level_objects = objects
end

function game.draw()
--    camera:set()
--    love.graphics.setColor(0,31,90)
--
--    for i = 1, #game.objects do
--        game.objects[i]:draw()
--        i=i-1
--    end
--
--    gui.draw( camera.x, camera.y )
--
--    love.graphics.setColor(255, 255, 255)
--    player:draw()
--    for i, e in pairs(units) do
--        e:draw()
--    end
--    love.graphics.setColor(0,0,0, 150)
--    love.graphics.rectangle("fill",camera.x , camera.y, 300, 300)
--    love.graphics.setColor(255, 255, 255)
--    love.graphics.print(text, camera.x, camera.y)

--    camera:unset()
    camera:draw()
end

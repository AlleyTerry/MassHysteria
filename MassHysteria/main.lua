function love.load()
    -- world
    world = love.physics.newWorld(0,0)
    -- {} means table
    player1 = {}
    player1.body = love.physics.newBody(world, 400, 200, "dynamic")
    player1.speed = 100
    --player2
    player2 = {}
    player2.body = love.physics.newBody(world, 400, 300, "dynamic")
    player2.speed = 100
    
 
    
    --fire
    fire = {}
    fire.body = love.physics.newBody(world, 100, 100, "kinematic")
    fireSizeX = 100
    fireSizeY = 100
    
end

function love.update(dt)
    world:update(dt)
    --movement code player 1
    local dx, dy = 0,0
    local dx2, dy2 = 0,0

    if love.keyboard.isDown("w") then
        --movement with apply force x, y
        dy = -player1.speed
    end
    if love.keyboard.isDown("s") then
        dy = player1.speed
    end
    if love.keyboard.isDown("d") then
        dx = player1.speed
    end
    if love.keyboard.isDown("a") then
        dx = -player1.speed
    end
    
    player1.body:setLinearVelocity(dx,dy)
    player1.x, player1.y = player1.body:getPosition()
    
    --movement code player 2
    if love.keyboard.isDown("up") then
        dy2 = -player2.speed
    end
    if love.keyboard.isDown("down") then
        dy2 = player2.speed
    end
    if love.keyboard.isDown("right") then
        dx2 = player2.speed
    end
    if love.keyboard.isDown("left") then
        dx2 = -player2.speed
    end

    player2.body:setLinearVelocity(dx2,dy2)
    player2.x, player2.y = player2.body:getPosition()
    
    --fire constantly going out
    fireSizeX = fireSizeX- 10 * dt
    fireSizeY = fireSizeY- 10 * dt
    
    
    
    
end


function love.draw()
    love.graphics.print("Hello World", 400, 300)
    --draws a circle at player position with a radius of 100
    love.graphics.circle("fill", player1.x, player1.y, 100)
    love.graphics.circle("fill", player2.x, player2.y, 100)
    fire.graphics = love.graphics.rectangle("fill", fire.body:getX(), fire.body:getY(), fireSizeX, fireSizeY)
    
end
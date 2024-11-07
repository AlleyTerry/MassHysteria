function love.load()
    -- world
    world = love.physics.newWorld(0,0)

    world:setCallbacks(beginContact, endContact) -- collision callback

    -- {} means table
    -- player1
    player1 = {}
    player1.body = love.physics.newBody(world, 400, 200, "dynamic")
    player1.shape = love.physics.newCircleShape(20) 
    player1.fixture = love.physics.newFixture(player1.body, player1.shape)
    player1.fixture:setUserData("player1")
    player1.speed = 100
    -- player2
    player2 = {}
    player2.body = love.physics.newBody(world, 400, 300, "dynamic")
    player2.shape = love.physics.newCircleShape(20)
    player2.fixture = love.physics.newFixture(player2.body, player2.shape)
    player2.fixture:setUserData("player2")
    player2.speed = 100
    
    -- wood
    wood = {}
    wood.body = love.physics.newBody(world, 300, 300, "dynamic")
    wood.shape = love.physics.newRectangleShape(60, 20)
    wood.fixture = love.physics.newFixture(wood.body, wood.shape)
    wood.fixture:setUserData("wood")
    wood.body:setMass(100)
    wood.fixture:setFriction(0.9)
    
    wood.pushed = false -- Flag used to detect simultaneous collision of two players
    
    wood.player1Contact = false
    wood.player2Contact = false

    -- fire
    fire = {}
    fire.x, fire.y = 100, 100 -- position
    fire.body = love.physics.newBody(world, fire.x, fire.y, "static")
    fire.shape = love.physics.newRectangleShape(100, 100) -- collider of the fire
    fire.fixture = love.physics.newFixture(fire.body, fire.shape)
    fire.fixture: setUserData("fire")
    fire.initialSize = 100  -- initial size of fire
    fire.size = fire.initialSize

    fireCountdown = 10 -- Timer
    
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

    -- an attempt to get the fire to reset if the wood was in the same position as it, that did not work
    
    -- woodX, woodY = wood.body:getPosition()
    -- fireX, fireY = fire.body:getPosition()

    --  if (woodX == fireX or woodY == fireY) then
    --      fireCountdown = 10 -- reset Timer
    --      fire.size = fire.initialSize -- reset fire size
    --      print("More fire!!")
    --  end
    
    -- collision
    if wood.player1Contact and wood.player2Contact then
        wood.pushed = true
    else if wood.player1Contact == false or wood.player2Contact == false then
        wood.pushed = false
    end

    -- if two players collide with the wood at the same time
    if wood.pushed then
        -- Calculate the combined push force based on both players' movement
        local pushForceX = (dx + dx2) * 10
        local pushForceY = (dy + dy2) * 10
        
        -- Apply force to wood to simulate pushing
        wood.body:applyForce(pushForceX, pushForceY)
    end

    -- timer and fire constantly going out
    fireCountdown = fireCountdown - dt

        if fireCountdown > 0 then
            fire.size = fire.initialSize * (fireCountdown / 10) -- shrinking
            end
        
    print(wood.pushed, 300, 300)
end

function love.draw()
    love.graphics.print("Hello World", 400, 300)

    --draws a circle at player position with a radius of 20
    love.graphics.circle("fill", player1.x, player1.y, 20)
    love.graphics.circle("fill", player2.x, player2.y, 20)
    fire.graphics = love.graphics.rectangle("fill", fire.body:getX(), fire.body:getY(), fire.size, fire.size)
    
    -- drawing wood
    love.graphics.setColor(0.5, 0.25, 0)
    love.graphics.polygon("fill", wood.body:getWorldPoints(wood.shape: getPoints()))

    -- timer
    -- when timer reaches 0, says game over instead
    love.graphics.setColor(1, 1, 1)
    if fireCountdown > 0 then
        love.graphics.print("Timer: " ..string.format("%.1f", fireCountdown), 10, 10)
    end
    if fireCountdown <= 0 then
    love.graphics.print("Game Over", 10, 10)
    end
end

-- Collision Enter!
function beginContact(a, b, coll)
    
    -- if player1 and player2 collide w/ the wood
    if a:getUserData() == "wood" and b:getUserData() == "player1" then
        wood.player1Contact = true
    end    
    if a:getUserData() == "wood" and b:getUserData() == "player2" then
        wood.player2Contact = true
    end

    if (a:getUserData() == "fire" and b:getUserData() == "wood") or
       (a:getUserData() == "wood" and b:getUserData() == "fire") then
        fireCountdown = 10 -- reset Timer
        fire.size = fire.initialSize -- reset fire size
        print("More fire!!")
    end
end

-- Collision Exit!!
function endContact(a, b, coll)
    -- players stop colliding w/ the wood
    if a:getUserData() == "wood" and b:getUserData() == "player1" then
        wood.player1Contact = false
    elseif a:getUserData() == "wood" and b:getUserData() == "player2" then
        wood.player2Contact = false
    end

end

end
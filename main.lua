local anim8 = require 'modules/anim8/anim8'
local wf = require 'modules/windfield/windfield'

function love.load()
  sprites = {
    playerSheet = love.graphics.newImage('sprites/playerSheet.png')
  }

  local grid = anim8.newGrid(
    614,
    564,
    sprites.playerSheet:getWidth(),
    sprites.playerSheet:getHeight()
  )

  animations = {
    idle = anim8.newAnimation(grid('1-15', 1), 0.05),
    jump = anim8.newAnimation(grid('1-7', 2), 0.05),
    run = anim8.newAnimation(grid('1-15', 3), 0.05)
  }

  world = wf.newWorld(0, 800, false)

  world:addCollisionClass('Platform')
  world:addCollisionClass('Player')
  world:addCollisionClass('Danger')

  player = world:newRectangleCollider(360, 100, 40, 100, {
    collision_class = 'Player'
  })
  player:setFixedRotation(true)
  player.speed = 240
  player.animation = animations.idle
  player.isMoving = false

  platform = world:newRectangleCollider(250, 400, 300, 100, {
    collision_class = 'Platform'
  })
  platform:setType('static')

  dangerZone = world:newRectangleCollider(0, 550, 800, 50, {
    collision_class = 'Danger'
  })
  dangerZone:setType('static')
end

function love.update(dt)
  world:update(dt)

  if player.body then
    player.isMoving = false
    local px, py = player:getPosition()
    if love.keyboard.isDown('right') then
      player:setX(px + player.speed * dt)
      player.isMoving = true
    end

    if love.keyboard.isDown('left') then
      player:setX(px - player.speed * dt)
      player.isMoving = true
    end

    if player:enter('Danger') then
      player:destroy()
    end
  end

  if player.isMoving then
    player.animation = animations.run
  else
    player.animation = animations.idle
  end

  player.animation:update(dt)
end

function love.draw()
  world:draw()

  local px, py = player:getPosition()
  player.animation:draw(
    sprites.playerSheet,
    px,
    py,
    nil,
    0.25,
    nil,
    130,
    300
  )
end

function love.keypressed(key)
  if key == 'up' then
    local colliders = world:queryRectangleArea(
      player:getX() - 20,
      player:getY() + 50,
      40,
      2,
      { 'Platform' }
    )

    if #colliders > 0 then
      player:applyLinearImpulse(0, -3500)
    end

  end
end

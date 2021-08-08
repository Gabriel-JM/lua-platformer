local anim8 = require 'modules/anim8/anim8'
local wf = require 'modules/windfield/windfield'

function love.load()
  love.window.setMode(1000, 768)

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

  player = require('./player')

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
  playerUpdate(dt)
end

function love.draw()
  world:draw()
  drawPlayer()
end

function love.keypressed(key)
  if key == 'up' then
    if player.grounded then
      player:applyLinearImpulse(0, -3500)
    end
  end
end

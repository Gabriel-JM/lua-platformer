local anim8 = require 'modules/anim8/anim8'
local wf = require 'modules/windfield/windfield'
local sti = require 'modules/Simple-Tiled-Implementation/sti'
local cameraFile = require 'modules/hump/camera'

function love.load()
  love.window.setMode(1000, 768)

  camera = cameraFile()
  sprites = {
    playerSheet = love.graphics.newImage('sprites/playerSheet.png'),
    enemySheet = love.graphics.newImage('sprites/enemySheet.png')
  }

  local grid = anim8.newGrid(
    614,
    564,
    sprites.playerSheet:getWidth(),
    sprites.playerSheet:getHeight()
  )
  local enemyGrid = anim8.newGrid(
    100,
    79,
    sprites.enemySheet:getWidth(),
    sprites.enemySheet:getHeight()
  )

  animations = {
    idle = anim8.newAnimation(grid('1-15', 1), 0.05),
    jump = anim8.newAnimation(grid('1-7', 2), 0.05),
    run = anim8.newAnimation(grid('1-15', 3), 0.05),
    enemy = anim8.newAnimation(enemyGrid('1-2', 1), 0.03)
  }

  world = wf.newWorld(0, 800, false)

  world:addCollisionClass('Platform')
  world:addCollisionClass('Player')
  world:addCollisionClass('Danger')

  player = require('./player')

  require('spawnPlatform')
  require('enemy')

  -- dangerZone = world:newRectangleCollider(0, 550, 800, 50, {
  --   collision_class = 'Danger'
  -- })
  -- dangerZone:setType('static')

  platforms = {}

  loadMap()
end

function love.update(dt)
  world:update(dt)
  gameMap:update(dt)
  playerUpdate(dt)
  updateEnemies(dt)

  local px, py = player:getPosition()
  camera:lookAt(px, love.graphics.getHeight() / 2)
end

function love.draw()
  camera:attach()

  gameMap:drawLayer(gameMap.layers['Tile Layer 1'])
  world:draw()
  drawPlayer()
  drawEnemies()

  camera:detach()
end

function love.keypressed(key)
  if key == 'up' then
    if player.grounded then
      player:applyLinearImpulse(0, -3500)
    end
  end
end

function loadMap()
  gameMap = sti('maps/level1.lua')

  for _, obj in pairs(gameMap.layers['Platforms'].objects) do
    spawnPlatform(obj.x, obj.y, obj.width, obj.height)
  end

  for _, enemyObj in pairs(gameMap.layers['Enemies'].objects) do
    spawnEnemy(enemyObj.x, enemyObj.y)
  end
end

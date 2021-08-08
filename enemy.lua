enemies = {}

function spawnEnemy(x, y)
  local width, height = 70, 90
  local enemy = world:newRectangleCollider(x, y, width, height, {
    collision_class = 'Danger'
  })
  enemy.direction = 1
  enemy.speed = 200
  enemy.animation = animations.enemy

  table.insert(enemies, enemy)
end

function updateEnemies(dt)
  for _, enemy in ipairs(enemies) do
    enemy.animation:update(dt)

    local ex, ey = enemy:getPosition()

    local colliders = world:queryRectangleArea(
      ex + (40 * enemy.direction),
      ey + 40,
      10,
      10,
      { 'Platform' }
    )

    if #colliders == 0 then
      enemy.direction = enemy.direction * -1
    end

    enemy:setX(ex + enemy.speed * dt * enemy.direction)
  end
end

function drawEnemies()
  for _, enemy in ipairs(enemies) do
    local ex, ey = enemy:getPosition()

    enemy.animation:draw(sprites.enemySheet, ex, ey, nil, enemy.direction, 1, 50, 65)
  end
end

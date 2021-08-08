function spawnPlatform(x, y, width, height)
  if width > 0 and height > 0 then
    local platform = world:newRectangleCollider(x, y, width, height, {
      collision_class = 'Platform'
    })
    platform:setType('static')

    table.insert(platforms, platform)
  end
end
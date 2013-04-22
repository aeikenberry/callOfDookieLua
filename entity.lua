require("state")

Entity = {}
Entity.__index = Entity

function Entity.create(type)
    local entity = {}
    setmetatable(entity, Entity)

    entity.x = 0;
    entity.y = 0;
    entity.lastX = 0;
    entity.lastY = 0;
    entity.vx = 0;
    entity.vy = 0;
    entity.dx = 1;
    entity.dy = 0;
    entity.w = 1;
    entity.h = 1;
    entity.type = type
    entity.state = State.create("initial")
    return entity
end

function Entity:getPosition()
    return self.x, self.y
end

function Entity:destroy()
    entity.destroyed = true
end

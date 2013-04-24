require('entity')
require('state')

Patron = {}
Patron.__index = Patron

local patrons = {
    "patron1",
    "patron2"
}
Patron.VARIANT_COUNT = table.getn(patrons)
local positions = {
    200,
    300,
    400,
    500,
    600,
    700
}
local patronsImg = {}
for i, v in ipairs(patrons) do
    patron = {}
    patron.normal = love.graphics.newImage("img/patrons/" .. patrons[i] .. ".png")
    patron.danger = love.graphics.newImage("img/patrons/" .. patrons[i] .. "-danger.png")
    patron.gross = love.graphics.newImage("img/patrons/" .. patrons[i] .. "-gross.png")
    patron.walking = love.graphics.newImage("img/patrons/" .. patrons[i] .. "-walking.png")
    patron.finish = love.graphics.newImage("img/patrons/" .. patrons[i] .. "-finish.png")
    patronsImg[i] = patron
end

function Patron.create()
    local var = math.random(Patron.VARIANT_COUNT)
    local s = {}
    setmetatable(s, Patron)
    s.position = tonumber(string.sub(tostring(positions[math.random(#positions)]), 1, 11))
    s.x = s.currentPosition
    s.y = 300
    s.walkingSpeed = .5
    s.irritibility = math.random(30)
    s.imgSet = patronsImg[var]
    s.state = State.create('normal')
    s.anim = newAnimation(s.imgSet.normal, 125, 300, 0.1, 0)
    s.anim:setMode('loop')
    return s
end

function Patron:update(dt)
    self.anim:update(dt)
end

function Patron:draw()
    if self.finished then
        return
    end
    self.anim:draw(self.position, 300)
end

function Patron:getPosition()
    return self.currentPosition
end

function Patron:destroy()
    self.finished = true
end

function Patron:walk(from, to)
    self.state = State.create('walking')
end

function Patron:getState()
    return self.state.name
end

---  Param Choices Are:
--'normal'
--'danger'
--'gross'
--'walking'
--'finish'
function Patron:changeAnim(state)
    self.anim = nil
    self.anim = newAnimation(self.imgSet[state], 125, 300, 0.1, 0)
    self.state:setState(state)
end

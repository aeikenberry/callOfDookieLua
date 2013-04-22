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
    local var = math.random(self.VARIANT_COUNT)
    local p = {}
    setmetatable(p, Patron)
    s.currentPosition = positions[6]
    s.x = s.currentPosition
    s.y = 300
    s.walkingSpeed = .5
    s.irritibility = math.random(30)
    s.imgSet = patronsImg[var]
    s.state = State.create('normal')
    s.anim = newAnimation(s.imgSet[s.state], 100, 300, 0.1, 0)
    s.anim:setMode('loop')

    return p
end

function Patron:update(dt)
    self.anim:update(dt)
end

function Patron:draw()
    if self.finished then
        return
    end
    self.anim:draw(self.currentPosition, 300)
end

function Patron:getPosition()
    return self.currentPosition
end

function Patron:destroy()
    self.finished = true
end

function Patron:walk(from, to)
    self.state = State.create('walking')
    self.anim

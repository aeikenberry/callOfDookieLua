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
    400,
    500,
    600,
    700,
    800,
    900
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

function Patron.create(pos)
    local var = math.random(Patron.VARIANT_COUNT)
    local s = {}
    setmetatable(s, Patron)
    s.position = pos or positions[math.random(#positions)]
    s.y = 300
    s.speed = 50
    s.xvel = 0
    s.irritibility = math.random(30)
    s.imgSet = patronsImg[var]
    s.state = 'normal'
    s.selected = false
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

function Patron:destroy()
    self.finished = true
    self.selected = false
    self.position = -100
end

function Patron:shiftLeft()
    self.position = self.position - 100
end


function Patron:switchWith(patron)
    y = patron.y
    pos = patron.position

    patron.y = self.y
    patron.position = self.position
    
    self.y = y
    self.position = pos

    self:change('normal')
    patron:change('normal')
end


function Patron:walk(pos, y)
    self:change('walking')
    self.position = x
    self.y = y
end

function Patron:getState()
    return self.state
end

---  Param Choices Are:
--'normal'
--'danger'
--'gross'
--'walking'
--'finish'
function Patron:change(state)
    self.anim = nil
    self.anim = newAnimation(self.imgSet[state], 125, 300, 0.1, 0)
    self.state = state
end

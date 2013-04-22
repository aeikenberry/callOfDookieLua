require('AnAL')



function love.load()
    -- Bouncer's Pointing Animation
    local p = love.graphics.newImage('img/BouncerPointerSprite.png')
    point = newAnimation(p, 216, 300, 0.1, 5)
    point:setMode('once')
    point:stop() -- So he starts off not pointing

    -- Selection Hand
    hand = {}
    hand['img'] = love.graphics.newImage('img/PointerHand.png')
    hand['x'] = 300 -- Initial values
    hand['y'] = 400 -- Initial values
    hand['position'] = 3 -- Initial position
end

function love.update(dt)
    if pointing then
        point:play()
        pointing = false
    end

    if retracting then
        point:playReverse()
        retracting = false
    end

    -- Bouncer will always be on the screen
    point:update(dt)

end

--- What's going to get drawn?
function love.draw()
    point:draw(100, 100)
    love.graphics.draw(hand['img'], hand['x'], hand['y'])
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.keypressed(key, unicode)
    
    if key == 'a' then
        pointing = true
        if retracting then
            retracting = false
        end
    end

    --- Hand Movement
    -- left
    if key == 'left' and hand['x'] ~= 100 then
        hand['x'] = hand['x'] - 100
        hand['position'] = hand['position'] - 1
    end
    -- right
    if key == 'right' and hand['x'] ~= 600 then
        hand['x'] = hand['x'] + 100
        hand['position'] = hand['position'] + 1
    end

    -- Patron Selection
    -- if key == 'return' then
    --     -- Check to see if there is a patron at that spot
    --     position = hand['position']
    --     for patron=1, #patrons, 1 do
    --         if patrons[patron]['position'] = position then
    --             -- We selected this one.
    --         end
    --     end


end

function love.keyreleased(key, unicode)
    if key == 'a' then
        pointing = false
        retracting = true
    end
end

function love.focus(f)
    if not f then
       print('lost focus')
    else
       print('gained focus')
    end
end

function love.quit()
    print('seeya sucker!')
end
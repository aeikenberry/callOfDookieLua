require('AnAL')
require('patron')


function love.load()
    -- Bouncer's Pointing Animation
    local p = love.graphics.newImage('img/BouncerPointerSprite.png')
    point = newAnimation(p, 216, 300, 0.1, 5)
    point:setMode('once')
    point:stop() -- So he starts off not pointing

    -- Selection Hand
    hand = {}
    hand['img'] = love.graphics.newImage('img/PointerHand.png')
    hand['y'] = 610 -- Initial values
    hand['position'] = 300 -- Initial position

    patrons = {}
    patrons[1] = Patron.create()
    patrons[2] = Patron.create()
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
    for i,v in ipairs(patrons) do patrons[i]:update(dt) end


end

--- What's going to get drawn?
function love.draw()
    point:draw(100, 400)
    for i,v in ipairs(patrons) do patrons[i]:draw(100, 300) end
    love.graphics.draw(hand['img'], hand['position'], hand['y'])
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
    if key == 'left' and hand['position'] ~= 300 then
        hand['position'] = hand['position'] - 100
    end
    -- right
    if key == 'right' and hand['x'] ~= 900 then
        hand['position'] = hand['position'] + 100
    end

    -- Patron Selection
    if key == 'return' then
        -- Check to see if there is a patron at that spot
        position = hand['position']
        selected = false
        selectedPatron = nil
        for patron=1, #patrons, 1 do 
            if patrons[patron].selected == true then
                selected = true
                selectedPatron = patrons[patron]
            end
        end

        for patron=1, #patrons, 1 do
            print(patrons[patron]['position'], position)
            if patrons[patron]['position'] == position then
                -- We selected this one.
                if patrons[patron]:getState() ~= 'danger' then
                    if selected == true then
                        print(selectedPatron)
                        patrons[patron]:switchWith(selectedPatron)
                        patrons[patron]:change('normal')
                        selectedPatron:change('normal')
                        selected = false
                        break
                    else
                        patrons[patron]:change('danger')
                        patrons[patron].selected = true
                        selected = true
                        break
                    end
                else
                    patrons[patron]:change('normal')
                    patrons[patron].selected = false
                end
            end
        end
    end


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
require('AnAL')
require('patron')


function love.load()
    -- Bouncer's Pointing Animation
    bouncer = {}
    local p = love.graphics.newImage('img/BouncerPointerSprite.png')
    bouncer.point = newAnimation(p, 216, 300, 0.1, 5)
    bouncer.point:setMode('once')
    bouncer.point:stop() -- So he starts off not pointing
    bouncer.pointing = false
    bouncer.retracting = false

    -- Selection Hand
    hand = {}
    hand.img = love.graphics.newImage('img/PointerHand.png')
    hand.y = 610 -- Initial values
    hand.position = 500 -- Initial position

    -- initial patrons
    patrons = {}
    patrons[1] = Patron.create()
    patrons[2] = Patron.create()

    -- container for tracking selection
    selected = {}
    selected.selected = false
    selected.person = nil

    -- level configs
    reserve_patrons = 20
    speed = 100
    counter = 0
    time_to_shift = false
end

function love.update(dt)

    if counter == speed and #patrons ~= 0 then
        time_to_shift = true
    end

    if bouncer.pointing then
        bouncer.point:play()
        -- only play this once
        bouncer.pointing = false
    end

    if bouncer.retracting then
        bouncer.point:playReverse()
        -- make sure we're not calling this over and over
        bouncer.retracting = false
    end

    -- Bouncer will always be on the screen
    bouncer.point:update(dt)
    for i,v in ipairs(patrons) do patrons[i]:update(dt) end

    -- shift them left if it's time.
    if time_to_shift then
        
        for patron=1, #patrons, 1 do 
            local p = patrons[patron]
            p:shiftLeft()
            
            if p.position < 400 then
                p:destroy()
                --table.remove(patrons, patron)
            end
        end

        if reserve_patrons > 0 then
            table.insert(patrons, Patron.create(900))
            reserve_patrons = reserve_patrons - 1
         end

         counter = 0
         time_to_shift = false

         if #patrons == 0 then
            game_over = true
        end
    end
    counter = counter + 1
end

--- What's going to get drawn?
function love.draw()
    bouncer.point:draw(100, 400)
    for i,v in ipairs(patrons) do patrons[i]:draw(100, 300) end
    love.graphics.draw(hand.img, hand.position, hand.y)
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.keypressed(key, unicode)
    local position = hand.position

    --- Hand Movement
    -- left
    if key == 'left' and position ~= 400 then
        hand.position = position - 100
    end
    -- right
    if key == 'right' and position ~= 900 then
        hand.position = position + 100
    end

    -- Patron Selection
    if key == 'return' then

        -- Check to see if there is a patron at that spot
        for patron=1, #patrons, 1 do 
            if patrons[patron].selected == true then
                selected.selected = true
                selected.person = patrons[patron]
            end
        end

        for patron=1, #patrons, 1 do
            local p = patrons[patron]
            
            if p.position == position then
 
                bouncer.pointing = true

                if p.state ~= 'danger' then
                    
                    if selected.selected == true and selected.person ~= p then
                        
                        -- time to switch
                        p:switchWith(selected.person)
                        p.selected = false

                        selected.selected = false
                        selected.person = nil

                        bouncer.retracting = true

                        break
                        
                    else
                        
                        p:change('danger')
                        p.selected = true
                        
                        selected.selected = true
                        selected.person = p

                        break
                        
                    end
                else
                    p:change('normal')
                    p.selected = false
                    bouncer.retracting = true

                    break
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
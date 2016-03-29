slime = require("slime")
helper = require("helper")
cell = require("cell")
game = {
    isbusy = false,
    bagY = 86
    }


-- Loads the given game stage
function game.warp(self, stage)
    self.stage = stage
    stage:setup()
end


function game.busy()
    game.isbusy = true
end


function game.unbusy()
    game.isbusy = false
end


function love.load ()
    -- Nearest image interpolation (pixel graphics, no anti-aliasing)
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    slime.settings["speech font"] = love.graphics.newFont(8)
    slime.settings["status font"] = love.graphics.newFont(8)
    -- Load the first stage
    game:warp(cell)
end


function love.draw ()
    love.graphics.push()
    love.graphics.scale(scale)
    slime:draw(scale)
    love.graphics.pop()
    slime:debugdraw()
end


function love.update (dt)
    
    helper:update(dt)
    
    slime:update(dt)
    
    -- display hover over objects
    local x, y = love.mouse.getPosition()
    -- Adjust for scale
    x = math.floor(x / scale)
    y = math.floor(y / scale)
    local objects = slime:getObjects(x, y)
    if objects then
        local items = ''
        for _, hoverobject in pairs(objects) do
            items = string.format("%s %s", hoverobject.name, items)
        end
        slime:status(items)
    else
        slime:status()
    end
    
end


function love.keypressed (key, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
end


-- Left clicking moves our Ego actor, and interacts with objects.
function love.mousepressed (x, y, button)

    if game.isbusy then
        slime:skipSpeech()
        return
    end
    
    -- Adjust for scale
    x = math.floor(x / scale)
    y = math.floor(y / scale)

    -- Left mouse button
    if button == "l" then
    
        -- The point is in our bag inventory area
        if (y > game.bagY) then
            local button = slime:getObjects(x, y)
            if button then
                local cursorSize = { button[1].image:getDimensions() }
                slime:setCursor(button[1].name, button[1].image, scale, 
                    cursorSize[1]/2, cursorSize[2]/2)
            end
        else
            if slime:someoneTalking() then
                slime:skipSpeech()
            else
                -- Move Ego then interact with any objects
                --if not slime:interact(x, y) then
                    slime:moveActor("ego", x, y)
                --end
            end
        end

    end
    
    -- Right clicks uses the default cursor
    if button == "r" then
        slime:setCursor()
    end
    
end


-- Position bag buttons
function slime.inventoryChanged (bag)
    slime.bagButtons = { }
    local xpos = 10
    for counter, item in pairs(slime:bagContents("ego")) do
        slime:bagButton(item.name, item.image, xpos, game.bagY)
        xpos = xpos + item.image:getWidth() + 4
    end
end

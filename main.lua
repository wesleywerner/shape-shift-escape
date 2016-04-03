slime = require("slime")
helper = require("helper")
cast = require("cast")
costumes = require("costumes")
cell = require("cell")
hallway = require("hallway")
security = require("security")
lab = require("lab")
storage = require("storage")
exithallway = require("exit-hallway")
shapeshift = require("shapeshift")
game = {
    egoshape = "monster",
    scientistReceivedReport = false,
    guardsKnockedOut = false,
    takenKnockoutGas = false,
    firstStoreVisit = true,
    isbusy = false,
    bagY = 86
    }
speech = nil


-- Loads the given game stage
function game.warp(self, stage)
    self.lastStage = self.stage
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
    
    -- enable debugging
    --if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    -- Random seed
    math.randomseed(os.time())
    
    -- Nearest image interpolation (pixel graphics, no anti-aliasing)
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    
    -- Slime settings
    slime.settings["speech font"] = love.graphics.newFont(8)
    slime.settings["speech position"] = 80
    slime.settings["status font"] = love.graphics.newFont(8)
    slime.settings["walk and talk"] = true
    slime.settings["builtin text"] = true
    
    -- Hook into the speech draw call
    slime.onDrawSpeechCallback = onDrawSpeech
    
    -- Speech font
    speechfont = love.graphics.newFont(20)
    
    -- Load the first stage
    --game:warp(cell)
    
    -- testing
    local bagitem = {
        ["name"] = "security card",
        ["image"] = "images/security-pass-inventory.png"
        }
    slime:bagInsert("ego", bagitem)
    
    game.scientistReceivedReport = true
    game.egoshape = "guard"
    game.stage = hallway
    game:warp(exithallway)
end


function love.draw ()
    love.graphics.push()
    love.graphics.scale(scale)
    slime:draw(scale)
    love.graphics.pop()
    drawSpeech()
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
            if hoverobject.name ~= "ego" then
                items = string.format("%s %s", hoverobject.name, items)
            end
        end
        slime:status(items)
    else
        slime:status()
    end
    
end


function love.keypressed (key, isrepeat)
    if key == "escape" then
        love.event.quit()
    elseif key == "tab" then
        slime.debug.enabled = not slime.debug.enabled
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
            if button and button[1].image then
                local cursorSize = { button[1].image:getDimensions() }
                slime:setCursor(button[1].name, button[1].image, scale, 
                    cursorSize[1]/2, cursorSize[2]/2)
            end
        end
            
        if slime:someoneTalking() then
            slime:skipSpeech()
        else
            -- Check with the current stage if we should walk up
            -- to an object first, or interact without movement
            if game.stage.onMoveTo then
                local hasmoved = false
                local objects = slime:getObjects(x, y)
                local action = slime.cursorName or "interact"
                if objects then
                    for _, item in pairs(objects) do
                        if game.stage:onMoveTo(action, item.name) then
                            hasmoved = true
                            slime:moveActor("ego", x, y)    
                        end
                    end
                else
                    -- no objects found, allow move
                    slime:moveActor("ego", x, y)    
                end
                if not hasmoved then
                    slime:interact(x, y)
                end
            else
                -- Move Ego then interact with any objects
                slime:moveActor("ego", x, y)
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


function onDrawSpeech (self, actorX, actorY, speechcolor, words)
    speech = {actorX=actorX, actorY=actorY, speechcolor=speechcolor, words=words}
end


function drawSpeech ()
    if speech then
        local x = speech.actorX * scale
        local y = speech.actorY * scale
        love.graphics.push()
        -- black border
        love.graphics.setColor({0, 0, 0, 255})
        love.graphics.printf(speech.words, x+2, y - 98, 200, "left")
        
        love.graphics.setColor(speech.speechcolor)
        love.graphics.setFont(speechfont)
        love.graphics.printf(speech.words, x, y - 100, 200, "left")
        love.graphics.setColor({255, 255, 255, 255})
        love.graphics.pop()
    end
end

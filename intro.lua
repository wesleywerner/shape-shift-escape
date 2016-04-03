local intro = {}

function intro.setup (self)

    -- Hook into the slime callbacks
    slime.callback = intro.onCallback
    slime.animationLooped = intro.onAnimationLooped
    
    -- Clear the stage
    slime:reset()
    
    local extraextra = love.audio.newSource("sounds/extraextra.wav", "static")
    love.audio.play(extraextra)

    -- Add the background
    local n = 0.05
    slime:background("images/newspaper12.png", n)
    slime:background("images/newspaper11.png", n)
    slime:background("images/newspaper10.png", n)
    slime:background("images/newspaper9.png", n)
    slime:background("images/newspaper8.png", n)
    slime:background("images/newspaper7.png", n)
    slime:background("images/newspaper6.png", n)
    slime:background("images/newspaper5.png", n)
    slime:background("images/newspaper4.png", n)
    slime:background("images/newspaper3.png", n)
    slime:background("images/newspaper-start.png", 600)
    
    local actor = slime:actor("play", 150, 80)
    actor:setImage("images/monster-button.png")
    
end


function intro.onCallback (event, object)

    if object.name == "play" then
        game:warp(cell)
    end
    
end


function intro.onAnimationLooped (actor, key, counter)
    
    
end


function intro.onMoveTo (self, action, name)
    

end


return intro
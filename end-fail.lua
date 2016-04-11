local fail = {}

function fail.setup (self)

    -- Hook into the slime callbacks
    slime.callback = fail.onCallback
    slime.animationLooped = fail.onAnimationLooped
    
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
    slime:background("images/newspaper-failed.png", 6)
    slime:background("images/end-thanks.png", 600)
    
    local actor = slime:actor("retry", 10, 80)
    actor:setImage("images/monster-button.png")
    
    game:reset()

    game:unbusy()
    
end


function fail.onCallback (event, object)

    if object.name == "retry" then
        game:warp(intro)
    end
    
end


function fail.onAnimationLooped (actor, key, counter)
    
end


function fail.onMoveTo (self, action, name)

end


return fail
local fail = {}

function fail.setup (self)

    -- Hook into the slime callbacks
    slime.callback = fail.onCallback
    slime.animationLooped = fail.onAnimationLooped
    
    -- Clear the stage
    slime:reset()

    -- Add the background
    slime:background("images/end-thanks.png")
    
end


function fail.onCallback (event, object)

end


function fail.onAnimationLooped (actor, key, counter)
    
end


function fail.onMoveTo (self, action, name)

end


return fail
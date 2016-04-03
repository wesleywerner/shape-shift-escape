local win = {}

function win.setup (self)

    -- Hook into the slime callbacks
    slime.callback = win.onCallback
    slime.animationLooped = win.onAnimationLooped
    
    -- Clear the stage
    slime:reset()

    -- Add the background
    slime:background("images/end.png")
    
end


function win.onCallback (event, object)

    slime:log(event .. " on " .. object.name)
    
    if (event == "moved" and object.name == "ego") then
        slime:interact(object.clickedX, object.clickedY)
    end
    
end


function win.onAnimationLooped (actor, key, counter)
    
    
end


function win.onMoveTo (self, action, name)
    
    -- skip moving to these items
    local skip = {}
    skip.actorOrHotspotName = true
    skip.onlyOnInteractActions = action == "interact"
    return not skip[name]

end


return win
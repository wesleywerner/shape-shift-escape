local template = {}

function template.setup (self)

    -- Hook into the slime callbacks
    slime.callback = cell.onCallback
    slime.animationLooped = cell.onAnimationLooped
    
    -- Clear the stage
    slime:reset()

    -- Add the background
    slime:background("images/background.png")
    
    -- Apply the walk-behind layer
    slime:layer("images/background.png", "images/layer.png", 50)
    
    -- Set the floor
    slime:floor("images/floor-closed.png")
    
    -- Add our main actor
    cast.ego(70, 50)
    
end


function template.onCallback (event, object)

    slime:log(event .. " on " .. object.name)
    
end


function template.onAnimationLooped (actor, key, counter)
    
    
end


function template.onMoveTo (self, action, name)
    
    -- skip moving to these items
    local skip = {}
    skip.actorOrHotspotName = true
    skip.onlyOnInteractActions = action == "interact"
    return not skip[name]

end


return template
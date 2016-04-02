local template = {}

function template.setup (self)

    -- Hook into the slime callbacks
    slime.callback = cell.callback
    slime.animationLooped = cell.animationLooped
    
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


function template.callback (event, object)

    slime:log(event .. " on " .. object.name)
    
end


function template.animationLooped (actor, key, counter)
    
    
end


function template.moveTo (self, name)
    
    -- skip moving to these items
    local skip = {}
    skip.actorOrHotspotName = true
    return not skip[name]

end


return template
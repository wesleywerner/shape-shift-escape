local cast = {}

function cast.ego (x, y)

    -- Add an actor named "ego"
    local ego = slime:actor("ego", x, y)
    
    -- The time between actor steps. More delay means slower steps.
    ego.movedelay = 0.05

    costumes.monster(ego)
    
end


function cast.guard (x, y, name)
    local actor = slime:actor(name, x, y)
    actor.movedelay = 0.05
    costumes.guard(actor)
end


return cast
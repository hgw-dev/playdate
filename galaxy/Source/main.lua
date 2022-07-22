import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

-- import 'ship'
import 'modules/star'
import 'modules/globals'
import 'modules/galaxy'
import 'modules/solarsystem'

-- local solarSystem = nil

-- local optionList
local function initialize()
    gfx.setBackgroundColor(gfx.kColorBlack)
    gfx.fillRect(0, 0, 400, 240)

    -- solarSystem = Solarsystem()
    -- optionList = OptionList()
    galaxy = Galaxy()
    galaxy:drawGalaxy()
    -- local ship = Ship(200, 120, 15, 15)
end

initialize()

local currentCrankPosition = nil
isModfiyingVariables = false


-- function pd.update()
    -- function pd.upButtonDown()
    --     galaxy:moveCamera(0, -1)
    -- end
    -- function pd.downButtonDown()
    --     galaxy:moveCamera(0, 1)
    -- end
    -- function pd.leftButtonDown()
    --     galaxy:moveCamera(-1, 0)
    -- end
    -- function pd.rightButtonDown()
    --     galaxy:moveCamera(1, 0)
    -- end
    
    -- function pd.cranked(crank, _)
    --     local degreesPerStar = 360 // #galaxy.starsInSector
    --     local idx = pd.getCrankPosition() // degreesPerStar
    --     local modIdx = (idx % #galaxy.starsInSector) + 1
        
    --     if modIdx ~= currentCrankPosition then
    --         currentCrankPosition = modIdx
            
    --         galaxy:getStar(modIdx)
    --     end
    -- end
    
--     function pd.AButtonDown()
--         if galaxy.markedStar ~= nil then
--             print('Selecting star: ' .. galaxy.markedStar.position.x .. ", " .. galaxy.markedStar.position.y)
--         end
--     end
    
--     gfx.sprite.update()
--     pd.drawFPS(200, 10)
--     pd.timer.updateTimers()
-- end

function pd.update()
    function pd.upButtonDown()
        galaxy:moveCamera(0, -1)
    end
    function pd.downButtonDown()
        galaxy:moveCamera(0, 1)
    end
    function pd.leftButtonDown()
        galaxy:moveCamera(-1, 0)
    end
    function pd.rightButtonDown()
        galaxy:moveCamera(1, 0)
    end
    
    function pd.cranked(crank, _)
        if isModfiyingVariables == false then
            local degreesPerStar = 360 // #galaxy.starsInSector
            local idx = pd.getCrankPosition() // degreesPerStar
            local modIdx = (idx % #galaxy.starsInSector) + 1
            
            if modIdx ~= currentCrankPosition then
                currentCrankPosition = modIdx
                
                galaxy:getStar(modIdx)
            end
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        -- menu only works when a star is marked
        if isModfiyingVariables == false and galaxy.markedStar == nil then
            return
        end 

        isModfiyingVariables = not isModfiyingVariables

        gfx.clear(gfx.kColorClear)
        gfx.sprite.removeAll()

        if isModfiyingVariables == true then
            drawDetailColumn()
        else
            galaxy:drawGalaxy()
        end    
    end
    
    gfx.sprite.update()
    pd.drawFPS(200, 10)
    pd.timer.updateTimers()
end

function drawDetailColumn()
    local instructionX = 125
    
    local barrier = 15 
    local solarSystemImage = gfx.image.new(400,240)

    gfx.pushContext(solarSystemImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(barrier, barrier, 400-(barrier*2),240-(barrier*2))
        
        barrier = 20
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(barrier, barrier, 400-(barrier*2),240-(barrier*2))

        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

    gfx.popContext()
    
    local starSprite = gfx.sprite.new(solarSystemImage)
    
    starSprite:moveTo((400)/2,(240)/2)
    starSprite:add()

    local newimage = gfx.image.new(200,200)
    
    local star = galaxy.markedStar
    gfx.pushContext(newimage)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawText("Position: " .. star.position.x .. ", " .. star.position.y, 10,10)
        gfx.drawText("Radius: " .. star.radius, 10, 30)
    gfx.popContext()
    local newsprite = gfx.sprite.new(newimage)

    newsprite:moveTo(100,100)
    newsprite:add()
end
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

local function initialize()
    gfx.setBackgroundColor(gfx.kColorBlack)
    gfx.fillRect(0, 0, 400, 240)

    galaxy = Galaxy()
    galaxy:drawGalaxy()

    -- pd.ui.crankIndicator:start()
end

initialize()

local currentCrankPosition = nil
isModfiyingVariables = false

-- local crankingIt = true

function pd.update()
    function pd.upButtonDown()
        if isModfiyingVariables == false then
            galaxy:moveCamera(0, -1)
        end
    end
    function pd.downButtonDown()
        if isModfiyingVariables == false then
            galaxy:moveCamera(0, 1)
        end
    end
    function pd.leftButtonDown()
        if isModfiyingVariables == false then
            galaxy:moveCamera(-1, 0)
        end
    end
    function pd.rightButtonDown()
        if isModfiyingVariables == false then
            galaxy:moveCamera(1, 0)
        end
    end
    
    function pd.cranked(crank, _)
        if isModfiyingVariables == false then
            local degreesPerStar = 360 // #galaxy.starsInSector
            local idx = pd.getCrankPosition() // degreesPerStar
            local modIdx = (idx % #galaxy.starsInSector) + 1
            
            if modIdx ~= currentCrankPosition then
                currentCrankPosition = modIdx
                
                galaxy:markStar(modIdx)
                -- crankingIt = false
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
            Solarsystem:init(galaxy.markedStar)
            -- crankingIt = false
        else
            galaxy:drawGalaxy()
            -- crankingIt = true
        end    
    end

    
    gfx.sprite.update()
    pd.drawFPS(200, 10)
    pd.timer.updateTimers()

    -- if crankingIt == true then
    --     pd.ui.crankIndicator:update()
    -- end
end
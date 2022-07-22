import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

-- import 'ship'
import 'modules/globals'
import 'modules/galaxy'

local function initialize()
    gfx.setBackgroundColor(gfx.kColorBlack)
    gfx.fillRect(0, 0, 400, 240)
    
    galaxy = Galaxy()
    -- local ship = Ship(200, 120, 15, 15)
end

initialize()

local currentCrankPosition = nil

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
        local degreesPerStar = 360 // #galaxy.starsInSector
        local idx = pd.getCrankPosition() // degreesPerStar
        local modIdx = (idx % #galaxy.starsInSector) + 1
        
        if modIdx ~= currentCrankPosition then
            currentCrankPosition = modIdx
            
            galaxy:getStar(modIdx)
        end
    end
    
    function pd.AButtonDown()
        if galaxy.markedStar ~= nil then
            print('Selecting star: ' .. galaxy.markedStar.position.x .. ", " .. galaxy.markedStar.position.y)
        end
    end
    
    gfx.sprite.update()
    pd.drawFPS(200, 10)
    pd.timer.updateTimers()
end


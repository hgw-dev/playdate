import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

-- import 'ship'
import 'galaxy'

local pd <const> = playdate
local gfx <const> = pd.graphics

local galaxy = nil

local function initialize()
	gfx.setBackgroundColor(gfx.kColorBlack)
	gfx.fillRect(0, 0, 400, 240)

	galaxy = Galaxy()
	-- local ship = Ship(200, 120, 15, 15)
end

initialize()

local currentCrankPosition = nil

function pd.update()
	-- function pd.upButtonDown()
	-- 	galaxy:moveCamera(0, -1)
	-- end
	-- function pd.downButtonDown()
	-- 	galaxy:moveCamera(0, 1)
	-- end
	-- function pd.leftButtonDown()
	-- 	galaxy:moveCamera(-1, 0)
	-- end
	-- function pd.rightButtonDown()
	-- 	galaxy:moveCamera(1, 0)
	-- end

	-- function pd.AButtonDown()
	function pd.cranked(crank, _)
		local degreesPerStar = 360 // #galaxy.starsInSector
		local idx = pd.getCrankPosition() // degreesPerStar

		if idx ~= currentCrankPosition then
			currentCrankPosition = idx

			-- galaxy:getStar(idx + 1)
			-- galaxy:regenerateGalaxy()
		end
	end

	gfx.sprite.update()
	pd.timer.updateTimers()
end


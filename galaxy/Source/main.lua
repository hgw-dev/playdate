import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

-- import 'star'
-- import 'ship'
import 'grid'

local pd <const> = playdate
local gfx <const> = pd.graphics

local function initialize()
	gfx.setBackgroundColor(gfx.kColorBlack)
	gfx.fillRect(0, 0, 400, 240)
	-- local star = Star(100, 100, 20)

	local grid = Grid()
	-- local ship = Ship(200, 200, 20, 20)
end

initialize()

function playdate.update()
	gfx.sprite.update()
	pd.timer.updateTimers()
end



local gfx <const> = playdate.graphics

class('Star').extends(gfx.sprite)

function Star:init(x, y, r)
	Star.super.init(self)

	local circleImage = gfx.image.new(r*2, r*2)

	gfx.pushContext(circleImage)
		gfx.fillCircleAtPoint(r, r, r)
	gfx.popContext()
	self:setImage(circleImage)

	self:moveTo(x, y)
    self:add()
end
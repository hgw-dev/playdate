local pd <const> = playdate
local gfx <const> = pd.graphics

class('Ship').extends(gfx.sprite)

function Ship:init(x, y, w, h)
	Ship.super.init(self)

	local shipImage = gfx.image.new(w, h)

	gfx.pushContext(shipImage)
        gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(0, 0, w, h)
	gfx.popContext()

	self:setImage(shipImage)
	self:setCollideRect(x,y,w,h)
	self:moveTo(x, y)

    self:add()

    self.speed = 5
end

-- function Ship:update()
--     Ship.super.update(self)

    -- if pd.buttonIsPressed(pd.kButtonUp) then
    --     self:moveBy(0, -self.speed)
    -- end
    -- if pd.buttonIsPressed(pd.kButtonDown) then
    --     self:moveBy(0, self.speed)
    -- end
    -- if pd.buttonIsPressed(pd.kButtonLeft) then
    --     self:moveBy(-self.speed, 0)
    -- end
    -- if pd.buttonIsPressed(pd.kButtonRight) then
    --     self:moveBy(self.speed, 0)
    -- end
-- end
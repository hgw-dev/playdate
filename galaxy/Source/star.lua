local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

class('Star').extends(gfx.sprite)
-- class('Star').extends()

function Star:init(pos, sector, starStart, galaxyDims, globalSeed)
	Star.super.init(self)
	
	self.galaxyDims = galaxyDims
	self.starStart = starStart
	self.marked = false

    local gen = (pos.x & 0xFFFF) << 16 | (pos.y & 0xFFFF)
    math.randomseed(math.ceil(gen/globalSeed))
    
    self.starExists = math.random(1,20) == 1
    if not self.starExists then return end

    local varianceX = math.random()
    local varianceY = math.random()

    varianceX *= math.random() < 0.5 and 1 or -1
    varianceY *= math.random() < 0.5 and 1 or -1

    self.position = geo.point.new(
        sector.x * 16 + starStart.x,
        sector.y * 16 + starStart.y
    )

    self.radius = math.random(3,8)
    self.dither = math.random() * .75

	if (
		self.position.x - self.radius/2 >= starStart.x and 
		self.position.x + self.radius/2 <= starStart.x + galaxyDims.x - 10 and
		self.position.y - self.radius/2 >= starStart.y and
		self.position.y + self.radius/2 <= starStart.y + galaxyDims.y - 10
	) then
		self.starExists = true
	else
		self.starExists = false
	end

	local starImage = gfx.image.new(self.radius, self.radius)

	gfx.pushContext(starImage)
		gfx.setColor(gfx.kColorWhite)
		gfx.setDitherPattern(self.dither)
		gfx.fillCircleAtPoint(self.position, self.radius)
    gfx.popContext()

    self:moveTo(self.position.x,self.position.y)
	-- borderSprite:setZIndex(1)
	self:setImage(starImage) 
	self:add()
end

function Star:unmark()
	self.marked = false
end
function Star:mark()
	self.marked = true
end

function Star:drawMarked()
	gfx.pushContext()
		gfx.setColor(gfx.kColorWhite)
        gfx.drawCircleAtPoint(self.position, self.radius * 2)
	gfx.popContext()
end

-- function Star:draw()

-- 	-- gfx.lockFocus(starImage)
-- 	-- 	local border = geo.rect.new(self.starStart.x,self.starStart.y, self.galaxyDims.x-5, self.galaxyDims.y-5)
-- 	-- 	gfx.setColor(gfx.kColorWhite)
--     --     gfx.drawRect(border)

-- 	-- 	gfx.setDitherPattern(self.dither)
-- 	-- 	gfx.fillCircleAtPoint(self.position.x-self.galaxyDims.x+5,self.position.y-self.galaxyDims.y+5, self.radius)

-- 	-- 	gfx.unlockFocus()

--     -- local borderSprite = gfx.sprite.new(starImage)
--     -- borderSprite:moveTo((self.galaxyDims.x-5)/2,(self.galaxyDims.y-5)/2)
--     -- borderSprite:add()
-- 	local starImage = gfx.image.new(self.radius, self.radius)

-- 	gfx.pushContext(starImage)
-- 		gfx.setColor(gfx.kColorWhite)
-- 		gfx.setDitherPattern(self.dither)
-- 		gfx.fillCircleAtPoint(self.position, self.radius)
--     gfx.popContext()

--     self:moveTo(self.position.x,self.position.y)
-- 	-- borderSprite:setZIndex(1)
-- 	self:setImage(starImage) 
-- 	self:add()
-- end

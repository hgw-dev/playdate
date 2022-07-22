local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

class('Star').extends(gfx.sprite)

function Star:init(pos, sector, galaxy)
	Star.super.init(self)
	
	self.galaxy = galaxy
	self.galaxyDims = self.galaxy.galaxyDims
	self.starStart = self.galaxy.starStart
	self.marked = false

    local gen = (pos.x & 0xFFFF) << 16 | (pos.y & 0xFFFF)
    math.randomseed(math.ceil(gen/self.galaxy.globalSeed))
    
    self.starExists = math.random(1,20) == 1
    if not self.starExists then return end

    local varianceX = math.random()
    local varianceY = math.random()

    varianceX *= math.random() < 0.5 and 1 or -1
    varianceY *= math.random() < 0.5 and 1 or -1

    self.position = geo.point.new(
        sector.x * 16 + self.starStart.x,
        sector.y * 16 + self.starStart.y
    )

    self.radius = math.random(3,10)
    self.dither = math.random() * .75

	if (
		self.position.x - self.radius/2 >= self.starStart.x and 
		self.position.x + self.radius/2 <= self.starStart.x + self.galaxyDims.x - 10 and
		self.position.y - self.radius/2 >= self.starStart.y and
		self.position.y + self.radius/2 <= self.starStart.y + self.galaxyDims.y - 10
	) then
		self.starExists = true
	else
		self.starExists = false
	end
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

function Star:drawStar()
	local starImage = gfx.image.new(self.radius*4,self.radius*4)
		
	gfx.pushContext(starImage)
		gfx.setColor(gfx.kColorWhite)
		gfx.setDitherPattern(self.dither)
		gfx.fillCircleAtPoint(self.radius*2, self.radius*2, self.radius)
		if self.marked == true then
				gfx.setColor(gfx.kColorWhite)
				gfx.drawCircleAtPoint(self.radius*2, self.radius*2, self.radius*2)
		end	
	gfx.popContext()

    self:moveTo(self.position.x,self.position.y)
	self:setZIndex(1)
	self:setImage(starImage) 

	self.drawn = true
	self:add()
end
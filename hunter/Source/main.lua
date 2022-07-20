import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

local gfx = playdate.graphics
gfx.clear()

class('Box').extends(playdate.graphics.sprite)
class('Entity').extends(playdate.graphics.sprite)
class('Player').extends(Entity)
class('Monster').extends(Entity)

local playerSprites = {}
local monsterSprites = {}

local playerImage = gfx.image.new('img/player')
local playerHitImage = gfx.image.new('img/player-hit')
local monsterImage = gfx.image.new('img/monster')
local monsterHitImage = gfx.image.new('img/monster-hit')

local kPlayerType = 1
local kMonsterType = 2
local collisionsCount = 0

playdate.display.setRefreshRate(40)

function Entity:init(type, image, hitImage)
	Entity.super.init(self)

	self.type = type
	self.image = image
	self.hitImage = hitImage
	self:setImage(image)
	
	local imageWidth, imageHeight = image:getSize()
	self:setCollideRect(2, 2, imageWidth-4, imageHeight-4)
	self:moveTo(math.random(30, 370), math.random(30, 210))
	self.velocityX = math.random(-80, 80)
	self.velocityY = math.random(-80, 80)
	self.collisionResponse = gfx.sprite.kCollisionTypeBounce

end

function Entity:hit()
	self:setImage(self.hitImage)
	
	if self.resetImageTimer ~= nil then
		self.resetImageTimer:remove()
	end
	
	self.resetImageTimer = playdate.timer.new(500, function() 
		self:setImage(self.image)
	end)
end

-- function Entity:update()
-- 	local dx = s.velocityX * dt / 1000.0
-- 	local dy = s.velocityY * dt / 1000.0

-- 	s:moveTo(s.x + dx, s.y + dy)
-- end

-- function Entity:collisionResponse(other)
-- 	if collision.normal.x ~= 0 then -- hit something in the X direction
-- 		s.velocityX = -s.velocityX
-- 	end
-- 	if collision.normal.y ~= 0 then -- hit something in the Y direction
-- 		s.velocityY = -s.velocityY
-- 	end

-- 	if (s:isa(Monster) and collision.other:isa(Player)) or (s:isa(Player) and collision.other:isa(Monster)) then
-- 		s:hit()
-- 		collision.other:hit()
-- 	end
-- end

function Player:init()
	Player.super.init(self, kPlayerType, playerImage, playerHitImage)

	self:setGroups({2})
	self:setCollidesWithGroups({3,4})
	
	playerSprites[#playerSprites+1] = self
	self:addSprite()
end

function Monster:init()
	Monster.super.init(self, kMonsterType, monsterImage, monsterHitImage)
	
	self:setGroups({3})
	self:setCollidesWithGroups({2,4})

	monsterSprites[#monsterSprites+1] = self
	self:addSprite()
end

local counter = gfx.image.new(1,1)
gfx.pushContext(counter)
	gfx.drawText("Collisions: " .. collisionsCount, 10, 10)
gfx.popContext()
local counterSprite = gfx.sprite.new(counter)
counterSprite:setZIndex(30)

counterSprite:moveTo(10,10)
counterSprite:add()

function counterSprite:draw()
	gfx.lockFocus(counterSprite)
		gfx.drawText("Collisions: " .. collisionsCount, 10, 10)
	gfx.unlockFocus()
end
-- function counter:update()
-- 	self:drawText("Collisions: " .. collisionsCount, 100, 100)
-- end
-- Player and Monster sprites just bounce off of each other, but don't collide with sprites of the same type (i.e. monsters don't collide with monsters, players don't collide with players)
local function updateMovingSprite(dt, s)
	local dx = s.velocityX * dt / 1000.0
	local dy = s.velocityY * dt / 1000.0

	local actualX, actualY, collisions, collisionCount = s:moveWithCollisions(s.x + dx, s.y + dy)
	for i=1, collisionCount do
		local collision = collisions[i]
		
		-- when a player or monster collides with anything just bounce off of it
		if collision.normal.x ~= 0 then -- hit something in the X direction
			s.velocityX = -s.velocityX
		end
		if collision.normal.y ~= 0 then -- hit something in the Y direction
			s.velocityY = -s.velocityY
		end

		if (s:isa(Monster) and collision.other:isa(Player)) or (s:isa(Player) and collision.other:isa(Monster)) then
			s:hit()
			collision.other:hit()
			collisionsCount += 1
			print(collisionsCount)
			counterSprite:markDirty()
		end
	end
end

local function addWallBlock(x,y,w,h)
	local block = Box()
	block:setCenter(0,0)
	block:setSize(w, h)
	block:moveTo(x, y)
	block:setCollideRect(0,0,w,h)
	block:setGroups({4})
	block.type = 5
	-- don't need to specifically set a layer mask walls, because by default sprites exist on all layers
	-- don't need to set a collision mask because the walls themselves never move or cause collisions, but even if they did, we'd want them to collide with all layers, which is the default
	
	block:addSprite()
end

function Box:draw(x, y, width, height)
	local cx, cy, cwidth, cheight = self:getCollideBounds()
	gfx.setColor(playdate.graphics.kColorWhite)
	gfx.fillRect(cx, cy, cwidth, cheight)
	gfx.setColor(playdate.graphics.kColorBlack)
	gfx.drawRect(cx, cy, cwidth, cheight)
end


-- set up walls for the sprites to bounce off of, set just offscreen on each edge
local borderSize = 10
local displayWidth = playdate.display.getWidth()
local displayHeight = playdate.display.getHeight()
addWallBlock(-borderSize, -borderSize, displayWidth+borderSize*2, borderSize)		-- top
addWallBlock(-borderSize, -borderSize, borderSize, displayHeight+borderSize*2)		-- left
addWallBlock(displayWidth, -borderSize, borderSize, displayHeight+borderSize*2)		-- right
addWallBlock(-borderSize, displayHeight, displayWidth+borderSize*2, borderSize)		-- bottom

-- set up some player and monster sprites
for i = 1, 5 do
	Player()
	Monster()
end

local lastTime = playdate.getCurrentTimeMilliseconds()

function playdate.update()
	local currentTime = playdate.getCurrentTimeMilliseconds()
	local deltaTime = currentTime - lastTime
	lastTime = currentTime

	for _, player in ipairs(playerSprites) do
		updateMovingSprite(deltaTime, player)
	end

	for _, monster in ipairs(monsterSprites) do
		updateMovingSprite(deltaTime, monster)
	end

	gfx.sprite:update()
	playdate.timer.updateTimers()
end


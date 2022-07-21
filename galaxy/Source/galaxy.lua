local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

import 'Star'

local start <const> = { x = 5, y = 30 }
local starStart <const> = { x = start.x + 5, y = start.y + 5 }

local galaxyTotalWidth <const> = pd.display.getWidth() * 8/9
local galaxyTotalHeight <const> = pd.display.getHeight() * 6/7

local galaxyDims = geo.vector2D.new(galaxyTotalWidth, galaxyTotalHeight)

local nSectorsX = galaxyDims.x / 16
local nSectorsY = galaxyDims.y / 16

local tempSeed = pd.getSecondsSinceEpoch()
math.randomseed(tempSeed)
local globalSeed = math.random()

class('Galaxy').extends()

function Galaxy:init()

    self.cameraPosition = geo.vector2D.new(0.5, 0.5)

    self.starsInSector = {}
    self.markedStar = nil

    self.start = start
    self.starStart = starStart
    self.galaxyDims = galaxyDims

    self.menu = Menu()
    self:regenerateGalaxy()
end

class('Menu').extends(gfx.sprite)
function Menu:init()
    Menu.super.init(self)

    self.numStars = 0

    -- local borderImage = gfx.image.new(galaxyDims.x, galaxyDims.y)
    -- local border = geo.rect.new(0,0, galaxyDims.x, galaxyDims.y)
	-- gfx.pushContext(borderImage)
    --     gfx.setLineWidth(5)
    --     gfx.setColor(gfx.kColorWhite)
    --     gfx.drawRect(border)
    -- gfx.popContext()

    -- local borderSprite = gfx.sprite.new(borderImage)
    -- borderSprite:moveTo(start.x+galaxyDims.x/2, start.y+galaxyDims.y/2)
    -- borderSprite:add()

    self:updateMenu()
	self:moveTo(200, 30)
    self:add()
end

function Menu:setNumStars(numStars)
    if self.numStars ~= numStars then
        self.numStars = numStars
        self:updateMenu()
    end
end

function Menu:updateMenu()
    local menuImage = gfx.image.new(pd.display.getWidth(), 50)
    
	gfx.pushContext(menuImage)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawText("Sup dick lickers", 5, 5)
        gfx.drawText("Stars in sector: " .. self.numStars, 250, 5)
    gfx.popContext()
    
	self:setImage(menuImage) 
end

function Galaxy:moveCamera(dx, dy)
    local amount = 1
    if pd.buttonIsPressed(pd.kButtonB) then
        amount = 0.1
    end
    self.cameraPosition.y += amount*dy
    self.cameraPosition.x += amount*dx

    self.markedStar = nil
    self:regenerateGalaxy()
end

function Galaxy:getStar(idx)
    local star = self.starsInSector[idx]
    self.markedStar = star
    print("Stars in sector " .. #self.starsInSector .. " marking Star #" .. idx)
end

function Galaxy:regenerateGalaxy()
    self.starsInSector = {}

    for sectorX = 0, nSectorsX, 1 do
        for sectorY = 0, nSectorsY, 1 do
            local posX = math.ceil(sectorX + self.cameraPosition.x)
            local posY = math.ceil(sectorY + self.cameraPosition.y)

            local pos = geo.vector2D.new(posX, posY)
            local sector = geo.vector2D.new(sectorX, sectorY)
            local star = Star(pos, sector, starStart, galaxyDims, globalSeed);

            if star.starExists then
                print(pos.x, pos.y)
                self.starsInSector[#self.starsInSector + 1] = star
            end
        end
    end

    self.menu:setNumStars(#self.starsInSector)
    print("star count: " .. #self.starsInSector)
    -- self:drawGalaxy()
end

-- function Galaxy:drawGalaxy()

    -- if self.markedStar ~= nil then 
    --     gfx.pushContext()
    --         gfx.setColor(gfx.kColorWhite)
    --         gfx.drawCircleAtPoint(self.markedStar.position, self.markedStar.radius * 2.5)
    --     gfx.popContext()
    --  end

    -- for starIndex = 1, #self.starsInSector, 1 do
    --     self.starsInSector[starIndex]:draw()
        -- local star = self.starsInSector[starIndex]
        
        -- local starImage = gfx.image.new(50,50)
    
        -- gfx.pushContext(starImage)
        --     gfx.setColor(gfx.kColorWhite)
        --     gfx.setDitherPattern(star.dither)
        --     gfx.fillCircleAtPoint(10,10, star.radius)
        -- gfx.popContext()
        
        -- local starSprite = gfx.sprite.new(starImage)
        -- starSprite:moveTo(star.position.x, star.position.y)
        -- starSprite:add()

--     end
-- end

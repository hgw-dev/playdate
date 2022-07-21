local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

import 'Star'

local galaxySize = 10
local galaxyTotalWidth <const> = pd.display.getWidth() * 8/9
local galaxyTotalHeight <const> = pd.display.getHeight() * 6/7

local galaxySize = geo.vector2D.new(galaxyTotalWidth, galaxyTotalHeight)

local nSectorsX = galaxySize.x / 16
local nSectorsY = galaxySize.y / 16

local start <const> = { x = 5, y = 30 }
local starStart <const> = { x = start.x + 5, y = start.y + 5 }

local counter = gfx.image.new(1,1)

local tempSeed = pd.getSecondsSinceEpoch()
math.randomseed(tempSeed)
local globalSeed = math.random()

class('Galaxy').extends()

function Galaxy:init()
    self.cameraPosition = geo.vector2D.new(0.5, 0.5)

    self.starsInSector = {}
    self.markedStar = nil

    self:regenerateGalaxy()
end

function Galaxy:draw()
    gfx.clear()

    self:drawTitle()
    self:drawGalaxy()
end

function Galaxy:drawTitle()
    gfx.pushContext()
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawText("Sup dick lickers", 5, 5)
        gfx.drawText("Stars in sector: " .. #self.starsInSector, 250, 5)
    gfx.popContext()
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

function Galaxy:drawGalaxy()
    local border = geo.rect.new(start.x, start.y, galaxySize.x, galaxySize.y)
    gfx.pushContext()
        gfx.setLineWidth(5)
        gfx.setColor(gfx.kColorWhite)
        gfx.drawRect(border)
    gfx.popContext()

    if self.markedStar ~= nil then 
        gfx.pushContext()
            gfx.setColor(gfx.kColorWhite)
            gfx.drawCircleAtPoint(self.markedStar.position, self.markedStar.radius * 2.5)
        gfx.popContext()
     end

    for starIndex = 1, #self.starsInSector, 1 do
        self.starsInSector[starIndex]:draw()
    end
end

function Galaxy:regenerateGalaxy()
    self.starsInSector = {}

    for sectorX = 0, nSectorsX, 1 do
        for sectorY = 0, nSectorsY, 1 do
            local posX = math.ceil(sectorX + self.cameraPosition.x)
            local posY = math.ceil(sectorY + self.cameraPosition.y)
            local pos = geo.vector2D.new(posX, posY)
            local sector = geo.vector2D.new(sectorX, sectorY)
            local star = Star(pos, sector, starStart, galaxySize, globalSeed);

            if star.starExists then
                self.starsInSector[#self.starsInSector + 1] = star
            end
        end
    end
    print("star count: " .. #self.starsInSector)
    self:draw()
end
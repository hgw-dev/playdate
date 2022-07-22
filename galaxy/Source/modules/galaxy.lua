import 'globals'
import 'star'
import 'menu'

class('Galaxy').extends()

function Galaxy:init()
    self.cameraPosition = geo.vector2D.new(0.5, 0.5)
    
    self.starsInSector = {}
    self.markedStar = nil
    
    self.menu = Menu()
    self:regenerateGalaxy()
end

function Galaxy:moveCamera(dx, dy)
    local amount = 2
    if pd.buttonIsPressed(pd.kButtonB) then
        amount = 1
    end
    if pd.buttonIsPressed(pd.kButtonA) then
        amount = 4
    end
    
    self.cameraPosition.y += amount*dy
    self.cameraPosition.x += amount*dx
    
    if self.markedStar ~= nil then
        self.markedStar.marked = false
        self.markedStar = nil
    end
    
    for _, k in ipairs(self.starsInSector) do
        k:remove()
    end
    
    self:regenerateGalaxy()
end

function Galaxy:getStar(idx)
    -- print("Stars in sector " .. #self.starsInSector .. " marking Star #" .. idx)
    local star = self.starsInSector[idx]
    
    if self.markedStar ~= nil then
        self.markedStar.marked = false
        self.markedStar:drawStar()
    end
    
    star.marked = true
    self.markedStar = star
    self.markedStar:drawStar()
end

function Galaxy:regenerateGalaxy()
    self.starsInSector = {}
    
    for sectorX = 0, nSectorsX, 1 do
        for sectorY = 0, nSectorsY, 1 do
            local posX = math.ceil(sectorX + self.cameraPosition.x)
            local posY = math.ceil(sectorY + self.cameraPosition.y)
            
            local pos = geo.vector2D.new(posX, posY)
            local sector = geo.vector2D.new(sectorX, sectorY)
            local star = Star(pos, sector);
            
            if star.starExists then
                -- print(pos.x, pos.y)
                self.starsInSector[#self.starsInSector + 1] = star
            end
        end
    end
    
    self.menu:setNumStars(#self.starsInSector)
    -- print("star count: " .. #self.starsInSector)
    self:drawGalaxy()
end

function Galaxy:drawGalaxy()
    for starIndex = 1, #self.starsInSector, 1 do
        self.starsInSector[starIndex]:drawStar()
    end
end

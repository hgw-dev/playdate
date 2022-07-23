import 'modules/globals'

class('Solarsystem').extends()

function Solarsystem:init(star)
    self.star = star

    self:drawBorders()
    self:drawInfo()
    self:drawSystem()
end

function Solarsystem:drawBorders()
    local instructionX = 125
        
    local barrier = 15 
    local solarSystemImage = gfx.image.new(400,240)

    gfx.pushContext(solarSystemImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(barrier, barrier, 400-(barrier*2),240-(barrier*2))
        
        barrier = 20
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(barrier, barrier, 400-(barrier*2),240-(barrier*2))

        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

    gfx.popContext()

    local starSprite = gfx.sprite.new(solarSystemImage)

    starSprite:moveTo((400)/2,(240)/2)
    starSprite:add()
end

function Solarsystem:drawInfo()
    local newimage = gfx.image.new(200,200)

    gfx.pushContext(newimage)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawText("Position: " .. self.star.position.x .. ", " .. self.star.position.y, 10,10)
        gfx.drawText("Radius: " .. self.star.radius, 10, 30)
        gfx.drawText("Planets: " .. #self.star.planets, 10, 50)
    gfx.popContext()
    local newsprite = gfx.sprite.new(newimage)

    newsprite:moveTo(115,115)
    newsprite:add()
end


function Solarsystem:drawSystem()
    local newimage = gfx.image.new(400,150)

    gfx.pushContext(newimage)
        gfx.setColor(gfx.kColorWhite)
        gfx.setDitherPattern(self.star.dither)

        gfx.fillCircleAtPoint(50, 50, self.star.radius*3)

        local distance = 20
        if #self.star.planets > 0 then
            for planetIdx = 1, #self.star.planets, 1 do
                local planet = self.star.planets[planetIdx]
                
                gfx.setColor(gfx.kColorWhite)
                gfx.setDitherPattern(planet.dither)
                gfx.fillCircleAtPoint(planetIdx * 40 + 100, 50, planet.radius*3)
            end
        end
    gfx.popContext()
    
    local newsprite = gfx.sprite.new(newimage)

    newsprite:moveTo(230,160)
    newsprite:add()
end
import 'modules/globals'

class('Menu').extends(gfx.sprite)
function Menu:init()
    Menu.super.init(self)
    
    self.numStars = 0
    
    local borderImage = gfx.image.new(galaxyDims.x, galaxyDims.y)
    local border = geo.rect.new(0,0, galaxyDims.x, galaxyDims.y)
    gfx.pushContext(borderImage)
        gfx.setLineWidth(5)
        gfx.setColor(gfx.kColorWhite)
        gfx.drawRect(border)
    gfx.popContext()

    local borderSprite = gfx.sprite.new(borderImage)
    borderSprite:moveTo(start.x+galaxyDims.x/2, start.y+galaxyDims.y/2)
    borderSprite:add()
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
        gfx.drawText("Galaxy Explorer", 5, 5)
        gfx.drawText("Stars in sector: " .. self.numStars, 250, 5)
    gfx.popContext()
    
    self:setImage(menuImage) 

    self:moveTo(200, 30)
    self:add()
end
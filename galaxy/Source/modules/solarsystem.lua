import 'modules/globals'


-- Generation variables. Controlled in the options grid
local generationKeys = { "size", "z", "repeatValue", "octaves", "persistence", "isArray"}
local generationVariables = {
    size = 10,
    z = 0,
    repeatValue = 0,
    octaves = 1,
    persistence = 1.0,
    isArray = false
}
local isModfiyingVariables = true


function variableDisplay(index)
    local label = generationKeys[index]
    local value = generationVariables[label]
    local result = "???"
    if label == "size" or label == "octaves" then
        result = string.format("%s = %d", label, value)
    elseif label == "z" then
        result = string.format("z = %.1f", value)
    elseif label == "persistence" then
        result = string.format("persist = %.2f", value)
    elseif label == "repeatValue" then
        -- This is special, because `repeat` is a Lua keyword
        result = string.format("repeat = %d", value)
    elseif label == "isArray" then
        if generationVariables.isArray then
            result = ".perlinArray(...)"
        else
            result = ".perlin(...)"
        end
    end
    return result
end

-- class('optionList').extends(playdate.ui.gridview)

-- function optionList:init()
    -- Options list view
    optionList = playdate.ui.gridview.new(0, 25)
    -- optionList.super.init(self, 0, 25)
    optionList:setNumberOfRows(#generationKeys)
    optionList:setCellPadding(0, 0, 5, 5)
    optionList:setContentInset(12, 12, 20, 20)

    -- Add a background to the optionList, with a vertical line to the left
    local backgroundImage = gfx.image.new(
        playdate.display.getWidth() / 2,
        playdate.display.getHeight(),
        gfx.kColorBlack
    )
    gfx.lockFocus(backgroundImage)
    gfx.setColor(gfx.kColorWhite)
    gfx.drawLine(0, 0, 0, playdate.display.getHeight())
    gfx.unlockFocus()
    optionList.backgroundImage = backgroundImage
-- end


-- function optionList:drawCell(section, row, column, selected, x, y, width, height)
--     local plusWidth, plusHeight = gfx.getTextSize("*+*")
--     local padding = 6
--     local textY = y + (height - plusHeight) / 2
--     gfx.setColor(gfx.kColorWhite)
--     if selected then
--         gfx.fillRoundRect(x, y, width, height, 4)
--         gfx.setImageDrawMode(gfx.kDrawModeCopy)
--         gfx.drawText("*+*", x + width - plusWidth - padding, textY)
--         gfx.drawText("*-*", x + padding, textY)
--     else
--         gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
--     end
--     gfx.drawTextInRect(
--         variableDisplay(row),
--         x + plusWidth + 2*padding,
--         y+4,
--         width - 2*plusWidth - 4*padding,
--         height,
--         nil,
--         "...",
--         kTextAlignment.center
--     )
-- end

function optionList:increaseSelectedValue()
    local key = generationKeys[self:getSelectedRow()]
    if key == "size" or key == "octaves" or key == "repeatValue" then
        generationVariables[key] += 1
    elseif key == "z" then
        local amount = 1.0
        if playdate.buttonIsPressed(playdate.kButtonB) then
            amount = 0.1
        end
        generationVariables[key] += amount
    elseif key == "persistence" then
        local amount = 0.1
        if playdate.buttonIsPressed(playdate.kButtonB) then
            amount = 0.01
        end
        generationVariables[key] += amount
    elseif key == "isArray" then
        generationVariables[key] = not generationVariables[key]
    end
end

function optionList:decreaseSelectedValue()
    local key = generationKeys[self:getSelectedRow()]
    if key == "size" or key == "octaves" then
        local newValue = math.max(1, generationVariables[key] - 1)
        generationVariables[key] = newValue
    elseif key == "repeatValue" then
        generationVariables[key] -= 1
    elseif key == "z" then
        local amount = 1.0
        if playdate.buttonIsPressed(playdate.kButtonB) then
            amount = 0.1
        end
        generationVariables[key] -= amount
    elseif key == "persistence" then
        local amount = 0.1
        if playdate.buttonIsPressed(playdate.kButtonB) then
            amount = 0.01
        end
        generationVariables[key] -= amount
    elseif key == "isArray" then
        generationVariables[key] = not generationVariables[key]
    end
end


-- class('Solarsystem').extends(gfx.sprite)

-- function Solarsystem:init()
--     Solarsystem.super.init(self)

--     self:add()
-- end


-- function Solarsystem:update()

    -- if isModfiyingVariables then
    --     optionList:drawInRect(220, 0, 180, 240)
    -- end

    -- -- Toggle the optionList when the user hits 🅰️
    -- if playdate.buttonJustPressed(playdate.kButtonA) then
    --     isModfiyingVariables = not isModfiyingVariables
    --     drawEverything()
    -- end
    -- drawEverything()
-- end

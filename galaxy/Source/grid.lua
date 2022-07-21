local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

local grid = {}
local gridTotalWidth <const> = pd.display.getWidth() * 8/9
local gridTotalHeight <const> = pd.display.getHeight() * 6/7

local start <const> = { x = 5, y = 30 }
local starStart <const> = { x = 20, y = 60 }
local isModfiyingVariables = false

local xPosition = 0.5
local yPosition = 0.5

local generationKeys = { "size", "z", "repeatValue", "octaves", "persistence", "isArray"}
local generationVariables = {
    size = 10,
    z = 0,
    repeatValue = 0,
    octaves = 1,
    persistence = 1.0,
    isArray = false
}

local tempSeed = pd.getSecondsSinceEpoch()
math.randomseed(tempSeed)
local globalSeed = math.random()
class('Grid').extends()

function Grid:init()
    if #grid < generationVariables.size then
        for i=1, generationVariables.size, 1 do
            grid[i] = {}
        end

        regenerateGrid()
        drawEverything()
    end

    if pd.buttonJustPressed(pd.kButtonA) then
        isModfiyingVariables = not isModfiyingVariables
        drawEverything()
    end
end

function playdate.upButtonDown()
    if isModfiyingVariables then
        optionList:selectPreviousRow()
    else
        local amount = 1
        if playdate.buttonIsPressed(playdate.kButtonB) then
            amount = 0.1
        end
        yPosition -= amount
        regenerateGrid()
        drawEverything()
    end

end

function playdate.downButtonDown()
    if isModfiyingVariables then
        optionList:selectNextRow()
    else
        local amount = 1
        if playdate.buttonIsPressed(playdate.kButtonB) then
            amount = 0.1
        end
        yPosition += amount
        regenerateGrid()
        drawEverything()
    end
end

function playdate.leftButtonDown()
    if isModfiyingVariables then
        optionList:decreaseSelectedValue()
    else
        local amount = 1
        if playdate.buttonIsPressed(playdate.kButtonB) then
            amount = 0.1
        end
        xPosition -= amount
    end
    regenerateGrid()
    drawEverything()
end

function playdate.rightButtonDown()
    if isModfiyingVariables then
        optionList:increaseSelectedValue()
    else
        local amount = 1
        if playdate.buttonIsPressed(playdate.kButtonB) then
            amount = 0.1
        end
        xPosition += amount
    end
    regenerateGrid()
    drawEverything()
end

function drawEverything()
    gfx.clear()

    drawTitle()
    drawGrid()
end

function drawTitle()
    gfx.pushContext()
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.drawText("Sup dick lickers", 5, 5)
    gfx.popContext()
end

function drawGrid()
    local size = generationVariables.size
    local dx = gridTotalWidth / size
    
    local border = geo.rect.new(start.x, start.y, gridTotalWidth, gridTotalHeight)
    gfx.pushContext()
        gfx.setLineWidth(5)
        gfx.setColor(gfx.kColorWhite)
        gfx.drawRect(border)
    gfx.popContext()

    for row = 1, 5, 1 do
        for col = 1, size, 1 do
            local value = grid[col][row]
            local varianceX = math.random()
            local varianceY = math.random()
            varianceX *= math.random() < 0.5 and 1 or -1
            varianceY *= math.random() < 0.5 and 1 or -1

            local point = geo.point.new(
                starStart.x + (col - 1 + varianceX) * dx,
                starStart.y + (row - 1 + varianceY) * dx
            )
            local rad = math.random(3,8)
            -- print(value)
            if (
                point.x - rad/2 >= start.x and 
                point.x + rad/2 <= start.x + gridTotalWidth and
                point.y - rad/2 >= start.y and
                point.y + rad/2 <= start.y + gridTotalHeight and
                value > 0
            ) then
                gfx.pushContext()
                    gfx.setColor(gfx.kColorWhite)
                    gfx.setDitherPattern(value*math.random())
                    gfx.fillCircleAtPoint(point, rad)
                gfx.popContext()
            end
        end
    end
end

-- Grid generation
function regenerateGrid()
    regenerateGridBySingleValue()
end

function regenerateGridBySingleValue()
    local size = generationVariables.size
    local z = generationVariables.z
    local repeatValue = generationVariables.repeatValue
    local octaves = generationVariables.octaves
    local persistence = generationVariables.persistence

    for row = 1, 5, 1 do
        for col = 1, size, 1 do
            local gen = (row & 0xFFFF) << 16 | (col & 0xFFFF)
            math.randomseed(math.ceil(gen/globalSeed))
            
            local tempValue = math.random()

            local value = math.ceil(tempValue*100) % 10 == 1 and tempValue or 0
            print(tempValue, value)
            
            grid[col] = grid[col] or {}
            grid[col][row] = value
        end
    end
end
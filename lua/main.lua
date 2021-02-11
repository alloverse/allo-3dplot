local stringx = require("pl.stringx")
stringx.import()
local Plotline = require("plotline")

local client = Client(
    arg[2], 
    "allo-3dplot"
)
local app = App(client)

local root = ui.View(ui.Bounds(-2, 0.7, 0,   1, 0.5, 0.1))
local mainView = ui.View(ui.Bounds(0, 0, 0,   1, 1, 1):scale(0.2, 0.2, 0.2))
root:addSubview(mainView)
local grabHandle = ui.GrabHandle(ui.Bounds( -0.5, 0.5, 0.3,   0.2, 0.2, 0.2))
grabHandle.rotationConstraint = {0,1,0}
root:addSubview(grabHandle)

local rowLabels = {}
local columnLabels = {}
local columnsValues = {}
local highestValue = -99999

local f = io.open("data.txt", "r")
local lineIndex = 0
for line in f:lines() do
    lineIndex = lineIndex + 1
    if lineIndex == 1 or lineIndex % 50 == 0 then
        print("Parsing", line)
        local fields = line:split("\t")
        for fieldIndex, field in ipairs(fields) do
            if lineIndex == 1 then
                table.insert(columnLabels, field)
                table.insert(columnsValues, {})
            elseif fieldIndex == 1 then
                table.insert(rowLabels, field)
            else
                local value = tonumber(field) and tonumber(field) or 0
                if value > highestValue then
                    highestValue = value
                end
                table.insert(columnsValues[fieldIndex], value)
            end
        end
    end
end
io.close(f)

local width = #columnLabels
local depth = #rowLabels
local height = 40

for i, columnLabel in ipairs(columnLabels) do
    local bounds = ui.Bounds(i, 0, 0,   0.2, 0.2, 0.2)
    local label = ui.Label{bounds=bounds, text=columnLabel, color={0,0,0,1}}
    mainView:addSubview(label)
end

for i, rowLabel in ipairs(rowLabels) do
    local bounds = ui.Bounds(1, 0, -i,   0.2, 0.2, 0.2)
    local label = ui.Label{bounds=bounds, text=rowLabel, color={0,0,0,1}}
    mainView:addSubview(label)
end

local step = highestValue / height
for i = 0, height do
    local bounds = ui.Bounds(1, i, 0,   0.2, 0.2, 0.2)
    local text = string.format("%.2f", step * i)
    local label = ui.Label{bounds=bounds, text=text, color={0,0,0,1}}
    mainView:addSubview(label)
end

for columnIndex, columnValues in ipairs(columnsValues) do
    for rowIndex, value in ipairs(columnValues) do
        local z = -rowIndex
        local y = (value / highestValue) * height
        local x = columnIndex
        local bounds = ui.Bounds(x, y, z,   0.2, 0.2, 0.2)
        local cube = ui.Cube(bounds)
        if columnIndex < 10 then
            cube:setColor({0.3, 0.8, 0.2, 1.0})
        else
            cube:setColor({0.7, 0.3, 0.4, 1.0})
        end
        mainView:addSubview(cube)
    end

    local bounds = ui.Bounds(columnIndex, height/2, -depth/2 - 1,   0.2, height, depth)
    local plot = Plotline(bounds)
    plot.maxValue = highestValue
    plot:setValues(columnValues, false)
    mainView:addSubview(plot)
    if columnIndex < 10 then
        plot:setColor({0.3, 0.8, 0.2, 1.0})
    else
        plot:setColor({0.7, 0.3, 0.4, 1.0})
    end
end



app.mainView = root
app:connect()
app:run()

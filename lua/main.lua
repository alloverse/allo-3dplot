local stringx = require("pl.stringx")
stringx.import()
local Cube = require("cube")

local client = Client(
    arg[2], 
    "allo-3dplot"
)
local app = App(client)

local mainView = ui.View(ui.Bounds(-15, 0.7, 0,   1, 0.5, 0.1):scale(0.2, 0.2, 0.2))
local grabHandle = ui.GrabHandle(ui.Bounds( -0.5, 0.5, 0.3,   0.2, 0.2, 0.2))
mainView:addSubview(grabHandle)

local f = io.open("data.txt", "r")
local lineIndex = 0
local actualLineIndex = 0
for line in f:lines() do
    lineIndex = lineIndex + 1
    if lineIndex == 1 or lineIndex % 50 == 0 then
        actualLineIndex = actualLineIndex + 1
        print("Parsing", line)
        for fieldIndex, field in ipairs(line:split("\t")) do
            local z = -actualLineIndex
            local y = tonumber(field) and tonumber(field)/10.0 or 0
            local x = fieldIndex
            
            local bounds = ui.Bounds(x, y, z,   0.2, 0.2, 0.2)
            if lineIndex == 1 or fieldIndex == 1 then
                local label = ui.Label{bounds=bounds, text=field, color={0,0,0,1}}
                mainView:addSubview(label)
            else
                local cube = Cube(bounds)
                if fieldIndex < 10 then
                    cube:setColor({0.3, 0.8, 0.2, 1.0})
                else
                    cube:setColor({0.7, 0.3, 0.4, 1.0})
                end
                mainView:addSubview(cube)
            end
        end
    end
end
io.close(f)



app.mainView = mainView
app:connect()
app:run()
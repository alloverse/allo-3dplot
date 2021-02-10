local modules = (...):gsub(".[^.]+.[^.]+$", '') .. "."

local class = require('pl.class')
local tablex = require('pl.tablex')
local pretty = require('pl.pretty')
local vec3 = require("modules.vec3")
local mat4 = require("modules.mat4")


class.Plotline(ui.View)
function Plotline:_init(bounds)
    self:super(bounds)

    self.values = {0} -- list of doubles
    self.maxValue = 1

    self.color = {0.9, 0.4, 0.3, 1.0}
end

function Plotline:setValues(values, updateMax)
    if updateMax == nil then 
        updateMax = true
    end
    
    while #self.values do
        table.remove(self.values)
    end

    local maxValue = -99999999999
    for i, v in ipairs(values) do
        table.insert(self.values, v)
        if v > maxValue then
            maxValue = values
        end
    end
    if updateMax then
        self.maxValue = maxValue
    end

    if self:isAwake() then
        local newSpec = self:specification()
        self:updateComponents({
            geometry= newSpec.geometry
        })
    end
end

function Plotline:specification()
    local s = self.bounds.size
    local w2 = s.width / 2.0
    local h2 = s.height / 2.0
    local d2 = s.depth / 2.0
    local step = s.depth / #self.values

    local mySpec = tablex.union(ui.View.specification(self), {
        geometry = {
            type = "inline",
                  --   #fbl                #fbr               #ftl                #ftr             #rbl                  #rbr                 #rtl                  #rtr
            vertices= {{-w2, -h2, d2},     {w2, -h2, d2},     {-w2, h2, d2},      {w2, h2, d2},    {-w2, -h2, -d2},      {w2, -h2, -d2},      {-w2, h2, -d2},       {w2, h2, -d2}},
            uvs=      {{0.0, 0.0},         {1.0, 0.0},        {0.0, 1.0},         {1.0, 1.0},      {0.0, 0.0},           {1.0, 0.0},          {0.0, 1.0},           {1.0, 1.0}   },
            triangles= {
              {0, 1, 2}, {1, 3, 2}, -- front
              {2, 3, 6}, {3, 7, 6}, -- top
              {1, 7, 3}, {5, 7, 1}, -- right
              {5, 1, 0}, {4, 5, 0}, -- bottom
              {4, 0, 2}, {4, 2, 6}, -- left
              {1, 0, 2}, {1, 2, 3}, -- rear
            },
        },
        material = {
            color = self.color
        },
    })

    return mySpec
end


function Plotline:setColor(rgba)
    self.color = rgba
    if self:isAwake() then
      local mat = self:specification().material
      self:updateComponents({
          material= mat
      })
    end
end

return Plotline
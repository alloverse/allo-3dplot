local modules = (...):gsub(".[^.]+.[^.]+$", '') .. "."

local class = require('pl.class')
local tablex = require('pl.tablex')
local pretty = require('pl.pretty')
local vec3 = require("modules.vec3")
local mat4 = require("modules.mat4")


class.Plotline(ui.View)
function Plotline:_init(bounds)
    self:super(bounds)

    self.values = {1.0, 1.0} -- list of doubles
    self.maxValue = 1

    self.color = {0.9, 0.4, 0.3, 1.0}
end

function Plotline:setValues(values, updateMax)
    if updateMax == nil then 
        updateMax = true
    end
    
    while #self.values > 0 do
        table.remove(self.values)
    end

    local maxValue = -99999999999
    for i, v in ipairs(values) do
        table.insert(self.values, v)
        if v > maxValue then
            maxValue = v
        end
    end
    if #self.values == 0 then
        print("oops too short, adding dummy")
        table.insert(self.values, 0.0)
        maxValue = 1.0
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

    local geom = {
        type= "inline",
        vertices= {},
        triangles= {},
    }

    -- let's start out adding the front bottom lip of the line.
    table.insert(geom.vertices, {-w2, -h2, d2})
    table.insert(geom.vertices, {w2, -h2, d2})

    -- then go ahead and add the rest of the faces
    for i, value in ipairs(self.values) do
        local valueFraction = value/self.maxValue
        local valueHeight = valueFraction * s.height
        table.insert(geom.vertices, {-w2, valueHeight -h2, (step * i) - d2})
        table.insert(geom.vertices, {w2, valueHeight -h2, (step * i) - d2})
        local top = #geom.vertices
        table.insert(geom.triangles, {top - 3, top - 2, top - 1})
        table.insert(geom.triangles, {top - 2, top - 0, top - 1})
    end

    local mySpec = tablex.union(View.specification(self), {
        geometry = geom,
        
        material = {
            color = self.color
        },
    })

    return mySpec
end
function Plotline:specificationz()
    local s = self.bounds.size
    local w2 = s.width / 2.0
    local h2 = s.height / 2.0
    local d2 = s.depth / 2.0
    local mySpec = tablex.union(View.specification(self), {
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

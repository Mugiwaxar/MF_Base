-- Item --
local dpI = {}
dpI.type = "item"
dpI.name = "DimensionalPlate"
dpI.icon = "__MF_Base__/graphics/items/DimensionalPlate.png"
dpI.icon_size = 64
dpI.subgroup = "MFIntermediate"
dpI.order = "b"
dpI.stack_size = 1000
data:extend{dpI}

-- Recipe --
local dpR = {}
dpR.type = "recipe"
dpR.name = "DimensionalPlate"
dpR.energy_required = 1
dpR.category = "DimensionalSmelting"
dpR.enabled = false
dpR.ingredients =
    {
		{"DimensionalOre", 2}
    }
dpR.result = "DimensionalPlate"
data:extend{dpR}
-- MACHINE FRAME MK1 --

-- Item --
local mfI = {}
mfI.type = "item"
mfI.name = "MachineFrame"
mfI.icon = "__MF_Base__/graphics/items/MachineFrame.png"
mfI.icon_size = 64
mfI.subgroup = "MFFrame"
mfI.order = "a"
mfI.stack_size = 150
data:extend{mfI}

-- Recipe --
local mfR = {}
mfR.type = "recipe"
mfR.name = "MachineFrame"
mfR.energy_required = 1
mfR.ingredients =
    {
      {"DimensionalOre", 7}
    }
mfR.result = "MachineFrame"
data:extend{mfR}


-- MACHINE FRAME MK2 --

-- Item --
local mf2I = {}
mf2I.type = "item"
mf2I.name = "MachineFrame2"
mf2I.icon = "__MF_Base__/graphics/items/MachineFrame2.png"
mf2I.icon_size = 64
mf2I.subgroup = "MFFrame"
mf2I.order = "b"
mf2I.stack_size = 150
data:extend{mf2I}

-- Recipe --
local mf2R = {}
mf2R.type = "recipe"
mf2R.name = "MachineFrame2"
mf2R.energy_required = 1.5
mf2R.enabled = false
mf2R.ingredients =
    {
		{"MachineFrame", 2},
		{"DimensionalPlate", 6}
    }
mf2R.result = "MachineFrame2"
data:extend{mf2R}


-- MACHINE FRAME MK3 --

-- Item --
local mf3I = {}
mf3I.type = "item"
mf3I.name = "MachineFrame3"
mf3I.icon = "__MF_Base__/graphics/items/MachineFrame3.png"
mf3I.icon_size = 64
mf3I.subgroup = "MFFrame"
mf3I.order = "c"
mf3I.stack_size = 150
data:extend{mf3I}

-- Recipe --
local mf3R = {}
mf3R.type = "recipe"
mf3R.name = "MachineFrame3"
mf3R.energy_required = 3
mf3R.enabled = false
mf3R.category = "DimensionalCrystallizaton"
mf3R.ingredients =
{
    {"MachineFrame2", 1},
	  {"DimensionalCrystal", 1}
}
mf3R.result = "MachineFrame3"
data:extend{mf3R}
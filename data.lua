require("prototypes/resources/dimensional-ore.lua")
require("prototypes/resources/dimensional-fluid.lua")
require("prototypes/items/dimensional-sample.lua")
require("prototypes/items/dimensional-plate.lua")
require("prototypes/items/dimensional-crystal.lua")
require("prototypes/items/dimensional-electronic.lua")
require("prototypes/items/machine-frame.lua")
require("prototypes/items/energy-core.lua")
require("prototypes/entities/dimensional-lab.lua")
require("prototypes/entities/dimensional-furnace.lua")
require("prototypes/entities/crystallizer.lua")

---- Add the MF Base Group --
data:extend{
	{
		type="item-group",
		name="MFBase",
		icon="__MF_Base__/graphics/items/DimensionalPlate.png",
		icon_size="32",
		order="w"
	}
}

---- Add Resources Category ----
data:extend{
	{
		type="item-subgroup",
		name="MFResources",
		group="MFBase",
		order="a"
	}
}

---- Add Intermediate Category ----
data:extend{
	{
		type="item-subgroup",
		name="MFIntermediate",
		group="MFBase",
		order="b"
	}
}

---- Add Electronic Category ----
data:extend{
	{
		type="item-subgroup",
		name="MFElectronic",
		group="MFBase",
		order="c"
	}
}

---- Add Frame Category ----
data:extend{
	{
		type="item-subgroup",
		name="MFFrame",
		group="MFBase",
		order="d"
	}
}

---- Add Structure Category ----
data:extend{
	{
		type="item-subgroup",
		name="MFStructure",
		group="MFBase",
		order="e"
	}
}

-- Add the Dimensional Smelting Recipe Category --
data:extend{
	{
		type="recipe-category",
		name="DimensionalSmelting",
		order="a"
	}
}

-- Add the Dimensional Crystallization Recipe Category --
data:extend{
	{
		type="recipe-category",
		name="DimensionalCrystallizaton",
		order="b"
	}
}
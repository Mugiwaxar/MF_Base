Util = Util or {}

-- Advenced print --
function dprint(v)
	game.print(serpent.block(v))
end

-- Print all Keys --
function dprintKeys(t)
	dprint("--- KEYS ---")
	for k, _ in pairs(t) do
		dprint(k)
	end
	dprint("------------")
end

-- Used to do a protected Function call --
function mfCall(fName, ...)
	-- Dont use pcall() if the game is in Instrument mode --
	if game.active_mods["debugadapter"] then
		fName(...)
		return
	end
	-- Secure call the Function --
	local result, error = pcall(fName, ...)

	-- Check if the Function was correctly executed --
	if result == false then
		-- Display the Error to all Player --
		for _, player in pairs(game.players) do
			GAPI.createErrorWindow(error, player)
		end
		return true
	end
end

-- Return the player object with his id --
function getPlayer(id)
	return game.players[id]
end

-- Round a Number --
function Util.round(n)
	return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end


-- Return a splitted table of a string --
function Util.split(str, char)
	char = "[^" .. char .."]+"
	local parts = {__index = table.insert}
	setmetatable(parts, parts)
	str:gsub(char, parts)
	setmetatable(parts, nil)
	parts.__index = nil
	return parts
end

-- Return a comprehensible time --
function Util.getRealTime(time)
	local second = time * 86400
	local minute = math.floor(second / 60) % 60
	local hour = math.floor(second/3600)
	local AMPM = hour > 12 and "AM" or "PM"
	if hour == 12 then hour = 0 elseif hour == 0 then hour = 12 end
	if hour > 12 then hour = hour - 12 end
	if hour == 0 then AMPM = "AM" end
	if minute < 10 then minute = 0 .. tostring(minute) else minute = tostring(minute) end
	if hour < 10 then hour = 0 .. tostring(hour) else hour = tostring(hour) end
	local realTime = {"", hour, "H", minute, " ", AMPM}
	return realTime
end

-- Return the localised Entity Name --
function Util.getLocEntityName(entName)
	if game.entity_prototypes[entName] ~= nil then
		return game.entity_prototypes[entName].localised_name
	end
end

-- Return the localised Item Name --
function Util.getLocItemName(itemName)
	if game.item_prototypes[itemName] ~= nil then
		return game.item_prototypes[itemName].localised_name
	end
end

-- Return the localised Fluid Name --
function Util.getLocFluidName(fluidName)
	if game.fluid_prototypes[fluidName] ~= nil then
		return game.fluid_prototypes[fluidName].localised_name
	end
end

-- Return the localised Recipe Name --
function Util.getLocRecipeName(recipeName)
	if game.recipe_prototypes[recipeName] ~= nil then
		return game.recipe_prototypes[recipeName].localised_name
	end
end

-- Reset an Animation --
function Util.resetAnimation(animId, totalFrame)
	local animSpeed = rendering.get_animation_speed(animId)
	local currentFrame = math.floor((game.tick * animSpeed) % totalFrame)
	rendering.set_animation_offset(animId, 0 - currentFrame)
end

-- Unlock a recipe for all Players --
function Util.unlockRecipeForAll(recipeName, techCondition)
	if recipeName == nil then return end
	for k, force in pairs(game.forces) do
		if techCondition ~= nil and Util.technologyUnlocked(techCondition, force) == true then
			force.recipes[recipeName].enabled = true
		end
	end
end

-- Test if player have this technologie unlocked --
function Util.technologyUnlocked(name, force)
	if force == nil then force = game.forces["player"] end
	if force == nil then return false end
	if force.technologies[name] ~= nil and force.technologies[name].researched then return true end
	return false
end

-- Create Tiles at the given position and radius --
function Util.createTilesAtPosition(position, radius, surface, tileName, force)
	-- Check all variables --
	if position == nil or radius == nil or surface == nil then return end
	if tileName == nil then tileName = "tutorial-grid" end
	-- Ajust the radius --
	radius = radius - 1
	-- Create all tiles --
	local tilesTable = {}
	for x = 0 - radius, radius do
		for y = 0 - radius, radius do
			posX = math.floor(position.x) + x
			posY = math.floor(position.y) + y
			tilesFind = surface.find_tiles_filtered{area={{posX, posY},{posX+1, posY+1}}}
			local replace = true
			for k, tile in pairs(tilesFind) do
				-- this check can somehow destroy Equalizer and kill player. See knownbugs.txt[1]
				if tileName == "tutorial-grid" and tile.name ~= "VoidTile" then
					replace = false
				end
			end
			if force == true or replace == true then
				table.insert(tilesTable, {name=tileName, position={posX, posY}})
			end
		end
	end
	-- Set tiles --
	if table_size(tilesTable) > 0 then surface.set_tiles(tilesTable) end
end

-- Create a frame from an Item --
function Util.itemToFrame(name, count, GUIObj, gui)
	-- Create the Button --
	local button = GUIObj:addButton("", gui, "item/" .. name, "item/" .. name, {"", Util.getLocItemName(name), ": ", Util.toRNumber(count)}, 37, true, true, count)
	button.style = "MF_Fake_Button_Blue"
	button.style.padding = 0
	button.style.margin = 0
end

-- Create a frame from a Fluid --
function Util.fluidToFrame(name, count, GUITable, gui)
	-- Create the Button --
	local button = GAPI.addButton(GUITable, "", gui, "fluid/" .. name, "fluid/" .. name, {"", Util.getLocFluidName(name), ": ", Util.toRNumber(count)}, 37, true, true, count)
	button.style = "MF_Fake_Button_Purple"
	button.style.padding = 0
	button.style.margin = 0
end

-- Randomize Table --
function Util.shuffle(array)
	for i = table_size(array), 2, -1 do
		local j = math.random(i)
		array[i], array[j] = array[j], array[i]
	end
	return array
end

-- Calcule the Distance between two Positions --
function Util.distance(position1, position2)
	local x1 = position1[1] or position1.x
	local y1 = position1[2] or position1.y
	local x2 = position2[1] or position2.x
	local y2 = position2[2] or position2.y
	return ((x1 - x2) ^ 2 + (y1 - y2) ^ 2) ^ 0.5
end

-- Calcule the distance in Tiles between two Positions --
function Util.distanceByTiles(position1, position2)
	local x1 = position1[1] or position1.x
	local y1 = position1[2] or position1.y
	local x2 = position2[1] or position2.x
	local y2 = position2[2] or position2.y
	return math.max(math.abs(x1-x2), math.abs(y1-y2))
end

-- Transform big numbers to readable numbers --
function Util.toRNumber(number)
	if number == nil then return 0 end
	local rNumber = number
	local rSuffix = "";
	if number >= 1000000000 then
		rNumber = number/1000000000
		rSuffix = " G"
	elseif number >= 1000000 then
		rNumber = number/1000000
		rSuffix = " M"
	elseif number >= 1000 then
		rNumber = number/1000 
		rSuffix = " k"
	end

	return string.format("%.2f", rNumber):gsub("%.0+$", "") .. rSuffix
end

-- Copy a Table --
function Util.copyTable(t1)
	local t2 = {}
	for k, j in pairs(t1 or {}) do
		t2[k] = j
	end
	return t2
end

-- Synchronize the Fluid between two Pipes --
function Util.syncPipes(outPipe, inPipe, way)

	if way == "input" then

		-- Check the Fluidbox --
		if outPipe.fluidbox == nil or outPipe.fluidbox[1] == nil then return end

		-- Get the Fluid inside the outPipe --
		local FName = outPipe.fluidbox[1].name
		local fAmount = outPipe.fluidbox[1].amount
		local fTemp = outPipe.fluidbox[1].temperature

		-- Insert the Fluid inside the inPipe --
		local inserted = inPipe.insert_fluid({name=FName, amount=fAmount, temperature=fTemp})

		-- Remove the Fluid from the outPipe --
		outPipe.remove_fluid{name=FName, amount=inserted}

		return

	end

	if way == "output" then

		-- Check the Fluidbox --
		if inPipe.fluidbox == nil or inPipe.fluidbox[1] == nil then return end

		-- Get the Fluid inside the inPipe --
		local FName = inPipe.fluidbox[1].name
		local fAmount = inPipe.fluidbox[1].amount
		local fTemp = inPipe.fluidbox[1].temperature

		-- Insert the Fluid inside the outPipe --
		local inserted = outPipe.insert_fluid({name=FName, amount=fAmount, temperature=fTemp})

		-- Remove the Fluid from the inPipe --
		inPipe.remove_fluid{name=FName, amount=inserted}

		return

	end

end
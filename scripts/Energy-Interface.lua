EI = EI or {}

-- Structures compatible with Energy --
_mfEnergyStructures = {
    ["EnergyLaser1"] = {speed=200000, canAccept=false, scanArea={-1, -1, 1, 1}},
    ["EnergyLaser2"] = {speed=1500000, canAccept=false, scanArea={-1, -1, 1, 1}},
    ["EnergyLaser3"] = {speed=5000000, canAccept=false, scanArea={-1, -1, 1, 1}},
    ["EnergyCubeMK1"] = {speed=200000, canAccept=true, scanArea={-1.5, -1.5, 1.5, 1.5}},
    ["EnergyCubeMK2"] = {speed=1500000, canAccept=true, scanArea={-1.5, -1.5, 1.5, 1.5}},
    ["EnergyCubeMK3"] = {speed=5000000, canAccept=true, scanArea={-1.5, -1.5, 1.5, 1.5}},
    ["InternalEnergyCube"] = {speed=5000000, canAccept=true, scanArea={-3.5, -2.5, 3.5, 4.5}},
    ["EnergyDispenserAcc"] = {speed=10000000, canAccept=true, scanArea={-2.5, -2.5, 2.5, 2.5}}
}

-- Structures compatible with Quatron Energy --
_mfQuatronStructures = {
    ["QuatronLaser1"] = {speed=200, canAccept=false, scanArea={-1, -1, 1, 1}},
    ["QuatronLaser2"] = {speed=1500, canAccept=false, scanArea={-1, -1, 1, 1}},
    ["QuatronLaser3"] = {speed=5000, canAccept=false, scanArea={-1, -1, 1, 1}},
    ["QuatronCubeMK1"] = {speed=200, canAccept=true, scanArea={-1.5, -1.5, 1.5, 1.5}},
    ["QuatronCubeMK2"] = {speed=1500, canAccept=true, scanArea={-1.5, -1.5, 1.5, 1.5}},
    ["QuatronCubeMK3"] = {speed=5000, canAccept=true, scanArea={-1.5, -1.5, 1.5, 1.5}},
    ["InternalQuatronCube"] = {speed=5000, canAccept=true, scanArea={-3.5, -2.5, 3.5, 4.5}},
    ["QuatronReactor"] = {speed=5000, canAccept=false, scanArea={-2.5, -2.5, 2.5, 2.5}},
    ["NetworkAccessPoint"] = {speed=1000, canAccept=true},
    ["FluidExtractor"] = {speed=1000, canAccept=true},
    ["OreCleaner"] = {speed=1000, canAccept=true}
}

-- Return the current Energy --
function EI.energy(obj)
    if obj.ent ~= nil and obj.ent.valid == true then
        return obj.energyCharge or obj.ent.energy or 0
    end
    return 0
end

-- Return the missing Energy before full --
function EI.missingEnergy(obj)
    return EI.maxEnergy(obj) - EI.energy(obj)
end

-- Return the Energy Level --
function EI.energyLevel(obj)
    return obj.energyLevel
end

-- Return the Energy Buffer size --
function EI.maxEnergy(obj)
    if obj.ent ~= nil and obj.ent.valid == true then
        return obj.energyBuffer or obj.ent.electric_buffer_size or 0
    end
    return 1
end

-- Return the I/O speed --
function EI.speed(obj)
    if obj.ent ~= nil and obj.ent.valid == true then
        if _mfEnergyStructures[obj.ent.name] ~= nil then
            return _mfEnergyStructures[obj.ent.name].speed
        end
        if _mfQuatronStructures[obj.ent.name] ~= nil then
            return _mfQuatronStructures[obj.ent.name].speed
        end
    end
    return 0
end

-- Add Energy --
function EI.addEnergy(obj, amount, level)
    if obj.ent == nil or obj.ent.valid == false then return 0 end
    if amount <= 0 then return 0 end
    local maxAdded = math.min(EI.speed(obj), EI.missingEnergy(obj), amount)
    if level ~= nil and EI.energy(obj) <= 0 then
        if obj.energyCharge ~= nil then
            obj.energyCharge = maxAdded
            obj.energyLevel = level
        else
            obj.ent.energy = maxAdded
            obj.energyLevel = level
        end
    elseif level ~= nil then
        EI.mixQuatron(obj, maxAdded, level)
    else
        obj.ent.energy = EI.energy(obj) + maxAdded
    end
    return maxAdded
end

-- Remove Energy --
function EI.removeEnergy(obj, amount)
    if obj.ent == nil or obj.ent.valid == false then return 0 end
    if amount <= 0 then return end
    local maxRemoved = math.min(amount, EI.energy(obj))
    if obj.energyCharge ~= nil then
        obj.energyCharge = math.max(EI.energy(obj) - maxRemoved, 0)
    else
        obj.ent.energy = math.max(EI.energy(obj) - maxRemoved, 0)
    end
    if EI.energyLevel(obj) ~= nil and EI.energy(obj) <= 0 then
        obj.energyLevel = 1
    end
    return maxRemoved
end

-- Find Structures that can accept Energy around --
function EI.findEIStructures(obj, laser)

    -- Check the Entity --
    if obj.ent == nil or obj.ent.valid == false then return end

    -- Get the Table and the definition Table --
    local defTable = _mfEnergyStructures[obj.ent.name] or _mfQuatronStructures[obj.ent.name]
    if defTable == nil then return end
    local tableType = _mfEnergyStructures[obj.ent.name] ~= nil and _mfEnergyStructures or _mfQuatronStructures

    -- Get all Structures around that can accept Energy --
    local eiTable = {}
    local x1 = obj.ent.position.x + defTable.scanArea[1]
    local y1 = obj.ent.position.y + defTable.scanArea[2]
    local x2 = obj.ent.position.x + defTable.scanArea[3]
    local y2 = obj.ent.position.y + defTable.scanArea[4]
    local ents = obj.ent.surface.find_entities_filtered{area={{x1, y1}, {x2, y2}}}
    for _, ent in pairs(ents) do
        if ent ~= nil and ent.valid == true and tableType[ent.name] ~= nil then
            local ei = global.entsTable[ent.unit_number]
            if ei~= nil and ei.ent ~= nil and ei.ent.valid == true then
                if laser ~= true and EI.energy(obj) > EI.energy(ei) and tableType[ent.name].canAccept == true then
                    table.insert(eiTable, ei)
                elseif laser == true and EI.energy(ei) > 0 then
                    return ei
                end
            end
        end
    end

    -- Return the Table --
    return eiTable

end

-- Share Energy with the Structures around --
function EI.shareEnergy(obj)

    -- Check the Entity --
    if obj.ent == nil or obj.ent.valid == false then return end

    -- Get all Energy Interfaces Around --
    local eiTable = EI.findEIStructures(obj)

    -- Check the Energy Interface Table --
    if table_size(eiTable) <= 0 then return end

    -- Send Energy to all surronding Structures --
    local flowLeft = math.min(EI.speed(obj), EI.energy(obj))
    local total = flowLeft
    local maxFlow = math.floor(flowLeft / table_size(eiTable))
    for k, ei in pairs(eiTable) do
        local flow = math.floor((EI.energy(obj) - EI.energy(ei)) / 2)
        local sent = EI.addEnergy(ei, math.min(maxFlow, flow), EI.energyLevel(obj))
        flowLeft = flowLeft - sent
        eiTable[k] = nil
        maxFlow = math.floor(flowLeft / table_size(eiTable))
    end

    -- Remove the Amount Sent --
    EI.removeEnergy(obj, total - flowLeft)

end

-- Send Energy (For Lasers) --
function EI.sendEnergy(eiObj, receiver, speed)

    -- Check the Entity --
    if eiObj == nil or receiver == nil or eiObj.ent == nil or receiver.ent == nil or eiObj.ent.valid == nil or receiver.ent.valid == nil then return 0 end

    -- Sent the Energy --
    local sent = EI.addEnergy(receiver, math.min(speed, EI.speed(eiObj), EI.speed(receiver), EI.energy(eiObj)), EI.energyLevel(eiObj))

    -- Check if something was sent --
    if sent <= 0 then return 0 end

    -- Remove the Energy --
    EI.removeEnergy(eiObj, sent)

    return sent

end

-- Mix Quatron Level --
function EI.mixQuatron(obj, newCharge, newLevel)
	local effectiveCharge = (EI.energy(obj)) * math.pow(EI.energyLevel(obj), _mfQuatronScalePower) + newCharge * math.pow(newLevel, _mfQuatronScalePower)
    if obj.energyCharge ~= nil then
        obj.energyCharge = EI.energy(obj) + newCharge
    else
        obj.ent.energy = EI.energy(obj) + newCharge
    end
	obj.energyLevel = math.pow(effectiveCharge / EI.energy(obj), 1/_mfQuatronScalePower)
end
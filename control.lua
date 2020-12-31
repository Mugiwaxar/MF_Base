require("scripts/Util.lua")
require("scripts/GUI-API.lua")

-- When a GUI Button is clicked --
function onButtonClicked(event)
	mfCall(buttonClicked, event)
end

function buttonClicked(event)
    -- Get the Player --
    local player = getPlayer(event.player_index)
    -- Close the Error --
    if event.element.name == "MFErrorContinue" then
        if player.gui.screen.MFBaseErrorWindows ~= nil and player.gui.screen.MFBaseErrorWindows.valid == true then
            player.gui.screen.MFBaseErrorWindows.destroy()
        end
    end
end

-- Events --
script.on_event(defines.events.on_gui_click, onButtonClicked)
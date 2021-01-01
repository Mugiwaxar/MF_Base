---------------------------------- The GUI API to create GUI easily ----------------------------------

GAPI = GAPI or {}

-- Create a Window --
function GAPI.createBaseWindows(name, title, MFPlayer, showTitle, showMainFrame, isScroolPane, windowsDirection, mainFrameDirection)
    if MFPlayer == nil then return end
    if MFPlayer.ent.gui.screen[name] ~= nil and MFPlayer.ent.gui.screen[name].valid == true then MFPlayer.ent.gui.screen[name].destroy() end
    if MFPlayer.ent.gui.screen[name] ~= nil and MFPlayer.ent.gui.screen[name].valid == false then MFPlayer.ent.gui.screen[name] = nil end
    local GUITable = {title=title, MFPlayer=MFPlayer, vars={}}
    GUITable.gui = MFPlayer.ent.gui.screen.add{type="frame", name=name, direction=windowsDirection or "vertical"}
    GUITable.gui.style.padding = 5
    GUITable.gui.style.top_padding = 0
    GUITable.gui.style.margin = 0
    if showTitle ~= false then GAPI.createTitle(GUITable) end
    if showMainFrame ~= false then
        local mainFrame = nil
        if isScroolPane ~= true then
            mainFrame = GAPI.addFrame(GUITable, "MainFrame", GUITable.gui, mainFrameDirection or "vertical", true)
            mainFrame.style = "invisible_frame"
        else
            mainFrame = GAPI.addScrollPane(GUITable, "MainFrame", GUITable.gui, nil, true)
        end
        mainFrame.style.vertically_stretchable = true
    end
    GAPI.setSize(GUITable.gui, _mfDefaultGuiHeight, _mfDefaultGuiWidth)
    GAPI.centerWindow(GUITable.gui)
    return GUITable
end

-- Set the Element Geometry --
function GAPI.setGeometry(Gui, posX, posY, minHeight, minWidth, maxHeight, maxWidth, height, width)
    if Gui == nil then return end
    if posX ~= nil then Gui.location = {posX, Gui.location.y} end
    if posY ~= nil then Gui.location = {Gui.location.x, posY} end
    if minHeight ~= nil then Gui.style.minimal_height = minHeight end
    if minWidth ~= nil then Gui.style.minimal_width = minWidth end
    if maxHeight ~= nil then Gui.style.minimal_height = maxHeight end
    if maxWidth ~= nil then Gui.style.maximal_height = maxWidth end
    if height ~= nil then Gui.style.natural_height = height end
    if width ~= nil then Gui.style.natural_width = width end
end

-- Set the Element Location --
function GAPI.setLocation(Gui, posX, posY)
    if Gui == nil then return end
    if posX ~= nil then Gui.location = {posX, Gui.location.y} end
    if posY ~= nil then Gui.location = {Gui.location.x, posY} end
end

-- Set the Element Normal Size --
function GAPI.setSize(Gui, height, width)
    if height ~= nil then Gui.style.natural_height = height end
    if width ~= nil then Gui.style.natural_width = width end
end

-- Set the Element Minimum Size --
function GAPI.setMinSize(Gui, minHeight, minWidth)
    if Gui == nil then return end
    if minHeight ~= nil then Gui.style.minimal_height = minHeight end
    if minWidth ~= nil then Gui.style.minimal_width = minWidth end
end

-- Set the Element Maximum Size --
function GAPI.setMaxSize(Gui, maxHeight, maxWidth)
    if Gui == nil then return end
    if maxHeight ~= nil then Gui.style.minimal_height = maxHeight end
    if maxWidth ~= nil then Gui.style.maximal_height = maxWidth end
end

-- Set all Sizes of the Element --
function GAPI.setAllSize(Gui, height, width)
    GAPI.setSize(Gui, height, width)
    GAPI.setMinSize(Gui, height, width)
    GAPI.setMaxSize(Gui, height, width)
end

-- Center the Window --
function GAPI.centerWindow(Gui)
    Gui.force_auto_center()
end

-- Add the Title to the Window --
function GAPI.createTitle(GUITable)
    -- Create the Menu Bar --
    local topBarFlow = GAPI.addFlow(GUITable, "topBarFlow", GUITable.gui, "horizontal", true)
    topBarFlow.style.vertical_align = "center"
    topBarFlow.style.padding = 0
    topBarFlow.style.margin = 0
	-- Add the Title Label --
	local barTitle = GUITable.title or {"gui-description." .. GUITable.gui.name .. "Title"}
	GAPI.addLabel(GUITable, "GUITitle", topBarFlow, barTitle, _mfOrange, nil, true, "TitleFont")
	-- Add the Draggable Area --
    local dragArea = GAPI.addEmptyWidget(GUITable, "", topBarFlow, GUITable.gui, _mfGUIDragAreaSize)
    dragArea.style.left_margin = 8
    dragArea.style.right_margin = 8
    dragArea.style.minimal_width = 30
end

-- Add a close Button --
function GAPI.addCloseButton(GUITable)
    local button = GAPI.addButton(GUITable, GUITable.gui.name.. "CloseButton", GUITable.vars.topBarFlow, "CloseIcon", "CloseIcon", {"gui-description.closeButton"}, _mfGUICloseButtonSize)
    button.style = "frame_action_button"
end

-- Add a new Frame --
function GAPI.addFrame(GUITable, name, gui, direction, save)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the frame --
	local frame = gui.add{type="frame", name=name, direction=direction}
	-- Set Style --
	frame.style.padding = 0
    frame.style.margin = 0
    frame.style.horizontally_stretchable = true
    -- Save the Frame inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = frame
    end
    return frame
end

-- Create a Title Label --
function GAPI.addTitledFrame(GUITable, name, gui, direction, text, color, save)
    local titleFrame = GAPI.addFrame(GUITable, nil, gui, "horizontal")
    titleFrame.style.horizontally_stretchable = true
    local titleFlow = GAPI.addFlow(GUITable, nil, titleFrame, "horizontal")
    GAPI.addLabel(GUITable, name .. "Label", titleFlow, text, color, "", save, "TitleFont")
    titleFlow.style.horizontal_align = "center"
    return titleFrame
end

-- Create a Subtitle --
function GAPI.addSubtitle(GUITable, name, gui, text, save)
    local flow = GAPI.addFlow(GUITable, "", gui, "vertical", save)
    flow.style.horizontal_align = "center"
    flow.style.vertically_stretchable = false
    GAPI.addLine(GUITable, "", flow, "horizontal")
    local label = GAPI.addLabel(GUITable, "", flow, text, nil, nil, false, nil, _mfLabelType.yellowTitle)
    label.style.left_margin = 10
    label.style.right_margin = 10
    GAPI.addLine(GUITable, "", flow, "horizontal")
end

-- Add a new Flow --
function GAPI.addFlow(GUITable, name, gui, direction, save)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Flow --
	local flow = gui.add{type="flow", name=name, direction=direction}
	-- Set Style --
	flow.style.padding = 0
    flow.style.margin = 0
    flow.style.horizontally_stretchable = true
    -- Save the Flow inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = flow
    end
    return flow
end

-- Add a new Scroll Pane --
function GAPI.addScrollPane(GUITable, name, gui, size, save, style, policy)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Scrool Pane --
    local scrollPane = gui.add{type="scroll-pane", name=name, horizontal_scroll_policy="never", vertical_scroll_policy=policy or "always"}
    -- Set Style --
    if style ~= nil then scrollPane.style = style end
    scrollPane.style.padding = 0
    scrollPane.style.margin = 0
    scrollPane.style.maximal_height = size
    scrollPane.style.horizontally_stretchable = true
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = scrollPane
    end
    return scrollPane
end

-- Add a Tabbed Pane --
function GAPI.addTabbedPane(GUITable, name, gui, text, tooltip, save, selectedIndex)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Tabbed Pane --
    local tabbedPane = gui.add{type="tabbed-pane", name=name, caption=text, tooltip=tooltip}
    -- Set the Style --
    tabbedPane.style.margin = 0
    tabbedPane.style.padding = 0
    -- Set the Selected Tab --
    tabbedPane.selected_tab_index = selectedIndex or 1
    -- Save the Tabbed Pane inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = tabbedPane
    end
    return tabbedPane
end

-- Add a Tab --
function GAPI.addTab(GUITable, name, gui, text, tooltip, save)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Tabbed Pane --
    local tab = gui.add{type="tab", name=name .. "tab", caption=text, tooltip=tooltip}
    -- Create the Flow --
    local flow = gui.add{type="flow", name=name, direction="vertical"}
    -- Set the Style --
    tab.style.margin = 0
    tab.style.padding = 0
    flow.style.margin = 0
    flow.style.padding = 0
    flow.style.horizontally_stretchable = true
    flow.style.vertically_stretchable  = true
    -- Save the Tab inside the Tabed Pane --
    gui.add_tab(tab, flow)
    -- Save the Tabbed Pane inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = flow
    end
    return flow
end

-- Add a new Table --
function GAPI.addTable(GUITable, name, gui, column, save)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Table --
    local tableGUI = gui.add{type="table", name=name, column_count=column}
    -- Set Style --
	tableGUI.style.padding = 0
    tableGUI.style.margin = 0
    tableGUI.style.cell_padding = 0
    tableGUI.style.horizontal_spacing  = 0
    tableGUI.style.horizontal_spacing  = 0
    tableGUI.style.vertical_spacing  = 0
    -- Save the Flow inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = tableGUI
    end
    return tableGUI
end

-- Add a new Draggable Space --
function GAPI.addEmptyWidget(GUITable, name, gui, parent, sizeX, sizeY, save)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Empty Widget --
    local emptyWidget = gui.add{type="empty-widget", name=name, style='draggable_space'}
    -- Set Style --
    emptyWidget.drag_target = parent
    if sizeX ~= nil then emptyWidget.style.height = sizeX end
    if sizeY ~= nil then emptyWidget.style.width = sizeY end
    emptyWidget.style.padding = 0
    emptyWidget.style.margin = 0
    emptyWidget.style.horizontally_stretchable = true
    -- Save the Empty Widget inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.elements[name] = emptyWidget
    end
    return emptyWidget
end

-- Add a new Label --
function GAPI.addLabel(GUITable, name, gui, text, color, tooltip, save, font, style)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Label --
    local label = gui.add{type="label", name=name, caption=text, tooltip=tooltip}
    if style ~= nil then
        -- Set the Style --
        label.style = style
    else
        -- Set the Text font and Color --
        label.style.font = font or "LabelFont"
        label.style.font_color = color or _mfBlue
    end
    -- Save the Label inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = label
    end
    return label
end

-- Add a dual Label --
function GAPI.addDualLabel(GUITable, gui, text1, text2, color1, color2, font, tooltip1, tooltip2, name, save)
    -- Create the Frame --
    local flow = GAPI.addFlow(GUITable, "", gui, "horizontal")
    GAPI.addLabel(GUITable, "Label1", flow, text1, color1, tooltip1, false, font)
    GAPI.addLabel(GUITable, "Label2", flow, text2, color2, tooltip2, false, font)
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = flow
    end
    return flow
end

-- Add a new Text Field --
function GAPI.addTextField(GUITable, name, gui, text, tooltip, save, numeric, allowDecimal, allowNegative, isPassword, tags)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    local textField = gui.add{type="textfield", name=name, text=text, tooltip=tooltip, numeric=numeric or false, allow_decimal=allowDecimal or false, allow_negative=allowNegative or false, is_password=isPassword or false, tags=tags}
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = textField
    end
    return textField
end

-- Add a Text Box --
function GAPI.addTextBox(GUITable, name, gui, text, tooltip, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    local textBox = gui.add{type="text-box", name=name, text=text, tooltip=tooltip}
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = textBox
    end
    return textBox
end

-- Add a new Button --
function GAPI.addButton(GUITable, name, gui, sprite, hovSprite, tooltip, size, save, visible, count, style, tags)
    if visible == false then return end
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Button --
    local button = gui.add{
		type="sprite-button",
		name=name,
		sprite=sprite,
		hovered_sprite=hovSprite,
		resize_to_sprite=false,
        tooltip=tooltip,
        number=count,
        tags=tags
    }
    -- Set the Style --
    if style ~= nil then button.style = style end
        button.style.minimal_width = size
        button.style.maximal_width = size
        button.style.minimal_height = size
        button.style.maximal_height = size
        button.style.padding = 0
        button.style.margin = 0
    -- Save the Button inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = button
    end
    return button
end

-- Add a new Simple Button --
function GAPI.addSimpleButton(GUITable, name, gui, text, tooltip, save, tags)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    local button = gui.add{type="button", name=name, caption=text, tooltip=tooltip, tags=tags}

    if GUITable ~= nil and save == true then
        GUITable.vars[name] = button
    end
    return button
end

-- Add a CheckBox --
function GAPI.addCheckBox(GUITable, name, gui, text, tooltip, state, save, tags)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the CheckBox --
    local checkBox = gui.add{type="checkbox", name=name, caption=text, tooltip=tooltip, state=state or false, tags = tags}
    -- Save the Check Box inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = checkBox
    end
    return checkBox
end

-- Add a Switch --
function GAPI.addSwitch(GUITable, name, gui, text1, text2, tooltip1, tooltip2, state, save, tags)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Switch --
    local switch = gui.add{type="switch", name=name, switch_state=state or "left", left_label_caption=text1, right_label_caption=text2, left_label_tooltip=tooltip1, right_label_tooltip=tooltip2, tags=tags}
    -- Save the Switch inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = switch
    end
    return switch
end

-- Add a new Line --
function GAPI.addLine(GUITable, name, gui, direction, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Line --
    local line = gui.add{type="line", name=name, direction=direction}
    -- Save the Line inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = line
    end
    return line
end

-- Add a Drop Down --
function GAPI.addDropDown(GUITable, name, gui, items, selected, save, tooltip, tags)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    local dropDown = gui.add{type="drop-down", name=name, items=items, selected_index=selected, tooltip=tooltip, tags=tags}
    dropDown.style.maximal_width = 200
    -- Save the Drop Down inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = dropDown
    end
    return dropDown
end

-- Add a new Progress Bar --
function GAPI.addProgressBar(GUITable, name, gui, text, tooltip, save, color, value, size)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Progress Bar --
	local progressBar = gui.add{type="progressbar", name=name, caption=text, tooltip=tooltip}
    -- Set the Progress Bar Color --
    if color ~= nil then progressBar.style.color = color end
    -- Set the Progress Bar Size --
    if size ~= nil then progressBar.style.maximal_width = size end
    progressBar.style.horizontally_stretchable = true
    -- Set the Progress Bar value --
    if value ~= nil then progressBar.value = value end
    -- Save the Progress Bar inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = progressBar
    end
    return progressBar
end

-- Add a new Filter --
function GAPI.addFilter(GUITable, name, gui, tooltip, save, elemType, size, tags)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Filter --
    local filter = gui.add{type="choose-elem-button", name=name, tooltip=tooltip, elem_type=elemType, tags=tags}
    filter.style.height = size
    filter.style.width = size
    -- Save the Filter inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = filter
    end
    return filter
end

-- Add a new Sprite --
function GAPI.addSprite(GUITable, name, gui, path, tooltip, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Sprite --
    local sprite = gui.add{type="sprite", name=name, sprite=path, tooltip=tooltip}
    sprite.style.padding = 0
    sprite.style.margin = 0
    -- Save the Spite inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = sprite
    end
    return sprite
end

-- Create Item Frame --
function GAPI.addItemFrame(GUITable, name, item, amount, gui, save)
    -- Create the Frame --
    local frame = GAPI.addFrame(name, gui, "horizontal")
    -- Create the Sprite --
    GAPI.addSprite(item, frame, "item/" .. item, game.item_prototypes[item].localised_name)
    -- Create the amount Label --
    GAPI.addLabel("", frame, Util.toRNumber(amount))
    -- Save the Spite inside the elements Table --
    if GUITable ~= nil and save == true then
        GUITable.vars[name] = frame
    end
    return frame
end

-- Create a Camera Frame --
function GAPI.createCamera(MFPlayer, name, title, ent, size, zoom)

    -- Create the Main Frame --
    local GUITable = GAPI.createBaseWindows(name, title, MFPlayer, true, true, false, "vertical", "vertical")
    local mainFrame = GUITable.gui.MainFrame
    GAPI.setAllSize(mainFrame, size, size)

    -- Add the Close Button --
    GAPI.addCloseButton(GUITable)

    -- Don't allow to Auto center --
    GUITable.gui.auto_center = false

	-- Create the Camera --
    local camera = mainFrame.add{type="camera", position=ent.position, surface_index =ent.surface.index, zoom=zoom or 1}
    camera.style.vertically_stretchable = true
	camera.style.horizontally_stretchable = true

	-- Return the Frame --
	return GUITable

end

-- Create the Window that handle Error message --
function GAPI.createErrorWindow(error, player)

    -- Check if the Windows doesn't already exist --
    if player.gui.screen.MFBaseErrorWindows ~= nil and player.gui.screen.MFBaseErrorWindows.valid == true then
        return
    end

    -- Create the Main Frame --
    local GUITable = GAPI.createBaseWindows("MFBaseErrorWindows", {"gui-description.MFError"}, {ent=player}, true, true, false, "vertical", "vertical")
    local mainFrame = GUITable.gui.MainFrame

    -- Create the Text Box --
    local errorText = "[color=white]A error occurred while executing a script and was caught to prevent a crash.[/color]\n"
    errorText = errorText .. "[color=white]Please report this error to the mod author.[/color]\n\n"
    errorText = errorText .. "[color=red]" .. error .. "[/color]\n\n"
    errorText = errorText .. "[color=white]You can still continue but this is not safe and may create some strange behaviors.[/color]\n"
    errorText = errorText .. "[color=white]Please keep a save before this error as a backup.[/color]"
    local textBlox = GAPI.addTextBox(GUITable, "", mainFrame, errorText)
    textBlox.enabled = false
    textBlox.style.width = 800
    textBlox.style.height = 200

    -- Create the Button --
    local flow = GAPI.addFlow(GUITable, "", mainFrame, "horizontal")
    flow.style.horizontally_stretchable = true
    flow.style.horizontal_align = "center"
    local button = GAPI.addSimpleButton(GUITable, "MFErrorContinue", flow, {"gui-description.MFErrorContinuBoutton"})
    button.style.top_margin = 5

end
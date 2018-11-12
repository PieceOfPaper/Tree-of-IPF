if UI_COMPONENT_TEST_TABLE == nil then UI_COMPONENT_TEST_TABLE = {} end

---------------------------------------------------------------------------------------------------------------------------------
--test
function UI_COMPONENT_TEST_TABLE.lib_toggle_button(testbox, x, y, name)
    if name == nil then
        name = "test_toggle_button";
    end
    testbox:RemoveChild(name);
    UI_LIB_TOGGLE_BUTTON_CREATE(testbox, name, "UI_LIB_TOGGLE_BUTTON_UPDATE_DUMMY", false, ui.LEFT, ui.TOP, x, y, 0, 0)
end


--test update function
function UI_LIB_TOGGLE_BUTTON_UPDATE_DUMMY(ctrlset, isToggle)
end
---------------------------------------------------------------------------------------------------------------------------------
--methods

function UI_LIB_TOGGLE_BUTTON_CREATE(parent, ctrlName, updateScript, initValue, horz, vert, left, top, right, bottom, width, height) -- initValue : boolean
    if GET_CHILD(parent, ctrlName) ~= nil then
        print('assert duplicate.')
        return;
    end

    if type(initValue) ~= "boolean" then
        print('assert initValue', initValue);
        return;
    end

    local ctrlset = parent:CreateControlSet("lib_toggle_button", ctrlName, horz, vert, left, top, right, bottom);
    AUTO_CAST(ctrlset);
    ctrlset:SetUserValue("UI_UPDATE_SCRIPT", updateScript);
    ctrlset:SetUserValue("UI_IS_TOGGLE", tostring(isToggle));
    local active_pic = GET_CHILD(ctrlset, "active_pic");
    UI_LIB_TOGGLE_BUTTON_UPDATE(ctrlset, active_pic);

    if width ~= nil and height ~= nil then
        ctrlset:Resize(width, height);
        active_pic:Resize(width, height);
    end
    return ctrlset;
end

function UI_LIB_TOGGLE_BUTTON_UPDATE(ctrlset, active_pic)
    local isToggle = ctrlset:GetUserValue("UI_IS_TOGGLE");
    isToggle = (isToggle == "false");
	
    ctrlset:SetUserValue("UI_IS_TOGGLE", tostring(isToggle));

    local toggleImg = nil;
    if isToggle then
        toggleImg = ctrlset:GetUserConfig("TOGGLE_ON")
    else
        toggleImg = ctrlset:GetUserConfig("TOGGLE_OFF")
    end

    active_pic:SetImage(toggleImg);

    local script = ctrlset:GetUserValue("UI_UPDATE_SCRIPT");
    local func = _G[script];
    if func ~= nil then
        func(ctrlset, isToggle);
    end
end

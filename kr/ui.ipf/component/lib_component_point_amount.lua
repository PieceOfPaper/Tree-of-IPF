if UI_COMPONENT_TEST_TABLE == nil then UI_COMPONENT_TEST_TABLE = {} end

---------------------------------------------------------------------------------------------------------------------------------
--test
function UI_COMPONENT_TEST_TABLE.lib_point_amount(testbox, x, y, name)
    if name == nil then
        name = "test_point_amount";
    end
    testbox:RemoveChild(name.."_1");
    testbox:RemoveChild(name.."_2");
    local opt1 = UI_LIB_POINT_AMOUNT_GET_OPTION("{@st66b}", false, "", "", nil, "DummyProp", "DummyValue");
    local opt2 = UI_LIB_POINT_AMOUNT_GET_OPTION("{@st66b}", true, nil, "", nil, "DummyProp", "DummyValue");
    UI_LIB_POINT_AMOUNT_CREATE(testbox, name.."_1", "aaa", 300, 40, ui.LEFT, ui.TOP, x, y, 0, 0, opt1)
    UI_LIB_POINT_AMOUNT_CREATE(testbox, name.."_2", "bbb", 300, 30, ui.LEFT, ui.TOP, x, y+100, 0, 0, opt2)
end

---------------------------------------------------------------------------------------------------------------------------------
function UI_LIB_POINT_AMOUNT_GET_OPTION(textStyle, useFullbg, refreshScript, addScript, amountScript, amountPropName, amountPropValue)
    local options = {}
    options["TextStyle"] = textStyle;
    options["UseFullbg"] = useFullbg;
    options["RefreshScript"] = refreshScript;
    options["AddScript"] = addScript;
    options["AmountScript"] = amountScript;
    options["AmountPropName"] = amountPropName;
    options["AmountPropValue"] = amountPropValue;
    return options;
end

--methods
--arg name, arg value, script
function UI_LIB_POINT_AMOUNT_CREATE(parent, ctrlName, nameText, width, height, horz, vert, left, top, right, bottom, options) -- refreshScript, addScript nil 일 경우 control 안씀.
    if GET_CHILD(parent, ctrlName) ~= nil then
        print('assert duplicate.')
        return;
    end
    
    if height == nil then
        height = ctrlset:GetHeight();
    end

    local ctrlset = parent:CreateControlSet("lib_point_amount", ctrlName, horz, vert, left, top, right, bottom);
    AUTO_CAST(ctrlset);
    local bg = GET_CHILD(ctrlset, "bg");
    local text_gb = GET_CHILD(ctrlset, "text_gb");
    local refresh_btn = GET_CHILD(ctrlset, "refresh_btn");
    local add_btn = GET_CHILD(ctrlset, "add_btn");
    local name_text = GET_CHILD_RECURSIVELY(ctrlset, "name_text");
    local value_text = GET_CHILD_RECURSIVELY(ctrlset, "value_text");

    name_text:SetTextByKey("value", nameText);
    value_text:SetTextByKey("value", "-");
    name_text:SetTextByKey("style", options["TextStyle"]);
    value_text:SetTextByKey("style", options["TextStyle"]);

    if width ~= nil then
        ctrlset:Resize(width, height)
    end

    if options["RefreshScript"] ~= nil then
        ctrlset:SetUserValue("UI_REFRESH_SCRIPT", options["RefreshScript"]);
    else
        refresh_btn:ShowWindow(0);
    end
    
    if options["AddScript"] ~= nil then
        ctrlset:SetUserValue("UI_ADD_SCRIPT", options["AddScript"]);
    else
        add_btn:ShowWindow(0);
    end
    
    if options["AmountScript"] ~= nil and options["AmountPropName"] ~= nil and options["AmountPropValue"] ~= nil then
        ctrlset:SetUserValue("UI_AMOUNT_SCRIPT", options["AmountScript"]);
        ctrlset:SetUserValue("UI_AMOUNT_PROP_NAME", options["AmountPropName"]);
        ctrlset:SetUserValue(options["AmountPropName"], options["AmountPropValue"]);
    end

    if height ~= nil then
        refresh_btn:Resize(height, height);
        add_btn:Resize(height, height);
        
        if options["RefreshScript"] ~= nil then
            local diff = height-add_btn:GetOriginalHeight();
            add_btn:SetOffset(add_btn:GetOriginalX()-diff, add_btn:GetOriginalY());
        end
    end

    local textwidth = 0;
    local textheight = text_gb:GetHeight()
    if height ~= nil then
        textheight = height;
    end

    if refresh_btn:IsVisible() == 1 then
        textwidth = refresh_btn:GetX();
    elseif add_btn:IsVisible() == 1 then
        textwidth = add_btn:GetX();
    else
        textwidth = ctrlset:GetWidth();
    end

    text_gb:Resize(textwidth, textheight);

    local bgheight = bg:GetHeight();
    if height ~= nil then
        bgheight = height;
    end
    if options["UseFullbg"] then
        bg:Resize(ctrlset:GetWidth(), bgheight);
    else
        bg:Resize(textwidth, bgheight);
    end
end

function UI_LIB_POINT_AMOUNT_REFRESH(parent, btn)
    local amountScriptName = parent:GetUserValue("UI_AMOUNT_SCRIPT");
    local amountPropName = parent:GetUserValue("UI_AMOUNT_PROP_NAME");
    local amountPropValue = parent:GetUserValue(amountPropName);
    local amountScript = _G[amountScriptName];

    local beforeAmount = nil;
    if amountScript ~= nil then
        beforeAmount = amountScript(parent, amountPropName, amountPropValue);
    end

    local refreshScriptName = parent:GetUserValue("UI_REFRESH_SCRIPT");
    local refreshScript = _G[refreshScriptName];

    if refreshScript ~= nil then
        refreshScript(parent, amountPropName, amountPropValue, beforeAmount);
    end
    
    if amountScript ~= nil then
        local afterAmount = amountScript(parent, amountPropName, amountPropValue);
        local value_text = GET_CHILD_RECURSIVELY(parent, "value_text");
        value_text:SetTextByKey("value", afterAmount);
    end
end

function UI_LIB_POINT_AMOUNT_ADD(parent, btn)
    local amountScriptName = parent:GetUserValue("UI_AMOUNT_SCRIPT");
    local amountPropName = parent:GetUserValue("UI_AMOUNT_PROP_NAME");
    local amountPropValue = parent:GetUserValue(amountPropName);
    local amountScript = _G[amountScriptName];

    local beforeAmount = nil;
    if amountScript ~= nil then
        beforeAmount = amountScript(parent, amountPropName, amountPropValue);
    end

    local addScriptName = parent:GetUserValue("UI_ADD_SCRIPT");
    local addScript = _G[addScriptName];
    if addScript ~= nil then
        addScript(parent);
    end
    
    if amountScript ~= nil then
        local afterAmount = amountScript(parent, amountPropName, amountPropValue);
        local value_text = GET_CHILD_RECURSIVELY(parent, "value_text");
        value_text:SetTextByKey("value", afterAmount);
    end
end

function UI_LIB_POINT_AMOUNT_UPDATE(parent, btn)
    local amountScriptName = parent:GetUserValue("UI_AMOUNT_SCRIPT");
    local amountPropName = parent:GetUserValue("UI_AMOUNT_PROP_NAME");
    local amountPropValue = parent:GetUserValue(amountPropName);
    local amountScript = _G[amountScriptName];
    
    if amountScript ~= nil then
        local afterAmount = amountScript(parent, amountPropName, amountPropValue);
        local value_text = GET_CHILD_RECURSIVELY(parent, "value_text");
        value_text:SetTextByKey("value", afterAmount);
    end
end
function CREATE_UPDOWNMAX_COMPONENT(parent, name, prop)
    local box = parent:CreateControl('groupbox', name, prop.x, prop.y, prop.width, prop.height);    
    box:SetSkinName('None');
    box:SetGravity(prop.gravity.horz, prop.gravity.vert);
    box:SetMargin(prop.margin[1], prop.margin[2], prop.margin[3], prop.margin[4]);

    local maxBtn = box:CreateControl('button', 'maxBtn', 0, 0, 60, prop.height);
    AUTO_CAST(maxBtn);
    maxBtn:SetGravity(ui.RIGHT, ui.CENTER_VERT);
    maxBtn:SetSkinName('test_white_h_btn');
    maxBtn:SetText('{@st66}{s16}'..ClMsg('Maximum'));    
    maxBtn:SetEventScript(ui.LBUTTONUP, 'UPDOWNMAX_MAXBTN_CLICK');
    if prop.maxBtnUpScp ~= nil then
        maxBtn:SetUserValue('CALLBACK_FUNCTION', prop.maxBtnUpScp);
    end

    local updownMarginY = 9;
    local upBtn = box:CreateControl('button', 'upBtn', 0, 0, 60, prop.height / 2);
    AUTO_CAST(upBtn);
    upBtn:SetGravity(ui.RIGHT, ui.CENTER_VERT);
    upBtn:SetMargin(0, -updownMarginY, 62, 0);
    upBtn:SetImage('test_up_w_btn');
    upBtn:SetEventScript(ui.LBUTTONUP, 'UPDOWNMAX_UPBTN_CLICK');
    if prop.upBtnUpScp ~= nil then
        upBtn:SetUserValue('CALLBACK_FUNCTION', prop.upBtnUpScp);
    end

    local downBtn = box:CreateControl('button', 'downBtn', 0, 0, 60, prop.height / 2);
    AUTO_CAST(downBtn);
    downBtn:SetGravity(ui.RIGHT, ui.CENTER_VERT);
    downBtn:SetMargin(0, updownMarginY, 62, 0);
    downBtn:SetImage('test_down_w_btn');    
    downBtn:SetEventScript(ui.LBUTTONUP, 'UPDOWNMAX_DOWNBTN_CLICK');
    if prop.downBtnUpScp ~= nil then
        downBtn:SetUserValue('CALLBACK_FUNCTION', prop.downBtnUpScp);
    end

    local edit = box:CreateControl('edit', 'edit', 0, 0, box:GetWidth() - downBtn:GetWidth() - maxBtn:GetWidth() - 3, prop.height);
    AUTO_CAST(edit);
    edit:SetGravity(ui.LEFT, ui.CENTER_VERT);
    edit:SetTextAlign('center', 'center');
    edit:SetSkinName('test_weight_skin');
    edit:SetFormat('%s%s');
    edit:AddParamInfo('style', '{@st41}{s18}');
    edit:AddParamInfo('number', '0');
    edit:SetTextByKey('number', 0);
    edit:SetFontName('white_18_ol');
    edit:SetNumberMode(1);

    local component = {
        ctrl = box,
        GetNumber = function(self)
            local edit = GET_CHILD(self.ctrl, 'edit');
            return tonumber(edit:GetTextByKey('number'));
        end,
        SetMinMax = function(self, min, max)            
            local edit = GET_CHILD(self.ctrl, 'edit');
            edit:SetMinNumber(min);
            edit:SetMaxNumber(max);
            edit:SetTextByKey('style', '{@st41}{s18}');
        end,
        GetMinMax = function(self)
            local edit = GET_CHILD(self.ctrl, 'edit');
            return edit:GetMinNumber(), edit:GetMaxNumber();
        end,
        SetStyle = function(self, style)
            local edit = GET_CHILD(self.ctrl, 'edit');
            edit:SetTextByKey('style', style);
        end,
        IsMax = function(self)
            local edit = GET_CHILD(self.ctrl, 'edit');
            if edit:GetMinNumber() >= edit:GetMaxNumber() then
                return false;
            end
            return self:GetNumber() >= edit:GetMaxNumber();
        end,
    };
    
    REGISTER_COMPONENT('UPDOWNMAX_'..name, component);
    return component;
end

function UPDOWNMAX_UPBTN_CLICK(parent, ctrl)
    local component = GET_COMPONENT('UPDOWNMAX_'..parent:GetName());
    local edit = GET_CHILD(parent, 'edit');
    local curNum = component:GetNumber();
    curNum = math.min(curNum + 1, edit:GetMaxNumber());
    edit:SetTextByKey('number', curNum);
    COMPONENT_CALLBACK_EVENT_SCRIPT(parent, ctrl, 'CALLBACK_FUNCTION');
end

function UPDOWNMAX_DOWNBTN_CLICK(parent, ctrl)
    local component = GET_COMPONENT('UPDOWNMAX_'..parent:GetName());
    local edit = GET_CHILD(parent, 'edit');
    local curNum = component:GetNumber();
    curNum = math.max(curNum - 1, edit:GetMinNumber());
    edit:SetTextByKey('number', curNum);
    COMPONENT_CALLBACK_EVENT_SCRIPT(parent, ctrl, 'CALLBACK_FUNCTION');
end

function UPDOWNMAX_MAXBTN_CLICK(parent, ctrl)
    local edit = GET_CHILD(parent, 'edit');
    edit:SetTextByKey('number', edit:GetMaxNumber());
    COMPONENT_CALLBACK_EVENT_SCRIPT(parent, ctrl, 'CALLBACK_FUNCTION');
end
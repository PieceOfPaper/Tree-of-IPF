function CREATE_TARGET_ITEM_SLOT_COMPONENT(parent, name, prop)
    local NAME_TEXT_HEIGHT = 30;
    local box = parent:CreateControl('groupbox', name, prop.x, prop.y, prop.width, prop.height + NAME_TEXT_HEIGHT);
    box:SetSkinName('None');
    box:SetGravity(prop.gravity.horz, prop.gravity.vert);
    box:SetMargin(prop.margin[1], prop.margin[2], prop.margin[3], prop.margin[4]);

    local slot = box:CreateControl('slot', 'slot', 0, 0, prop.width, prop.height);
    slot:SetSkinName('invenslot2');
    slot:SetEventScript(ui.DROP, 'ON_TARGET_ITEM_SLOT_COMPONENT_DROP');
    if prop.dropScp ~= nil then
        slot:SetUserValue('CALLBACK_FUNCTION_DROP', prop.dropScp);
    end
    if prop.dropCheckScp ~= nil then
        slot:SetUserValue('CALLBACK_FUNCTION_DROPCHECK', prop.dropCheckScp);
    end
    slot:SetEventScript(ui.RBUTTONUP, 'ON_TARGET_ITEM_SLOT_COMPONENT_RBTNUP');
    if prop.rBtnUpScp ~= nil then
        slot:SetUserValue('CALLBACK_FUNCTION_RBTNUP', prop.rBtnUpScp);
    end

    local slotBgPic = slot:CreateControl('picture', 'slotBgPic', 0, 0, prop.width - 20, prop.height - 20);
    AUTO_CAST(slotBgPic);
    slotBgPic:SetImage('socket_slot_bg');
    slotBgPic:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT); 
    slotBgPic:SetEnableStretch(1);
    slotBgPic:EnableHitTest(0);

    if prop.useNameText == true then        
        local nameText = box:CreateControl('richtext', 'nameText', 0, 0, prop.width, NAME_TEXT_HEIGHT);
        AUTO_CAST(nameText);
        nameText:SetFormat('%s%s');
        nameText:AddParamInfo('style', '{@st41}');
        nameText:AddParamInfo('name', 'ddddddd');
        nameText:SetTextByKey('style', '{@st41}');
        nameText:SetGravity(ui.CENTER_HORZ, ui.BOTTOM);
    end

    local component = {
        ctrl = box,
        isUseNameText = prop.useNameText;
        SetSlotItem = function(self, invItem)
            local slotBgPic = GET_CHILD_RECURSIVELY(self.ctrl, 'slotBgPic');
            slotBgPic:ShowWindow(0);

            local slot = GET_CHILD(self.ctrl, 'slot');
            local icon = slot:GetIcon();
            if icon == nil then
                icon = CreateIcon(slot);
            end

            SET_SLOT_ITEM_IMAGE(slot, invItem);

            if self.isUseNameText == true and invItem ~= nil then
                local itemObj = GetIES(invItem:GetObject());
                local nameText = GET_CHILD(self.ctrl, 'nameText');
                nameText:SetTextByKey('name', GET_FULL_NAME(itemObj));
            end
        end,
        IsEmpty = function(self)
            local slot = GET_CHILD(self.ctrl, 'slot');
            local icon = slot:GetIcon();
            if icon == nil then
                return true;
            end
            local iconinfo = icon:GetInfo();
            if iconinfo == nil or iconinfo.type == 0 then
                return true;
            end
            return false;
        end,
        GetItemInfo = function(self) -- return itemObj, invItem
            local slot = GET_CHILD(self.ctrl, 'slot');
            local icon = slot:GetIcon();
            if icon == nil then
                return nil, nil;
            end
            local iconinfo = icon:GetInfo();
            if iconinfo == nil then
                return nil, nil;
            end
            local invItem = session.GetInvItemByGuid(iconinfo:GetIESID());
            if invItem == nil then
                return nil, nil;
            end
            return invItem, GetIES(invItem:GetObject());
        end,
        Clear = function(self)
            local slot = GET_CHILD(self.ctrl, 'slot');
            local slotBgPic = GET_CHILD(slot, 'slotBgPic');
            slot:ClearIcon();
            slotBgPic:ShowWindow(1);

            if self.isUseNameText == true then
                local nameText = GET_CHILD(self.ctrl, 'nameText');
                nameText:SetTextByKey('name', '');
            end
        end,
        ShowWindow = function(self, isShow)
            self.ctrl:ShowWindow(isShow);
        end,
    };
    REGISTER_COMPONENT('TARGET_ITEM_SLOT_'..name, component);
    return component;
end

function ON_TARGET_ITEM_SLOT_COMPONENT_RBTNUP(parent, slot)    
    local component = GET_COMPONENT('TARGET_ITEM_SLOT_'..parent:GetName());
    component:Clear();

    COMPONENT_CALLBACK_EVENT_SCRIPT(parent, slot, 'CALLBACK_FUNCTION_RBTNUP');
end

function ON_TARGET_ITEM_SLOT_COMPONENT_DROP(parent, ctrl)
    local frame = parent:GetTopParentFrame();
	local liftIcon = ui.GetLiftIcon();
	local iconInfo = liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());	
	if nil == invItem then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
    local dropCheckScpName = ctrl:GetUserValue('CALLBACK_FUNCTION_DROPCHECK');
    local DropCheckScp = _G[dropCheckScpName];
    if DropCheckScp ~= nil and DropCheckScp(parent, ctrl, itemObj) == false then
        return;
    end

    local component = GET_COMPONENT('TARGET_ITEM_SLOT_'..parent:GetName());
    component:SetSlotItem(invItem);
    
    COMPONENT_CALLBACK_EVENT_SCRIPT(parent, ctrl, 'CALLBACK_FUNCTION_DROP');
end
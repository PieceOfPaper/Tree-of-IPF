function SELECTCOMPANIONINFO_ON_INIT(addon, frame)
	

end

function SELCOMPANIONINFO_ON_SELECT_CHAR(guid)

	local pet = barrack.GetPet(guid);
	if pet ~= nil then
		UPDATE_BARRACK_COMPANION_INFO(pet);		
	end

end

function ON_CLOSE_BARRACK_SELECT_MONSTER()
	local companionInfoFrame = ui.GetFrame('selectcompanioninfo')
	if companionInfoFrame ~= nil then
		companionInfoFrame:ShowWindow(0);
	end
end

function UPDATE_BARRACK_COMPANION_INFO(actor)

	local frame = ui.GetFrame("selectcompanioninfo");
	frame:ShowWindow(1);

	local brkSystem = GetBarrackSystem(actor);
	local petInfo = brkSystem:GetPetInfo();
	frame:SetUserValue("PET_GUID", petInfo:GetStrGuid());

	local name = frame:GetChild("name");
	name:SetTextByKey("value", actor:GetName());
	local petCls = GetClassByType("Monster", actor:GetType());
	local pettype = frame:GetChild("pettype");
	pettype:SetTextByKey("value", petCls.Name);

	local pic = GET_CHILD(frame, "pic", "ui::CPicture");
	pic:SetImage(petCls.Icon);
	
	local obj = GetIES(petInfo:GetObject());
	local gotopc = frame:GetChild("gotopc");
	if obj.OverDate >= 10 then
		gotopc:SetEnable(0);
		gotopc:SetTextByKey("value", ScpArgMsg("Death"));	
	else
		gotopc:SetEnable(1);
		gotopc:SetTextByKey("value", ScpArgMsg("GoTogether"));
	end
	
end

function SEL_COMPANION_WITH_PC(parent, ctrl)
	ui.SysMsg(ClMsg("SelectPCToBringTheCompanion"));

	parent:ShowWindow(0);
	barrack.SetLBtnDownScript("COMPANION_SELECT_PC");
	
end

function COMPANION_SELECT_PC(selActor)	
	local frame = ui.GetFrame("selectcompanioninfo");
	local petGuid = frame:GetUserValue("PET_GUID");
	local pet = barrack.GetPet(petGuid);
	local brkSystem = GetBarrackSystem(pet);

	if selActor == nil then
		frame:ShowWindow(1);
		brkSystem:SetPetPC(nil);
		return;
	end	

	selActor = tolua.cast(selActor, "CFSMActor");
	brkSystem:SetPetPC(selActor);
	frame:ShowWindow(0);
end

function SEL_COMPANION_MOVE_BARRACK_LAYER(parent, ctrl)
    local titleText = ScpArgMsg("InputCount");    
	local charName = barrack.GetSelectedCharacterName();
	local frame = ui.GetFrame("barrack_charlist")
	if frame == nil then
		return
	end

    INPUT_DROPLIST_BOX(frame, "SELECT_CHARINFO_CHANGE_TARGET_LAYER_COMPANION", charName, "", 1, 3) 
end

function EXEC_MOVE_LAYER_COMPANION(frame, ret, inputframe)
    inputframe:ShowWindow(0);
    ret = tonumber(ret)    
    if ret < 1 or ret > 3 then 
        return
    end
    
    local frame = ui.GetFrame("selectcompanioninfo");
	local petGuid = frame:GetUserValue("PET_GUID");
	barrack.ChangeBarrackTargetLayer(petGuid, tonumber(ret))
	--parent:ShowWindow(0);
	ui.SysMsg(ClMsg("MoveBarrackLayer"));
end
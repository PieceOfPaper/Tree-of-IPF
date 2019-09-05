function SCR_CLIENT_Premium_Change_Guild_Emblem(invItem)
    session.party.DeleteGuildEmblem()
 end

 function ABILITY_POINT_RESET_C(invItem)
 	if invItem.isLockState == true then
 		ui.SysMsg(ClMsg('MaterialItemIsLock'));
 		return;
 	end

 	local itemObj = GetIES(invItem:GetObject());
 	if itemObj.ItemLifeTimeOver > 0 then
 		ui.SysMsg(ClMsg('LessThanItemLifeTime'));
		return;
 	end 	

 	local yesscp = string.format('_ABILITY_POINT_RESET_C("%s")', invItem:GetIESID());
 	ui.MsgBox(ClMsg('ReallyUseAbilityPointResetItem'), yesscp, 'None');
 end

 function _ABILITY_POINT_RESET_C(itemGuid) 	
 	pc.ReqExecuteTx_Item("ABILITY_POINT_RESET", itemGuid, '0');
 end

-- 아츠 특성 초기화
function ABILITY_POINT_RESET_ARTS_C(invItem)
	if invItem.isLockState == true then
		ui.SysMsg(ClMsg('MaterialItemIsLock'));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	if itemObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ClMsg('LessThanItemLifeTime'));
		return;
	end 	

	local yesscp = string.format('_ABILITY_POINT_RESET_ARTS_C("%s")', invItem:GetIESID());
	ui.MsgBox(ClMsg('ReallyUseAbilityPointResetItem_arts'), yesscp, 'None');
end

function _ABILITY_POINT_RESET_ARTS_C(itemGuid)
	pc.ReqExecuteTx_Item("ABILITY_POINT_RESET_ARTS", itemGuid, '0');
end
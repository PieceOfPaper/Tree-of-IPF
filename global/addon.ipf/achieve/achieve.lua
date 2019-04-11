
function ACHIEVE_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg('ACHIEVE_POINT_LIST', 'UPDATE_ACHIEVE_LIST');
	addon:RegisterOpenOnlyMsg('ACHIEVE_POINT', 'UPDATE_ACHIEVE_LIST');	
	addon:RegisterMsg('ACHIEVE_NEW', 'GET_NEW_ACHIEVE');
	addon:RegisterMsg('ACHIEVE_RANK', 'GET_RANK_ACHIEVE');	

end

function GET_NEW_ACHIEVE(frame, msg, argStr, classID)

	local achiName = geAchieveTable.GetDescTitle(classID);	
	local msg = ScpArgMsg("Auto_[{Auto_1}]_eopJeogeul_HoegDeugHayeossSeupNiDa.", "Auto_1", achiName);
	ui.AddText("SystemMsgFrame",  msg);
end

function GET_RANK_ACHIEVE(frame, msg, argStr, classID)
	local achiName = geAchieveTable.GetName(classID);	
	local msg = ScpArgMsg("{Auto_1}CanEquipRankAchieve", "Auto_1", achiName);
	ui.AddText("SystemMsgFrame",  msg);
end


function UPDATE_ACHIEVE_ADVBOX(frame)

	for i = 0, 1 do 

		local advbox = frame:GetChild( "AdvBox_" .. i );
				
		tolua.cast(advbox, "ui::CAdvListBox");
		advbox:ClearItems();
	
 		advbox:SetStartRow(1);	
 		advbox:SetHeadItem("ICON", 0, "", "white_16_ol");
 		advbox:SetRowBgColor(0, "#4a443f");
 		advbox:SetColWidth(0, 290);
 		advbox:SetRowHeight(0, 40); 		
	
	end
end


function UPDATE_ACHIEVE_LIST(frame)

	for i = 0, 1 do 

		local advbox = frame:GetChild( "AdvBox_" .. i );
				
		tolua.cast(advbox, "ui::CAdvListBox");
		advbox:ClearUserItems();
		
	end

	local list = session.GetAchieveList();
	local cnt = list:Count();
	
	local index = 0;
	for i = 0 , cnt - 1 do
		local type = list:Element(i);
		
		local achiProp = geAchieveTable.GetProp(type);
		SET_ACHIEVE_TO_ADV_BOX(frame, achiProp, index);
		index = index + 1;
	end

end

function SET_ACHIEVE_TO_ADV_BOX(frame, achiProp, index)

	local ADV_BOX_ROW = 9;
	local ADV_BOX_COL = 2;

	local advBoxIndex = math.floor(index / ADV_BOX_ROW);
	local advbox = frame:GetChild( "AdvBox_" .. advBoxIndex );
	tolua.cast(advbox, "ui::CAdvListBox");
	
	
	local item = advbox:SetItem(achiProp.ClassID, 0, achiProp:GetName(), "white_16_ol");
	item:EnableHitTest(1);
	item:SetTooltipType('texthelp');
	item:SetTooltipArg(achiProp:GetDesc());
	

end



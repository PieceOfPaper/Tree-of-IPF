

layerscore_width = 0;
layerscore_height = 0;
function LAYERSCORE_ON_INIT(addon, frame)

	--[[addon:RegisterMsg('LAYER_PC_LIST_UPDATE', 'ON_LAYER_PC_LIST_UPDATE');
 	addon:RegisterMsg('LAYER_PC_PROP_UPDATE', 'ON_LAYER_PC_PROP_UPDATE');
 	addon:RegisterMsg('LAYER_TIME', 'ON_LAYER_TIME');
	]]
end

function LAYERSCORE_CREATE(addon, frame) 	

	layerscore_width = frame:GetWidth();
	layerscore_height = frame:GetHeight();
	
	
	LAYERSCORE_ADVBOX_INIT(frame);

end

function GetLayerSObjName()

	local type = session.GetLayerSObjType();
	local cls = GetClassByType("SessionObject", type);
	return cls.ClassName;

end

function ON_TAB_KEY_DOWN(frame)
	TOGGLE_LAYER_SCORE(frame);
end

function ON_TAB_KEY_UP(frame)
	TOGGLE_LAYER_SCORE(frame);
end

function TOGGLE_LAYER_SCORE(frame)

	if frame:GetValue() == 0 then
		frame:Resize(layerscore_width, 40);
		frame:SetValue(1);
	else
		frame:Resize(layerscore_width, layerscore_height);
		frame:SetValue(0);
	end

end

function LAYERSCORE_ADVBOX_INIT(frame)

	local sObjName = 1;
	local advbox = frame:GetChild( "AdvBox" );
	tolua.cast(advbox, "ui::CAdvListBox");

--[[
	advbox:SetStartRow(1);	
	advbox:SetHeadItem("NAME", 0, ScpArgMsg("Name"), "white_16_ol");
	advbox:SetHeadItem("PCKILL", 1, ScpArgMsg("Auto_Kil"), "white_16_ol"); 		
	advbox:SetHeadItem("DAMAGE", 2, ScpArgMsg("Auto_oBeoKil"), "white_16_ol");
	advbox:SetHeadItem("MONSTER", 3, ScpArgMsg("Auto_PiKyeog"), "white_16_ol");
	advbox:SetHeadItem("DEAD", 4, ScpArgMsg("Auto_SaMang"), "white_16_ol");
	advbox:SetRowBgColor(0, "#4a443f");
 	advbox:SetColWidth(0, 120);
 	advbox:SetColWidth(1, 50);
 	advbox:SetColWidth(2, 50);
 	advbox:SetColWidth(3, 50);
 	advbox:SetColWidth(4, 50);
 	advbox:SetRowHeight(0, 20);
 	--]]
 		
end

function ON_LAYER_PC_LIST_UPDATE(frame)

	ON_LAYER_PC_PROP_UPDATE(frame);

end

function ON_LAYER_PC_PROP_UPDATE(frame)

		local advbox = frame:GetChild( "AdvBox" );
				
		tolua.cast(advbox, "ui::CAdvListBox");
		advbox:ClearUserItems();
	
		local pclist = session.GetLayerPCList();	
		
		local cnt = pclist:Count();
		for j = 0 , cnt - 1 do 
			local pcinfo = pclist:Element(j);
			local name = pcinfo.name;
			local obj = GetIES(pcinfo:GetIESObject());
			SET_ADVBOX_ITEM_C(advbox, name, 0, name, "white_16_ol");
			SET_ADVBOX_ITEM_C(advbox, name, 1, obj.Step1, "white_16_ol");
			SET_ADVBOX_ITEM_C(advbox, name, 2, obj.Step2, "white_16_ol");
			SET_ADVBOX_ITEM_C(advbox, name, 3, obj.Step3, "white_16_ol");
			SET_ADVBOX_ITEM_C(advbox, name, 4, obj.Step4, "white_16_ol");
		end

end

function ON_LAYER_TIME(frame)

	LAYER_SCORE_SET_TIMER_UPDATE(frame);
	
end


function UPDATE_LAYER_TIME(frame)
	local m1time = frame:GetChild('m1time');
	local m2time = frame:GetChild('m2time');
	local s1time = frame:GetChild('s1time');
	local s2time = frame:GetChild('s2time');

	tolua.cast(m1time, "ui::CPicture");
	tolua.cast(m2time, "ui::CPicture");
	tolua.cast(s1time, "ui::CPicture");
	tolua.cast(s2time, "ui::CPicture");	
	
	local remainTime = session.GetLayerRemainTime();
	local min, sec = GET_QUEST_MIN_SEC(remainTime);
	
	SET_QUESTINFO_TIME_TO_PIC(min, sec, m1time, m2time, s1time, s2time);			
	frame:Invalidate();
end

function LAYER_SCORE_OPEN(frame)
	ON_LAYER_PC_PROP_UPDATE(frame);	
	frame:SetValue(0);
	
	ui.CloseFrame('questinfoset_2');
	ui.ShowWindowByPIPType(frame:GetName(), ui.PT_RIGHT, 1);
end

function LAYER_SCORE_CLOSE(frame)
	ui.OpenFrame('questinfoset_2');	
end

function MINIMIZE_LAYERSCORE()

	local frame = ui.GetFrame("layerscore");
	frame:Resize(layerscore_width, 40);
	frame:SetValue(1);

end

function LAYER_SCORE_SET_TIMER_UPDATE(frame)

	local timer = frame:GetChild("addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_LAYER_TIME");
	timer:Start(0.3);
	UPDATE_LAYER_TIME(frame);

end


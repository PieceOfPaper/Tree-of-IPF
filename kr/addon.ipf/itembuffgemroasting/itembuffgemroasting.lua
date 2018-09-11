--itembuffgemroasting.lua

function ITEMBUFFGEMROASTING_ON_INIT(addon, frame)
end

function ITEMBUFFGEMROASTING_UI_COMMON(groupName, sellType, handle)

	local frame = ui.GetFrame("itembuffgemroasting");
	GEMROASTING_UI_RESET(frame);
	frame:ShowWindow(1);
	frame:SetUserValue("GroupName", groupName);
	GEMROASTING_VIEW(frame);

	local tabCtrl = frame:GetChild('statusTab');
	ITEMBUFF_SHOW_TAB(tabCtrl, handle);

	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	local sklName = GetClassByType("Skill", groupInfo.classID).ClassName;
	frame:SetUserValue("SKILLNAME", sklName)
	frame:SetUserValue("SKILLLEVEL", groupInfo.level);
	frame:SetUserValue("HANDLE", handle);
	
	GEMROASTING_UPDATE_MATERIAL(frame);

	local bodyBox = frame:GetChild("roasting");
	local money = bodyBox:GetChild("reqitemMoney");

	if session.GetMyHandle() == handle then
		money:SetTextByKey("txt", groupInfo.price);
	else
		frame:SetUserValue("PRICE",groupInfo.price);
		money:SetTextByKey("txt", "");
	end
	ui.OpenFrame("inventory");
end

function GEMROASTING_TAP_CHANGE(frame)
	local tabObj		    = frame:GetChild('statusTab');
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	if nil ~= itembox_tab then
		local curtabIndex	    = itembox_tab:GetSelectItemIndex();
		if curtabIndex == 0 then
			GEMROASTING_VIEW(frame);
		elseif curtabIndex == 1 then
			GEMROASTING_LOG_VIEW(frame);
		end
	end
end
function GEMROASTING_VIEW(frame)
	local gboxctrl = frame:GetChild("roasting");
	gboxctrl:ShowWindow(1);
	local gboxctrl = frame:GetChild("log");
	gboxctrl:ShowWindow(0);
end

function GEMROASTING_LOG_VIEW(frame)
	local gboxctrl = frame:GetChild("roasting");
	gboxctrl:ShowWindow(0);
	local gboxctrl = frame:GetChild("log");
	gboxctrl:ShowWindow(1);
end

function GEMROASTING_SLOT_POP(parent, ctrl)
	GEMROASTING_UI_RESET(parent);
	
	local frame = parent:GetTopParentFrame();
	GEMROASTING_UPDATE_MATERIAL(frame);

end

function GEMROASTING_SLOT_DROP(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	local liftIcon 			= ui.GetLiftIcon();
	local slot 			    = tolua.cast(ctrl, 'ui::CSlot');
	local iconInfo			= liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());	
	if nil == invItem then
		return;
	end

	if nil == session.GetInvItemByType(invItem.type) then
		ui.SysMsg(ClMsg("CannotDropItem"));
		return;
	end

	if iconInfo == nil or invItem == nil or slot == nil then
		return;
	end

	local pc = GetMyPCObject();
	local obj = GetIES(invItem:GetObject());

	if obj.GemRoastingLv >= frame:GetUserIValue("SKILLLEVEL") then
		ui.SysMsg(ClMsg("CannontDropGam"));
		return;
	end

	local checkItem = _G["ITEMBUFF_CHECK_" .. frame:GetUserValue("SKILLNAME")];
	if 1 ~= checkItem(pc, obj) then
		ui.SysMsg(ClMsg("WrongDropItem"));
		return;
	end
	
	local checkFunc = _G["ITEMBUFF_NEEDITEM_" .. frame:GetUserValue("SKILLNAME")];
	local name, cnt = checkFunc(pc, obj);

	SET_SLOT_ITEM_IMAGE(slot, invItem);
	slot:SetUserValue("GEM_IESID", iconInfo:GetIESID());
	local roastingbox = frame:GetChild("roasting");
	local slotNametext = roastingbox:GetChild("slotName");
	slotNametext:SetTextByKey("txt", obj.Name);

	local effectBox = GET_CHILD(roastingbox, "effectGbox",'ui::CGroupBox')
	effectBox:RemoveChild('tooltip_gem_property');

	local yPos = 100;
	local CSet = effectBox:CreateOrGetControlSet('tooltip_gem_property', 'tooltip_gem_property', 0, yPos);
	local property_gbox= GET_CHILD(CSet,'gem_property_gbox','ui::CGroupBox')

	local inner_yPos = 0;
	local innerCSet = nil
	local innerpropcount = 0
	local innerpropypos = 0

	local lv = GET_ITEM_LEVEL_EXP(obj, obj.ItemExp) - frame:GetUserIValue("SKILLLEVEL");	

	if lv < 1 then
		lv = 0;
	end
	
	local gemProp = geItemTable.GetProp(obj.ClassID);
	local socketPenaltyProp = gemProp:GetSocketPropertyByLevel(lv);
	local propIndex = 0;
	local propNameList = GET_ITEM_PROP_NAME_LIST(obj)
	for i = 1 , #propNameList do

		local title = propNameList[i]["Title"];
		local propName = propNameList[i]["PropName"];
		local propValue = propNameList[i]["PropValue"];
		local useOperator = propNameList[i]["UseOperator"];
		if title ~= nil then
			innerCSet = property_gbox:CreateOrGetControlSet('tooltip_each_gem_property', title, 0, inner_yPos); 
			local type_text = GET_CHILD(innerCSet,'type_text','ui::CRichText')
			type_text:SetText( ScpArgMsg(title) )
			local type_icon = GET_CHILD(innerCSet,'type_icon','ui::CPicture')
			tolua.cast(CSet, "ui::CControlSet");
			local imgname = GET_ICONNAME_BY_WHENEQUIPSTR(CSet,title)
			type_icon:SetImage( imgname )
			innerpropcount = 0
			innerpropypos = type_text:GetHeight()+type_text:GetY()

			innerCSet:GetChild("labelline"):ShowWindow(0);
			
		else
			local type_text = GET_CHILD(innerCSet,'type_text','ui::CRichText')
			innerInnerCSet = innerCSet:CreateOrGetControlSet('tooltip_each_gem_property_each_text', 'proptext'..innerpropcount, 0, innerpropypos);
			
			local realtext = nil
			local penaltyText = nil;
			if useOperator ~= nil and propValue > 0 then
				realtext = ScpArgMsg(propName) .. " : " .."{img green_up_arrow 16 16}".. propValue;
				
			else
				local propPenaltyAdd = socketPenaltyProp:GetPropPenaltyAddByIndex(propIndex, 0);
				if nil == propPenaltyAdd then
					ui.SysMsg(ClMsg("WrongDropItem"));
					GEMROASTING_UI_RESET(frame);
					return;
				end
				propIndex = propIndex + 1;
				realtext = ScpArgMsg(propName) .. " : " .."{img red_down_arrow 16 16}".. propValue;
				penaltyText = string.format("   {img alch_gemlos_arrow %d %d}   ", 80, 18) .. --[[ScpArgMsg(propPenaltyAdd:GetPropName()) ..]] ScpArgMsg('PropDown') .. propPenaltyAdd.value ;
			end
			
			local proptext = GET_CHILD(innerInnerCSet,'prop_text','ui::CRichText')
			proptext:SetText( realtext );
			local propPenaltyText = GET_CHILD(innerInnerCSet,'prop_text2','ui::CRichText')
			propPenaltyText:SetText( penaltyText );
			propPenaltyText:SetMargin(210, 0, 0, 0);
			innerpropcount = innerpropcount + 1;
			
			tolua.cast(innerCSet, "ui::CControlSet");
			innerpropypos = innerInnerCSet:GetY() + innerInnerCSet:GetHeight();
			innerCSet:Resize(innerCSet:GetOriginalWidth(), innerInnerCSet:GetY() + innerInnerCSet:GetHeight() + 10 )
			inner_yPos = innerCSet:GetY() + innerCSet:GetHeight();
		end
	end

	property_gbox:Resize(property_gbox:GetOriginalWidth(), inner_yPos);
	CSet:Resize(CSet:GetWidth(), CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + 10);

	GEMROASTING_UPDATE_MATERIAL(frame, cnt, iconInfo:GetIESID());
	GEMROASTING_VIEW(frame);

	if frame:GetUserIValue("HANDLE") ~=  session.GetMyHandle() then
		local money = roastingbox:GetChild("reqitemMoney");
		money:SetTextByKey("txt", cnt*frame:GetUserIValue("PRICE"));
	end
end

function GEMROASTING_UI_RESET(frame)

	frame = frame:GetTopParentFrame();
	local roastingbox = frame:GetChild("roasting");
	local effectBox = GET_CHILD(roastingbox, "effectGbox",'ui::CGroupBox')
	effectBox:RemoveChild('tooltip_gem_property');

	local slot = GET_CHILD(roastingbox, "slot", "ui::CSlot");
	slot:ClearIcon();
	text = roastingbox:GetChild("slotName");
	text:SetTextByKey("txt", '');

	slot:SetUserValue("GEM_IESID", "");
end


function GEMROASTING_UPDATE_MATERIAL(frame, cnt, guid)
	local roastingbox = frame:GetChild("roasting");
	local reqitembox = roastingbox:GetChild("materialGbox");
	local reqitemtext = reqitembox:GetChild("reqitemCount");
	local reqitemName = reqitembox:GetChild("reqitemNameStr");
	local reqitemIamge= reqitembox:GetChild("reqitemImage");
	local reqitemNeed= reqitembox:GetChild("reqitemNeedCount");

	local invItemList = session.GetInvItemList();
	local checkFunc = _G["ITEMBUFF_STONECOUNT_" .. frame:GetUserValue("SKILLNAME")];
	local name, cnt2 = checkFunc(invItemList, frame);
	local cls = GetClass("Item", name);
	reqitemIamge:SetTextByKey("txt", GET_ITEM_IMG_BY_CLS(cls, 50));
	local txt = cls.Name;
	reqitemName:SetTextByKey("txt", txt);
	local text = cnt2 .. " " .. ClMsg("CountOfThings");
	reqitemtext:SetTextByKey("txt", text);
	
	if nil ~= cnt then
		reqitemNeed:SetTextByKey("txt", cnt  ..ClMsg("CountOfThings"));
	else
		reqitemNeed:SetTextByKey("txt", "");
	end
	if nil ~= guid then
		reqitemIamge:SetTextByKey("guid", guid);
	else
		reqitemIamge:SetTextByKey("guid", "");
	end
end

function GEMROASTING_SUCCEED()
	local frame = ui.GetFrame("itembuffgemroasting");
	GEMROASTING_UI_RESET(frame);
	GEMROASTING_UPDATE_MATERIAL(frame);
end

function GEMROASTING_TARGET_UI_CENCEL()
	ui.CloseFrame("itembuffgemroasting");
end

function GEMROASTING_EXCUTE(parent)
	
	session.ResetItemList();

	local frame = parent:GetTopParentFrame();
	local targetbox = frame:GetChild("roasting");
	local slot = GET_CHILD(targetbox, "slot", "ui::CSlot");
	local itemIESID = slot:GetUserValue("GEM_IESID");
	if itemIESID == "0" or itemIESID == "" then
		ui.MsgBox(ScpArgMsg("DropItemPlz"))
		return;
	end

	session.AddItemID(itemIESID);
	local handle = frame:GetUserValue("HANDLE");
	local skillName = frame:GetUserValue("SKILLNAME");

	session.autoSeller.BuyItems(handle, AUTO_SELL_GEM_ROASTING, session.GetItemIDList(), skillName);
end

function GEMROASTING_CENCEL_CHECK(frame)
	frame = frame:GetTopParentFrame();
	local handle = frame:GetUserIValue("HANDLE");
	session.autoSeller.BuyerClose(AUTO_SELL_GEM_ROASTING, handle);
end

function GEMROASTING_UPDATE_HISTORY(frame)
	local groupName = frame:GetUserValue("GroupName");	
	local cnt = session.autoSeller.GetHistoryCount(groupName);

	local gboxctrl = frame:GetChild("log");
	local log_gbox = gboxctrl:GetChild("log_gbox");
	log_gbox:RemoveAllChild();

	for i = cnt -1 , 0, -1 do
		local info = session.autoSeller.GetHistoryByIndex(groupName, i);
		local ctrlSet = log_gbox:CreateControlSet("alchemist_roasting_history", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local sList = StringSplit(info:GetHistoryStr(), "#");

		local txt = ctrlSet:GetChild("txt");
		txt:SetTextByKey("text", sList[1]);
		local itemClsID = sList[2];
		local itemCls = GetClassByType("Item", itemClsID);

		local propNameValue = sList[3];
		local propToken = StringSplit(propNameValue, "@");
		if nil ~= itemCls then
			local strBuf = string.format("%s(%d -> %d)", itemCls.Name , propToken[2], propToken[3]);
			txt:SetTextByKey("value", strBuf);
		end
	end

	GBOX_AUTO_ALIGN(log_gbox, 20, 3, 10, true, false);
end
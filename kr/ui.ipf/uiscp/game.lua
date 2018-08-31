---- - game.lua --

---------------- DEFINED GLOBAL VARIABLES ------------------------------

COLOR_LEADER_NAME = '{#EE2222}'
COLOR_MY_NAME = '{#22EE22}'
COLOR_GRAY = '{#AAAAAA}'
COLOR_WHITE_GRAY = '{#333333}'
COLOR_GREEN = '{#00FF00}'
COLOR_RED = '{#FF0000}'
COLOR_JU = '{#FF8000}'
COLOR_BROWN = '{#804040}'
COLOR_YELLOW = '{#FFFF00}'
COLOR_BY = '{#FF8000}';

KEY_SHIFT	= 16;
KEY_CTRL	= 17;
KEY_ALT		= 18;
TEMP_ITEM_IMAGE = "icon_item_Sword_1";
----------------------------------------------------------------------

function GET_MONEY_IMG(size)
	return string.format("{img icon_item_silver %d %d}", size, size);
end

function GET_ITEM_IMG(itemType, size)
	local cls = GetClassByType("Item", itemType);
	return string.format("{img %s %d %d}", cls.Icon, size, size);
end

function GET_ITEM_IMG_BY_CLS(cls, size)
	return string.format("{img %s %d %d}", cls.Icon, size, size);
end

function GET_MON_CAPTION(class, level, name, uniquename)

	--[[
	if uniquename ~= "None" then
		return SofS(class.Name, uniquename);
	end
	]]

	if name ~= 'None' then
		return name;
	end

	return class.Name;

end

function CREATE_ITEM_TEMP()

	local clslist, cnt  = GetClassList("Item");
	--[[
	local lowweightcnt = 0
	for i = 0 , cnt do
		local cls = GetClassByIndexFromList(clslist, i);
		if cls ~= nil and IS_NO_EQUIPITEM(cls) == 0 and cls.Weight < 10 then
			lowweightcnt = lowweightcnt + 1
		end
		
	end
	]]
	--print(lowweightcnt)
--[[	
	for i = 0, 500 do
		ui.Chat("//item 221481")
	end]]
	
	for i = 0 , 2000 do
		local cls = GetClassByIndexFromList(clslist, i);

		if IS_NO_EQUIPITEM(cls) == 0 and cls.Weight < 2 then
			local key = cls.ClassID;
			ui.Chat("//item ".. key)
		end
		
	end
	
end


function GET_LEVEL_COLOR(my, target)
	if target > my + 30 then
		return COLOR_RED;
	elseif target > my + 15 then
		return COLOR_JU;
	elseif target > my + 5 then
		return COLOR_BROWN;
	end

	return COLOR_YELLOW;
end


function UI_LOAD_SERVER_LIST(frame, control, arg1, arg2)

	LoadServerList();
	UpdateData("login");
 end

function UI_EXIP_APP(frame, control, arg1, arg2)

	ExitApp();
 end

function UI_NEW_ACCOUNT(frame, control, arg1, arg2)

	NewAccount();
 end

function UI_CHEAT(frame, control, arg1, arg2)

	local uiframe = Getframe(frame);
	local cheatIndex = GetNumber(uiframe, "select cheat");
	Cheat(cheatIndex);
 end
 

function CONS()
	assert(1 == 0);
end

function MAX(a , b)
	if a > b then
		return a;
	end

	return b;
end

function MIN(a , b)
	if a < b then
		return a;
	end

	return b;
end

function TEST_MAPMAKE()

	local frame = OPENNEW("mapmake");
	frame:ShowWindow(1);
	UPDATE_MAP_MAKE_TOOL(frame);

end


	
function TEST_AYASE2(x,y)


end

	

function MAKE_NPC_LIST_TO_HTML()
					
	local file = io.open("mon_image_list.html","w+")
	local retstring = "<table>\n"

	local clsList, cnt  = GetClassList("Map");

	for i = 0 , cnt - 1 do

		local mapcls = GetClassByIndexFromList(clsList, i);
		local gentypeclsname = "GenType_"..mapcls.ClassName

		local GenclsList, Gencnt  = GetClassList(gentypeclsname);
		
		for j = 0 , Gencnt - 1 do
			local gentypecls = GetClassByIndexFromList(GenclsList, j);


			if gentypecls.Name ~= "UnvisibleName" and gentypecls.Name ~= "None" then
				retstring = retstring .. "<tr>\n"
				retstring = retstring .. "<td>" .. mapcls.Name .. "</td>\n"
				retstring = retstring .. "<td>" .. gentypecls.Name .. "</td>\n"
				retstring = retstring .. "<td><img src=\"images/" .. gentypecls.ClassType .. ".jpg\"></td>\n"
				retstring = retstring .. "</tr>\n"
			end

		end
		
		
	end



	retstring = retstring .. "</table>"

	file:write(retstring)
	file:close()


end

function MAKE_ALL_DEFAULT_HAIR()

	local Rootclasslist = imcIES.GetClassList('HairType');

	for gender = 1 , 2 do

		local Selectclass   = Rootclasslist:GetClass(gender);
		local Selectclasslist = Selectclass:GetSubClassList();

		for i = 1, Selectclasslist:Count() do

			local name = ui.CaptureModelHeadImageByHairtype(gender,i)
			
		end

	end

	
end

	
function TEST_AYASE()
    print("friend ui test");    
    session.friends.TestAddManyFriend(FRIEND_LIST_COMPLETE, 200);
    session.friends.TestAddManyFriend(FRIEND_LIST_BLOCKED, 100);
end

function JOB_COMMAND()
		TEST_PARTY();
end

function TEST_DIALOG_CALLBACK(frame, ack)

	print(ack);

end

function TEST_PARTY()

	ui.ToggleFrame("spray");
	
end

function CLOSE_BOSS_UI()

	local frame = ui.GetFrame("targetinfotoboss");
	ui.CloseFrame(frame);
end

function TEST_TOS()
	local w = option.GetClientWidth() + 500;
	local h = option.GetClientHeight() + 500;
	local f = ui.GetFrame("quickslotnexpbar");
	f:MoveFrame(w, h);
	f = ui.GetFrame("fps");
	f:MoveFrame(w, h);
	f = ui.GetFrame("playtime");
	f:MoveFrame(w, h);
	f = ui.GetFrame("questinfoset_2");
	f:MoveFrame(w, h);
	f = ui.GetFrame("minimap");
	f:MoveFrame(w, h);

	f = ui.GetFrame("chatwiki");
	f:MoveFrame(w, h);

	f = ui.GetFrame("chat");
	f:MoveFrame(w, h);

end

function TEST_FOCUS()
	local obj = ui.GetFocusObject();
end

function HIDE_UI_TEST()

	local w = option.GetClientWidth() + 300;
	local h = option.GetClientHeight() + 300;
	local f = ui.GetFrame("quickslotnexpbar");
	f:MoveFrame(w, h);
	f = ui.GetFrame("fps");
	f:MoveFrame(w, h);
	f = ui.GetFrame("playtime");
	f:MoveFrame(w, h);
	f = ui.GetFrame("questinfoset_2");
	f:MoveFrame(w, h);

end

-- ==    SELECT_FIELDEVENT_TOOL_ITEM

function TEST_GROUPGEN()
	TEST_UI("groupgentool");
end

function TEST_UI(uiName)

	local frame = OPENNEW(uiName);
	frame:ShowWindow(1);

end

function TEST_MAPNAME()
	local frame = OPENNEW("mapname");
	frame:ShowWindow(1);

end

function TEST_SELCOLOR()

	local frame = OPENNEW("selectcolor");
	frame:ShowWindow(1);

end

function TEST_CHATMAKE()

	local frame = OPENNEW("createchat");
	--local frame = ui.GetFrame("config");
	frame:ShowWindow(1);
	MAKE_CHECKBOX_COLBOXES(frame);

end

function TEST_CONFIG()

	local frame = OPENNEW("config");
	--local frame = ui.GetFrame("config");
	frame:ShowWindow(1);

end

function TEST_WAREHOUSE()

	--local frame = OPENNEW("warehouse");
	local frame = ui.GetFrame("warehouse");
	frame:ShowWindow(1);

end

function TEST_TRACK_T()

	local frame = OPENNEW("tracktool");
	frame:ShowWindow(1);

end

function TEST_ITEMSEL_POPUP()

	local frame = OPENNEW("itemselpopup");
	--local frame = ui.GetFrame("itemselpopup");
	frame:ShowWindow(1);
	ITEMSELPOPUP_FIRST_OPEN(frame);

end

function TEST_QLOCTOOL()

	local frame = OPENNEW("questloctool");
	frame:ShowWindow(1);

	local mapName = session.GetMapName();
	QLOCTOOL_SETMAP(frame, mapName);
	QLOCTOOL_INIT(frame);

end

function TEST_QREWARDTOOL()

	--local frame = OPENNEW("questrewardtool");
	local frame = ui.GetFrame("questrewardtool");
	frame:ShowWindow(1);

end

function TEST_QREWARD()

	local frame = OPENNEW("questreward");
	frame:ShowWindow(1);
	QUEST_REWARD_TEST(frame);

end

function TEST_DLGEDIT()

	local frame = ui.GetFrame("dialogedit");
	--local frame = OPENNEW("dialogedit");
	frame:ShowWindow(1);
	DIALOGEDIT_UPDATE(frame);

end

function TEST_MONGEN()


	local frame = OPENNEW("mongenman");
	frame:ShowWindow(1);
	UPDATE_ALL_MONGEN(frame);


end


function TEST_BTN_BLINK()

	local frame = ui.GetFrame("sysmenu");
	local focus_ui = GET_CHILD(frame, "quest", "ui::CObject");
	focus_ui:Emphasize("focus_ui", 0, 1.0, "AAFF0000");

end

function TEST_MONDEAD()

	--local frame = OPENNEW('mondeadtest');
	local frame = ui.GetFrame('mondeadtest');
	frame:ShowWindow(1);
	SET_TEST_MONSTER_TYPE(frame, 11120);


end

function TEST_IESLIST()

	local frame = OPENNEW('iesmanagerlist');
	frame:ShowWindow(1);
	IESMANAGERLIST_UPDATE(frame);


end

function TEST_XMLCONVERT()

	--[[local list = iesman.GetIESHistory();
	local index = list:FirstInorder();
	while 1 do
		if index == list:InvalidIndex() then
			break;
		end

		local key = list:Key(index);
		index = list:NextInorder(index);
	end
	]]

	local frame = OPENNEW('iesmanagertoxml');
	frame:ShowWindow(1);
	TOXML_UPDATE(frame);


end

function TEST_IES()

	--ui.ToggleFrame("iesmanager");
	local frame = OPENNEW('iesmanager');
	frame:ShowWindow(1);

end

function TEST_CLONETEX()

	local frame = ui.GetFrame("map");
	local picture = GET_CHILD(frame, "map", "ui::CPicture");

	picture:ClonePicture();
	--picture:ShowWindow(1);
	picture:Invalidate();

end

function TEST_MAP()

	geMapTable.ReInit();

	local frame = ui.GetFrame("map");
	UPDATE_MAP(frame);

	frame = ui.GetFrame("minimap");
	UPDATE_MINIMAP(frame)
end

function TEST_MAPFOG()

	local frame = ui.GetFrame('mapfog');
	frame:ShowWindow(1);
	MAPFOG_SET_CUR_MAP(frame);
	--ui.ToggleFrame("mapfog");
end


function TEST_SETITEM()

	local frame = OPENNEW('setitemalarm');
	--ui.ToggleFrame('setitemalarm');
	frame:ShowWindow(1);
	UPDATE_SETITEMALARM(frame);

end

function TEST_SKILLVAN_()
--TEST_SKILLVAN();

	local frame = ui.GetFrame("skillvan");
	SKILLVAN_SET_CENTER_POSITION(500, 500, frame);

end

function TEST_SELECTITEM()

	local frame= ui.GetFrame("selectitem");
	--local frame = OPENNEW("selectitem");
	SELECTITEM_UPDATE(frame);
	frame:ShowWindow(1);
	--ui.ToggleFrame("selectitem");


end

function OPENNEW(frameName)

	local newframe = ui.CreateNewFrame(frameName);
	newframe:ShowWindow(1);
	return newframe;

end

function TEST_LAYER()

	local frame = OPENNEW("layerscore");
	LAYERSCORE_ADVBOX_INIT(frame);

end

function TEST_FIELDEVENT()

	ui.ToggleFrame("fieldevent");
	--local frame = OPENNEW("fieldevent");
	--TEST_FIELDEVENT_FRAME(frame);

end

function RELOAD_HALL()

	local frame = ui.GetFrame("halloffame");
	ui.ToggleFrame("halloffame");

end

function RELOAD_ACHIEVE()

	local frame = ui.GetFrame("achieve");
	UPDATE_ACHIEVE_LIST(frame);
	ui.ToggleFrame("achieve");

end

function RELOAD_MAP()

	debug.RM();

	local map = ui.GetFrame("map");
	UPDATE_MAP(map);

	local minimap = ui.GetFrame("minimap");
	MINIMAP_FIRST_OPEN(minimap);

end

function OPEN_CHAT_MENU(frame, control, commname, text, x, y)

	OPEN_CHAT_CONTEXT(commname);

end


function OPEN_CHAT_CONTEXT(commname)

	if commname == "" then
		return;
	end

	if GetMyName() == commname then
		return;
	end


	local ScpBuf = "";
	local context = ui.CreateContextMenu(commname, commname, 0, 0, 100, 100);

	ScpBuf = string.format("WHISPER_CHAT(\"%s\")", commname);
	ui.AddContextMenuItem(context, ScpArgMsg("WHISPER"), ScpBuf);

	ui.OpenContextMenu(context);
end

function GetMyName()
	return info.GetName(session.GetMyHandle());
end

function GETMYFAMILYNAME()
	local acc = session.barrack.GetMyAccount();
	return acc:GetFamilyName();
end

function GET_MAP_NAME(mapid)

	if mapid == 0 then
		return "";
	end

	return GetClassString('Map',mapid ,'Name');

end


function GET_ENDURE_COLOR(invitem)

	local percent = 0;
	local dur = invitem.Dur;
	if dur >0 then
		percent = dur * 100 / invitem.MaxDur;
	end

	if percent < 10 then
		return "{#ff0000}";
	end

	return "";

end


function GET_ITEM_BY_GUID(guid, equipfirst)

	if equipfirst == 1 then
		local pitem = session.GetEquipItemByGuid(guid);
		if pitem ~= nil then
			return pitem;
		end

		pitem = session.GetInvItemByGuid(guid);
		if pitem ~= nil then
			return pitem;
		end

		return nil;

	end

		local pitem = session.GetInvItemByGuid(guid);
		if pitem ~= nil then
			return pitem;
		end

		pitem = session.GetEquipItemByGuid(guid);
		if pitem ~= nil then
			return pitem;
		end

		return nil;


end

function UPDATE_TXT_TOOLTIP(frame, strArg, num, arg2)
	local caption = frame:GetChild("caption");
	caption:SetText(strArg);
	if num > 0 then

		local txt = caption:GetText();
		caption:Resize(num, caption:GetHeight());
		caption:SetText(txt);

		frame:Resize(caption:GetWidth() + 10, caption:GetHeight() + 16);
	else
		frame:Resize(caption:GetWidth() + 20, caption:GetHeight() + 16);
	end

	return 1;
end

function GET_QUEST_TOOLTIP_TXT(clsID)

	local cls = GetClassByType("QuestProgressCheck", clsID);

	local mylevel = info.GetLevel(session.GetMyHandle());
	local MonsterConditionTxt = GET_QUEST_INFO_TXT(cls);
	local color = GET_LEVEL_COLOR(mylevel, cls.Level);
	return color .. cls.Name .. "{/}" .. MonsterConditionTxt;

end

function UPDATE_MINI_QUEST_TOOLTIP(frame, strarg, numarg1, numarg2)

	local cls = GetClassByType("QuestProgressCheck", numarg1);

	local txt = GET_QUEST_TOOLTIP_TXT(numarg1);

	local GroupCtrl = frame:GetChild("gbox");
	tolua.cast(GroupCtrl, "ui::CGroupBox");
	GroupCtrl:DeleteAllControl();
	GroupCtrl:EnableResizeByParent(0);

	local y = 10;
	local frameWidth = 270;
	local ctrlset = MAKE_QUEST_INFO(GroupCtrl, cls, y);
	if ctrlset ~= nil then
		y = y + ctrlset:GetHeight() + 3;
	end

	frame:Resize(frameWidth, y + 5);
	GroupCtrl:Resize(frameWidth, y);
	GroupCtrl:UpdateData();

	return 1;
end

function CREATE_NUMBER_PICTURES(gbox, ypos, text, name)

	local picWidth = 25;
	local picHeight = 35;
	local len = string.len(text);
	local totalWidth = picWidth * len;
	local startX = (gbox:GetWidth() - totalWidth) / 2;

	for i = 1 , len do
		local x = startX + (i - 1) * picWidth;
		local subStr = string.sub(text, i, i);
		local pic;

		if subStr == '/' then
			pic = gbox:CreateOrGetControl("richtext", name .. i, x, ypos - 5, picWidth, picHeight);
			pic:SetText("{s42}{b}"..'/');
			pic:ShowWindow(1);
		else
			pic = gbox:CreateOrGetControl("picture", name .. i, x, ypos, picWidth, picHeight);
			tolua.cast(pic, "ui::CPicture");
			pic:SetImage(subStr);
			pic:SetEnableStretch(1);
			pic:ShowWindow(1);
		end


		if i == len then
			ypos = GET_END_POS(pic);
		end
	end

	return ypos;
end

function CREATE_GBOX_TEXT(gbox, x, ypos, ctrlName, text, isCenterAlign)

	if isCenterAlign == 1 then
		x = 0;
	end

	local txt = gbox:CreateOrGetControl("richtext", ctrlName, x, ypos, gbox:GetWidth() - x, 20);
	tolua.cast(txt, "ui::CRichText");
	txt:ShowWindow(1);
	txt:SetText(text);
	txt:EnableResizeByText(1);
	if isCenterAlign == 1 then
		txt:SetTextAlign("top", "center");
		txt:SetGravity(ui.CENTER_HORZ, ui.TOP);
	end

	ypos = GET_END_POS(txt);
	return ypos;

end

function DRAW_OPTION_TOOLTIP(tooltipframe, invitem, strarg, ypos)

	local OptionCnt = GET_OPTION_CNT(invitem);

	if OptionCnt == 0 then
		return ypos;
	end

	ypos = ypos + 10;
	for i = 0 , OptionCnt - 1 do
		local xc = 20;
		local socketName = "OPTION_" .. i;
		ypos = MAKE_OPTION_UI(tooltipframe, socketName, xc, ypos, i, invitem);
	end

	local exinfo = GET_CHILD(tooltipframe, "exinfo", "ui::CGroupBox");
	if exinfo ~= nil then
		ypos = ADD_EX_LABEL_LINE_TOOLTIP(exinfo, ypos);
		exinfo:AutoSize(1);
	end

	return ypos;
end

function ADD_EX_LABEL_LINE_TOOLTIP(GroupCtrl, xPos, yPos, width, height)

	if GroupCtrl == nil then
		return yPos;
	end

	local cnt = GroupCtrl:GetChildCount();
	local labelLine = GroupCtrl:CreateControl('labelline', "EX"..cnt, xPos, yPos, width, height);

	return labelLine:GetHeight() + labelLine:GetOffsetY();
end

function ADD_EX_PIC_TOOLTIP(GroupCtrl, txt, atkup, angleup, yPos)
	local cnt = GroupCtrl:GetChildCount();
	local ControlSetObj	 = GroupCtrl:CreateControlSet('itemtooltipexinfo', "EX" .. cnt , 20, yPos);
	local ControlSetCtrl = tolua.cast(ControlSetObj, 'ui::CControlSet');
	local nameText = ControlSetCtrl:GetChild("name");
	GroupCtrl:SetGravity(ui.LEFT, ui.TOP);
	ControlSetCtrl:SetGravity(ui.LEFT, ui.TOP);
	nameText:SetGravity(ui.LEFT, ui.TOP);
	nameText:SetFontName(ITEM_TOOLTIP_TEXT_FONT);
	nameText:SetText("{#003300}"..txt);

	local anglePic = GET_CHILD(ControlSetCtrl, "angle_pic", "ui::CPicture");
	local angleText = GET_CHILD(ControlSetCtrl, "angle_text", "ui::CRichText");
	local atkPic = GET_CHILD(ControlSetCtrl, "atk_pic", "ui::CPicture");
	local atkText = GET_CHILD(ControlSetCtrl, "atk_text", "ui::CRichText");

	local xPos = 0;
	if angleup ~= 0 then
		local angleTextTemp = tostring(angleup);
		angleText:SetFontName(ITEM_TOOLTIP_TEXT_FONT);
		angleText:SetText("{#003300}"..angleTextTemp);

		--angleText:SetOffset(xPos + anglePic:GetWidth(), angleText:GetY());

		anglePic:ShowWindow(1);
		angleText:ShowWindow(1);

		xPos = ControlSetCtrl:GetWidth() / 2;
	else
		anglePic:ShowWindow(0);
		angleText:ShowWindow(0);
	end

	if atkup ~= 0 then
		local atkTextTemp = tostring(atkup);
		atkText:SetFontName(ITEM_TOOLTIP_TEXT_FONT);
		atkText:SetText("{#003300}"..atkTextTemp);
		--atkPic:SetOffset(xPos, atkPic:GetY());
		--atkText:SetOffset(xPos + atkPic:GetWidth(), atkText:GetY());

		atkPic:ShowWindow(1);
		atkText:ShowWindow(1);
	else
		atkPic:ShowWindow(0);
		atkText:ShowWindow(0);
	end

	ControlSetCtrl:Resize(190, 45);

	return ControlSetCtrl:GetHeight() + ControlSetCtrl:GetOffsetY();
end

function ADD_EX_TOOLTIP(GroupCtrl, txt, yPos, ySize)

	if GroupCtrl == nil then
		return 0;
	end

	local cnt = GroupCtrl:GetChildCount();
	
	local ControlSetObj			= GroupCtrl:CreateControlSet('richtxt', "EX" .. cnt , ySize, yPos);
	local ControlSetCtrl		= tolua.cast(ControlSetObj, 'ui::CControlSet');
	local richText = GET_CHILD(ControlSetCtrl, "text", "ui::CRichText");
	GroupCtrl:SetGravity(ui.LEFT, ui.TOP);
	ControlSetCtrl:SetGravity(ui.LEFT, ui.TOP);
	richText:SetGravity(ui.LEFT, ui.TOP);
	richText:SetFontName(ITEM_TOOLTIP_TEXT_FONT);
	ControlSetCtrl:Resize(255, ySize);
	ControlSetCtrl:SetTextByKey('text', txt);
	GroupCtrl:ShowWindow(1)
	return ControlSetCtrl:GetHeight() + ControlSetCtrl:GetOffsetY();

end

function ADD_TXT_GROUP_C(frame, name, txt, x, ypos, height, fixsize)

	local width = frame:GetWidth() - x;
	local item = frame:CreateOrGetControl("richtext", name, x, ypos, width, height);
	tolua.cast(item, "ui::CRichText");
	item:ShowWindow(1);
	if fixsize == 1 then
		item:SetTextFixWidth(1);
	end

	item:EnableResizeByText(0);
	item:SetGravity(ui.CENTER_HORZ, ui.TOP);
	item:SetTextAlign("center", "top");
	item:SetText(txt);
	return GET_END_POS(item);
end

function MAKE_OPTION_UI(GroupCtrl, name, x, ypos, index, invitem)
	x = 0;
	local optiontype = invitem["Option_" .. index];
	local opttype = OPT_TYPE(optiontype);
	local optvalue = OPT_VALUE(optiontype);
	local class = GetClassByType('Option', opttype);
	if class ~= nil then
		local Desc = string.format(class.Desc, optvalue);
		local optionTxt = string.format( "{#050505}%s{/}", Desc);
		ypos = ADD_TXT_GROUP_C(GroupCtrl, name, optionTxt, x, ypos, 20, 1);

		local dur = invitem["OpDur_" .. index];
		local mdur = invitem["OpMDur_" .. index];
		local durtxt = string.format( "{#050505}(%s/%s){/}", dur, mdur);
		ypos = ADD_TXT_GROUP_C(GroupCtrl, name.."_D", durtxt, x, ypos, 20, 1);
	end

	return ypos + 5;
end

function GET_CHILD_GROUPBOX(frame, name)

	local obj = frame:GetChild(name);
	tolua.cast(obj, "ui::CGroupBox");
	return obj;

end

function INIT_ITEM_TOOLTIP_GROUPBOX(frame, groupbox, ypos)

	groupbox:DeleteAllControl();
	groupbox:EnableResizeByParent(0);
	groupbox:ShowWindow(1);
	groupbox:SetOffset(8, ypos);
	groupbox:Resize(frame:GetWidth(), 1);

end

function DRAW_TOOLTIP_LINE(frame, name, ypos)

	local label = frame:GetChild(name);
	label:SetOffset(8, ypos);
	label:ShowWindow(1);
	ypos = label:GetY() + label:GetHeight();
	return ypos;

end

function GET_ITEM_SET_TITLE_TEXT(set)

	local cnt =	set:GetItemCount();
	local curCnt = GET_TOTALHAVE_SET_COUNT(set);

	return string.format(" %s (%d/%d)", set:GetSetName(), curCnt, cnt );

end

function GET_ITEM_SET_TITLE_TEXT_EQP(set)
	return string.format("%s", set:GetSetName());
end

function GET_ITEM_SET_EFFECT_TEXT(set, onlyEquip, GroupCtrl, y)
	local resText = "";
	local curCnt = 0;
	if onlyEquip == 1 then
		curCnt = GET_EQUIPED_SET_COUNT(set);
	else
		curCnt = GET_TOTALHAVE_SET_COUNT(set);
	end

	local maxCnt = geItemTable.GetMaxSetCnt();
	for i = 0 , maxCnt - 1 do
		local setEffect = set:GetSetEffect(i);
		if setEffect ~= nil then
			local color = "{#704010}";
			if curCnt >= i + 1 then
				color = '{#050505}';
			end

			local setTitle = ScpArgMsg("Auto_{s18}{Auto_1}{Auto_2}_SeTeu_HyoKwa__{nl}", "Auto_1",color, "Auto_2",i + 1);
			local setDesc = string.format("{s18}%s%s", color, setEffect:GetDesc());

			local setTitleText = GroupCtrl:CreateOrGetControl("richtext", "SET_LIST_EFT_"..i, 15, y, 350, 20);
			tolua.cast(setTitleText, "ui::CRichText");
			setTitleText:ShowWindow(1);
			setTitleText:SetTextFixWidth(0);
			setTitleText:EnableResizeByText(0);
			setTitleText:SetGravity(ui.LEFT, ui.TOP);
			setTitleText:SetText(setTitle .. ' ' .. setDesc);

			y = y + setTitleText:GetHeight();
		end
	end
	return y + 10;
end

function GET_END_POS(ctrl)
	return ctrl:GetHeight() + ctrl:GetY();
end

function DRAW_SET_LIST_TOOLTIP_OLD(GroupCtrl, set, x, y)

	local cnt =	set:GetItemCount();
	local xPos = 0;
	local xSpace = 0;
	local yPos = 0;
	if cnt == 2 then
		xPos = 38;
		xSpace = 38;
	elseif cnt == 3 then
		xPos = 25;
		xSpace = 12;
	elseif cnt == 4 then
		xPos = 10;
		xSpace = 3;
	elseif cnt == 5 or cnt == 6 or cnt == 7 then
		xPos = 10;
		xSpace = 3;
		yPos = 45;
	end

	for i = 0, cnt -1 do
		local clsName = set:GetItemClassName(i);
		local cls = GetClass("Item", clsName);

		if cls ~= nil then
			local name = set:GetItemName(i);
			local count = i;

			if i == 4 then
				count = 0;
				y = y + 70;
			elseif i == 5 then
				count = 1;
			elseif i == 6 then
				count = 2;
			elseif i == 7 then
				count = 3;
			end

			local slot = GroupCtrl:CreateOrGetControl('slot', "SET_LIST_SLOT" .. i, xPos + (64 * count + xSpace * count) , y-20, 64, 64);
			tolua.cast(slot, "ui::CSlot");
			slot:ShowWindow(1);

			local imgName = GET_ICON_BY_NAME(cls.ClassName);
			local icon = SET_SLOT_ICON(slot, imgName);

			if GET_EQP_ITEM_CNT(cls.ClassID) > 0 then
				icon:SetColorTone("FFFFFFFF");
				slot:SetColorTone("FFFFFFFF");
			else
				icon:SetColorTone("66FFFFFF");
				slot:SetColorTone("66FFFFFF");
			end
		end
	end

	y = y + 45;
	y = GET_ITEM_SET_EFFECT_TEXT(set, 1, GroupCtrl, y);

	return y;
end

function CREATE_GROUP_CHILD(groupctrl, type, name, x, y, height)

	local width = groupctrl:GetWidth() - x * 2;
	local ctrl = groupctrl:CreateOrGetControl(type, name, x, y, width, height);
	ctrl:ShowWindow(1);
	ctrl:SetTextFixWidth(0);
	return ctrl;
end

function GET_ITEM_SET_LIST_TEXT(set, onlyEquip)

	local haveFormat = "";
	local noHaveFormat = "";
	local checkScp = nil;
	if onlyEquip == 1 then
		checkScp = _G["GET_EQP_ITEM_CNT"];
		haveFormat = ScpArgMsg("Auto_(JangChag)");
		noHaveFormat = ScpArgMsg("Auto_(MiJangChag)");
	else
		checkScp = _G["GET_TOTAL_ITEM_CNT"];
		haveFormat = "(1/1)";
		noHaveFormat = "(0/1)";
	end

	local cnt =	set:GetItemCount();
	local resText = "";
	for i = 0, cnt -1 do
		local clsName = set:GetItemClassName(i);
		local cls = GetClass("Item", clsName);
		local name = set:GetItemName(i);

		if checkScp(cls.ClassID) > 0 then
			resText = resText .. string.format("{#AAAA22}%s %s{nl}", name, haveFormat);
		else
			resText = resText .. string.format("{#222222}%s %s{nl}", name, noHaveFormat);
		end
	end

	resText = string.sub(resText, 1, string.len(resText) - 4);
	return resText;
end

function EXTEND_BY_CHILD(parent, ctrl)

	local width = MAX(parent:GetWidth(), ctrl:GetX() + ctrl:GetWidth() );
	local height = MAX(parent:GetHeight(), ctrl:GetY() + ctrl:GetHeight() ) + 5;
	parent:Resize(width, height);

end

function GET_EQUIPED_SET_COUNT(set)

	local haveCnt = 0;
	local cnt =	set:GetItemCount();

	for i = 0, cnt -1 do
		local clsName = set:GetItemClassName(i);
		if session.GetEquipItemByName(clsName) ~= nil then
			haveCnt = haveCnt + 1;
		end
	end

	return haveCnt;

end

function GET_TOTALHAVE_SET_COUNT(set)

	local haveCnt = 0;
	local cnt =	set:GetItemCount();

	for i = 0, cnt -1 do
		local clsName = set:GetItemClassName(i);
		local type = GetClass("Item", clsName).ClassID;
		if GET_TOTAL_ITEM_CNT(type) > 0 then
			haveCnt = haveCnt + 1;
		end
	end

	return haveCnt;

end


function CLEAR_GROUPBOX(frame, objName)
	local obj = frame:GetChild(objName);
	if obj ~= nil then
		obj = tolua.cast(obj, 'ui::CGroupBox');
		--obj:RemoveChild('durectrlset');
		obj:ShowWindow(0);
		obj:DeleteAllControl();
	end
end

function HIDE_PAGEGROUPBOX(frame, objName)
	local obj = frame:GetChild(objName);
	if obj ~= nil then
		obj = tolua.cast(obj, 'ui::CGroupBox');
		--obj:RemoveChild('durectrlset');
		obj:Resize(obj:GetWidth(),20);
		obj:ShowWindow(0);
	end
end

function HIDE_LABEL(frame, name)
	if frame:GetChild(name) ~= nil then
		frame:GetChild(name):ShowWindow(0);
	end
end


function HIDE_EX_INFO(tooltipframe)

	HIDE_CHILD_BYNAME(tooltipframe, "OPTION_");
	HIDE_CHILD_BYNAME(tooltipframe, "SET_LIST_");

	HIDE_CHILD_BYNAME(tooltipframe, "durectrlset");
	HIDE_CHILD_BYNAME(tooltipframe, "desc");
	HIDE_CHILD_BYNAME(tooltipframe, "atk_");
	HIDE_CHILD_BYNAME(tooltipframe, "usage");
	HIDE_CHILD_BYNAME(tooltipframe, "range");
	HIDE_CHILD_BYNAME(tooltipframe, "type");
	HIDE_CHILD_BYNAME(tooltipframe, "atkName");
	HIDE_CHILD_BYNAME(tooltipframe, "atkValue");

	HIDE_CHILD_BYNAME(tooltipframe, "SET_LIST_SLOT");
	HIDE_CHILD_BYNAME(tooltipframe, "SOCKET_");
	HIDE_CHILD_BYNAME(tooltipframe, "OPTION_");

	CLEAR_GROUPBOX(tooltipframe, 'exinfo');
	HIDE_PAGEGROUPBOX(tooltipframe, 'item_0');
	CLEAR_GROUPBOX(tooltipframe, 'item_1');
	CLEAR_GROUPBOX(tooltipframe, 'item_2');
	CLEAR_GROUPBOX(tooltipframe, 'item_3');
	HIDE_CHILD(tooltipframe, "tabtext");

end

function HIDE_EX_INFO_COMPARITION(tooltipframe)

	HIDE_EX_INFO(tooltipframe);

end

function HIDE_EX_INFO_CHANGEVALUE(tooltipframe)
	CLEAR_GROUPBOX(tooltipframe, 'changevalue');
end

function GET_ITEM_FONT_COLOR(rank)

	if rank == 0 then
		return "{#FFFFFF}";
	elseif rank == 1 then
		return "{#051505}";
	elseif rank == 2 then
		return "{#050515}";
	elseif rank == 3 then
		return "{#151505}";
	elseif rank == 4 then
		return "{#FFFF00}";
	elseif rank == 4 then
		return "{#FF0000}";
	end

	return "{#FFFFFF}";
end

function GET_ITEM_TOOLTIP_SKIN(cls)

	if cls.ToolTipScp == "WEAPON" or cls.ToolTipScp == "ARMOR" then
		return "test_Item_tooltip_equip";
	elseif cls.ToolTipScp == "ETC" and cls.GroupName == "Drug" then
		return "test_Item_tooltip_normal";
	elseif cls.ToolTipScp == "ETC" and cls.GroupName == "Quest" then
		return "test_Item_tooltip_normal";
	elseif cls.ToolTipScp == "ETC" and cls.GroupName == "Material" then
		return "test_Item_tooltip_normal";
	elseif cls.ToolTipScp == "ETC" and cls.GroupName == "Card" then
		return "test_Item_tooltip_equip";
	end

	return "Item_tooltip_consumable";
end

function GET_ITEM_BG_PICTURE_BY_GRADE(rank, needAppraisal, needRandomOption)

	local pic = 'None'
	local flag = 3
	
	if needAppraisal == 1 or needRandomOption == 1 then
		flag = 4
	end
	if rank == 1 then
		pic = "one_two_star_item_bg" .. flag;
	elseif rank == 2 then
		pic ="three_star_item_bg" .. flag;
	elseif rank == 3 then
		pic = "four_star_item_bg" .. flag;
	elseif rank == 4 then
		pic = "five_item_bg" .. flag;
	elseif rank == 5 then
	    pic = "six_item_bg" .. flag;
	elseif rank == 0 then
		return "premium_item_bg";
	end

	return pic;
end

function GET_ITEM_BG_PICTURE_BY_ITEMLEVEL(itemlv) 

	local clslist, cnt  = GetClassList("item_bg_image_level_table");

	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clslist, i);

		if cls.MaxLv >= itemlv then
			return cls.ImageName
		end
	end

	return 'None';

end

function GET_ITEM_PICTURE_RANK(cls)

	if cls == nil then
		return "None";
	end

	local itemRank = cls.ItemStar;

	if itemRank == 0 then
		return "None";
	elseif itemRank == 1 then
		return "itemicon_rank_D";
	elseif itemRank == 2 then
		return "itemicon_rank_C";
	elseif itemRank == 3 then
		return "itemicon_rank_B";
	elseif itemRank == 4 then
		return "itemicon_rank_A";
	elseif itemRank == 5 then
		return "itemicon_rank_AA";
	elseif itemRank == 6 then
		return "itemicon_rank_AAA";
	elseif itemRank == 7 then
		return "itemicon_rank_AAA+";
	elseif itemRank == 8 then
		return "itemicon_rank_AAA++";
	elseif itemRank == 9 then
		return "itemicon_rank_S";
	elseif itemRank == 10 then
		return "itemicon_rank_SS";
	elseif itemRank == 11 then
		return "itemicon_rank_SSS";
	elseif itemRank == 12 then
		return "itemicon_rank_SSS+";
	elseif itemRank == 13 then
		return "itemicon_rank_SSS++";
	end
end

function GET_FULL_GRADE_NAME(itemCls, gradeSize)
	local gradeTxt = GET_ITEM_GRADE_TXT(itemCls, gradeSize);
	return GET_FULL_NAME(itemCls) .. "{nl}" .. gradeTxt;
end

function GET_FULL_NAME(item, useNewLine, isEquiped)	
	if isEquiped == nil then
		isEquiped = 0;
	end
	local ownName = GET_NAME_OWNED(item);
	local reinforce_2 = TryGetProp(item, "Reinforce_2");
	local isHaveLifeTime = TryGetProp(item, "LifeTime");
	local pc = GetMyPCObject();
	local bonusReinf = TryGetProp(pc, 'BonusReinforce');
	local ignoreReinf = TryGetProp(pc, 'IgnoreReinforce');
	local overReinf = TryGetProp(pc, 'OverReinforce');
	if bonusReinf ~= nil then
		if TryGetProp(item, 'EquipGroup') == 'SubWeapon' and isEquiped > 0 then
			reinforce_2 = reinforce_2 + bonusReinf;
		end
	end
	if overReinf ~= nil then
		if TryGetProp(item, 'GroupName') == 'Weapon' and isEquiped > 0 then
			reinforce_2 = reinforce_2 + overReinf;
		end
	end
	if isEquiped > 0 and ignoreReinf == 1 then
		reinforce_2 = 0;
	end	
	
	if 0 ~= isHaveLifeTime then
		ownName = string.format("{img test_cooltime 30 30}%s{/}", ownName);
	end
	
	if reinforce_2 ~= nil and reinforce_2 > 0 then
		ownName = string.format("+%d %s", reinforce_2, ownName);
	end

	local lv = GET_ITEM_LEVEL(item);
	if lv > 0 then
		if useNewLine == nil then
			-- return string.format("%s - {ol}{#FFFFEE}Lv %d", ownName, lv);
		--else
		--	local maxLv = GET_ITEM_MAX_LEVEL(item);
		--	if maxLv > 1 then
		--		return string.format("%s{nl}{ol}{#FFFFFF}Lv  %d / %d", ownName, lv, maxLv);
		--	end
		end
	end

	if IS_ENCHANT_JEWELL_ITEM(item) == true then
		return GET_EXTRACT_ITEM_NAME(item);
	end

	if IS_SKILL_SCROLL_ITEM ~= nil and IS_SKILL_SCROLL_ITEM(item) == true then
		local skillCls = GetClassByType('Skill', item.SkillType);
		return ownName..string.format('[Lv. %d %s]', item.SkillLevel, skillCls.Name);
	end

	return ownName;
end

function GET_NAME_OWNED(item)
	local itemName = item.Name
	local legendPrefix = TryGetProp(item, "LegendPrefix")
	if legendPrefix ~= nil then
		itemName = GET_LEGEND_PREFIX_ITEM_NAME(item)
	end

	if item.ItemType == "Equip" and item.IsPrivate == "YES" and item.Equiped == 0 then
		return ClMsg("LOST_ITEM") .. " " ..itemName;
	end

	local customTooltip = TryGetProp(item, "CustomToolTip");
	if customTooltip ~= nil and customTooltip ~= "None" then
		local nameFunc = _G[customTooltip .. "_NAME"];
		if nameFunc ~= nil then
			return nameFunc(item);
		end
	end

	if GetPropType(item, 'CustomName') ~= nil then
		local customName = item.CustomName;
		if customName ~= "None" then
			return customName..'('..itemName..')';
		end
	end

	return itemName;

end

function GET_REQ_TOOLTIP(invitem)
	local req = invitem.ReqToolTip;

	if item.ItemType == "Equip" then
		local useJob = invitem.UseJob;
		if useJob ~= "All" then
			req = ScpArgMsg(useJob).." "..req;
		end
	end

	return req;
end

function GET_EQUIPABLE_JOB(cls)

	local prop = geItemTable.GetProp(cls.ClassID);
	local cnt = prop:GetUseJobCount();

	if cnt == 0 then
		return "";
	end

	local result = "";
	for i = 0 , cnt - 1 do
		local jobCls = GetClassByType("Job", prop:GetUseJob(i));
		local temp = " ";
		if i ~= 0 then
			temp = ", ";
		end
		result = result .. temp .. jobCls.Name;
	end

	if cls.ToolTipScp == "WEAPON" then
		return result..ScpArgMsg("Auto__MuKi");
	elseif cls.ToolTipScp == "ARMOR" then
		return result..ScpArgMsg("Auto__JangBi");
	else
		return result;
	end
end

function IS_RECIPE_ITEM(itemCls)

	local clslist, cnt  = GetClassList("Recipe");

	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clslist, i);
		if itemCls == nil then
			return 0
		end
		local itemClsClassName = TryGetProp(itemCls, 'ClassName');
		if itemClsClassName == nil then
			return
		end

		if cls.ClassName == itemClsClassName then
			local TargetItemID = TryGetProp(cls, 'TargetItem');

			if TargetItemID ~= nil then
				local newitemCls = GetClass("Item", cls.TargetItem);
				if newitemCls ~= nil then
					return newitemCls.ClassID				
				end
			end
		end
	end

	return 0

end

function SCR_MAGICAMULET_EQUIP(fromitem, toitem)
	if nil == fromitem or nil == toitem then
		return;
	end
	local fromobj = GetIES(fromitem:GetObject());
	local toobj = GetIES(toitem:GetObject());

	local potential = toobj.PR;

	if potential <= 0 then
		ITEM_MSG(ScpArgMsg("NotEnoughReinforcePotential"));
		return;
	end
	
	local socketCnt = GET_MAGICAMULET_EMPTY_SOCKET_INDEX(toobj);

	if socketCnt == -1 then
		ITEM_MSG(ScpArgMsg("NOT_HAVE_MAGIC_AMULET_SOCKET_SPACE"));
		return;
	end

	local strscp = string.format( "LUMIN_EXECUTE(\"%s\", \"%s\")", fromitem:GetIESID(), toitem:GetIESID());
	local remaincountstr = ScpArgMsg('RemainMagicAmuletSocket','Remain',toobj.MaxSocket_MA - socketCnt);
	local msg = "["..fromobj.Name..ScpArgMsg("Auto_]_KaDeuLeul_[")..toobj.Name..ScpArgMsg("Auto_]_e_JangChagHaSiKessSeupNiKka?")..remaincountstr;
	ui.MsgBox(msg, strscp, "None");

end

function SCR_GEM_EQUIP(fromitem, toitem)

	local fromobj = GetIES(fromitem:GetObject());
	local toobj = GetIES(toitem:GetObject());

	local potential = toobj.PR;

	if potential <= 0 then
		ITEM_MSG(ScpArgMsg("NotEnoughReinforcePotential"));
		return;
	end
	
	local socketindex = GET_GEM_SOCKET_CNT(toobj,fromobj_gemtype);

	if socketindex == -1 then
		socketindex = GET_GEM_SOCKET_CNT(toobj,5);
	end

	if socketindex == -1 then
		ITEM_MSG(ScpArgMsg("NOT_HAVE_SOCKET_SPACE"));
		return;
	end

	local strscp = string.format( "LUMIN_EXECUTE(\"%s\", \"%s\")", fromitem:GetIESID(), toitem:GetIESID());
	local msg = "["..fromobj.Name..ScpArgMsg("Auto_]_KaDeuLeul_[")..toobj.Name..ScpArgMsg("Auto_]_e_JangChagHaSiKessSeupNiKka?");
	ui.MsgBox(msg, strscp, "None");

end

function SCR_RUNE_EQUIP(fromitem, toitem)

	local fromobj = GetIES(fromitem:GetObject());
	local toobj = GetIES(toitem:GetObject());

	local socketCnt = GET_SOCKET_CNT(toobj);

	if socketCnt == 0 then
		ITEM_MSG(ScpArgMsg("NOT_HAVE_SOCKET_SPACE"));
		return;
	end

	if toitem.ItemStar < fromitem.ItemStar then
		return;
	end

	local strscp = string.format( "LUMIN_EXECUTE(\"%s\", \"%s\")", fromitem:GetIESID(), toitem:GetIESID());
	local msg = "["..fromobj.Name..ScpArgMsg("Auto_]_KaDeuLeul_[")..toobj.Name..ScpArgMsg("Auto_]_e_JangChagHaSiKessSeupNiKka?");
	ui.MsgBox(msg, strscp, "None");

	--[[
	local tframe = ui.GetNewToolTip("item", "item_test");
    tframe:SetTooltipType('wholeitem');
    tframe:SetTooltipArg('inven', 0, toitem:GetIESID());
    tframe:RefreshTooltip();

	local yPos = tframe:GetHeight() + 10;
	local clickLumin = tframe:CreateOrGetControl('richtext', "DESC", 20, yPos, tframe:GetWidth(), 25);
	clickLumin:ShowWindow(1);
	local newtxt = string.format("{@st41}%s{/}", ClMsg("DropCartToSlot"));
	clickLumin:SetText(newtxt);
	yPos = yPos + clickLumin:GetHeight();

	tframe:Resize(tframe:GetWidth(), yPos + 20);

	ui.ToCenter(tframe);
    tframe:ShowWindow(1);
	]]
end

function LUMIN_EXECUTE(fromIESID, toIESID)
	item.UseItemToItem(fromIESID, toIESID, 0);
end

function SHOW_NEW_TOOLTIP(invitem, tipname)
	local itemobj = GetIES(invitem:GetObject());
	local socketCnt = GET_SOCKET_CNT(itemobj);
	if socketCnt == 0 then
		return;
	end

	local newframe = 0;
	local tframe = ui.GetFrame(tipname);
	if tframe == nil then
		tframe = ui.GetNewToolTip("item", tipname);
		newframe = 1;
	end

	tolua.cast(tframe, 'ui::CTooltipFrame');
	HIDE_EX_INFO(tframe)

	local  oldx = tframe:GetX();
	local  oldy = tframe:GetY();

	SET_ITEM_TOOLTIP_ALL_TYPE(tframe, invitem, itemobj.ClassName, 'inven', 0, invitem:GetIESID());
    tframe:RefreshTooltip();
	ui.ToCenter(tframe);

    tframe:ShowWindow(1);

end

function UPDATE_NEW_TIP(tframe)

	local  oldx = tframe:GetX();
	local  oldy = tframe:GetY();

	local iesID = tframe:GetTooltipIESID();
	local item_c = session.GetInvItemByGuid(iesID);

	tolua.cast(tframe, 'ui::CTooltipFrame');
	tframe:RefreshTooltip();
	MODIFY_TOOLTIP_FOR_SOCKET(tframe, item_c);
	tframe:MoveFrame(oldx, oldy);
end

function MODIFY_TOOLTIP_FOR_SOCKET(tframe, invitem)
	local itemobj = GetIES(invitem:GetObject());
	local socketCnt = GET_SOCKET_CNT(itemobj);

	if socketCnt == 0 then
		return;
	end

	local nameChild = tframe:GetChild('name');

	local ypos = 0;
	local x = 15;
	for i = 0 , socketCnt - 1 do
		local socketName = "SOCKET_" .. i;
		local slotNameCtrl = nil;
		slotNameCtrl = secondPageGroupBox:GetChild(socketName);

		local skttype = GetIESProp(itemobj, "Socket_" .. i);
		local basiccls = GetClassByType("Socket", skttype % SOCKET_MAX);
		local curcls = GetClassByType("Socket", CUR_SOCKET(skttype));

		local newtxt = string.format('{s16}{#050505}'.."%s"..'{/}', curcls.Name);
		slotNameCtrl:SetText(newtxt);

		slotNameCtrl:ShowWindow(1);

		local slotName = "SLOT_SOCKET_"..i;
		local socketSlot = nil;

		socketSlot = secondPageGroupBox:GetChild(slotName);

		local skttype = GetIESProp(itemobj, "Socket_" .. i);
		local basiccls = GetClassByType("Socket", skttype % SOCKET_MAX);
		local curcls = GetClassByType("Socket", CUR_SOCKET(skttype));

		tolua.cast(socketSlot, "ui::CSlot");
		socketSlot:SetSkinName(basiccls.SlotName);
		socketSlot:ShowWindow(1);
		socketSlot:ClearIcon();
		if curcls.SlotIcon ~= "None" then
			local icon = CreateIcon(socketSlot);
			icon:SetImage("icon_"..curcls.SlotIcon);
			icon:SetColorTone("FFFFFFFF");
			icon:SetEnable(1);
		end

		socketSlot:SetDropScp("LUMIN_DROP");
		socketSlot:SetDropArgStr(invitem:GetIESID());
		socketSlot:SetDropArgNum(i);

		ypos = socketSlot:GetY() + 35;
	end

	tolua.cast(tframe, "ui::CTooltipFrame");
	local pageCount = tframe:GetPageCount();

	for i=0, pageCount-1 do
		local pageGroupBox = tframe:GetChild(tframe:GetName()..'_'..i);
		local picture = tframe:GetChild('pageNum_'..i);
		if i == tooltipPage then
			pageGroupBox:ShowWindow(1);
			if picture ~= nil then
				tolua.cast(picture, "ui::CPicture");
				picture:SetImage('page_'..i+1);
			end
		else
			pageGroupBox:ShowWindow(0);
			if picture ~= nil then
				tolua.cast(picture, "ui::CPicture");
				picture:SetImage('pagemarker_off');
			end
		end
	end
	tframe:Resize(200, secondPageGroupBox:GetY()+secondPageGroupBox:GetHeight()+15);
end

function LUMIN_DROP(frame, control, argStr, argNum)

	local liftIcon 		= ui.GetLiftIcon();
	local frominfo 		= liftIcon:GetInfo();
	local slot 	   		= tolua.cast(control, 'ui::CSlot');
	local toicon   		= slot:GetIcon();
	local fromInvIndex  = frominfo.ext;
	local fromitem 		= session.GetInvItem(fromInvIndex);
	local fromobj 		= GetIES(fromitem:GetObject());

	if fromobj.Script ~= "SCR_RUNE_EQUIP" then
		return;
	end

end

function LUMIN_DROP_EXECUTE(iesID, framName, argStr, argNum)
	local tframe = ui.GetFrame(framName);
	if tframe ~= nil and tframe:IsVisible() == 1 then
		tframe:ShowWindow(0);
	end

	item.UseItemToItem(iesID, argStr, argNum);
end

function ITEM_MSG(msg)
	--logger.SysMsg(msg);
	ui.SysMsg(msg);

end

function GET_QUEST_STATE_TXT(state)

	if state == 'COMPLETE' then
		return "[" .. ScpArgMsg(state) .. "]";
	end

	return ScpArgMsg(state);
end


function SHOW_MONSTER_HELP(monsterID)

	local moncls = GetClassByType("Monster",  numarg1);

	local txt = tooltipframe:GetChild("name");
	txt:SetText(strarg);

	local imgname = "npc_icon_" .. moncls.ClassName;
	if ui.IsImageExist(imgname) == true then
		local img = tooltipframe:GetChild("img");
		tolua.cast(img, "ui::CPicture");
		img:SetImage(imgname);

		img:Resize(100, 100);
		local maxX = math.max(img:GetWidth(), txt:GetWidth());
		tooltipframe:Resize(maxX + 20, img:GetY() + img:GetHeight() + 10);
	else
		tooltipframe:Resize(txt:GetWidth() + 20 , txt:GetHeight() + 10);
	end

end

function SCR_ITEM_MIXER_CLIENT(invitem)

	local uiframe = ui.GetFrame('mixer');
	MIXER_TEST(uiframe, invitem);

end

function SCR_ITEM_COLOR_SPRAY_CLIENT(invItem)

	local uiFrame = ui.GetFrame("spray");
	uiFrame:ShowWindow(1);
	ui.CloseFrame("inventory");

end

function CONVERT_STATE(state)

	if state == 'PROGRESS' then
		return 'Prog';
	elseif state == 'SUCCESS' then
		return 'End';
	end

	return 'Start';
end

function STATE_NUMBER(state)

	if state == 'POSSIBLE' then
		return 0;
	elseif state == 'PROGRESS' then
		return 1;
	elseif state == 'SUCCESS' then
		return 2;
	end

	return -1;
end

function GET_NPCNAME_BY_QUEST(maptype, dialog)
	local genspace = "GenType_" .. maptype;
	local cls = GetClassByStrProp(genspace, "Dialog", dialog);
	if cls == nil then
		return " - ";
	end

	return cls.Name;
end

function FIND_STRING(str, startPos, findStr)

	local cap = string.sub(str, startPos, string.len(str));
	local pos = string.find(cap, findStr);
	if pos == nil then
		return nil;
	end

	return pos + startPos;
end

function SCR_SKILLITEM(invItem)

	local obj = GetIES(invItem:GetObject());
	local skilCls = GetClass("Skill", obj.StringArg);
	local sklType = skilCls.ClassID;

	spcitem.CreateVirtualSkill(sklType, invItem:GetIESID(), obj.Level);
	control.Skill(sklType,  obj.Level);

end

function SCR_SKILLSCROLL(invItem)
	if world.IsPVPMap() then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if obj.SkillType == 0 then

		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local sklType = obj.SkillType;
	spcitem.CreateScrollSkill(sklType, invItem:GetIESID(), obj.SkillLevel, true);
	control.Skill(sklType, obj.SkillLevel, true);
end

 function SCR_MONGWANGGA_CLIENT(invItem)

	local obj = GetIES(invItem:GetObject());
	local skilCls = GetClass("Skill", obj.StringArg);
	control.ItemSkillCast(skilCls.ClassID, invItem:GetIESID(), "SCR_EXEC_MONWANGGA");

end

function SCR_EXEC_MONWANGGA(guid, x, y, z)

	item.UseItemToGround(guid, x, y, z);

end

 function GET_TOTAL_MONEY_STR() -- int로 잘리지 않고 싶으면 이걸 쓰도록하되, 밖에서 계산할 때는 tonumber하거나 BigNumber 전용 함수들 사용 권장
	local silver = '0';
	local invItem = session.GetInvItemByName('Vis');
	if invItem ~= nil then
		silver = invItem:GetAmountStr();
	end
	return silver;
 end

function TRADE_DIALOG_CLOSE()
	control.DialogOk();
end

function UI_TOGGLE_QUIT()

	ui.ToggleFrame('apps');
	--[[
	if world.IsSingleMode() == 0 then
		ui.ToggleFrame('apps');
	else
		ui.ToggleFrame('quitsingle');
	end
	]]

end

-- ?? ctrl + y
function UI_KEYDOWN_OKAY()

end

-- ?? ctrl + n
function UI_KEYDOWN_CANCEL()

end

function SCR_CELL_TOGGLE()

	if true == session.IsGM() then
		debug.ToggleCell()
	end
end

function SCR_IESMANAGER_TOGGLE()
	ui.ToggleFrame('iesmanager')

end

function SCR_UIDEBUG_TOGGLE()
	--if true == session.IsGM() then
		debug.ToggleUIDebug()
	--end

end

function SCR_RELOAD_EFFECT()
	if true == session.IsGM() then
		debug.ReloadEffect()
	end

end

function SCR_DEBUG_RC()
	if true == session.IsGM() then
		debug.RC()
	end

end



-- ON_WORLD_MSG_%d (WORLD_MESSAGE_ACHIEVE_ADD == 0)
function ON_WORLD_MSG_0(name, type, pointType, point)

	local list = session.party.GetPartyMemberList(PARTY_NORMAL);

	local count = list:Count();
	local ispartymesmbers = false;

	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		if partyMemberInfo:GetName() == name and info.GetFamilyName(session.GetMyHandle()) ~= name then
			ispartymesmbers = true
			break
		end
	end
	
	if nil ~= session.friends.GetFriendByFamilyName(FRIEND_LIST_COMPLETE, name) or ispartymesmbers == true then
		
		local achiName = geAchieveTable.GetName(type);	

		local msg = ScpArgMsg("Auto_{#FFFF00}[{Auto_1}]Nimi_<{Auto_2}>eopJeogeul_DalSeongHayeossSeupNiDa.","Auto_1", name, "Auto_2",achiName);
		ui.AddText("SystemMsgFrame", msg);

		--msg = ScpArgMsg("Auto_{#FFFF00}{a_SEARCH_FAME_RANK_{Auto_1}_{Auto_2}}[{Auto_3}]Nimi_<{Auto_4}>eopJeogeul_DalSeongHayeossSeupNiDa.","Auto_1", name,"Auto_2", pointType,"Auto_3", name,"Auto_4", achiName);
		--logger.SysMsg(msg);
	end
end

function SEARCH_FAME_RANK(name, pointType)

	FAME_SEARCH_POINT_NAME(pointType, name);

end

function GET_PORTRAIT_NAME(job, gender)

	local jobcls = GetClassByType("Job", job);
	local GenderName = "M";
	if gender == 2 then
		GenderName = "F";
	end

	return jobcls.ClassName .. "_" .. GenderName;

end

function ITEM_EQUIP(index, slotName)

	ITEM_EQUIP_MSG(session.GetInvItem(index), slotName);

end

function ITEM_EQUIP_BY_TYPE(type)

	ITEM_EQUIP_MSG(session.GetInvItemByType(type));

end

function ITEM_EQUIP_BY_ID(iesID)

	ITEM_EQUIP_MSG(session.GetInvItemByGuid(iesID));

end

function GETMYPCLEVEL()

	return info.GetLevel(session.GetMyHandle());

end

function GETMYPCJOB()
	return info.GetJob(session.GetMyHandle());
end

function GETMYPCGENDER()
	return info.GetGender(session.GetMyHandle());
end

function GETMYICON()
	local icon = info.GetIcon(session.GetMyHandle());
	return ui.CaptureModelHeadImage_IconInfo(icon);
end

function GETMYPCNAME()
	local MySession		= session.GetMyHandle()
	local CharName		= info.GetName(MySession);
	return CharName;
end

function CHECK_EQUIPABLE(type)
	local pc = GetMyPCObject();
	local lv = GETMYPCLEVEL();
	local job = GETMYPCJOB();
	local gender = GETMYPCGENDER();
	local prop = geItemTable.GetProp(type);
	
	local ret = prop:CheckEquip(lv, job, gender);
	local haveAbil =  session.IsEquipWeaponAbil(type);
	if ret == 'OK' then
		if 0 ~= haveAbil then
			return ret;
		else
			return 'ABIL'
		end
	else
		if ret == 'LV' or ret == 'GENDER' then
			return ret;
		elseif 0 ~= haveAbil then
			return 'OK'
		end
	end

	return ret;
end

function ITEM_EQUIP_EXCEPTION(item)
	if item == nil then
		return 0
	end
	
	local hairFrame = ui.GetFrame('beauty_hair');
	if hairFrame ~= nil and hairFrame:IsVisible() == 1 then
		ui.SysMsg(ScpArgMsg("Auto_MiyongSil_iyongJungeNeun_aiTemeul_JangChag_Hal_Su_eopSeupNiDa."));
		return 0
	end
			
	local result = CHECK_EQUIPABLE(item.type);
	if result ~= "OK" then
		ui.MsgBox(ITEM_REASON_MSG(result));
		return 0
	end
			
	local obj = GetIES(item:GetObject());
	if obj.IsPrivate == "YES" and obj.Equiped == 0 then
		ui.EnableToolTip(0);
		ui.MsgBox(ScpArgMsg("Auto_HaeDang_aiTemeun_ChagyongSi_KwiSogDoeeo_KeoLaeHal_Su_eopSeupNiDa._ChagyongHaSiKessSeupNiKka?"), strscp, "None");
		return 0;
	end
		
	return 1;
end

function ITEM_EQUIP_MSG(item, slotName)
	
	if 1 ~= ITEM_EQUIP_EXCEPTION(item) then
		return;
	end
		
	if true == BEING_TRADING_STATE() then
		return;
	end
	
	local itemCls = GetIES(item:GetObject());
	if itemCls.EqpType == "HELMET" and slotName == "HAIR" then
		slotName = "HELMET";
	end
	
	local strscp = string.format("item.Equip(%d)", item.invIndex);
	if slotName ~= nil then
		strscp = string.format("item.Equip(\"%s\", %d)", slotName, item.invIndex);
	end

	RunStringScript(strscp);
end

function GET_ITEM_EQUIP_INDEX(item)

	if 1 ~= ITEM_EQUIP_EXCEPTION(item) then
		return 0;
	end

	return item.invIndex;
end

function ITEM_REASON_MSG(msg)
	if msg == "LV" then
		return ScpArgMsg("Auto_LeBeli_BuJogHapNiDa._aiTem_SeolMyeongeSeo_JangChag_KaNeungHan_LeBeleul_HwaginHaSeyo");
	elseif msg == "JOB" then
		return ScpArgMsg("Auto_Chagyong_Hal_Su_issNeun_Jigeopi_aNipNiDa");
	elseif msg == "NOEQUIP" then
		return ScpArgMsg("CanNotItemEquip");
	elseif msg == "GENDER" then
		local gender = GETMYPCGENDER();
		if gender == 1 then
			return ScpArgMsg("Auto_NamSeongeun_ChagyongHal_Su_eopSeupNiDa._aiTem_SeolMyeongeSeo_JangChag_KaNeungHan_SeongByeolKwa_LeBeleul_HwaginHaSeyo");
		else
			return ScpArgMsg("Auto_yeoSeongeun_ChagyongHal_Su_eopSeupNiDa._aiTem_SeolMyeongeSeo_JangChag_KaNeungHan_SeongByeolKwa_LeBeleul_HwaginHaSeyo");
		end
	elseif msg == "ABIL" then
		return ScpArgMsg("EquipWeaponNeedAbility");
	end
end

function GUILD_PTS_TEXT(point, pointName)

	return ScpArgMsg("Auto_uiLoe_KiyeoDo_:_")  .. point;

end

function GET_ICON_BY_NAME(name)

	local cls = GetClass("Item", name);
	return cls.Icon;

end

function MAKE_HAVE_ITEM_TOOLTIP(control, itemType)

	local invItem = session.GetInvItemByType(itemType);
	if invItem ~= nil then
		ICON_SET_INVENTORY_TOOLTIP(control, invItem);
		return;
	end

	local eqpItem = session.GetEquipItemByType(itemType);
	if eqpItem ~= nil then
		ICON_SET_EQUIPITEM_TOOLTIP(control, eqpItem);
		return;
	end

	SET_ITEM_TOOLTIP_ALL_TYPE(control, invItem, invItem.ClassName,'inven', itemType, "");
end

function EXEC_CHATMACRO(index)

	local macro = GET_CHAT_MACRO(index);
	if macro == nil then
		return;
	end
	
	local poseCls = GetClassByType('Pose', macro.poseID);	
	if poseCls ~= nil then
		control.Pose(poseCls.ClassName);
	end

	if macro.macro == "" then
		return;
	end

	ui.Chat(REPLACE_EMOTICON(macro.macro));
end

function GET_CHAT_MACRO(index)

	local list = session.GetChatMacroList();
	local cnt = list:Count();
	for i = 0 , cnt - 1 do
		local info = list:PtrAt(i);
		if info.index == index then
			return info;
		end
	end

	return nil;
end

function SET_BUFF_TOOLTIP_BY_NAME(ctrl, name)

	local cls = GetClass("Buff", name);
	ctrl:SetTooltipType('buff');
	ctrl:SetTooltipArg(0, cls.ClassID, "");

end

function SET_ITEM_TOOLTIP_BY_NAME(ctrl, name)

	local cls = GetClass("Item", name);
	SET_ITEM_TOOLTIP_BY_TYPE(ctrl, cls.ClassID)

end

function SET_ITEM_TOOLTIP_BY_TYPE(ctrl, type)

	SET_ITEM_TOOLTIP_TYPE(ctrl, type);
	ctrl:SetTooltipArg('inven', type, "");
end

function SET_ITEM_TOOLTIP_BY_OBJ(icon, invItem)
	local itemCls = GetIES(invItem:GetObject());
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, invItem, itemCls.ClassName, 'inven', itemCls.ClassID, invItem:GetIESID());
end

function ON_RULLET_LIST()

	local list = session.GetRulletList();
	local cnt = list:Count();

	for i = 0 , cnt - 1 do
		SHOW_RULLET_INFO(list:Element(i), i, cnt);
	end

end

function UI_CHECK_NOT_PVP_MAP()
	if world.IsPVPMap() or session.colonywar.GetIsColonyWarMap() == true then
		return 0;
	end

	return 1;
end

function UI_CHECK_PROP(propname, propvalue)

	local pc = GetMyPCObject();
	if pc[propname] == propvalue then
		return 1;
	end

	return 0;

end

function UI_CHECK_GRIMOIRE_UI_OPEN(propname, propvalue)
	local jobcls = GetClass("Job", 'Char2_6');
	local jobid = jobcls.ClassID

	if IS_HAD_JOB(jobid) == 1 then
		return 1
	end

	return 0;
end

function UI_CHECK_PARTY()

	local party = session.party.GetPartyInfo();
	if party == nil then
		return 0;
	end
	return 1;

end

function COPY_TOOLTIP_INFO(a, b)

	local type = a:GetTooltipType();
	local strArg = a:GetTooltipStrArg();
	local numArg = a:GetTooltipNumArg();
	local iesID = a:GetTooltipIESID();

	b:SetTooltipType(type);
	b:SetTooltipArg(strArg, numArg, iesID);

end

function LIMIT_TXT(text, maxLen)

	local strLen = string.len(text);
	if strLen < maxLen then
		return text;
	end

	return string.sub(text, 1, maxLen) .. "..";

end

function UP_SUB_STRING(str, s, e)

	local strLen = string.len(str);
	local a = string.sub(str, 1, s - 1);
	local b = string.sub(str, s, e);
	local c = string.sub(str, e + 1, strLen);
	b = string.upper(b);
	return a .. b .. c;

end

function ST()
	return GetServerAppTime();
end

function PRINT_TIME(name, time, totaltime)

	local st = ST();
	return time;

end

function SET_ADVBOX_BTN(advBox, key, col, text)

	local width = advBox:GetColWidth(col) - 10;
	local height = advBox:GetHeightperrow();
	local item = advBox:SetItemByType(key, col, "button",  width, height, 0);
	item:SetText(text);
	return item;
end

function SET_ADVBOX_ITEM_C(advBox, key, col, text, font, alignTextToCenter)
	local item = advBox:SetItem(key, col, text, font);
	if alignTextToCenter == 1 then
		item:SetTextAlign("center", "center");
	end

	FIXWIDTH_ADVBOX_ITEM(advBox, col, item);
	return item;
end

function SET_ADVBOX_ITEM(advBox, key, col, text, font)
	local item = advBox:SetItem(key, col, text, font);
	if item ~= nil then
		FIXWIDTH_ADVBOX_ITEM(advBox, col, item);
		item:SetTextAlign("left", "center");
	end
	return item;
end

function FIXWIDTH_ADVBOX_ITEM(advBox, col, item)
	tolua.cast(item, "ui::CRichText");
	item:SetTextFixWidth(1);
	local width = advBox:GetColWidth(col);
	item:SetTextMaxWidth(width - 20);
	item:Resize(width - 20, 	advBox:GetHeightperrow());
end

function ADVBOX_OMIT_TEXT(advBox, col, item)

	local width = advBox:GetColWidth(col);
	tolua.cast(item, "ui::CRichText");
	item:Resize(width, 	advBox:GetHeightperrow());

end

function GET_LEN(a, b)
	return math.pow( math.pow(a, 2) + math.pow(b, 2), 0.5);
end


function FIND_ADVBOX_ITEM(advBox, findText, col)

	local currow = advBox:GetNumber();
	if currow  < 0 then
		currow = 1;
	end

	local cnt = advBox:GetRowItemCnt();
	local row = currow + 1;

	while 1 do

		if row == currow then
			break;
		end

		local name = advBox:GetObjectXY(row, col):GetText();
		if string.find(name, findText) ~= nil then
			advBox:SetCuritemIndex(row, row - 2);
			advBox:FocusToSelect();
			return 1;
		end

		row = row + 1;
		if row >= cnt then
			row = 1;
		end

	end

	return 0;
end

function SET_SELECT_PARENT_ADVBOX(item, key)
	item:EnableHitTest(1);
	item:SetEventScript(ui.LBUTTONDOWN, "SELECT_ADVBOX_BY_KEY");
	item:SetEventScriptArgString(ui.LBUTTONDOWN, key);
	item:SetEventScript(ui.RBUTTONDOWN, "SELECT_ADVBOX_BY_KEY");
	item:SetEventScriptArgString(ui.RBUTTONDOWN, key);
end

function SELECT_ADVBOX_BY_KEY(advBox, ctrl, propName, num)

	tolua.cast(advBox, "ui::CAdvListBox");
	advBox:SelectItemByKey(propName);

end

function MSGBOX_EDIT_PROP_ITEM(advBox, ctrl, propName, num)

	local idSpace = advBox:GetSValue();
	local clsID = advBox:GetValue();
	local cls = GetClassByType(idSpace, clsID);
	local curValue = cls[propName];

	local execScp = ctrl:GetSValue();
	local sframe = INPUT_STRING_BOX(ScpArgMsg("Auto_ByeonKyeongHal_Kapeul_ipLyeogHaSeyo."), execScp, curValue, 0, 512);
	local frame = advBox:GetTopParentFrame();
	sframe:SetSValue(frame:GetName());
	sframe:SetEventScriptArgString(ui.LBUTTONDOWN, advBox:GetName());

	if num == 1 then
		local edit = GET_CHILD(sframe, 'input', "ui::CEditControl");
		edit:SetEnableEditTag(0);
	end
end


function APPLY_MSGBOX_EDIT_PROP(inputframe, ctrl)

	if ctrl:GetName() == "inputstr" then
		inputframe = ctrl;
	end

	local txt = GET_INPUT_STRING_TXT(inputframe);
	local frameName = inputframe:GetSValue();
	local uiName = inputframe:GetEventScriptArgString(ui.LBUTTONDOWN);

	local frame = ui.GetFrame(frameName);
	local advBox = GET_CHILD(frame, uiName, "ui::CAdvListBox");

	local idSpace = advBox:GetSValue();
	local clsID = advBox:GetValue();
	local propName = advBox:GetSelectedKey();
	if propName == "ClassName" then
		if nil ~= GetClass(idSpace, txt) then
			ui.MsgBox(ScpArgMsg("Auto_iMi_JonJaeHaNeun_ClassNameipNiDa"));
		end
	end

	local cls = GetClassByType(idSpace, clsID);

	local item = advBox:GetObjectByKey(propName, 1);
	item:SetText(txt);

	dtool.ChangeIESEntry(idSpace, clsID, propName, txt);
	inputframe:ShowWindow(0);

	FIXWIDTH_ADVBOX_ITEM(advBox, 1, item);
	advBox:UpdateAdvBox();

	return idSpace, clsID;

end



function FIND_ITEM_BY_NAME(frame, edit, str, num)

	tolua.cast(edit, "ui::CEditControl");
	if edit:IsHaveFocus() == 0 then
		return;
	end

	local advBox = GET_CHILD(frame, str, "ui::CAdvListBox");
	local input = edit:GetText();

	FIND_ADVBOX_ITEM(advBox, input, num);

end

function GET_MONEY_TAG_TXT(itemCnt)

	itemCnt = math.abs(itemCnt);
	return ScpArgMsg("Auto_{ol}{@st45}BatKe_Doel_SilBeo_:_{Auto_1}_{img_Zeny_20_20}","Auto_1", GetCommaedText(itemCnt))

end

function GET_BUFF_TAG_TXT(buffName)

	local cls = GetClass("Buff", buffName);
	if cls == nil then
		ui.SysMsg(buffName .. " Buff Not Exist");
		return "";
	end
	local icon = cls.Icon;

	return ScpArgMsg("Auto_{img_{Auto_1}_20_20}{ol}{@st45}_{Auto_2}_BeoPeu","Auto_1", 'icon_'..cls.Icon,"Auto_2", cls.Name)

end
function GET_PCPROPERTY_TAG_TXT(propertyName, value)
    local ret, propertyTxt
    if propertyName == 'STR' then
        propertyTxt = ScpArgMsg("STR")
    elseif propertyName == 'DEX' then
        propertyTxt = ScpArgMsg("DEX")
    elseif propertyName == 'CON' then
        propertyTxt = ScpArgMsg("CON")
    elseif propertyName == 'INT' then
        propertyTxt = ScpArgMsg("INT")
    elseif propertyName == 'MSTA' then
        propertyTxt = ScpArgMsg("MSTA")
    elseif propertyName == 'MHP' then
        propertyTxt = ScpArgMsg("MHP")
    elseif propertyName == 'MSP' then
        propertyTxt = ScpArgMsg("MSP")
    elseif propertyName == 'MaxWeight' then
        propertyTxt = ScpArgMsg("MaxWeight")
	elseif propertyName == 'MNA' then
        propertyTxt = ScpArgMsg("MNA")
    else
        propertyTxt = propertyName
    end
    
    ret = ScpArgMsg("QuestRewardPCPropertyText1","Auto_1", propertyTxt,"Auto_2", value)
    
    return ret
end

function GET_HONOR_TAG_TXT(honor, point_value)

	local cls = GetClass("AchievePoint", honor);
	local ret
	point_value = tonumber(point_value)
	if point_value == nil or point_value <= 1 then
	    ret = '{ol}{@st45w3}{s18}'..cls.Name
	else
	    ret = ScpArgMsg("Auto_{ol}{@st45tw}{Auto_1}_:_{Auto_2}_Jeom","Auto_1", cls.Name,"Auto_2", point_value)
	end
	
	local clslist, cnt  = GetClassList("Achieve");
	for i = 0 , cnt - 1 do
		local cls2 = GetClassByIndexFromList(clslist, i);
		if cls2.NeedPoint == honor and cls2.NeedCount <= point_value  then
			ret = ScpArgMsg("RepeatRewardAchieve")..'{@st41b}'..cls2.Name
			break
		end
	end
	
	return ret

end

function GET_ITEM_TAG_TXT(itemName, itemCnt)

	local cls = GetClass("Item", itemName);
	local icon = cls.Icon;

	itemCnt = math.abs(itemCnt);
	return string.format("{img %s 20 20}{ol}{@st45} %d", cls.Icon, itemCnt)

end

function FILL_ALL_ITEM_ADV_BOX(frame, boxName)

	local advBox = GET_CHILD(frame, boxName, "ui::CAdvListBox");
	advBox:ClearUserItems();

	local clslist, cnt  = GetClassList("Item");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		local key = cls.ClassID;
		SET_ADVBOX_ITEM_INFO(advBox, key, 0, cls);
	end

	advBox:UpdateAdvBox();

end

function SET_ADVBOX_ITEM_INFO(advBox, key, col, cls)

	local txt = GET_ITEM_TAG_TXT(cls.ClassName, 1);
	local item = SET_ADVBOX_ITEM(advBox, key, col, txt, "white_12_ol");
	item:EnableHitTest(1);
	--SET_ITEM_TOOLTIP_BY_NAME(item, cls.ClassName);

	item:SetDragFrame("textdrag");
	item:SetDragScp("START_DRAG_ITEM");
	item:SetTooltipNumArg(key);

end

function SET_FRAME_ARGSTR(frame, advBox, str, num)
	tolua.cast(advBox, "ui::CAdvListBox");
	frame:SetSValue(advBox:GetSelectedKey());
end

function SET_FRAME_ARGNUM(frame, advBox, str, num)
	tolua.cast(advBox, "ui::CAdvListBox");
	frame:SetValue(advBox:GetSelectedKey());
end

function POPUP_ITEM_SEL(scpName)

	local frame = ui.GetFrame("itemselpopup");
	ITEM_SEL_INIT(frame, scpName);

end

function GET_POPUP_SEL_ITEM()

	local frame = ui.GetFrame("itemselpopup");
	local ItemList = GET_CHILD(frame, "ItemList", "ui::CAdvListBox");
	local clsID = tonumber(ItemList:GetSelectedKey());
	if clsID == nil then
		return  nil;
	end

	return GetClassByType("Item", clsID);

end

function IS_CLEAR_SLOT_ITEM_INFO(slot)
	return slot:GetIcon();
end

function CLEAR_SLOT_ITEM_INFO(slot)
	slot:ClearIcon();
	slot:SetText("", 'count', 'right', 'bottom', -2, 1);
end

function GET_SOLDITEM_BY_INDEX(index)

	index = tonumber(index);
	local list = session.GetSoldItemList();
	if 0 == list:IsValidIndex(index) then
		return nil;
	end

	return list:Element(index);
end

function ADD_QUEST_CHECK_MONSTER(questID, monname)

	if questID == -1 then
		-- GuildQuest
		return;
	end

    local pc = GetMyPCObject()
    local questIES = GetClassByType('QuestProgressCheck', questID)

    if questIES.Succ_Kill_Layer == 'Layer' and GetLayer(pc) == 0 then
        return
    end

	local cutStr = SCR_STRING_CUT(monname);
	if #cutStr > 1 then
		for i = 1 , #cutStr do
			quest.AddCheckQuestMonsterList(questID, cutStr[i]);
		end
	else
		quest.AddCheckQuestMonsterList(questID, monname);
	end
end

function ADD_QUEST_CHECK_DROPITEM(questID, monname)
	quest.AddCheckQuestDropItemList(questID, monname);
end

function REMOVE_QUEST_CHECK_DROPITEM(questID, monname)
	quest.RemoveCheckQuestDropItemList(questID, monname);
end

function FIELD_EVENT_JOIN(frame)
	local stat = info.GetStat(session.GetMyHandle());
	if stat.HP > 0 then
		local clsID = frame:GetValue();
		packet.ReqJoinFieldEvent(clsID);
	end
end

function UPDATE_TARGET_ITEM_TOOLTIP(tooltipframe, strarg, numarg1, numarg2)

end

function DESTROY_FRAME(name)
	ui.DestroyFrame(name);
end

function START_RESIZE_PARENT(frame, ctrl, str, num)

	local tframe = frame:GetTopParentFrame();
	if tframe == nil then
		return;
	end

	tolua.cast(tframe, "ui::CFrame");
	tframe:StartResize(6);

end

function OPEN_COLORSELECT_DLG(targetScp, initColor, x, y)

	local frame = ui.GetFrame("selectcolor");
	frame:SetSValue(targetScp);

	local selectedColor = GET_CHILD(frame, "selectedColor", "ui::CPicture");
	selectedColor:FillClonePicture(initColor);
	frame:ShowWindow(1);
	ui.SetTopMostFrame(frame);

	if x ~= nil then
		frame:MoveIntoClientRegion(x, y);
	end

end

function GET_SELECTED_COL()

	local frame = ui.GetFrame("selectcolor");
	local selectedColor = GET_CHILD(frame, "selectedColor", "ui::CPicture");
	local curColor = selectedColor:GetPixelColor(1, 1);
	return curColor;
end

function GET_MOUSE_POS()

	local x = mouse.GetX();
	local y = mouse.GetY();

	return x, y;
end

function SCR_ITEM_ENTER_EFFECT(itemObj, handle, itemType)
	local enterEffectName = 'None';
	local invitem = GetClassByType("Item", itemType);

	if invitem ~= nil and invitem.GroupName == "Money" then
		return "F_coin_effect";
	end

	if invitem ~= nil then
		local ToolTipScp = _G['ITEM_ENTER_COMMON_EFFECT'];

		if invitem.ToolTipScp == 'WEAPON' or invitem.ToolTipScp == 'ARMOR' then
			if invitem.EqpType == 'SH' then
				if GetClassString('Item', invitem.ClassName, 'DefaultEqpSlot') == 'RH' then
					local item = session.GetEquipItemBySpot(item.GetEquipSpotNum("RH"));
					local equipItem = GetIES(item:GetObject());
					enterEffectName = ToolTipScp(invitem, equipItem, strarg);
				elseif GetClassString('Item', invitem.ClassName, 'DefaultEqpSlot') == 'LH' then
					local item = session.GetEquipItemBySpot(item.GetEquipSpotNum("LH"));
					local equipItem = GetIES(item:GetObject());
					enterEffectName = ToolTipScp(invitem, equipItem, strarg);
				end
			elseif invitem.EqpType == 'DH' then
				local item = session.GetEquipItemBySpot(item.GetEquipSpotNum("RH"));
				local equipItem = GetIES(item:GetObject());
				enterEffectName = ToolTipScp(invitem, equipItem, strarg);
			else
				local equitSpot = item.GetEquipSpotNum(invitem.EqpType);
				local item = session.GetEquipItemBySpot(equitSpot);
				if item ~= nil then
					local equipItem = GetIES(item:GetObject());
					enterEffectName = ToolTipScp(invitem, equipItem, strarg);
				end
			end
		end
	end

	return enterEffectName;
end

function ITEM_ENTER_COMMON_EFFECT(invitem, equipItem, strarg)
--	if equipItem.Icon ~= 'icon_item_nothing' then
--
--		local propList = GET_COMPARE_PROP_LIST(invitem);
--		local valueUp = 0;
--		if ITEM_BETTER_THAN(invitem, equipItem) then
--			valueUp = 1;
--		else
--			local equipAbilityTotal = GET_SUM_OF_PROP(equipItem, propList);
--			local invAbilityTotal = GET_SUM_OF_PROP(invitem, propList);
--
--			if ABILITY_COMPARITION_VALUE(invAbilityTotal, equipAbilityTotal) < 0 then
--				valueUp = 1;
--			end
--		end
--
--		if valueUp == 1 then
--			return 'item_effect_green';
--		else
--			return 'item_effect_red';
--		end
--	else
--		local invAbilityTotal = GET_SUM_OF_PROP(invitem, propList);
--		if invAbilityTotal > 0 then
--			return 'item_effect_green';
--		else
--			return 'item_effect_red';
--		end
--	end

    return 'F_item_drop_violet';
end

function SCR_ITEM_FIELD_TOOLTIP(itemObj, handle, itemType)
	-- ????
end

function USE_ITEMTARGET_ICON(frame, itemobj, argNum)
	local stat = info.GetStat(session.GetMyHandle());
	if stat.HP <= 0 then
		return;
	end
	if itemobj.ClassName == "Drug_Socket" then

		local invItemList = session.GetInvItemList();
		local index = invItemList:Head();
		local itemCount = session.GetInvItemList():Count();

		for i = 0, itemCount - 1 do
			local invItem = invItemList:Element(index);

			if invItem ~= nil then

				local slot = INV_GET_SLOT_BY_ITEMGUID(invItem:GetIESID())
				tolua.cast(slot, "ui::CSlot");

				local icon 		= slot:GetIcon();

				if icon ~= nil then
					local class     = GetClassByType('Item', invItem.type);
					local invitem = GET_TOOLTIP_ITEM_OBJECT('inven', invItem:GetIESID());
					local socketCnt = GET_SOCKET_CNT(invitem);
					local maxcnt = 0;
					if invitem.ItemType == 'Equip' then
						maxcnt = invitem.MaxSocket;
					end
					if invitem.ToolTipScp ~= 'WEAPON' and invitem.ToolTipScp ~= 'ARMOR' or socketCnt == maxcnt then
						slot:Select(0);
					else
						slot:Select(1);
					end
				end
			end

			index = invItemList:Next(index);
		end

		local statusFrame = ui.GetFrame('status');
		local curChildIndex = 0;
		local equipItemList = session.GetEquipItemList();
		for i = 0, equipItemList:Count() - 1 do
			local equipItem = equipItemList:Element(i);
			local spotName = item.GetEquipSpotName(equipItem.equipSpot);

			if  spotName  ~=  nil  then
				local child = statusFrame:GetChild(spotName);
				local slot = tolua.cast(child, 'ui::CSlot');
				if  child  ~=  nil  then
					if  equipItem.type  ~=  item.GetNoneItem(equipItem.equipSpot)  then
						local equipItemObj = GetIES(equipItem:GetObject());
						local socketCnt = GET_SOCKET_CNT(equipItemObj);
						local maxcnt = equipItemObj.MaxSocket;

						if equipItemObj.ToolTipScp ~= 'WEAPON' and equipItemObj.ToolTipScp ~= 'ARMOR' or socketCnt == maxcnt then
							slot:Select(0);
						else
							slot:Select(1);
						end
					end
				end
			end
		end
	elseif itemobj.ClassName == "Drug_Reinforce" then

		local invItemList = session.GetInvItemList();
		local index = invItemList:Head();
		local itemCount = session.GetInvItemList():Count();

		for i = 0, itemCount - 1 do
		
			local invItem = invItemList:Element(index);
			if invItem ~= nil then

				local slot = INV_GET_SLOT_BY_ITEMGUID(invItem:GetIESID())
				tolua.cast(slot, "ui::CSlot");
				local icon 		= slot:GetIcon();

				if icon ~= nil then
					local class     = GetClassByType('Item', invItem.type);
					local invitem  = GET_TOOLTIP_ITEM_OBJECT('inven', invItem:GetIESID());

					if invitem.ItemType == 'Equip' then
						local potential = invitem.PR;
						if invitem.ToolTipScp ~= 'WEAPON' and invitem.ToolTipScp ~= 'ARMOR' or potential <= 0 then
							slot:Select(0);
						else
							slot:Select(1);
						end
					end
				end
			end

			index = invItemList:Next(index);
		end

		local statusFrame = ui.GetFrame('status');
		local curChildIndex = 0;
		local equipItemList = session.GetEquipItemList();
		for i = 0, equipItemList:Count() - 1 do
			local equipItem = equipItemList:Element(i);
			local spotName = item.GetEquipSpotName(equipItem.equipSpot);

			if  spotName  ~=  nil  then
				local child = statusFrame:GetChild(spotName);
				local slot = tolua.cast(child, 'ui::CSlot');
				if  child  ~=  nil  then
					if  equipItem.type  ~=  item.GetNoneItem(equipItem.equipSpot)  then
						local equipItemObj = GetIES(equipItem:GetObject());

						local potential = equipItemObj.PR;
						if equipItemObj.ToolTipScp ~= 'WEAPON' and equipItemObj.ToolTipScp ~= 'ARMOR' or potential <= 0 then
							slot:Select(0);
						else
							slot:Select(1);
						end
					end
				end
			end
		end


	elseif itemobj.GroupName == "Gem" then
							
		local invItemList = session.GetInvItemList();
		local index = invItemList:Head();
		local itemCount = session.GetInvItemList():Count();

		local cnt = 0;
		for i = 0, itemCount - 1 do
			local invItem = invItemList:Element(index);
			local invitem = GET_TOOLTIP_ITEM_OBJECT('inven', invItem:GetIESID());
			if invItem ~= nil and false == geItemTable.IsMoney(invItem.type) and invitem.ItemType == "Equip" then
				local tab = GET_CHILD_RECURSIVELY(frame, "inventype_Tab")
				tolua.cast(tab, "ui::CTabControl");
				tab:SelectTab(1);

				local slot = INV_GET_SLOT_BY_ITEMGUID(invItem:GetIESID())
				tolua.cast(slot, "ui::CSlot");
				if slot ~= nil then
					local icon = slot:GetIcon();
					if icon ~= nil then
						local class     = GetClassByType('Item', invItem.type);
						
						local socketCnt = GET_SOCKET_CNT(invitem);

							for i=0, socketCnt do
								local temp = GetIESProp(invitem, 'Socket_Equip_'..i);
								if temp == 0 then
									socketNum = i;
									break;
								end
							end

							if socketCnt > socketNum then
								slot:Select(1);
							else
								slot:Select(0);
							end
					end
					cnt = cnt + 1;
				end
			end

			index = invItemList:Next(index);
		end

		local statusFrame = ui.GetFrame('status');
		local curChildIndex = 0;
		local equipItemList = session.GetEquipItemList();
		for i = 0, equipItemList:Count() - 1 do
			local equipItem = equipItemList:Element(i);
			local spotName = item.GetEquipSpotName(equipItem.equipSpot);

			

			if  spotName  ~=  nil  then
	
				local slot = GET_CHILD_RECURSIVELY(frame, spotName, "ui::CSlot")

				if  slot  ~=  nil  then

				slot:SetSelectedImage('socket_slot_check')

					if  equipItem.type  ~=  item.GetNoneItem(equipItem.equipSpot)  then
						local equipItemObj = GetIES(equipItem:GetObject());
						local socketCnt = GET_SOCKET_CNT(equipItemObj);

						for i=0, socketCnt do
							local temp = GetIESProp(equipItemObj, 'Socket_Equip_'..i);
							if temp == 0 then
								socketNum = i;
								break;
							end
						end

						if socketCnt > socketNum then
							slot:Select(1);
						else
							slot:Select(0);
						end
					end
				end
			end
		end
	end

	if itemobj.GroupName == "Gem" then
		local yesscp = string.format("USE_ITEMTARGET_ICON_GEM(%d)", argNum);
		ui.MsgBox(ClMsg("GemHasPenaltyLater"), yesscp, "None");
		return;
	end
	item.SelectTargetItem(argNum);
end

function USE_ITEMTARGET_ICON_GEM(argNum)
	local invFrame     	= ui.GetFrame("inventory");
	local invGbox		= invFrame:GetChild('inventoryGbox');
	local tab = invGbox:GetChild("inventype_Tab");
	tolua.cast(tab, "ui::CTabControl");
	tab:SelectTab(1);
	item.SelectTargetItem(argNum)
end

function SCR_ITEM_USE_TARGET_RELEASE()
	local frame				= ui.GetFrame('inventory');	
	INVENTORY_UPDATE_ICONS(frame);

	local frame 			= ui.GetFrame('status');
	STATUS_ON_MSG(frame, 'EQUIP_ITEM_LIST_GET', 'None', 0);
end

function SCR_GEM_ITEM_SELECT(argNum, luminItem, frameName)

	-- get inventory item
	local invitem = nil;
	if frameName == 'inventory' then
		invitem = session.GetInvItem(argNum);		
	else
		invitem = session.GetEquipItemBySpot(argNum);
	end
	if invitem == nil then
		return;
	end

	-- get item object
	local itemobj = GetIES(invitem:GetObject());
	if itemobj == nil then
		return
	end

	-- get total / empty socket count
	local socketCnt = GET_SOCKET_CNT(itemobj);
	if socketCnt == 0 then
		ui.SysMsg(ScpArgMsg("NOT_HAVE_SOCKET_SPACE"))
		return;
	end
	local emptyCnt = GET_EMPTY_SOCKET_CNT(socketCnt, itemobj)
	if emptyCnt < 1 then
		ui.SysMsg(ScpArgMsg("Auto_SoKaeseopKeoNa_JeonBu_SayongJungiDa"))
		return
	end

	-- 몬스?�젬�?중복검??
	local gemClass = GetClassByType("Item", luminItem.type)
	if gemClass ~= nil then
		local gemEquipGroup = TryGetProp(gemClass, "EquipXpGroup")
		if gemEquipGroup == 'Gem_Skill' then
			if IS_SAME_TYPE_GEM_IN_ITEM(itemobj, luminItem.type, socketCnt) then
				local ret = true
				local invFrame = ui.GetFrame(frameName)
				invFrame:SetUserValue("GEM_EQUIP_ITEM_ID", luminItem:GetIESID())
				invFrame:SetUserValue("GEM_EQUIP_TARGET_ID", invitem:GetIESID())

				if frameName == 'inventory' then
					ui.MsgBox(ScpArgMsg("GEM_EQUIP_SAME_TYPE"), "GEM_EQUIP_TRY", "None")
				elseif frameName == 'status' then
					ui.MsgBox(ScpArgMsg("GEM_EQUIP_SAME_TYPE"), "GEM_EQUIP_TRY_STATUS", "None")
				end
				return
			end
		end
	end

	if IS_ENABLE_EQUIP_GEM(itemobj, gemClass.ClassID) == false then
		ui.SysMsg(ScpArgMsg("ValidDupEquipGemBy{VALID_CNT}", "VALID_CNT", VALID_DUP_GEM_CNT));
		return;
	end

	local cnt = 0;
	for i = 0 , socketCnt - 1 do
		local socketName = "SOCKET_" .. i;
		local skttype = itemobj["Socket_" .. i];
		local socketCls = GetClassByType('Socket', skttype);

		if socketCls ~= nil then
			break;
		else
			cnt = cnt + 1;
		end
	end
	item.UseItemToItem(luminItem:GetIESID(), invitem:GetIESID(), cnt);
end

function GEM_EQUIP_TRY_STATUS()
	local invFrame = ui.GetFrame('status')
	local fromItem = invFrame:GetUserValue("GEM_EQUIP_ITEM_ID")
	local toItem = invFrame:GetUserValue('GEM_EQUIP_TARGET_ID')
	item.UseItemToItem(fromItem, toItem, 0);
end

function GEM_EQUIP_TRY()
	local invFrame = ui.GetFrame('inventory')
	local fromItem = invFrame:GetUserValue("GEM_EQUIP_ITEM_ID")
	local toItem = invFrame:GetUserValue('GEM_EQUIP_TARGET_ID')
	item.UseItemToItem(fromItem, toItem, 0);
end

function ENABLE_CTRL(ctrl, isEnable)

	ctrl:SetEnable(isEnable);
	if isEnable == 0 then
		ctrl:SetGrayStyle(1);
	else
		ctrl:SetGrayStyle(0);
	end

end

function PUSH_CHAT_FRAME(eftName)

	ui.ShowUnFocusedChatFrames(0);
	local chatFrame = GET_CHATFRAME();
	chatFrame:ShowWindow(1);
	chatFrame:EndEffect(5);
	--chatFrame:SetEffect(eftName, 5);
	--chatFrame:StartEffect(5);
	--chatFrame:SetEffect('ringcommandMove', 6);
	local pullEffect = chatFrame:GetEffectByIndex(6);
	pullEffect:SetDestMovePos(chatFrame:GetX(), chatFrame:GetY(), 1.0, 0.0);
end

function PULL_CHAT_FRAME(eftName)

	local chatFrame = GET_CHATFRAME();
	chatFrame:EndEffect(5);
	chatFrame:StartEffect(6);
	ui.ShowChatFrames(1);

end

function IS_VISIBLE(name)

	local fr = ui.GetFrame(name);
	if fr == nil then
		return 0;
	end

	return fr:IsVisible();

end

function GET_MY_PCNAME()
	local MySession		= session.GetMyHandle()
	local CharName		= info.GetName(MySession);
	return CharName;
end

function WIKI_ALLTROPHY_SLOT_DESTROY(frame)
	DESTROY_CHILD_BYNAME(frame, 'WIKI_SLOT');
end

function WIKI_ALLTROPHY_SLOT_HIDE(frame)
	HIDE_CHILD_BYNAME(frame, 'WIKI_SLOT');
end


function OPEN_FILE_FIND(dirName, scpName, isSaveMode, findStr)

	local frame = ui.GetFrame("filefind");
	FILE_FIND_BINDIR(frame, dirName, scpName, isSaveMode, findStr);
	frame:ShowWindow(1);

end

function CREATE_TIMER_CTRLS(frame, creX, creY)

	local getset = frame:GetChild("SET");
	if getset ~= nil then
		return getset;
	end

	local ctrlset = frame:CreateControlSet('emptyset', "SET", creX, creY);
	tolua.cast(ctrlset, 'ui::CControlSet');
	ctrlset:Resize(300, 80);

	local y = 40;

	local txt = ctrlset:CreateControl("richtext", "commatext", 70, y + 5, 100, 100);
	txt:SetText("{s22}:{/}");

	local m1time = ctrlset:CreateControl('picture', "m1time", 10, y, 28, 38);
	local m2time = ctrlset:CreateControl('picture', "m2time", 40, y, 28, 38);
	local s1time = ctrlset:CreateControl('picture', "s1time", 80, y, 28, 38);
	local s2time = ctrlset:CreateControl('picture', "s2time", 110, y, 28, 38);

	tolua.cast(m1time, "ui::CPicture");
	m1time:SetImage("time_0");

	return ctrlset;

end

function TIMER_SET_EVENTTIMER(frame, remainSec)

	local timer = frame:GetChild("addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");

	timer:SetUpdateScript("EVENT_UPDATE_TIME");
	timer:SetArgNum(remainSec);
	timer:Start(0.15);
end

function EVENT_UPDATE_TIME(frame, ctrl, str, totalSec, elapsedSec)

	local remainSec = totalSec - elapsedSec;

	if remainSec < 0 then
		ctrl:Stop();
		frame:ShowWindow(0);
		return;
	end

	local ctrlset = GET_CHILD(frame, "SET", "ui::CControlSet");

	if remainSec > 86400 then
		local min, sec = GET_QUEST_MIN_SEC(remainSec / 3600);
		SET_QUESTINFO_TIME_TO_SET(min, sec, ctrlset);
	elseif remainSec > 3600 then
		local min, sec = GET_QUEST_MIN_SEC(remainSec / 60);
		SET_QUESTINFO_TIME_TO_SET(min, sec, ctrlset);
	else
		local min, sec = GET_QUEST_MIN_SEC(remainSec);
		SET_QUESTINFO_TIME_TO_SET(min, sec, ctrlset);
	end


	ctrlset:Invalidate();

end

function SCR_QUEST_CHECK_T(pc, questname)
	local result, reason = SCR_QUEST_CHECK(pc, questname);
	local reasonString = "";
	if reason ~= nil then
		for j = 1 , #reason do
			reasonString = reasonString .. reason[j];
			if j ~= #reason then
				reasonString = reasonString .. "#";
			end
		end
	end

	return result, reasonString;
end

function SCR_QUEST_CHECK_C(pc, questname)
	local questState = GetQuestState(questname);
	if "PROGRESS" == questState then -- 진행중일?? ?�션?�브?�트???�로 ?�인?�보?�록 ?�자.
	-- 마법?�회 ?�스?��? 갱신???��? ?�기?�문??
		local questIES = GetClass('QuestProgressCheck', questname);
		local sObj_quest = GetSessionObject(pc, questIES.Quest_SSN);
		if nil ~= sObj_quest then
			local Succ_req_SSNInvItem, ssnInvItemCheck = SCR_QUEST_SUCC_CHECK_MODULE_SSNINVITEM(pc, questIES, sObj_quest);
			if 'YES' == Succ_req_SSNInvItem then
				return SCR_QUEST_CHECK(pc, questname);
			end
		end
	end
	return questState;
end


function OPEN_SHOPUI_COMMON()

	HIDE_LEFTBASE_UI();

	local invenFrame = ui.GetFrame('inventory');
	if invenFrame:IsVisible() == 0 then
		invenFrame:ShowWindow(1);
	end

end

function HIDE_LEFTBASE_UI()

	local statusFrame = ui.GetFrame('status');
	if statusFrame:IsVisible() == 1 then
		statusFrame:ShowWindow(0);
	end

	local questFrame = ui.GetFrame('quest');
	if questFrame:IsVisible() == 1 then
		questFrame:ShowWindow(0);
	end

end

function HIDE_RIGHTBASE_UI()
	local minimapFrame = ui.GetFrame('minimap');

	minimapFrame:ShowWindow(0);

	local statusFrame = ui.GetFrame('status');

	if statusFrame:IsVisible() == 0 then
		local questInfoFrame = ui.GetFrame('questinfoset_2');

		--questInfoFrame:EndEffect(5);
		--questInfoFrame:SetEffect('questInfoSkillMoving', 5);
		--questInfoFrame:StartEffect(5);
	end

end


function SHOW_RIGHTBASE_UI()

	local minimapFrame = ui.GetFrame('minimap');
	minimapFrame:ShowWindow(1);

	local questInfoFrame = ui.GetFrame('questinfoset_2');
	--questInfoFrame:EndEffect(5);
	--questInfoFrame:SetEffect('questInfoSkillBackMoving', 5);
	--questInfoFrame:StartEffect(5);

end

function CHATFRAME_LEFTPIC_LBTNUP(frame, ctrl, argStr, argNum)
	tolua.cast(frame, "ui::CChatFrame");
	local pageIndex = frame:GetPageIndex();
	frame:SetPageIndex(pageIndex - 1);
end

function CHATFRAME_RIGHTPIC_LBTNUP(frame, ctrl, argStr, argNum)
	tolua.cast(frame, "ui::CChatFrame");
	local pageIndex = frame:GetPageIndex();
	frame:SetPageIndex(pageIndex + 1);
end

function SET_IMAGE_HITTEST(ctrl, img)
	ctrl:SetImage(img);
	ctrl:SetEnableStretch(1);
	ctrl:ShowWindow(1);
	ctrl:EnableHitTest(1);
end

function ACHIEVE_EQUIP(frame, ctrl, argStr, argNum)
	session.EquipAchieve(argNum);
end


function HAVE_ACHIEVE_FIND(achieveType)
	local list = session.GetAchieveList();
	local cnt = list:Count();

	for i = 0 , cnt - 1 do
		local type = list:Element(i);

		if type == achieveType then
			return 1;
		end
	end

	return 0;
end

function GET_ACHIEVE_COUNT(exceptPeriodAchieve)
	local list = session.GetAchieveList();
	local cnt = list:Count();
	local noPeriodAchieveCnt = 0

	for i = 0 , cnt - 1 do
		local classID = list:Element(i)
		local cls = GetClassByType("Achieve", classID)

		if cls.PeriodAchieve == 'NO' then
			noPeriodAchieveCnt = noPeriodAchieveCnt + 1
		end
	end

	if exceptPeriodAchieve == 1 then
		return noPeriodAchieveCnt
	else
		return cnt
	end
end

function CLEAR_ITEM_SLOTSET(slots, overSound)

	local cnt = slots:GetSlotCount();
	for i = 0 , cnt - 1 do
		local slot = slots:GetSlotByIndex(i);
		CLEAR_SLOT_ITEM_INFO(slot);

		if overSound ~= nil then
			slot:SetOverSound(overSound);
		end
	end

end

function INTO_CLIENT(frame)

	frame:MoveIntoClientRegion(frame:GetX(), frame:GetY());

end

function SET_GAUGE_PERCENT_STAT(g)

	g:SetStatFont(0, "white_16_ol");
	g:SetStatAlign(0, "center", "top");

end

function GET_MAP_NAME(mapID)

	local mapName = geMapTable.GetMapName(mapID);
	if mapName == "None" then
		return ClMsg("Logout");
	end

	return mapName;
end

function GET_MEMBER_TIP_TXT(name, memberInfo)

	local info = memberInfo:GetInst();
	local mapID = memberInfo:GetMapID();
	local mapName = GET_MAP_NAME(mapID);
	local txt = string.format("{ol}{s16}%s (%s:%d){nl}%s:%s{nl}HP : (%d/%d){nl}SP : (%d/%d){nl}", name, ClMsg("Level"), memberInfo:GetLevel(),
	ClMsg("Area"), mapName	, info.hp, info.maxhp, info.sp, info.maxsp);
	return txt;

end

function GET_MAP_TIP_TXT(name, memberInfo)

	local info = memberInfo:GetInst();
	local txt = string.format("{ol}{s16}%s (%s:%d){nl}HP : (%d/%d){nl}SP : (%d/%d){nl}", name, ClMsg("Level"), memberInfo:GetLevel(),
		info.hp, info.maxhp, info.sp, info.maxsp);
	return txt;

end

function UPDATE_PARTY_TOOLTIP(frame, name, type, funcName)

	frame = tolua.cast(frame, "ui::CTooltipFrame");
	if name == "" then
		frame:HoldProcess(1);
		frame:ShowWindow(0);
		return;
	end

	frame:HoldProcess(0);

	local nameCtrl = frame:GetChild("caption");
	local memberInfo = session.party.GetPartyMemberInfoByName(type, name);
	if memberInfo == nil then
		nameCtrl:SetText("{@st45}".. name);
		return;
	end

	local func = _G[funcName];
	local txt = func(name, memberInfo);

	nameCtrl:SetText(txt);

end

function UPDATE_MEMBER_TOOLTIP(frame, name, type)

	UPDATE_PARTY_TOOLTIP(frame, name, type, "GET_MEMBER_TIP_TXT");
	local nameCtrl = frame:GetChild("caption");
	nameCtrl:Resize(nameCtrl:GetWidth(), nameCtrl:GetHeight() + 30);
	frame:Resize(nameCtrl:GetWidth() + 20, nameCtrl:GetHeight() + 30);

end

function UPDATE_MEMBER_MAP_TOOLTIP(frame, name, type)

	UPDATE_PARTY_TOOLTIP(frame, name, type, "GET_MAP_TIP_TXT");
	local nameCtrl = frame:GetChild("caption");
	nameCtrl:Resize(nameCtrl:GetWidth(), nameCtrl:GetHeight() + 20);
	frame:Resize(nameCtrl:GetWidth() + 20, nameCtrl:GetHeight() + 20);

end

function CHATTAGET_MENU(frame, ctrl, argStr, argNum)
	tolua.cast(frame, "ui::CChatFrame");
	frame:SetAlive();

	local context = ui.CreateContextMenu(frame:GetName(), ctrl:GetText(), 0, 0, 140, 100);

	local strWhisperScp = string.format("ui.WhisperTo('%s')", ctrl:GetText());
	ui.AddContextMenuItem(context, ClMsg("WHISPER"), strWhisperScp);
	ui.AddContextMenuItem(context, ClMsg("Cancel"), "None");
	ui.OpenContextMenu(context);
end

function GET_OPT_TEXT(item, index)

	local optionValue = item["Option_" .. index];
	local opttype = OPT_TYPE(optionValue);
	local optvalue = OPT_VALUE(optionValue);
	local class = GetClassByType('Option', opttype);
	return string.format(class.Desc, optvalue);

end

function SCR_TREASURE_MARK_BYMAP(zoneClassName, xPos, yPos, zPos)
	local newframe = ui.CreateNewFrame('map', 'Map_TreasureMark');
	newframe:ShowWindow(1);
	newframe:EnableHide(1);
	newframe:EnableCloseButton(1);
	newframe:SetLayerLevel(100);

	DESTORY_MAP_PIC(newframe);
	local mapprop = geMapTable.GetMapProp(zoneClassName);
	local KorName = GetClassString('Map', zoneClassName, 'Name');

	local title = GET_CHILD(newframe, "title", "ui::CRichText");
	title:SetText('{@st46}'..KorName);

	local rate = newframe:GetChild('rate');
	rate:ShowWindow(0);

	local monlv = GET_CHILD_RECURSIVELY(newframe,"monlv")
	if monlv ~= nil then
		monlv:ShowWindow(0);
	end

	local myctrl = newframe:GetChild('my');
	tolua.cast(myctrl, "ui::CPicture");
	myctrl:ShowWindow(1);

	local mappicturetemp = GET_CHILD(newframe,'map','ui::CPicture')	
	mappicturetemp:SetImage(zoneClassName);
	
	local width = ui.GetImageWidth(zoneClassName .. "_fog");
	local height = ui.GetImageHeight(zoneClassName .. "_fog");

	local treasureMarkPic = newframe:CreateOrGetControl('picture', 'treasuremark', 0, 0, 32, 32);
	tolua.cast(treasureMarkPic, "ui::CPicture");
	treasureMarkPic:SetImage('trasuremapmark');
	local MapPos = mapprop:WorldPosToMinimapPos(xPos, zPos, width, height);
	treasureMarkPic:SetEnableStretch(1);

	local offsetX = mappicturetemp:GetX();
	local offsetY = mappicturetemp:GetY();

	local x = offsetX + MapPos.x - treasureMarkPic:GetWidth() / 2;
	local y = offsetY + MapPos.y - treasureMarkPic:GetHeight() / 2;
	treasureMarkPic:SetOffset(x, y);
end

function SCR_TREASURE_MARK_LIST_MAP(zoneClassName, posVec)

	local newframe = ui.CreateNewFrame('map', 'Map_TreasureMark');
	newframe:ShowWindow(1);
	newframe:EnableHide(1);
	newframe:EnableCloseButton(1);
	newframe:SetLayerLevel(100);

	DESTORY_MAP_PIC(newframe);
	local mapprop = geMapTable.GetMapProp(zoneClassName);
	local KorName = GetClassString('Map', zoneClassName, 'Name');

	local title = GET_CHILD(newframe, "title", "ui::CRichText");
	title:SetText('{@st46}'..KorName);

	local rate = newframe:GetChild('rate');
	rate:ShowWindow(0);

	local monlv = GET_CHILD_RECURSIVELY(newframe,"monlv")
	if monlv ~= nil then
		monlv:ShowWindow(0);
	end

	local myctrl = newframe:GetChild('my');
	tolua.cast(myctrl, "ui::CPicture");
	myctrl:ShowWindow(1);

	local mappicturetemp = GET_CHILD(newframe,'map','ui::CPicture')	
	mappicturetemp:SetImage(zoneClassName);
	
	local width = ui.GetImageWidth(zoneClassName .. "_fog");
	local height = ui.GetImageHeight(zoneClassName .. "_fog");

	local cnt = GetLuaPosCount(posVec);
	for i = 0 , cnt - 1 do
		local pos = GetLuaPosByIndex(posVec, i);

		local xPos = pos.x;
		local zPos = pos.z;
		local treasureMarkPic = newframe:CreateOrGetControl('picture', 'treasuremark'..i, 0, 0, 32, 32);
		tolua.cast(treasureMarkPic, "ui::CPicture");
		treasureMarkPic:SetImage('trasuremapmark');
		local mappicturetemp = GET_CHILD(newframe,'map','ui::CPicture')	
		mappicturetemp:SetImage(zoneClassName);

		local MapPos = mapprop:WorldPosToMinimapPos(xPos, zPos, width, height);
		treasureMarkPic:SetEnableStretch(1);
	
		local offsetX = mappicturetemp:GetX();
		local offsetY = mappicturetemp:GetY();
	
		local x = offsetX + MapPos.x - treasureMarkPic:GetWidth() / 2;
		local y = offsetY + MapPos.y - treasureMarkPic:GetHeight() / 2;
		treasureMarkPic:SetOffset(x, y);
	end
end
function GET_MY_STAT()

	return info.GetStat(session.GetMyHandle());

end

function UPDATE_QUEST_TALK_TOOLTIP(tooltipframe, strarg, numarg1, numarg2)
	tooltipframe:SetSkinName('textballoon_quest');
	local questIES = GetClassByType('QuestProgressCheck', numarg1);
	if questIES == nil then
		--tooltipframe:Resize(0, 0);
		tooltipframe:ShowWindow(0);
		return;
	end

	local questDesc = tooltipframe:GetChild('desc');
	tolua.cast(questDesc, "ui::CRichText");
	local pc = GetMyPCObject();
	local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName);
	local State = CONVERT_STATE(result);

	local descTxt = questIES[State .. 'Story'];
	questDesc:SetTextFixWidth(1);
	questDesc:EnableResizeByText(0);

	questDesc:Resize(320, 20);
	questDesc:SetText('{@st45tw2}'..descTxt);

	tooltipframe:Resize(350, questDesc:GetY() + questDesc:GetHeight()+10);
	imcSound.PlaySoundItem('textballoon_open');
end

function GET_SHOP_SSN()
	return session.GetSessionObjectByName("ssn_shop");
end

function GET_SHOP_PROP_POINT(pointName)

	local ssn = GET_SHOP_SSN();
	local availCnt = 0;
	if ssn ~= nil then
		local obj = GetIES(ssn:GetIESObject());
		availCnt = obj[pointName];
	end

	return availCnt;

end

function GUIDE_MSG(msg)
	addon.BroadMsg("NOTICE_Dm_!", msg, 2);
end


function GET_JARISU(cnt)

	local result = 1;
	while 1 do
		if cnt < 10 then
			return result;
		end
		cnt = math.floor(cnt / 10);
		result = result + 1;
	end

	return result;

end


function DIALOG_TEXT_VOICE(flowTextObj)
	--imcSound.StopAllVoiceSound();
	local voiceFileName = flowTextObj:GetVoiceName();
	if voiceFileName ~= "None" then
		local sStart, sEnd = string.find(voiceFileName, "/");
		if sStart == nil then
			--game.PlayVoice(voiceFileName, 255);
		else
			local voiceName = string.sub(voiceFileName, 1, sStart - 1);
			--game.PlayVoice(string.format("%s", voiceName), 255);

			local nextvoiceName = string.sub(voiceFileName, sEnd+1, string.len(voiceFileName));
			flowTextObj:SetVoiceName(string.format("%s", nextvoiceName));
		end
	end
end

function GET_RADIOBTN_NUMBER(radioBtn)

	radioBtn = tolua.cast(radioBtn, "ui::CRadioButton");
	radioBtn = radioBtn:GetSelectedButton();
	return AtoI_N(radioBtn:GetName(), string.len(radioBtn:GetName()) - 1);

end

function QUICK_RING_EXECUTE(ringIndex)

	local frame = ui.GetFrame("quickslotnexpbar");
	QUICK_RING_USE(frame, nil, nil, ringIndex)
end


function CHEAT_LIST_OPEN()

	local frame = ui.GetFrame('cheatlist')
	if 1 == session.IsGM() and frame ~= nil then
		ui.ToggleFrame('cheatlist')
	end

end

function ON_RIDING_VEHICLE(onoff)
    local commanderPC = GetCommanderPC()
    if IsBuffApplied(commanderPC, 'pet_PetHanaming_buff') == 'YES' then -- no ride
        return;
    end
	
	
	local isRidingOnly = 'NO';
    local summonedCompanion = session.pet.GetSummonedPet(0);	-- Riding Companion Only / Not Hawk --
    if summonedCompanion ~= nil then
		local companionObj = summonedCompanion:GetObject();
		local companionIES = GetIES(companionObj);
		local companionClassName = TryGetProp(companionIES, 'ClassName');
		if companionClassName ~= nil then
			local companionClass = GetClass('Companion', companionClassName);
			isRidingOnly = TryGetProp(companionClass, 'RidingOnly');
		end
	end
	
	if control.HaveNearCompanionToRide() == true or isRidingOnly == 'YES' then
		local fsmActor = GetMyActor();

		local subAction = fsmActor:GetSubActionState();
		
		-- 41, 42 == CSS_SKILL_READY, CSS_SKILL_USE
		if subAction == 41 or subAction == 42 then
			ui.SysMsg(ClMsg('SkillUse_Vehicle'));
			return;
		end
		
		if 1 == onoff then
			local abil = GetAbility(GetMyPCObject(), "CompanionRide");
			if nil == abil and control.IsPremiumCompanion() == false then
				ui.SysMsg(ClMsg('PetHasNotAbility'));
				return
			end
		end
		
		local ret = control.RideCompanion(onoff);
		if ret == false then
			return;
		end
	else
		if onoff == 1 then
			local cartHandle = control.GetNearSitableCart();
			if cartHandle ~= 0 then
				local index = control.GetNearSitableCartIndex();
				control.ReqRideCart(cartHandle, index);
			end
		else
			local myActor = GetMyActor();
			if myActor ~= nil and myActor:GetUserIValue("CART_ATTACHED") == 1 then
				control.ReqRideCart(myActor:GetUserIValue("CART_ATTACHED_HANDLE"), -1);
			end			
		end
	end
	

end

function COMPANION_INTERACTION(index)
	
	if ui.IsFrameVisible("petcommand") == 1 then
		
		RINGCOMMAND_ALT_NUMKEY(index)
	end
	
end

function UPDATE_MON_TITLE_VISIBLE(frame, handle)
	frame = tolua.cast(frame, "ui::CObject");
	local targetinfo = info.GetTargetInfo(handle);
	if targetinfo == nil then
		return;
	end

	if 0 == targetinfo.TargetWindow then
		HIDE_MONBASE_INFO(frame);
		return;
	end
		
	local isHp = targetinfo.showHP;	
	
	if info.IsNegativeRelation(handle) == 0 then
		isHp = 0;		
	end

	local hpGauge = GET_CHILD(frame, "hp", "ui::CGauge");
	if isHp == 0 then
		hpGauge:SetPoint(0, 0);		
		hpGauge:ShowWindow(0);
	else
		hpGauge:ShowWindow(1);
	end
	
end



function UPDATE_COMPANION_TITLE(frame, handle)

	frame = tolua.cast(frame, "ui::CObject");

	local petguid  = session.pet.GetPetGuidByHandle(handle);

	local mycompinfoBox = GET_CHILD_RECURSIVELY(frame, "mycompinfo");
	if mycompinfoBox == nil then
		return;
	end
		
	local otherscompinfo = GET_CHILD_RECURSIVELY(frame, "otherscompinfo");

	if petguid == 'None' then
		
		mycompinfoBox:ShowWindow(0)
		otherscompinfo:ShowWindow(1)
		
		local targetinfo = info.GetTargetInfo(handle);
		if targetinfo == nil then
			return;
		end

		local othernameTxt = GET_CHILD_RECURSIVELY(frame, "othername");
		othernameTxt:SetText(targetinfo.name)

	else
		mycompinfoBox:ShowWindow(1)
		otherscompinfo:ShowWindow(0)

		local mynameRtext = GET_CHILD_RECURSIVELY(frame, "myname");
		local gauge_stamina = GET_CHILD_RECURSIVELY(frame, "StGauge");
		local gauge_HP = GET_CHILD_RECURSIVELY(frame, "HpGauge");

		local pet = session.pet.GetPetByGUID(petguid);
		mynameRtext:SetText(pet:GetName())

		local petObj = GetIES(pet:GetObject());
		gauge_stamina:SetPoint(petObj.Stamina, petObj.MaxStamina);
		
		local petInfo = info.GetStat(handle); --IESObject ?�보 ?�용??HP???�시간으�??�기???��? ?�는??
		gauge_HP:SetPoint(petInfo.HP, petInfo.maxHP);		
	end

	frame:Invalidate()

end

function SCR_QUEST_TAB_CHECK(mode)
    if mode == 'MAIN' then
        return 'MAIN'
    end
    
    return 'SUB'
end


function UI_ONLY_NAME(onoff)
	ui.UiOnlyName()
end


function R1_PERF()

	local frame = ui.GetFrame('perfman')
	OPEN_PERFMAN(frame)
	frame:ShowWindow(1);
end


function TEST_TIARUA()

ReloadHotKey()
--print("?�щ줈??�빂??)
--ui.OpenFrame("joystickrestquickslot");
--[[
local quickFrame = ui.GetFrame('quickslotnexpbar')
	local joystickQuickFrame = ui.GetFrame('joystickquickslot')
	local Set1 = GET_CHILD(joystickQuickFrame,'Set1','ui::CGroupBox');
	local Set2 = GET_CHILD(joystickQuickFrame,'Set2','ui::CGroupBox');

	if IsJoyStickMode() == 1 then
		quickFrame:ShowWindow(0);
		joystickQuickFrame:ShowWindow(1);
		Set1:ShowWindow(1);
		Set2:ShowWindow(0);	
	elseif IsJoyStickMode() == 0 then
		quickFrame:ShowWindow(1);
		joystickQuickFrame:ShowWindow(0);
		Set1:ShowWindow(0);
		Set2:ShowWindow(0);	
	end
]]--
end

function TEST_TIA()
	
--	debug.TestEffectAllocatedCount(0, 3);
end


function UI_MODE_CHANGE(index)

	local quickFrame = ui.GetFrame('quickslotnexpbar')
	local restquickslot = ui.GetFrame('restquickslot')
	local joystickQuickFrame = ui.GetFrame('joystickquickslot')
	local joystickrestquickslot = ui.GetFrame('joystickrestquickslot')
	local flutingFrame = ui.GetFrame('fluting_keyboard')
	local monQuickslot = ui.GetFrame("monsterquickslot")
	if joystickQuickFrame == nil then
		return;
	end

	if monQuickslot:IsVisible() == 1 then
		return;
	end
	
	if flutingFrame:IsVisible() == 1 then
		return;
	end

	local Set1 = GET_CHILD(joystickQuickFrame,'Set1','ui::CGroupBox');
	local Set2 = GET_CHILD(joystickQuickFrame,'Set2','ui::CGroupBox');

	if index == nil then
		if IsJoyStickMode() == 1 then
			if control.IsRestSit() == true then	
				joystickQuickFrame:ShowWindow(0);
				joystickrestquickslot:ShowWindow(1);
			else
				joystickQuickFrame:ShowWindow(1);
				joystickrestquickslot:ShowWindow(0);
			end
			
			quickFrame:ShowWindow(0);
			restquickslot:ShowWindow(0);

			Set1:ShowWindow(1);
			Set2:ShowWindow(0);	
		elseif IsJoyStickMode() == 0 then
			if control.IsRestSit() == true then	
				if flutingFrame:IsVisible() ~= 1 then
					quickFrame:ShowWindow(0);
					restquickslot:ShowWindow(1);
				else
					quickFrame:ShowWindow(0);
					restquickslot:ShowWindow(0);
				end
			else
				quickFrame:ShowWindow(1);
				restquickslot:ShowWindow(0);
			end
			
			joystickQuickFrame:ShowWindow(0);
			joystickrestquickslot:ShowWindow(0);

			Set1:ShowWindow(0);
			Set2:ShowWindow(0);	
		end
	elseif index == 1 then
		if control.IsRestSit() == true then	
			joystickQuickFrame:ShowWindow(0);
			joystickrestquickslot:ShowWindow(1);
		else
			joystickQuickFrame:ShowWindow(1);
			joystickrestquickslot:ShowWindow(0);
		end
			
		quickFrame:ShowWindow(0);
		restquickslot:ShowWindow(0);

		Set1:ShowWindow(1);
		Set2:ShowWindow(0);	
	elseif index == 2 then
		if control.IsRestSit() == true then	
			quickFrame:ShowWindow(0);
			restquickslot:ShowWindow(1);
		else
			quickFrame:ShowWindow(1);
			restquickslot:ShowWindow(0);
		end
			
		joystickQuickFrame:ShowWindow(0);
		joystickrestquickslot:ShowWindow(0);

		Set1:ShowWindow(0);
		Set2:ShowWindow(0);	
	end
end

function KEYBOARD_INPUT()
	if geClientDirection.IsMyActorPlayingClientDirection() == true then
        return;
    end

	if GetChangeUIMode() == 1 then
		return;
	end

	local quickFrame = ui.GetFrame('quickslotnexpbar')
	local restquickslot = ui.GetFrame('restquickslot')
	local joystickrestquickslot = ui.GetFrame('joystickrestquickslot')
	local flutingFrame = ui.GetFrame('fluting_keyboard')
	local monsterquickslot = ui.GetFrame('monsterquickslot')
	local summoncontrol = ui.GetFrame('summoncontrol')
	SetJoystickMode(0)
	if quickFrame:IsVisible() == 1 or restquickslot:IsVisible() == 1 or joystickrestquickslot:IsVisible() == 1 or monsterquickslot:IsVisible() == 1 or summoncontrol:IsVisible() == 1 then
		local joystickQuickFrame = ui.GetFrame('joystickquickslot')
		if joystickQuickFrame:IsVisible() == 1 then
			joystickQuickFrame:ShowWindow(0);
		end
		if joystickrestquickslot:IsVisible() == 1 then
			joystickrestquickslot:ShowWindow(0);
		end
	end

	if GetChangeUIMode() == 0 then
		local quickFrame = ui.GetFrame('quickslotnexpbar')
		local joystickQuickFrame = ui.GetFrame('joystickquickslot')
		local Set1 = GET_CHILD(joystickQuickFrame,'Set1','ui::CGroupBox');
		local Set2 = GET_CHILD(joystickQuickFrame,'Set2','ui::CGroupBox');

		if monsterquickslot:IsVisible() ~= 1 then
			if control.IsRestSit() == true then
				quickFrame:ShowWindow(0);
				if flutingFrame:IsVisible() ~= 1 then
					restquickslot:ShowWindow(1);
				else
					restquickslot:ShowWindow(0);
				end
			else
				quickFrame:ShowWindow(1);
				restquickslot:ShowWindow(0);
			end
		end

		joystickQuickFrame:ShowWindow(0);
		joystickrestquickslot:ShowWindow(0);

		Set1:ShowWindow(0);
		Set2:ShowWindow(0);	

		quickFrame:Invalidate();
	end
end

function JOYSTICK_INPUT()
    if geClientDirection.IsMyActorPlayingClientDirection() == true then
        return;
    end

	if GetChangeUIMode() == 2 or GetChangeUIMode() == 3 then
		return;
	end

	local joystickQuickFrame = ui.GetFrame('joystickquickslot')
	local joystickrestquickslot = ui.GetFrame('joystickrestquickslot')
	local restquickslot = ui.GetFrame('restquickslot')
	local flutingFrame = ui.GetFrame('fluting_keyboard')
	local monsterquickslot = ui.GetFrame('monsterquickslot')
	local summoncontrol = ui.GetFrame('summoncontrol')
	SetJoystickMode(1)
	if joystickQuickFrame:IsVisible() == 1 or joystickrestquickslot:IsVisible() == 1 or restquickslot:IsVisible() == 1 or monsterquickslot:IsVisible() == 1 or summoncontrol:IsVisible() == 1 then
		local quickFrame = ui.GetFrame('quickslotnexpbar') 
		if quickFrame:IsVisible() == 1 then	
			quickFrame:ShowWindow(0);
		end
		if restquickslot:IsVisible() == 1 then	
			restquickslot:ShowWindow(0);
		end
	end

	if GetChangeUIMode() == 0 then
		local quickFrame = ui.GetFrame('quickslotnexpbar')
		local Set1 = GET_CHILD(joystickQuickFrame,'Set1','ui::CGroupBox');
		local Set2 = GET_CHILD(joystickQuickFrame,'Set2','ui::CGroupBox');
		
		if monsterquickslot:IsVisible() ~= 1 then
			if control.IsRestSit() == true then
				if flutingFrame:IsVisible() ~= 1 then
					joystickQuickFrame:ShowWindow(0);
					joystickrestquickslot:ShowWindow(1);
				else
					joystickQuickFrame:ShowWindow(0);
					joystickrestquickslot:ShowWindow(0);
				end
			else
				joystickQuickFrame:ShowWindow(1);
				joystickrestquickslot:ShowWindow(0);
			end
		end

		quickFrame:ShowWindow(0);
		restquickslot:ShowWindow(0);

		-- 기존 set ????.
		if Set2:IsVisible() == 1 then 
			Set1:ShowWindow(0);
			Set2:ShowWindow(1);
		else
			Set2:ShowWindow(0);
			Set1:ShowWindow(1);
		end
		
		joystickQuickFrame:Invalidate();
	end
end

function BLOCK_MSG(blockName, sysTime)

	sysTime = tolua.cast(sysTime, "SYSTEMTIME");
	local dateText = GET_DATE_TXT(sysTime);

	local msgClassName;
	if blockName == "ChatStopTime" then
		msgClassName = "ChatBlockedUntil{Time}";
	elseif blockName == "TradeStopTime" then
		msgClassName = "TradeBlockedUntil{Time}";
	else
		return;
	end

	local msgStr = ScpArgMsg(msgClassName, "Time", dateText);
	ui.SysMsg(msgStr);
	
end

function UI_CHECK_NOT_EVENT_MAP()
    if IS_IN_EVENT_MAP() == true then
        return 0;
    end
    return 1;
end

function TEST_CLIENT_SCRIPT()

	local frame = ui.GetFrame("beautyshop_test");
	if frame ~= nil then
		if frame:IsVisible() == 1 then
			frame:ShowWindow(0)
		else
			frame:ShowWindow(1)
		end
	end 
	

	--[[
	local pc = GetMyActor();
	local pos = pc:GetPos();
 
  	print("TEST_CLIENT_SCRIPT xyz", pos.x, pos.y, pos.z);
	TEST_CAMERA_CHANGE(pc, 1, pos.x , pos.y, pos.z, 180)
	]]
end
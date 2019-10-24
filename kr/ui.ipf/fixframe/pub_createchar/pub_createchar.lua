-- pub create RequestCreateCharacter
function PUB_CREATECHAR_ON_INIT(addon, frame)
	addon:RegisterMsg("BARRACK_NEWCHARACTER", "PUB_BARRACK_NEWCHARACTER");
	addon:RegisterMsg("RESET_HEAD_ICON_IMAGE", "PUB_RESET_SLOT_HAIR");
	addon:RegisterMsg("BARRACK_PRECHECK_VIEW_CONTROL", "PUB_PRECHECK_VIEW_CONTROL");
end

function PUB_CANCEL_CREATECHAR(frame)
	frame:ShowWindow(0);
	GetBarrackPub():EnableFocusChar(false);
	PUB_PRECHECK_VIEW_CONTROL(frame, " ", " ", 0);
	customizing_ui.SetUsePoseName("None");
end

local function _CREATE_STAT_GAUGE(box, ypos, stat, value, onImg, offImg, style, gaugeMarginX, gaugeLeftMarginX)	
	local statText = box:CreateControl('richtext', 'statText_'..stat, 0, ypos, 300, 30);
	statText:SetText(style..ClMsg(stat));

	local max_stat_value = 5;
	local image_width = 55;
	local image_height = 17;
	local line_interval = 8;
	local xpos = gaugeLeftMarginX;
	for i = 1, max_stat_value do
		local bg = box:CreateControl('picture', 'statBg_'..stat..'_'..i, xpos, ypos, image_width, image_height);
		AUTO_CAST(bg);
		bg:SetImage(offImg);		
		
		if i <= value then
			local img = box:CreateControl('picture', 'statImg_'..stat..'_'..i, xpos, ypos, image_width, image_height);
			AUTO_CAST(img);
			img:SetImage(onImg);
		end
		xpos = xpos + image_width + gaugeMarginX;
	end

	ypos = ypos + statText:GetHeight() + line_interval;
	return ypos;
end

local function _PUB_CREATE_UPDATE_JOB_SPECIAL_STAT(frame, jobCls)
	local job_specialstat_text = GET_CHILD_RECURSIVELY(frame, "job_specialstat");
	if job_specialstat_text == nil then return; end
	job_specialstat_text:SetTextByKey("value", ClMsg("pubcreate_title_spcialstat"));

	local statbg = GET_CHILD_RECURSIVELY(frame, 'statbg');	
	local statgruop = GET_CHILD(statbg, 'statgroup');
	statgruop:RemoveAllChild();

	local JOB_SPECIAL_FONT = frame:GetUserConfig('JOB_SPECIAL_FONT');
	local GAUGE_LEFT_MARGIN_X = tonumber(frame:GetUserConfig('GAUGE_LEFT_MARGIN_X'));
	local GAUGE_INTERVAL_MARGIN_X = tonumber(frame:GetUserConfig('GAUGE_INTERVAL_MARGIN_X'));
	local caption = jobCls.Caption2;
	local infos = StringSplit(caption, '/');
	local ypos = 0;
	for i = 1, #infos, 2 do
		local stat = infos[i];
		local value = infos[i + 1];
		ypos = _CREATE_STAT_GAUGE(statgruop, ypos, stat, tonumber(value), 'stat_gauge_bar', 'stat_gauge_frame', JOB_SPECIAL_FONT, GAUGE_INTERVAL_MARGIN_X, GAUGE_LEFT_MARGIN_X);
	end
end

function PUB_CREATE_UPDATE_JOB_SKILL(frame, jobCls)
	if frame == nil then return; end
	local tooltip_pox = tonumber(frame:GetUserConfig("SKL_TOOLTIP_POSX"));
	local tooltip_poy = tonumber(frame:GetUserConfig("SKL_TOOLTIP_POSY"));
	frame:SetPosTooltip(tooltip_pox, tooltip_poy);

	local skillgroup = GET_CHILD_RECURSIVELY(frame, "skillgroup");
	if skillgroup == nil then return; end
	skillgroup:RemoveAllChild();

	local job_skills = {};
	local list, cnt = GetClassList("SkillTree");
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(list, i);
		if cls ~= nil then
			local checkJobName = jobCls.ClassName .. '_';
			if string.find(cls.ClassName, checkJobName) ~= nil then
				job_skills[#job_skills+1] = cls.SkillName;
			end
		end
	end

	local slot_max_count = tonumber(frame:GetUserConfig("SKL_ICON_MAXCNT"));
	local slot_start_x = tonumber(frame:GetUserConfig("SKL_ICON_START_X"));
	local slot_interver_x = tonumber(frame:GetUserConfig("SKL_ICON_INTERVAL_X"));
	for i = 1, slot_max_count do
		local skill_class = GetClass("Skill", job_skills[i]);
		if skill_class == nil then break; end

		local skill_slot = skillgroup:CreateOrGetControl("slot", "SLOT_"..i, slot_start_x + (i - 1) * slot_interver_x, 0, 69, 69);
		skill_slot = tolua.cast(skill_slot, "ui::CSlot");
		skill_slot:ShowWindow(1);
		skill_slot:EnableDrag(0);
		skill_slot:SetOverSound('win_open');
		skill_slot:SetSkinName('slot');

		local icon = CreateIcon(skill_slot);
		local icon_name = "icon_"..skill_class.Icon;
		icon:SetImage(icon_name);
		icon:SetTooltipType("skill_pubcreatechar");
		icon:SetTooltipStrArg(skill_class.ClassName);
		icon:SetTooltipNumArg(skill_class.ClassID);	

		local skl = session.GetSkillByName(skill_class.ClassName);
		if skl ~= nil then
			icon:SetTooltipIESID(skl:GetIESID());
		end
		icon:Set(icon_name, "Skill", skill_class.ClassID, 1);
	end
end

function PUB_CHARFRAME_UPDATE(frame, actor)
	local apc = actor:GetPCApc();
	local gender = apc:GetGender();
	local job = apc:GetJob();
	local headType = apc:GetHeadType();
	if actor ~= nil then
		customizing_ui.SetActorOriginHairType(actor:GetHandleVal(), headType);
	end

	-- custom job
	local jobCls = GetClassByType("Job", job);
	local ratingstr = jobCls.Rating;
	ratingstr_arg = {}

	local maingroup = GET_CHILD_RECURSIVELY(frame, "maingroup");
	for i = 1, 4 do -- 혹시 별점 항목이 늘어난다면 이 3을 늘릴 것
		ratingstr_arg[i] = string.sub(ratingstr, 2 * i - 1, 2 * i - 1)
		ratingstr_arg[i] = ratingstr_arg[i] + 0;
	end

	local classimage = GET_CHILD_RECURSIVELY(frame, "classIconImage", "ui::CPicture");
	classimage:SetImage(jobCls.Icon);

	local job_title = maingroup:GetChild("job_title");
	job_title:SetTextByKey("value", jobCls.Name);

	local job_desc = maingroup:GetChild("job_desc");
	job_desc:SetTextByKey("value", jobCls.Caption1);
	
	_PUB_CREATE_UPDATE_JOB_SPECIAL_STAT(frame, jobCls);
	PUB_CREATE_UPDATE_JOB_SKILL(frame, jobCls);

	-- custom face
	local skinIndex = tonumber(frame:GetUserValue("SKIN_SELECT_INDEX"));
	if skinIndex ~= nil and skinIndex ~= 2 then
		frame:SetUserValue("SKIN_SELECT_INDEX", 2);
	end
	customizing_ui.CustomizingSkinChangeDefaultColor(actor);

	PUB_SELECT_SLOT_CLEAR(frame, "custom_hairgroup");
	local custom_headgb = GET_CHILD_RECURSIVELY(frame, "custom_hairgroup");
	if custom_headgb == nil then return; end
	PUB_CUSTOM_HAIR_SET_SLOT(frame, custom_headgb, actor, gender);

	PUB_SELECT_SLOT_CLEAR(frame, "custom_skingroup");
	local custom_skingb = GET_CHILD_RECURSIVELY(frame, "custom_skingroup");
	if custom_skingb == nil then return; end
	PUB_CUSTOM_SKIN_SET_SLOT(frame, custom_skingb, actor, gender);

	-- custom privew
	PUB_SELECT_SLOT_CLEAR(frame, "custom_costumegroup");
	local custom_costumegb = GET_CHILD_RECURSIVELY(frame, "custom_costumegroup");
	if custom_costumegb == nil then return; end

	local originHeight = tonumber(frame:GetUserConfig("PREVEIW_GB_ORIGIN_HEIGHT"));
	custom_costumegb:Resize(custom_costumegb:GetX(), custom_costumegb:GetY(), custom_costumegb:GetWidth(), originHeight);
	PUB_CUSTOM_COSTUME_SET_SLOT(frame, custom_costumegb, actor, gender);

	-- init costume view btn setting
	local downBtnImage = frame:GetUserConfig("PREVIEW_DOWNBTN_IMAGE");
	local upBtnImage = frame:GetUserConfig("PREVIEW_UPBTN_IMAGE");
	local costume_view_btn = GET_CHILD_RECURSIVELY(frame, "costume_view_btn");
	if costume_view_btn == nil then return; end
	costume_view_btn:SetImage(upBtnImage);

	local pose_view_btn = GET_CHILD_RECURSIVELY(frame, "pose_view_btn");
	if pose_view_btn == nil then return; end
	pose_view_btn:SetImage(downBtnImage);

	-- init view flag userconfig
	frame:SetUserConfig("COSTUME_VIEW_FALG", 1);
	frame:SetUserConfig("POSE_VIEW_FALG", 0);

	-- init slot align
	PUB_CREATE_UPDATE_GBOX_ALIGN(frame);

	-- init prview pose group
	local pose_gb = GET_CHILD_RECURSIVELY(frame, "custom_posegroup");
	if pose_gb == nil then return; end
	pose_gb:RemoveAllChild();

	local left_btn = GET_CHILD_RECURSIVELY(frame, "pose_left_btn");
	local right_btn = GET_CHILD_RECURSIVELY(frame, "pose_right_btn");
	left_btn:SetVisible(0);
	right_btn:SetVisible(0);

	-- init select check image
	local hair_selectImage = GET_CHILD_RECURSIVELY(frame, "hair_select_check_pic");
	if hair_selectImage == nil then return; end
	hair_selectImage:SetVisible(0);

	local skin_selectImage = GET_CHILD_RECURSIVELY(frame, "skin_select_check_pic");
	if skin_selectImage == nil then return; end
	skin_selectImage:SetVisible(0);
end

function PUB_CREATE_UPDATE_GBOX_ALIGN(frame)
	local config_titlestart_y = tonumber(frame:GetUserConfig("TITLESLOT_START_Y"));
	local config_viewbtnstart_y = tonumber(frame:GetUserConfig("VIEWBTN_START_Y"));
	local config_titleinv_y = tonumber(frame:GetUserConfig("TITLESLOT_INV_Y"));
	local config_viewbtninv_y = tonumber(frame:GetUserConfig("VIEWBTN_INV_Y"));
	local config_titletextinv_y = tonumber(frame:GetUserConfig("TITLETEXT_INV_Y"));

	local starty_titletextgb = 1;
	local intervaly_titletextgb = config_titletextinv_y;
	local titleTextgb = GET_CHILD_RECURSIVELY(frame, "custom_preview_titletext_group");
	GBOX_AUTO_ALIGN(titleTextgb, starty_titletextgb, intervaly_titletextgb, 0, true, false, false);

	local starty_titlegb = config_titlestart_y; 
	local intervaly_titlegb = config_titleinv_y;
	local titlegb = GET_CHILD_RECURSIVELY(frame, "custom_preview_titleslot_group");
	GBOX_AUTO_ALIGN(titlegb, starty_titlegb, intervaly_titlegb, 0, true, false, false);

	local starty_viewgb = config_viewbtnstart_y; 
	local intervaly_viewgb = config_viewbtninv_y;
	local viewgb = GET_CHILD_RECURSIVELY(frame, "custom_preview_viewbtn_group");
	GBOX_AUTO_ALIGN(viewgb, starty_viewgb, intervaly_viewgb, 0, true, false, false);	

	local tabTitle = GET_CHILD_RECURSIVELY(frame, "custom_preview_pose_tab_title");		
	local starty_slotgb = starty_titlegb + tabTitle:GetHeight(); 
	local slotgb = GET_CHILD_RECURSIVELY(frame, "custom_preview_slot_group");
	GBOX_AUTO_ALIGN(slotgb, starty_slotgb, 0, 0, true, false, false);
end

function OPEN_PUB_CREATECHAR(frame)
	PUB_CUSTOM_FACE_INIT(frame)
	PUB_CUSTOM_PREVIEW_INIT(frame);
	PUB_CUSTOM_ROTATE_INIT(frame);

	local input_name = GET_CHILD_RECURSIVELY(frame, "input_name");
	if input_name ~= nil then
		input_name:SetText("");
	end

	local input_name_text = GET_CHILD_RECURSIVELY(frame, "input_name_text");
	if input_name_text ~= nil then
		input_name_text:SetTextByKey("value", ClMsg("pubcreate_input_name_title"));
	end

	local choice_class_title = GET_CHILD_RECURSIVELY(frame, "choice_class_title");
	if choice_class_title == nil then return; end
	choice_class_title:SetTextByKey("value", ClMsg("pubcreate_choice_class"));

	frame:SetUserValue("GENDER", 0);
end

function CLOSE_PUB_CREATECHAR(frame)
	local custom_costumegb = GET_CHILD_RECURSIVELY(frame, "custom_costumegroup");
	if custom_costumegb == nil then return; end
	custom_costumegb:RemoveAllChild();

	local custom_posegb = GET_CHILD_RECURSIVELY(frame, "custom_posegroup");
	if custom_posegb == nil then return; end
	custom_posegb:RemoveAllChild();
end

function IS_FULL_SLOT_CURRENT_LAYER()
    local frame = ui.GetFrame("barrack_charlist")
    local child = GET_CHILD(frame, 'scrollBox')
    local char_cnt = child:GetChildCount() - 1
    if char_cnt >= 16 then        
        return true
    end
    return false
end

function PUB_EXEC_CREATECHAR(parent, ctrl)    
	local accountInfo = session.barrack.GetMyAccount();
	if accountInfo:GetPCCount() > 0 then
		local frame = ui.GetFrame("pub_createchar");
		local input_name = GET_CHILD_RECURSIVELY(frame, "input_name");
		local text = input_name:GetText();
		if text ~= nil and text == "" then
			local textMsg = ScpArgMsg("pubcreate_need_to_enter_name");
			ui.MsgBox(textMsg);
			return;
		end

		local msg = ScpArgMsg("WillYouSeeOpeningAgain?");
		ui.MsgBox(msg, "_PUB_EXEC_CREATECHAR(1)", "_PUB_EXEC_CREATECHAR(0)");
	else
		_PUB_EXEC_CREATECHAR(1)
	end
end

function _PUB_EXEC_CREATECHAR(viewOpening)    
	local frame = ui.GetFrame("pub_createchar");    
	local input_name = GET_CHILD(frame, "input_name", "ui::CEditControl");
	local text = input_name:GetText();

    local make_layer = current_layer
    if make_layer < 1 or make_layer > 3 then
        make_layer = 1
    end

	local actor = GetBarrackPub():GetSelectedActor();
	barrack.RequestCreateCharacter(text, actor, make_layer);
	GetBarrackPub():EnablePlayOpening(viewOpening);
end

-------------- custom face 
function PUB_CUSTOM_FACE_INIT(frame)
	if frame == nil then return; end
	local tabImageName = frame:GetUserConfig("TAB_IMAGE_NAME");

	local hairtab_title_btn = GET_CHILD_RECURSIVELY(frame, "customhair_tab_title");
	if hairtab_title_btn == nil then return; end
	local hairtab_caption = string.format("{@st41b}{s20}  %s{/}", ClMsg("pubcreate_tab_hair"));
	hairtab_title_btn:SetText(hairtab_caption);

	local skintab_title_btn = GET_CHILD_RECURSIVELY(frame, "customskin_tab_title");
	if skintab_title_btn == nil then return; end
	local skintab_caption = string.format("{@st41b}{s20}  %s{/}", ClMsg("pubcreate_tab_skin"));
	skintab_title_btn:SetText(skintab_caption);

	frame:SetUserValue("SKIN_DEFAULT_SEELCT_INDEX", 2);
end

function PUB_CUSTOM_HAIR_SET_SLOT(frame, gb, actor, gender)
	if actor == nil then return; end
	if gender == nil or gender == 0 then return; end
	if gb == nil then return; end
	gb:RemoveAllChild();

	local slot_skinName = frame:GetUserConfig("CUSTOM_SLOT_SKIN_NAME");
	local slot_size = tonumber(frame:GetUserConfig("CUSTOM_LARGE_SLOT_SIZE"));
	local slot_reducedvalue = frame:GetUserConfig("ICON_REDUCED_VALUE");
	slot_reducedvalue = StringSplit(slot_reducedvalue, " ");
	local reduced_width = tonumber(slot_reducedvalue[1]);
	local reduced_height = tonumber(slot_reducedvalue[2]);

	local slot_start_x = 10;
	local slot_start_y = 10;
	local slot_interver_x = slot_size + 5;
	local slot_interver_y = slot_size + 5;

	local slot_index_y = 0;
	local slot_index_x = 0;
	
	local cnt = customizing_ui.GetCustomizingHairListSize(actor, gender);
	for i = 1, cnt do
		if slot_index_x ~= 0 and slot_index_x % 5 == 0 then
			slot_index_y = slot_index_y + 1;
			slot_index_x = 0;
		end

		local slot = gb:CreateOrGetControl("slot", "HAIR_SLOT_"..i, slot_start_x + (slot_index_x * slot_interver_x), slot_start_y + (slot_index_y * slot_interver_y), slot_size, slot_size);
		slot_index_x = slot_index_x + 1;
		slot = tolua.cast(slot, "ui::CSlot");
		slot:ShowWindow(1);
		slot:EnableDrag(0);
		slot:SetSkinName(slot_skinName);
		slot:SetEventScript(ui.LBUTTONDOWN, "PUB_CUSTOM_HAIR_SELECT");

		local icon = CreateIcon(slot);
		local skinIndex = tonumber(frame:GetUserValue("SKIN_SELECT_INDEX"));
		if skinIndex == nil then
			skinIndex = 2;
		end

		local headIconName = "icon_skintone_";
		local genderStr = "";
		if gender == 1 then
			genderStr = "_m";
		elseif gender == 2 then
			genderStr = "_f";
		end

		if i < 10 then
			headIconName = headIconName.."0"..skinIndex..genderStr.."0"..i;
		else
			headIconName = headIconName.."0"..skinIndex..genderStr..i;
		end
		
		icon:SetImage(headIconName);
		icon:SetDisableSlotSize(true);
		icon:SetReducedvalue(reduced_width, reduced_height);
	end
end

function PUB_CUSTOM_SKIN_SET_SLOT(frame, gb, actor, gender)
	if frame == nil then return; end
	if gb == nil then return; end
	if gender == nil then return; end

	local slot_skinName = frame:GetUserConfig("CUSTOM_SLOT_SKIN_NAME");
	local slot_size = tonumber(frame:GetUserConfig("CUSTOM_SMALL_SLOT_SIZE"));

	local slot_start_x = 10;
	local slot_start_y = 10;
	local slot_interver_x = slot_size + 10;
	local slot_interver_y = slot_size + 5;

	local slot_index_y = 0;
	local slot_index_x = 0;

	local cnt = customizing_ui.GetCustomizingSkinListSize(actor:GetHandleVal());
	for i = 1, cnt do
		if slot_index_x ~= 0 and slot_index_x % 7 == 0 then
			slot_index_y = slot_index_y + 1;
			slot_index_x = 0;
		end

		local slot = gb:CreateOrGetControl("slot", "SKIN_SLOT_"..i, slot_start_x + (slot_index_x * slot_interver_x), slot_start_y + (slot_index_y * slot_interver_y), slot_size, slot_size);
		slot_index_x = slot_index_x + 1;
		slot = tolua.cast(slot, "ui::CSlot");
		slot:ShowWindow(1);
		slot:EnableDrag(0);
		slot:SetSkinName(slot_skinName);
		slot:SetEventScript(ui.LBUTTONDOWN, "PUB_CUSTOM_SKIN_SELECT");

		local icon = CreateIcon(slot);
		local skinImageName = "";
		if i + 5 < 10 then
			skinImageName = string.format("skin_color_0%d", i + 5);
		elseif i + 5 >= 10 then
			skinImageName = string.format("skin_color_%d", i + 5);
		end

		icon:SetImage(skinImageName);
		slot:Invalidate();
	end
end

function PUB_CUSTOM_HAIR_SELECT(frame, slot)
	if frame == nil then return; end
	if slot == nil then return; end
	slot:Select(1);

	local topFrame = frame:GetTopParentFrame();
	if topFrame ~= nil then
		local hair_selectImage = GET_CHILD_RECURSIVELY(topFrame, "hair_select_check_pic");
		if hair_selectImage == nil then return; end
		hair_selectImage:SetVisible(1);

		local offsetx = tonumber(topFrame:GetUserConfig("HAIR_SELECT_OFFSETX"));
		local offsety = tonumber(topFrame:GetUserConfig("HAIR_SELECT_OFFSETY"));

		local margin = slot:GetMargin();
		local x = margin.left + offsetx;
		local y = margin.top + offsety;
		hair_selectImage:SetOffset(x, y);
	end

	local prvIndex = tonumber(frame:GetUserValue("HAIR_SELECT_INDEX"));
	local slotIndex = slot:GetName();
	slotIndex = StringSplit(slotIndex, '_');
	slotIndex = tonumber(slotIndex[3]);
	frame:SetUserValue("HAIR_SELECT_INDEX", slotIndex);

	if prvIndex == nil then
		prvIndex = slotIndex;
	end

	if prvIndex ~= slotIndex then
		local slotName = "HAIR_SLOT_"..prvIndex;
		PUB_CUSTOM_SLOT_SELECT_CLEAR(frame, slotName);
	end

	local actor = GetBarrackPub():GetSelectedActor();
	if actor ~= nil then
		local hairType = customizing_ui.GetCustomizingHairTypeByIndex(actor, slotIndex - 1);
		if hairType ~= 0 then
			GetBarrackPub():ChangeHair(hairType);
		end
	end
end

function PUB_CUSTOM_SKIN_SELECT(frame, slot)
	if frame == nil then return; end
	if slot == nil then return; end
	slot:Select(1);

	local topFrame = frame:GetTopParentFrame();
	if topFrame ~= nil then
		local skin_selectImage = GET_CHILD_RECURSIVELY(topFrame, "skin_select_check_pic");
		if skin_selectImage == nil then return; end
		skin_selectImage:SetVisible(1);

		local offsetx = tonumber(topFrame:GetUserConfig("SKIN_SELECT_OFFSETX"));
		local offsety = tonumber(topFrame:GetUserConfig("SKIN_SELECT_OFFSETY"));

		local margin = slot:GetMargin();
		local x = margin.left + offsetx;
		local y = margin.top + offsety;
		skin_selectImage:SetOffset(x, y);
	end

	local prvIndex = tonumber(topFrame:GetUserValue("SKIN_SELECT_INDEX"));
	local slotIndex = slot:GetName();
	slotIndex = StringSplit(slotIndex, '_');
	slotIndex = tonumber(slotIndex[3]);
	topFrame:SetUserValue("SKIN_SELECT_INDEX", slotIndex);

	if prvIndex == nil then
		prvIndex = slotIndex;
	end

	if prvIndex ~= slotIndex then
		local slotName = "SKIN_SLOT_"..prvIndex;
		PUB_CUSTOM_SLOT_SELECT_CLEAR(frame, slotName);
	end

	local actor = GetBarrackPub():GetSelectedActor();
	if actor ~= nil then
		customizing_ui.CustomizingSkinChangeByIndex(actor, slotIndex - 1);
	end
end

function PUB_RESET_SLOT_HAIR(frame, msg)
	if frame == nil then return end;
	
	local custom_headgb = GET_CHILD_RECURSIVELY(frame, "custom_hairgroup");
	if custom_headgb == nil then return; end
	custom_headgb:RemoveAllChild();

	local actor = GetBarrackPub():GetSelectedActor();
	if actor == nil then return; end

	local apc = actor:GetPCApc();
	local gender = apc:GetGender();
	PUB_CUSTOM_HAIR_SET_SLOT(frame, custom_headgb, actor, gender);

	local poseName = customizing_ui.GetUsePoseName();
	if poseName ~= "None" and poseName ~= nil then 
		control.PubActorPose(poseName, 0.0, 0.0, actor:GetHandleVal());
	end
end
-------------- custom face end
-------------- custom preview 
function PUB_CUSTOM_PREVIEW_INIT(frame)
	if frame == nil then return; end
	local tabImageName = frame:GetUserConfig("TAB_IMAGE_NAME");

	local preview_title = GET_CHILD_RECURSIVELY(frame, "costume_preview_title");
	if preview_title == nil then return; end
	preview_title:SetTextByKey("value", ClMsg("pubcreate_title_preview"));

	local previewoutertab_title_btn = GET_CHILD_RECURSIVELY(frame, "custom_preview_outer_tab_title");
	if previewoutertab_title_btn == nil then return; end
	local previewoutertab_caption = string.format("{@st41b}{s20}  %s{/}", ClMsg("pubcreate_tab_costume"));
	previewoutertab_title_btn:SetText(previewoutertab_caption);

	local previewposetab_title_btn = GET_CHILD_RECURSIVELY(frame, "custom_preview_pose_tab_title");
	if previewposetab_title_btn == nil then return; end
	local previewposetab_caption = string.format("{@st41b}{s20}  %s{/}", ClMsg("pubcreate_tab_pose"));
	previewposetab_title_btn:SetText(previewposetab_caption);
end

function PUB_CUSTOM_COSTUME_SET_SLOT(frame, gb, actor, gender)
	if frame == nil then return; end
	if gb == nil then return; end
	if gender == nil then return; end

	local slot_skinName = frame:GetUserConfig("CUSTOM_SLOT_SKIN_NAME");
	local slot_size = tonumber(frame:GetUserConfig("CUSTOM_LARGE_SLOT_SIZE"));

	local slot_start_x = 50;
	local slot_start_y = 10;
	local slot_interver_x = slot_size + 3;
	local slot_index_x = 0;
	
	local max = tonumber(frame:GetUserConfig("COSTUME_MAX_CNT"));
	local cnt = customizing_ui.GetCostumeListSize(actor:GetHandleVal());

	local left_btn = GET_CHILD_RECURSIVELY(frame, "costume_left_btn");
	local right_btn = GET_CHILD_RECURSIVELY(frame, "costume_right_btn");
	if max ~= nil and max <= 5 then
		left_btn:SetVisible(0);
		right_btn:SetVisible(0);
	elseif max ~= nil and max > 5 then
		left_btn:SetVisible(1);
		right_btn:SetVisible(1);
	end

	for i = 1, cnt do
		local slot = gb:CreateOrGetControl("slot", "COSTUME_SLOT_"..i, slot_start_x + (slot_index_x * slot_interver_x), slot_start_y, slot_size, slot_size);
		slot_index_x = slot_index_x + 1;
		slot = tolua.cast(slot, "ui::CSlot");
		slot:ShowWindow(1);
		slot:EnableDrag(0);
		slot:SetSkinName(slot_skinName);
		slot:SetEventScript(ui.LBUTTONDOWN, "PUB_CUSTOM_COSTUME_SELECT");

		local icon = CreateIcon(slot);
		local imageName = frame:GetUserConfig("COSTUME_ICON_NAME");
		if imageName ~= nil then
			imageName = imageName..i;
			icon:SetImage(imageName);

			local click_imageName = imageName.."_clicked";
			slot:SetSelectedImage(click_imageName);
		end
		
		slot:Invalidate();
	end
end

function PUB_CUSTOM_COSTUME_SELECT(frame, slot)
	if frame == nil then return; end
	if slot == nil then return; end
	slot:Select(1);

	local costumeSplit = StringSplit(slot:GetName(), '_');
	if costumeSplit == nil then return; end

	local prvIndex = tonumber(frame:GetUserValue("COSTUME_SELECT_INDEX"));
	local index = tonumber(costumeSplit[3]);
	if index == nil then return; end
	frame:SetUserValue("COSTUME_SELECT_INDEX", index);

	if prvIndex == nil then
		prvIndex = index;
	end

	if prvIndex ~= index then
		local slotName = "COSTUME_SLOT_"..prvIndex;
		PUB_CUSTOM_SLOT_SELECT_CLEAR(frame, slotName);
	end

	local actor = GetBarrackPub():GetSelectedActor();
	if actor == nil then return; end
	customizing_ui.ApplyCostumeByIndex(actor:GetHandleVal(), index - 1);
end

function PUB_CUSTOM_POSE_SET_SLOT(frame, gb, actor)
	if frame == nil then return; end
	if gb == nil then return; end
	if actor == nil then return; end

	local slot_skinName = frame:GetUserConfig("CUSTOM_SLOT_SKIN_NAME");
	local slot_size = tonumber(frame:GetUserConfig("CUSTOM_LARGE_SLOT_SIZE"));
	slot_size = slot_size + 2;

	local slot_start_x = 50;
	local slot_start_y = 10;
	local slot_interver_x = slot_size + 1;
	local slot_index_x = 0;

	local max = tonumber(frame:GetUserConfig("POSE_MAX_CNT"));
	local cnt = customizing_ui.GetPoseListSize();
	local left_btn = GET_CHILD_RECURSIVELY(frame, "pose_left_btn");
	local right_btn = GET_CHILD_RECURSIVELY(frame, "pose_right_btn");
	if cnt ~= nil and cnt <= 5 then
		left_btn:SetVisible(0);
		right_btn:SetVisible(0);
	elseif cnt ~= nil and cnt > 5 then
		left_btn:SetVisible(1);
		right_btn:SetVisible(1);
	end

	for i = 1, cnt do
		local poseName = customizing_ui.GetPoseNameByIndex(i - 1);
		local slot = gb:CreateOrGetControl("slot", "POSE_SLOT_"..poseName, slot_start_x + (slot_index_x * slot_interver_x), slot_start_y, slot_size, slot_size);
		slot_index_x = slot_index_x + 1;
		slot = tolua.cast(slot, "ui::CSlot");
		slot:ShowWindow(1);
		slot:EnableDrag(0);
		slot:SetSkinName(slot_skinName);
		slot:SetEventScript(ui.LBUTTONDOWN, "PUB_CUSTOM_POSE_SELECT");

		local icon = CreateIcon(slot);
		local poseIconImage = customizing_ui.GetPoseIconNameByIndex(i - 1);
		if poseIconImage ~= nil then
			icon:SetImage(poseIconImage);
		end

		slot:Invalidate();
	end
end

function PUB_CUSTOM_POSE_SELECT(frame, slot)
	if frame == nil then return; end
	if slot == nil then return; end
	slot:Select(1);

	local poseSplit = StringSplit(slot:GetName(), '_');
	if poseSplit == nil then return; end

	local prvName = frame:GetUserValue("POSE_SELECT_NAME");
	local poseName = poseSplit[3];
	if poseName == nil then return; end
	frame:SetUserValue("POSE_SELECT_NAME", poseName);
	
	if prvName ~= poseName then
		local slotName = "POSE_SLOT_"..prvName;
		PUB_CUSTOM_SLOT_SELECT_CLEAR(frame, slotName);
	end

	local actor = GetBarrackPub():GetSelectedActor();
	if actor == nil then return; end
	control.PubActorPose(poseName, 0.0, 0.0, actor:GetHandleVal());
end

function PUB_PREVIEW_VIEWBTN(gb, btn)
	if gb == nil then return; end
	if btn == nil then return; end

	local frame = gb:GetTopParentFrame();
	if frame == nil then return; end
	
	local custom_costumegb = GET_CHILD_RECURSIVELY(frame, "custom_costumegroup");
	if custom_costumegb == nil then return; end

	local actor = GetBarrackPub():GetSelectedActor();
	if actor == nil then return; end
	local apc = actor:GetPCApc();
	local gender = apc:GetGender();

	local slotgb = GET_CHILD_RECURSIVELY(frame, "custom_preview_slot_group");
	local titlegb = GET_CHILD_RECURSIVELY(frame, "custom_preview_titleslot_group");
	local viewgb = GET_CHILD_RECURSIVELY(frame, "custom_preview_viewbtn_group");
	local upBtnImage = frame:GetUserConfig("PREVIEW_UPBTN_IMAGE");
	local downBtnImage = frame:GetUserConfig("PREVIEW_DOWNBTN_IMAGE");

	local viewFlag = tonumber(frame:GetUserConfig("COSTUME_VIEW_FALG"));
	local costume_view_btn = GET_CHILD_RECURSIVELY(frame, "costume_view_btn");
	local pose_view_btn = GET_CHILD_RECURSIVELY(frame, "pose_view_btn");
	if viewFlag == 1 then
		viewFlag = 0;
		pose_view_btn:SetImage(upBtnImage);
		costume_view_btn:SetImage(downBtnImage);
	elseif viewFlag == 0 then
	 	viewFlag = 1;
		pose_view_btn:SetImage(downBtnImage);
		costume_view_btn:SetImage(upBtnImage);		
	end
	frame:SetUserConfig("COSTUME_VIEW_FALG", viewFlag);

	local config_titlestart_y = tonumber(frame:GetUserConfig("TITLESLOT_START_Y"));
	local config_viewbtnstart_y = tonumber(frame:GetUserConfig("VIEWBTN_START_Y"));
	local config_titleinv_y = tonumber(frame:GetUserConfig("TITLESLOT_INV_Y"));
	local config_viewbtninv_y = tonumber(frame:GetUserConfig("VIEWBTN_INV_Y"));
	local config_titleinvreduce_y = tonumber(frame:GetUserConfig("TITLESLOT_INV_REDUCE_Y"));
	local config_viewbtninvreduce_y = tonumber(frame:GetUserConfig("VIEWBTN_INV_REDUCE_Y"));
	local originHeight = tonumber(frame:GetUserConfig("PREVEIW_GB_ORIGIN_HEIGHT"));

	local heightRate = ui.GetHeightRate_Inv();
	if heightRate == nil then return; end
	if viewFlag == 0 then
		custom_costumegb:RemoveAllChild();
		custom_costumegb:Resize(custom_costumegb:GetX(), custom_costumegb:GetY(), custom_costumegb:GetWidth(), 0);
		custom_costumegb:Invalidate();	

		local custom_posegb = GET_CHILD_RECURSIVELY(frame, "custom_posegroup");
		if custom_posegb == nil then return; end
		custom_posegb:Resize(custom_posegb:GetX(), custom_posegb:GetY(), custom_posegb:GetWidth(), originHeight);
		PUB_CUSTOM_POSE_SET_SLOT(frame, custom_posegb, actor);

		local starty_titlegb = config_titlestart_y; 
		local intervaly_titlegb = config_titleinvreduce_y;
		GBOX_AUTO_ALIGN(titlegb, starty_titlegb, intervaly_titlegb, 0, true, false, false);

		local starty_viewgb = config_viewbtnstart_y; 
		local intervaly_viewgb = config_viewbtninvreduce_y;
		GBOX_AUTO_ALIGN(viewgb, starty_viewgb, intervaly_viewgb, 0, true, false, false);

		local tabTitle = GET_CHILD_RECURSIVELY(frame, "custom_preview_pose_tab_title");		
		local starty_slotgb = starty_titlegb + tabTitle:GetHeight(); 
		local intervaly_slotgb = tabTitle:GetHeight();
		GBOX_AUTO_ALIGN(slotgb, starty_slotgb, intervaly_slotgb, 5, true, true, false);
	elseif viewFlag == 1 then
		local custom_posegb = GET_CHILD_RECURSIVELY(frame, "custom_posegroup");
		if custom_posegb == nil then return; end
		custom_posegb:RemoveAllChild();
		custom_posegb:Resize(custom_posegb:GetX(), custom_posegb:GetY(), custom_posegb:GetWidth(), 0);
		custom_posegb:Invalidate();

		custom_costumegb:Resize(custom_costumegb:GetX(), custom_costumegb:GetY(), custom_costumegb:GetWidth(), originHeight);
		PUB_CUSTOM_COSTUME_SET_SLOT(frame, custom_costumegb, actor, gender);

		local starty_titlegb = config_titlestart_y; 
		local intervaly_titlegb = config_titleinv_y;
		GBOX_AUTO_ALIGN(titlegb, starty_titlegb, intervaly_titlegb, 0, true, false, false);

		local starty_viewgb = config_viewbtnstart_y; 
		local intervaly_viewgb = config_viewbtninv_y;
		GBOX_AUTO_ALIGN(viewgb, starty_viewgb, intervaly_viewgb, 0, true, false, false);

		local tabTitle = GET_CHILD_RECURSIVELY(frame, "custom_preview_outer_tab_title");
		local starty_slotgb = starty_titlegb + tabTitle:GetHeight(); 
		local intervaly_slotgb = starty_slotgb;
		GBOX_AUTO_ALIGN(slotgb, starty_slotgb, intervaly_slotgb, 5, true, true, false);
	end

	slotgb:Invalidate();
	titlegb:Invalidate();
	viewgb:Invalidate();
end
-------------- custom preview end
-------------- custom rotate
function PUB_CUSTOM_ROTATE_INIT(frame)
	if frame == nil then return; end

	local rotateTitle = GET_CHILD_RECURSIVELY(frame, "rotate_title");
	if rotateTitle == nil then return; end
	rotateTitle:SetTextByKey("value", ClMsg("pubcreate_title_rotate"));
end

function PUB_CUSTOM_ROTATE_RIGHT_DIRECTION(parent, ctrl)
	GetBarrackPub():ChangeDirection(1);
end

function PUB_CUSTOM_ROTATE_LEFT_DIRECTION(parent, ctrl)
	GetBarrackPub():ChangeDirection(2);
end

function PUB_CUSTOM_ROTATE_FRONT_DIRECTION(parent, ctrl)
	GetBarrackPub():ChangeDirectionDefault();
end
-------------- custom rotate end
function PUB_CLICK_ACTOR(actor)
	GetBarrackPub():EnableFocusChar(true, 0);
	local frame = ui.GetFrame("pub_createchar");
	frame:ShowWindow(1);
	PUB_PRECHECK_VIEW_CONTROL(frame, "", "", 1);
	PUB_CHARFRAME_UPDATE(frame, actor);	
end

function PUB_ACTOR_INIT_CUSTOM_SETTING(actor)
	if actor == nil then return; end
	local frame = ui.GetFrame("pub_createchar");
	if frame ~= nil then
		local apc = actor:GetPCApc();
		local gender = apc:GetGender();
		local job = apc:GetJob();
		local headType = apc:GetHeadType();
		local jobCls = GetClassByType("Job", job);
		local ratingstr = jobCls.Rating;
		ratingstr_arg = {}

		local skinIndex = tonumber(frame:GetUserValue("SKIN_SELECT_INDEX"));
		if skinIndex ~= nil and skinIndex ~= 2 then
			frame:SetUserValue("SKIN_SELECT_INDEX", 2);
		end
		customizing_ui.CustomizingSkinChangeDefaultColor(actor);

		local hairType = customizing_ui.GetActorOriginHairType(actor:GetHandleVal());
		if hairType ~= 0 then
			GetBarrackPub():ChangeHairByActor(actor:GetHandleVal(), hairType);
		end

		customizing_ui.ApplyCostumeByIndex(actor:GetHandleVal(), 0);
	end
end

-- run script from code CBarrackPub Class
function PUB_RBTNDOWN()
	local frame = ui.GetFrame("pub_createchar");
	if frame:IsVisible() == 0 then
		return;
	end
	PUB_CANCEL_CREATECHAR(frame);
end

function PUB_BARRACK_NEWCHARACTER(frame)
	frame:ShowWindow(0);
	local input_name = GET_CHILD(frame, "input_name", "ui::CEditControl");
	input_name:ClearText();
end

function PUB_INPUT_NAME_KEY(frame, edit)
	if frame == nil then return; end
	if edit == nil then return; end

	local input_name_text = GET_CHILD_RECURSIVELY(frame, "input_name_text");
	local input_text = edit:GetText();
	if input_text ~= "" then
		if input_name_text ~= nil then
			input_name_text:SetTextByKey("value", "");
		end
	else
		if input_name_text ~= nil then
			input_name_text:SetTextByKey("value", ClMsg("pubcreate_input_name_title"));
		end
	end
end

function PUB_CUSTOM_SLOT_SELECT_CLEAR(frame, slotName)
	if slotName ~= nil then
		local slot = GET_CHILD_RECURSIVELY(frame, slotName);
		if slot ~= nil then
			slot:Select(0);
		end
	end
end

function PUB_SELECT_SLOT_CLEAR(frame, gbName)
	if frame == nil then return; end
	if gbName == nil then return; end

	local gb = GET_CHILD_RECURSIVELY(frame, gbName);
	if gb ~= nil then
		local slotName = "";
		if gb:GetName() == "custom_hairgroup" then
			slotName = "HAIR_SLOT_";
		elseif gb:GetName() == "custom_skingroup" then
			slotName = "SKIN_SLOT_";
		elseif gb:GetName() == "custom_costumegroup" then
			slotName = "COSTUME_SLOT_"
		end

		local childCnt = gb:GetChildCount();
		for i = 1, childCnt do
			local child = gb:GetChildByIndex(i - 1);
			if child ~= nil and child:GetName() == slotName..i then
				slot = tolua.cast(child, "ui::CSlot");
				slot:Select(0);
			end
		end
	end
end

function PUB_PRECHECK_VIEW_CONTROL(frame, msg, argStr, isEnable)
	if frame == nil then return; end
	frame:ShowWindow(1);
	
	local jobgb = GET_CHILD_RECURSIVELY(frame, "jobbg");
	if jobgb ~= nil then
		jobgb:SetVisible(isEnable);
	end

	local statbg = GET_CHILD_RECURSIVELY(frame, "statbg");
	if statbg ~= nil then
		statbg:SetVisible(isEnable);
	end

	local custom_headbg = GET_CHILD_RECURSIVELY(frame, "custom_headbg");
	if custom_headbg ~= nil then
		custom_headbg:SetVisible(isEnable);
	end

	local custom_preview_appearancebg = GET_CHILD_RECURSIVELY(frame, "custom_preview_appearancebg");
	if custom_preview_appearancebg ~= nil then
		custom_preview_appearancebg:SetVisible(isEnable);
	end

	local input_name_text = GET_CHILD_RECURSIVELY(frame, "input_name_text");
	if input_name_text ~= nil then
		input_name_text:SetVisible(isEnable);
	end

	local input_name_skin = GET_CHILD_RECURSIVELY(frame, "input_name_skin");
	if input_name_skin ~= nil then
		input_name_skin:SetVisible(isEnable);
	end

	local input_name = GET_CHILD_RECURSIVELY(frame, "input_name");
	if input_name ~= nil then
		input_name:SetVisible(isEnable);
	end

	local createcharBtn = GET_CHILD_RECURSIVELY(frame, "createcharBtn");
	if createcharBtn ~= nil then
		createcharBtn:SetVisible(isEnable);
	end

	local selectcancleBtn = GET_CHILD_RECURSIVELY(frame, "selectcancleBtn");
	if selectcancleBtn ~= nil then
		selectcancleBtn:SetVisible(isEnable);
	end
end
ADVENTURE_BOOK_GROW = {};

function ADVENTURE_BOOK_GROW.RENEW()
	ADVENTURE_BOOK_GROW.CLEAR();
	ADVENTURE_BOOK_GROW.FILL_CHAR_LIST(gbox);
	ADVENTURE_BOOK_GROW.FILL_CTRL_TYPES();
    ADVENTURE_BOOK_GROW_SET_POINT();
    ADVENTURE_BOOK_GROW_SET_TEAM_LEVEL();
end

function ADVENTURE_BOOK_GROW.CLEAR()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_grow", "ui::CGroupBox");
	local charList = GET_CHILD(page, "grow_char_list", "ui::CGroupBox");

	local warriorList = GET_CHILD(page, "page_grow_warrior", "ui::CGroupBox");
	local wizardList = GET_CHILD(page, "page_grow_wizard", "ui::CGroupBox");
	local archerList = GET_CHILD(page, "page_grow_archer", "ui::CGroupBox");
	local clericList = GET_CHILD(page, "page_grow_cleric", "ui::CGroupBox");

	charList:RemoveAllChild();
	warriorList:RemoveAllChild();
	wizardList:RemoveAllChild();
	archerList:RemoveAllChild();
	clericList:RemoveAllChild();
end

function ADVENTURE_BOOK_GROW.FILL_CHAR_LIST()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_grow", "ui::CGroupBox");
	local gbox = GET_CHILD(page, "grow_char_list", "ui::CGroupBox");

	local char_name_func = ADVENTURE_BOOK_GROW_CONTENT['CHAR_NAME_LIST']
	local char_info_func = ADVENTURE_BOOK_GROW_CONTENT['CHAR_INFO']

	if char_name_func == nil or char_info_func == nil then
		return;
	end

	local char_name_table = char_name_func();

    local yPos = 0;
	for i=1,#char_name_table do
		local charName = char_name_table[i]
		local char_info_table = char_info_func(charName);

		local ctrlSet = gbox:CreateOrGetControlSet("adventure_book_grow_elem", "list_char_" .. i, ui.LEFT, ui.TOP, 0, yPos, 0, 0);
		local icon = GET_CHILD(ctrlSet, "icon_pic", "ui::CPicture");
		icon:SetImage(char_info_table.icon);
		SET_TEXT(ctrlSet, "name_text", "value", char_info_table["name"])
		SET_TEXT(ctrlSet, "level_text", "value", char_info_table["level"])
        ADVENTURE_BOOK_GROW_SET_JOB_HISTORY_TOOLTIP(icon, char_info_table["name"]);
        yPos = yPos + ctrlSet:GetHeight();
	end

    -- companion list
    local petCount = session.pet.GetPetCount();    
    for i = 0, petCount - 1 do    
        local petInfo = session.pet.GetPetInfoByIndex(i);
        if petInfo ~= nil then
            local ctrlSet = gbox:CreateOrGetControlSet("adventure_book_grow_elem", "list_char_pet_"..i , ui.LEFT, ui.TOP, 0, yPos, 0, 0);
		    local icon = GET_CHILD(ctrlSet, "icon_pic", "ui::CPicture");
            local monCls = GetClass('Monster', petInfo:GetClassName());
		    icon:SetImage(GET_MON_ILLUST(monCls));
		    SET_TEXT(ctrlSet, "name_text", "value", petInfo:GetName());
		    SET_TEXT(ctrlSet, "level_text", "value", petInfo:GetLevel());
            yPos = yPos + ctrlSet:GetHeight();
        end
    end
end

function ADVENTURE_BOOK_GROW.FILL_CTRL_TYPES()
	ADVENTURE_BOOK_GROW.FILL_CTRL_TYPE("Warrior", "page_grow_warrior");
	ADVENTURE_BOOK_GROW.FILL_CTRL_TYPE("Wizard", "page_grow_wizard");
	ADVENTURE_BOOK_GROW.FILL_CTRL_TYPE("Archer", "page_grow_archer");
	ADVENTURE_BOOK_GROW.FILL_CTRL_TYPE("Cleric", "page_grow_cleric");
end

function ADVENTURE_BOOK_GROW.FILL_CTRL_TYPE(ctrlType, ctrlName)
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_grow", "ui::CGroupBox");
	local gbox = GET_CHILD(page, ctrlName, "ui::CGroupBox");

	local job_list_func = ADVENTURE_BOOK_GROW_CONTENT['JOB_LIST_BY_TYPE']
	local job_info_func = ADVENTURE_BOOK_GROW_CONTENT['JOB_INFO']

	if job_list_func == nil or job_info_func == nil then
		return;
	end

	local char_name_table = job_list_func(ctrlType);
	
	for i=1,#char_name_table do
		local jobClsID = char_name_table[i]
		local job_info_table = job_info_func(jobClsID);
	
		local width = frame:GetUserConfig("JOB_ELEM_WIDTH")
		local height = frame:GetUserConfig("JOB_ELEM_HEIGHT")

		local x = (i-1)%5*width
		local y = math.floor((i-1)/5)*height
		local ctrlSet = gbox:CreateOrGetControlSet("adventure_book_grow_job_icon", "list_job_" .. i, ui.LEFT, ui.TOP, x, y, 0, 0);
		local icon = GET_CHILD(ctrlSet, "icon_pic", "ui::CPicture");
		icon:SetImage(job_info_table['icon']);
		if job_info_table['has_job'] == 0 then
            local SIHOUETTE_COLOR_TONE = frame:GetUserConfig('SIHOUETTE_COLOR_TONE');
			icon:SetColorTone(SIHOUETTE_COLOR_TONE);
		end
		icon:SetTooltipType('adventure_book_job_info');
		icon:SetTooltipArg(jobClsID, 0, 0);
	end
end

function ADVENTURE_BOOK_GROW.TOOLTIP_JOB(frame, strArg)
	local job_info_func = ADVENTURE_BOOK_GROW_CONTENT['JOB_INFO']
	local job_info_table = job_info_func(strArg);

	SET_TEXT(frame, "jobname_text", "value", job_info_table["name"])
	SET_TEXT(frame, "jobrank_text", "value", job_info_table["ctrltype_and_rank"])
	SET_TEXT(frame, "jobtype_text", "value", job_info_table["type"])
	SET_TEXT(frame, "jobdifficulty_text", "value", job_info_table["difficulty"])
	SET_TEXT(frame, "desc_text", "value", job_info_table["desc"])
end

function ADVENTURE_BOOK_GROW_SET_POINT()
    local adventure_book = ui.GetFrame('adventure_book');
    local page_grow = adventure_book:GetChild('page_grow');
    local total_score_text = page_grow:GetChild('total_score_text');
    local totalScore = ADVENTURE_GROWTH_CATEGORY();   
    total_score_text:SetTextByKey('value', totalScore);
end

function ADVENTURE_BOOK_GROW_SET_TEAM_LEVEL()
    local adventure_book = ui.GetFrame('adventure_book');
    local page_grow = adventure_book:GetChild('page_grow');
    local team_level_text = page_grow:GetChild('team_level_text');
    local team_score_text = page_grow:GetChild('team_score_text');
    local class_score_text = page_grow:GetChild('class_score_text');
    local account = session.barrack.GetMyAccount();
    if account ~= nil then
        team_level_text:SetTextByKey('value', account:GetTeamLevel());
    end
    team_score_text:SetTextByKey('value', GET_ADVENTURE_BOOK_TEAMLEVEL_POINT());
    class_score_text:SetTextByKey('value', GET_ADVENTURE_BOOK_CLASS_POINT());
end

function ADVENTURE_BOOK_GROW_SET_JOB_HISTORY_TOOLTIP(icon, charName)
    -- get job and grade
    local jobHistoryStr = GetCharacterJobHistoryString(pc, charName);
    local jobHistoryList = StringSplit(jobHistoryStr, ';');
	local jobInfoTable = {};
	for i = 1, #jobHistoryList do
		local jobName = jobHistoryList[i];
        if jobInfoTable[jobName] == nil then
            jobInfoTable[jobName] = 1;
        else
            jobInfoTable[jobName] = jobInfoTable[jobName] + 1;
        end
	end

    local gender = info.GetGender(session.GetMyHandle());
    local startext = '';
    for jobName, grade in pairs(jobInfoTable) do
        local jobCls = GetClass('Job', jobName);        
        if jobCls ~= nil then
            startext = startext .. ("{@st41}").. GET_JOB_NAME(jobCls, gender);
        end
        
		for i = 1 , 3 do
			if i <= grade then
				startext = startext ..('{img star_in_arrow 20 20}');
			else
				startext = startext ..('{img star_out_arrow 20 20}');
			end
		end
		startext = startext ..('{nl}');
    end
    icon:SetTextTooltip(startext);
	icon:EnableHitTest(1);
end
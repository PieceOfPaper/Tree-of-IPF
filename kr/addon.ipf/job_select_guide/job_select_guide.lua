
local json = require("json_imc")

function JOB_SELECT_GUIDE_ON_INIT(addon, frame)
    addon:RegisterMsg("JOB_SELECT_GUIDE_OPEN", "JOB_SELECT_GUIDE_ON_MSG");
    JOB_SELECT_GUIDE = {}
end

function JOB_SELECT_GUIDE_ON_MSG(frame, msg, argStr, argNum)
end

function INIT_JOB_SELECT_GUIDE(frame, ctrlType)
    JOB_SELECT_GUIDE = {}
    JOB_SELECT_GUIDE["CTRL_TYPE"] = ctrlType;
    JOB_SELECT_GUIDE["QUESTION_GROUP"] = GET_JOB_SELECT_GUIDE_QUESTIONS(ctrlType);    
    JOB_SELECT_GUIDE["CUR_INDEX"] = 1;
    JOB_SELECT_GUIDE["JOB_STACK"] = INIT_JOB_SELECT_GUIDE_JOB_STACK(ctrlType);

    JOB_SELECT_GUIDE["RESULT_CUR_PAGE"] = 1;
    JOB_SELECT_GUIDE["RESULT_JOB_LIST"] = {};
end

function DEPLOY_JOB_SELECT_GUIDE(frame, ctrlType, index)
    local title_text = GET_CHILD(frame, "title_text");
    
    local gb = GET_CHILD(frame, "gb");
    gb:RemoveAllChild();
    
    local questionGroup = JOB_SELECT_GUIDE["QUESTION_GROUP"][index]
    if questionGroup == nil then
        IMC_LOG("INFO_NORMAL", "QUESTION_GROUP " .. tostring(index));
        return;
    end
    title_text:SetTextByKey("value", ClMsg("JobSelectGuide_"..questionGroup.GROUP_NAME));
    
    local curJobList = JOB_SELECT_GUIDE["JOB_STACK"][index]
    if #curJobList <= 0 then
        IMC_LOG("INFO_NORMAL", "assert");
        return;
    end
    
    local validQuestionList = {}
    for i=1, #questionGroup.QUESTION_CLS_LIST do
        local qna = questionGroup.QUESTION_CLS_LIST[i];
        local intersectList = GET_INTERSECT_TABLE_BY_VALUE(curJobList, qna.JOB_LIST);
        if #intersectList > 0 then
            validQuestionList[#validQuestionList + 1] = {CLS_NAME = qna.CLS_NAME, JOB_LIST = intersectList};
        end
    end
    
    if #validQuestionList <= 0 then
        IMC_LOG("INFO_NORMAL", "assert");
        return;
    end
    
    local cardWidth = ui.GetControlSetAttribute("job_select_guide_card", "width");
    local cardHeight =  ui.GetControlSetAttribute("job_select_guide_card", "height");

    local maxOneLineCnt = frame:GetUserConfig("MaxOneLineCnt");
    maxOneLineCnt = tonumber(maxOneLineCnt);
    local positionList = GET_JOB_SELECT_GUIDE_CARD_POSITION(#validQuestionList, cardWidth, cardHeight, gb:GetWidth(), gb:GetHeight(), 10, 10, maxOneLineCnt)
    for i = 1, #validQuestionList do
        local cls = GetClass("ClassSelectGuide_Question", validQuestionList[i].CLS_NAME);
        if cls == nil then
            IMC_LOG("INFO_NORMAL", "assert");
        end

        local position = positionList[i];
        local ctrlset = gb:CreateOrGetControlSet("job_select_guide_card", "card_"..i, position["x"], position["y"])
        local text = GET_CHILD_RECURSIVELY(ctrlset, "text");
        text:SetTextByKey("value", cls.AnswerName)
        local pic = GET_CHILD_RECURSIVELY(ctrlset, "pic");
        ctrlset:SetUserValue("ClsName", cls.ClassName);
        local point = TryGetProp(cls, "Point");
        point = tonumber(point)
        if point == nil or point == 0 then
            point = 1;
        end
        ctrlset:SetUserValue("Point", point);

        local defaultScale = frame:GetUserConfig("CardDefaultScale");
        local destScale = frame:GetUserConfig("CardDestScale");
        local destAngle = frame:GetUserConfig("CardDestAngle");
        
        defaultScale = tonumber(defaultScale)
        destScale = tonumber(destScale)
        destAngle = tonumber(destAngle)
        
        pic:SetUserValue("DefaultAngle", cls.Angle);
        pic:SetUserValue("DefaultScale", defaultScale);
        pic:SetUserValue("DestScale", destScale);
        pic:SetUserValue("DestAngle", 0);
        pic:Resize(pic:GetWidth()*defaultScale, pic:GetHeight()*defaultScale);
        pic:SetImage(cls.Image);
        pic:SetAngle(cls.Angle);
        pic:SetUserValue("DefaultWidth", pic:GetWidth());
        pic:SetUserValue("DefaultHeight", pic:GetHeight());
        pic:SetEventScript(ui.MOUSEON, "ON_MOUSEON_JOB_SELECT_GUIDE_CARD");
        pic:SetEventScript(ui.MOUSEOFF, "ON_MOUSEOFF_JOB_SELECT_GUIDE_CARD");
    end
end

function SHOW_JOB_SELECT_GUIDE_RESULT_BUTTON(frame, isShow, curPage, pageCnt)
    local left_btn = GET_CHILD(frame, "result_left_btn");
    local right_btn = GET_CHILD(frame, "result_right_btn");
    local page_num_text = GET_CHILD(frame, "page_num_text");
    left_btn:ShowWindow(isShow)
    right_btn:ShowWindow(isShow)
    page_num_text:ShowWindow(isShow)
    if curPage ~= nil and pageCnt ~= nil then
        page_num_text:SetTextByKey("cur", curPage)
        page_num_text:SetTextByKey("max", pageCnt)

        if curPage == 1 then
            left_btn:SetGrayStyle(1)
            left_btn:SetEnable(0);
        else
            left_btn:SetGrayStyle(0)
            left_btn:SetEnable(1);
        end

        if curPage == pageCnt then
            right_btn:SetGrayStyle(1)
            right_btn:SetEnable(0);
        else
            right_btn:SetGrayStyle(0)
            right_btn:SetEnable(1);
        end
    end
end

function ON_OPEN_JOB_SELECT_GUIDE(frame)
	local nowjob = info.GetJob(session.GetMyHandle());
	local nowjCls = GetClassByType("Job", nowjob);
    local ctrlType = nowjCls.CtrlType;
    INIT_JOB_SELECT_GUIDE(frame, ctrlType);
    SHOW_JOB_SELECT_GUIDE_RESULT_BUTTON(frame, 0)    

    DEPLOY_JOB_SELECT_GUIDE(frame, ctrlType, JOB_SELECT_GUIDE["CUR_INDEX"])
end

function ON_CLOSE_JOB_SELECT_GUIDE(frame)
    local gb = GET_CHILD(frame, "gb");
    gb:RemoveAllChild();
    JOB_SELECT_GUIDE = {}
    frame:ShowWindow(0);
end

function ON_BACK_JOB_SELECT_GUIDE(frame)
    SHOW_JOB_SELECT_GUIDE_RESULT_BUTTON(frame, 0)

    if JOB_SELECT_GUIDE["CUR_INDEX"] <= 1 then
        IMC_LOG("INFO_NORMAL", "assert");
        return;
    end

    local curIndex = JOB_SELECT_GUIDE["CUR_INDEX"]
    JOB_SELECT_GUIDE["JOB_STACK"][curIndex] = nil;
    JOB_SELECT_GUIDE["CUR_INDEX"] = curIndex - 1;
    DEPLOY_JOB_SELECT_GUIDE(frame, JOB_SELECT_GUIDE["CTRL_TYPE"], JOB_SELECT_GUIDE["CUR_INDEX"])
end

function ON_RESTART_JOB_SELECT_GUIDE(frame)
    SHOW_JOB_SELECT_GUIDE_RESULT_BUTTON(frame, 0)

    local gb = GET_CHILD(frame, "gb");
    gb:RemoveAllChild();
    
    INIT_JOB_SELECT_GUIDE(frame, JOB_SELECT_GUIDE["CTRL_TYPE"]);
    DEPLOY_JOB_SELECT_GUIDE(frame, JOB_SELECT_GUIDE["CTRL_TYPE"], JOB_SELECT_GUIDE["CUR_INDEX"])
end

function ON_CLICK_JOB_SELECT_GUIDE_CARD(parent, btn)
    local questionClsName = parent:GetUserValue("ClsName");
    local frame = parent:GetTopParentFrame();
    local curIndex = JOB_SELECT_GUIDE["CUR_INDEX"];
    
    local curJobList = JOB_SELECT_GUIDE["JOB_STACK"][curIndex];
    local questionGroup = JOB_SELECT_GUIDE["QUESTION_GROUP"][curIndex]
    
    local selectedQuestionJobList = nil;
    for i=1, #questionGroup.QUESTION_CLS_LIST do
        local qna = questionGroup.QUESTION_CLS_LIST[i];
        if qna.CLS_NAME == questionClsName then
            selectedQuestionJobList = qna.JOB_LIST;
            break;
        end
    end

    local intersectList = GET_INTERSECT_TABLE_BY_VALUE(curJobList, selectedQuestionJobList);
    JOB_SELECT_GUIDE["JOB_STACK"][curIndex + 1] = intersectList;

    if curIndex < #JOB_SELECT_GUIDE["QUESTION_GROUP"] then
        JOB_SELECT_GUIDE["CUR_INDEX"] = curIndex + 1;
        DEPLOY_JOB_SELECT_GUIDE(frame, JOB_SELECT_GUIDE["CTRL_TYPE"], JOB_SELECT_GUIDE["CUR_INDEX"])
    else
        JOB_SELECT_GUIDE["CUR_INDEX"] = curIndex + 1;
        RESULT_JOB_SELECT_GUIDE_CARD(frame);
    end
end

function CALC_RESULT_JOB_SELECT_GUIDE_CARD()
    local curIndex = JOB_SELECT_GUIDE["CUR_INDEX"];
    return JOB_SELECT_GUIDE["JOB_STACK"][curIndex];
end

function RESULT_JOB_SELECT_GUIDE_CARD(frame)
    local COUNT_PER_PAGE = frame:GetUserConfig("ResultCountPerPage");
    COUNT_PER_PAGE = tonumber(COUNT_PER_PAGE);

	local pc = GetMyPCObject();
	local pcjobinfo = GetClass("Job", pc.JobName)
	local pcCtrlType = pcjobinfo.CtrlType

    local title_text = GET_CHILD(frame, "title_text");
    title_text:SetTextByKey("value", ClMsg("JobSelectGuide_Result"));
    
    JOB_SELECT_GUIDE["RESULT_CUR_PAGE"] = 1;
    JOB_SELECT_GUIDE["RESULT_JOB_LIST"] = CALC_RESULT_JOB_SELECT_GUIDE_CARD();

    local pageCount = GET_JOB_SELECT_GUIDE_PAGE_COUNT(#JOB_SELECT_GUIDE["RESULT_JOB_LIST"] , COUNT_PER_PAGE);
    SHOW_JOB_SELECT_GUIDE_RESULT_BUTTON(frame, 1, JOB_SELECT_GUIDE["RESULT_CUR_PAGE"], pageCount)

    UPDATE_JOB_SELECT_GUIDE_RESULT_PAGE(frame, JOB_SELECT_GUIDE["RESULT_JOB_LIST"], JOB_SELECT_GUIDE["RESULT_CUR_PAGE"])    
    local pageCount = GET_JOB_SELECT_GUIDE_PAGE_COUNT(#JOB_SELECT_GUIDE["RESULT_JOB_LIST"] , COUNT_PER_PAGE);
    SHOW_JOB_SELECT_GUIDE_RESULT_BUTTON(frame, 1, JOB_SELECT_GUIDE["RESULT_CUR_PAGE"], pageCount)
end

function UPDATE_JOB_SELECT_GUIDE_RESULT_PAGE(frame, jobList, pageIndex)
    local page_num_text = GET_CHILD(frame, "page_num_text");
    
    local COUNT_PER_PAGE = frame:GetUserConfig("ResultCountPerPage");
    COUNT_PER_PAGE = tonumber(COUNT_PER_PAGE);
    local gb = GET_CHILD(frame, "gb");
    gb:RemoveAllChild();

    local elemCount = GET_JOB_SELECT_GUIDE_RESULT_COUNT_PER_PAGE(#jobList, pageIndex, COUNT_PER_PAGE)

    local width = ui.GetControlSetAttribute("job_select_guide_result", "width");
    local dist = 20;
    local y = 60;

    for i=1, elemCount do
        local clsName = GET_SELECT_GUIDE_JOB_CLASS_NAME(jobList, pageIndex, COUNT_PER_PAGE, i);
        local jobCls = GetClass("Job", clsName);
        if jobCls == nil then
            IMC_LOG("INFO_NORMAL", "assert");
            return nil;
        end

        local x = CALC_CENTER_ALIGN_POSITION(i, elemCount, width, dist, gb:GetWidth())
        local ctrlset = gb:CreateOrGetControlSet("job_select_guide_result", "result_"..i, x, y);
        ctrlset:SetUserValue("JobClassName", clsName);

        local portrait_pic = GET_CHILD(ctrlset, "portrait_pic");
        local job_icon_pic = GET_CHILD(ctrlset, "job_icon_pic");
        local job_name_text = GET_CHILD(ctrlset, "job_name_text");
        
        local guideCls = GetClass("ClassSelectGuide", GET_SELECT_GUIDE_JOB_CLASS_NAME(jobList, pageIndex, COUNT_PER_PAGE, i));
        portrait_pic:SetImage(TryGetProp(guideCls, "Image"));
        job_icon_pic:SetImage(jobCls.Icon)
        job_name_text:SetTextByKey("value", jobCls.Name);

        JOB_SELECT_GUIDE_CLEAR_SUGGESTION(ctrlset);
        GetJobRanking(clsName, "JOB_SELECT_GUIDE_GET_SUGGESTION_RESULT")
    end
end

function JOB_SELECT_GUIDE_CLEAR_SUGGESTION(ctrlset)
    for index = 1, 3 do
        local suggestion = GET_CHILD_RECURSIVELY(ctrlset, "suggestion_"..index);
        local gb = GET_CHILD(suggestion, "gb");
        gb:RemoveAllChild();
    end
end

function JOB_SELECT_GUIDE_SET_SUGGESTION(jobClsName, index, tree)
    local frame = ui.GetFrame("job_select_guide");
    local COUNT_PER_PAGE = frame:GetUserConfig("ResultCountPerPage");
    COUNT_PER_PAGE = tonumber(COUNT_PER_PAGE);
    local gb = GET_CHILD(frame, "gb");
    
    local elemCount = GET_JOB_SELECT_GUIDE_RESULT_COUNT_PER_PAGE(#JOB_SELECT_GUIDE["RESULT_JOB_LIST"], JOB_SELECT_GUIDE["RESULT_CUR_PAGE"], COUNT_PER_PAGE)
    local ctrlset = nil;
    for i=0, elemCount do
        local ctrl = gb:GetControlSet("job_select_guide_result", "result_"..i);
        if ctrl ~= nil and ctrl:GetUserValue("JobClassName") == jobClsName then
            ctrlset = ctrl;
            break;
        end
    end
    if ctrlset == nil then
        return;
    end
    AUTO_CAST(ctrlset)
    
    local jobCls = GetClass("Job", jobClsName)
    if jobCls == nil then
        return;
    end
    
    local suggestion = GET_CHILD_RECURSIVELY(ctrlset, "suggestion_"..index);
    local gb = GET_CHILD(suggestion, "gb");
    gb:RemoveAllChild();
    
    local starTextWidth = tonumber(frame:GetUserConfig("StarTextWidth"));
    local jobTree = PARSE_JOB_SELECT_GUIDE_RANKING(tree);
    for i=1, #jobTree do
        local jobInfo = jobTree[i];
        local width = ui.GetControlSetAttribute("job_select_guide_circle", "width");
        local rank = gb:CreateOrGetControlSet("job_select_guide_circle", "job_"..i, i*width, 0);
        local job_icon_pic = GET_CHILD(rank, "job_icon_pic");
        local circle_text = GET_CHILD(rank, "circle_text");
        
        local job = GetClass("Job", jobInfo["ClassName"]);
        job_icon_pic:SetImage(job.Icon)
        
        local starText = ""
        for i=1, jobInfo["Circle"] do
            starText = starText .. "{img star_in_arrow "..starTextWidth.." "..starTextWidth.."}";
        end
        
        circle_text:SetText(starText)
    end

    suggestion:SetTooltipType("job_select_guide_tree_tooltip");
    suggestion:SetTooltipArg(tree, jobCls.ClassID, 0);
end

function ON_LEFT_JOB_SELECT_GUIDE(parent, btn)
    local frame = parent:GetTopParentFrame();
    local COUNT_PER_PAGE = frame:GetUserConfig("ResultCountPerPage");
    COUNT_PER_PAGE = tonumber(COUNT_PER_PAGE);
    
    local page = JOB_SELECT_GUIDE["RESULT_CUR_PAGE"] - 1;
    if page <= 0 then
        page = 1;
    end

    if page == JOB_SELECT_GUIDE["RESULT_CUR_PAGE"] then
        return;
    end

    JOB_SELECT_GUIDE["RESULT_CUR_PAGE"] = page;
    UPDATE_JOB_SELECT_GUIDE_RESULT_PAGE(frame, JOB_SELECT_GUIDE["RESULT_JOB_LIST"], JOB_SELECT_GUIDE["RESULT_CUR_PAGE"])
    local pageCount = GET_JOB_SELECT_GUIDE_PAGE_COUNT(#JOB_SELECT_GUIDE["RESULT_JOB_LIST"] , COUNT_PER_PAGE);
    SHOW_JOB_SELECT_GUIDE_RESULT_BUTTON(frame, 1, JOB_SELECT_GUIDE["RESULT_CUR_PAGE"], pageCount)
end

function ON_RIGHT_JOB_SELECT_GUIDE(parent, btn)
    local frame = parent:GetTopParentFrame();
    local COUNT_PER_PAGE = frame:GetUserConfig("ResultCountPerPage");
    COUNT_PER_PAGE = tonumber(COUNT_PER_PAGE);

    local page = JOB_SELECT_GUIDE["RESULT_CUR_PAGE"] + 1;
    local pageCount = GET_JOB_SELECT_GUIDE_PAGE_COUNT(#JOB_SELECT_GUIDE["RESULT_JOB_LIST"], COUNT_PER_PAGE);
    if page > pageCount then
        page = pageCount;
    end

    if page == JOB_SELECT_GUIDE["RESULT_CUR_PAGE"] then
        return;
    end

    JOB_SELECT_GUIDE["RESULT_CUR_PAGE"] = page;
    UPDATE_JOB_SELECT_GUIDE_RESULT_PAGE(frame, JOB_SELECT_GUIDE["RESULT_JOB_LIST"], JOB_SELECT_GUIDE["RESULT_CUR_PAGE"])
    local pageCount = GET_JOB_SELECT_GUIDE_PAGE_COUNT(#JOB_SELECT_GUIDE["RESULT_JOB_LIST"] , COUNT_PER_PAGE);
    SHOW_JOB_SELECT_GUIDE_RESULT_BUTTON(frame, 1, JOB_SELECT_GUIDE["RESULT_CUR_PAGE"], pageCount)
end

function ON_MOUSEON_JOB_SELECT_GUIDE_CARD(ctrlset, pic)
    local defaultAngle = pic:GetUserValue("DefaultAngle")
    local defaultScale = pic:GetUserValue("DefaultScale")

    pic:SetUserValue("InitAngle", defaultAngle);
    pic:SetUserValue("InitScale", defaultScale);
    
    pic:StopUpdateScript("ON_UPDATE_MOUSEOFF_GUIDE_CARD")
    pic:RunUpdateScript("ON_UPDATE_MOUSEON_GUIDE_CARD", 0, 0, 0, 1);
end

function ON_MOUSEOFF_JOB_SELECT_GUIDE_CARD(ctrlset, pic)
    local curAngle = pic:GetUserValue("CurAngle")
    local curScale = pic:GetUserValue("CurScale")

    if curAngle ~= "None" then
        pic:SetUserValue("CurAngle", "None");
        pic:SetUserValue("InitAngle", curAngle);
    end
    
    if curScale ~= "None" then
        pic:SetUserValue("CurScale", "None")
        pic:SetUserValue("InitScale", curScale);
    end

    pic:StopUpdateScript("ON_UPDATE_MOUSEON_GUIDE_CARD")
    pic:RunUpdateScript("ON_UPDATE_MOUSEOFF_GUIDE_CARD", 0, 0, 0, 1);
end

function GET_ANGLE_GUIDE_CARD(defaultAngle, destAngle, totalElapsedTime, maxTime)
    local diff = (destAngle-defaultAngle);
    local rate = totalElapsedTime/maxTime;
    local curAngle = defaultAngle + diff*rate;
    return curAngle;
end

function GET_SCALE_GUIDE_CARD(initScale, destScale, totalElapsedTime, maxTime)
    local diff = (destScale-initScale);
    local rate = totalElapsedTime/maxTime;
    local curScale = initScale + diff*rate;
    return curScale;
end

function ON_UPDATE_MOUSEON_GUIDE_CARD(pic, totalElapsedTime)
    AUTO_CAST(pic)
    local defaultAngle = pic:GetUserValue("InitAngle");
    local destAngle = pic:GetUserValue("DestAngle");
    local defaultWidth = pic:GetUserValue("DefaultWidth");
    local defaultHeight = pic:GetUserValue("DefaultHeight");
    local defaultScale = pic:GetUserValue("DefaultScale");
    local destScale = pic:GetUserValue("DestScale");

    local frame = pic:GetTopParentFrame();
    local cardAnimSec = frame:GetUserConfig("CardAnimSec");
    cardAnimSec = tonumber(cardAnimSec);
    if totalElapsedTime > cardAnimSec then
        return 0;
    end

    local curAngle = GET_ANGLE_GUIDE_CARD(defaultAngle, destAngle, totalElapsedTime, cardAnimSec)
    local curScale = GET_SCALE_GUIDE_CARD(defaultScale, destScale, totalElapsedTime, cardAnimSec)
    
    pic:Resize(defaultWidth*curScale, defaultHeight*curScale)
    pic:SetAngle(curAngle)

    pic:SetUserValue("CurAngle", curAngle)
    pic:SetUserValue("CurScale", curScale)
    return 1;
end

function ON_UPDATE_MOUSEOFF_GUIDE_CARD(pic, totalElapsedTime)
    AUTO_CAST(pic)
    local defaultAngle = pic:GetUserValue("DefaultAngle");
    local destAngle = pic:GetUserValue("DestAngle");
    local defaultWidth = pic:GetUserValue("DefaultWidth");
    local defaultHeight = pic:GetUserValue("DefaultHeight");
    local defaultScale = pic:GetUserValue("DefaultScale");
    
    local initAngle = pic:GetUserValue("InitAngle");
    local initScale = pic:GetUserValue("InitScale");
    
    local frame = pic:GetTopParentFrame();
    local cardAnimSec = frame:GetUserConfig("CardAnimSec");
    cardAnimSec = tonumber(cardAnimSec);
    if totalElapsedTime > cardAnimSec then
        return 0;
    end
    
    local curAngle = GET_ANGLE_GUIDE_CARD(initAngle, defaultAngle, totalElapsedTime, cardAnimSec)
    local curScale = GET_SCALE_GUIDE_CARD(initScale, defaultScale, totalElapsedTime, cardAnimSec)
        
    pic:Resize(defaultWidth*curScale, defaultHeight*curScale)
    pic:SetAngle(curAngle)
    return 1; 
end

function UPDATE_JOB_SELECT_GUIDE_TREE_TOOLTIP(frame, tree, jobClsID, num)
    local pc = GetMyPCObject();
    local gender = pc.Gender;

    local jobnametext = ("");
    local startext = ("");
    local jobTree = PARSE_JOB_SELECT_GUIDE_RANKING(tree);
    for i=1, #jobTree do
        local jobInfo = jobTree[i];
        local cls = GetClass("Job", jobInfo["ClassName"])
		jobnametext = jobnametext .. ("{@st41}").. GET_JOB_NAME(cls, gender);
        jobnametext = jobnametext ..('{nl}');
		
		for i = 1 , jobInfo["Circle"] do
			startext = startext ..('{img star_in_arrow 20 20}');
		end
		startext = startext ..('{nl}');
    end
    
    SET_TEXT(frame, "jobname_text", "value", jobnametext)
    SET_TEXT(frame, "star_text", "value", startext)
    
    local totalHeight = frame:GetOriginalHeight() * #jobTree
    frame:Resize(frame:GetOriginalWidth(), totalHeight);
end

function JOB_SELECT_GUIDE_GET_SUGGESTION_RESULT(code, buffer)
    if code ~= 200 then
        IMC_LOG("ERROR_HTTP_FAIL", tostring(code));
        return;
    end

    if buffer == "" then
        return;
    end

    local table = json.decode(buffer)
    for ranking, tree in pairs(table['list']) do
        JOB_SELECT_GUIDE_SET_SUGGESTION(table['clazz'], ranking, tree)
    end
end
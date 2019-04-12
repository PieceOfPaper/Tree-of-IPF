-- indun_char_status.lua
function INDUN_CHAR_STATUS_ON_INIT(addon, frame)

end


function UI_TOGGLE_INDUNINFO_CHAR_UI()
    if app.IsBarrackMode() == true then
        return;
    end

    ui.ToggleFrame('indun_char_status');
end

function INDUNINFO_CHAR_UI_OPEN(frame, msg, argStr, argNum)
    if nil ~= frame then
        frame:ShowWindow(1);
    else
        ui.OpenFrame("indun_char_status");
    end
    local charListBox = GET_CHILD_RECURSIVELY(frame, 'charListBox');
    charListBox:RemoveAllChild();
    local indunClsList, indunCount = GetClassList('Indun');

	local accountInfo = session.barrack.GetMyAccount();

    local cnt = accountInfo:GetBarrackPCCount();
    local SCROLL_WIDTH = 25;
    local ctrlWidth = charListBox:GetWidth() - SCROLL_WIDTH;
	for i = 0 , cnt - 1 do
        local pcInfo = accountInfo:GetBarrackPCByIndex(i);
        local pcName = pcInfo:GetName();
        if pcName ~= session.GetMySession():GetPCApc():GetName() then
            local charGroupBox = charListBox:CreateOrGetControl("groupbox", 'CHARACTER_CTRL_' .. pcName, 3, 10, ctrlWidth, 195)
            charGroupBox:EnableHitTest(0)
            charGroupBox = tolua.cast(charGroupBox, 'ui::CGroupBox')
            charGroupBox:EnableDrawFrame(0)
            local nameLabel = charGroupBox:CreateOrGetControl("richtext", 'CHARACTER_NAME_' .. pcName, 5, 10, ctrlWidth, 50)
            nameLabel:SetText('{@st42b}Lv.' .. pcInfo:GetLevel() .. " " .. pcName)

            local playPerRestTypeTable={}

            --기본 인던들 추가

            for i=1, #g_indunCategoryList do
                charGroupBox:CreateOrGetControl("groupbox", "INDUN_CONTROL_".. g_indunCategoryList[i], 0, 0, ctrlWidth, 20)
            end
            
            for j = 0, indunCount - 1 do
                local indunCls = GetClassByIndexFromList(indunClsList, j)
                if indunCls ~= nil and indunCls.Category ~= 'None' then

                    local indunGroupBox = charGroupBox:CreateOrGetControl("groupbox", "INDUN_CONTROL_".. indunCls.PlayPerResetType, 0, 0, ctrlWidth, 20)
                    indunGroupBox = tolua.cast(indunGroupBox, "ui::CGroupBox")
                    indunGroupBox:EnableDrawFrame(0)
                    local indunLabel = indunGroupBox:CreateOrGetControl("richtext", "INDUN_NAME_" .. indunCls.PlayPerResetType, 20, 0, ctrlWidth / 2, 20)
                    indunLabel = tolua.cast(indunLabel, 'ui::CRichText')
                    indunLabel:SetText('{@st42b}' .. indunCls.Category)
                    indunLabel:SetEnable(0)
                    
                    local indunCntLabel = indunGroupBox:CreateOrGetControl("richtext", "INDUN_COUNT_" .. indunCls.PlayPerResetType, 2, 0, ctrlWidth / 2, 20)
                    indunCntLabel:SetGravity(ui.RIGHT, ui.TOP)
                    indunCntLabel:SetEnable(0)

                    local entranceCount = GET_CHAR_INDUN_ENTRANCE_COUNT(pcInfo.cid, indunCls.PlayPerResetType)
                    if entranceCount ~= nil then
                        if entranceCount == 'None' then
                            entranceCount = 0;
                        end
                        indunCntLabel:SetText("{@st42b}" .. entranceCount .. "/" .. GET_INDUN_MAX_ENTERANCE_COUNT(indunCls.PlayPerResetType))
                    end
                    if indunCls.Level <= pcInfo:GetLevel() or playPerRestTypeTable["INDUN_COUNT_" .. indunCls.PlayPerResetType]==1 then
                        indunLabel:SetEnable(1)
                        indunCntLabel:SetEnable(1)
                        playPerRestTypeTable["INDUN_COUNT_" .. indunCls.PlayPerResetType]=1
                    end
                   

                end
            end
            local silverLabel = charGroupBox:CreateOrGetControl("richtext", 'CHARACTER_SILVER_' .. pcName, 20, 10, ctrlWidth, 20)
            silverLabel:SetText('{@st42b}실버:' .. GET_COMMAED_STRING(pcInfo:GetSilver()))


            local labelLine = charGroupBox:CreateOrGetControl('labelline', "CHARACTER_LINE_" .. pcName, 0, 0, ctrlWidth, 10)
            labelLine:SetSkinName("labelline2")
            GBOX_AUTO_ALIGN(charGroupBox, 0, 3, 0, true, true)
        end
    end
    GBOX_AUTO_ALIGN(charListBox, 5, 5, 0, true, true)
end

function GET_CHAR_INDUN_ENTRANCE_COUNT(cid, resetGroupID)
    local accountInfo = session.barrack.GetMyAccount();

    local indunClsList, cnt = GetClassList('Indun');
    local indunCls = nil;
    for i = 0, cnt - 1 do
        indunCls = GetClassByIndexFromList(indunClsList, i);
        if indunCls ~= nil and indunCls.PlayPerResetType == resetGroupID and indunCls.Category ~= 'None' then
            break;
        end
    end
    
    if indunCls.WeeklyEnterableCount ~= nil and indunCls.WeeklyEnterableCount ~= "None" and indunCls.WeeklyEnterableCount ~= 0 then
        return accountInfo:GetBarrackCharEtcProp(cid,'IndunWeeklyEnteredCount_'..resetGroupID)   --매주 남은 횟수
    else
        return accountInfo:GetBarrackCharEtcProp(cid, 'InDunCountType_'..resetGroupID);            --매일 남은 횟수
    end
end

function GET_INDUN_MAX_ENTERANCE_COUNT(resetGroupID)
    local indunClsList, cnt = GetClassList('Indun');
    local indunCls = nil;
    for i = 0, cnt - 1 do
        indunCls = GetClassByIndexFromList(indunClsList, i);
        if indunCls ~= nil and indunCls.PlayPerResetType == resetGroupID and indunCls.Category ~= 'None' then
            break;
        end
    end
    
    local infinity = TryGetProp(indunCls, 'EnableInfiniteEnter', 'NO')
    if indunCls.AdmissionItemName ~= "None" or infinity == 'YES'  then
        local a = "{img infinity_text 20 10}"
        return a;
    end
    
    local bonusCount = 0;
    if indunCls.WeeklyEnterableCount ~= nil and indunCls.WeeklyEnterableCount ~= "None" and indunCls.WeeklyEnterableCount ~= 0 then
        return indunCls.WeeklyEnterableCount + bonusCount;  --매주 max
    else
        return indunCls.PlayPerReset + bonusCount;          --매일 max
    end
end
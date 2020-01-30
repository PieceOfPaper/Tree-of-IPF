function WEEKLYBOSS_PATTERNINFO_ON_INIT(addon, frame)
    addon:RegisterMsg('WEEKLY_BOSS_UI_UPDATE', 'WEEKLYBOSS_PATTERNINFO_UI_UPDATE');
end
function WEEKLYBOSS_PATTERNINFO_UI_OPEN(frame)
    WEEKLYBOSS_PATTERNINFO_MAKE_LIST(frame)
end

function WEEKLYBOSS_PATTERNINFO_UI_CLOSE()
    ui.CloseFrame('weeklyboss_patterninfo');
end

function WEEKLYBOSS_PATTERNINFO_MAKE_LIST(frame)
    local patternListBox = GET_CHILD_RECURSIVELY(frame, 'patternListBox');
    patternListBox:RemoveAllChild()

    local weeklybossInfo = session.weeklyboss.GetPatternInfo()
    local mapPatternCnt = weeklybossInfo:GetMapPatternCount()

    local ctrlSetHeight = 104

    for i = 0,mapPatternCnt-1 do
        local patternID = weeklybossInfo:GetMapPatternIDByIndex(i)
        local patternCls = GetClassByType('boss_pattern',patternID)

        local patternCtrl = patternListBox:CreateOrGetControlSet('weekly_boss_pattern', 'PATTERN_CTRL_'..i, 0, (ctrlSetHeight-5)*i);
        local patternNameText = GET_CHILD_RECURSIVELY(patternCtrl,'patternName')
        patternNameText:SetText('{@st66b}{s16}'..patternCls.Name)
        local patternPic = GET_CHILD_RECURSIVELY(patternCtrl,'patternPic')
        patternPic:SetImage('icon_'..patternCls.Icon)

        local patternDescText = GET_CHILD_RECURSIVELY(patternCtrl,'patternDesc')
        patternDescText:SetText(patternCls.ToolTip)
    end

    local patternCnt = weeklybossInfo:GetPatternCount()
    for i = 0,patternCnt-1 do
        local patternID = weeklybossInfo:GetPatternIDByIndex(i)
        local patternCls = GetClassByType('boss_pattern',patternID)

        local patternCtrl = patternListBox:CreateOrGetControlSet('weekly_boss_pattern', 'PATTERN_CTRL_'..(i+mapPatternCnt), 0, (ctrlSetHeight-5)*(i+mapPatternCnt));
        local patternNameText = GET_CHILD_RECURSIVELY(patternCtrl,'patternName')
        patternNameText:SetText('{@st66b}{s16}'..patternCls.Name)
        local patternPic = GET_CHILD_RECURSIVELY(patternCtrl,'patternPic')
        patternPic:SetImage('icon_'..patternCls.Icon)

        local patternDescText = GET_CHILD_RECURSIVELY(patternCtrl,'patternDesc')
        patternDescText:SetText(patternCls.ToolTip)
    end
end


function WEEKLYBOSS_PATTERNINFO_UI_UPDATE(frame,msg)
    WEEKLYBOSS_PATTERNINFO_MAKE_LIST(frame)
end
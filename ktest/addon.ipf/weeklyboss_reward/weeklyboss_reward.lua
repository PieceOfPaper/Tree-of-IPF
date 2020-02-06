function WEEKLYBOSS_REWARD_ON_INIT(addon, frame)
    addon:RegisterMsg('WEEKLY_BOSS_RECEIVE_REWARD', 'WEEKLY_BOSS_RECEIVE_REWARD');    
end

function WEEKLYBOSSREWARD_OPEN(frame)

end

function WEEKLYBOSSREWARD_SHOW(index)
    ui.OpenFrame("weeklyboss_reward")
    WEEKLYBOSSREWARD_REWARD_OPEN(index)
end

function WEEKLYBOSSREWARD_CLOSE(frame)

end

function WEEKLYBOSSREWARD_REWARD_OPEN(index)
    local frame = ui.GetFrame("weeklyboss_reward")

    local week_num = WEEKLY_BOSS_RANK_WEEKNUM_NUMBER();
    frame:SetUserValue("WEEK_NUM",week_num)
    local rewardType = ""
    if index == 0 then
        -- 리그 보상(등수)
        local retlist = WEEKLYBOSSREWARD_GET_RANKING_REWARD_LIST(week_num)
        WEEKLYBOSSREWARD_RANK_REWARD_UPDATE(frame, retlist);
        rewardType = "Ranking"
    elseif index == 1 then
        -- 누적 대미지 보상        
        local retlist = WEEKLYBOSSREWARD_GET_ABSOLUTED_REWARD_LIST(week_num)
        WEEKLYBOSSREWARD_ABSOLUTED_REWARD_UPDATE(frame, retlist);
        rewardType = "Damage"
    end
    frame:SetUserValue("REWARD_TYPE",rewardType)
end

function WEEKLYBOSSREWARD_GET_RANKING_REWARD_LIST(week_num)
    local retlist = {};
    local retindex = 1;

    local maxcount = session.weeklyboss.GetRankingRewardSize(week_num);
    for i = 1, maxcount do
        local rewardstr = session.weeklyboss.GetRankingRewardToString(week_num, i);
        if rewardstr == "" then
            break;
        end
        
        local prereward = "";
        if 0 < retindex - 1 then
            prereward = retlist[retindex - 1].rewardstr;
        end

        -- 이전 등수 정보가 없거나 이전 등수와 보상이 다르면 
        if prereward == "" or prereward ~= rewardstr then
            -- 새로운 보상 구간 정보 추가
            local retTable = {};
            retTable['start_rank'] = i;
            retTable['end_rank'] = i
            retTable['rewardstr'] = rewardstr;
            retlist[retindex] = retTable;
            retindex = retindex + 1;
        else
            retlist[retindex - 1].end_rank = i;
        end
    end
    return retlist
end

function WEEKLYBOSSREWARD_GET_ABSOLUTED_REWARD_LIST(week_num)
    local sectionstr = session.weeklyboss.GetAbsolutedSectionToString(week_num);
    local sectionlist = StringSplit(sectionstr, ";");
    table.sort(sectionlist,function(a,b) return IsGreaterThanForBigNumber(b,a)==1 end)
    
    local retlist = {};
    local retindex = 1;
    for i = 1, #sectionlist do
        local rewardstr = session.weeklyboss.GetAbsolutedRewardToString(week_num, sectionlist[i]);
        if rewardstr ~= nil then    
            local retTable = {};
            retTable['point'] = sectionlist[i];
            retTable['rewardstr'] = rewardstr;
            retlist[retindex] = retTable;
            retindex = retindex + 1;
        end
    end
    return retlist
end

-- 누적 대미지 보상 목록 출력
function WEEKLYBOSSREWARD_ABSOLUTED_REWARD_UPDATE(frame, retlist)
    VALIDATE_GET_ALL_REWARD_BUTTON(frame,0)
    local week_num = tonumber(frame:GetUserValue("WEEK_NUM"))
    local rewardgb = GET_CHILD_RECURSIVELY(frame, "rewardgb", "ui::CGroupBox");
    rewardgb:RemoveAllChild();
    local myDamage = session.weeklyboss.GetWeeklyBossAccumulatedDamage(week_num)
    local y = 0;
    local cnt = #retlist -- 보상 구간
    for i = 1, cnt do
        local ctrl = rewardgb:CreateControlSet("content_status_board_reward_attribute", "REWARD_" .. i,  ui.LEFT, ui.TOP, 0, y, 0, 0);
        local attr_value_text = GET_CHILD(ctrl, "attr_value_text", "ui::CRichText");
        attr_value_text:SetFontName("black_16_b");
        
        local ABSOLUTED_FORMAT = frame:GetUserConfig("ABSOLUTED_FORMAT");
        attr_value_text:SetFormat(ABSOLUTED_FORMAT);
        attr_value_text:AddParamInfo("value", STR_KILO_CHANGE(retlist[i].point));
        attr_value_text:UpdateFormat();
        attr_value_text:SetText(""); -- 이게 없으면 위에서 설정한 값이 출력이 안됨
        
        WEEKLYBOSSREWARD_REWARD_LIST_UPDATE(frame, ctrl, retlist[i].rewardstr);

        
        local condComplete = IsGreaterThanForBigNumber(myDamage,retlist[i].point) == 1
        if condComplete == false then
            if myDamage == retlist[i].point then
                condComplete = true;
            end
        end

        local alreayGet = session.weeklyboss.CanAcceptAbsoluteReward(week_num,retlist[i].point) == false
        local rewardType = 1
        if alreayGet == false and condComplete == true then
            rewardType = 1
            VALIDATE_GET_ALL_REWARD_BUTTON(frame,1)
        elseif alreayGet == true then
            rewardType = 4
        else
            rewardType = 3
        end
        WEEKLYBOSSREWARD_ITEM_BUTTON_SET(ctrl,rewardType,retlist[i].point)

        y = y + ctrl:GetHeight();
    end
end

-- 리그 보상 목록 출력
function WEEKLYBOSSREWARD_RANK_REWARD_UPDATE(frame, retlist)
    VALIDATE_GET_ALL_REWARD_BUTTON(frame,0)
    local rewardgb = GET_CHILD_RECURSIVELY(frame, "rewardgb", "ui::CGroupBox");
    rewardgb:RemoveAllChild();
    local week_num = tonumber(frame:GetUserValue("WEEK_NUM"))
    local myrank = session.weeklyboss.GetMyRankInfo(week_num);
    local y = 0;
    local cnt = #retlist -- 랭킹 cnt
    for i = 1, cnt do
        local ctrl = rewardgb:CreateControlSet("content_status_board_reward_attribute", "REWARD_" .. i,  ui.LEFT, ui.TOP, 0, y, 0, 0);
        local attr_value_text = GET_CHILD(ctrl, "attr_value_text", "ui::CRichText");
        attr_value_text:SetFontName("black_16_b");

        local startrank = retlist[i].start_rank;
        local endrank = retlist[i].end_rank;

        if startrank == endrank then
            local RANK_FORMAT = frame:GetUserConfig("RANK_FORMAT_1");

            attr_value_text:SetFormat(RANK_FORMAT);
            attr_value_text:AddParamInfo("value", startrank);
            attr_value_text:UpdateFormat();
                    
            attr_value_text:SetText(""); -- 이게 없으면 위에서 설정한 값이 출력이 안됨

        else
            local RANK_FORMAT = frame:GetUserConfig("RANK_FORMAT_2");
            attr_value_text:SetFormat(RANK_FORMAT);
            attr_value_text:AddParamInfo("min", startrank);
            attr_value_text:AddParamInfo("max", endrank);
            attr_value_text:UpdateFormat();

            attr_value_text:SetText(""); -- 이게 없으면 위에서 설정한 값이 출력이 안됨
        end

        WEEKLYBOSSREWARD_REWARD_LIST_UPDATE(frame, ctrl, retlist[i].rewardstr);
        local alreadyGet = session.weeklyboss.CanAcceptRankingReward(week_num) == false
        if myrank <= retlist[i].end_rank and myrank >= retlist[i].start_rank then
            if alreadyGet==true then
                WEEKLYBOSSREWARD_ITEM_BUTTON_SET(ctrl,4)
            elseif week_num < session.weeklyboss.GetNowWeekNum() then
                WEEKLYBOSSREWARD_ITEM_BUTTON_SET(ctrl,1, myrank)
                VALIDATE_GET_ALL_REWARD_BUTTON(frame,1)
            else
                WEEKLYBOSSREWARD_ITEM_BUTTON_SET(ctrl,2)
            end
        else
            WEEKLYBOSSREWARD_ITEM_BUTTON_SET(ctrl,3)
        end
        y = y + ctrl:GetHeight();
    end
end

-- 구간별 보상 리스트 출력 
function WEEKLYBOSSREWARD_REWARD_LIST_UPDATE(frame, ctrl, rewardstr)    
    local attr_reward_gb = GET_CHILD(ctrl, "attr_reward_gb");
    local attr_btn = GET_CHILD(ctrl, "attr_btn");
    attr_reward_gb:RemoveAllChild();
    
    local OFFSET_SMALL = frame:GetUserConfig("OFFSET_SMALL");
    local OFFSET_MIDDLE = frame:GetUserConfig("OFFSET_MIDDLE");
    local rewardlist = StringSplit(rewardstr, ";")
    local rewardcnt = #rewardlist -- 보상 종류 수
    
    local listy = OFFSET_SMALL + OFFSET_MIDDLE;
    for i = 1, rewardcnt do
        local ctrlSet = attr_reward_gb:CreateControlSet("content_status_board_reward_list_attribute", "REWARD_LIST_" .. i,  ui.LEFT, ui.TOP, 0, listy, 0, 0);
        local attr_pic = GET_CHILD(ctrlSet, "attr_pic");
        local attr_name_text = GET_CHILD(ctrlSet, "attr_name_text");
        local attr_count_text = GET_CHILD(ctrlSet, "attr_count_text");

        local strlist = StringSplit(rewardlist[i], "/");
        local cls = GetClass("Item", strlist[1]);
        if cls == nil then
            return;
        end

        attr_pic:SetImage(GET_ITEM_ICON_IMAGE(cls));
        attr_name_text:SetTextByKey("value", cls.Name);
        attr_count_text:SetTextByKey("value", strlist[2]);

        listy = listy + ctrlSet:GetHeight() + OFFSET_MIDDLE;
    end

    attr_btn:Resize(attr_btn:GetWidth(), listy + OFFSET_MIDDLE);
    attr_reward_gb:Resize(attr_reward_gb:GetWidth(), listy + OFFSET_MIDDLE);
    ctrl:Resize(ctrl:GetWidth(), listy + OFFSET_SMALL);


end
--rewardtype : 1-선택수령가능, 2-모두받기수령가능, 3-조건미충족, 4-수령완료
function WEEKLYBOSSREWARD_ITEM_BUTTON_SET(ctrl,rewardtype, argNum)
    local attr_reward_gb = GET_CHILD(ctrl, "attr_reward_gb");
    local attr_btn = GET_CHILD(ctrl, "attr_btn");
    if rewardtype == 1 then
        attr_btn:SetEventScript(ui.LBUTTONUP, 'WEEKLYBOSSREWARD_REWARD_LIST_CLICK');
        attr_btn:SetEventScriptArgString(ui.LBUTTONUP, argNum);
    elseif rewardtype == 2 then
        attr_btn:EnableHitTest(0)
        return
    elseif rewardtype == 3 then
        attr_btn:SetEnable(0)
    elseif rewardtype == 4 then
        attr_btn:SetEnable(0)
        local stampPic = GET_CHILD(ctrl,'stampPic')
        stampPic:SetImage("adventure_stamp")
    end
end

-- 보상 구간 button 클릭
function WEEKLYBOSSREWARD_REWARD_LIST_CLICK(parent, ctrl, argStr, argNum)
    local frame = parent:GetTopParentFrame()
    
    local rewardType = frame:GetUserValue("REWARD_TYPE")
    if rewardType == 'Damage' then
        local frame = parent:GetTopParentFrame()
        local week_num = tonumber(frame:GetUserValue("WEEK_NUM"))
        weekly_boss.RequestAcceptAbsoluteReward(week_num, argStr);
    elseif rewardType == 'Ranking' then
        local week_num = tonumber(frame:GetUserValue("WEEK_NUM"))
        weekly_boss.RequestAccpetRankingReward(week_num, tonumber(argStr));
    end
   
end

function WEEKLYBOSS_REWARD_GET_ALL(frame,ctrl,argStr,argNum)
    frame = frame:GetTopParentFrame()
    local week_num = tonumber(frame:GetUserValue("WEEK_NUM"))
    local rewardType = frame:GetUserValue("REWARD_TYPE")

    if rewardType == 'Damage' then
        weekly_boss.RequestAcceptAbsoluteRewardAll(week_num);
    elseif rewardType == 'Ranking' then
        local myrank = session.weeklyboss.GetMyRankInfo(week_num);
        weekly_boss.RequestAccpetRankingReward(week_num, myrank);
    end
end


function WEEKLY_BOSS_RECEIVE_REWARD(frame,msg,argStr,argNum)
    local rewardType = frame:GetUserValue("REWARD_TYPE")
    local week_num = tonumber(frame:GetUserValue("WEEK_NUM"))
    if argStr ~= rewardType or week_num ~= argNum then
        return;
    end
    if argStr == 'Ranking' then
        -- 리그 보상(등수)
        local retlist = WEEKLYBOSSREWARD_GET_RANKING_REWARD_LIST(week_num)
        WEEKLYBOSSREWARD_RANK_REWARD_UPDATE(frame, retlist);
    elseif argStr == 'Damage' then
        -- 누적 대미지 보상        
        local retlist = WEEKLYBOSSREWARD_GET_ABSOLUTED_REWARD_LIST(week_num)
        WEEKLYBOSSREWARD_ABSOLUTED_REWARD_UPDATE(frame, retlist);
    end
end

--모두받기 활성화
function VALIDATE_GET_ALL_REWARD_BUTTON(frame, is_enable)
    local btn = GET_CHILD_RECURSIVELY(frame,'btn_reward')
    btn:SetEnable(is_enable)
end
local json = require "json_imc"
local has_kick_claim = false
local has_guild_war_list_claim = false;
local claim_list={}
function HAS_KICK_CLAIM()
    return has_kick_claim
end

function HAS_CLAIM_CODE(code)
    return claim_list[code]
end

function HAS_GUILD_WAR_LIST_CLIAM()
    return has_guild_war_list_claim;
end
function INIT_UI_BY_CLAIM()
    GetPlayerClaims("SET_UI_BY_CLAIM", session.loginInfo.GetAID());
end

function SET_UI_BY_CLAIM(code, ret_json)
    has_kick_claim = false;
    has_guild_war_list_claim = false;
    claim_list={}
    local guild = GET_MY_GUILD_INFO();
    if guild == nil then 
        return
    end

    local frame = ui.GetFrame("guildinfo")

    local settingTab = GET_CHILD_RECURSIVELY(frame, 'settingTab')
    settingTab:SelectTab(0)


    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "SET_UI_BY_CLAIM")
        return
    end

    local ownedClaimList = json.decode(ret_json);

    local isLeader = AM_I_LEADER(PARTY_GUILD);

    local inviteBtn = GET_CHILD_RECURSIVELY(frame, 'inviteBtn');
    inviteBtn:SetEnable(isLeader);

    --tabCtrl:SetTabVisible(1, true);
     -- 리더인 경우 모든 권한이 있으므로 다 활성화, 없으면 전부 비활성화 후 권한에 따라 활성화
    local regEmblemBtn = GET_CHILD_RECURSIVELY(frame, 'regEmblemBtn'); 
    regEmblemBtn:SetEnable(isLeader)
    
    local regBannerBtn = GET_CHILD_RECURSIVELY(frame, 'regBannerBtn')
    regBannerBtn:SetEnable(isLeader);

    local noticeEdit = GET_CHILD_RECURSIVELY(frame, 'noticeEdit')
    noticeEdit:EnableHitTest(isLeader)

    local noticeRegisterBtn = GET_CHILD_RECURSIVELY(frame, "noticeRegisterBtn");
    noticeRegisterBtn:SetEnable(isLeader);

    local regPromoteText = GET_CHILD_RECURSIVELY(frame, 'regPromoteText')
    regPromoteText:SetEnable(isLeader)

    local colonyJoinBtn = GET_CHILD_RECURSIVELY(frame, 'joinRadio_0')
    local colonyJoinBtn1 = GET_CHILD_RECURSIVELY(frame, 'joinRadio_1')
--    colonyJoinBtn:SetEnable(0)
--    colonyJoinBtn1:SetEnable(0)
--    local templerCls = GetClass('Job', 'Char1_16');
--    if IS_EXIST_JOB_IN_HISTORY(templerCls.ClassID) == true then
    colonyJoinBtn:SetEnable(isLeader)
    colonyJoinBtn1:SetEnable(isLeader)
--    end

    local neutralCheck = GET_CHILD_RECURSIVELY(frame, 'neutralCheck')
    neutralCheck:SetEnable(isLeader)

    local postNewTxt = GET_CHILD_RECURSIVELY(frame, 'writeOnelineBoardBtn')
    postNewTxt:SetEnable(isLeader)

    local promoteEdit = GET_CHILD_RECURSIVELY(frame, 'regPromoteText')
    promoteEdit:SetEnable(isLeader)

    local promoteSetBtn = GET_CHILD_RECURSIVELY(frame, 'setPr')
    promoteSetBtn:SetEnable(isLeader)

    local regPromoteImageBtn = GET_CHILD_RECURSIVELY(frame, 'regPromoteImageBtn')
    
    regPromoteImageBtn:SetEnable(isLeader)

    local outsiderCheck = GET_CHILD_RECURSIVELY(frame, 'outsiderCheck')
    outsiderCheck:SetEnable(isLeader)

    local depositBtn =  GET_CHILD_RECURSIVELY(frame, 'depositBtn')
    depositBtn:SetEnable(isLeader)

    local boolIsLeader = false
    if isLeader == 1 then
        boolIsLeader = true
    end

    settingTab:SetTabVisible(1, boolIsLeader)
    settingTab:SetTabVisible(2, boolIsLeader)
   --local titleSetSection = GET_CHILD_RECURSIVELY(frame, 'titleSetSection')
    --titleSetSection:ShowWindow(isLeader)

        --local claimAuthListSection = GET_CHILD_RECURSIVELY(frame, "claimAuthListSection")
        --claimAuthListSection:ShowWindow(isLeader)

        --local claimAuthHeaderSection = GET_CHILD_RECURSIVELY(frame, "claimAuthHeaderSection")
        --claimAuthHeaderSection:ShowWindow(isLeader)

        --local titleListPanelSection = GET_CHILD_RECURSIVELY(frame, "titleListPanelSection")
        --titleListPanelSection:ShowWindow(isLeader)
  
    for index = 1, #ownedClaimList do
        local claim = ownedClaimList[index]

        claim_list[claim] = true

        if claim == 10 then
            has_kick_claim = true;
        elseif claim == 11 then
            inviteBtn:SetEnable(1);
        elseif claim == 15 then -- 엠블렘 교체
            regEmblemBtn:SetEnable(1);
        elseif claim == 16 then -- 배너 교체
            regBannerBtn:SetEnable(1);
        elseif claim == 17 then --직급 임명
            settingTab:SetTabVisible(1, true)
        elseif  claim == 19 then -- 길드 가입 신청서 삭제/수락
            settingTab:SetTabVisible(2, true)
        elseif claim == 202 then -- 공지 쓰기
            noticeEdit:EnableHitTest(1)
            noticeRegisterBtn:SetEnable(1);
        elseif claim == 103 then -- 길드 자금 입금
            depositBtn:SetEnable(1)
        elseif claim == 203 then -- 소개글 쓰기
            regPromoteText:SetEnable(1)
            promoteSetBtn:SetEnable(1)
        elseif claim == 205 then -- 길드 한줄 게시판 등록
            postNewTxt:SetEnable(1)
        elseif claim == 302 then -- 길드 전쟁 중립 설정
            neutralCheck:SetEnable(1)
        elseif claim == 303 then -- 전쟁중인 길드 목록 보기
            has_guild_war_list_claim = true;
        elseif claim == 402 then
            outsiderCheck:SetEnable(1)
        end
    end
	
end


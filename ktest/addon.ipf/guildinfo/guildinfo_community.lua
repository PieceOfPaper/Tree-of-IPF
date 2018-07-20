local json = require "json_imc"

local refreshBoard = false
local isUpdating = false; -- 타임라인 게시글 가져왔는지 여부 확인용
local selectedCard = nil;
local isTimelineEnd = false

local lastBoardIndex = 0;
local lastIndex = 1;

function GUILDINFO_COMMUNITY_INIT(communityBox)
    selectedCard = nil;
    GetGuildNotice("GUILDNOTICE_GET")
    GetTimeLine("ON_TIMELINE_UPDATE", "0", "0")

    local frame = ui.GetFrame("guildinfo");
    local communityPanel = GET_CHILD_RECURSIVELY(frame, "communitypanel", "ui::CGroupBox");
    communityPanel:SetEventScript(ui.SCROLL, "LOAD_MORE_ONLINE_BOARD");
    
    communityPanel:RemoveAllChild()
    lastIndex = 1;
    refreshBoard = false
    isTimelineEnd = false
    lastBoardIndex = 0
end
function GUILDNOTICE_GET(code, ret_json)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "GUILDNOTICE_GET")
    end
    local frame = ui.GetFrame("guildinfo")
    local notifyText = GET_CHILD_RECURSIVELY(frame, 'noticeEdit');
    if notifyText:IsHaveFocus() == 0 then
        notifyText:SetText(ret_json)
        notifyText:Invalidate()
    end

end


function REFRESH_BOARD()
    refreshBoard = true
    --스패밍 자제
    GetTimeLine("ON_TIMELINE_UPDATE", "0", "0");
end


function ON_TIMELINE_UPDATE(code, ret_json)
    isUpdating = false
    if code ~= 200 then
        local splitmsg = StringSplit(ret_json, " ");
        local errorNum = splitmsg[1];
        if errorNum == "1" then
            return;
        end
        SHOW_GUILD_HTTP_ERROR(code, ret_json,"ON_TIMELINE_UPDATE")
        return
    end

    local decoded_json = json.decode(ret_json);
    local list = decoded_json["list"];

    if #list == 0 then
        isTimelineEnd = true
        return;
    end

    local frame = ui.GetFrame("guildinfo");
    local communityPanel = GET_CHILD_RECURSIVELY(frame, "communitypanel", "ui::CGroupBox");
    
    if refreshBoard == true then
        communityPanel:RemoveAllChild();
        lastIndex = 1;
        refreshBoard = false;
    end
    local i = 1;

    for  i = 1, #list do
        local ctrlSet = communityPanel:CreateOrGetControlSet("community_card_layout", lastIndex + i, 0, 0);
        
        ctrlSet:EnableHitTest(1);
        local mainText = GET_CHILD_RECURSIVELY(ctrlSet, "mainText", "ui::CRichText");
        local authorTxt = GET_CHILD_RECURSIVELY(ctrlSet, "writerName", "ui::CRichText");
        local regDateTxt = GET_CHILD_RECURSIVELY(ctrlSet, "date", "ui::CRichText");
        local replyCount = GET_CHILD_RECURSIVELY(ctrlSet, "replyCount", "ui::CRichText");
        local replyPic = GET_CHILD_RECURSIVELY(ctrlSet, "replyPic", "ui::CPicture"); 

        authorTxt:SetText("{@st66d}" .. list[i]["author"] .. "{/}");
        if GETMYFAMILYNAME() == list[i]["author"] then
            
            authorTxt:SetText("{@st66d_y}" .. list[i]["author"] .. "{/}");
        end
        replyCount:SetText(list[i]["comment_count"])
        if list[i]["comment_count"] == 0 then
            replyPic:SetImage("guild_comment_off")
        end

        regDateTxt:SetText(list[i]["reg_time"])
        mainText:SetTextByKey('text',  list[i]["message"])
        mainText:SetUserValue("boardIdx", list[i]["board_idx"]);
        
        local replyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "sendReply", "ui::CButton");
        replyBtn:SetEventScript(ui.LBUTTONUP, "ON_REPLY_SEND")
        replyBtn:SetUserValue("boardIdx", list[i]["board_idx"]);

        OPEN_COMMUNITY_CARD(communityPanel, mainText)

    end
    if #list ~= 0 then
        lastBoardIndex = list[#list]["seq"]
        lastIndex = lastIndex + #list;
        GBOX_AUTO_ALIGN(communityPanel, 0, 0, 0, true, false);
    end
    GBOX_AUTO_ALIGN(communityPanel, 0, 0, 0, true, false);

end
function ON_REPLY_SEND(parent, control)
 
    parent = parent:GetAboveControlset();
    local message = GET_CHILD_RECURSIVELY(parent, "editReply", "ui::CEdit");
    if message:GetText() == "" then
        return;
    end
    local badword = IsBadString(message:GetText());
    if badword ~= nil then
        ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
        return;
    end
   
    WriteOnelineComment("ON_REPLY_SUCCESS", message:GetText(), control:GetUserValue("boardIdx"))
    message:SetText("")
end
function ON_REPLY_SUCCESS(code, ret_json)

    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "ON_REPLY_SUCCESS")
        return
    end

    if selectedCard ~= nil then
        local sendReply = GET_CHILD_RECURSIVELY(selectedCard, "sendReply")

        local boardIdx = sendReply:GetUserValue("boardIdx");

        GetComment("ON_COMMENT_GET", boardIdx);
end

end



function ON_COMMENT_GET(code, ret_json)
    if code ~= 200 then
        if code == 400 then -- 400:댓글이 없거나 로드에 실패함. 이외 코드는 출력해서 보여줌.

        else
            SHOW_GUILD_HTTP_ERROR(code, ret_json, "ON_COMMENT_GET")
        end
        return
    end
    local list = json.decode(ret_json);
    list = list["list"];
    if selectedCard ~= nil then
        local totalHeight = 0;
    
        local replyList = GET_CHILD_RECURSIVELY(selectedCard, "replyBox", "ui::CGroupBox");
        local replyArea = GET_CHILD_RECURSIVELY(selectedCard, "replyArea", "ui::CGroupBox");
        local editReply = GET_CHILD_RECURSIVELY(selectedCard, "editReply", "ui::CEdit");
        local bottomBox = GET_CHILD_RECURSIVELY(selectedCard, "bottomBox", "ui::CGroupBox");
        local bg = GET_CHILD_RECURSIVELY(selectedCard, "mainBg")
        local replyTxt = ""
        local replySetHeight=0;
        for i=1, #list do
            local replySet = replyList:CreateOrGetControlSet("community_card_reply", i, 0, 0)
            replySet:EnableHitTest(0)
            replySetHeight = replySet:GetHeight()
            local replyData = list[i]

            local authorTxt = GET_CHILD_RECURSIVELY(replySet, "commentAuthorText");
            authorTxt:SetText("{@st66d}" .. replyData["author"] .. "{/}");
            if GETMYFAMILYNAME() == replyData["author"] then
                authorTxt:SetText("{@st66d_y}" .. replyData["author"] .. "{/}");
            end
            
            local regTime =  GET_CHILD_RECURSIVELY(replySet, "dateText");
            regTime:SetTextByKey("text", replyData["reg_time"]);

            local replyText = GET_CHILD_RECURSIVELY(replySet, "replyText");
            replyText:SetTextByKey("text", replyData["message"]);
            totalHeight = totalHeight + replySetHeight;
        end
        --기본 컨트롤셋 크기가 댓글 2개는 보이도록 함
        if #list > 2 then
            replyList:Resize(replyList:GetWidth(), totalHeight);
            bottomBox:Resize(bottomBox:GetWidth(), totalHeight + editReply:GetHeight() + 50);
            replyArea:Resize(replyArea:GetWidth(), totalHeight + editReply:GetHeight());
            local replyBoxHeight = totalHeight - (2 * replySetHeight) -- 2 * replySetHeight: 댓글 2개 크기
            replyBoxHeight = replyBoxHeight + editReply:GetHeight();
            replyBoxHeight = replyBoxHeight + 400;
            selectedCard:Resize(selectedCard:GetWidth(), replyBoxHeight );        
        else
            bottomBox:Resize(bottomBox:GetWidth(), 250)
        end
        if selectedCard ~= nil then
            local replyCount = GET_CHILD_RECURSIVELY(selectedCard, "replyCount", "ui::CRichText");
            replyCount:SetText(#list)
        end
        bg:Resize(selectedCard:GetWidth(), selectedCard:GetHeight())
        GBOX_AUTO_ALIGN(replyList, 0, 0, 0, true, false);
        local frame = ui.GetFrame("guildinfo");
        local communityPanel = GET_CHILD_RECURSIVELY(frame, "communitypanel", "ui::CGroupBox");
        GBOX_AUTO_ALIGN(communityPanel, 0, 0, 0, true, false);
    end

end

function LOAD_MORE_ONLINE_BOARD(parent, control)
    if control:GetScrollCurPos() == 0 or isTimelineEnd == true then
        return;
    end
    control = tolua.cast(control, "ui::CGroupBox")
    if control:IsScrollEnd() == true and isUpdating == false then -- 로딩중이면 무시
        GetTimeLine("ON_TIMELINE_UPDATE", lastBoardIndex ,"1")
        isUpdating = true
    end

end

-- 하단 매직넘버(width, height값 uservalue나 userconfig으로 수정해야함)
function OPEN_COMMUNITY_CARD(parent, control)
    local controlset = control:GetAboveControlset();
    controlset = tolua.cast(controlset, "ui::CControlSet")
    selectedCard = controlset;
    local main_box = GET_CHILD_RECURSIVELY(controlset, "main_box");
    local height = controlset:GetHeight()
    local bottomBox = GET_CHILD_RECURSIVELY(controlset, "bottomBox");
    local replyArea =  GET_CHILD_RECURSIVELY(controlset, "replyArea");
    local replyBox = GET_CHILD_RECURSIVELY(controlset, "replyBox");
    local editReply =  GET_CHILD_RECURSIVELY(controlset, "editReply");
    local sendReply = GET_CHILD_RECURSIVELY(controlset, "sendReply");
    local mainText = GET_CHILD_RECURSIVELY(controlset, "mainText", "ui::CRichText");
    local bg = GET_CHILD_RECURSIVELY(controlset, "mainBg")
    if height == 140 then  -- closed. opening
        local additionalTextHeight = mainText:GetHeight() - 100
        if additionalTextHeight > 0 then
            main_box:Resize(main_box:GetWidth(), mainText:GetHeight())
            controlset:Resize(controlset:GetWidth(), 450 + additionalTextHeight)
        else
            main_box:Resize(main_box:GetWidth(), 100)
            controlset:Resize(controlset:GetWidth(), 400)
        end

        bottomBox:Resize(bottomBox:GetWidth(), 250)
        replyArea:SetVisible(1)
        replyBox:SetVisible(1)
        editReply:SetVisible(1)
        local sendReply = GET_CHILD_RECURSIVELY(controlset, "sendReply")

        local boardIdx = sendReply:GetUserValue("boardIdx");

        GetComment("ON_COMMENT_GET", boardIdx);
        bg:Resize(controlset:GetWidth(), controlset:GetHeight())
    else --opened. closing
        controlset:Resize(controlset:GetWidth(), 140)
        main_box:Resize(main_box:GetWidth(), 20)
        bg:Resize(controlset:GetWidth(), 140)
        bottomBox:Resize(bottomBox:GetWidth(), 50)
        replyArea:SetVisible(0)
        
        replyBox:SetVisible(0)
        editReply:SetVisible(0)
    end
    local frame = ui.GetFrame("guildinfo");
    local communityPanel = GET_CHILD_RECURSIVELY(frame, "communitypanel", "ui::CGroupBox");
    GBOX_AUTO_ALIGN(communityPanel, 0, 0, 0, true, false);
end
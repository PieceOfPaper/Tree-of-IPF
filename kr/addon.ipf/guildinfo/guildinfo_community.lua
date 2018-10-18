local json = require "json_imc"

local refreshBoard = false
local isUpdating = false; -- 타임라인 게시글 가져왔는지 여부 확인용
local isTimelineEnd = false

local lastBoardIndex = 0;
local lastIndex = 1;

function GUILDINFO_COMMUNITY_INIT(communityBox)

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
        ctrlSet:SetUserValue("opened", "false")
        local mainText = GET_CHILD_RECURSIVELY(ctrlSet, "mainText", "ui::CRichText");
        local authorTxt = GET_CHILD_RECURSIVELY(ctrlSet, "writerName", "ui::CRichText");
        local regDateTxt = GET_CHILD_RECURSIVELY(ctrlSet, "date", "ui::CRichText");
        local replyCount = GET_CHILD_RECURSIVELY(ctrlSet, "replyCount", "ui::CRichText");
        local replyPic = GET_CHILD_RECURSIVELY(ctrlSet, "replyPic", "ui::CPicture"); 
        if HAS_CLAIM_CODE(207) == nil and AM_I_LEADER(PARTY_GUILD) == 0 then
            local deleteBtn = GET_CHILD_RECURSIVELY(ctrlSet, "card_deleteBtn", "ui::CButton"); 
            deleteBtn:SetEnable(0)
            deleteBtn:SetVisible(0)
        end

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
        ctrlSet:SetUserValue("boardIdx", list[i]["board_idx"]);

        local replyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "sendReply", "ui::CButton");
        replyBtn:SetEventScript(ui.LBUTTONUP, "ON_REPLY_SEND")
        replyBtn:SetUserValue("boardIdx", list[i]["board_idx"]);

        local replyArea = GET_CHILD_RECURSIVELY(ctrlSet, "replyArea", "ui::CGroupBox");
        replyArea:SetVisible(0);
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


function ON_REPLY_SUCCESS(code, ret_json, boardIdx)

    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "ON_REPLY_SUCCESS")
        return
    end

    local boardCtrl = GET_ONELINE_BOARD(boardIdx)
    if boardCtrl == nil then
        return
end
    GetComment("ON_COMMENT_GET", boardIdx);
end



function ON_COMMENT_GET(code, ret_json, boardIdx)
    if code ~= 200 then
        if code ~= 400 then -- 400:댓글이 없거나 로드에 실패함. 이외 코드는 출력해서 보여줌.
            SHOW_GUILD_HTTP_ERROR(code, ret_json, "ON_COMMENT_GET")
        end
        return
    end

    local list = json.decode(ret_json);
    list = list["list"];

    local selectedCard = GET_ONELINE_BOARD(boardIdx)
    if selectedCard == nil then
        return
    end 
    
    local replyBox = GET_CHILD_RECURSIVELY(selectedCard, "replyBox", "ui::CGroupBox");
    local replyArea = GET_CHILD_RECURSIVELY(selectedCard, "replyArea", "ui::CGroupBox");
    local bottomBox = GET_CHILD_RECURSIVELY(selectedCard, "bottomBox", "ui::CGroupBox");
    local mainBg = GET_CHILD_RECURSIVELY(selectedCard, "mainBg")
    replyBox:RemoveAllChild()  
     
    for i=1, #list do
        local replySet = replyBox:CreateOrGetControlSet("community_card_reply", i, 0, 0)
        local replyData = list[i]

        replySet:SetUserValue("comment_idx", replyData["comment_idx"]);


        local authorTxt = GET_CHILD_RECURSIVELY(replySet, "commentAuthorText");
        authorTxt:SetText("{@st66d}" .. replyData["author"] .. "{/}");

        if GETMYFAMILYNAME() == replyData["author"] then
            authorTxt:SetText("{@st66d_y}" .. replyData["author"] .. "{/}");
        end
        authorTxt:SetTextTooltip(replyData["author"]);
            
        local regTime =  GET_CHILD_RECURSIVELY(replySet, "dateText");
        regTime:SetTextByKey("text", replyData["reg_time"]);
        if HAS_CLAIM_CODE(207) == nil and AM_I_LEADER(PARTY_GUILD) == 0 then
            local btn = GET_CHILD_RECURSIVELY(replySet, 'deleteCommentBtn')
            btn:SetEnable(0)
            btn:SetVisible(0)
        end
        local replyText = GET_CHILD_RECURSIVELY(replySet, "replyText");
        replyText:SetTextByKey("text", replyData["message"]);
        replyText:SetUserValue("comment_idx", replyData["comment_idx"])
        replyText:SetUserValue("board_idx", replyData["board_idx"])
    end

    GBOX_AUTO_ALIGN(replyBox, 0, 0, 0, false, true, true)
    GBOX_AUTO_ALIGN(replyArea, 0, 0, 0, true, true, true)
    GBOX_AUTO_ALIGN(bottomBox, 0, 0, 0, true, true, true)
    GBOX_AUTO_ALIGN(mainBg, 0, 0, 10, true, true, true)
    selectedCard:Resize(selectedCard:GetWidth(), mainBg:GetHeight())

    REALIGN_COMMUNITYPANEL()
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

function OPEN_COMMUNITY_CARD(parent, control)
    local controlset = control:GetAboveControlset();
    controlset = tolua.cast(controlset, "ui::CControlSet")

    local mainBg = GET_CHILD_RECURSIVELY(controlset, "mainBg")
    local header = GET_CHILD_RECURSIVELY(controlset, "header");
    
    local main_box = GET_CHILD_RECURSIVELY(controlset, "main_box");
    local bottomBox = GET_CHILD_RECURSIVELY(controlset, "bottomBox");
    local mainText = GET_CHILD_RECURSIVELY(controlset, "mainText", "ui::CRichText");
    local replyArea =  GET_CHILD_RECURSIVELY(controlset, "replyArea");

    if controlset:GetUserValue("opened") == "true" then -- 열려있음. 닫혀야함
        controlset:SetUserValue("opened", "false")
       
        main_box:Resize(main_box:GetWidth(), main_box:GetOriginalHeight())
        
        replyArea:SetVisible(0);
        

    else--닫힘. 열고 코멘트 로드함
        controlset:SetUserValue("opened", "true")
        if mainText:GetHeight() > main_box:GetOriginalHeight() then
            main_box:Resize(main_box:GetWidth(), mainText:GetHeight())
        end
        replyArea:SetVisible(1);

        local sendReply = GET_CHILD_RECURSIVELY(controlset, "sendReply")
        local boardIdx = sendReply:GetUserValue("boardIdx");
        GetComment("ON_COMMENT_GET", boardIdx);
    end
    GBOX_AUTO_ALIGN(bottomBox, 0, 0, 0, true, true, true)
    GBOX_AUTO_ALIGN(mainBg, 0, 0, 10, true, true, true)
    controlset:Resize(controlset:GetWidth(), mainBg:GetHeight())
        

    REALIGN_COMMUNITYPANEL()
end

function REALIGN_COMMUNITYPANEL()
    local frame = ui.GetFrame("guildinfo");
    local communityPanel = GET_CHILD_RECURSIVELY(frame, "communitypanel", "ui::CGroupBox");
    GBOX_AUTO_ALIGN(communityPanel, 0, 0, 0, false, false);
end


function COMMUNITY_CARD_DELETE(frame, control)
    local context = ui.CreateContextMenu("CARD_DELETE_CONTEXT","", 0, 0, 170, 100)
    ui.AddContextMenuItem(context, ClMsg("Delete"), "DELETE_COMMUNITY_CARD(" .. frame:GetUserValue("boardIdx") .. ")");
    ui.AddContextMenuItem(context, ClMsg("Cancel"), "ui.CloseFrame('CARD_DELETE_CONTEXT')")
    ui.OpenContextMenu(context)
end

function DELETE_COMMUNITY_CARD(boardIdx)
    local yesScp = string.format("DeleteBoard(%s, %s)","'ON_DELETE_COMMUNITY_CARD'", boardIdx)
    ui.MsgBox("정말로 삭제하시겠습니까?", yesScp, "None")
    
end

function ON_DELETE_COMMUNITY_CARD(code, ret_json, boardIdx)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json,"ON_DELETE_COMMUNITY_CARD")
        return
    end

    local selectedBoard = GET_ONELINE_BOARD(boardIdx)
    if selectedBoard == nil then
        return
    end

    local parent = selectedBoard:GetParent();
    if parent ~= nil then
        parent:RemoveChild(selectedBoard:GetName())
        selectedBoard = nil;
        REALIGN_COMMUNITYPANEL()
    end
end

function DELETE_ONELINE_COMMENT(frame, control)
    local boardIdx = frame:GetUserValue("board_idx")
    local commentIdx = frame:GetUserValue("comment_idx")
    local yesScp = string.format("DeleteComment(%s, %s, %s)","'ON_DELETE_COMMUNITY_COMMENT'", boardIdx, commentIdx)
    ui.MsgBox("정말로 삭제하시겠습니까?", yesScp, "None")
end

function ON_DELETE_COMMUNITY_COMMENT(code, ret_json, board_idx, comment_idx)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json,"ON_DELETE_COMMUNITY_COMMENT")
        return
    end

    local boardCtrl = GET_ONELINE_BOARD(board_idx)
    if boardCtrl == nil then
        return
    end

    local replyBox = GET_CHILD_RECURSIVELY(boardCtrl, "replyBox", "ui::CGroupBox")
    local childCount = replyBox:GetChildCount()
    for i=0, childCount-1 do
        local child = replyBox:GetChildByIndex(i)
        if child:GetUserValue("comment_idx") == comment_idx then
            replyBox:RemoveChild(child:GetName())
            GBOX_AUTO_ALIGN(replyBox, 0, 0, 0, true, true)
            local replyCount = GET_CHILD_RECURSIVELY(boardCtrl, "replyCount", "ui::CRichText");
            replyCount:SetText( tonumber(replyCount:GetText())-1);
            return
        end
    end
end

function GET_ONELINE_BOARD(board_idx)
    local frame = ui.GetFrame("guildinfo");
    local communityPanel = GET_CHILD_RECURSIVELY(frame, "communitypanel", "ui::CGroupBox");
    
    local childCount = communityPanel:GetChildCount();	
	for i=0, childCount-1 do
        local selectedCard = communityPanel:GetChildByIndex(i);
        
        if selectedCard:GetUserValue("boardIdx") == board_idx then
            return selectedCard;
        end
    end
    return nil;
end
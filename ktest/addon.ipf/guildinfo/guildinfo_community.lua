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
        if code == 400 then -- 400:댓글이 없거나 로드에 실패함. 이외 코드는 출력해서 보여줌.
        else
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
    local totalHeight = 0;
    
    local replyList = GET_CHILD_RECURSIVELY(selectedCard, "replyBox", "ui::CGroupBox");
    local replyArea = GET_CHILD_RECURSIVELY(selectedCard, "replyArea", "ui::CGroupBox");
    local editReply = GET_CHILD_RECURSIVELY(selectedCard, "editReply", "ui::CEdit");
    local bottomBox = GET_CHILD_RECURSIVELY(selectedCard, "bottomBox", "ui::CGroupBox");
    local bg = GET_CHILD_RECURSIVELY(selectedCard, "mainBg")
    local replyTxt = ""
    local replySetHeight=0;
    replyList:RemoveAllChild()
    for i=1, #list do
        local replySet = replyList:CreateOrGetControlSet("community_card_reply", i, 0, 0)
        local replyData = list[i]

        replySet:SetUserValue("comment_idx", replyData["comment_idx"]);
        replySetHeight = replySet:GetHeight()

        local authorTxt = GET_CHILD_RECURSIVELY(replySet, "commentAuthorText");
        authorTxt:SetText("{@st66d}" .. replyData["author"] .. "{/}");

        if GETMYFAMILYNAME() == replyData["author"] then
            authorTxt:SetText("{@st66d_y}" .. replyData["author"] .. "{/}");
        end
            
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
        totalHeight = totalHeight + replySetHeight;
    end
        replyList:Resize(replyList:GetWidth(), totalHeight);
        bottomBox:Resize(bottomBox:GetWidth(), totalHeight + editReply:GetHeight() + 50);
        replyArea:Resize(replyArea:GetWidth(), totalHeight + editReply:GetHeight());

        local replyBoxHeight = totalHeight + replySetHeight
        replyBoxHeight = replyBoxHeight + editReply:GetHeight();
        replyBoxHeight = replyBoxHeight + 100;
        selectedCard:Resize(selectedCard:GetWidth(), replyBoxHeight );      

    local replyCount = GET_CHILD_RECURSIVELY(selectedCard, "replyCount", "ui::CRichText");

    replyCount:SetText(#list)
    bg:Resize(selectedCard:GetWidth(), selectedCard:GetHeight())
    GBOX_AUTO_ALIGN(replyList, 0, 0, 0, true, false);
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

-- 하단 매직넘버(width, height값 uservalue나 userconfig으로 수정해야함)
function OPEN_COMMUNITY_CARD(parent, control)
    local controlset = control:GetAboveControlset();
    controlset = tolua.cast(controlset, "ui::CControlSet")
    local main_box = GET_CHILD_RECURSIVELY(controlset, "main_box");
    local height = controlset:GetHeight()
    local bottomBox = GET_CHILD_RECURSIVELY(controlset, "bottomBox");
    local replyArea =  GET_CHILD_RECURSIVELY(controlset, "replyArea");
    local replyBox = GET_CHILD_RECURSIVELY(controlset, "replyBox");
    local editReply =  GET_CHILD_RECURSIVELY(controlset, "editReply");
    local sendReply = GET_CHILD_RECURSIVELY(controlset, "sendReply");
    local mainText = GET_CHILD_RECURSIVELY(controlset, "mainText", "ui::CRichText");
    local bg = GET_CHILD_RECURSIVELY(controlset, "mainBg")

    replyBox:SetUserValue("card_name", control:GetName())
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
        local replyCount = GET_CHILD_RECURSIVELY(controlset, "replyCount", "ui::CRichText");
        replyCount:SetText('0')
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
    REALIGN_COMMUNITYPANEL()
end

function REALIGN_COMMUNITYPANEL()
    local frame = ui.GetFrame("guildinfo");
    local communityPanel = GET_CHILD_RECURSIVELY(frame, "communitypanel", "ui::CGroupBox");
    GBOX_AUTO_ALIGN(communityPanel, 0, 0, 0, true, false);
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
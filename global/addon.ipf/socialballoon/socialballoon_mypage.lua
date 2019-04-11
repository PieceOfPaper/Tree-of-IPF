-- socialballoon_mypage.lua

function SOCIAL_MYPAGE_MODE_SIMPLE(frame, handle)
	frame:SetSkinName("textballoon_mid");
	local myPageGbox_detail = GET_CHILD(frame, "myPageGbox_detail", "ui::CGroupBox");
	myPageGbox_detail:ShowWindow(0);
	
	local myPageGbox = GET_CHILD(frame, "myPageGbox", "ui::CGroupBox");
	myPageGbox:ShowWindow(1);
	-- MyPageMode
	
	local rootComment = social.GetMyPageModeCommentByIndex(handle, 0);
	
	local titleText = GET_CHILD(myPageGbox, "titleText", "ui::CRichText");
	titleText:EnableSplitBySpace(0);
	titleText:SetText(rootComment.comment);
end

function SOCIAL_MYPAGE_MODE_DETAIL(frame, handle)
	-- Init()
	local myPageGbox = GET_CHILD(frame, "myPageGbox", "ui::CGroupBox");
	myPageGbox:ShowWindow(0);

	frame:SetSkinName("test_win_mypage");
	frame:Resize(320, 420);
	
	local myPageGbox_detail = GET_CHILD(frame, "myPageGbox_detail", "ui::CGroupBox");
	myPageGbox_detail:ShowWindow(1);
	myPageGbox_detail:Resize(270, 370);
	
	local titleText = GET_CHILD(myPageGbox_detail, "myPageTitleText", "ui::CRichText");		
	titleText:SetText(info.GetPCName(handle)..ScpArgMsg("Auto_ui_KeSiPan"));
	
	local commentGroupBox = GET_CHILD(myPageGbox_detail, "commentGbox", "ui::CGroupBox");	
	
	local yPos = 10;
	local myPageMapCount = social.GetMyPageModeCount(handle);
	for i=0, myPageMapCount-1 do
		local rootComment = social.GetMyPageModeCommentByIndex(handle, i);
		yPos = MYPAGE_COMMENT_SMALL_CTRL_SETTING(commentGroupBox, rootComment, yPos, handle);
	end
	
	commentGroupBox:UpdateData();
	commentGroupBox:InvalidateScrollBar();
	
	local myPageVisitBtn = GET_CHILD(myPageGbox_detail, "myPageVisitBtn", "ui::CButton");
	local strscp = string.format("MYPAGE_TARGET_INIT(%d)", handle);
	myPageVisitBtn:SetEventScript(ui.LBUTTONDOWN, strscp);	
end

function MYPAGE_COMMENT_SMALL_CTRL_SETTING(commentGbox, commentStruct, yPos, handle)
	if commentStruct == nil then
		return yPos;
	end

	local xPos = commentStruct.replyDepth * 13;
	local commentCtrl = commentGbox:CreateOrGetControlSet("myPageComment_small", commentStruct.commentIndex.."_comment", xPos+10, yPos);
	commentCtrl:SetValue(commentStruct.commentIndex);	

	local writerIdCtrl = GET_CHILD(commentCtrl, "writerId", "ui::CRichText");
	writerIdCtrl:SetText(commentStruct.writerAccountID);
	
	local commentTextCtrl = GET_CHILD(commentCtrl, "comment", "ui::CRichText");	
	commentTextCtrl:Resize(225 - xPos, 40);
	commentTextCtrl:EnableResizeByText(0);
	commentTextCtrl:SetTextFixWidth(1);
	commentTextCtrl:SetText(commentStruct.comment);
	
	local commentYPos = 25;
	if commentTextCtrl:GetLineCount() >= 2 then
		commentTextCtrl:SetOffset(commentTextCtrl:GetX(), commentYPos);
		commentCtrl:Resize(commentGbox:GetWidth() - xPos - 30, commentTextCtrl:GetHeight() + 40);
	else
		commentTextCtrl:SetOffset(commentTextCtrl:GetX(), commentYPos);
		commentCtrl:Resize(commentGbox:GetWidth() - xPos - 30, commentCtrl:GetHeight());
	end
	
	local replyBtn = GET_CHILD(commentCtrl, "replyBtn", "ui::CButton");	
	replyBtn:SetEventScript(ui.LBUTTONDOWN, "MYPAGE_MODE_NEW_COMMENT");
	replyBtn:SetEventScriptArgNumber(ui.LBUTTONDOWN, handle);

	local deleteBtn = GET_CHILD(commentCtrl, "deleteBtn", "ui::CButton");
	deleteBtn:ShowWindow(0);
	if commentStruct.isDeletePower == true then		
		deleteBtn:ShowWindow(1);
	end
		
	yPos = yPos + commentCtrl:GetHeight();
	return yPos;
end

function MYPAGE_MODE_NEW_COMMENT(commentCtrl, replyBtn, argStr, handle)
	local commentGroupBox = commentCtrl:GetParent();	

	-- InitPos
	local scrollBarCurLine = commentGroupBox:GetCurLine();
	local yPos = 10;
	local myPageMapCount = social.GetMyPageModeCount(handle);
	for i=0, myPageMapCount-1 do
		local rootComment = social.GetMyPageModeCommentByIndex(handle, i);
		local childObj = commentGroupBox:GetChild(rootComment.commentIndex.."_comment");
		if childObj ~= nil then
			childObj:SetOffset(childObj:GetX(), yPos - scrollBarCurLine);
			yPos = yPos + childObj:GetHeight();
		end
	end

	local xPos = 0;
	local ctrlYPos = commentCtrl:GetY() + commentCtrl:GetHeight();
	local newCommentCtrl = commentGroupBox:CreateOrGetControlSet("myPageNewComment_small", "newComment", xPos, ctrlYPos);
	newCommentCtrl:Resize(commentGroupBox:GetWidth() - xPos - 20, commentCtrl:GetHeight());

	local commitBtn = GET_CHILD(newCommentCtrl, "commit", "ui::CButton");
	commitBtn:SetEventScript(ui.LBUTTONUP, "MYPAGE_MODE_NEW_COMMENT_REPLY_REGISTER");	
	commitBtn:SetEventScriptArgNumber(ui.LBUTTONUP, commentCtrl:GetValue());

	local newCommentEditCtrl = GET_CHILD(newCommentCtrl, "writeEdit", "ui::CEditControl");
	newCommentEditCtrl:Resize(commitBtn:GetX() - newCommentEditCtrl:GetX(), newCommentEditCtrl:GetHeight());
	newCommentEditCtrl:MakeTextPack();
	newCommentEditCtrl:SetFontName("white_20");

	local cnt = commentGroupBox:GetChildCount();
	for  i = 0, cnt -1 do
		local childObj = commentGroupBox:GetChildByIndex(i);
		local name = childObj:GetName();
		if string.find(name, "_comment") ~= nil then
			if childObj:GetY() >= ctrlYPos then
				childObj:SetOffset(childObj:GetX(), childObj:GetY() + newCommentCtrl:GetHeight());
			end
		end
	end
	commentGroupBox:SetLineCount(yPos + newCommentCtrl:GetHeight());
	commentGroupBox:InvalidateScrollBar();
	newCommentCtrl:ShowWindow(1);
end

function MYPAGE_MODE_NEW_COMMENT_REPLY_REGISTER(Gbox, ctrl, argStr, argNum)
	local writeEditCtrl = GET_CHILD(Gbox, "writeEdit", "ui::CEditControl");
	if writeEditCtrl:GetText() ~= "" then		
		session.AddMyPageComment(writeEditCtrl:GetText(), argNum);		
		writeEditCtrl:ClearText();
		Gbox:ShowWindow(0);
	end
end

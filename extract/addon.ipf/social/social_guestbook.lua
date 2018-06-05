function GUESTPAGE_LOAD_COMPLETE(frame)
	local guestbookGbox = GET_CHILD(frame, "guestbookGbox", "ui::CGroupBox");	
	GUESTPAGE_SETUP(guestbookGbox);
end

function GUESTPAGE_SETUP(guestPageGBox)
	local isMyPc = false;
	if handle == session.GetMyHandle() then
		isMyPc = true
	end
	
	local commentGroupBox = GET_CHILD(guestPageGBox, "commentGbox", "ui::CGroupBox");
	commentGroupBox:DeleteAllControl();
	
	local yPos = 10;
	local myPageMapCount = session.GetGuestPageCount();
	for i=0, myPageMapCount-1 do
		local rootComment = session.GetGuestPageComment(i);
		local commentTime = session.GetGuestPageCommentTime(i);
		yPos = GUESTBOOK_COMMENT_CTRL_SETTING(commentGroupBox, rootComment, commentTime, yPos, isMyPc);
	end

	commentGroupBox:UpdateData();
	commentGroupBox:InvalidateScrollBar();
end

function GUESTBOOK_COMMENT_CTRL_SETTING(commentGroupBox, commentStruct, commentTime, yPos, isMyPc)
	if commentStruct == nil then
		return yPos;
	end

	local xPos = commentStruct.replyDepth * 30;
	local commentCtrl = commentGroupBox:CreateOrGetControlSet("myPageComment", commentStruct.commentIndex.."_comment", xPos+10, yPos);
	commentCtrl:SetValue(commentStruct.commentIndex);	

	local writerIdCtrl = GET_CHILD(commentCtrl, "writerId", "ui::CRichText");
	writerIdCtrl:SetText(commentStruct.writerCharName);

	local yearStr = tostring(commentTime.wYear);
	yearStr = string.sub(yearStr, 3);

	local timeStr = string.format("{s12}  %s.%d.%d ", yearStr, commentTime.wMonth, commentTime.wDay);
	local commentTextCtrl = GET_CHILD(commentCtrl, "comment", "ui::CRichText");	
	commentTextCtrl:Resize(330 - xPos, 40);
	commentTextCtrl:EnableResizeByText(0);
	commentTextCtrl:SetTextFixWidth(1);
	commentTextCtrl:SetText(commentStruct.comment..timeStr);
	
	local commentYPos = 20;
	if commentTextCtrl:GetLineCount() > 2 then
		commentTextCtrl:SetOffset(commentTextCtrl:GetX(), commentYPos - 10);
		commentCtrl:Resize(commentGroupBox:GetWidth() - xPos - 30, commentTextCtrl:GetHeight() + 20);
	else
		commentTextCtrl:SetOffset(commentTextCtrl:GetX(), commentYPos);
		commentCtrl:Resize(commentGroupBox:GetWidth() - xPos - 30, commentCtrl:GetHeight());
	end

	local textXPos = commentTextCtrl:GetLastTextXPos() + commentTextCtrl:GetX();
	local textYPos = commentTextCtrl:GetLastTextYPos() + commentTextCtrl:GetY();

	local replyBtn = GET_CHILD(commentCtrl, "replyBtn", "ui::CButton");
	replyBtn:SetOffset(textXPos+8, textYPos-3);
	replyBtn:SetEventScript(ui.LBUTTONDOWN, "GUESTBOOK_NEW_COMMENT");
	replyBtn:SetEventScriptArgNumber(ui.LBUTTONDOWN, commentStruct.commentIndex);

	local deleteBtn = GET_CHILD(commentCtrl, "deleteBtn", "ui::CButton");
	deleteBtn:ShowWindow(0);
	if commentStruct.isDeletePower == true then
		deleteBtn:SetOffset(textXPos + replyBtn:GetWidth() + 10, textYPos-3);
		deleteBtn:ShowWindow(1);
	end
	
	local viewCheckBox = GET_CHILD(commentCtrl, "viewComment", "ui::CCheckBox");	
	viewCheckBox:ShowWindow(0);
	
	yPos = yPos + commentCtrl:GetHeight();
	return yPos;
end

function GUESTBOOK_NEW_COMMENT(commentCtrl, replyBtn, argStr, argNum)
	local commentGroupBox = commentCtrl:GetParent();	

	-- InitPos
	local scrollBarCurLine = commentGroupBox:GetCurLine();
	local yPos = 10;
	local myPageMapCount = session.GetGuestPageCount();
	local parentComment = nil;
	
	for i=0, myPageMapCount-1 do
		local rootComment = session.GetGuestPageComment(i);
		if rootComment.commentIndex == argNum then
			parentComment = rootComment;
		end
		
		local childObj = commentGroupBox:GetChild(rootComment.commentIndex.."_comment");
		if childObj ~= nil then
			childObj:SetOffset(childObj:GetX(), yPos - scrollBarCurLine);
			yPos = yPos + childObj:GetHeight();
		end
	end

	local xPos = commentCtrl:GetX() + 30;
	local ctrlYPos = commentCtrl:GetY() + commentCtrl:GetHeight();
	local commentCtrl = commentGroupBox:CreateOrGetControlSet("myPageNewComment", "newComment", xPos, ctrlYPos);
	commentCtrl:Resize(commentGroupBox:GetWidth() - xPos - 20, commentCtrl:GetHeight());

	local commitBtn = GET_CHILD(commentCtrl, "commit", "ui::CButton");
	commitBtn:SetEventScript(ui.LBUTTONUP, "GUESTBOOK_NEW_COMMENT_REPLY_REGISTER");	
	commitBtn:SetEventScriptArgNumber(ui.LBUTTONUP, argNum);
	commitBtn:SetValue(parentComment.replyDepth + 1);

	local newCommentEditCtrl = GET_CHILD(commentCtrl, "writeEdit", "ui::CEditControl");
	newCommentEditCtrl:Resize(commitBtn:GetX() - newCommentEditCtrl:GetX(), newCommentEditCtrl:GetHeight());
	newCommentEditCtrl:MakeTextPack();
	newCommentEditCtrl:SetFontName("white_20");

	local cnt = commentGroupBox:GetChildCount();
	for  i = 0, cnt -1 do
		local childObj = commentGroupBox:GetChildByIndex(i);
		local name = childObj:GetName();
		if string.find(name, "_comment") ~= nil then
			if childObj:GetY() >= ctrlYPos then
				childObj:SetOffset(childObj:GetX(), childObj:GetY() + commentCtrl:GetHeight());
			end
		end
	end
	commentGroupBox:SetLineCount(yPos + commentCtrl:GetHeight());
	commentGroupBox:InvalidateScrollBar();
	commentCtrl:ShowWindow(1);
end

function GUESTBOOK_NEW_COMMENT_REPLY_REGISTER(Gbox, ctrl, argStr, argNum)
	local writeEditCtrl = GET_CHILD(Gbox, "writeEdit", "ui::CEditControl");
	if writeEditCtrl:GetText() ~= "" then
		session.AddGuestBookComment(writeEditCtrl:GetText(), argNum, ctrl:GetValue());
		writeEditCtrl:ClearText();
		Gbox:ShowWindow(0);
	end
end


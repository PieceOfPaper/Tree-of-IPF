function MYPAGE_LOAD_COMPLETE(frame, msg, argStr, argNum)
	local mypageGbox = GET_CHILD(frame, "mypageGbox", "ui::CGroupBox");	
	MYPAGE_SETUP(mypageGbox);
end

function MYPAGE_SETUP(frame)
	local handle = session.GetMyPageOwnerHandle();
	local myInfoCtrlSet = frame:CreateOrGetControlSet("mypageInfo", "accountInfo", 5, 5);

	local myAccountIDCtrl = GET_CHILD(myInfoCtrlSet, "myName", "ui::CRichText");
	myAccountIDCtrl:SetText("{@st43}".. GETMYFAMILYNAME());

	local job 		= info.GetJob(handle);
	local gender 	= info.GetGender(handle);
	local jCls		= GetClassByType('Job', job);
	local jName 	= GET_JOB_NAME(jCls, gender);
	local CharName	= info.GetName(handle);
	local level 	= info.GetLevel(handle);
	local myInfoCtrl = GET_CHILD(myInfoCtrlSet, "myInfo", "ui::CRichText");
	myInfoCtrl:SetText("{@st41b}".. jName.."["..CharName.."]"..", "..level..ClMsg("Level").."{/}");

	local loginTime = session.GetLoginTime();
	local yearStr = tostring(loginTime.wYear);
	yearStr = string.sub(yearStr, 3);
	local timeStr = string.format("{@st42b}%s %s.%d.%d %d:%d", ClMsg("LostLogin"), yearStr, loginTime.wMonth, loginTime.wDay, loginTime.wHour, loginTime.wMinute);

	local myLoginCtrl = GET_CHILD(myInfoCtrlSet, "myLogin", "ui::CRichText");
	myLoginCtrl:SetText(timeStr);
	
	local commentGroupBox = GET_CHILD(frame, "commentGbox", "ui::CGroupBox");
	commentGroupBox:DeleteAllControl();
	
	MYPAGE_WRITE_CTRL_SETTING(frame, handle);
	
	local isMyPc = false;
	if handle == session.GetMyHandle() then
		isMyPc = true
	end

	local yPos = 10;
	local myPageMapCount = session.GetMyPageCount();		
	for i=0, myPageMapCount-1 do
		local rootComment = session.GetMyPageComment(i);
		local commentTime = session.GetMyPageCommentTime(i);
		yPos = MYPAGE_COMMENT_CTRL_SETTING(commentGroupBox, rootComment, commentTime, yPos, isMyPc);
	end
	
	commentGroupBox:UpdateData();
	commentGroupBox:InvalidateScrollBar();
	--frame:ShowWindow(1);
	
	local newCommentCtrl = GET_CHILD(commentGroupBox, "newComment", "ui::CControlSet");
	if newCommentCtrl ~= nil then
		newCommentCtrl:ShowWindow(0);
	end
end

function MYPAGE_COMMENT_CTRL_SETTING(commentGroupBox, commentStruct, commentTime, yPos, isMyPc)
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
	print(commentStruct.comment..timeStr);
	
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
	replyBtn:SetEventScript(ui.LBUTTONDOWN, "MYPAGE_NEW_COMMENT");
	replyBtn:SetEventScriptArgNumber(ui.LBUTTONDOWN, commentStruct.commentIndex);

	local deleteBtn = GET_CHILD(commentCtrl, "deleteBtn", "ui::CButton");
	deleteBtn:ShowWindow(0);
	if commentStruct.isDeletePower == true or isMyPc == true then
		deleteBtn:SetEventScript(ui.LBUTTONUP, "MYPAGE_DELETE_CHECK");
		deleteBtn:SetEventScriptArgNumber(ui.LBUTTONUP, commentStruct.commentIndex);
		deleteBtn:SetOffset(textXPos + replyBtn:GetWidth() + 10, textYPos-3);
		deleteBtn:ShowWindow(1);
	end
	
	local viewCheckBox = GET_CHILD(commentCtrl, "viewComment", "ui::CCheckBox");
	if commentStruct.parentIndex ~= 0 or isMyPc == false then
		viewCheckBox:ShowWindow(0);
	else 
		viewCheckBox:ShowWindow(1);
		viewCheckBox:SetEventScript(ui.LBUTTONDOWN, "VIEW_COMMENT_CHECK");
		viewCheckBox:SetEventScriptArgNumber(ui.LBUTTONDOWN, commentStruct.commentIndex);
	end

	yPos = yPos + commentCtrl:GetHeight();
	return yPos;
end

function MYPAGE_WRITE_CTRL_SETTING(pageGBox, targetHandle)
	local isMyPc = false;
	if targetHandle == session.GetMyHandle() then
		isMyPc = true
	end
	
	local commentGbox = GET_CHILD(pageGBox, "commentGbox", "ui::CGroupBox");
	local writeText = GET_CHILD(pageGBox, "writeText", "ui::CRichText");
	local writeEdit = GET_CHILD(pageGBox, "writeEdit", "ui::CEditControl");
	local writeReg	= GET_CHILD(pageGBox, "writeReg", "ui::CButton");	
	local boardModeOn = GET_CHILD(pageGBox, "boardModeOn", "ui::CButton");
	
	if isMyPc == false then
		writeText:ShowWindow(0);
		writeEdit:ShowWindow(0);
		writeReg:ShowWindow(0);
		boardModeOn:ShowWindow(0);
		pageGBox:Resize(520, 940);
		commentGbox:Resize(510, 770);
	else
		writeText:ShowWindow(1);
		writeEdit:ShowWindow(1);
		writeReg:ShowWindow(1);		
		boardModeOn:ShowWindow(1);
		pageGBox:Resize(520, 940);
		commentGbox:Resize(510, 685);
	end
end

function MYPAGE_NEW_COMMENT(commentCtrl, replyBtn, argStr, argNum)
	local commentGroupBox = commentCtrl:GetParent();	

	-- InitPos
	local scrollBarCurLine = commentGroupBox:GetCurLine();
	local yPos = 10;
	local myPageMapCount = session.GetMyPageCount();
	local parentComment = nil;
	
	for i=0, myPageMapCount-1 do
		local rootComment = session.GetMyPageComment(i);
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
	commitBtn:SetEventScript(ui.LBUTTONUP, "MYPAGE_NEW_COMMENT_REPLY_REGISTER");	
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

function MYPAGE_NEW_COMMENT_REPLY_REGISTER(Gbox, ctrl, argStr, argNum)
	local writeEditCtrl = GET_CHILD(Gbox, "writeEdit", "ui::CEditControl");
	if writeEditCtrl:GetText() ~= "" then		
		session.AddMyPageComment(writeEditCtrl:GetText(), argNum, ctrl:GetValue());		
		writeEditCtrl:ClearText();
		Gbox:ShowWindow(0);		
	end
end

function MYPAGE_DELETE_CHECK(commentCtrl, deleteBtn, argStr, argNum)
	local strScp = string.format("MYPAGE_DELETE_COMMIT(%d)", argNum);
	ui.MsgBoxByBalloon(ClMsg("DeleteQuestion"), strScp, "None");
end

function MYPAGE_DELETE_COMMIT(commentIndex)	
	session.DeleteMyPageComment(commentIndex);
end

function MYPAGE_MODE_START(boardGBox, btnCtrl, argStr, argNum)	
	session.MyPageModeOn(argNum);
end
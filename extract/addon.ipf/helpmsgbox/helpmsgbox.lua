function HELPMSGBOX_ON_INIT(addon, frame)
--	addon:RegisterMsg("HELP_MSG_ADD_DBSAVE_NO", "HELPMSGBOX_MSG");
--	addon:RegisterMsg("HELP_MSG_ADD", "HELPMSGBOX_MSG");
end

function HELPMSGBOX_MSG(frame, msg, argStr, argNum)
	--if msg == "HELP_MSG_ADD_DBSAVE_NO" then
		HELPMSGBOX_POPUP_INIT(frame);
		HELPMSGBOX_POPUP_ADD(frame, argStr, argNum);
	--end
end

function HELPMSGBOX_POPUP_INIT(frame)


	local isDetailBtn = GET_CHILD(frame, "isDetailBtn", "ui::CButton");
	isDetailBtn:SetValue(1);

	CLEAR_GROUPBOX(frame, "detail_explain");
	local detailGroupBox = GET_CHILD(frame, "detail_explain", "ui::CGroupBox");
	
	frame:Resize(frame:GetWidth(), 270 + 440);
	detailGroupBox:Resize(detailGroupBox:GetWidth(), 480);

	local helpSimpleExplainCtrl = GET_CHILD(frame, "simple_explain", "ui::CRichText");

	isDetailBtn:SetText(ScpArgMsg("Auto_{@st41b}JeopKi_"));
	detailGroupBox:SetCurLine(0);
	detailGroupBox:InvalidateScrollBar();
	detailGroupBox:Invalidate();
	frame:Invalidate();
end

function HELP_MSG_SHOW_DETAIL_POPUP(frame, ctrl, argStr, argNum)
	
	local isDetailBtn = tolua.cast(ctrl, "ui::CButton");
	local btnValue = isDetailBtn:GetValue();
	isDetailBtn:SetValue((btnValue == 1) and 0 or 1);

	local detailGroupBox = GET_CHILD(frame, "detail_explain", "ui::CGroupBox");

	if isDetailBtn:GetValue() == 1 then
		detailGroupBox:ShowWindow(1);
		frame:Resize(frame:GetWidth(), 270 + 440);
		detailGroupBox:Resize(detailGroupBox:GetWidth(), 480);
		--detailGroupBox:SetCurLine(0);

		local helpSimpleExplainCtrl = GET_CHILD(frame, "simple_explain", "ui::CRichText");

		isDetailBtn:SetText(ScpArgMsg("Auto_{@st41b}JeopKi_"));
		detailGroupBox:SetCurLine(0);
		detailGroupBox:InvalidateScrollBar();
	else
		detailGroupBox:ShowWindow(0);
		--detailGroupBox:SetCurLine(0);

		local helpSimpleExplainCtrl = GET_CHILD(frame, "simple_explain", "ui::CRichText");
		frame:Resize(frame:GetWidth(), helpSimpleExplainCtrl:GetY() + helpSimpleExplainCtrl:GetHeight() + isDetailBtn:GetHeight());

		isDetailBtn:SetText(ScpArgMsg("Auto_{@st41b}SangSe_BoKi_"));
		detailGroupBox:SetCurLine(0);
		detailGroupBox:InvalidateScrollBar();
	end
end

function HELPMSGBOX_POPUP_ADD(frame, isforceopen, addHelpType)
	local helpCls = GetClassByType("Help", addHelpType);
	if helpCls == nil then
		return;
	end

	if isforceopen ~= "FORCE_OPEN" then -- helplist에서 클릭해서 오픈하는게 아니라면 이미 갖고 있는 헬프들은 두번 팝업하지 않는다.

		local helpType = session.GetHelpTypeByIndex(addHelpType);

		if helpType ~= -1 then
			return;
		end
	end

	local helpTitleCtrl = GET_CHILD(frame, "helpName", "ui::CRichText");
	helpTitleCtrl:SetText("{@st42b}"..helpCls.Title.."{/}");

	local helpSimpleExplainCtrl = GET_CHILD(frame, "simple_explain", "ui::CRichText");
	helpSimpleExplainCtrl:Resize(330, 0);
	helpSimpleExplainCtrl:EnableResizeByText(1);
	helpSimpleExplainCtrl:SetTextFixWidth(1);
	helpSimpleExplainCtrl:SetTextMaxWidth(320);
	helpSimpleExplainCtrl:EnableSplitBySpace(0);
	helpSimpleExplainCtrl:SetText("{@st42b}"..helpCls.SimpleExplain.."{/}");

	local isDetailBtn = GET_CHILD(frame, "isDetailBtn", "ui::CButton");
	--frame:Resize(frame:GetWidth(), helpSimpleExplainCtrl:GetY() + helpSimpleExplainCtrl:GetHeight() + isDetailBtn:GetHeight());

	local detailGroupBox = GET_CHILD(frame, "detail_explain", "ui::CGroupBox");


	detailGroupBox:SetOffset(0, helpSimpleExplainCtrl:GetY() + helpSimpleExplainCtrl:GetHeight() + 7);

	local yPos = 10;
	for index = 1, 20 do
		yPos = HELPMSG_DETAIL_ADD_POPUP(detailGroupBox, helpCls, index, yPos);
	end

	detailGroupBox:SetCurLine(0);
	detailGroupBox:UpdateData();
	detailGroupBox:InvalidateScrollBar();

	detailGroupBox:ShowWindow(1);
	frame:ShowWindow(1);

end

function HELPMSG_DETAIL_ADD_POPUP(groupBox, helpCls, index, yPos)
	if HasClassProperty("Help", helpCls.ClassID, "DetailExplain_"..index) == false then
		return yPos;
	end

	if helpCls["DetailExplain_"..index] == "None" then
		return yPos;
	end

	local xPos = 5;
	local detailCtrlSet = groupBox:CreateOrGetControlSet("helpCtrlSet", "detail"..helpCls["DetailExplain_"..index], xPos, yPos);

	local detailExplainCtrl = GET_CHILD(detailCtrlSet, "detailText", "ui::CRichText");
	local detailExplain = helpCls["DetailExplain_"..index];
	detailExplainCtrl:Resize(330, 0);
	detailExplainCtrl:EnableResizeByText(1);
	detailExplainCtrl:SetTextFixWidth(1);
	detailExplainCtrl:SetTextMaxWidth(320);
	detailExplainCtrl:EnableSplitBySpace(0);
	detailExplainCtrl:SetText("{@st42b}"..detailExplain);
	detailExplainCtrl:SetOffset(5, 5);

	local ctrlSetHeight = detailExplainCtrl:GetHeight();

	local pictureCtrl 	= GET_CHILD(detailCtrlSet, "pic", "ui::CPicture");
	local detailPic		= helpCls["PictureAboutExplain_"..index];
	if detailPic == "None" then
		pictureCtrl:ShowWindow(0);
	else
		pictureCtrl:ShowWindow(1);
		pictureCtrl:SetImage(detailPic);
		pictureCtrl:Resize(5, detailExplainCtrl:GetY() + detailExplainCtrl:GetHeight(), pictureCtrl:GetImageWidth(), pictureCtrl:GetImageHeight());
		ctrlSetHeight = ctrlSetHeight + pictureCtrl:GetHeight();
	end

	local subExplainCtrl = GET_CHILD(detailCtrlSet, "picText", "ui::CRichText");
	local subExplain = helpCls["SubExplainAboutPicture_"..index];
	if subExplain == "None" then
		subExplainCtrl:ShowWindow(0);
	else
		subExplainCtrl:ShowWindow(1);
		subExplainCtrl:SetText("{@st42b}"..subExplain);
		subExplainCtrl:SetOffset(pictureCtrl:GetX(), pictureCtrl:GetY() + pictureCtrl:GetHeight());
		ctrlSetHeight = ctrlSetHeight + subExplainCtrl:GetHeight();
	end

	detailCtrlSet:Resize(370, ctrlSetHeight + 10);

	return yPos + detailCtrlSet:GetHeight();
end


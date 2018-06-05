function PIPHELP_ON_INIT(addon, frame)
	addon:RegisterMsg("HELP_MSG_ADD_DBSAVE_NO", "PIPHELP_MSG");
	addon:RegisterMsg("HELP_MSG_ADD", "PIPHELP_MSG");
	addon:RegisterMsg("HELP_MSG_CLOSE", "PIPHELP_MSG");
end

function PIPHELP_MSG(frame, msg, argStr, argNum)

	if msg == "HELP_MSG_CLOSE" then

		if argNum > 0 then 
			ReserveScript("ui.CloseFrame(\"piphelp\")", argNum);
		else
			frame:ShowWindow(0)
		end
	else

		PIPHELP_POPUP_INIT(frame);
		PIPHELP_POPUP_ADD(frame, msg, argNum);

	end

end

function PIPHELP_POPUP_INIT(frame)

	frame:Invalidate();
end

function HELP_MSG_SHOW_DETAIL_POPUP_OLD(frame, ctrl, argStr, argNum)
	
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

		isDetailBtn:SetText(ScpArgMsg("Auto_JeopKi_"));
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

function PIPHELP_POPUP_ADD(frame, isforceopen, addHelpType)

	local helpCls = GetClassByType("Help", addHelpType);
	if helpCls == nil then
		return;
	end

	local helpTitleCtrl = GET_CHILD_RECURSIVELY(frame, "helpName", "ui::CRichText");
	helpTitleCtrl:SetText(helpCls.Title);

	local helpSimpleExplainCtrl = GET_CHILD_RECURSIVELY(frame, "simple_explain", "ui::CRichText");

	helpSimpleExplainCtrl:Resize(400, 0);
	helpSimpleExplainCtrl:EnableResizeByText(1);
	helpSimpleExplainCtrl:SetTextFixWidth(1);
	helpSimpleExplainCtrl:SetTextMaxWidth(400);
	helpSimpleExplainCtrl:EnableSplitBySpace(0);
	helpSimpleExplainCtrl:SetText(helpCls.SimpleExplain.."{/}");


	local detailGroupBox = GET_CHILD_RECURSIVELY(frame, "detail_explain", "ui::CGroupBox");
	detailGroupBox:RemoveAllChild();
	detailGroupBox:Resize(detailGroupBox:GetOriginalWidth(), detailGroupBox:GetOriginalHeight() )

	local yPos = 10;
	for index = 1, 20 do
		yPos = PIPHELP_DETAIL_ADD_POPUP(detailGroupBox, helpCls, index, yPos);
	end

	frame:ShowWindow(1);

	detailGroupBox:UpdateData();
	detailGroupBox:SetCurLine(0);
	detailGroupBox:InvalidateScrollBar();

	frame:Invalidate();

end

function PIPHELP_DETAIL_ADD_POPUP(groupBox, helpCls, index, yPos)

	if HasClassProperty("Help", helpCls.ClassID, "DetailExplain_"..index) == false then
		return yPos;
	end

	if helpCls["DetailExplain_"..index] == "None" then
		return yPos;
	end

	local xPos = 5;
	DESTROY_CHILD_BYNAME(groupBox, "detail"..helpCls["DetailExplain_"..index]);
local detailCtrlSet = groupBox:CreateControlSet("helpCtrlSet", "detail"..helpCls["DetailExplain_"..index], xPos + 10, yPos);

	local detailExplainCtrl = GET_CHILD(detailCtrlSet, "detailText", "ui::CRichText");
	local detailExplain = helpCls["DetailExplain_"..index];
	detailExplainCtrl:Resize(380, 0);
	detailExplainCtrl:EnableResizeByText(1);
	detailExplainCtrl:SetTextFixWidth(1);
	detailExplainCtrl:SetTextMaxWidth(368);
	detailExplainCtrl:EnableSplitBySpace(0);
	detailExplainCtrl:SetText("{@st42b}"..detailExplain);
	detailExplainCtrl:SetOffset(5, 5);
	detailExplainCtrl:SetUseOrifaceRect(true)

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
	subExplainCtrl:SetUseOrifaceRect(true)

	if subExplain == "None" then
		subExplainCtrl:ShowWindow(0);
	else
		subExplainCtrl:ShowWindow(1);
		subExplainCtrl:SetText("{@st42b}"..subExplain);
		subExplainCtrl:SetOffset(pictureCtrl:GetX(), pictureCtrl:GetY() + pictureCtrl:GetHeight());
		ctrlSetHeight = ctrlSetHeight + subExplainCtrl:GetHeight();
	end

	detailCtrlSet:Resize(380, ctrlSetHeight + 10);

	return yPos + detailCtrlSet:GetHeight();
end


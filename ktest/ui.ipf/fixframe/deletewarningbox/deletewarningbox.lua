-- deleteWarningBox.lua --

function DELETE_WARNING_BOX_ON_INIT(second, petGuid)

	if (nil == second) or (nil == petGuid) then 
		return 1;
	end

	ui.SetEscapeScp("CANCEL_DELETE_WARNING_BOX");

	local frame = ui.GetFrame("deleteWarningBox");	
	DELETE_WARNING_BOX_RESET(frame);
		
	frame:SetUserValue("END_TIME_SECOND", second);	

	
	local pet = barrack.GetPet(petGuid);
	local brkSystem = GetBarrackSystem(pet);
	local petInfo = brkSystem:GetPetInfo();
	local monCls = GetClassByType("Monster", petInfo:GetPetType());	
	local nameStr = string.format("%s (%s)", petInfo:GetName(), monCls.Name);
	frame:SetUserValue("PET_GUID_DEL", petGuid);
	frame:SetUserValue("CHAR_CID_DEL", brkSystem:GetCID());		
	text1 = frame:GetChild("richtext_1");
	text2 = frame:GetChild("richtext_3");
	btnYes = frame:GetChild("button_yes");		
	text1:SetTextByKey("Name", nameStr);		
	text2:SetTextByKey("Name", nameStr);	
		
	DELETE_WARNING_BOX_STAGE(frame, 1);
	DELETE_WARNING_BOX_SETPOS(frame, 1);

	local msg = "{s18}{ol}{#ffffcc}"..ScpArgMsg("CLASS_TYPE_Companion").. "{/}{s35}{@st42}"..  nameStr  .."{/}{/}"..ScpArgMsg("Delete_Target");
	btnYes:SetText(msg);	

	frame:ShowWindow(1);
end

function CANCEL_DELETE_WARNING_BOX()		
	ui.SetEscapeScp("");	
	local frame = ui.GetFrame("deleteWarningBox");	
	CHAR_N_PET_LIST_LOCKMANGED(1);
	DELETE_WARNING_BOX_RESET(frame);
end

function CANCEL_DELETE_WARNING_BOX_TIME(frame, ctrl)	
	frame:StopUpdateScript("DELETE_WARNING_BOX_COUNTTIME");
	CANCEL_DELETE_WARNING_BOX();
end

function DELETE_NOTICE_WARNING_BOX_YES_BTN(frame, ctrl)
	if nil == frame then
		return;
	end

	DELETE_WARNING_BOX_STAGE(frame, 2);
	DELETE_WARNING_BOX_SETPOS(frame, 2);
	
	local startTime = frame:GetUserValue("END_TIME_SECOND");
	frame:SetUserValue("STARTWAITSEC", startTime);
	frame:SetUserValue("ELAPSED_SEC", 0);
	frame:SetUserValue("START_SEC", imcTime.GetAppTime());
	frame:RunUpdateScript("DELETE_WARNING_BOX_COUNTTIME");
	
	local skinFrame2 = frame:GetChild("SkinFrame2");
	skinFrame2:StopAlphaBlend();
end

function DELETE_NOTICE_WARNING_BOX_OK_BTN(frame, ctrl)
	if nil == frame then
		return;
	end
	
	local petGuid = frame:GetUserIValue("PET_GUID_DEL");
	local charCID = frame:GetUserIValue("CHAR_CID_DEL");

	if (petGuid == nil) or (charCID == nil) then
		return 0;
	end;
	
	_EXEC_DELETE_PET(petGuid, charCID);
	CANCEL_DELETE_WARNING_BOX();

	
end

function DELETE_WARNING_BOX_COUNTTIME(frame)
	if nil == frame then
		return 0;
	end
	
	local startWaitSec = frame:GetUserIValue("STARTWAITSEC");
	local elapsedSec = frame:GetUserIValue("ELAPSED_SEC");
	local startSec = frame:GetUserIValue("START_SEC");
	local curSec = imcTime.GetAppTime() -  startSec + elapsedSec;
	local remainSec = startWaitSec - curSec;
	remainSec = math.floor(remainSec);
		
	local textTime = frame:GetChild("richtext_4");	
	local timeTxt = GET_TIME_TXT(remainSec);
	textTime:SetTextByKey("Time", remainSec);	

	if remainSec < 0 then
		local petGuid = frame:GetUserValue("PET_GUID_DEL");
		local charCID = frame:GetUserValue("CHAR_CID_DEL");		
		frame:StopUpdateScript("DELETE_WARNING_BOX_COUNTTIME");
		if (petGuid == nil) or (charCID == nil) then
			CANCEL_DELETE_WARNING_BOX();
			return 0;
		end;
		_EXEC_DELETE_PET(petGuid, charCID);
		CANCEL_DELETE_WARNING_BOX();
		return 1;
	end
	local gauge = GET_CHILD(frame, "progressTime");
	gauge:SetPoint(startWaitSec - remainSec, startWaitSec);
	return 1;
	
end

function DELETE_WARNING_BOX_RESET(frame)
	if nil == frame then
		return;
	end

	frame:SetUserValue("END_TIME_SECOND", "None");
	frame:SetUserValue("PET_GUID_DEL", "None");
	frame:SetUserValue("CHAR_CID_DEL", "None");
	frame:SetUserValue("STARTWAITSEC", "None");		
	frame:SetUserValue("ELAPSED_SEC", "None");
	frame:SetUserValue("START_SEC", "None");		

	frame:ShowWindow(0);									
end

function DELETE_WARNING_BOX_STAGE(frame, stage)
	local text1 = frame:GetChild("richtext_1");	
	local text2 = frame:GetChild("richtext_2");
	local text3 = frame:GetChild("richtext_3");
	local text4 = frame:GetChild("richtext_4");
	local btnYes = frame:GetChild("button_yes");	
	local btnNo = frame:GetChild("button_no");
	local btnCancel = frame:GetChild("button_cancel");	
	local prograss = frame:GetChild("progressTime");	

	if stage == 1 then
		text1:SetVisible(1);
		text2:SetVisible(1);
		text3:SetVisible(0);
		text4:SetVisible(0);
		prograss:SetVisible(0);
		btnYes:SetVisible(1);
		btnNo:SetVisible(1);
		btnCancel:SetVisible(0);
	elseif stage == 2 then
		text1:SetVisible(0);
		text2:SetVisible(0);
		text3:SetVisible(1);
		text4:SetVisible(1);
		prograss:SetVisible(1);
		btnYes:SetVisible(0);
		btnNo:SetVisible(0);
		btnCancel:SetVisible(1);
	end
end

function DELETE_WARNING_BOX_SETPOS(frame, stage)
	local text1 = nil;
	local text2 = nil;
	local btn1= nil;
	local btn2 = nil;
	local prograss = nil;
	if stage == 1 then
		text1 = frame:GetChild("richtext_1");	
		text2 = frame:GetChild("richtext_2");
		btn1 = frame:GetChild("button_yes");	
		btn2 = frame:GetChild("button_no");	
	elseif stage == 2 then
		text1 = frame:GetChild("richtext_3");	
		text2 = frame:GetChild("richtext_4");	
		btn1 = frame:GetChild("button_cancel");	
		prograss = frame:GetChild("progressTime");
	end
		
	local widthFrame = math.max(text1:GetWidth(), text2:GetWidth()) + 80;
	local heightFrame = text2:GetY() + text2:GetHeight();

	if stage == 2 then
		prograss:SetPos( 0,heightFrame);
		widthFrame = prograss:GetWidth() + 80;
		heightFrame = prograss:GetY() + prograss:GetHeight();
	end
			
	local btnWidth = widthFrame - 140;
	if btnWidth < btn1:GetWidth() then
		btnWidth = btn1:GetWidth();
		widthFrame = btnWidth + 140;
	end;

	local btnPosY = heightFrame;
	btnPosY = btnPosY + 10;
	btn1:Resize(btnWidth, btn1:GetHeight());
	btn1:SetPos(widthFrame/2 - btnWidth/2, btnPosY);	

	if stage == 1 then
		btn2:Resize(btn1:GetWidth(), btn1:GetHeight());
		btn2:SetPos(widthFrame/2 - btn2:GetWidth()/2, btnPosY + btn1:GetHeight() + 5);	
		heightFrame = heightFrame + btn1:GetHeight() + 5;
	end
	
	heightFrame = heightFrame + btn1:GetHeight() + 60;
	frame:Resize(widthFrame, heightFrame);	
	
	local skinFrame = frame:GetChild("SkinFrame");	
	local skinFrame2 = frame:GetChild("SkinFrame2");
	skinFrame:Resize(widthFrame, heightFrame);	
	skinFrame2:Resize(widthFrame, heightFrame);	
	skinFrame2:SetAlpha(0.01, 100, 10, 2, "QUIT_ALPHA_BLEND_END", 1);

	--skinFrame:SetColorBlend(1, "FFFF0000", "FFFFFFFF", true);
end
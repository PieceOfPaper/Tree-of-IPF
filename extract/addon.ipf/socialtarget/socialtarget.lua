-- bin/addon/socialtarget/socialtarget.lua
function SOCIALTARGET_ON_INIT(addon, frame)
	addon:RegisterMsg("MYPAGE_LOAD_COMPLETE", "SOCIALTARGET_MSG");
	SOCIAL_GBOX_SHOW(frame, "bgGbox");
end

function SOCIALTARGET_MSG(frame, msg, argStr, argNum)
	if msg == "MYPAGE_LOAD_COMPLETE" then
		local mypageGbox = GET_CHILD(frame, "mypageGbox", "ui::CGroupBox");	
		MYPAGE_SETUP(mypageGbox);
	end
end

function MYPAGET_TARGET_UI_INIT(handle)
	local frame = ui.GetFrame("socialtarget");
	frame:ShowWindow(1);
	
	local bgBox = GET_CHILD(frame, "bgGbox", "ui::CGroupBox");
	
	local name = info.GetName(handle);
	local titleCtrl = GET_CHILD(frame, "title", "ui::CRichText");
	titleCtrl:SetText("{@st43}"..name..ScpArgMsg("Auto_ui_")..ClMsg("Social").."{/}");
	
	SOCIALTARGET_APPS_INIT(bgBox, "mypage", ScpArgMsg("Auto_MaiPeiJi"), "icon_life_mypage", 10, 50);
	SOCIALTARGET_APPS_INIT(bgBox, "guestbook", ScpArgMsg("Auto_BangMyeongLog"), "icon_life_guestbook", 120, 50);
	
	local mypageGbox = GET_CHILD(frame, "mypageGbox", "ui::CGroupBox");	
	MYPAGE_SETUP(mypageGbox);
end

function SOCIALTARGET_APPS_INIT(bgBox, title, titleName, slotImage, xPos, yPos)
	local myPageApp = bgBox:CreateOrGetControlSet("app", title, xPos, yPos);
	local titleText = GET_CHILD(myPageApp, "appName", "ui::CRichText");
	titleText:SetText(titleName);

	local titleSlot = GET_CHILD(myPageApp, "appSlot", "ui::CSlot");
	titleSlot:SetEventScript(ui.LBUTTONUP, "SOCIALTARGET_VIEW_CHANGE");
	titleSlot:SetEventScriptArgString(ui.LBUTTONUP, title);

	local icon = CreateIcon(titleSlot);
	icon:SetImage(slotImage);

	local labelBox = myPageApp:GetChild("appNotice");
	labelBox:ShowWindow(0);
	local labelBoxText = GET_CHILD(myPageApp, "appNoticetext", "ui::CRichText");
	labelBoxText:ShowWindow(0);
end

function SOCIALTARGET_VIEW_CHANGE(frame, ctrlSet, selectName, argNum)
	local frame = ui.GetFrame("socialtarget");
	SOCIAL_GBOX_SHOW(frame, selectName.."Gbox");

	if selectName == "mypage" then
		SOCIAL_MYPAGE_VIEW(frame);
	elseif selectName == "guestbook" then
		SOCIAL_GUESTBOOK_VIEW(frame);	
	end
end

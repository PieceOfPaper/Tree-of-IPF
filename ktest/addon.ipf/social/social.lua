-- bin/addon/social/social.lua
function SOCIAL_ON_INIT(addon, frame)
	addon:RegisterMsg("MYPAGE_LOAD_COMPLETE", "SOCIAL_MSG");
	addon:RegisterMsg("SOCIAL_SELL_ITEM_LIST", "SOCIAL_MSG");
end

function SOCIAL_CREATE(addon, frame)

	SOCIAL_GBOX_SHOW(frame, "bgGbox");
	SOCIAL_BGBOX_INTI(frame);

end

function SOCIAL_OPEN(frame)
	MYPAGE_LOAD_COMPLETE(frame);
	GUESTPAGE_LOAD_COMPLETE(frame);
end

function SOCIAL_CLOSE(frame)
	session.SetMyPageOwnerHandle(session.GetMyHandle());
end

function SOCIAL_FIRST_OPEN(frame)
	SOCIAL_SELL_INIT(frame);
	SOCIAL_BUY_INIT(frame);
	SOCIAL_GBOX_SHOW(frame, "bgGbox");
end

function SOCIAL_MSG(frame, msg, argStr, argNum)

	if msg == "MYPAGE_LOAD_COMPLETE" or msg == "GAME_START" then
		MYPAGE_LOAD_COMPLETE(frame);
		GUESTPAGE_LOAD_COMPLETE(frame);
	end
	
	if msg == "SOCIAL_SELL_ITEM_LIST" then
		SOCIAL_SELL_ITEM_LIST(frame);
	end
end

function SOCIAL_BGBOX_INTI(frame)
	local bgBox = GET_CHILD(frame, "bgGbox", "ui::CGroupBox");

	SOCIAL_APPS_INIT(bgBox, "mypage", ScpArgMsg("Auto_MaiPeiJi"), "icon_life_mypage", 10, 50);
	SOCIAL_APPS_INIT(bgBox, "guestbook", ScpArgMsg("Auto_BangMyeongLog"), "icon_life_guestbook", 120, 50);
--	SOCIAL_APPS_INIT(bgBox, "friend", ScpArgMsg("Auto_ChinKu"), "icon_life_mypage", 230, 50);

	SOCIAL_APPS_INIT(bgBox, "sell", ScpArgMsg("Auto_KaeinSangJeom"), "icon_life_sell", 10, 210);
--	SOCIAL_APPS_INIT(bgBox, "buy", ScpArgMsg("Auto_KuMaeyoCheong"), "icon_life_buy", 120, 210);
--	SOCIAL_APPS_INIT(bgBox, "trade", ScpArgMsg("Auto_MulPumKeoLae"), "icon_life_trade", 230, 210);

--	SOCIAL_APPS_INIT(bgBox, "mercenary", ScpArgMsg("Auto_yongByeongKyeyag"), "icon_life_mercenary", 10, 370);
	SOCIAL_APPS_INIT(bgBox, "pose", ScpArgMsg("Auto_JeSeuChyeo"), "icon_life_pose", 10, 370);
end

function SOCIAL_APPS_INIT(bgBox, title, titleName, slotImage, xPos, yPos)
	local myPageApp = bgBox:CreateOrGetControlSet("app", title, xPos, yPos);
	local titleText = GET_CHILD(myPageApp, "appName", "ui::CRichText");
	titleText:SetText(titleName);

	local titleSlot = GET_CHILD(myPageApp, "appSlot", "ui::CSlot");
	titleSlot:SetEventScript(ui.LBUTTONUP, "SOCIAL_VIEW_CHANGE");
	titleSlot:SetEventScriptArgString(ui.LBUTTONUP, title);

	local icon = CreateIcon(titleSlot);
	icon:SetImage(slotImage);

	local labelBox = myPageApp:GetChild("appNotice");
	labelBox:ShowWindow(0);
	local labelBoxText = GET_CHILD(myPageApp, "appNoticetext", "ui::CRichText");
	labelBoxText:ShowWindow(0);
end

function SOCIAL_VIEW_CHANGE(frame, ctrlSet, selectName, argNum)
	frame = ui.GetFrame("social");
	if frame == nil then
		return;
	end
	SOCIAL_GBOX_SHOW(frame, selectName.."Gbox");

	if selectName == "mypage" then
		SOCIAL_MYPAGE_VIEW(frame);
	elseif selectName == "guestbook" then
		SOCIAL_GUESTBOOK_VIEW(frame);
	elseif selectName == "sell" then
		SOCIAL_SELL_VIEW(frame);
	elseif selectName == "buy" then
		SOCIAL_BUY_VIEW(frame);
	elseif selectName == "mercenary" then
		SOCIAL_MERCENARY_VIEW(frame);
	elseif selectName == "pose" then
		SOCIAL_POSE_VIEW(frame);
	end
end

function SOCIAL_VIEW_ALLVIEW(frame, btnCtrl, argStr, argNum)
	SOCIAL_GBOX_SHOW(frame, "bgGbox");
	local descText = GET_CHILD(frame, "descText", "ui::CRichText");
	descText:SetText(ScpArgMsg("Auto_MoDu_BoKi"));
	frame:Invalidate();
end


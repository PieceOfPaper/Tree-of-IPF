
function CHAT_EMOTICON_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg('ADD_CHAT_EMOTICON', 'CHAT_EMOTICON_MAKELIST');
end

function CHAT_EMOTICON_OPEN(frame)
	CHAT_EMOTICON_MAKELIST(frame);
	frame:RunUpdateScript("_CHAT_EMOTICON_UPDATE", 0.001);
	frame:SetDuration(3);
end
	
function CHAT_EMOTICON_CLOSE(frame)
	local emo_frame = ui.GetFrame('chat_emoticon');
	emo_frame:ShowWindow(0);
end

function _CHAT_EMOTICON_UPDATE(frame, ctrl)
	if 1 == keyboard.IsKeyPressed("ESCAPE") then
		frame:ShowWindow(0);	
	end
	
	if keyboard.IsKeyDown("ENTER") == 1 or keyboard.IsKeyDown("PADENTER") == 1 then
		frame:ShowWindow(0);	
	end

	return 1;
end

function CHAT_EMOTICON_ADDDURATION()
	local emo_frame = ui.GetFrame('chat_emoticon');
	emo_frame:SetDuration(3);
end

function CHAT_EMOTICON_MAKELIST(frame)

	local emoticons = GET_CHILD(frame, "emoticons", "ui::CSlotSet");
	local cnt = emoticons:GetSlotCount();
	local etc = GetMyEtcObject();
	local index = 0;
	local list, listCnt = GetClassList("chat_emoticons");

	-- 아이콘 타입 확인 : 일반, 모션
	local iconGroup = frame:GetUserValue("EMOTICON_GROUP");
	local curCnt = frame:GetUserIValue("CURCNT");
	if iconGroup == "None" then
		iconGroup = "Normal";
	end

	for i = 0 , listCnt - 1 do
		local slot = emoticons:GetSlotByIndex(index);
		slot:SetEventScript(ui.MOUSEMOVE, "CHAT_EMOTICON_ADDDURATION");	
		slot:SetOverSound("button_over")
		slot:SetClickSound("button_click_chat")
		if index < cnt then
			local cls = GetClassByIndexFromList(list, i);

			if cls.IconGroup == iconGroup then
				if cls.CheckServer == 'YES' then
					-- check session emoticons
					local haveEmoticon = TryGetProp(etc, 'HaveEmoticon_' .. cls.ClassID);
					if haveEmoticon > 0 then
						local icon = CreateIcon(slot);
						local namelist = StringSplit(cls.ClassName, "motion_");
						local imageName = namelist[1];
						if 1 < #namelist then
							imageName = namelist[2];
						end
						
						icon:SetImage(imageName);
						local tooltipText = string.format( "%s%s" , "/" ,cls.IconTokken);
						icon:SetTextTooltip(tooltipText);

						index = index + 1;				
						slot:ShowWindow(1);
					end
				else
					local icon = CreateIcon(slot);
					local namelist = StringSplit(cls.ClassName, "motion_");
					local imageName = namelist[1];
					if 1 < #namelist then
						imageName = namelist[2];
					end
						
					icon:SetImage(imageName);
					local tooltipText = string.format( "%s%s" , "/" ,cls.IconTokken);
					icon:SetTextTooltip(tooltipText);
					index = index + 1;				
					slot:ShowWindow(1);
				end				
			end
		end
	end

	if curCnt ~= 0 then
		for i = index , curCnt - 1 do
			local slot = emoticons:GetSlotByIndex(i);
			slot:ClearIcon();
		end
	end

	frame:SetUserValue("CURCNT", index);
end

function CHAT_EMOTICON_SELECT(frame, ctrl)
	local emo_frame = ui.GetFrame('chat_emoticon');
	local iconGroup = emo_frame:GetUserValue("EMOTICON_GROUP");
	if iconGroup == "None" then
		iconGroup = "Normal";
	end

	if ctrl:GetClassName() == "slot" then
		if iconGroup == "Motion" then
			-- 모션 이모티콘			
			local slot = tolua.cast(ctrl, "ui::CSlot");
			local icon = slot:GetIcon();
			if icon ~= nil then
				local imageName = icon:GetInfo():GetImageName();
				if imageName ~= "" then					
					CHAT_ADD_EMOTICON_MOTION(imageName)
				end
			end
		else
			-- 일반 이모티콘
			local slot = tolua.cast(ctrl, "ui::CSlot");
			local icon = slot:GetIcon();
			if icon ~= nil then
				local imageName = icon:GetInfo():GetImageName();
				if imageName ~= "" then
					CHAT_ADD_EMOTICON(imageName)
				end
			end
	
			--Shift키를 누르면 연속적으로 선택하게.
			if 0 == keyboard.IsKeyPressed("LSHIFT") then
				CHAT_EMOTICON_CLOSE(emo_frame);
			else		
				emo_frame:SetDuration(3);
			end			
		end		
	end
end

function CHAT_ADD_EMOTICON(imageName)
	local chatFrame = GET_CHATFRAME();
	local editCtrl = GET_CHILD(chatFrame, "mainchat", "ui::CEditControl");
	local curLinkCount = editCtrl:GetLinkCount();
	if curLinkCount >= 3 then
		ui.MsgBox(ScpArgMsg("Auto_LingKeuui_KaeSuNeun_3KaeLeul_Neomeul_Su_eopSeupNiDa."));
		return;
	end

	local imgheight = 30;
	local imgtag =  string.format("{img %s %d %d}{/}", imageName, imgheight, imgheight);
		
	local left = editCtrl:GetCursurLeftText();
	local right = editCtrl:GetCursurRightText();
	--이 함수 들어오는 시점에서 이미 스페이스키를 클릭한 상태이므로 추가해줌
	right = right .. " ";
	local resultText = string.format("%s%s%s", left, imgtag, right);
	SET_CHAT_TEXT(resultText);
	editCtrl:SetCursorPos(#resultText)
end

function CHAT_CHECK_EMOTICON(szIconTokken, imageName)
	local chatFrame = GET_CHATFRAME();
	local editCtrl = GET_CHILD(chatFrame, "mainchat", "ui::CEditControl");
	local tempMsg = string.gsub(string.lower(editCtrl:GetText()), string.lower(szIconTokken), "");

	editCtrl:ClearText();
	editCtrl:SetText(tempMsg);

	local cls = GetClass("chat_emoticons", imageName);
	if cls.CheckServer == 'YES' then
		local etc = GetMyEtcObject();
		local haveEmoticon = TryGetProp(etc, 'HaveEmoticon_' .. cls.ClassID);
		if haveEmoticon <= 0 then
			return;
		end
	end
	
	if cls.IconGroup == "Motion" then
		local chattype = ui.GetChatType();
		if chattype == 1 then
			-- 외치기에서는 모션 이모티콘 사용 불가
			return;
		end
	
		-- 모션이모티콘
		CHAT_ADD_EMOTICON_MOTION(imageName);
	else
		-- 일반 이모티콘
		CHAT_ADD_EMOTICON(imageName)
	end		
end

g_chatEmoticonCacheTable = {}; -- key: iconToken, valud: Class in idspace of "chat_emoticons"
function GET_EMOTICON_CLASS_BY_ICON_TOKEN(iconToken)	
	if g_chatEmoticonCacheTable[iconToken] ~= nil then		
		return g_chatEmoticonCacheTable[iconToken];
	end

	local clslist, cnt = GetClassList('chat_emoticons');
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);		
		local replacedByDic = dictionary.ReplaceDicIDInCompStr(cls.IconTokken);
		if replacedByDic == iconToken then
			g_chatEmoticonCacheTable[iconToken] = cls;
			return cls;
		end
	end
	return nil;
end

function CHAT_CHECK_EMOTICON_WITH_ENTER(originText)
	local text = REPLACE_EMOTICON(originText)
	if text ~= nil then
		SET_CHAT_TEXT(text);
	end
end

function REPLACE_EMOTICON(originText)
	if string.find(originText, '/') == nil then		
		return originText;
	end

	local loopCount = 0;

	local index = 1;
	local totalLen = string.len(originText);
	while index < totalLen do
		local slashIndex = string.find(originText, '/', index);		
		if slashIndex == nil then
			break;
		end

		-- get / started text
		local replaceTargetText = string.sub(originText, slashIndex, totalLen);		
		local whiteSpaceIndex = string.find(replaceTargetText, ' ');		
		if whiteSpaceIndex == nil then
			whiteSpaceIndex = string.len(replaceTargetText);
		else
			whiteSpaceIndex = whiteSpaceIndex - 1;
		end

		if whiteSpaceIndex <= 0 then
			break;
		end

		replaceTargetText = string.sub(replaceTargetText, 0, whiteSpaceIndex);
		
		-- get icon
		local iconToken = string.gsub(replaceTargetText, '/', '');
		local imageClass = GET_EMOTICON_CLASS_BY_ICON_TOKEN(iconToken);
		if imageClass ~= nil then
			if string.find(imageClass.ClassName, "motion_") ~= nil then
				local chattype = ui.GetChatType();
				if chattype == 1 then
					-- 외치기에서는 모션 이모티콘 사용 불가
					return;
				end

				--모션 이모티콘
				local namelist = StringSplit(imageClass.ClassName, "motion_");
				local toText = string.format('{spine %s 120 120}{/}', imageClass.ClassName);
				
				return toText;
			else
				--일반 이모티콘
				local toText = string.format('{img %s 30 30}{/}', imageClass.ClassName);			
				originText = string.gsub(originText, replaceTargetText, toText);
				totalLen = string.len(originText);
				index = index + string.len(toText);
			end
		else
			index = index + string.len(replaceTargetText);
		end

		loopCount = loopCount + 1;
		if loopCount > 1000 then
			break;
		end
	end

	return originText;
end

-- 모션 이모티콘 사용
function CHAT_ADD_EMOTICON_MOTION(imageName)
	local chatFrame = GET_CHATFRAME();
	local editCtrl = GET_CHILD(chatFrame, "mainchat", "ui::CEditControl");
	local curLinkCount = editCtrl:GetLinkCount();
	if curLinkCount >= 3 then
		ui.MsgBox(ScpArgMsg("Auto_LingKeuui_KaeSuNeun_3KaeLeul_Neomeul_Su_eopSeupNiDa."));
		return;
	end
	
	-- 아이콘 클릭시에는 imageName이 아이콘 이미지 이름
	-- /IconTokken 으로 입력시에는 imageName이 ClassName
	if string.find(imageName, "motion_") == nil then
		imageName = "motion_"..imageName;
	end

	local spinetag =  string.format("{spine %s %d %d}{/}", imageName, 120, 120);
	local chattype = ui.GetChatType();
	if chattype == 1 then
		-- 외치기에서는 모션 이모티콘 사용 불가
		return;
	end

	SET_CHAT_TEXT(spinetag);
	ui.ProcessReturnKey();
end
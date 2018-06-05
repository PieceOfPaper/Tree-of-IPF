
function MINIGAME_ON_INIT(addon)
		
	addon:RegisterMsg('START_MINI_TEXT', 'MINIGAME_TEXT_START');
	addon:RegisterMsg('SEND_MINIGAME_RESULT', 'MINIGAME_TEXT_UPDATE');
end

function MINIGAME_TEXT_START(frame, msg, str, num)
	
	ui.ToggleFrame("minigame");
	local richText = frame:GetChild('text');
	richText:SetFontName(ITEM_TOOLTIP_TEXT_FONT);
	richText:SetText(str);
	
end

function MINIGAME_TEXT_UPDATE(frame, msg, str, num)


	local richText = frame:GetChild('text');
	richText:SetFontName(ITEM_TOOLTIP_TEXT_FONT);
	
	if num == 1 then

		richText:SetText(ScpArgMsg("Auto_"));
	elseif num == 0 then

		richText:SetText(ScpArgMsg("Auto_MeongCheongi__")..str);
	end
end

-- 입력하고 엔터치면 이거 실행됨
function EXEC_MAKE_MINI(frame, edit)
	
	local editCtrl 	= tolua.cast(edit, "ui::CEditControl");
	if editCtrl ~= nil then
		local txt = editCtrl:GetText();		
		if txt ~= "" then
			packet.ReqMiniText(tostring(txt));
		end
	end
end

function CLOSE_MINIGAME(frame)
	ui.CloseFrame("minigame");
end




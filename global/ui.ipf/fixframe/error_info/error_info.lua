function ERROR_INFO_INIT(errorCode, summary, infoMsg, handleMsg, url, argNum, closeScp)
	local frame = ui.GetFrame('error_info');
	if frame:IsVisible() == 1 then
		return;
	end

	frame:SetUserValue('CLOSE_SCP', closeScp);

	local summaryText = frame:GetChild('summaryText');	
	local _summaryText = MAKE_NEW_LINE_TAG(summary, false);
	summaryText:SetTextByKey('msg', _summaryText);

	local errorCodeText = frame:GetChild('errorCodeText');
	errorCodeText:SetTextByKey('errorCode', errorCode);

	local infoText = GET_CHILD_RECURSIVELY(frame, 'infoText');	
	local _infoText = MAKE_NEW_LINE_TAG(infoMsg);
	if argNum ~= 0 then
		_infoText = _infoText..'('..argNum..')';
	end
	infoText:SetTextByKey('msg', _infoText);

	local ypos = infoText:GetY() + infoText:GetHeight() + 10;
	local infoBox = frame:GetChild('infoBox');
	infoBox:Resize(infoBox:GetWidth(), ypos);	

	local handleBox = frame:GetChild('handleBox');
	handleBox:SetOffset(handleBox:GetX(), infoBox:GetY() + infoBox:GetHeight() + 10);
	local handleText = GET_CHILD_RECURSIVELY(frame, 'handleText');	
	local _handleText = MAKE_NEW_LINE_TAG(handleMsg);
	handleText:SetTextByKey('msg', _handleText);
	ypos = handleText:GetY() + handleText:GetHeight() + 10;
	handleBox:Resize(handleBox:GetWidth(), ypos);	

	local urlBox = frame:GetChild('urlBox');
	ypos = handleBox:GetY() + handleBox:GetHeight() + 10;
--	urlBox:SetOffset(urlBox:GetX(), ypos);
	if url ~= '' then
		local urlText = GET_CHILD_RECURSIVELY(frame, 'urlText');
		urlText:SetTextByKey('url', url);
		urlBox:Resize(urlBox:GetWidth(), urlText:GetY() + urlText:GetHeight() + 10);
		ypos = ypos + urlBox:GetHeight();
--		urlBox:ShowWindow(1);
	else
--		urlBox:ShowWindow(0);
	end

	local okBtn = frame:GetChild('okBtn');
	local margin = okBtn:GetMargin();
	ypos = ypos + okBtn:GetHeight() + margin.bottom * 2;

	frame:Resize(frame:GetWidth(), ypos);
	frame:ShowWindow(1);
end

function MAKE_NEW_LINE_TAG(originText, exceptSpecialChar)
	local infoCharacter = '{img notice_br_ydot 4 4} ';
	local replaceStr = '.{nl}{img notice_br_ydot 4 4}  ';
	if exceptSpecialChar ~= false then
		originText = infoCharacter..originText;
	end
	return string.gsub(originText, '[.][ ]', replaceStr);
end

function ERROR_INFO_OPEN_BROWSER(parent, text)
	local url = text:GetTextByKey('url');	
	login.OpenURL(url);
end

function ERROR_INFO_CLOSE(parent, ctrl)
	local closeScript = parent:GetUserValue('CLOSE_SCP');
	if closeScript ~= 'None' then
		local _closeScript = _G[closeScript];
		_closeScript();
		return;
	end
	ui.CloseFrame('error_info');
end

function ERROR_INFO_DESTROY_GAME()
	script.DestroyGame();
end
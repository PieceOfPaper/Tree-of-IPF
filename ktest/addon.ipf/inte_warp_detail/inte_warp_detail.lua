
-- 이쪽 UI안쓴다.

function INTE_WARP_DETAIL_ON_INIT(addon, frame)

--	 addon:RegisterMsg('INTE_SKILL_WARP', 'ON_INTE_SKILL_WARP');
end

function INTE_WARP_DETAIL_INFO(cost, infoString, xPos)

	local myMoney = GET_TOTAL_MONEY();

	if myMoney < cost then
		ui.SysMsg(ScpArgMsg('Auto_SilBeoKa_BuJogHapNiDa.'));
		return;
	end

	local frame = ui.GetFrame('inte_warp_detail');
	local camp_warp_class = GetClass('camp_warp', infoString)
	if camp_warp_class ~= nil then
		
		local box = frame:GetChild('box');
		tolua.cast(box, "ui::CGroupBox");

		local closeBtn = frame:GetChild('CLOSE');
		tolua.cast(closeBtn, "ui::CButton");

		closeBtn:SetClickSound('button_click_big')


		local nameRechText = GET_CHILD(frame, "richtext_mapname", "ui::CRichText");
		nameRechText:SetTextByKey("mapname",camp_warp_class.Name);

		local nameRechText2 = GET_CHILD(frame, "richtext_medal", "ui::CRichText");
		nameRechText2:SetTextByKey("medal",cost..ScpArgMsg('Auto__SilBeo_SoMo'));
		--nameRechText2:SetTextByKey("medal",'');

		world.PreloadMinimap(camp_warp_class.Zone);
		local pic = GET_CHILD(frame, "picture_minimap", "ui::CPicture");
		pic:SetImage(camp_warp_class.Zone);

		local okBtn = box:CreateControl('button', 'ok_btn', 140, 195, 100, 30);
		tolua.cast(okBtn, 'ui::CButton');
		okBtn:SetText(ScpArgMsg('Auto_{@st41b}Hwagin{/}'));
		okBtn:SetTooltipType('texthelp');
		okBtn:SetTooltipArg(ScpArgMsg('Auto_{@st59}SilBeoLeul_SoMoHayeo_HaeDang_JiyeogeuLo_iDongHapNiDa.{/}'));
		--okBtn:SetTooltipArg(ScpArgMsg('Auto_{@st59}HaeDang_JiyeogeuLo_iDongHapNiDa.{/}'));
		okBtn:SetEventScriptArgNumber(ui.LBUTTONDOWN, camp_warp_class.ClassID);

		okBtn:SetEventScript(ui.LBUTTONUP, 'WARP_TO_AREA');
		okBtn:SetOverSound('button_over');
		okBtn:SetClickSound('button_click_stats_ok');
		
	else
	
		-- 이전 아이템포탈 위치
		local mapClass = GetClass('Map', infoString)
		local box = frame:GetChild('box');
		tolua.cast(box, "ui::CGroupBox");

		local closeBtn = frame:GetChild('CLOSE');
		tolua.cast(closeBtn, "ui::CButton");

		closeBtn:SetClickSound('button_click_big')


		local nameRechText = GET_CHILD(frame, "richtext_mapname", "ui::CRichText");
		nameRechText:SetTextByKey("mapname",mapClass.Name);

		local nameRechText2 = GET_CHILD(frame, "richtext_medal", "ui::CRichText");
		nameRechText2:SetTextByKey("medal",cost..ScpArgMsg('Auto__SilBeo_SoMo'));
		--nameRechText2:SetTextByKey("medal",'');

		world.PreloadMinimap(mapClass.ClassName);
		local pic = GET_CHILD(frame, "picture_minimap", "ui::CPicture");
		pic:SetImage(mapClass.ClassName);

		local okBtn = box:CreateControl('button', 'ok_btn', 140, 195, 100, 30);
		tolua.cast(okBtn, 'ui::CButton');
		okBtn:SetText(ScpArgMsg('Auto_{@st41b}Hwagin{/}'));
		okBtn:SetTooltipType('texthelp');
		okBtn:SetTooltipArg(ScpArgMsg('Auto_{@st59}SilBeoLeul_SoMoHayeo_HaeDang_JiyeogeuLo_iDongHapNiDa.{/}'));
		--okBtn:SetTooltipArg(ScpArgMsg('Auto_{@st59}HaeDang_JiyeogeuLo_iDongHapNiDa.{/}'));
		okBtn:SetEventScriptArgNumber(ui.LBUTTONDOWN, mapClass.ClassID);

		okBtn:SetEventScript(ui.LBUTTONUP, 'WARP_TO_AREA');
		okBtn:SetOverSound('button_over');
		okBtn:SetClickSound('button_click_stats_ok');
	end	

	frame:ShowWindow(1);
	frame:Invalidate();
end

function ON_INTE_SKILL_WARP(frame, msg, argStr, argNum)

	movie.InteWarp(session.GetMyHandle(), 'None');

	packet.ClientDirect("InteWarp");
end
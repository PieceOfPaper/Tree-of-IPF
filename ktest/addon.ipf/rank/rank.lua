function RANK_ON_INIT(addon, frame)
end

function RANK_OPEN(frame, ctrl, argStr, argNum)

	imc.client.statistics.api.lua.sync_rank_open("RANK_UPDATE_TITLE_PAGE", '');
	local minimap = ui.GetFrame('minimap')
	minimap:ShowWindow(0)

	local quest = ui.GetFrame('questinfoset_2')
	quest:ShowWindow(0)
end

function RANK_CLOSE(frame)

	local minimap = ui.GetFrame('minimap')
	minimap:ShowWindow(1)

	local quest = ui.GetFrame('questinfoset_2')
	quest:ShowWindow(1)
end

function RANK_UPDATE_TITLE_PAGE(str)

	local frame = ui.GetFrame('rank')
	if frame == nil then return end

	-- 데미지 탑100 1위표시
	local page = GET_CHILD(frame, 'main', 'ui::CPage');
	local ctrlSet = GET_CHILD(page, 'AttackTop100', 'ui::CControlSet');
	local desc = GET_CHILD(ctrlSet, 'desc', 'ui::CRichText');

	local rank = imc.client.statistics.api.lua.get_attack_top();
	if rank ~= nil and rank.name ~= '' then
		desc:SetText(ScpArgMsg('Auto_{@st41b}{#ffffcc}1wi_')..rank.name)
	end


	-- 킬 탑100 1위표시
	page = GET_CHILD(frame, 'main', 'ui::CPage');
	ctrlSet = GET_CHILD(page, 'KillTop100', 'ui::CControlSet');
	desc = GET_CHILD(ctrlSet, 'desc', 'ui::CRichText');

	rank = imc.client.statistics.api.lua.get_kill_top();
	if rank ~= nil and rank.name ~= '' then
		desc:SetText(ScpArgMsg('Auto_{@st41b}{#ffffcc}1wi_')..rank.name)
	end


	-- 돈획득 탑100 1위표시
	page = GET_CHILD(frame, 'main', 'ui::CPage');
	ctrlSet = GET_CHILD(page, 'MoneyTop100', 'ui::CControlSet');
	desc = GET_CHILD(ctrlSet, 'desc', 'ui::CRichText');

	rank = imc.client.statistics.api.lua.get_money_top();
	if rank ~= nil and rank.name ~= '' then
		desc:SetText(ScpArgMsg('Auto_{@st41b}{#ffffcc}1wi_')..rank.name)
	end


	-- 레벨 탑100 1위표시
	page = GET_CHILD(frame, 'main', 'ui::CPage');
	ctrlSet = GET_CHILD(page, 'LevelTop100', 'ui::CControlSet');
	desc = GET_CHILD(ctrlSet, 'desc', 'ui::CRichText');

	rank = imc.client.statistics.api.lua.get_level_top();
	if rank ~= nil and rank.name ~= '' then
		desc:SetText(ScpArgMsg('Auto_{@st41b}{#ffffcc}1wi_')..rank.name)
	end

	--[[
	-- 모험일지 탑100 1위표시
	page = GET_CHILD(frame, 'main', 'ui::CPage');
	ctrlSet = GET_CHILD(page, 'LevelTop100', 'ui::CControlSet');
	desc = GET_CHILD(ctrlSet, 'desc', 'ui::CRichText');

	rank = imc.client.statistics.api.lua.get_level_top();
	if rank ~= nil and rank.name ~= '' then
		desc:SetText(ScpArgMsg('Auto_{@st43}1wi_')..rank.name)
	end
	]]
end

function RANK_SHOW_BACK_BUTTON(frame)
	local btn = GET_CHILD(frame, 'back', 'ui::CObject')
	btn:ShowWindow(1)

	local obj = GET_CHILD(frame, 'main', 'ui::CObject')
	obj:ShowWindow(0)
end

function RANK_BACK_MAIN(ctrl, ctrlset, argStr, argNum)
	local frame = ui.GetFrame('rank')
	HIDE_CHILD_BYNAME(frame, 'group_');

	local obj = GET_CHILD(frame, 'back', 'ui::CObject')
	obj:ShowWindow(0)

	obj = GET_CHILD(frame, 'main', 'ui::CObject')
	obj:ShowWindow(1)

end

function RANK_PREV_PAGE(ctrl, ctrlset, argStr, argNum)
	local frame = ui.GetFrame('rank')
	local name = frame:GetUserConfig('selected')
	if name == nil then
		return
	end
	local group = GET_CHILD(frame, 'group_'..name, 'ui::CGroupBox')

	if group == nil then
		return;
	end

	local page = GET_CHILD(group, 'page', 'ui::CPage')
	page:PrevPage();
end

function RANK_NEXT_PAGE(ctrl, ctrlset, argStr, argNum)
	local frame = ui.GetFrame('rank')
	local name = frame:GetUserConfig('selected')
	if name == nil then
		return
	end
	local group = GET_CHILD(frame, 'group_'..name, 'ui::CGroupBox')

	if group == nil then
		return;
	end

	local page = GET_CHILD(group, 'page', 'ui::CPage')
	page:NextPage();
end


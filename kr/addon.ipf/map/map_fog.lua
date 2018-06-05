-- map_fog.lua
  
function REVEAL_MAP_PICTURE(frame, mapName, info, i, forMinimap)

	if info.group > 0 then
		REVEAL_MAP_PICTURE_GROUP(frame, mapName, info.group, forMinimap);
		return;
	end

	REVEAL_MAP_PICTURE_INDEX(frame, info, i);

end

function REVEAL_MAP_PICTURE_INDEX(frame, info, i)

	info.revealed = 1;
	local pic = frame:GetChild("map");
	tolua.cast(pic, "ui::CPicture");
	if 0 == pic:LockClonePicture() then
		return;
	end
	WRITE_RECT_CLONE_PICTURE(pic, info);
	pic:UnLockClonePicture();
	

end

function UPDATE_FOG_HIDED_NPC(frame, mapName, onlyCheckNotVisible)

	if 0 == MAP_USE_FOG(mapName) then
		return;
	end

	local minimapFrame = ui.GetFrame('minimap');
	local npcList = minimapFrame:GetChild('npclist')

	local list = session.GetMapFogList(mapName);
	local listCnt = list:Count();
	local cnt = frame:GetChildCount();
	for i = 0 , cnt - 1 do
		local ctrl = frame:GetChildByIndex(i);
		if onlyCheckNotVisible == nil or ctrl:IsVisible() == 0 then
			local childName = ctrl:GetName();
			if string.find(childName, "_GEN_NPC_") ~= nil then
				local x, y, w, h = GET_XYWH(ctrl);
				local isReveal = IS_REVEAL_POS(x, y, list, listCnt);
				ctrl:ShowWindow(isReveal);
				local minimapChild = npcList:GetChild(childName);
				if minimapChild ~= nil then
					minimapChild:ShowWindow(isReveal);
				end
			end
		end
	end
end

function IS_REVEAL_POS(x, y, list, listCnt)

	x = x - m_offsetX;
	y = y - m_offsetY;

	for i = 0 , listCnt - 1 do
		local info = list:PtrAt(i);
		if info.revealed == 1 and IS_IN_FOG_RECT(x, y, iconW, iconH, info) == 1 then
			return 1;
		end
	end

	return 0;

end

function IS_IN_FOG_RECT(x, y, width, height, info)

	local endX = x + width;
	local endY = y + height;

	local infoEndX = info.x + info.w;
	local infoEndY = info.y + info.h;

	if IS_INTERSECT(x, endX, info.x, infoEndX) == 1
		and
		IS_INTERSECT(y, endY, info.y, infoEndY) == 1 then
		return 1;
	end

	return 0;

end

function IS_INTERSECT(x11, x12, x21, x22)

	if (x11 > x21 and x11 < x22) or (x21 > x11 and x21 < x12) then
		return 1;
	end

	return 0;

end

function UPDATE_MAP_FOG_RATE(frame, mapName)

	if 0 == MAP_USE_FOG(mapName) then
		return;
	end

	local rate = GET_CHILD(frame, "rate", "ui::CRichText");
	local recoverRate = session.GetMapFogRevealRate(mapName);
	local outStr = string.format("%.1f", recoverRate);
	if rate ~= nil then
		rate:SetTextByKey("rate", outStr);
	end

	--local questInfoFrame = ui.GetFrame('questinfoset_2');
	--UPDATE_QUESTINFOSET_2(questInfoFrame);
	-- �� �ϴ°��� �ּ� ������
	if recoverRate >= 100.0 then
		CHECK_ACHIEVE_MAP(frame, mapName);
	end
end

function CHECK_ACHIEVE_MAP(frame, mapName)

	if frame:GetValue() == 1 then
		return;
	end

	local prop = geAchieveTable.GetPropByName(mapName);
	if prop == nil then
		return;
	end

	local type = prop.ClassID;
	local have = session.HaveAchieve(type);
	if have == 0 then
		packet.ReqGetMapRevealAchieve();
	else
		frame:SetValue(1);
	end

end


function REVEAL_MAP_PICTURE_GROUP(frame, mapName, group, forMinimap)

	local pic = GET_CHILD(frame, "map", "ui::CPicture");
	if 0 == pic:LockClonePicture() then
		return;
	end

	local list = session.GetMapFogList(mapName);
	local cnt = list:Count();
	for i = 0 , cnt - 1 do
		local info = list:PtrAt(i);
		if (info.revealed == 0 or forMinimap ~= nil) and info.group == group then
			info.revealed = 1;
			WRITE_RECT_CLONE_PICTURE(pic, info);
		end
	end

	pic:UnLockClonePicture();
	pic:Invalidate();

	if forMinimap ~= nil then
		RUN_GROUP_REVEAL_EVENT(mapName, group);
	end

end

function RUN_GROUP_REVEAL_EVENT(mapName, group)

	local clsName = string.format("%s_%d", mapName, group);
	local cls = GetClass("MapFogEvent", clsName);

	if cls.Message ~= "None" then
		addon.BroadMsg("NOTICE_Dm_GuildQuestSuccess", cls.Message, 3);
	end

	if cls.Sound ~= "None" then
		--imcSound.PlaySoundItem(cls.Sound);
	end

	if cls.Script ~= "None" then
		RunStringScript(cls.Script);
	end

	ui.OpenFrame("map");
end

function RUN_REVEAL_CHECKER(frame, mapName)

	if 0 == MAP_USE_FOG(mapName) then
		return;
	end

	frame:RunUpdateScript("UPDATE_CHECK_REVEAL", 0.1, 0, 0, 1);	
end

function UPDATE_CHECK_REVEAL(frame)

	local mapName = session.GetMapName();
	local mx, my = GET_C_XY(myposition);
	local bx = frame:GetUserIValue("BEFORE_X");
	local by = frame:GetUserIValue("BEFORE_Y");

	local dif = math.abs(bx - mx) + math.abs(by - my);
	if dif <= 20 then
		return 1;
	end

	frame:SetUserValue("BEFORE_X", mx);
	frame:SetUserValue("BEFORE_Y", my);

	local list = session.GetMapFogList(mapName);
	local cnt = list:Count();

	map_picture = GET_CHILD(frame,'map','ui::CPicture')

	local px, py = GET_C_XY(map_picture);
	mx = mx - px;
	my = my - py;
	mx = mx / map_picture:GetWidth() * map_picture:GetImageWidth();
	my = my / map_picture:GetHeight() * map_picture:GetImageHeight();
	mx = mx + myposition:GetWidth() / 2;
	my = my + myposition:GetHeight() / 2;

	local changed = 0;
	for i = 0 , cnt - 1 do
		local info = list:PtrAt(i);
		if info.revealed == 0 then
			if 1 == IS_IN_RECT(mx, my, info.x - info.w / 2, info.y - info.h / 2, info.w * 2, info.h * 2) then
				REVEAL_MAP_PICTURE(frame, mapName, info, i);
				changed = 1;
			end
		end
	end

	if changed == 1 then
		packet.ReqSaveMapReveal(mapName);
		UPDATE_MAP_FOG_RATE(frame, mapName)
		--UPDATE_FOG_HIDED_NPC(frame, mapName, 1);
	end

	return 1;
end


function REVEAL_ALL_MAP()

	local mapName = session.GetMapName();
	local list = session.GetMapFogList(mapName);
	local cnt = list:Count();
	for i = 0 , cnt - 1 do
		local info = list:PtrAt(i);
		info.revealed = 1;
	end

	packet.ReqSaveMapReveal(mapName);

	local frame = ui.GetFrame('map');
	UPDATE_MAP(frame);

end


function FOG_ALL_MAP()

	local mapName = session.GetMapName();
	local list = session.GetMapFogList(mapName);
	local cnt = list:Count();
	for i = 0 , cnt - 1 do
		local info = list:PtrAt(i);
		info.revealed = 0;
	end

	local frame = ui.GetFrame('map');
	UPDATE_MAP(frame);

	frame = ui.GetFrame('minimap');
	UPDATE_MINIMAP(frame);

end



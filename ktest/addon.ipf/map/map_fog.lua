-- map_fog.lua
 
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

	frame = tolua.cast(frame, "ui::CFrame");
	if 0 == MAP_USE_FOG(mapName) then
		return;
	end

	local rate = GET_CHILD(frame, "rate", "ui::CRichText");
	local recoverRate = session.GetMapFogRevealRate(mapName);
	local outStr = string.format("%.1f", recoverRate);
	if rate ~= nil then
		rate:SetTextByKey("rate", outStr);
	end
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

	packet.UpdateCheckReveal(mapName, frame);
	frame:SetUserValue("BEFORE_X", mx);
	frame:SetUserValue("BEFORE_Y", my);
	return 1;
end

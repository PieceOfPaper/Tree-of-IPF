
function MAP_RECON_ON_INIT(addon, frame)
    addon:RegisterMsg('OPEN_MAP_RECON', 'ON_OPEN_MAP_RECON');
	addon:RegisterMsg('MAP_RECON_LIST', 'ON_MAP_RECON_LIST');
    addon:RegisterMsg('REMOVE_MAP_RECON', 'ON_REMOVE_MAP_RECON');
    addon:RegisterMsg('CLOSE_MAP_RECON', 'ON_CLOSE_MAP_RECON');
end

function ON_OPEN_MAP_RECON(frame, msg, itemClsName, mapID)
	frame:StopUpdateScript("UPDATE_FADEOUT_MAP_RECON");
	local list_gb =  GET_CHILD_RECURSIVELY(frame, "list_gb");
	local mapClsName = GetClassString('Map', mapID, 'ClassName');

	local title = GET_CHILD_RECURSIVELY(frame, "title");
	local itemName = GetClassString('Item', itemClsName, 'Name');
	title:SetTextByKey('itemname', itemName);

	SCR_SHOW_LOCAL_MAP_RECON(frame, mapClsName, false, 0, 0)
	frame:SetUserValue("MapClsName", mapClsName)
	REMOVE_MAP_RECON_PC_ICON(list_gb, {})
	frame:ShowWindow(1);
end

function ON_CLOSE_MAP_RECON(frame)
	frame:StopUpdateScript("UPDATE_FADEOUT_MAP_RECON");
	frame:ShowWindow(0);
end

function ON_MAP_RECON_LIST(frame, msg, strarg, mapID)
	local mapClsName = GetClassString("Map", mapID, "ClassName");

	local beforeMapClsName = frame:GetUserValue("MapClsName")
	local mapClsName = GetClassString("Map", mapID, "ClassName");
	if beforeMapClsName ~= mapClsName then
		REMOVE_MAP_RECON_PC_ICON(list_gb, {})
		SCR_SHOW_LOCAL_MAP_RECON(frame, mapClsName, false, 0, 0);
		frame:SetUserValue("MapClsName", mapClsName);
		frame:StopUpdateScript("UPDATE_FADEOUT_MAP_RECON");
	end
	
	local list_gb =  GET_CHILD_RECURSIVELY(frame, "list_gb");
	local map_pic =  GET_CHILD_RECURSIVELY(frame, 'map_pic');
    local hash = TOKENIZE_MAP_RECON_HASH(strarg);
	REMOVE_MAP_RECON_PC_ICON(list_gb, hash)

	for k, info in pairs(hash) do
		ADD_MAP_RECON_PC_ICON(frame, mapClsName, info.handle, info.x, info.z);
	end
end

function UPDATE_FADEOUT_MAP_RECON(frame, elapsedTime)
	AUTO_CAST(frame)
	local FADE_OUT_SEC = tonumber(frame:GetUserConfig("FADE_OUT_SEC"));
	local list_gb =  GET_CHILD_RECURSIVELY(frame, "list_gb");
	if elapsedTime > FADE_OUT_SEC then
		REMOVE_MAP_RECON_PC_ICON(list_gb, {})
		return 0;
	end

	local iconList = GET_MAP_RECON_PC_ICON_LIST(list_gb)
	for i=1, #iconList do
		local picName = iconList[i];
		local pc_pic = GET_CHILD(list_gb, picName);
		local percent = 100 - math.floor(100*elapsedTime/FADE_OUT_SEC);
		pc_pic:SetAlpha(percent)
	end

	return 1;
end
	

function ON_REMOVE_MAP_RECON(frame, msg, strarg, mapID)
	local list_gb =  GET_CHILD_RECURSIVELY(frame, "list_gb");

	frame:RunUpdateScript("UPDATE_FADEOUT_MAP_RECON");
end

function ADD_MAP_RECON_PC_ICON(frame, mapClsName, handle, x, z)
	local PC_ICON_NAME = frame:GetUserConfig("PC_ICON_NAME");
	local PC_ICON_WIDTH = frame:GetUserConfig("PC_ICON_WIDTH");
	local PC_ICON_HEIGHT = frame:GetUserConfig("PC_ICON_HEIGHT");

	local bg =  GET_CHILD_RECURSIVELY(frame, "bg");
	local list_gb =  GET_CHILD_RECURSIVELY(frame, "list_gb");
	local pc_pic = list_gb:CreateOrGetControl('picture', GET_MAP_RECON_PC_ICON_NAME(handle), 0, 0, tonumber(PC_ICON_WIDTH), tonumber(PC_ICON_HEIGHT));
	AUTO_CAST(pc_pic);
	pc_pic:SetUserValue("handle", handle);
	pc_pic:SetImage(PC_ICON_NAME);
	pc_pic:ShowWindow(1);

	local map_pic =  GET_CHILD_RECURSIVELY(frame, 'map_pic');
	local map_size = map_pic:GetWidth();
	local mapprop = geMapTable.GetMapProp(mapClsName);
	local MapPos = mapprop:WorldPosToMinimapPos(x, z, map_size, map_size);
	MapPos.x = MapPos.x * (map_pic:GetWidth() / map_size);
	MapPos.y = MapPos.y * (map_pic:GetHeight() / map_size);

	local offsetX = map_pic:GetX();
	local offsetY = map_pic:GetY();
	
	local x = offsetX + MapPos.x - pc_pic:GetWidth() / 2;
	local y = offsetY + MapPos.y - pc_pic:GetHeight() / 2;
	
	pc_pic:SetEnableStretch(1);
	pc_pic:SetOffset(x, y);
end

function SCR_SHOW_LOCAL_MAP_RECON(frame, zoneClsName, useMapFog, showX, showZ)
	local icon_gb =  GET_CHILD_RECURSIVELY(frame, 'icon_gb');
	DESTORY_MAP_PIC(icon_gb);

	local mapName = GetClassString('Map', zoneClsName, 'Name');
	local mapname_text = GET_CHILD_RECURSIVELY(frame, "mapname_text");
	mapname_text:SetTextByKey('mapname', mapName);

	local map_pic =  GET_CHILD_RECURSIVELY(frame, 'map_pic');
	local map_size = map_pic:GetWidth();
	UPDATE_MAP_BY_NAME(icon_gb, zoneClsName, map_pic, map_size, map_size, map_pic:GetX(), map_pic:GetY());
	MAKE_MAP_NPC_ICONS(icon_gb, zoneClsName, map_size, map_size, map_pic:GetX(), map_pic:GetY());

	local offsetX = map_pic:GetX() - 100;
	local offsetY = map_pic:GetY() - 30;
	MAKE_MAP_AREA_INFO(frame, zoneClsName, "{s15}", map_size, map_size, offsetX, offsetY);

	world.PreloadMinimap(zoneClsName, map_size);
	map_pic:SetImage(zoneClsName);
	local width = ui.GetImageWidth(zoneClsName);
	local height = ui.GetImageHeight(zoneClsName);
end

function TOKENIZE_MAP_RECON_HASH(strarg)
	local hash = {}
    local tokenlist = TokenizeByChar(strarg, ";");
	for i=1, #tokenlist do 
		if tokenlist[i] ~= "" then
			local handle, x, z = TOKENIZE_MAP_RECON(tokenlist[i]);
			if handle ~= nil and x ~= nil and z ~= nil then
				hash[handle] = {}
				hash[handle]["handle"] = handle;
				hash[handle]["x"] = x;
				hash[handle]["z"] = z;
			end
		end
	end

	return hash;
end

function TOKENIZE_MAP_RECON(strarg)
    local tokenlist = TokenizeByChar(strarg, ":");
    if #tokenlist ~= 3 then
        return;
    end

    local handle = tonumber(tokenlist[1]);
    local x = tonumber(tokenlist[2]);
    local z = tonumber(tokenlist[3]);
	return handle, x, z;
end

function GET_MAP_RECON_PC_ICON_LIST(list_gb)
	local list = {};
	local cnt = list_gb:GetChildCount();
	for i=0, cnt-1 do
		local pc_pic = list_gb:GetChildByIndex(i);
		local handle = pc_pic:GetUserIValue("handle");
		if handle > 0 then
			list[#list+1] = pc_pic:GetName();
		end
	end
	return list;
end

function REMOVE_MAP_RECON_PC_ICON(list_gb, hash)
	local iconList = GET_MAP_RECON_PC_ICON_LIST(list_gb)

	local removeList = {};
	for i=1, #iconList do
		local picName = iconList[i];
		local pc_pic = GET_CHILD(list_gb, picName);
		local handle = pc_pic:GetUserIValue("handle");
		if hash[handle] == nil then
			removeList[#removeList+1] = picName;
		end
	end

	for i=1, #removeList do
		local name = removeList[i];
		list_gb:RemoveChild(name);
	end
end

function GET_MAP_RECON_PC_ICON_NAME(handle)
	return "pc_"..handle;
end

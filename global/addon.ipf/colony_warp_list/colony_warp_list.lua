function COLONY_WARP_LIST_ON_INIT(addon, frame)
    addon:RegisterMsg('CLEAR_COLONY_WARP_LIST', 'ON_CLEAR_COLONY_WARP_LIST');
    addon:RegisterMsg('ADD_COLONY_WARP_LIST', 'ON_ADD_COLONY_WARP_LIST');
    addon:RegisterMsg('OPEN_COLONY_WARP_LIST', 'ON_OPEN_COLONY_WARP_LIST');
    COLONY_WARP_LIST = {}
end

function ON_CLEAR_COLONY_WARP_LIST(frame, msg, strarg, numarg)
    local list_gb = GET_CHILD(frame, "list_gb");
    list_gb:RemoveAllChild();
end

function TOKENIZE_COLONY_WARP_LIST(strarg)
    local tokenlist = TokenizeByChar(strarg, ";");
    if #tokenlist ~= 7 then
        print('assert')
        return;
    end

    local zoneName = tokenlist[1];
    local x = tonumber(tokenlist[2]);
    local y = tonumber(tokenlist[3]);
    local z = tonumber(tokenlist[4]);
    local way = tonumber(tokenlist[5]);
    local itemID = tonumber(tokenlist[6]);
    return zoneName, x, y, z, way, itemID
end
function ON_ADD_COLONY_WARP_LIST(frame, msg, strarg, numarg)
    local zoneName, x, y, z, way, itemID = TOKENIZE_COLONY_WARP_LIST(strarg);
    local list_gb = GET_CHILD(frame, "list_gb");
    local cnt = list_gb:GetChildCount();
    local ctrlset = list_gb:CreateControlSet("colony_warp_elem", "colony_warp_elem_"..cnt, 0, 45*(cnt-1));
    local map_text = GET_CHILD_RECURSIVELY(ctrlset, "map_text");
    local state_text = GET_CHILD_RECURSIVELY(ctrlset, "state_text");
    local linkstr = MAKE_LINK_MAP_TEXT(zoneName, x, z);
    map_text:SetTextByKey("value", linkstr)
    map_text:EnableTextCursorOnStyle(false);
    
    local statestr = ""
    if way == 1 then
        statestr = ClMsg("ColonyOccupied")
    end
    state_text:SetTextByKey("value", statestr)

    local move_btn = GET_CHILD_RECURSIVELY(ctrlset, "move_btn");
    move_btn:SetEventScriptArgString(ui.LBUTTONUP, strarg);
end

function ON_OPEN_COLONY_WARP_LIST(frame, msg, strarg, numarg)
    for i=1, #COLONY_WARP_LIST do
        print(COLONY_WARP_LIST[i])
    end
    ui.OpenFrame("colony_warp_list");
end

function ON_REQ_COLONY_WARP_LIST_MOVE_BTN(parent, ctrl, strarg, numarg)
    local zoneName, x, y, z, way, itemID = TOKENIZE_COLONY_WARP_LIST(strarg);
    local map = GetClass("Map", zoneName);
    if map == nil then
        return;
    end
    
    local invitem = session.GetInvItemByType(itemID)
    if invitem == nil then
        ui.SysMsg(ScpArgMsg("WebService_16"));
        ui.CloseFrame('colony_warp_list')
        return;
    end

    if session.colonywar.GetProgressState() ~= true then
        ui.SysMsg(ScpArgMsg("ColonyWarIsNotInProgress"));
        ui.CloseFrame('colony_warp_list')
        return;
    end
    
	session.ResetItemList();
    session.AddItemID(invitem:GetIESID());
    local resultlist = session.GetItemIDList();
    
    local dialogarg = string.format("%d %d %d %d %d %d", map.ClassID, x, y, z, way, itemID);
    item.DialogTransaction("REQ_COLONY_WARP_SCROLL_MOVE", resultlist, dialogarg);
    ui.CloseFrame('colony_warp_list')
end

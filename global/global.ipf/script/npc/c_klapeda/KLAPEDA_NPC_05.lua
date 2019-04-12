function SCR_COLLECTION_SHOP_DIALOG(self, pc)
    local select = ShowSelDlg(pc, 0, 'HENRIKA_BASIC01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg("COLLECTION_SHOP_ALPHABET_EVENT"), ScpArgMsg('Auto_DaeHwa_JongLyo'))
    if select == 1 then
        SendAddOnMsg(pc, "COLLECTION_UI_OPEN", "", 0);
		REGISTERR_LASTUIOPEN_POS_SERVER(pc,"collection")
	elseif select == 2 then
        -- ALPHABET_EVENT
	    local dlgTable = {'HENRIKA_ALPHABET_EVENT_NONE','HENRIKA_ALPHABET_EVENT_SELECT1', 'HENRIKA_ALPHABET_EVENT_FULL'}
	    SCR_ALPHABET_EVENT_EXCHANGE(pc, dlgTable)
    end
end

function SCR_JOURNAL_MON_REWARD_CHECK(pc)
    local monList = {}
    local monSelList = {}
    local cnt = GetClassCount('Journal_monkill_reward')
    local pcetc = GetETCObject(pc)
	for i = 0, cnt - 1 do
		local jIES = GetClassByIndex('Journal_monkill_reward', i);
		if jIES ~= nil and jIES.Count1 > 0 then
		    local monClassName = jIES.ClassName
		    local property = 'Reward_'..monClassName
		    if GetPropType(pcetc, property) ~= nil then
		        if pcetc[property] == 0 then
		            local wiki = GetWikiByName(pc, monClassName)
                    if wiki ~= nil then
                        local killcount = GetWikiIntProp(wiki, "KillCount");
                        if killcount >= jIES.Count1 then
                            monList[#monList + 1] = {}
                            monList[#monList][1] = monClassName
                            monList[#monList][2] = killcount
                            
                            monSelList[#monSelList + 1] = GetClassString('Monster', monClassName, 'Name');
                        end
                    end
		        end
		    end
		end
	end
	
	if #monList > 2 then
	    table.insert(monList, 1, {'ALL',0})
	    table.insert(monSelList, 1, ScpArgMsg('MONKILLREWARDALL', "COUNT",#monList - 1))
	end
	
	return monList, monSelList
end

function SCR_JOURNAL_MON_REWARD_GIVE(pc, monList, select)
    local monClassName = monList[select][1]
    if monClassName == 'ALL' then
        local pcetc = GetETCObject(pc)
        local tx = TxBegin(pc);
        for i = 2, #monList do
            monClassName = monList[i][1]
            local monKillCount = monList[i][2]
            local property = 'Reward_'..monClassName
            local jIES = GetClass('Journal_monkill_reward', monClassName)
            if jIES.Count1 > 0 and monKillCount >= jIES.Count1 then
                if GetPropType(pcetc, property) ~= nil then
                    if pcetc[property] == 0 then
                        TxGiveItem(tx, jIES.ItemName1_1, jIES.ItemCount1_1, 'JMonKill_'..monClassName);
                        TxSetIESProp(tx, pcetc, property, 1);
                    end
                end
            end
        end
        local ret = TxCommit(tx);
    else
    local monKillCount = monList[select][2]
    local property = 'Reward_'..monClassName
    local jIES = GetClass('Journal_monkill_reward', monClassName)
    if jIES.Count1 > 0 and monKillCount >= jIES.Count1 then
        local pcetc = GetETCObject(pc)
        if GetPropType(pcetc, property) ~= nil then
            if pcetc[property] == 0 then
                local tx = TxBegin(pc);
                TxGiveItem(tx, jIES.ItemName1_1, jIES.ItemCount1_1, 'JMonKill_'..monClassName);
                    TxSetIESProp(tx, pcetc, property, 1);
                local ret = TxCommit(tx);
            end
        end
    end
end
end

function SCR_JOURNAL_MAP_REWARD_CHECK(pc)
    local mapList = {}
    local mapSelList = {}
    local cnt = GetClassCount('Map')
    local pcetc = GetETCObject(pc)
	for i = 0, cnt - 1 do
		local jIES = GetClassByIndex('Map', i);
		if jIES ~= nil and jIES.MapRatingRewardItem1 ~= 'None' and jIES.WorldMapPreOpen == 'YES' and jIES.UseMapFog ~= 0  then
		    local mapClassName = jIES.ClassName
		    local property = 'Reward_'..mapClassName
		    if GetPropType(pcetc, property) ~= nil then
		        if pcetc[property] == 0 then
                    local mapFog = GetMapFogSearchRate(pc, mapClassName)
                    if mapFog >= 100 then
                        mapList[#mapList + 1] = {}
                        mapList[#mapList][1] = mapClassName
                        
                        mapSelList[#mapSelList + 1] = jIES.Name
                    end
		        end
		    end
		end
	end
	
	if #mapList > 2 then
	    table.insert(mapList, 1, {'ALL'})
	    table.insert(mapSelList, 1, ScpArgMsg('MONKILLREWARDALL', "COUNT",#mapList - 1))
	end
	
	return mapList, mapSelList
end

function SCR_JOURNAL_MAP_REWARD_GIVE(pc, mapList, select)

	local ret = "FAIL";

    local mapClassName = mapList[select][1]
    if mapClassName == 'ALL' then
        local pcetc = GetETCObject(pc)
        local tx = TxBegin(pc);
        for i = 2, #mapList do
            mapClassName = mapList[i][1]
            local property = 'Reward_'..mapClassName
            local jIES = GetClass('Map', mapClassName)
            if jIES ~= nil and jIES.MapRatingRewardItem1 ~= 'None' and jIES.WorldMapPreOpen == 'YES' and jIES.UseMapFog ~= 0  then
                if GetPropType(pcetc, property) ~= nil then
                    if pcetc[property] == 0 then
                        TxGiveItem(tx, jIES.MapRatingRewardItem1, jIES.MapRatingRewardCount1, 'JMap_'..mapClassName);
                        TxSetIESProp(tx, pcetc, property, 1);
                    end
                end
            end
        end
        ret = TxCommit(tx);
    else
    local jIES = GetClass('Map', mapClassName)
    if jIES ~= nil and jIES.MapRatingRewardItem1 ~= 'None' and jIES.WorldMapPreOpen == 'YES' and jIES.UseMapFog ~= 0  then
        local pcetc = GetETCObject(pc)
        local property = 'Reward_'..mapClassName
        if GetPropType(pcetc, property) ~= nil then
            local mapFog = GetMapFogSearchRate(pc, mapClassName)
            if pcetc[property] == 0 and mapFog >= 100  then
                local tx = TxBegin(pc);
                TxGiveItem(tx, jIES.MapRatingRewardItem1, jIES.MapRatingRewardCount1, 'JMap_'..mapClassName);
                        TxSetIESProp(tx, pcetc, property, 1);
                    ret = TxCommit(tx);
                end
            end
        end
    end

	if ret ~= "SUCCESS" then
		return;
    end

	SendProperty(pc, pcetc);
	SendAddOnMsg(pc, 'WIKI_PROP_UPDATE_MAP');
end
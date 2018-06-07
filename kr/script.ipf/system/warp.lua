function SCR_WS_SAMEZONE_WARP(self,pc,ws_classname)
    UIOpenToPC(pc,'fullblack',1)
    sleep(500)
    Warp(pc, ws_classname)
    sleep(500)
    UIOpenToPC(pc,'fullblack',0)
end

function SCR_WS_SCRIPT(self,pc,ws_classname, warp_AniOn)
    -- NPC?? Hide ???????? u???? Hide ???¶?? return
    if self ~= nil then
        if self.Dialog ~= nil and self.Dialog ~= 'None' then
            if isHideNPC(pc, self.Dialog) == 'YES' then
                return
            end
        end
        if self.Enter ~= nil and self.Enter ~= 'None' then
            if isHideNPC(pc, self.Enter) == 'YES' then
                return
            end
        end
        if self.Leave ~= nil and self.Leave ~= 'None' then
            if isHideNPC(pc, self.Leave) == 'YES' then
                return
            end
        end
    end

	local curzoneID = GetZoneInstID(pc);
--	local pc_x, pc_y, pc_z = GetPos(pc);
--	local xdir, zdir = GetDirection(self);

--	local dest_x = pc_x + xdir * 75.0;
--	local dest_z = pc_z + zdir * 75.0;
    local target = GetClass('Warp', ws_classname)
    
    if target == nil then
        print(ScpArgMsg("Auto_eopNeun_woPeu_JiyeogeuLo_iDongHaLyeoKoHam")..self.Enter..' : '..self.Dialog..ScpArgMsg("Auto_NPCLeul_TongHaeSeo_")..ws_classname..ScpArgMsg("Auto_Lo_iDongHaLyeoKoHam"))
        return
    end
    
--    if IS_SEASON_SERVER(pc) == 'YES' then
--        local season_server_no_warp = {
--                                        "f_castle_20_3",
--                                        "f_castle_20_2",
--                                        "f_castle_20_1",
--                                        "f_castle_20_4",
--                                        "f_dcapital_20_5",
--                                        "f_dcapital_20_6",
--                                        "f_dcapital_103",
--                                        "f_whitetrees_23_1",
--                                        "f_maple_23_2",
--                                        "f_whitetrees_23_3",
--                                        "f_whitetrees_56_1",
--                                        "f_bracken_42_1",
--                                        "f_bracken_42_2",
--                                        "d_limestonecave_52_1",
--                                        "d_limestonecave_52_2",
--                                        "d_limestonecave_52_3",
--                                        "d_limestonecave_52_4",
--                                        "d_limestonecave_52_5",
--                                        "f_bracken_43_1",
--                                        "f_bracken_43_2",
--                                        "f_bracken_43_3",
--                                        "f_bracken_43_4",
--                                        "d_limestonecave_55_1",
--                                        "f_maple_25_1",
--                                        "f_maple_25_2",
--                                        "f_maple_25_3",
--                                        "id_catacomb_25_4",
--                                        "f_katyn_18",
--                                        "d_firetower_69_1",
--                                        "d_firetower_69_2",
--                                        "f_whitetrees_21_2",
--                                        "f_whitetrees_21_1"
--                                        }
--        if table.find(season_server_no_warp,target.TargetZone) > 0 then
--            local zoneName = GetClassString('Map', target.TargetZone, 'Name')
--            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("SEASON_SERVER_MSG1", "ZONE", zoneName), 10)
--            return
--        end
--    end
    local targetZone = target.TargetZone
    local zoneIES = GetClass('Map', targetZone)
    local zoneLv = zoneIES.QuestLevel
    local pcLv = pc.Lv
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local highLv = 40
    if pcLv <= 20 then
        highLv = 10
    elseif pcLv <= 45 then
        highLv = 15
    elseif pcLv <= 135 then
        highLv = 25
    elseif pcLv <= 235 then
        highLv = 30
    end
    
    local flagLvCheck = 0
    if zoneLv > 0 and pcLv <= 50 and pcLv + 5 <= zoneLv then
        if sObj.LowPCHighLvZoneEnterMsgCount < 5 then
            local expcardList = {'expCard1','expCard2','expCard3','expCard5'}
            local flag = 0
            for i = 1, #expcardList do
                local itemUseLv =  GetClassNumber('Item',expcardList[i], 'UseLv')
                if GetInvItemCount(pc, expcardList[i]) > 0 and itemUseLv <= pcLv then
                    flag = 1
                    break
                end
            end
            if flag == 1 then
                flagLvCheck = 1
                sObj.LowPCHighLvZoneEnterMsgCount = sObj.LowPCHighLvZoneEnterMsgCount + 1
                SaveSessionObject(pc, sObj)
                local select = ShowSelDlg(pc,0, 'HighLvZoneEnterMsgCustom\\'..ScpArgMsg("HighLvZoneEnterMsg2"), ScpArgMsg("WS_ZACHA2F_01_TO_02_ANSWER_GO"), ScpArgMsg("WS_ZACHA2F_01_TO_02_ANSWER_NO"))
                if select == nil or select == 2 then
                    return
                end
            end
        end
    end
    if flagLvCheck == 0 and zoneLv > 0 and pcLv + highLv <= zoneLv then
        flagLvCheck = 2
        local select = ShowSelDlg(pc,0, 'HighLvZoneEnterMsgCustom\\'..ScpArgMsg("HighLvZoneEnterMsg1","ZONE",zoneIES.Name,"ZONELV",zoneLv), ScpArgMsg("WS_ZACHA2F_01_TO_02_ANSWER_GO"), ScpArgMsg("WS_ZACHA2F_01_TO_02_ANSWER_NO"))
        if select == nil or select == 2 then
            return
        end
    end
    
    if GetZoneName(pc) == target.TargetZone then
    	_TRACK(curzoneID, "PLAYER",
    	{
    		{"RUNSCRIPT", pc, "TUTORIAL_DIRECT_START"},
--    		{"RUNSCRIPT", pc, "SetPosMoveAnim", dest_x, dest_z},
    		--{"RUNSCRIPT", pc, "UIOpenToPC", "fullblack", 1},
    		{"RUNSCRIPT", pc, "TUTORIAL_DIRECT_END"},
    		{"SLEEP", 1000},
    		{"RUNSCRIPT", pc, "Warp", ws_classname},
    		{"SLEEP", 300},
    		{"RUNSCRIPT", pc, "UIOpenToPC", "fullblack", 0},
    	}
    	);
    else
        if warp_AniOn ~= nil and warp_AniOn == 1 then
            _TRACK(curzoneID, "PLAYER",
        	{
        		{"RUNSCRIPT", pc, "TUTORIAL_DIRECT_START"},
    --    		{"RUNSCRIPT", pc, "SetPosMoveAnim", dest_x, dest_z},
        		--{"RUNSCRIPT", pc, "UIOpenToPC", "fullblack", 1},
        		{"RUNSCRIPT", pc, "PlayAnim", 'WARP', 1},
        		{"SLEEP", 1000},
        		{"RUNSCRIPT", pc, "TUTORIAL_DIRECT_END"},
        		{"RUNSCRIPT", pc, "Warp", ws_classname},
        	}
        	);
        else
            _TRACK(curzoneID, "PLAYER",
        	{
        		{"RUNSCRIPT", pc, "TUTORIAL_DIRECT_START"},
    --    		{"RUNSCRIPT", pc, "SetPosMoveAnim", dest_x, dest_z},
        		--{"RUNSCRIPT", pc, "UIOpenToPC", "fullblack", 1},
        		{"RUNSCRIPT", pc, "TUTORIAL_DIRECT_END"},
        		{"RUNSCRIPT", pc, "Warp", ws_classname},
        	}
        	);
    	end
    end
end


function TRACK_SETPOS(pc, x, y, z, SLEEP)

	if SLEEP == nil then
		SLEEP = 300;
	end
	local curzoneID = GetZoneInstID(pc);


	_TRACK(curzoneID, "PLAYER",
	{
		{"RUNSCRIPT", pc, "DIRECT_START"},

		{"RUNSCRIPT", pc, "UIOpenToPC", "fullblack", 1},
		{"SLEEP", SLEEP},
		{"RUNSCRIPT", pc, "SetPos", x, y, z},

		{"RUNSCRIPT", pc, "UIOpenToPC", "fullblack", 0},

		{"RUNSCRIPT", pc, "DIRECT_END"},

	}
	);
end



function GET_RANDOM_POS(self, list, range)

	return GetRandomPos(self, list[1], list[2], list[3], range);

end

function SET_POS_AROUND(pc, x, y, z, range)

	if range == nil then
		range = 0;
	end

	local x, y, z = GetRandomPos(pc, x, y, z, range);
	if x == nil then
		return;
	end

	SetPos(pc, x, y, z);

end

function SET_POS_Y_AROUND(pc, x, y, z, range)

	if range == nil then
		range = 0;
	end

	local x, y, z = GetRandomPos(pc, x, y, z, range);
	if x == nil then
		return;
	end

	SetPos(pc, x, y, z);

end

function SET_POS(pc, list, range)

	if range == nil then
		SetPos(pc, list[1], list[2], list[3]);
	else

		local x, y, z = GetRandomPos(pc, list[1], list[2], list[3], range);
		if x == nil then
			return;
		end

		SetPos(pc, x, y, z);
	end
end

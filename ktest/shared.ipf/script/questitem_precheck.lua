function SCR_PRE_VACYS_RECORD(self, argstring, argnum1, argnum2)
    local pcX, pcY, pcZ = GetPos(self)
    if GetZoneName(self) == 'f_rokas_31' and SCR_POINT_DISTANCE(pcX,pcZ,-1229,576) <= 50 then
        return 1
    else
        if IsServerSection(self) == 1 then
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_'KupeoBoNeun_KyoChaLo'_Jiyeog_wangLeung_ipKue_Sewoya_HapNiDa"), 3);
        end
    end
    
    return 0
end




function SCR_PRE_CalmIncense(self, argstring, argnum1, argnum2)
    local fndList, fndCount = SelectObject(self, 50, 'ALL');
    if fndCount > 0 then
        local i
        for i = 1, fndCount do
            if IsBuffApplied(fndList[i],'Transparent')  == 'YES' then
                return GetHandle(fndList[i])
            end
        end
    end
    return 0
end

function SCR_PRE_Cmine8_9_WarpScroll(self, argstring, argnum1, argnum2)
    return 1
end






function SCR_PRE_Act4_Purify(self, argstring, argnum1, argnum2)
    local zonename = GetZoneName(self)
    if zonename == 'd_cmine_01' then
        return 1
    else
        if IsServerSection(self) == 1 then
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_SuJeong_KwangSan_1Cheung_eSeo_Sayong_KaNeung"), 2);
        end
        return 0
    end
end

function SCR_PRE_MINE_1_Charge_Scroll_1(self, argstring, argnum1, argnum2)
    local zonename = GetZoneName(self)
    local result1 = SCR_QUEST_CHECK(self, 'MINE_1_CRYSTAL_4')
    local result2 = SCR_QUEST_CHECK(self, 'MINE_1_CRYSTAL_8')
    local result3 = SCR_QUEST_CHECK(self, 'MINE_1_CRYSTAL_13')
    local result4 = SCR_QUEST_CHECK(self, 'MINE_2_CRYSTAL_5')
    local result5 = SCR_QUEST_CHECK(self, 'MINE_2_CRYSTAL_10')
--    local result6 = SCR_QUEST_CHECK(self, 'DMINE8_QUEST07')
    if zonename == 'd_cmine_01' or zonename == 'd_cmine_02' or zonename == 'd_cmine_6' then
        if result1 == 'PROGRESS' or result2 == 'PROGRESS' or result3 == 'PROGRESS' or result4 == 'PROGRESS' or result5 == 'PROGRESS' or result6 == 'PROGRESS' then
--            if result4 == 'PROGRESS' then
--                local fndList2, fndCount2 = SelectObject(self, 800, 'ALL', 1);
--                if fndCount2 > 0 then
--                    for x = 1, fndCount2 do
--                        if fndList2[x].ClassName ~= 'PC' and fndList2[x].Dialog == 'MINE_2_PURIFY_3' then
--                            return 1
--                        end
--                    end
--                end
--                
--                if IsServerSection(self) == 1 then
--                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_3Kuyeog_JeongHwaJangChi_KeunCheoeSeo_SayongKaNeung_HapNiDa!"), 2);
--                end
--            elseif result5 == 'PROGRESS' then
--                local fndList2, fndCount2 = SelectObject(self, 800, 'ALL', 1);
--                if fndCount2 > 0 then
--                    for x = 1, fndCount2 do
--                        if fndList2[x] ~= nil and fndList2[x].ClassName ~= 'PC' and fndList2[x].Dialog == 'MINE_2_PURIFY_6' then
--                            return 1
--                        end
--                    end
--                end
--                
--                if IsServerSection(self) == 1 then
--                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_5Kuyeog_JeongHwaJangChi_KeunCheoeSeo_SayongKaNeung_HapNiDa!"), 2);
--                end
--            else
                return 1
--            end
        else
            if IsServerSection(self) == 1 then
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_aJig_SayongHal_Su_eopSeupNiDa"), 2);
            end
        end
    else
        if IsServerSection(self) == 1 then
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_SuJeong_KwangSaneSeo_Sayong_KaNeung"), 2);
        end
        return 0
    end
--    return 0
end

function SCR_PRE_ITEM_RemoveALLBuff(self, argstring, argnum1, argnum2) -- ¹???f
    return 1
end

function SCR_PRE_FOLEMMAGICITEM(self, argstring, argnum1, argnum2)
	local fndList, fndCount = SelectObject(self, 60, 'ALL');
	local i
	local golem_count = 0
	
	for i = 1, fndCount do
		if fndList[i].ClassName == 'boss_Golem' and IsBuffApplied(fndList[i], 'Stun') == 'NO' then
		    return GetHandle(fndList[i])
		elseif fndList[i].ClassName == 'boss_Golem' then
		    golem_count = golem_count + 1
		end
	end
	if IsServerSection(self) == 1 then
	    if golem_count > 0 then
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_MaLyeog_BangHae_Jeogyong_Jung"), 2);
        else
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_KolLem_eopeum"), 2);
        end
    end
	return 0
end


function SCR_PRE_ROKAS31_Q12(self, argstring, argnum1, argnum2)
   local result1 = SCR_QUEST_CHECK(self, 'ROKAS31_MS_13')
   local result2 = SCR_QUEST_CHECK(self, 'ROKAS31_MS_14')
   if result2 == 'PROGRESS' then
        if GetLayer(self) ~= 0 then
            local fndList, fndCount = SelectObject(self, 50, 'ENEMY');
            local i
            if fndCount > 0 then
                for i = 1, fndCount do
                    if fndList[i].ClassName ~= 'PC' then
                    	if IsServerSection(self) == 1 then
                            return GetHandle(fndList[i])
                        end
                    end
                end
            end
        end   
   elseif result1 == 'PROGRESS' then
        local fndList, fndCount = SelectObject(self, 50, 'ENEMY');
        local i
        if fndCount > 0 then
            for i = 1, fndCount do
                if fndList[i].ClassName ~= 'PC' then
                    return GetHandle(fndList[i])
                end
            end
        end
    end
end




function SCR_PRE_KATYN10_OWL(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'KATYN10_MQ_05')
    local quest_ssn = GetSessionObject(self, 'SSN_KATYN10_MQ_05')
    if quest_ssn ~= nil then
        if result == 'PROGRESS' then
            local fndList, fndCount = SelectObject(self, 100, 'ALL');
            local i
            if fndCount > 0 then
                for i = 1, fndCount do
                    if fndList[i].ClassName == 'boss_Sequoia_sleep' then
                        return GetHandle(fndList[i])
                    end
                end
            end
        end
    end
    return 0
end


function SCR_PRE_KATYN10_OWL2(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'KATYN10_MQ_13')
    local quest_ssn = GetSessionObject(self, 'SSN_KATYN10_MQ_13')
    if quest_ssn ~= nil then
        if result == 'PROGRESS' then
            local fndList, fndCount = SelectObject(self, 100, 'ALL');
            local i
            if fndCount > 0 then
                for i = 1, fndCount do
                    if fndList[i].ClassName == 'boss_Sequoia_sleep' then
                        return GetHandle(fndList[i])
                    end
                end
            end
        end
    end
    return 0
end


function SCR_PRE_KATYN10_OWL3(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'KATYN10_MQ_27')
    local quest_ssn = GetSessionObject(self, 'SSN_KATYN10_MQ_27')
    if quest_ssn ~= nil then
        if result == 'PROGRESS' then
            local fndList, fndCount = SelectObject(self, 100, 'ALL');
            local i
            if fndCount > 0 then
                for i = 1, fndCount do
                    if fndList[i].ClassName == 'boss_Sequoia_sleep' then
                        return GetHandle(fndList[i])
                    end
                end
            end
        end
    end
    return 0
end


function SCR_PRE_SIAULIAI11_SoulPrisonScroll(self, argstring, argnum1, argnum2)
	local fndList, fndCount = SelectObject(self, 50, 'ENEMY');
	local i
	
	for i = 1, fndCount do
	    if fndList[i].ClassName == 'Goblin_Archer_red' then
	        if fndList[i].StrArg1 == 'None' then
    		    return GetHandle(fndList[i])
    		end
    	end
	end
	
	if IsServerSection(self) == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_'yeongHonKamog_SeuKeuLol'eul_JeogyongHal_JalLiaSeu_elLumi_eopSeupNiDa"), 5);
    end
	return 0
end

function SCR_PRE_ROKAS31_SUB_03_SCROLL(self, argstring, argnum1, argnum2)
	local fndList, fndCount = SelectObject(self, 100, 'ENEMY');
	local i
	
	for i = 1, fndCount do
	    if fndList[i].ClassName == 'warleader_hogma' then
	        if fndList[i].StrArg1 == 'None' then
    		    return GetHandle(fndList[i])
    		end
    	end
	end
	
	if IsServerSection(self) == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("ROKAS31_SUB_03_MSG01"), 3);
    end
    return 0
end



function SCR_PRE_JOB_PSYCHOKINESIST2_2_ITEM1(self, argstring, argnum1, argnum2)
    if GetLayer(self) ~= 0 then
        if GetZoneName(self) == 'd_thorn_20' then
            local fndList, fndCount = SelectObjectByFaction(self, 50, 'Peaceful', 1);
        	local i
        	
        	for i = 1, fndCount do
				local obj = fndList[i];
        	    if obj.ClassName == "Matsum" then
            	    return GetHandle(fndList[i])
            	end
        	end
        	
        	if IsServerSection(self) == 1 then
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_SilHeomyong_MonSeuTeoKa_eopSeupNiDa!"), 5);
            end
        end
    end
    
    return 0
    
	
end

function SCR_PRE_JOB_PYROMANCER2_1_ITEM1(self, argstring, argnum1, argnum2)
    local Sobj = GetSessionObject(self, "SSN_JOB_PYROMANCER2_1")
    if Sobj ~= nil then
        if GetLayer(self) == 0 then
            if GetZoneName(self) == 'f_gele_57_4' then
                if Sobj.Step1 < 1 then
                local fndList, fndCount = SelectObject(self, 50, 'ENEMY', 1);
                	if fndCount >= 1 then
                	    for i = 1, fndCount do
                	        if fndList[i].Faction == 'Monster' then
                	            return 1
                	        end
                	    end
                	end
            	elseif Sobj.Step1 >= 1 then
--                    Sobj.Step1 = 0
                    return 0
            	end
            	if IsServerSection(self) == 1 then
                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_JuByeone_Bului_Kiuneul_KaJyeool_MonSeuTeoKa_isseoya_HapNiDa!"), 5);
                end
            else
                if IsServerSection(self) == 1 then
                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_MuJiKae_yeonMos_JiyeogeSeoMan_SayongHal_Su_issSeupNiDa"), 5);
                end
            end
        else
            if IsServerSection(self) == 1 then
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_ilBan_PilDeueSeoMan_Sayong_Hal_Su_issSeupNiDa"), 5);
            end
        end
    end
    
    return 0
end

function SCR_PRE_JOB_PYROMANCER3_1_ITEM1(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'JOB_PYROMANCER3_2')
    if result == 'PROGRESS' then
        if GetLayer(self) == 0 then
            if GetZoneName(self) == 'f_rokas_25' then
                local fndList, fndCount = SelectObject(self, 50, 'ENEMY', 1);
            	local pcX, pcY, pcZ = GetPos(self)
                if SCR_POINT_DISTANCE(pcX,pcZ,821,1169) <= 50 then
                    return 1
                end
            else
                if IsServerSection(self) == 1 then
                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_MaBeopSaui_Tap_1Cheung_JiyeogeSeoMan_SayongHal_Su_issSeupNiDa"), 5);
                end
            end
        else
            if IsServerSection(self) == 1 then
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_ilBan_PilDeueSeoMan_Sayong_Hal_Su_issSeupNiDa"), 5);
            end
        end
    else
        if IsServerSection(self) == 1 then
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_aJigeun_Sayong_HaSil_Su_eopSeupNiDa"), 5);
        end
    end
    
    return 0
end

function SCR_PRE_JOB_KRIVI2_1_ITEM1(self, argstring, argnum1, argnum2)
	local fndList, fndCount = SelectObject(self, 70, 'ALL', 1);
	local i
	
	if fndCount > 0 then
    	for i = 1, fndCount do
    	    if fndList[i].ClassName == 'statue_zemina' or fndList[i].ClassName == 'statue_vakarine' then
    		    return GetHandle(fndList[i])
        	end
    	end
    end
	
	if IsServerSection(self) == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_yeoSinSangi_JuByeone_eopSeupNiDa!"), 5);
    end
	return 0
end

function SCR_PRE_JOB_WIZARD2_2_ITEM1(self, argstring, argnum1, argnum2)
    local info = {
                    {-697, 240, 605, 100}
                    ,{-951, -1, -502, 100}
                    ,{341, -1, -991, 100}
                    ,{934, -1, -467, 100}
                    ,{213, 148, 868, 100}
                }
    local result = SCR_QUEST_CHECK(self, 'JOB_WIZARD2_2')
    if result == 'PROGRESS' then
        if GetLayer(self) == 0 then
            if GetZoneName(self) == 'c_Klaipe' then
                local x, y, z = GetPos(self)
                for i = 1, 5 do
                    if SCR_POINT_DISTANCE(x,z,info[i][1],info[i][3]) <= info[i][4] then
                        return 1
                    end
                end
            end
        end
    end
    return 0
end


function SCR_PRE_JOB_WIZARD3_2_ITEM1(self, argstring, argnum1, argnum2)
    local info = {
                    {-642, 169, -281, 100}
                    ,{263, 160, -207, 100}
                    ,{494, 484, 906, 100}
                }
    local result = SCR_QUEST_CHECK(self, 'JOB_WIZARD3_2')
    if result == 'PROGRESS' then
        if GetLayer(self) == 0 then
            if GetZoneName(self) == 'c_fedimian' then
                local x, y, z = GetPos(self)
                for i = 1, 3 do
                    if SCR_POINT_DISTANCE(x,z,info[i][1],info[i][3]) <= info[i][4] then
                        return 1
                    end
                end
            end
        end
    end
    return 0
end


function SCR_PRE_JOB_SAPPER3_2_ITEM1(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0 then
        if GetZoneName(self) == 'f_siauliai_2' then
            local result = SCR_QUEST_CHECK(self, 'JOB_SAPPER3_2')
            if result == 'PROGRESS' then
                local fndList, fndCount = SelectObject(self, 80, 'ENEMY', 1);
            	local i
            	
            	if fndCount > 0 then
                	for i = 1, fndCount do
            		    return GetHandle(fndList[i])
                	end
                end
            	
            	if IsServerSection(self) == 1 then
                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_PogTaneul_SayongHal_MonSeuTeoKa_eopSeupNiDa!"), 3);
                end
            end
        else
            if IsServerSection(self) == 1 then
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_SyaulLei_DongJjog_SupeSeoMan_Sayong_KaNeungHapNiDa!"), 3);
            end
        end
    else
        if IsServerSection(self) == 1 then
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_yeonChul_SangHwangeSeoNeun_SayongHal_Su_eopSeupNiDa!"), 3);
        end
    end
    
    return 0
end

function SCR_PRE_KATYN71_DUMMY01(self, argstring, argnum1, argnum2)
    
    local result = SCR_QUEST_CHECK(self, 'KATYN71_MQ_07')
    if result == 'PROGRESS' then
        if GetLayer(self) ~= 0 then
            if GetZoneName(self) == 'f_katyn_7' then
                return 1
            end
        end
    end
    return 0
end


function SCR_PRE_KATYN71_DUMMY02(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'KATYN71_MQ_04')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_7' then
            return 1
        end
    end
    return 0
end



function SCR_PRE_THORN_RAIDE_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'raid_thorn1' then
        return 1
    end
    return 0
end

function SCR_PRE_SIAUL_EAST_RECLAIM4_ITME(self, argstring, argnum1, argnum2)
    
    local result = SCR_QUEST_CHECK(self, 'SIAUL_EAST_RECLAIM4')
    if result == 'PROGRESS' then
        if GetLayer(self) ~= 0 then
            if GetZoneName(self) == 'f_siauliai_2' then
                return 1
            end
        end
    end
    return 0
end


function SCR_PRE_ROKAS24_SQ_01_ITEM(self, argstring, argnum1, argnum2)
    local fndList, fndCount = SelectObject(self, 70, 'ENEMY');
	local i
	if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_rokas_24' then
        	for i = 1, fndCount do
        	    if fndList[i].ClassName == 'Pino' then
        	        if fndList[i].StrArg1 == 'None' then
            		    return GetHandle(fndList[i])
            		end
            	end
        	end
        end
    end
	
	if IsServerSection(self) == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_'PiNo'eKe_SayongKaNeung!"), 5);
    end
	return 0
    
end



function SCR_PRE_ROKAS27_QB_6(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'ROKAS27_QB_6')
    
    if result == 'PROGRESS' then
        if GetLayer(self) == 0 then
            
            if GetZoneName(self) == 'f_rokas_27' then
                
                return 1
            end
        end
    else
--        RunScript('TAKE_ITEM_TX', self, 'ROKAS27_QB_6', 1, "Q_ROKAS27_QB_6")
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_aMuKeosDo_BalKyeonHaJi_Mos_HaessSeupNiDa."), 3);
    end
    return 0
end

function SCR_PRE_ROKAS28_MQ1_QUESTMAP(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'ROKAS27_MQ_5')
    if result == 'COMPLETE' then
        if GetLayer(self) == 0 then
            if GetZoneName(self) == 'f_rokas_28' then
                return 1
            end
        end
    end
end

function SCR_PRE_ZACHA3F_MQ_02_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == "d_zachariel_34" then
    local fndList, fndCount = SelectObject(self, 40, 'ALL');
	local i
    local result = SCR_QUEST_CHECK(self, 'ZACHA3F_MQ_03')
        if result == 'PROGRESS' then
            for i = 1, fndCount do
                if fndList[i].ClassName == "wolf_statue_mage_pollution" then
                    return GetHandle(fndList[i])
                end
            end
        end
    end
    return 0
end

function SCR_PRE_REMAIN38_STONESLATE2(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'REMAIN38_MQ03')
    
    if result == 'PROGRESS' then
        if GetLayer(self) == 0 then
            
            if GetZoneName(self) == 'f_remains_38' then
                    local itemType = GetClass("Item", 'REMAIN38_STONESLATE2').ClassID;
                    local itemResult = GetInvItemCountByType(self, itemType)
--                    print(itemResult)
                    if itemResult >= 5 then
                        
                        return 1
                    else 
                        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_BiSeog_JoKagi_MoJaLapNiDa."), 3);
                    end
            end
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_BiSeog_JoKagi_MoJaLapNiDa."), 3);
    end
    return 0
end


function SCR_PRE_REMAIN38_SQ03(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'REMAIN38_SQ03')
    if result == 'PROGRESS' then
        if GetLayer(self) == 0 then
            if GetZoneName(self) == 'f_remains_38' then
                return 1
            end
        end
    end
    return 0
end

function SCR_PRE_REMAINS40_MQ_06_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == "f_remains_40" then
        local result = SCR_QUEST_CHECK(self, 'REMAINS40_MQ_06')
        if result == 'PROGRESS' then
            local quest_ssn = GetSessionObject(self, 'SSN_REMAINS40_MQ_06')
            if quest_ssn ~= nil then
                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                    if quest_ssn.QuestInfoValue2 < quest_ssn.QuestInfoMaxCount2 then
                        return 1
                    end
                end
            end
        end
    end
    return 0
end





function SCR_PRE_FTOWER41_MQ_04_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == "d_firetower_41" then
        local result = SCR_QUEST_CHECK(self, 'FTOWER41_MQ_04')
        if result == 'PROGRESS' then
            return 1
        end
    end
    return 0;
end



function SCR_PRE_FTOWER42_MQ_01_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'FTOWER42_MQ_01')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'd_firetower_42' then
            if GetLayer(self) == 0 then 
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, 2236, -729) < 900 then
                    return 1
                end
            end
        end
    end
    return 0
end


function SCR_PRE_FTOWER_FIRE_ESSENCE(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == "d_firetower_42" then
        local result = SCR_QUEST_CHECK(self, 'FTOWER42_MQ_03')
        if result == 'PROGRESS' then
            return 1
        end
    end
    return 0;
end

function SCR_PRE_THORN19_MQ02_POCKET(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'THORN19_MQ03')
    if result == 'PROGRESS' then
	    local fndList, fndCount = SelectObject(self, 30, 'ENEMY');
	    local i
	    if GetLayer(self) == 0  then
	        if GetZoneName(self) == 'd_thorn_19' then
        	    for i = 1, fndCount do
        	        if fndList[i].ClassName == 'Bagworm' then
            		    if fndList[i].StrArg1 == 'None' then
            		        return GetHandle(fndList[i])
            		    end
            	    end
        	    end
            end
        end
	end
	if IsServerSection(self) == 1 then
	    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_THORN19_MQ_MQ02_POCKET_WRONGUSE"), 5);
    end
	return 0
end

function SCR_PRE_THORN19_MQ05_BODFLUIDS(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'THORN19_MQ07')
    if result == 'PROGRESS' then
	    local fndList, fndCount = SelectObject(self, 30, 'ENEMY');
	    local i
	    if GetLayer(self) == 0  then
	        if GetZoneName(self) == 'd_thorn_19' then
        	    for i = 1, fndCount do
        	        if fndList[i].ClassName == 'truffle' then
        	            if fndList[i].StrArg1 == 'None' then
            		        return GetHandle(fndList[i])
            		    end
            	    end
        	    end
            end
        end
	end
	if IsServerSection(self) == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_THORN19_MQ05_BODFLUIDS_WRONGUSE"), 5);
    end
	return 0
end

function SCR_PRE_THORN20_MQ05_THORNDRUG(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'THORN20_MQ06')
    local result1 = SCR_QUEST_CHECK(self, 'THORN20_MQ07')
    if result == 'PROGRESS' or result1 == 'PROGRESS' then
--        local buff_Result = GetBuffByName(self, 'Weaken')
	    if GetLayer(self) ~= 0  then
	        if GetZoneName(self) == 'd_thorn_20' then
--        	    if buff_Result ~= nil then
            	    return 1
--            	end
            end
        end
    end
--	if IsServerSection(self) == 1 then
--        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_THORNFLOWER_WRONGUSE"), 5);
--    end
	return 0
end


function SCR_PRE_CHAPLE576_MQ_07(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_chapel_57_6' then
    local result1 = SCR_QUEST_CHECK(self, 'CHAPLE576_MQ_07')
    local result2 = SCR_QUEST_CHECK(self, 'CHAPLE576_MQ_08')
        if result1 == 'PROGRESS' or result2 == 'PROGRESS' then
            if result2 == 'PROGRESS' then
                if GetLayer(self) ~= 0 then
                    local list, cnt = SelectObject(self, 100, 'ENEMY');
                    local i
            	    for i = 1, cnt do
            		    return GetHandle(list[i])
            	    end
                else
                    return 0
                end
            end
            local list, cnt = SelectObject(self, 100, 'ENEMY');
--            local list, cnt = SelectObjectByClassName(self, 100, '****');
            local i
            if GetLayer(self) == 0  then
        	    for i = 1, cnt do
        		    return GetHandle(list[i])
        	    end
            end
        end
        if IsServerSection(self) == 1 then
--            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_THORNFLOWER_WRONGUSE"), 5);
        end
    
    end
    return 0
end

function SCR_PRE_THORN20_MQ05_DRUG(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_thorn_20' then
        local result1 = SCR_QUEST_CHECK(self, 'THORN20_MQ05')
        local thorn20_item1 = GetInvItemCount(self, 'THORN20_MQ05_GROLL')
        if result1 == "PROGRESS" then
            if thorn20_item1 >= 5 then
                return 1
            end
        end
    end
    return 0
end





function SCR_PRE_CHAPLE577_MQ_06(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_chapel_57_7' then
        local result = SCR_QUEST_CHECK(self, 'CHAPLE577_MQ_06')
        if result == "PROGRESS" then
            return 1
        end
    end
    return 0
end


function SCR_PRE_CHAPLE577_MQ_07(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_chapel_57_7' then
        if GetLayer(self) ~= 0 then
            local result = SCR_QUEST_CHECK(self, 'CHAPLE577_MQ_07')
            if result == "PROGRESS" then
                local list, cnt = SelectObject(self, 150, 'ENEMY');
                local i
        	    for i = 1, cnt do
        		    return GetHandle(list[i])
        	    end
            end
        end
    end
    return 0
end



function SCR_PRE_KEY_OF_LEGEND_01(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'CHAPLE577_MQ_10')
    local result2 = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_69_MQ060')
--    local result2 = SCR_QUEST_CHECK(self, 'HUEVILLAGE_58_1_MQ11')
    
    local PC_zone = GetZoneName(self)
    
    if PC_zone == 'd_chapel_57_7' then
        if GetLayer(self) == 0 then
            if result1 == "PROGRESS" or result1 == "SUCCESS" or result1 == "COMPLETE" then
                local list_npc, cnt_npc = SelectObject(self, 40, 'ALL', 1)
                local i
                for i = 1, cnt_npc do
                    if list_npc[i].ClassName == "secret_warp_npc" then
                        return 1;
                    end
                end
            end
        end
--    elseif PC_zone == 'f_huevillage_58_1' then
--        if GetLayer(self) ~= 0 then
--            if result2 == "PROGRESS" then
--                local list, cnt = SelectObject(self, 100, 'ALL')
--                local i
--        	    for i = 1, cnt do
--            	    if list[i].ClassName == 'magicsquare_1_mini' then
--                        return 1
--                    end
--        	    end
--            end
--        end
    elseif PC_zone == 'f_siauliai_west' or
            PC_zone == 'f_pilgrimroad_52' or
            PC_zone == 'd_velniasprison_51_4' or
            PC_zone == 'd_velniasprison_51_1' or
            PC_zone == 'd_velniasprison_51_5' or
            PC_zone == 'id_catacomb_25_4' or
            PC_zone == 'f_maple_25_1' then
            
        if GetLayer(self) == 0 then
--            if result1 == "PROGRESS" or result2 == "PROGRESS" then
            if result1 == "PROGRESS" then
                local list_npc, cnt_npc = SelectObject(self, 40, 'ALL', 1)
                local i
                for i = 1, cnt_npc do
                    if list_npc[i].ClassName == "secret_warp_npc" then
                        return 1;
                    end
                end
            else
                return 1;
            end
        end
    end
    return 0
end

function SCR_PRE_THORN21_MQ07_THORNDRUG(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'THORN21_MQ07')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_thorn_21' then
            if GetLayer(self) ~= 0 then
--            local fndList, fndCount = SelectObject(self, 95, 'ALL', 1);
--            for i = 1, fndCount do
--                print(fndList[i].ClassName)
--        	    if fndList[i].ClassName == 'HiddenTrigger6' or  fndList[i].ClassName == 'HiddenTrigger2' then
            	    return 1
--            	end
--            end
            end
        end
    end
    return 0
end

function SCR_PRE_THORN21_MQ04_DRUG(self, argstring, argnum1, argnum2)
    local result2 = SCR_QUEST_CHECK(self, 'THORN21_MQ04')
    if result2 == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'd_thorn_21' then
                local thorn21_item1 = GetInvItemCount(self, 'THORN21_MQ04_BUGWING')
                if thorn21_item1 >= 4 then
                    return 1
                end
            end
        end
    end
    return 0
end



function SCR_PRE_GELE574_MQ_08_ITEM(self, argstring, argnum1, argnum2)
    local result2 = SCR_QUEST_CHECK(self, 'GELE574_MQ_08')
    if result2 == 'PROGRESS' then
        if GetLayer(self) ~= 0  then
    	    if GetZoneName(self) == 'd_thorn_21' then
    	        local list, cnt = SelectObject(self, 100, 'ALL')
    	        local i
    	        for i = 1, cnt do
    	            if list[i].Enter == 'GELE574_MQ_08_D' then
    	                return GetHandle(list[i])
    	            end
    	        end
            end
        end
    end
    return 0
end





function SCR_PRE_JOB_FLETCHER4_1_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'JOB_FLETCHER4_1')
    if result == 'PROGRESS' then
        return 1
    end
    return 0
end


function SCR_PRE_JOB_WUGU4_1_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'JOB_WUGU4_1')
    if result == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'f_katyn_14' then
    	        local list, cnt = SelectObject(self, 100, 'ENEMY')
    	        local i
    	        for i = 1, cnt do
    	            if list[i].ClassName == 'honey_bee' then
    	                return GetHandle(list[i])
    	            end
    	        end
            end
        end
    end
    return 0
end


function SCR_PRE_JOB_SCOUT4_1_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'JOB_SCOUT4_1')
    if result == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'f_pilgrimroad_52' then
                local quest_ssn = GetSessionObject(self, 'SSN_JOB_SCOUT4_1')
                if quest_ssn ~= nil then
--                    if quest_ssn.Goal1 == 1 then
                        return 1
--                    end
                end
            end
        end
    end
    return 0
end



function SCR_PRE_JOB_ROGUE4_1_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'JOB_ROGUE4_1')
    if result == 'PROGRESS' then
        if GetLayer(self) ~= 0  then
    	    if GetZoneName(self) == 'f_katyn_7' then
                return 1;
            end
        end
    end
    return 0
end



function SCR_PRE_JOB_SWORDMAN4_1_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'JOB_SWORDMAN4_1')
    if result == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'f_pilgrimroad_55' then
--    	        if GetHatedCount(self) >= 5 then
    	            local quest_ssn = GetSessionObject(self, 'SSN_JOB_SWORDMAN4_1')
                    if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
            	        local list, cnt = SelectObject(self, 50, 'ENEMY')
            	        local i
            	        for i = 1, cnt do
        	                return GetHandle(list[i])
            	        end
                        if IsServerSection(self) == 1 then
                            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg('Auto_JOB_ROGUE4_1_MSG'), 1);
                        end
                    end
--                end
            end
        end
    end
    return 0
end



function SCR_PRE_JOB_CENTURION5_1_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'JOB_CENTURION5_1')
    if result == 'PROGRESS' then
        if GetLayer(self) ~= 0 then
            return 1
        end
    end
    return 0
end



function SCR_PRE_JOB_SQUIRE4_1_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'JOB_SQUIRE4_1')
    if result == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'f_katyn_13' then
    	        local list, cnt = SelectObject(self, 100, 'ENEMY')
    	        local i
    	        for i = 1, cnt do
	                return GetHandle(list[i])
    	        end
            end
        end
    end
    return 0
end



function SCR_PRE_MODPAT_DEV_ITEM(self, argstring, argnum1, argnum2)
    return 1
end



function SCR_PRE_REMAIN39_SQ03_FEDIMIAN(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'REMAIN39_SQ02')
    if result == 'COMPLETE' then
        return 1
    end
    return 0
end



function SCR_PRE_REMAINS40_MQ_07_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'REMAINS40_MQ_07')
    if result == 'COMPLETE' then
        return 1
    end
    return 0
end


function SCR_PRE_HIGHLANDER_HQ01_BOX(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'HIGHLANDER_HQ_02')
    local highlander_Item1 = GetInvItemCount(self, 'WOOD_CARVING_REPAIR_WOOD')
    local highlander_Item2 = GetInvItemCount(self, 'WOOD_CARVING_REPAIR_ROPE')
    local highlander_Item3 = GetInvItemCount(self, 'WOOD_CARVING_WRECK')
    if result == 'PROGRESS' then
        if highlander_Item1 >= 5 and highlander_Item2 >= 1 and highlander_Item3 >= 1 then
            if GetLayer(self) == 0  then
        	    return 1
        	end
        end
    end
    return 0
end

function SCR_PRE_ROKAS_30_HQ01_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'ROKAS_30_HQ_01')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_rokas_29' then
            if GetLayer(self) == 0  then
                local list, cnt = SelectObject(self, 100, 'ALL', 1)
        	    for i = 1, cnt do
        	        if list[i].ClassName == "stone_monument1" then
                        return 1
                    end
                end
            end
        end
    end
    return 0
end



function SCR_PRE_GELE572_MQ_06(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == "f_gele_57_2" then
        local result1 = SCR_QUEST_CHECK(self, 'GELE572_MQ_06')
        local result2 = SCR_QUEST_CHECK(self, 'GELE572_MQ_07')
        if result1 == 'PROGRESS' or result2 == 'PROGRESS' then
            return 1
        end
    end
    return 0;
end


--GELE572_MQ_04
function SCR_PRE_GELE572_MQ_DOLL_01(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == "f_gele_57_2" then
        local result1 = SCR_QUEST_CHECK(self, 'GELE572_MQ_04')
        local result2 = SCR_QUEST_CHECK(self, 'GELE572_MQ_05')
        if result1 == 'PROGRESS' or result2 == 'PROGRESS' then
            return 1
        end
    end
    return 0;
end


--GELE574_MQ_05_ITEM
function SCR_PRE_GELE574_MQ_05_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_gele_57_4' then
        if GetLayer(self) == 0 then
            local result1 = SCR_QUEST_CHECK(self, 'GELE574_MQ_05')
            if result1 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 50, 'ALL')
                local i 
                for i = 1, cnt do
                    if list[i].ClassName == 'Npanto_archer' then
                        if IsBuffApplied(list[i], 'GELE574_MQ_05') == 'NO' then
                            if IsBuffApplied(list[i], 'GELE574_MQ_05_2') == 'NO' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--GELE574_MQ_06_ITEM
function SCR_PRE_GELE574_MQ_06_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_gele_57_4' then
        if GetLayer(self) ~= 0 then
            local result1 = SCR_QUEST_CHECK(self, 'GELE574_MQ_06')
            if result1 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 80, 'ALL')
                local i 
                for i = 1, cnt do
                    if list[i].ClassName == 'Npanto_archer' then
                        if list[i].Name ~= ScpArgMsg("SSN_GELE574_MQ_05_RUN") then
                            if IsBuffApplied(list[i], 'GELE574_MQ_06') == 'NO' then
                                return 1
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end





--CHAPLE575_MQ_06
function SCR_PRE_CHAPLE575_MQ_06_ITEM(self, argstring, argnum1, argnum2)
    
    if GetZoneName(self) == 'd_chapel_57_5' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'CHAPLE575_MQ_06')
            if result1 == 'PROGRESS' then
                return 1
            end
        end
    end
    return 0
end




--CHAPLE575_MQ_07
function SCR_PRE_CHAPLE575_MQ_07_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_chapel_57_5' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'CHAPLE575_MQ_07')
            if result1 == 'PROGRESS' then
--                local x,y,z = GetPos(self)
--                if SCR_POINT_DISTANCE(x, z, -818, -165) < 300 then
                    return 1
--                end
            end
        end
    end
    return 0
end





function SCR_PRE_HUEVILLAGE_58_2_MQ01_ITEM2(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_huevillage_58_2' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'HUEVILLAGE_58_2_MQ01')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 100, 'ENEMY')
                local i 
                for i = 1, fndCnt do
                    if fndList[i].ClassName == 'Zibu_Maize' then
                        if GetHpPercent(fndList[i]) <= 0.5 then
                            return GetHandle(fndList[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end






--CHAPLE576_MQ_06
function SCR_PRE_CHAPLE576_MQ_06_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_chapel_57_6' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'CHAPLE576_MQ_06')
            if result1 == 'PROGRESS' then
                if IsBuffApplied(self, 'CHAPLE576_MQ_06_1') == "NO" and IsBuffApplied(self, 'CHAPLE576_MQ_06') == "YES" then
                    return 1
                end
            end
        end
    end
    return 0
end



--REMAIN37_MQ01_ITEM
function SCR_PRE_REMAIN37_MQ01_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_remains_37' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'REMAIN37_MQ01')
            if result1 == 'PROGRESS' then
                local itemResult = GetInvItemCount(self, 'REMAIN37_MQ01_ITEM')
                if itemResult >= 10 then
                    return 1
                end
            end
        end
    end
    return 0
end


--REMAIN37_MQ02_ITEM
function SCR_PRE_REMAIN37_MQ02_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_remains_37' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'REMAIN37_MQ02')
            if result1 == 'PROGRESS' then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, -848, -2211) <= 550 then
                    return 1
                end
            end
        end
    end
    return 0
end



--REMAIN37_SQ03_ITEM_02
function SCR_PRE_REMAIN37_SQ03_ITEM_02(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_remains_37' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'REMAIN37_SQ03')
            if result1 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 30, 'ALL')
                local i
                for i = 1, cnt do
                    if list[i].ClassName == 'stub_tree' then
                        return GetHandle(list[i])
                    end
                end
            end
        end
    end
    return 0
end


--SCR_PRE_REMAIN38_MQ03_2_ITEM
function SCR_PRE_REMAIN38_MQ03_2_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_remains_38' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'REMAIN38_MQ03')
            if result1 == 'PROGRESS' then
                local quest_ssn = GetSessionObject(self, 'SSN_REMAIN38_MQ03')
                if quest_ssn ~= nil then
                    if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                        local list, cnt = SelectObject(self, 100, 'ALL')
                        local i
                        for i = 1, cnt do
                            if list[i].ClassName == 'Long_Arm' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--SIAULIAI_46_3_MQ_01_ITEM
function SCR_PRE_SIAULIAI_46_3_MQ_01_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_siauliai_46_3' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'SIAULIAI_46_3_MQ_02')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 100, 'ENEMY')
                local i 
                for i = 1, fndCnt do
                    if fndList[i].Faction == 'Monster' then
                        return GetHandle(fndList[i])
                    end
                end
            end
        end
    end
    return 0
end


function SCR_PRE_CHATHEDRAL53_MQ03_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'CHATHEDRAL53_MQ03')
    local result2 = SCR_QUEST_CHECK(self, 'CHATHEDRAL54_MQ01_PART1')
    local result3 = SCR_QUEST_CHECK(self, 'CHATHEDRAL56_MQ08')
    local result4 = SCR_QUEST_CHECK(self, "CHATHEDRAL56_MQ01")
    local result5 = SCR_QUEST_CHECK(self, "CHATHEDRAL56_SQ01")
    local result6 = SCR_QUEST_CHECK(self, "CHATHEDRAL56_MQ05")
    
    local Hide_result = isHideNPC(self, "CHATHEDRAL56_MQ_BISHOP")
    local Hide_result02 = isHideNPC(self, "CHATHEDRAL54_BISHOP_AFTER")
    
    if GetZoneName(self) == 'd_cathedral_53' then
        if result1 == 'PROGRESS' or result1 == 'SUCCESS' or result1 == 'COMPLETE' then
            if GetLayer(self) == 0 then
                return 1
            elseif GetLayer(self) >= 1 then
                if Hide_result == "YES" then
                    return 1
                else 
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM"), 3);
                    return 0
                end
            end
        end
    elseif GetZoneName(self) == 'd_cathedral_54' then
        if result3 == "COMPLETE" then
            return 0
        elseif result2 == 'COMPLETE' then
            if GetLayer(self) == 0 then
                if Hide_result02 == "NO" then
                    return 0
                elseif Hide_result02 == "YES" then
                    return 1
                end
            end
        end
    elseif GetZoneName(self) == 'f_pilgrimlord_55' then
        return 0
    elseif GetZoneName(self) == 'd_cathedral_56' then
        if GetLayer(self) >= 1 then
        print(GetLayer(self))
            if result6 == "PROGRESS" then
                return 1
            end
        elseif GetLayer(self) == 0 then
            if Hide_result == 'YES' then
                return 1
            else
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM"), 3);
                return 0
            end
        end
    end
    
    if result5 == "PROGRESS" then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
        return 0
    else
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM"), 3);
        return 0
    end
end

--SIAULIAI_46_2_MQ_01_ITEM
function SCR_PRE_SIAULIAI_46_2_MQ_01_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'SIAULIAI_46_2_MQ_02')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_siauliai_46_2' then
            if GetLayer(self) == 0 then 
                local fndList, fndCnt = SelectObject(self, 100, 'ENEMY')
                local i 
                for i = 1, fndCnt do
                    if fndList[i].Faction == 'Monster' then
                        if GetHpPercent(fndList[i]) <= 0.5 then
                            return GetHandle(fndList[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--SIAULIAI_46_2_MQ_03_ITEM
function SCR_PRE_SIAULIAI_46_2_MQ_03_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'SIAULIAI_46_2_MQ_03')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_siauliai_46_2' then
            if GetLayer(self) == 0 then 
                local fndList, fndCnt = SelectObject(self, 250, 'ALL')
                local i 
                for i = 1, fndCnt do
                    if fndList[i].ClassName ~= 'PC' then
                        if fndList[i].Name == 'SIAULIAI_46_2_MQ_03_TRIGGER' then
                            return 1
                        end
                    end
                end
            end
        end
    end
    return 0
end

--PILGRIM50_SQ_030
function SCR_PRE_PILGRIM50_ITEM_01(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'PILGRIM50_SQ_030')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_pilgrimroad_50' then
            if GetLayer(self) == 0 then 
                local fndList, fndCnt = SelectObject(self, 100, 'ENEMY')
                local i 
                for i = 1, fndCnt do
                    if fndList[i].Faction == 'Monster' then
          	            if fndList[i].StrArg1 == 'None' and (fndList[i].ClassName == 'kodomor' or fndList[i].ClassName == 'Romor' 
          	             or fndList[i].ClassName == 'lapasape_bow' or fndList[i].ClassName == 'Siaulav_mage') then
            	            --print(fndList[i].Name)
                		    return GetHandle(fndList[i])
                		end
                    end
                end
            end
        end
    end
    return 0
end

--SIAULIAI_46_1_SQ_05_ITEM01
function SCR_PRE_SIAULIAI_46_1_SQ_05_ITEM01(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'SIAULIAI_46_1_SQ_05')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_siauliai_46_1' then
            if GetLayer(self) == 0 then 
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, 775, 655) < 500 then
                    return 1
                end
            end
        end
    end
    return 0
end

--CHATHEDRAL56_MQ03
function SCR_PRE_CHATHEDRAL56_MQ03_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_cathedral_56' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'CHATHEDRAL56_MQ03')
            if result1 == 'PROGRESS' then
                if IsBuffApplied(self, 'CHATHEDRAL56_MQ03_BUFF') == "NO" then --and IsBuffApplied(self, 'CHAPLE576_MQ_06') == "YES" then
                    return 1
                end
            end
        end
    end
    return 0
end


function SCR_PRE_PILGRIM51_ITEM_01(self, argstring, argnum1, argnum2)
    local zone = GetZoneName(self)
    --local layer = GetLayer(self)
    if zone == 'f_pilgrimroad_51' then
        return 1;
    end
end

--PILGRIM51_SQ_5_1
function SCR_PRE_PILGRIM51_ITEM_11(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0 then
        --print("aaaa", self.Name)
        if GetZoneName(self) == 'f_pilgrimroad_51' then
            local result = SCR_QUEST_CHECK(self, 'PILGRIM51_SQ_5_1')
            if result == 'PROGRESS' then
                --print("bbbbbbbbb")
            
            	local fndList, fndCount = SelectObject(self, 100, 'ALL', 1);
            	local i
            	
            	for i = 1, fndCount do
            	    --print(fndList[i].Name)
            	    if fndList[i].Name ==  "PILGRIM51_INSIGNIA" then   
            	        --print("gggggg")
                	    return GetHandle(fndList[i])
                	end
            	end
            end
        end
    end
    return 0
end

function SCR_PRE_PILGRIM46_ITEM_07(self, argstring, argnum1, argnum2)
--    print(self.ClassName, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM46_SQ_100')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_pilgrimroad_46' then
    
        	local fndList, fndCount = SelectObject(self, 100, 'ALL', 1);
        	local i
        	for i = 1, fndCount do
        	    if fndList[i].ClassName == 'Kepari' or fndList[i].ClassName == 'Kepo' 
        	     or fndList[i].ClassName == 'Kepo_seed' or fndList[i].ClassName == 'wood_goblin_red' then
        	        if fndList[i].StrArg1 == 'None' then
        	            --print(fndList[i].Name)
            		    return GetHandle(fndList[i])
            		end
            	end
        	end
        	
        end
    end
    return 0
end



function SCR_PRE_FLASH64_SQ_08_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'FLASH64_SQ_08')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_flash_64' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 100, 'ENEMY')
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
	    end
    end
    return 0
end



--CMINE_COMPASS_ITEM
function SCR_PRE_CMINE_COMPASS_ITEM(self, argstring, argnum1, argnum2)
--    local PC_zone = GetZoneName(self)
--    if PC_zone == 'd_cmine_01' or PC_zone == 'd_cmine_02' then
--        if GetLayer(self) == 0 then
--            return 1
--        end
--    end
--    return 0

    local PC_zone = GetZoneName(self)
    if PC_zone == 'd_cmine_01' then
        local result1 = SCR_QUEST_CHECK(self, 'MINE_1_CRYSTAL_8')
        local result2 = SCR_QUEST_CHECK(self, 'MINE_1_CRYSTAL_13')

        if result1 == "PROGRESS" or result2 == "PROGRESS" then
            return 1
        end
        
    elseif PC_zone == 'd_cmine_02' then
        local result1 = SCR_QUEST_CHECK(self, 'MINE_2_CRYSTAL_5')
        local result2 = SCR_QUEST_CHECK(self, 'MINE_2_CRYSTAL_7')
        local result3 = SCR_QUEST_CHECK(self, 'MINE_2_CRYSTAL_14')
        
        if result1 == "PROGRESS" or result2 == "PROGRESS" or result3 == "PROGRESS" then
            return 1
        end
    end

    return 0
end



--SELECT_PLEASE_ITEM
function SCR_PRE_SELECT_PLEASE_ITEM(self, argstring, argnum1, argnum2)
    return 1
end



function SCR_PRE_FLASH59_SQ_04_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'FLASH59_SQ_04')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_flash_59' then
            if GetLayer(self) == 0 then 
            	local list, cnt = SelectObject(self, 30, 'ALL');
            	local i
        	    for i = 1, cnt do
        	        if list[i].ClassName == 'blank_npc' then
                        return GetHandle(list[i])
                    end
        	    end
        	end
        end
    end
    return 0
end


function SCR_PRE_FLASH60_SQ_05_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'FLASH60_SQ_05')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_flash_60' then
            if GetLayer(self) == 0 then 
            	local list, cnt = SelectObject(self, 100, 'ALL');
            	local i
        	    for i = 1, cnt do
        	        if list[i].ClassName == 'Bavon' or list[i].ClassName == 'Moya' then
                        return GetHandle(list[i])
                    end
        	    end
        	end
        end
    end
    return 0
end



--FLASH61_SQ_08
function SCR_PRE_FLASH61_SQ_08_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'FLASH61_SQ_08')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_flash_61' then
            if GetLayer(self) == 0 then 
                return 1
        	end
        end
    end
    return 0
end


--FLASH63_SQ_06
function SCR_PRE_FLASH63_SQ_06_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'FLASH63_SQ_06')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_flash_63' then
            if GetLayer(self) == 0 then 
                local list, cnt = SelectObject(self, 100, 'ALL')
                local i
                for i = 1 , cnt do
                    if list[i].ClassName == 'Lemur' or list[i].ClassName == 'goblin2_hammer' or list[i].ClassName == 'goblin2_wand3' then 
                        return GetHandle(list[i])
                    end
                end
        	end
        end
    end
    return 0
end


--THORN19_MQ09
function SCR_PRE_THORN19_MQ8_SOLVENT(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'THORN19_MQ09')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_thorn_19' then
            if GetLayer(self) == 0 then 
                local list, cnt = SelectObject(self, 50, 'ALL')
                local i
                for i = 1 , cnt do
                    if list[i].ClassName == "thorn_gateway_4_2" then
                        return GetHandle(list[i])
                    end
                end
        	end
        end
    end
    return 0
end

--THORN19_MQ09
function SCR_PRE_THORN19_MQ13_SPELLCRYSTAL(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'THORN19_MQ14')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_thorn_19' then
            if GetLayer(self) == 0 then 
                local list, cnt = SelectObject(self, 50, 'ALL',1)
                local i
                if cnt > 0 then
                for i = 1 , cnt do
                    if list[i].ClassName == "thorn_gateway_1_2" then
                        return GetHandle(list[i])
                    end
                end
                end
        	end
        end
    end
    return 0
end


--CATHEDRAL53_SQ_02
function SCR_PRE_CATHEDRAL53_SQ_02_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL53_SQ02')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_cathedral_53' then
            if GetLayer(self) == 0 then 
                local list, cnt = SelectObject(self, 240, 'ALL', 1)
                if cnt > 0 then
                for i = 1 , cnt do
                    if list[i].ClassName == "HiddenTrigger4" then
                        return 1
                    end
                end
                end
        	end
        end
    end
    return 0
end

--CATHEDRAL54_SQ_04
function SCR_PRE_CATHEDRAL54_SQ_04_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL54_SQ03_PART1')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_cathedral_54' then
            if GetLayer(self) == 0 then 
                local list, cnt = SelectObject(self, 50, 'ALL', 1)
                local i
                if cnt > 0 then
                for i = 1 , cnt do
                    if list[i].ClassName == "Stoulet_blue" or list[i].ClassName == "NightMaiden_mage" then
                        return GetHandle(list[i])
                    end
                end
                end
        	end
        end
    end
    return 0
end

--CHATHEDRAL54_SQ04_PART2
function SCR_PRE_CATHEDRAL54_SQ04_PART2_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL54_SQ04_PART2')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_cathedral_54' then
            if GetLayer(self) == 0 then 
--                local list, cnt = SelectObject(self, 40, 'ALL')
--                local i
--                for i = 1 , cnt do
--                    if list[i].ClassName == "Stoulet_blue" then
--                        return GetHandle(list[i])
                            return 1
--                    end
--                end
        	end
        end
    end
    return 0
end

--CHATHEDRAL54_SQ04_PART2
function SCR_PRE_PILGRIMROAD55_SQ03_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIMROAD55_SQ03')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_pilgrimroad_55' then
            if GetLayer(self) == 0 then
                return 1
        	end
        end
    end
    return 0
end

--CHATHEDRAL53_MQ06_REDKEY
function SCR_PRE_CHATHEDRAL53_MQ06_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL56_MQ08')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_cathedral_56' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 40, 'ALL',1)
                local i
                for i = 1 , cnt do
                    if list[i].ClassName == "holly_sphere_chapel_01" then
                        return GetHandle(list[i])
                    end
        	    end
            end
        end
        return 0
    end
end

--CHATHEDRAL53_MQ06_BULEKEY
function SCR_PRE_CHATHEDRAL54_MQ01_PART1_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL56_MQ08')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_cathedral_56' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 40, 'ALL',1)
                local i
                for i = 1 , cnt do
                    if list[i].ClassName == "holly_sphere_chapel_01" then
                        return GetHandle(list[i])
                    end
        	    end
            end
        end
        return 0
    end
end

--CHATHEDRAL53_MQ06_PURPLEKEY
function SCR_PRE_CHATHEDRAL54_MQ04_PART2_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL56_MQ08')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_cathedral_56' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 40, 'ALL',1)
                local i
                for i = 1 , cnt do
                    if list[i].ClassName == "holly_sphere_chapel_01" then
                        return GetHandle(list[i])
                    end
        	    end
            end
        end
        return 0
    end
end

--CHATHEDRAL53_MQ06_GREENKEY
function SCR_PRE_CHATHEDRAL56_MQ04_PART2_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL56_MQ08')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_cathedral_56' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 40, 'ALL',1)
                local i
                for i = 1 , cnt do
                    if list[i].ClassName == "holly_sphere_chapel_01" then
                        return GetHandle(list[i])
                    end
        	    end
            end
        end
        return 0
    end
end

--CHATHEDRAL53_MQ06_YELLOWKEY
function SCR_PRE_CHATHEDRAL56_SQ01_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL56_MQ08')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_cathedral_56' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 40, 'ALL',1)
                local i
                for i = 1 , cnt do
                    if list[i].ClassName == "holly_sphere_chapel_01" then
                        return GetHandle(list[i])
                    end
        	    end
            end
        end
        return 0
    end
end

--CHATHEDRAL54_MQ04_PART2
function SCR_PRE_CATHEDRAL54_MQ02_PART2_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL54_MQ04_PART2')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_cathedral_54' then
            if GetLayer(self) == 0 then
                return 1
            end
        end
    end
    return 0
end

--PILGRIM51_SQ_9
function SCR_PRE_PILGRIM51_SQ_9_ITEM_1(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM51_SQ_9')
    if result == 'PROGRESS' then
        local currentZone = GetZoneName(self)
        if currentZone ~= StringArg then
            return 1;
        else
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_9_MSG06"), 3);
            return 0;
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_9_MSG07"), 3);
        return 0
    end
end


--VPRISON512_MQ_03
function SCR_PRE_VPRISON512_MQ_03_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'VPRISON512_MQ_03')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_velniasprison_51_2' then
            if GetLayer(self) == 0 then 
                local list, cnt = SelectObject(self, 100, 'ENEMY')
                local i
                for i = 1 , cnt do
                    if list[i].ClassName ~= 'rootcrystal_05' then
                        return GetHandle(list[i])
                    end
                end
        	end
        end
    end
    return 0
end

--UNDERF592_TYPEB_POTION
function SCR_PRE_UNDERF592_TYPEB_POTION(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_underfortress_59_2' then
        if GetLayer(self) == 0 then 
            return 1
    	end
    else
        return 0
    end
    return 0
end


--FARM492_MQ05 TOOL
function SCR_PRE_FARM49_2_MQ05_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'FARM49_2_MQ05')
    local quest_ssn = GetSessionObject(self, 'SSN_FARM49_2_MQ05')
    if result == "PROGRESS" then
        if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
            if GetZoneName(self) == 'f_farm_49_2' then
                if GetLayer(self) == 0 then
                    if quest_ssn.Step1 ~= 1 then
                        local list, cnt = SelectObjectByFaction(self, 50, 'Monster', 1)
                        local i
                        for i = 1, cnt do
                            if list[i].ClassName == 'Flying_Flog_green' then
                                if GetHpPercent(list[i]) < 0.5 then
                                    return GetHandle(list[i])
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--FARM492_MQ06 BOWL
function SCR_PRE_FARM49_2_MQ06_ITEM1(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'FARM49_2_MQ06')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_farm_49_2' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 2, 'ALL', 1)
                local i
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].Faction == 'Neutral' then
                                if IsServerSection(self) == 1 then
                                    if list[i].Dialog == 'FARM492_MQ_06_2' then
                                        return GetHandle(list[i])
                                    end
                                else
                                    if GetDialogByObject(list[i]) == 'FARM492_MQ_06_2' then
                                        return GetHandle(list[i])
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--FARM47_4_SQ_090
function SCR_PRE_FARM47_4_SQ_090_ITEM_2(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'FARM47_4_SQ_090')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_siauliai_47_4' then
            if GetLayer(self) == 0 then
                return 1
        	end
        end
    end
    return 0
end



--VPRISON515_MQ_RUNE
function SCR_PRE_VPRISON515_MQ_RUNE_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'VPRISON515_MQ_03')
    local result2 = SCR_QUEST_CHECK(self, 'VPRISON515_MQ_04')
    local result3 = SCR_QUEST_CHECK(self, 'VPRISON515_MQ_05')
    local x, y, z = GetPos(self)
    if GetZoneName(self) == 'd_velniasprison_51_5' then
        if GetLayer(self) == 0 then 
            if result1 == "PROGRESS" then
                if SCR_POINT_DISTANCE(x, z, -776, 634) < 450 then
                    local list, cnt = SelectObject(self, 100, 'ENEMY')
                    local i
                    for i = 1 , cnt do
                        if list[i].ClassName == 'Hohen_gulak' or list[i].ClassName == 'Mushroom_boy_green' or list[i].ClassName == 'Hohen_mage' then
                            return GetHandle(list[i])
                        end
                    end
                end
                return 0
            elseif result2 == 'PROGRESS' then
                if SCR_POINT_DISTANCE(x, z, 724, 609) < 500 then
                    local list, cnt = SelectObject(self, 100, 'ENEMY')
                    local i
                    for i = 1 , cnt do
                        if list[i].ClassName == 'Hohen_gulak' or list[i].ClassName == 'Mushroom_boy_green' or list[i].ClassName == 'Hohen_mage' then
                            return GetHandle(list[i])
                        end
                    end
                else
                    return 0
                end
                
            elseif result3 == 'PROGRESS' then
                if SCR_POINT_DISTANCE(x, z, 326, -707) < 650 then
                    local list, cnt = SelectObject(self, 100, 'ENEMY')
                    local i
                    for i = 1 , cnt do
                        if list[i].ClassName == 'Hohen_gulak' or list[i].ClassName == 'Mushroom_boy_green' or list[i].ClassName == 'Hohen_mage' then
                            return GetHandle(list[i])
                        end
                    end
                else
                    return 0
                end
                
            end
        end
    end
    return 0
end




--VPRISON513_MQ_03_ITEM
function SCR_PRE_VPRISON513_MQ_03_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'VPRISON513_MQ_03')
    local x, y, z = GetPos(self)
    if GetZoneName(self) == 'd_velniasprison_51_3' then
        if GetLayer(self) == 0 then 
            if result1 == "PROGRESS" then
                if SCR_POINT_DISTANCE(x, z, -1520, 333) < 700 then
                    local list, cnt = SelectObject(self, 150, 'ENEMY')
                    local i
                    for i = 1 , cnt do
                        if list[i].ClassName ~= 'rootcrystal_05' then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--FARM47_1_SQ_030
function SCR_PRE_FARM47_1_SQ_030_ITEM_1(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_farm_47_1' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'FARM47_1_SQ_030')
            if result1 == 'PROGRESS' then
                return 1
            end
        end
    end
    return 0
end

function SCR_PRE_FARM47_1_SQ_100_ITEM_1(self, argstring, argnum1, argnum2)

    if GetLayer(self) == 0 then

        if GetZoneName(self) == 'f_farm_47_1' then
            local result = SCR_QUEST_CHECK(self, 'FARM47_1_SQ_100')
            if result == 'PROGRESS' then
            
            	local fndList, fndCount = SelectObject(self, 100, 'ALL', 1);
            	local i

            	
            	for i = 1, fndCount do

            	    if fndList[i].Name == "MAGIC_TRIGGER" then   
                	    return GetHandle(fndList[i])
                	end
            	end
            end
        end
    end
    return 0
end

--FARM47_2_SQ_030
function SCR_PRE_FARM47_2_SQ_030_ITEM_2(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0 then
        if GetZoneName(self) == 'f_farm_47_2' then
            local result = SCR_QUEST_CHECK(self, 'FARM47_2_SQ_030')
            if result == "PROGRESS" then

                local item_2 = GetInvItemCount(self, "FARM47_2_SQ_030_ITEM_3")
                if item_2 >= 1 then
                    return 1;
                end
            end
        end
    end
    return 0;
end

--VELNIAS54_1 FREE DUNGEAN USE ITEM
function SCR_PRE_VELNIAS54_1_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_velniasprison_54_1' then
        if GetLayer(self) == 0 then 
            return 1
        end
    end
    return 0
end

--FARM47_3_SQ_050
function SCR_PRE_FARM47_3_SQ_050_ITEM_11(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_farm_47_3' then
        if GetLayer(self) == 0 then 
        
            local quest_ssn = GetSessionObject(self, 'SSN_FARM47_3_SQ_050')
            if quest_ssn ~= nil then
                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
    
    
                    local result1 = SCR_QUEST_CHECK(self, 'FARM47_3_SQ_050')
                    if result1 == 'PROGRESS' then
                        return 1
                    end
                end
            end
        end
    end
    return 0
end

--PILGRIM50_SQ_028
function SCR_PRE_PILGRIM50_ITEM_11(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'PILGRIM50_SQ_028')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_pilgrimroad_50' then
            if GetLayer(self) == 0 then 
                local fndList, fndCnt = SelectObject(self, 100, 'ENEMY')
                local i 
                for i = 1, fndCnt do
                    if fndList[i].Faction == 'Monster' then
          	            if fndList[i].StrArg1 == 'None' then
            	            --print(fndList[i].Name)
                		    return GetHandle(fndList[i])
                		end
                    end
                end
            end
        end
    end
    return 0
end



--CATACOMB_38_2_SQ_02_ITEM
function SCR_PRE_CATACOMB_38_2_SQ_02_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_38_2_SQ_02')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_38_2' then
            if GetLayer(self) == 0 then
                local fndList, fndCnt = SelectObject(self, 150, 'ENEMY')
                if fndCnt >= 1 then
                    for i = 1, fndCnt do
                        if fndList[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(fndList[i], 'Normal', 'Special', 'Material') == 'YES' then
                    		    return GetHandle(fndList[i])
                    		end
                        end
                    end
                end
            end
        end
    end
    return 0;
end



--CATACOMB_38_2_SQ_03_ITEM
function SCR_PRE_CATACOMB_38_2_SQ_03_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_38_2_SQ_05')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_38_2' then
            if GetLayer(self) == 0 then
                local quest_ssn = GetSessionObject(self,'SSN_CATACOMB_38_2_SQ_05')
                if quest_ssn ~= nil then
                    if quest_ssn.Step1 == 0 then
                return 1;
            end
        end
    end
        end
    end
    
    local result2 = SCR_QUEST_CHECK(self, 'CATACOMB_04_SQ_05')
    if result2 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_04' then
            if GetLayer(self) == 0 then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, -400, 950) < 550 then
                    return 1;
                end
            end
        end
    end    
    return 0;
end



--CATACOMB_38_2_SQ_06_ITEM
function SCR_PRE_CATACOMB_38_2_SQ_06_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_38_2_SQ_06')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_38_2' then
            if GetLayer(self) ~= 0 then
                return 1;
            end
        end
    end
    return 0;
end



--CATACOMB_04_SQ_03_ITEM
function SCR_PRE_CATACOMB_04_SQ_03_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_04_SQ_03')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_04' then
            if GetLayer(self) == 0 then
                local fndList, fndCnt = SelectObject(self, 100, 'ENEMY')
                if fndCnt >= 1 then
                    for i = 1, fndCnt do
                        if fndList[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(fndList[i], 'Normal', 'Special', 'Material') == 'YES' then
                		        return GetHandle(fndList[i])
                		    end
                        end
                    end
                end
            end
        end
    end
    return 0;
end



--CATACOMB_04_SQ_MEMO_ITEM
function SCR_PRE_CATACOMB_04_SQ_MEMO_ITEM(self, argstring, argnum1, argnum2)
--    local PC_zone = GetZoneName(self)
--    if PC_zone == 'id_catacomb_38_2' or PC_zone == 'id_catacomb_04' then
        return 1;
--    else
--        SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('CATACOMB_04_SQ_MEMO_ITEM_MSG1'), 5)
--    end
--    return 0;
end



--CATACOMB_38_1_SQ_03_ITEM
function SCR_PRE_CATACOMB_38_1_SQ_03_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_38_1_SQ_03')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'id_catacomb_38_1' then
    	        local list, cnt = SelectObject(self, 200, 'ALL')
    	        if cnt >= 1 then
        	        for i = 1, cnt do
        	            if IsServerSection(self) == 1 then
            	            if list[i].ClassName ~= 'PC' then
                	            if list[i].Dialog == 'CATACOMB_38_1_OBJ_01' then
                	                return GetHandle(list[i])
                	            end
                	        end
        	            else
            	            if list[i].ClassName ~= 'PC' then
                	            if GetDialogByObject(list[i]) == 'CATACOMB_38_1_OBJ_01' then
                	                return GetHandle(list[i])
                	            end
                	        end
            	        end
        	        end
        	    end
            end
        end
    end
    return 0
end



--CATACOMB_02_SQ_03_ITEM
function SCR_PRE_CATACOMB_02_SQ_03_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_02_SQ_04')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'id_catacomb_02' then
    	        local list, cnt = SelectObject(self, 100, 'ALL')
    	        if cnt >= 1 then
        	        for i = 1, cnt do
        	            if IsServerSection(self) == 1 then
            	            if list[i].ClassName ~= 'PC' then
                	            if list[i].Dialog == 'CATACOMB_02_OBJ_04' or list[i].Dialog == 'CATACOMB_02_OBJ_05_1' or list[i].Dialog == 'CATACOMB_02_OBJ_05_2' or list[i].Dialog == 'CATACOMB_02_OBJ_05_3' then
                	                return 1;
                	            end
                	        end
        	            else
            	            if list[i].ClassName ~= 'PC' then
                	            if GetDialogByObject(list[i]) == 'CATACOMB_02_OBJ_04' or GetDialogByObject(list[i]) == 'CATACOMB_02_OBJ_05_1' or GetDialogByObject(list[i]) == 'CATACOMB_02_OBJ_05_2' or GetDialogByObject(list[i]) == 'CATACOMB_02_OBJ_05_3' then
                	                return 1;
                	            end
                	        end
            	        end
        	        end
        	    end
            end
        end
    end
    
    local result2 = SCR_QUEST_CHECK(self, 'CATACOMB_02_SQ_05')
    if result2 == 'PROGRESS' then
        if GetLayer(self) ~= 0  then
    	    if GetZoneName(self) == 'id_catacomb_02' then
                return 1;
            end
        end
    end
    
    return 0
end



--CATACOMB_02_SQ_06_ITEM
function SCR_PRE_CATACOMB_02_SQ_06_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_02_SQ_07')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_02' then
            if GetLayer(self) ~= 0 then
                local fndList, fndCnt = SelectObject(self, 100, 'ENEMY')
                if fndCnt >= 1 then
                    for i = 1, fndCnt do
                        if fndList[i].ClassName == 'boss_archon_Q4' then
                            if IsServerSection(self) == 1 then
                                local buff = GetBuffByName(fndList[i], 'CATACOMB_02_SQ_07_BUFF')
                                if buff == nil then
                                    return GetHandle(fndList[i])
                                else
                                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CATACOMB_02_SQ_06_ITEM_MSG2"), 5);
                                end
                            else
                    		    return GetHandle(fndList[i])
                    		end
                        end
                    end
                end
            end
        end
    end
    return 0;
end

--JOB_CHRONO_6_1_ITEM
function SCR_PRE_JOB_CHRONO_6_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_CHRONO_6_1')
    local result2 = SCR_QUEST_CHECK(self, 'JOB_ALCHEMIST_6_2')
    if result1 == 'PROGRESS' or result2 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            local map_search = {};
            local all_map = 0;
            map_search[1] = GetMapFogSearchRate(self, 'd_cmine_01');
            map_search[2] = GetMapFogSearchRate(self, 'd_cmine_02');
            map_search[3] = GetMapFogSearchRate(self, 'd_cmine_6');
            map_search[4] = GetMapFogSearchRate(self, 'd_cmine_8');
            map_search[5] = GetMapFogSearchRate(self, 'd_cmine_9');
            
            for i = 1, 5 do
                if map_search[i] == nil then
                    map_search[i] = 0;
                else
                    map_search[i] = math.floor(map_search[i]);
                end
                
                all_map = all_map + map_search[i];
            end
            
            if all_map == 500 then
                return 1;
            end
        end
    end
    return 0;
end



--JOB_ROGUE_6_1_ITEM
function SCR_PRE_JOB_ROGUE_6_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_ROGUE_6_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_orchard_34_1' then
            if GetLayer(self) == 0 then
    	        local list, cnt = SelectObject(self, 30, 'ENEMY')
    	        if cnt >= 1 then
        	        for i = 1, cnt do
        	            if list[i].Faction == 'Monster' then
        	                if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                                if IsServerSection(self) == 1 then
                                    local buff = GetBuffByName(list[i], 'JOB_ROGUE_6_1_BUFF')
                                    if buff == nil then
                                        return GetHandle(list[i])
                                    end
                                else
                	                return GetHandle(list[i]);
                	            end
                	        end
                	    end
        	        end
        	        
        	        if IsServerSection(self) == 1 then
        	            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_ROGUE_6_1_ITEM_MSG4"), 5);
        	        end
        	    end
            end
        end
    end
    return 0;
end

--JOB_FALCONER_6_1_ITEM
function SCR_PRE_JOB_FALCONER_6_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_FALCONER_6_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
	        local list, cnt = SelectObject(self, 100, 'ENEMY')
	        if cnt >= 1 then
    	        for i = 1, cnt do
                    if list[i].Faction == 'Monster' then
                        if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
    	                    if IsServerSection(self) == 1 then
    	                        if list[i].MoveType == 'Flying' then
            	                    return GetHandle(list[i]);
            	                end
    	                    else
    	                        if TryGetProp(list[i], "MoveType") == 'Flying' then
    	                            return GetHandle(list[i]);
    	                        end
            	            end
            	        end
        	        end
    	        end
    	    end
        end
    end
    return 0;
end



--JOB_ORACLE_6_1_ITEM
function SCR_PRE_JOB_ORACLE_6_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_ORACLE_6_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_rokas_36_1' then
            if GetLayer(self) == 0 then
    	        local list, cnt = SelectObject(self, 40, 'ALL')
    	        if cnt >= 1 then
        	        for i = 1, cnt do
        	            if IsServerSection(self) == 1 then
            	            if list[i].ClassName ~= 'PC' then
                	            if list[i].Dialog == 'JOB_ORACLE_6_1_TRIGGER1' or list[i].Dialog == 'JOB_ORACLE_6_1_TRIGGER2' or list[i].Dialog == 'JOB_ORACLE_6_1_TRIGGER3' then
                	                return GetHandle(list[i]);
                	            end
                	        end
        	            else
            	            if list[i].ClassName ~= 'PC' then
                	            if GetDialogByObject(list[i]) == 'JOB_ORACLE_6_1_TRIGGER1' or GetDialogByObject(list[i]) == 'JOB_ORACLE_6_1_TRIGGER2' or GetDialogByObject(list[i]) == 'JOB_ORACLE_6_1_TRIGGER3' then
                	                return GetHandle(list[i]);
                	            end
                	        end
            	        end
        	        end
        	    end
            end
        end
    end
    return 0;
end



--KATYN_10_MQ_04_ITEM
function SCR_PRE_KATYN_10_MQ_04_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'KATYN_10_MQ_04')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_10' then
            if GetLayer(self) == 0 then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, 4364, -637) < 750 then
                    return 1;
                end
            end
        end
    end
    
    local result2 = SCR_QUEST_CHECK(self, 'KATYN_10_MQ_05')
    if result2 == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_10' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 150, 'ENEMY')
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                                return GetHandle(list[i]);
                	        end
            	        end
                    end
                end
            end
        end
    end
    return 0;
end

--KATYN_10_MQ_11_ITEM
function SCR_PRE_KATYN_10_MQ_11_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'KATYN_12_MQ_02')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_12' then
            if GetLayer(self) == 0 then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, -2890, 1520) < 250 then
                    return 1;
                end
            end
        end
    end
    return 0;
end

--KATYN_12_MQ_02_ITEM
function SCR_PRE_KATYN_12_MQ_02_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'KATYN_12_MQ_03')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_12' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 100, 'ENEMY')
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                                return GetHandle(list[i]);
                	        end
            	        end
                    end
                end
            end
        end
    end
    return 0;
end

--KATYN_12_MQ_03_ITEM
function SCR_PRE_KATYN_12_MQ_03_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'KATYN_12_MQ_05')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_12' then
            if GetLayer(self) == 0 then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, -600, 490) < 500 then
                    return 1;
                end
            end
        end
    end
    
    local result2 = SCR_QUEST_CHECK(self, 'KATYN_12_MQ_07')
    if result2 == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_12' then
            if GetLayer(self) == 0 then
    	        local list, cnt = SelectObject(self, 60, 'ALL')
    	        if cnt >= 1 then
        	        for i = 1, cnt do
        	            if IsServerSection(self) == 1 then
            	            if list[i].ClassName ~= 'PC' then
                	            if list[i].Dialog == 'KATYN_12_OBJ_03_1' or list[i].Dialog == 'KATYN_12_OBJ_03_2' or list[i].Dialog == 'KATYN_12_OBJ_03_3' then
                	                return GetHandle(list[i]);
                	            end
                	        end
        	            else
            	            if list[i].ClassName ~= 'PC' then
                	            if GetDialogByObject(list[i]) == 'KATYN_12_OBJ_03_1' or GetDialogByObject(list[i]) == 'KATYN_12_OBJ_03_2' or GetDialogByObject(list[i]) == 'KATYN_12_OBJ_03_3' then
                	                return GetHandle(list[i]);
                	            end
                	        end
            	        end
        	        end
        	    end
            end
        end
    end
    
    return 0;
end



--KATYN_12_SQ_01_ITEM
function SCR_PRE_KATYN_12_SQ_01_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'KATYN_12_SQ_01')
    if result1 == 'PROGRESS' then
        return 1;
    end

    return 0;
end



--JOB_2_PYROMANCER_3_1_ITEM
function SCR_PRE_JOB_2_PYROMANCER_3_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_PYROMANCER_3_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            local list, cnt = SelectObject(self, 100, 'ENEMY')
            if cnt >= 1 then
                for i = 1, cnt do
                    if list[i].Faction == 'Monster' then
                        return GetHandle(list[i]);
        	        end
        	    end
            end
        end
    end
    return 0;
end



--JOB_2_CRYOMANCER_3_1_ITEM
function SCR_PRE_JOB_2_CRYOMANCER_3_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_CRYOMANCER_3_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            local list, cnt = SelectObject(self, 100, 'ENEMY')
            if cnt >= 1 then
                for i = 1, cnt do
                    if list[i].Faction == 'Monster' then
                        if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                            return GetHandle(list[i]);
            	        end
        	        end
    	        end
            end
        end
    end
    return 0;
end



--JOB_2_PSYCHOKINO_3_1_ITEM
function SCR_PRE_JOB_2_PSYCHOKINO_3_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_PSYCHOKINO_3_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            local list, cnt = SelectObject(self, 80, 'ENEMY')
            if cnt >= 1 then
                for i = 1, cnt do
                    if list[i].Faction == 'Monster' then
                        if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                            if list[i].MoveType ~= 'Holding' then
                                if IsServerSection(self) == 1 then
                                    local buff = GetBuffByName(list[i], 'JOB_2_PSYCHOKINO_3_1_BUFF')
                                    if buff == nil then
                                        return GetHandle(list[i])
                                    end
                                else
                                    return GetHandle(list[i]);
                                end
                            end
            	        end
        	        end
        	    end
        	    
        	    if IsServerSection(self) == 1 then
                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_2_PSYCHOKINO_3_1_ITEM_MSG02"), 5);
                end
            end
        end
    end
    return 0;
end



--JOB_2_PSYCHOKINO_4_1_ITEM
function SCR_PRE_JOB_2_PSYCHOKINO_4_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_PSYCHOKINO_4_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            local list, cnt = SelectObject(self, 100, 'ENEMY')
            if cnt >= 1 then
                for i = 1, cnt do
                    if list[i].Faction == 'Monster' then
                        return GetHandle(list[i]);
        	        end
                end
            end
        end
    end
    return 0;
end



--JOB_2_WUGUSHI_5_1_ITEM
function SCR_PRE_JOB_2_WUGUSHI_5_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_WUGUSHI_5_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            local list, cnt = SelectObject(self, 100, 'ENEMY')
            if cnt >= 1 then
                for i = 1, cnt do
                    if list[i].Faction == 'Monster' then
                        if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                            if list[i].Attribute == 'Poison' then
                                return GetHandle(list[i]);
                            end
            	        end
        	        end
                end
            end
        end
    end
    return 0;
end



--JOB_2_SCOUT_5_1_ITEM
function SCR_PRE_JOB_2_SCOUT_5_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_SCOUT_5_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            local pc_zone = GetZoneName(self);
            local zone = {'d_firetower_41', 'd_firetower_42', 'd_firetower_43', 'd_firetower_44', 'd_firetower_45'}
            local x, y, z = GetPos(self)
            
            for i = 1, #zone do
                if pc_zone == zone[i] then
                    if i == 1 then
                        if SCR_POINT_DISTANCE(x, z, 559, -1057) < 50 then
                            return 1;
                        end
                    elseif i == 2 then
                        if SCR_POINT_DISTANCE(x, z, 241, 193) < 50 then
                            return 1;
                        end
                    elseif i == 3 then
                        if SCR_POINT_DISTANCE(x, z, -298, -1509) < 50 then
                            return 1;
                        end
                    elseif i == 4 then
                        if SCR_POINT_DISTANCE(x, z, -385, -1408) < 50 then
                            return 1;
                        end
                    elseif i == 5 then
                        if SCR_POINT_DISTANCE(x, z, 1074, 1264) < 50 then
                            return 1;
                        end
                    end
                end
            end
        end
    end
    return 0;
end



--JOB_2_WUGUSHI_4_1_ITEM
function SCR_PRE_JOB_2_WUGUSHI_4_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_WUGUSHI_4_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_33_2' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 80, 'ENEMY')
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                                if IsServerSection(self) == 1 then
                                    local buff = GetBuffByName(list[i], 'JOB_2_WUGUSHI_4_1_BUFF')
                                    if buff == nil then
                                        return GetHandle(list[i])
                                    end
                                else
                                    return GetHandle(list[i]);
                                end
                            end
            	        end
        	        end
        	    end
        	    
        	    if IsServerSection(self) == 1 then
                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_2_WUGUSHI_4_1_ITEM_MSG02"), 5);
                end
            end
        end
    end
    return 0;
end



--JOB_WARLOCK_7_1_ITEM
function SCR_PRE_JOB_WARLOCK_7_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_WARLOCK_7_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_02' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 80, 'ENEMY')
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                                return 1;
                            end
            	        end
        	        end
        	    end
            end
        end
    end
    return 0;
end



--JOB_FEATHERFOOT_7_1_ITEM
function SCR_PRE_JOB_FEATHERFOOT_7_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_FEATHERFOOT_7_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            local list, cnt = SelectObject(self, 100, 'ENEMY')
            if cnt >= 1 then
                for i = 1, cnt do
                    if list[i].Faction == 'Monster' then
                        if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                            if IsServerSection(self) == 1 then
                                local buff = GetBuffByName(list[i], 'JOB_FEATHERFOOT_7_1_BUFF')
                                if buff == nil then
                                    return GetHandle(list[i])
                                end
                            else
                                return GetHandle(list[i]);
                            end
                        end
        	        end
        	    end
        	    
        	    if IsServerSection(self) == 1 then
                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_FEATHERFOOT_7_1_ITEM_MSG2"), 5);
                end
    	    end
        end
    end
    return 0;
end



--JOB_KABBALIST_7_1_ITEM
function SCR_PRE_JOB_KABBALIST_7_1_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_KABBALIST_7_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_siauliai_35_1' then
            if GetLayer(self) == 0 then
                return 1;
            end
        end
    end
    return 0;
end



--JOB_SHINOBI_HIDDEN_ITEM_4
function SCR_PRE_JOB_SHINOBI_HIDDEN_ITEM_4(self, argstring, argnum1, argnum2)
    return 1;
end



--JOB_SHINOBI_HIDDEN_ITEM_5
function SCR_PRE_JOB_SHINOBI_HIDDEN_ITEM_5(self, argstring, argnum1, argnum2)
    return 1;
end



--ORCHARD_34_1_SQ_2_ITEM
function SCR_PRE_ORCHARD_34_1_SQ_2_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_34_1_SQ_2')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'f_orchard_34_1' then
                local sObj = GetSessionObject(self, 'SSN_ORCHARD_34_1_SQ_2')
                if sObj ~= nil then
                    if sObj.QuestInfoValue1 == 1 then
                        if IsServerSection(self) == 1 then
                            return 1;
                        else
                            return 0
                        end
                    else
            	        local list, cnt = SelectObject(self, 50, 'ALL')
            	        if cnt >= 1 then
                	        for i = 1, cnt do
                	            if IsServerSection(self) == 1 then
                    	            if list[i].ClassName ~= 'PC' then
                        	            if list[i].Dialog == 'ORCHARD_34_1_SQ_2_OBJ_1' then
                        	                return 1;
                        	            end
                        	        end
                	            else
                    	            if list[i].ClassName ~= 'PC' then
                        	            if GetDialogByObject(list[i]) == 'ORCHARD_34_1_SQ_2_OBJ_1' then
                        	                return 1;
                        	            end
                        	        end
                    	        end
                	        end
                	    end
            	        if IsServerSection(self) == 1 then
            	            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ORCHARD_34_1_SQ_2_ITEM_MSG_no1"), 5);
            	        end
                	end
                end
            end
        end
    end
    return 0
end



--ORCHARD_34_1_SQ_4_ITEM_1
function SCR_PRE_ORCHARD_34_1_SQ_4_ITEM_1(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_34_1_SQ_4')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'f_orchard_34_1' then
    	        local list, cnt = SelectObject(self, 60, 'ENEMY')
    	        if cnt >= 1 then
        	        for i = 1, cnt do
        	            if list[i].ClassName == 'eldigo_green' then
            	            if IsServerSection(self) == 1 then
                                local buff1 = GetBuffByName(list[i], 'ORCHARD_34_1_SQ_4_BUFF')
                                if buff1 == nil then
                	                return GetHandle(list[i])
                	            end
            	            else
            	                return GetHandle(list[i])
                	        end
            	        end
        	        end
        	    end
        	    
                if IsServerSection(self) == 1 then
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ORCHARD_34_1_SQ_4_ITEM_1_MSG2"), 5);
        	    end
            end
        end
    end
    return 0
end



--ORCHARD_34_1_SQ_5_ITEM_1
function SCR_PRE_ORCHARD_34_1_SQ_5_ITEM_1(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_orchard_34_1' then
            return 1;
        end
    end
    return 0
end



--ORCHARD_34_1_SQ_5_ITEM_2
function SCR_PRE_ORCHARD_34_1_SQ_5_ITEM_2(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_orchard_34_1' then
            return 1;
        end
    end
    return 0
end



--ORCHARD_34_1_SQ_5_ITEM_3
function SCR_PRE_ORCHARD_34_1_SQ_5_ITEM_3(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_orchard_34_1' then
            return 1;
        end
    end
    return 0
end



--HIDDEN_RUNECASTER_ITEM_1
function SCR_PRE_HIDDEN_RUNECASTER_ITEM_1(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
        return 1;
    end
    return 0
end



--HIDDEN_RUNECASTER_ITEM_2
function SCR_PRE_HIDDEN_RUNECASTER_ITEM_2(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
        return 1;
    end
    return 0
end



--HIDDEN_RUNECASTER_ITEM_3
function SCR_PRE_HIDDEN_RUNECASTER_ITEM_3(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
        return 1;
    end
    return 0
end



--HIDDEN_RUNECASTER_ITEM_4
function SCR_PRE_HIDDEN_RUNECASTER_ITEM_4(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
        return 1;
    end
    return 0
end



--HIDDEN_RUNECASTER_ITEM_5
function SCR_PRE_HIDDEN_RUNECASTER_ITEM_5(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
        return 1;
    end
    return 0
end



--PRISON_78_MQ_3_ITEM
function SCR_PRE_PRISON_78_MQ_3_ITEM(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
        local _zone = GetZoneName(self)
        local i
        
        for i = 78, 82 do
            if _zone == 'd_prison_'..i then
                return 1;
            end
        end
    end
    return 0;
end



--PRISON_78_MQ_5_ITEM
function SCR_PRE_PRISON_78_MQ_5_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'PRISON_78_MQ_7')
    if result1 == 'PROGRESS' then
        if GetLayer(self) ~= 0  then
    	    if GetZoneName(self) == 'd_prison_78' then
    	        local list, cnt = SelectObject(self, 100, 'ENEMY')
    	        if cnt >= 1 then
        	        for i = 1, cnt do
        	            if list[i].ClassName == 'boss_Mandara_Q1' then
        	                local buff1 = IsBuffApplied(list[i], 'PRISON_78_MQ_7_BUFF')
                            if buff1 == 'YES' then
            	                return GetHandle(list[i])
            	            else
                	            if IsServerSection(self) == 1 then
                	                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PRISON_78_MQ_5_ITEM_MSG3"), 5);
                	            end
            	            end
            	        end
        	        end
        	    end
            end
        end
    end
    return 0;
end



--PRISON_80_MQ_4_ITEM
function SCR_PRE_PRISON_80_MQ_4_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'PRISON_80_MQ_5')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'd_prison_80' then
                return 1;
            end
        end
    end
    return 0;
end



--PRISON_82_MQ_7_ITEM
function SCR_PRE_PRISON_82_MQ_7_ITEM(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'd_prison_82' then
            local result1 = SCR_QUEST_CHECK(self, 'PRISON_82_MQ_8')
            local result2 = SCR_QUEST_CHECK(self, 'PRISON_82_MQ_9')
            if result1 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 100, 'ENEMY')
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                                if IsServerSection(self) == 1 then
                                    local buff = GetBuffByName(list[i], 'PRISON_82_MQ_8_BUFF')
                                    if buff == nil then
                                        return GetHandle(list[i])
                                    end
                                else
                                    return GetHandle(list[i]);
                                end
                	        end
            	        end
            	    end
            	    
            	    if IsServerSection(self) == 1 then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PRISON_82_MQ_7_ITEM_MSG1"), 5);
                    end
                end
            elseif result2 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 100, 'ALL')
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'mine_crystal_red2_small' then
                                if IsServerSection(self) == 1 then
                                    local buff = GetBuffByName(list[i], 'PRISON_82_MQ_8_BUFF')
                                    if buff == nil then
                                        return GetHandle(list[i])
                                    end
                                else
                                    return GetHandle(list[i]);
                                end
                	        end
            	        end
            	    end
            	    
            	    if IsServerSection(self) == 1 then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PRISON_82_MQ_7_ITEM_MSG1"), 5);
                    end
                end
            end
        end
    end
    return 0;
end



--CASTLE_20_3_SQ_5_ITEM_1
function SCR_PRE_CASTLE_20_3_SQ_5_ITEM_1(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_3' then
            local result1 = SCR_QUEST_CHECK(self,'CASTLE_20_3_SQ_5')
            if result1 == 'PROGRESS' then
                local _item1 = GetInvItemCount(self, 'CASTLE_20_3_SQ_5_ITEM_1')
                local _item2 = GetInvItemCount(self, 'CASTLE_20_3_SQ_5_ITEM_2')
                if _item1 >= 1 and _item2 >= 1 then
                    return 1;
                end
            end
        end
    end
    return 0;
end



--CASTLE_20_3_SQ_6_ITEM
function SCR_PRE_CASTLE_20_3_SQ_6_ITEM(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_3' then
            local result1 = SCR_QUEST_CHECK(self, 'CASTLE_20_3_SQ_7')
            if result1 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 50, 'ALL', 1)
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if IsServerSection(self) == 1 then
                                if list[i].Dialog == 'CASTLE_20_3_OBJ_7' then
                                    return GetHandle(list[i]);
                                end
                            else
                	            if GetDialogByObject(list[i]) == 'CASTLE_20_3_OBJ_7' then
                	                return 1;
                	            end
                            end
            	        end
            	    end
                end
            end
        end
    end
    return 0;
end



--CASTLE_20_3_SQ_3_ITEM_1
function SCR_PRE_CASTLE_20_3_SQ_3_ITEM_1(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_3' then
            local result1 = SCR_QUEST_CHECK(self, 'CASTLE_20_3_SQ_10')
            if result1 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 40, 'ALL', 1)
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if IsServerSection(self) == 1 then
                                if list[i].Dialog == 'CASTLE_20_3_OBJ_20_1' or list[i].Dialog == 'CASTLE_20_3_OBJ_20_2' then
                                    return GetHandle(list[i]);
                                end
                            else
                	            if GetDialogByObject(list[i]) == 'CASTLE_20_3_OBJ_20_1' or GetDialogByObject(list[i]) == 'CASTLE_20_3_OBJ_20_2' then
                	                return 1;
                	            end
                            end
            	        end
            	    end
                end
            elseif result1 == 'SUCCESS' or result1 == 'COMPLETE' then
                return 1;
            end
        end
    end
    return 0;
end



--CASTLE_20_3_SQ_1_ITEM
function SCR_PRE_CASTLE_20_3_SQ_1_ITEM(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_3' or GetZoneName(self) == 'f_castle_20_2' then
            return 1;
        end
    end
    return 0;
end



--CASTLE_20_2_SQ_4_ITEM
function SCR_PRE_CASTLE_20_2_SQ_4_ITEM(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_2' then
            local result1 = SCR_QUEST_CHECK(self, 'CASTLE_20_2_SQ_10')
            if result1 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 60, 'ALL', 1)
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if IsServerSection(self) == 1 then
                                if list[i].Dialog == 'CASTLE_20_2_OBJ_8' then
                                    return GetHandle(list[i]);
                                end
                            else
                	            if GetDialogByObject(list[i]) == 'CASTLE_20_2_OBJ_8' then
                	                return 1;
                	            end
                            end
            	        end
            	    end
                end
            end
        end
    end
    return 0;
end



--CASTLE_20_2_SQ_12_ITEM
function SCR_PRE_CASTLE_20_2_SQ_12_ITEM(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_2' then
            local result1 = SCR_QUEST_CHECK(self,'CASTLE_20_2_SQ_12')
            if result1 == 'PROGRESS' or result1 == 'SUCCESS' then
                return 1;
            end
        end
    end
    return 0;
end



--CASTLE_20_2_SQ_10_ITEM_1
function SCR_PRE_CASTLE_20_2_SQ_10_ITEM_1(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_2' then
            return 1;
        end
    end
    return 0;
end



--CASTLE_20_4_SQ_3_ITEM
function SCR_PRE_CASTLE_20_4_SQ_3_ITEM(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_4' then
            local result1 = SCR_QUEST_CHECK(self, 'CASTLE_20_4_SQ_4')
            if result1 == 'PROGRESS' then
                local _range = 50;
                if IsServerSection(self) == 1 then
                    _range = _range + 10;
                end
                
                local list, cnt = SelectObject(self, _range, 'ALL', 1)
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if IsServerSection(self) == 1 then
                                if list[i].Dialog == 'CASTLE_20_4_OBJ_3' then
                                    return GetHandle(list[i]);
                                end
                            else
                	            if GetDialogByObject(list[i]) == 'CASTLE_20_4_OBJ_3' then
                	                return 1;
                	            end
                            end
            	        end
            	    end
                end
            end
        end
    end
    return 0;
end



--CASTLE_20_4_SQ_2_ITEM_2
function SCR_PRE_CASTLE_20_4_SQ_2_ITEM_2(self, argstring, argnum1, argnum2)
    if GetLayer(self) ~= 0  then
	    if GetZoneName(self) == 'f_castle_20_4' then
            local result1 = SCR_QUEST_CHECK(self, 'CASTLE_20_4_SQ_7')
            if result1 == 'PROGRESS' then
                return 1;
            end
        end
    end
    return 0;
end



--JOB_MIKO_6_1_ITEM
function SCR_PRE_JOB_MIKO_6_1_ITEM(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'd_cmine_66_1'
	                            or 'd_underfortress_59_1'
	                            or 'd_castle_67_1'
	                            or 'd_underfortress_68_1'
	                            or 'd_startower_60_1'
	                            or 'd_velniasprison_54_1'
	                            or 'd_firetower_61_1' then
            local result1 = SCR_QUEST_CHECK(self, 'JOB_MIKO_6_1')
            if result1 == 'PROGRESS' then
                local npc_list = { 'JOB_MIKO_6_1_CMINE_66_1',
                                    'JOB_MIKO_6_1_UNDER_59_1',
                                    'JOB_MIKO_6_1_CASTLE_67_1',
                                    'JOB_MIKO_6_1_UNDER_68_1',
                                    'JOB_MIKO_6_1_STOWER_60_1',
                                    'JOB_MIKO_6_1_VPRISON_54_1',
                                    'JOB_MIKO_6_1_FTOWER_61_1'
                                    }
--                local list, cnt = GetWorldObjectList(self, "MON", 100);
                local list, cnt = SelectObject(self, 50, "ALL", 1);
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        for j = 1, #npc_list do
                            if IsServerSection(self) == 1 then
                                if list[i].Dialog == npc_list[j] then
                                    return GetHandle(list[i]);
                                end
                            else
                                if GetDialogByObject(list[i]) == npc_list[j] then
                                    return 1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0;
end



--WTREES_21_2_SQ_1_ITEM
function SCR_PRE_WTREES_21_2_SQ_1_ITEM(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_whitetrees_21_2' then
            local result1 = SCR_QUEST_CHECK(self, 'WTREES_21_2_SQ_1')
            if result1 == 'PROGRESS' then
                return 1;
            end
        end
    end
    return 0;
end



--WTREES_21_2_SQ_3_ITEM
function SCR_PRE_WTREES_21_2_SQ_3_ITEM(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_whitetrees_21_2' then
            local result1 = SCR_QUEST_CHECK(self, 'WTREES_21_2_SQ_3')
            if result1 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 50, 'ALL', 1)
                if cnt >= 1 then
                    local _hidelist = { 'WTREES_21_2_OBJ_2_1', 'WTREES_21_2_OBJ_2_2', 'WTREES_21_2_OBJ_2_3' }
                    for i = 1, cnt do
                        for j = 1, 3 do
--                            if IsServerSection(self) == 1 then
--                                if list[i].Dialog == 'WTREES_21_2_OBJ_2_1_DUMMY'
--                                or list[i].Dialog == 'WTREES_21_2_OBJ_2_2_DUMMY'
--                                or list[i].Dialog == 'WTREES_21_2_OBJ_2_3_DUMMY' then
--                                    return GetHandle(list[i]);
--                                end
--                            else
--                                if GetDialogByObject(list[i]) == 'WTREES_21_2_OBJ_2_1_DUMMY'
--                                or GetDialogByObject(list[i]) == 'WTREES_21_2_OBJ_2_2_DUMMY'
--                                or GetDialogByObject(list[i]) == 'WTREES_21_2_OBJ_2_3_DUMMY' then
--                                    return 1;
--                                end
--                            end
                            
                            if IsServerSection(self) == 1 then
                                if list[i].Dialog == _hidelist[j]..'_DUMMY' then
                                    if isHideNPC(self, _hidelist[j]) == 'YES' then
                                        return GetHandle(list[i]);
                                    end
                                end
                            else
                                if GetDialogByObject(list[i]) == _hidelist[j]..'_DUMMY' then
                                    if isHideNPC(self, _hidelist[j]) == 'YES' then
                                        return 1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0;
end



--WTREES_21_2_SQ_6_ITEM_1
function SCR_PRE_WTREES_21_2_SQ_6_ITEM_1(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_whitetrees_21_2' then
            local result1 = SCR_QUEST_CHECK(self, 'WTREES_21_2_SQ_7')
            if result1 == 'PROGRESS' then
    	        local list, cnt = SelectObject(self, 100, 'ENEMY')
    	        if cnt >= 1 then
        	        for i = 1, cnt do
        	            if list[i].ClassName == 'kucarry_symbani'
        	            or list[i].ClassName == 'kucarry_balzer'
        	            or list[i].ClassName == 'kucarry_Zeffi' then
            	            if IsServerSection(self) == 1 then
                                local buff1 = GetBuffByName(list[i], 'WTREES_21_2_SQ_7_BUFF')
                                if buff1 == nil then
                	                return GetHandle(list[i]);
                	            end
            	            else
            	                return 1;
                	        end
            	        end
        	        end
        	    end
        	    
                if IsServerSection(self) == 1 then
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WTREES_21_2_SQ_6_ITEM_1_MSG2"), 5);
        	    end
            end
        end
    end
    return 0;
end



--WTREES_21_1_SQ_1_ITEM
function SCR_PRE_WTREES_21_1_SQ_1_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_whitetrees_21_1' then
        return 1;
    end
    return 0;
end






















































































































function SCR_PRE_REMAINS37_1_SQ_030_ITEM_1(self, argstring, argnum1, argnum2)
--    print(self.ClassName, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'REMAINS37_1_SQ_030')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_remains_37_1' then
            local item = GetInvItemCount(self, 'REMAINS37_1_SQ_030_ITEM_2')
            if item < 4 then
            	local fndList, fndCount = SelectObject(self, 100, 'ALL', 1);
                local i
            	for i = 1, fndCount do
            	    if fndList[i].ClassName == 'Wendigo_archer' or fndList[i].ClassName == 'Wendigo_magician' or fndList[i].ClassName == 'Templeslave_sword' then
            	        if fndList[i].StrArg1 == 'None' then
            	            --print(fndList[i].Name)
                		    return GetHandle(fndList[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--THORN392_MQ03_ITEM
function SCR_PRE_THORN39_2_MQ03_ITEM_2(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'THORN39_2_MQ03')
    local quest_ssn = GetSessionObject(self, 'SSN_THORN39_2_MQ03')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'd_thorn_39_2' then
            if GetLayer(self) == 0 then
                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                    local list, cnt = SelectObject(self, 10, 'ALL')
                    local i
                    for i = 1, cnt do
                        if list[i].ClassName == "npc_friar_down01" or list[i].ClassName == "npc_friar_down02" then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0;
end

function SCR_PRE_REMAINS37_1_SQ_040_ITEM_1(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_remains_37_1' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'REMAINS37_1_SQ_040')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 100, 'ENEMY')
                local i 
                for i = 1, fndCnt do
                    if fndList[i].ClassName == 'Wendigo_archer' then
                        --if GetHpPercent(fndList[i]) <= 0.5 then
                            return GetHandle(fndList[i])
                        --end
                    end
                end
            end
        end
    end
    return 0
end

function SCR_PRE_REMAINS37_2_SQ_010_ITEM_1(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0 then
        if GetZoneName(self) == 'f_remains_37_2' then
            local result = SCR_QUEST_CHECK(self, 'REMAINS37_2_SQ_010')
            if result == "PROGRESS" then

                local item_2 = GetInvItemCount(self, "REMAINS37_2_SQ_010_ITEM_2")
                if item_2 >= 1 then
                    return 1;
                end
            end
        end
    end
    return 0;
end

--THORN391_MQ03_BOWL
function SCR_PRE_THORN39_1_MQ03_BOWL(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'THORN39_1_MQ05')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'd_thorn_39_1' then
            if GetLayer(self) == 0 then
                local itemCnt = GetInvItemCount(self, 'THORN39_1_MQ05_ITEM')
                if itemCnt <= 4 then
                    local list, cnt = SelectObject(self, 30, 'ALL', 1)
                    local i
                    for i = 1, cnt do
                        if list[i].ClassName == "HiddenTrigger2" then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0;
end

--REMAINS37_2_SQ_040
function SCR_PRE_REMAINS37_2_SQ_040_ITEM_3(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'REMAINS37_2_SQ_040')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_remains_37_2' then
            if GetLayer(self) == 0 then
                return 1
        	end
        end
    end
    return 0
end

--REMAINS37_3_SQ_060
function SCR_PRE_REMAINS37_3_SQ_060_ITEM_1(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'REMAINS37_3_SQ_060')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_remains_37_3' then
            if GetLayer(self) == 0 then 
                local fndList, fndCnt = SelectObject(self, 100, 'ENEMY', 1)
                local i 
                for i = 1, fndCnt do
                    if fndList[i].ClassName == 'Hallowventor_bow' then
          	            if fndList[i].StrArg1 == 'None' then
            	            --print(fndList[i].Name)
                		    return GetHandle(fndList[i])
                		end
                    end
                end
            end
        end
    end
    return 0
end

--REMAINS37_3_SQ_090
function SCR_PRE_REMAINS37_3_SQ_090_ITEM_2(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0 then
        if GetZoneName(self) == 'f_remains_37_3' then
            local result = SCR_QUEST_CHECK(self, 'REMAINS37_3_SQ_090')
            if result == "PROGRESS" then
                local item_2 = GetInvItemCount(self, "REMAINS37_3_SQ_090_ITEM_1")
                if item_2 >= 2 then
                    return 1;
                end
            end
        end
    end
    return 0;
end

--REMAINS37_3_SQ_090
function SCR_PRE_REMAINS37_3_SQ_090_ITEM_3(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0 then
        if GetZoneName(self) == 'f_remains_37_3' then
            --print("11111111111")
            local result = SCR_QUEST_CHECK(self, 'REMAINS37_3_SQ_091')
            if result == 'PROGRESS' then
                --print("22222222222222")
            	local fndList, fndCount = SelectObject(self, 400, 'ALL', 1);
            	local i
            	for i = 1, fndCount do
            	    if fndList[i].Name ==  "REMAINS37_3_HIDDEN" then   
                	    return GetHandle(fndList[i])
                	end
            	end
            end
        end
    end
    return 0
end




--FLASH63_SQ_02_ITEM
function SCR_PRE_FLASH63_SQ_02_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'FLASH63_SQ_02')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_flash_63' then
            if GetLayer(self) == 0 then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, 963, -1351) < 200 then
                    local list, cnt = SelectObject(self, 100, 'ALL')
                    local i
                    for i = 1, cnt do
                        if list[i].ClassName == 'Lemur' or list[i].ClassName == 'goblin2_wand3' or list[i].ClassName == 'goblin2_hammer' then
                            return GetHandle(list[i])
                        end
                    end
                end
        	end
        end
    end
    return 0
end

--PARTY_Q_040_ITEM
function SCR_PRE_PARTY_Q_040_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'PARTY_Q_040')
    local list, cnt = SelectObject(self, 100, 'ALL',1)
    local i
    
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_huevillage_58_1' then
            if GetLayer(self) == 0 then
                for i = 1, cnt do
                    if list[i].ClassName == "HiddenTrigger6" then
                        return 1
                    end
        	    end
            end
        end
    end
    
    return 0
end

--PARTY_Q5_ITEM02
function SCR_PRE_PARTY_Q5_ITEM02(self, argstring, argnum1, argnum2)
    local result01 = SCR_QUEST_CHECK(self, 'PARTY_Q_050')
    
    if result01 == "PROGRESS" then
        if GetZoneName(self) == 'f_huevillage_58_3' or GetZoneName(self) == 'f_huevillage_58_4' then
            if GetLayer(self) == 0 then
                local itemCnt = GetInvItemCount(self, 'PARTY_Q5_ITEM')
                if itemCnt >= 53 then
                    return 1
                end
            end
        end
    end
    
    return 0
end

--PARTY_Q5_ITEM03
function SCR_PRE_PARTY_Q5_ITEM03(self, argstring, argnum1, argnum2)
    local list, cnt = SelectObject(self, 60, 'ALL',1)
    local i
    local result01 = SCR_QUEST_CHECK(self, 'PARTY_Q_051')
    if result01 == "PROGRESS" then
        if GetZoneName(self) == 'f_huevillage_58_3' then
            if GetLayer(self) == 0 then
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName == "HiddenTrigger6" then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    
    return 0
end

--PARTY_Q7_ICEITEM
function SCR_PRE_PARTY_Q7_ICEITEM(self, argstring, argnum1, argnum2)
    local list, cnt = SelectObject(self, 50, 'ALL', 1)
    local i
    local result01 = SCR_QUEST_CHECK(self, 'PARTY_Q_070')
    if result01 == "PROGRESS" then
        if GetZoneName(self) == 'f_katyn_13' then
            if GetLayer(self) == 0 then
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName == "HighBube_Spear" or list[i].ClassName == "HighBube_Archer" or list[i].ClassName == "arburn_pokubu_green" then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    
    return 0
end

--PARTY_Q8_CRYSTAL
function SCR_PRE_PARTY_Q8_CRYSTAL(self, argstring, argnum1, argnum2)
    local result01 = SCR_QUEST_CHECK(self, 'PARTY_Q_080')
    local result02 = SCR_QUEST_CHECK(self, 'PARTY_Q_081')

    if GetZoneName(self) == 'f_remains_40' then
        if GetLayer(self) == 0 then
            if result01 == "PROGRESS" then
                return 1
            elseif result02 == "PROGRESS" then
                local list, cnt = SelectObject(self, 200, 'ALL', 1)
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName == "HiddenTrigger4" then
                            return 1
                        end
                    end
                end
                return 0
            end
        end
    end
    return 0
end

--PARTY_Q10_CRYSTAL
function SCR_PRE_PARTY_Q10_CRYSTAL(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'PARTY_Q_101')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_siauliai_46_2' then
            if GetLayer(self) == 0 then 
                local fndList, fndCnt = SelectObject(self, 250, 'ALL',1)
                local i
                if fndCnt > 0 then
                    for i = 1, fndCnt do
                        if fndList[i].ClassName ~= 'PC' then
                            if fndList[i].Name == 'SIAULIAI_46_2_MQ_03_TRIGGER' then
                                return 1
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--UNDERFORTRESS65_SQ020_BOOM
function SCR_PRE_UNDERFORTRESS65_SQ020_BOOM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_65_SQ020')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'd_underfortress_65' then
            if GetLayer(self) == 0 then 
                local fndList, fndCnt = SelectObject(self, 150, 'ALL', 1)
                local i
                if fndCnt > 0 then
                    for i = 1, fndCnt do
                        if fndList[i].ClassName == 'ExplosionTrap' then
                            return GetHandle(fndList[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--UNDER66_MQ6_ITEM01
function SCR_PRE_UNDER66_MQ6_ITEM01(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_66_MQ050')
    local result2 = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_66_MQ060')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'd_underfortress_66' then
            if GetLayer(self) == 0 then 
                local fndList, fndCnt = SelectObject(self, 30, 'ALL', 1)
                local i
                if fndCnt > 0 then
                    for i = 1, fndCnt do
                        if fndList[i].ClassName == 'HiddenTrigger6' then
                            return GetHandle(fndList[i])
                        end
                    end
                end
            end
        end
    elseif result2 == 'PROGRESS' then
        if GetZoneName(self) == 'd_underfortress_66' then
            if GetLayer(self) > 0 then 
                return 1
            end
        end
    end
    return 0
end

--FLASH_58_SQ_060
function SCR_PRE_FLASH_58_SQ_060_ITEM_1_ITEM_1(self, argstring, argnum1, argnum2)
    if GetLayer(self) == 0 then
        if GetZoneName(self) == 'f_flash_58' then
            local result = SCR_QUEST_CHECK(self, 'FLASH_58_SQ_060')
            if result == 'PROGRESS' then
            	local fndList, fndCount = SelectObject(self, 120, 'ALL', 1);
            	local i            	
            	for i = 1, fndCount do
            	    if fndList[i].Name == "HIddenTrigger" then   
                	    return GetHandle(fndList[i])
                	end
            	end
            end
        end
    end
    return 0
end

--FLASH_58_SQ_070
function SCR_PRE_FLASH_58_SQ_070_ITEM_1(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'FLASH_58_SQ_070')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_flash_58' then
            if GetLayer(self) == 0 then 
                local item = GetInvItemCount(self, 'FLASH_58_SQ_070_ITEM_2')
                if item < 3 then
                    local fndList, fndCnt = SelectObject(self, 100, 'ENEMY')
                    local i 
                    for i = 1, fndCnt do
                        if fndList[i].Faction == 'Monster' then
              	            if fndList[i].StrArg1 == 'None' and 
              	                (fndList[i].ClassName == 'Infroholder_red' or fndList[i].ClassName == 'Infroholder_mage_green' 
              	                    or fndList[i].ClassName == 'Socket_purple') then
                	            --print(fndList[i].Name)
                    		    return GetHandle(fndList[i])
                    		end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--CATACOMB_33_1_SQ_04_FIRE
function SCR_PRE_CATACOMB_33_1_SQ_04_FIRE(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, "CATACOMB_33_1_SQ_04")
    
    if result == "PROGRESS" then
        local list, cnt = SelectObject(self, 40, 'ALL')
        local i
        if cnt > 0 then
            for i = 1, cnt do
            
                if list[i].ClassName ~= 'PC' then
                    if IsBuffApplied(list[i], "CATACOMB_33_1_DEAD") == "YES" then
                        return GetHandle(list[i])
                    end
                end
            end
        end
    end
    return 0
end

--CATACOMB_33_1_SQ_05_DOLL
function SCR_PRE_CATACOMB_33_1_SQ_05_DOLL(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == "id_catacomb_33_1" then
        local result = SCR_QUEST_CHECK(self, 'CATACOMB_33_1_SQ_06')
        if result == 'PROGRESS' then
            local list, cnt = SelectObject(self, 200, 'ALL')
            local i
            if cnt > 0 then
                for i = 1, cnt do
                    if list[i].ClassName ~= 'castle_of_firepuppet' then
                        if list[i].ClassName == 'npc_pilgrim_shrine_NoObb' then
                            return 1
                        end
                    else
                        return 0
                    end
                end
            end
        end
    end
    return 0
end

--CATACOMB_33_2_SQ_02_ORB
function SCR_PRE_CATACOMB_33_2_SQ_02_ORB(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == "id_catacomb_33_2" then
        local result = SCR_QUEST_CHECK(self, 'CATACOMB_33_2_SQ_02')
        if result == 'PROGRESS' then
            return 1
        end
    end
    return 0;
end

--CATACOMB_33_2_SQ_03_BURN
function SCR_PRE_CATACOMB_33_2_SQ_03_BURN(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, "CATACOMB_33_2_SQ_03")
    
    if result == "PROGRESS" then
        local list, cnt = SelectObject(self, 40, 'ALL')
        local i
        if cnt > 0 then
            for i = 1, cnt do
                if list[i].ClassName ~= 'PC' then
                    if IsBuffApplied(list[i], "CATACOMB_33_1_DEAD") == "YES" then
                        return GetHandle(list[i])
                    end
                end
            end
        end
    end
    return 0
end
--    if GetZoneName(self) == 'id_catacomb_33_2' then
--        if GetLayer(self) == 0 then 
--            local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_33_2_SQ_03')
--            if result1 == 'PROGRESS' then
--                local list, cnt = SelectObject(self, 100, 'ENEMY')
--                local i 
--                for i = 1, cnt do
--                    if list[i].ClassName == 'bubbe_mage_priest' then
--                        if GetHpPercent(list[i]) ~= 0 then
--                            if GetHpPercent(list[i]) <= 0.5 then
--                                return GetHandle(list[i])
--                            end
--                        end
--                    end
--                end
--            end
--        end
--    end
--    return 0
--end

--UNDER68_MQ3_ITEM01
function SCR_PRE_UNDER68_MQ3_ITEM01(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == "d_underfortress_68" then
        local result = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_68_MQ030')
        if result == 'PROGRESS' then
            local fndList, fndCnt = SelectObject(self, 100, 'ALL', 1)
            local i
            if fndCnt > 0 then
                for i = 1, fndCnt do
                    if fndList[i].ClassName == 'Deadbornscab_red' then
                        return 1
                    end
                end
            end
        end
    end
    return 0
end

--UNDER68_MQ4_ITEM01
function SCR_PRE_UNDER68_MQ4_ITEM01(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == "d_underfortress_68" then
        local result01 = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_68_MQ040')
        local result02 = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_68_MQ050')
        if result01 == 'PROGRESS' or result02 == 'PROGRESS' then
            local fndList, fndCnt = SelectObject(self, 40, 'ALL', 1)
            local i
            if fndCnt > 0 then
                for i = 1, fndCnt do
                    if fndList[i].ClassName == 'mon_paladin_follower1_3_Q' then
                        --print(fndList[i].ClassName, fndList[i].Faction)
                            return GetHandle(fndList[i])
                    end
                end
            end
        end
    end
    return 0
--    if GetZoneName(self) == "d_underfortress_68" then
--        local result = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_68_MQ040')
--        if result == 'PROGRESS' then
--            return 1
--        end
--    end
--    return 0
end

--CATACOMB_33_2_SQ_SYMBOL
function SCR_PRE_CATACOMB_33_2_SQ_SYMBOL(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'id_catacomb_33_2' then
        if GetLayer(self) > 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_33_2_SQ_06')
            if result1 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 100, 'ALL')
                local i 
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'npc_pilgrim_shrine' then
                                if list[i].HP > 0 then
                                    if IsBuffApplied(list[i], 'Invincible') == 'NO' then
                                        if IsBuffApplied(list[i], 'SoulDuel_DEF') == 'YES' then
                                            return GetHandle(list[i])
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--UNDER69_MQ4_ITEM01
function SCR_PRE_UNDER69_MQ4_ITEM01(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_underfortress_69' then
        if GetLayer(self) < 1 then 
            local result1 = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_69_MQ040')
            if result1 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 80, 'ALL',1)
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName == "npc_Obelisk" then
                            return 1
                        end
                    end
                end
            end
        end
    end
    return 0
end


--PILGRIM311_SQ_02_ITEM
function SCR_PRE_PILGRIM311_SQ_02_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_pilgrimroad_31_1' then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'PILGRIM311_SQ_02')
            if result == 'PROGRESS' then
                return 1
            end
    	end
    else
        return 0
    end
    return 0
end


--PILGRIM311_SQ_04_ITEM
function SCR_PRE_PILGRIM311_SQ_04_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_pilgrimroad_31_1' then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'PILGRIM311_SQ_04')
            if result == 'PROGRESS' then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, -832, 1155) <= 500 then
                    return 1
                end
            end
    	end
    else
        return 0
    end
    return 0
end

--TABLELAND281_SQ04_ITEM
function SCR_PRE_TABLELAND28_1_SQ04_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'TABLELAND28_1_SQ04')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_tableland_28_1' then
            if GetLayer(self) ~= 0 then
                return 1
            end
        end
    end
    return 0;
end

--TABLELAND282_SQ06_ITEM1
function SCR_PRE_TABLELAND28_2_SQ06_ITEM1(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'TABLELAND28_2_SQ06')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_tableland_28_2' then
            if GetLayer(self) == 0 then
                local itemCnt = GetInvItemCount(self, 'TABLELAND28_2_SQ06_ITEM2')
                if itemCnt <= 7 then
                    local list, cnt = SelectObject(self, 20, 'ALL', 1)
                    local i
                    for i = 1, cnt do
                        if list[i].ClassName == "HiddenTrigger2" then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0;
end



--PILGRIM312_SQ_04_ITEM
function SCR_PRE_PILGRIM312_SQ_04_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_pilgrimroad_31_2' then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'PILGRIM312_SQ_04')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 100, 'ALL', 1)
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].Faction == 'Monster' then
                                if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                                    if IsBuffApplied(list[i], 'PILGRIM312_SQ_04_BUFF') == 'NO' then
                                        if list[i].ClassName ~= "rootcrystal_01" then
                                            return GetHandle(list[i])
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
    	end
    else
--        SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('PILGRIM312_SQ_04_ITEM_CANT'), 3)
        return 0
    end
    return 0
end

--CATACOMB_33_2_SQ_DOC
function SCR_PRE_CATACOMB_33_2_SQ_DOC(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'CATACOMB_33_2_SQ_09')
    if result == 'PROGRESS' then
        local list, cnt = SelectObject(self, 10, 'ALL')
        local i
        if cnt > 0 then
            for i = 1, cnt do
                if list[i].ClassName ~= 'PC' then
                    if list[i].ClassName == 'bonfire_1' then
                        return 1
                    elseif list[i].ClassName == 'pub_book' then
                        return 0
                    end
                end
            end
        end
    end
    return 0
end

--UNDER69_SQ3_ITEM
function SCR_PRE_UNDER69_SQ3_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_69_SQ030')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'd_underfortress_69' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 40, 'ALL', 1)
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName == 'HiddenTrigger6' then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--PILGRIM_48_SQ_030_ITEM_1
function SCR_PRE_PILGRIM_48_SQ_030_ITEM_1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM_48_SQ_030')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_siauliai_west' or GetZoneName(self) == 'f_siauliai_2' or GetZoneName(self) == 'f_siauliai_out' 
         or GetZoneName(self) == 'd_cmine_01' or GetZoneName(self) == 'd_cmine_02' or GetZoneName(self) == 'd_cmine_6'
          or GetZoneName(self) == 'f_siauliai_16' or GetZoneName(self) == 'f_siauliai_15_re' or GetZoneName(self) == 'f_siauliai_11_re' 
           or GetZoneName(self) == 'd_prison_62_1' or GetZoneName(self) == 'd_prison_62_2' or GetZoneName(self) == 'd_prison_62_3'  
            
            then
            
            local pc_list, pc_cnt = SelectObject(self, 100, 'ALL', 1)
            local i
            for i = 1, pc_cnt do
                if pc_list[i].ClassName == 'PC' then
                
                    if pc_list[i].Lv <= 25 and pc_list[i].Lv >= 1 then
                        --print(pc_list[i].Name, pc_list[i].Lv)

--                        local pc_sObj = GetSessionObject(pc_list[i], "ssn_klapeda")
--                        if pc_sObj.PILGRIM_48_SQ_030_BUFF ~= 300 then
--                            local pc_buff = GetBuffByName(pc_list[i], 'PILGRIM_48_SQ_030_BEGINNER')
--                            if pc_buff == nil then
                                return GetHandle(pc_list[i])
--                            end
--                        end
                    end
                end
            end
        end
    end
    return 0
end

--PILGRIM_48_SQ_060_ITEM_1
function SCR_PRE_PILGRIM_48_SQ_060_ITEM_1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM_48_SQ_060')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_pilgrimroad_48' then
            if GetLayer(self) == 0 then
                return 1;
            end
        end
    end
    return 0;
end

--PILGRIM_48_SQ_090_ITEM_1
function SCR_PRE_PILGRIM_48_SQ_090_ITEM_1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM_48_SQ_090')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_pilgrimroad_48' then
            if GetLayer(self) == 0 then
                local list_spot, cnt_spot = SelectObjectByFaction(self, 300, "Neutral", 1)
                local i
                if cnt_spot > 0 then
                    for i = 1, cnt_spot do
                        if list_spot[i].Name == "PILGRIM_48_SQ_090_DISTANCE_CHECK" then
                            return 1
                        end
                    end
                end
            end
        end
    end
    return 0;
end

--PILGRIM_49_SQ_040_ITEM_2
function SCR_PRE_PILGRIM_49_SQ_040_ITEM_2(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM_49_SQ_040')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_pilgrimroad_49' then
            if GetLayer(self) == 0 then    
                local invent = GetInvItemCount(self, 'PILGRIM_49_SQ_040_ITEM_1')
                if invent >= 8 then
                    return 1;
                end
            end
        end
    end
    return 0;
end

--ORCHARD_323_SQ_WATER
function SCR_PRE_ORCHARD_323_SQ_WATER(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_orchard_32_3' then
        if GetLayer(self) == 0 then
            local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_323_SQ_03')
            if result1 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 40, 'ALL')
                local i 
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'blank_npc' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--ORCHARD_323_SQ_CARVE
function SCR_PRE_ORCHARD_323_SQ_CARVE(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_orchard_32_3' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_323_SQ_05')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 100, 'ALL')
                local i 
                if fndCnt > 0 then
                    for i = 1, fndCnt do
                        if fndList[i].ClassName == 'ferret_patter' or fndList[i].ClassName == 'ferret_searcher' or ndList[i].ClassName == 'ferret_slinger' then
                            return GetHandle(fndList[i])
                        elseif fndList[i].ClassName == 'skill_romuva_D' then
                            return 0
                        end
                    end
                end
            end
        end
    end
    return 0
end

--ORCHARD_342_MQ_05_ITEM
function SCR_PRE_ORCHARD_342_MQ_05_ITEM(self, argObj, argstring, arg1, arg2)
    local quest_ssn = GetSessionObject(self, 'SSN_ORCHARD_342_MQ_05')
    if quest_ssn ~= nil then
        if quest_ssn.Goal1 < 3 then
            local list, cnt = SelectObject(self, 100, 'ALL')
            local i
            if cnt > 0 then
                for i = 1, cnt do
                    if list[i].ClassName == 'binding_Laima' then
                        return 1
                    end
                end
            end
        end
    end
    return 0
end

--ORCHARD_342_SQ_01_SCROLL
function SCR_PRE_ORCHARD_342_SQ_01_SCROLL(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'f_orchard_34_2' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_342_SQ_01')
            if result1 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 40, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName == 'ferret_folk' or list[i].ClassName == 'ferret_loader' then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--ORCHARD_342_SQ_02_TRANSFORM
function SCR_PRE_ORCHARD_342_SQ_02_TRANSFORM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_orchard_34_2' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_342_SQ_02')
            if result1 == 'PROGRESS' then
                if IsBuffApplied(self, 'ORCHARD342_TRANSFORM_BUFF') == "NO" then
                    return 1
                end
            end
        end
    end
    return 0
end

--ORCHARD_342_SQ_03_WOOD
function SCR_PRE_ORCHARD_342_SQ_03_WOOD(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_orchard_34_2' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_342_SQ_03')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 200, 'ENEMY')
                local i
                if fndCnt > 0 then
                    for i = 1, fndCnt do
                        if fndList[i].ClassName == 'ferret_folk' or fndList[i].ClassName == 'ferret_loader' then
                            return GetHandle(fndList[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--ORCHARD_342_SQ_04_ITEM
function SCR_PRE_ORCHARD_342_SQ_04_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'f_orchard_32_3' then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'ORCHARD_342_SQ_04')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 10, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'bonfire_1' then
                                return 1
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--ORCHARD_342_MQ_HOLLY_SPHERE
function SCR_PRE_ORCHARD_342_MQ_HOLLY_SPHERE(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_324_MQ_05')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_orchard_32_4' then
            local list, cnt = SelectObject(self, 40, 'ALL', 1)
            local i
            if cnt > 0 then
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].ClassName == 'kruvina_pillar' then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--ORCHARD_324_SQ_SCROLL
function SCR_PRE_ORCHARD_324_SQ_SCROLL(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_324_SQ_03')
    if result1 == 'PROGRESS' then
        local list, cnt = SelectObject(self, 40, 'ALL')
        local i
        if cnt > 0 then
            for i = 1, cnt do
                if list[i].ClassName ~= 'PC' then
                    if list[i].ClassName == 'blank_npc_noshadow' then
                        return GetHandle(list[i])
                    end
                end
            end
        end
    end
    return 0
end

--ORCHARD_324_SQ_04_SEED
function SCR_PRE_ORCHARD_324_SQ_04_SEED(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_orchard_32_4' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_324_SQ_04')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 40, 'ALL')
                local i
                if fndCnt > 0 then
                    for i = 1, fndCnt do
                        if fndList[i].ClassName == 'blank_npc_2' then
                            return GetHandle(fndList[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end


--BRACKEN632_SQ2_ITEM01
function SCR_PRE_BRACKEN632_SQ2_ITEM01(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_bracken_63_2' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'BRACKEN_63_2_SQ040')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 40, 'ALL',1)
                local i
                if fndCnt > 0 then
                    for i = 1, fndCnt do
                        if fndList[i].ClassName == 'siauliai_grass_1' then
                            return GetHandle(fndList[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--JOB_2_KRIVIS2_ITEM2
function SCR_PRE_JOB_2_KRIVIS2_ITEM2(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'JOB_2_KRIVIS2')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'c_orsha' then
            local list, cnt = SelectObject(self, 30, 'ALL')
            for i = 1, cnt do
                if list[i].ClassName ~= 'PC' then
                    if list[i].ClassName == 'cathedral_torch' then
                        return GetHandle(list[i])
                    end
                end
            end
        end
    end
    return 0
end

--JOB_2_CLERIC3_ITEM
function SCR_PRE_JOB_2_CLERIC3_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'JOB_2_CLERIC3')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_siauliai_16' then
            local list, cnt = SelectObject(self, 30, 'ALL', 1)
            for i = 1, cnt do
                if list[i].ClassName ~= 'PC' then
                    if list[i].ClassName == 'orsha_m_2' or list[i].ClassName == 'orsha_f_4' or list[i].ClassName == 'orsha_m_14_1' then
                        if IsBuffApplied(list[i],'JOB_2_CLERIC_CURED')  == 'NO' then
                            if IsServerSection(self) == 1 then
                                if list[i].Dialog == 'JOB_2_CLERIC3_PATIENT' then
                                    return GetHandle(list[i])
                                end
                            else
                                if GetDialogByObject(list[i]) == 'JOB_2_CLERIC3_PATIENT' then
                                    return GetHandle(list[i])
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--JOB_2_KRIVIS3_ITEM
function SCR_PRE_JOB_2_KRIVIS3_ITEM(self, argObj, argstring, argnum1, argnum2)
	local fndList, fndCount = SelectObject(self, 70, 'ALL', 1);
	local i
	
	if fndCount > 0 then
    	for i = 1, fndCount do
    	    if fndList[i].ClassName == 'statue_zemina' or fndList[i].ClassName == 'statue_vakarine' then
    		    return GetHandle(fndList[i])
        	end
    	end
    end
	
	if IsServerSection(self) == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_yeoSinSangi_JuByeone_eopSeupNiDa!"), 5);
    end
	return 0
end

--JOB_2_KRIVIS4_ITEM1
function SCR_PRE_JOB_2_KRIVIS4_ITEM1(self, argObj, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'JOB_2_KRIVIS4')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_pilgrimroad_31_1' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObjectByFaction(self, 50, 'Monster')
                local i
                for i = 1, cnt do
                    if GetHpPercent(list[i]) < 0.5 then
                        return GetHandle(list[i])
                    end
                end
            end
        end
    end
    return 0
end

--JOB_2_SADHU4_ITEM
function SCR_PRE_JOB_2_SADHU4_ITEM(self, argObj, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'JOB_2_SADHU4')
    local quest_ssn = GetSessionObject(self, "SSN_JOB_2_SADHU4")
    if result == "PROGRESS" then
        if quest_ssn.Step1 ~= 1 then
            if GetZoneName(self) == 'f_pilgrimroad_31_1' then
                if GetLayer(self) == 0 then
                    local list, cnt = SelectObject(self, 50, 'ENEMY')
                    local i
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].Faction == 'Monster' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--JOB_2_BARBARIAN5_ITEM
function SCR_PRE_JOB_2_BARBARIAN5_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'JOB_2_BARBARIAN5')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_pilgrimroad_52' then
            if GetLayer(self) == 0 then
                if IsBuffApplied(self,'JOB_2_BARBARIAN_ACID')  == 'NO' then
                    return 1
                end
            end
        end
    end
    return 0
end

 
--SIAU15RE_SQ_03_ITEM
function SCR_PRE_SIAU15RE_SQ_03_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'f_siauliai_15_re' then
        if GetLayer(self) == 0 then
            local result = SCR_QUEST_CHECK(self, 'SIAU15RE_SQ_03')
            if result == 'PROGRESS' then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, -328, -2560) <= 600 then
                    local list, cnt = SelectObject(self, 80, 'ENEMY')
                    local i
                    for i = 1, cnt do
        	            if list[i].Faction == 'Monster' then
        	                if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end


--SIAU11RE_MQ_03_ITEM
function SCR_PRE_SIAU11RE_MQ_03_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'f_siauliai_11_re' then
        if GetLayer(self) == 0 then
            local result = SCR_QUEST_CHECK(self, 'SIAU11RE_MQ_03')
            if result == 'PROGRESS' then
                return 1
            end
        end
    end
    return 0
end



--PRISON621_SQ_04_ITEM
function SCR_PRE_PRISON621_SQ_04_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'd_prison_62_1' then
        if GetLayer(self) == 0 then
            local result = SCR_QUEST_CHECK(self, 'PRISON621_SQ_04')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 180, 'ENEMY')
                local i
                for i = 1, cnt do
                    if cnt > 0 then
                        if list[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--PRISON622_SQ_02_ITEM
function SCR_PRE_PRISON622_SQ_02_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'd_prison_62_2' then
        if GetLayer(self) == 0 then
            local result = SCR_QUEST_CHECK(self, 'PRISON622_SQ_02')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 180, 'ENEMY')
                local i
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
        	            if list[i].Faction == 'Monster' then
        	                if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--_F_3CMLAKE_83_MQ_04
function SCR_PRE_F_3CMLAKE_83_MQ_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE_83_MQ_04')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_3cmlake_83' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 150, 'ALL', 1)
                local i
                if cnt ~= 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].Faction == 'Monster' then
                                return 1
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--CASTLE65_1_MQ02_ITEM
function SCR_PRE_CASTLE65_1_MQ02_ITEM(self, argObj, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'CASTLE65_1_MQ02')
    local quest_ssn = GetSessionObject(self, "SSN_CASTLE65_1_MQ02")
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_castle_65_1' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 50, 'ALL', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].ClassName == 'rokas_pot3_small' or list[i].ClassName == 'Stone01_NoObb'then
                            if IsServerSection(self) == 1 then
                                if list[i].Dialog == 'CASTLE651_MQ_02_1' then
                                    if quest_ssn.Step1 ~= 1 then
                                        return GetHandle(list[i])
                                    end
                                elseif list[i].Dialog == 'CASTLE651_MQ_02_2' then
                                    if quest_ssn.Step2 ~= 1 then
                                        return GetHandle(list[i])
                                    end
                                elseif list[i].Dialog == 'CASTLE651_MQ_02_3' then
                                    return GetHandle(list[i])
                                elseif list[i].Dialog == 'CASTLE651_MQ_02_4' then
                                    if quest_ssn.Step3 ~= 1 then
                                        return GetHandle(list[i])
                                    end
                                elseif list[i].Dialog == 'CASTLE651_MQ_02_5' then
                                    if quest_ssn.Step4 ~= 1 then
                                        return GetHandle(list[i])
                                    end
                                end
                            else
                                if GetDialogByObject(list[i]) == 'CASTLE651_MQ_02_1' then
                                    if quest_ssn.Step1 ~= 1 then
                                        return GetHandle(list[i])
                                    end
                                elseif GetDialogByObject(list[i]) == 'CASTLE651_MQ_02_2' then
                                    if quest_ssn.Step2 ~= 1 then
                                        return GetHandle(list[i])
                                    end
                                elseif GetDialogByObject(list[i]) == 'CASTLE651_MQ_02_3' then
                                    return GetHandle(list[i])
                                elseif GetDialogByObject(list[i]) == 'CASTLE651_MQ_02_4' then
                                    if quest_ssn.Step3 ~= 1 then
                                        return GetHandle(list[i])
                                    end
                                elseif GetDialogByObject(list[i]) == 'CASTLE651_MQ_02_5' then
                                    if quest_ssn.Step4 ~= 1 then
                                        return GetHandle(list[i])
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--CASTLE65_2_MQ02_ITEM
function SCR_PRE_CASTLE65_2_MQ02_ITEM(self, argObj, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'CASTLE65_2_MQ02')
    local result1 = SCR_QUEST_CHECK(self, 'CASTLE65_2_MQ03')
    local result2 = SCR_QUEST_CHECK(self, 'CASTLE65_2_MQ04')
    if GetZoneName(self) == 'f_castle_65_2' then
        if GetLayer(self) == 0 then
            if result == "PROGRESS" then
                local quest_ssn = GetSessionObject(self, "SSN_CASTLE65_2_MQ02")
                local list, cnt = SelectObject(self, 300, 'ALL', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].ClassName == 'HiddenTrigger2' then
                            if IsServerSection(self) == 1 then
                                if list[i].Dialog == 'CASTLE652_MQ_02_AREA' then
                                    return 1
                                end
                            else
                                if GetDialogByObject(list[i]) == 'CASTLE652_MQ_02_AREA' then
                                    return 1
                                end
                            end
                        end
                    end
                end
            elseif result1 == "PROGRESS" then
                local quest_ssn = GetSessionObject(self, "SSN_CASTLE65_2_MQ03")
                local list, cnt = SelectObject(self, 300, 'ALL', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].ClassName == 'HiddenTrigger2' then
                            if IsServerSection(self) == 1 then
                                if list[i].Dialog == 'CASTLE652_MQ_03_AREA' then
                                    return GetHandle(list[i])
                                end
                            else
                                if GetDialogByObject(list[i]) == 'CASTLE652_MQ_03_AREA' then
                                    return GetHandle(list[i])
                                end
                            end
                        end
                    end
                end
            elseif result2 == "PROGRESS" then
                local quest_ssn = GetSessionObject(self, "SSN_CASTLE65_2_MQ04")
                local list, cnt = SelectObject(self, 300, 'ALL', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].ClassName == 'HiddenTrigger2' then
                            if IsServerSection(self) == 1 then
                                if list[i].Dialog == 'CASTLE652_MQ_04_AREA' then
                                    return 1
                                end
                            else
                                if GetDialogByObject(list[i]) == 'CASTLE652_MQ_04_AREA' then
                                    return 1
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--CASTLE65_3_SQ01_ITEM
function SCR_PRE_CASTLE65_3_SQ01_ITEM(self, argObj, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'CASTLE65_3_SQ01')
    local result1 = SCR_QUEST_CHECK(self, 'CASTLE65_3_SQ02')
    if GetZoneName(self) == 'f_castle_65_3' then
        if GetLayer(self) == 0 then
            if result == "PROGRESS" then
                local quest_ssn = GetSessionObject(self, "SSN_CASTLE65_3_SQ01")
                if quest_ssn.Step2 >= 1 then
                    return 1
                end
            end
        end
    elseif GetZoneName(self) == 'f_castle_65_2' then
        if GetLayer(self) == 0 then
            if result1 == "PROGRESS" then
                local quest_ssn = GetSessionObject(self, "SSN_CASTLE65_3_SQ02")
                local list, cnt = SelectObject(self, 50, 'ALL')
                local i
                if quest_ssn.Step2 >= 1 then
                    return 1
                end
            end
        end
    end
    return 0
end

--SCR_PRE_PRISON611_MAP_ITEM
function SCR_PRE_PRISON611_MAP_ITEM(self, argObj, argstring, arg1, arg2)
    return 1
end


--FIRETOWER691_ITEM_1
function SCR_PRE_FIRETOWER691_ITEM_1(self, argObj, argstring, arg1, arg2)
    local zone_name = GetZoneName(self)
    local _layer = GetLayer(self)
    local x, y, z = GetPos(self)
    
    
    --f_remains_37
    if zone_name == 'f_remains_37' then

        local result1 = SCR_QUEST_CHECK(self, 'FIRETOWER691_PRE_1')
        if result1 == 'PROGRESS' then

            if _layer == 0 then
                if SCR_POINT_DISTANCE(x, z, 511, -1724) <= 300 then
                    return 1
                end
            end
        end

    --d_firetower_69_1
    elseif zone_name == 'd_firetower_69_1' then
        local result2 = SCR_QUEST_CHECK(self, 'FIRETOWER691_PRE_2')
        local result3 = SCR_QUEST_CHECK(self, 'FIRETOWER691_MQ_1')
        local result4 = SCR_QUEST_CHECK(self, 'FIRETOWER691_MQ_2')
        local result5 = SCR_QUEST_CHECK(self, 'FIRETOWER691_MQ_3')
        local result6 = SCR_QUEST_CHECK(self, 'FIRETOWER691_MQ_4')
        local result7 = SCR_QUEST_CHECK(self, 'FIRETOWER691_MQ_5')
        if result2 == 'PROGRESS' then
            if _layer == 0 then
                local quest_ssn = GetSessionObject(self, 'SSN_FIRETOWER691_PRE_2')
                if quest_ssn ~= nil then
                    if quest_ssn.QuestInfoValue2 < quest_ssn.QuestInfoMaxCount2 then
                        if SCR_POINT_DISTANCE(x, z, -1647, -261) <= 100 then
                            return 1
                        end
                    end
                end
            end
        end
        if result3 == 'PROGRESS' then
            if _layer == 0 then
            local quest_ssn = GetSessionObject(self, 'SSN_FIRETOWER691_MQ_1')
                if quest_ssn ~= nil then
                    if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                        if SCR_POINT_DISTANCE(x, z, -1766, 908) <= 100 then
                            return 1
                        end
                    end
                end
            end
        end
        if result4 == 'PROGRESS' then
            if _layer == 0 then
            local quest_ssn = GetSessionObject(self, 'SSN_FIRETOWER691_MQ_2')
                if quest_ssn ~= nil then
                    if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                        if SCR_POINT_DISTANCE(x, z, -749, 555) <= 150 then
                            return 1
                        end
                    end
                end
            end
        end
        if result5 == 'PROGRESS' then
            if _layer == 0 then
                if SCR_POINT_DISTANCE(x, z, 1326, 374) <= 550 then
                    local list, cnt = SelectObjectByFaction(self, 100, 'Monster')
                    if cnt == 0 then
                        return 1
                    else
                        return 0
                    end
                end
            end
        end
--        if result6 == 'PROGRESS' then
--            if _layer == 0 then
--                if SCR_POINT_DISTANCE(x, z, 2110, 362) <= 650 then
--                    return 1
--                end
--            end
--        end
--        if result7 == 'PROGRESS' then
--            if _layer == 0 then
--                return 1
--            end
--        end
    end

    return 0
end



--ABBAY643_SQ3_ITEM2
function SCR_PRE_ABBAY643_SQ3_ITEM2(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == "d_abbey_64_3" then
        local result1 = SCR_QUEST_CHECK(self, 'ABBAY_64_3_SQ030')
        local item = GetInvItemCount(self, 'ABBAY643_SQ3_ITEM01')
        if result1 == 'PROGRESS' then
            if item >= 8 then
                return 1
            end
        end
    end
    return 0;
end

--GIMMICK_TRANSFORM_POPOLION
function SCR_PRE_GIMMICK_TRANSFORM_POPOLION(self, argstring, argnum1, argnum2)
    local zone = GetZoneName(self)
    local city = GetClass("Map", zone)
    if GetLayer(self) == 0 then 
        if city.MapType == 'City' or zone == 'guild_agit_1' then
            if IsBuffApplied(self, 'GIMMICK_TRANSFORM_BUFF') == "NO" then
                return 1
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('GIMMICK_TRANSFORM_FAIL'), 10)
        end
    end
    return 0
end

--GIMMICK_TRANSFORM_FERRET
function SCR_PRE_GIMMICK_TRANSFORM_FERRET(self, argstring, argnum1, argnum2)
    local zone = GetZoneName(self)
    local city = GetClass("Map", zone)
    if GetLayer(self) == 0 then 
        if city.MapType == 'City' or zone == 'guild_agit_1' then
            if IsBuffApplied(self, 'GIMMICK_TRANSFORM_BUFF') == "NO" then
                return 1
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('GIMMICK_TRANSFORM_FAIL'), 10)
        end
    end
    return 0
end

--GIMMICK_TRANSFORM_TINY
function SCR_PRE_GIMMICK_TRANSFORM_TINY(self, argstring, argnum1, argnum2)
    local zone = GetZoneName(self)
    local city = GetClass("Map", zone)
    if GetLayer(self) == 0 then 
        if city.MapType == 'City' or zone == 'guild_agit_1' then
            if IsBuffApplied(self, 'GIMMICK_TRANSFORM_BUFF') == "NO" then
                return 1
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('GIMMICK_TRANSFORM_FAIL'), 10)
        end
    end
    return 0
end

--GIMMICK_TRANSFORM_PHANTO
function SCR_PRE_GIMMICK_TRANSFORM_PHANTO(self, argstring, argnum1, argnum2)
    local zone = GetZoneName(self)
    local city = GetClass("Map", zone)
    if GetLayer(self) == 0 then 
        if city.MapType == 'City' or zone == 'guild_agit_1' then
            if IsBuffApplied(self, 'GIMMICK_TRANSFORM_BUFF') == "NO" then
                return 1
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('GIMMICK_TRANSFORM_FAIL'), 10)
        end
    end
    return 0
end

--GIMMICK_TRANSFORM_HONEY
function SCR_PRE_GIMMICK_TRANSFORM_HONEY(self, argstring, argnum1, argnum2)
    local zone = GetZoneName(self)
    local city = GetClass("Map", zone)
    if GetLayer(self) == 0 then 
        if city.MapType == 'City' or zone == 'guild_agit_1' then
            if IsBuffApplied(self, 'GIMMICK_TRANSFORM_BUFF') == "NO" then
                return 1
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('GIMMICK_TRANSFORM_FAIL'), 10)
        end
    end
    return 0
end

--GIMMICK_TRANSFORM_ONION
function SCR_PRE_GIMMICK_TRANSFORM_ONION(self, argstring, argnum1, argnum2)
    local zone = GetZoneName(self)
    local city = GetClass("Map", zone)
    if GetLayer(self) == 0 then 
        if city.MapType == 'City' or zone == 'guild_agit_1' then
            if IsBuffApplied(self, 'GIMMICK_TRANSFORM_BUFF') == "NO" then
                return 1
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('GIMMICK_TRANSFORM_FAIL'), 10)
        end
    end
    return 0
end

--GIMMICK_TRANSFORM_JUKOPUS
function SCR_PRE_GIMMICK_TRANSFORM_JUKOPUS(self, argstring, argnum1, argnum2)
    local ride = GetVehicleState(self);
	if 1 == ride then
		SendSysMsg(self, "DonUseItemOnRIde");
		return 0;
	end
	local isSit = IsRest(self);
	if 1 == isSit then
		SendSysMsg(self, "DonUseItemOnRIde");
		return 0;
	end
    local zone = GetZoneName(self)
    local city = GetClass("Map", zone)
    if GetLayer(self) == 0 then 
        if city.MapType == 'City' or zone == 'guild_agit_1' then
            if IsBuffApplied(self, 'GIMMICK_TRANSFORM_BUFF') == "NO" then
                return 1
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('GIMMICK_TRANSFORM_FAIL'), 10)
        end
    end
    return 0
end

--Escape_Orb
function SCR_PRE_ITEM_Escape(self, argObj, BuffName, arg1, arg2)
    if GetLayer(self) ~= 0 then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("EscapeDisabled"), 5)
        return 0;
    else
        local cls = GetClassList('Map');
        local zone = GetZoneName(self);
        local obj = GetClassByNameFromList(cls, zone);
        if obj.Type == "MISSION" then
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("EscapeDisabled"), 5);
            return 0
        end
    end
    
    return 1;
end

--TABLELAND_11_1_SQ_06_CHARM
function SCR_PRE_TABLELAND_11_1_SQ_06_CHARM(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "f_tableland_11_1" then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'TABLELAND_11_1_SQ_06')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 40, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'SCS_M2_Mon' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--CORAL_32_1_SQ_11_ITEM1
function SCR_PRE_CORAL_32_1_SQ_11_ITEM1(self, argObj, BuffName, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'CORAL_32_1_SQ_11')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_coral_32_1' then
            if GetLayer(self) == 0 then
                return 1;
            end
        end
    end
    return 0;
end

--TABLELAND_11_1_SQ_10_LETTER
function SCR_PRE_TABLELAND_11_1_SQ_10_LETTER(self, argObj, BuffName, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'TABLELAND_11_1_SQ_09')
    if result == 'COMPLETE' then
        return 1
    else
        ShowBalloonText(self, 'TABLELAND_11_1_SQ_10_FAIL')
    end
    return 0
end

--TABLELAND_11_1_SQ_11_PAPER
function SCR_PRE_TABLELAND_11_1_SQ_11_PAPER(self, argObj, BuffName, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'TABLELAND_11_1_SQ_09')
    if result == 'COMPLETE' then
        return 1
    end
    return 0
end

--SIAULIAI_35_1_SQ_7_REAGENT
function SCR_PRE_SIAULIAI_35_1_SQ_7_REAGENT(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "f_siauliai_35_1" then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'SIAULIAI_35_1_SQ_8')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 40, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'vine_4' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--TABLE71_SUBQ4ITEM
function SCR_PRE_TABLE71_SUBQ4ITEM(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "f_tableland_71" then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'TABLELAND_71_SQ4')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 100, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].Faction == 'Neutral' then
                                if list[i].ClassName == 'HiddenTrigger4' then
                                    --if list[i].Enter == 'TABLE71_POINT3' then
                                        --print(list[i].Enter)
                                        return GetHandle(list[i])
                                    --end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--TABLE71_SUBQ7ITEM2
function SCR_PRE_TABLE71_SUBQ7ITEM2(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "f_tableland_71" then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'TABLELAND_71_SQ7')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 60, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].Faction == 'Monster' then
                                if list[i].ClassName == 'Hohen_ritter_purple' then
                                    return GetHandle(list[i])
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--TABLE72_SUBQ6ITEM1
function SCR_PRE_TABLE72_SUBQ6ITEM1(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "f_tableland_72" then
        if GetLayer(self) == 0 then
            local result = SCR_QUEST_CHECK(self, 'TABLELAND_72_SQ6')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 40, 'ALL', 1)
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'npc_orb1' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--ABBEY_35_3_SQ_ORB
function SCR_PRE_ABBEY_35_3_SQ_ORB(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "d_abbey_35_3" then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'ABBEY_35_3_SQ_3')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 100, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'Hohen_mage_red' or list[i].ClassName == 'Hohen_ritter_green' or list[i].ClassName == 'hohen_barkle_green' then
                                if GetHpPercent(list[i]) <= 0.5 then
                                    return GetHandle(list[i])
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--ABBEY_35_4_SQ_HOLLYORB
function SCR_PRE_ABBEY_35_4_SQ_HOLLYORB(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "d_abbey_35_4" then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'ABBEY_35_4_SQ_6')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 100, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'npc_Obelisk' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--ABBEY_35_3_SQ_10_REAGENT
function SCR_PRE_ABBEY_35_3_SQ_10_REAGENT(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "d_abbey_35_3" then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'ABBEY_35_3_SQ_10')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 40, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'vine_4' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--SCR_PRE_TABLE72_SUBQ9ITEM
function SCR_PRE_TABLE72_SUBQ9ITEM(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "f_tableland_73" then
        if GetLayer(self) == 0 then
            local result = SCR_QUEST_CHECK(self, 'TABLELAND_73_SQ1')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 40, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName == 'npc_orb1' then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
end

--SCR_PRE_TABLE73_SUBQ5_ITEM
function SCR_PRE_TABLE73_SUBQ5_ITEM(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "f_tableland_73" then
        if GetLayer(self) > 0 then
            local quest_item = GetInvItemCount(self, 'TABLE73_SUBQ5_ITEM')
            if quest_item >= 5 then
                return 1
            end
        end
    end
    return 0;
end

--SCR_PRE_TABLE73_SUBQ6_ITEM
function SCR_PRE_TABLE73_SUBQ6_ITEM(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "f_tableland_73" then
        if GetLayer(self) == 0 then
            local result = SCR_QUEST_CHECK(self, 'TABLELAND_73_SQ6')
            if result == 'PROGRESS' then
                local quest_item = GetInvItemCount(self, 'TABLE73_SUBQ6_ITEM')
                if quest_item >= 5 then
                    return 1
                else
                    SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('TABLE73_SUBQ5_MSG1'), 5)
                end
            end
        end
    end
    return 0;
end

--CORAL_35_2_SQ_2_STONEPIECE
function SCR_PRE_CORAL_35_2_SQ_2_STONEPIECE(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "f_coral_35_2" then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'CORAL_35_2_SQ_2')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 100, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'Altarcrystal_G1' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--CORAL_35_2_SQ_3_HORNPIECE
function SCR_PRE_CORAL_35_2_SQ_3_HORNPIECE(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "f_coral_35_2" then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'CORAL_35_2_SQ_3')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 100, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'Altarcrystal_G1' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--CORAL_35_2_SQ_8_MARINESTONE
function SCR_PRE_CORAL_35_2_SQ_8_MARINESTONE(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == "f_coral_35_2" then
        local result = SCR_QUEST_CHECK(self, 'CORAL_35_2_SQ_8')
        if result == 'PROGRESS' then
            return 1
        end
    end
    return 0;
end

--CORAL_35_2_SQ_7_HARMONYSTONE
function SCR_PRE_CORAL_35_2_SQ_7_HARMONYSTONE(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == "f_coral_35_2" then
        local result = SCR_QUEST_CHECK(self, 'CORAL_35_2_SQ_7')
        if result == 'PROGRESS' then
            return 1
        else
            local result2 = SCR_QUEST_CHECK(self, 'CORAL_35_2_SQ_11')
            if result2 == 'PROGRESS' then
                local list, cnt = SelectObject(self, 100, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'Altarcrystal_Silhouette_Noobb' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0;
end

--CORAL_35_2_SQ_6_TERRASTONE
function SCR_PRE_CORAL_35_2_SQ_6_TERRASTONE(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == "f_coral_35_2" then
        local result = SCR_QUEST_CHECK(self, 'CORAL_35_2_SQ_12')
        if result == 'PROGRESS' then
            return 1
        end
    end
    return 0;
end

--CORAL_35_2_SQ_14_FINDER
function SCR_PRE_CORAL_35_2_SQ_14_FINDER(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'CORAL_35_2_SQ_14')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_coral_35_2' then
            if GetLayer(self) == 0 then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, -338, 1082) < 750 or SCR_POINT_DISTANCE(x, z, 865, 628) < 750 then
                    return 1;
                end
            end
        end
    end
    return 0;
end

--CORAL_32_2_SQ_5_ITEM
function SCR_PRE_CORAL_32_2_SQ_5_ITEM(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == 'f_coral_32_2' then
        if GetLayer(self) == 0 then
            local x, y, z = GetPos(self)
            local dist1 = SCR_POINT_DISTANCE(x, z, -698, 785)
            local dist2 = SCR_POINT_DISTANCE(x, z, 4, 39)
            if dist1 <= 40 then
                return 1;
            elseif dist2 <= 40 then
                return 1;
            end
        end
    end
    return 0;
end

--CORAL_32_2_SQ_12_ITEM2
function SCR_PRE_CORAL_32_2_SQ_12_ITEM2(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == 'f_coral_32_2' then
        if GetLayer(self) == 0 then
            local list, cnt = SelectObject(self, 40, 'ALL', 1)
            local i
            if cnt > 0 then
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].ClassName == 'Stone04' then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0;
end

--PILGRIM41_2_SQ05_ITEM
function SCR_PRE_PILGRIM41_2_SQ05_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM41_2_SQ05')
    local quest_ssn = GetSessionObject(self, 'SSN_PILGRIM41_2_SQ05')
    if result == "PROGRESS" then
        if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
            if GetZoneName(self) == 'f_pilgrimroad_41_2' then
                if GetLayer(self) == 0 then
                    local list, cnt = SelectObjectByFaction(self, 50, 'Monster', 1)
                    local i
                    for i = 1, cnt do
                        if IsBuffApplied(list[i], 'PILGRIM41_2_DARKAURA') == 'YES' then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--PILGRIM41_4_SQ05_ITEM
function SCR_PRE_PILGRIM41_4_SQ05_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM41_4_SQ06')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_pilgrimroad_41_4' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObjectByFaction(self, 50, 'Monster', 1)
                local i
                for i = 1, cnt do
                    if list[i].RaceType == 'Velnias' then
                        if IsBuffApplied(list[i], 'PILGRIM41_4_MONWEAK') == 'NO' then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--PILGRIM41_5_SQ02_1_ITEM
function SCR_PRE_PILGRIM41_5_SQ02_1_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM41_5_SQ02')
    local result1 = SCR_QUEST_CHECK(self, 'PILGRIM41_5_SQ03')
    local result2 = SCR_QUEST_CHECK(self, 'PILGRIM41_5_SQ06')
    if result == "PROGRESS" or result1 == "PROGRESS" or result2 == "PROGRESS" then
        local item_cnt = GetInvItemCount(self, 'PILGRIM41_5_SQ02_2_ITEM')
        if item_cnt == 0 then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObjectByFaction(self, 50, 'Neutral', 1)
                local i
                for i = 1, cnt do
                    if IsServerSection(self) == 1 then
                        if list[i].Dialog == 'PILGRIM415_TREE' then
                            return GetHandle(list[i])
                        end
                    else
                        if GetDialogByObject(list[i]) == 'PILGRIM415_TREE' then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--MAPLE_25_3_SQ_120_ITEM1
function SCR_PRE_MAPLE_25_3_SQ_120_ITEM1(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_maple_25_3' then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'MAPLE_25_3_SQ_120')
            if result == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 80, 'ENEMY')
                local i 
                for i = 1, fndCnt do
                    if fndList[i].ClassName == 'rodeyokel' then
                        if GetHpPercent(fndList[i]) <= 0.5 then
                            return GetHandle(fndList[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--UNDER30_3_EVENT2_BOMB
function SCR_PRE_UNDER30_3_EVENT2_BOMB(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_underfortress_30_3' then
        if GetLayer(self) == 0 then
            return 1
        end
    end
    if IsServerSection(self) == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("UNDER30_3_EVENT2_BOBM"), 5);
    end
    return 0
end

--BRACKEN42_1_SQ06_ITEM
function SCR_PRE_BRACKEN42_1_SQ06_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'BRACKEN42_1_SQ07')
    if result == "PROGRESS" then
        return 1
    end
    return 0
end

--BRACKEN42_1_SQ07_ITEM
function SCR_PRE_BRACKEN42_1_SQ07_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'BRACKEN42_1_SQ08')
    if result == "PROGRESS" then
        local item_cnt = GetInvItemCount(self, 'BRACKEN42_1_SQ08_1_ITEM')
        if item_cnt ~= 0 then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 320, 'ALL', 1)
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].Faction == 'Neutral' then
                            if IsServerSection(self) == 1 then
                                if list[i].Dialog == 'BRACKEN421_SQ_08_2' then
                                    return 1
                                end
                            else
                                if GetDialogByObject(list[i]) == 'BRACKEN421_SQ_08_2' then
                                    return 1
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--BRACKEN42_2_SQ05_ITEM
function SCR_PRE_BRACKEN42_2_SQ05_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'BRACKEN42_2_SQ05')
    if result == "PROGRESS" then
        if GetZoneName(self) == "f_bracken_42_2" then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 50, 'ALL', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].ClassName == 'Moglan_blue' then
                            if GetHpPercent(list[i]) <= 0.3 then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--BRACKEN42_2_SQ06_ITEM
function SCR_PRE_BRACKEN42_2_SQ06_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'BRACKEN42_2_SQ06')
    local quest_ssn = GetSessionObject(self, "SSN_BRACKEN42_2_SQ06")
    if result == "PROGRESS" then
        if GetZoneName(self) == "f_bracken_42_2" then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObjectByFaction(self, 50, 'Neutral')
                local i
                local j
                for i = 1, cnt do
                    for j = 1, 5 do
                        if IsServerSection(self) == 1 then
                            if list[i].Dialog == 'BRACKEN422_SQ_06_'..j then
                                return GetHandle(list[i])
                            end
                        else
                            if GetDialogByObject(list[i]) == 'BRACKEN422_SQ_06_'..j then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--BRACKEN42_2_SQ11_ITEM
function SCR_PRE_BRACKEN42_2_SQ11_ITEM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'BRACKEN42_2_SQ11')
    if result == "PROGRESS" then
        if GetZoneName(self) == "f_bracken_42_2" then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObjectByFaction(self, 50, 'Neutral', 1)
                local i
                for i = 1, cnt do
                    if IsServerSection(self) == 1 then
                        if list[i].Dialog == 'BRACKEN422_SQ_11' then
                            return GetHandle(list[i])
                        end
                    else
                        if GetDialogByObject(list[i]) == 'BRACKEN422_SQ_11' then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--LIMESTONE_52_1_MQ_10_CRYSTAL--
function SCR_PRE_LIMESTONE_52_1_MQ_10_CRYSTAL(self, argObj, BuffName, arg1, arg2)
    if GetZoneName(self) == "d_limestonecave_52_1" then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'LIMESTONE_52_1_MQ_10')
            if result == 'PROGRESS' then
                local list, cnt = SelectObject(self, 100, 'ALL')
                local i
                if cnt > 0 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].ClassName == 'cmine_cartheap' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--LIMESTONE_52_1_SQ_1_POWDER--
function SCR_PRE_LIMESTONE_52_1_SQ_1_POWDER(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_limestonecave_52_1' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'LIMESTONE_52_1_SQ_1')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 100, 'ALL')
                local i 
                for i = 1, fndCnt do
                    if fndList[i].ClassName ~= 'PC' then
                        if fndList[i].ClassName == 'tala_sorcerer' then
                            if GetHpPercent(fndList[i]) <= 0.5 then
                                return GetHandle(fndList[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--LIMESTONE_52_1_SQ_1_NECK_1--
function SCR_PRE_LIMESTONE_52_1_SQ_1_NECK_1(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, "LIMESTONE_52_1_SQ_3")
    
    if result == "PROGRESS" then
        local list, cnt = SelectObject(self, 40, 'ALL')
        local i
        if cnt > 0 then
            for i = 1, cnt do
            
                if list[i].ClassName ~= 'PC' then
                    if IsBuffApplied(list[i], "LIMESTONE_52_1_STUN") == "YES" then
                        return GetHandle(list[i])
                    end
                end
            end
        end
    end
    return 0
end

--MAPLE_25_1_SQ_40_ITEM
function SCR_PRE_MAPLE_25_1_SQ_40_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'f_maple_25_1' then
        if GetLayer(self) == 0 then
            local result = SCR_QUEST_CHECK(self, 'MAPLE_25_1_SQ_40')
            if result == 'PROGRESS' then
                return 1
            end
        end
    end
    return 0
end

--MAPLE_25_2_SQ_100_ITEM2
function SCR_PRE_MAPLE_25_2_SQ_100_ITEM2(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'f_maple_25_2' then
        if GetLayer(self) == 0 then
            local result = SCR_QUEST_CHECK(self, 'MAPLE_25_2_SQ_100')
            if result == 'PROGRESS' then
                return 1
            end
        end
    end
    return 0
end

--LIMESTONE_52_4_HOLY_CHARM--
function SCR_PRE_LIMESTONE_52_4_HOLY_CHARM(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'LIMESTONE_52_4_MQ_5')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'd_limestonecave_52_4' then
            if GetLayer(self) == 0 then 
                local list, cnt = SelectObject(self, 100, 'ALL')
                local i
                for i = 1 , cnt do
                    if list[i].ClassName ~= 'pc' then
                        if list[i].ClassName == 'flamag_green' or list[i].ClassName == 'flamme_archer_green' then
                            return GetHandle(list[i])
                        end
                    end
                end
        	end
        end
    end
    return 0
end

--LIMESTONE_52_5_MQ_4_FINDER--
function SCR_PRE_LIMESTONE_52_5_MQ_4_FINDER(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'LIMESTONE_52_5_MQ_4')
    local result2 = SCR_QUEST_CHECK(self, 'LIMESTONE_52_5_SQ_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'd_limestonecave_52_5' then
            if GetLayer(self) == 0 then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, 982, 376) < 300 or SCR_POINT_DISTANCE(x, z, 451, 983) < 300 or SCR_POINT_DISTANCE(x, z, 1259, -317) < 300 then
                    return 1;
                end
            end
        end
    else
        if result2 == 'PROGRESS' then
            if GetZoneName(self) == 'd_limestonecave_52_5' then
                if GetLayer(self) == 0 then
                    local x, y, z = GetPos(self)
                    if SCR_POINT_DISTANCE(x, z, 96, -205) < 1600 then
                        return 1;
                    end
                end
            end
        end
    end
    return 0;
end

--BRACKEN431_SUBQ6_ITEM1
function SCR_PRE_BRACKEN431_SUBQ6_ITEM1(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'BRACKEN43_1_SQ5')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_bracken_43_1' then
            if GetLayer(self) == 0 then 
                local list, cnt = SelectObject(self, 10, 'ALL')
                local i
                for i = 1 , cnt do
                    if list[i].ClassName ~= 'pc' then
                        if list[i].ClassName == 'pilgrim_shrine_parts' then
                            if IsBuffApplied(list[i], "BRACKEN431_SUBQ5_BUFF") == "YES" then
                            return GetHandle(list[i])
                        end
                    end
                end
        	end
        end
    end
    end
    return 0
end

--SCR_PRE_DCAPITAL_20_5_SQ_60_ITEM

function SCR_PRE_DCAPITAL_20_5_SQ_60_ITEM(self, argstring, argnum1, argnum2)
    local result1 = SCR_QUEST_CHECK(self, 'F_DCAPITAL_20_5_SQ_60')
    local result2 = SCR_QUEST_CHECK(self, 'F_DCAPITAL_20_5_SQ_80')
    local result3 = SCR_QUEST_CHECK(self, 'F_DCAPITAL_20_5_SQ_90')
    local result4 = SCR_QUEST_CHECK(self, 'F_DCAPITAL_20_6_SQ_80')
    
    local x, y, z = GetPos(self)
    
    if result1 == "PROGRESS" then
        if GetZoneName(self) == 'f_dcapital_20_5' then
            if GetLayer(self) == 0 then
                if SCR_POINT_DISTANCE(x, z, -999, 20) < 600 then
                    return 1;
                end
            end
        end
    elseif result2 == "PROGRESS" then
        if GetZoneName(self) == 'f_dcapital_20_5' then
            if GetLayer(self) == 0 then
                if SCR_POINT_DISTANCE(x, z, 593, 568) < 600 then
                    return 1;
                end
            end
        end
    elseif result3 == "PROGRESS" then
        if GetZoneName(self) == 'f_dcapital_20_5' then
            if GetLayer(self) == 0 then
                if SCR_POINT_DISTANCE(x, z, 1333, 87) < 600 then
                    return 1;
                end
            end
        end
    elseif result4 == "PROGRESS" then
        if GetZoneName(self) == 'f_dcapital_20_6' then
            if GetLayer(self) == 0 then
                if SCR_POINT_DISTANCE(x, z, 1333, 87) < 600 then
                    return 1;
                end
            end
        end
    end
    return 0;
end

--SCR_PRE_BRACKEN432_SUBQ6_ITEM1
function SCR_PRE_BRACKEN432_SUBQ6_ITEM1(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'BRACKEN43_2_SQ6')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_bracken_43_2' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 50, 'ALL', 1)
                local i
                for i = 1 , cnt do
                    if list[i].ClassName == 'HiddenTrigger6' then
                        if list[i].Name == 'BRACKEN432_FLOWER_NPC' then
                            return GetHandle(list[i])
                        end
                    end
                end
        	end
        end
    end
    return 0
end

--SCR_PRE_BRACKEN432_SUBQ2_ITEM1
function SCR_PRE_BRACKEN432_SUBQ2_ITEM1(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_bracken_43_2' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'BRACKEN43_2_SQ2')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 100, 'ENEMY')
                local i 
                for i = 1, fndCnt do
                    if fndList[i].ClassName == 'darong' then
                        local item_cnt = GetInvItemCount(self, "BRACKEN432_SUBQ2_ITEM5")
                        if item_cnt < 1 then
                            if GetHpPercent(fndList[i]) <= 0.5 then
                                return GetHandle(fndList[i])
                            end
                        else
                            return 0
                        end
                    elseif fndList[i].ClassName == 'dorong' then
                        local item_cnt = GetInvItemCount(self, "BRACKEN432_SUBQ2_ITEM6")
                        if item_cnt < 1 then
                            if GetHpPercent(fndList[i]) <= 0.5 then
                                return GetHandle(fndList[i])
                            end
                        else
                            return 0
                        end
                    end
                end
            end
        end
    end
    return 0
end

--SCR_PRE_BRACKEN433_SUBQ9_ITEM2
function SCR_PRE_BRACKEN433_SUBQ9_ITEM2(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_bracken_43_3' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'BRACKEN43_3_SQ10')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 330, 'ALL', 1)
                local i
                for i = 1, fndCnt do
                    if fndList[i].ClassName == 'Hiddennpc' then
                        return 1
                    end
                end
            end
        end
    end
    return 0
end

--SCR_PRE_BRACKEN433_SUBQ3_ITEM1
function SCR_PRE_BRACKEN433_SUBQ3_ITEM1(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_bracken_43_3' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'BRACKEN43_3_SQ4')
            if result1 == 'PROGRESS' then
                return 1
            end
        end
    end
    return 0
end

--SCR_PRE_BRACKEN434_SUBQ2_ITEM2
function SCR_PRE_BRACKEN434_SUBQ2_ITEM2(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_bracken_43_4' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'BRACKEN43_4_SQ2')
            if result1 == 'PROGRESS' then
                return 1
            end
        end
    end
    return 0
end

--SCR_PRE_BRACKEN434_SUBQ7_ITEM
function SCR_PRE_BRACKEN434_SUBQ7_ITEM(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_bracken_43_4' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'BRACKEN43_4_SQ7')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 100, 'ALL', 1)
                local i 
                for i = 1, fndCnt do
                    if fndList[i].ClassName == 'npc_rokas_5' or fndList[i].ClassName == 'extra_tomb_no_obb' or fndList[i].ClassName == 'npc_rokas_2' or fndList[i].ClassName == 'npc_Obelisk_broken' or fndList[i].ClassName == 'stonepillar_1' then
                        return GetHandle(fndList[i])
                        
                    end
                end
            end
        end
    end
    return 0
end


--SCR_PRE_BRACKEN434_SUBQ9_ITEM2
function SCR_PRE_BRACKEN434_SUBQ9_ITEM2(self, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'f_bracken_43_4' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'BRACKEN43_4_SQ9')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 100, 'ENEMY', 1)
                local i 
                for i = 1, fndCnt do
                    if fndList[i].ClassName == 'vilkas_mage' or fndList[i].ClassName == 'vilkas_warrior' or fndList[i].ClassName == 'vilkas_fighter' then
                        if GetHpPercent(fndList[i]) <= 0.3 then
                            return GetHandle(fndList[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--WHITETREES23_1_SQ06_ITEM1
function SCR_PRE_WHITETREES23_1_SQ06_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'WHITETREES23_1_SQ06')
    if result == 'PROGRESS' then
        if GetZoneName(self) == "f_whitetrees_23_1" then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 50, 'ALL', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].Faction == 'Monster' then
                            if list[i].ClassName == 'kucarry_Tot' then
                                if IsBuffApplied(list[i], "WHITETREES23_1_SQ06_IMPETUS") == "NO" then
                                    return GetHandle(list[i])
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--MAPLE23_2_SQ06_ITEM1
function SCR_PRE_MAPLE23_2_SQ06_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'MAPLE23_2_SQ06')
    local quest_ssn = GetSessionObject(self, 'SSN_MAPLE23_2_SQ06')
    if result == 'PROGRESS' then
        if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
            if GetZoneName(self) == "f_maple_23_2" then
                if GetLayer(self) == 0 then
                    local list, cnt = SelectObject(self, 50, 'ALL', 1)
                    local i
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
                            if list[i].Faction == 'Neutral' then
                                if IsServerSection(self) == 1 then
                                    if list[i].Dialog == 'MAPLE232_SQ_06' then
                                        return GetHandle(list[i])
                                    end
                                else
                                    if GetDialogByObject(list[i]) == 'MAPLE232_SQ_06' then
                                        return GetHandle(list[i])
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--WHITETREES23_3_SQ06_ITEM1
function SCR_PRE_WHITETREES23_3_SQ06_ITEM1(self, argObj, argstring, arg1, arg2)
    return 1
end

--WHITETREES23_3_SQ06_ITEM2
function SCR_PRE_WHITETREES23_3_SQ06_ITEM2(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'WHITETREES23_3_SQ06')
    local quest_ssn = GetSessionObject(self, "SSN_WHITETREES23_3_SQ06")
    if result == "PROGRESS" then
        if GetZoneName(self) == "f_whitetrees_23_3" then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObjectByFaction(self, 50, 'Neutral')
                local i
                for i = 1, cnt do
                    for j = 1, 5 do
                        if IsServerSection(self) == 1 then
                            if list[i].Dialog == 'WHITETREES233_SQ_06_'..j then 
                                return GetHandle(list[i])
                            end
                        else
                            if GetDialogByObject(list[i]) == 'WHITETREES233_SQ_06_'..j then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--SCR_PRE_JOB_3_NECROMANCER_ITEM
function SCR_PRE_JOB_3_NECROMANCER_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'JOB_NECROMANCER7_1')
    if result == 'PROGRESS' then
        if GetZoneName(self) == "f_bracken_42_2" then
            if GetLayer(self) < 1 then
                local list, cnt = SelectObject(self, 70, 'ENEMY', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].ClassName == 'duckey_red' or list[i].ClassName == 'Moglan_blue' or list[i].ClassName == 'beetow_blue' then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
        return 0
    end
end

--SCR_PRE_JOB_2_WAROLCK_ITEM1
function SCR_PRE_JOB_2_WAROLCK_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'JOB_WARLOCK_8_1')
    if result == 'PROGRESS' then
        if GetZoneName(self) == "f_castle_20_1" then
            if GetLayer(self) < 1 then
                local list, cnt = SelectObject(self, 70, 'ENEMY', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special') == 'YES' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
        return 0
    end
end

--SCR_PRE_JOB_2_FEATHERFOOT_ITEM1
function SCR_PRE_JOB_2_FEATHERFOOT_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'JOB_FEATHERFOOT_8_1')
    if result == 'PROGRESS' then
        if GetZoneName(self) == "f_bracken_42_1" then
            if GetLayer(self) < 1 then
                if IsBuffApplied(self, "JOB_FEATHERFOOT_8_DEBUFF1") == "YES" then
                    return 1
                end
            end
        end
        return 0
    end
end

--SCR_PRE_JOB_2_KABBALIST_ITEM1
function SCR_PRE_JOB_2_KABBALIST_ITEM1(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_KABBALIST_8_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_castle_20_2' then
            if GetLayer(self) == 0 then
                return 1;
            end
        end
    end
    return 0;
end

--SCR_PRE_JOB_1_ENCHEANTER_ITEM1
function SCR_PRE_JOB_1_ENCHEANTER_ITEM1(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_ENCHANTER_8_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'c_fedimian' then
            if GetLayer(self) < 1 then
                local list, cnt = SelectObject(self, 70, 'ALL', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName == 'Hiddennpc_move' then
                        if list[i].Faction == 'Neutral' then
                            if list[i].Dialog ~= nil then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0; 
end

--SCR_PRE_JOB_1_INQUGITOR_ITEM2
function SCR_PRE_JOB_1_INQUGITOR_ITEM2(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_INQUGITOR_8_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'd_abbey_41_6' then
            if GetLayer(self) < 1 then
                local list, cnt = SelectObject(self, 60, 'ALL', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName == 'pedlar_lose_1' then
                        return GetHandle(list[i])
                    end
                end
            end
        end
    end
    return 0; 
end

--SCR_PRE_JOB_1_DAOSHI_ITEM1
function SCR_PRE_JOB_1_DAOSHI_ITEM1(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_DAOSHI_8_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_maple_25_1' then
            if GetLayer(self) < 1 then
                local list, cnt = SelectObject(self, 80, 'ALL', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0; 
end

--SCR_PRE_JOB_3_DRUID_ITEM
function SCR_PRE_JOB_3_DRUID_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_DRUID_7_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_pilgrimroad_41_5' then
            if GetLayer(self) < 1 then
                local list, cnt = SelectObject(self, 60, 'ALL', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName == 'siauliai_grass_2' then
                        if IsBuffApplied(list[i], "JOB_3_DRUID_BUFF") == "YES" then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0; 
end
--JOB_DRAGOON_8_1_ITEM1_ITEM1
function SCR_PRE_JOB_DRAGOON_8_1_ITEM1(self, argObj, BuffName, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'JOB_DRAGOON_8_1')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_tableland_11_1' then
            if GetLayer(self) == 0 then
                return 1;
            end
        end
    end
    return 0;
end

--WHITETREES561_SUBQ4_ITEM2
function SCR_PRE_WHITETREES561_SUBQ4_ITEM2(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'WHITETREES56_1_SQ4')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_whitetrees_56_1' then
            local item1 = GetInvItemCount(self, 'WHITETREES561_SUBQ4_ITEM1')
            if item1 >= 1 then
                if GetLayer(self) == 0 then
                    return 1;
                end
            end
        end
    end
    return 0;
end

--WHITETREES561_SUBQ7_ITEM2
function SCR_PRE_WHITETREES561_SUBQ7_ITEM2(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'WHITETREES56_1_SQ7')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_whitetrees_56_1' then
            if GetLayer(self) < 1 then
                local list, cnt = SelectObject(self, 40, 'ALL', 1)
                local i
                for i = 1, cnt do
                    if list[i].ClassName == 'Hiddennpc_Q1' then
                        return GetHandle(list[i])
                    end
                end
            end
        end
    end
    return 0; 
end

--DCAPITAL103_SQ03_ITEM1
function SCR_PRE_DCAPITAL103_SQ03_ITEM1(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'DCAPITAL103_SQ03')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_dcapital_103' then
            if GetLayer(self) == 0 then
                local itemCnt = GetInvItemCount(self, 'DCAPITAL103_SQ03_ITEM2')
                if itemCnt <= 7 then
                    local list, cnt = SelectObject(self, 20, 'ALL', 1)
                    local i
                    for i = 1, cnt do
                        if list[i].ClassName == "Hiddennpc" then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--DCAPITAL103_SQ09_ITEM1
function SCR_PRE_DCAPITAL103_SQ09_ITEM1(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'DCAPITAL103_SQ09')
    if result == "PROGRESS" then
        if GetLayer(self) == 0 then
            local list, cnt = SelectObject(self, 100, 'ALL', 1)
            for i = 1, cnt do
                if list[i].ClassName ~= 'PC' then
                    if list[i].Faction == 'Neutral' then
                        if IsServerSection(self) == 1 then
                            if list[i].Dialog == 'DCAPITAL103_SQ_09' then
                                return 1
                            end
                        else
                            if GetDialogByObject(list[i]) == 'DCAPITAL103_SQ_09' then
                                return 1
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end




--KEY_QUEST_COMMON
function SCR_PRE_KEY_QUEST_COMMON_1(self, argstring, argnum1, argnum2)
    return 1
end


--SCR_PRE_UNDER67_HIDDENQ1_ITEM1
function SCR_PRE_UNDER67_HIDDENQ1_ITEM1(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'UNDERFORTRESS67_HQ1')
    local sObj = GetSessionObject(self, "SSN_UNDERFORTRESS67_HQ1")
    if result == "PROGRESS" then
        if GetLayer(self) == 0 then
            local list, cnt = SelectObject(self, 160, 'ALL', 1)
            for i = 1, cnt do
                if list[i].ClassName == 'Hiddennpc_move' then
                    if list[i].Faction == "Neutral" then
                        if GetZoneName(self) == 'd_underfortress_65' then
                            if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                                return GetHandle(list[i])
                            end
                        elseif GetZoneName(self) == 'd_underfortress_66' then
                            if sObj.QuestInfoValue2 < sObj.QuestInfoMaxCount2 then
                                return GetHandle(list[i])
                            end
                        elseif GetZoneName(self) == 'd_underfortress_67' then
                            if sObj.QuestInfoValue3 < sObj.QuestInfoMaxCount3 then
                                return GetHandle(list[i])
                            end
                        elseif GetZoneName(self) == 'd_underfortress_68' then
                            if sObj.QuestInfoValue4 < sObj.QuestInfoMaxCount4 then
                                return GetHandle(list[i])
                            end
                        elseif GetZoneName(self) == 'd_underfortress_69' then
                            if sObj.QuestInfoValue5 < sObj.QuestInfoMaxCount5 then
                                return GetHandle(list[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return 0
end

--SCR_PRE_SIAULIAI16_HIDDENQ1_ITEM2
function SCR_PRE_SIAULIAI16_HIDDENQ1_ITEM2(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'SIAULIAI16_HQ2')
    local highlander_Item1 = GetInvItemCount(self, 'SIAULIAI16_HIDDENQ1_ITEM3')
    if result == 'PROGRESS' then
        if highlander_Item1 >= 13 then
            if GetLayer(self) == 0  then
        	    return 1
        	end
        end
    end
    return 0
end

--SCR_PRE_ORSHA_HIDDENQ2_ITEM1
function SCR_PRE_ORSHA_HIDDENQ2_ITEM1(self, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'ORSHA_HQ2')
    local Item1 = GetInvItemCount(self, 'ORSHA_HIDDENQ2_ITEM2')
    local Item2 = GetInvItemCount(self, 'ORSHA_HIDDENQ2_ITEM3')
    if result == "PROGRESS" then
        if Item1 >= 5 and Item2 >= 3 then
            if GetLayer(self) == 0 then
                return 1
            end
        end
    end
    return 0
end


--SCR_PRE_ORSHA_HIDDENQ3_ITEM1
function SCR_PRE_ORSHA_HIDDENQ3_ITEM1(self, strArg, num1, num2, itemType)
    local result = SCR_QUEST_CHECK(self, 'ORSHA_HQ3')
    if result == "PROGRESS" then
        if GetLayer(self) == 0 then
        	if 1 == IsGuildHouseWorld(self) then
        		return 1;
        	end
        
        	local pcPetList = GetSummonedPetList(self)
        	if #pcPetList == 0 then
        		return 0;
        	end
        
--        	local itemCls = GetClassByType("Item_Quest", itemType );
--        	if itemCls == nil then
--        	print("22222222222222222222")
--        		return 0;
--        	end
        	
        	local pcPet = nil;
        	for i=1, #pcPetList do
        		local petObj = pcPetList[i];
        		if petObj.Lv >= 300 then
            		local petCls = GetClassByStrProp("Companion", "ClassName", petObj.ClassName)
            		local foodGroup = 0;
            
            		if petCls ~= nil and petCls.FoodGroup ~= "None" then
            			foodGroup = tonumber(petCls.FoodGroup);
            		end
                    --print(petCls, foodGroup)
            		if petCls ~= nil then
            			pcPet = petObj;
            		end
        		end
        	end	
        	
        	if pcPet == nil then
        		SendSysMsg(self, "ThisCompanionDoesNotEatThisFood");
        	    return 0;
        	end
        	
        	
        	local ret = IsNodeMonsterAttached(self, "None");
        	if ret == 0 then
        		return 1;
        	end
    	end
    end
	return 0;
end

function SCR_PRE_TABLE281_HIDDENQ1_ITEM5(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'TABLELAND28_1_HQ1')
    local sObj = GetSessionObject(self, "SSN_TABLELAND28_1_HQ1")
    if result == "PROGRESS" then
        if GetLayer(self) == 0 then
        	if GetZoneName(self) == "f_orchard_32_3" then
        	    if isHideNPC(self, "ORCHARD323_HIDDEN_OBJ2") == "NO" then
        	        if IsBuffApplied(self, "TABLE281_HIDDENQ1_BUFF1") == "YES" then
        	            return 1
        	        end
        	    end
        	elseif GetZoneName(self) == "f_pilgrimroad_51" then
        	    if isHideNPC(self, "PILGRIM51_HIDDEN_OBJ3") == "NO" then
        	        if IsBuffApplied(self, "TABLE281_HIDDENQ1_BUFF2") == "YES" then
        	            return 1
        	        end
        	    end
        	elseif GetZoneName(self) == "f_flash_58" then
        	    if isHideNPC(self, "FLASH58_HIDDEN_OBJ4") == "NO" then
        	        if IsBuffApplied(self, "TABLE281_HIDDENQ1_BUFF3") == "YES" then
        	            return 1
        	        end
        	    end
        	end
        end
    end
    return 0
end
--PILGRIMROAD55_SQ12_ITEM
function SCR_PRE_PILGRIMROAD55_SQ12_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'f_pilgrimroad_55' then
        if GetLayer(self) == 0 then 
            local result1 = SCR_QUEST_CHECK(self, 'PILGRIMROAD55_SQ12')
            if result1 == 'PROGRESS' then
                local fndList, fndCnt = SelectObject(self, 100, 'ENEMY', 1)
                local i 
                for i = 1, fndCnt do
                    if fndList[i].ClassName == 'Burialer' then
                        if GetHpPercent(fndList[i]) <= 0.3 then
                            return GetHandle(fndList[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--LOWLV_BOASTER_SQ_20_ITEM
function SCR_PRE_LOWLV_BOASTER_SQ_20_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'LOWLV_BOASTER_SQ_20')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_siauliai_16' then
            if GetLayer(self) == 0 then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x,z,-389,-435) <= 70 then
                    return 1; 
                elseif SCR_POINT_DISTANCE(x,z,-396,201) <= 70 then
                    return 1; 
                elseif SCR_POINT_DISTANCE(x,z,654,1145) <= 70 then
                    return 1; 
                elseif SCR_POINT_DISTANCE(x,z,1434,125) <= 70 then
                    return 1; 
                elseif SCR_POINT_DISTANCE(x,z,979,-721) <= 70 then
                    return 1; 
                elseif SCR_POINT_DISTANCE(x,z,54,-945) <= 70 then
                    return 1; 
                else
                    return 0
                end
            end
        end
    end
    return 0; 
end


--THORN39_1_SQ04_ITEM1
function SCR_PRE_THORN39_1_SQ04_ITEM1(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'd_thorn_39_1' then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'THORN39_1_SQ04')
            if result == 'PROGRESS' then
                local list, Cnt = SelectObject(self, 100, 'ENEMY', 1)
                local i 
                for i = 1, Cnt do
                    if list[i].ClassName == 'Pandroceum' then
                        if GetHpPercent(list[i]) <= 0.3 then
                            return GetHandle(list[i])
                        end
                    end
                end
            end
        end
    end
    return 0
end

--THORN39_1_SQ06_ITEM
function SCR_PRE_THORN39_1_SQ06_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'd_thorn_39_1' then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'THORN39_1_SQ06')
            if result == 'PROGRESS' then
                local x, y, z = GetPos(self)
                local sObj = GetSessionObject(self, 'SSN_THORN39_1_SQ06')
                if SCR_POINT_DISTANCE(x, z, 1298, -1288) < 50 then
                    if sObj.Goal1 == 2 then
                    return 0
                    elseif sObj.Goal1 == 0 then
                    return 1
                    end
                elseif SCR_POINT_DISTANCE(x, z, 1443, -1432) < 50 then
                    if sObj.Goal2 == 2 then
                    return 0
                    elseif sObj.Goal2 == 0 then
                    return 1
                    end
                elseif SCR_POINT_DISTANCE(x, z, 1122, -1467) < 50 then
                    if sObj.Goal3 == 2 then
                    return 0
                    elseif sObj.Goal3 == 0 then
                    return 1
                    end
                elseif SCR_POINT_DISTANCE(x, z, 1271, -1603) < 50 then
                    if sObj.Goal4 == 2 then
                    return 0
                    elseif sObj.Goal4 == 0 then
                    return 1
                    end
                end
            end
        end
    end
    return 0;
end

--THORN39_3_SQ07_ITEM
function SCR_PRE_THORN39_3_SQ07_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'd_thorn_39_3' then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'THORN39_3_SQ07')
            if result == 'PROGRESS' then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, 759, -858) < 50 then
                    if isHideNPC(self, 'THORN39_3_SQ07_OBJ1') == 'YES' then
                    return 1
                    else
                    return 0;
                    end
                end
                if SCR_POINT_DISTANCE(x, z, 1366, -1181) < 50 then
                    if isHideNPC(self, 'THORN39_3_SQ07_OBJ2') == 'YES' then
                    return 1
                    else
                    return 0;
                    end
                end
                if SCR_POINT_DISTANCE(x, z, 2062, -822) < 50 then
                    if isHideNPC(self, 'THORN39_3_SQ07_OBJ3') == 'YES' then
                    return 1
                    else
                    return 0;
                    end
                end
            end
        end
    end
    return 0;
end

--PILGRIMROAD362_HIDDENQ1_ITEM3
function SCR_PRE_PILGRIMROAD362_HIDDENQ1_ITEM3(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'f_pilgrimroad_36_2' then
        if GetLayer(self) == 0  then
            return 1;
        end
    end
    return 0
end

--SCR_PRE_PILGRIM48_HIDDENQ1_PREITEM
function SCR_PRE_PILGRIM48_HIDDENQ1_PREITEM(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
        return 1;
    end
    return 0
end


--SCR_PRE_PILGRIM48_HIDDENQ1_ITEM3
function SCR_PRE_PILGRIM48_HIDDENQ1_ITEM3(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM48_HQ1')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_pilgrimroad_49' then
            if GetLayer(self) == 0 then
                return 1;
            end
        end
    end
    return 0;
end

--SCR_PRE_CATHEDRAL1_HIDDENQ1_ITEM1
function SCR_PRE_CATHEDRAL1_HIDDENQ1_ITEM1(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'f_remains_39' then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'CATHEDRAL1_HQ1')
            if result == 'PROGRESS' then
                local list, Cnt = SelectObject(self, 100, 'ALL', 1)
                for i = 1, Cnt do
                    if list[i].ClassName == 'noshadow_npc_8' then
--                        if list[i].Dialog == 'CATHEDRAL1_HIDDEN_NPC_CHAT' then
                            return GetHandle(list[i])
--                        end
                    end
                end
            end
        end
    end
    return 0
end

--SCR_PRE_CATACOMB38_2_HIDDENQ1_ITEM1
function SCR_PRE_CATACOMB38_2_HIDDENQ1_ITEM1(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'id_catacomb_38_2' then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'CATACOMB38_2_HQ1')
            if result == 'PROGRESS' then
                local list, Cnt = SelectObject(self, 100, 'ALL', 1)
                for i = 1, Cnt do
                    if list[i].ClassName == 'Hiddennpc_move' then
--                        if IsServerSection(self) == 1 then
--                            if list[i].Dialog == 'CATACOMB382_HIDDENQ1_SPIRIT' then
--                            if list[i].Faction == "Neutral" then
                                return GetHandle(list[i])
--                            end
--                        end
                    end
                end
            end
        end
    end
    return 0
end



--SCR_PRE_FTOWER692_KQ_1_ITEM
function SCR_PRE_FTOWER692_KQ_1_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'd_firetower_69_2' then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'FTOWER692_KQ_1')
            if result == 'PROGRESS' then
                return 1
            end
        end
    end
    return 0
end


--PILGRIM412_KQ_1
function SCR_PRE_PILGRIM412_KQ_1_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'f_pilgrimroad_41_2' then
        if GetLayer(self) == 0 then 
            
            local result = SCR_QUEST_CHECK(self, 'PILGRIM412_KQ_1')
            if result == 'PROGRESS' then
                return 1
            end
        end
    end
    return 0
end


--LSCAVE521_KQ_1
function SCR_PRE_LSCAVE521_KQ_1_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'd_limestonecave_52_1' then
        if GetLayer(self) == 0 then 
            local result = SCR_QUEST_CHECK(self, 'LSCAVE521_KQ_1')
            if result == 'PROGRESS' then
                return 1
            end
        end
    end
    return 0
end
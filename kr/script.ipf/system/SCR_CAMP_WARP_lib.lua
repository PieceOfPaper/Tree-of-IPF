function SCR_CAMP_WARP(self,pc)
    local sObj_main = GetSessionObject(pc, 'ssn_klapeda')
    if sObj_main ~= nil then
        
        -- 큐폴 특화로 200레벨 이하 존 워프 활성화 시작 --
        if (GetServerNation() == "KOR" and GetServerGroupID() == 9001) then
            local warpList, warpCnt = GetClassList("camp_warp")
            local mapList = GetClassList("Map");
            
            local needSave = 0;
            for i = 0, warpCnt-1 do
                local warpIndex = GetClassByIndexFromList(warpList, i);
                if warpIndex.Zone ~= nil and warpIndex.Zone ~= "None" then
                    local mapIndex = GetClassByNameFromList(mapList, warpIndex.Zone);
                    if mapIndex.WorldMapPreOpen == "YES" and mapIndex.QuestLevel <= 360 then
                        if sObj_main[warpIndex.ClassName] ~= 300 then
                            sObj_main[warpIndex.ClassName] = 300;
                            needSave = needSave + 1;
                        end
                    end
                end
            end
            
            if needSave > 0 then
                SaveSessionObject(pc, sObj_main);
            end
        end
        -- 큐폴 특화로 200레벨 이하 존 워프 활성화 끝 --
        
        local camp_warp_class = GetClass('camp_warp', self.Dialog)
        if sObj_main[self.Dialog] ~= 300 then
            local now_zone = GetClass('Map', camp_warp_class.City)
            
            sObj_main[self.Dialog] = 300
            SaveSessionObject(pc, sObj_main)
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("Auto_KaemPeuKan_iDong_:_")..camp_warp_class.Name..ScpArgMsg("Auto__HwalSeongHwa_{nl}_'woPeu_JuMunSeo'_Sayong_Si_eoDiSeoNa_woPeu_KaNeung!"), 7);
        end
        
        
        
        if camp_warp_class ~= nil then
            gentype_classcount = GetClassCount('camp_warp')
            local result = {}
            if gentype_classcount > 0 then
                for i = 0 , gentype_classcount-1 do
                    local cls = GetClassByIndex('camp_warp', i);
                    if sObj_main[cls.ClassName] == 300 and cls.ClassName ~= camp_warp_class.ClassName then
                        result[#result + 1] = cls
                    end
                end
            end

-- ??????? ?????? ??????? ???? ??? ????o??
--            local city = camp_warp_class.City
--            
--            
--            local result = SCR_GET_XML_IES('camp_warp', 'City', city)
--            local result_temp = {}
--            
--            for index = 1, #result do
--                if sObj_main[result[index].ClassName] == 300 and result[index].ClassName ~= camp_warp_class.ClassName then
--                    result_temp[#result_temp + 1] = result[index]
--                end
--            end
--            
--            result = result_temp
            
            if #result == 0 then
                SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_HwalSeongHwaDoen_KaemPeu_yeoSinSangi_eopeo_JiKeumeun_iDongHaSil_Su_eopSeupNiDa"), 5);
                return
            else
                local result2 = DOTIMEACTION_B(pc, ScpArgMsg('Auto_KyeongBae_Jung'), 'WORSHIP', 1)
                
--                SCR_EV161110(self, pc)
                
                if result2 == 1 then
                    REGISTERR_LASTUIOPEN_POS_SERVER(pc,"worldmap")
                    SetExProp(pc, "WarpFree", 0);
                    ExecClientScp(pc, "INTE_WARP_OPEN_BY_NPC()");
                end
            end
        end
    end
end
        
        
        
--        if camp_warp_class ~= nil then
--                local city = camp_warp_class.City
--                
--                
--                local result = SCR_GET_XML_IES('camp_warp', 'City', city)
--
--                local result_temp = {}
--                
--                for index = 1, #result do
--                    if sObj_main[result[index].ClassName] == 300 and result[index].ClassName ~= camp_warp_class.ClassName then
--                        result_temp[#result_temp + 1] = result[index]
--                    end
--                end
--                
--                result = result_temp
--                
--                if #result == 0 then
--                    SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_HwalSeongHwaDoen_KaemPeu_yeoSinSangi_eopeo_JiKeumeun_iDongHaSil_Su_eopSeupNiDa"), 5);
--                    return
--                end
--                
--                result2 = SCR_DUPLICATION_SOLVE_IES(result, 'Group')
--                
--                
--                local select
--                for y = 0, math.floor(#result2/5) do
--                    local sel_txt = {}
--                    for i = 1, 5 do
--                        if result2[5*y+i] ~= nil then
--                            sel_txt[i] = result2[5*y+i].Group
--                        else
--                            sel_txt[i] = nil
--                        end
--                    end
--                    if y ~= math.floor(#result2/5) then
--                        select = ShowSelDlgDirect(pc, 0, 'CAMP_WARP_SelectGroup', sel_txt[1], sel_txt[2], sel_txt[3], sel_txt[4], sel_txt[5], ScpArgMsg("Auto_NaMeoJi_Jiyeog"),ScpArgMsg("Auto_ChwiSo"))
--                    else
--                        select = ShowSelDlgDirect(pc, 0, 'CAMP_WARP_SelectGroup', sel_txt[1], sel_txt[2], sel_txt[3], sel_txt[4], sel_txt[5],ScpArgMsg("Auto_ChwiSo"))
--                    end
--            
--                    if select == nil then
--                        return
--                    end
--            
--                    if select < 6 and select ~= nil then
--                        select = select + 5*y
--                        break
--                    elseif (y == math.floor(#result2/5) and select == 6) or select == 7 then
--                        return
--                    end
--                end
--                
--                local result_temp2 = {}
--                for index = 1, #result do
--                    if result[index].Group == result2[select].Group  then
--                        result_temp2[#result_temp2 + 1] = result[index]
--                    end
--                end
--                
--                result = result_temp2
--                
--                local select2
--                for y = 0, math.floor(#result/5) do
--                    local sel_txt = {}
--                    for i = 1, 5 do
--                        if result[5*y+i] ~= nil then
--                            sel_txt[i] = result[5*y+i].Name
--                        else
--                            sel_txt[i] = nil
--                        end
--                    end
--                    
--                    if y ~= math.floor(#result/5) then
--                        select2 = ShowSelDlgDirect(pc, 0, 'CAMP_WARP_SelectCamp', sel_txt[1], sel_txt[2], sel_txt[3], sel_txt[4], sel_txt[5], ScpArgMsg("Auto_NaMeoJi_KaemPeu"),ScpArgMsg("Auto_ChwiSo"))
--                    else
--                        select2 = ShowSelDlgDirect(pc, 0, 'CAMP_WARP_SelectCamp', sel_txt[1], sel_txt[2], sel_txt[3], sel_txt[4], sel_txt[5],ScpArgMsg("Auto_ChwiSo"))
--                    end
--            
--                    if select2 == nil then
--                        return
--                    end
--            
--                    if select2 < 6 and select2 ~= nil then
--                        select2 = select2 + 5*y
--                        break
--                    elseif (y == math.floor(#result/5) and select2 == 6) or select2 == 7 then
--                        return
--                    end
--                end
--                
--                
--                local result3 = SCR_GET_MONGEN_ANCHOR(result[select2].Zone, 'Dialog', result[select2].ClassName)
--                
--                if result3 ~= nil then
--                    local zone = GetClass('Map', camp_warp_class.City)
--                    local zone_ClassName = result[select2].Zone
--                    
--                    local posX = result3[1].PosX
--                    local posY = result3[1].PosY + 30
--                    local posZ = result3[1].PosZ
--                    
--                    
--                    if IMCRandom(1,2) == 1 then
--                        posX = posX + IMCRandom(40,60)
--                    else
--                        posX = posX - IMCRandom(40,60)
--                    end
--                    
--                    if IMCRandom(1,2) == 1 then
--                        posZ = posZ + IMCRandom(40,60)
--                    else
--                        posZ = posZ - IMCRandom(40,60)
--                    end
--                    
--                    -- ????? ???
--                    local tx = TxBegin(pc);
--                  local aobj = GetAccountObj(pc);
--                  TxAddIESProp(tx, aobj, "Medal", -1);
--                  local ret = TxCommit(tx);
--                  
--                  -- ???
--                    MoveZone(pc, zone_ClassName, posX, posY, posZ)
--                end
--        end
--    end
--end



--function SCR_EV161110(self, pc)
--    if GetServerNation() ~= 'KOR' then
--        return
--    end
--    if self == nil or (self.Dialog ~= 'WARP_C_FEDIMIAN' and self.Dialog ~= 'WARP_C_KLAIPE' and self.Dialog ~= 'WARP_C_ORSHA') then
--        return
--    end
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local day = now_time['day']
--    local sObj = GetSessionObject(pc, 'ssn_klapeda')
--    if sObj ~= nil then
--        if GetPropType(sObj, 'EV161110_REWARD_DATE') ~= nil then
--            local nowDate = year..'/'..month..'/'..day
--            if sObj.EV161110_REWARD_DATE ~= nowDate then
--                local giveItem = {{'Event_161110_1',1},{'Event_161110_2',1},{'Event_161110_3',1}}
--                local sObjInfo_set = {{'ssn_klapeda','EV161110_REWARD_DATE',nowDate}}
--                GIVE_TAKE_SOBJ_ACHIEVE_TABLE_TX(pc, giveItem, nil, nil, nil, 'EV161110', sObjInfo_set)
--            end
--        end
--    end
--end


function SCR_CAMP_WARP_BY_SKILL(pc)

    local sObj_main = GetSessionObject(pc, 'ssn_klapeda')
    if sObj_main ~= nil then

        local city = 'c_Klaipe' 
        -- ?? ??? ?????? ???ð? ?þ??? ???? ???????. 131128 ??.
                
                
        local result = SCR_GET_XML_IES('camp_warp', 'City', city)

        local result_temp = {}
                
        for index = 1, #result do
            if sObj_main[result[index].ClassName] == 300 then
                result_temp[#result_temp + 1] = result[index]
            end
        end
                
        result = result_temp
                
        if #result == 0 then
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_HwalSeongHwaDoen_KaemPeu_yeoSinSangi_eopeo_JiKeumeun_iDongHaSil_Su_eopSeupNiDa"), 5);
            return
        end
                
        result2 = SCR_DUPLICATION_SOLVE_IES(result, 'Group')
                
                
        local select
        for y = 0, math.floor(#result2/5) do
            local sel_txt = {}
            for i = 1, 5 do
                if result2[5*y+i] ~= nil then
                    sel_txt[i] = result2[5*y+i].Group
                else
                    sel_txt[i] = nil
                end
            end
            if y ~= math.floor(#result2/5) then
                select = ShowSelDlgDirect(pc, 0, 'CAMP_WARP_SelectGroup', sel_txt[1], sel_txt[2], sel_txt[3], sel_txt[4], sel_txt[5], ScpArgMsg("Auto_NaMeoJi_Jiyeog"),ScpArgMsg("Auto_ChwiSo"))
            else
                select = ShowSelDlgDirect(pc, 0, 'CAMP_WARP_SelectGroup', sel_txt[1], sel_txt[2], sel_txt[3], sel_txt[4], sel_txt[5],ScpArgMsg("Auto_ChwiSo"))
            end
            
            if select == nil then
                return
            end
            
            if select < 6 and select ~= nil then
                select = select + 5*y
                break
            elseif (y == math.floor(#result2/5) and select == 6) or select == 7 then
                return
            end
        end
                
        local result_temp2 = {}
        for index = 1, #result do
            if result[index].Group == result2[select].Group  then
                result_temp2[#result_temp2 + 1] = result[index]
            end
        end
                
        result = result_temp2
                
        local select2
        for y = 0, math.floor(#result/5) do
            local sel_txt = {}
            for i = 1, 5 do
                if result[5*y+i] ~= nil then
                    sel_txt[i] = result[5*y+i].Name
                else
                    sel_txt[i] = nil
                end
            end
                    
            if y ~= math.floor(#result/5) then
                select2 = ShowSelDlgDirect(pc, 0, 'CAMP_WARP_SelectCamp', sel_txt[1], sel_txt[2], sel_txt[3], sel_txt[4], sel_txt[5], ScpArgMsg("Auto_NaMeoJi_KaemPeu"),ScpArgMsg("Auto_ChwiSo"))
            else
                select2 = ShowSelDlgDirect(pc, 0, 'CAMP_WARP_SelectCamp', sel_txt[1], sel_txt[2], sel_txt[3], sel_txt[4], sel_txt[5],ScpArgMsg("Auto_ChwiSo"))
            end
            
            if select2 == nil then
                return
            end
            
            if select2 < 6 and select2 ~= nil then
                select2 = select2 + 5*y
                break
            elseif (y == math.floor(#result/5) and select2 == 6) or select2 == 7 then
                return
            end
        end
                
                
        local result3 = SCR_GET_MONGEN_ANCHOR(result[select2].Zone, 'Dialog', result[select2].ClassName)
                
        if result3 ~= nil then
            local zone = GetClass('Map', city) -- ????
            local zone_ClassName = result[select2].Zone
                    
            local posX = result3[1].PosX
            local posY = result3[1].PosY + 30
            local posZ = result3[1].PosZ
                    
                    
            if IMCRandom(1,2) == 1 then
                posX = posX + IMCRandom(40,60)
            else
                posX = posX - IMCRandom(40,60)
            end
                    
            if IMCRandom(1,2) == 1 then
                posZ = posZ + IMCRandom(40,60)
            else
                posZ = posZ - IMCRandom(40,60)
            end
                    
            -- ????? ???
            local useMedal = 1;
            local tx = TxBegin(pc);
            local aobj = GetAccountObj(pc);
            TxAddIESProp(tx, aobj, "Medal", -useMedal,"WarpSkill");
            local ret = TxCommit(tx);

            if ret == 'SUCCESS' then
                -- ???
                SetSafe(pc, 1);
                EnableControl(pc, 0, "CAMP_WARP_BY_SKILL");
                BroadcastClientScript(pc, "RUN_INTE_WARP");
                
                sleep(2000);
                
                MoveZone(pc, zone_ClassName, posX, posY, posZ, 'Camp')
                SetSafe(pc, 0)
                EnableControl(pc, 1, "CAMP_WARP_BY_SKILL");

                return 1;
            end           
            return 0;
        end
        
    end
end


function SCR_TUTO_CAMPEWARP_SENDADDONMSG(pc, state)
    if state == 1 then
        sleep(4000)
        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("Auto_2._SyaulLei_SeonTaeg__SyaulLei_SeoJjog_Sup_SeonTaeg"), 5);
    end
end


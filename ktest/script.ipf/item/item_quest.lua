function SCR_USEITEM_QUESTSTART(self,argstring,arg1,arg2)
    SCR_QUEST_POSSIBLE(self, argstring)
--    local questIES = GetClass('QuestProgressCheck', argstring)
--    if questIES ~= nil then
--        local sObj = GetSessionObject(self, 'ssn_klapeda')
--        if sObj[questIES.QuestPropertyName] < CON_QUESTPROPERTY_MIN then
--            SCR_QUEST_POSSIBLE(self, argstring)
--        end
--    end
end

function SCR_USE_ITEM_InviteTheBishop_Box(self,argstring,arg1,arg2)
    local tx = TxBegin(self);
	TxGiveItem(tx, 'BishopRoom_Key', 1, "Bag");
	local ret = TxCommit(tx);
end


function SCR_FOLEMMAGICITEM(self,argObj, argstring, arg1, arg2)

	local _success = RESULT_NO;
	local fndList, fndCount = SelectObject(self, 60, 'ALL');
	for i = 1, fndCount do
		if fndList[i].ClassName == 'boss_Golem'  then
			local _golem = fndList[i];
			local _isWeaken = IsBuffApplied(_golem, 'Weaken');
			if _isWeaken ~= RESULT_OK then
				
				SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('Auto_MaLyeog_PogPungui_yeongHyangeuLo_KolLemi_yagHwa_DoeeossSeupNiDa.'), 3);

				PlayEffect(_golem, 'F_burstup028_fire');
				PlayEffect(_golem, 'explosion_burst');
				PlayEffect(_golem, 'explosion_c1');
				PlayEffect(_golem, 'F_ground095_circle');

				local _moveResult = IsMoving(_golem);
				if _moveResult == 1 then
					StopMove(_golem);
				end
				local _sklResult = IsSkillUsing(_golem);
				if _sklResult == 1 then
					SkillCancel(_golem);
				end
				SCR_MON_LIB_HOLD(_golem, 3);
				PlayAnim(_golem, 'KNOCKDOWN', 0, 1);

				_success = RESULT_OK;
			end
		end
	end

	if _success ~= RESULT_OK then
		SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('Auto_aMu_ilDo_ileoNaJi_anassDa.'), 3);
	end

end


function SCR_CalmIncense (self,argObj, argstring, argnum1, argnum2)
	    PlayEffect(argObj, 'F_smoke099_white')
      	RemoveBuff(argObj, "Transparent");
   	    SetCurrentFaction(argObj, 'Monster')

end

function SCR_USE_Cmine8_9_WarpScroll (self,argObj, argstring, argnum1, argnum2)
    if GetZoneName(self) == 'd_cmine_9' then
        Warp(self, 'WS_SIAULST3_CMINE8')
    elseif GetZoneName(self) == 'd_cmine_8' then
        Warp(self, 'WS_CMINE8_CMINE9')
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_KaeBangDoen,_PyeSwaeDoen_SuJeongKwangSaneSeoMan_SayongKaNeung"), 3);
    end
end


function SCR_QUESTE_START_ITEM(self,argObj, argstring, argnum1, argnum2)
    local quest_state = SCR_QUEST_CHECK(self,argstring)

    if quest_state == 'POSSIBLE' then
        SCR_QUEST_POSSIBLE_AGREE(self, argstring)
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_aMu_HyoKwa_eopeum"), 3);
    end
--
--    local main_ssn = GetSessionObject(self, 'ssn_klapeda')
--    if main_ssn ~= nil then
--        if main_ssn[argstring] ~= 0 then
--            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_aMu_HyoKwa_eopeum"), 3);
--        else
--            SCR_QUEST_POSSIBLE_AGREE(self, argstring)
--        end
--    end
end


function SCR_USE_VACYS_RECORD(self)
    local result = SCR_QUEST_CHECK(self, 'ROKAS29_VACYS9')
    if result == 'PROGRESS' then
        SCR_QUEST_SUCCESS(self, 'ROKAS29_VACYS9')
    end
end

function SCR_USE_ROKAS30_PIPOTI_MAP(self,argObj, strArg, numArg1, humarg2, itemClassID, itemID)
    if GetZoneName(self) == 'f_rokas_30' then
        for i = 2, 5 do
            local sObj_main = GetSessionObject(self, 'ssn_klapeda')
            if sObj_main ~= nil and GetPropType(sObj_main, 'ROKAS30_PIPOTI0'..i) ~= nil then
                local result = SCR_QUEST_CHECK(self, 'ROKAS30_PIPOTI0'..i)
                if result == 'POSSIBLE' then
                    if i == 2 then
                        TreasureMarkByMap(self, 'f_rokas_30', 359, 402, 1078)
                    elseif i == 3 then
                        TreasureMarkByMap(self, 'f_rokas_30', -239, 348, 727)
                    elseif i == 4 then
                        TreasureMarkByMap(self, 'f_rokas_30', 36, 215, -310)
                    elseif i == 5 then
                        TreasureMarkByMap(self, 'f_rokas_30', -1550, 215, -426)
                    end
                    break
                end
            end
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ROKAS_30_PIPOTI_MAP_ZONE_CHECK"), 5)
    end
end



function SCR_USE_Act4_Purify(self,argObj, x, y, z)
    local zinstID = GetZoneInstID(self);
    if IsValidPos(zinstID,x,y,z) == 'YES' then
        local iesObj = CreateGCIES('Monster', 'HiddenTrigger4');

        iesObj.Faction = 'Neutral'
        iesObj.Tactics = 'MON_ACT4_PURIFY'

        local mon = CreateMonster(self, iesObj, x, y, z, 0, 1);
        if mon ~= nil then
            SetLayer(mon,GetLayer(self))
            SetOwner(mon, self, 0)
        end
    end
end

function SCR_USE_MINE_1_Charge_Scroll_1(self,argObj, strArg, numArg1, numArg2)

   local x, y, z = GetPos(self);

    local zinstID = GetZoneInstID(self);
    local iesObj = CreateGCIES('Monster', 'HiddenTrigger2');

    iesObj.Faction = 'Neutral'
    iesObj.Tactics = 'MON_ACT4_PURIFY'

    local mon = CreateMonster(self, iesObj, x, y, z, 0, 1);
    
    if mon ~= nil then
        local sObj = GetSessionObject(self, 'SSN_MINE_1_CRYSTAL_4')
        if sObj ~= nil then
            if sObj.Goal1 == 0 then
                sObj.Goal1 = 300
            end
        end
    end
    
	ShowGroundMark(self, x, y, z, 230, 10);

end





function SCR_USE_ROKAS31_Q12(self,argObj, argstring, argnum1, argnum2)
    SendAddOnMsg(self, "NOTICE_Dm_!", argObj.Name..ScpArgMsg("Auto__:_SeuTeone_KeolLyeossSeupNiDa!_CheoChiHaSeyo"), 3);
    AddBuff(self, argObj,'Stun', 1, 0, 8000, 1)
    
end


function SCR_USE_KATYN10_OWL(self, argObj, argstring, argnum1, argnum2)
    local quest_ssn = GetSessionObject(self, 'SSN_KATYN10_MQ_05')
    if quest_ssn ~= nil then
        if argObj.ClassName == 'boss_Sequoia_sleep' then
            PlayAnim(argObj,'WAKEUP', 1)
            if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoMaxCount1
            end
            RunScript('SCR_USE_KATYN10_OWL_SLEEP',self, argObj, argstring, argnum1, argnum2)
        end
    end
end

function SCR_USE_KATYN10_OWL_SLEEP(self, argObj, argstring, argnum1, argnum2)
    PlayEffect(argObj, 'F_archer_broadhead_shot_light', 0.3)
    sleep(1300)
    PlayAnim(argObj, 'ASTD', 1)
    RunSimpleAIOnly(argObj, 'KATYN10_SLEEPER_01')
    sleep(3000)
    PC_LAYER_RUN(self)
end



function SCR_USE_KATYN10_OWL2(self, argObj, argstring, argnum1, argnum2)
    local quest_ssn = GetSessionObject(self, 'SSN_KATYN10_MQ_13')
    if quest_ssn ~= nil then
        if argObj.ClassName == 'boss_Sequoia_sleep' then
            PlayAnim(argObj,'WAKEUP', 1)
            if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoMaxCount1
            end
            RunScript('SCR_USE_KATYN10_OWL2_SLEEP',self, argObj, argstring, argnum1, argnum2)
        end
    end
end

function SCR_USE_KATYN10_OWL2_SLEEP(self, argObj, argstring, argnum1, argnum2)
    PlayEffect(argObj, 'F_archer_broadhead_shot_light', 0.3)
    sleep(1300)
    PlayAnim(argObj, 'ASTD', 1)
    RunSimpleAIOnly(argObj, 'KATYN10_SLEEPER_02')
    sleep(3000)
    PC_LAYER_RUN(self)
end



function SCR_USE_KATYN10_OWL3(self, argObj, argstring, argnum1, argnum2)
    local quest_ssn = GetSessionObject(self, 'SSN_KATYN10_MQ_27')
    if quest_ssn ~= nil then
        if argObj.ClassName == 'boss_Sequoia_sleep' then
            PlayAnim(argObj,'WAKEUP', 1)
            if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoMaxCount1
            end
            RunScript('SCR_USE_KATYN10_OWL3_SLEEP',self, argObj, argstring, argnum1, argnum2)
        end
    end
end
function SCR_USE_KATYN10_OWL3_SLEEP(self, argObj, argstring, argnum1, argnum2)
    PlayEffect(argObj, 'F_archer_broadhead_shot_light', 0.3)
    sleep(1300)
    PlayAnim(argObj, 'ASTD', 1)
    RunSimpleAIOnly(argObj, 'KATYN10_SLEEPER_03')
    sleep(3000)
    PC_LAYER_RUN(self)
end




function SCR_USE_SIAULIAI11_SoulPrisonScroll(self,argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'SIAULIAI11_ADDQUEST5')
    if result == 'PROGRESS' then
        if argObj.StrArg1 == 'None' then
            SetEmoticon(argObj, 'I_emo_toxiceffect')
            argObj.StrArg1 = 'SIAULIAI11_ADDQUEST5'
            InsertHate(argObj, self, 1)
            AttachEffect(argObj, 'I_spread_out001_light', 2, "MID")
        end
    end
end

function SCR_USE_ROKAS31_SUB_03_SCROLL(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'ROKAS31_SUB_03')
    if result == 'PROGRESS' then
        if argObj.StrArg1 == 'None' then
            argObj.StrArg1 = 'ROKAS31_SUB_03'
            InsertHate(argObj, self, 1)
            AttachEffect(argObj, 'I_smoke008_red', 2, "BOT")
        end
    end
end


function SCR_USE_JOB_PSYCHOKINESIST2_2_ITEM1(self,argObj, argstring, arg1, arg2)
    if argObj.StrArg1 == 'JOB_PSYCHOKINESIST2_2' then
        Dead(argObj)
        RunMGame(self, "JOB_PSYCHOKINESIST2_2_mini")
--        SCR_CREATE_SSN_MON_SUMMON_FUN(self, 4000, '2/4', ScpArgMsg("Auto_Matsum:MeSyum:50/Matsum:MeSyum:50/Matsum:MeSyum:50/Matsum_Big:MeSyumMa:51"), 'Random', nil, 250, 15, self)
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_MolLyeoDeuNeun_MeSyum_CheoChi"), 5);
        local result = SCR_QUEST_CHECK(self, 'JOB_PSYCHOKINESIST2_2')
        if result == 'PROGRESS' then
            local quest_sObj = GetSessionObject(self, 'SSN_JOB_PSYCHOKINESIST2_2')
            
            if quest_sObj ~= nil then
                if quest_sObj.QuestInfoValue1 < quest_sObj.QuestInfoMaxCount1 then
                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_PSYCHOKINESIST2_2', 'QuestInfoValue1', 1)
                end
            end
        end
    end
end

function SCR_USE_JOB_PYROMANCER2_1_ITEM1(self,argObj, argstring, arg1, arg2)
--    print(self.ClassName,argObj, argstring, arg1, arg2)
    local Sobj = GetSessionObject(self, "SSN_JOB_PYROMANCER2_1")
    local zoneID = GetZoneInstID(self)
    local pos_list = SCR_CELLGENPOS_LIST(self, 'Front2', 0)
    if #pos_list > 0 then
        for i = 1, #pos_list do
            if IsValidPos(zoneID, pos_list[i][1], pos_list[i][2], pos_list[i][3]) == 'YES' then
            local pos = IsValidPos(zoneID, pos_list[i][1], pos_list[i][2], pos_list[i][3])
            local Result = DOTIMEACTION_R(self, ScpArgMsg("JOB_PYROMANCER2_1_ITEM1_USE"), 'MAKING', 3)
                if Result == 1 then
                local npc = CREATE_MONSTER(self, 'rokas_pot2', pos_list[i][1], pos_list[i][2], pos_list[i][3], 0, 'Law', 0, 45, nil, ScpArgMsg("Auto_Bului_HangaLi"), nil, 2000, 50, nil)
                    if npc ~= nil then
--                            SCR_CREATE_SSN_MON_SUMMON_FUN(npc, 6000, '1/4', ScpArgMsg("JOB_PYROMANCER2_1"), 'Random', nil, 250, 40, npc, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'ssn_smartgen_mon', 'None')
                        SetExArgObject(npc, 'OWNER', self)
                        CreateSessionObject(npc, 'SSN_JOB_PYROMANCER2_1_MON')
                        Sobj.Step1 = 1
                    end
                end
            end
        end
    end
end

function MONGEN_TIMER(self)
    local Mon_sObj = GetSessionObject(self, "SSN_SMARTGEN_MON")
end

function SCR_USE_JOB_PYROMANCER3_1_ITEM1(self,argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'JOB_PYROMANCER3_2')
    local zoneID = GetZoneInstID(self)
    if result == 'PROGRESS' then
        local pos_list = SCR_CELLGENPOS_LIST(self, 'Front2', 0)
        if #pos_list > 0 then
            for i = 1, #pos_list do
                if IsValidPos(zoneID, pos_list[i][1], pos_list[i][2], pos_list[i][3]) == 'YES' then
                    local Result = DOTIMEACTION_R(self, ScpArgMsg("JOB_PYROMANCER2_1_ITEM1_USE"), 'MAKING', 3)
                    if Result == 1 then
                        local x,y,z = GetPos(self)
                        local npc = CREATE_MONSTER(self, 'rokas_pot2', pos_list[i][1], pos_list[i][2], pos_list[i][3], 0, 'Neutral', 0, 50, nil, ScpArgMsg("Auto_Taeyangui_JeongSu"), nil, 2000, 50)
                        
                        if npc ~= nil then
                            PlayEffect(npc, 'I_pc_standthrow_force', 1, 'MID')
                            PlayEffect(npc, 'F_spread_in011_yellow', 2, 'TOP')
                            local quest_sObj = GetSessionObject(self, 'SSN_JOB_PYROMANCER3_2')
                            
                            if quest_sObj ~= nil then
                                if quest_sObj.QuestInfoValue1 < quest_sObj.QuestInfoMaxCount1 then
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_PYROMANCER3_2', 'QuestInfoValue1', 1)
                                    SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("Auto_Taeyangui_JeongSu_BaeChi_wanLyo!"), 3);
                                end
                            end
                            CreateSessionObject(npc, 'SSN_COUNTDOWN_KILL')
                        end
                    end
                end
            end
        end
    end
end

function SCR_USE_JOB_KRIVI2_1_ITEM1(self,argObj, argstring, arg1, arg2)
    local info = {{'f_siauliai_west','statue_vakarine'}
                    ,{'f_siauliai_west','statue_zemina'}
                    ,{'f_siauliai_2','statue_vakarine'}
                    ,{'f_siauliai_out','statue_vakarine'}
                    ,{'f_siauliai_out','statue_zemina'}
                }
    local zone = GetZoneName(self)
    local npcClassName = argObj.ClassName
    LookAt(self, argObj)
    
    local index = 0
    for i = 1, 10 do
        if zone == info[i][1] and npcClassName == info[i][2] then
            index = i
            break
        end
    end
    
    if index > 0 then
        local result = DOTIMEACTION_R_FAILTIME_SET(self, 'JOB_KRIVI2_1', ScpArgMsg("Auto_Kongyang_Jung"), 3, 'WORSHIP')
        if result == 1 then
            local result2 = SCR_QUEST_CHECK(self, 'JOB_KRIVI2_1')
            if result2 == 'PROGRESS' then
                local quest_sObj = GetSessionObject(self, 'SSN_JOB_KRIVI2_1')
                
                if quest_sObj ~= nil then
                    if quest_sObj['QuestInfoValue'..index] < quest_sObj['QuestInfoMaxCount'..index] then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_KRIVI2_1', 'QuestInfoValue'..index, 1)
                        PlayEffect(self, 'F_lineup010_ground', 0.4)
                    else
                        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("Auto_iMi_Kongyangeul_DeuLyeossSeupNiDa!"), 5);
                    end
                end
            end
        end
    end
end

function SCR_USE_JOB_WIZARD2_2_ITEM1(self,argObj, argstring, arg1, arg2)
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
                local index = 0
                for i = 1, 5 do
                    if SCR_POINT_DISTANCE(x,z,info[i][1],info[i][3]) <= info[i][4] then
                        index = i
                        break
                    end
                end
                if index > 0 then
                    local quest_sObj = GetSessionObject(self, 'SSN_JOB_WIZARD2_2')
                    
                    if quest_sObj ~= nil then
                        if quest_sObj['QuestInfoValue'..index] < quest_sObj['QuestInfoMaxCount'..index] then
                            local Result = DOTIMEACTION_R(self, ScpArgMsg("JOB_WIZARD2_2_ITEM1_USE"), 'MAKING', 2);
                            if Result == 1 then
                                PlayEffectToGround(self, 'F_ground056', x, y, z, 1, 5000)
                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_WIZARD2_2', 'QuestInfoValue'..index, 1)
                                
                                quest_sObj['QuestMapPointView'..index] = 0;
                                SaveSessionObject(self, quest_sObj)
                            end
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("Auto_iMi_SilDeuLeul_SayongHan_JiyeogipNiDa!"), 5);
                        end
                    end
                end
            end
        end
    end
end

function SCR_USE_JOB_WIZARD3_2_ITEM1(self,argObj, argstring, arg1, arg2)
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
                local index = 0
                for i = 1, 3 do
                    if SCR_POINT_DISTANCE(x,z,info[i][1],info[i][3]) <= info[i][4] then
                        index = i
                        break
                    end
                end
                if index > 0 then
                    local quest_sObj = GetSessionObject(self, 'SSN_JOB_WIZARD3_2')
                    
                    if quest_sObj ~= nil then
                        if quest_sObj['QuestInfoValue'..index] < quest_sObj['QuestInfoMaxCount'..index] then
                            PlayEffectToGround(self, 'F_ground056', x, y, z, 1, 5000)
                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_WIZARD3_2', 'QuestInfoValue'..index, 1)
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("Auto_iMi_SilDeuLeul_SayongHan_JiyeogipNiDa!"), 5);
                        end
                    end
                end
            end
        end
    end
end

function SCR_USE_CMINE_DIARY_TOOL(self,argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'd_cmine_6' then
        local sObj_diary = GetSessionObject(self, 'SSN_CMINE_DIARY')
        if sObj_diary ~= nil then
            local x = sObj_diary.PosX
            local y = sObj_diary.PosY
            local z = sObj_diary.PosZ
            
            local zoneInstID = GetZoneInstID(self)
            local posIES
            while 1 do
                local pcX, pcY, pcZ = GetPos(self)
                local dist = SCR_POINT_DISTANCE(-830, 282, pcX, pcZ)
                if IsValidPos(zoneInstID, x, y, z) == 'YES' and dist >= 300 then
                    sObj_diary.PosX = x
                    sObj_diary.PosY = y
                    sObj_diary.PosZ = z
                    SaveSessionObject(self, sObj_diary)
                    break
                else
                    posIES = SCR_RANDOM_ZONE_ANCHORIES('d_cmine_6')
                    x = posIES.PosX
                    y = posIES.PosY
                    z = posIES.PosZ
                end
            end
            
--            print('TEST!!!', x,y,z)
            
            local result = DOTIMEACTION_R(self, ScpArgMsg("Auto_TamSaeg_Jung"), '#SITGROPESET', 3)
            if result == 1 then
                local PosX,PosY,PosZ = GetPos(self)
                local result = SCR_POINT_DISTANCE(x,z,PosX,PosZ)
                if result <= 100 then
                    local sObj_main = GetSessionObject(self, 'ssn_klapeda')
                    if sObj_main ~= nil then
                        if sObj_main.CMINE_DIARY_05 == 0 then
                            sObj_main.CMINE_DIARY_05 = 1
                            GIVE_TAKE_ITEM_TX(self, 'CMINE_DIARY_5/1', 'CMINE_DIARY_TOOL/1', 'Quest')
                            SaveSessionObject(self, sObj_main)
                            ShowBalloonText(self, "CMINE_DIARY_TOOL_SUCCESS", 5)
                        end
                    end
                else
                    Chat(self, ScpArgMsg("Auto_MogPyoKkaJi_KeoLi_:_")..result)
                end
            end
        end
    else
        ShowBalloonText(self, "CMINE_DIARY_TOOL_FAIL1", 5)
    end
end

--function SCR_USE_JOB_SAPPER3_2_ITEM1(self,argObj, argstring, arg1, arg2)
--    if argObj ~= nil then
--        local fndList, fndCount = SelectObject(self, 80, 'ALL', 1);
--    	local i
--    	local flag = 0
--    	if fndCount > 0 then
--    	    
--    	    --PlayAnim(self, "PUBLIC_THROW")
--            local x, y, z = GetFrontPos(self, 60);
--        	local fndList1, fndCount1 = SelectObjectPos(self, x, y, z, 30, "ALL")
--        	MslThrow(self, "I_light001#Bip01 R Finger02", 3.0, x, y, z, 10, 0.1, 0.1, 1, 0.8, "F_wizard_countdown_shot_explosion", 1, 0.5);
----        	MslThrow(self, eftName, eftScale, x, y, z, range, flyTime, delayTime, gravity, spd, endEftName, endScale, eftMoveDelay);
--            sleep(600)
--        	for i = 1, fndCount do
--        	    if GetCurrentFaction(fndList[i]) == 'Monster' then
--            	    for i= 1, fndCount1 do
--                	    if GetCurrentFaction(fndList1[i]) == 'Monster' then
--    --            	        PlayExpEffect(fndList[i], self, 'stamina', 75)
--                	        local angle = GetAngleTo(self, fndList1[i]);
--                            local dam = math.floor(fndList1[i].MHP / 20)
----                            PlayEffect(fndList[i], 'F_wizard_countdown_shot_explosion', 1, 1, 'MID')
--                            TakeDamage(self, fndList1[i], "None", dam, 1, "None", "None", "None", HIT_REFLECT, HITRESULT_BLOW)
--                            KnockBack(fndList1[i], self, 150, angle, 45, 1)
--                            
--                            flag = flag + 1
--                        end
--                    end
--            	end
--        	end
--        end
--        
--        if flag > 0 then
--            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_SAPPER3_2', 'QuestInfoValue1', 1)
--        end
--    end
--end

function SCR_USE_KATYN71_DUMMY01(self, argObj, argstring, argnum1, argnum2)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'dummy_carving', x, y, z, -45, 'Our_Forces', self.Lv, KATYN71_DUMMY01_MON);
    SetLifeTime(mon, 25)
    
--    local boss = CREATE_MONSTER(self, "dummy_carving", x, y, z, -45, "Our_Forces", newlayer, 28, 'KATYN71_DUMMY_01', ScpArgMsg("Auto_DeDeuBon_MiKki"), nil, 100, 25, nil, nil, 'Dummy')
end

function  KATYN71_DUMMY01_MON(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'KATYN71_DUMMY_01'
end

function SCR_USE_KATYN71_DUMMY02(self, argObj, argstring, argnum1, argnum2)
--    local quest_ssn = GetSessionObject(self, "SSN_KATYN71_MQ_04")
--    local dummy = GetArgObj1(quest_ssn)
--    if dummy == nil then
        local x, y, z = GetPos(self)
        local boss = CREATE_MONSTER(self, "dummy_carving", x, y, z, -45, "Our_Forces", newlayer, 28, 'KATYN71_DUMMY_02', ScpArgMsg("Auto_DeDeuBon_MiKki"), nil, 100, 25, nil, nil, 'Dummy')
        SCR_SCRIPT_PARTY("KATYN71_DUMMY02_UES",1, self, boss, "SSN_KATYN71_MQ_04")
--    else
--        SCR_SCRIPT_PARTY("KATYN71_MQ_04_CK_MSG", 1, self, "NOTICE_Dm_scroll", ScpArgMsg("KATYN71_DUMMY02_MSG1"),3)
--    end
end

function KATYN71_DUMMY02_UES(self, mon, quest_ssn)
    --print("111111111")
    local sObj = GetSessionObject(self, quest_ssn)
    SetArgObj1(sObj, mon)
end

function SCR_USE_THORN_RAIDE_ITEM(self, argObj, argstring, argnum1, argnum2)
    RunScript('THORN_RAID_ITEM_RUN', self)

end


function SCR_USE_ROKAS24_SQ_01_ITEM(self, argObj, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'ROKAS24_SQ_01')
    if result == 'PROGRESS' then
        if argObj.StrArg1 == 'None' then
            --print(self)
            local ran = IMCRandom(1, 5)
            if ran < 3 then
                RunScript('GIVE_ITEM_TX_QUEST', self, item, count, 'Q_ROKAS24_SQ_01')
                Kill(argObj)
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg('Auto_PiNoLeul_JapassDa.'), 5);
                local quest_sObj = GetSessionObject(self, 'SSN_ROKAS24_SQ_01')
                if quest_sObj ~= nil then
                    if quest_sObj.QuestInfoValue1 < quest_sObj.QuestInfoMaxCount1 then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ROKAS24_SQ_01', 'QuestInfoValue1', 1)
                    end
                end
            else if ran >= 3 then
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg('Auto_PiNoui_JeoHangi_SimHae_NohChyeossDa.'), 30);
            end
            end
        end
    end
end

function GIVE_ITEM_TX_QUEST(self, item, count, giveway)
    local tx = TxBegin(self);
	TxGiveItem(tx, 'ROKAS_24_PINO', 1, giveway);
	local ret = TxCommit(tx);
end

function SCR_USE_REMAIN38_SQ03(self, argstring, argnum1, argnum2)
    local sObj = GetSessionObject(self, 'SSN_REMAIN38_SQ03')
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'rokas_pot1', x, y, z, -45, 'Neutral', self.Lv, REMAIN38_SQ03_MON);
    SetLifeTime(mon, 25)
    SetArgObj1(sObj, mon)
end

function REMAIN38_SQ03_MON(mon)
    mon.Name = ScpArgMsg("Auto_MaBeop_HangaLi")
--    mon.SimpleAI = ' '
end


function SCR_USE_REMAINS40_MQ_06_ITEM(self, argObj, StringArg, argnum1, argnum2)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Firetower_GateOpen', x, y, z, GetDirectionByAngle(self), 'Our_Forces', 87, SET_REMAINS40_MON);
	SetOwner(mon, self, 1);
	SetLifeTime(mon, 60000);
	local sObj = GetSessionObject(self, "SSN_REMAINS40_MQ_06")
	SetArgObj1(sObj, mon)
end

function SET_REMAINS40_MON(mon)
    mon.SimpleAI = "REMAINS40_MQ_06"
	mon.BTree = "None";
	mon.Tactics = "None";
--	mon.MHP = 2500
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("Auto_powerful_pot_01");
end





function SCR_USE_FTOWER41_MQ_04_ITEM(self,argObj, strArg, numArg1, numArg2)
    FTOWER41_MQ_04_RUN(self,argObj, strArg, numArg1, numArg2)
end





function SCR_USE_FTOWER42_MQ_01_ITEM(self, argObj, argstring, argnum1, argnum2)
    local result = SCR_QUEST_CHECK(self, 'FTOWER42_MQ_01')
    if result == 'PROGRESS' then
        local sObj = GetSessionObject(self, "SSN_FTOWER42_MQ_01")
        local fndList, fndCount = SelectObject(self, 200, 'ALL', 1);
        local i
        if fndCount > 0 then
            for i = 1, fndCount do
                if fndList[i].ClassName ~= 'PC' then
                    if fndList[i].Dialog == 'FTOWER42_MQ_01_STONE' then
                        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("FTOWER42_MQ_01_ITEM_MSG1"), 5);
                        return 0;
                    end
                end
            end
        end
        
        if IMCRandom(1, 3) == 1 then
            local x, y, z = GetFrontPos(self, 60)
            local mon = CREATE_MONSTER_EX(self, 'spell_crystal_gem_red', x, y, z, GetDirectionByAngle(self), 1, self.Lv, SCR_FTOWER42_MQ_01_STONE_SET);
            SetLifeTime(mon, 30);
            PlayEffect(mon, 'F_buff_basic011_green', 1.0)
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("FTOWER42_MQ_01_ITEM_MSG2"), 5);
        else
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("FTOWER42_MQ_01_ITEM_MSG3"), 5);
        end
    end
end

function SCR_USE_FTOWER_FIRE_ESSENCE(self, argObj, argstring, argnum1, argnum2)
	local result2 = DOTIMEACTION_R(self, ScpArgMsg("Auto_PuleoNohNeun_Jung"), 'MAKING', 1.5);
	if result2 == 1 then
        local x, y, z = GetFrontPos(self, 20);
        local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x, y, z, GetDirectionByAngle(self), 'Our_Forces', self.Lv, FTOWER42_MQ_01_ITEM_02_NPC);
        SET_NPC_BELONGS_TO_PC(mon, self)
        SetLifeTime(mon, 60);
    end
end

function SCR_USE_THORN19_MQ02_POCKET(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'THORN19_MQ03')
    if result == 'PROGRESS' then
        if argObj.StrArg1 == 'None' then
            LookAt(argObj, self)
            PlayAnim(self, 'MAKING')
--            local result = DOTIMEACTION_R(self, ScpArgMsg("Auto_Installation"), 'MAKING', 1)
--            if result == 1 then
                AddBuff(self, argObj, 'Slow', 1, 0, 10000, 1)
                argObj.StrArg1 = 'THORN19_MQ03_OIL_GET'
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('Auto_THORN19_MQ_MQ02_POCKET_USE'), 4);
--            end
        end
    end
end

function SCR_USE_THORN19_MQ05_BODFLUIDS(self,argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'THORN19_MQ07')
    if result == 'PROGRESS' then
        AttachEffect(argObj, 'F_explosion064', 3, 'BOT')
        local x, y, z = GetPos(argObj)
        Kill(argObj)
        local mon = CREATE_MONSTER(self, 'varv', x+15, y+15, z, 0, 'Monster', GetLayer(self), 25);
        SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('Auto_Lantern_mushroom_mini_appear'), 4);
        CreateSessionObject(mon, 'SSN_THORN19_MQ07_VARV')
    end
end

function SCR_USE_THORN20_MQ05_THORNDRUG(self,argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'THORN20_MQ06')
    local result1 = SCR_QUEST_CHECK(self, 'THORN20_MQ07')
    if result == 'PROGRESS' or result1 == 'PROGRESS' then
        local result_Dotimeaction = DOTIMEACTION_R(self, ScpArgMsg("Auto_THORNFLOWER_USE_AFTER"), 'DRINK', 1)
        if result_Dotimeaction == 1 then
            PlayEffect(self, "F_buff_Cleric_Cure_Buff", 2, 1, "MID")
            RemoveBuff(self, "Weaken")
        end
    end
end

function SCR_USE_CHAPLE576_MQ_07(self,argObj, argstring, arg1, arg2)
    local list, cnt = SelectObjectByFaction(self, 80, 'Monster')
    local i
    for i = 1, cnt do
        AddBuff(self, list[i], 'CHAPLE576_MQ_07_01', 1, 0, 10000, 1)
        PlayEffect(list[i], 'F_archer_crossarrow_shot_light', 3, 1, 'MID', 1)
        KnockDown(list[i], self, 150, GetAngleTo(self, list[i]), 45, 1)
    end
    PlayEffect(self, 'F_explosion004_blue', 0.3, 1, 'MID')
    PlayEffect(self, 'F_ground095_circle', 5, 1, 'BOT', 1)
end


function SCR_USE_THORN20_MQ05_DRUG(self,argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'THORN20_MQ05')
    if result == 'PROGRESS' then
        local result_Dotimeaction = DOTIMEACTION_R(self, ScpArgMsg("Auto_THORNFLOWER_DRUG"), 'MAKING', 4)
        if result_Dotimeaction == 1 then
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN20_MQ05', 'QuestInfoValue1', 1, nil, "THORN20_MQ05_THORNDRUG/1")
        end
    end
end

function SCR_USE_CHAPLE577_MQ_06(self,argObj, argstring, arg1, arg2)
    AddBuff(self, self, 'CHAPLE577_MQ_06_01', 1, 0, 10000, 1)

end

function SCR_USE_CHAPLE577_MQ_07(self, argObj, argstring, arg1, arg2)
    local x, y, z = GetPos(argObj)
    local mon = CREATE_NPC_EX(self, argObj.ClassName, x, y, z+30, GetLocalAngle(self, argObj), 'Our_Forces', ScpArgMsg("Auto_dummy_577_06"), 35, CHAPLE577_MQ_07_DUMMY)
    InsertHate(argObj, mon, 999)
    SetLifeTime(mon, 20)
end




function SCR_USE_KEY_OF_LEGEND_01(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'd_chapel_57_7' then
        if GetLayer(self) == 0 then
            local result = SCR_QUEST_CHECK(self, 'CHAPLE577_MQ_10')
            if result == "PROGRESS" or result == "SUCCESS" or result == "COMPLETE" then
                local list1, cnt1 = SelectObjectByClassName(self, 40, 'secret_warp_npc')
                if cnt1 ~= 0 then
                    RunScript('CHAPLE577_SECRET_ROOM', self)
                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CHAPLE577_MQ_10', 'QuestInfoValue1', nil, 1)
                else
                    SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('SECRET_WARP_MSG02'), 5);
                end
            end
        end
    elseif GetZoneName(self) == 'f_siauliai_west' then
        if GetLayer(self) == 0 then
--            local tarX = 3041
--            local tarY = 423
--            local tarZ = 715
--            local posX, posY, posZ = GetPos(self)
--            if SCR_POINT_DISTANCE(tarX, tarZ, posX, posZ) <= 500 the
            local list2, cnt2 = SelectObjectByClassName(self, 40, 'secret_warp_npc')
            if cnt2 ~= 0 then
                RunScript('SIAULIAI_WEST_SECRET_ROOM', self)
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('SECRET_WARP_MSG02'), 5);
            end
        end
        
    elseif GetZoneName(self) == 'f_pilgrimroad_52' then
        if GetLayer(self) == 0 then
            local list3, cnt3 = SelectObjectByClassName(self, 40, 'secret_warp_npc')
            if cnt3 ~= 0 then
                RunScript('PILGRIM_52_TO_SECRET_ROOM', self)
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('SECRET_WARP_MSG02'), 5);
            end
        end
--    elseif GetZoneName(self) == 'f_huevillage_58_1' then
--        if GetLayer(self) ~= 0 then
--            local result = SCR_QUEST_CHECK(self, 'HUEVILLAGE_58_1_MQ11')
--            if result == "PROGRESS" then
--                local list, cnt = SelectObject(self, 100, 'ALL')
--                local i
--        	    for i = 1, cnt do
--            	    if list[i].ClassName == 'magicsquare_1_mini' then
--                        RunScript('HUEVILLAGE_58_1_TO_HUEVILLAGE_58_4_PORTAL', self, list[i])
--                    end
--        	    end
--            end
--        end
    elseif GetZoneName(self) == 'd_velniasprison_51_4' then
        if GetLayer(self) == 0 then
            local list4, cnt4 = SelectObjectByClassName(self, 40, 'secret_warp_npc')
            if cnt4 ~= 0 then
                RunScript('VPRISON514_TO_SECRET_ROOM', self)
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('SECRET_WARP_MSG02'), 5);
            end
        end
        
    elseif GetZoneName(self) == 'd_velniasprison_51_1' then
        if GetLayer(self) == 0 then
            local list4, cnt4 = SelectObjectByClassName(self, 40, 'secret_warp_npc')
            if cnt4 ~= 0 then
                RunScript('VPRISON511_TO_SECRET_ROOM', self)
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('SECRET_WARP_MSG02'), 5);
            end
        end
        
    elseif GetZoneName(self) == 'd_velniasprison_51_5' then
        if GetLayer(self) == 0 then
            local list4, cnt4 = SelectObjectByClassName(self, 40, 'secret_warp_npc')
            if cnt4 ~= 0 then
                RunScript('VPRISON515_TO_SECRET_ROOM', self)
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('SECRET_WARP_MSG02'), 5);
            end
        end
    elseif GetZoneName(self) == 'id_catacomb_25_4' then
        if GetLayer(self) == 0 then
            local list5, cnt5 = SelectObjectByClassName(self, 40, 'secret_warp_npc')
            if cnt5 ~= 0 then
                RunScript('CATACOMB254_TO_SECRET_ROOM', self)
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('SECRET_WARP_MSG02'), 5);
            end
        end
    elseif GetZoneName(self) == 'f_maple_25_1' then
        if GetLayer(self) == 0 then
            local list6, cnt6 = SelectObjectByClassName(self, 40, 'secret_warp_npc')
            if cnt6 ~= 0 then
                RunScript('MAPLE251_TO_SECRET_ROOM', self)
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('SECRET_WARP_MSG02'), 5);
            end
        end
    end
end

function CHAPLE577_SECRET_ROOM(self)
    PlayAnim(self, 'WARP', 0)
    UIOpenToPC(self,'fullblack',1)
    sleep(1000)
    MoveZone(self, 'd_chapel_57_7', 950, 36, -1243) 
    UIOpenToPC(self,'fullblack',0)
    PlayAnim(self, 'SLAND', 0)
end

function SIAULIAI_WEST_SECRET_ROOM(self)
    PlayAnim(self, 'WARP', 0)
    UIOpenToPC(self,'fullblack',1)
    sleep(1000)
    MoveZone(self, 'f_siauliai_west', 2826, 423, 564) 
    UIOpenToPC(self,'fullblack',0)
    PlayAnim(self, 'SLAND', 0)
end

function PILGRIM_52_TO_SECRET_ROOM(self)
    PlayAnim(self, 'WARP', 0)
    UIOpenToPC(self,'fullblack',1)
    sleep(1000)
    MoveZone(self, 'f_pilgrimroad_52', 2667, 156, 147) 
    UIOpenToPC(self,'fullblack',0)
    PlayAnim(self, 'SLAND', 0)
end

--function HUEVILLAGE_58_1_TO_HUEVILLAGE_58_4_PORTAL(self, portal)
--    local quest_ssn = GetSessionObject(self,'SSN_HUEVILLAGE_58_1_MQ11')
--    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_HUEVILLAGE_58_1_MQ11', 'QuestInfoValue1', 1)
--    PlayEffectLocal(portal, self, 'F_pc_warp_circle', 1.0)
--    PlayEffectLocal(portal, self, 'F_pc_warp_light', 1.0)
--    PlayAnim(self, 'WARP', 0)
--end

function VPRISON514_TO_SECRET_ROOM(self)
    PlayAnim(self, 'WARP', 0)
    UIOpenToPC(self,'fullblack',1)
    sleep(1000)
    MoveZone(self, 'd_velniasprison_51_4', 380, -150, 820) 
    UIOpenToPC(self,'fullblack',0)
    PlayAnim(self, 'SLAND', 0)
end

function VPRISON511_TO_SECRET_ROOM(self)
    PlayAnim(self, 'WARP', 0)
    UIOpenToPC(self,'fullblack',1)
    sleep(1000)
    MoveZone(self, 'd_velniasprison_51_1', 23, 259, -998) 
    UIOpenToPC(self,'fullblack',0)
    PlayAnim(self, 'SLAND', 0)
end

function VPRISON515_TO_SECRET_ROOM(self)
    PlayAnim(self, 'WARP', 0)
    UIOpenToPC(self,'fullblack',1)
    sleep(1000)
    MoveZone(self, 'd_velniasprison_51_5', 2042, -162, 30) 
    UIOpenToPC(self,'fullblack',0)
    PlayAnim(self, 'SLAND', 0)
end

function CATACOMB254_TO_SECRET_ROOM(self)
    PlayAnim(self, 'WARP', 0)
    UIOpenToPC(self,'fullblack',1)
    sleep(1000)
    MoveZone(self, 'id_catacomb_25_4', -867, -46, -1181) 
    UIOpenToPC(self,'fullblack',0)
    PlayAnim(self, 'SLAND', 0)
end

function MAPLE251_TO_SECRET_ROOM(self)
    PlayAnim(self, 'WARP', 0)
    UIOpenToPC(self,'fullblack',1)
    sleep(1000)
    MoveZone(self, 'f_maple_25_1', -1988, 53, -297) 
    UIOpenToPC(self,'fullblack',0)
    PlayAnim(self, 'SLAND', 0)
end


function SCR_USE_THORN21_MQ07_THORNDRUG(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'THORN21_MQ07')
    if result == 'PROGRESS' then
        PlayAnim(self, "DRINK")
            AddBuff(self, self, 'THORN21_MQ07_THORNDRUG', 1, 0, 15000, 1)
            AttachEffect(self, 'I_sphere007_mash', 3, "BOT", 0);
        end
    end

function SCR_USE_THORN21_MQ04_DRUG(self, argObj, argstring, arg1, arg2)
    local result2 = SCR_QUEST_CHECK(self, 'THORN21_MQ04')
    local sObj = GetSessionObject(self, "SSN_THORN21_MQ04")
    local item1 = GetInvItemCount(self, "THORN21_MQ04_BUGWING")
    if result2 == 'PROGRESS' then
        local result_Dotimeaction = DOTIMEACTION_R(self, ScpArgMsg("Auto_THORN21_DRUG_MAKE"), 'FLASK', 2)
        if result_Dotimeaction == 1 then
            if sObj ~= nil then
                if sObj.QuestInfoValue2 < sObj.QuestInfoMaxCount2 then
        	        sObj.QuestInfoValue2 = sObj.QuestInfoMaxCount2
        	        SaveSessionObject(self, sObj)
        	        RunScript("GIVE_TAKE_ITEM_TX", self, "THORN21_MQ07_THORNDRUG/1", "THORN21_MQ04_DRUG/1/THORN21_MQ04_BUGWING/"..item1, "QUEST")
        	    end
        	end
        end
    end
end

function SCR_USE_ZACHA3F_MQ_02_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'ZACHA3F_MQ_03')
    if result == 'PROGRESS' then
        if argObj.NumArg1 < 1 then
        local result2 = DOTIMEACTION_R(self, ScpArgMsg("Auto_SoKeumPogyag_Sayong_Jung"), 'MAKING', 2, 'SSN_HATE_AROUND')
        if result2 == 1 then
                if argObj.NumArg1 < 1 then
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ZACHA3F_MQ_03', 'QuestInfoValue1', 1)
                    argObj.NumArg1 = 1
                end
            if IMCRandom(1, 10) > 8 then
                PlayEffect(argObj, 'F_archer_turret_hit_explosion', 0.7)
                Dead(argObj)
            else
                argObj.Name = ScpArgMsg('Auto_oyeomDoen_HwilLen')
                BroadcastShape(argObj)
                SetCurrentFaction(argObj, 'Monster')
                RunSimpleAIOnly(argObj, 'D_ZACHA3F_MON');
                RunScript('ZACHA3F_MQ_03_GOTO_DIE', argObj)
                InsertHate(argObj, self, 9999)
                end
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg("ZACHA3F_MQ_02_ITEM_MSG1"), 3);
        end
    end
end




function SCR_USE_GELE574_MQ_08_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'GELE574_MQ_08')
    if result == 'PROGRESS' then
        local result_Dotimeaction = DOTIMEACTION_R(self, ScpArgMsg("Auto_THORNFLOWER_DRUG_USE"), 'DRINK', 1)
        if result_Dotimeaction == 1 then
            AddBuff(self, self, 'THORN21_MQ07_THORNDRUG', 1, 0, 10000, 1)
        end
    end
end


function SCR_USE_JOB_FLETCHER4_1_ITEM(self, argObj, argstring, arg1, arg2)
    RunScript('SCR_USE_JOB_FLETCHER4_1_ITEM_RUN', self)
end

function SCR_USE_JOB_FLETCHER4_1_ITEM_RUN(self)
    local result = DOTIMEACTION_R(self, ScpArgMsg("Auto_namu_distictio"), 'MAKING', 0.5)
    if result == 1 then
        local rnd = IMCRandom(1, 3)
        if rnd == 2 then
            SendAddOnMsg(self, 'NOTICE_Dm_GetItem',ScpArgMsg("Auto_namu_get_01"), 3);
            GIVE_TAKE_ITEM_TX(self, 'JOB_FLETCHER4_ITEM/1', 'JOB_FLETCHER4_1_ITEM/1', 'Quest_JOB_FLETCHER4_1')
        else
            SendAddOnMsg(self, 'NOTICE_Dm_!',ScpArgMsg("Auto_namu_lose_01"), 3);
            RunScript('TAKE_ITEM_TX', self, 'JOB_FLETCHER4_1_ITEM', 1, "Quest")
        end
    end
end



function SCR_USE_JOB_WUGU4_1_ITEM(self, argObj, argstring, arg1, arg2)
    PlayAnim(self, 'BLK', 0)
    InsertHate(argObj, self, 99999)
    AddBuff(self, argObj, 'JOB_WUGU4_1', 1, 0, 0, 1)
end


function SCR_USE_JOB_SCOUT4_1_ITEM(self, argObj, argstring, arg1, arg2)
    local quest_ssn = GetSessionObject(self, 'SSN_JOB_SCOUT4_1')
    if quest_ssn ~= nil then
        JOB_SCOUT4_2_ITEM(self, quest_ssn)
    end
end

function JOB_SCOUT4_2_ITEM(self, quest_ssn)
    local i
    for i =1 , 100 do
        local x1, y, z1 = GetPos(self)
        local x, z = GetAroundPos(self, IMCRandom(0, 360), 100);
        local zoneIst = GetZoneInstID(self);
        if IsValidPos(zoneIst, x, y, z) == 'YES' then
            local mon = CREATE_MONSTER_EX(self, 'blank_npc', x, y, z, 0, 'Neutral', 144, JOB_SCOUT4_2_ITEM_AI, self);
            SetLifeTime(mon, 30)
            quest_ssn.Goal1 = 0
            quest_ssn.Step3 = 0
            break;
        end
    end
end

function JOB_SCOUT4_2_ITEM_AI(mon, self)
    mon.SimpleAI = 'JOB_SCOUT4_1'
    mon.Dialog = 'JOB_SCOUT4_1_D'
    mon.Name = ScpArgMsg("Auto_JOB_SCOUT4_1_ITEM")
end




function SCR_USE_JOB_ROGUE4_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'JOB_ROGUE4_1')
    if result == 'PROGRESS' then
        if GetLayer(self) ~= 0  then
    	    if GetZoneName(self) == 'f_katyn_7' then
                local list, cnt = SelectObject(self, 80, 'ENEMY')
                local i
                PlayAnim(self, 'PUBLIC_THROW',1)
                AddBuff(self, self, 'JOB_ROGUE4_1_BUFF', 1, 0, 10000, 1)
                PlayEffect(self, 'F_burstup026_green', 4)
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                                sleep(500)
                                AddBuff(list[i], list[i], 'JOB_ROGUE4_1_DEBUFF', 1, 0, 10000, 1)
                                ResetHated(list[i])
                            end
                        end
                    end
                end
                
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_ROGUE4_1', 'QuestInfoValue1', 1, nil, nil, nil, nil, nil, nil, nil, nil, 'JOB_ROGUE4_1')
                
                --    local val = GetMGameValue(self, 'JOB_ROGUE4_1')
                --    SetMGameValue(self, 'JOB_ROGUE4_1', val + 1)
            end
        end
    end
end




function SCR_USE_JOB_SWORDMAN4_1_ITEM(self, argObj, argstring, arg1, arg2)
    local quest_ssn = GetSessionObject(self, 'SSN_JOB_SWORDMAN4_1')
    local list, cnt = SelectObjectByFaction(self, 40, 'Monster')
    if quest_ssn ~= nil then
        if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
            quest_ssn.Goal1 = quest_ssn.Goal1 + cnt
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("Auto_JOB_SWORDMAN4_1_PROG1")..quest_ssn.Goal1.." / "..quest_ssn.QuestInfoMaxCount1..ScpArgMsg("Auto_JOB_SWORDMAN4_1_PROG2"), 2);
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_SWORDMAN4_1', 'QuestInfoValue1', cnt)
            UsePcSkill(self, self, 'Warrior_Provoke', 1, 1)
        end
    end
end


function SCR_USE_JOB_CENTURION5_1_ITEM(self, argObj, argstring, arg1, arg2)
    --UsePcSkill(self, self, 'Warrior_PhalanxFormation', 1, 1)
    UsePcSkill(self, self, 'Centurion_Conscript', 1, 1)
end


function SCR_USE_JOB_SQUIRE4_1_ITEM(self, argObj, argstring, arg1, arg2)
    local x, y, z = GetPos(argObj)
    local list, cnt = SelectObjectPos(self, x,y,z, 100, 'ENEMY')
    local i
    if cnt >= 3 then
        for i = 1 , cnt do
            AddBuff(self, list[i], 'Stun', 1, 0, 8000, 1)
            PlayAnim(list[i], 'ASTD')
        end
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_SQUIRE4_1', 'QuestInfoValue1', 1)
        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('Auto_JOB_SQUIRE4_1_GET'), 3);
    else
        SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('Auto_JOB_SQUIRE4_1_MISS'), 3);
    end
--    UsePcSkill(self, argObj, 'Warrior_PhalanxFormation', 1, 1)
end




function SCR_USE_MODPAT_DEV_ITEM(self, argObj, argstring, arg1, arg2)
    UsePcSkill(self, self, 'Centurion_PhalanxFormation', 1, 1)
end



function SCR_USE_REMAIN39_SQ03_FEDIMIAN(self, argObj, argstring, arg1, arg2)
    ShowOkDlg(self, 'REMAIN39_SQ03_FEDIMIAN_01', 1)
end





function SCR_USE_REMAINS40_MQ_07_ITEM(self, argObj, argstring, arg1, arg2)
	local m_sObj = GetSessionObject(self, "ssn_klapeda");	
	if m_sObj ~= nil then
	    if m_sObj.REMAINS40_MQ_07_ITEM == 0 then
        	local tx = TxBegin(self);
        	local beforeValue = self.StatByBonus
        	TxAddIESProp(tx, self, 'StatByBonus', 1);
        	TxSetIESProp(tx, m_sObj, 'REMAINS40_MQ_07_ITEM', 300)
        	local ret = TxCommit(tx);
        	local afterValue = self.StatByBonus
        	
            CustomMongoLog(self, "StatByBonusADD", "Layer", GetLayer(self), "beforeValue", beforeValue, "afterValue", afterValue, "addValue", 1, "Way", "SCR_USE_REMAINS40_MQ_07_ITEM", "Type", "QUEST_ITEM")
        	if ret == "SUCCESS" then
        		SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('Auto_REMAINS40_MQ_07_ITEM'), 3);
        	end
        end
    end
end

function SCR_USE_HIGHLANDER_HQ01_BOX(self, argObj, argstring, arg1, arg2)
    local quest_result = SCR_QUEST_CHECK(self, 'HIGHLANDER_HQ_02')
    if quest_result == "PROGRESS" then
        local result = DOTIMEACTION_R(self, ScpArgMsg("HIGHLANDER_HQ01_BOX"), 'MAKING', 4)
        if result == 1 then
            SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('HIGHLANDER_HQ01_BOX_REPAIR_COMPLETE'), 3);
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_HIGHLANDER_HQ_02', 'QuestInfoValue1', 1, nil, "WOOD_CARVING_REPAIR/1", "WOOD_CARVING_REPAIR_WOOD/5/WOOD_CARVING_REPAIR_ROPE/1/WOOD_CARVING_WRECK/1")
        end
    end
end

function SCR_USE_ROKAS_30_HQ01_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'ROKAS_30_HQ_01')
    local zoneID = GetZoneInstID(self)
    if result == "PROGRESS" then
        local pos_list = SCR_CELLGENPOS_LIST(self, 'Front2', 0)
        if #pos_list > 0 then
            for i = 1, #pos_list do
                if IsValidPos(zoneID, pos_list[i][1], pos_list[i][2], pos_list[i][3]) == 'YES' then
                    local mon = CREATE_NPC(self, "Hiddennpc", pos_list[i][1], pos_list[i][2], pos_list[i][3], 0, "Neutral", GetLayer(self), nil, nil)
                    local action_result = DOTIMEACTION_R(self, ScpArgMsg("ROKAS_30_HQ01_ITEM_BURN_ING"), 'MAKING', 4)
                    if action_result == 1 then
                        AttachEffect(mon, "F_burstup027_fire", 3, "BOT")
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ROKAS_30_HQ_01', 'QuestInfoValue1', 1, nil, nil, "ROKAS_30_HQ01_ITEM/1")
                        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('ROKAS_30_HQ01_ITEM_BURN'), 3);
                        SetLifeTime(mon, 5)
                        ShowOkDlg(self, 'ROKAS_30_HQ01_ITEM_LOG', 1)
                        break;
                    end
                end
            end
        end
    end
end


 
function GELE572_MQ_05_RUNNPC(self, argObj, argstring, arg1, arg2)
    local follower = GetScpObjectList(self, 'GELE572_MQ_DOLL')
    if #follower == 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'tower_of_firepuppet_black', x+30, y+15, z, GetDirectionByAngle(self), 'Our_Forces', self.Lv, GELE572_MQ_DOLL_02_RUN);
        LookAt(mon, self) 
        SET_NPC_BELONGS_TO_PC(mon, self, 'GELE572_MQ_DOLL', 2);
        AddScpObjectList(self, 'GELE572_MQ_DOLL', mon)
        CreateSessionObject(mon, "SSN_GELE572_MQ_08_1")
    end
end

function GELE572_MQ_DOLL_02_RUN(mon)
    mon.Lv = 30
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("GELE572_MQ_DOLL_02");
	mon.SimpleAI = 'GELE572_MQ_DOLL_02_RUN'
	mon.WlkMSPD = 70
end



--GELE572_MQ_04
function SCR_USE_GELE572_MQ_DOLL_01(self, argObj, argstring, arg1, arg2)
    local follower = GetScpObjectList(self, 'GELE572_MQ_DOLL')
    if #follower == 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'gele_of_firepuppet', x+30, y+15, z, GetDirectionByAngle(self), 'Our_Forces', self.Lv, GELE572_MQ_DOLL_01_RUN);
        AddBuff(self, mon, 'SoulDuel_ATK', 1, 0, 0, 1)
        SET_NPC_BELONGS_TO_PC(mon, self, 'GELE572_MQ_DOLL', 2);
        AddScpObjectList(self, 'GELE572_MQ_DOLL', mon)
        CreateSessionObject(mon, "SSN_GELE572_MQ_08_1")
    else
        local i
        for i = 1, #follower do
            Kill(follower[i])
        end
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'gele_of_firepuppet', x+30, y+15, z, GetDirectionByAngle(self), 'Our_Forces', self.Lv, GELE572_MQ_DOLL_01_RUN);
        AddBuff(self, mon, 'SoulDuel_ATK', 1, 0, 0, 1)
        SET_NPC_BELONGS_TO_PC(mon, self, 'GELE572_MQ_DOLL', 2);
        AddScpObjectList(self, 'GELE572_MQ_DOLL', mon)
        CreateSessionObject(mon, "SSN_GELE572_MQ_08_1")
    end
end


function GELE572_MQ_DOLL_01_RUN(mon)
    mon.Lv = 30
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("MQ_G57_8");
	mon.SimpleAI = 'GELE572_MQ_04_DOLL_01'
	mon.WlkMSPD = 70
end


--GELE574_MQ_05_ITEM
function SCR_USE_GELE574_MQ_05_ITEM(self, argObj, argstring, arg1, arg2)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("GELE574_MQ_05_01"), 2);
    AddBuff(self, argObj, 'GELE574_MQ_05', 1, 0, 25000, 1)
    InsertHate(argObj, self, 1)
end



--GELE574_MQ_06_ITEM
function SCR_USE_GELE574_MQ_06_ITEM(self, argObj, argstring, arg1, arg2)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("GELE574_MQ_05_01"), 2);
    local list, cnt = SelectObjectByClassName(self, 100, 'Npanto_archer')
    local i
    for i = 1 , cnt do
        if IsBuffApplied(list[i], 'GELE574_MQ_06') == 'NO' then
            AddBuff(self, list[i], 'GELE574_MQ_06', 1, 0, 0, 1)
        end
    end
end




--CHAPLE575_MQ_06
function SCR_USE_CHAPLE575_MQ_06_ITEM(self, argObj, argstring, arg1, arg2)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAPLE575_MQ_06_2"), 3)
    PlayAnim(self, 'DRINK', 1)
    AddBuff(self, self, 'CHAPLE575_MQ_06', 1, 0, 0, 1)
end



--CHAPLE575_MQ_07
function SCR_USE_CHAPLE575_MQ_07_ITEM(self, argObj, argstring, arg1, arg2)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Altarcrystal_N1', x, y+10, z, 0, 'Neutral', self.Lv, CHAPLE575_MQ_07_RUN);
    SetOwner(mon, self, 1)
    SetLifeTime(mon, 60)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAPLE575_MQ_07"), 3)
end

function CHAPLE575_MQ_07_RUN(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'CHAPLE575_MQ_07_AI'
    mon.Name = ScpArgMsg('CHAPLE575_MQ_07_ITEM')
end





function SCR_USE_HUEVILLAGE_58_2_MQ01_ITEM2(self, argObj, argstring, arg1, arg2)
    local x, y, z = GetPos(argObj)
    local mon = CREATE_MONSTER_EX(self, 'Zibu_Maize', x, y, z, GetDirectionByAngle(self), 'Neutral', nil, SET_HUEVILLAGE_58_2_MQ01_MON);
    Kill(argObj)
	SetLifeTime(mon, 12);
	SetDialogRotate(mon, 0)
	PlayEffect(mon, 'F_explosion053_smoke', 1.0)
	AddBuff(self, mon, 'Stun', 1, 0, 10000, 1);
end





function SET_HUEVILLAGE_58_2_MQ01_MON(mon)
    mon.Dialog = "HUEVILLAGE_58_2_MQ01_MON"
	mon.BTree = "None";
	mon.Tactics = "None";
	mon.SimpleAI = 'HUEVILLAGE_58_2_MQ01_MON'
	mon.Name = ScpArgMsg("HUEVILLAGE_58_2_MQ01_MONNAME");
	mon.MaxDialog = 1;
end






--CHAPLE576_MQ_06
function SCR_USE_CHAPLE576_MQ_06_ITEM(self, argObj, argstring, arg1, arg2)
    local ridingCompanion = GetRidingCompanion(self);
    if ridingCompanion ~= nil then
        RideVehicle(self, ridingCompanion, 0)
    end
    local mon = {
                'Pawndel',
                'pawnd'
                }
    local rnd = IMCRandom(1, 2)
	if 1 == TransformToMonster(self, mon[rnd], 'CHAPLE576_MQ_06_1') then
		AddBuff(self, self, 'CHAPLE576_MQ_06_1', 1, 1, 300000, 1)
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAPLE576_MQ_06_ZE"), 3);
	end

end






--REMAIN37_MQ01_ITEM
function SCR_USE_REMAIN37_MQ01_ITEM(self, argObj, argstring, arg1, arg2)
    local itemType = GetClass("Item", 'REMAIN37_MQ01_ITEM').ClassID;
    local itemCnt = GetInvItemCountByType(self, itemType)
    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_REMAIN37_MQ01', 'QuestInfoValue1', nil, 1, "REMAIN37_MQ02_ITEM/1")
    PlayEffect(self, 'F_light032_green', 1, 1, 'MID')
    PlayEffect(self, 'F_light028_blue1', 1, 1, 'MID')
    SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('REMAIN37_MQ01_ITEM'), 3);
end


--REMAIN37_MQ02_ITEM
function SCR_USE_REMAIN37_MQ02_ITEM(self, argObj, argstring, arg1, arg2)
    local px
    local py
    local pz
    while 1 do
        local x = IMCRandom(-1398, -298)
        local y = 989
        local z = IMCRandom(-2761, -1661)
        local zinstID = GetZoneInstID(self);
        local x1, y1, z1 = GetPos(self)
        if SCR_POINT_DISTANCE(x, z, x1, z1) <= 150 then
            if IsValidPos(zinstID, x, y, z) == 'YES' then
                px = x
                py = y
                pz = z
                break
            end
        end
    end
    
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("REMAIN37_MQ02_ITEM_01"), 'MAKING', 3);
    if result1 == 1 then
        local mon = CREATE_MONSTER_EX(self, 'blank_npc', px, py, pz, -45, 'Neutral', 1, REMAIN37_MQ02_ITEM);
        SetLifeTime(mon, 60)
        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('REMAIN37_MQ02_ITEM_02'), 3);
    end

end

function REMAIN37_MQ02_ITEM(mon)
    mon.SimpleAI = 'REMAIN37_MQ02_ITEM'
    mon.Tactics = 'None' 
    mon.Name = ScpArgMsg("REMAIN37_MQ02_ITEM")
    mon.Dialog = 'REMAIN37_MQ02_ITEM'
    mon.MaxDialog = 1
end


--REMAIN37_SQ03_ITEM_02
function SCR_USE_REMAIN37_SQ03_ITEM_02(self, argObj, argstring, arg1, arg2)
    SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('REMAIN37_SQ03_ITEM_02'), 3);
    AddBuff(self, argObj, 'REMAIN37_SQ03_ITEM_02', 1, 0, 10000, 1)
    PlayEffect(argObj, 'F_explosion001_fire', 1, 1, 'MID')
    PlayAnim(argObj, 'EVENT', 1)
end



--SCR_USE_REMAIN38_MQ03_2_ITEM
function SCR_USE_REMAIN38_MQ03_2_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    PlayAnim(self, 'PUBLIC_THROW', 1, 0)
    sleep(800)
    PlayAnim(self, 'ASTD', 1, 1)
    PlayEffect(argObj, 'F_archer_explosiontrap_hit_explosion', 1)
    InsertHate(argObj, self, 1)
    AddBuff(self, argObj, 'REMAIN38_MQ03', 1, 0, 60000, 1)
end


--SIAULIAI_46_3_MQ_01_ITEM
function SCR_USE_SIAULIAI_46_3_MQ_01_ITEM(self, argObj, argstring, arg1, arg2)

    PlayEffect(self, 'I_force069_yellow', 1.0)
    PlayEffect(argObj, 'I_force014_yellow', 1.0)

    local buff = GetBuffByName(argObj, 'SIAULIAI_46_3_MQ_01_BUFF')
    if buff == nil then
        AddBuff(self, argObj, 'SIAULIAI_46_3_MQ_01_BUFF', 1, 0, 30000, 1)
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_SIAULIAI_46_3_MQ_02', 'QuestInfoValue1', 1)
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("SIAULIAI_46_3_MQ_01_ITEM_MSG1"), 3);
        if GetHpPercent(argObj) >= 1 then
            RemoveHate(argObj, self)
        end
    end
end


function SCR_USE_CHATHEDRAL53_MQ03_ITEM(self, argObj, argstring, arg1, arg2)
    local follower = GetScpObjectList(self, 'CHATHEDRAL53_MQ_BISHOP')
    local quest_Result = SCR_QUEST_CHECK(self, 'CHATHEDRAL53_MQ03')
    if #follower == 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'npc_aurelius', x+30, y+15, z, GetDirectionByAngle(self), 'Neutral', self.Lv, CHATHEDRAL53_MQ_BISHOP_RUN);
        LookAt(mon, self)
        PlayEffectToGroundLocal(self, "F_buff_basic025_white_line_2", x+30, y+15, z, 1)
        SetOwner(mon, self, 0)
        SET_NPC_BELONGS_TO_PC_LOCAL(mon, self, 'CHATHEDRAL53_MQ_BISHOP', 2);
        AddScpObjectList(self, "CHATHEDRAL53_MQ_BISHOP", mon);
        if quest_Result == 'PROGRESS' then
            local sObj = GetSessionObject(self, "SSN_CHATHEDRAL53_MQ03")
            if sObj ~= nil then
                if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                    sObj.QuestInfoValue1 = sObj.QuestInfoMaxCount1
                    SaveSessionObject(self, sObj)
                end
            end
        end
    end
end

function CHATHEDRAL53_MQ_BISHOP_RUN(mon)
    mon.Lv = 160
    mon.Range = 200
    mon.Dialog = "CHATHEDRAL_BISHOP"
	mon.Leave = "CHATHEDRAL56_BISHOP_HIDE"
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("CHATHEDRAL53_MQ_BISHOP_NAME");
	mon.SimpleAI = 'CHATHEDRAL53_MQ_BISHOP'
end

function SCR_USE_PILGRIM46_ITEM_07(self, argObj, argstring, arg1, arg2)
--    print(self.Name, argObj.ClassName, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM46_SQ_100')
    if result == 'PROGRESS' then
        if argObj == nil then
            return
        end
        local angle = GetLocalAngle(self, argObj)
        local x,y,z = GetPos(argObj)
        local bx, by, bz = GetPos(self)
        RotateToByAngle(self, argObj, angle)
        LookAt(self, argObj)
--        print(angle, argObj, "GGGGGGGGGG")
        PlayAnim(self, "PUBLIC_THROW", 1)
        
        MslThrow(self, "I_force012_green#Bip01 R Finger41", 0.5,        x, y, z, 5,     0.5,     0.1,       1,       0.8, "I_explosion002_green_L", 1,        0.5);
            
        local imc_int = IMCRandom(1,2)
        if imc_int == 1 then
            if argObj.StrArg1 == 'None' then
                argObj.StrArg1 = 'PILGRIM46_SQ_100'
                InsertHate(argObj, self, 1)
                AttachEffect(argObj, 'I_force060_dark', 2, "TOP")
                SetEmoticon(argObj, 'I_emo_stitch')
                PlayTextEffect(argObj, "I_SYS_Text_Effect_Skill", ScpArgMsg("PILGRIM46_SQ_100_MSG05"))
            end
        else
            local fndList, fndCount = SelectObject(self, 100, 'ALL', 1);
            local i
            for i = 1, fndCount do
                if GetCurrentFaction(fndList[i]) == 'Monster' then
                    InsertHate(fndList[i], self, 1)
                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("PILGRIM46_SQ_100_MSG06"), 5);
                end
            end
        end
    end

end

--SIAULIAI_46_2_MQ_01_ITEM
function SCR_USE_SIAULIAI_46_2_MQ_01_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'SIAULIAI_46_2_MQ_02')
    if result == 'PROGRESS' then
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_SIAULIAI_46_2_MQ_02', nil, nil, nil, 'SIAULIAI_46_2_MQ_02_ITEM/1')
        PlayEffect(argObj, 'F_buff_basic025_white_line', 0.3)
        Dead(argObj)
    end
end

--SIAULIAI_46_2_MQ_03_ITEM
function SCR_USE_SIAULIAI_46_2_MQ_03_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'SIAULIAI_46_2_MQ_03')
    if result == 'PROGRESS' then
--    	local result2 = DOTIMEACTION_R(self, ScpArgMsg("Auto_SeolChiJung"), 'MAKING', 1.5);
--    	if result2 == 1 then
            local x, y, z = GetPos(self)
            local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x+IMCRandom(-15, 15), y+15, z+IMCRandom(-15, 15), GetDirectionByAngle(self), 'Our_Forces', self.Lv, SCR_SIAULIAI_46_2_BEAD);
            SET_NPC_BELONGS_TO_PC(mon, self)
            SetLifeTime(mon, 60);
--        end
    end
end


--SIAULIAI_46_1_SQ_05_ITEM01
function SCR_USE_SIAULIAI_46_1_SQ_05_ITEM01(self, argObj, argstring, arg1, arg2)

    PlayEffect(self, 'F_light029_yellow', 2.0, nil, 'MID')
    
    local fndList, fndCnt = SelectObject(self, 180, 'ALL')
    local i 
    for i = 1, fndCnt do
        if fndList[i].Enter == 'SIAULIAI_46_1_SQ_05_TRIGGER' then
            local fndList2, fndCnt2 = SelectObject(fndList[i], 10, 'ALL')
            local j 
            for j = 1, fndCnt do
                if fndList[j].Dialog == 'SIAULIAI_46_1_SQ_05_GRASS' then
                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("SIAULIAI_46_1_SQ_05_ITEM01_MSG2"), 3);
                    return 0;
                end
            end

            local rnd = IMCRandom(1, 2)
            if rnd == 1 then
                local x, y, z = GetPos(fndList[i])
                local mon = CREATE_MONSTER_EX(self, 'siauliai_grass_1', x, y, z, -45, 1, self.Lv, SCR_SIAULIAI_46_1_SQ_05_GRASS_SET);
                SetLifeTime(mon, 10);
                PlayEffect(mon, 'F_buff_basic011_green', 1.0)
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("SIAULIAI_46_1_SQ_05_ITEM01_MSG3"), 3);
                Kill(fndList[i])
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("SIAULIAI_46_1_SQ_05_ITEM01_MSG1"), 3);
            end
            return
        end
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("SIAULIAI_46_1_SQ_05_ITEM01_MSG1"), 3);
    end
end

--CHATHEDRAL56_MQ03
function SCR_USE_CHATHEDRAL56_MQ03_ITEM(self, argObj, argstring, arg1, arg2)
    local DoTime_Action = DOTIMEACTION_R(self, ScpArgMsg("CHATHEDRAL56_MQ03_ITEM_DRINKING"), "SCROLL", 1.2)
    if DoTime_Action == 1 then
        PlayEffect(self, "F_burstup015_blue", 1.5)
        local mon = {
                    'Pawnd_purple',
                    'Pawndel_blue',
                    --'NightMaiden_bow'
                    }
--        local buff = GetBuffOver(self, 'CHAPLE576_MQ_06')
        local rnd = IMCRandom(1, 2)
--        if buff > 0 then
        	if 1 == TransformToMonster(self, mon[rnd], "CHATHEDRAL56_MQ03_BUFF") then
        		AddBuff(self, self, 'CHATHEDRAL56_MQ03_BUFF', 1, 1, 60000, 1)
        	end
--        end
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL56_MQ03_ITEM_SUCCESS"), 3);
    end
end


function SCR_USE_PILGRIM51_ITEM_01(self, argObj, strArg, numArg1, humarg2, itemClassID, itemID)

    TreasureMarkListByMap(self, 'f_pilgrimroad_51', 7, -1456, 548, -1902, --SR01
                                                        -278, 726, -1262, --SR02
                                                        1003, 300, -7,    --SR03
                                                        1134, 496, 1241,  --SR04
                                                        -1723, 564, 284,  --SR05
                                                        -296, 453, 265,   --SR06
                                                        -1673, 563, 904)  --SR07
end

--PILGRIM51_SQ_5_1
function SCR_USE_PILGRIM51_ITEM_11(self, argObj, strArg, numArg1, humarg2, itemClassID, itemID)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM51_SQ_5_1')
    if result == 'PROGRESS' then
        PlayAnim(self, 'BUFF',1)
        AttachEffect(self, "E_circle001", 4, 'MID');

        local x, y, z = GetPos(self)
        local layer = GetLayer(self)
        local mon = CREATE_MONSTER(self, "Prisonfighter", x+(IMCRandom(-30, 30)), y, z+(IMCRandom(-30, 30)), 0, 'Monster', layer, nil, "SCR_PILGRIM51_CALL_PRISONFIGHTER_RUN", ScpArgMsg("PILGRIM51_SQ_5_1_MSG02"))
        SetLifeTime(mon, 60)
        InsertHate(mon, self, 1)
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_5_1_MSG03"), 3);
        
        local fndList, fndCount = SelectObject(self, 100, 'ALL', 1);
        local i
        for i = 1, fndCount do 
            if fndList[i].Name == ScpArgMsg("PILGRIM51_SQ_5_1_MSG07") then  --ScpArgMsg("PILGRIM51_SQ_5_1_MSG07")
                Kill(fndList[i])
                sleep(1000)
                DetachEffect(self, "E_circle001" )
                --print("999999999999999")
            end
        end
    end
end

function SCR_PILGRIM51_CALL_PRISONFIGHTER_RUN(mon)
    mon.Dialog = "PILGRIM51_CALL_PRISONFIGHTER"
	mon.BTree = "None";
	mon.Tactics = "None";
	mon.MaxDialog = 1;
	--mon.SimpleAI = 'SCR_PILGRIM51_CALL_PRISONFIGHTER'
	--mon.Name = ScpArgMsg("PILGRIM51_SQ_5_1_MSG02");
end

function SCR_USE_PILGRIM50_ITEM_01(self, argObj, argstring, arg1, arg2)
--    print(self.Name, argObj.ClassName, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM50_SQ_030')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        PlayAnim(self, "PUBLIC_THROW", 1)
        local imc_int = IMCRandom(1, 2)
        if imc_int == 1 then
            if argObj.StrArg1 == 'None' then
                argObj.StrArg1 = 'PILGRIM50_SQ_030'
                AttachEffect(argObj, 'I_spread_out001_light', 4, "TOP")
                Chat(argObj, ScpArgMsg("PILGRIM50_SQ_030_MSG01"))
            end
        else
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("PILGRIM50_SQ_030_MSG02"), 5);
        end
    end
end




--FLASH64_SQ_08_ITEM
function SCR_USE_FLASH64_SQ_08_ITEM(self,argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    PlayAnim(self, 'PUBLIC_THROW', 1, 0)
    sleep(800)
    PlayAnim(self, 'ASTD', 1, 1)
    PlayEffect(argObj, 'F_archer_explosiontrap_hit_explosion', 1)
    InsertHate(argObj, self, 1)
    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_FLASH64_SQ_08', 'QuestInfoValue1', 1)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("FLASH64_SQ_08_ITEM"), 2);
--    AddBuff(self, argObj, 'REMAIN38_MQ03', 1, 0, 60000, 1)
end



--CMINE_COMPASS_ITEM
function SCR_USE_CMINE_COMPASS_ITEM(self,argObj, argstring, arg1, arg2)

    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1.5, 'CMINE_COMPASS_ITEM')
    local result = DOTIMEACTION_R(self, ScpArgMsg("USE_CMINE_COMPASS_ITEM"), 'COMPASS', animTime, 'SSN_HATE_AROUND')
    DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'CMINE_COMPASS_ITEM')
    
    if result == 1 then
        
        local PC_zone = GetZoneName(self)
        if PC_zone == 'd_cmine_01' then
            local result1 = SCR_QUEST_CHECK(self, 'MINE_1_CRYSTAL_8')
            local result2 = SCR_QUEST_CHECK(self, 'MINE_1_CRYSTAL_13')
            local select
            
            if result1 == "PROGRESS" and result2 == "PROGRESS" then
                select = ShowSelDlgDirect(self, 0, 'CMINE_COMPASS_cmine_basic', ScpArgMsg('CMINE_COMPASS_cmine_1_1'), ScpArgMsg('CMINE_COMPASS_cmine_1_2'))
            elseif result1 == "PROGRESS" and result2 ~= "PROGRESS" then
                select = 1
            elseif result1 ~= "PROGRESS" and result2 == "PROGRESS" then
                select = 2
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CMINE_COMPASS_cmine_noquest"), 5);
                return
            end
            
            if select == 1 then
                SCR_QUEST_SUCCESS(self, 'MINE_1_CRYSTAL_8')
            elseif select == 2 then
                SCR_QUEST_SUCCESS(self, 'MINE_1_CRYSTAL_13')
            end
        elseif PC_zone == 'd_cmine_02' then
            local result1 = SCR_QUEST_CHECK(self, 'MINE_2_CRYSTAL_5')
            local result2 = SCR_QUEST_CHECK(self, 'MINE_2_CRYSTAL_7')
            local result3 = SCR_QUEST_CHECK(self, 'MINE_2_CRYSTAL_14')
            local select
            
            if (result1 == "PROGRESS" or result2 == "PROGRESS") and result3 == "PROGRESS" then
                select = ShowSelDlgDirect(self, 0, 'CMINE_COMPASS_cmine_basic', ScpArgMsg('CMINE_COMPASS_cmine_2_1'), ScpArgMsg('CMINE_COMPASS_cmine_2_2'))
            elseif (result1 == "PROGRESS" or result2 == "PROGRESS") and result3 ~= "PROGRESS" then
                select = 1
            elseif result1 ~= "PROGRESS" and result2 ~= "PROGRESS" and result3 == "PROGRESS" then
                select = 2
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CMINE_COMPASS_cmine_noquest"), 5);
                return
            end
            
            if select == 1 then
                if result1 == "PROGRESS" then
                    SCR_QUEST_SUCCESS(self, 'MINE_2_CRYSTAL_5')
                elseif result2 == "PROGRESS" then
                    SCR_QUEST_SUCCESS(self, 'MINE_2_CRYSTAL_7')
                end
            elseif select == 2 then
                SCR_QUEST_SUCCESS(self, 'MINE_2_CRYSTAL_14')
            end
        end
    end
end



--SELECT_PLEASE_ITEM
function SCR_USE_SELECT_PLEASE_ITEM(self,argObj, argstring, arg1, arg2)
    local select = ShowSelDlgDirect(self, 0, 'CMINE_COMPASS_cmine_basic', ScpArgMsg('CMINE_COMPASS_cmine_1'), ScpArgMsg('CMINE_COMPASS_cmine_2'))
    
    if select == 1 then
        --print('1111111111')
    elseif select == 2 then
        --print('2222222222')
    end
end



--FLASH59_SQ_04_ITEM
function SCR_USE_FLASH59_SQ_04_ITEM(self, argObj, argstring, arg1, arg2)
    AttachEffect(argObj, 'F_cleric_resurrection_cast_loop', 5, 1, 'BOT')
    local result = DOTIMEACTION_R(self, ScpArgMsg("FLASH59_SQ_04_1"), 'scroll', 2)
    if result == 1 then
        DetachEffect(argObj, 'F_cleric_resurrection_cast_loop')
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_FLASH59_SQ_04', 'QuestInfoValue1', IMCRandom(10, 15))
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("FLASH59_SQ_04_ITEM_1"), 2);
        PlayEffect(argObj, 'I_smoke018_spread_in', 1)
        Kill(argObj)
    else
        DetachEffect(argObj, 'F_cleric_resurrection_cast_loop')
    end
end


--FLASH60_SQ_05_ITEM
function SCR_USE_FLASH60_SQ_05_ITEM(self, argObj, argstring, arg1, arg2)
    if IsBuffApplied(argObj, 'FLASH60_SQ_05_DEBUFF') == 'NO' then
        local result = DOTIMEACTION_R(self, ScpArgMsg("FLASH60_SQ_05_ITEM_3"), 'MAKING', 0.5)
        if result == 1 then
            AddBuff(self, argObj, 'FLASH60_SQ_05_DEBUFF', 1, 0, 60000, 1)
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_FLASH60_SQ_05', 'QuestInfoValue1', 1)
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("FLASH60_SQ_05_ITEM_2"), 2);
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("FLASH60_SQ_05_ITEM_5"), 2);
    end
end




--FLASH61_SQ_08
function SCR_USE_FLASH61_SQ_08_ITEM(self, argObj, argstring, arg1, arg2)
    local result = DOTIMEACTION_R(self, ScpArgMsg("FLASH61_SQ_08_ITEM_1"), 'MAKING', 1)
    if result == 1 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'pcskill_icewall', x, y+10, z, 0, 'Neutral', self.Lv, FLASH61_SQ_08_ITEM_RUN);
--        SetOwner(mon, self, 1)
--        SetLifeTime(mon, 15)
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("FLASH61_SQ_08_ITEM_2"), 2);
    end
end

function FLASH61_SQ_08_ITEM_RUN(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'FLASH60_SQ_05_ITEM'
--    mon.Name = ScpArgMsg('FLASH60_SQ_05_ITEM_1')
end



--FLASH63_SQ_06
function SCR_USE_FLASH63_SQ_06_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    PlayAnim(self, "PUBLIC_THROW")
    sleep(1000)
    AttachEffect(argObj, 'F_archer_turret_hit_explosion', IMCRandomFloat(0.1, 2))
    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_FLASH63_SQ_06', 'QuestInfoValue1', 1)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("FLASH63_SQ_06_ITEM_1"), 2);
    InsertHate(argObj, self, 1)
end

--THORN19_MQ09
function SCR_USE_THORN19_MQ8_SOLVENT(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local Result = DOTIMEACTION_R(self, ScpArgMsg("THORN_GATE_OPEN2"), 'MAKING', 3);
    if Result == 1 then
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN19_MQ09', 'QuestInfoValue1', 1)
    end
end

--THORN19_MQ13
function SCR_USE_THORN19_MQ13_SPELLCRYSTAL(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local Result = DOTIMEACTION_R(self, ScpArgMsg("THORN_GATE_OPEN3"), 'MAKING', 3);
    if Result == 1 then
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN19_MQ14', 'QuestInfoValue1', 1)
    end
end

--CATHEDRAL53_SQ_02
function SCR_USE_CATHEDRAL53_SQ_02_ITEM(self, argObj, argstring, arg1, arg2)
    local Result = DOTIMEACTION_R(self, ScpArgMsg("CATHEDRAL_OBJECT_DETECT"), 'MAKING', 1);
    if Result == 1 then
    PlayEffect(self, "F_circle017", 1.1, 1, "BOT")
        local list, cnt = SelectObject(self, 95, 'ALL', nil)
        local i
        for i = 1 , cnt do
            if list[i].ClassName == "HiddenTrigger6" then
                local Obj_Hide = isHideNPC(self, list[i].Enter)
                if Obj_Hide == 'NO' then
                    local x, y, z = GetPos(list[i])
                    local orb = CREATE_MONSTER_EX(self, 'npc_orb1', x+1, y, z, 0, 'Neutral', self.Lv, CATHEDRAL_OBJECT_RUN);
                    SCR_SCRIPT_PARTY('SCR_CATHEDRAL53_SQ2_OBJ_FUNC', 2,  orb, self)
--                    CreateSessionObject(mon, 'SSN_QUESTNPC_AUTOKILL')
                end
            end
        end
    end
end

function CATHEDRAL_OBJECT_RUN(mon)
    mon.MaxDialog = 1;
    mon.Dialog = "CHATHEDRAL53_SQ02_OBJECT"
    mon.Name = ScpArgMsg("CATHEDRAL_OBJECT_NAME");
    mon.SimpleAI = "CATHEDRAL53_SQ_02_OBJ"
end

function SCR_CATHEDRAL53_SQ2_OBJ_FUNC(mon, pc)
    SetLifeTime(mon, 4)
    AddVisiblePC(mon, pc, 1)
end

--CHATHEDRAL54_SQ03_PART1
function SCR_USE_CATHEDRAL54_SQ04_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local Result = DOTIMEACTION_R(self, ScpArgMsg("CATHEDRAL_SCROLL_USE"), 'SCROLL', 1);
    if Result == 1 then
        if argObj.ClassName == "Stoulet_blue" or argObj.ClassName == "NightMaiden_mage" then
            if IsBuffApplied(argObj, 'CATHEDRAL54_SQ04_DEBUFF') == 'NO' then
                PlayEffect(argObj, "F_cleric_clairvoyance_ground", 1, 1, "BOT")
                AddBuff(self, argObj, 'CATHEDRAL54_SQ04_DEBUFF', 1, 0, 30000, 0)
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CATHEDRAL_SCROLL_USE_SUCCESS"), 3)
            else 
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CATHEDRAL_SCROLL_USE_COMPLETE"), 3)
            end
        end
    end
end

--CHATHEDRAL54_SQ04_PART2
function SCR_USE_CATHEDRAL54_SQ04_PART2_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local Result = DOTIMEACTION_R(self, ScpArgMsg("CATHEDRAL_DRUG_USE"), 'MAKING', 1);
    local ran = IMCRandom(1, 30)
    if Result == 1 then
--        PlayEffect(self, "F_circle017", 1, 1, "BOT")
        if argObj.ClassName == "Stoulet_blue" then
            if ran <= 5 then
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CATHEDRAL_DRUG_USE01"), 3)
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CHATHEDRAL54_SQ04_PART2', 'QuestInfoValue1', 1)
            elseif ran <= 15 then
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CATHEDRAL_DRUG_USE02"), 3)
                PlayAnim(argObj, "knockdown")
                AddBuff(self, argObj, "Stun", 2, 0, 2000)
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CHATHEDRAL54_SQ04_PART2', 'QuestInfoValue1', 1)
            elseif ran <= 30 then
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CATHEDRAL_DRUG_USE03"), 3)
                PlayEffect(argObj, "F_explosion025", 0.5, 1, "MID")
                Dead(argObj)
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CHATHEDRAL54_SQ04_PART2', 'QuestInfoValue1', 1)
            end
        end
    end
end

--PILGRIMROAD55_SQ03
function SCR_USE_PILGRIMROAD55_SQ03_ITEM(self, argObj, argstring, arg1, arg2)
    local Result = DOTIMEACTION_R(self, ScpArgMsg("MEAT_DRUG_MIX"), 'MAKING', 1);
    if Result == 1 then
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_PILGRIMROAD55_SQ03', 'QuestInfoValue1', 1, nil, "PILGRIMROAD55_SQ06_ITEM/20", "PILGRIMROAD55_SQ02_ITEM/20")
    end
end

--CHATHEDRAL53_MQ06_REDKEY
function SCR_USE_CHATHEDRAL53_MQ06_ITEM(self, argObj, argstring, arg1, arg2)
    local Pc_sObj = GetSessionObject(self, "SSN_CHATHEDRAL56_MQ08")
    local Result = DOTIMEACTION_R(self, ScpArgMsg("INPUT_KEY"), 'MAKING', 1);
    if Result == 1 then
    --print(argObj.ClassName)
        if argObj.Enter == "CHATHEDRAL56_MQ08_RED" then
            if Pc_sObj.Step1 < 1 then
                SCR_SCRIPT_PARTY("CHATHEDRAL53_MQ6_ITEM_FUNC", 1, self,  "Step1")
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CHATHEDRAL56_MQ08', 'QuestInfoValue1', 1, nil)
                PlayEffectLocal(argObj, self, "F_buff_basic029_red_line", 1)
            end
        end
    end
end

--CHATHEDRAL53_MQ06_BLUEKEY
function SCR_USE_CHATHEDRAL54_MQ01_PART1_ITEM(self, argObj, argstring, arg1, arg2)
    local Pc_sObj = GetSessionObject(self, "SSN_CHATHEDRAL56_MQ08")
    local Result = DOTIMEACTION_R(self, ScpArgMsg("INPUT_KEY"), 'MAKING', 1);
    if Result == 1 then
        if argObj.Enter == "CHATHEDRAL56_MQ08_BLUE" then
            if Pc_sObj.Step2 < 1 then
                SCR_SCRIPT_PARTY("CHATHEDRAL53_MQ6_ITEM_FUNC", 1, self,  "Step2")
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CHATHEDRAL56_MQ08', 'QuestInfoValue1', 1, nil)
                PlayEffectLocal(argObj, self, "F_buff_basic027_navy_line", 1)
            end
        end
    end
end

--CHATHEDRAL53_MQ06_PURPLEKEY
function SCR_USE_CHATHEDRAL54_MQ04_PART2_ITEM(self, argObj, argstring, arg1, arg2)
    local Pc_sObj = GetSessionObject(self, "SSN_CHATHEDRAL56_MQ08")
    local Result = DOTIMEACTION_R(self, ScpArgMsg("INPUT_KEY"), 'MAKING', 1);
    if Result == 1 then
        if argObj.Enter == "CHATHEDRAL56_MQ08_PURPLE" then
            if Pc_sObj.Step3 < 1 then
                SCR_SCRIPT_PARTY("CHATHEDRAL53_MQ6_ITEM_FUNC", 1, self,  "Step3")
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CHATHEDRAL56_MQ08', 'QuestInfoValue1', 1, nil)
                PlayEffectLocal(argObj, self, "F_buff_basic028_violet_line", 1)
            end
        end
    end
end

--CHATHEDRAL53_MQ06_GREENKEY
function SCR_USE_CHATHEDRAL56_MQ04_PART2_ITEM(self, argObj, argstring, arg1, arg2)
    local Pc_sObj = GetSessionObject(self, "SSN_CHATHEDRAL56_MQ08")
    local Result = DOTIMEACTION_R(self, ScpArgMsg("INPUT_KEY"), 'MAKING', 1);
    if Result == 1 then
        if argObj.Enter == "CHATHEDRAL56_MQ08_GREEN" then
            if Pc_sObj.Step4 < 1 then
                SCR_SCRIPT_PARTY("CHATHEDRAL53_MQ6_ITEM_FUNC", 1, self,  "Step4")
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CHATHEDRAL56_MQ08', 'QuestInfoValue1', 1, nil)
                PlayEffectLocal(argObj, self, "F_buff_basic031_green_line", 1)
            end
        end
    end
end

--CHATHEDRAL53_MQ06_YELLOWKEY
function SCR_USE_CHATHEDRAL56_SQ01_ITEM(self, argObj, argstring, arg1, arg2)
    local Pc_sObj = GetSessionObject(self, "SSN_CHATHEDRAL56_MQ08")
    local Result = DOTIMEACTION_R(self, ScpArgMsg("INPUT_KEY"), 'MAKING', 1);
    if Result == 1 then
        if argObj.Enter == "CHATHEDRAL56_MQ08_YELLOW" then
            if Pc_sObj.Step5 < 1 then
                SCR_SCRIPT_PARTY("CHATHEDRAL53_MQ6_ITEM_FUNC", 1, self,  "Step5")
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CHATHEDRAL56_MQ08', 'QuestInfoValue1', 1, nil)
                PlayEffectLocal(argObj, self, "F_buff_basic032_yellow_line", 1)
        end
    end
end
end

function CHATHEDRAL53_MQ6_ITEM_FUNC(pc, _StepValue)
    local sObj = GetSessionObject(pc, "SSN_CHATHEDRAL56_MQ08")
    sObj[_StepValue] = 1
    SaveSessionObject(pc, sObj)
end

--CHATHEDRAL54_MQ04_PART2
function SCR_USE_CATHEDRAL54_MQ02_PART2_ITEM(self, argstring, argnum1, argnum2)
    local sObj = GetSessionObject(self, "SSN_CHATHEDRAL54_MQ04_PART2")
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'spell_crystal_red', x, y+10, z, 0, 'Neutral', self.Lv, CATHEDRAL54_MQ02_RUN);
    SetOwner(mon, self, 1)
    SetLifeTime(mon, 58)
    sObj.Step1 = 1
    AttachEffect(mon, 'F_ground017_loop', 4.1, "BOT", 0);
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CATHEDRAL54_MQ02"), 3)
end

function CATHEDRAL54_MQ02_RUN(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'CATHEDRAL54_MQ02_CRYSTAL_RUN'
    mon.Name = ScpArgMsg('CATHEDRAL54_MQ02_ITEM')
end

--PILGRIM51_SQ_9_ITEM_1
function SCR_USE_PILGRIM51_SQ_9_ITEM_1(self)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM51_SQ_9')
    if result == 'PROGRESS' then
        PlayAnim(self, 'WARP');
        sleep(100)
        MoveZone(self, 'f_rokas_27', -468, 1196, -3165);
        PlayAnim(self, 'SLAND', 0)
        
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_9_MSG07"), 3)
    end
end


--VPRISON512_MQ_03_ITEM
function SCR_USE_VPRISON512_MQ_03_ITEM(self, argObj, argstring, arg1, arg2)
    if IsBuffApplied(argObj, 'VPRISON512_MQ_03_DEBUFF') == 'NO' then
        AddBuff(self, argObj, 'VPRISON512_MQ_03_DEBUFF', 1, 0, 0, 1)
    end
end


--UNDERF592_TYPEB_POTION
function SCR_USE_UNDERF592_TYPEB_POTION(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, 'SSN_UNDERF592_TYPEB')
    if sObj ~= nil then
        sObj.Goal1 = 0
        AddBuff(self, self, 'UNDERF592_TYPEB_KINGVOICE', 1, 0, 60000, 1)
        AddBuff(self, self, 'UNDERF592_TYPEB_OTP', 1, 0, 0, 1)
    end
end



--FARM49_2_MQ05_ITEM
function SCR_USE_FARM49_2_MQ05_ITEM(self, argObj, argstring, arg1, arg2)
    local list1, cnt1 = SelectObjectByFaction(self, 300, 'Our_Forces')
    local quest_ssn = GetSessionObject(self,'SSN_FARM49_2_MQ05')
    if cnt1 == 0 or cnt1 == nil then
        local result1 = DOTIMEACTION_R(self, ScpArgMsg("FARM49_2_MQ05_TAMING"), 'MAKING', 1)
        if result1 == 1 then
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("FARM49_2_MQ05"), 2)
            SetCurrentFaction(argObj, 'Neutral')
            ClearBTree(argObj)
            SET_NPC_BELONGS_TO_PC(argObj, self, 'FARM49_2_MQ05', 0)
            AddScpObjectList(self, 'FARM49_2_MQ05_FOLLOWER', argObj)
            RunSimpleAIOnly(argObj, 'FARM49_2_MQ05_F')
            AddHP(argObj, argObj.MHP)
            AddBuff(self, argObj, 'HPLock', argObj.MHP, 0, 0, 1)
            quest_ssn.Step1 = 1
            SaveSessionObject(self, quest_ssn)
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("FARM49_2_MQ05_FAIL"), 2)
    end
end

--FARM492_MQ06 BOWL
function SCR_USE_FARM49_2_MQ06_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'FARM49_2_MQ06')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        local result1 = DOTIMEACTION_R(self, ScpArgMsg("FARM49_2_MQ06"), 'SITWATER_LOOP', 2)
        if result1 == 1 then
            SCR_PARTY_QUESTPROP_ADD(self, nil, nil, nil, nil, 'FARM49_2_MQ06_ITEM2/1', 'FARM49_2_MQ06_ITEM1/1', nil, nil, nil, nil, nil, 'FARM49_2_MQ06')
            AddEffect(self, 'I_spread_out001_light', 1.0, 1, 'MID')
        end
    end
end

--FARM47_4_SQ_090
function SCR_USE_FARM47_4_SQ_090_ITEM_2(self, argObj, argstring, arg1, arg2)
--    print("1111111111")
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("FARM47_4_SQ_090_MSG05"), 'STANDSPINKLE', 1)
    if result1 == 1 then
--    PlayAnim(self, "STANDSPINKLE", 1)
--    print("22222222222222")
        local x, y, z = GetPos(self)
        local layer = GetLayer(self)

        local drop_item = CREATE_NPC(self, "FARM47_4_SQ_090_ITEM_2", x, y+20, z, 0, "Peaceful", layer, "UnvisibleName", nil, nil, 0, 1, nil)
        KnockDown(drop_item, self, 3, GetAngleFromPos(self, x, z), 3)
        SetLifeTime(drop_item, 2)

        local mon = CREATE_MONSTER(self, "haming_orange", x + 100 , y, z + 100, 0, 'Monster', layer, nil, nil, nil, nil, nil, 100)
        SetLifeTime(mon, 30)
        InsertHate(mon, self, 1)
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("FARM47_4_SQ_090_MSG07"), 10);
        
    end

end

--VPRISON515_MQ_RUNE
function SCR_USE_VPRISON515_MQ_RUNE_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'VPRISON515_MQ_03')
    local result2 = SCR_QUEST_CHECK(self, 'VPRISON515_MQ_04')
    local result3 = SCR_QUEST_CHECK(self, 'VPRISON515_MQ_05')
    if result1 == "PROGRESS" then
        AddBuff(self, argObj, "VPRISON515_MQ_03_DEBUFF", 1 , 0, 60000, 1)
    elseif result2 == 'PROGRESS' then
        AddBuff(self, argObj, "VPRISON515_MQ_04_DEBUFF", 1 , 0, 60000, 1)
    elseif result3 == 'PROGRESS' then
        AddBuff(self, argObj, "VPRISON515_MQ_05_DEBUFF", 1 , 0, 60000, 1)
    end
    InsertHate(argObj, self, 1)
end



--VPRISON513_MQ_03_ITEM
function SCR_USE_VPRISON513_MQ_03_ITEM(self, argObj, argstring, arg1, arg2)
    local list, cnt = SelectObjectByFaction(argObj, 240, 'Monster')
    local i
    if cnt ~= 0  then
        AddBuff(self, argObj, "VPRISON513_MQ_03_HAUBERK", 1 , 0, 25000, 1)
        InsertHate(argObj, self, 1)
    else
        local x, y, z = GetPos(argObj)
        local zinstID = GetZoneInstID(self);
        local mon = {}
        for i = 1, 2 do
            x, y, z = GetRandomPos(argObj, x, y, z, 240);
            if IsValidPos(zinstID, x, y, z) == 'YES' then
                mon[i] = CREATE_MONSTER_EX(self, argObj.ClassName, x, y, z, GetDirectionByAngle(argObj), GetCurrentFaction(argObj), 1, VPRISON513_MQ_03_ITEM_RUN, argObj);
                InsertHate(mon[i], self, 1)
            end
        end
    end
end


function VPRISON513_MQ_03_ITEM_RUN(mon, argObj)
    mon.Lv = argObj.Level
end


--FARM47_1_SQ_030
function SCR_USE_FARM47_1_SQ_030_ITEM_1(self, argObj, argstring, arg1, arg2)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Skill_poison_pot', x, y+10, z, 0, 'Neutral', self.Lv, FARM47_SMALL_POT_AI_RUN);
    SetOwner(mon, self, 1)
    SetLifeTime(mon, 20)
    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("FARM47_1_SQ_030_MSG01"), 3)
end

function FARM47_SMALL_POT_AI_RUN(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'FARM47_SMALL_POT_AI'
    mon.Name = ScpArgMsg('FARM47_1_SQ_030_MSG02')
end

function SCR_USE_FARM47_1_SQ_100_ITEM_1(self, argObj, argstring, arg1, arg2)

    local result = SCR_QUEST_CHECK(self, 'FARM47_1_SQ_100')
    if result == 'PROGRESS' then

        local fndList, fndCount = SelectObject(self, 100, 'ALL', 1);
        local i
        if fndCount > 0 then
            for i = 1, fndCount do
                if fndList[i].ClassName ~= "PC" then
                    if fndList[i].Dialog == 'FARM47_MAGIC31_D' then
    
           
                        local angle = GetLocalAngle(self, fndList[i])
                        local x,y,z = GetPos(fndList[i])
                        local bx, by, bz = GetPos(self)
                        RotateToByAngle(self, fndList[i], angle)
                        LookAt(self, fndList[i])
    
                        PlayAnim(self, "PUBLIC_THROW", 1)
            
                        MslThrow(self, "I_force068_green#Bip01 R Finger41",             0.5,        x, y, z, 5,           0.5,     0.1,       1,        0.8,        "F_burstup012_violet", 1,        0.5);
                        --MslThrow(self, (effectName) 'I_breath022_green', x, y, z,          skillrange, (time) 2, delay, (speedFix) 2, easing(1.0), (EndEffect) 'F_blood007_violet');
                        sleep(1500)
                        local imc_int = IMCRandom(1,3)
                        if imc_int == 1 then
                            PlayEffect(fndList[i], 'F_burstup004_dark', 2, 1, 'BOT')
                            TakeDamage(fndList[i], self, "None", dam)
                            KnockBack(self, fndList[i], 100, nil, GetAngleFromPos(self, 1381, 1060), 45)
                            SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("FARM47_1_SQ_100_MSG07"), 5);
                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_FARM47_1_SQ_100', 'QuestInfoValue1', 1, nil)
                            
                        else
                            PlayEffect(fndList[i], 'F_burstup004_dark', 2, 1, 'BOT')
                            AddBuff(fndList[i], self, "UC_sleep", 1, 0, 5000, 1) 
                            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("FARM47_1_SQ_100_MSG09"), 5);
                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_FARM47_1_SQ_100', 'QuestInfoValue1', 1, nil)
                        end
                    end
                end
            end
        end
    end
end

--VELNIAS54_1 FREE DUNGEAN USE ITEM
function SCR_USE_VELNIAS54_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("VELNIASP54_1_ITEM_SETUP"), 'BURY', 2)
    
    if result1 == 1 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'npc_orb1', x, y+10, z, 0, 'Neutral', self.Lv, VELNIAS54_1_ITEM_RUN);
        
        AttachEffect(mon, "F_ground023", 1, "BOT")
        SetLifeTime(mon, 30)
    
    end
end

function VELNIAS54_1_ITEM_RUN(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'VELNIAS54_1_ITEM_RUN_AI'
    mon.Name = ScpArgMsg('VELNIASP54_1_ITEM_NAME')
end

--FARM47_2_SQ_030
function SCR_USE_FARM47_2_SQ_030_ITEM_2(self, argObj, argstring, arg1, arg2)
--    local result1 = DOTIMEACTION_R(self, ScpArgMsg("FARM47_2_SQ_030_MSG01"), 'CRAFT', 3)
    
    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 3, 'FARM47_2_SQ_030')
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("FARM47_2_SQ_030_MSG01"), 'CRAFT', animTime)
    DOTIMEACTION_R_AFTER(self, result1, animTime, before_time, 'FARM47_2_SQ_030')
    if result1 == 1 then
        local quest_ssn = GetSessionObject(self,'SSN_FARM47_2_SQ_030')
        if quest_ssn ~= nil then
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_FARM47_2_SQ_030', 'QuestInfoValue3', 1, nil, 'FARM47_2_SQ_030_ITEM_4/1', 'FARM47_2_SQ_030_ITEM_3/1')
        end
    end
end

--FARM47_3_SQ_050
function SCR_USE_FARM47_3_SQ_050_ITEM_11(self, argObj, argstring, arg1, arg2)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Skill_poison_pot', x, y+10, z, 0, 'Neutral', self.Lv, FARM47_MAGIC_POT_AI_RUN);
    SetOwner(mon, self, 1)
    SetLifeTime(mon, 20)
    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("FARM47_3_SQ_050_MSG05"), 3)
end

function FARM47_MAGIC_POT_AI_RUN(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'FARM47_MAGIC_POT_AI'
    mon.Name = 'UnvisibleName'
end

function SCR_USE_PILGRIM50_ITEM_11(self, argObj, argstring, arg1, arg2)
--    print(self.Name, argObj.ClassName, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM50_SQ_028')
    if result == 'PROGRESS' then
                    
        if argObj.StrArg1 == 'None' then
            argObj.StrArg1 = 'PILGRIM50_SQ_028'
            AttachEffect(argObj, 'I_spread_out001_light', 4, "TOP")
            sleep(2000)
            Dead(argObj)
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_PILGRIM50_SQ_028', 'QuestInfoValue1', 1, nil)
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("PILGRIM50_SQ_028_MSG03"), 5)
        end
    end
end



--CATACOMB_38_2_SQ_02_ITEM
function SCR_USE_CATACOMB_38_2_SQ_02_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_38_2_SQ_02')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_38_2' then
            if GetLayer(self) == 0 then
                if SCR_QUEST_MONRANK_CHECK(argObj, 'Normal', 'Special', 'Material') == 'YES' then
                    LookAt(self, argObj)
                    PlayEffect(argObj, 'F_buff_basic020_white', 1.5)
                    
                    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'CATACOMB_38_2_SQ_02_ITEM')
                    local result = DOTIMEACTION_R(self, ScpArgMsg("CATACOMB_38_2_SQ_02_ITEM_MSG1"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                    DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'CATACOMB_38_2_SQ_02_ITEM')
                    if result == 1 then
                        InsertHate(argObj, self, 1)
                        if argObj.NumArg1 < 200 then
                            local x1, y1, z1 = GetPos(argObj)
                            local x2, y2, z2 = GetPos(self)
                            local dead_range = SCR_POINT_DISTANCE(x1, z1, x2, z2);
                            local skill = GetNormalSkill(argObj);
                            ForceDamage(argObj, skill, self, argObj, 0, 'MOTION', 'BLOW', 'I_force015_white', 1, 'arrow_cast', 'I_explosion014_white', 0.5, 'arrow_blow', 'SLOW', 20+(dead_range*0.5), 1, 0, 0, 0, 1, 1)
                            
                            local rnd = IMCRandom(50, 100)
                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CATACOMB_38_2_SQ_02', 'QuestInfoValue1', rnd, nil)
                            argObj.NumArg1 = argObj.NumArg1 + rnd;
                            if argObj.NumArg1 >= 200 then
                                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CATACOMB_38_2_SQ_02_ITEM_MSG2"), 5);
                                PlayEffect(argObj, 'I_explosion008_violet', 1.5)
                                Kill(argObj);
                            end
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CATACOMB_38_2_SQ_02_ITEM_MSG2"), 5);
                            PlayEffect(argObj, 'I_explosion008_violet', 1.5)
                            Kill(argObj);
                        end
                    end
                end
            end
        end
    end
end



--CATACOMB_38_2_SQ_03_ITEM
function SCR_USE_CATACOMB_38_2_SQ_03_ITEM(self, argObj, argstring, arg1, arg2)
    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'CATACOMB_38_2_SQ_03_ITEM')
    local result = DOTIMEACTION_R(self, ScpArgMsg("CATACOMB_38_2_SQ_03_ITEM_MSG1"), 'MAKING', animTime, 'SSN_HATE_AROUND')
    DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'CATACOMB_38_2_SQ_03_ITEM')
    if result == 1 then
        local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_38_2_SQ_05')
        if result1 == 'PROGRESS' then
            local hover = GetScpObjectList(self, 'CATACOMB_38_2_SQ_05_SCP_PC')
            if #hover == 0 then
                local x, y, z = GetPos(self)
                local mon1 = CREATE_MONSTER_EX(self, 'spell_crystal_gem_red', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, SCR_CATACOMB_38_2_SQ_03_ITEM_SET);
                AddScpObjectList(mon1, 'CATACOMB_38_2_SQ_05_SCP_OWNER', self)
                AddScpObjectList(self, 'CATACOMB_38_2_SQ_05_SCP_PC', mon1)
                SetNoDamage(mon1, 1);
                HoverAround(mon1, self, 15, 1, 1.0, 1);
                PlayEffect(mon1, 'F_levitation005_red', 1.5)
                PlayAnim(mon1, "on_loop", 1)

                    local quest_ssn = GetSessionObject(self,'SSN_CATACOMB_38_2_SQ_05')
                    if quest_ssn ~= nil then
                        quest_ssn.Step1 = 1;
                    end
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CATACOMB_38_2_SQ_03_ITEM_MSG2"), 5);
            end
        end
        
        local result2 = SCR_QUEST_CHECK(self, 'CATACOMB_04_SQ_05')
        if result2 == 'PROGRESS' then
            local summon = GetScpObjectList(self, 'CATACOMB_04_SQ_05_SCP')
            if #summon == 0 then
                local x, y, z = GetFrontPos(self, 20)
                local mon1 = CREATE_MONSTER_EX(self, 'spell_crystal_gem_red', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, SCR_CATACOMB_38_2_SQ_03_ITEM_SET2);
                PlayEffect(mon1, 'F_levitation005_red', 1.5)
                AttachEffect(mon1, 'F_light076_spread_in_blue_loop', 0.8, 'BOT')
                PlayAnim(mon1, "on_loop", 1)
                SetOwner(mon1, self, 1)
                SetLifeTime(mon1, 60)
                AddScpObjectList(self, 'CATACOMB_04_SQ_05_SCP', mon1)
            end
        end
    end
end

function SCR_CATACOMB_38_2_SQ_03_ITEM_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "CATACOMB_38_2_SQ_05_AI";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "None"
end

function SCR_CATACOMB_38_2_SQ_03_ITEM_SET2(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "CATACOMB_04_SQ_05_AI";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Enter = "CATACOMB_04_SQ_05_STONE"
end



--CATACOMB_38_2_SQ_06_ITEM
function SCR_USE_CATACOMB_38_2_SQ_06_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_38_2_SQ_06')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_38_2' then
            if GetLayer(self) ~= 0 then
                local x, y, z = GetPos(self)
                local mon1 = CREATE_MONSTER_EX(self, 'noshadow_npc_64', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, SCR_CATACOMB_38_2_SQ_06_ITEM_SET);
                AttachEffect(mon1, 'I_force019_violet', 8.0, 'TOP')
                AttachEffect(mon1, 'F_circle012_violet', 80.0, 'BOT')
                SetLifeTime(mon1, 10);
                SetNoDamage(mon1, 1);
                
                local list, Cnt = SelectObjectByFaction(self, 100, 'Monster')
            	local i
            	
            	for i = 1, Cnt do
                    SetNoDamage(list[i], 0)
                    ObjectColorBlend(list[i], 255, 255, 255, 255, 1, 1)
                    return 1;
            	end
            end
        end
    end
end

function SCR_CATACOMB_38_2_SQ_06_ITEM_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Enter = "CATACOMB_38_2_SQ_06_TRUTHEYES"
end



--CATACOMB_04_SQ_03_ITEM
function SCR_USE_CATACOMB_04_SQ_03_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_04_SQ_03')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_04' then
            if GetLayer(self) == 0 then
                if SCR_QUEST_MONRANK_CHECK(argObj, 'Normal', 'Special', 'Material') == 'YES' then
                    LookAt(self, argObj)
                    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'CATACOMB_04_SQ_03_ITEM')
                    local result = DOTIMEACTION_R(self, ScpArgMsg("CATACOMB_04_SQ_03_ITEM_MSG1"), 'MAKING', animTime, 'SSN_HATE_AROUND')
                    DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'CATACOMB_04_SQ_03_ITEM')
                    if result == 1 then
                        local follower = GetScpObjectList(self, 'CATACOMB_04_SQ_03_FOLLOWER')
                        if #follower < 5 then
                            PlayEffect(argObj, 'F_smoke137_white', 0.5)
                            
                            local x, y, z = GetPos(argObj)
                            Kill(argObj)
                            
                            local mon1 = CREATE_MONSTER_EX(self, 'noshadow_npc', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, SCR_CATACOMB_04_SQ_03_ITEM_SET);
                            AttachEffect(mon1, 'I_force001_yellow', 3.0, 'TOP')
                            SetLifeTime(mon1, 10);
                            SetNoDamage(mon1, 1);
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CATACOMB_04_SQ_03_SOUL_MSG1"), 5);
                        end
                    end
                end
            end
        end
    end
end

function SCR_CATACOMB_04_SQ_03_ITEM_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "CATACOMB_04_SQ_03_SOUL"
	mon.MaxDialog = 1;
end



--CATACOMB_04_SQ_MEMO_ITEM
function SCR_USE_CATACOMB_04_SQ_MEMO_ITEM(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, 'CATACOMB_04_SQ_MEMO_book1', 1)
end



--CATACOMB_38_1_SQ_03_ITEM
function SCR_USE_CATACOMB_38_1_SQ_03_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_38_1_SQ_03')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'id_catacomb_38_1' then
    	        if argObj.Dialog == 'CATACOMB_38_1_OBJ_01' then
                    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'CATACOMB_04_SQ_03_ITEM')
                    local result = DOTIMEACTION_R(self, ScpArgMsg("CATACOMB_38_1_SQ_03_ITEM_MSG1"), 'STANDSPINKLE', animTime, 'SSN_HATE_AROUND')
                    DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'CATACOMB_04_SQ_03_ITEM')
                    if result == 1 then
                        local x, y, z = GetFrontPos(self, 20)
                        local mon1 = CREATE_MONSTER_EX(self, 'noshadow_npc', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, SCR_CATACOMB_38_1_SQ_03_ITEM_SET);
                        PlayEffect(mon1, 'F_smoke005_dark', 0.5)
                        AttachEffect(mon1, 'F_circle014_dark', 8.0, 'MID')
                        SetLifeTime(mon1, 10);
                    end
                end
            end
        end
    end
end

function SCR_CATACOMB_38_1_SQ_03_ITEM_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "CATACOMB_38_1_SQ_03_DARKAURA"
	mon.MaxDialog = 1;
end



--CATACOMB_02_SQ_03_ITEM
function SCR_USE_CATACOMB_02_SQ_03_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_02_SQ_04')
    if result1 == 'PROGRESS' then
        LookAt(self, argObj)
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'CATACOMB_02_SQ_03_ITEM')
        local result = DOTIMEACTION_R(self, ScpArgMsg("CATACOMB_02_SQ_03_ITEM_MSG1"), 'MAKING', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'CATACOMB_02_SQ_03_ITEM')
        if result == 1 then
            local list, cnt = SelectObject(self, 100, 'ALL')
            local i
            local correct_list = 0;
            for i = 1, cnt do
                if list[i].ClassName ~= 'PC' then
    	            if list[i].Dialog == 'CATACOMB_02_OBJ_05_1' or list[i].Dialog == 'CATACOMB_02_OBJ_05_2' or list[i].Dialog == 'CATACOMB_02_OBJ_05_3' then
    	                PlayEffect(list[i], 'F_levitation005', 1.5);
    	                correct_list = correct_list + 1;
    	            end
    	        end
            end
            
            if correct_list >= 1 then
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CATACOMB_02_SQ_03_ITEM_MSG2"), 5);
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CATACOMB_02_SQ_03_ITEM_MSG3"), 5);
            end
        end
    end
        
    local result2 = SCR_QUEST_CHECK(self, 'CATACOMB_02_SQ_05')
    if result2 == 'PROGRESS' then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'CATACOMB_02_SQ_03_ITEM')
        local result = DOTIMEACTION_R(self, ScpArgMsg("CATACOMB_02_SQ_03_ITEM_MSG5"), 'MAKING', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'CATACOMB_02_SQ_03_ITEM')
        if result == 1 then
            local zoneID = GetZoneInstID(self)
            local PC_layer = GetLayer(self)
            local zon_Obj = GetLayerObject(zoneID, PC_layer);
            
            if zon_Obj ~= nil then
                local list, cnt = GetLayerAliveMonList(zoneID, PC_layer);
                
                for i = 1 , cnt do
                    if list[i].Dialog == 'CATACOMB_02_OBJ_06_TRACK01'
                    or list[i].Dialog == 'CATACOMB_02_OBJ_06_TRACK02'
                    or list[i].Dialog == 'CATACOMB_02_OBJ_06_TRACK03'
                    or list[i].Dialog == 'CATACOMB_02_OBJ_06_TRACK04'
                    or list[i].Dialog == 'CATACOMB_02_OBJ_06_TRACK05'
                    or list[i].Dialog == 'CATACOMB_02_OBJ_06_TRACK06'
                    or list[i].Dialog == 'CATACOMB_02_OBJ_06_TRACK07'
                    or list[i].Dialog == 'CATACOMB_02_OBJ_06_TRACK08'
                    or list[i].Dialog == 'CATACOMB_02_OBJ_06_TRACK09' then
--                        AttachEffect(list[i], 'F_levitation005_dark_blue', 2.5, 'BOT')
                        list[i].NumArg1 = 0;
                    end
            	end
            	
            	SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CATACOMB_02_SQ_03_ITEM_MSG4"), 5);
            end
        end
    end
end



--CATACOMB_02_SQ_06_ITEM
function SCR_USE_CATACOMB_02_SQ_06_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'CATACOMB_04_SQ_03')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_04' then
            if GetLayer(self) == 0 then
                LookAt(self, argObj)
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'CATACOMB_02_SQ_06_ITEM')
                local result = DOTIMEACTION_R(self, ScpArgMsg("CATACOMB_02_SQ_06_ITEM_MSG1"), 'MAKING', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'CATACOMB_02_SQ_06_ITEM')
                if result == 1 then
                    local buff = GetBuffByName(argObj, 'CATACOMB_02_SQ_07_BUFF')
                    if buff == nil then
                        AddBuff(argObj, argObj, "CATACOMB_02_SQ_07_BUFF", 1 , 0, 10000, 1)
                        PlayEffect(self, 'I_light013_spark_blue_2', 2.0, nil, 'MID')
                    else
                        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CATACOMB_02_SQ_06_ITEM_MSG2"), 5);
                    end
                end
            end
        end
    end
end



--JOB_CHRONO_6_1_ITEM
function SCR_USE_JOB_CHRONO_6_1_ITEM(self, argObj, argstring, arg1, arg2)
    local questCheck1 = SCR_QUEST_CHECK(self, 'JOB_CHRONO_6_1')
    local questCheck2 = SCR_QUEST_CHECK(self, 'JOB_ALCHEMIST_6_2')
    local questCheck3 = SCR_QUEST_CHECK(self, 'MASTER_CHRONO1')
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
            if questCheck1 == 'PROGRESS' or questCheck2 == 'PROGRESS' then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'JOB_CHRONO_6_1_ITEM')
                local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_CHRONO_6_1_ITEM_MSG1"), 'MAKING', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_CHRONO_6_1_ITEM')
                if result == 1 then
                    if questCheck1 == 'PROGRESS' then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_CHRONO_6_1', 'QuestInfoValue1', 1)
                    end
                    
                    if questCheck2 == 'PROGRESS' then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_ALCHEMIST_6_2', 'QuestInfoValue1', 1)
                    end
                    
                end
            elseif questCheck3 == 'PROGRESS' then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'MASTER_CHRONO1')
                local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_CHRONO_6_1_ITEM_MSG1"), 'MAKING', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'MASTER_CHRONO1')
                if result == 1 then
                    if questCheck3 == 'PROGRESS' then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_MASTER_CHRONO1', 'QuestInfoValue1', 1)
                    end
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_CHRONO_6_1_ITEM_MSG2"), 5);
            end
        end
    end
end



--JOB_ROGUE_6_1_ITEM
function SCR_USE_JOB_ROGUE_6_1_ITEM(self, argObj, argstring, arg1, arg2)
    local questCheck1 = SCR_QUEST_CHECK(self, 'JOB_ROGUE_6_1')
    local questCheck2 = SCR_QUEST_CHECK(self, 'MASTER_ROGUE1')
    if questCheck1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_orchard_34_1' then
            if GetLayer(self) == 0 then
	            if argObj.Faction == 'Monster' then
	                if SCR_QUEST_MONRANK_CHECK(argObj, 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                        LookAt(self, argObj)
                        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'JOB_ROGUE_6_1_ITEM')
                        local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_ROGUE_6_1_ITEM_MSG1"), 'GROPE', animTime, nil)
                        DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_ROGUE_6_1_ITEM')
                        if result == 1 then
                            local is_back = SCR_IS_BACK_CHECK(self,argObj,90)
                            if is_back == 'YES' then
                                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("JOB_ROGUE_6_1_ITEM_MSG2"), 5);
                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_ROGUE_6_1', 'QuestInfoValue1', 1)
                                AddBuff(argObj, argObj, 'JOB_ROGUE_6_1_BUFF', 1, 0, 30000, 1)
                            else
                                LookAt(argObj, self)
                                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_ROGUE_6_1_ITEM_MSG5"), 5);
--                                local rnd = IMCRandom(1, 3)
--                                ChatLocal(argObj, self, ScpArgMsg("JOB_ROGUE_6_1_ITEM_MSG3_"..rnd), 5)
                            end
                            InsertHate(argObj, self, 1)
                        end
                    end
                end
            end
        end
    elseif questCheck2 == 'PROGRESS' then
        if GetZoneName(self) == 'f_orchard_34_1' then
            if GetLayer(self) == 0 then
	            if argObj.Faction == 'Monster' then
	                if SCR_QUEST_MONRANK_CHECK(argObj, 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                        LookAt(self, argObj)
                        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'MASTER_ROGUE1')
                        local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_ROGUE_6_1_ITEM_MSG1"), 'GROPE', animTime, nil)
                        DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'MASTER_ROGUE1')
                        if result == 1 then
                            local is_back = SCR_IS_BACK_CHECK(self,argObj,90)
                            if is_back == 'YES' then
                                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("JOB_ROGUE_6_1_ITEM_MSG2"), 5);
                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_MASTER_ROGUE1', 'QuestInfoValue1', 1)
                                AddBuff(argObj, argObj, 'JOB_ROGUE_6_1_BUFF', 1, 0, 30000, 1)
                            else
                                LookAt(argObj, self)
                                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_ROGUE_6_1_ITEM_MSG5"), 5);
                            end
                            InsertHate(argObj, self, 1)
                        end
                    end
                end
            end
        end
    end
end



--JOB_FALCONER_6_1_ITEM
function SCR_USE_JOB_FALCONER_6_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_FALCONER_6_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            if argObj.Faction == 'Monster' then
                if SCR_QUEST_MONRANK_CHECK(argObj, 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                    if argObj.MoveType == 'Flying' then
                        local sObj = GetSessionObject(self, 'SSN_JOB_FALCONER_6_1');
                        for i = 1, 3 do
                            if sObj['String'..i] == argObj.ClassName then
                                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_FALCONER_6_1_MSG2"), 5);
                                return
                            end
                        end
                        
                        for i = 1, 3 do
                            if sObj['String'..i] == 'None' then
                                LookAt(self, argObj)
                                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'JOB_FALCONER_6_1_ITEM')
                                local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_FALCONER_6_1_MSG1"), 'STANDSPINKLE', animTime, 'SSN_HATE_AROUND')
                                DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_FALCONER_6_1_ITEM')
                                if result == 1 then
                                    InsertHate(argObj, self, 1)
                                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_FALCONER_6_1_MSG3"), 5);
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_FALCONER_6_1', 'QuestInfoValue1', 1)
                                    sObj['String'..i] = argObj.ClassName;
                                    SaveSessionObject(self, sObj)
                                    return
                                end
                            end
                        end
	                end
    	        end
	        end
        end
    end
end



--JOB_ORACLE_6_1_ITEM
function SCR_USE_JOB_ORACLE_6_1_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_ORACLE_6_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            for i = 1, 3 do
                if argObj.Dialog == 'JOB_ORACLE_6_1_TRIGGER'..i then
                    if isHideNPC(self, 'JOB_ORACLE_6_1_OBJ'..i) == 'YES' then
                        local sObj = GetSessionObject(self, 'SSN_JOB_ORACLE_6_1');
                        local list, Cnt = SelectObjectByFaction(self, 200, 'Monster');
                        if Cnt >= 1 then
                            for j = 1, Cnt do
                                InsertHate(list[j], self, 1)
                            end
                        else
                            if sObj['Step'..i] == 0 then
                                sObj['Step'..i] = 1;
                                local mon_x, mon_y, mon_z = GetPos(self)
                                local mon_a = CREATE_MONSTER_EX(self, 'Onion', mon_x + 30, mon_y, mon_z + 30, IMCRandom(0, 359), 'Monster', nil, nil);
                                local mon_b = CREATE_MONSTER_EX(self, 'Onion', mon_x - 30, mon_y, mon_z - 30, IMCRandom(0, 359), 'Monster', nil, nil);
                                InsertHate(mon_a, self, 1)
                                InsertHate(mon_b, self, 1)
                            end
                        end
                        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 3, 'JOB_ORACLE_6_1_ITEM')
                        local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_ORACLE_6_1_MSG1"), 'MAKING', animTime, 'SSN_HATE_AROUND')
                        DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_ORACLE_6_1_ITEM')
                        if result == 1 then
                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_ORACLE_6_1', 'QuestInfoValue1', 1)
                            UnHideNPC(self, 'JOB_ORACLE_6_1_OBJ'..i)
                            local sObj = GetSessionObject(self, 'SSN_JOB_ORACLE_6_1');
                            
                            local list, Cnt = SelectObject(self, 200, 'ALL', 1);
                            if Cnt >= 1 then
                                for k = 1, Cnt do
                                    if list[k].Enter == 'JOB_ORACLE_6_1_OBJ'..i then
                                        PlayEffect(list[k], 'F_burstup015_blue', 1.0, nil, 'BOT')
                                    end
                                end
                            end
                            
                            sObj['QuestMapPointView'..i] = 0;
                            SaveSessionObject(self, sObj)
                            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("JOB_ORACLE_6_1_MSG2"), 5);
                        end
                    else
                        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_ORACLE_6_1_MSG3"), 5);
                    end
                end
	        end
        end
    end
end



--KATYN_10_MQ_04_ITEM
function SCR_USE_KATYN_10_MQ_04_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'KATYN_10_MQ_04')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_10' then
            if GetLayer(self) == 0 then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'KATYN_10_MQ_04_ITEM_01')
                local result = DOTIMEACTION_R(self, ScpArgMsg("KATYN_10_MQ_04_ITEM_01_MSG4"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'KATYN_10_MQ_04_ITEM_01')
                if result == 1 then
                    PlayEffect(self, 'F_light081_ground_orange', 3.0, 'BOT')
                    
                    local list, cnt = SelectObject(self, 200, 'ALL')
                    local i
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'PC' then
            	            if list[i].Dialog == 'KATYN_10_MQ_04_CRYSTAL' then
            	                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("KATYN_10_MQ_04_ITEM_MSG1"), 5);
            	                return;
                            end
                        end
                    end
                    
                    local x, y, z = GetPos(self)
                    if SCR_POINT_DISTANCE(x, z, 4364, -637) < 750 then
                        if SCR_POINT_DISTANCE(x, z, 4269, -1050) < 150 then
                            local mon1 = CREATE_MONSTER_EX(self, 'Altarcrystal_G1', 4269, 135, -1050, 0, 'Neutral', 1, SCR_KATYN_10_MQ_04_ITEM_SET);
                            PlayEffect(mon1, 'F_ground139_light_green', 0.5)
                            AttachEffect(mon1, 'F_light055_green', 5.0, 'MID')
                            SetLifeTime(mon1, 10);
                            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("KATYN_10_MQ_04_ITEM_MSG2"), 5);
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("KATYN_10_MQ_04_ITEM_MSG3"), 5);
                        end
                    end
                end
            end
        end
    end
    
    local result2 = SCR_QUEST_CHECK(self, 'KATYN_10_MQ_05')
    if result2 == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_10' then
            if GetLayer(self) == 0 then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'KATYN_10_MQ_04_ITEM_02')
                local result = DOTIMEACTION_R(self, ScpArgMsg("KATYN_10_MQ_04_ITEM_01_MSG4"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'KATYN_10_MQ_04_ITEM_02')
                if result == 1 then
                    PlayEffect(self, 'F_light081_ground_orange', 4.0, 'BOT')
                    
                    local list, cnt = SelectObject(self, 200, 'ENEMY')
                    local i
                    for i = 1, cnt do
                        if list[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                                local buff = GetBuffByName(list[i], 'KATYN_10_MQ_05_BUFF')
                                if buff == nil then
                                    local rnd = IMCRandom(1,2)
                                    if rnd == 1 then
                                        list[i].NumArg1 = 1;
                                        AttachEffect(list[i], 'F_ground135', 2.0, 'BOT')
                                        AddBuff(self, list[i], 'KATYN_10_MQ_05_BUFF', 1, 0, 60000, 1)
                                    else
                                        AddBuff(self, list[i], 'KATYN_10_MQ_05_BUFF', 1, 0, 30000, 1)
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



function SCR_KATYN_10_MQ_04_ITEM_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "KATYN_10_MQ_04_CRYSTAL"
	mon.MaxDialog = 1;
end



--KATYN_10_MQ_11_ITEM
function SCR_USE_KATYN_10_MQ_11_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'KATYN_12_MQ_02')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_12' then
            if GetLayer(self) == 0 then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x, z, -2890, 1520) < 250 then
                    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'KATYN_10_MQ_11_ITEM')
                    local result = DOTIMEACTION_R(self, ScpArgMsg("KATYN_10_MQ_11_ITEM_MSG05"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                    DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'KATYN_10_MQ_11_ITEM')
                    if result == 1 then
                        local list, cnt = SelectObjectPos(self, -2965, 505, 1673, 100, 'ALL')
                        if cnt > 0 then
                            for i = 1, cnt do
                                if list[i].ClassName ~= 'PC' then
                                    if list[i].Dialog == 'KATYN_12_OBJ_01' then
                                        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("KATYN_10_MQ_11_ITEM_MSG04"), 5);
                                        return;
                                    end
                                end
                            end
                        end
                            
                        PlayEffectLocal(self, self, 'F_bg_light010_yellow_long2', 1.0, nil, 'BOT')
                        
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_KATYN_12_MQ_02', 'Step1', 1)
                        
                        local sObj = GetSessionObject(self, 'SSN_KATYN_12_MQ_02');
                        local rnd = IMCRandom(3, 6)
                        if sObj.Step1 >= rnd then
                            local mon1 = CREATE_MONSTER_EX(self, 'farm49_sapling', -2965, 505, 1673, 0, 'Neutral', 1, SCR_KATYN_10_MQ_11_ITEM_SET);
                            AddVisiblePC(mon1, self, 1);
                            PlayEffectLocal(mon1, self, 'F_lineup015_blue', 0.7, nil, 'BOT')
                            PlayEffectLocal(mon1, self, 'F_light030_blue', 0.7, nil, 'MID')
                            SetLifeTime(mon1, 10);
                            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("KATYN_10_MQ_11_ITEM_MSG03"), 5);
                        else
                            local list, Cnt = SelectObjectByFaction(self, 200, 'Monster');
                            if Cnt >= 1 then
                                for i = 1, Cnt do
                                    InsertHate(list[i], self, 1)
                                end
                                
                                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("KATYN_10_MQ_11_ITEM_MSG01"), 5);
                            else
                                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("KATYN_10_MQ_11_ITEM_MSG02"), 5);
                            end
                        end
                    end
                end
            end
        end
    end
end



function SCR_KATYN_10_MQ_11_ITEM_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("KATYN_12_OBJ_01_NAME")
	mon.Dialog = "KATYN_12_OBJ_01"
	mon.MaxDialog = 1;
end



--KATYN_12_MQ_02_ITEM
function SCR_USE_KATYN_12_MQ_02_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'KATYN_12_MQ_03')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_12' then
            if GetLayer(self) == 0 then
                if argObj ~= nil then
                    if argObj.Faction == 'Monster' then
                        if SCR_QUEST_MONRANK_CHECK(argObj, 'Normal', 'Special', 'Material') == 'YES' then
                            LookAt(self, argObj)
                            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'KATYN_12_MQ_02_ITEM')
                            local result2 = DOTIMEACTION_R(self, ScpArgMsg("KATYN_12_MQ_02_ITEM_MSG01"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                            DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'KATYN_12_MQ_02_ITEM')
                            if result2 == 1 then
                                PlayEffectLocal(argObj, self, 'F_burstup015_blue', 1.0, nil, 'BOT')
                                PlayForceEffectSendPacket(self, argObj, self, 'I_force082_mint', 2.0, 'None', 'F_light029_mint', 1.0, 'None', 'SLOW', 100.0, 1.0, 300.0, 0.0, 5.0, 5.0, 10.0, 0.0)
                                Kill(argObj)
                                
                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_KATYN_12_MQ_03', 'QuestInfoValue1', IMCRandom(5, 10))
                                
                                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("KATYN_12_MQ_02_ITEM_MSG02"), 5);
                            end
            	        end
        	        end
                end
            end
        end
    end
end



--KATYN_12_MQ_03_ITEM
function SCR_USE_KATYN_12_MQ_03_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'KATYN_12_MQ_05')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_12' then
            if GetLayer(self) == 0 then
                local list, cnt = SelectObject(self, 30, 'ALL')
                for i = 1, cnt do
                    if list[i].ClassName == "HiddenTrigger6" then
                        if list[i].Enter == "KATYN_12_OBJ_02" then
                            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'KATYN_12_MQ_05')
                            local result = DOTIMEACTION_R(self, ScpArgMsg("KATYN_12_MQ_07_MSG01"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                            DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'KATYN_12_MQ_05')
                                if result == 1 then
                                local f_x, f_y, f_z = GetFrontPos(self, 30)
                                local mon1 = CREATE_MONSTER_EX(self, 'npc_wooden_romuva_white', f_x, f_y, f_z, -45, 'Neutral', 1, SCR_KATYN_12_MQ_05_SET);
                                SetOwner(mon1, self, 1)
                                SetNoDamage(mon1, 1);
                                PlayEffect(mon1, 'F_lineup015_blue', 0.7)
                                AttachEffect(mon1, 'F_circle012_blue', 7.0, 'BOT')
                                AttachEffect(mon1, 'F_smoke130_blue_loop', 2.0, 'BOT')
                                SetLifeTime(mon1, 5);
                            end
                        end
                    end
                end
            end
        end
    end
    
    local result2 = SCR_QUEST_CHECK(self, 'KATYN_12_MQ_07')
    if result2 == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_12' then
            if GetLayer(self) == 0 then
                if argObj ~= nil then
    	            if argObj.Dialog == 'KATYN_12_OBJ_03_1' or argObj.Dialog == 'KATYN_12_OBJ_03_2' or argObj.Dialog == 'KATYN_12_OBJ_03_3' then
    	                LookAt(self, argObj)
    	                local hate_list, hate_cnt = SelectObject(self, 150, 'ENEMY', 1)
    	                local hate_i;
    	                if hate_cnt >= 1 then
        	                for hate_i = 1, hate_cnt do
                	            if hate_list[hate_i].Faction == 'Monster' then
                	                if SCR_QUEST_MONRANK_CHECK(hate_list[hate_i], 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                	                    InsertHate(hate_list[hate_i], self, 1)
                	                end
                	            end
        	                end
        	            end
    	                
                        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'KATYN_12_MQ_07')
                        local result = DOTIMEACTION_R(self, ScpArgMsg("KATYN_12_MQ_07_MSG01"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                        DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'KATYN_12_MQ_07')
                        if result == 1 then
                            local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
                            local p
                            if P_cnt >= 1 then
                                for p = 1, P_cnt do
                                    if isHideNPC(P_list[p], argObj.Dialog) == 'NO' then
                                        local sObj = GetSessionObject(P_list[p], 'SSN_KATYN_12_MQ_07');
                                        PlayEffectLocal(argObj, P_list[p], 'F_burstup015_blue', 2.0, nil, 'BOT')
                                        PlayEffectLocal(argObj, P_list[p], 'F_burstup007_blue', 0.6, nil, 'BOT')
                                        HideNPC(P_list[p], argObj.Dialog)
                                        sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
                                        
                                        local i;
                                        for i = 1, 3 do
                                            if argObj.Dialog == 'KATYN_12_OBJ_03_'..i then
                                                sObj['QuestMapPointView'..i] = 0;
                                            end
                                        end
                                        
                                        SaveSessionObject(P_list[p], sObj)
                                    end
                                end
                            end
                            
                            
                            
--                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_KATYN_12_MQ_07', 'QuestInfoValue1', 1, nil, nil, nil, argObj.Dialog, 1)
--                            local i;
--                            for i = 1, 3 do
--                                if argObj.Dialog == 'KATYN_12_OBJ_03_'..i then
--                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_KATYN_12_MQ_07', 'QuestMapPointView'..i, nil, 0)
--                                end
--                            end
                        end
        	        end
        	    end
            end
        end
    end
end



function SCR_KATYN_12_MQ_05_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "KATYN_12_MQ_05_AI";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("KATYN_12_MQ_03_ITEM_NAME")
	mon.Dialog = "None"
end



--KATYN_12_SQ_01_ITEM
function SCR_USE_KATYN_12_SQ_01_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'KATYN_12_SQ_01')
    if result1 == 'PROGRESS' then
        ShowBookItem(self, 'KATYN_12_SQ_01_letter01');
    end
end



--JOB_2_PYROMANCER_3_1_ITEM
function SCR_USE_JOB_2_PYROMANCER_3_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_PYROMANCER_3_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            if argObj.Faction == 'Monster' then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'JOB_2_PYROMANCER_3_1_ITEM')
                local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_PYROMANCER_3_1_ITEM_MSG01"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_2_PYROMANCER_3_1_ITEM')
                if result == 1 then
                    local f_x, f_y, f_z = GetFrontPos(self, 30)
                    local mon1 = CREATE_MONSTER_EX(self, 'npc_orb1', f_x, f_y, f_z, -45, 'Neutral', 1, SCR_JOB_2_PYROMANCER_3_1_ITEM_SET);
                    Fly(mon1, 15)
--                    AddVisiblePC(mon1, self, 1);
                    SetOwner(mon1, self, 1)
                    SetNoDamage(mon1, 1);
                    AttachEffect(mon1, 'F_bg_fire002', 1.0, 'BOT')
                    SetLifeTime(mon1, 10);
                    local PT_list, PT_cnt = GET_PARTY_ACTOR(self, 0)
                    if PT_cnt >= 1 then
                        local p
                        for p = 1, PT_cnt do
                            ShowGroundMark(PT_list[p], f_x, f_y, f_z, 90, 10)
                        end
                    end
                end
	        end
        end
    end
end

function SCR_JOB_2_PYROMANCER_3_1_ITEM_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "NO_OWNER_DEAD_AI";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName";
	mon.Enter = "JOB_2_PYROMANCER_3_1_POT"
end



--JOB_2_CRYOMANCER_3_1_ITEM
function SCR_USE_JOB_2_CRYOMANCER_3_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_CRYOMANCER_3_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            local list, cnt = SelectObject(self, 100, 'ENEMY')
            if cnt >= 1 then
                LookAt(self, argObj)
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'JOB_2_CRYOMANCER_3_1_ITEM')
                local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_CRYOMANCER_3_1_ITEM_MSG01"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_2_CRYOMANCER_3_1_ITEM')
                if result == 1 then
                    for i = 1, cnt do
                        if list[i].Faction == 'Monster' then
                            if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                                AddBuff(self, list[i], 'JOB_2_CRYOMANCER_3_1_BUFF', 1, 0, 10000, 1)
                            end
            	        end
        	        end
    	        end
            end
        end
    end
end



--JOB_2_PSYCHOKINO_3_1_ITEM
function SCR_USE_JOB_2_PSYCHOKINO_3_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_PSYCHOKINO_3_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            if argObj.Faction == 'Monster' then
                if SCR_QUEST_MONRANK_CHECK(argObj, 'Normal', 'Special', 'Material') == 'YES' then
                    if argObj.MoveType ~= 'Holding' then
                        local buff = GetBuffByName(argObj, 'JOB_2_PSYCHOKINO_3_1_BUFF')
                        if buff == nil then
                            LookAt(self, argObj)
                            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'JOB_2_PSYCHOKINO_3_1_ITEM')
                            local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_PSYCHOKINO_3_1_ITEM_MSG01"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                            DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_2_PSYCHOKINO_3_1_ITEM')
                            if result == 1 then
                                local x, y, z = GetPos(self);
                        		local angle = GetAngleFromPos(argObj, x, z);
                        		KnockBack(argObj, self, 150, angle, 40, 1)
                        		InsertHate(argObj, self, 1)
                        		AddBuff(self, argObj, 'JOB_2_PSYCHOKINO_3_1_BUFF', 1, 0, 30000, 1)
                        		SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_2_PSYCHOKINO_3_1', 'QuestInfoValue1', 1)
                			end
                		end
            		end
    	        end
            end
        end
    end
end



--JOB_2_PSYCHOKINO_4_1_ITEM
function SCR_USE_JOB_2_PSYCHOKINO_4_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_PSYCHOKINO_4_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            if argObj.Faction == 'Monster' then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'JOB_2_PSYCHOKINO_4_1_ITEM')
                local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_PSYCHOKINO_4_1_ITEM_MSG01"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_2_PSYCHOKINO_4_1_ITEM')
                if result == 1 then
                    local f_x, f_y, f_z = GetFrontPos(self, 30)
                    local mon1 = CREATE_MONSTER_EX(self, 'npc_orb1', f_x, f_y, f_z, -45, 'Neutral', 1, SCR_JOB_2_PSYCHOKINO_4_1_ITEM_SET);
                    Fly(mon1, 15)
--                    AddVisiblePC(mon1, self, 1);
                    SetOwner(mon1, self, 1)
                    SetNoDamage(mon1, 1);
                    AttachEffect(mon1, 'I_light010_2_loop_blue', 0.5, 'MID')
                    SetLifeTime(mon1, 10);
                    ShowGroundMark(self, f_x, f_y, f_z, 30, 10)
                end
	        end
        end
    end
end

function SCR_JOB_2_PSYCHOKINO_4_1_ITEM_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "NO_OWNER_DEAD_AI";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName";
	mon.Enter = "JOB_2_PSYCHOKINO_4_1_BEAD"
end



--JOB_2_WUGUSHI_5_1_ITEM
function SCR_USE_JOB_2_WUGUSHI_5_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_WUGUSHI_5_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            if argObj.Faction == 'Monster' then
                if SCR_QUEST_MONRANK_CHECK(argObj, 'Normal', 'Special', 'Material') == 'YES' then
                    if argObj.Attribute == 'Poison' then
                        LookAt(self, argObj)
                        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'JOB_2_WUGUSHI_5_1_ITEM')
                        local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_WUGUSHI_5_1_ITEM_MSG01"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                        DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_2_WUGUSHI_5_1_ITEM')
                        if result == 1 then
                            local mon_HP = GetHpPercent(argObj)
                            local point = IMCRandom(1, 100) / 100
                            if point >= mon_HP then
                                PlayEffect(argObj, 'F_smoke048_green', 1.0, nil, 'BOT')
                                PlayForceEffect(argObj, self, 'I_force027_green', 0.5, 'None', 'None', 0.0, 'None', 'SLOW', 150.0, 1.0, 1.0, 0.0, 5.0, 5.0, 10.0, 0.0)
                                Kill(argObj)
                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_2_WUGUSHI_5_1', 'QuestInfoValue1', 1)
                                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("JOB_2_WUGUSHI_5_1_ITEM_MSG02"), 5);
                            else
                                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_2_WUGUSHI_5_1_ITEM_MSG03"), 5);
                            end
                        end
                    end
    	        end
	        end
        end
    end
end



--JOB_2_SCOUT_5_1_ITEM
function SCR_USE_JOB_2_SCOUT_5_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_SCOUT_5_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            local pc_zone = GetZoneName(self);
            local zone = {'d_firetower_41', 'd_firetower_42', 'd_firetower_43', 'd_firetower_44', 'd_firetower_45'}
            local x, y, z = GetPos(self)
            local sObj = GetSessionObject(self, 'SSN_JOB_2_SCOUT_5_1')
            if sObj ~= nil then
                for i = 1, #zone do
                    if pc_zone == zone[i] then
                        local record = 0;
                        if i == 1 then
                            if SCR_POINT_DISTANCE(x, z, 559, -1057) < 50 then
                                record = 1;
                            end
                        elseif i == 2 then
                            if SCR_POINT_DISTANCE(x, z, 241, 193) < 50 then
                                record = 1;
                            end
                        elseif i == 3 then
                            if SCR_POINT_DISTANCE(x, z, -298, -1509) < 50 then
                                record = 1;
                            end
                        elseif i == 4 then
                            if SCR_POINT_DISTANCE(x, z, -385, -1408) < 50 then
                                record = 1;
                            end
                        elseif i == 5 then
                            if SCR_POINT_DISTANCE(x, z, 1074, 1264) < 50 then
                                record = 1;
                            end
                        end
                        
                        if record == 1 then
                            if sObj['QuestInfoValue'..i] == 0 then
                                local list, Cnt = SelectObjectByFaction(self, 200, 'Monster');
                                if Cnt >= 1 then
                                    for i = 1, Cnt do
                                        InsertHate(list[i], self, 1)
                                    end
                                end
                                
                                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'JOB_2_SCOUT_5_1_ITEM')
                                local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_SCOUT_5_1_ITEM_MSG01"), 'LOOK', animTime, 'SSN_HATE_AROUND')
                                DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_2_SCOUT_5_1_ITEM')
                                if result == 1 then
                                    sObj['QuestInfoValue'..i] = sObj['QuestInfoMaxCount'..i];
                                    sObj['QuestMapPointView'..i] = 0;
                                    SaveSessionObject(self, sObj)
                                    SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("JOB_2_SCOUT_5_1_ITEM_MSG03"), 5);
                                end
                            else
                                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_2_SCOUT_5_1_ITEM_MSG02"), 5);
                            end
                        end
                    end
                end
            end
        end
    end
end



--JOB_2_WUGUSHI_4_1_ITEM
function SCR_USE_JOB_2_WUGUSHI_4_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_2_WUGUSHI_4_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_33_2' then
            if GetLayer(self) == 0 then
                if argObj.Faction == 'Monster' then
                    if SCR_QUEST_MONRANK_CHECK(argObj, 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                        local buff = GetBuffByName(argObj, 'JOB_2_WUGUSHI_4_1_BUFF')
                        if buff == nil then
                            LookAt(self, argObj)
                            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'JOB_2_WUGUSHI_4_1_ITEM')
                            local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_WUGUSHI_4_1_ITEM_MSG01"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                            DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_2_WUGUSHI_4_1_ITEM')
                            if result == 1 then
                                PlayEffect(argObj, 'F_smoke048_green', 1.0, nil, 'BOT')
                                PlayForceEffect(argObj, self, 'I_force027_green', 0.5, 'None', 'None', 0.0, 'None', 'SLOW', 150.0, 1.0, 1.0, 0.0, 5.0, 5.0, 10.0, 0.0)
                        		InsertHate(argObj, self, 1)
                        		AddBuff(self, argObj, 'JOB_2_WUGUSHI_4_1_BUFF', 1, 0, 30000, 1)
                        		SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_2_WUGUSHI_4_1', 'QuestInfoValue1', 1)
                			end
                		end
            		end
    	        end
            end
        end
    end
end



--JOB_WARLOCK_7_1_ITEM
function SCR_USE_JOB_WARLOCK_7_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_WARLOCK_7_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'id_catacomb_02' then
            if GetLayer(self) == 0 then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'JOB_WARLOCK_7_1_ITEM')
                local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_WARLOCK_7_1_ITEM_MSG01"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_WARLOCK_7_1_ITEM')
                if result == 1 then
                    PlayEffect(self, 'F_circle011_dark', 0.9, nil, 'BOT')
                    local list, cnt = SelectObject(self, 80, 'ENEMY')
                    if cnt >= 1 then
                        for i = 1, cnt do
                            if list[i].Faction == 'Monster' then
                                if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                                    local buff = GetBuffByName(list[i], 'JOB_WARLOCK_7_1_BUFF')
                                    if buff == nil then
                                        PlayEffect(list[i], 'F_burstup025_dark', 1.0, nil, 'BOT')
                                        InsertHate(list[i], self, 1)
                                        AddBuff(self, list[i], 'JOB_WARLOCK_7_1_BUFF', 1, 0, 30000, 1)
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



--JOB_FEATHERFOOT_7_1_ITEM
function SCR_USE_JOB_FEATHERFOOT_7_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_FEATHERFOOT_7_1')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            if argObj.Faction == 'Monster' then
                if SCR_QUEST_MONRANK_CHECK(argObj, 'Normal', 'Special', 'Material') == 'YES' then
                    local buff = GetBuffByName(argObj, 'JOB_FEATHERFOOT_7_1_BUFF')
                    if buff == nil then
                        LookAt(self, argObj)
                        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'JOB_FEATHERFOOT_7_1_ITEM')
                        local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_FEATHERFOOT_7_1_ITEM_MSG1"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                        DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_FEATHERFOOT_7_1_ITEM')
                        if result == 1 then
                            PlayEffect(self, 'F_lineup022_dark', 0.5, nil, 'BOT')
--                            PlayEffect(argObj, 'F_lineup022_dark', 0.8, nil, 'BOT')
                    		InsertHate(argObj, self, 1)
                    		AddBuff(self, argObj, 'JOB_FEATHERFOOT_7_1_BUFF', 1, 0, 30000, 1)
                    		AddBuff(self, argObj, "Stun", 1 , 0, 3000, 1)
                    		SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_FEATHERFOOT_7_1', 'QuestInfoValue1', 1)
            			end
            		else
            		    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_FEATHERFOOT_7_1_ITEM_MSG2"), 5);
            		end
        		end
            end
        end
    end
end



--JOB_KABBALIST_7_1_ITEM
function SCR_USE_JOB_KABBALIST_7_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_KABBALIST_7_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_siauliai_35_1' then
            if GetLayer(self) == 0 then
                local zoneID = GetZoneInstID(self)
                local zon_Obj = GetLayerObject(zoneID, 0);
                if zon_Obj ~= nil then
                    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'JOB_KABBALIST_7_1_ITEM')
                    local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_KABBALIST_7_1_MSG1"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                    DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_KABBALIST_7_1_ITEM')
                    if result == 1 then
                        local list, cnt = GetLayerAliveMonList(zoneID, 0);
                        local mon_list = {}
                        for i = 1 , cnt do
                            if list[i].Faction == 'Monster' then
                                if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                                    mon_list[#mon_list+1] = list[i];
                                end
                            end
                		end
                		
                		local rnd = IMCRandom(1, #mon_list)
                		local mon_num = mon_list[rnd].Lv;
                        local hidden_num = {};
                        local quest_num = 0;
                        for i = 1, 10 do
                            hidden_num[#hidden_num + 1] = mon_num % 10;
                            if mon_num >= 10 then
                                mon_num = math.floor(mon_num / 10);
                            else
                                for j = 1, #hidden_num do
                                    quest_num = quest_num + hidden_num[j]
                                end
                                
                                local sObj = GetSessionObject(self, 'SSN_JOB_KABBALIST_7_1')
                                if sObj ~= nil then
                                    sObj.Step1 = quest_num;
                                    ShowBalloonText(self, quest_num, 10)
                                    PlayTextEffect(self, "I_SYS_Text_Effect_Skill", quest_num)
                                    PlayEffectLocal(self, self, 'I_spread_out001_light_violet2', 1.0, nil, 'MID')
                                    SaveSessionObject(self, sObj)
                                    return
                                end
                            end
                        end
                		
                		SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_KABBALIST_7_1_MSG2"), 5);
                    end
    	        end
            end
        end
    end
end



--JOB_SHINOBI_HIDDEN_ITEM_4
function SCR_USE_JOB_SHINOBI_HIDDEN_ITEM_4(self, argObj, argstring, arg1, arg2)
    ShowBalloonText(self, "JOB_SHINOBI_HIDDEN_ITEM_5_book1", 5)
end



--JOB_SHINOBI_HIDDEN_ITEM_5
function SCR_USE_JOB_SHINOBI_HIDDEN_ITEM_5(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, 'JOB_SHINOBI_HIDDEN_ITEM_5_book2', 1)
end



--ORCHARD_34_1_SQ_2_ITEM
function SCR_USE_ORCHARD_34_1_SQ_2_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_34_1_SQ_2')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'f_orchard_34_1' then
                local sObj = GetSessionObject(self, 'SSN_ORCHARD_34_1_SQ_2')
                if sObj ~= nil then
	                ShowBookItem(self, 'ORCHARD_34_1_SQ_2_book1', 1)
                    if sObj.QuestInfoValue1 == 0 then
                        sObj.QuestInfoValue1 = 1;
                        SaveSessionObject(self, sObj)
                        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("ORCHARD_34_1_SQ_2_ITEM_MSG1"), 5);
    	            end
    	        end
            end
        end
    end
end



--ORCHARD_34_1_SQ_4_ITEM_1
function SCR_USE_ORCHARD_34_1_SQ_4_ITEM_1(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    if argObj ~= nil then
        local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_34_1_SQ_4')
        if result1 == 'PROGRESS' then
            if GetLayer(self) == 0  then
        	    if GetZoneName(self) == 'f_orchard_34_1' then
    	            if argObj.ClassName == 'eldigo_green' then
                        local result2 = DOTIMEACTION_R(self, ScpArgMsg("ORCHARD_34_1_SQ_4_ITEM_1_MSG1"), 'STANDSPINKLE', 1, 'SSN_HATE_AROUND')
                        if result2 == 1 then
                            local buff1 = GetBuffByName(argObj, 'ORCHARD_34_1_SQ_4_BUFF')
                            if buff1 == nil then
                                local x, y, z = GetPos(argObj)
                                local mon = CREATE_MONSTER_EX(self, 'eldigo_green', x, y, z, GetDirectionByAngle(argObj), 'Neutral', argObj.Lv, SCR_ORCHARD_34_1_SQ_4_ITEM_1_SET);
                                Kill(argObj)
                                PlayEffect(mon, 'F_smoke099_white', 0.2, nil, 'BOT')
                                AddBuff(mon, mon, 'ORCHARD_34_1_SQ_4_BUFF_1', 1, 0, 10000, 1)
                                SetDialogRotate(mon, 0)
                                return;
            	            end
            	        end
        	        end
                end
            end
        end
    end
end

function SCR_ORCHARD_34_1_SQ_4_ITEM_1_SET(mon)
	mon.BTree = "None";
	mon.Tactics = "None";
	mon.KDArmor = 999
--	mon.Name = "UnvisibleName";
	mon.SimpleAI = 'None'
	mon.MaxDialog = 1;
	mon.Dialog = 'ORCHARD_34_1_SQ_4_MON'
end



--ORCHARD_34_1_SQ_5_ITEM_1
function SCR_USE_ORCHARD_34_1_SQ_5_ITEM_1(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_orchard_34_1' then
            ShowBookItem(self, 'ORCHARD_34_1_SQ_5_book1', 1)
            
            local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_34_1_SQ_8')
            if result1 == 'PROGRESS' then
                local sObj = GetSessionObject(self, 'SSN_ORCHARD_34_1_SQ_8')
                if sObj ~= nil then
                    if sObj.QuestInfoValue1 == 0 then
                        sObj.QuestInfoValue1 = 1;
                    end
                end
            end
        end
    end
end



--ORCHARD_34_1_SQ_5_ITEM_2
function SCR_USE_ORCHARD_34_1_SQ_5_ITEM_2(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_orchard_34_1' then
            ShowBookItem(self, 'ORCHARD_34_1_SQ_5_book2', 1)
            
            local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_34_1_SQ_8')
            if result1 == 'PROGRESS' then
                local sObj = GetSessionObject(self, 'SSN_ORCHARD_34_1_SQ_8')
                if sObj ~= nil then
                    if sObj.QuestInfoValue2 == 0 then
                        sObj.QuestInfoValue2 = 1;
                    end
                end
            end
        end
    end
end



--ORCHARD_34_1_SQ_5_ITEM_3
function SCR_USE_ORCHARD_34_1_SQ_5_ITEM_3(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_orchard_34_1' then
            ShowBookItem(self, 'ORCHARD_34_1_SQ_5_book3', 1)
            
            local result1 = SCR_QUEST_CHECK(self, 'ORCHARD_34_1_SQ_8')
            if result1 == 'PROGRESS' then
                local sObj = GetSessionObject(self, 'SSN_ORCHARD_34_1_SQ_8')
                if sObj ~= nil then
                    if sObj.QuestInfoValue3 == 0 then
                        sObj.QuestInfoValue3 = 1;
                    end
                end
            end
        end
    end
end



--HIDDEN_RUNECASTER_ITEM_1
function SCR_USE_HIDDEN_RUNECASTER_ITEM_1(self, argObj, argstring, arg1, arg2)
    SCR_USE_HIDDEN_RUNECASTER_ITEM_RUN(self, argObj, argstring, arg1, arg2)
end



--HIDDEN_RUNECASTER_ITEM_2
function SCR_USE_HIDDEN_RUNECASTER_ITEM_2(self, argObj, argstring, arg1, arg2)
    SCR_USE_HIDDEN_RUNECASTER_ITEM_RUN(self, argObj, argstring, arg1, arg2)
end



--HIDDEN_RUNECASTER_ITEM_3
function SCR_USE_HIDDEN_RUNECASTER_ITEM_3(self, argObj, argstring, arg1, arg2)
    SCR_USE_HIDDEN_RUNECASTER_ITEM_RUN(self, argObj, argstring, arg1, arg2)
end



--HIDDEN_RUNECASTER_ITEM_4
function SCR_USE_HIDDEN_RUNECASTER_ITEM_4(self, argObj, argstring, arg1, arg2)
    SCR_USE_HIDDEN_RUNECASTER_ITEM_RUN(self, argObj, argstring, arg1, arg2)
end



--HIDDEN_RUNECASTER_ITEM_5
function SCR_USE_HIDDEN_RUNECASTER_ITEM_5(self, argObj, argstring, arg1, arg2)
    SCR_USE_HIDDEN_RUNECASTER_ITEM_RUN(self, argObj, argstring, arg1, arg2)
end

function SCR_USE_HIDDEN_RUNECASTER_ITEM_RUN(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
        local runestone_item = {
                                'HIDDEN_RUNECASTER_ITEM_1',
                                'HIDDEN_RUNECASTER_ITEM_2',
                                'HIDDEN_RUNECASTER_ITEM_3',
                                'HIDDEN_RUNECASTER_ITEM_4',
                                'HIDDEN_RUNECASTER_ITEM_5'
                                }
        for i = 1, #runestone_item do
            if GetInvItemCount(self, runestone_item[i]) == 0 then
                local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(self, 'Char2_17')
                if _hidden_prop == 257 then
                    ShowBalloonText(self, "HIDDEN_RUNECASTER_runestone_dlg2", 5)
                else
                    ShowBalloonText(self, "HIDDEN_RUNECASTER_runestone_dlg1", 5)
                end
                return;
            end
        end
        
        local tx1 = TxBegin(self);
        for i = 1, #runestone_item do
            if GetInvItemCount(self, runestone_item[i]) >= 1 then
                TxTakeItem(tx1, runestone_item[i], GetInvItemCount(self, runestone_item[i]), 'Quest_HIDDEN_RUNECASTER');
            end
        end
        TxGiveItem(tx1, "HIDDEN_RUNECASTER_ITEM_6", 1, "Quest_HIDDEN_RUNECASTER");
        local ret = TxCommit(tx1);
        if ret == "SUCCESS" then
            SCR_SET_HIDDEN_JOB_PROP(self, 'Char2_17', 258)
            UnHideNPC(self, 'RUNECASTER_MASTER')
        else
            print("tx FAIL!")
        end
    end
end



--PRISON_78_MQ_3_ITEM
function SCR_USE_PRISON_78_MQ_3_ITEM(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
        local _zone = GetZoneName(self)
        local x, y, z = GetPos(self)
        local result_quest = { };
        if _zone == 'd_prison_78' then
            local result_q1 = SCR_QUEST_CHECK(self, 'PRISON_78_MQ_7');
            local result_q2 = SCR_QUEST_CHECK(self, 'PRISON_78_MQ_9');
            if result_q1 ~= 'SUCCESS' and result_q1 ~= 'COMPLETE' then
                if SCR_POINT_DISTANCE(x, z, 366, 1925) <= 900 then
                    SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("PRISON_78_MQ_3_ITEM_FAIL_MSG1"), 5);
                    return;
                end
            elseif result_q2 ~= 'SUCCESS' and result_q2 ~= 'COMPLETE' then
                if SCR_POINT_DISTANCE(x, z, -160, 2148) <= 500 then
                    SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("PRISON_78_MQ_3_ITEM_FAIL_MSG2"), 5);
                    return;
                end
            end
            
            result_quest = {
                            'PRISON_78_MQ_5', 'SUCCESS',
                            'PRISON_78_MQ_6', 'POSSIBLE',
                            'PRISON_78_MQ_6', 'SUCCESS',
                            'PRISON_78_MQ_7', 'POSSIBLE',
                            'PRISON_78_MQ_7', 'SUCCESS',
                            'PRISON_78_MQ_8', 'POSSIBLE',
                            'PRISON_78_MQ_8', 'SUCCESS',
                            'PRISON_78_MQ_9', 'POSSIBLE'
                            }
        end
        
        if _zone == ('d_prison_78' or 'd_prison_79' or 'd_prison_80' or 'd_prison_81' or 'd_prison_82') then
            local _npc = GetScpObjectList(self, 'PRISON_78_MQ_3_ITEM_SCPOBJ')
            if #_npc >= 1 then
                if GetDistance(self, _npc[1]) < 350 then
                    SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("PRISON_78_MQ_3_ITEM_MSG3"), 5);
                    return;
                else
                    local j;
                    for j = 1, #_npc do
                        Kill(_npc[j])
                    end
                end
            end
            
            local i;
            for i = 1, #result_quest/2 do
                if SCR_QUEST_CHECK(self, result_quest[(i*2)-1]) == result_quest[(i*2)] then
                    local result2 = DOTIMEACTION_R(self, ScpArgMsg("PRISON_78_MQ_3_ITEM_MSG2"), 'MAKING', 2, 'SSN_HATE_AROUND')
                    if result2 == 1 then
                        local fx, fy, fz = GetFrontPos(self, 40);
                        local mon = CREATE_MONSTER_EX(self, 'npc_zanas', fx, fy, fz, GetDirectionByAngle(self), 'Neutral', 1, SCR_PRISON_78_MQ_3_ITEM_SET, 'PRISON_78_NPC_2');
                        AddVisiblePC(mon, self, 1);
                        ObjectColorBlend(mon, 10.0, 130.0, 255.0, 180.0, 1)
                        SetFixAnim(mon, 'soul_std')
                        PlayEffect(mon, 'F_lineup020_blue_mint', 0.6, nil, 'BOT')
                        LookAt(mon, self)
                        EnableAIOutOfPC(mon)
                        SetNoDamage(mon, 1);
                        AddScpObjectList(self, 'PRISON_78_MQ_3_ITEM_SCPOBJ', mon)
                        AddScpObjectList(mon, 'PRISON_78_MQ_3_ITEM_SCPPC', self)
                        AddBuff(mon, mon, 'PRISON_78_MQ_3_ITEM_BUFF', 1, 0, 300000, 1)
                        SetLifeTime(mon, 330, 1)
                    end
                    return;
                end
            end
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("PRISON_78_MQ_3_ITEM_MSG1"), 5);
        end
    end
end

function SCR_PRISON_78_MQ_3_ITEM_SET(mon, _dialog)
	mon.BTree = 'None';
	mon.Tactics = 'MON_DUMMY';
    mon.SimpleAI = 'None';
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("PRISON_78_MQ_3_ITEM_NPC_NAME")
	mon.Dialog = _dialog;
end

function SCR_PRISON_78_MQ_3_ITEM_TS_BORN_ENTER(self)
    SCR_MON_DUMMY_TS_BORN_ENTER(self)
end

function SCR_PRISON_78_MQ_3_ITEM_TS_BORN_UPDATE(self)
    local _pc = GetScpObjectList(self, 'PRISON_78_MQ_3_ITEM_SCPPC')
    if #_pc == 0 then
        Kill(self);
    end
end

function SCR_PRISON_78_MQ_3_ITEM_TS_BORN_LEAVE(self)
    SCR_MON_DUMMY_TS_BORN_LEAVE(self)
end

function SCR_PRISON_78_MQ_3_ITEM_TS_DEAD_ENTER(self)
    SCR_MON_DUMMY_TS_DEAD_ENTER(self)
end

function SCR_PRISON_78_MQ_3_ITEM_TS_DEAD_UPDATE(self)
    SCR_MON_DUMMY_TS_DEAD_UPDATE(self)
end

function SCR_PRISON_78_MQ_3_ITEM_TS_DEAD_LEAVE(self)
    SCR_MON_DUMMY_TS_DEAD_LEAVE(self)
end



--PRISON_78_MQ_5_ITEM
function SCR_USE_PRISON_78_MQ_5_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'PRISON_78_MQ_7')
    if result1 == 'PROGRESS' then
        if GetLayer(self) ~= 0  then
    	    if GetZoneName(self) == 'd_prison_78' then
	            if argObj.ClassName == 'boss_Mandara_Q1' then
                    local buff1 = GetBuffByName(argObj, 'PRISON_78_MQ_7_BUFF')
                    if buff1 ~= nil then
                        local result2 = DOTIMEACTION_R(self, ScpArgMsg("PRISON_78_MQ_5_ITEM_MSG1"), 'SCROLL', 2, 'SSN_HATE_AROUND')
                        if result2 == 1 then
                            PlayEffect(self, 'I_bomb008_blue', 1.5, nil, 'MID')
                            PlayEffect(argObj, 'I_rize009', 1.5, nil, 'MID')
                            PlayEffect(argObj, 'F_ground089_blue', 6.0, nil, 'BOT')
        	                RemoveBuff(argObj, 'PRISON_78_MQ_7_BUFF')
                            SetNoDamage(argObj, 0)
                            DetachEffect(argObj, 'I_sphere008_boss_barrier_mash_loop')
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PRISON_78_MQ_5_ITEM_MSG2"), 5);
                        end
    	            else
    	                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PRISON_78_MQ_5_ITEM_MSG3"), 5);
    	            end
    	        end
            end
        end
    end
end



--PRISON_80_MQ_4_ITEM
function SCR_USE_PRISON_80_MQ_4_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'PRISON_80_MQ_5')
    if result1 == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'd_prison_80' then
                local sObj = GetSessionObject(self, 'SSN_PRISON_80_MQ_5')
                if sObj ~= nil then
--                    PlayAnim(self, 'WARP')
                    local result2 = DOTIMEACTION_R(self, ScpArgMsg("PRISON_80_MQ_5_ITEM_MSG2"), 'WARP', 1, 'SSN_HATE_AROUND')
                    if result2 == 1 then
                        SCR_SETPOS_FADEOUT(self, 'd_prison_80', 1242, 148, 71, 15)
                        sObj.QuestInfoValue1 = 1;
                        SaveSessionObject(self, sObj);
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PRISON_80_MQ_5_ITEM_MSG1"), 5);
                    end
                end
            end
        end
    end
end



--PRISON_82_MQ_7_ITEM
function SCR_USE_PRISON_82_MQ_7_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'd_prison_82' then
            local result1 = SCR_QUEST_CHECK(self, 'PRISON_82_MQ_8')
            local result2 = SCR_QUEST_CHECK(self, 'PRISON_82_MQ_9')
            if result1 == 'PROGRESS' then
                if argObj.Faction == 'Monster' then
                    if SCR_QUEST_MONRANK_CHECK(argObj, 'Normal', 'Special', 'Material') == 'YES' then
                        local buff = GetBuffByName(argObj, 'PRISON_82_MQ_8_BUFF')
                        if buff == nil then
                            PlayAnim(self, 'ABSORB')
                            AddBuff(self, argObj, 'PRISON_82_MQ_8_BUFF', 1, 0, 5000, 1)
                            SetLifeTime(argObj, 10)
                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_PRISON_82_MQ_8', 'QuestInfoValue1', 1)
                            return;
                        end
                    end
                end
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PRISON_82_MQ_7_ITEM_MSG1"), 5);
            elseif result2 == 'PROGRESS' then
                if argObj.ClassName ~= 'PC' then
                    if argObj.ClassName == 'mine_crystal_red2_small' then
                        local buff = GetBuffByName(argObj, 'PRISON_82_MQ_8_BUFF')
                        if buff == nil then
                            PlayAnim(self, 'ABSORB')
                            AddBuff(self, argObj, 'PRISON_82_MQ_8_BUFF', 1, 0, 5000, 1)
                            SetLifeTime(argObj, 10)
                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_PRISON_82_MQ_9', 'QuestInfoValue1', 1)
                            return;
                        end
                    end
                end
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PRISON_82_MQ_7_ITEM_MSG1"), 5);
            end
        end
    end
end



--CASTLE_20_3_SQ_5_ITEM_1
function SCR_USE_CASTLE_20_3_SQ_5_ITEM_1(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_3' then
            local result1 = SCR_QUEST_CHECK(self,'CASTLE_20_3_SQ_5')
            if result1 == 'PROGRESS' then
                local _item1 = GetInvItemCount(self, 'CASTLE_20_3_SQ_5_ITEM_1')
                local _item2 = GetInvItemCount(self, 'CASTLE_20_3_SQ_5_ITEM_2')
                if _item1 >= 1 and _item2 >= 1 then
                    local result2 = DOTIMEACTION_R(self, ScpArgMsg("CASTLE_20_3_SQ_5_ITEM_1_MSG1"), 'CRAFT', 2, 'SSN_HATE_AROUND')
                    if result2 == 1 then
                        local tx1 = TxBegin(self);
                        TxTakeItem(tx1, 'CASTLE_20_3_SQ_5_ITEM_1', _item1, 'Quest_CASTLE_20_3_SQ_5_ITEM_1');
                        TxTakeItem(tx1, 'CASTLE_20_3_SQ_5_ITEM_2', _item2, 'Quest_CASTLE_20_3_SQ_5_ITEM_1');
                        TxGiveItem(tx1, "CASTLE_20_3_SQ_5_ITEM_3", 1, "Quest_CASTLE_20_3_SQ_5_ITEM_1");
                        local ret = TxCommit(tx1);
                    end
                end
            end
        end
    end
end



--CASTLE_20_3_SQ_6_ITEM
function SCR_USE_CASTLE_20_3_SQ_6_ITEM(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_3' then
            local result1 = SCR_QUEST_CHECK(self, 'CASTLE_20_3_SQ_7')
            if result1 == 'PROGRESS' then
                if argObj.Dialog == 'CASTLE_20_3_OBJ_7' then
                    local sObj = GetSessionObject(self, 'SSN_CASTLE_20_3_SQ_7')
                    if sObj ~= nil then
                        LookAt(self, argObj)
                        local result2 = DOTIMEACTION_R(self, ScpArgMsg("CASTLE_20_3_SQ_6_ITEM_MSG1"), 'ABSORB', 2, 'SSN_HATE_AROUND')
                        if result2 == 1 then
                            local _way = SCR_4WAY_SIDE_CHECK(self, argObj);
                            if _way == 'BACK' then
                                if sObj.QuestInfoValue1 == 0 then
                                    PlayEffectLocal(argObj, self, 'F_light081_ground_orange', 1.0, nil, 'MID')
                                    PlayEffectLocal(argObj, self, 'F_light081_ground_orange', 1.0, nil, 'BOT')
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE_20_3_SQ_7', 'QuestInfoValue1', 1)
                                    return
                                end
                            elseif _way == 'FRONT' then
                                if sObj.QuestInfoValue2 == 0 then
                                    PlayEffectLocal(argObj, self, 'F_light081_ground_orange', 1.0, nil, 'MID')
                                    PlayEffectLocal(argObj, self, 'F_light081_ground_orange', 1.0, nil, 'BOT')
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE_20_3_SQ_7', 'QuestInfoValue2', 1)
                                    return
                                end
                            elseif _way == 'RIGHT' then
                                if sObj.QuestInfoValue3 == 0 then
                                    PlayEffectLocal(argObj, self, 'F_light081_ground_orange', 1.0, nil, 'MID')
                                    PlayEffectLocal(argObj, self, 'F_light081_ground_orange', 1.0, nil, 'BOT')
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE_20_3_SQ_7', 'QuestInfoValue3', 1)
                                    return
                                end
                            elseif _way == 'LEFT' then
                                if sObj.QuestInfoValue4 == 0 then
                                    PlayEffectLocal(argObj, self, 'F_light081_ground_orange', 1.0, nil, 'MID')
                                    PlayEffectLocal(argObj, self, 'F_light081_ground_orange', 1.0, nil, 'BOT')
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE_20_3_SQ_7', 'QuestInfoValue4', 1)
                                    return
                                end
                            end
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CASTLE_20_3_SQ_6_ITEM_MSG2"), 5);
                        end
                    end
                end
            end
        end
    end
end



--CASTLE_20_3_SQ_3_ITEM_1
function SCR_USE_CASTLE_20_3_SQ_3_ITEM_1(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_3' then
            local result1 = SCR_QUEST_CHECK(self, 'CASTLE_20_3_SQ_10')
            if result1 == 'PROGRESS' then
                LookAt(self, argObj)
                local result2 = DOTIMEACTION_R(self, ScpArgMsg("CASTLE_20_3_SQ_3_ITEM_1_MSG1"), 'SCROLL', 2, 'SSN_HATE_AROUND')
                if result2 == 1 then
                    if argObj.Dialog == 'CASTLE_20_3_OBJ_20_2' then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE_20_3_SQ_10', 'QuestInfoValue1', 1)
                        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CASTLE_20_3_SQ_3_ITEM_1_MSG2"), 5);
                        ShowBookItem(self, 'CASTLE_20_3_SQ_10_book1', 1)
                    else
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CASTLE_20_3_SQ_3_ITEM_1_MSG3"), 5);
                    end
                end
            elseif result1 == 'SUCCESS' or result1 == 'COMPLETE' then
                ShowBookItem(self, 'CASTLE_20_3_SQ_10_book1', 1)
            end
        end
    end
end



--CASTLE_20_3_SQ_1_ITEM
function SCR_USE_CASTLE_20_3_SQ_1_ITEM(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
        local _quest_list = { };
        local book_txt = 'None';
        
	    if GetZoneName(self) == 'f_castle_20_3' then
	        _quest_list = {
                            'CASTLE_20_3_SQ_10',
                            'CASTLE_20_3_SQ_8',
                            'CASTLE_20_3_SQ_7',
                            'CASTLE_20_3_SQ_3',
                            'CASTLE_20_3_SQ_2'
                            }
            book_txt = 'CASTLE_20_3_SQ_clue_';
        elseif GetZoneName(self) == 'f_castle_20_2' then
	        _quest_list = {
                            'CASTLE_20_2_SQ_10',
                            'CASTLE_20_2_SQ_8',
                            'CASTLE_20_2_SQ_7',
                            'CASTLE_20_2_SQ_6',
                            'CASTLE_20_2_SQ_5'
                            }
            book_txt = 'CASTLE_20_2_SQ_clue_';
        else
            return;
        end
        
        local result1 = 'None'
        
        local i
        for i = 1, #_quest_list do
            result1 = SCR_QUEST_CHECK(self, _quest_list[i])
            if result1 == 'COMPLETE' then
                ShowBookItem(self, book_txt..#_quest_list + 1 - i, 1)
                return
            end
        end
        ShowBookItem(self, book_txt, 1)
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CASTLE_20_3_SQ_clue_MSG1"), 5);
    end
end



--CASTLE_20_2_SQ_4_ITEM
function SCR_USE_CASTLE_20_2_SQ_4_ITEM(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_2' then
            local result1 = SCR_QUEST_CHECK(self, 'CASTLE_20_2_SQ_10')
            if result1 == 'PROGRESS' then
                local sObj = GetSessionObject(self, 'SSN_CASTLE_20_2_SQ_10')
                if sObj ~= nil then
                    local _obj = GetScpObjectList(self, 'CASTLE_20_2_SQ_10_SCPOBJ')
                    if #_obj == 0 then
                        LookAt(self, argObj)
                        local result2 = DOTIMEACTION_R(self, ScpArgMsg("CASTLE_20_2_SQ_4_ITEM_MSG1"), 'SCROLL', 2, 'SSN_HATE_AROUND')
                        if result2 == 1 then
                            if argObj.Dialog == 'CASTLE_20_2_OBJ_8' then
                                local _pos = SCR_RANDOM_ARRANGE( { { 310, 0, -796 }, { 365, 0, -726 }, { 404, 0, -831 }, { 446, 0, -783 }, { 389, -4, -896 }, { 466, 0, -866 } } );
                                local mon = { };
                                
                                for i = 1, #_pos do
                                    mon[i] = CREATE_MONSTER_EX(self, 'noshadow_npc', _pos[i][1], _pos[i][2], _pos[i][3], GetDirectionByAngle(self), 'Neutral', 1, SCR_CASTLE_20_2_SQ_4_ITEM_SET);
                                    AddVisiblePC(mon[i], self, 1);
                                    AddScpObjectList(mon[i], 'CASTLE_20_2_SQ_10_SCPPC', self)
                                    AddScpObjectList(self, 'CASTLE_20_2_SQ_10_SCPOBJ', mon[i])
                                    SetTacticsArgStringID(mon[i], 'CASTLE_20_2_SQ_10_SCPPC')
                                    SetNoDamage(mon[i], 1);
                                    EnableAIOutOfPC(mon[i])
                                    if i <= 3 then
                                        mon[i].NumArg1 = 1;
                                        AttachEffect(mon[i], 'I_obelisk_mash', 1.0, 'MID')
                                    else
                                        AttachEffect(mon[i], 'I_obelisk_mash_red', 1.0, 'MID')
                                    end
                                end
                                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CASTLE_20_2_SQ_4_ITEM_MSG2"), 5);
                            end
                        end
                    else
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CASTLE_20_2_SQ_4_ITEM_MSG3"), 5);
                    end
                end
            end
        end
    end
end

function SCR_CASTLE_20_2_SQ_4_ITEM_SET(mon)
	mon.BTree = 'None';
	mon.Tactics = 'NO_SCPLIST_DEAD_TAC';
    mon.SimpleAI = 'None';
	mon.KDArmor = 999
	mon.Name = 'UnvisibleName'
	mon.Dialog = 'CASTLE_20_2_SQ_4_ITEM_SUMMON';
end

function SCR_CASTLE_20_2_SQ_4_ITEM_SUMMON_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'CASTLE_20_2_SQ_10')
    if result1 == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_CASTLE_20_2_SQ_10')
        if sObj ~= nil then
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("CASTLE_20_2_SQ_10_MSG1"), 'ABSORB', 2, 'SSN_HATE_AROUND')
            if result2 == 1 then
                if self.NumArg1 == 1 then
                    sObj.Step1 = sObj.Step1 + 1;
                    SaveSessionObject(pc, sObj)
                    if sObj.Step1 >= 3 then
                        SCR_SEND_ADDON_MSG_PARTY(pc, ScpArgMsg("CASTLE_20_2_SQ_10_MSG2"), 'NOTICE_Dm_scroll', 5, 'CASTLE_20_2_SQ_10/PROGRESS')
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_CASTLE_20_2_SQ_10', 'QuestInfoValue1', 1)
                        
                        local _obj = GetScpObjectList(pc, 'CASTLE_20_2_SQ_10_SCPOBJ');
                        if #_obj >= 1 then
                            local i;
                            for i = 1, #_obj do
                                ClearEffect(_obj[i])
                                PlayEffectLocal(_obj[i], pc, 'I_smoke052_white', 1.0, nil, 'MID')
                                Kill(_obj[i])
                            end
                        end
                    end
                    ClearEffect(self)
                    PlayEffectLocal(self, pc, 'I_smoke052_white', 1.0, nil, 'MID')
                    Kill(self)
                else
                    sObj.Step1 = 0;
                    SaveSessionObject(pc, sObj)
                    
                    local _obj = GetScpObjectList(pc, 'CASTLE_20_2_SQ_10_SCPOBJ');
                    if #_obj >= 1 then
                        local i;
                        for i = 1, #_obj do
                            ClearEffect(_obj[i])
                            PlayEffectLocal(_obj[i], pc, 'I_smoke052_white', 1.0, nil, 'MID')
                            Kill(_obj[i])
                        end
                    end
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CASTLE_20_2_SQ_10_MSG3"), 5);
                end
            end
        end
    end
end



--CASTLE_20_2_SQ_12_ITEM
function SCR_USE_CASTLE_20_2_SQ_12_ITEM(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_2' then
            local result1 = SCR_QUEST_CHECK(self,'CASTLE_20_2_SQ_12')
            if result1 == 'PROGRESS' then
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE_20_2_SQ_12', 'QuestInfoValue1', 1)
            end
            ShowBookItem(self, 'CASTLE_20_2_SQ_12_book1', 1)
        end
    end
end



--CASTLE_20_2_SQ_10_ITEM_1
function SCR_USE_CASTLE_20_2_SQ_10_ITEM_1(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_2' then
            ShowBookItem(self, 'CASTLE_20_2_SQ_10_book1', 1)
        end
    end
end



--CASTLE_20_4_SQ_3_ITEM
function SCR_USE_CASTLE_20_4_SQ_3_ITEM(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_castle_20_4' then
            local result1 = SCR_QUEST_CHECK(self, 'CASTLE_20_4_SQ_4')
            if result1 == 'PROGRESS' then
                LookAt(self, argObj)
                local result2 = DOTIMEACTION_R(self, ScpArgMsg("CASTLE_20_4_SQ_3_ITEM_MSG1"), 'PUBLIC_THROW', 0.7, 'SSN_HATE_AROUND')
                if result2 == 1 then
                    if IsDead(argObj) == 0 then
                        --ForceEffect
                        PlayEffect(argObj, 'F_explosion025', 0.35, nil, 'BOT')
                        Kill(argObj)
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE_20_4_SQ_4', 'QuestInfoValue1', 1)
                    else
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CASTLE_20_4_SQ_3_ITEM_MSG2"), 5);
                    end
                end
            end
        end
    end
end



--CASTLE_20_4_SQ_2_ITEM_2
function SCR_USE_CASTLE_20_4_SQ_2_ITEM_2(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) ~= 0  then
	    if GetZoneName(self) == 'f_castle_20_4' then
            local result1 = SCR_QUEST_CHECK(self, 'CASTLE_20_4_SQ_7')
            if result1 == 'PROGRESS' then
--                local result2 = DOTIMEACTION_R(self, ScpArgMsg("CASTLE_20_4_SQ_2_ITEM_2_MSG1"), 'DRINK', 1, 'SSN_HATE_AROUND')
--                if result2 == 1 then
                    PlayAnim(self, 'DRINK')
                    AddBuff(self, self, 'CASTLE_20_4_SQ_7_BUFF_3', 1, 0, 10000, 1)
--                end
            end
        end
    end
end



--JOB_MIKO_6_1_ITEM
function SCR_USE_JOB_MIKO_6_1_ITEM(self, argObj, argstring, arg1, arg2)
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
                for i = 1, #npc_list do
                    if argObj.Dialog == npc_list[i] then
                        local sObj = GetSessionObject(self, 'SSN_JOB_MIKO_6_1')
                        if sObj ~= nil then
                            if sObj['QuestInfoValue'..i] == 0 then
                                LookAt(self, argObj)
                                local result2 = DOTIMEACTION_R(self, ScpArgMsg("JOB_MIKO_6_1_ITEM_MSG1"), 'SKL_GOHEI', 3.0, 'SSN_HATE_AROUND')
                                if result2 == 1 then
                                    PlayEffectLocal(argObj, self, 'F_spread_out039_green', 0.5, nil, 'BOT')
                                    sObj['QuestInfoValue'..i] = 1;
                                    sObj['QuestMapPointView'..i] = 0;
                                    SaveSessionObject(self, sObj)
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_MIKO_6_1_ITEM_MSG2"), 5);
                                end
                            else
                                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_MIKO_6_1_ITEM_MSG3"), 5);
                            end
                        end
                    end
                end
            end
        end
    end
end



--WTREES_21_2_SQ_1_ITEM
function SCR_USE_WTREES_21_2_SQ_1_ITEM(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_whitetrees_21_2' then
            local result1 = SCR_QUEST_CHECK(self, 'WTREES_21_2_SQ_1')
            if result1 == 'PROGRESS' then
                local result2 = DOTIMEACTION_R(self, ScpArgMsg("WTREES_21_2_SQ_1_ITEM_MSG1"), 'DRINK', 1, 'SSN_HATE_AROUND')
                if result2 == 1 then
                    local sObj = GetSessionObject(self, 'SSN_WTREES_21_2_SQ_1')
                    if sObj ~= nil then
                        sObj.QuestInfoValue1 = 1;
                        SaveSessionObject(self, sObj)
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WTREES_21_2_SQ_1_ITEM_MSG2"), 5);
                    end
                end
            end
        end
    end
end



--WTREES_21_2_SQ_3_ITEM
function SCR_USE_WTREES_21_2_SQ_3_ITEM(self, argObj, argstring, arg1, arg2)
    if argObj.Dialog == 'WTREES_21_2_OBJ_2_1_DUMMY'
    or argObj.Dialog == 'WTREES_21_2_OBJ_2_2_DUMMY'
    or argObj.Dialog == 'WTREES_21_2_OBJ_2_3_DUMMY' then
        LookAt(self, argObj)
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'f_whitetrees_21_2' then
                local result1 = SCR_QUEST_CHECK(self, 'WTREES_21_2_SQ_3')
                if result1 == 'PROGRESS' then
                    local result2 = DOTIMEACTION_R(self, ScpArgMsg("WTREES_21_2_SQ_3_ITEM_MSG1"), 'ABSORB', 2, 'SSN_HATE_AROUND')
                    if result2 == 1 then
                        SCR_RUNSCRIPT_PARTY('SCR_WTREES_21_2_SQ_3_ITEM_RUN', 1, self, argObj)
                        PlayEffectLocal(argObj, self, 'F_lineup022_blue', 0.55, nil, 'BOT')
                    end
                end
            end
        end
    end
end

function SCR_WTREES_21_2_SQ_3_ITEM_RUN(self, argObj)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_whitetrees_21_2' then
            local result1 = SCR_QUEST_CHECK(self, 'WTREES_21_2_SQ_3')
            if result1 == 'PROGRESS' then
                local _hidelist = { 'WTREES_21_2_OBJ_2_1', 'WTREES_21_2_OBJ_2_2', 'WTREES_21_2_OBJ_2_3' }
                for i = 1, 3 do
                    if argObj.Dialog == _hidelist[i]..'_DUMMY' then
                        if isHideNPC(self, _hidelist[i]) == 'YES' then
                            local sObj = GetSessionObject(self, 'SSN_WTREES_21_2_SQ_3')
                            if sObj ~= nil then
                                UnHideNPC(self, _hidelist[i])
                                sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
                                sObj['QuestMapPointView'..i] = 0;
                                SaveSessionObject(self, sObj)
                            end
                        end
                    end
                end
            end
        end
    end
end



--WTREES_21_2_SQ_6_ITEM_1
function SCR_USE_WTREES_21_2_SQ_6_ITEM_1(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    if GetLayer(self) == 0  then
	    if GetZoneName(self) == 'f_whitetrees_21_2' then
            local result1 = SCR_QUEST_CHECK(self, 'WTREES_21_2_SQ_7')
            if result1 == 'PROGRESS' then
	            if argObj.ClassName == 'kucarry_symbani'
	            or argObj.ClassName == 'kucarry_balzer'
	            or argObj.ClassName == 'kucarry_Zeffi' then
                    local result2 = DOTIMEACTION_R(self, ScpArgMsg("WTREES_21_2_SQ_6_ITEM_1_MSG1"), 'ABSORB', 1, 'SSN_HATE_AROUND')
                    if result2 == 1 then
                        AddBuff(argObj, argObj, 'WTREES_21_2_SQ_7_BUFF', 1, 0, 30000, 1)
                        PlayEffect(self, 'F_buff_basic001_violet', 1.0, nil, 'BOT')
                    end
                end
            end
        end
    end
end



--WTREES_21_1_SQ_1_ITEM
function SCR_USE_WTREES_21_1_SQ_1_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'f_whitetrees_21_1' then
        local _quest_list = {
                                { 'WTREES_21_1_SQ_10', 'POSSIBLE', 'PROGRESS', 'SUCCESS', 'COMPLETE' },
                                { 'WTREES_21_1_SQ_9', 'POSSIBLE', 'PROGRESS', 'SUCCESS', 'COMPLETE' },
                                { 'WTREES_21_1_SQ_8', 'POSSIBLE', 'PROGRESS', 'SUCCESS', 'COMPLETE' },
                                { 'WTREES_21_1_SQ_7', 'PROGRESS', 'SUCCESS', 'COMPLETE' },
                                { 'WTREES_21_1_SQ_7', 'POSSIBLE' },
                                { 'WTREES_21_1_SQ_6', 'POSSIBLE', 'PROGRESS', 'SUCCESS', 'COMPLETE' },
                                { 'WTREES_21_1_SQ_5', 'POSSIBLE', 'PROGRESS', 'SUCCESS', 'COMPLETE' },
                                { 'WTREES_21_1_SQ_4', 'POSSIBLE', 'PROGRESS', 'SUCCESS', 'COMPLETE' },
                                { 'WTREES_21_1_SQ_3', 'SUCCESS', 'COMPLETE' },
                                { 'WTREES_21_1_SQ_3', 'PROGRESS' },
                                { 'WTREES_21_1_SQ_3', 'POSSIBLE' }
                            };
        
        local result1 = 'None'
        for i = 1, #_quest_list do
            result1 = SCR_QUEST_CHECK(self, _quest_list[i][1])
            for j = 2, #_quest_list[i] do
                if result1 == _quest_list[i][j] then
                    ShowBookItem(self, 'WTREES_21_1_SQ_1_ITEM_book'..i, 1)
                    return
                end
            end
        end
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WTREES_21_1_SQ_1_ITEM_MSG1"), 5);
    end
end






































































































function SCR_USE_REMAINS37_1_SQ_030_ITEM_1(self, argObj, argstring, arg1, arg2)
--    print(self.Name, argObj.ClassName, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'REMAINS37_1_SQ_030')
    if result == 'PROGRESS' then
        
        local angle = GetLocalAngle(self, argObj)
        local x, y, z = GetPos(argObj)
        local bx, by, bz = GetPos(self)
        RotateToByAngle(self, argObj, angle)
        LookAt(self, argObj)
        PlayAnim(self, "PUBLIC_THROW", 1)
        MslThrow(self, "I_force012_green#Bip01 R Finger41", 0.5,        x, y, z, 5,     0.5,     0.1,       1,       0.8, "I_explosion002_green_L", 1,        0.5);
--      MslThrow(self, eftName,                            eftScale,     x, y, z, range, flyTime, delayTime, gravity, spd, endEftName,                          endScale, eftMoveDelay);

--        local imc_int = IMCRandom(1, 4)
--        if imc_int > 1 then
            if argObj.StrArg1 == 'None' then
                argObj.StrArg1 = 'REMAINS37_1_SQ_030'
                InsertHate(argObj, self, 1)
                AttachEffect(argObj, 'I_force060_dark', 1, "TOP")
                SetEmoticon(argObj, 'I_emo_fear')
                PlayTextEffect(argObj, "I_SYS_Text_Effect_Skill", ScpArgMsg("REMAINS37_1_SQ_030_MSG01"))
            end
--        else
--            local fndList, fndCount = SelectObject(self, 100, 'ALL', 1);
--            local i
--            for i = 1, fndCount do
--                if GetCurrentFaction(fndList[i]) == 'Monster' then
--                    InsertHate(fndList[i], self, 1)
--                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("REMAINS37_1_SQ_030_MSG02"), 5);
--                end
--            end
--        end
    end
end

--THORN392_MQ03_ITEM
function SCR_USE_THORN39_2_MQ03_ITEM_2(self, argObj, argnum1, argnum2)
    local quest_ssn = GetSessionObject(self, 'SSN_THORN39_2_MQ03')
    if argObj.Dialog == "THORN392_MQ_03_P1" then
        if quest_ssn.Step1 == 0 then
            LookAt(self, argObj)
            local result = DOTIMEACTION_R(self, ScpArgMsg("THORN39_2_CURE"), 'SITGROPE2_READY', 1)
            if result == 1 then
                PlayEffect(argObj, 'F_light028_mint2', 1.5, 1, 'BOT')
                PlayEffect(argObj, 'F_light032_green', 1, 1, 'BOT')
                quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
                local j = IMCRandom(1, 2)
                if j == 1 then
                    Chat(argObj, ScpArgMsg("THORN39_2_CURED_1"), 2)
                else
                    Chat(argObj, ScpArgMsg("THORN39_2_CURED_2"), 2)
                end
                quest_ssn.Step1 = 1
            end
        else
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("THORN39_2_ALREADY"), 2)
        end
    elseif argObj.Dialog == "THORN392_MQ_03_P2" then
        if quest_ssn.Step2 == 0 then
            local result = DOTIMEACTION_R(self, ScpArgMsg("THORN39_2_CURE"), 'SITGROPE2_READY', 1)
            if result == 1 then
                PlayEffect(argObj, 'F_light028_mint2', 1.5, 1, 'BOT')
                PlayEffect(argObj, 'F_light032_green', 1, 1, 'BOT')
                quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
                local j = IMCRandom(1, 2)
                if j == 1 then
                    Chat(argObj, ScpArgMsg("THORN39_2_CURED_1"), 2)
                else
                    Chat(argObj, ScpArgMsg("THORN39_2_CURED_2"), 2)
                end
                quest_ssn.Step2 = 1
            end
        else
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("THORN39_2_ALREADY"), 2)
        end
    elseif argObj.Dialog == "THORN392_MQ_03_P3" then
        if quest_ssn.Step3 == 0 then
            local result = DOTIMEACTION_R(self, ScpArgMsg("THORN39_2_CURE"), 'SITGROPE2_READY', 1)
            if result == 1 then
                PlayEffect(argObj, 'F_light028_mint2', 1.5, 1, 'BOT')
                PlayEffect(argObj, 'F_light032_green', 1, 1, 'BOT')
                quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
                local j = IMCRandom(1, 2)
                if j == 1 then
                    Chat(argObj, ScpArgMsg("THORN39_2_CURED_1"), 2)
                else
                    Chat(argObj, ScpArgMsg("THORN39_2_CURED_2"), 2)
                end
                quest_ssn.Step3 = 1
            end
        else
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("THORN39_2_ALREADY"), 2)
        end
    end
end

--REMAINS37_1_SQ_040
function SCR_USE_REMAINS37_1_SQ_040_ITEM_1(self, argObj, argstring, arg1, arg2)
    local x, y, z = GetPos(argObj)
    LookAt(self, argObj)
    PlayAnim(self, "PUBLIC_THROW", 1)
    MslThrow(self, "I_force012_green#Bip01 R Finger41", 0.5,        x, y, z, 5,     0.5,     0.1,       1,       0.8, "I_explosion002_green_L", 1,        0.5);

    sleep(500)
    local mon = CREATE_MONSTER_EX(self, 'Wendigo_archer', x, y, z, GetDirectionByAngle(self), 'Neutral', nil, REMAINS37_1_SQ_040_AI_RUN);
    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("REMAINS37_1_SQ_040_MSG03"), 5);
    Kill(argObj)
	SetLifeTime(mon, 10);
	local angle = GetAngleTo(self, mon)
	--KnockDown(mon, self, 150, angle, 1)
    KnockBack(mon, self, 200, angle, 15, 1)
    SetFixAnim(mon, "KNOCKDOWN", 1)
	SetDialogRotate(mon, 0)
	PlayEffect(mon, 'F_explosion053_smoke', 1.0)
	AddBuff(self, mon, 'Stun_Quest', 1, 0, 10000, 1);
end

function REMAINS37_1_SQ_040_AI_RUN(mon)
    mon.Dialog = "REMAINS37_1_SQ_040_AI_RUN"
	mon.BTree = "None";
	mon.Tactics = "None";
	mon.SimpleAI = 'REMAINS37_1_SQ_040_AI'
	mon.Name = ScpArgMsg("REMAINS37_1_SQ_040_MSG02");
	mon.MaxDialog = 1;
end

function SCR_USE_REMAINS37_2_SQ_010_ITEM_1(self, argObj, argstring, arg1, arg2)

    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 3, 'REMAINS37_2_SQ_010')
    local make_act = DOTIMEACTION_R(self, ScpArgMsg("REMAINS37_2_SQ_010_MSG06"), 'CRAFT', animTime, 'SSN_HATE_AROUND')
    DOTIMEACTION_R_AFTER(self, make_act, animTime, before_time, 'REMAINS37_2_SQ_010')

--    local make_act = DOTIMEACTION_R(self, ScpArgMsg("REMAINS37_2_SQ_010_MSG06"), 'CRAFT', 3)
    if make_act == 1 then
        local quest_ssn = GetSessionObject(self,'SSN_REMAINS37_2_SQ_010')
        if quest_ssn ~= nil then
        
            if quest_ssn.QuestInfoValue3 < quest_ssn.QuestInfoMaxCount3 then
                local item = GetInvItemCount(self, "REMAINS37_2_SQ_010_ITEM_2")
                if item >= 1 then
        
                    quest_ssn.QuestInfoValue3 = quest_ssn.QuestInfoValue3 + 1
                    RunScript('GIVE_TAKE_ITEM_TX', self, 'REMAINS37_2_SQ_010_ITEM_3/1', 'REMAINS37_2_SQ_010_ITEM_2/1', "REMAINS37_2_SQ_010")
                end
            end
        
--            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_REMAINS37_2_SQ_010', 'QuestInfoValue3', 1, nil, 'REMAINS37_2_SQ_010_ITEM_3/1', 'REMAINS37_2_SQ_010_ITEM_2/1')
        end
    end

end

--THORN391_MQ03_BOWL
function SCR_USE_THORN39_1_MQ03_BOWL(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'THORN39_1_MQ05')
    if result == 'PROGRESS' then
        local result1 = DOTIMEACTION_R(self, ScpArgMsg("THORN39_1_MQ05_WATER"), 'SITWATER_LOOP', 2, 'SSN_HATE_AROUND')
        if result1 == 1 then
            if argObj.NumArg1 ~= 0 then
                return;
            else 
                argObj.NumArg1 = 1;
--                local i = IMCRandom(1, 100)
--                if i <= 80 then
                    PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
                    SCR_PARTY_QUESTPROP_ADD(self, nil, nil, nil, nil, 'THORN39_1_MQ05_ITEM/1', nil, nil, nil, nil, nil, nil, 'THORN39_1_MQ05')
                    SCR_THORN39_1_MQ05_MSG(self)
--                else
--                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("THORN39_1_MQ05_FAIL"), 3)
--                end
                Kill(argObj)
            end
        end
    end
end

function SCR_THORN39_1_MQ05_MSG(self)
    local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
    local p
    if P_cnt >= 1 then
        for p = 1, P_cnt do
            local result = SCR_QUEST_CHECK(P_list[p], 'THORN39_1_MQ05')
            if result == 'PROGRESS' then
                local itemCnt = GetInvItemCount(P_list[p], 'THORN39_1_MQ05_ITEM')
                if itemCnt < 7 then
                    SendAddOnMsg(P_list[p], "NOTICE_Dm_GetItem", ScpArgMsg("THORN39_1_MQ05_MSG1"), 3)
                end
            end
        end
    end
end

--REMAINS37_2_SQ_040
function SCR_USE_REMAINS37_2_SQ_040_ITEM_3(self, argObj, argstring, arg1, arg2)

    local result1 = DOTIMEACTION_R(self, ScpArgMsg("REMAINS37_2_SQ_040_MSG01"), 'BURY', 1)
    if result1 == 1 then
        local x, y, z = GetPos(self)
        local layer = GetLayer(self)
        local drop_item = CREATE_NPC(self, "REMAINS37_2_SQ_040_ITEM_4", x, y+100, z, 0, "Peaceful", layer, "UnvisibleName", nil, nil, 0, 1, nil)
--        AddBuff(drop_item, drop_item, 'COMMON_BUFF_DEAD', 1, 0, 2000, 1)
        SetLifeTime(drop_item, 2, 0)
        
        sleep(1000)
        local mon = CREATE_MONSTER_EX(self, "Infrogalas_mage", x + IMCRandom(-50, 50), y, z + IMCRandom(-50, 50), 0, 'Monster', nil, REMAINS37_2_SQ_040_AI_RUN)
        --SetLifeTime(mon, 30, 0)
        AddBuff(self, mon, 'COMMON_BUFF_DEAD', 1, 0, 30000, 1)
        InsertHate(mon, self, 1)
        AddScpObjectList(mon, 'REMAINS37_2_SQ_040', self)
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("REMAINS37_2_SQ_040_MSG02"), 10);
    end
end

function REMAINS37_2_SQ_040_AI_RUN(mon)
    mon.Name = ScpArgMsg("REMAINS37_2_SQ_040_MSG03")
    mon.SimpleAI = "REMAINS37_2_SQ_040_AI";
--    mon.Dialog = 'REMAINS37_2_SQ_040_SUMMON_MONSTER'
--    mon.MaxDialog = 1;
    mon.DropItemList = "None"
end

function REMAINS37_2_SQ_040_AI_ACT_01(self)
end

function REMAINS37_2_SQ_040_AI_DIE_01(self)
    local _pc = GetScpObjectList(self, 'REMAINS37_2_SQ_040')
    if #_pc ~= 0 then
        local i
        for i = 1, #_pc do
            if _pc[i].ClassName == 'PC' then
                local ssn = GetSessionObject(_pc[i], "SSN_REMAINS37_2_SQ_040")
                if ssn ~= nil then
                    SCR_PARTY_QUESTPROP_ADD(_pc[i], 'SSN_REMAINS37_2_SQ_040', 'QuestInfoValue1', 1, nil, 'REMAINS37_2_SQ_040_ITEM_2/1')
                    break
                end
            end
        end
    end

end


--REMAINS37_3_SQ_060
function SCR_USE_REMAINS37_3_SQ_060_ITEM_1(self, argObj, argstring, arg1, arg2)
--    print(self.Name, argObj.ClassName, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'REMAINS37_3_SQ_060')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        PlayAnim(self, "PUBLIC_THROW", 1)
        MslThrow(self, "I_force012_green#Bip01 R Finger41", 0.5,        x, y, z, 5,     0.5,     0.1,       1,       0.8, "I_explosion002_green_L", 1,        0.5);
        sleep(500)
--        local imc_int = IMCRandom(1, 2)
--        if imc_int == 1 then
            if argObj.StrArg1 == 'None' then
                argObj.StrArg1 = 'REMAINS37_3_SQ_060'
                AttachEffect(argObj, 'I_smoke007_green', 2, "MID");
                PlayTextEffect(argObj, "I_SYS_Text_Effect_Skill", ScpArgMsg("REMAINS37_3_SQ_060_MSG01"))
                InsertHate(argObj, self, 1)
            end
--        else
--            local fndList, fndCount = SelectObject(self, 100, 'ALL', 1);
--            local i
--            for i = 1, fndCount do
--                if GetCurrentFaction(fndList[i]) == 'Monster' then
--                    InsertHate(fndList[i], self, 1)
--                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("REMAINS37_3_SQ_060_MSG02"), 5);
--                end
--            end
--        end
    end
end

--REMAINS37_3_SQ_090
function SCR_USE_REMAINS37_3_SQ_090_ITEM_2(self, argObj, argstring, arg1, arg2)
    local make_act = DOTIMEACTION_R(self, ScpArgMsg("REMAINS37_3_SQ_090_MSG01"), 'CRAFT', 3)
    if make_act == 1 then
        local quest_ssn = GetSessionObject(self,'SSN_REMAINS37_3_SQ_090')
        if quest_ssn ~= nil then
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_REMAINS37_3_SQ_090', 'QuestInfoValue3', 1, nil, 'REMAINS37_3_SQ_090_ITEM_3/1', 'REMAINS37_3_SQ_090_ITEM_1/1')
        end
    end
end

--REMAINS37_3_SQ_091
function SCR_USE_REMAINS37_3_SQ_090_ITEM_3(self, argObj, strArg, numArg1, humarg2, itemClassID, itemID)
    local result = SCR_QUEST_CHECK(self, 'REMAINS37_3_SQ_091')
    if result == 'PROGRESS' then
--        local make_act = DOTIMEACTION_R(self, ScpArgMsg("REMAINS37_3_SQ_091_MSG01"), 'skl_assistattack_metaldetector', 1.5)
        local make_act = DOTIMEACTION_R_DUMMY_ITEM(self, ScpArgMsg("REMAINS37_3_SQ_091_MSG01"), 'skl_assistattack_metaldetector', 2, nil, nil, 630013, "RH")
        if make_act == 1 then
            AttachEffect(self, "E_circle001", 4, 'MID');
    
            local x, y, z = GetPos(self)
            local layer = GetLayer(self)
            local mon = CREATE_MONSTER_EX(self, 'noshadow_npc', x+(IMCRandom(-100, 100)), y, z+(IMCRandom(-100, 100)), 0, 'Neutral', self.Lv, REMAINS37_3_SQ_091_AI_RUN);
            SetLifeTime(mon, 20)
--            local x_mon, y_mon, z_mon = GetPos(mon)
            AddScpObjectList(self, "REMAINS37_3_SQ_091", mon);
            AddScpObjectList(mon, "REMAINS37_3_SQ_091", self);
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("REMAINS37_3_SQ_091_MSG02"), 3);
--            PlayAnim(self, "skl_assistattack_metaldetector", 1)
--            SCR_MOVEEX_HOLD(self, mon, x_mon, y_mon, z_mon, 5)
            
        end
    end
end

function REMAINS37_3_SQ_091_AI_RUN(mon)
    mon.Name = "UnvisibleName"
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'REMAINS37_3_SQ_091_AI'
    mon.Dialog = 'REMAINS37_3_SQ_091_METAL'
    mon.MaxDialog = 1
end

function REMAINS37_3_SQ_091_AI_ACT_01(self)
    local PC_Owner = GetOwner(self)
    local list = GetScpObjectList(self, 'REMAINS37_3_SQ_091')
    if #list == 0 then
        Kill(self)
    else
        if list[1].ClassName == 'PC' then
            local quest_ssn = GetSessionObject(list[1],'SSN_REMAINS37_3_SQ_091')
            if quest_ssn == nil then
                Kill(self)
            end
        end
    end
    

end

--REMAINS37_3_SQ_DEMERTRIJUS_RECORD
function SCR_USE_DEMERTRIJUS_RECORD(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, 'DEMERTRIJUS_RECORD', 1)
end

--REMAINS37_2_SQ_AITVARAS_RECORD
function SCR_USE_AITVARAS_RECORD(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, 'AITVARAS_RECORD', 1)
end

--REMAINS37_1_SQ_PROPHECY
function SCR_USE_PROPHECY_COPY(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, 'PROPHECY_COPY', 1)
end

--FLASH63_SQ_02_ITEM
function SCR_USE_FLASH63_SQ_02_ITEM(self, argObj, argstring, arg1, arg2)
    if IsBuffApplied(argObj, 'FLASH63_SQ_02_CK') == 'NO' then
        AddBuff(argObj, argObj, 'FLASH63_SQ_02_CK', 1, 0, 20000, 1)
    end
    LookAt(argObj, self)
    PlayAnim(self, "PUBLIC_THROW")
    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_FLASH63_SQ_02', 'QuestInfoValue1', 1)
end

--PARTY_Q_040_ITEM
function SCR_USE_PARTY_Q_040_ITEM(self, argObj, argstring, arg1, arg2)
    local result = DOTIMEACTION_R(self, ScpArgMsg("PARTY_Q_040_ITEM_USE"), 'MAKING', 2)
    if result == 1 then
        PlayEffectLocal(self, self, "F_light018", 2, 0,"MID")
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_PARTY_Q_040', 'QuestInfoValue1', 1)
    end
end

--PARTY_Q5_ITEM02
function SCR_USE_PARTY_Q5_ITEM02(self, argObj, argstring, arg1, arg2)
    local result = DOTIMEACTION_R(self, ScpArgMsg("PARTY_Q5_ITEM02"), 'EVENT_UPGRADEGEM', 2)
    if result == 1 then
        PlayEffectLocal(self, self, "F_light072", 2, 0, "MID")
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_PARTY_Q_050', 'QuestInfoValue1', 1, nil, "PARTY_Q5_ITEM03/1", "PARTY_Q5_ITEM02/1")
    end
end

--PARTY_Q5_ITEM03
function SCR_USE_PARTY_Q5_ITEM03(self, argObj, argstring, arg1, arg2)
    local zoneID = GetZoneInstID(self)
    local pos_list = SCR_CELLGENPOS_LIST(self, 'Front2', 0)
    if #pos_list > 0 then
        for i = 1, #pos_list do
            if IsValidPos(zoneID, pos_list[i][1], pos_list[i][2], pos_list[i][3]) == 'YES' then
            local result = DOTIMEACTION_R(self, ScpArgMsg("PARTY_Q5_ITEM03"), 'BURY', 2)
                if result == 1 then
                    AttachEffect(self, "E_circle001", 4, 'MID');
                    local x, y, z = GetPos(self)
                    local layer = GetLayer(self)
                    local mon = CREATE_MONSTER_EX(self, 'npc_orb1', pos_list[i][1],pos_list[i][2],pos_list[i][3], 0, 'Neutral', self.Lv, PARTY_Q5_ITEM03_RUN);
                    --SetLifeTime(mon, 13, 0)
                    SetOwner(mon, self)
                    SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("PARTY_Q5_ITEM03_USE"), 4);
                end
            end
        end
    end
end

function PARTY_Q5_ITEM03_RUN(mon)
    mon.Name = ScpArgMsg("PARTY_Q5_ITEM03_NAME")
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = "PARTY_Q5_ITEM03_AI"
end

--PARTY_Q7_ICEITEM
function SCR_USE_PARTY_Q7_ICEITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local result = DOTIMEACTION_R(self, ScpArgMsg("PARTY_Q7_ICEITEM_USE"), 'MAKING', 1)
    if result == 1 then
        PlayEffect(argObj, "I_explosion006_ice", 1.3, "MID")
        AddBuff(self, argObj, "ROKAS_ICE_DEBUFF", 1, 0, 10000, 1)
        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("PARTY_Q7_ICEITEM_SUCC"), 4);
    end
end

--PARTY_Q8_CRYSTAL
function SCR_USE_PARTY_Q8_CRYSTAL(self, argObj, argstring, arg1, arg2)
    local result01 = SCR_QUEST_CHECK(self, 'PARTY_Q_080')
    local result02 = SCR_QUEST_CHECK(self, 'PARTY_Q_081')
    if result01 == "PROGRESS" then
        local sObj = GetSessionObject(self, "SSN_PARTY_Q_080")
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'npc_orb1', x, y+10, z, 0, 'Neutral', self.Lv, PARTY_Q8_CRYSTAL_FUNC);
        SetOwner(mon, self, 1)
        SetLifeTime(mon, 23)
        sObj.Step1 = 1
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PARTY_Q8_CRYSTAL_USE"), 3)
    elseif result02 == "PROGRESS" then
        local list, cnt = SelectObject(self, 200, 'ALL', 1)
        local i
        for i = 1, cnt do
            if list[i].ClassName == "HiddenTrigger4" then
                local skill = GetNormalSkill(self);
                ForceDamage(self, skill, list[i], self, 0, 'MOTION', 'BLOW', 'I_force079_yellow', 1, 'arrow_cast', 'F_pc_drug_spup', 2, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
                AddBuff(self, self, 'PARTY_Q8_CRYSTAL_FIND', 1, 0, 10000, 1)
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PARTY_Q8_CRYSTAL_USE02"), 3)
            end
        end
    end
end

function PARTY_Q8_CRYSTAL_FUNC(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'PARTY_Q8_CRYSTAL_RUN_AI'
    mon.Faction = "Neutral"
    mon.KDArmor = 999
    mon.Name = ScpArgMsg('PARTY_Q8_CRYSTAL_NAME')
end

--PARTY_Q10_CRYSTAL
function SCR_USE_PARTY_Q10_CRYSTAL(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PARTY_Q_101')
    if result == 'PROGRESS' then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x+IMCRandom(-15, 15), y+15, z+IMCRandom(-15, 15), GetDirectionByAngle(self), 'Our_Forces', self.Lv, PARTY_Q10_CRYSTAL_FUNC);
        SET_NPC_BELONGS_TO_PC(mon, self)
        SetLifeTime(mon, 20);
    end
end

function PARTY_Q10_CRYSTAL_FUNC(mon)
    mon.Faction = 'Our_Forces'
    mon.Name = ScpArgMsg('PARTY_Q10_CRYSTAL_NAME')
    mon.SimpleAI = 'PARTY_Q10_CRYSTAL_AI'
end

--UNDERFORTRESS65_SQ020_BOOM
function SCR_USE_UNDERFORTRESS65_SQ020_BOOM(self, argObj, argstring, arg1, arg2)
    local Quest_result = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_65_SQ020')
    local sObj = GetSessionObject(self, "SSN_UNDERFORTRESS_65_SQ020")
    if Quest_result == 'PROGRESS' then
        LookAt(self, argObj)
        local Ani_result = DOTIMEACTION_R(self, ScpArgMsg("UNDER65_SQ02_BOMB_TOOLKIT"), 'MAKING', 1)
        if Ani_result == 1 then
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_UNDERFORTRESS_65_SQ020', 'QuestInfoValue1', 1, nil, "UNDERFORTRESS65_SQ010_BOOM/1")
            local list, cnt = SelectObject(self, 80, "ALL", 1)
            for i = 1, cnt do
                if list[i].ClassName == "HiddenTrigger6" then
                    if list[i].Dialog == "UNDER65_SQ02_BOMB_RANGE01" then
                        sObj.Step1 = 1
                    elseif list[i].Dialog == "UNDER65_SQ02_BOMB_RANGE02" then
                        sObj.Step2 = 1
                    elseif list[i].Dialog == "UNDER65_SQ02_BOMB_RANGE03" then
                        sObj.Step3 = 1
                    elseif list[i].Dialog == "UNDER65_SQ02_BOMB_RANGE04" then
                        sObj.Step4 = 1
                    end
                end
            end
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("UNDER65_SQ02_BOMB_SUCC"), 4);
            PlayEffectLocal(argObj, self, "F_pc_making_finish_white", 2, 0, "BOT")
            Kill(argObj)
        end
    end
end

function SCR_USE_UNDER66_MQ6_ITEM01(self, argObj, argstring, arg1, arg2)
    local Quest_result01 = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_66_MQ050')
    local Quest_result02 = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_66_MQ060')
    if Quest_result01 == 'PROGRESS' then
        local x, y, z = GetPos(self)
        LookAt(self, argObj)
        local Ani_result = DOTIMEACTION_R(self, ScpArgMsg("UNDER66_MQ6_ITEM01_ANI"), 'MAKING', 1)
        if Ani_result == 1 then
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_UNDERFORTRESS_65_SQ020', 'QuestInfoValue1', 1, nil, "UNDERFORTRESS65_SQ010_BOOM/1")
            local list, cnt = SelectObjectByClassName(self, 40, "HiddenTrigger6")
            for i = 1, cnt do
                if list[i].ClassName == "HiddenTrigger6" then
                    HideNPC(self, list[i].Enter)
                end
            end
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("UNDER66_MQ6_ITEM01_SUCC"), 4);
            PlayEffectLocal(argObj, self, "F_pc_making_finish_white", 2, 0, "BOT")
        end
    elseif Quest_result02 == "PROGRESS" then
        local Ani_result = DOTIMEACTION_R(self, ScpArgMsg("UNDER66_MQ6_ITEM01_ANI"), 'MAKING', 1)
        if Ani_result == 1 then
            local mon = CREATE_MONSTER_EX(self, 'Box1', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv, UNDER66_BOMB_AI_FUNC);
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("UNDER66_MQ6_ITEM01_SUCC"), 4);
            PlayEffectLocal(argObj, self, "F_pc_making_finish_white", 2, 0, "BOT")
        end
    end
end

function UNDER66_BOMB_AI_FUNC(mon)
    mon.Faction = 'Our_Forces'
    mon.Name = ScpArgMsg('UNDER66_MQ6_ITEM01_NAME')
    mon.SimpleAI = 'UNDER66_BOMB'
end

--FLASH_58_SQ_060
function SCR_USE_FLASH_58_SQ_060_ITEM_1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'FLASH_58_SQ_060')
    if result == 'PROGRESS' then
        local fndList, fndCount = SelectObject(self, 120, 'ALL', 1);
        local i
        if fndCount > 0 then
            for i = 1, fndCount do
                if fndList[i].ClassName ~= "PC" then
                    if fndList[i].Dialog == 'FLASH_58_SQ_060_D' then
                        local angle = GetLocalAngle(self, fndList[i])
                        local x,y,z = GetPos(fndList[i])
                        local bx, by, bz = GetPos(self)
                        RotateToByAngle(self, fndList[i], angle)
                        LookAt(self, fndList[i])
    
                        PlayAnim(self, "PUBLIC_THROW", 1)
                        sleep(500)
                        MslThrow(self,    "I_force019_blue#Dummy_R_HAND", 0.5,        x, y, z,   5,      0.55,      0,        1,       0.8,  nil);
                        --MslThrow(self,   eftName,                       eftScale,   x, y, z,   range,  flyTime,  delayTime, gravity, spd,  endEftName,  endScale,    eftMoveDelay);
                        sleep(1000)
                        
                        local ssn = GetSessionObject(self, "SSN_FLASH_58_SQ_060")
                        if ssn.QuestInfoValue2 == 0 then
                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_FLASH_58_SQ_060', 'QuestInfoValue2', 1, nil, nil, "FLASH_58_SQ_060_ITEM_1/1")
                            
                            --PlayEffectLocal(fndList[i], self, "soul_gathering_mchn_2_1_std", 2, 0, 'BOT')
                            --PlayEffectLocal(fndList[i], self, "F_explosion065_violet ", 5, 0, 'BOT')
                            --PlayEffectLocal(fndList[i], self, "F_explosion065_violet", 0.6, 0, 'BOT')
                            
                            if isHideNPC(self, "FLASH_SOUL_COLLECTOR_S3_1_D") == "YES" then
                                UnHideNPC(self, "FLASH_SOUL_COLLECTOR_S3_1_D")                                
                            end
                            
                            PlayEffect(fndList[i], "soul_gathering_mchn_2_1_std", 2.0, 0, 'BOT')
                            PlayEffect(fndList[i], "F_explosion065_violet", 1, 0, 'BOT')
                            PlayEffect(fndList[i], "F_smoke061", 0.6, 0, 'BOT')
                            
                            if isHideNPC(self, "FLASH_SOUL_COLLECTOR_S3_D") == "NO" then
                                HideNPC(self, "FLASH_SOUL_COLLECTOR_S3_D")
                            end
                            
--                            local npc_list, npc_cnt = SelectObject(self, 300, 'ALL', 1);
--                            local j
--                            for j = 1, npc_cnt do
--                                if npc_list[j].ClassName ~= "PC" then
--                                    if npc_list[j].Dialog == "FLASH_SOUL_COLLECTOR_S3_1_D" then
--                                        print(npc_list[j].ClassName )
--                                        --PlayAnimLocal(npc_list[j], self, 'STD2', 1)
--                                    end
--                                end
--                            end
                                                      
                        elseif ssn.QuestInfoValue2 == 1 then
                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_FLASH_58_SQ_060', 'QuestInfoValue2', 1, nil, nil, "FLASH_58_SQ_060_ITEM_1/1")

                            PlayEffect(fndList[i], "soul_gathering_mchn_2_2_std", 2.0, 0, 'BOT')
                            PlayEffect(fndList[i], "F_explosion065_violet", 1, 0, 'BOT')
                            PlayEffect(fndList[i], "F_smoke061", 0.6, 0, 'BOT')

                            if isHideNPC(self, "FLASH_SOUL_COLLECTOR_S3_1_D") == "NO" then
                                HideNPC(self, "FLASH_SOUL_COLLECTOR_S3_1_D")
                            end
                            
                            if isHideNPC(self, "FLASH_SOUL_COLLECTOR_S3_2_D") == "YES" then
                                UnHideNPC(self, "FLASH_SOUL_COLLECTOR_S3_2_D")
                                
                            end
                            
--                            local npc_list, npc_cnt = SelectObject(self, 300, 'ALL', 1);
--                            local k
--                            for k = 1, npc_cnt do
--                                if npc_list[k].ClassName ~= "PC" then
--                                    if npc_list[k].Dialog == "FLASH_SOUL_COLLECTOR_S3_2_D" then
--                                        print(npc_list[k].Dialog)
--                                        PlayAnimLocal(npc_list[k], self, 'STD2', 1)
--                                    end
--                                end
--                            end

                        elseif ssn.QuestInfoValue2 == 2 then
                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_FLASH_58_SQ_060', 'QuestInfoValue2', 1, nil, nil, "FLASH_58_SQ_060_ITEM_1/1")
                            CameraShockWave(self, 2, 99999, 3, 1, 100, 0)
                            KnockDown(self, fndList[i], 150, GetAngleTo(fndList[i], self), 45, 1)
                            
                            local npc_list, npc_cnt = SelectObject(self, 300, 'ALL', 1);
                            local l
                            for l = 1, npc_cnt do
                                if npc_list[l].ClassName ~= "PC" then
                                    if npc_list[l].Dialog == "FLASH_SOUL_COLLECTOR_S3_2_D" then
                                        --print(npc_list[l].Dialog)
                                        PlayAnimLocal(npc_list[l], self, 'DEAD', 1)
                                        --print("dead animation played")
                                    end
                                end
                            end

                            PlayEffect(fndList[i], "soul_gathering_mchn_2_1_std", 2.0, 0, 'BOT')
                            PlayEffect(fndList[i], "F_explosion065_violet", 1, 0, 'BOT')
                            PlayEffect(fndList[i], "F_smoke061", 0.6, 0, 'BOT')
                            
                            if isHideNPC(self, "FLASH_SOUL_COLLECTOR_S3_2_D") == "NO" then
                                HideNPC(self, "FLASH_SOUL_COLLECTOR_S3_2_D")
                            end
                        end
                    end
                end
            end
        end
    end
end

--function SCR_PLAY_LOCALANIM(pc)
--    local npc_list, npc_cnt = SelectObject(pc, 300, 'ALL', 1);
--    local j
--    for j = 1, npc_cnt do
--        if npc_list[j].ClassName ~= "PC" then
--            if npc_list[j].Dialog == "FLASH_SOUL_COLLECTOR_S3_1_D" then
--                print(npc_list[j].ClassName )
--                --PlayAnimLocal(npc_list[j], self, 'STD2', 1)
--            end
--        end
--    end
--end

function SCR_USE_FLASH_58_SQ_070_ITEM_1(self, argObj, argstring, arg1, arg2)
--    print(self.Name, argObj.ClassName, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'FLASH_58_SQ_070')
    if result == 'PROGRESS' then
        PlayAnim(self, "BUFF", 1)
        local imc_int = IMCRandom(1, 2)
        if imc_int == 1 then
            if argObj.StrArg1 == 'None' then
                argObj.StrArg1 = 'FLASH_58_SQ_070'
                AttachEffect(argObj, 'I_light001', 2, "TOP")
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("FLASH_58_SQ_070_MSG03"), 5);
                InsertHate(argObj, self, 1)
--                print(argObj.StrArg1)
            end
        else
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("FLASH_58_SQ_070_MSG01"), 5);
            InsertHate(argObj, self, 1)
        end
    end
end

--SCR_USE_CATACOMB_33_1_SQ_04_FIRE
function SCR_USE_CATACOMB_33_1_SQ_04_FIRE(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, "CATACOMB_33_1_SQ_04")
    
    if result == "PROGRESS" then
        LookAt(self, argObj)
        local result2 = DOTIMEACTION_R(self, ScpArgMsg("CATACOMB_33_1_SQ_04_FIRE_BURN"), "fire", 1)
        
        if result2 == 1 then
            local list, cnt = SelectObjectByFaction(self, 40, "Neutral")
            
            for i = 1, cnt do
                if list[i].ClassName == "Fisherman_green" then
                    if list[i].NumArg1 == 0 then
                    SCR_PARTY_QUESTPROP_ADD(self, "SSN_CATACOMB_33_1_SQ_04", "QuestInfoValue1", 1)
                        list[i].NumArg1 = list[i].NumArg1 + 1
                    RunScript('CATACOMB_33_1_BURNINGMON_DEAD', list[i])
                    end
                end
            end
        end
    end
end

--CATACOMB_33_1_SQ_05_DOLL
function SCR_USE_CATACOMB_33_1_SQ_05_DOLL(self, argObj, argstring, arg1, arg2)
    local follower = GetScpObjectList(self, 'CATACOMB_33_1_SQ_05_DOLL')
    if #follower == 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'castle_of_firepuppet', x+30, y+15, z, GetDirectionByAngle(self), 'Our_Forces', self.Lv, CATACOMB_33_1_SQ_05_DOLL_RUN)
        SET_NPC_BELONGS_TO_PC_LOCAL(mon, self, 'CATACOMB_33_1_SQ_05_DOLL', 2)
        AddScpObjectList(self, 'CATACOMB_33_1_SQ_05_DOLL', mon)
--        CreateSessionObject(mon, "SSN_CATACOMB_33_1_SQ")
    end
end

function CATACOMB_33_1_SQ_05_DOLL_RUN(mon)
    mon.Lv = 30
	mon.BTree = "None"
    mon.Tactics = "None"
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("CATACOMB_33_1_SQ_DOLL_NAME")
	mon.SimpleAI = "CATACOMB_33_1_SQ_05_DOLL"
	mon.WlkMSPD = 100
end

--CATACOMB_33_2_SQ_02_ORB
function SCR_USE_CATACOMB_33_2_SQ_02_ORB(self, argObj, argstring, arg1, arg2)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Altarcrystal_P1', x, y+15, z, GetDirectionByAngle(self), 'Neutral', self.Lv, CATACOMB_33_2_SQ_02_NPC)
    AddScpObjectList(self, 'CATACOMB_33_2_SQ_02_NPC', mon)
    SetLifeTime(mon, 20);
    AttachEffect(mon, 'F_light055_green', 8, 'MID')
    AttachEffect(mon, 'F_ground002', 40, 'BOT')
--    AttachEffect(mon, 'F_cleric_AustrasKoks_shot_ground', 4, 'BOT')
    
end

function CATACOMB_33_2_SQ_02_NPC(mon)
	mon.BTree = "None"
	mon.Tactics = "None"
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("CATACOMB_33_2_SQ_02_ORB_NAME")
end

--CATACOMB_33_2_SQ_03_BURN
function SCR_USE_CATACOMB_33_2_SQ_03_BURN(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, "CATACOMB_33_2_SQ_03")
    
    if result == "PROGRESS" then
        LookAt(self, argObj)
        local result2 = DOTIMEACTION_R(self, ScpArgMsg("CATACOMB_33_1_SQ_04_FIRE_BURN"), "fire", 1)
        
        if result2 == 1 then
            local list, cnt = SelectObjectByFaction(self, 40, "Neutral")
            
            for i = 1, cnt do
                if list[i].ClassName == "Sec_Spector_gh_purple" then
                    if list[i].NumArg1 == 0 then
                        SCR_PARTY_QUESTPROP_ADD(self, "SSN_CATACOMB_33_2_SQ_03", "QuestInfoValue1", 1)
                        list[i].NumArg1 = list[i].NumArg1 + 1
                        RunScript('CATACOMB_33_2_SQ_03_MON_DEAD', list[i])
                    end
                end
            end
        end
    end
end

--UNDER68_MQ3_ITEM01
function SCR_USE_UNDER68_MQ3_ITEM01(self, argObj, argstring, arg1, arg2)
    local Anim_Result = DOTIMEACTION_R(self, ScpArgMsg("UNDER68_MQ3_SETUP"), "BURY", 1)
    local x, y, z = GetPos(self)
    if Anim_Result == 1 then
        local mon = CREATE_MONSTER_EX(self, 'npc_orb1_Q', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv, UNDER68_MQ3_ITEM01_NPC)
        SET_NPC_BELONGS_TO_PC(mon, self)
        SetOwner(mon, self, 1)
        SetLifeTime(mon, 20);
    end
end

function UNDER68_MQ3_ITEM01_NPC(mon)
	mon.BTree = "None"
	mon.Tactics = "None"
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("UNDER68_MQ3_NAME")
	mon.SimpleAI = "UNDER68_MQ3_ITEM01_NPC_AI"
end

--UNDER68_MQ4_ITEM01
function SCR_USE_UNDER68_MQ4_ITEM01(self, argObj, argstring, arg1, arg2)
    local result01 = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_68_MQ040')
    local result02 = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_68_MQ050')
    
    if result01 == 'PROGRESS' then
    local hover = GetScpObjectList(self, 'UNDER68_MQ4_SPIRIT_HOVER')
        if #hover == 0 then
            LookAt(self, argObj)
            local Anim_Result = DOTIMEACTION_R(self, ScpArgMsg("UNDER68_MQ4_ITEM_USE"), "ABSORB", 1)
            if Anim_Result == 1 then
                if IsBuffApplied(argObj, "UNDER68_MQ4_ITEM1_BUFF") == "NO" then
                    AddBuff(self, argObj, "UNDER68_MQ4_ITEM1_BUFF",1, 0, 5000, 1)
                LookAt(argObj, self)
                local msg = {
                                ScpArgMsg("UNDER68_MQ4_ITEM_CHAT01"),
                                ScpArgMsg("UNDER68_MQ4_ITEM_CHAT02"),
                                ScpArgMsg("UNDER68_MQ4_ITEM_CHAT03")
                            }
                Chat(argObj, msg[IMCRandom(1,3)], 3)
                sleep(3000)
                PlayEffect(argObj, "F_smoke012_violet", 0.4, 1, "BOT")
                    local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, UNDER68_MQ4_SPIRIT_FUNC);
                    SetOwner(mon, self, 1)
                    AddScpObjectList(self, 'UNDER68_MQ4_SPIRIT_HOVER', mon)
                    AttachEffect(mon, 'F_light055_blue', 5.0, 'TOP')
                    SetNoDamage(mon, 1);
            --      AddBuff(mon, mon, 'HPLock', mon.MHP, 0, 0, 1)
                    HoverAround(mon, self, 20, 1, 1.0, 1);
                    Kill(argObj)
                end
            end
        elseif #hover > 0 then
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("UNDER68_MQ4_SPIRIT_01"), 4);
        end
    elseif result02 == 'PROGRESS' then
        LookAt(self, argObj)
        if argObj.NumArg1 < 1 then
        local Anim_Result = DOTIMEACTION_R(self, ScpArgMsg("UNDER68_MQ4_ITEM_USE"), "ABSORB", 1)
            if Anim_Result == 1 then
                if GetCurrentFaction(argObj) == "Peaceful" then
--                    SetCurrentFaction(argObj, "Monster");
                    LookAt(argObj, self)
                    local msg = {
                                    ScpArgMsg("UNDER68_MQ5_CHAT01"),
                                    ScpArgMsg("UNDER68_MQ5_CHAT02"),
                                }
                    Chat(argObj, msg[IMCRandom(1,2)], 3)
                    argObj.NumArg4 = 1
                    SetCurrentFaction(argObj, "Monster");
                    SetTendency(argObj, 'Attack')
                    SetTendencysearchRange(argObj, 200)
                    AddBuff(argObj, argObj, "HPLock", 100, 0, 0, 1)
                    ShowBalloonText(self, 'UNDER_68_MQ060_DLG2', 5)
                    InsertHate(argObj,self, 900)
                end
            end
        elseif argObj.NumArg1 >= 1 then
            local hover = GetScpObjectList(self, 'UNDER68_MQ4_SPIRIT_HOVER')
            if #hover == 0 then
                LookAt(self, argObj)
                local Anim_Result = DOTIMEACTION_R(self, ScpArgMsg("UNDER68_MQ4_ITEM_USE"), "ABSORB", 1)
                if Anim_Result == 1 then
                    if IsBuffApplied(argObj, "UNDER68_MQ4_ITEM1_BUFF") == "NO" then
                        AddBuff(self, argObj, "UNDER68_MQ4_ITEM1_BUFF",1, 0, 5000, 1)
                    LookAt(argObj, self)
                    local msg = {
                                    ScpArgMsg("UNDER68_MQ5_CHAT03"),
                                    ScpArgMsg("UNDER68_MQ5_CHAT04"),
                                }
                    Chat(argObj, msg[IMCRandom(1,2)], 3)
                    sleep(2000)
                    PlayEffect(argObj, "F_smoke012_violet", 0.4, 1, "BOT")
                        local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, UNDER68_MQ5_SPIRIT_FUNC);
                        SetOwner(mon, self, 1)
                        AddScpObjectList(self, 'UNDER68_MQ4_SPIRIT_HOVER', mon)
                        AttachEffect(mon, 'F_light055_blue', 5.0, 'TOP')
                        SetNoDamage(mon, 1);
                --      AddBuff(mon, mon, 'HPLock', mon.MHP, 0, 0, 1)
                        HoverAround(mon, self, 20, 1, 1.0, 1);
                        Kill(argObj)
                    end
                end
            elseif #hover > 0 then
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("UNDER68_MQ4_SPIRIT_01"), 4);
            end
        end
    end
end

function UNDER68_MQ4_SPIRIT_FUNC(mon)
    mon.SimpleAI = "UNDER68_MQ4_SPIRIT_AI"
end

function UNDER68_MQ5_SPIRIT_FUNC(mon)
    mon.SimpleAI = "UNDER68_MQ5_SPIRIT_AI"
end

--CATACOMB_33_2_SQ_SYMBOL
function SCR_USE_CATACOMB_33_2_SQ_SYMBOL(self, argObj, argstring, arg1, arg2)
    local list, cnt = SelectObject(self, 300, 'ALL')
    local i
    for i = 1, cnt do
        if list[i].ClassName ~= 'PC' then
            if list[i].ClassName == 'npc_pilgrim_shrine' then
                PlayEffect(self, 'F_buff_basic031_green_line', 1, 'BOT')
                RemoveBuff(list[i], 'SoulDuel_DEF')
                DetachEffect(list[i], 'F_pattern007_dark_loop')
                ShowBalloonText(self, 'CATACOMB_33_2_SYMBOL_USE', 3)
            end
        end
    end
end

--UNDER69_MQ4_ITEM01
function SCR_USE_UNDER69_MQ4_ITEM01(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'UNDERFORTRESS_69_MQ040')
    if result == 'PROGRESS' then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'Altarcrystal_B1', x+IMCRandom(-15, 15), y+15, z+IMCRandom(-15, 15), GetDirectionByAngle(self), 'Our_Forces', self.Lv, UNDER69_MQ4_ITEM01_FUNC);
        SET_NPC_BELONGS_TO_PC(mon, self)
        SetLifeTime(mon, 20);
    end
end

function UNDER69_MQ4_ITEM01_FUNC(mon)
    mon.Faction = 'Our_Forces'
    mon.Name = ScpArgMsg('UNDER_69_MQ4_AI_NAME')
    mon.SimpleAI = 'UNDER69_MQ4_ITEM01_AI'
end

--TABLELAND281_SQ04_ITEM
function SCR_USE_TABLELAND28_1_SQ04_ITEM(self, argObj, argstring, arg1, arg2)
    local quest_ssn = GetSessionObject(self, 'SSN_TABLELAND28_1_SQ04')
    if quest_ssn.Step1 == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("TABLELAND28_1_SQ04_MEMO1"), 3)
    elseif quest_ssn.Step1 == 2 then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("TABLELAND28_1_SQ04_MEMO2"), 3)
    elseif quest_ssn.Step1 == 3 then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("TABLELAND28_1_SQ04_MEMO3"), 3)
    else
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("TABLELAND28_1_SQ04_MEMO4"), 3)
    end
end

--TABLELAND282_SQ06_ITEM1
function SCR_USE_TABLELAND28_2_SQ06_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'TABLELAND28_2_SQ06')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        local result = DOTIMEACTION_R(self, ScpArgMsg("TABLELAND28_2_SQ06_CRACK"), 'CUTVINE_LOOP', 2, 'SSN_HATE_AROUND')
        if result == 1 then
            if argObj.NumArg1 ~= 0 then
                return;
            else 
                argObj.NumArg1 = 1;
--                local i = IMCRandom(1, 3)
--                if i <= 2 then
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("TABLELAND28_2_SQ06_CUT"), 3)
                    SCR_PARTY_QUESTPROP_ADD(self, nil, nil, nil, nil, 'TABLELAND28_2_SQ06_ITEM2/1', nil, nil, nil, nil, nil, nil, 'TABLELAND28_2_SQ06')
                    Kill(argObj)
--                else
--                    SendAddOnMsg(self, "NOTICE_Dm_ResBuff", ScpArgMsg("TABLELAND28_2_SQ06_FAIL"), 3)
--                    Kill(argObj)
--                end
            end
        end
    end
end

--PILGRIM311_SQ_02_ITEM
function SCR_USE_PILGRIM311_SQ_02_ITEM(self, argObj, argstring, arg1, arg2)
    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'PILGRIM311_SQ_02_ITEM')
    local result = DOTIMEACTION_R(self, ScpArgMsg("PILGRIM311_SQ_02_ITEM_MSG1"), 'MAKING', animTime, 'SSN_HATE_AROUND')
    DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'PILGRIM311_SQ_02_ITEM')
    if result == 1 then
        local list, cnt = SelectObjectByFaction(self, 300, 'Monster')
        local i
        if cnt >= 3 then
            for i = 1, 3 do
                if list[i] ~= nil then
                    AddBuff(self, list[i], 'PILGRIM311_SQ_02_ITEM', 1, 0, 120000, 1)
                end
            end
        else
            local rest_mon = 3 - cnt
            if rest_mon <= 0 then
                rest_mon = 3
            end
            
            local j;
            local mon = {};
            local x, y, z = GetPos(self);
            for j = 1, rest_mon do
                mon[j] = CREATE_MONSTER(self, "Sec_Hallowventor", x+IMCRandom(-100, 100), y+5, z+IMCRandom(-100, 100), GetDirectionByAngle(self), "Monster", GetLayer(self))
                AddBuff(self, mon[j], 'PILGRIM311_SQ_02_ITEM', 1, 0, 0, 1)
                SetLifeTime(mon[j], 120, 1)            
            end
    --        local list, cnt = CREATE_MONSTER_CELL(self, 'Sec_Hallowventor', self, 'cardinal_far', rest_mon, 50, 'Monster')
    --        local i
    --        for i = 1, cnt do
    --            AddBuff(self, list[i], 'PILGRIM311_SQ_02_ITEM', 1, 0, 0, 1)
    --            SetLifeTime(list[i], 120, 1)
    --        end
        end 
        PlayEffect(self, 'F_levitation039_green', 0.5, 1, 'BOT')
        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('PILGRIM311_SQ_02_ITEM'), 3);
    end
end



--PILGRIM311_SQ_04_ITEM
function SCR_USE_PILGRIM311_SQ_04_ITEM(self, argObj, argstring, arg1, arg2)
    local Result = DOTIMEACTION_R(self, ScpArgMsg("PILGRIM311_SQ_04_ITEM_DO"), "#SITGROPESET", 1.5)
    if Result == 1 then
        local x, y, z = GetPos(self)
        local trap_mon = CREATE_MONSTER_EX(self, 'Box1', x, y, z, 90, 'Our_Forces', 1, PILGRIM311_SQ_04_ITEM_RUN);
        SetOwner(trap_mon, self)
        SetLifeTime(trap_mon, 60)
        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('PILGRIM311_SQ_04_ITEM_1'), 3);
    end
end

function PILGRIM311_SQ_04_ITEM_RUN(mon)
    mon.SimpleAI = 'PILGRIM311_SQ_04_ITEM_RUN'
    mon.Name = 'UnvisibleName'
    mon.HPCount = 4
end


function PILGRIM311_SQ_04_ITEM_MAKE_DEAD(self)
    local _pc = GetOwner(self)
    if _pc ~= nil then
        local result = SCR_QUEST_CHECK(_pc, 'PILGRIM311_SQ_04')
        if result == 'PROGRESS' then
            local list, cnt = SelectObjectByFaction(self, 250, 'Monster')
            local i
            for i = 1, cnt do
                if i < 5 then
                    SCR_PARTY_QUESTPROP_ADD(_pc, "SSN_PILGRIM311_SQ_04", "QuestInfoValue1", 1)
                    SCR_SENDMSG_CNT(_pc, 'SSN_PILGRIM311_SQ_04', 'scroll', 'PILGRIM311_SQ_04_CNT', 1, 2)
                    PlayEffect(list[i], 'E_explosion_box', 0.8)
                    Dead(list[i])
                else
                    break
                end
            end
        else
            PlayEffect(self, 'E_explosion_box')
            Kill(self)
        end
    else
        PlayEffect(self, 'E_explosion_box')
        Kill(self)
    end
end



function PILGRIM311_SQ_04_ITEM_MAKE(self)
    local _pc = GetOwner(self)
    if _pc ~= nil then
        local result = SCR_QUEST_CHECK(_pc, 'PILGRIM311_SQ_04')
        if result == 'PROGRESS' then
            local list, cnt = SelectObjectByFaction(self, 250, 'Monster')
            local i
            for i = 1, cnt do
                if i >= 5 then
                    break
                end
                local hated = GetHate(list[i], self);
                if hated == 0 then
                    InsertHate(list[i], self, 1)
                    MoveToTarget(list[i], self, 10)
                end
            end
        end
    end
end

--PILGRIM312_SQ_04_ITEM
function SCR_USE_PILGRIM312_SQ_04_ITEM(self, argObj, argstring, arg1, arg2)
    if IsBuffApplied(argObj, 'PILGRIM312_SQ_04_BUFF') == 'NO' then
        AddBuff(self, argObj, 'PILGRIM312_SQ_04_BUFF', 1, 0, 15000, 1)
    end
end

--CATACOMB_33_2_SQ_DOC
function SCR_USE_CATACOMB_33_2_SQ_DOC(self, argObj, argstring, arg1, arg2)
    local list, cnt = SelectObject(self, 20, 'ALL')
    local i
    for i = 1, cnt do
        if list[i].ClassName == 'bonfire_1' then
            if list[i].Faction == 'Peaceful' then
                local act = DOTIMEACTION_R(self, ScpArgMsg("CATACOMB_33_2_BURNING"), "BURY", 1)
                if act == 1 then
                    local x, y, z = GetPos(list[i])
                    local mon = CREATE_MONSTER_EX(self, 'pub_book', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv, CATACOMB_33_2_SQ_BOOK)
                    SetLifeTime(mon, 10)
                    RunScript('CATACOMB_33_2_SQ_BURNING_BOOK', mon)
                    SCR_PARTY_QUESTPROP_ADD(self, "SSN_CATACOMB_33_2_SQ_09", "QuestInfoValue1", 1, nil, nil, 'CATACOMB_33_2_SQ_DOC/1')
                    SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('CATACOMB_33_2_SQ_BURN_T'), 3)
                end
            elseif list[i].Faction ~= 'Peaceful' then
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('CATACOMB_33_2_SQ_BURN_F'), 3)
            end
        end
    end
end

function CATACOMB_33_2_SQ_BOOK(mon)
	mon.BTree = "None"
	mon.Tactics = "None"
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("CATACOMB_33_2_SQ_BOOK_NAME")
	mon.Dialog = "None"
end

--UNDER69_SQ3_ITEM
function SCR_USE_UNDER69_SQ3_ITEM(self, argObj, argstring, arg1, arg2)
    local act = DOTIMEACTION_R(self, ScpArgMsg("UNDER69_SQ3_ANI"), "MAKING", 1)
    if act == 1 then
        if argObj.NumArg1 < 1 then
            argObj.NumArg1 = 1
        local x, y, z = GetPos(argObj)
        local mon1 = CREATE_MONSTER_EX(self, 'mon_paladin_follower1_2', x, y, z, GetDirectionByAngle(self), 'Neutral', 10, UNDER69_SQ3_GHOST);
        PlayEffectLocal(mon1, self, "F_buff_basic025_white_line", 1.2)
        --PlayAnim(mon1, "BORN")
        LookAt(mon1, self)
        SetLifeTime(mon1, 5)
        Chat(mon1, ScpArgMsg("UNDER69_SQ03_CHAT"))
        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('UNDER69_SQ3_DONE'), 3)
        SCR_PARTY_QUESTPROP_ADD(self, "SSN_UNDERFORTRESS_69_SQ030", "QuestInfoValue1", 1)
        Kill(argObj)
        end
    end
end

function UNDER69_SQ3_GHOST(self)
    self.SimpleAI = "ALPHABLANDER_NPC"
    self.Name = ScpArgMsg("UNDER69_SQ3_NAME")
end

--PILGRIM_48_SQ_030_ITEM_1
function SCR_USE_PILGRIM_48_SQ_030_ITEM_1(self, argObj, argstring, arg1, arg2)
    local pc_list, pc_cnt = SelectObject(self, 100, 'ALL', 1)
    local i
    for i = 1, pc_cnt do
        if pc_list[i].ClassName == 'PC' then
            local pc_ssn_main = GetSessionObject(pc_list[i], "ssn_klapeda")
            if pc_ssn_main.PILGRIM_48_SQ_030_BUFF ~= 300 then
                local pc_buff = GetBuffByName(pc_list[i], 'PILGRIM_48_SQ_030_BEGINNER')
                if pc_buff == nil then
                    if pc_list[i].Lv >= 1 and pc_list[i].Lv <= 25 then
                        LookAt(self, pc_list[i])
                        PlayAnim(self, "BUFF", 1)
                        MslThrow(pc_list[i], "I_force015_white", 0.5, 1342, 44, -181, 5, 0.5, 0.1, 1, 0.8, "I_light010", 1, 0.5);
                        sleep(1500)
                        PlayTextEffect(pc_list[i], "I_SYS_Text_Effect_Skill", ScpArgMsg("PILGRIM_48_SQ_030_MSG01"))
                        ShowBalloonText(pc_list[i], "PILGRIM_48_SQ_030_BUFF", 5)
                        AddBuff(self, pc_list[i], 'PILGRIM_48_SQ_030_BEGINNER', 1, 0, 600000, 1)
                        pc_ssn_main.PILGRIM_48_SQ_030_BUFF = 300
                        SCR_PARTY_QUESTPROP_ADD(self, "SSN_PILGRIM_48_SQ_030", "QuestInfoValue1", 1)
                        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('PILGRIM_48_SQ_030_MSG02'), 5)
                    else
                        SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('PILGRIM_48_SQ_030_MSG03'), 5)
                    end
                else
                    SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('PILGRIM_48_SQ_030_MSG05'), 5)
                end
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('PILGRIM_48_SQ_030_MSG04'), 5)
            end
        end
    end
end

--PILGRIM_48_SQ_060_ITEM_1
function SCR_USE_PILGRIM_48_SQ_060_ITEM_1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM_48_SQ_060')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_pilgrimroad_48' then
            if GetLayer(self) == 0 then
                
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1.5, 'PILGRIM_48_SQ_060')
                local result2 = DOTIMEACTION_R(self, ScpArgMsg("PILGRIM_48_SQ_060_MSG01"), 'COMPASS', animTime, 'SSN_HATE_AROUND') 
                DOTIMEACTION_R_AFTER(self, result2, animTime, before_time, 'PILGRIM_48_SQ_060')
                if result2 == 1 then
                
                    local list_spot, cnt_spot = SelectObject(self, 3000, "ALL", 1)
                    local i
                    for i = 1, cnt_spot do
                        if list_spot[i].ClassName ~= "PC" then
                            if list_spot[i].Dialog == "PILGRIM_48_EXCAVATION03" then
                                local angle = GetAngleTo(list_spot[i], self)
                                local x_pc, y_pc, z_pc = GetPos(self)
                                local x_spot, y_spot, z_spot = GetPos(list_spot[i])
                                local dist_spot = SCR_POINT_DISTANCE(x_pc, z_pc, x_spot, z_spot)
                            
                                
                                if dist_spot > 1 and dist_spot <= 150 then
                                
                                    local x_mon = x_pc 
                                    local y_mon = y_pc
                                    local z_mon = z_pc 
                                    local zoneID = GetZoneInstID(self)
                                    if IsValidPos(zoneID, x_mon, y_mon, z_mon) == "YES" then
                                        local list_r, cnt_r = SelectObject(self, 250, "ALL", 1)
                                        local j 
                                        for j = 1, cnt_r do
                                            if list_r[j].ClassName ~= "PC" then
                                                if list_r[j].Dialog ~= "PILGRIM_48_SQ_060_RELIC" then
                                                    local mon_relic = CREATE_MONSTER_EX(self, 'noshadow_npc', x_mon , y_mon, z_mon , 0, 'Neutral', 1, PILGRIM_48_SQ_060_RELIC_AI_RUN);
                                                    SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('PILGRIM_48_SQ_060_MSG08'), 5)
                                                    --SET_NPC_BELONGS_TO_PC(mon_relic, self)
                                                    AddScpObjectList(self, "PILGRIM_48_SQ_060", mon_relic);
                                                    AddScpObjectList(mon_relic, "PILGRIM_48_SQ_060", self);
                                                    --print("ssssssssssssssss")
                                                    break
                                                else
                                                    SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('PILGRIM_48_SQ_060_MSG02'), 5) 
                                                end
                                            end
                                        end
                                    else
                                        SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('PILGRIM_48_SQ_060_MSG03'), 5) 
                                    end
                                
                                elseif dist_spot > 150 and dist_spot <= 500 then
                                    if angle > -120 and angle <= -60 then
                                        ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_01", 5) 
                                    elseif angle > -60 and angle <= -30 then
                                        ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_02", 5) 
                                    elseif angle > -30  and angle <= 45 then
                                        ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_03", 5) 
                                    else
                                        ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_04", 5)
                                         
                                    end
                                
                                elseif dist_spot > 500 and dist_spot <= 750 then
                                    if angle > -120 and angle <= -60 then
                                        ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_05", 5) 
                                    elseif angle > -60 and angle <= -30 then
                                        ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_06", 5) 
                                    elseif angle > -30  and angle <= 45 then
                                        ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_07", 5) 
                                    else
                                        ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_08", 5) 
                                       
                                    end

                                elseif dist_spot > 750 and dist_spot <= 1000 then
                                    if angle > -120 and angle <= -60 then
                                        ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_09", 5) 
                                    elseif angle > -60 and angle <= -30 then
                                        ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_10", 5) 
                                    elseif angle > -30  and angle <= 45 then
                                        ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_11", 5) 
                                    else
                                        ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_12", 5) 
                                       
                                    end
                                    
                                elseif dist_spot > 1000 then
                                    SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('PILGRIM_48_SQ_060_MSG04'), 5)
                                else
                                    SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('PILGRIM_48_SQ_060_MSG04'), 5)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function PILGRIM_48_SQ_060_RELIC_AI_RUN(mon_relic)
    mon_relic.Name = ScpArgMsg("PILGRIM_48_SQ_060_MSG05") 
    mon_relic.Tactics = 'None'
    mon_relic.BTree = 'None'
    mon_relic.Dialog = 'PILGRIM_48_SQ_060_RELIC'
    mon_relic.MaxDialog = 1;
    mon_relic.SimpleAI = 'PILGRIM_48_SQ_060_RELIC_AI'
end

function PILGRIM_48_SQ_060_RELIC_AI_ACT_01(self)
    local PC_Owner = GetOwner(self)
    local list = GetScpObjectList(self, 'PILGRIM_48_SQ_060')
    if #list == 0 then
        Kill(self)
    else
        if list[1].ClassName == 'PC' then
            local quest_ssn = GetSessionObject(list[1],'SSN_PILGRIM_48_SQ_060')
            if quest_ssn == nil then
                Kill(self)
            end
        end
    end

--    local PC_Owner = GetOwner(self)
--    local quest_ssn = GetSessionObject(PC_Owner,'SSN_PILGRIM_48_SQ_060')
--    if quest_ssn == nil then
--        Dead(self)
--    end
end

--PILGRIM_48_SQ_090_ITEM_1
function SCR_USE_PILGRIM_48_SQ_090_ITEM_1(self, argObj, argstring, arg1, arg2)
    local list_spot, cnt_spot = SelectObjectByFaction(self, 300, "Neutral", 1)
    local i
    if cnt_spot > 0 then
        for i = 1, cnt_spot do
            if list_spot[i].Name == "PILGRIM_48_SQ_090_DISTANCE_CHECK" then
                local dist = GetDistance(self, list_spot[i])
                if dist <= 300 then
                    local action = DOTIMEACTION_R(self, ScpArgMsg("PILGRIM_48_SQ_090_MSG01"), 'BURY', 1.5)
                    if action == 1 then
                        PlayEffect(self, "F_smoke139_blue", 1, 'TOP');
                
                        local x, y, z = GetPos(self)
                        local layer = GetLayer(self)
                        local mon = CREATE_MONSTER_EX(self, 'pilgrim_trap_01', x, y, z, 0, 'Neutral', 1, PILGRIM_48_SQ_090_TRAP_AI_RUN);
                        SetLifeTime(mon, 21)
                        SetDialogRotate(mon, 0)
                        --SET_NPC_BELONGS_TO_PC(mon, self)
                        AddScpObjectList(self, "PILGRIM_48_SQ_090", mon);
                        AddScpObjectList(mon, "PILGRIM_48_SQ_090", self);
                        
                        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM_48_SQ_090_MSG02"), 5);            
                    end
                else
                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("PILGRIM_48_SQ_090_MSG07"), 5);
                end
            end
        end
    end
end

function PILGRIM_48_SQ_090_TRAP_AI_RUN(mon)
    mon.Name = 'UnvisibleName'
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.Dialog = 'None'
    mon.SimpleAI = 'PILGRIM_48_SQ_090_TRAP_AI'
    mon.Interactive = "NO"
end

function PILGRIM_48_SQ_090_TRAP_AI_ACT_01(self)
    local PC_Owner = GetOwner(self)
    local list = GetScpObjectList(self, 'PILGRIM_48_SQ_090')
    if #list == 0 then
        Kill(self)
    else
        if list[1].ClassName == 'PC' then
            local quest_ssn = GetSessionObject(list[1],'SSN_PILGRIM_48_SQ_090')
            if quest_ssn == nil then
                Kill(self)
            end
        end
    end

--    local PC_Owner = GetOwner(self)
--    local quest_ssn = GetSessionObject(PC_Owner,'SSN_PILGRIM_48_SQ_090')
--    if quest_ssn == nil then
--        Dead(self)
--    end
end

function PILGRIM_48_SQ_090_TRAP_AI_ACT_02(self)
    local x_trap, y_trap, z_trap = GetPos(self)
    local mon_list, mon_cnt = SelectObjectByFaction(self, 15, 'Monster')
    local i
    for i = 1, mon_cnt do
        if mon_list[i].ClassName == "Sec_InfroBurk" then
            local x_mon, y_mon, z_mon = GetPos(mon_list[i])
            if x_mon ~= x_trap and z_mon ~= z_trap then
                PlayEffect(self, "F_spin029_smoke", 2, 'BOT');
                
                SetPos(mon_list[i], x_trap, y_trap+10, z_mon)
                Kill(mon_list[i])
                local mon_down = CREATE_MONSTER_EX(self, 'Sec_InfroBurk', x_trap, y_trap, z_trap, 0, 'Neutral', 1, PILGRIM_48_SQ_090_TRAP_MON_AI_RUN);
                SetLifeTime(mon_down, 10)
                SetDialogRotate(mon_down, 0)
                ClearSimpleAI(self, "PILGRIM_48_SQ_090_TRAP_AI")
                break
            end
        end
    end
end

function PILGRIM_48_SQ_090_TRAP_MON_AI_RUN(mon_down)
    mon_down.Name = ScpArgMsg("PILGRIM_48_SQ_090_MSG04")
    mon_down.Tactics = 'None'
    mon_down.BTree = 'None'
    mon_down.SimpleAI = 'PILGRIM_48_SQ_090_TRAP_MON_AI'
    mon_down.Dialog = 'PILGRIM_48_SQ_090_TRAP_MON'
    mon_down.MaxDialog = 1;
    
end

--PILGRIM_49_SQ_040_ITEM_2
function SCR_USE_PILGRIM_49_SQ_040_ITEM_2(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM_49_SQ_040')
    if result == 'PROGRESS' then    
    
        local act = DOTIMEACTION_R(self, ScpArgMsg("PILGRIM_49_SQ_040_MSG01"), "CRAFT", 5)
        if act == 1 then
            --SCR_PARTY_QUESTPROP_ADD(self, "SSN_PILGRIM_49_SQ_040", "QuestInfoValue2", 1, nil, "PILGRIM_49_SQ_040_ITEM_3/1", "PILGRIM_49_SQ_040_ITEM_1/8")
            
            
            local sObj = GetSessionObject(self, "SSN_PILGRIM_49_SQ_040")
            if sObj ~= nil then
                if sObj.QuestInfoValue2 < sObj.QuestInfoMaxCount2 then
                
                    GIVE_TAKE_ITEM_TX(self, 'PILGRIM_49_SQ_040_ITEM_3/1', 'PILGRIM_49_SQ_040_ITEM_1/-100', 'PILGRIM_49_SQ_040')
                    sObj.QuestInfoValue2 = sObj.QuestInfoValue2 + 1
                    SendAddOnMsg(self, 'NOTICE_Dm_GetItem', ScpArgMsg('PILGRIM_49_SQ_040_MSG02'), 5)
                    AttachEffect(self, 'F_pc_making_finish_white', 5, "TOP")
                end
            end
        end
    end
end

--ORCHARD_323_SQ_WATER
function SCR_USE_ORCHARD_323_SQ_WATER(self, argObj, argstring, arg1, arg2)
    if argObj.ClassName == 'blank_npc' then
        LookAt(self, argObj)
        local result = DOTIMEACTION_R_FAILTIME_SET(self, 'ORCHARD_323_SQ_03', ScpArgMsg('ORCHARD323_FOOD_POLLUTION'), 1, 'SKL_ASSISTATTACK_WATERINGCAN', 'SSN_HATE_AROUND')
        if result == 1 then
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ORCHARD_323_SQ_03', 'QuestInfoValue2', 1)
            PlayEffect(argObj, 'I_smoke008_red_noloop', 1)
            Kill(argObj)
            HideNPC(self, 'ORCHARD323_FOOD')
        end
    end
end

--ORCHARD_323_SQ_CARVE
function SCR_USE_ORCHARD_323_SQ_CARVE(self, argObj, argstring, arg1, arg2)
    local follower = GetScpObjectList(self, 'ORCHARD_323_SQ_CARVE')
    if #follower == 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'skill_romuva_D', x+30, y+15, z, GetDirectionByAngle(self), 'Neutral', 1, ORCHARD_323_SQ_CARVE_ATT)
        SetOwner(mon, self)
        AddScpObjectList(self, 'ORCHARD_323_SQ_CARVE', mon)
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ORCHARD_323_SQ_05', 'QuestInfoValue1', 1)
        AddVisiblePC(mon, self, 1)
        SetLifeTime(mon, 30)
        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("ORCHARD323_CARVE_SET"), 3)
        PlayEffect(mon, 'F_smoke046', 0.5)
    end
end

function ORCHARD_323_SQ_CARVE_ATT(mon)
	mon.BTree = "None"
    mon.Tactics = "None"
	mon.Name = "UnvisibleName"
	mon.SimpleAI = "ORCHARD_323_SQ_CARVE_AI"
end

--ORCHARD_342_MQ_05_ITEM
function SCR_USE_ORCHARD_342_MQ_05_ITEM(self, argObj, argstring, arg1, arg2)
    local quest_ssn = GetSessionObject(self, 'SSN_ORCHARD_342_MQ_05')
    if quest_ssn ~= nil then
        PlayAnim(self, 'PUBLIC_THROW')
        sleep(1000)
        PlayEffect(self, 'F_explosion053_smoke', 3.0)
        quest_ssn.Goal1 = quest_ssn.Goal1 + 1
        local list, cnt = SelectObject(self, 100, 'ALL')
        local i
        for i = 1, cnt do
            if list[i].ClassName ~= 'PC' then
                if list[i].ClassName == 'ferret_folk' or list[i].ClassName == 'ferret_loader' then
                    if IsBuffApplied(list[i], 'ORCHARD342_STUN') == 'NO' then
                        AddBuff(self, list[i], 'ORCHARD342_STUN', 1, 0, 12000, 1)
                        PlayEffect(list[i], 'F_explosion053_smoke', 1.0)
                    end
                end
            end
        end
        if quest_ssn.Goal1 == 1 then
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("ORCHARD_342_MQ_05_ONE"), 3)
        elseif quest_ssn.Goal1 == 2 then
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("ORCHARD_342_MQ_05_TWO"), 3)
        elseif quest_ssn.Goal1 == 3 then
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("ORCHARD_342_MQ_05_THREE"), 3)
        end
    end
end

--ORCHARD_342_SQ_01_SCROLL
function SCR_USE_ORCHARD_342_SQ_01_SCROLL(self, argObj, argstring, arg1, arg2)
    local list, cnt = SelectObject(self, 40, 'ALL')
    local i 
    for i = 1, cnt do
        if list[i].ClassName == 'ferret_folk' or list[i].ClassName == 'ferret_loader' then
            if IsBuffApplied(list[i], 'ORCHARD342_OBSERVE') == 'NO' then
                LookAt(self, list[i])
                local result2 = DOTIMEACTION_R_FAILTIME_SET(self, 'ORCHARD_342_SQ_01', ScpArgMsg('ORCHARD342_OBSERVATION'), 2, 'write', 'SSN_HATE_AROUND')
                if result2 == 1 then
                    AddBuff(self, list[i], 'ORCHARD342_OBSERVE', 1, 0, 10000, 1)
                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ORCHARD_342_SQ_01', 'QuestInfoValue1', IMCRandom(10, 20))
                    PlayEffect(list[i], 'F_pc_making_finish_white', 2, 1, 'BOT')
                    local txtrnd = IMCRandom(1, 5)
                    if txtrnd == 1 then
                        ShowBalloonText(self, 'ORCHARD342_SQ_01_MON_DLG1', 3)
                        return
                    elseif txtrnd == 2 then
                        ShowBalloonText(self, 'ORCHARD342_SQ_01_MON_DLG2', 3)
                        return
                    elseif txtrnd == 3 then
                        ShowBalloonText(self, 'ORCHARD342_SQ_01_MON_DLG3', 3)
                        return
                    elseif txtrnd == 4 then
                        ShowBalloonText(self, 'ORCHARD342_SQ_01_MON_DLG4', 3)
                        return
                    elseif txtrnd == 5 then
                        ShowBalloonText(self, 'ORCHARD342_SQ_01_MON_DLG5', 3)
                        return
                    end
                end
            elseif IsBuffApplied(list[i], 'ORCHARD342_OBSERVE') == 'YES' then
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("ORCHARD342_OBSERVATION_F"), 3)
            end
        end
    end
end

--ORCHARD_342_SQ_02_TRANSFORM
function SCR_USE_ORCHARD_342_SQ_02_TRANSFORM(self, argObj, argstring, arg1, arg2)
    local ridingCompanion = GetRidingCompanion(self);
    if ridingCompanion ~= nil then
        RideVehicle(self, ridingCompanion, 0)
    end
    local mon = {
                'ferret_folk',
                'ferret_loader'
                }
    local rnd = IMCRandom(1, 2)
	if 1 == TransformToMonster(self, mon[rnd], 'ORCHARD342_TRANSFORM_BUFF') then
		AddBuff(self, self, 'ORCHARD342_TRANSFORM_BUFF', 1, 1, 300000, 1)
		PlayEffect(self, 'F_smoke037', 0.5, 'MID')
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ORCHARD342_TRANSFORM_S"), 3)
	end
end

--ORCHARD_342_SQ_03_WOOD
function SCR_USE_ORCHARD_342_SQ_03_WOOD(self, argObj, argstring, arg1, arg2)
    local follower = GetScpObjectList(self, 'ORCHARD_342_SQ_03_WOOD')
    if #follower == 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'npc_husband_1_down', x+30, y+15, z, GetDirectionByAngle(self), 'Our_Forces', 1, ORCHARD_342_SQ_03_WOOD_SET)
        PlayEffect(mon, 'F_smoke037', 0.5, 'MID')
        SetOwner(mon, self, 1)
        AddScpObjectList(self, 'ORCHARD_342_SQ_03_WOOD', mon)
        CreateSessionObject(mon, "SSN_ORCHARD_342_SQ_03_WOOD")
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ORCHARD_342_SQ_03', 'QuestInfoValue1', 1)
    end
end

function ORCHARD_342_SQ_03_WOOD_SET(mon)
	mon.BTree = "None"
    mon.Tactics = "None"
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("ORCHARD_342_SQ_03_WOOD_NAME")
	mon.Dialog = 'None'
	mon.SimpleAI = "ORCHARD_342_SQ_03_WOOD_AI"
end

--ORCHARD_342_SQ_04_ITEM
function SCR_USE_ORCHARD_342_SQ_04_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = DOTIMEACTION_R_FAILTIME_SET(self, 'ORCHARD_342_SQ_04', ScpArgMsg('ORCHARD342_BURN_POWDER'), 1, 'BURY', 'SSN_HATE_AROUND')
    if result1 == 1 then
        PlayEffect(self, 'F_explosion053_smoke', 3.0)
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ORCHARD_342_SQ_04', 'QuestInfoValue1', 1)
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ORCHARD_342_SQ_04_RUNAWAY"), 3)
        local list, cnt = SelectObject(self, 80, 'ALL')
        local i
        for i = 1, cnt do
            if list[i].ClassName ~= 'PC' then
                if list[i].ClassName == 'ferret_patter' or list[i].ClassName == 'ferret_searcher' or list[i].ClassName == 'ferret_slinger' then
                    PlayEffect(list[i], 'F_explosion053_smoke', 1.0)
                    RunAwayFrom(list[i], self, 100)
                end
            end
        end
    end
end

--ORCHARD_342_MQ_HOLLY_SPHERE
function SCR_USE_ORCHARD_342_MQ_HOLLY_SPHERE(self, argObj, argstring, arg1, arg2)
    local list, cnt = SelectObject(self, 100, 'ALL')
    local i
    if cnt > 0 then
        for i = 1, cnt do
            if list[i].ClassName ~= 'PC' then
                if list[i].Faction == 'Monster' then
                    if list[i].ClassName == 'ferret_archer' or list[i].ClassName == 'beeterineas' or list[i].ClassName == 'ferret_vendor' or list[i].ClassName == 'ferret_bearer_elite' or list[i].ClassName == 'Sec_wolf_statue_mage' then
                        if IsDead(list[i]) == 0 then
                            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("ORCHARD_324_DESPENSOR_MONKILL"), 3)
                            InsertHate(list[i], self, 1)
                            return
                        end
                    end
                end
            end
        end
        if argObj.ClassName == 'kruvina_pillar' then
            LookAt(self, argObj)
            local result = DOTIMEACTION_R_FAILTIME_SET(self, 'ORCHARD_324_MQ_05', ScpArgMsg('ORCHARD_324_DESPENSOR_DESTROY_ING'), 3, 'ABSORB', 'SSN_HATE_AROUND')
            if result == 1 then
                HideNPC(self, 'ORCHARD324_DESPENSOR')
                local x,y,z = GetPos(argObj)
                local mon = CREATE_MONSTER_EX(self, 'kruvina_pillar', x, y, z, GetDirectionByAngle(argObj), 'Peaceful', 1, ORCHARD324_DESPENSOR_SET)
                AddVisiblePC(mon, self, 1)
                ActorVibrate(mon, 1, 0.5, 100, 0)
                PlayEffect(mon, 'F_buff_basic033_orange_line', 1)
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ORCHARD_324_MQ_05', 'QuestInfoValue1', 1)
                RunScript('ORCHARD324_DESPENSOR_KILL', mon)
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("ORCHARD_324_DESPENSOR_DESTROY"), 3)
                HideNPC(self, 'ORCHARD_324_DESPENSOR_EFF')
                UnHideNPC(self, 'ORCHARD324_LADA_EFF')
            end
        end
    else
        if argObj.ClassName == 'kruvina_pillar' then
            LookAt(self, argObj)
            local result = DOTIMEACTION_R_FAILTIME_SET(self, 'ORCHARD_324_MQ_05', ScpArgMsg('ORCHARD_324_DESPENSOR_DESTROY_ING'), 3, 'ABSORB', 'SSN_HATE_AROUND')
            if result == 1 then
                HideNPC(self, 'ORCHARD324_DESPENSOR')
                local x,y,z = GetPos(argObj)
                local mon = CREATE_MONSTER_EX(self, 'kruvina_pillar', x, y, z, GetDirectionByAngle(argObj), 'Peaceful', 1, ORCHARD324_DESPENSOR_SET)
                AddVisiblePC(mon, self, 1)
                ActorVibrate(mon, 1, 0.5, 100, 0)
                PlayEffect(mon, 'F_buff_basic033_orange_line', 1)
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ORCHARD_324_MQ_05', 'QuestInfoValue1', 1)
                RunScript('ORCHARD324_DESPENSOR_KILL', mon)
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("ORCHARD_324_DESPENSOR_DESTROY"), 3)
                HideNPC(self, 'ORCHARD_324_DESPENSOR_EFF')
                UnHideNPC(self, 'ORCHARD324_LADA_EFF')
            end
        end
    end
end

function ORCHARD324_DESPENSOR_SET(mon)
    mon.BTree = "None"
    mon.Tactics = "None"
	mon.Name = ScpArgMsg("ORCHARD_324_DESPENSOR_NAME")
end

--PILGRIM_36_2_SQ_090_ITEM_2
function SCR_USE_PILGRIM_36_2_SQ_090_ITEM_2(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM_36_2_SQ_090')
    if result == 'IMPOSSIBLE' or result == 'COMPLETE' then
        ShowBalloonText(self, "PILGRIM_36_2_SQ_090_USE_PAPER", 5)
        
        RunScript('TAKE_ITEM_TX', self, "PILGRIM_36_2_SQ_090_ITEM_2", 1, "Q_PILGRIM_36_2_SQ_090")
--        local tx = TxBegin(self);
--        TxTakeItem(tx, ""PILGRIM_36_2_SQ_090_ITEM_2"", 1, 'Quest');
--        local ret = TxCommit(tx);
--        print("aaaaaaaaaaaaaaaaaaaaaaaa")
    end
end

--ORCHARD_324_SQ_SCROLL
function SCR_USE_ORCHARD_324_SQ_SCROLL(self, argObj, argstring, arg1, arg2)
    local list, cnt = SelectObject(self, 100, 'ALL')
    local i
    if cnt > 0 then
        for i = 1, cnt do
            if list[i].ClassName ~= 'PC' then
                if list[i].Faction == 'Monster' then
                    if list[i].ClassName == 'ferret_archer' or list[i].ClassName == 'beeterineas' or list[i].ClassName == 'ferret_vendor' or list[i].ClassName == 'ferret_bearer_elite' or list[i].ClassName == 'Sec_wolf_statue_mage' then
                        if IsDead(list[i]) == 0 then
                            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("ORCHARD_324_DESPENSOR_MONKILL"), 3)
                            InsertHate(list[i], self, 1)
                            return
                        end
                    end
                end
            end
        end
        if argObj.ClassName == 'blank_npc_noshadow' then
            LookAt(self, argObj)
            local result = DOTIMEACTION_R_FAILTIME_SET(self, 'ORCHARD_324_SQ_03', ScpArgMsg('ORCHARD_324_CLEAR_ING'), 3, 'ABSORB', 'SSN_HATE_AROUND')
            if result == 1 then
                local quest_ssn = GetSessionObject(self, 'SSN_ORCHARD_324_SQ_03')
                PlayEffectLocal(argObj, self, 'F_ground012_light', 1)
                PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ORCHARD_324_SQ_03', 'QuestInfoValue1', 1)
                SaveSessionObject(self, quest_ssn)
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("ORCHARD_324_CLEAR"), 3)
                if argObj.Enter == 'ORCHARD324_DARK1' then
                    HideNPC(self, 'ORCHARD324_DARK1')
                elseif argObj.Enter == 'ORCHARD324_DARK2' then
                    HideNPC(self, 'ORCHARD324_DARK2')
                elseif argObj.Enter == 'ORCHARD324_DARK3' then
                    HideNPC(self, 'ORCHARD324_DARK3')
                elseif argObj.Enter == 'ORCHARD324_DARK4' then
                    HideNPC(self, 'ORCHARD324_DARK4')
                end
            end
        end
    else
        if argObj.ClassName == 'blank_npc_noshadow' then
            LookAt(self, argObj)
            local result = DOTIMEACTION_R_FAILTIME_SET(self, 'ORCHARD_324_SQ_03', ScpArgMsg('ORCHARD_324_CLEAR_ING'), 3, 'ABSORB', 'SSN_HATE_AROUND')
            if result == 1 then
                local quest_ssn = GetSessionObject(self, 'SSN_ORCHARD_324_SQ_03')
                PlayEffectLocal(argObj, self, 'F_ground012_light', 1)
                PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ORCHARD_324_SQ_03', 'QuestInfoValue1', 1)
                SaveSessionObject(self, quest_ssn)
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("ORCHARD_324_CLEAR"), 3)
                if argObj.Enter == 'ORCHARD324_DARK1' then
                    HideNPC(self, 'ORCHARD324_DARK1')
                elseif argObj.Enter == 'ORCHARD324_DARK2' then
                    HideNPC(self, 'ORCHARD324_DARK2')
                elseif argObj.Enter == 'ORCHARD324_DARK3' then
                    HideNPC(self, 'ORCHARD324_DARK3')
                elseif argObj.Enter == 'ORCHARD324_DARK4' then
                    HideNPC(self, 'ORCHARD324_DARK4')
                end
            end
        end
    end
end

--ORCHARD_324_SQ_04_SEED
function SCR_USE_ORCHARD_324_SQ_04_SEED(self, argObj, argstring, arg1, arg2)
    if argObj.ClassName == 'blank_npc_2' then
        LookAt(self, argObj)
        local result = DOTIMEACTION_R_FAILTIME_SET(self, 'ORCHARD_324_SQ_04', ScpArgMsg('ORCHARD_324_SEED_SPREAD'), 2, 'BURY', 'SSN_HATE_AROUND')
        if result == 1 then
            local follower = GetScpObjectList(self, 'ORCHARD_324_SQ_04_SEED')
            if #follower == 0 then
                local x, y, z = GetPos(argObj)
                local mon = CREATE_MONSTER_EX(self, 'Hidden_Mon_01', x, y, z, GetDirectionByAngle(self), 'Our_Forces', 1, ORCHARD_324_SQ_04_SEED_SET)
                SetOwner(mon, self, 1)
                AddScpObjectList(self, 'ORCHARD_324_SQ_04_SEED', mon)
                Kill(argObj)
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("ORCHARD_324_SEED_WAIT"), 3)
            end
        end
    end
end

function ORCHARD_324_SQ_04_SEED_SET(mon)
	mon.BTree = "None"
    mon.Tactics = "None"
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("ORCHARD_324_SEED_NAME")
	mon.SimpleAI = "ORCHARD_324_SEED_AI"
	mon.Dialog = 'None'
end

--BRACKEN632_SQ2_ITEM01
function SCR_USE_BRACKEN632_SQ2_ITEM01(self, argObj, argstring, arg1, arg2)
    if argObj.ClassName == 'siauliai_grass_1' then
        LookAt(self, argObj)
        local result = DOTIMEACTION_R(self, ScpArgMsg("BRACKEN632_ITEM_USE01"), 'STANDSPINKLE', 1.5, 'SSN_HATE_AROUND')
        if result == 1 then
            if argObj.NumArg1 < 1 then
                argObj.NumArg1 = 1
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_BRACKEN_63_2_SQ040', 'QuestInfoValue1', 1)
            PlayEffect(argObj, "F_smoke131_dark_green2", 0.5, 'BOT')
            Kill(argObj)
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("BRACKEN632_ITEM_USE02"), 3)
            else
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("BRACKEN632_ITEM_MSG1"), 3)
            end
        end
    end
end

--JOB_2_KRIVIS2_ITEM2
function SCR_USE_JOB_2_KRIVIS2_ITEM2(self, argObj, argstring, arg1, arg2)
    local quest_ssn = GetSessionObject(self, 'SSN_JOB_2_KRIVIS2')
    if quest_ssn ~= nil then
        LookAt(self, argObj)
        local result1 = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_KRIVIS2_FIRE"), 'ABSORB', 2)
        if result1 == 1 then
            quest_ssn.QuestInfoValue2 = quest_ssn.QuestInfoValue2 + 1
            PlayAnim(argObj,'ON', 1)
        end
    end
end

--JOB_2_CLERIC3_ITEM
function SCR_USE_JOB_2_CLERIC3_ITEM(self, argObj, argstring, arg1, arg2)
    local quest_ssn = GetSessionObject(self, "SSN_JOB_2_CLERIC3")
    if quest_ssn ~= nil then
        if IsBuffApplied(argObj,'JOB_2_CLERIC_CURED')  == 'NO' then
            LookAt(self, argObj)
            local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_CLERIC3_CURE"), 'SITGROPE', 2)
            if result == 1 then
                AddBuff(self, argObj,'JOB_2_CLERIC_CURED', 1, 0, 600000, 1)
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_2_CLERIC3', 'QuestInfoValue1', 1)
                RunScript('SCR_JOB_2_CLERIC3_PATIENT_CURED', argObj)
            end
        end
    end
end

--JOB_2_KRIVIS3_ITEM
function SCR_USE_JOB_2_KRIVIS3_ITEM(self,argObj, argstring, arg1, arg2)
    local info = {{'f_siauliai_16','statue_vakarine'}
                    ,{'f_siauliai_16','statue_zemina'}
                    ,{'f_siauliai_15_re','statue_vakarine'}
                    ,{'f_siauliai_11_re','statue_vakarine'}
                }
    local zone = GetZoneName(self)
    local npcClassName = argObj.ClassName
    LookAt(self, argObj)
    
    local index = 0
    for i = 1, 10 do
        if zone == info[i][1] and npcClassName == info[i][2] then
            index = i
            break
        end
    end
    
    if index > 0 then
        local result = DOTIMEACTION_R_FAILTIME_SET(self, 'JOB_2_KRIVIS3', ScpArgMsg("Auto_Kongyang_Jung"), 3, 'WORSHIP')
        if result == 1 then
            local result2 = SCR_QUEST_CHECK(self, 'JOB_2_KRIVIS3')
            if result2 == 'PROGRESS' then
                local quest_sObj = GetSessionObject(self, 'SSN_JOB_2_KRIVIS3')
                
                if quest_sObj ~= nil then
                    if quest_sObj['QuestInfoValue'..index] < quest_sObj['QuestInfoMaxCount'..index] then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_JOB_2_KRIVIS3', 'QuestInfoValue'..index, 1)
                        PlayEffect(self, 'F_lineup010_ground', 0.4)
                    else
                        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("Auto_iMi_Kongyangeul_DeuLyeossSeupNiDa!"), 5);
                    end
                end
            end
        end
    end
end

--JOB_2_KRIVIS4_ITEM1
function SCR_USE_JOB_2_KRIVIS4_ITEM1(self, argObj, argstring, arg1, arg2)
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_KRIVIS4_FIRE"), 'ABSORB', 1)
    if result1 == 1 then
        PlayEffect(argObj, 'F_fire019', 1, 1, 'BOT')
        KILL_BLEND(argObj, 1, 1)
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_2_KRIVIS4_SUCCESS"), 2)
        RunScript('GIVE_ITEM_TX',self, 'JOB_2_KRIVIS4_ITEM2', 1, 'Quest')
    end
end

--JOB_2_SADHU4_ITEM
function SCR_USE_JOB_2_SADHU4_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_SADHU4_CHAIN"), 'ABSORB', 1)
    if result1 == 1 then
        local quest_ssn = GetSessionObject(self, "SSN_JOB_2_SADHU4")
        PlayEffect(argObj, 'F_buff_basic018_blue_fire')
        AddBuff(self, argObj,'JOB_2_SADHU_SOUL', 1, 0, 60000, 1)
        quest_ssn.Step1 = 1
        SaveSessionObject(self, quest_ssn)
    end
end

--JOB_2_BARBARIAN5_ITEM
function SCR_USE_JOB_2_BARBARIAN5_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_BARBARIAN5_DRINK"), 'DRINK', 1)
    if result1 == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_2_BARBARIAN5_PDOWN"), 2)
        AddBuff(self, self,'JOB_2_BARBARIAN_ACID', 1, 0, 120000, 1)
    end
end




--SIAU15RE_SQ_03_ITEM
function SCR_USE_SIAU15RE_SQ_03_ITEM(self, argObj, argstring, arg1, arg2)
    if IsBuffApplied(argObj, 'SIAU15RE_SQ_03_ITEM_01') == 'NO' then
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_SIAU15RE_SQ_03', 'QuestInfoValue1', 1)
        SCR_SENDMSG_CNT(self, 'SSN_SIAU15RE_SQ_03', 'scroll', 'SIAU15RE_SQ_03_MSG_SCROLL', 1, 2)
        AddBuff(self, argObj, 'SIAU15RE_SQ_03_ITEM_01', 1, 0, 20000, 1)
    end
end




--SIAU11RE_MQ_03_ITEM
function SCR_USE_SIAU11RE_MQ_03_ITEM(self, argObj, argstring, arg1, arg2)
    local dog = GetScpObjectList(self, 'SIAU11RE_MQ_03_ITEM')
    if #dog == 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'npc_dog6', x, y+5, z, GetDirectionByAngle(self), 'Neutral', 1, SIAU11RE_MQ_03_ITEM_RUN);
        AddVisiblePC(mon, self, 1);
        AddScpObjectList(mon, 'SIAU11RE_MQ_03_ITEM', self)
        AddScpObjectList(self, 'SIAU11RE_MQ_03_ITEM', mon)
        mon.FIXMSPD_BM = 70;
        EnableAIOutOfPC(mon)
        InvalidateStates(mon);
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("SIAU11RE_MQ_03_ITEM_HAVEDOG"), 2)
    end
end




--PRISON621_SQ_04_ITEM
function SCR_USE_PRISON621_SQ_04_ITEM(self, argObj, argstring, arg1, arg2)
    local result = DOTIMEACTION_R(self, ScpArgMsg("PRISON621_SQ_04_MSG_00"), 'MAKING', 0, 'SSN_HATE_AROUND')
    if result == 1 then
        local rnd = IMCRandom(1, 10)
        local list, cnt = SelectObjectByFaction(self, 150, 'Monster')
        local i
        if cnt > 0 then
            if rnd > 3 then
                for i = 1, cnt do
                    if GetPropType(list[i], 'KDArmor') ~= nil and list[i].KDArmor < 900 then
                        KnockDown(list[i], self, 150, GetAngleTo(self, list[i]), 45, 1)
                        InsertHate(list[i], self, 1)
                    end
                end
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_PRISON621_SQ_04', 'QuestInfoValue1', 1)
                SCR_SENDMSG_CNT(self, 'SSN_PRISON621_SQ_04', 'scroll', 'PRISON621_SQ_04_MSG_SCROLL_01', 1, 2)
            else
                local healHp = math.floor(self.MHP/100)
                AddHP(self, healHp)
                PlayEffect(self, 'F_pc_drug_hpup', 3, 'MID')
                SCR_SENDMSG_CNT(self, 'SSN_PRISON621_SQ_04', 'scroll', 'PRISON621_SQ_04_MSG_SCROLL_03', 1, 2)
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_PRISON621_SQ_04', 'QuestInfoValue1', 1)
            end
        end
    end
end


--PRISON622_SQ_02_ITEM
function SCR_USE_PRISON622_SQ_02_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    PlayAnim(self, 'PUBLIC_THROW', 1)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x, y+5, z, 0, 'Peaceful', 1, PRISON622_SQ_02_ITEM_RUN);
    SetLifeTime(mon, 30, 1)
    AddScpObjectList(mon, 'PRISON622_SQ_02_ITEM', self)
    AddScpObjectList(self, 'PRISON622_SQ_02_ITEM', mon)
end


function PRISON622_SQ_02_ITEM_RUN(mon)
    mon.SimpleAI = 'PRISON622_SQ_02_ITEM_RUN'
    mon.Name = 'UnvisibleName'
    mon.FIXMSPD_BM = 80

end

function PRISON622_SQ_02_ITEM_RUN_1(self)
    local _pc = GetScpObjectList(self, 'PRISON622_SQ_02_ITEM')
    if #_pc ~= 0 then
        local list, cnt = SelectObjectByFaction(self, 300, 'Monster')
        if cnt > 0 then
            local i
            local mon = list[1]
            if GetDistance(self, mon) > 10 then
                MoveToTarget(self, mon, 5)
            else
                if IsBuffApplied(mon, 'PRISON622_SQ_02_ITEM') == 'NO' then
                    AddBuff(self, mon, 'PRISON622_SQ_02_ITEM', 1, 0, 20000, 1)
                end
                PlayEffect(self, 'I_explosion005_blue', 1.5)
                if self.NumArg4 == 0 then
                    self.NumArg4 = 1
                    SetLifeTime(self, 1, 1)
                end
            end
        end
    else
        Kill(self)
    end
end

--_F_3CMLAKE_83_MQ_04
function SCR_USE_F_3CMLAKE_83_MQ_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE_83_MQ_04')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_3cmlake_83' then
            if GetLayer(self) == 0 then
                PlayAnimLocal(self, self, 'COMPASS', 1)
                local list, cnt = SelectObjectByFaction(self, 150, 'Monster')
                if cnt >= 1 then
                    for i = 1, cnt do
                        if IsBuffApplied(list[i], 'F_3CMLAKE_83_MQ_04_BUFF') == 'YES' then
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("F_3CMLAKE_83_MQ_01"), 5)
                            InsertHate(list[i], self, 9999)
                            local skill = GetNormalSkill(self)
                            ForceDamage(self, skill, list[i], self, 0, 'MOTION', 'BLOW', 'I_force025_red', 1, 'arrow_cast', nil, 1, 'arrow_blow', 'SLOW', 100, 1, 0, 0, 0, 1, 1)
                            return
                        end
                        local random = IMCRandom(1,4)
                        if random == 1 then
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("F_3CMLAKE_83_MQ_01"), 5)
                            InsertHate(list[i], self, 9999)
                            local skill = GetNormalSkill(self)
                            ForceDamage(self, skill, list[i], self, 0, 'MOTION', 'BLOW', 'I_force025_red', 1, 'arrow_cast', nil, 1, 'arrow_blow', 'SLOW', 100, 1, 0, 0, 0, 1, 1)
                            AddBuff(self, list[i], 'F_3CMLAKE_83_MQ_04_BUFF', 1, 0, 60000, 1)
                            return
                        end
                    end
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("F_3CMLAKE_83_MQ_02"), 5)
                end
            end
        end
    end
end

--CASTLE65_1_MQ02_ITEM
function SCR_USE_CASTLE65_1_MQ02_ITEM(self, argObj, argstring, arg1, arg2)
    local quest_ssn = GetSessionObject(self, "SSN_CASTLE65_1_MQ02")
    if quest_ssn ~= nil then
        PlayAnim(self, 'COMPASS', 2)
        if argObj.Dialog == 'CASTLE651_MQ_02_1' then
            if quest_ssn.Step1 ~= 2 then
                PlayEffectLocal(argObj, self, 'F_buff_basic021_yellow_fire', 1, "BOT")
                if isHideNPC(self, 'CASTLE651_MQ_02_1') == 'NO' then
                    HideNPC(self, 'CASTLE651_MQ_02_1')
                end
                if isHideNPC(self, 'CASTLE651_MQ_04_1') == 'YES' then
                    UnHideNPC(self, 'CASTLE651_MQ_04_1')
                end
                SCR_CASTLE65_1_MQ02_MSG(self, 1)
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_1_MQ02', 'QuestInfoValue1', 1)
                quest_ssn.Step1 = 1
                if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 then
                    if isHideNPC(self, 'CASTLE651_MQ_03') == 'YES' then
                        UnHideNPC(self, 'CASTLE651_MQ_03')
                    end
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CASTLE65_1_MQ02_NOTHING"), 2)
                quest_ssn.Step1 = 1
            end
        elseif argObj.Dialog == 'CASTLE651_MQ_02_2' then
            if quest_ssn.Step2 ~= 2 then
                PlayEffectLocal(argObj, self, 'F_buff_basic021_yellow_fire', 1, "BOT")
                if isHideNPC(self, 'CASTLE651_MQ_02_2') == 'NO' then
                    HideNPC(self, 'CASTLE651_MQ_02_2')
                end
                if isHideNPC(self, 'CASTLE651_MQ_04_2') == 'YES' then
                    UnHideNPC(self, 'CASTLE651_MQ_04_2')
                end
                SCR_CASTLE65_1_MQ02_MSG(self, 1)
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_1_MQ02', 'QuestInfoValue1', 1)
                quest_ssn.Step2 = 1
                if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 then
                    if isHideNPC(self, 'CASTLE651_MQ_03') == 'YES' then
                        UnHideNPC(self, 'CASTLE651_MQ_03')
                    end
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CASTLE65_1_MQ02_NOTHING"), 2)
                quest_ssn.Step2 = 1
            end
        elseif argObj.Dialog == 'CASTLE651_MQ_02_3' then
            PlayEffectLocal(argObj, self, 'F_buff_basic021_yellow_fire', 1, "BOT")
            if isHideNPC(self, 'CASTLE651_MQ_02_3') == 'NO' then
                HideNPC(self, 'CASTLE651_MQ_02_3')
            end
            if isHideNPC(self, 'CASTLE651_MQ_04_3') == 'YES' then
                UnHideNPC(self, 'CASTLE651_MQ_04_3')
            end
            SCR_CASTLE65_1_MQ02_MSG(self, 1)
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_1_MQ02', 'QuestInfoValue1', 1)
            if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 then
                if isHideNPC(self, 'CASTLE651_MQ_03') == 'YES' then
                    UnHideNPC(self, 'CASTLE651_MQ_03')
                end
            end
        elseif argObj.Dialog == 'CASTLE651_MQ_02_4' then
            if quest_ssn.Step3 ~= 2 then
                PlayEffectLocal(argObj, self, 'F_buff_basic021_yellow_fire', 1, "BOT")
                if isHideNPC(self, 'CASTLE651_MQ_02_4') == 'NO' then
                    HideNPC(self, 'CASTLE651_MQ_02_4')
                end
                if isHideNPC(self, 'CASTLE651_MQ_04_4') == 'YES' then
                    UnHideNPC(self, 'CASTLE651_MQ_04_4')
                end
                SCR_CASTLE65_1_MQ02_MSG(self, 1)
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_1_MQ02', 'QuestInfoValue1', 1)
                quest_ssn.Step3 = 1
                if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 then
                    if isHideNPC(self, 'CASTLE651_MQ_03') == 'YES' then
                        UnHideNPC(self, 'CASTLE651_MQ_03')
                    end
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CASTLE65_1_MQ02_NOTHING"), 2)
                quest_ssn.Step3 = 1
            end
        elseif argObj.Dialog == 'CASTLE651_MQ_02_5' then
            if quest_ssn.Step4 ~= 2 then
                PlayEffectLocal(argObj, self, 'F_buff_basic021_yellow_fire', 1, "BOT")
                if isHideNPC(self, 'CASTLE651_MQ_02_5') == 'NO' then
                    HideNPC(self, 'CASTLE651_MQ_02_5')
                end
                if isHideNPC(self, 'CASTLE651_MQ_04_5') == 'YES' then
                    UnHideNPC(self, 'CASTLE651_MQ_04_5')
                end
                SCR_CASTLE65_1_MQ02_MSG(self, 1)
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_1_MQ02', 'QuestInfoValue1', 1)
                quest_ssn.Step4 = 1
                if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 then
                    if isHideNPC(self, 'CASTLE651_MQ_03') == 'YES' then
                        UnHideNPC(self, 'CASTLE651_MQ_03')
                    end
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CASTLE65_1_MQ02_NOTHING"), 2)
                quest_ssn.Step4 = 1
            end
        end
        SaveSessionObject(self, quest_ssn)
    end
end

function SCR_CASTLE65_1_MQ02_MSG(self, num)
    local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
    local p
    if P_cnt >= 1 then
        for p = 1, P_cnt do
            if num == 1 then
                SendAddOnMsg(P_list[p], "NOTICE_Dm_scroll", ScpArgMsg("CASTLE65_1_MQ02_FIND"), 2)
            end
        end
    end
end

--CASTLE65_1_SQ02_ITEM
function SCR_USE_CASTLE65_1_SQ02_ITEM1(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, 'CASTLE65_1_SQ02_PAGE_01')
end

function SCR_USE_CASTLE65_1_SQ02_ITEM2(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, 'CASTLE65_1_SQ02_PAGE_02')
end

function SCR_USE_CASTLE65_1_SQ02_ITEM3(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, 'CASTLE65_1_SQ02_PAGE_03')
end

--CASTLE65_2_MQ02_ITEM
function SCR_USE_CASTLE65_2_MQ02_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'CASTLE65_2_MQ02')
    local result1 = SCR_QUEST_CHECK(self, 'CASTLE65_2_MQ03')
    local result2 = SCR_QUEST_CHECK(self, 'CASTLE65_2_MQ04')
    local quest_ssn = GetSessionObject(self, "SSN_CASTLE65_2_MQ02")
    local quest_ssn1 = GetSessionObject(self, "SSN_CASTLE65_2_MQ03")
    local quest_ssn2 = GetSessionObject(self, "SSN_CASTLE65_2_MQ04")
    if quest_ssn ~= nil or quest_ssn1 ~= nil or quest_ssn2 ~= nil then
        local result3 = DOTIMEACTION_R(self, ScpArgMsg("CASTLE65_2_MQ02_INSTALL"), 'MAKING', 2)
        if result3 == 1 then
            local x, y, z = GetFrontPos(self, 15)
            local mon = CREATE_MONSTER_EX(self, 'Altarcrystal_R1', x, y, z, 0, 'Neutral', nil, SCR_CASTLE65_2_MQ02_RUN)
            SetLifeTime(mon, 3)
            SetOwner(mon, self, 0)
            PlayEffectLocal(mon, self, 'F_light047_red', 1, "BOT")
            SetLifeTime(mon, 3)
            sleep(2000)
            PlayEffectLocal(mon, self, 'F_spread_out006', 1, "BOT")
            sleep(1500)
            if result1 == "PROGRESS" then
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_2_MQ03', 'QuestInfoValue1', 1)
                local list, cnt = SelectObjectByFaction(self, 200, 'Monster')
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CASTLE65_2_MQ03_MONSTER"), 3)
                if argObj.NumArg1 ~= 1 and cnt == 0 then
                    argObj.NumArg1 = 1
                    local x, y, z = GetPos(self)
                    local mon1 = CREATE_MONSTER_EX(self, 'Paggnat', 1747, 1, -519, 76, 'Monster')
                    local mon2 = CREATE_MONSTER_EX(self, 'Paggnat', 1795, 1, -552, 76, 'Monster')
                    local mon3 = CREATE_MONSTER_EX(self, 'charog', 1650, 132, -1366, 76, 'Monster')
                    local mon4 = CREATE_MONSTER_EX(self, 'charog', 1722, 133, -1369, 76, 'Monster')
                    InsertHate(mon1, self, 9999)
                    InsertHate(mon2, self, 9999)
                    InsertHate(mon3, self, 9999)
                    InsertHate(mon4, self, 9999)
                    MoveEx(mon1, x, y, z, 1)
                    MoveEx(mon2, x, y, z, 1)
                    MoveEx(mon3, x, y, z, 1)
                    MoveEx(mon4, x, y, z, 1)
                else
                    for i = 1, cnt do
                        InsertHate(list[i], self, 9999)
                    end
                end
            else
                local list, cnt = SelectObjectByClassName(mon, 100, 'HiddenTrigger6')
                if cnt ~= 0 then
                    for i = 1, cnt do
                        if result == "PROGRESS" then
                            if list[i].Enter == "CASTLE652_MQ_02_HIDE" then
                                local x, y, z = GetPos(list[i])
                                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CASTLE65_2_MQ02_FIND"), 3)
                                PlayEffectLocal(list[i], self, 'F_lineup009_ground', 2, "BOT")
                                local mon1 = CREATE_MONSTER_EX(self, 'kruvina_pillar', x, y, z, 0, 'Neutral', nil, CASTLE65_2_PILLAR_RUN)
                                SetOwner(mon1, self, 0)
                                EnableAIOutOfPC(mon1)
                                sleep(1000)
                                PlayAnimLocal(mon1, self, 'event_loop', 1)
                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_2_MQ02', 'QuestInfoValue1', 1)
                                if isHideNPC(self, 'CASTLE652_MQ_02') == 'NO' then
                                    HideNPC(self, "CASTLE652_MQ_02")
                                end
                                return
                            elseif i == cnt then
                                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CASTLE65_2_MQ02_NOT"), 3)
                            end
                        elseif result2 == "PROGRESS" then
                            if list[i].ClassName ~= "PC" then
                                if list[i].Enter == "CASTLE652_MQ_04_HIDE" then
--                                    SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CASTLE65_2_MQ02_FIND"), 3)
                                    PlayDirection(self, 'CASTLE65_2_MQ04_TRACK')
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_2_MQ04', 'QuestInfoValue1', 1)
                                    if isHideNPC(self, 'CASTLE652_MQ_02') == 'YES' then
                                        UnHideNPC(self, "CASTLE652_MQ_02")
                                    end
                                    if isHideNPC(self, 'CASTLE652_MQ_04_PILLAR') == 'YES' then
                                        UnHideNPC(self, "CASTLE652_MQ_04_PILLAR")
                                    end
                                    return
                                end
                            elseif i == cnt then
                                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CASTLE65_2_MQ02_NOT"), 3)
                            end
                        end
                    end
                else
                    sleep(1000)
                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CASTLE65_2_MQ02_NOT"), 3)
                end
            end
            KILL_BLEND(mon, 1, 1)
        end
    end
end

--CASTLE65_3_SQ01_ITEM
function SCR_USE_CASTLE65_3_SQ01_ITEM(self, argObj, argstring, arg1, arg2)
    if GetZoneName(self) == 'f_castle_65_3' then
        local quest_ssn = GetSessionObject(self, "SSN_CASTLE65_3_SQ01")
        if quest_ssn ~= nil then
            local list, cnt = SelectObject(self, 50, 'ALL', 1)
            if cnt ~= 0 then
                for i = 1, cnt do
                    if list[i].Faction ~= 'PC' then
                        if list[i].Dialog == 'CASTLE653_SQ_01_1' or list[i].Dialog == 'CASTLE653_SQ_01_2' or list[i].Dialog == 'CASTLE653_SQ_01_3' then
                            if isHideNPC(self, list[i].Dialog) == 'NO' then
                                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                                    if quest_ssn.Step2 >= 1 then
                                        LookAt(self, list[i])
                                        local result1 = DOTIMEACTION_R(self, ScpArgMsg("CASTLE65_3_SQ01_CHAIN"), 'ABSORB', 1, 'SSN_HATE_AROUND')
                                        if result1 == 1 then
                                            PlayEffectLocal(list[i], self, 'F_spread_out028_dark_fire', 1, "BOT")
                                            CameraShockWave(self, 2, 99999, 5, 0.8, 30, 0)
                                            if list[i].Dialog == 'CASTLE653_SQ_01_1' then
                                                SCR_CASTLE65_3_SQ01_MSG(self)
                                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_3_SQ01', 'QuestInfoValue1', 1)
                                                quest_ssn.Step2 = 0
                                                PlayAnimLocal(list[i], self, 'off', 1)
                                                sleep(2000)
                                                HideNPC(self, 'CASTLE653_SQ_01_1')
                                                if isHideNPC(self, 'CASTLE653_SQ_01_4') == 'YES' then
                                                    UnHideNPC(self, 'CASTLE653_SQ_01_4')
                                                end
                                                return
                                            elseif list[i].Dialog == 'CASTLE653_SQ_01_2' then
                                                SCR_CASTLE65_3_SQ01_MSG(self)
                                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_3_SQ01', 'QuestInfoValue1', 1)
                                                quest_ssn.Step2 = 0
                                                PlayAnimLocal(list[i], self, 'off', 1)
                                                sleep(2000)
                                                HideNPC(self, 'CASTLE653_SQ_01_2')
                                                if isHideNPC(self, 'CASTLE653_SQ_01_5') == 'YES' then
                                                    UnHideNPC(self, 'CASTLE653_SQ_01_5')
                                                end
                                                return
                                            else
                                                SCR_CASTLE65_3_SQ01_MSG(self)
                                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_3_SQ01', 'QuestInfoValue1', 1)
                                                quest_ssn.Step2 = 0
                                                PlayAnimLocal(list[i], self, 'off', 1)
                                                sleep(2000)
                                                HideNPC(self, 'CASTLE653_SQ_01_3')
                                                if isHideNPC(self, 'CASTLE653_SQ_01_6') == 'YES' then
                                                    UnHideNPC(self, 'CASTLE653_SQ_01_6')
                                                end
                                                return
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CASTLE65_3_SQ01_FAIL"), 2)
        end
    elseif GetZoneName(self) == 'f_castle_65_2' then
        local quest_ssn = GetSessionObject(self, "SSN_CASTLE65_3_SQ02")
        if quest_ssn ~= nil then
            local list, cnt = SelectObject(self, 50, 'ALL', 1)
            if cnt ~= 0 then
                for i = 1, cnt do                
                    if list[i].Faction ~= 'PC' then
                        if list[i].Dialog == 'CASTLE652_MQ_02_PILLAR' or list[i].Dialog == 'CASTLE652_MQ_04_PILLAR' or list[i].Dialog == 'CASTLE652_MQ_PILLAR_EX' then
                            if isHideNPC(self, list[i].Dialog) == 'NO' then
                                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                                    if quest_ssn.Step2 >= 1 then
                                        LookAt(self, list[i])
                                        local result1 = DOTIMEACTION_R(self, ScpArgMsg("CASTLE65_3_SQ01_CHAIN"), 'ABSORB', 1, 'SSN_HATE_AROUND')
                                        if result1 == 1 then
                                            PlayEffectLocal(list[i], self, 'F_explosion049_fire', 2, "MID")
                                            CameraShockWave(self, 2, 99999, 5, 0.8, 30, 0)
                                            if list[i].Dialog == 'CASTLE652_MQ_02_PILLAR' then
                                                SCR_CASTLE65_3_SQ01_MSG(self)
                                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_3_SQ02', 'QuestInfoValue1', 1)
                                                quest_ssn.Step2 = 0
                                                PlayAnimLocal(list[i], self, 'dead', 1)
                                                sleep(2500)
                                                PlayEffectLocal(list[i], self, 'F_smoke023_red', 2, "BOT")
                                                HideNPC(self, 'CASTLE652_MQ_02_PILLAR')
                                                if isHideNPC(self, 'CASTLE653_SQ_02_PILLAR1') == 'YES' then
                                                    UnHideNPC(self, 'CASTLE653_SQ_02_PILLAR1')
                                                end
                                                return
                                            elseif list[i].Dialog == 'CASTLE652_MQ_04_PILLAR' then
                                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_3_SQ02', 'QuestInfoValue1', 1)
                                                quest_ssn.Step2 = 0
                                                SCR_CASTLE65_3_SQ01_MSG(self)
                                                PlayAnimLocal(list[i], self, 'dead', 1)
                                                sleep(2500)
                                                PlayEffectLocal(list[i], self, 'F_smoke023_red', 2, "BOT")
                                                HideNPC(self, 'CASTLE652_MQ_04_PILLAR')
                                                if isHideNPC(self, 'CASTLE653_SQ_02_PILLAR2') == 'YES' then
                                                    UnHideNPC(self, 'CASTLE653_SQ_02_PILLAR2')
                                                end
                                                return
                                            else
                                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CASTLE65_3_SQ02', 'QuestInfoValue1', 1)
                                                quest_ssn.Step2 = 0
                                                SCR_CASTLE65_3_SQ01_MSG(self)
                                                PlayAnimLocal(list[i], self, 'dead', 1)
                                                sleep(2500)
                                                PlayEffectLocal(list[i], self, 'F_smoke023_red', 2, "BOT")
                                                HideNPC(self, 'CASTLE652_MQ_PILLAR_EX')
                                                if isHideNPC(self, 'CASTLE653_SQ_02_PILLAR3') == 'YES' then
                                                    UnHideNPC(self, 'CASTLE653_SQ_02_PILLAR3')
                                                end
                                                return
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CASTLE65_3_SQ01_FAIL"), 2)
        end
    end
end


function SCR_CASTLE65_3_SQ01_MSG(self)
    local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
    local p
    if P_cnt >= 1 then
        for p = 1, P_cnt do
            SendAddOnMsg(P_list[p], "NOTICE_Dm_scroll", ScpArgMsg("CASTLE65_3_SQ01_EMPTY"), 2)
        end
    end
end


function SCR_USE_PRISON611_MAP_ITEM(self, argObj, argstring, arg1, arg2)
    TreasureMarkByMap(self, 'd_prison_62_1', 1964, 199, 611)
    TreasureMarkByMap(self, 'd_prison_62_1', 873, 323, 664)
end


function SCR_USE_FIRETOWER691_ITEM_1(self, argObj, argstring, arg1, arg2)
    local zone_name = GetZoneName(self)
    local _layer = GetLayer(self)
    local x, y, z = GetPos(self)
    
    --f_remains_37
    if zone_name == 'f_remains_37' then
        local result1 = SCR_QUEST_CHECK(self, 'FIRETOWER691_PRE_1')
        if result1 == 'PROGRESS' then
            local quest_ssn = GetSessionObject(self, 'SSN_FIRETOWER691_PRE_1')
            if quest_ssn ~= nil then
                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                    quest_ssn.QuestInfoValue1 = 1
                    FIRETOWER691_DIR_LIB_SINGLE(self, 'FIRETOWER691_PRE_1')
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
                        quest_ssn.QuestInfoValue2 = 1
                        FIRETOWER691_DIR_LIB_SINGLE(self, 'FIRETOWER691_PRE_2')
                    end
                end
            end
        end
        if result3 == 'PROGRESS' then
            if _layer == 0 then
                local quest_ssn = GetSessionObject(self, 'SSN_FIRETOWER691_MQ_1')
                if quest_ssn ~= nil then
                    if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                        quest_ssn.QuestInfoValue1 = 1
                        FIRETOWER691_DIR_LIB_SINGLE(self, 'FIRETOWER691_MQ_1')
                    end
                end
            end
        end
        if result4 == 'PROGRESS' then
            if _layer == 0 then
                local quest_ssn = GetSessionObject(self, 'SSN_FIRETOWER691_MQ_2')
                if quest_ssn ~= nil then
                    if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                        quest_ssn.QuestInfoValue1 = 1
                        FIRETOWER691_DIR_LIB_SINGLE(self, 'FIRETOWER691_MQ_2')
                    end
                end
            end
        end
        if result5 == 'PROGRESS' then
            if _layer == 0 then
                local quest_ssn = GetSessionObject(self, 'SSN_FIRETOWER691_MQ_3')
                if quest_ssn ~= nil then
                    if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                        quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
                        FIRETOWER691_DIR_LIB_SINGLE(self, 'FIRETOWER691_MQ_3')
                    end
                end
            end
        end
        if result6 == 'PROGRESS' then
            if _layer == 0 then
                local quest_ssn = GetSessionObject(self, 'SSN_FIRETOWER691_MQ_4')
                if quest_ssn ~= nil then
                    if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                        quest_ssn.QuestInfoValue1 = 1
                        FIRETOWER691_DIR_LIB_SINGLE(self, 'FIRETOWER691_MQ_4')
                    end
                end
            end
        end
        if result7 == 'PROGRESS' then
            if _layer == 0 then
                return 1
            end
        end
    end
end





--ABBAY643_SQ3_ITEM2
function SCR_USE_ABBAY643_SQ3_ITEM2(self, argObj, argstring, arg1, arg2)
    --print("11111")
    if GetZoneName(self) == 'd_abbey_64_3' then
        local result1 = DOTIMEACTION_R(self, ScpArgMsg("BRACKEN631_ITEM01"), 'CRAFT', 1)
        if result1 == 1 then
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ABBAY_64_3_SQ030', 'QuestInfoValue1', 1, nil, "ABBAY643_SQ4_ITEM1/1")
            PlayEffect(self, 'F_levitation029_violet', 1,0, "BOT")
        end
    end
end

--GIMMICK_TRANSFORM_POPOLION
function SCR_USE_GIMMICK_TRANSFORM_POPOLION(self, argObj, argstring, arg1, arg2)
    TransformToMonster(self, 'Popolion_Blue_Transfrom', 'GIMMICK_TRANFORM_BUFF')
	PlayEffect(self, 'F_smoke037', 0.5, 'MID')
	AddBuff(self, self, 'GIMMICK_TRANSFORM_BUFF', 1, 1, 300000, 1)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("GIMMICK_TRANSFORM_MSG"), 3)
end

--GIMMICK_TRANSFORM_FERRET
function SCR_USE_GIMMICK_TRANSFORM_FERRET(self, argObj, argstring, arg1, arg2)
    TransformToMonster(self, 'ferret_folk_Transfrom', 'GIMMICK_TRANFORM_BUFF')
	PlayEffect(self, 'F_smoke037', 0.5, 'MID')
	AddBuff(self, self, 'GIMMICK_TRANSFORM_BUFF', 1, 1, 300000, 1)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("GIMMICK_TRANSFORM_MSG"), 3)
end

--GIMMICK_TRANSFORM_TINY
function SCR_USE_GIMMICK_TRANSFORM_TINY(self, argObj, argstring, arg1, arg2)
    TransformToMonster(self, 'Tiny_Transfrom', 'GIMMICK_TRANFORM_BUFF')
	PlayEffect(self, 'F_smoke037', 0.5, 'MID')
	AddBuff(self, self, 'GIMMICK_TRANSFORM_BUFF', 1, 1, 300000, 1)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("GIMMICK_TRANSFORM_MSG"), 3)
end

--GIMMICK_TRANSFORM_PHANTO
function SCR_USE_GIMMICK_TRANSFORM_PHANTO(self, argObj, argstring, arg1, arg2)
    TransformToMonster(self, 'Npanto_baby_Transfrom', 'GIMMICK_TRANFORM_BUFF')
	PlayEffect(self, 'F_smoke037', 0.5, 'MID')
	AddBuff(self, self, 'GIMMICK_TRANSFORM_BUFF', 1, 1, 300000, 1)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("GIMMICK_TRANSFORM_MSG"), 3)
end

--GIMMICK_TRANSFORM_HONEY
function SCR_USE_GIMMICK_TRANSFORM_HONEY(self, argObj, argstring, arg1, arg2)
    TransformToMonster(self, 'Honeybean_Transfrom', 'GIMMICK_TRANFORM_BUFF')
	PlayEffect(self, 'F_smoke037', 0.5, 'MID')
	AddBuff(self, self, 'GIMMICK_TRANSFORM_BUFF', 1, 1, 300000, 1)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("GIMMICK_TRANSFORM_MSG"), 3)
end

--GIMMICK_TRANSFORM_ONION
function SCR_USE_GIMMICK_TRANSFORM_ONION(self, argObj, argstring, arg1, arg2)
    TransformToMonster(self, 'Onion_Transfrom', 'GIMMICK_TRANFORM_BUFF')
	PlayEffect(self, 'F_smoke037', 0.5, 'MID')
	AddBuff(self, self, 'GIMMICK_TRANSFORM_BUFF', 1, 1, 300000, 1)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("GIMMICK_TRANSFORM_MSG"), 3)
end

--GIMMICK_TRANSFORM_JUKOPUS
function SCR_USE_GIMMICK_TRANSFORM_JUKOPUS(self, argObj, argstring, arg1, arg2)
    TransformToMonster(self, 'Jukopus_Transfrom', 'GIMMICK_TRANFORM_BUFF')
	PlayEffect(self, 'F_smoke037', 0.5, 'MID')
	AddBuff(self, self, 'GIMMICK_TRANSFORM_BUFF', 1, 1, 300000, 1)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("GIMMICK_TRANSFORM_MSG"), 3)
end

function SCR_QUEST_START_ITEM(self,argObj, argstring, argnum1, argnum2)
    local quest_state = SCR_QUEST_CHECK(self,argstring)

    if quest_state == 'POSSIBLE' then
        SCR_QUEST_POSSIBLE_AGREE(self, argstring)
    end
end

--TABLELAND_11_1_SQ_06_CHARM
function SCR_USE_TABLELAND_11_1_SQ_06_CHARM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, "TABLELAND_11_1_SQ_06")
    
    if result == "PROGRESS" then
        if IsBuffApplied(argObj, 'TABLELAND_FORZEN_MANA') == 'NO' then
            LookAt(self, argObj)
            local result2 = DOTIMEACTION_R(self, ScpArgMsg("TABLELAND_11_1_SQ_06_DRAIN"), "ABSORB", 2)
            
            if result2 == 1 then
                local skill = GetNormalSkill(argObj)
                ForceDamage(argObj, skill, self, argObj, 0, 'MOTION', 'BLOW', 'I_wizard_necromancer_force', 1, 'arrow_cast', 'I_wizard_necromancer_force2', 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
                SCR_PARTY_QUESTPROP_ADD(self, "SSN_TABLELAND_11_1_SQ_06", "QuestInfoValue1", IMCRandom(5, 20))
                AddBuff(argObj, argObj, 'TABLELAND_FORZEN_MANA', 1, 0, 60000, 1)
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('TABLELAND_11_1_SQ_06_ORING'), 3)
        end
    end
end

--CORAL_32_1_SQ_11_ITEM1
function SCR_USE_CORAL_32_1_SQ_11_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'CORAL_32_1_SQ_11')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_coral_32_1' then
            if GetLayer(self) == 0 then
                local result1 = DOTIMEACTION_R(self, ScpArgMsg("CORAL_32_1_SQ_11_ROD1"), 'COMPASS', 1)
                if result1  == 1 then
                    local list, cnt = SelectObject(self, 200, 'ALL')
                    if cnt >= 1 then
                        for i = 1, cnt do
                            if list[i].ClassName == 'HiddenTrigger6' then
                                if list[i].Dialog == 'CORAL_32_1_KEY' then
                                    local x, y, z = GetPos(list[i])
                                    SCR_SCRIPT_PARTY('SCR_CORAL_32_1_SQ_11_RUN', 1, self, x, y, z)
                                    Kill(list[i])
                                    return
                                end
                            end
                        end
                    end
                    SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg("CORAL_32_1_SQ_11_ROD3"), 3)
                end
            end
        end
    end
end

function SCR_QUEST_START_ITEM(self,argObj, argstring, argnum1, argnum2)
    local quest_state = SCR_QUEST_CHECK(self,argstring)

    if quest_state == 'POSSIBLE' then
        SCR_QUEST_POSSIBLE_AGREE(self, argstring)
    end
end

function SCR_QUEST_START_ITEM_KEY_QUEST(self,argObj, argstring, argnum1, argnum2)
    local quest_state = SCR_QUEST_CHECK(self,argstring)

    if quest_state == 'POSSIBLE' or quest_state == 'COMPLETE' then
        SCR_QUEST_POSSIBLE_AGREE(self, argstring)
    end
end



--TABLELAND_11_1_SQ_10_LETTER
function SCR_USE_TABLELAND_11_1_SQ_10_LETTER(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, 'TABLELAND_11_1_SQ_10_LETTER')
    SCR_QUEST_START_ITEM(self, nil, 'TABLELAND_11_1_SQ_10')
end

--TABLELAND_11_1_SQ_11_PAPER
function SCR_USE_TABLELAND_11_1_SQ_11_PAPER(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, 'TABLELAND_11_1_SQ_11_PAPER')
    SCR_QUEST_START_ITEM(self, nil, 'TABLELAND_11_1_SQ_11')
end

--SIAULIAI_35_1_SQ_7_REAGENT
function SCR_USE_SIAULIAI_35_1_SQ_7_REAGENT(self, argObj, argstring, arg1, arg2)
    local quest_ssn = GetSessionObject(self, 'SSN_SIAULIAI_35_1_SQ_8')
    if quest_ssn ~= nil then
        LookAt(self, argObj)
        local result2 = DOTIMEACTION_R(self, ScpArgMsg("SIAULIAI_35_1_SQ_7_REAGENT_ING"), "FLASK", 2)
        if result2 == 1 then
            local list, cnt = SelectObject(self, 100, 'ALL')
            local i
            for i = 1, cnt do
                if list[i].ClassName == 'vine_4' then
                    HideNPC(self, 'SIAULIAI_35_1_SQ_8_VINE')
                    local x, y, z = GetPos(list[i])
                    local mon = CREATE_MONSTER_EX(list[i], 'vine_4', x, y, z, GetDirectionByAngle(list[i]), 'Neutral', nil, SIAULIAI_35_1_SQ_8_VINE_SET)
                    AddVisiblePC(mon, self, 1)
--                    AddScpObjectList(list[i], 'SIAULIAI_35_1_SQ_7', self)
                    RunScript('SIAULIAI_35_1_SQ_8_VINE_BURST', mon)
                    if quest_ssn.QuestInfoValue2 < quest_ssn.QuestInfoMaxCount2 then
                        quest_ssn.QuestInfoValue2 = quest_ssn.QuestInfoValue2 + 1
                        SaveSessionObject(self, quest_ssn)
                    end
                end
            end
        end
    end
end

--TABLELAND71_SUBQ4ITEM
function SCR_UES_TABLE71_SUBQ4ITEM(self, argObj, argstring, arg1, arg2)
    local check_point = GetScpObjectList(argObj, 'TABLE71_CHECK_POINT')
    local action = DOTIMEACTION_R(self,  ScpArgMsg('TABLE71_SUBQ4_MSG1'), 'SKL_ASSISTATTACK_METALDETECTOR', 1)
    if action == 1 then
        local hover = GetScpObjectList(self, 'TABLE71_POINT_HOVER')
        if #hover == 0 then
            local x, y, z = GetPos(self)
            local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, HIDENSEEK_HOVER_SET)
            AddScpObjectList(self, 'TABLE71_POINT_HOVER', mon)
            SetOwner(mon, self, 1)
            AttachEffect(mon, 'I_light015_yellow', 2.0, 'TOP')
            SetNoDamage(mon, 1)
            SetLifeTime(mon, 5, 1)
            RunScript('TABLE71_POINT_HOVER_FIND', self, mon, argObj)
        else
            RunScript('TABLE71_POINT_HOVER_FIND', self, mon, argObj)
        end
    end
end

function HIDENSEEK_HOVER_SET(mon)
    mon.Name = "UnvisibleName"
    mon.BTree = "None"
    mon.Tactics = "None"
end

function TABLE71_POINT_HOVER_FIND(self, mon, argObj)
    local hover = GetScpObjectList(self, 'TABLE71_POINT_HOVER')
    local hover_owner = GetOwner(self)
    local x, y, z = GetPos(mon)
    local sObj = GetSessionObject(self, "SSN_TABLELAND_71_SQ4")
    if argObj ~= nil then
        local PosX, PosY, PosZ = GetPos(argObj)
        local range = SCR_POINT_DISTANCE(x, z, PosX, PosZ)
        if range < 50 then
            PlayEffect(argObj, 'F_buff_basic032_yellow_line', 1, 'BOT')
            if argObj.Dialog == "TABLE71_POINT1" then
                if isHideNPC(self, "TABLE71_POINT1") == "NO" then
                    if sObj.Step1 < 1 then
                        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('TABLE71_SUBQ7_RESULT1'), 5)
                        AddBuff(self, self, "TABLE71_SUBQ4_BUFF1",1, 0, 10000, 1)
                    else
                        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('TABLE71_SUBQ7_RESULT2'), 5)
                    end
                end
            elseif argObj.Dialog == "TABLE71_POINT2" then
                if isHideNPC(self, "TABLE71_POINT2") == "NO" then
                    if sObj.Step2 < 1 then
                        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('TABLE71_SUBQ7_RESULT1'), 5)
                        AddBuff(self, self, "TABLE71_SUBQ4_BUFF2",1, 0, 10000, 1)
                    else
                        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('TABLE71_SUBQ7_RESULT2'), 5)
                    end
                end
            elseif argObj.Dialog == "TABLE71_POINT3" then
                if isHideNPC(self, "TABLE71_POINT3") == "NO" then
                    if sObj.Step3 < 1 then
                        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('TABLE71_SUBQ7_RESULT1'), 5)
                        AddBuff(self, self, "TABLE71_SUBQ4_BUFF3",1, 0, 10000, 1)
                    else
                        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('TABLE71_SUBQ7_RESULT2'), 5)
                    end
                end
            end
            Kill(mon)
--        elseif range> 40 and range < 50 then
--            HoverAround(mon, self, 10, 1, 20.0, 1)
--            ShowBalloonText(self, 'TABLELAND71_POINT_NEAR', 3)
        elseif range> 50 and range < 70 then
            HoverAround(mon, self, 10, 1, 10.0, 1)
            ShowBalloonText(self, 'TABLELAND71_POINT_NEAR', 3)
--        elseif range > 60 and range < 70 then
--            HoverAround(mon, self, 10, 1, 8.0, 1)
--            ShowBalloonText(self, 'TABLELAND71_POINT_MORECLOSER', 3)
        elseif range > 70 and range < 90 then
            HoverAround(mon, self, 10, 1, 6.0, 1)
            ShowBalloonText(self, 'TABLELAND71_POINT_CLOSE', 3)
--        elseif range > 80 and range < 90 then
--            HoverAround(mon, self, 10, 1, 4.0, 1)
--            ShowBalloonText(self, 'TABLELAND71_POINT_GETCLOSER', 3)
        else
            HoverAround(mon, self, 10, 1, 2.0, 1)
            ShowBalloonText(self, 'TABLELAND71_POINT_CLOSER', 3)
        end
    end
end



--TABLE71_SUBQ7ITEM2
function SCR_UES_TABLE71_SUBQ7ITEM2(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, "TABLELAND_71_SQ7")
    if result == "PROGRESS" then
        LookAt(self, argObj)
        local action_r = DOTIMEACTION_R(self,  ScpArgMsg('TABLELAND_71_SQ7_SCROLL'), 'SCROLL', 0.7)
        if action_r == 1 then
            PlayEffect(argObj, 'F_light013', 2, 'MID')
            AddBuff(self, argObj, 'TABLE71_SUBQ7ITEM2_BUFF', 1, 0, 5000, 1);
            SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('TABLELAND_71_SQ7_SUCC'), 5)
        end
    end
end

--TABLE72_SUBQ6ITEM1
function SCR_USE_TABLE72_SUBQ6ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, "TABLELAND_72_SQ6")
    if result == "PROGRESS" then
        LookAt(self, argObj)
        local action_r = DOTIMEACTION_R(self,  ScpArgMsg('TABLELAND_72_SQ6_ANI'), 'MAKING', 1, 'SSN_HATE_AROUND')
        if action_r == 1 then
            if IsBuffApplied(argObj, "TABLE72_SUBQ6_BUFF") == "NO" then
                PlayEffect(argObj, 'F_smoke058_violet', 1, 'BOT')
                SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('TABLELAND_72_SQ6_MSG1'), 5)
                AddBuff(self, self, 'TABLE72_SUBQ6ITEM1_BUFF', 1, 0, 6000, 1);
            else
                SendAddOnMsg(self, 'NOTICE_Dm_ResBuff', ScpArgMsg('TABLELAND_72_SQ6_MSG2'), 5)
            end
        end
    end
end

--ABBEY_35_3_SQ_ORB
function SCR_USE_ABBEY_35_3_SQ_ORB(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, "ABBEY_35_3_SQ_3")
    if result == "PROGRESS" then
        LookAt(self, argObj)
        if IsBuffApplied(argObj, 'UC_stun') == 'NO' then
            AddBuff(self, argObj, 'UC_stun', 1, 0, 3000, 1)
        local action_r = DOTIMEACTION_R(self,  ScpArgMsg('ABBEY_35_3_SQ_3_DRAIN_ING'), 'ABSORB', 2)
        if action_r == 1 then
            local skill = GetNormalSkill(argObj)
            ForceDamage(argObj, skill, self, argObj, 0, 'MOTION', 'BLOW', 'I_force036_green', 1, 'arrow_cast', 'I_explosion002_green', 1, 'arrow_blow', 'SLOW', 100, 1, 0, 0, 0, 1, 1)
            SCR_PARTY_QUESTPROP_ADD(self, "SSN_ABBEY_35_3_SQ_3", "QuestInfoValue1", IMCRandom(5, 10))
            SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('ABBEY_35_3_SQ_3_DRAIN'), 5)
                PlayEffect(argObj, 'F_burstup004_dark', 1, nil, 'BOT')
            Kill(argObj)
        elseif action_r == 0 then
                if IsBuffApplied(argObj, 'UC_stun') == 'YES' then
                    RemoveBuff(argObj, 'UC_stun')
            end
        end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('ABBEY_35_3_SQ_3_DRAIN_FAIL'), 5)
        end
    end
end

--ABBEY_35_4_SQ_HOLLYORB
function SCR_USE_ABBEY_35_4_SQ_HOLLYORB(self, argObj, argstring, arg1, arg2)
    local quest_ssn = GetSessionObject(self, 'SSN_ABBEY_35_4_SQ_6')
    if quest_ssn ~= nil then
        if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
            LookAt(self, argObj)
            local action_r = DOTIMEACTION_R(self,  ScpArgMsg('ABBEY_35_4_SQ_8_INJECT'), 'ABSORB', 2)
            if action_r == 1 then
                HideNPC(self, 'ABBEY_35_4_UNHOLY')
                local x, y, z = GetPos(argObj)
                local mon = CREATE_MONSTER_EX(self, 'npc_Obelisk', x, y, z, GetDirectionByAngle(argObj), 'Peaceful', 1, ABBEY_35_4_UNHOLY_SET)
                SetTacticsArgStringID(mon, 'Anim/ON_RED')
                AddVisiblePC(mon, self, 1)
                ActorVibrate(mon, 1, 0.5, 100, 0)
                PlayEffect(mon, 'F_buff_basic027_navy_line', 1)
                RunScript('ABBEY_35_4_UNHOLY_KILL', mon)
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("ABBEY_35_4_SQ_8_DESTROY"), 3)
                quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
                SaveSessionObject(self, quest_ssn)
            end
        end
    end
end

function ABBEY_35_4_UNHOLY_SET(mon)
    mon.BTree = "None";
	mon.Tactics = "None";
	mon.Name = 'UnvisibleName'
end

--ABBEY_35_3_SQ_10_REAGENT
function SCR_USE_ABBEY_35_3_SQ_10_REAGENT(self, argObj, argstring, arg1, arg2)
    local quest_ssn = GetSessionObject(self, 'SSN_ABBEY_35_3_SQ_10')
    if quest_ssn ~= nil then
        LookAt(self, argObj)
        local result2 = DOTIMEACTION_R(self, ScpArgMsg("SIAULIAI_35_1_SQ_7_REAGENT_ING"), "FLASK", 2)
        if result2 == 1 then
            local list, cnt = SelectObject(self, 100, 'ALL')
            local i
            for i = 1, cnt do
                if list[i].ClassName == 'vine_4' then
                    HideNPC(self, 'ABBEY_35_3_VINE')
                    local x, y, z = GetPos(list[i])
                    local mon = CREATE_MONSTER_EX(list[i], 'vine_4', x, y, z, GetDirectionByAngle(list[i]), 'Neutral', nil, SIAULIAI_35_1_SQ_8_VINE_SET)
                    AddVisiblePC(mon, self, 1)
                    RunScript('ABBEY_35_3_SQ_10_VINE_DEAD', mon)
                    if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                        quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
                        SaveSessionObject(self, quest_ssn)
                    end
                end
            end
        end
    end
end

--SCR_USE_TABLE72_SUBQ9ITEM
function SCR_USE_TABLE72_SUBQ9ITEM(self, argObj, BuffName, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, "TABLELAND_73_SQ1")
    if result == "PROGRESS" then
        LookAt(self, argObj)
        local action_r = DOTIMEACTION_R(self,  ScpArgMsg('TABLELAND_72_SQ6_ANI'), 'MAKING', 1)
        if action_r == 1 then
            PlayEffect(argObj, 'F_smoke058_violet', 1, 'BOT')
            SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('TABLELAND_72_SQ6_MSG1'), 5)
            SCR_PARTY_QUESTPROP_ADD(self, "SSN_TABLELAND_73_SQ1", "QuestInfoValue1", IMCRandom(2, 10))
            Kill(self)
        end
    end
end

--SCR_USE_TABLE73_SUBQ5_ITEM
function SCR_USE_TABLE73_SUBQ5_ITEM(self, argObj, BuffName, arg1, arg2)
    local zoneID = GetZoneInstID(self)
    local pos_list = SCR_CELLGENPOS_LIST(self, 'Front2', 0)
    if #pos_list > 0 then
        for i = 1, #pos_list do
            if IsValidPos(zoneID, pos_list[i][1], pos_list[i][2], pos_list[i][3]) == 'YES' then
                local action_result = DOTIMEACTION_R(self, ScpArgMsg("TABLE73_SUBQ5_MSG5"), 'MAKING', 1)
                if action_result == 1 then
                    local mon = CREATE_NPC(self, "bonfire_1", pos_list[i][1], pos_list[i][2], pos_list[i][3], 0, "Neutral", GetLayer(self))
                    SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('TABLE73_SUBQ5_MSG6'), 3);
                    SetLifeTime(mon, 60)
                    mon.StrArg1 ="Campfire"
                    PlayAnim(mon, "ON", 1)
                    RunScript("TAKE_ITEM_TX", self, "TABLE73_SUBQ5_ITEM", 5, "Quest")
                    break;
                end
            end
        end
    end
end

--SCR_USE_TABLE73_SUBQ6_ITEM
function SCR_USE_TABLE73_SUBQ6_ITEM(self, argObj, BuffName, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, "TABLELAND_73_SQ6")
    if result == "PROGRESS" then
    local zoneID = GetZoneInstID(self)
        local pos_list = SCR_CELLGENPOS_LIST(self, 'Front2', 0)
        if #pos_list > 0 then
            for i = 1, #pos_list do
                if IsValidPos(zoneID, pos_list[i][1], pos_list[i][2], pos_list[i][3]) == 'YES' then
                    local action_result = DOTIMEACTION_R(self, ScpArgMsg("TABLE73_SUBQ5_MSG5"), 'MAKING', 2)
                    if action_result == 1 then
                        local mon = CREATE_NPC(self, "bonfire_1", pos_list[i][1], pos_list[i][2], pos_list[i][3], 0, "Neutral", GetLayer(self))
                        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('TABLE73_SUBQ5_MSG6'), 3);
                        SetLifeTime(mon, 10)
                        mon.StrArg1 ="Campfire"
                        PlayAnim(mon, "ON", 1)
                        RunScript("TAKE_ITEM_TX", self, "TABLE73_SUBQ6_ITEM", 5, "Quest")
                        break;
                    end
                end
            end
        end
    end
end

--CORAL_35_2_SQ_2_STONEPIECE
function SCR_USE_CORAL_35_2_SQ_2_STONEPIECE(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'CORAL_35_2_SQ_2')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        local result2 = DOTIMEACTION_R(self, ScpArgMsg("CORAL_35_2_SQ_2_STONE_SHOT"), "PUBLIC_THROW", 0.2)
        if result2 == 1 then
            local skill = GetNormalSkill(self)
            ForceDamage(self, skill, argObj, self, 0, 'MOTION', 'BLOW', 'I_SlaveStone_mash', 0.2, 'arrow_cast', 'F_stone005', 1, 'arrow_blow', 'SLOW', 150, 1, 0, 0, 0, 1, 1)
            SCR_PARTY_QUESTPROP_ADD(self, "SSN_CORAL_35_2_SQ_2", "QuestInfoValue1", 1)
            ShowBalloonText(self, 'CORAL_35_2_SQ_2_STONE', 4)
        end
    end
end

--CORAL_35_2_SQ_3_HORNPIECE
function SCR_USE_CORAL_35_2_SQ_3_HORNPIECE(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'CORAL_35_2_SQ_3')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        local result2 = DOTIMEACTION_R(self, ScpArgMsg("CORAL_35_2_SQ_3_THROWING"), "PUBLIC_THROW", 0.2)
        if result2 == 1 then
            local skill = GetNormalSkill(self)
            ForceDamage(self, skill, argObj, self, 0, 'MOTION', 'BLOW', 'I_cleric_jincangu_force_mash', 0.5, 'arrow_cast', 'F_stone005', 1, 'arrow_blow', 'SLOW', 150, 1, 0, 0, 0, 1, 1)
            local list, cnt = SelectObject(self, 100, 'ALL')
            local i
            if cnt > 0 then
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].ClassName == 'Altarcrystal_G1' then
                            if list[i].Enter == 'CORAL_35_2_CRYSTAL_TERRA' then
                                RunScript('CORAL_35_2_SQ_3_1_RUN', self)
                            elseif list[i].Enter == 'CORAL_35_2_CRYSTAL_MARINE' then
                                RunScript('CORAL_35_2_SQ_3_2_RUN', self)
                            end
                        end
                    end
                end
            end
        end
    end
end

--CORAL_35_2_SQ_8_MARINESTONE
function SCR_USE_CORAL_35_2_SQ_8_MARINESTONE(self, argObj, argstring, arg1, arg2)
    local count = GetScpObjectList(self, 'CORAL_35_2_SQ_8')
    if #count == 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'Altarcrystal_P1', x, y+15, z, GetDirectionByAngle(self), 'Neutral', self.Lv, CORAL_35_2_SQ_8_NPC_SET)
        AddScpObjectList(self, 'CORAL_35_2_SQ_8', mon)
        SetLifeTime(mon, 15);
        AttachEffect(mon, 'F_light055_blue', 8, 'MID')
        AttachEffect(mon, 'F_ground002', 40, 'BOT')
    end
end

function CORAL_35_2_SQ_8_NPC_SET(mon)
	mon.BTree = "None"
	mon.Tactics = "None"
	mon.KDArmor = 999
	mon.Name = 'UnvisibleName'
end

--CORAL_35_2_SQ_7_HARMONYSTONE
function SCR_USE_CORAL_35_2_SQ_7_HARMONYSTONE(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'CORAL_35_2_SQ_7')
    if result == 'PROGRESS' then
        local count = GetScpObjectList(self, 'CORAL_35_2_SQ_7')
        if #count == 0 then
            local x, y, z = GetPos(self)
            local mon = CREATE_MONSTER_EX(self, 'Altarcrystal_P1', x, y+15, z, GetDirectionByAngle(self), 'Neutral', self.Lv, CORAL_35_2_SQ_7_NPC_SET)
            AddScpObjectList(self, 'CORAL_35_2_SQ_7', mon)
            SetLifeTime(mon, 15);
            AttachEffect(mon, 'F_light055_orange', 8, 'MID')
            AttachEffect(mon, 'F_ground002', 40, 'BOT')
        end
    else
        local quest_ssn = GetSessionObject(self, 'SSN_CORAL_35_2_SQ_11')
        if quest_ssn ~= nil then
            local list, cnt = SelectObject(self, 100, 'ALL')
            local i
            if cnt > 0 then
                for i = 1, cnt do
                    if list[i].ClassName == 'jukotail' or list[i].ClassName == 'Siaulav_orange' or list[i].ClassName == 'Siaulav_bow_orange' then
                        if IsDead(list[i]) == 0 then
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CORAL_35_2_SQ_11_USE_FAIL"), 3)
                            InsertHate(list[i], self, 1)
                            return
                        end
                    end
                end
                if argObj.ClassName == 'Altarcrystal_Silhouette_Noobb' then
                    LookAt(self, argObj)
                    local action_result = DOTIMEACTION_R(self, ScpArgMsg("CORAL_35_2_SQ_11_SUCC_ING"), 'ABSORB', 5)
                    if action_result == 1 then
                        PlayEffectLocal(argObj, self, 'F_pattern015_orange', 1)
                        RunScript('CORAL_35_2_SQ_11_SUCC', self)
                        if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                            quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
                            SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("CORAL_35_2_SQ_11_SUCC_MSG"), 5);
                        end
                    end
                end
            else
                if argObj.ClassName == 'Altarcrystal_Silhouette_Noobb' then
                    LookAt(self, argObj)
                    local action_result = DOTIMEACTION_R(self, ScpArgMsg("CORAL_35_2_SQ_11_SUCC_ING"), 'ABSORB', 2)
                    if action_result == 1 then
                        PlayEffectLocal(argObj, self, 'F_pattern015_orange', 1)
                        RunScript('CORAL_35_2_SQ_11_SUCC', self)
                        if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                            quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
                            SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("CORAL_35_2_SQ_11_SUCC_MSG"), 5);
                        end
                    end
                end
            end
        end
    end
end

function CORAL_35_2_SQ_7_NPC_SET(mon)
	mon.BTree = "None"
	mon.Tactics = "None"
	mon.KDArmor = 999
	mon.Name = 'UnvisibleName'
end

--CORAL_35_2_SQ_6_TERRASTONE
function SCR_USE_CORAL_35_2_SQ_6_TERRASTONE(self, argObj, argstring, arg1, arg2)
    local count = GetScpObjectList(self, 'CORAL_35_2_SQ_12')
    if #count == 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'Altarcrystal_P1', x, y+15, z, GetDirectionByAngle(self), 'Neutral', self.Lv, CORAL_35_2_SQ_12_NPC_SET)
        AddScpObjectList(self, 'CORAL_35_2_SQ_12', mon)
        SetLifeTime(mon, 15);
        AttachEffect(mon, 'F_light055_green', 8, 'MID')
        AttachEffect(mon, 'F_ground002', 40, 'BOT')
    end
end

function CORAL_35_2_SQ_12_NPC_SET(mon)
	mon.BTree = "None"
	mon.Tactics = "None"
	mon.KDArmor = 999
	mon.Name = 'UnvisibleName'
end

--CORAL_35_2_SQ_14_FINDER
function SCR_USE_CORAL_35_2_SQ_14_FINDER(self, argObj, argstring, arg1, arg2)
    local check_Q1 = SCR_QUEST_CHECK(self, 'CORAL_35_2_SQ_14')
    if check_Q1 == 'PROGRESS' then
        local action_r = DOTIMEACTION_R(self, ScpArgMsg('CORAL_35_2_SQ_14_READY'), 'ABSORB', 2)
        if action_r == 1 then
            PlayEffect(self, 'F_light081_ground_orange', 4.0, 'BOT')
            local rnd = IMCRandom(1, 2)
            if rnd == 1 then
                local x, y, z = GetPos(self)
                local rnd_pos = SCR_DOUGHNUT_RANDOM_POS(x, z, 60, 120)
                local mon = CREATE_MONSTER_EX(self, 'blank_npc_3', rnd_pos['x'], y, rnd_pos['z'], GetDirectionByAngle(self), 'Neutral', self.Lv, CORAL_35_2_SQ_14_NPC_SET)
                AddScpObjectList(mon, 'CORAL_35_2_SQ_14', self)
                SetLifeTime(mon, 60)
                AttachEffect(mon, 'F_ground007', 10, 'BOT')
                SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("CORAL_35_2_SQ_14_FIND"), 5)
            else
                SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CORAL_35_2_SQ_14_FIND_FAIL"), 5)
            end
        end
    end
end

function CORAL_35_2_SQ_14_NPC_SET(mon)
    mon.BTree = "None";
	mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = 'UnvisibleName'
	mon.SimpleAI = 'CORAL_35_2_SQ_14_MAGIC_AI'
	mon.Dialog = 'None'
	mon.Enter = 'CORAL_35_2_SQ_14_MAGIC'
	mon.Range = 20
	mon.OnlyPCCheck = 'NO'
end

--CORAL_32_2_SQ_5_ITEM
function SCR_USE_CORAL_32_2_SQ_5_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'CORAL_32_2_SQ_5')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_coral_32_2' then
            if GetLayer(self) == 0 then
                local x, y, z = GetPos(self)
                local dist1 = SCR_POINT_DISTANCE(x, z, -698, 785)
                local dist2 = SCR_POINT_DISTANCE(x, z, 4, 39)
                local sObj = GetSessionObject(self, 'SSN_CORAL_32_2_SQ_5')
                if dist1 <= 45 then
                    if sObj.QuestInfoValue1 < 1 then
                        SetDirectionByAngle(self, GetAngleToPos(self, -698, 785))
                        PlayAnimLocal(self, self, 'BURY', 1)
                        SCR_SCRIPT_PARTY('SCR_CORAL_32_2_SQ_5_RUN', 1, self, 1)
                    else
                        ShowBalloonText(self, "CORAL_32_2_SQ_5_USE", 5)
                    end
                elseif dist2 <= 45 then
                    if sObj.QuestInfoValue2 < 1 then
                        SetDirectionByAngle(self, GetAngleToPos(self, 4, 39))
                        PlayAnimLocal(self, self, 'BURY', 1)
                        SCR_SCRIPT_PARTY('SCR_CORAL_32_2_SQ_5_RUN', 1, self, 2)
                    else
                        ShowBalloonText(self, "CORAL_32_2_SQ_5_USE", 5)
                    end
                end
            end
        end
    end
end

--CORAL_32_2_SQ_12_ITEM2
function SCR_USE_CORAL_32_2_SQ_12_ITEM2(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'CORAL_32_2_SQ_12')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_coral_32_2' then
            if GetLayer(self) == 0 then
                local result1 = DOTIMEACTION_R(self, ScpArgMsg("CORAL_32_2_SQ_12_ITEM"), 'EVENT_HOLY', 1)
                if result1  == 1 then
                    local list, cnt = SelectObject(self, 40, 'ALL', 1)
                    if cnt > 0 then
                        for i = 1, cnt do
                            if list[i].ClassName ~= 'PC' then
                                if list[i].ClassName == 'Stone04' then
                                    if list[i].Dialog == 'CORAL_32_2_SQ_12_STONE' then
                                        PlayEffect(list[i], 'F_light035_blue', 2, 0, 'BOT')
                                        list[i].NumArg4 = 1
                                        ShowBalloonText(self, 'CORAL_32_2_SQ_12_CHK2', 3)
                                        return;
                                    else
                                        list[i].NumArg4 = 1
                                        ShowBalloonText(self, 'CORAL_32_2_SQ_12_CHK', 3)
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

--PILGRIM41_2_SQ05_ITEM
function SCR_USE_PILGRIM41_2_SQ05_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local quest_ssn = GetSessionObject(self,'SSN_PILGRIM41_2_SQ05')
    local result = DOTIMEACTION_R(self, ScpArgMsg("PILGRIM41_2_SQ05_POTION"), 'EVENT_HOLY', 1)
    if result == 1 then
        if argObj.NumArg1 ~= 0 then
            return;
        else 
            argObj.NumArg1 = 1;
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIM41_2_SQ05_SUCC"), 2)
            ClearSimpleAI(argObj, 'ALL')
            DetachEffect(argObj, 'F_smoke019_dark_loop')
            RemoveBuff(argObj, "PILGRIM41_2_DARKAURA")
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_PILGRIM41_2_SQ05', 'QuestInfoValue1', 1)
            if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 then
                if isHideNPC(self, 'PILGRIM412_SQ_04') == 'YES' then
                    UnHideNPC(self, 'PILGRIM412_SQ_04')
                end
            end
            RandomMove(argObj, 1000)
            sleep(12000)
            KILL_BLEND(argObj, 1, 1)
        end
    end
end

--PILGRIM41_4_SQ05_ITEM
function SCR_USE_PILGRIM41_4_SQ05_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("PILGRIM41_4_SQ06_HOLY"), 'EVENT_HOLY', 0.5)
    if result1 == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIM41_4_SQ06_WEAK"), 2)
        AddBuff(self, argObj, 'PILGRIM41_4_MONWEAK', 1, 0, 0, 1)
        InsertHate(argObj, self, 99999)
    end
end

--PILGRIM41_5_SQ02_1_ITEM
function SCR_USE_PILGRIM41_5_SQ02_1_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM41_5_SQ03')
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("PILGRIM41_5_SQ02_HOLY"), 'EVENT_SPRAYFOOT', 1)
    if result1 == 1 then
        RunScript('GIVE_TAKE_ITEM_TX', self, 'PILGRIM41_5_SQ02_2_ITEM/1', 'PILGRIM41_5_SQ02_1_ITEM/1', 'QUEST')
        if result == "SUCCESS" then
            if isHideNPC(self, 'PILGRIM415_SQ_03') == 'YES' then
                UnHideNPC(self, 'PILGRIM415_SQ_03')
            end
        end
    end
end

--UNDER30_3_EVENT2_BOMB
function SCR_USE_UNDER30_3_EVENT2_BOMB(self, argObj, argstring, arg1, arg2)
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("UNDER303_ITEM_USE"), 'BURY', 2)
    if result1 == 1 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'ExplosionTrap', x, y+10, z, 0, 'Neutral', self.Lv, UNDER30_3_EVENT2_ITEM_SET);
        SetOwner(mon, self)
        AttachEffect(mon, "F_ground023", 1, "BOT")
        SetLifeTime(mon, 10)
        EnableAIOutOfPC(mon)
        RunScript("TAKE_ITEM_TX", self, "UNDER30_3_EVENT2_BOMB", 1, "UNDER30_3_EVENT2_gimmick")
    end
end

function UNDER30_3_EVENT2_ITEM_SET(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'UNDER30_3_EVENT2_ITEM_AI'
    mon.Name = ScpArgMsg('UNDER303_ITEM_NAME')
    mon.HPCount = 10
end

--MAPLE_25_3_SQ_120_ITEM1
function SCR_USE_MAPLE_25_3_SQ_120_ITEM1(self, argObj, argstring, arg1, arg2)
    PlayAnimLocal(self, self, 'EVENT_SPRAYFOOT', 1)
    local x, y, z = GetPos(argObj)
    local mon = CREATE_MONSTER_EX(self, 'rodeyokel', x, y, z, GetDirectionByAngle(self), 'Neutral', nil, SET_MAPLE_25_3_SQ_120_MON);
    Kill(argObj)
	SetLifeTime(mon, 12);
	SetDialogRotate(mon, 0)
	AddBuff(self, mon, 'Stun', 1, 0, 10000, 1);
end

function SET_MAPLE_25_3_SQ_120_MON(mon)
    mon.Dialog = "MAPLE_25_3_SQ_120_MON"
	mon.BTree = "None";
	mon.Tactics = "None";
	mon.SimpleAI = 'MAPLE_25_3_SQ_120_MON'
	mon.Name = ScpArgMsg("MAPLE_25_3_SQ_120_MONNAME");
	mon.MaxDialog = 1;
end

--BRACKEN42_1_SQ06_ITEM
function SCR_USE_BRACKEN42_1_SQ06_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'BRACKEN42_1_SQ07')
    if result == 'PROGRESS' then
        local result1 = DOTIMEACTION_R(self, ScpArgMsg("BRACKEN42_1_SQ07_OPEN"), 'MAKING', 3)
        if result1 == 1 then
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('BRACKEN42_1_SQ07_LOCK'), 5)
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_BRACKEN42_1_SQ07', 'QuestInfoValue1', 1)
        end
    end
end

--BRACKEN42_1_SQ07_ITEM
function SCR_USE_BRACKEN42_1_SQ07_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'BRACKEN42_1_SQ08')
    if result == 'PROGRESS' then
        local result1 = DOTIMEACTION_R(self, ScpArgMsg("BRACKEN42_1_SQ08_USE"), 'MAKING', 1)
        if result1 == 1 then
            RunScript('TAKE_ITEM_TX', self, 'BRACKEN42_1_SQ08_1_ITEM', 1, "Quest")
            local list, cnt = SelectObjectByClassName(self, 150, 'HiddenTrigger6')
            if cnt ~= 0 then
                for i = 1, cnt do
                    if list[i].Enter == 'BRACKEN421_SQ_08_1' then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('BRACKEN42_1_SQ08_FIND'), 5)
                        local x, y, z = GetPos(list[i])
                        Kill(list[i])
                        local mon = CREATE_MONSTER_EX(self, 'noshadow_npc', x, y, z, 0, 'Neutral', 0, BRACKEN421_SQ_08_RUN)
                        AddVisiblePC(mon, self, 1)
                    	SetLifeTime(mon, 60)
                    	AttachEffect(mon, 'F_light094_blue_loop', 5, 'BOT')
                    end
                end
            else
                SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('BRACKEN42_1_SQ08_FAIL'), 5)
            end
        end
    end
end

--BRACKEN42_2_SQ05_ITEM
function SCR_USE_BRACKEN42_2_SQ05_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'BRACKEN42_2_SQ05')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        local result1 = DOTIMEACTION_R(self, ScpArgMsg("BRACKEN42_2_SQ05_USE"), 'EVENT_HOLY', 1)
        if result1 == 1 then
            local buff = GetBuffByName(argObj, 'BRACKEN42_2_SLEEP')
            if buff == nil then
        	    PlayEffectLocal(argObj, self, 'F_explosion053_smoke', 1.0)
        	    AddBuff(self, argObj, 'Stun', 1, 0, 10000, 1)
                AddBuff(self, argObj, 'BRACKEN42_2_SLEEP', 1, 0, 20000, 1)
                SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('BRACKEN42_2_SQ05_SLEEP'), 5)
            else 
            end
        end
    end
end

--BRACKEN42_2_SQ06_ITEM
function SCR_USE_BRACKEN42_2_SQ06_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'BRACKEN42_2_SQ06')
    local quest_ssn = GetSessionObject(self, "SSN_BRACKEN42_2_SQ06")
    if result == 'PROGRESS' then
        if argObj.Dialog == 'BRACKEN422_SQ_06_1' then
            if quest_ssn.Step1 ~= 1 then
                LookAt(self, argObj)
                local result1 = DOTIMEACTION_R(self, ScpArgMsg("BRACKEN42_2_SQ06_USE"), 'FLASK', 1)
                if result1 == 1 then
                    if quest_ssn.Step1 ~= 1 then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_BRACKEN42_2_SQ06', 'QuestInfoValue1/ADD/1/Step1/FIXED/1')
                    	PlayEffectLocal(argObj, self, 'F_smoke043_green', 0.3, 0, 'BOT')
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('BRACKEN42_2_SQ06_POISON'), 5)
                    end
                end
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('BRACKEN42_2_SQ06_ALREADY'), 5)
            end
        elseif argObj.Dialog == 'BRACKEN422_SQ_06_2' then
            if quest_ssn.Step2 ~= 1 then
                LookAt(self, argObj)
                local result1 = DOTIMEACTION_R(self, ScpArgMsg("BRACKEN42_2_SQ06_USE"), 'FLASK', 1)
                if result1 == 1 then
                    if quest_ssn.Step2 ~= 1 then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_BRACKEN42_2_SQ06', 'QuestInfoValue1/ADD/1/Step2/FIXED/1')
                	    PlayEffectLocal(argObj, self, 'F_smoke043_green', 0.3, 0, 'BOT')
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('BRACKEN42_2_SQ06_POISON'), 5)
                    end
                end
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('BRACKEN42_2_SQ06_ALREADY'), 5)
            end
        elseif argObj.Dialog == 'BRACKEN422_SQ_06_3' then
            if quest_ssn.Step3 ~= 1 then
                LookAt(self, argObj)
                local result1 = DOTIMEACTION_R(self, ScpArgMsg("BRACKEN42_2_SQ06_USE"), 'FLASK', 1)
                if result1 == 1 then
                    if quest_ssn.Step3 ~= 1 then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_BRACKEN42_2_SQ06', 'QuestInfoValue1/ADD/1/Step3/FIXED/1')
                    	PlayEffectLocal(argObj, self, 'F_smoke043_green', 0.3, 0, 'BOT')
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('BRACKEN42_2_SQ06_POISON'), 5)
                    end
                end
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('BRACKEN42_2_SQ06_ALREADY'), 5)
            end
        elseif argObj.Dialog == 'BRACKEN422_SQ_06_4' then
            if quest_ssn.Step4 ~= 1 then
                LookAt(self, argObj)
                local result1 = DOTIMEACTION_R(self, ScpArgMsg("BRACKEN42_2_SQ06_USE"), 'FLASK', 1)
                if result1 == 1 then
                    if quest_ssn.Step4 ~= 1 then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_BRACKEN42_2_SQ06', 'QuestInfoValue1/ADD/1/Step4/FIXED/1')
                    	PlayEffectLocal(argObj, self, 'F_smoke043_green', 0.3, 0, 'BOT')
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('BRACKEN42_2_SQ06_POISON'), 5)
                    end
                end
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('BRACKEN42_2_SQ06_ALREADY'), 5)
            end
        elseif argObj.Dialog == 'BRACKEN422_SQ_06_5' then
            if quest_ssn.Step5 ~= 1 then
                LookAt(self, argObj)
                local result1 = DOTIMEACTION_R(self, ScpArgMsg("BRACKEN42_2_SQ06_USE"), 'FLASK', 1)
                if result1 == 1 then
                    if quest_ssn.Step5 ~= 1 then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_BRACKEN42_2_SQ06', 'QuestInfoValue1/ADD/1/Step5/FIXED/1')
                    	PlayEffectLocal(argObj, self, 'F_smoke043_green', 0.3, 0, 'BOT')
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('BRACKEN42_2_SQ06_POISON'), 5)
                    end
                end
            else
                SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('BRACKEN42_2_SQ06_ALREADY'), 5)
            end
        end
    end
end

--BRACKEN42_2_SQ11_ITEM
function SCR_USE_BRACKEN42_2_SQ11_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'BRACKEN42_2_SQ11')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        local result1 = DOTIMEACTION_R(self, ScpArgMsg("BRACKEN42_2_SQ11_USE"), 'BURY', 2)
        if result1 == 1 then
            if argObj.NumArg1 < 1 then
                argObj.NumArg1 = 1;
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_BRACKEN42_2_SQ11', 'QuestInfoValue1', 1)
            	PlayEffect(argObj, 'F_smoke141_darkblue_spread_out2', 0.5, 0, 'BOT')
                Kill(argObj)
            end
        end
    end
end

--LIMESTONE_52_1_MQ_10_CRYSTAL--
function SCR_USE_LIMESTONE_52_1_MQ_10_CRYSTAL(self, argObj, argstring, arg1, arg2)
    local quest_ssn = GetSessionObject(self, 'SSN_LIMESTONE_52_1_MQ_10')
    if quest_ssn ~= nil then
        LookAt(self, argObj)
        local result2 = DOTIMEACTION_R(self, ScpArgMsg("LIMESTONE_52_1_CRYSTAL_ING"), "ABSORB", 2)
        if result2 == 1 then
            local list, cnt = SelectObject(self, 200, 'ALL')
            local i
            for i = 1, cnt do
                if list[i].ClassName == 'cmine_cartheap' then
                    HideNPC(self, 'LIMSTONE_52_1_CART')
                    local x, y, z = GetPos(list[i])
                    sleep(500)
                    local mon = CREATE_MONSTER_EX(list[i], 'cmine_cartheap_Noobb', x, y, z, GetDirectionByAngle(list[i]), 'Neutral', nil, LIMESTONE_52_1_MQ_10_SET)
                    AddVisiblePC(mon, self, 1)
                    RunScript('LIMESTONE_52_1_MQ_10_KUPOLE', self, mon)
                    RunScript('LIMESTONE_52_1_MQ_10_RUN', mon)
                    if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                        quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
                        SaveSessionObject(self, quest_ssn)
                    end
                end
            end
        end
    end
end

function LIMESTONE_52_1_MQ_10_SET(mon)
    mon.Name = 'UnvisibleName'
    mon.BTree = 'None'
    mon.Tactics = 'None'
end

--LIMESTONE_52_1_SQ_1_POWDER--
function SCR_USE_LIMESTONE_52_1_SQ_1_POWDER(self, argObj, argstring, arg1, arg2)
    local x, y, z = GetPos(argObj)
    local mon = CREATE_MONSTER_EX(self, 'tala_sorcerer', x, y, z, GetDirectionByAngle(self), 'Neutral', nil, LIMESTONE_52_1_SQ_1_SET);
    Kill(argObj)
	SetLifeTime(mon, 12, 1);
	SetDialogRotate(mon, 0)
	PlayEffect(mon, 'F_explosion053_smoke', 1.0)
	AddBuff(self, mon, 'Stun', 1, 0, 10000, 1);
end

function LIMESTONE_52_1_SQ_1_SET(mon)
    mon.Dialog = "LIMESTONE_52_1_SQ_1_MON"
	mon.BTree = "None";
	mon.Tactics = "None";
	mon.SimpleAI = 'LIMESTONE_52_1_STUNMON'
	mon.Name = 'UnvisibleName'
	mon.MaxDialog = 1;
end

--LIMESTONE_52_1_SQ_1_NECK_1--
function SCR_USE_LIMESTONE_52_1_SQ_1_NECK_1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, "LIMESTONE_52_1_SQ_3")
    
    if result == "PROGRESS" then
        LookAt(self, argObj)
        local result2 = DOTIMEACTION_R(self, ScpArgMsg("LIMESTONE_52_1_SQ_3_ING"), "bury", 1)

        if result2 == 1 then
            local list, cnt = SelectObject(self, 40, "ALL")
            if cnt > 0 then
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].ClassName == "tala_sorcerer" then
                            if list[i].Faction == 'Neutral' then
                                SCR_PARTY_QUESTPROP_ADD(self, "SSN_LIMESTONE_52_1_SQ_3", "QuestInfoValue1", 1)
                                RunScript('LIMESTONE_52_1_STUNMON_DEAD', list[i], self)
                            end
                        end
                    end
                end
            end
        end
    end
end

--MAPLE_25_1_SQ_40_ITEM
function SCR_USE_MAPLE_25_1_SQ_40_ITEM(self, argObj, argstring, arg1, arg2)
    local dog = GetScpObjectList(self, 'MAPLE_25_1_SQ_40_ITEM')
    if #dog == 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'npc_dog6', x, y+5, z, GetDirectionByAngle(self), 'Neutral', 1, MAPLE_25_1_SQ_40_ITEM_RUN);
        AddVisiblePC(mon, self, 1);
        AddScpObjectList(mon, 'MAPLE_25_1_SQ_40_ITEM', self)
        AddScpObjectList(self, 'MAPLE_25_1_SQ_40_ITEM', mon)
        mon.FIXMSPD_BM = 70;
        EnableAIOutOfPC(mon)
        InvalidateStates(mon);
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("MAPLE_25_1_SQ_40_ITEM_HAVEDOG"), 2)
    end
end

--MAPLE_25_2_SQ_100_ITEM2
function SCR_USE_MAPLE_25_2_SQ_100_ITEM2(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'MAPLE_25_2_SQ_100')
    if result1 == 'PROGRESS' then
        local sObj = GetSessionObject(self, 'SSN_MAPLE_25_2_SQ_100')
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'MAPLE_25_2_SQ_100')
        --local result2 = DOTIMEACTION_R(self, ScpArgMsg("MAPLE_25_2_SQ_100_MSG1"), 'SKL_ASSISTATTACK_SHOVEL', animTime, 'SSN_HATE_AROUND')
        
        local result2 = DOTIMEACTION_R_DUMMY_ITEM(self, ScpArgMsg("MAPLE_25_2_SQ_100_MSG1"), 'skl_assistattack_shovel', animTime, 'SSN_HATE_AROUND', nil, 630012, "RH")
        
        DOTIMEACTION_R_AFTER(self, result2, animTime, before_time, 'MAPLE_25_2_SQ_100')
        if result2  == 1 then
            if sObj ~= nil then
                local list, cnt = SelectObjectByClassName(self, 70, 'Hiddennpc_Q4')
                if cnt > 0 then
                    local i
                    for i = 1, cnt do
                        PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'MID')
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_MAPLE_25_2_SQ_100', nil, nil, nil, 'MAPLE_25_2_SQ_100_ITEM/1')
                        SendAddOnMsg(self, 'NOTICE_Dm_GetItem', ScpArgMsg("MAPLE_25_2_SQ_100_MSG2"), 7)
                        Kill(list[i])
                        return 1
                    end
                else
                    ShowBalloonText(self, "MAPLE_25_2_SQ_100_DLG", 7)
                end
            end
        end
    end
end

--LIMESTONE_52_4_HOLY_CHARM--
function SCR_USE_LIMESTONE_52_4_HOLY_CHARM(self, argObj, argstring, arg1, arg2)
    local action_r = DOTIMEACTION_R(self, ScpArgMsg('LIMESTONE_52_4_HOLY_CHARM_ING'), 'ABSORB', 1)
    if action_r == 1 then
        if IsBuffApplied(argObj, 'LIMESTONE_52_4_HOLYCHARM') == 'NO' then
            AddBuff(self, argObj, 'LIMESTONE_52_4_HOLYCHARM', 1, 0, 0, 1)
        end
    end
end

--LIMESTONE_52_5_MQ_4_FINDER--
function SCR_USE_LIMESTONE_52_5_MQ_4_FINDER(self, argObj, argstring, arg1, arg2)
    local check_Q1 = SCR_QUEST_CHECK(self, 'LIMESTONE_52_5_MQ_4')
    local check_Q2 = SCR_QUEST_CHECK(self, 'LIMESTONE_52_5_SQ_1')
    if check_Q1 == 'PROGRESS' then
        local cntQ1 = GetScpObjectList(self, 'LIMESTONE_52_5_MQ_4_NPC')
        if #cntQ1 == 0 then
            local action_r = DOTIMEACTION_R(self, ScpArgMsg('CORAL_35_2_SQ_14_READY'), 'ABSORB', 2)
            if action_r == 1 then
                PlayEffect(self, 'F_light081_ground_orange', 6, 'BOT')
                local rnd = IMCRandom(1, 2)
                if rnd == 1 then
                    local x, y, z = GetPos(self)
                    local rnd_pos = SCR_DOUGHNUT_RANDOM_POS(x, z, 60, 120)
                    local mon = CREATE_MONSTER_EX(self, 'npc_telepty_device', rnd_pos['x'], y, rnd_pos['z'], 105, 'Neutral', self.Lv, LIMESTONE_52_5_MQ_4_NPC_SET)
                    SCR_RUNSCRIPT_PARTY('AddVisiblePC' , 1, mon, self, 1)
                    AddScpObjectList(self, 'LIMESTONE_52_5_MQ_4_NPC', mon)
                    SetLifeTime(mon, 60, 1)
                    AttachEffect(mon, 'F_smoke019_dark_loop', 1, 'BOT')
                    SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("LIMESTONE_52_5_MQ_4_FINDER_OK"), 5)
                else
                    SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("LIMESTONE_52_5_MQ_4_FINDER_NO"), 5)
                end
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("LIMESTONE_52_5_MQ_4_YET"), 5)
        end
    else
        if check_Q2 == 'PROGRESS' then
            local cntQ2 = GetScpObjectList(self, 'LIMESTONE_52_5_SQ_1_NPC')
            if #cntQ2 == 0 then
                local action_r = DOTIMEACTION_R(self, ScpArgMsg('CORAL_35_2_SQ_14_READY'), 'ABSORB', 2)
                if action_r == 1 then
                    PlayEffect(self, 'F_light081_ground_orange', 6, 'BOT')
                    local rnd = IMCRandom(1, 2)
                    if rnd == 1 then
                        local x, y, z = GetPos(self)
                        local rnd_pos = SCR_DOUGHNUT_RANDOM_POS(x, z, 60, 120)
                        local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', rnd_pos['x'], y, rnd_pos['z'], GetDirectionByAngle(self), 'Neutral', self.Lv, LIMESTONE_52_5_SQ_1_NPC_SET)
                        AddVisiblePC(mon, self, 1)
                        AddScpObjectList(self, 'LIMESTONE_52_5_SQ_1_NPC', mon)
                        SetLifeTime(mon, 60)
                        AttachEffect(mon, 'I_force080_violet', 0.5, 'MID')
                        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("LIMESTONE_52_5_SQ_1_FIND"), 5)
                    else
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("LIMESTONE_52_5_SQ_1_FAIL"), 5)
                    end
                end
            else
                SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("LIMESTONE_52_5_SQ_1_YET"), 5)
            end
        end
    end
end

function LIMESTONE_52_5_MQ_4_NPC_SET(mon)
    mon.BTree = "None";
	mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = 'UnvisibleName'
	mon.Dialog = 'LIMESTONE_52_5_MQ_4_EVIL_NPC'
end

function LIMESTONE_52_5_SQ_1_NPC_SET(mon)
    mon.BTree = "None";
	mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = 'UnvisibleName'
	mon.Dialog = 'LIMESTONE_52_5_SQ_1_NPC'
end

--BRACKEN431_SUBQ6_ITEM1
function SCR_USE_BRACKEN431_SUBQ6_ITEM1(self, argObj, argstring, arg1, arg2)
    local action_r = DOTIMEACTION_R(self, ScpArgMsg('BRACKEN431_SUBQ6_ITEM1_USE'), 'ABSORB', 1)
    if action_r == 1 then
        local zoneID = GetZoneInstID(self)
        local pos_list = SCR_CELLGENPOS_LIST(self, 'Front2', 0)
        if #pos_list > 0 then
            for i = 1, #pos_list do
                if IsValidPos(zoneID, pos_list[i][1], pos_list[i][2], pos_list[i][3]) == 'YES' then
                    local pos = IsValidPos(zoneID, pos_list[i][1], pos_list[i][2], pos_list[i][3])
                    local mon = CREATE_MONSTER_EX(self, 'magictrap_core_s', pos_list[i][1], pos_list[i][2], pos_list[i][3], GetDirectionByAngle(self), 'Neutral', self.Lv, BRACKEN431_SUBQ6_ITEM_SET)
                    SetOwner(mon, self)
                    SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("BRACKEN431_SUBQ5_MSG1"), 5)
                end
            end
        end
    end
end

function BRACKEN431_SUBQ6_ITEM_SET(mon)
    mon.BTree = "None";
	mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = 'UnvisibleName'
	mon.SimpleAI = "BRACKEN431_SUBQ6_ITEM_AI"
end

--SCR_USE_BRACKEN432_SUBQ6_ITEM1
function SCR_USE_BRACKEN432_SUBQ6_ITEM1(self, argObj, argstring, arg1, arg2)
    local action_r = DOTIMEACTION_R(self, ScpArgMsg('BRACKEN432_SUB_NPC_ANIM'), 'ABSORB', 1)
    if action_r == 1 then
        local x, y, z = GetPos(argObj)
        local mon = CREATE_NPC(self, "small_dandelion", x, y, z , -106, "Neutral", GetLayer(self), 'UnvisibleName', "BRACKEN432_FLOWER")
        PlayEffectLocal(argObj, self, "I_force081_red", 0.5, 'MID')
        SetLifeTime(mon, 15)
        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("BRACKEN432_SUB_NPC_FIND"), 3);
        Kill(argObj)
        mon.MaxDialog = 1
    end
end

--SCR_USE_BRACKEN432_SUBQ2_ITEM1
function SCR_USE_BRACKEN432_SUBQ2_ITEM1(self, argObj, argstring, arg1, arg2)
    local x, y, z = GetPos(argObj)
    if argObj.ClassName == "darong" then
        local mon = CREATE_MONSTER_EX(self, 'darong', x, y, z, GetDirectionByAngle(self), 'Neutral', nil, BRACKEN432_SUBQ_MON_KNOCKDAWN_FUNC);
        Kill(argObj)
    	SetLifeTime(mon, 12);
    	SetDialogRotate(mon, 0)
    	PlayEffect(mon, 'F_explosion053_smoke', 1.0)
    	AddBuff(self, mon, 'Stun', 1, 0, 10000, 1);
    elseif argObj.ClassName == "dorong" then
        local mon = CREATE_MONSTER_EX(self, 'dorong', x, y, z, GetDirectionByAngle(self), 'Neutral', nil, BRACKEN432_SUBQ_MON_KNOCKDAWN_FUNC);
        Kill(argObj)
    	SetLifeTime(mon, 12);
    	SetDialogRotate(mon, 0)
    	PlayEffect(mon, 'F_explosion053_smoke', 1.0)
    	AddBuff(self, mon, 'Stun', 1, 0, 10000, 1);
    end
end

function BRACKEN432_SUBQ_MON_KNOCKDAWN_FUNC(mon)
    mon.BTree = "None"
	mon.Tactics = "None"
	mon.Name = "UnvisibleName"
	mon.SimpleAI = 'BRACKEN432_MON_KNOCKDAWN_ANI'
	mon.Dialog = "BRACKEN432_SUBQ2_MON1"
	mon.MaxDialog = 1
	if mon.ClassName == "darong" then
        mon.Name = ScpArgMsg("BRACKEN432_SUBQ2_MONNAME1");
    elseif mon.ClassName == "dorong" then
        mon.Name = ScpArgMsg("BRACKEN432_SUBQ2_MONNAME2");
    end
end

--SCR_USE_BRACKEN433_SUBQ9_ITEM2
function SCR_USE_BRACKEN433_SUBQ9_ITEM2(self, argObj, argstring, arg1, arg2)
    local action = DOTIMEACTION_R(self,  ScpArgMsg('BRACKEN433_SUBQ10_ANIM'), 'ABSORB', 1)
    if action == 1 then
        if isHideNPC(self, "BRACKEN433_ARROW_NPC") == "YES" then
            local fndList, fndCnt = SelectObject(self, 330, 'ALL', 1)
            local i
            local check_mon
            if fndCnt >= 1 then
                for i = 1, fndCnt do
                    if fndList[i].ClassName == "pedlar_lose_1" then
                        if fndList[i].Dialog == "BRACKEN433_ARROW_NPC" then
                            check_mon = fndList[i]
                            break;
                        end
                    end
                end
            end
            local x, y, z = GetPos(self)
            local PosX, PosY, PosZ = GetPos(check_mon)
            local range = SCR_POINT_DISTANCE(x, z, PosX, PosZ)
            local mon
            if range < 150 then
                mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, ARROW_FIND_HOVER_SET)
                AddScpObjectList(self, 'ARROW_FIND_HOVER', mon)
                SetOwner(mon, self, 1)
                AttachEffect(mon, 'I_light015_yellow', 2.0, 'TOP')
                SetNoDamage(mon, 1)
                SetLifeTime(mon, 3, 1)
                RunScript('ARROW_FIND_HOVER_FIND', self, mon, check_mon)
            else
                ShowBalloonText(self, 'BRACKEN433_SUBQ10_POINT_FAR', 5)
            end
        end
    end
end

function ARROW_FIND_HOVER_SET(mon)
    mon.Name = "UnvisibleName"
    mon.BTree = "None"
    mon.Tactics = "None"
end

function ARROW_FIND_HOVER_FIND(self, mon, check_mon)
    local x, y, z = GetPos(self)
    local sObj = GetSessionObject(self, "SSN_BRACKEN43_3_SQ10")
    local PosX, PosY, PosZ = GetPos(check_mon)
    local range = SCR_POINT_DISTANCE(x, z, PosX, PosZ)
    if range < 40 then
        PlayEffectLocal(check_mon, self, 'F_buff_basic032_yellow_line', 1, 'BOT')
        UnHideNPC(self, "BRACKEN433_ARROW_NPC")
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_BRACKEN43_3_SQ10', 'QuestInfoValue1', 1, nil)
        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('BRACKEN433_SUBQ10_RESULT1'), 5)
    elseif range> 50 and range < 80 then
        HoverAround(mon, self, 10, 1, 10.0, 1)
        ShowBalloonText(self, 'BRACKEN433_SUBQ10_POINT_NEAR', 5)
    elseif range > 80 and range < 110 then
        HoverAround(mon, self, 10, 1, 6.0, 1)
        ShowBalloonText(self, 'BRACKEN433_SUBQ10_POINT_CLOSE', 5)
    elseif range > 110 and range < 150 then
        HoverAround(mon, self, 10, 1, 3.0, 1)
        ShowBalloonText(self, 'BRACKEN433_SUBQ10_POINT_CLOSER', 5)
    else
        ShowBalloonText(self, 'BRACKEN433_SUBQ10_POINT_FAR', 5)
    end
end

--SCR_USE_BRACKEN433_SUBQ3_ITEM1
function SCR_USE_BRACKEN433_SUBQ3_ITEM1(self, argObj, argstring, arg1, arg2)
    local action = DOTIMEACTION_R(self,  ScpArgMsg('BRACKEN433_SUBQ3_MSG1'), 'APPLY', 1)
    if action == 1 then
        if IsBuffApplied(self, "BRACKEN433_SUBQ3_BUFF") == "NO" then
            AddBuff(self, self, "BRACKEN433_SUBQ3_BUFF", 1, 0, 20000 ,1)
            SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('BRACKEN433_SUBQ3_MSG2'), 5)
        end
    end
end

--SCR_USE_BRACKEN434_SUBQ2_ITEM2
function SCR_USE_BRACKEN434_SUBQ2_ITEM2(self, argObj, argstring, arg1, arg2)
    local action = DOTIMEACTION_R(self,  ScpArgMsg('BRACKEN434_SUB_ITEM_USE'), 'ABSORB', 1)
    if action == 1 then
        local Obj = GetScpObjectList(self, 'BRACKEN434_SUBQ2_OBJ')
        if #Obj <= 0 then
            local sObj = GetSessionObject(self, "SSN_BRACKEN43_4_SQ2")
            local pos1 = sObj.Goal1
            local pos2 = sObj.Goal2
            local pos3 = sObj.Goal3
            local pos4 = sObj.Goal4
            local pos5 = sObj.Goal5
            local pos6 = sObj.Goal6
            local pos7 = sObj.Goal7
            local pos8 = sObj.Goal8
            local pos9 = sObj.Goal9
            --print("pos1 : "..pos1.." / sObj.Goal1 : "..sObj.Goal1, "pos2 : "..pos2.." / sObj.Goal2 : "..sObj.Goal2, "pos3 : "..pos3.." / sObj.Goal3 : "..sObj.Goal3, "pos4 : "..pos4.." / sObj.Goal4 : "..sObj.Goal4, "pos5 : "..pos5.." / sObj.Goal5 : "..sObj.Goal5, "pos6 : "..pos6.." / sObj.Goal6 : "..sObj.Goal6, "pos7 : "..pos7.." / sObj.Goal7 : "..sObj.Goal7, "pos8 : "..pos8.." / sObj.Goal8 : "..sObj.Goal8, "pos9 : "..pos9.." / sObj.Goal9 : "..sObj.Goal9)
            local pos_arr = {pos1, pos2, pos3, pos4, pos5, pos6, pos7, pos8, pos9}
            
            local loc = {}
            loc[1] = {123, 155, 1045}
            loc[2] = {95, 155, 883}
            loc[3] = {361, 155, 678}
            loc[4] = {494, 155, 614}
            loc[5] = {711, 155, 716}
            loc[6] = {769, 162, 848}
            loc[7] = {523, 155, 879}
            loc[8] = {398, 155, 862}
            loc[9] = {349, 155, 1043}
            local i = IMCRandom(1, 9)
            
            if sObj.Step1 <= 0 then
                sObj.Step1 = 9
            end
            
            local cnt = sObj.Step1
            
            if cnt == 9 then
                local i = IMCRandom(1, 9)
                sObj.Step2 = loc[i][1]
                sObj.Step3 = loc[i][2]
                sObj.Step4 = loc[i][3]
                pos_arr[i] = 1
            elseif cnt < 9 then
                local target_pos = BRACKEN434_SUBQ2_RAN_LOC_CK(self, pos_arr, cnt)
                --print("selec pos : ", target_pos)
                sObj.Step2 = loc[target_pos][1]
                sObj.Step3 = loc[target_pos][2]
                sObj.Step4 = loc[target_pos][3]
            end
            
            local x, y, z = GetPos(self)
            local mon = CREATE_NPC_EX(self, "Hiddennpc_move", x, y, z, 0, "Neutral", "UnvisibleName", self.Lv, BRACKEN434_SUBQ2_OBJ_SET)
            SetOwner(mon, self, 1)
            AttachEffect(mon, 'I_spread_out001_light', 2.0, 'TOP')
            AddScpObjectList(self, 'BRACKEN434_SUBQ2_OBJ', mon)
            SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('BRACKEN434_SUB_OBJ_CRE'), 5)
            EnableAIOutOfPC(mon)
            SetLifeTime(mon, 20)
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('BRACKEN434_SUB_OBJ_CRE1'), 5)
        end
    end
end

function BRACKEN434_SUBQ2_RAN_LOC_CK(self, pos_arr, cnt)
    local i
    local j = 0
    local random = {}
    for i = 1, #pos_arr do
        --print("pos_arr"..i.." : "..pos_arr[i])
        if pos_arr[i] == 0 then
            random[j+1] = pos_arr[i] + i
            j = j + 1
            --print(random[j])
        end
    end
    
    local rnd
    
    if cnt == 8 then 
        rnd = select(IMCRandom(1,cnt), random[1], random[2], random[3], random[4], random[5], random[6], random[7], random[8])
    elseif cnt == 7 then 
        rnd = select(IMCRandom(1,cnt), random[1], random[2], random[3], random[4], random[5], random[6], random[7])
    elseif cnt == 6 then 
        rnd = select(IMCRandom(1,cnt), random[1], random[2], random[3], random[4], random[5], random[6])
    elseif cnt == 5 then 
        rnd = select(IMCRandom(1,cnt), random[1], random[2], random[3], random[4], random[5])
    elseif cnt == 4 then 
        rnd = select(IMCRandom(1,cnt), random[1], random[2], random[3], random[4])
    elseif cnt == 3 then 
        rnd = select(IMCRandom(1,cnt), random[1], random[2], random[3])
    elseif cnt == 2 then 
        rnd = select(IMCRandom(1,cnt), random[1], random[2])
    end
    return rnd
end

function BRACKEN434_SUBQ2_OBJ_SET(mon)
    mon.BTree = "None"
    mon.Tactics = "None"
    mon.MSPD = 70
    mon.SimpleAI = "BRACKEN434_SUBQ2_OBJ_AI"
end

--SCR_USE_BRACKEN434_SUBQ7_ITEM
function SCR_USE_BRACKEN434_SUBQ7_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local action = DOTIMEACTION_R(self,  ScpArgMsg('BRACKEN434_SUB_ITEM_SEARCH'), 'ABSORB', 1)
    if action == 1 then
        if argObj.ClassName == "extra_tomb_no_obb" then
            if argObj.Enter == "BRACKEN434_SUBQ_FAKE_NPC3" then
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_BRACKEN43_4_SQ7', 'QuestInfoValue1', 1)
                PlayEffectLocal(argObj, self, "F_buff_basic034_pink", 1, 0, "BOT")
                SCR_SCRIPT_PARTY("BRACKEN434_SUBQ7_MSG_FUNC", 1, self)
            else
                SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("BRACKEN434_SUB7_NO_REACTION"), 5)
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("BRACKEN434_SUB7_NO_REACTION"), 5)
        end
    end
end

function BRACKEN434_SUBQ7_MSG_FUNC(pc)
    SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg("BRACKEN434_SUB7_COMPLETE"), 5)
end

--SCR_USE_BRACKEN434_SUBQ9_ITEM2
function SCR_USE_BRACKEN434_SUBQ9_ITEM2(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    if IsBuffApplied(argObj, "BRACKEN434_SUBQ_BUFF1") == "NO" then
        local action = DOTIMEACTION_R(self,  ScpArgMsg('BRACKEN434_SUBQ9_ANIM1'), 'ABSORB', 1)
        if action == 1 then
            AddBuff(self, argObj, "BRACKEN434_SUBQ_BUFF1", 1, 0, 8000, 1)
            PlayEffect(argObj, "F_light015_violet2", 1, "BOT")
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("BRACKEN434_SUBQ9_SUCCESS"), 6)
        end
    end
end

--SCR_USE_DCAPITAL_20_5_SQ_60_ITEM
function SCR_USE_DCAPITAL_20_5_SQ_60_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'F_DCAPITAL_20_5_SQ_60')
    local result2 = SCR_QUEST_CHECK(self, 'F_DCAPITAL_20_5_SQ_80')
    local result3 = SCR_QUEST_CHECK(self, 'F_DCAPITAL_20_6_SQ_80')
    local result4 = SCR_QUEST_CHECK(self, 'F_DCAPITAL_20_5_SQ_90')

    if result1 == 'PROGRESS' then
        local result4 = DOTIMEACTION_R(self, ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_DTA"), "ABSORB", 2)
        if result4 == 1 then
            local list1, cnt1 = SelectObject(self, 100, "ALL")
            if cnt1 > 0 then
                for i = 1, cnt1 do
                    if list1[i].ClassName ~= 'PC' then
                        if list1[i].ClassName == "bracken_ruin2" then
                            if list1[i].Dialog == 'DCAPITAL_20_5_SQ_60_CLUE' then
                                if GetDistance(self, list1[i]) <= 50 then
                                    PlayEffectLocal(list1[i], self, "F_light018", 1, 0, "BOT")
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_DCAPITAL_20_5_SQ_60', 'QuestInfoValue1', 1)
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_MSG1"), 3)
                                    return;
                                else
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_MSG2"), 3)
                                    return;
                                end
                            end
                        end
                    end
                end
            end
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_MSG3"), 3)
        end
    elseif result2 == 'PROGRESS' then
        local result7 = DOTIMEACTION_R(self, ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_DTA"), "ABSORB", 2)
        if result7 == 1 then
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_MSG3"), 3)
        end
    elseif result4 == 'PROGRESS' then
        local result5 = DOTIMEACTION_R(self, ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_DTA"), "ABSORB", 2)
        if result5 == 1 then
            local list2, cnt2 = SelectObject(self, 100, "ALL")
            if cnt2 > 0 then
                for j = 1, cnt2 do
                    if list2[j].ClassName ~= 'PC' then
                        if list2[j].ClassName == "bracken_ruin1" then
                            if list2[j].Dialog == 'DCAPITAL_20_5_SQ_90_CLUE' then
                                if GetDistance(self, list2[j]) <= 50 then
                                    PlayEffectLocal(list2[j], self, "F_light018", 1, 0, "BOT")
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_DCAPITAL_20_5_SQ_90', 'QuestInfoValue1', 1)
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_MSG1"), 3)
                                    return;
                                else
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_MSG2"), 3)
                                    return;
                                end
                            end
                        end
                    end
                end
            end
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_MSG3"), 3)
        end
    elseif result3 == 'PROGRESS' then
        local result6 = DOTIMEACTION_R(self, ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_DTA"), "ABSORB", 2)
        if result6 == 1 then
            local list3, cnt3 = SelectObject(self, 100, "ALL")
            if cnt3 > 0 then
                for k = 1, cnt3 do
                    if list3[k].ClassName ~= 'PC' then
                        if list3[k].ClassName == ("bracken_ruin1" or "bracken_ruin2") then
                            if list3[k].Dialog == 'DCAPITAL_20_6_SQ_80' then
                                if GetDistance(self, list3[k]) <= 50 then
                                    PlayEffectLocal(list3[k], self, "F_light018", 1, 0, "BOT")
                                    AddBuff(self, self, 'DCAPITAL_20_6_SQ_80_BUFF', 1, 0, 0, 1);
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_MSG4"), 3)
                                    return;
                                else
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_MSG3"), 3)
                                    return;
                                end
                            end
                        end
                    end
                end
            end
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_MSG3"), 3)
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DCAPITAL_20_5_SQ_60_ITEM_MSG1"), 3)
    end
end

--WHITETREES23_1_SQ06_ITEM1
function SCR_USE_WHITETREES23_1_SQ06_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'WHITETREES23_1_SQ06')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        local result1 = DOTIMEACTION_R(self, ScpArgMsg("WHITETREES23_1_SQ06_USE"), 'EVENT_HOLY', 1)
        if result1 == 1 then
            AddBuff(self, argObj, "WHITETREES23_1_SQ06_IMPETUS", 1, 0, 60000 ,1)
        end
    end
end

--MAPLE23_2_SQ06_ITEM1
function SCR_USE_MAPLE23_2_SQ06_ITEM1(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local result = DOTIMEACTION_R(self, ScpArgMsg("MAPLE23_2_SQ06_ACID"), 'EVENT_HOLY', 1, 'SSN_HATE_AROUND')
    local quest_ssn = GetSessionObject(self, 'SSN_MAPLE23_2_SQ06')
    if result == 1 then
        if IMCRandom(1, 5) ~= 5 then
            PlayEffectLocal(argObj, self, "F_smoke160_white_levitation", 1.5)
            local maple_acid = IMCRandom(8,16)
            local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
            local p
            if P_cnt >= 1 then
                for p = 1, P_cnt do
                    local quest_ssn = GetSessionObject(P_list[p], 'SSN_MAPLE23_2_SQ06')
                    quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + maple_acid
                    SaveSessionObject(P_list[p], quest_ssn)
                    if quest_ssn.QuestInfoValue1 >= quest_ssn.QuestInfoMaxCount1 then
                        SendAddOnMsg(P_list[p], "NOTICE_Dm_Clear", ScpArgMsg("MAPLE23_2_SQ06_CLEAN"), 5)
                    end
                end
            end
            RunScript('TAKE_ITEM_TX', self, "MAPLE23_2_SQ06_ITEM1", 1, "MAPLE23_2_SQ06")
        else
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("MAPLE23_2_SQ06_FAIL"), 5)
        end
    end
end

--WHITETREES23_3_SQ06_ITEM1
function SCR_USE_WHITETREES23_3_SQ06_ITEM1(self, argObj, strArg, numArg1, humarg2, itemClassID, itemID)
    TreasureMarkListByMap(self, 'f_whitetrees_23_3', 5, -681, 11, -1154,
                                                        -250, 79, -447,
                                                        885, 166, -219,
                                                        885, 219, 554,
                                                        57, 219, 1135)
end

--WHITETREES23_3_SQ06_ITEM2
function SCR_USE_WHITETREES23_3_SQ06_ITEM2(self, argObj, strArg, numArg1, humarg2, itemClassID, itemID)
    local result = SCR_QUEST_CHECK(self, 'WHITETREES23_3_SQ06')
    local quest_ssn = GetSessionObject(self, 'SSN_WHITETREES23_3_SQ06')
    if result == 'PROGRESS' then
        if argObj.Dialog == 'WHITETREES233_SQ_06_1' then
            if quest_ssn.Step1 ~= 0 then
                LookAt(self, argObj)
                local result1 = DOTIMEACTION_R(self, ScpArgMsg("WHITETREES23_3_SQ06_USE"), 'ABSORB', 1)
                if result1 == 1 then
                    if quest_ssn.Step1 == 1 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_RED', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM3/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_RED', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step1 == 2 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_BLUE', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM4/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_BLUE', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step1 == 3 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_YELLOW', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM5/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_YELLOW', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step1 == 4 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_MINT', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM6/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_MINT', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step1 == 5 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_VIOLET', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM7/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_VIOLET', self, argObj, quest_ssn)
                        end
                    end
                    quest_ssn.Step1 = 0
                    SaveSessionObject(self, quest_ssn)
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WHITETREES23_3_SQ06_ALREADY"), 5)
            end
        elseif argObj.Dialog == 'WHITETREES233_SQ_06_2' then
            if quest_ssn.Step2 ~= 0 then
                LookAt(self, argObj)
                local result1 = DOTIMEACTION_R(self, ScpArgMsg("WHITETREES23_3_SQ06_USE"), 'ABSORB', 1)
                if result1 == 1 then
                    if quest_ssn.Step2 == 1 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_RED', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM3/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_RED', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step2 == 2 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_BLUE', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM4/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_BLUE', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step2 == 3 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_YELLOW', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM5/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_YELLOW', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step2 == 4 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_MINT', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM6/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_MINT', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step2 == 5 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_VIOLET', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM7/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_VIOLET', self, argObj, quest_ssn)
                        end
                    end
                    quest_ssn.Step2 = 0
                    SaveSessionObject(self, quest_ssn)
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WHITETREES23_3_SQ06_ALREADY"), 5)
            end
        elseif argObj.Dialog == 'WHITETREES233_SQ_06_3' then
            if quest_ssn.Step3 ~= 0 then
                LookAt(self, argObj)
                local result1 = DOTIMEACTION_R(self, ScpArgMsg("WHITETREES23_3_SQ06_USE"), 'ABSORB', 1)
                if result1 == 1 then
                    if quest_ssn.Step3 == 1 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_RED', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM3/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_RED', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step3 == 2 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_BLUE', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM4/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_BLUE', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step3 == 3 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_YELLOW', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM5/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_YELLOW', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step3 == 4 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_MINT', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM6/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_MINT', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step3 == 5 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_VIOLET', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM7/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_VIOLET', self, argObj, quest_ssn)
                        end
                    end
                    quest_ssn.Step3 = 0
                    SaveSessionObject(self, quest_ssn)
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WHITETREES23_3_SQ06_ALREADY"), 5)
            end
        elseif argObj.Dialog == 'WHITETREES233_SQ_06_4' then
            if quest_ssn.Step4 ~= 0 then
                LookAt(self, argObj)
                local result1 = DOTIMEACTION_R(self, ScpArgMsg("WHITETREES23_3_SQ06_USE"), 'ABSORB', 1)
                if result1 == 1 then
                    if quest_ssn.Step4 == 1 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_RED', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM3/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_RED', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step4 == 2 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_BLUE', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM4/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_BLUE', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step4 == 3 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_YELLOW', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM5/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_YELLOW', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step4 == 4 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_MINT', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM6/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_MINT', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step4 == 5 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_VIOLET', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM7/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_VIOLET', self, argObj, quest_ssn)
                        end
                    end
                    quest_ssn.Step4 = 0
                    SaveSessionObject(self, quest_ssn)
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WHITETREES23_3_SQ06_ALREADY"), 5)
            end
        elseif argObj.Dialog == 'WHITETREES233_SQ_06_5' then
            if quest_ssn.Step5 ~= 0 then
                LookAt(self, argObj)
                local result1 = DOTIMEACTION_R(self, ScpArgMsg("WHITETREES23_3_SQ06_USE"), 'ABSORB', 1)
                if result1 == 1 then
                    if quest_ssn.Step5 == 1 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_RED', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM3/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_RED', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step5 == 2 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_BLUE', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM4/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_BLUE', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step5 == 3 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_YELLOW', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM5/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_YELLOW', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step5 == 4 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_MINT', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM6/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_MINT', self, argObj, quest_ssn)
                        end
                    elseif quest_ssn.Step5 == 5 then
                        if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 - 1 then
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_VIOLET', self, argObj, quest_ssn)
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'WHITETREES23_3_SQ06_ITEM7/1', 'WHITETREES23_3_SQ06_ITEM2/1', 'WHITETREES23_3_SQ06')
                        else
                            RunScript('SCR_WHITETREES23_3_SQ06_ITEM2_VIOLET', self, argObj, quest_ssn)
                        end
                    end
                    quest_ssn.Step5 = 0
                    SaveSessionObject(self, quest_ssn)
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WHITETREES23_3_SQ06_ALREADY"), 5)
            end
        end
    end
end

function SCR_WHITETREES23_3_SQ06_ITEM2_RED(self, argObj, quest_ssn)
    PlayEffectLocal(argObj, self, 'F_lineup022_red', 5, nil, 'BOT')
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WHITETREES23_3_SQ06_RED"), 5)
    quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
    SaveSessionObject(self, quest_ssn)
end

function SCR_WHITETREES23_3_SQ06_ITEM2_BLUE(self, argObj, quest_ssn)
    PlayEffectLocal(argObj, self, 'F_lineup022_blue', 5, nil, 'BOT')
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WHITETREES23_3_SQ06_BLUE"), 5)
    quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
    SaveSessionObject(self, quest_ssn)
end

function SCR_WHITETREES23_3_SQ06_ITEM2_YELLOW(self, argObj, quest_ssn)
    PlayEffectLocal(argObj, self, 'F_lineup022_yellow', 5, nil, 'BOT')
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WHITETREES23_3_SQ06_YELLOW"), 5)
    quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
    SaveSessionObject(self, quest_ssn)
end

function SCR_WHITETREES23_3_SQ06_ITEM2_MINT(self, argObj, quest_ssn)
    PlayEffectLocal(argObj, self, 'F_lineup022_mint', 5, nil, 'BOT')
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WHITETREES23_3_SQ06_MINT"), 5)
    quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
    SaveSessionObject(self, quest_ssn)
end

function SCR_WHITETREES23_3_SQ06_ITEM2_VIOLET(self, argObj, quest_ssn)
    PlayEffectLocal(argObj, self, 'F_lineup022_violet', 5, nil, 'BOT')
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WHITETREES23_3_SQ06_VIOLET"), 5)
    quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
    SaveSessionObject(self, quest_ssn)
end

--WHITETREES23_3_SQ07_ITEM
function SCR_USE_WHITETREES23_3_SQ07_ITEM(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, 'WHITETREES233_SQ_07_Memo', 1)
end

--JOB_3_NECROMANCER_ITEM
function SCR_USE_JOB_3_NECROMANCER_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local anim_result = DOTIMEACTION_R(self, ScpArgMsg("JOB_NECROMANCER7_1_MSG4"), 'ABSORB', 1)
    if anim_result == 1 then
        local ran = IMCRandom(1, 10)
        if ran < 8 then
            local skill = GetNormalSkill(self);
            ForceDamage(self, skill, argObj, self, 0, 'MOTION', 'BLOW', 'I_force042_violet#Bip01 R Hand', 1, 'arrow_cast', 'I_force071_light_green', 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_NECROMANCER7_1_MSG5"), 5)
            AddBuff(self, argObj, "JOB_NECROMANCER7_1_ITEM_BUFF1", 1, 0, 5000, 1)
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_NECROMANCER7_1_MSG6"), 5)
        end
    end
end

--JOB_2_WAROLCK_ITEM1
function SCR_USE_JOB_2_WAROLCK_ITEM1(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local anim_result = DOTIMEACTION_R(self, ScpArgMsg("JOB_WARLOCK_8_1_MSG1"), 'ABSORB', 1)
    if anim_result == 1 then
        local ran = IMCRandom(1, 10)
        if IsBuffApplied(argObj, "JOB_WARLOCK_8_1_ITEM_BUFF1") == "NO" then
            if ran <= 8 then
                local skill = GetNormalSkill(argObj);
                ForceDamage(argObj, skill, self, argObj, 0, 'MOTION', 'BLOW', 'I_force042_violet', 1, 'arrow_cast', 'I_force071_light_green', 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
                SCR_PARTY_QUESTPROP_ADD(self, "SSN_JOB_WARLOCK_8_1", 'QuestInfoValue1', 1, nil)
                SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("JOB_WARLOCK_8_1_MSG2"), 5)
                AddBuff(self, argObj, "JOB_WARLOCK_8_1_ITEM_BUFF1", 1, 0, 15000, 1)
                PlayEffect(argObj, "F_burstup025_dark", 0.7, 0, "BOT")
            else
                SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_WARLOCK_8_1_MSG4"), 5)
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_WARLOCK_8_1_MSG3"), 5)
        end
    end
end

--JOB_2_FEATHERFOOT_ITEM1
function SCR_USE_JOB_2_FEATHERFOOT_ITEM1(self, argObj, argstring, arg1, arg2)
    local anim_result = DOTIMEACTION_R(self, ScpArgMsg("JOB_WARLOCK_8_1_MSG1"), 'MAKING', 1)
    if anim_result == 1 then
        if IsBuffApplied(self, "JOB_FEATHERFOOT_8_DEBUFF1") == "YES" then
            RemoveBuff(self, "JOB_FEATHERFOOT_8_DEBUFF1")
            --PlayEffect(self, "F_circle016", 0.5, 0, "BOT")
            PlayEffect(self, "F_ground038", 0.5, 0, "BOT")
            SCR_PARTY_QUESTPROP_ADD(self, "SSN_JOB_FEATHERFOOT_8_1", 'QuestInfoValue1', 1, nil)
            AddBuff(self, self, "JOB_FEATHERFOOT_8_BUFF1", 1, 0, 5000, 1)
            SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("JOB_FEATHERFOOT_8_1_MSG5"), 5)
        end
    end
end

--JOB_2_KABBALIST_ITEM1
function SCR_USE_JOB_2_KABBALIST_ITEM1(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'JOB_KABBALIST_8_1')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_castle_20_2' then
            if GetLayer(self) == 0 then
                local zoneID = GetZoneInstID(self)
                local zon_Obj = GetLayerObject(zoneID, 0);
                if zon_Obj ~= nil then
                    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1, 'JOB_2_KABBALIST_ITEM1')
                    local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_2_KABBALIST_ITEM1_MSG01"), 'ABSORB', animTime, 'SSN_HATE_AROUND')
                    DOTIMEACTION_R_AFTER(self, result, animTime, before_time, 'JOB_2_KABBALIST_ITEM1')
                    if result == 1 then
                        local list, cnt = GetLayerAliveMonList(zoneID, 0);
                        local mon_list = {}
                        for i = 1 , cnt do
                            if list[i].Faction == 'Monster' then
                                if SCR_QUEST_MONRANK_CHECK(list[i], 'Normal', 'Special', 'Material') == 'YES' then
                                    mon_list[#mon_list+1] = list[i];
                                end
                            end
                		end
                		
                		local rnd = IMCRandom(1, #mon_list)
                		local mon_num = mon_list[rnd].Lv;
                        local hidden_num = {};
                        local quest_num = 1;
                        for i = 1, 10 do
                            hidden_num[#hidden_num + 1] = mon_num % 10;
                            if mon_num >= 10 then
                                mon_num = math.floor(mon_num / 10);
                            else
                                for j = 1, #hidden_num do
                                    quest_num = quest_num * hidden_num[j]
                                end
                                
                                local sObj = GetSessionObject(self, 'SSN_JOB_KABBALIST_8_1')
                                if sObj ~= nil then
                                    sObj.Step1 = quest_num;
                                    ShowBalloonText(self, quest_num, 10)
                                    PlayTextEffect(self, "I_SYS_Text_Effect_Skill", quest_num)
                                    PlayEffectLocal(self, self, 'I_spread_out001_light_violet2', 1.0, nil, 'MID')
                                    SaveSessionObject(self, sObj)
                                    return
                                end
                            end
                        end
                		
                		SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_KABBALIST_7_1_MSG2"), 5);
                    end
    	        end
            end
        end
    end
end

--JOB_1_ENCHEANTER_ITEM1
function SCR_USE_JOB_1_ENCHEANTER_ITEM1(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local anim_result = DOTIMEACTION_R(self, ScpArgMsg("JOB_ENCHEANTER_8_1_MSG1"), 'ABSORB', 1)
    if anim_result == 1 then
        if IsBuffApplied(argObj, "JOB_ENCHANTER_8_1_BUFF") == "NO" then
            local ran = IMCRandom(1, 50)
            local sObj = GetSessionObject(self, "SSN_JOB_ENCHANTER_8_1")
            if sObj ~= nil then
                local skill = GetNormalSkill(argObj);
                ForceDamage(argObj, skill, self, argObj, 0, 'MOTION', 'BLOW', 'I_spread_out001_light', 1, 'arrow_cast', 'F_light077_yellow', 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
                sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + ran;
                SaveSessionObject(self, sObj)
            end
            AddBuff(self, argObj, "JOB_ENCHANTER_8_1_BUFF", 1, 0, 8000, 1)
            --print(IsBuffApplied(argObj, "JOB_ENCHANTER_8_1_BUFF"))
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_ENCHEANTER_8_1_MSG2"), 5);
        else
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_ENCHEANTER_8_1_MSG3"), 5);
        end
    end
end

--SCR_USE_JOB_1_INQUGITOR_ITEM1
function SCR_USE_JOB_1_INQUGITOR_ITEM1(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, argstring);
    local sObj = GetSessionObject(self, "SSN_JOB_INQUGITOR_8_1")
    if sObj ~= nil then
        sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
        SaveSessionObject(self, sObj)
    end
end


--SCR_USE_JOB_1_INQUGITOR_ITEM2
function SCR_USE_JOB_1_INQUGITOR_ITEM2(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "SSN_JOB_INQUGITOR_8_1")
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= sObj.QuestInfoMaxCount1 then
            LookAt(self, argObj)
            local anim_result = DOTIMEACTION_R(self, ScpArgMsg("JOB_INQUGITOR_8_1_MSG1"), 'ABSORB', 1)
            if anim_result == 1 then
--                local ran = IMCRandom(1, 10)
--                if ran < 8 then
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_INQUGITOR_8_1_MSG2"), 5);
                    if IsBuffApplied(argObj, "JOB_INQUGITOR_8_1_BUFF1") == "NO" then
                        AddBuff(self, argObj, "JOB_INQUGITOR_8_1_BUFF1", 1, 0, 15000, 1)
                    end
--                else
--                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_INQUGITOR_8_1_MSG7"), 5);
--                end
            end
        else
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_INQUGITOR_8_1_MSG3"), 5);
        end
    end
end

--SCR_USE_JOB_1_DAOSHI_ITEM1
function SCR_USE_JOB_1_DAOSHI_ITEM1(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    
    local anim_result = DOTIMEACTION_R(self, ScpArgMsg("JOB_DAOSHI_8_1_MSG1"), 'ABSORB', 1)
    if anim_result == 1 then
        
        local ran = IMCRandom(1, 12)
        local skill = GetNormalSkill(self);
        
        if ran >= 9 then
            ForceDamage(self, skill, argObj, self, 0, 'MOTION', 'BLOW', 'I_force042_violet#Bip01 R Hand', 1, 'arrow_cast', nil, 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
            AddBuff(self, argObj, "JOB_1_DAOSHI_BUFF1", 1, 0, 5000, 1)
            --PlayEffectLocal(argObj, self, 'I_spread_out001_light_violet2', 1.0, nil, 'MID')
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_DAOSHI_8_1_MSG2"), 5);
        elseif ran >= 5 then
            ForceDamage(self, skill, argObj, self, 0, 'MOTION', 'BLOW', 'I_force042_violet#Bip01 R Hand', 1, 'arrow_cast', nil, 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
            AddBuff(self, argObj, "JOB_1_DAOSHI_BUFF2", 1, 0, 5000, 1)
            --PlayEffectLocal(argObj, self, 'I_spread_out001_light_violet2', 1.0, nil, 'MID')
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_DAOSHI_8_1_MSG3"), 5);
        elseif ran >= 1 then
            ForceDamage(self, skill, argObj, self, 0, 'MOTION', 'BLOW', 'I_force042_violet#Bip01 R Hand', 1, 'arrow_cast', nil, 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
            AddBuff(self, argObj, "JOB_1_DAOSHI_BUFF3", 1, 0, 5000, 1)
            --PlayEffectLocal(argObj, self, 'I_spread_out001_light_violet2', 1.0, nil, 'MID')
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_DAOSHI_8_1_MSG4"), 5);
        end
        
        local sObj = GetSessionObject(self, "SSN_JOB_DAOSHI_8_1")
        if sObj ~= nil then
            sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
            SaveSessionObject(self, sObj)
        end
        
    end
end

--SCR_USE_JOB_3_DRUID_ITEM
function SCR_USE_JOB_3_DRUID_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    
    local anim_result = DOTIMEACTION_R(self, ScpArgMsg("JOB_3_DRUID_MSG1"), 'ABSORB', 1, 'SSN_HATE_AROUND')
    if anim_result == 1 then
        RemoveBuff(argObj, "JOB_3_DRUID_BUFF")
        PlayEffectLocal(argObj, self, "F_light048_blue", 1, nil, "BOT")
        local sObj = GetSessionObject(self, "SSN_JOB_DRUID_7_1")
        if sObj ~= nil then
            sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
            SaveSessionObject(self, sObj)
        end
        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("JOB_3_DRUID_MSG2"), 5);
        PlayEffectLocal(argObj, self, "F_light089_mint", 0.9, nil, "BOT")
    end
end
--JOB_DRAGOON_8_1_ITEM1
function SCR_USE_JOB_DRAGOON_8_1_ITEM1(self, argObj, argstring, arg1, arg2)
    local questCheck1 = SCR_QUEST_CHECK(self, 'JOB_DRAGOON_8_1')
    local questCheck2 = SCR_QUEST_CHECK(self, 'MASTER_DRAGOON1')
    if questCheck1 == 'PROGRESS' or questCheck2 == "PROGRESS" then
        if GetZoneName(self) == 'f_tableland_11_1' then
            if GetLayer(self) == 0 then
                local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_DRAGOON_8_1_ROD1"), 'ABSORB', 1)
                if result  == 1 then
                    local list, cnt = SelectObject(self, 450, 'ALL')
                    if cnt >= 1 then
                        for i = 1, cnt do
                            if list[i].ClassName == 'HiddenTrigger6' then
                                if list[i].Dialog == 'JOB_DRAGOON_8_1_KEY' then
                                    local itemchk = GetDistance(self, list[i])
                                    if itemchk > 300 then
                                        ShowBalloonText(self, 'JOB_DRAGOON_8_1_DLG2', 5)
                                        return
                                    elseif itemchk > 150 then
                                        ShowBalloonText(self, 'JOB_DRAGOON_8_1_DLG3', 5)
                                        return
                                    elseif itemchk <= 150 then
                                        local x, y, z = GetPos(list[i])
                                        SCR_JOB_DRAGOON_8_1_RUN(self, x, y, z)
                                        Kill(list[i])
                                        return
                                    end
                                end
                            end
                        end
                    end
                    SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg("JOB_DRAGOON_8_1_ROD3"), 3)
                end
            end
        end
    end
end

--WHITETREES561_SUBQ4_ITEM2
function SCR_USE_WHITETREES561_SUBQ4_ITEM2(self, argObj, argstring, arg1, arg2)
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("WHITETREES561_SUBQ4_MSG1"), 'CRAFT', 3, 'SSN_HATE_AROUND')
    if result1  == 1 then
        local item_takecnt
        local list, cnt = GetPartyMemberList(self, PARTY_NORMAL, range);
        SCR_SCRIPT_PARTY("WHITETREES561_ITEM_TAKE", 1, self)
        SCR_PARTY_QUESTPROP_ADD(self, "SSN_WHITETREES56_1_SQ4", nil, nil, nil, "WHITETREES561_SUBQ4_ITEM3/1")
        SendAddOnMsg(self, 'NOTICE_Dm_GetItem', ScpArgMsg("WHITETREES561_SUBQ4_MSG2"), 3)
    end
end

function WHITETREES561_ITEM_TAKE(pc)
    local item = GetInvItemCount(pc, "WHITETREES561_SUBQ4_ITEM1")
    local item_takecnt
    if item >= 1 then
        item_takecnt = 1
    elseif item < 1 then
        item_takecnt = 0
    end
    if item_takecnt == 1 then
        RunScript('GIVE_TAKE_ITEM_TX',pc, nil, "WHITETREES561_SUBQ4_ITEM1/"..item_takecnt, "QUEST")
    end
end

--WHITETREES561_SUBQ7_ITEM2
function SCR_USE_WHITETREES561_SUBQ7_ITEM2(self, argObj, argstring, arg1, arg2)
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("WHITETREES561_SUBQ7_MSG1"), 'EVENT_HOLY', 1)
    if result1  == 1 then
        local zoneID = GetZoneInstID(self)
        local pos_list = SCR_CELLGENPOS_LIST(self, 'Front2', 0)
        if #pos_list > 0 then
            for i = 1, #pos_list do
                if IsValidPos(zoneID, pos_list[i][1], pos_list[i][2], pos_list[i][3]) == 'YES' then
                    local pos = IsValidPos(zoneID, pos_list[i][1], pos_list[i][2], pos_list[i][3])
                    local mon = CREATE_NPC_EX(self, "siauliai_grass_2", pos_list[i][1], pos_list[i][2], pos_list[i][3], 0, "Neutral", "UnvisibleName", self.Lv, WHITETREES561_SUBQ7_OBJ_SET)
                    SetOwner(mon, self, 1)
                    AttachEffect(mon, 'I_spread_out001_light', 2.0, 'TOP')
                    SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("WHITETREES561_SUBQ7_MSG2"), 3)
                    SetLifeTime(mon, 3000)
                end
            end
        end
        Kill(argObj)
    end
end

function WHITETREES561_SUBQ7_OBJ_SET(mon)
    mon.Dialog = "WHITETREES561_SUBQ7_OBJ"
    mon.MaxDialog = 1
end

--DCAPITAL103_SQ03_ITEM1
function SCR_USE_DCAPITAL103_SQ03_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'DCAPITAL103_SQ03')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        local result = DOTIMEACTION_R(self, ScpArgMsg("DCAPITAL103_SQ03_CRACK"), 'CUTVINE_LOOP', 2, 'SSN_HATE_AROUND')
        if result == 1 then
            if IsDead(argObj) ~= 1 then
--                local i = IMCRandom(1, 5)
--                if i <= 4 then
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DCAPITAL103_SQ03_JUICE"), 3)
                    SCR_PARTY_QUESTPROP_ADD(self, nil, nil, nil, nil, 'DCAPITAL103_SQ03_ITEM2/1', nil, nil, nil, nil, nil, nil, 'DCAPITAL103_SQ03')
                    Kill(argObj)
--                else
--                    SendAddOnMsg(self, "NOTICE_Dm_ResBuff", ScpArgMsg("DCAPITAL103_SQ03_FAIL"), 3)
--                    Kill(argObj)
--                end
            else
            end
        end
    end
end

--DCAPITAL103_SQ09_ITEM1
function SCR_USE_DCAPITAL103_SQ09_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'DCAPITAL103_SQ09')
    if result == 'PROGRESS' then
        local result1 = DOTIMEACTION_R(self, ScpArgMsg("DCAPITAL103_SQ09_USE"), 'BUTTON', 1)
        if result1 == 1 then
            local list, cnt = SelectObjectByClassName(self, 50, 'HiddenTrigger6')
            if cnt ~= 0 then
                for i = 1, cnt do
                    if list[i].Dialog == 'DCAPITAL103_SQ_09' then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('DCAPITAL103_SQ09_FIND'), 5)
                        local x, y, z = GetPos(list[i])
                        Kill(list[i])
                        local mon = CREATE_MONSTER_EX(self, 'Hidden_Mon_01', x, y, z, 0, 'Neutral', 0, DCAPITAL103_SQ09_RUN)
                        local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
                        local p
                        if P_cnt >= 1 then
                            for p = 1, P_cnt do
                            	AddVisiblePC(mon, P_list[p], 1)
                            end
                        end
                    	SetLifeTime(mon, 60)
                        AttachEffect(mon, 'F_light054', 5, 'BOT')
                    end
                end
            else
                SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('DCAPITAL103_SQ09_FAIL'), 2)
            end
        end
    end
end




-- Key_Quest_Select Lv1
function SCR_USE_KQ_SELECT_LV_1(self, argObj, argstring, arg1, arg2)	
	local map_check = SCR_KEY_QUEST_MAP_CHECK(self)
    if map_check == 0 then
        return
    end
    
    local pre_check = SCR_KEY_QUEST_PRECHECK_MEMBER(self, 1)
    if pre_check == 0 then
        return
    end
    
    local select_check = SCR_KEY_QUEST_PRECHECK_MEMBER(self, 1)
    if select_check == 0 then
        return
    else
		RunScript('GIVE_TAKE_ITEM_OBJECT_TX', self, nil, 'KQ_token_hethran_1/1', 'KeyQuest')
        local quest_classname = SCR_KEY_QUEST_USE_SELECT(self, 1)
		RunScript("SCR_KEY_QUEST_START_PARTY", self, quest_classname)
        
    end
end

-- Key_Quest_Select Lv2
function SCR_USE_KQ_SELECT_LV_2(self, argObj, argstring, arg1, arg2)
    local map_check = SCR_KEY_QUEST_MAP_CHECK(self)
    if map_check == 0 then
        return
    end
    
    local pre_check = SCR_KEY_QUEST_PRECHECK_MEMBER(self, 2)
    if pre_check == 0 then
        return
    end
    
    local select_check = SCR_KEY_QUEST_PRECHECK_MEMBER(self, 2)
    if select_check == 0 then
        return
    else
        RunScript('GIVE_TAKE_ITEM_OBJECT_TX', self, nil, 'KQ_token_hethran_2/1', 'KeyQuest')
        local quest_classname = SCR_KEY_QUEST_USE_SELECT(self, 2)
        RunScript("SCR_KEY_QUEST_START_PARTY", self, quest_classname)        
    end
end
--
---- Key_Quest_Select Lv3
--function SCR_USE_KQ_SELECT_LV_3(self, argObj, argstring, arg1, arg2)
--    local map_check = SCR_KEY_QUEST_MAP_CHECK(self)
--    if map_check == 0 then
--        return
--    end
--    
--    local pre_check = SCR_KEY_QUEST_PRECHECK_MEMBER(self, 3)
--    if pre_check == 0 then
--        return
--    end
--    
--    local select_check = SCR_KEY_QUEST_SELECT_DLG(self, 3)
--    if select_check == 0 then
--        return
--    else
--        local quest_classname = SCR_KEY_QUEST_USE_SELECT(self, 3)
--        SCR_KEY_QUEST_START_PARTY(self, quest_classname)
--        RunScript('GIVE_TAKE_ITEM_TX', self, nil, 'KQ_token_hethran_3/1', 'KeyQuest')
--    end
--end


--HT
function SCR_USE_HT_F_3CMLAKE_84_SQ_ITEM1(self, argObj, argstring, arg1, arg2)
    local pc_buff = GetBuffByName(self, "HT_3CMLAKE_84_BUCKET2_DEBUFF")
    if pc_buff ~= nil then
        RemoveBuff(self, "HT_3CMLAKE_84_BUCKET2_DEBUFF")
        
    else
        ShowBalloonText(self, "HT_3CMLAKE_84_BUCKET2_DEBUFF_REMOVE_BLM05", 5) 
    end
end

--SCR_USE_UNDER67_HIDDENQ1_ITEM1
function SCR_USE_UNDER67_HIDDENQ1_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'UNDERFORTRESS67_HQ1')
    if result == "PROGRESS" then
        if GetLayer(self) == 0  then
            local sObj = GetSessionObject(self, "SSN_UNDERFORTRESS67_HQ1")
    	    if sObj ~= nil then
        	    local list, cnt = SelectObject(self, 160, 'ALL', 1)
                for i = 1, cnt do
                    if list[i].ClassName == 'Hiddennpc_move' then
                        if list[i].Faction == "Neutral" then
                            if GetZoneName(self) == 'd_underfortress_65' then
                                if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                                    local result1 = DOTIMEACTION_R(self, ScpArgMsg("UNDER67_HIDDENQ1_MSG1"), 'WRITE', 1)
                                    if result1 == 1 then
                                        sObj.QuestInfoValue1 = sObj.QuestInfoMaxCount1
                                        SaveSessionObject(self, sObj)
                                        ShowBookItem(self, 'UNDER67_HIDDENQ1_BOOK1', 1)
                                        RunZombieScript("GIVE_ITEM_TX", self, "UNDER67_HIDDENQ1_ITEM2", 1, "QUEST")
                                        return
                                    end
                                else
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("UNDER67_HIDDENQ1_MSG2"), 5)
                                end
                            elseif GetZoneName(self) == 'd_underfortress_66' then
                                if sObj.QuestInfoValue2 < sObj.QuestInfoMaxCount2 then
                                    local result1 = DOTIMEACTION_R(self, ScpArgMsg("UNDER67_HIDDENQ1_MSG1"), 'WRITE', 1)
                                    if result1 == 1 then
                                        sObj.QuestInfoValue2 = sObj.QuestInfoMaxCount2
                                        SaveSessionObject(self, sObj)
                                        ShowBookItem(self, 'UNDER67_HIDDENQ1_BOOK2', 1)
                                        RunZombieScript("GIVE_ITEM_TX", self, "UNDER67_HIDDENQ1_ITEM3", 1, "QUEST")
                                        return
                                    end
                                else
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("UNDER67_HIDDENQ1_MSG2"), 5)
                                end
                            elseif GetZoneName(self) == 'd_underfortress_67' then
                                if sObj.QuestInfoValue3 < sObj.QuestInfoMaxCount3 then
                                    local result1 = DOTIMEACTION_R(self, ScpArgMsg("UNDER67_HIDDENQ1_MSG1"), 'WRITE', 1)
                                    if result1 == 1 then
                                        sObj.QuestInfoValue3 = sObj.QuestInfoMaxCount3
                                        SaveSessionObject(self, sObj)
                                        ShowBookItem(self, 'UNDER67_HIDDENQ1_BOOK3', 1)
                                        RunZombieScript("GIVE_ITEM_TX", self, "UNDER67_HIDDENQ1_ITEM4", 1, "QUEST")
                                        return
                                    end
                                else
                                    SendAddOnMsg(self,"NOTICE_Dm_scroll",  ScpArgMsg("UNDER67_HIDDENQ1_MSG2"), 5)
                                end
                            elseif GetZoneName(self) == 'd_underfortress_68' then
                                if sObj.QuestInfoValue4 < sObj.QuestInfoMaxCount4 then
                                    local result1 = DOTIMEACTION_R(self, ScpArgMsg("UNDER67_HIDDENQ1_MSG1"), 'WRITE', 1)
                                    if result1 == 1 then
                                        sObj.QuestInfoValue4 = sObj.QuestInfoMaxCount4
                                        SaveSessionObject(self, sObj)
                                        ShowBookItem(self, 'UNDER67_HIDDENQ1_BOOK4', 1)
                                        RunZombieScript("GIVE_ITEM_TX", self, "UNDER67_HIDDENQ1_ITEM5", 1, "QUEST")
                                        return
                                    end
                                else
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("UNDER67_HIDDENQ1_MSG2"), 5)
                                end
                            elseif GetZoneName(self) == 'd_underfortress_69' then
                                if sObj.QuestInfoValue5 < sObj.QuestInfoMaxCount5 then
                                    local result1 = DOTIMEACTION_R(self, ScpArgMsg("UNDER67_HIDDENQ1_MSG1"), 'WRITE', 1)
                                    if result1 == 1 then
                                        sObj.QuestInfoValue5 = sObj.QuestInfoMaxCount5
                                        SaveSessionObject(self, sObj)
                                        ShowBookItem(self, 'UNDER67_HIDDENQ1_BOOK5', 1)
                                        RunZombieScript("GIVE_ITEM_TX", self, "UNDER67_HIDDENQ1_ITEM6", 1, "QUEST")
                                        return
                                    end
                                else
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("UNDER67_HIDDENQ1_MSG2"), 5)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

--SCR_USE_SIAULIAI16_HIDDENQ1_ITEM2
function SCR_USE_SIAULIAI16_HIDDENQ1_ITEM2(self, argObj, argstring, arg1, arg2)
    local quest_result = SCR_QUEST_CHECK(self, 'SIAULIAI16_HQ2')
    if quest_result == "PROGRESS" then
        local result = DOTIMEACTION_R(self, ScpArgMsg("SIAULIAI16_HIDDENQ1_MSG3"), 'CRAFT', 4)
        local Item1 = GetInvItemCount(self, 'SIAULIAI16_HIDDENQ1_ITEM3')
        if result == 1 then
            SendAddOnMsg(self, 'NOTICE_Dm_GetItem', ScpArgMsg('SIAULIAI16_HIDDENQ1_MSG4'), 3);
            RunZombieScript("GIVE_TAKE_ITEM_TX", self, "SIAULIAI16_HIDDENQ1_ITEM4/1", "SIAULIAI16_HIDDENQ1_ITEM3/"..Item1, "QUEST")
--            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_SIAULIAI16_HQ2', 'QuestInfoValue1', 1, nil, "SIAULIAI16_HIDDENQ1_ITEM4/1", "SIAULIAI16_HIDDENQ1_ITEM3/13")
        end
    end
end

--SCR_USE_ORSHA_HIDDENQ2_ITEM1
function SCR_USE_ORSHA_HIDDENQ2_ITEM1(self, argObj, argstring, arg1, arg2)
    local Item1 = GetInvItemCount(self, 'ORSHA_HIDDENQ2_ITEM2')
    local Item2 = GetInvItemCount(self, 'ORSHA_HIDDENQ2_ITEM3')
    local result = DOTIMEACTION_R(self, ScpArgMsg("ORSHA_HIDDENQ2_MSG1"), 'MAKING', 3)
    local sObj = GetSessionObject(self, "SSN_ORSHA_HQ2")
    if result == 1 then
        SendAddOnMsg(self, 'NOTICE_Dm_GetItem', ScpArgMsg('ORSHA_HIDDENQ2_MSG2'), 3);
        RunZombieScript("GIVE_TAKE_ITEM_TX", self, nil, "ORSHA_HIDDENQ2_ITEM2/"..Item1.."/ORSHA_HIDDENQ2_ITEM3/"..Item2, "QUEST")
    	if sObj ~= nil then
    	    if sObj.QuestInfoValue3 < sObj.QuestInfoMaxCount3 then
    	        sObj.QuestInfoValue3 = sObj.QuestInfoMaxCount3
                SaveSessionObject(self, sObj)
            end
    	end 
    end
end

--SCR_ORSHA_HIDDENQ3_ITEM1
function SCR_ORSHA_HIDDENQ3_ITEM1(self, argObj, strArg, num1, num2, itemType)
	local pcPetList = GetSummonedPetList(self)
	if #pcPetList == 0 then
		return 0;
	end

	local itemCls = GetClassByType("Item", itemType );
	if itemCls == nil then
		return 0;
	end
	
	local pcPet = nil;
	for i=1, #pcPetList do
		local petObj = pcPetList[i];
		local petCls = GetClassByStrProp("Companion", "ClassName", petObj.ClassName)
		local foodGroup = 0;
		if petCls ~= nil and petCls.FoodGroup ~= "None" then
			foodGroup = tonumber(petCls.FoodGroup);
		end

		if petCls ~= nil then
			pcPet = petObj;
		end
	end	

	if nil == pcPet then
		return 0;
	end

	SCR_PLAY_FOOD_ANIM(self, pcPet, nil, itemCls.StringArg, num1)
	local sObj = GetSessionObject(self, "SSN_ORSHA_HQ3")
	if sObj ~= nil then
	    if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
	        sObj.QuestInfoValue1 = sObj.QuestInfoMaxCount1
            SaveSessionObject(self, sObj)
            RunZombieScript("GIVE_TAKE_ITEM_TX", self, nil, "ORSHA_HIDDENQ3_ITEM1/1", "QUEST")
        end
	end 
end

function SCR_USE_TABLE281_HIDDENQ1_ITEM5(self, argObj, argstring, arg1, arg2)
    local result = DOTIMEACTION_R(self, ScpArgMsg("TABLELAND281_HIDDENQ1_MSG1"), 'SCROLL', 3)
    if result == 1 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'sheepdog_black',  x, y, z, -55, 'Neutral', 100, TABLELAND281_HIDDENQ1_DOG_AI);
        SetOwner(mon, self)
        PlayEffect(mon, "F_smoke137_white", 0.5, 1, "BOT")
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("TABLELAND281_HIDDENQ1_MSG6"), 5)
    end
end

function TABLELAND281_HIDDENQ1_DOG_AI(mon)
    mon.Tactics = 'None'
    mon.BTree = 'BasicMonster'
    mon.SimpleAI = 'TABLELAND281_HIDDENQ1_DOG_AI'
    mon.Name = ScpArgMsg("TABLELAND281_HIDDENQ1_MSG7")
    mon.WlkMSPD = 60
end

function SCR_UES_PRISON622_HIDDEN_ITEM_BOOK2(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "SSN_PRISON62_2_HQ1_UNLOCK")
    local passward1 = sObj.Goal1
    ShowBookItem(self, "PRISON622_HIDDEN_OBJ1_"..passward1)
end

function SCR_UES_PRISON622_HIDDEN_ITEM_BOOK3(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "SSN_PRISON62_2_HQ1_UNLOCK")
    local passward2 = sObj.Goal2
    ShowBookItem(self, "PRISON622_HIDDEN_OBJ2_"..passward2);
end

function SCR_UES_PRISON622_HIDDEN_ITEM_BOOK4(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "SSN_PRISON62_2_HQ1_UNLOCK")
    local passward3 = sObj.Goal3
    ShowBookItem(self, "PRISON622_HIDDEN_OBJ3_"..passward3);
end

function SCR_UES_PRISON622_HIDDEN_ITEM_BOOK5(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "SSN_PRISON62_2_HQ1_UNLOCK")
    local passward4 = sObj.Goal4
    ShowBookItem(self, "PRISON622_HIDDEN_OBJ4_"..passward4);
end

--PILGRIMROAD55_SQ12_ITEM
function SCR_USE_PILGRIMROAD55_SQ12_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'PILGRIMROAD55_SQ12')
    if result == 'PROGRESS' then
        if IsDead(argObj) == 0 then
            LookAt(self, argObj)
            local result = DOTIMEACTION_R(self, ScpArgMsg("PILGRIMROAD55_SQ12_MSG1"), 'ABSORB', 1, 'SSN_HATE_AROUND')
            if result == 1 then
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIMROAD55_SQ12_MSG3"), 3)
                PlayEffect(argObj, "I_smoke058_blue", 3, "BOT")
                PlayEffect(argObj, "F_light076_spread_in_blue", 0.7, "BOT")
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_PILGRIMROAD55_SQ12', 'QuestInfoValue1', 1)
                SetCurrentFaction(argObj, 'Peaceful')
                ObjectColorBlend(argObj, 0, 0, 0, 0, 1, 3)
                sleep(3000)
                Kill(argObj)
            end
        end
    end
end

--LOWLV_GREEN_SQ_50_ITEM
function SCR_USE_LOWLV_GREEN_SQ_50_ITEM(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, 'LOWLV_GREEN_SQ_50_BOOK')
end

--LOWLV_BOASTER_SQ_20_ITEM
function SCR_USE_LOWLV_BOASTER_SQ_20_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'LOWLV_BOASTER_SQ_20')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_siauliai_16' then
            if GetLayer(self) == 0 then
                local x, y, z = GetPos(self)
                if SCR_POINT_DISTANCE(x,z,-389,-435) <= 50 then
                    SCR_LOWLV_BOASTER_SQ_20_RUN(self, 1)
                elseif SCR_POINT_DISTANCE(x,z,-396,201) <= 50 then
                    SCR_LOWLV_BOASTER_SQ_20_RUN(self, 2)
                elseif SCR_POINT_DISTANCE(x,z,654,1145) <= 50 then
                    SCR_LOWLV_BOASTER_SQ_20_RUN(self, 3)
                elseif SCR_POINT_DISTANCE(x,z,1434,125) <= 50 then
                    SCR_LOWLV_BOASTER_SQ_20_RUN(self, 4)
                elseif SCR_POINT_DISTANCE(x,z,979,-721) <= 50 then
                    SCR_LOWLV_BOASTER_SQ_20_RUN(self, 5)
                elseif SCR_POINT_DISTANCE(x,z,54,-945) <= 50 then
                    SCR_LOWLV_BOASTER_SQ_20_RUN(self, 6)
                else
                    return 0
                end
            end
        end
    end
end


--THORN39_1_SQ04_ITEM1
function SCR_USE_THORN39_1_SQ04_ITEM1(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    if IsDead(argObj) == 0 then
        local result = DOTIMEACTION_R(self, ScpArgMsg("THORN39_1_SQ04_MSG1"), 'ABSORB', 1, 'SSN_HATE_AROUND')
        if result == 1 then
            if argObj.NumArg1 ~= 0 then
                return;
            else 
                argObj.NumArg1 = 1;
                Kill(argObj)
                local x, y, z = GetPos(argObj)
                local mon = CREATE_MONSTER_EX(self, 'Pandroceum', x, y, z, GetDirectionByAngle(self), 'Neutral', nil, SCR_THORN39_1_SQ04_RUN);
            	SetLifeTime(mon, 15);
            	SetDialogRotate(mon, 0)
            	PlayAnim(mon, 'STD', 1)
                AddBuff(self, mon, 'THORN39_1_SQ04_STUN', 1, 0, 15000, 0)
            	PlayEffect(mon, 'F_explosion053_smoke', 1, 0, 'BOT')
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("THORN39_1_SQ04_MSG2"), 5)
            end
        end
    end
end

function SCR_THORN39_1_SQ04_RUN(mon)
    mon.Dialog = "THORN39_1_SQ04_MON"
	mon.MaxDialog = 1;
	mon.BTree = "None";
	mon.Tactics = "None";
	mon.SimpleAI = "None";
end

--THORN39_1_SQ06_ITEM1
function SCR_USE_THORN39_1_SQ06_ITEM(self, argObj, argstring, arg1, arg2)
    local list, cnt = SelectObject(self, 60, 'ALL')
    local i
    for i = 1, cnt do
        if cnt > 0 then
            if list[i].ClassName == 'noshadow_npc' then
            LookAt(self, list[i])
                local result = DOTIMEACTION_R(self, ScpArgMsg("THORN39_1_SQ06_MSG1"), 'SITABSORB', 3, 'SSN_HATE_AROUND')
                local sObj = GetSessionObject(self, 'SSN_THORN39_1_SQ06')
                if result == 1 then
                    local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
                    local p
                    if P_cnt >= 1 then
                        for p = 1, P_cnt do
                            local x, y, z = GetPos(self)
                            if sObj.Step1 < 5 then
                                if SCR_POINT_DISTANCE(x, z, 1298, -1288) < 50 then
                                    local mon1 = CREATE_MONSTER_EX(self, 'noshadow_npc', 1298, y, -1288, 0, 'Neutral', nil, SCR_THORN39_1_SQ06_RUN1);
                                    AddVisiblePC(mon1, P_list[p], 1);
                                    SetExArgObject(mon1, 'OWNER', self)
                                    AddScpObjectList(self, "THORN39_1_SQ06_OBJ", mon1)
                                    SetLifeTime(mon1, 40)
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN39_1_SQ06', 'Step1', nil, 1)
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN39_1_SQ06', 'Goal1', nil, 2)
                                elseif SCR_POINT_DISTANCE(x, z, 1443, -1432) < 50 then 
                                    local mon2 = CREATE_MONSTER_EX(self, 'noshadow_npc', 1443, y, -1432, 0, 'Neutral', nil, SCR_THORN39_1_SQ06_RUN2);
                                    AddVisiblePC(mon2, P_list[p], 1);
                                    SetExArgObject(mon2, 'OWNER', self)
                                    AddScpObjectList(self, "THORN39_1_SQ06_OBJ", mon2)
                                    SetLifeTime(mon2, 40)
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN39_1_SQ06', 'Step2', nil, 1)
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN39_1_SQ06', 'Goal2', nil, 2)
                                elseif SCR_POINT_DISTANCE(x, z, 1122, -1467) < 50 then 
                                    local mon3 = CREATE_MONSTER_EX(self, 'noshadow_npc', 1122, y, -1467, 0, 'Neutral', nil, SCR_THORN39_1_SQ06_RUN3);
                                    AddVisiblePC(mon3, P_list[p], 1);
                                    SetExArgObject(mon3, 'OWNER', self)
                                    AddScpObjectList(self, "THORN39_1_SQ06_OBJ", mon3)                                    
                                    SetLifeTime(mon3, 40)
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN39_1_SQ06', 'Step3', nil, 1)
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN39_1_SQ06', 'Goal3', nil, 2)
                                elseif SCR_POINT_DISTANCE(x, z, 1271, -1603) < 50 then 
                                    local mon4 = CREATE_MONSTER_EX(self, 'noshadow_npc', 1271, y, -1603, 0, 'Neutral', nil, SCR_THORN39_1_SQ06_RUN4);
                                    AddVisiblePC(mon4, P_list[p], 1);
                                    SetExArgObject(mon4, 'OWNER', self)
                                    AddScpObjectList(self, "THORN39_1_SQ06_OBJ", mon4)                                    
                                    SetLifeTime(mon4, 40)
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN39_1_SQ06', 'Step4', nil, 1)
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN39_1_SQ06', 'Goal4', nil, 2)
                                end            
                            	if sObj.Step1 ~= 1 or sObj.Step2 ~= 1 or sObj.Step3 ~= 1 or sObj.Step4 ~= 1 then
                                    SendAddOnMsg(P_list[p], "NOTICE_Dm_!", ScpArgMsg("THORN39_1_SQ06_MSG2"), 3)
                                elseif sObj.Step1 == 1 and sObj.Step2 == 1 and sObj.Step3 == 1 and sObj.Step4 == 1 then
                                    SendAddOnMsg(P_list[p], "NOTICE_Dm_scroll", ScpArgMsg("THORN39_1_SQ06_MSG3"), 5)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function SCR_THORN39_1_SQ06_RUN1(self)
    self.Name = ScpArgMsg("THORN39_1_SQ06_MSG4")
    self.Dialog = "THORN39_1_SQ06_OBJ"
	self.MaxDialog = 1;
	self.BTree = "None";
	self.Tactics = "None";
	self.SimpleAI = "THORN39_1_SQ06_RUN1";
end

function SCR_THORN39_1_SQ06_RUN2(self)
    self.Name = ScpArgMsg("THORN39_1_SQ06_MSG4")
    self.Dialog = "THORN39_1_SQ06_OBJ"
	self.MaxDialog = 1;
	self.BTree = "None";
	self.Tactics = "None";
	self.SimpleAI = "THORN39_1_SQ06_RUN2";
end

function SCR_THORN39_1_SQ06_RUN3(self)
    self.Name = ScpArgMsg("THORN39_1_SQ06_MSG4")
    self.Dialog = "THORN39_1_SQ06_OBJ"
	self.MaxDialog = 1;
	self.BTree = "None";
	self.Tactics = "None";
	self.SimpleAI = "THORN39_1_SQ06_RUN3";
end

function SCR_THORN39_1_SQ06_RUN4(self)
    self.Name = ScpArgMsg("THORN39_1_SQ06_MSG4")
    self.Dialog = "THORN39_1_SQ06_OBJ"
	self.MaxDialog = 1;
	self.BTree = "None";
	self.Tactics = "None";
	self.SimpleAI = "THORN39_1_SQ06_RUN4";
end

--THORN39_3_SQ07_ITEM
function SCR_USE_THORN39_3_SQ07_ITEM(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, 'SSN_THORN39_3_SQ07')
    local result = DOTIMEACTION_R(self, ScpArgMsg("THORN39_3_SQ07_MSG1"), 'BURY', 3, 'SSN_HATE_AROUND')
    if result == 1 then
        local x, y, z = GetPos(self)
        if SCR_POINT_DISTANCE(x, z, 759, -858) < 50 then
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN39_3_SQ07', 'QuestInfoValue1', 1, nil, nil, nil, "THORN39_3_SQ07_OBJ1", 0)                                        
            SCR_SCRIPT_PARTY("THORN39_3_SQ07_EFFECT1", 2, nil, self)

        elseif  SCR_POINT_DISTANCE(x, z, 1366, -1181) < 50 then
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN39_3_SQ07', 'QuestInfoValue2', 1, nil, nil, nil, "THORN39_3_SQ07_OBJ2", 0)      
            SCR_SCRIPT_PARTY("THORN39_3_SQ07_EFFECT2", 2, nil, self)
                  
        elseif  SCR_POINT_DISTANCE(x, z, 2062, -822) < 50 then
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_THORN39_3_SQ07', 'QuestInfoValue3', 1, nil, nil, nil, "THORN39_3_SQ07_OBJ3", 0)      
            SCR_SCRIPT_PARTY("THORN39_3_SQ07_EFFECT3", 2, nil, self)
        end
          SCR_THORN39_3_SQ07_MSG(self)
    end
end

function THORN39_3_SQ07_EFFECT1(mon, pc)
    local x, y, z = GetPos(pc)
    PlayEffectToGround(pc, "F_pose_magical_light", 759, y, -858, 3)
end

function THORN39_3_SQ07_EFFECT2(mon, pc)
    local x, y, z = GetPos(pc)
    PlayEffectToGround(pc, "F_pose_magical_light", 1366, y, -1181, 3)
end

function THORN39_3_SQ07_EFFECT3(mon, pc)
    local x, y, z = GetPos(pc)
    PlayEffectToGround(pc, "F_pose_magical_light", 2062, y, -822, 3)
end

function SCR_THORN39_3_SQ07_MSG(self)
    local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
    local p
    if P_cnt >= 1 then
        for p = 1, P_cnt do
            local sObj = GetSessionObject(P_list[p], 'SSN_THORN39_3_SQ07')
            local result = SCR_QUEST_CHECK(P_list[p], 'THORN39_3_SQ07')
            if result == 'SUCCESS' then
                if sObj.QuestInfoValue1 == 1 and sObj.QuestInfoValue2 == 1 and sObj.QuestInfoValue3 == 1 then
                    if sObj.Step1 < 1 then
                        SendAddOnMsg(P_list[p], "NOTICE_Dm_Clear", ScpArgMsg("THORN39_3_SQ07_MSG2"), 5)
                        sObj.Step1 = 1
                    end
                end
            end
        end
    end
end

function SCR_USE_PILGRIMROAD362_HIDDENQ1_ITEM3(self, argObj, argstring, arg1, arg2)
    local result = DOTIMEACTION_R(self, ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG8"), 'ABSORB', 1.5)
    if result == 1 then
    local sObj = GetSessionObject(self, "SSN_PILGRIMROAD362_HQ3")
        if sObj ~= nil then
            local Hidden_objdlg = { sObj.String1, sObj.String2, sObj.String3, sObj.String4 }
            --print(sObj.String1, sObj.String2, sObj.String3,sObj.String4)
            local x, y, z = GetPos(self)
            PlayEffectLocal(self, self, "F_circle016", 2.3, nil, "BOT")
            if 200 > SCR_POINT_DISTANCE(x, z, 881, 1259) then
                if sObj.Goal1 < 1 then
                    local state = PILGRIMROAD362_HIDDENQ1_ITEM3_SEARCH(self, sObj, #Hidden_objdlg,Hidden_objdlg, "Goal1")
                    if state ~= "YES" then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG12"), 3)
                    else
                        if 100 > SCR_POINT_DISTANCE(x, z, 881, 1259) then
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG10"), 3)
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG14"), 3)
                        end
                    end
                else
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG13"), 3)
                end
            elseif 200 > SCR_POINT_DISTANCE(x, z, 1, -871) then
                if sObj.Goal2 < 1 then
                    local state = PILGRIMROAD362_HIDDENQ1_ITEM3_SEARCH(self, sObj, #Hidden_objdlg,Hidden_objdlg, "Goal2")
                    if state ~= "YES" then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG12"), 3)
                    else
                        if 100 > SCR_POINT_DISTANCE(x, z, 1, -871) then
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG10"), 3)
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG14"), 3)
                        end
                    end
                else
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG13"), 3)
                end
            elseif 200 > SCR_POINT_DISTANCE(x, z, -939, -234) then
                if sObj.Goal3 < 1 then
                    local state = PILGRIMROAD362_HIDDENQ1_ITEM3_SEARCH(self, sObj, #Hidden_objdlg,Hidden_objdlg, "Goal3")
                    if state ~= "YES" then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG12"), 3)
                    else
                        if 100 > SCR_POINT_DISTANCE(x, z, -939, -234) then
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG10"), 3)
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG14"), 3)
                        end
                    end
                else
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG13"), 3)
                end
            elseif 200 > SCR_POINT_DISTANCE(x, z, -1374, 1166) then
                if sObj.Goal4 < 1 then
                    local state = PILGRIMROAD362_HIDDENQ1_ITEM3_SEARCH(self, sObj, #Hidden_objdlg,Hidden_objdlg, "Goal4")
                    if state ~= "YES" then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG12"), 3)
                    else
                        if 100 > SCR_POINT_DISTANCE(x, z, -1374, 1166) then
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG10"), 3)
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG14"), 3)
                        end
                    end
                else
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG13"), 3)
                end
            elseif 200 > SCR_POINT_DISTANCE(x, z, -376, 1129) then
                if sObj.Goal5 < 1 then
                    local state = PILGRIMROAD362_HIDDENQ1_ITEM3_SEARCH(self, sObj, #Hidden_objdlg,Hidden_objdlg, "Goal5")
                    if state ~= "YES" then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG12"), 3)
                    else
                        if 100 > SCR_POINT_DISTANCE(x, z, -376, 1129) then
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG10"), 3)
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG14"), 3)
                        end
                    end
                else
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG13"), 3)
                end
            elseif 200 > SCR_POINT_DISTANCE(x, z, 1020, 629) then
                if sObj.Goal6 < 1 then
                    local state = PILGRIMROAD362_HIDDENQ1_ITEM3_SEARCH(self, sObj, #Hidden_objdlg,Hidden_objdlg, "Goal6")
                    if state ~= "YES" then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG12"), 3)
                    else
                        if 100 > SCR_POINT_DISTANCE(x, z, 1020, 629) then
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG10"), 3)
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG14"), 3)
                        end
                    end
                else
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG13"), 3)
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG12"), 3)
            end
        end
    end
end

function PILGRIMROAD362_HIDDENQ1_ITEM3_SEARCH(self, sObj, arrcnt, obj_arr, _prop)
    local obj, cnt = SelectObject(self, 200, "ALL", 1)
    if cnt >= 1 then
        for i = 1, cnt do
            if obj[i].ClassName == "Hiddennpc" then
                for j =1, arrcnt do
                local Hidden_objdlg = obj_arr[j]
                    if sObj[_prop] < 1 then
                        if Hidden_objdlg == obj[i].Dialog then
                            if isHideNPC(self, Hidden_objdlg) == "YES" then
                                UnHideNPC(self, Hidden_objdlg)
                                PlayEffectLocal(self, self, "I_light013_spark_blue_2", 1.8, nil, "MID")
                                return 'YES'
                            else
                                PlayEffectLocal(self, self, "I_light013_spark_blue_2", 1.8, nil, "MID")
                                return 'YES'
                            end
                        end
                    end
                end
            end
        end
    end
end


--SCR_USE_PILGRIM48_HIDDENQ1_PREITEM
function SCR_USE_PILGRIM48_HIDDENQ1_PREITEM(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) == 0  then
        local paper_item = {
                                'PILGRIM48_HIDDENQ1_PREITEM1',
                                'PILGRIM48_HIDDENQ1_PREITEM2',
                                'PILGRIM48_HIDDENQ1_PREITEM3',
                                }
        for i = 1, #paper_item do
            if GetInvItemCount(self, paper_item[i]) == 0 then
                ShowBalloonText(self, "PILGRIM48_GETBOOK_MSG1", 5)
                return;
            end
        end
        local sel = ShowSelDlg(self, 1, "PILGRIM48_HIDDENQ1_DLG1", ScpArgMsg("PILGRIM48_HIDDENQ1_MSG1"), ScpArgMsg("PILGRIM48_HIDDENQ1_MSG2"))
        if sel == 1 then
            local result = DOTIMEACTION_R(self, ScpArgMsg("PILGRIM48_HIDDENQ1_MSG3"), 'ABSORB', 1.5)
            if result == 1 then
                local tx1 = TxBegin(self);
                for i = 1, #paper_item do
                    if GetInvItemCount(self, paper_item[i]) >= 1 then
                        TxTakeItem(tx1, paper_item[i], GetInvItemCount(self, paper_item[i]), 'PILGRIMROAD48_HQ1_PRE');
                    end
                end
                TxGiveItem(tx1, "PILGRIM48_HIDDENQ1_ITEM1", 1, "PILGRIMROAD48_HQ1_PRE");
                local ret = TxCommit(tx1);
                if ret == "SUCCESS" then
                    local sObj = GetSessionObject(self, "SSN_PILGRIM48_HQ1_UNLOCK")
                    if sObj ~= nil then
                        sObj.Goal1 = 1
                    end
                else
                    print("tx FAIL!")
                end
            end
        end
    end
end

--SCR_USE_PILGRIM48_HIDDENQ1_ITEM3
function SCR_USE_PILGRIM48_HIDDENQ1_ITEM3(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "SSN_PILGRIM48_HQ1")
    local result = SCR_QUEST_CHECK(self, 'PILGRIM48_HQ1')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_pilgrimroad_49' then
            if GetLayer(self) == 0 then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 1.5, 'PILGRIM48_HQ1')
                local result2 = DOTIMEACTION_R(self, ScpArgMsg("PILGRIM48_HIDDENQ1_OBJ_MSG1"), 'COMPASS', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(self, result2, animTime, before_time, 'PILGRIM48_HQ1')
                local obj1, obj2, obj3, obj4
                if result2 == 1 then
                    local list_spot, cnt_spot = GetWorldObjectList(self, "MON", 6000)
                    local i
                    for i = 1, cnt_spot do
                        if list_spot[i].ClassName == "Hiddennpc_move" then
                            if list_spot[i].Faction == "Neutral" then
                                if list_spot[i].Dialog == "PILGRIM48_HIDDENQ1_OBJ1" then
                                    if sObj.Goal1 < 1 then
                                        obj1 = list_spot[i]
                                    end
                                end
                                if list_spot[i].Dialog == "PILGRIM48_HIDDENQ1_OBJ2" then
                                    if sObj.Goal2 < 1 then
                                        obj2 = list_spot[i]
                                    end
                                end
                                if list_spot[i].Dialog == "PILGRIM48_HIDDENQ1_OBJ3" then
                                    if sObj.Goal3 < 1 then
                                        obj3 = list_spot[i]
                                    end
                                end
                                if list_spot[i].Dialog == "PILGRIM48_HIDDENQ1_OBJ4" then
                                    if sObj.Goal4 < 1 then
                                        obj4 = list_spot[i]
                                    end
                                end
                            end
                        end
                    end
                    local close_obj = PILGRIM48_HIDDENQ1_CLOSE_OBJ_CHECK(self, obj1, obj2, obj3, obj4)
                    if close_obj.Dialog == "PILGRIM48_HIDDENQ1_OBJ1" then
                        PILGRIM48_HIDDENQ1_OBJ_SERCH(self, close_obj)
                    elseif close_obj.Dialog == "PILGRIM48_HIDDENQ1_OBJ2" then
                        PILGRIM48_HIDDENQ1_OBJ_SERCH(self, close_obj)
                    elseif close_obj.Dialog == "PILGRIM48_HIDDENQ1_OBJ3" then
                        PILGRIM48_HIDDENQ1_OBJ_SERCH(self, close_obj)
                    elseif close_obj.Dialog == "PILGRIM48_HIDDENQ1_OBJ4" then
                        PILGRIM48_HIDDENQ1_OBJ_SERCH(self, close_obj)
                    end
                end
            end
        end
    end
end

function PILGRIM48_HIDDENQ1_CLOSE_OBJ_CHECK(self, obj1, obj2, obj3, obj4)
    local x, y, z = GetPos(self)
    local distance1, distance2, distance3, distance4
    if obj1 ~= nil then
        local Obj1_x, Obj1_y, Obj1_z = GetPos(obj1)
        distance1 = SCR_POINT_DISTANCE(x, z, Obj1_x, Obj1_z)
    end
    
    if obj2 ~= nil then
        local Obj2_x, Obj2_y, Obj2_z = GetPos(obj2)
        distance2 = SCR_POINT_DISTANCE(x, z, Obj2_x, Obj2_z)
    end
    
    if obj3 ~= nil then
        local Obj3_x, Obj3_y, Obj3_z = GetPos(obj3)
        distance3 = SCR_POINT_DISTANCE(x, z, Obj3_x, Obj3_z)
    end
    
    if obj4 ~= nil then
        local Obj4_x, Obj4_y, Obj4_z = GetPos(obj4)
        distance4 = SCR_POINT_DISTANCE(x, z, Obj4_x, Obj4_z)
    end
--    print("obj1 Name "..obj1.Dialog.." distance "..distance1, "obj2 Name "..obj2.Dialog.." distance "..distance2, "obj3 Name "..obj3.Dialog.." distance "..distance3, "obj4 Name "..obj4.Dialog.." distance "..distance4)
    --print(distance1, distance2, distance3, distance4)
    local close_distance1, close_distance2
    local Close_Obj1, Close_Obj2
    
    if distance1 == nil then
        close_distance1 = distance2
        Close_Obj1 = obj2
    elseif distance2 == nil then
        close_distance1 = distance1
        Close_Obj1 = obj1
    elseif distance1 < distance2 then
        close_distance1 = distance1
        Close_Obj1 = obj1
    elseif distance1 == distance2 then
        close_distance1 = distance1
        Close_Obj1 = obj1
    else
        close_distance1 = distance2
        Close_Obj1 = obj2
    end
    
    if distance3 == nil then
        close_distance2 = distance4
        Close_Obj2 = obj4
    elseif distance4 == nil then
        close_distance2 = distance3
        Close_Obj2 = obj3
    elseif distance3 < distance4 then
        close_distance2 = distance3
        Close_Obj2 = obj3
    elseif distance3 == distance4 then
        close_distance2 = distance3
        Close_Obj2 = obj3
    else
        close_distance2 = distance4
        Close_Obj2 = obj4
    end
    
    if close_distance1 == nil then
        return Close_Obj2
    elseif close_distance2 == nil then
        return Close_Obj1
    elseif close_distance1 < close_distance2 then
        return Close_Obj1
    elseif close_distance1 == close_distance2 then
        return Close_Obj1
    else
        return Close_Obj2
    end
end

function PILGRIM48_HIDDENQ1_OBJ_SERCH(self, obj)
    local angle = GetAngleTo(obj, self)
    local x_pc, y_pc, z_pc = GetPos(self)
    local x_spot, y_spot, z_spot = GetPos(obj)
    local dist_spot = SCR_POINT_DISTANCE(x_pc, z_pc, x_spot, z_spot)
    
    if dist_spot > 1 and dist_spot <= 150 then
        UnHideNPC(self, obj.Dialog)
        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('PILGRIM48_HIDDENQ1_OBJ_MSG2'), 5) --PILGRIM48_HIDDENQ1_OBJ_MSG2
--            local mon_relic = CREATE_MONSTER_EX(self, 'noshadow_npc', x_mon , y_mon, z_mon , 0, 'Neutral', 1, PILGRIM_48_SQ_060_RELIC_AI_RUN);
--                SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('PILGRIM_48_SQ_060_MSG02'), 5) 
--            SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('PILGRIM_48_SQ_060_MSG03'), 5) 
    elseif dist_spot > 150 and dist_spot <= 500 then
        if angle > -120 and angle <= -60 then
            ShowBalloonText(self, "PILGRIM48_HIDDENQ1_OBJ_SERCH1", 5) --PILGRIM48_HIDDENQ1_OBJ_SERCH1
        elseif angle > -60 and angle <= -30 then
            ShowBalloonText(self, "PILGRIM48_HIDDENQ1_OBJ_SERCH2", 5) 
        elseif angle > -30  and angle <= 45 then
            ShowBalloonText(self, "PILGRIM48_HIDDENQ1_OBJ_SERCH3", 5) 
        else
            ShowBalloonText(self, "PILGRIM48_HIDDENQ1_OBJ_SERCH4", 5)
        end
    elseif dist_spot > 500 and dist_spot <= 750 then
        if angle > -120 and angle <= -60 then
            ShowBalloonText(self, "PILGRIM48_HIDDENQ1_OBJ_SERCH5", 5) 
        elseif angle > -60 and angle <= -30 then
            ShowBalloonText(self, "PILGRIM48_HIDDENQ1_OBJ_SERCH6", 5) 
        elseif angle > -30  and angle <= 45 then
            ShowBalloonText(self, "PILGRIM48_HIDDENQ1_OBJ_SERCH7", 5) 
        else
            ShowBalloonText(self, "PILGRIM48_HIDDENQ1_OBJ_SERCH8", 5) 
        end
    elseif dist_spot > 750 then --and dist_spot <= 1000
        if angle > -130 and angle <= -60 then
            ShowBalloonText(self, "PILGRIM48_HIDDENQ1_OBJ_SERCH9", 5) 
        elseif angle > -60 and angle <= -30 then
            ShowBalloonText(self, "PILGRIM48_HIDDENQ1_OBJ_SERCH10", 5) 
        elseif angle > -30  and angle <= 45 then
            ShowBalloonText(self, "PILGRIM48_HIDDENQ1_OBJ_SERCH11", 5) 
        else
            ShowBalloonText(self, "PILGRIM48_HIDDENQ1_OBJ_SERCH12", 5) 
        end
--    elseif dist_spot > 1000 then
--        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('PILGRIM48_HIDDENQ1_OBJ_MSG3'), 5)
--    else
--        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('PILGRIM48_HIDDENQ1_OBJ_MSG3'), 5)
    end
end

--SCR_USE_CATHEDRAL1_HIDDENQ1_ITEM1
function SCR_USE_CATHEDRAL1_HIDDENQ1_ITEM1(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "SSN_CATHEDRAL1_HQ1")
    PlaySoundLocal(self, "hidden_piri_3")
    local result = DOTIMEACTION_R(self, ScpArgMsg("CATHEDRAL1_HIDDEN_NPC_MSG5"), 'FLUTE_PLAY', 4)
    if result == 1 then
        if argObj == nil then
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg('CATHEDRAL1_HIDDEN_NPC_MSG6'), 7)
        else
            if sObj ~= nil then
                if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
    	            sObj.QuestInfoValue1 = sObj.QuestInfoMaxCount1
    	            SaveSessionObject(self, sObj)
    	            PlayEffectLocal(argObj, self, "F_light119_music", 2, 1, "TOP")
    	            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg('CATHEDRAL1_HIDDEN_NPC_MSG8'), 7)
    	            Chat(argObj, ScpArgMsg("CATHEDRAL1_HIDDEN_NPC_MSG7"), 3)
    	        end
    	    end
        end
    else
        StopSound(self, "hidden_piri_3")
    end
end

--SCR_USE_CATACOMB38_2_HIDDENQ1_ITEM1
function SCR_USE_CATACOMB38_2_HIDDENQ1_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = DOTIMEACTION_R(self, ScpArgMsg("CATACOMB38_2_HIDDENQ1_MSG5"), 'ABSORB', 2)
    if result == 1 then
        PlayEffect(self, "F_circle016", 2, "BOT")
        local x, y, z = GetPos(argObj)
        local mon = CREATE_NPC(self, 'noshadow_npc_8', x, y, z, GetDirectionByAngle(self), 'Neutral', 0, ScpArgMsg("CATACOMB382_HIDDENQ_GHOST_OBJ"), "CATACOMB382_HIDDEN_SPIRIT");
        AttachEffect(mon, "I_smoke063_ball_dark_red_loop_mesh", 3, 'TOP')
        Kill(argObj)
        SetLifeTime(mon, 5)
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg('CATACOMB38_2_HIDDENQ1_MSG6'), 7)
    end
end

function SCR_CATACOMB382_HIDDEN_SPIRIT_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'CATACOMB38_2_HQ1')
    local sObj = GetSessionObject(pc, "SSN_CATACOMB38_2_HQ1")
    if result == 'PROGRESS' then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("CATACOMB38_2_HIDDENQ1_MSG7"), 'ABSORB', 1.5)
        if result == 1 then
            if sObj ~= nil then
                if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
        	        sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
        	        PlayEffect(self, "F_light013", 2, "BOT")
        	        Kill(self)
        	        DetachEffect(self, "I_smoke063_ball_dark_red_loop_mesh")
        	        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg('CATACOMB38_2_HIDDENQ1_MSG8'), 7)
        	    end
    	    end
        end
    end
end


--FTOWER692_KQ_1
function SCR_USE_FTOWER692_KQ_1_ITEM(self, argObj, argstring, arg1, arg2)
    KQ_PUPPET_GIMMICK_LIB(self, 'FTOWER692_KQ_1', 'd_firetower_69_2', 300)
end






--PILGRIM412_KQ_1
function SCR_USE_PILGRIM412_KQ_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result2 = DOTIMEACTION_R(self, ScpArgMsg("RANDBOX_GIMMICK_DOTIME_2"), 'MAKING', 1)
    if result2 == 1 then
        local list = GetScpObjectList(self, 'RANDOM_MAPPOS_GMMICK_NPC')
        local x = {}
        local y = {}
        local z = {}
        if #list > 0  then
            local j
            for j = 1, #list do
                x[j], y[j], z[j]  = GetPos(list[j])
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('RANDBOX_GIMMICK_PLZ_UPDATE_1'), 8);
            return
        end
        TreasureMarkListByMap(self, GetZoneName(self), #list, x[1], y[1], z[1],
                                                      x[2], y[2], z[2],
                                                      x[3], y[3], z[3]
                                                      )
    end
end



--LSCAVE521_KQ_1
function SCR_USE_LSCAVE521_KQ_1_ITEM(self, argObj, argstring, arg1, arg2)
    local result2 = DOTIMEACTION_R(self, ScpArgMsg("RANDBOX_GIMMICK_DOTIME_2"), 'MAKING', 1)
    if result2 == 1 then
        local list = GetScpObjectList(self, 'RANDOM_MAPPOS_GMMICK_NPC')
        local x = {}
        local y = {}
        local z = {}
        if #list > 0  then
            local j
            for j = 1, #list do
                x[j], y[j], z[j]  = GetPos(list[j])
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('RANDBOX_GIMMICK_PLZ_UPDATE_1'), 8);
            return
        end
        TreasureMarkListByMap(self, GetZoneName(self), #list, x[1], y[1], z[1],
                                                      x[2], y[2], z[2],
                                                      x[3], y[3], z[3]
                                                      )
    end
end
function SCR_USE_KLAIPE_CHAR313_ITEM1(self, argObj, argstring, arg1, arg2)
    --SCR_UES_ITEM_BOOK(self,argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "SSN_APPRAISER_UNLOCK")
    if  sObj.Goal1 < 1 and sObj.Goal2 < 1 then
        ShowBookItem(self, "KLAIPE_CHAR313_ITEM1_BOOK");
    elseif sObj.Goal1 == 1 and sObj.Goal2 == 1 then
        ShowBookItem(self, "KLAIPE_CHAR313_ITEM1_BOOK4");
    elseif sObj.Goal1 == 1 or sObj.Goal2 == 1 then
        if sObj.Goal1 == 1 then
            ShowBookItem(self, "KLAIPE_CHAR313_ITEM1_BOOK2");
        elseif sObj.Goal2 == 1 then
            ShowBookItem(self, "KLAIPE_CHAR313_ITEM1_BOOK3");
        end
    else
        
    end
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(self, 'Char3_13');
    local ran = IMCRandom(1, 20)
    if hidden_prop < 40 then
        if ran <= 10 then
            ShowBalloonText(self, "CHAR313_MSTEP4_3_MSG1", 5)
            sObj.Step4 = 1
            SaveSessionObject(self, sObj)
        else
            ShowBalloonText(self, "CHAR313_MSTEP4_3_MSG2", 5)
            sObj.Step5 = 1
            SaveSessionObject(self, sObj)
        end
    elseif hidden_prop == 40 then
        ShowBalloonText(self, "CHAR313_MSTEP4_3_MSG3", 5)
    end
    local hidden_count = sObj.Step4 + sObj.Step5
    if hidden_count == 2 then
        sObj.Goal3 = 1
        SaveSessionObject(self, sObj)
    end
    if sObj.Goal1 == 1 and sObj.Goal2 == 1 and sObj.Goal3 == 1 then
        if hidden_prop < 40 then
            SCR_SET_HIDDEN_JOB_PROP(self, 'Char3_13', 40)
        end
    end
end

--CORAL_44_2_SQ_60_ITEM1
function SCR_USE_CORAL_44_2_SQ_60_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'CORAL_44_2_SQ_60')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_coral_44_2' then
            if GetLayer(self) == 0 then
                local x, y, z = GetPos(self)
                local dist = SCR_POINT_DISTANCE(x, z, 985, -381)
                if dist <= 40 then
                    local sObj = GetSessionObject(self, 'SSN_CORAL_44_2_SQ_60')
                    if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                        local result1 = DOTIMEACTION_R(self, ScpArgMsg("CORAL_44_2_SQ_60_DTA"), 'SITWATER_LOOP', 3)
                        if result1  == 1 then
                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CORAL_44_2_SQ_60', 'QuestInfoValue1', 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_GetItem/'..ScpArgMsg("CORAL_44_2_SQ_60_ITEM_MSG2")..'/5')
                        end
                    end
                end
            end
        end
    end
end



--FANTASYLIB481_MQ_4_ITEM
function SCR_USE_FANTASYLIB481_MQ_4_ITEM(self, argObj, argstring, arg1, arg2)
    
    local list, cnt = SelectObjectByClassName(self, 150, 'Hiddennpc_Q3')
    if cnt > 0 then
        local i
        for i = 1, cnt do
            local x, y, z = GetPos(list[i])
            local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_Q2', x, y, z, -45, 'Neutral', self.Lv, FANTASYLIB481_MQ_4_ITEM_RUN);
            AddVisiblePC(mon, self, 1);
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('FANTASYLIB481_MQ_4_ITEM_FIND'), 8);
            AddScpObjectList(self, "FANTASYLIB481_MQ_4_ITEM", mon)
            AddScpObjectList(mon, "FANTASYLIB481_MQ_4_ITEM", self)
            Kill(list[i])
            return
        end
    else
        SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('FANTASYLIB481_MQ_4_ITEM_CANT'), 8);
        return
    end
end



function FANTASYLIB481_MQ_4_ITEM_RUN(mon)
    mon.Name = ScpArgMsg("FANTASYLIB481_MQ_4_ITEM_NAME")
    mon.Dialog = 'FANTASYLIB481_MQ_4_NPC'
    mon.SimpleAI = 'FANTASYLIB481_MQ_4_NPC_AI'
end

function SCR_FANTASYLIB481_MQ_4_NPC_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'FANTASYLIB481_MQ_4')
    if result == 'PROGRESS' then
        local list = GetScpObjectList(self, "FANTASYLIB481_MQ_4_ITEM")
        if #list == 0 then
            Kill(self)
        end

        if IsSameObject(pc, list[1]) == 1 then
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("FANTASYLIB481_MQ_4_MSG_0"), 'MAKING', 1.5);
            if result2 == 1 then
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_FANTASYLIB481_MQ_4', 'QuestInfoValue1', 1)
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg('FANTASYLIB481_MQ_4_ITEM_DONE'), 8);
                Kill(self)
            end
        else
            SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('FANTASYLIB481_MQ_4_ITEM_NOT_YOU'), 8);
        end

    end
end

        

function FANTASYLIB481_MQ_4_NPC_AI_1(self)
    local list = GetScpObjectList(self, "FANTASYLIB481_MQ_4_ITEM")
    if #list == 0 then
        Kill(self)
    end
end




--FANTASYLIB483_MQ_7_ITEM
function SCR_USE_FANTASYLIB483_MQ_7_ITEM(self, argObj, argstring, arg1, arg2)
    local list, cnt = SelectObjectByFaction(argObj, 150, 'Monster')
    if cnt > 0 then
        local i
        for i = 1, cnt do
            KnockDown(list[i], argObj, 250, GetAngleTo(argObj, list[i]), 45, 1)
        end
    end
end

--FANTASYLIB485_MQ_ITEM
function SCR_USE_FANTASYLIB485_MQ_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'FANTASYLIB485_MQ_3')
    if result == 'PROGRESS' then
        local result2 = DOTIMEACTION_R(self, ScpArgMsg("FANTASYLIB485_MQ_3_MSG_1"), 'ABSORB', 1.5);
        if result2 == 1 then
            local x, y, z = GetPos(argObj)
            local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_Q4', x, y, z, 0, 'Neutral', 1, FANTASYLIB485_MQ_ITEM_AI);
            AddVisiblePC(mon, self, 1)
            SetLifeTime(mon, 15)
            Kill(argObj)
        end
    end
end

function FANTASYLIB485_MQ_ITEM_AI(mon)
    mon.SimpleAI = 'FANTASYLIB485_MQ_PUBLIC_WARP'
    mon.Name = 'UnvisibleName'
    mon.Dialog = 'FANTASYLIB485_MQ_3_NPC'
end




--F_3CMLAKE_85_MQ_02_3_ITEM_01
function SCR_USE_F_3CMLAKE_85_MQ_02_3_ITEM_01(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE_85_MQ_02_3')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_3cmlake_85' then
            if GetLayer(self) == 0 then
                LookAt(self, argObj)
                local result = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE_85_MQ_02_3_MSG1"), 'SITWATER_LOOP', 3, 'SSN_HATE_AROUND')
                if result == 1 then
                    if argObj.NumArg1 ~= 1 then
                        SCR_PARTY_QUESTPROP_ADD(self, nil, nil, nil, nil, 'F_3CMLAKE_85_MQ_02_3_ITEM_02/1', nil, nil, nil, nil, nil, nil, 'F_3CMLAKE_85_MQ_02_3', 'NOTICE_Dm_GetItem/'..ScpArgMsg("F_3CMLAKE_85_MQ_02_3_MSG2")..'/3')
                        argObj.NumArg1 = 1
                        Kill(argObj)
                    end
                end
            end
        end
    end
end

--F_3CMLAKE_85_MQ_03_ITEM_01
function SCR_USE_F_3CMLAKE_85_MQ_03_ITEM_01(self, argObj, argstring, arg1, arg2)
    ShowOkDlg(self, 'F_3CMLAKE_85_MQ_03_ITEM_DLG', 1)
end

--F_3CMLAKE_85_MQ_08_ITEM
function SCR_USE_F_3CMLAKE_85_MQ_08_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE_85_MQ_08_1')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_3cmlake_85' then
            if GetLayer(self) == 0 then
                LookAt(self, argObj)
                local result = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE_85_MQ_08_1_MSG1"), 'SITWATER_LOOP', 5, 'SSN_HATE_AROUND')
                if result == 1 then
                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_85_MQ_08_1', 'QuestInfoValue1', 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_Clear/'..ScpArgMsg("F_3CMLAKE_85_MQ_08_1_MSG2")..'/5')
                    local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
                    local p
                    if P_cnt >= 1 then
                        for p = 1, P_cnt do
                            local sObj = GetSessionObject(P_list[p], 'SSN_F_3CMLAKE_85_MQ_08_1')
                            if sObj.QuestInfoValue1 == 1 then
                                if isHideNPC(P_list[p], 'F_3CMLAKE_85_MQ_03_NPC') == 'NO' then
                                    HideNPC(P_list[p], 'F_3CMLAKE_85_MQ_03_NPC')
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

--F_3CMLAKE_85_MQ_09_ITEM
function SCR_USE_F_3CMLAKE_85_MQ_09_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'F_3CMLAKE_85_MQ_09')
    if result1 == 'PROGRESS' then
        if GetZoneName(self) == 'f_3cmlake_85' then        
            if GetLayer(self) ~= 0 then            
                LookAt(self, argObj)
                local result = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE_85_MQ_09_MSG1"), 'ABSORB', 1, 'SSN_HATE_AROUND')
                if result == 1 then
                    AddBuff(self, argObj, 'F_3CMLAKE_85_MQ_09_STUN', 1, 0, 7000, 0)
                	PlayEffect(argObj, 'F_light029_yellow', 3, 0, 'MID')
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("F_3CMLAKE_85_MQ_09_MSG2"), 5)
                end
            end
        end
    end
end

--F_3CMLAKE_85_SQ_02_ITEM
function SCR_USE_F_3CMLAKE_85_SQ_02_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE_85_SQ_02')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        local result = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE_85_SQ_02_MSG1"), 'ABSORB', 2)
        if result == 1 then
            local ran = IMCRandom(1, 10)
            if ran <= 5 then
                AddBuff(self, argObj, "F_3CMLAKE_85_SQ_02_STUN", 1, 0, 20000, 1)
                PlayEffect(argObj, "F_smoke010_blue", 1, "BOT")
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg('F_3CMLAKE_85_SQ_02_MSG2'), 5)
            else
                AddBuff(self, argObj, 'F_3CMLAKE_85_SQ_02_FRENZY', 1, 0, 20000, 1)
                PlayEffect(argObj, "F_smoke010_blue", 1, "BOT")
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg('F_3CMLAKE_85_SQ_02_MSG3'), 5)
            end
        end
    end
end

--F_3CMLAKE86_MQ2_ITEM
function SCR_USE_F_3CMLAKE86_MQ2_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE_86_MQ_02')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        local result = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE_86_MQ_02_MSG1"), 'skl_assistattack_shovel', 2)
        if result == 1 then
            if argObj.NumArg1 ~= 1 then
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_86_MQ_02', 'QuestInfoValue1', 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_Clear/'..ScpArgMsg("F_3CMLAKE_86_MQ_02_MSG2")..'/5')
                PlayEffect(argObj, "F_ground065_smoke", 0.5, 1, "BOT")
                argObj.NumArg1 = 1
                local x, y, z = GetPos(argObj)
                KILL_BLEND(argObj, 1, 1)
                local mon = CREATE_MONSTER_EX(self, 'boss_summon_spiderweb', x, y, z, 0, 'Neutral', 0, F_3CMLAKE_86_MQ_02_RUN)
                AddVisiblePC(mon, self, 1)
            	SetLifeTime(mon, 1)
            end
        end
    end
end

--F_3CMLAKE86_MQ8_ITEM
function SCR_USE_F_3CMLAKE86_MQ8_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE_86_MQ_08')
    if result == 'PROGRESS' then
        local result1 = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE_86_MQ_08_MSG1"), 'MAKING', 3)
        if result1 == 1 then
            local list, cnt = SelectObjectByClassName(self, 100, 'Hiddennpc_move')
            local i
            if cnt > 0 then
                for i = 1, cnt do
                    if list[i].ClassName ~= 'PC' then
                        if list[i].Enter == 'F_3CMLAKE_86_MQ_08_CHECK2' then
                            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('F_3CMLAKE_86_MQ_08_MSG2'), 5)
                            local x, y, z = GetPos(list[i])
                            Kill(list[i])
                            local mon = CREATE_MONSTER_EX(self, 'noshadow_npc', x, y, z, 0, 'Neutral', 0, F_3CMLAKE_86_MQ_08_RUN)
                            AddVisiblePC(mon, self, 1)
                        	SetLifeTime(mon, 60)
                        	AttachEffect(mon, 'F_pattern013_ground', 5, 'BOT')
                        end
                    end
                end
            else
                SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('F_3CMLAKE_86_MQ_08_MSG3'), 5)
            end
        end
    end
end


--F_3CMLAKE86_MQ14_ITEM
function SCR_USE_F_3CMLAKE86_MQ14_ITEM(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, 'SSN_F_3CMLAKE_86_MQ_16')
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE_86_MQ_16')
    if result == 'PROGRESS' then
        local result = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE_86_MQ_16_MSG1"), 'BURY', 3, 'SSN_HATE_AROUND')
        if result == 1 then
            local x, y, z = GetPos(self)
            local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
            local p
            if P_cnt >= 1 then
                for p = 1, P_cnt do
                    if SCR_POINT_DISTANCE(x, z, 183, 1577) < 50 then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_86_MQ_16', 'QuestInfoValue1', 1, nil, nil, nil, "F_3CMLAKE_86_MQ_16_CHECK1", 0, nil, nil, nil, nil, 'NOTICE_Dm_Clear/'..ScpArgMsg("F_3CMLAKE_86_MQ_16_MSG2")..'/5')  
                        PlayEffect(P_list[p], "F_smoke046", 1, 'MID')
                    elseif  SCR_POINT_DISTANCE(x, z, 151, 1379) < 50 then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_86_MQ_16', 'QuestInfoValue2', 1, nil, nil, nil, "F_3CMLAKE_86_MQ_16_CHECK2", 0, nil, nil, nil, nil, 'NOTICE_Dm_Clear/'..ScpArgMsg("F_3CMLAKE_86_MQ_16_MSG2")..'/5')  
                        PlayEffect(P_list[p], "F_smoke046", 1, 'MID')
                    elseif  SCR_POINT_DISTANCE(x, z, 137, 1217) < 50 then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_86_MQ_16', 'QuestInfoValue3', 1, nil, nil, nil, "F_3CMLAKE_86_MQ_16_CHECK3", 0, nil, nil, nil, nil, 'NOTICE_Dm_Clear/'..ScpArgMsg("F_3CMLAKE_86_MQ_16_MSG2")..'/5')  
                        PlayEffect(P_list[p], "F_smoke046", 1, 'MID')
                    end
                end
            end
        end
    end
end

--D_CATACOMB_80_GIMMICK_BUFF
function SCR_USE_ITEM_HASTEBUFF_CATACOMB_80(self,argObj,BuffName,arg1,arg2)
	AddBuff(self, self, 'CATACOMB_80_HASTE', arg1, 0, arg2, 1);
end

function SCR_USE_ITEM_ATKBUFF_CATACOMB_80(self,argObj,BuffName,arg1,arg2)
	AddBuff(self, self, 'CATACOMB_80_ATK', arg1, 0, arg2, 1);
end

function SCR_USE_ITEM_MATKBUFF_CATACOMB_80(self,argObj,BuffName,arg1,arg2)
	AddBuff(self, self, 'CATACOMB_80_MATK', arg1, 0, arg2, 1);
end

function SCR_PRECHECK_CONSUME_CATACOMB_80(self)
	if OnKnockDown(self) == 'NO' then
        local ZoneNameCheck = GetZoneName(self)
        if ZoneNameCheck == 'd_catacomb_80_1' or ZoneNameCheck == 'd_catacomb_80_2' or ZoneNameCheck == 'd_catacomb_80_3' then
            return 1;
        else
            SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg("CATACOMB_80_1_CRYSTAL_CONSUME"), 5)
            return 0;
        end
	end
	return 0;
end

--F_3CMLAKE87_MQ2_ITEM
function SCR_USE_F_3CMLAKE87_MQ2_ITEM(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, 'SSN_F_3CMLAKE_87_MQ_02')
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE_87_MQ_02')
    if result == 'PROGRESS' then
        local list, Cnt = SelectObject(self, 50, 'ALL')
        for i = 1, Cnt do
            if list[i].ClassName == 'Link_stone' then                                    
                LookAt(self, list[i])
                local result = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE_87_MQ_02_MSG1"), 'ABSORB', 3, 'SSN_HATE_AROUND')
                if result == 1 then
                    PlayEffect(list[i], "F_smoke046", 1, 'MID')
                    if list[i].Dialog == 'F_3CMLAKE_87_MQ_02_OBJ_1' then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_87_MQ_02', 'Step1', nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_scroll/'..ScpArgMsg("F_3CMLAKE_87_MQ_02_MSG2")..'/5')
                    end
                    if list[i].Dialog == 'F_3CMLAKE_87_MQ_02_OBJ_2' then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_87_MQ_02', 'Step2', nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_scroll/'..ScpArgMsg("F_3CMLAKE_87_MQ_02_MSG2")..'/5')
                    end
                    if list[i].Dialog == 'F_3CMLAKE_87_MQ_02_OBJ_3' then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_87_MQ_02', 'Step3', nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_scroll/'..ScpArgMsg("F_3CMLAKE_87_MQ_02_MSG2")..'/5')
                    end
                    if list[i].Dialog == 'F_3CMLAKE_87_MQ_02_OBJ_4' then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_87_MQ_02', 'Step4', nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_scroll/'..ScpArgMsg("F_3CMLAKE_87_MQ_02_MSG2")..'/5')
                    end
                    if list[i].Dialog == 'F_3CMLAKE_87_MQ_02_OBJ_5' then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_87_MQ_02', 'Step5', nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_scroll/'..ScpArgMsg("F_3CMLAKE_87_MQ_02_MSG2")..'/5')
                    end
                    if list[i].Dialog == 'F_3CMLAKE_87_MQ_02_OBJ_6' then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_87_MQ_02', 'Step6', nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_scroll/'..ScpArgMsg("F_3CMLAKE_87_MQ_02_MSG2")..'/5')
                    end                                                                                                    
                end
            end
        end
    end
end


--F_3CMLAKE87_MQ8_ITEM
function SCR_USE_F_3CMLAKE87_MQ8_ITEM(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, 'SSN_F_3CMLAKE_87_MQ_08')
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE_87_MQ_08')
    if result == 'PROGRESS' then
        local follower1 = GetScpObjectList(self, 'F_3CMLAKE_87_MQ_08_1')
        local follower2 = GetScpObjectList(self, 'F_3CMLAKE_87_MQ_08_2')
        if #follower1 == 0 and #follower2 == 0 then
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("F_3CMLAKE_87_MQ_08_MSG3"), 3)        
        else
            local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
            local p
            if P_cnt >= 1 then
                for p = 1, P_cnt do            
                    local list, Cnt = SelectObject(self, 30, 'ALL')
                    for i = 1, Cnt do
                        if list[i].Enter == 'F_3CMLAKE_87_MQ_08_OBJ_1' then                                    
                            LookAt(self, list[i])
                            local result = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE_87_MQ_08_MSG1"), 'SITGROPE', 3, 'SSN_HATE_AROUND')
                            if result == 1 then
                                local x, y, z = GetPos(self) 
                                if SCR_POINT_DISTANCE(x, z, 133, 1228) < 30 then
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_87_MQ_08', 'QuestInfoValue1', 1, nil, nil, nil, "F_3CMLAKE_87_MQ_08_OBJ_1", 0, nil, nil, nil, nil, 'NOTICE_Dm_scroll/'..ScpArgMsg("F_3CMLAKE_87_MQ_08_MSG2")..'/5')  
                                    local x, y, z = GetPos(list[i])
                                    PlayEffectToGround(P_list[p], "F_smoke046", x, y, z, 1)
                                end
                            end
                        elseif list[i].Enter == 'F_3CMLAKE_87_MQ_08_OBJ_2' then                                    
                            LookAt(self, list[i])
                            local result = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE_87_MQ_08_MSG1"), 'SITGROPE', 3, 'SSN_HATE_AROUND')
                            if result == 1 then
                                local x, y, z = GetPos(self) 
                                if SCR_POINT_DISTANCE(x, z, 70, 1183) < 30 then
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_87_MQ_08', 'QuestInfoValue2', 1, nil, nil, nil, "F_3CMLAKE_87_MQ_08_OBJ_2", 0, nil, nil, nil, nil, 'NOTICE_Dm_scroll/'..ScpArgMsg("F_3CMLAKE_87_MQ_08_MSG2")..'/5')  
                                    local x, y, z = GetPos(list[i])
                                    PlayEffectToGround(P_list[p], "F_smoke046", x, y, z, 1)
                                end
                            end
                        elseif list[i].Enter == 'F_3CMLAKE_87_MQ_08_OBJ_3' then                                    
                            LookAt(self, list[i])
                            local result = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE_87_MQ_08_MSG1"), 'SITGROPE', 3, 'SSN_HATE_AROUND')
                            if result == 1 then
                                local x, y, z = GetPos(self) 
                                if SCR_POINT_DISTANCE(x, z, 92, 1113) < 30 then
                                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_F_3CMLAKE_87_MQ_08', 'QuestInfoValue3', 1, nil, nil, nil, "F_3CMLAKE_87_MQ_08_OBJ_3", 0, nil, nil, nil, nil, 'NOTICE_Dm_scroll/'..ScpArgMsg("F_3CMLAKE_87_MQ_08_MSG2")..'/5')  
                                    local x, y, z = GetPos(list[i])
                                    PlayEffectToGround(P_list[p], "F_smoke046", x, y, z, 1)
                                end
                            end
                        end
                    end
                    if isHideNPC(P_list[p], 'F_3CMLAKE_87_MQ_08_OBJ_1') == 'NO' and 
                        isHideNPC(P_list[p], 'F_3CMLAKE_87_MQ_08_OBJ_2') == 'NO' and 
                        isHideNPC(P_list[p], 'F_3CMLAKE_87_MQ_08_OBJ_3') == 'NO' then
                        sleep(500)
                        UIOpenToPC(P_list[p],'fullblack',1)
                        sleep(5000)
                        UIOpenToPC(P_list[p],'fullblack',0)    
                    end
                end
            end        
        end
    end
end

function SCR_USE_WTREES22_1_SUBQ2_ITEM1(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    if IsBuffApplied(argObj, "WTREES22_1_SUBQ2_BUFF1") == "NO" then
        local result = DOTIMEACTION_R(self, ScpArgMsg("WTREES22_1_SUBQ2_ITEM1_USING"), 'STANDSPINKLE', 2)
        if result == 1 then
            AddBuff(self, argObj, "WTREES22_1_SUBQ2_BUFF1", 1, 0, 8000, 1)
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("WTREES22_1_SUBQ3_MSG3"), 3)
        end
    else
        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("WTREES22_1_SUBQ3_MSG4"), 3)
    end
end

function SCR_USE_WTREES22_1_SUBQ5_ITEM3(self, argObj, argstring, arg1, arg2)
    local result = DOTIMEACTION_R(self, ScpArgMsg("WTREES22_1_SUBQ5_MSG1"), 'FLASK', 2)
    if result == 1 then
        SCR_RUNSCRIPT_PARTY("SCR_WTREES221_SUBQ5_ITEM3_USE_RESULT", 1, self)
    end
end

function SCR_WTREES221_SUBQ5_ITEM3_USE_RESULT(self)
    local quest = SCR_QUEST_CHECK(self, "WTREES22_1_SQ5")
    if quest == "PROGRESS" then
    local item = GetInvItemCount(self, "WTREES22_1_SUBQ5_ITEM1")
    local count
    if item >= 1 then
        count = 1
    else
        count = 0
    end
    RunZombieScript("GIVE_TAKE_ITEM_TX", self, "WTREES22_1_SUBQ5_ITEM4/1", "WTREES22_1_SUBQ5_ITEM1/"..count, "QUSET")
    SendAddOnMsg(self, 'NOTICE_Dm_GetItem', ScpArgMsg("WTREES22_1_SUBQ5_MSG2"),5)
    end
end

function SCR_USE_WTREES22_1_SUBQ6_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = DOTIMEACTION_R(self, ScpArgMsg("WTREES22_1_SUBQ6_MSG1"), 'FLASK', 2)
    if result == 1 then
        if argObj ~= nil then
            local mon = {}
            PlayEffect(argObj, "F_smoke058_violet", 2, 1, "BOT")  
            local x, y, z = GetPos(argObj)
            local ran = IMCRandom(1, 2)
            for i = 1, ran do
                mon[i] = CREATE_NPC(self, "noshadow_npc_MANA_WAR", x, y, z, 0, "Neutral", 0, "UnVisibleName", nil, nil, nil, 1, nil, "WTREES22_1_SUBQ6_FIREFLY")
                AddScpObjectList(self, 'WTREES22_1_SUBQ6_FIREFLY_PC', mon[i])
                AddScpObjectList(mon[i], 'WTREES22_1_SUBQ6_FIREFLY_MON', self)
                AttachEffect(mon[i], 'I_light001', 6, "TOP")
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WTREES22_1_SUBQ6_MSG2"), 5)
                SetLifeTime(mon[i], 50)
                EnableAIOutOfPC(mon[i])
                Kill(argObj)
                mon[i].FIXMSPD_BM = 70;
        		InvalidateMSPD(mon[i]);
    		end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
        elseif argObj == nil then
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("WTREES22_1_SUBQ6_MSG1"), 5)
        end
    end
end

function SCR_USE_WTREES22_2_SUBQ2_ITEM1(self, argObj, argstring, arg1, arg2)
    ShowBookItem(self, "WTREES22_2_SUBQ2_ITEM1_MEMO", 1)
end

function SCR_USE_WTREES22_2_SUBQ4_ITEM1(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "")
    local result = DOTIMEACTION_R(self, ScpArgMsg("WTREES22_2_SUBQ5_MSG2"), 'BURY', 2)
    if result == 1 then
        if argObj ~= nil then
            for j = 1, 8 do
                if argObj.Dialog == "WTREES22_2_SUBQ5_NPC"..j then
                    local item = GetInvItemCount(self, "WTREES22_2_SUBQ4_ITEM1")
                    if item >= 1 then
                        count = 1
                    else
                        count = 0
                    end
                    if isHideNPC(self, "WTREES22_2_SUBQ6_FLOWER"..j) == "YES" then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_WTREES22_2_SQ5', "QuestInfoValue1", 1, nil, nil, "WTREES22_2_SUBQ4_ITEM1/"..count, "WTREES22_2_SUBQ6_FLOWER"..j, 0,nil, nil, nil, nil, 'NOTICE_Dm_GetItem/'..ScpArgMsg("WTREES22_2_SUBQ5_MSG1")..'/5')
                        PlayEffect(self, "F_ground068_smoke_white", 1,1, "BOT")
                    end
                    break;
                    --print(j, isHideNPC(self, "WTREES22_2_SUBQ6_FLOWER1"), isHideNPC(self, "WTREES22_2_SUBQ6_FLOWER2"), isHideNPC(self, "WTREES22_2_SUBQ6_FLOWER3"), isHideNPC(self, "WTREES22_2_SUBQ6_FLOWER4"), isHideNPC(self, "WTREES22_2_SUBQ6_FLOWER5"), isHideNPC(self, "WTREES22_2_SUBQ6_FLOWER6"), isHideNPC(self, "WTREES22_2_SUBQ6_FLOWER7"), isHideNPC(self, "WTREES22_2_SUBQ6_FLOWER8"))
                end
            end
        end
    end
end

function SCR_USE_WTREES22_3_SUBQ6_ITEM1(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    if IsBuffApplied(argObj, "WTREES22_3_SUBQ5_BUFF1") == "NO" then
        AddBuff(argObj, argObj, "WTREES22_3_SUBQ5_BUFF1", 1, 0, 0, 1)
        local result = DOTIMEACTION_R(self, ScpArgMsg("WTREES22_3_SUBQ5_MSG2"), 'ABSORB', 1)
        if result == 1 then
            local ran = IMCRandom(20, 50)
            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_WTREES22_3_SQ5', "QuestInfoValue1", ran, nil, nil, nil, nil, nil,nil, nil, nil, nil, 'NOTICE_Dm_Clear/'..ScpArgMsg("WTREES22_3_SUBQ5_MSG1")..'/5')
            PlayEffect(argObj, "F_light013", 2.6, 1, "MID")
            RemoveBuff(argObj, "WTREES22_3_SUBQ5_BUFF1")
            Kill(argObj)
        else
            RemoveBuff(argObj, "WTREES22_3_SUBQ5_BUFF1")
        end
    end
end


function SCR_USE_E_Balloon(self, argObj, argstring, arg1, arg2)
    local balloon = 'artefact_balloon_'..argstring
    local node = 'Dummy_balloon';
    AttachBalloon(self, balloon, node)
end


--3CMLAKE_SQ11_ITEM
function SCR_USE_3CMLAKE261_SQ11_ITEM(self, argObj, argstring, arg1, arg2)
    local result1 = SCR_QUEST_CHECK(self, 'F_3CMLAKE261_SQ11')
    if result1 == 'PROGRESS' then
        local list, cnt = SelectObject(self, 30, 'ALL')
        if cnt ~= 0 then
            for i = 1, cnt do
                if list[i].ClassName == 'cart_spp_3cm' then
                    if IsDead(list[i]) == 0 then  
                        if GetZoneName(self) == 'f_3cmlake_26_1' then
                            if GetLayer(self) == 0 then
                                AttachEffect(list[i], 'F_drop_water001_alpha', 1, 'MID')
                                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 2, 'F_3CMLAKE261_SQ11')
                                local result2 = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE261_SQ11_MSG01"), 'FIRE', animTime, 'SSN_HATE_AROUND') 
                                DOTIMEACTION_R_AFTER(self, result2, animTime, before_time, 'F_3CMLAKE261_SQ11')
                                if result2 == 1 then
                                    AttachEffect(list[i], 'F_burstup036_fire2',3,'BOT')
                                    SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("F_3CMLAKE261_SQ11_MSG02"), 5)
                                    SCR_PARTY_QUESTPROP_ADD(self,'SSN_F_3CMLAKE261_SQ11', 'QuestInfoValue1',1,nil, nil, "3CMLAKE261_SQ09_ITEM/1/3CMLAKE261_SQ11_ITEM/1")
                                    sleep(3000)
                                    Dead(list[i])
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


--3CMLAKE261_SQ10_ITEM
function SCR_USE_3CMLAKE261_SQ10_ITEM01(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE261_SQ10')
    if result == "PROGRESS" then
        local list, cnt = SelectObject(self, 30, 'ALL')
        if cnt ~= 0 then
            for i = 1, cnt do
                if list[i].ClassName == "HiddenTrigger6" then
                    if IsDead(list[i]) == 0 then
                        if GetZoneName(self) == 'f_3cmlake_26_1' then
                            if GetLayer(self) == 0 then
                                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 3, 'F_3CMLAKE261_SQ10')
                                local result2 = DOTIMEACTION_R(self, ScpArgMsg("F_3CMLAKE261_SQ10_MSG02"), 'WRITE', animTime, 'SSN_HATE_AROUND') 
                                DOTIMEACTION_R_AFTER(self, result2, animTime, before_time, 'F_3CMLAKE261_SQ10')
                                if result2 == 1 then
                                    SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("F_3CMLAKE261_SQ10_MSG03"), 5)
                                    SCR_PARTY_QUESTPROP_ADD(self,'SSN_F_3CMLAKE261_SQ10','QuestInfoValue1',1, nil, "3CMLAKE261_SQ10_ITEM02/1", "3CMLAKE261_SQ10_ITEM01/1")
                                    Kill(list[i])
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


--3CMLAKE262_SQ10_ITEM02 (USE_SQ11)
function SCR_USE_3CMLAKE262_SQ10_ITEM02(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE262_SQ11')
    if result == "PROGRESS" then
        if GetZoneName(self) == 'f_3cmlake_26_2' then
            if GetLayer(self) == 0 then
                local list, cnt = GetWorldObjectList(self, 'MON', 100)
                if cnt ~= 0 then
                    for i = 1, cnt do
                        if list[i].ClassName == "lakegolem" or list[i].ClassName == "pondus" or list[i].ClassName == "anchor_golem" then
                            if IsBuffApplied(list[i], '3CMLAKE262_SQ11_BUFF') == 'NO' then
                                LookAt(self, list[i])
                                PlayAnim(self, "EVENT_HOLY")
                                SetExArgObject(list[i], "3CM_TARGET", self)
                                AddBuff(self, list[i], '3CMLAKE262_SQ11_BUFF', 1, 0, 60000, 1)
                                SetDeadScript(list[i], "SCR_3CMLAKE262_SQ11_CHECK")
                                SetExArgObject(list[i], "3CM_TARGET", self)
                                SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("F_3CMLAKE262_SQ11_MSG01"), 5)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

function SCR_USE_ABBEY22_4_SUBQ3_ITEM1(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    local result = DOTIMEACTION_R(self, ScpArgMsg("ABBEY22_4_SUBQ3_MSG1"), 'FLASK', 1)
    if result == 1 then
        if IsBuffApplied(argObj, "ABBEY22_4_SUBQ4_BUFF") == "NO" then
            AddBuff(self, argObj, "ABBEY22_4_SUBQ4_BUFF", 1, 0, 10000, 1)
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ABBEY22_4_SUBQ3_MSG2"), 5)
        else
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ABBEY22_4_SUBQ3_MSG3"), 5)
        end
    end
end

function SCR_UES_ABBEY22_5_SUBQ3_ITEM1(self, argObj, argstring, arg1, arg2)
    local result = DOTIMEACTION_R(self, ScpArgMsg("ABBEY22_5_SUBQ2_MSG1"), 'ABSORB', 0.5)
    if result == 1 then
        if IsBuffApplied(argObj, "ABBEY22_5_SUBQ2_BUFF") == "NO" then
            AddBuff(self, argObj, "ABBEY22_5_SUBQ2_BUFF", 1, 0, 0, 1)
            local x, y, z = GetPos(argObj)
            local mon = CREATE_NPC_EX(self, "Hiddennpc_move", x, y, z, 0, "Neutral", "UnvisibleName", self.Lv, ABBEY22_5_SUBQ3_SET)
            AttachEffect(mon, "I_light004_violet2", 2, 1, "MID", 1)
            AddScpObjectList(mon, 'ABBEY22_5_SUBQ2_OBJ', self)
            AddVisiblePC(mon, self, 1)
            EnableAIOutOfPC(mon)
            SetLifeTime(mon, 10)
            mon.FIXMSPD_BM = 70;
    		InvalidateMSPD(mon);
    		SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ABBEY22_5_SUBQ2_MSG3"), 5)
            Kill(argObj)
        else
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ABBEY22_5_SUBQ2_MSG4"), 5)
        end
    else
        RemoveBuff(argObj, "ABBEY22_5_SUBQ2_BUFF")
    end
end

function ABBEY22_5_SUBQ3_SET(mon)
    mon.BTree = "None"
    mon.Tactics = "None"
    mon.Dialog = "ABBEY22_5_SUBQ3_OBJ_DLG"
    mon.SimpleAI = "ABBEY22_5_SUBQ3_AI"
end

function SCR_USE_ABBEY22_5_SUBQ5_ITEM2(self, argObj, argstring, arg1, arg2)
    if GetLayer(self) >= 0  then
	    if GetZoneName(self) == 'd_abbey_22_5' then
            local buff1 = GetBuffByName(self, 'ABBEY22_5_SUBQ5_BUFF')
            if buff1 == nil then
                AddBuff(self, self, 'ABBEY22_5_SUBQ5_BUFF', 1, 0, 0, 1) 
                local x, y, z = GetPos(self)
                local mon1 = CREATE_MONSTER_EX(self, 'npc_boss_kinghammer', x, y, z, 0, 'Neutral', 1, SCR_ABBEY22_5_SUBQ5_SET);
                           --CREATE_MONSTER_EX(self, 'npc_Socket_mage_red', x, y, z, 0, 'Neutral', 1, SCR_PRISON_80_MQ_2_SET);
                PlayEffectLocal(self, self, 'F_smoke124_violet1', 0.8, nil, 'BOT')
                AttachEffect(mon1, 'F_smoke011_blue', 3.0, 'MID')
                AddVisiblePC(mon1, self, 1);
                AddScpObjectList(mon1, 'ABBEY22_5_SUBQ5_SCPPC', self)
                AddScpObjectList(self, 'ABBEY22_5_SUBQ5_SCPOBJ', mon1)
                SetOwner(mon1, self, 1)
                ObjectColorBlend(mon1, 150.0, 150.0, 150.0, 150.0, 1)
                AttachToObject(mon1, self, 'None', 'None', 1)
                EnableAIOutOfPC(mon1)
                SetNoDamage(mon1, 1);
            end
        end
    end
end

function SCR_ABBEY22_5_SUBQ5_SET(mon)
	mon.BTree = 'None';
	mon.Tactics = 'ABBEY22_5_SUBQ5_TACTICS';
    mon.SimpleAI = 'None';
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "None"
	mon.TargetMark = 0;
	mon.TargetWindow = 0;
end

function SCR_ABBEY22_5_SUBQ5_TACTICS_TS_BORN_ENTER(self)
    SCR_MON_DUMMY_TS_BORN_ENTER(self)
end

function SCR_ABBEY22_5_SUBQ5_TACTICS_TS_BORN_UPDATE(self)
    local _pc = GetScpObjectList(self, 'ABBEY22_5_SUBQ5_SCPPC')
    if #_pc == 0 then
        Kill(self);
    else
        if IsMoving(_pc[1]) == 1 then
            PlayAnim(self, "run")
        else
            PlayAnim(self, "idle")
        end
        local x, y, z = GetFrontPos(_pc[1], 30)
        SetDirectionToPos(self, x, z)
--        local angle = GetAngleFromPos(_pc[1], x, z)
--        SetDirectionByAngle(self, angle)
    end
end

function SCR_ABBEY22_5_SUBQ5_TACTICS_TS_BORN_LEAVE(self)
    SCR_MON_DUMMY_TS_BORN_LEAVE(self)
end

function SCR_ABBEY22_5_SUBQ5_TACTICS_TS_DEAD_ENTER(self)
    SCR_MON_DUMMY_TS_DEAD_ENTER(self)
end

function SCR_ABBEY22_5_SUBQ5_TACTICS_TS_DEAD_UPDATE(self)
    SCR_MON_DUMMY_TS_DEAD_UPDATE(self)
end

function SCR_ABBEY22_5_SUBQ5_TACTICS_TS_DEAD_LEAVE(self)
    SCR_MON_DUMMY_TS_DEAD_LEAVE(self)
end

--ABBEY22_5_SUBQ9_ITEM2
function SCR_USE_ABBEY22_5_SUBQ9_ITEM2(self, argObj, argstring, arg1, arg2)
    print("SCR_USE_ABBEY22_5_SUBQ9_ITEM2")
    local result = DOTIMEACTION_R(self, ScpArgMsg("ABBEY22_5_SUBQ10_MSG1"), 'ABSORB', 0.5)
    local Harugal_cnt = 0
    if result == 1 then
        local mon_list, mon_cnt = SelectObject(self, 150, "ENEMY")
        if mon_cnt >= 1 then
            for i = 1 , mon_cnt do
                if mon_list[i].ClassName ~= "PC" then
                    if  mon_list[i].Dialog == "ABBEY225_SUBQ9_HARUGAL" then
                        if mon_list[i].Faction == "Monster"then
                            --if IsBuffApplied(mon_list[i], "ABBEY22_5_SUBQ10_BUFF1") == "YES" then
                            if IsBuffApplied(mon_list[i], "ABBEY22_5_SUBQ10_BUFF2") == "NO" then
                                AddBuff(self, mon_list[i], "ABBEY22_5_SUBQ10_BUFF2", 1, 0, 20000, 1)
                                Harugal_cnt = Harugal_cnt + 1
                            else
                                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ABBEY22_5_SUBQ10_MSG6"), 5)
                            end
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ABBEY22_5_SUBQ10_MSG6"), 5)
                        end
                    else
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ABBEY22_5_SUBQ10_MSG6"), 5)
                    end
                end
            end
        else
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ABBEY22_5_SUBQ10_MSG6"), 5)
        end
        if Harugal_cnt >= 1 then
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ABBEY22_5_SUBQ10_MSG2"), 5)
        end
    end
end

--ABBEY22_5_SUBQ7_ITEM1
function SCR_USE_ABBEY22_5_SUBQ7_ITEM1(self, argObj, argstring, arg1, arg2)
    print("SCR_USE_ABBEY22_5_SUBQ7_ITEM1")
    local quest = SCR_QUEST_CHECK(self, "ABBEY22_5_SQ10")
    if quest == "PROGRESS" then
        if IsBuffApplied(argObj, "ABBEY22_5_SUBQ10_BUFF2") == "YES" then
            if argObj.Faction == "Monster" then
                if GetHpPercent(argObj) <= 0.3 then
                    if IsBuffApplied(self, "ABBEY22_5_SUBQ10_BUFF1") == "NO" then
                        local result = DOTIMEACTION_R(self, ScpArgMsg("ABBEY22_5_SUBQ10_MSG3"), 'ABSORB', 0.7)
                        if result == 1 then
                            SetCurrentFaction(argObj, "Neutral")
                            SkillCancel(argObj);
                            ClearBTree(argObj);
                            SetNoDamage(argObj, 1)
                --            print(self.SimpleAI)
                --            self.SimpleAI = "ABBEY22_5_SUBQ10_AI"
                            MoveEx(argObj, -602, 95, -18, 1)
                            AddBuff(argObj, argObj, "ABBEY22_5_SUBQ10_BUFF1", 1, 0, 5000, 1)
                            SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ABBEY22_5_SQ10', "QuestInfoValue1", 1, nil, nil, nil, nil, nil,nil, nil, nil, nil, 'NOTICE_Dm_scroll/'..ScpArgMsg("ABBEY22_5_SUBQ10_MSG4")..'/5')
                        end
                    end
                else
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ABBEY22_5_SUBQ10_ITEM_MSG1"), 5)
                end
            end
        end
    end
end

--CHAR318_MSTEP3_3ITEM2
function SCR_USE_CHAR318_MSTEP3_3ITEM2(self, argObj, argstring, arg1, arg2)
    if IsBuffApplied(self, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "NO" then
        local anim = DOTIMEACTION_R(self, ScpArgMsg("CHAR318_MSETP3_3_ACTION2"), 'ABSORB', 0.7)
        if anim == 1 then
            AddBuff(self, self, "CHAR318_MSETP3_3_EFFECT_BUFF1", 1, 0, 0, 1)
        end
    else
        local anim = DOTIMEACTION_R(self, ScpArgMsg("CHAR318_MSETP3_3_ACTION3"), 'ABSORB', 0.7);
        if anim == 1 then
            RemoveBuff(self, "CHAR318_MSETP3_3_EFFECT_BUFF1")
            DetachEffect(self, "I_circle001");
        end
    end
end

--CORAL_44_3_SQ_90_ITEM
function SCR_USE_CORAL_44_3_SQ_90_ITEM(self, argObj, argstring, arg1, arg2)
    LookAt(self, argObj)
    if IsDead(argObj) == 0 then
        local result = DOTIMEACTION_R(self, ScpArgMsg("CORAL_44_3_SQ_90_ITEM_MSG1"), 'EVENT_HOLY', 1)
        if result == 1 then
            if IsDead(argObj) == 0 then
                Kill(argObj)
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CORAL_44_3_SQ_90', 'QuestInfoValue1', 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_Clear/'..ScpArgMsg("CORAL_44_3_SQ_90_ITEM_MSG2")..'/5')
            else
                SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('F_CORAL_44_3_ALREADY_PURITY'), 3)
            end
        end
    else
        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('F_CORAL_44_3_ALREADY_PURITY'), 3)
    end
end


--JOB_MATADOR1_ITEM
function SCR_USE_JOB_MATADOR1_ITEM(self, argObj, argstring, arg1, arg2)
    local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_MATADOR1_ITEM_MSG1"), 'SKL_CAPOTE', 0.8)
    if result == 1 then
        PlayAnim(self, "ASTD")
        AddBuff(self, argObj, "JOB_MATADOR1_ITEM_BUFF1", 1, 0, 25000, 1)
        argObj.StrArg1 = "JOB_MATADOR_QMONSTER"
        local bt = CreateBTree("Job_matador_mon_Btree")
	    SetBTree(argObj, bt)
        SetCurrentFaction(argObj, "Monster")
        SetTendency(argObj, 'Attack')
        InsertHate(argObj, self, 100)
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_MATADOR1_ITEM_MSG2"), 5)
   end
end

--JOB_ZEALOT_QUEST_COSTUME_ITEM
function SCR_USE_JOB_ZEALOT_QUEST_COSTUME_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'JOB_ZEALOT_QUEST_COSTUME')
    local sObj = GetSessionObject(self, 'SSN_JOB_ZEALOT_QUEST_COSTUME')
    if result == "PROGRESS" then
        if GetZoneName(self) == "id_catacomb_25_4" then
            if GetLayer(self) ~= 0 then
                local x = -1893
                local y = -121
                local z = -11
                if sObj.Step1 == 0 then
                    local result1, result2 = SCR_STEPREWARD_QUEST_REMAINING_CHECK(self, 'JOB_ZEALOT_QUEST_COSTUME')
                    local cnt = 0
                    if #result2 ~= 0 then
                        local seltext_list = { seltext1, seltext2, seltext3 }
                        for i = 1, #result2 do
                            seltext_list[result2[i]] = ScpArgMsg('JOB_ZEALOT_QUEST_COSTUME_MSG'..result2[i])
                        end
                        local select1 = ShowSelDlg(self, 0, 'JOB_ZEALOT_QUEST_COSTUME_DLG1', seltext_list[1], seltext_list[2], seltext_list[3])
                        if select1 == 1 then
                            SCR_ZEALOT_QUEST_SETTING(self, sObj, 0, -1893, -121, -11, 1)
                        elseif select1 == 2 then
                            SCR_ZEALOT_QUEST_SETTING(self, sObj, 2, -1893, -121, -11, 2)
                        elseif select1 == 3 then
                            SCR_ZEALOT_QUEST_SETTING(self, sObj, 4, -1893, -121, -11, 3)
                        end
                    end
                elseif sObj.Step1 == 1 or sObj.Step1 == 2 then
                    SCR_ZEALOT_QUEST_POS(self, sObj, sObj.Step3, x, z)
                elseif sObj.Step1 == 3 then
                    RunScript('ABANDON_Q_BY_NAME', self, sObj.QuestName, 'FAIL')
                end
            end
        end
    end
end

--CHAR120_HOSHINBOO_ITEM
function SCR_USE_CHAR120_HOSHINBOO_ITEM(self, argObj, argstring, arg1, arg2)
    local result = DOTIMEACTION_R(self, ScpArgMsg("CHAR120_HOSHINBOO_ITEM_USE"), 'ABSORB', 1)
    if GetLayer(self) < 1 then
        if result == 1 then
            local map_name = GetZoneName(self)
            local map1 = GetClass("Map", map_name)
            local map2 = GetClass("Map", "f_gele_57_4")
            
            print(map1.WorldMap.." / "..map2.WorldMap)
            local pos1 = SCR_STRING_CUT(map1.WorldMap)
            local pos2 = SCR_STRING_CUT(map2.WorldMap)
            local x_Distance, y_Distance, z_Distance, total_Distance 
            for i = 1, 3 do
                if i == 1 then
                    x_Distance = math.abs(tonumber(pos1[i])-tonumber(pos2[i]))
                elseif i == 2 then
                    y_Distance = math.abs(tonumber(pos1[i])-tonumber(pos2[i]))
                 elseif i == 3 then
                    z_Distance = math.abs(tonumber(pos1[i])-tonumber(pos2[i]))
                end
--                print(pos1[i].." / "..pos2[i])
            end
            
            total_Distance = x_Distance + y_Distance
--            print("total_Distanc : "..total_Distance, "x_Distance : "..x_Distance, "y_Distance : "..y_Distance)
--            if z_Distance > 0 then
--                ShowBalloonText(self, "PILGRIM_48_SQ_060_TILL_SPOT_01", 5)
--                return
--            end
            if total_Distance == 0 then
                ShowBalloonText(self, "HOSHINBOO_ITEM_MSG1", 5)
                --PlayEffect(self)
            elseif total_Distance <= 3 then
                ShowBalloonText(self, "HOSHINBOO_ITEM_MSG2", 5)
                --PlayEffect(self)
            elseif total_Distance <= 10 then
                ShowBalloonText(self, "HOSHINBOO_ITEM_MSG3", 5)
                --PlayEffect(self)
            elseif total_Distance <= 25 then
                ShowBalloonText(self, "HOSHINBOO_ITEM_MSG4", 5)
                --PlayEffect(self)
            else
                ShowBalloonText(self, "HOSHINBOO_ITEM_MSG5", 5)
                --PlayEffect(self)
            end
        end
    end
end


--CHAR120_MSTEP5_4_ITEM3
function SCR_USE_CHAR120_MSTEP5_4_ITEM3(self, argObj, argstring, arg1, arg2)
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(self, "Char1_20")
    local sObj = GetSessionObject(self, "SSN_NAKMUAY_UNLOCK")
    if hidden_Prop == 100 then
        if sObj ~= nil then
            --sObj.Step5 is Dandelion IMPLANT count
            --sObj.Step5 = sObj.Step5 + 1
            
            --sObj.Goal5~7 is A Dandelion IMPLANT Check
            if sObj.Step4 < 2 then
                for i = 1, 3 do
                    if sObj["Goal"..i+4] < 1 then
                    local result = DOTIMEACTION_R(self, ScpArgMsg("CHAR120_MSTEP5_4_ITEM3_USE"), 'bury', 1)
                        if result == 1 then
                            local now_time = os.date('*t')
                            local year = now_time['year']
                            local month = now_time['month']
                            local day = now_time['day']
                            local hour = now_time['hour']
                            local min = now_time['min']
                            local _now_tiem = tostring(year..month..day).."/"..tostring(hour * 60) + tostring(min)
                            
                            local pos_X, pos_Y, pos_Z = GetPos(self)
                            sObj["Goal"..i+4] = 1
                            sObj["String"..i] = _now_tiem
                            sObj["String"..i+3] = pos_X.."/"..pos_Y.."/"..pos_Z
                            RunScript("TAKE_ITEM_TX", self, "CHAR120_MSTEP5_4_ITEM3", 1, "Quest_HIDDEN_NAKMUAY")
                            SaveSessionObject(self, sObj)
                            break
                        end
                    end
                end
            else
                ShowBalloonText(self, "ROKAS_36_1_SQ_030_MSG01_SILVER", 5)
            end
        end
    end
end

--SCR_USE_CHAR120_MSTEP5_5_ITEM1
function SCR_USE_CHAR120_MSTEP5_5_ITEM1(self, argObj, argstring, arg1, arg2)
    local item_Cnt = GetInvItemCount(self, "CHAR120_MSTEP5_5_ITEM2")
    if item_Cnt < 1 then
        local result = DOTIMEACTION_R(self, ScpArgMsg("CHAR120_MSTEP5_5_ITEM1_OPEN"), 'SITGROPE2_LOOP', 1)
        if result == 1 then
            ShowBalloonText(self, "CHAR120_MSTEP5_5_ITEM1_BOXOPEN", 5)
            RunScript("GIVE_ITEM_TX", self, "CHAR120_MSTEP5_5_ITEM2", 1, "Quest_HIDDEN_NAKMUAY")
        end
    else
        ShowBalloonText(self, "CHAR120_MSTEP5_5_ITEM1_BOXOPEN2", 5)
    end
end

function SCR_USE_CHAR120_MSTEP5_5_ITEM2(self, argObj, argstring, arg1, arg2)
    if isHideNPC(self, "CHAR120_MSTEP5_5_NPC1") == "YES" then
        UnHideNPC(self, "CHAR120_MSTEP5_5_NPC1")
    end
    ShowBookItem(self, "CHAR120_MSTEP5_5_ITEM2_LETTER");
    --ShowBalloonText(self, "CHAR120_MSTEP5_5_ITEM1_LETTER_AFTER", 4)
end

--SCR_USE_CHAR121_MSTEP2_ITEM1
function SCR_USE_CHAR121_MSTEP2_ITEM1(self, argObj, argstring, arg1, arg2)
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(self, "Char1_18")
    if hidden_Prop == 100 then
        local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
        if sObj ~= nil then
            local result = DOTIMEACTION_R(self, ScpArgMsg("CHAR121_MSTEP2_ITEM1_EAT"), 'FOODTABLE_EATSOUP', 1)
            if result == 1 then
                local eat_buff = IsBuffApplied(self, 'CHAR118_MSTEP2_ITEM1_BUFF1');
                if eat_buff == "NO" then
                    AddBuff(self, self,'CHAR118_MSTEP2_ITEM1_BUFF1', 1, 0, 180000, 1)
                end
            end
        end
    end
end

--SCR_USE_CHAR118_MSTEP2_ITEM2
function SCR_USE_CHAR118_MSTEP2_ITEM2(self, argObj, argstring, arg1, arg2)
--Goal1 is traning Goal Count(muscular strength) max count : 40
--Goal2 is traning Goal Count(endurande) max count : 15
--Goal3 is traning Goal Count(agility) max count : 40
--Goal5 is traning Goal Count(simulation) max count : 40

--Step1 is traning stamina

    local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
    if sObj ~= nil then
        muscular_P = sObj.Goal1
        endurande_P = sObj.Goal2
        agility_P = sObj.Goal3
        simulation_P = sObj.Goal5
        stamina_P = sObj.Step1
        if muscular_P < 25 or endurande_P < 3 or agility_P < 20 or simulation_P < 20 then
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR121_MSTEP2_ITEM2_MSG1", "muscular", muscular_P, "endurande", endurande_P, "agility", agility_P, "simulation", simulation_P, "stamina", stamina_P), 15)
        elseif muscular_P >= 25 and endurande_P >= 3 and agility_P >= 20 and simulation_P >= 20 then
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR121_MSTEP2_ITEM2_MSG2", "muscular", muscular_P, "endurande", endurande_P, "agility", agility_P, "simulation", simulation_P), 10)
        end
    end
end

--SCR_USE_CHAR118_MSTEP2_1_ITEM1
function SCR_USE_CHAR118_MSTEP2_1_ITEM1(self, argObj, argstring, arg1, arg2)
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(self, "Char1_18")
    if hidden_Prop == 100 then
        local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
        if sObj ~= nil then
            local training_Stamina = sObj.Step1
            local training_Count = sObj.Step2
            local discount
            
            if training_Count == 1 then
                discount = 5
            elseif training_Count == 2 then
                discount = 4
            elseif training_Count == 3 then
                discount = 3
            elseif training_Count == 4 then
                discount = 2
            elseif training_Count >= 5 then
                discount = 1
            end
            
            if (training_Stamina == 0) or (training_Stamina < discount) then
                if GetInvItemCount(self, "CHAR118_MSTEP2_ITEM1") < 1 then
                SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg('RETIARII_STAMINA_NOT_ENOUGH'), 5)
            else
                    SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg('RETIARII_STAMINA_NOT_ENOUGH2'), 5)
                end
            else
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(self, 3, 'MAPLE23_2_SQ04')
                local result = DOTIMEACTION_R_DUMMY_ITEM(self, ScpArgMsg("CHAR118_MSTEP2_1_ITEM1_TRAINING"), 'SKL_ASSISTATTACK_DUMBELL',3, 'SSN_HATE_AROUND', nil, 630014, "RH")
            if result == 1 then
                    RETIARII_TRAINING_FUNC(self, "Step1", "Step2", "Goal1", 25)
                end
            end
        end
    end
end

--SCR_USE_CHAR118_MSTEP2_2_ITEM1
function SCR_USE_CHAR118_MSTEP2_2_ITEM1(self, argObj, argstring, arg1, arg2)
    local ridingCompanion = GetRidingCompanion(self);
    local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
    local posX, posZ, posY = GetPos(self)
    if ridingCompanion == nil then
    if sObj ~= nil then
        local training_Stamina = sObj.Step1
        local training_Count = sObj.Step2
        local discount
        
        if training_Count == 1 then
            discount = 5
        elseif training_Count == 2 then
            discount = 4
        elseif training_Count == 3 then
            discount = 3
        elseif training_Count == 4 then
            discount = 2
        elseif training_Count >= 5 then
            discount = 1
        end
        
        if (training_Stamina == 0) or (training_Stamina < discount) then
            if GetInvItemCount(self, "CHAR118_MSTEP2_ITEM1") < 1 then
            SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg('RETIARII_STAMINA_NOT_ENOUGH'), 5)
        else
                SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg('RETIARII_STAMINA_NOT_ENOUGH2'), 5)
            end
        else
        local goal_point = sObj.Goal2
            if goal_point < 3 then
                if IsBuffApplied(self, "CHAR118_MSTEP2_2_ITEM1_BUFF1") == "NO" then
    local master_Dis = SCR_POINT_DISTANCE(posX, posY, -1312, -341)
    if master_Dis < 60 then
        local result = DOTIMEACTION_R(self, ScpArgMsg("CHAR118_MSTEP2_2_ITEM1_USE"), 'bury', 1)
        if result == 1 then
            if IsBuffApplied(self, "CHAR118_MSTEP2_2_ITEM1_BUFF1") == "NO" then
                if sObj ~= nil then
                    AddBuff(self, self,'CHAR118_MSTEP2_2_ITEM1_BUFF1', 1, 0, 0, 1)
                                local goal_group = IMCRandom(1, 3)
                    sObj.Step7 = goal_group
                    sObj.Step6 = 1
                    for i = 1, 3 do
                        if isHideNPC(self, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i) == "YES" then
                            UnHideNPC(self, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i)
                                        --Chat(self, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i, 1)
                                    end
                                end
                                if goal_group == 1 then
                                    TreasureMarkByMap(self, 'f_farm_47_1', -1134, 40, -1152)
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR118_MSTEP2_2_STARTLINE1"), 7)
                                elseif goal_group == 2 then
                                    TreasureMarkByMap(self, 'f_farm_47_1', -1244, 6, 578)
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR118_MSTEP2_2_STARTLINE2"), 7)
                                elseif goal_group == 3 then
                                    TreasureMarkByMap(self, 'f_farm_47_1', -1134, 40, -1152)
                                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR118_MSTEP2_2_STARTLINE1"), 7)
                                end
                                SaveSessionObject(self, sObj)
                        end
                    end
                    end
                else
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR118_MSTEP2_2_ITEM1_FAR_MSG"), 6)
                end
                elseif IsBuffApplied(self, "CHAR118_MSTEP2_2_ITEM1_BUFF1") == "YES" then
                    local result = DOTIMEACTION_R(self, ScpArgMsg("CHAR118_MSTEP2_2_ITEM1_REMOVE_MSG1"), 'bury', 1)
                    if result == 1 then
                        RemoveBuff(self, "CHAR118_MSTEP2_2_ITEM1_BUFF1")
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR118_MSTEP2_2_ITEM1_REMOVE_MSG2"), 6)
                    end
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("RETIARII_TRAINING_SUCC2"), 6)
            end
        end
    end
    else
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("RETIARII_TRAINING_COMPANION_NOT"), 6)
    end
end


--SCR_USE_CHAR118_MSTEP2_2_ITEM2
function SCR_USE_CHAR118_MSTEP2_2_ITEM2(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal2 < 50 then
            if IsBuffApplied(self, "CHAR118_MSTEP2_2_ITEM1_BUFF1") == "YES" then
                local goal_Group = sObj.Step7
                local goal_Point = sObj.Step6
                if goal_Group == 1 then
                    if goal_Point == 1 then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR118_MSTEP2_2_STARTLINE1"), 7)
                        TreasureMarkByMap(self, 'f_farm_47_1', -1134, 40, -1152)
                    elseif goal_Point == 2 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_GOALPOINT2_2"), 6)
                        TreasureMarkByMap(self, 'f_farm_47_1', 98, -41, -386)
                    elseif goal_Point == 3 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_ITEM1_RETURNTOMASTER"), 6)
                        TreasureMarkByMap(self, 'f_farm_47_1', -1273, -41, -325)
                    end
                elseif goal_Group == 2 then
                    if goal_Point == 1 then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR118_MSTEP2_2_STARTLINE2"), 7)
                        TreasureMarkByMap(self, 'f_farm_47_1', -1244, 6, 578)
                    elseif goal_Point == 2 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_GOALPOINT2_2"), 6)
                        TreasureMarkByMap(self, 'f_farm_47_1', 98, -41, -386)
                    elseif goal_Point == 3 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_ITEM1_RETURNTOMASTER"), 6)
                        TreasureMarkByMap(self, 'f_farm_47_1', -1273, -41, -325)
                    end
                elseif goal_Group == 3 then
                    if goal_Point == 1 then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR118_MSTEP2_2_STARTLINE1"), 7)
                        TreasureMarkByMap(self, 'f_farm_47_1', -1134, 40, -1152)
                    elseif goal_Point == 2 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_GOALPOINT1_2"), 6)
                        TreasureMarkByMap(self, 'f_farm_47_1', 367, 57, -1124)
                    elseif goal_Point == 3 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_ITEM1_RETURNTOMASTER"), 6)
                        TreasureMarkByMap(self, 'f_farm_47_1', -1273, -41, -325)
                    end
                end
            else
                SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_MAPMSG1"), 10)
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("RETIARII_TRAINING_SUCC2"), 10)
        end
    end
end

--JOB_ONMYOJI_ITEM
function SCR_USE_JOB_ONMYOJI_MSTEP1_ITEM1(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        local text1 = ScpArgMsg('CHAR220_MSETP1_ITEM_TXT1')
        local text2 = ScpArgMsg('CHAR220_MSETP1_ITEM_TXT1')
        local text3 = ScpArgMsg('CHAR220_MSETP1_ITEM_TXT2')
        local text4 = ScpArgMsg('CHAR220_MSETP1_ITEM_TXT2')
        local text5 = ScpArgMsg('CHAR220_MSETP1_ITEM_TXT3')
        local text6 = ScpArgMsg('CHAR220_MSETP1_ITEM_TXT4')
        local text7 = ScpArgMsg('CHAR220_MSETP1_ITEM_TXT5')
        local text8 = ScpArgMsg('CHAR220_MSETP1_ITEM_TXT6')
        local text9 = ScpArgMsg('CHAR220_MSETP1_ITEM_TXT7')
        local dlg1 = 'CHAR220_MSETP1_ITEM_DLG1_1'
        local dlg2 = 'CHAR220_MSETP1_ITEM_DLG1_2'
        local dlg3 = 'CHAR220_MSETP1_ITEM_DLG2_1'
        local dlg4 = 'CHAR220_MSETP1_ITEM_DLG2_2'
        local dlg5 = 'CHAR220_MSETP1_ITEM_DLG3'
        local dlg6 = 'CHAR220_MSETP1_ITEM_DLG4'
        local dlg7 = 'CHAR220_MSETP1_ITEM_DLG5'
        local dlg8 = 'CHAR220_MSETP1_ITEM_DLG6'
        local dlg9 = 'CHAR220_MSETP1_ITEM_DLG7'
        local textList = {text1, text2, text3, text4, text5, text6, text7, text8, text9}
        local dlgList = {dlg1, dlg2, dlg3, dlg4, dlg5, dlg6, dlg7, dlg8, dlg9}
        local sel_textList = {}
        local sel_dlgList = {}
        local complete_check = 0
        for i = 1, 9 do
            if sObj['Step'..i] == 1 then
                if i == 9 then
                    if sObj['Goal'..i] == 100 then
                        sel_textList[#sel_textList+1] = textList[i].." [ v ]"
                        complete_check = complete_check + 1
                    else
                        sel_textList[#sel_textList+1] = textList[i].." [   ]"
                    end
                elseif i == 6 then
                    if sObj['Goal'..i] == 1000 then
                        sel_textList[#sel_textList+1] = textList[i].." [ v ]"
                        complete_check = complete_check + 1
                    else
                        sel_textList[#sel_textList+1] = textList[i].." [   ]"
                    end
                else
                    if sObj['Goal'..i] == 10 then
                        sel_textList[#sel_textList+1] = textList[i].." [ v ]"
                        complete_check = complete_check + 1
                    else
                        sel_textList[#sel_textList+1] = textList[i].." [   ]"
                    end
                end
                sel_dlgList[#sel_dlgList+1] = dlgList[i]
            end
        end
        if complete_check == 2 then
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_COMPLETE"), 5)
        end
        local select = ShowSelDlgDirect(self, 0,'CHAR220_MSETP1_ITEM', sel_textList[1], sel_textList[2], ScpArgMsg('CHAR220_MSETP1_ITEM_CANCLE'))
        if select == 1 then
            ShowOkDlg(self, sel_dlgList[select], 1)
        elseif select == 2 then
            ShowOkDlg(self, sel_dlgList[select], 1)
        end
    end
end

function SCR_USE_JOB_ONMYOJI_MSTEP2_1_1_ITEM1(self, argObj, argstring, arg1, arg2)
    local max_cnt = 80
    local trade_cnt = 3
    if GetInvItemCount(self, "CHAR220_MSTEP2_1_1_ITEM2") < max_cnt then
        if GetInvItemCount(self, "CHAR220_MSTEP2_1_1_ITEM1") >= trade_cnt then
            local inv_item1 = GetInvItemCount(self, "CHAR220_MSTEP2_1_1_ITEM1")
            local inv_item2 = GetInvItemCount(self, "CHAR220_MSTEP2_1_1_ITEM2")
            local take_item = 'CHAR220_MSTEP2_1_1_ITEM1'
            local give_item = 'CHAR220_MSTEP2_1_1_ITEM2'
            local take_cnt = inv_item1 - (inv_item1%trade_cnt)
            local give_cnt_pre = math.floor(inv_item1/trade_cnt)
            local give_cnt = 0
            for i = 1, give_cnt_pre do
                local ran = IMCRandom(1, 2)
                give_cnt = give_cnt + ran
            end
            local charge_time = math.floor((inv_item1-1)*0.2)
            local time = 1 + charge_time
            if inv_item1 >= max_cnt then
                time = 30
            end
            local result = DOTIMEACTION_R(self, ScpArgMsg("CHAR220_MSETP2_1_1_MSG1"), "MAKING", time)
            if result == 1 then
                RunScript('TAKE_ITEM_TX', self, take_item, take_cnt, "CHAR220_MSTEP2_1_1");
                RunScript('GIVE_ITEM_TX', self, give_item, give_cnt, "CHAR220_MSTEP2_1_1");
                PlayEffectLocal(self, self, "F_light028_violet1", 1, 1, "TOP")
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_1_1_MSG4{cnt1}{cnt2}", "cnt1", take_cnt, "cnt2", give_cnt), 7)
            end
        else
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR220_MSETP2_1_1_MSG2{cnt}", "cnt", trade_cnt), 3)
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_1_1_MSG3"), 3)
    end
end

function SCR_USE_JOB_ONMYOJI_MSTEP2_3_ITEM1(self, argObj, argstring, arg1, arg2)
    local max_cnt = 50
    local trade_cnt = 2
    if GetInvItemCount(self, "CHAR220_MSTEP2_3_ITEM2") < max_cnt then
        if GetInvItemCount(self, "CHAR220_MSTEP2_3_ITEM1") >= trade_cnt then
            local inv_item1 = GetInvItemCount(self, "CHAR220_MSTEP2_3_ITEM1")
            local inv_item2 = GetInvItemCount(self, "CHAR220_MSTEP2_3_ITEM2")
            local take_item = 'CHAR220_MSTEP2_3_ITEM1'
            local give_item = 'CHAR220_MSTEP2_3_ITEM2'
            local take_cnt = inv_item1 - (inv_item1%trade_cnt)
            local give_cnt_pre = math.floor(inv_item1/trade_cnt)
            local give_cnt = 0
            for i = 1, give_cnt_pre do
                local ran = IMCRandom(1, 10)
                if ran <= 8 then
                    give_cnt = give_cnt + 1
                end
            end
            local charge_time = math.floor((inv_item1-1)*0.2)
            local time = 1 + charge_time
            if inv_item1 >= max_cnt then
                time = 30
            end
            local result = DOTIMEACTION_R(self, ScpArgMsg("CHAR220_MSETP2_3_MSG1"), "MAKING", time)
            if result == 1 then
                local fail_cnt = 0 + (give_cnt_pre - give_cnt)
                local fail_msg = "{nl}"
                if fail_cnt > 0 then
                    fail_msg = ScpArgMsg("CHAR220_MSETP2_3_MSG5{cnt}", "cnt", fail_cnt)
                end
                RunScript('TAKE_ITEM_TX', self, take_item, take_cnt, "CHAR220_MSTEP2_3");
                if give_cnt > 0 then
                    RunScript('GIVE_ITEM_TX', self, give_item, give_cnt, "CHAR220_MSTEP2_3");
                end
                PlayEffectLocal(self, self, "F_light028_violet1", 1, 1, "TOP")
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_3_MSG4{cnt1}{cnt2}", "cnt1", take_cnt, "cnt2", give_cnt)..fail_msg, 7)
            end
        else
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR220_MSETP2_3_MSG2{cnt}", "cnt", trade_cnt), 3)
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_3_MSG3"), 3)
    end
end

function SCR_USE_JOB_ONMYOJI_MSTEP2_6_ITEM1(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        local obj_list = { "CHAR220_MSETP2_6_OBJ1_1", "CHAR220_MSETP2_6_OBJ1_2",
                            "CHAR220_MSETP2_6_OBJ1_3", "CHAR220_MSETP2_6_OBJ1_4",
                            "CHAR220_MSETP2_6_OBJ1_5", "CHAR220_MSETP2_6_OBJ1_6",
                            "CHAR220_MSETP2_6_OBJ1_7", "CHAR220_MSETP2_6_OBJ1_8",
                            "CHAR220_MSETP2_6_OBJ1_9", "CHAR220_MSETP2_6_OBJ1_10",
                            "CHAR220_MSETP2_6_OBJ1_11", "CHAR220_MSETP2_6_OBJ1_12",
                            "CHAR220_MSETP2_6_OBJ1_13", "CHAR220_MSETP2_6_OBJ1_14",
                            "CHAR220_MSETP2_6_OBJ1_15", "CHAR220_MSETP2_6_OBJ1_16",
                            "CHAR220_MSETP2_6_OBJ1_17", "CHAR220_MSETP2_6_OBJ1_18",
                            "CHAR220_MSETP2_6_OBJ1_19", "CHAR220_MSETP2_6_OBJ1_20",
                            "CHAR220_MSETP2_6_OBJ1_21", "CHAR220_MSETP2_6_OBJ1_22",
                            "CHAR220_MSETP2_6_OBJ1_23", "CHAR220_MSETP2_6_OBJ1_24",
                            "CHAR220_MSETP2_6_OBJ1_25" }
        local result = DOTIMEACTION_R(self, ScpArgMsg("CHAR220_MSETP2_6_MSG1"), 'METALDETECTOR', 2)
        if result == 1 then
            PlayEffectLocal(self, self, "F_circle016_rainbow", 1.5, "MID")
            local list, cnt = SelectObject(self, 120, "ALL", 1)
            if cnt > 0 then
                for i = 1, cnt do
                    if list[i].ClassName ~= "PC" then
                        if TryGetProp(list[i], "Dialog") == 'CHAR220_MSETP2_6_OBJ2' then
                            local ownerCID = GetExProp_Str(list[i], "JOB_ONMYOJI_MSTEP2_6")
                            if ownerCID == nil then
                                Kill(list[i]);
                            else
                                local charCID = GetPcCIDStr(self);
                                if tostring(ownerCID) == tostring(charCID) then
                                    ShowBalloonText(self, "CHAR220_MSETP2_6_FIND_DLG1", 7)
                                    AddVisiblePC(list[i], self, 1)
                                    return
                                end
                            end
                        end
                    end
                end
                for i = 1, cnt do
                    if list[i].ClassName ~= "PC" then
                        local num = table.find(obj_list, TryGetProp(list[i], "Enter"))
                        if num > 0 then
                            if sObj.String4 ~= "None" then
                                local string_cut_list = SCR_STRING_CUT(sObj.String4);
                                if table.find(string_cut_list, num) <= 0 then
                                    local x, y, z = GetPos(list[i])
                                    local mon = CREATE_MONSTER_EX(self, 'noshadow_npc', x+10, y, z+10, -45, 'Neutral', nil, CHAR220_MSETP2_6_OBJ2_SET);
                                    local charCID = GetPcCIDStr(self)
                                    local day, time = ONMYOJI_TIME_CHECK(self)
                                    local today = tonumber(day)
                                    local nowtime = tonumber(time)
                                    local lastday = sObj.Step18
                                    local lasttime = sObj.Goal18
                                    local lifeTime
                                    if today == lastday then
                                        lifeTime = lasttime - nowtime
                                    elseif today ~= lastday then
                                        lifeTime = lasttime - (nowtime + 1440)
                                    end
                                        lifeTime = lifeTime * 60
                                    	SetLifeTime(mon, lifeTime)
                                        AddVisiblePC(mon, self, 1)
                                        SetExProp_Str(mon, "JOB_ONMYOJI_MSTEP2_6", charCID)
                                        SetExProp(mon, "JOB_ONMYOJI_MSTEP2_6_NUMBER", num)
                                    	AttachEffect(mon, "F_light071_loop", 13, "TOP")
                                    	AttachEffect(mon, "F_light104_yellow_loop", 1.5, "MID")
                                        ShowBalloonText(self, "CHAR220_MSETP2_6_FIND_DLG1", 7)
                                        sObj.String4 = sObj.String4.."/"..tostring(num)
                                        SaveSessionObject(self, sObj)
                                    return
                                end
                            end
                        end
                    end
                end
            end
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR220_MSETP2_6_MSG4"),3)
        end
    end
end

function CHAR220_MSETP2_6_OBJ2_SET(mon)
    mon.Dialog = "CHAR220_MSETP2_6_OBJ2"
    mon.Name = "UnvisibleName"
    mon.MaxDialog = 1;
end

function SCR_CHAR220_MSETP2_6_OBJ2_DIALOG(self, pc)
    local num = GetExProp(self, "JOB_ONMYOJI_MSTEP2_6_NUMBER")
    local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char2_20')
    if is_unlock == "NO" then
        local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
        if prop == 10 then
            local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
            if sObj ~= nil then
                if sObj.Goal8 == 1 then
                    local max_cnt = 20
                    if GetInvItemCount(pc, "CHAR220_MSTEP2_6_ITEM2") < max_cnt then
                        local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR220_MSETP2_6_MSG2"), "SITGROPE_LOOP", 2.0)
                        if result == 1 then
                            DetachEffect(self, 'F_light104_yellow_loop')
                            DetachEffect(self, 'F_light071_loop')
                            Kill(self)
                            local cnt = 1
                            local item = 'CHAR220_MSTEP2_6_ITEM2'
                            RunScript('GIVE_ITEM_TX', pc, item, cnt, "CHAR220_MSTEP2_6");
                            PlayEffectLocal(pc, pc, "F_light048_yellow", 0.5, 1, "TOP")
                            SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg("CHAR220_MSETP2_6_MSG3"),3)
                            if sObj.String4 ~= "None" then
                                local string_cut_list = SCR_STRING_CUT(sObj.String4);
                                if table.find(string_cut_list, num) <= 0 then
                                    sObj.String4 = sObj.String4.."/"..tostring(num)
                                    SaveSessionObject(pc, sObj)
                                end
                            end
                        end
                    else
                        SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg("CHAR220_MSETP2_6_MSG5"),3)
                    end
                end
            end
        end
    end
end

function SCR_USE_JOB_ONMYOJI_MSTEP2_7_ITEM1(self, argObj, argstring, arg1, arg2)
    local obj_list = { "CHAR220_MSETP2_7_OBJ_1", 
                        "CHAR220_MSETP2_7_OBJ_2",
                        "CHAR220_MSETP2_7_OBJ_3",
                        "CHAR220_MSETP2_7_OBJ_4",
                        "CHAR220_MSETP2_7_OBJ_5",
                        "CHAR220_MSETP2_7_OBJ_6",
                        "CHAR220_MSETP2_7_OBJ_7",
                        "CHAR220_MSETP2_7_OBJ_8",
                        "CHAR220_MSETP2_7_OBJ_9" }
    LookAt(self, argObj)
    local sObj = GetSessionObject(self, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        local result = DOTIMEACTION_R(self, ScpArgMsg("CHAR220_MSETP2_7_MSG1"), "ABSORB", 3)
        if result == 1 then
            if sObj.String5 ~= "None" then
                local num = table.find(obj_list, TryGetProp(argObj, "Enter"))
                local string_cut_list1 = SCR_STRING_CUT(sObj.String5);
                local string_cut_list2 = SCR_STRING_CUT(sObj.String6);
                if table.find(string_cut_list1, num) <= 0 then
                    if table.find(string_cut_list2, num) <= 0 then
                        local max_cnt = 11
                        if sObj.Goal9 < max_cnt then
                            if sObj.String6 == nil or sObj.String6 == "None" then
                                sObj.String6 = tostring(num)
                            else
                                sObj.String6 = sObj.String6.."/"..tostring(num)
                            end
                            sObj.Goal9 = sObj.Goal9 + 1
                        else
                            if sObj.String6 == nil or sObj.String6 == "None" then
                                sObj.String6 = tostring(num)
                            else
                                sObj.String6 = sObj.String6.."/"..tostring(num)
                            end
                            sObj.Goal9 = max_cnt
                        end
                        PlayEffectLocal(argObj, self, "F_lineup003", 1.5, "TOP")
                        if sObj.Goal9 < max_cnt then
                            local msg_max_cnt = max_cnt - 1
                            local msg_cnt = sObj.Goal9 - 1
                            SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("CHAR220_MSETP2_7_MSG2").."{nl}".."( "..msg_cnt.." / "..msg_max_cnt.." "..ScpArgMsg('NumberOfThings').." )",3)
                        else
                            SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("CHAR220_MSETP2_7_MSG7"),3)
                        end
                    else
                        SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("CHAR220_MSETP2_7_MSG3"),3)
                    end
                    SaveSessionObject(self, sObj)
                    return
                else
                    local fail_num = table.find(string_cut_list1, num)
                    if fail_num == 1 or fail_num == 3 or fail_num == 5 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR220_MSETP2_7_MSG4"),3)
                        return
                    elseif fail_num == 2 or fail_num == 4 or fail_num == 6 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR220_MSETP2_7_MSG5"),3)
                        return
                    end
                end
            end
        end
    end
end


--JOB_ONMYOJI_Q1_ITEM
function SCR_USE_JOB_ONMYOJI_Q1_ITEM(self, argObj, argstring, arg1, arg2)
    local result = SCR_QUEST_CHECK(self, 'JOB_ONMYOJI_Q1')
    if result == 'PROGRESS' then
        LookAt(self, argObj)
        local result = DOTIMEACTION_R(self, ScpArgMsg("JOB_ONMYOJI_Q1_MSG1"), "ABSORB", 0.5)
        if result == 1 then
            local angle = math.floor(GetDirectionByAngle(argObj))
            if angle <= 1 and angle >= -1 then
                angle = 90
                SetDirectionByAngle(argObj, angle)
                StopMove(argObj)
            elseif angle <= 91 and angle >= 89 then
                angle = -180
                SetDirectionByAngle(argObj, angle)
                StopMove(argObj)
            elseif angle <= -179 or angle >= 179 then
                angle = -90
                SetDirectionByAngle(argObj, angle)
                StopMove(argObj)
            elseif angle <= -89 and angle >= -91 then
                angle = 0
                SetDirectionByAngle(argObj, angle)
                StopMove(argObj)
            end
            local zoneID = GetZoneInstID(argObj)
            local x, y, z = GetPos(argObj)
            local dir = GetDirectionByAngle(argObj)
            local _far = 50
            local x1, y1, z1 = GetFrontPosByAngle(argObj, dir, _far, 1, x, y, z, 1);
            if IsValidPos(zoneID, x1, y1, z1) == 'YES' then
                MoveEx(argObj, x1, y1, z1, 1)
                PlayEffectNode(argObj,'F_lineup003', 1, 'Bip01 Head')
            end
        end
    end
end

--SCR_USE_CHAR118_MSTEP2_2_ITEM2
function SCR_USE_CHAR118_MSTEP2_2_ITEM2(self, argObj, argstring, arg1, arg2)
    local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal2 < 50 then
            if IsBuffApplied(self, "CHAR118_MSTEP2_2_ITEM1_BUFF1") == "YES" then
                local goal_Group = sObj.Step7
                local goal_Point = sObj.Step6
                if goal_Group == 1 then
                    if goal_Point == 1 then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR118_MSTEP2_2_STARTLINE1"), 7)
                        TreasureMarkByMap(self, 'f_farm_47_1', -1134, 40, -1152)
                    elseif goal_Point == 2 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_GOALPOINT2_2"), 6)
                        TreasureMarkByMap(self, 'f_farm_47_1', 98, -41, -386)
                    elseif goal_Point == 3 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_ITEM1_RETURNTOMASTER"), 6)
                        TreasureMarkByMap(self, 'f_farm_47_1', -1273, -41, -325)
                    end
                elseif goal_Group == 2 then
                    if goal_Point == 1 then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR118_MSTEP2_2_STARTLINE2"), 7)
                        TreasureMarkByMap(self, 'f_farm_47_1', -1244, 6, 578)
                    elseif goal_Point == 2 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_GOALPOINT2_2"), 6)
                        TreasureMarkByMap(self, 'f_farm_47_1', 98, -41, -386)
                    elseif goal_Point == 3 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_ITEM1_RETURNTOMASTER"), 6)
                        TreasureMarkByMap(self, 'f_farm_47_1', -1273, -41, -325)
                    end
                elseif goal_Group == 3 then
                    if goal_Point == 1 then
                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR118_MSTEP2_2_STARTLINE1"), 7)
                        TreasureMarkByMap(self, 'f_farm_47_1', -1134, 40, -1152)
                    elseif goal_Point == 2 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_GOALPOINT1_2"), 6)
                        TreasureMarkByMap(self, 'f_farm_47_1', 367, 57, -1124)
                    elseif goal_Point == 3 then
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_ITEM1_RETURNTOMASTER"), 6)
                        TreasureMarkByMap(self, 'f_farm_47_1', -1273, -41, -325)
                    end
                end
            else
                SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR118_MSTEP2_2_MAPMSG1"), 10)
            end
        else
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("RETIARII_TRAINING_SUCC2"), 10)
        end
    end
end

--GM_WHITETREES_OBJ_ITEM2
function SCR_USE_GM_WHITETREES_OBJ_ITEM2(self, argObj, argstring, arg1, arg2)
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("GM_WHITETREES_NPC1_MSG8"), "BURY", 1.5)
    if result1 == 1 then
        local x,y,z = GetPos(self)
        RunScript("TAKE_ITEM_TX", self, "GM_WHITETREES_OBJ_ITEM2", 1, "GM_WHITETREES")
        local mon = CREATE_MONSTER_EX(self, "Bomb", x, y, z, 1, "Our_Forces", 1, GM_WHITETREES_OBJ_ITEM2_SET)
        local boom_ssn = GetSessionObject(mon, 'SSN_QUESTITEM_BOOM')
        if boom_ssn == nil then
            CreateSessionObject(mon, 'SSN_QUESTITEM_BOOM', 1)
        end
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("GM_WHITETREES_ITEM_MSG1"), 3)
    end
end

function GM_WHITETREES_OBJ_ITEM2_SET(self)
    self.Name = ScpArgMsg("GM_WHITETREES_ITEM_MSG1_NAME")
    self.Tactics = "None"
end

--GM_WHITETREES_OBJ_ITEM3
function SCR_USE_GM_WHITETREES_OBJ_ITEM3(self, argObj, argstring, arg1, arg2)
    GM_WHITETREES_OBJ_ITEM_FUNC(self, ScpArgMsg("GM_WHITETREES_NPC1_MSG9"), "GM_WHITETREES_OBJ_ITEM3", "GM_Large_crossbow", ScpArgMsg("GM_WHITETREES_NPC1_MSG12"))
end

--GM_WHITETREES_OBJ_ITEM4
function SCR_USE_GM_WHITETREES_OBJ_ITEM4(self, argObj, argstring, arg1, arg2)
    GM_WHITETREES_OBJ_ITEM_FUNC(self, ScpArgMsg("GM_WHITETREES_NPC1_MSG10"), "GM_WHITETREES_OBJ_ITEM4", "GM_arrow_trap", ScpArgMsg("GM_WHITETREES_NPC1_MSG13"))
end

--GM_WHITETREES_OBJ_ITEM5
function SCR_USE_GM_WHITETREES_OBJ_ITEM5(self, argObj, argstring, arg1, arg2)
    GM_WHITETREES_OBJ_ITEM_FUNC(self, ScpArgMsg("GM_WHITETREES_NPC1_MSG11"), "GM_WHITETREES_OBJ_ITEM5", "GM_stake_stockades",ScpArgMsg("GM_WHITETREES_NPC1_MSG14"))
end

function GM_WHITETREES_OBJ_ITEM_FUNC(self, animmsg, item, obj, msg)
    local result1 = DOTIMEACTION_R(self, animmsg, "BURY", 1.5)
    if result1 == 1 then
        local x,y,z = GetPos(self)
        RunScript("TAKE_ITEM_TX", self, item, 1, "GM_WHITETREES")
        local mon = CREATE_MONSTER_EX(self, obj, x, y, z, 1, "Our_Forces", 1, GM_WHITETREES_OBJ_ITEM_SET1)
        SendAddOnMsg(self, "NOTICE_Dm_scroll", msg, 3)
    end
end

function GM_WHITETREES_OBJ_ITEM_SET1(self)
    if self.ClassName == "GM_Large_crossbow" then
        self.HPCount = 50
        self.Dialog = "GM_WHITETREES_ITEM_OBJ"
    elseif self.ClassName == "GM_arrow_trap" then
        self.HPCount = 75
        self.Dialog = "GM_WHITETREES_ITEM_OBJ"
    elseif self.ClassName == "GM_stake_stockades" then
        self.HPCount = 150
    end
    self.Tactics = "None"
end

function SCR_GM_WHITETREES_ITEM_OBJ_DIALOG(self, pc)
    if GetInvItemCount(pc, "GM_WHITETREES_OBJ_ITEM1") >= 1 then
        local result1 = DOTIMEACTION_R(pc, "GM_WHITETREES_ITEM1_MSG1", "BURY", 1.5)
        if result1 == 1 then
            RunScript("TAKE_ITEM_TX", pc, "GM_WHITETREES_OBJ_ITEM1",1, "GM_WHITETREES_56_1")
            AddBuff(self, self, "GM_WHITETREES_DEFFENCE_OBJ_BUFF", 1, 0, 0, 1)
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("GM_WHITETREES_ITEM1_MSG2"), 5)
        end
    end
end
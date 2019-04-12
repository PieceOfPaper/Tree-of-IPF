function SCR_SSN_KLAPEDA_KillMonster_PARTY(self, party_pc, sObj, msg, argObj, argStr, argNum)
    if SHARE_QUEST_PROP(self, party_pc) == true then
        if GetLayer(self) ~= 0 then
            if GetLayer(self) == GetLayer(party_pc) then
                SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
            end
        else
            SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
        end
    end

    --MAGAZINE event --
    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
        SCR_EVENT_MAGAZINE_NUM1_DROPITEM(self, sObj, msg, argObj, argStr, argNum)
    end

end

function SCR_SSN_KLAPEDA_KillMonster(self, sObj, msg, argObj, argStr, argNum)
	PC_WIKI_KILLMON(self, argObj, true);
	CHECK_SUPER_DROP(self);
	SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
    CHECK_CHALLENGE_MODE(self, argObj);

    --MAGAZINE event --
    SCR_EVENT_MAGAZINE_NUM1_DROPITEM(self, sObj, msg, argObj, argStr, argNum)

end

function SCR_SSN_KLAPEDA_ZoneEner(self, sObj, msg, argObj, argStr, argNum)
    sObj.TRACK_QUEST_NAME = 'None'
    
    local drop_sObj = GetSessionObject(self, 'ssn_drop')
	if drop_sObj == nil then
	    CreateSessionObject(self,'ssn_drop')
	end
	
    sObj.PRESENT_ZONEID = GetClassNumber('Map', argStr, 'ClassID');

    if sObj.QUESTSAVE ~= 0 then
        local questIES = GetClass('QuestProgressCheck', SCR_SEARCH_CLASSIDIES('QuestProgressCheck', sObj.QUESTSAVE))
        local questsave_point = {}

        if questIES ~= nil then
            local questsave_gentype = GetClassCount('GenType_'..questIES.StartMap)
            local i, gentype, search_range
            for i = 0 , questsave_gentype -1 do
                if GetClassStringByIndex('GenType_'..questIES.StartMap,i,'Dialog') == questIES.StartNPC or GetClassStringByIndex('GenType_'..questIES.StartMap,i,'Enter') == questIES.StartNPC or GetClassStringByIndex('GenType_'..questIES.StartMap,i,'Leave') == questIES.StartNPC then
                    gentype = GetClassNumberByIndex('GenType_'..questIES.StartMap,i,'GenType');
                    search_range = GetClassNumberByIndex('GenType_'..questIES.StartMap,i,'Range');
                    break
                end
            end

            local questsave_anchor = GetClassCount('Anchor_'..questIES.StartMap)

            for i = 0 , questsave_anchor -1 do
                if GetClassNumberByIndex('Anchor_'..questIES.StartMap,i,'GenType') == gentype then
                    questsave_point[1] = GetClassNumberByIndex('Anchor_'..questIES.StartMap,i,'PosX');
                    questsave_point[2] = GetClassNumberByIndex('Anchor_'..questIES.StartMap,i,'PosY');
                    questsave_point[3] = GetClassNumberByIndex('Anchor_'..questIES.StartMap,i,'PosZ');
                    break
                end
            end

            if questsave_point[1] ~= nil and questsave_point[2] ~= nil and questsave_point[3] ~= nil then
--                UIOpenToPC(self,'fullblack',1)
                local self_posx, self_posy, self_posz = GetPos(self)
                if GetZoneName(self) == questIES.StartMap  and SCR_POINT_DISTANCE(questsave_point[1], questsave_point[3], self_posx, self_posz) > search_range then
                    MoveZone(self, questIES.StartMap, questsave_point[1], questsave_point[2], questsave_point[3])
                    sObj.QUESTSAVE = 0
                    SaveSessionObject(self,sObj)
--                    UIOpenToPC(self,'fullblack',0)
                end
            end
        end
    end
    
    if argStr == 'd_firetower_41' then
        FTOWER41_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_firetower_42' then
        FTOWER42_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_firetower_43' then
        FTOWER43_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_firetower_44' then
        FTOWER44_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_cmine_01' then
        AddHelpByName(self, 'TUTO_DUNGEON')
        TUTO_PIP_CLOSE_QUEST(self)
    elseif argStr == 'd_prison_62_1' then
        AddHelpByName(self, 'TUTO_DUNGEON')
        TUTO_PIP_CLOSE_QUEST(self)
    elseif argStr == 'f_remains_38' then
        REMAIN38_SQ05_MON_CREATE(self)
    elseif argStr == 'd_underfortress_59_1' then
        UNDERF591_TYPED_GET_ITEM(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_underfortress_59_2' then
        UNDERF592_TYPEB_GATE_BUFF(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_velniasprison_51_1' then
        HAUBERK_HOVER_VPRISON(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_velniasprison_51_2' then
        HAUBERK_HOVER_VPRISON(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_velniasprison_51_4' then
        HAUBERK_HOVER_VPRISON(self, sObj, msg, argObj, argStr, argNum)
--    elseif argStr == 'd_firetower_61_1' then
--        SCR_INI_SSN_FD_FTOWER611(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_thorn_39_2' then
        SCR_THORN392_MQ_05_COMPANION_REGET(self, sObj, msg, argObj, argStr, argNum)
        SCR_THORN392_FRIAR_HIDE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_thorn_39_1' then
        SCR_THORN391_SQ_01_COMPANION_REGET(self, sObj, msg, argObj, argStr, argNum)
        SCR_THORN391_FRIAR_HIDE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_abbey_39_4' then
        SCR_ABBEY394_HUNTER_HIDE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'c_Klaipe' then
        if sObj.TUTO_SOCIAL == 0 then
            sObj.TUTO_SOCIAL = 300
            AddHelpByName(self, 'TUTO_SOCIAL')
        end
        if self.Lv >= 100 then
            if sObj.TUTO_REQUEST == 0 then
                sObj.TUTO_REQUEST = 300
                AddHelpByName(self, 'TUTO_REQUEST')
            end
        end
        local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL54_MQ06_PART3')
        if result == 'COMPLETE' then
            if sObj.TUTO_ITEM_AWAKENING == 0 then
                sObj.TUTO_ITEM_AWAKENING = 300
                AddHelpByName(self, 'TUTO_ITEM_AWAKENING')
            end
        end
        --스팀 콜로니전 최초 승리 보상 지급 스크립트
        local state = GetColonyWarState()
       if state ~= 2 then
            if GetServerNation() ~= 'KOR' then
                if GetServerNation() == 'GLOBAL' then
                    SCR_STEAM_COLONY_WAR_FIRST_VICTORY_REWARD(self)
                end
            end
        end
    elseif argStr == 'c_orsha' then
        if sObj.TUTO_SOCIAL == 0 then
            sObj.TUTO_SOCIAL = 300
            AddHelpByName(self, 'TUTO_SOCIAL')
        end
        local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL54_MQ06_PART3')
        if result == 'COMPLETE' then
            if sObj.TUTO_ITEM_AWAKENING == 0 then
                sObj.TUTO_ITEM_AWAKENING = 300
                AddHelpByName(self, 'TUTO_ITEM_AWAKENING')
            end
        end
    elseif argStr == 'c_fedimian' then
        if sObj.TUTO_REQUEST == 0 then
--            sObj.TUTO_REQUEST = 300
--            AddHelpByName(self, 'TUTO_REQUEST')
        end
        local result = SCR_QUEST_CHECK(self, 'FTOWER45_MQ_06')
        if result == 'COMPLETE' then
            if sObj.TUTO_GEM_ROASTING == 0 then
                sObj.TUTO_GEM_ROASTING = 300
                AddHelpByName(self, 'TUTO_GEM_ROASTING')
            end
        end
        --스팀 콜로니전 최초 승리 보상 지급 스크립트
        local state = GetColonyWarState()
        if state ~= 2 then
            if GetServerNation() ~= 'KOR' then
                if GetServerNation() == 'GLOBAL' then
                    SCR_STEAM_COLONY_WAR_FIRST_VICTORY_REWARD(self)
                end
            end
        end
    elseif argStr == 'c_barber_dress' then
        FixCamera(self, -7.83 , 4.81, 13.42, 230)
        AddBuff(self, self, "BEAUTY_HAIR_BUFF", 1, 0, 0)
    elseif argStr == 'f_pilgrimroad_31_2' then
        PILGRIM312_SQ_04_01_ADD(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_bracken_63_1' then
        BRACKEN631_MQ3_DOG01_AI_CREATE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_bracken_63_2' then
        BRACKEN632_ROZE01_AI_CREATE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_castle_65_3' then
        SCR_CASTLE653_MQ_FOLLOWER_RE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_katyn_45_3' then
        SCR_KATYN_45_3_BUFF(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_bracken_42_1' then
        SCR_BRACKEN421_FOLLOWER_RE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_bracken_42_2' then
        SCR_BRACKEN422_FOLLOWER_RE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'mission_groundtower_2' then
        SendAddOnMsg(self, "NOTICE_Dm_move_to_point", ScpArgMsg('GT2_LOBBY_ENTER_1'), 10);
--        SCR_GROUNDTOWER_ENTER_EVT(self)
    elseif argStr == 'd_limestonecave_52_1' then
        LIMESTONE_52_1_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_limestonecave_52_2' then
        LIMESTONE_52_2_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_limestonecave_52_3' then
        LIMESTONE_52_3_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_limestonecave_52_4' then
        LIMESTONE_52_4_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_flash_64' then
        local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(self, 'Char4_19')
        if hidden_Prop >= 5 then
            local master_Hide_Check = isHideNPC(self, 'ZEALOT_MASTER')
            if master_Hide_Check == 'YES' then
                UnHideNPC(self, "ZEALOT_MASTER")
            end
        end
    elseif argStr == 'd_limestonecave_52_5' then
        LIMESTONE_52_5_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_bracken_43_1' then
        BRACKEN431_SUBQ3_AI_CREATE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_pilgrimroad_41_3' then
        SCR_PILGRIM413_FOLLOWER_RE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_whitetrees_23_3' then
        SCR_WHITETREES233_SQ_07_RF(self)
    elseif argStr == 'f_whitetrees_23_1' then
        SCR_WHITETREES231_SQ_07_RF(self)
    elseif argStr == 'f_maple_23_2' then
        SCR_MAPLE232_SQ_10_FR(self)
--    elseif argStr == 'mission_groundtower_1' then
--        SCR_GROUNDTOWER_ENTER_EVT(self)
      elseif argStr == "d_prison_62_3" then
        --this logic is hidden quest [PRISON62_2_HQ1] problerom solve
        SCR_PRISON622_HQ1_CHANGE_STATE(self)
    elseif argStr == "d_cathedral_56" then
        --this logic is nexon japan CHATHEDRAL56_SQ01 quest problerom solve logic
        SCR_CHATHEDRAL56_SQ1_NPC_HIDE(self)
    elseif argStr == 'd_chapel_57_5' then
        AddHelpByName(self, 'TUTO_PENALTY')
        TUTO_PIP_CLOSE_QUEST(self)
    elseif argStr == 'f_farm_49_3' then
        FARM49_3_SQ06_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_startower_76_2' then
        SCR_D_STARTOWER_GIMMICK_REENTER(self) 
    end

    local regendCardTutoCheck = self.Lv
    if regendCardTutoCheck >= 330 then
        if sObj.TUTO_REGEND_CARD == 0 then
            AddHelpByName(self, 'TUTO_REGEND_CARD')
            sObj.TUTO_REGEND_CARD = 1
        end
    end
    
    local partyObj = GetPartyObj(self)
    if partyObj == nil then
        RunZombieScript('SCR_BASIC_PartyMemberOut_TX',self, sObj)
    else
        RunZombieScript('SCR_PartyPropertyCheck_TX',self, sObj, partyObj)
    end

    local _weight = math.floor(self.NowWeight/self.MaxWeight*100)
    if _weight >= 60 then
        AddHelpByName(self, 'TUTO_STORAGE')
    end
    
    local itemCount1 = GetInvItemCount(self, 'MISSION_UPHILL_GIMMICK_ITEM1')
    if itemCount1 > 0 then
        TAKE_ITEM_TX(self, 'MISSION_UPHILL_GIMMICK_ITEM1', itemCount1, 'MISSION_UPHILL_ZONELELEAVE')
    end
    local jobCircle1 = GetJobGradeByName(self, 'Char4_19')
    if jobCircle1 > 0 then
        if isHideNPC(self, 'ZEALOT_MASTER') == 'YES' then
            UnHideNPC(self, 'ZEALOT_MASTER')
        end
    end
    local jobCircle2 = GetJobGradeByName(self, 'Char2_19')
    if jobCircle2 > 0 then
        if isHideNPC(self, 'JOB_SHADOWMANCER_MASTER') == 'YES' then
            UnHideNPC(self, 'JOB_SHADOWMANCER_MASTER')
        end
    end
    local jobCircle3 = GetJobGradeByName(self, 'Char1_19')
    if jobCircle3 > 0 then
        if isHideNPC(self, 'MATADOR_MASTER') == 'YES' then
            UnHideNPC(self, 'MATADOR_MASTER')
        end
    end
    local jobCircle4 = GetJobGradeByName(self, 'Char3_18')
    if jobCircle4 > 0 then
        if isHideNPC(self, 'BULLETMARKER_MASTER') == 'YES' then
            UnHideNPC(self, 'BULLETMARKER_MASTER')
        end
    end
    if IS_KOR_TEST_SERVER() then
        if argStr == 'c_fedimian' then
            if isHideNPC(self, 'FEDIMIAN_APPRAISER') == 'NO' then
                HideNPC(self, 'FEDIMIAN_APPRAISER')
            end
            if isHideNPC(self, 'FEDIMIAN_APPRAISER_NPC') == 'YES' then
                UnHideNPC(self, 'FEDIMIAN_APPRAISER_NPC')
            end
        elseif argStr == 'f_tableland_28_1' then
            if isHideNPC(self, 'SHINOBI_MASTER') == 'YES' then
                UnHideNPC(self, 'SHINOBI_MASTER')
            end
        elseif argStr == 'f_remains_38' then
            if isHideNPC(self, 'RUNECASTER_MASTER') == 'YES' then
                UnHideNPC(self, 'RUNECASTER_MASTER')
            end
        elseif argStr == 'd_thorn_22' then
            if isHideNPC(self, 'CHAPLAIN_MASTER') == 'YES' then
                UnHideNPC(self, 'CHAPLAIN_MASTER')
            end
        elseif argStr == 'p_cathedral_1' then
            if isHideNPC(self, 'MIKO_MASTER') == 'YES' then
                UnHideNPC(self, 'MIKO_MASTER')
            end
        elseif argStr == 'f_flash_64' then
            if isHideNPC(self, 'ZEALOT_MASTER') == 'YES' then
                UnHideNPC(self, 'ZEALOT_MASTER')
            end
        elseif argStr == 'f_pilgrimroad_41_3' then
            if isHideNPC(self, 'JOB_SHADOWMANCER_MASTER') == 'YES' then
                UnHideNPC(self, 'JOB_SHADOWMANCER_MASTER')
            end
        elseif argStr == 'c_fedimian' then
            if isHideNPC(self, 'MATADOR_MASTER') == 'YES' then
                UnHideNPC(self, 'MATADOR_MASTER')
            end
        elseif argStr == 'f_farm_49_1' then
            if isHideNPC(self, 'BULLETMARKER_MASTER') == 'YES' then
                UnHideNPC(self, 'BULLETMARKER_MASTER')
            end
        elseif argStr == 'f_gele_57_4' then
            if isHideNPC(self, 'CHAR120_MASTER') == 'YES' then
                UnHideNPC(self, 'CHAR120_MASTER')
            end
        end
        
    end
     if GetAchieveCount(self) > 0 then
        AddBuff(self, self, "Achieve_Possession_Buff", 1, 0, 0, 1)
    end
   
    if IsJoinColonyWarMap(self) == 1 then
        RunScript("SCR_GUILD_COLONY_MUSIC_PLAY", self)
        local state = GetColonyWarState()
        if state == 3 then
            SCR_GUILD_COLONY_ALREADY_END_MSG(self)
       --스팀 콜로니전 매일 기본 보상 지급 스크립트
       elseif state == 1 or state == 2 then
           if GetServerNation() ~= 'KOR' then
               if GetServerNation() == 'GLOBAL' then
                   SCR_STEAM_COLONY_WAR_ONEDAY_REWARD(self)
                    SCR_STEAM_COLONY_WAR_FIVE_TIME_REWARD(self)
                    SCR_STEAM_COLONY_WAR_FIRST_ENTRY_REWARD(self)
               end
           end
        end
    end
    
    -- Change Job Quest Fail
    local pcetc = GetETCObject(self)
    if pcetc ~= nil and pcetc.JobChanging > 0 then
        SCR_CHANGEJOB_QUEST_FAIL(self, pcetc)
    end
    
    -- EVENT_1706_FISHING_BALLOON
--    RunScript('SCR_EVENT_1706_FISHING_BALLOON_ITEM_REMOVE',self)
    
--    if IsPVPServer(self) ~= 1 and GetServerNation() == 'KOR' then
--        RunZombieScript('SCR_EV161215_HOTTIME',self, sObj)
--    end
    
    -- EVENT_1710_HOLIDAY
--    SCR_EVENT_1710_HOLIDAY(self)
    
    -- 2017.12.02 ~ 2017.12.03 LootingChance + 2000 Event --
    SCR_EVENT_171202_171203_LOOTINGCHANCE(self)

--    SCR_SSN_KLAPEDA_CITYATTACK_BOSS(self, sObj)
    WORLDPVP_TIME_CHECK(self)
--    SCR_QUEST_BUG_TEMP(self,sObj)

    --reward_property achieve reward check
    local list, listCnt = GetClassList("reward_property");
    for i = 0, listCnt -1 do
        local cls = GetClassByIndexFromList(list, i);
        if cls ~= nil and TryGetProp(cls, "Property") == "AchievePoint" then
            local quest_auto = GetClass('QuestProgressCheck_Auto', cls.ClassName);
            if quest_auto ~= nil then
                if quest_auto.Success_HonorPoint ~= 'None' then
                    local honor_name, point_value = string.match(quest_auto.Success_HonorPoint,'(.+)[/](.+)')
                    if honor_name ~= nil then
                        if GetAchievePoint(self, honor_name) < 1 then
                            local result = SCR_QUEST_CHECK(self, cls.ClassName)
                            if result == 'COMPLETE' then
                                local tx = TxBegin(self);
                                TxEnableInIntegrate(tx)
                                TxAddAchievePoint(tx, honor_name, tonumber(point_value))
                                local ret = TxCommit(tx);
                            end
                        end
                    end
                end
            end
        end
    end

    -- EVENT_1802_WEEKEND
--    EVENT_1802_WEEKEND(self)
    
    if argStr == 'c_firemage_event' then
        self.FIXMSPD_BM = 25
        Invalidate(self, 'MSPD');
    end
    
end
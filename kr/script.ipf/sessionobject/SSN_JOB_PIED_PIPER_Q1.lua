function SCR_SSN_JOB_PIED_PIPER_Q1_BASIC_HOOK(self, sObj)
    RegisterHookMsg(self, sObj, 'UseSkill', 'SSN_JOB_PIED_PIPER_UseSkill', 'NO')
    RegisterHookMsg(self, sObj, 'SetLayer', 'SSN_JOB_PIED_PIPER_SetLayer', 'NO')
    SetTimeSessionObject(self, sObj, 1, 1000, "SCR_SSN_JOB_PIED_PIPER_TRACK_START")
end

function SCR_CREATE_SSN_JOB_PIED_PIPER_Q1(self, sObj)
	SCR_SSN_JOB_PIED_PIPER_Q1_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_JOB_PIED_PIPER_Q1(self, sObj)
	SCR_SSN_JOB_PIED_PIPER_Q1_BASIC_HOOK(self, sObj)
	ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')
end

function SCR_DESTROY_SSN_JOB_PIED_PIPER_Q1(self, sObj)
end

function SCR_TIMEOUT_SSN_JOB_PIED_PIPER_Q1(self, sObj)

    local maxRewardIndex = SCR_QUEST_CHECK_MODULE_STEPREWARD_FUNC(self, sObj.QuestName)
    if maxRewardIndex ~= nil and maxRewardIndex > 0 then
    	SCR_SSN_TIMEOUT_PARTY_SUCCESS(self, sObj.QuestName, nil, nil)
    else
        RunZombieScript('ABANDON_Q_BY_NAME',self, sObj.QuestName, 'FAIL')
    end
end

function SCR_SSN_JOB_PIED_PIPER_Q1_COUNTTIME(self, sObj, remainTime)
	SCR_DIE_DIRECTION_CHECK(self, sObj, remainTime)
end

function IS_JOB_PIED_PIPER_TRACK(self)
    local layer = GetLayer(self)
    if layer > 0 then
        local obj = GetLayerObject(GetZoneInstID(self), layer);
        if obj ~= nil then
        	if obj.EventName == 'JOB_PIED_PIPER_Q1' then
        	    return 'YES'
        	end
        end
    end
    return 'NO'
end

function SCR_SSN_JOB_PIED_PIPER_TRACK_START(self, sObj)
    if IS_JOB_PIED_PIPER_TRACK(self) == 'YES' then
	    SetTimeSessionObject(self, sObj, 1, 1000, "SCR_SSN_JOB_PIED_PIPER_TIMER")
    end
end

function SCR_SSN_JOB_PIED_PIPER_TIMER(self, sObj, remainTime)
    if IsPlayingDirection(self) ~= 1 then
        SendSkillQuickSlot(self, 1, 'PiedPiper_Quest1', 'PiedPiper_Quest2', 'PiedPiper_Quest3', 'PiedPiper_Quest4', 'PiedPiper_Quest5')
        SetTimeSessionObject(self, sObj, 1, 1000, "None")
    end
    
end

function SSN_JOB_PIED_PIPER_SetLayer(self, sObj, msg, argObj, argStr, argNum)
    if GetLayer(self) == 0 then
        SendSkillQuickSlot(self, 0, 'PiedPiper_Quest1', 'PiedPiper_Quest2', 'PiedPiper_Quest3', 'PiedPiper_Quest4', 'PiedPiper_Quest5')
    end
end

function SSN_JOB_PIED_PIPER_UseSkill(self, sObj, msg, sklObj)
    local skill_list = {"PiedPiper_Quest1", 
                        "PiedPiper_Quest2",
                        "PiedPiper_Quest3",
                        "PiedPiper_Quest4"}
    local reset_skill = "PiedPiper_Quest5"
    if table.find(skill_list, sklObj.ClassName) == 0 and sklObj.ClassName ~= reset_skill then
        return
    else
        local x, y, z = GetPos(self)
        PlayEffectLocal(self, self, "F_archer_fluflu_hit_spread_out", 1, 0, "TOP")
        if table.find(skill_list, sklObj.ClassName) ~= 0 then
            local angle_list = {0, 90, 180, 270}
            local sound_list = { {"C", 1, 0},
                                {"E", 1, 0},
                                {"G", 1, 0},
                                {"C", 2, 0}
                                }
            local skill_number = table.find(skill_list, sklObj.ClassName)
            local angle = angle_list[skill_number]
            local sound = sound_list[skill_number]
            PlayFluting(self, sound[1], sound[2], sound[3])
            RunScript("SCR_JOB_PIED_PIPER_Q1_SOUND_OFF", self, sound[1], sound[2], sound[3])
            local list, cnt = SelectObjectPos(self, x, y, z, 15, "ALL")
            if cnt > 0 then
                for i = 1, cnt do
                    if list[i].ClassName == "Hiddennpc_move" then
                        local end_pos_check = GetExProp(list[i], 'END_POS')
                        if end_pos_check == nil or end_pos_check == 0 then
                            local angle_check = GetExProp(list[i], 'ANGLE')
                            if angle ~= angle_check then
                                DetachEffect(list[i], 'I_sys_target_arrow')
                                SetDirectionByAngle(list[i], angle)
                                SetExProp(list[i], 'ANGLE', angle)
                                AttachEffect(list[i], 'I_sys_target_arrow', 1.5, 'BOT', 0, 2, 0, 1)
                                PlayEffect(list[i], "I_change_ground_mash", 1.2, "TOP")
                                return
                            end
                        end
                    end
                end
            end
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_PIED_PIPER_Q1_MSG3"), 1)
        else
            local sound = {"B", 2, 0}
            PlayFluting(self, sound[1], sound[2], sound[3])
            RunScript("SCR_JOB_PIED_PIPER_Q1_SOUND_OFF", self, sound[1], sound[2], sound[3])
        	local zoneID = GetZoneInstID(self);
        	local layer = GetLayer(self);
        	local list, cnt = GetLayerMonList(zoneID, layer);
        	if cnt > 0 then
                for i = 1, cnt do
                    local obj_check = GetExProp(list[i], 'PIED_PIPER_Q1_OBJ')
                    if obj_check == 1 then
                        DetachEffect(list[i], 'I_sys_target_arrow')
                        Kill(list[i])
                    end
                end
                
            end
            local list, cnt = GetLayerMonList(zoneID, layer);
            if cnt > 0 then
                for i = 1, cnt do
                    local obj_check = GetExProp(list[i], 'PIED_PIPER_Q1_INIT_OBJ')
                    if obj_check == 1 then
                        RunScript('SCR_JOB_PIED_PIPER_Q1_GIMMICK_SETTING', list[i])
                        return
                    end
                end
            end
        end
    end
end

function SCR_JOB_PIED_PIPER_Q1_SOUND_OFF(self, scale, octave, isSharp)
    sleep(450)
    StopFluting(self, scale, octave, isSharp)
end
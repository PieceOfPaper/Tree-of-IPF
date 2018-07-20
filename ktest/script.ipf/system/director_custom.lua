function SCR_DIRECTOR_NOTICE(pc, noticeType, msg, sce)
    if noticeType == nil then
        noticeType = 'NOTICE_Dm_!'
    end
    
    if msg == nil or msg == 'None' then
        local obj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc));
        if obj ~= nil then
        	msg = obj.EventName.." None MSG"
        end
        
        if msg == nil or msg == 'None' then
            msg = "None MSG"
        end
    end
    
    if sce == nil or sce == 0 then
        sce = 3
    end
    
    SendAddOnMsg(pc, noticeType, msg, sce);
end

function SCR_DIRECTOR_NOTICE_SCREEN(pc, msg, sce)
    if msg == nil or msg == 'None' then
        local obj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc));
        if obj ~= nil then
        	msg = obj.EventName.." None MSG"
        end
        
        if msg == nil or msg == 'None' then
            msg = "None MSG"
        end
    end
    
    if sce == nil or sce == 0 then
        sce = 3
    end
    
    SendAddOnMsg(pc, "NOTICE_SCREEN", msg, sce)
end

function WAIT_END_DIRECTION(pc)

	while 1 do
		if IsDummyPC(pc) == 0 and 0 == IsPlayingDirection(pc) then
			break;
		end

		sleep(500)
	end

	local slowTime = GetExProp(pc, "SLOW_TIME") + 3;
	local curTime = imcTime.GetAppTime();
	local sleepTime = slowTime - curTime;
	if sleepTime > 0 then
		sleep(sleepTime * 1000);
	end
	

end

function DRT_OK_DLG(pc, dlg)
	ShowOkDlg(pc, dlg, 1);
end

function DRT_OK_DLG_PC(self, dlg)
    if self.ClassName ~= 'PC' then
        local list, cnt = GetLayerPCList(self)
        if cnt > 0 then
            local i
            for i = 1, cnt do
            	local partyObj = GetGuildObj(list[i]);
            	if partyObj == nil then
            		return;
            	end

            	local isLeader = IsPartyLeaderPc(partyObj, list[i]);
            	if isLeader == 1 then
        	        ShowOkDlg(pc, dlg, 1)
        	        break
        	    end
    	    end
    	end
    end
end



function DRT_CRE_SCRLOCK(pc, scrLockName, x, y, z)
	local boxMon = CREATE_BATTLE_BOX_A(pc, scrLockName, x, y, z);

	local list, cnt = GetDirectionMonList(pc);
	for i = 1 , cnt do
		ADD_BATTLE_BOX_MONSTER(boxMon, list[i]);
	end
end

function DRT_PLAY_MGAME(pc, mGameName)
	RunMGame(pc, mGameName);
end

function DRT_QUEST_DIALOG(pc, dlgName)
	COMMON_QUEST_HANDLER(nil,pc, dlgName)
end

function DRT_BGMODEL_ANIM(pc, bgObjName, animName, loop)
	PlayBGModelAnim(pc, bgObjName, animName, loop);
end

function DRT_ACTOR_ATTACH_EFFECT(actor, eftName, scl, hOffset)
	AttachEffect(actor, eftName, scl, hOffset);	
end

function DRT_ACTOR_PLAY_EFT(actor, eftName, scl, hOffset, skipIfExist)
	PlayEffect(actor, eftName, scl, skipIfExist, hOffset);
end

function DRT_PLAY_EFT(pc, eftName, scl, x, y, z, lifeTime, delay)
	PlayEffectToGroundLocal(pc, eftName, x, y, z, scl, lifeTime, delay);
end

function DRT_CHANGE_COLOR(self, red, green, blue, alpha, switch, blendtime)
	local broadPacket = 1;
	ObjectColorBlend(self, red, green, blue, alpha, switch, blendtime, 1, broadPacket);
end

function DRT_CHANGE_COLOR_OPT(self, s_red, s_green, s_blue, s_alpha, e_red, e_green, e_blue, e_alpha, blendtime)
	local broadPacket = 1;
	ObjectColorBlend(self, s_red, s_green, s_blue, s_alpha, 1, 1, 1, broadPacket);
	ObjectColorBlend(self, e_red, e_green, e_blue, e_alpha, 1, blendtime, 1, broadPacket);
end


function DRT_ALPHA_NPC(self, kill, aniname, s_red, s_green, s_blue, s_alpha, e_red, e_green, e_blue, e_alpha, blendtime)
	local broadPacket = 1;
	if aniname == nil then
	    aniname = 'STD'
	end
--	SetFixAnim(self, aniname)
	ObjectColorBlend(self, s_red, s_green, s_blue, s_alpha, 1, 1, 0, broadPacket);
	ObjectColorBlend(self, e_red, e_green, e_blue, e_alpha, 1, blendtime, 0, broadPacket);
    if kill == 2 then  
    	SetLifeTime(self, blendtime, 1)
    end
end


function DRT_KNOCKBACK_RUN(self, from, power, hAngle, vAngle, kdCount, speed, verticalPow)	
    KnockDown_Serv(self, from, power, hAngle, vAngle, kdCount, speed, verticalPow)	
end

function DRT_KNOCKB_RUN(self, from, power, hAngle, vAngle, speed)	
    KnockBack_Serv(self, from, power, hAngle, vAngle, speed)	
end

function DRT_KILL(self)
	Kill(self);
end

function DRT_DEAD(self)
	Dead(self);
end

function DRT_MOVE_BY_WMOVE(self, fileName)
	
end

function PLAY_ANIM_RUN(self, AnimID, freezeanim, skipIfExist, readyTime, animSpd)
    PlayAnim(self, AnimID, freezeanim, skipIfExist, readyTime, animSpd)
end

function TRACK_ACTOR_FUNC(self, funcname, argObj1)
    local func = _G[funcname]
    if func ~= nil then
        func(self, argObj1)
    else
        print(funcname, ScpArgMsg("Auto_HamSuKa_eopeum"))
    end
end

function DRT_SET_WIDE_VIEW(self, range)
	SetWideViewRange(self, range);
end

function DRT_RUN_FUNCTION(self, script)
    RunScript(script, self)
end

function DRT_FACTIONCHANGE(self, factionName)
    SetCurrentFaction(self, factionName)
end

function DRT_SETRENDER(self, select)
    if select == 0 then
        SetRenderOption(self, "Freeze", 1);
    elseif select == 1 then
        SetRenderOption(self, "Stonize", 1);
    end
end

function DRT_SETRENDER_REMOVE(self, select)
    if select == 0 then
        SetRenderOption(self, "Freeze", 0);
    elseif select == 1 then
        SetRenderOption(self, "Stonize", 0);
    end
end

function DRT_SETHOOKMSGOWNER(self, pc, setowner, die)
    if pc == nil then
        print(ScpArgMsg("Auto_DRT_nonePc"))
        return
    else
        SetHookMsgOwner(self, pc)
    end
    
    if setowner == 1 then
        if die == 1 then
            SetOwner(self, pc, 1)
        else
            SetOwner(self, pc, 0)
        end
    else
        return
    end
end



function DRT_CHANGESCALE_OBJ(self, scale, blendTime)
	local broadcastPacket = 1;

	if IsDirectionEndByClient() == 1 then
		broadcastPacket = 0;
	end
	
	ChangeScale(self, scale, blendTime, broadcastPacket);
end

function SCR_CREATE_SSN_SCALE_CHANGE_RUN(self, sObj)
    sObj.Goal1 = self.Scale
    sObj.Goal3 = (self.Scale + sObj.Goal10)
    sObj.Goal4 = 1
    SetTimeSessionObject(self, sObj, 1, self.NumArg4, 'SCR_SSN_SCALE_CHANGE_RUN_RUN')
end

function SCR_REENTER_SSN_SCALE_CHANGE_RUN(self, sObj)
    SetTimeSessionObject(self, sObj, 1, self.NumArg4, 'SCR_SSN_SCALE_CHANGE_RUN_RUN')
end

function SCR_DESTROY_SSN_SCALE_CHANGE_RUN(self, sObj)
end

function SCR_SSN_SCALE_CHANGE_RUN_RUN(self, sObj, remainTime)
    
    if sObj.Goal2 == 0 then
        if sObj.Goal10 > 1 then
            if sObj.Goal1 <= sObj.Goal10 then
                sObj.Goal1 = sObj.Goal1 + sObj.Goal11
                ChangeScale(self, sObj.Goal1, 0.05)
            else
                DestroySessionObject(self, sObj)
            end
        elseif self.NumArg2 <= 1 then
            if sObj.Goal4 > sObj.Goal10 then
                sObj.Goal4 = sObj.Goal4 - sObj.Goal11
                if sObj.Goal4 > sObj.Goal10 then
                    if sObj.Goal4 > 0 then
                        ChangeScale(self, sObj.Goal4, 0.05)
                    end
                end
            else
                DestroySessionObject(self, sObj)
            end
        end
    else
    end
end


--Move3D
function DRT_MOVE3D(self, target, speed, accel, holdMove, holdAI)
    if self ~= nil and target ~= nil then
        local x, y, z = GetPos(target)
        Move3D(self, x, y, z, speed, accel, holdMove, holdAI)
    end
end


--DRT_ADDBUFF
function DRT_ADDBUFF(self, target, buffname, buffLv, arg2, time, over)
    AddBuff(self, target, buffname, buffLv, arg2, time, over);
end


function DRT_SWAPOBJ_RUN(self, target)
    local x, y, z = GetPos(target)
    local angle = GetDirectionByAngle(target)

    SetPos(self, x, y, z)
    SetDirectionByAngle(self, angle)
end

function DRT_LINK_OBJECT(self, target, linkEft, fromNode, toNode)
	LinkObject(self, target, linkEft, fromNode, toNode)
end


function DRT_CHAT_RUN(self, Msg, lifeTime)
    if lifeTime == nil then
        Chat(self, Msg);
    else
        Chat(self, Msg, lifeTime);
    end
end


function DRT_PLAY_FORCE(self, target, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, collRange, createLength, radiusSpd, searchType, searchRange)
	local skill = GetNormalSkill(self);
	ForceDamage(self, skill, target, self, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, 0, collRange, createLength, radiusSpd)
end
		
function DRT_MOVE_TO_TARGET(self, tgtHandle, range)
	MoveToTarget(self, tgtHandle, range);
end

function DRT_LOOKAT(self, tgtHandle)
    LookAt(self, tgtHandle)
end

function DRT_JUMP_TO_POS(self, x, y, z, moveTime, jumpPower)
	JumpToPos(self, x, y, z, moveTime, jumpPower);
end

function DRT_SETPOS(self, x, y, z)
    SetPos(self, x, y, z)
end

function DRT_SERVER_PLAYPOSE(self, posID)
	PlayPose(self,posID);
end

function DRT_SERVER_ANIM(self, animName, freeze)
    PlayAnim(self, animName, freeze, 1)
end

function DRT_SET_PC_SSN(self, sObj, value)
	local list, cnt = GetLayerPCList(self);
	for i = 1 , cnt do
	    local quest_ssn = GetSessionObject(list[i], sObj)
	    if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
        	    quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
        	end
	    end
	end
end

function DRT_COPY_AROUND_OBJ(self, range, faction, argstr)
    
    if GetLayer(self) ~= 0 then
        local zoneID = GetZoneInstID(self);
    	local list, Cnt = GetLayerMonList(zoneID, 0);
        local i
        local mon = {}
        for i = 1, Cnt do
            if list[i].Faction == faction then
                if GetDistance(self, list[i]) <= range then
                    local argstr1, argstr2, argstr3 = GetTacticsArgStringID(list[i])
                    if argstr == argstr3 then
                        local x, y, z = GetPos(list[i])
                        local angle = GetDirectionByAngle(list[i]);
                        local tactics = list[i].Tactics
                        local btree = list[i].BTree
                        local simple_AI = list[i].SimpleAI
                        local dialog = list[i].Dialog
                        local enter = list[i].Enter
                        local leave = list[i].Leave
                        local mon_range = list[i].Range
                        mon[i] = CREATE_MONSTER_EX(self, list[i].ClassName, x, y, z, angle, faction, list[i].Lv, DRT_COPY_AROUND_OBJ_RUN, simple_AI, btree, tactics, dialog, enter, leave, mon_range, list[i]);
                    end
                end
            end
        end
    end
end

function DRT_COPY_AROUND_OBJ_RUN(mon, simple_AI, btree, tactics, dialog, enter, leave, mon_range, mon_obj)
    mon.Name = mon_obj.Name
    mon.Dialog = dialog
    mon.Enter = enter
    mon.Leave = leave
    mon.Range = mon_range
    if simple_AI ~= nil and simple_AI ~= 'None' then
        mon.SimpleAI = simple_AI
        mon.BTree = 'None'
        mon.Tactics = 'None'
    elseif btree ~= nil and btree ~= 'None' then
        mon.SimpleAI = 'None'
        mon.BTree = btree
        mon.Tactics = 'None'
    elseif tactics ~= nil and tactics ~= 'None' then
        mon.SimpleAI = 'None'
        mon.BTree = 'None'
        mon.Tactics = tactics
    end
end

function DRT_COPY_AROUND_NAME(self, range, func_name)
    
    local t = SCR_STRING_CUT(func_name)
    local t2 = {}
        for i = 1, #t do
            t2[#t2 +1] = {}
            t2[#t2][1] = t[i]
        end
    
    AROUND_NPC_GEN(self, GetLayer(self), t2, range)
end



function DRT_FUNC_ACT(self, script)
    RunScript(script, self)
end

function DRT_FUNC_UNHIDENPC(self, npcFunctionName)
    UnHideNPC(self, npcFunctionName)
end

function DRT_FUNC_HIDENPC(self, npcFunctionName)
    HideNPC(self, npcFunctionName)
end

function DRT_RUN_OBJ(self, obj, script)
    RunScript(script, self, obj)
end


function DRT_MOVETOTGT(self, obj, range)
    MoveToTarget(self, obj, range);
end





function DRT_PC_TO_SAVE(self, ssn_name)
    local zoneInst = GetZoneInstID(self);
    local pc_list, pc_cnt = GetLayerPCList(zoneInst, GetLayer(self))
    local i
    if pc_cnt ~= nil then
        for i = 1, pc_cnt do
            local sObj = GetSessionObject(pc_list[i], ssn_name)
            if sObj ~= nil then
                SetArgObj4(sObj, self)
            end
        end
    end
end


function DRT_BALL_DLG(self, msg, time)
    ShowBalloonText(self, msg, time)
end
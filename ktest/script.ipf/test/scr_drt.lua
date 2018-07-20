function KILL_BLEND(self, blendtime, buff)
    if blendtime == 0 then
        blendtime = 1
    end
    
    if buff == 1 then
        if IsBuffApplied(self, 'DRT_KILLING_WAIT') == 'YES' then
            return
        end
        AddBuff(self, self, 'DRT_KILLING_WAIT', 1, 0, 0, 1)
    end

    ObjectColorBlend(self, 255, 255, 255, 0, 1, blendtime);
    RunZombieScript('SCR_KILL_SLEEP', self, blendtime)
end

function SCR_KILL_SLEEP(self, blendtime)
    sleep(blendtime*1000)
    Kill(self)
end


function SCR_SENDMSG_CNT(self, ssn_classname, icon, msgArg, value, time)
    if time <= 0 then
        time = 2
    end
    if value <= 0 and value > 10 then
        return
    end
    
    local quest_ssn = GetSessionObject(self, ssn_classname)
    
    if quest_ssn == nil then
        return
    else
        local QuestInfoValue = "QuestInfoValue"..value
        local QuestInfoMaxCount = "QuestInfoMaxCount"..value
        SendAddOnMsg(self, 'NOTICE_Dm_'..icon, ScpArgMsg(msgArg).."{nl}( "..quest_ssn[QuestInfoValue].." / "..quest_ssn[QuestInfoMaxCount].." )", time)
    end
end


function SCR_SSN_GETITEM_NOTICE_RUN(self, sObj, msg, argObj, giveWay, itemType, itemCount, hookInfo)
    local itemname = GetClassString('Item', itemType, 'ClassName')
    local itemIES = GetClass('Item', itemname)
    
    local i
    for i = 1, 5 do
        local item_classname = GetClassString("QuestProgressCheck_Auto", sObj.QuestName, 'Success_TakeItemName'..i)
        if item_classname == itemname then
            SendAddOnMsg(self, 'NOTICE_Dm_GetItem', itemIES.Name..ScpArgMsg('PUBLIC_GET_QUESTITEM'), 8)
        end
    end
end


function SCR_SENDMSG_CNT_INVITEM(self, quest_classname, item_className, icon, msgArg, value, time)
    if time <= 0 then
        time = 2
    end
    if value <= 0 and value > 10 then
        return
    end
    local questIES = GetClass('QuestProgressCheck', quest_classname);
    local item_cnt = GetInvItemCount(self, item_className)
    if questIES == nil then
        return
    else
        if questIES.Succ_InvItemCount1 >= item_cnt then
        SendAddOnMsg(self, 'NOTICE_Dm_'..icon, ScpArgMsg(msgArg).."{nl}( "..item_cnt.." / "..questIES.Succ_InvItemCount1.." )", time)
    end
end
end


function SCR_SENDMSG_CNT_KILLMON(self, ssn_classname, icon, msgArg, value, time)
    if time <= 0 then
        time = 2
    end
    if value <= 0 and value > 10 then
        return
    end
    
    local quest_ssn = GetSessionObject(self, ssn_classname)
    local quest_classname = quest_ssn.QuestName
    local questIES = GetClass('QuestProgressCheck', quest_classname);

    if quest_ssn == nil or questIES == nil then
        return
    else
        local QuestInfoValue = "QuestInfoValue"..value
        local QuestInfoMaxCount = "QuestInfoMaxCount"..value
        SendAddOnMsg(self, 'NOTICE_Dm_'..icon, ScpArgMsg(msgArg).."{nl}( "..quest_ssn.KillMonster1.." / "..questIES.Succ_MonKillCount1.." )", time)
    end
end


-- Caution :: only value1 
function DOTIMEACTION_CHARGE(pc, target, msg, anim, second, quest_sObj, add_value, sObj_name, ridingAnim)
    CancelMouseMove(pc)
    anim = DOTIMEACTION_RIDING_ANIM_CHANGE(pc,anim, ridingAnim)
    
    if IsBuffApplied(target, 'DOCHARGE_ACTION_RESTRAIN') == 'YES' then
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("TryLater"), 1);
        return 0
    else
        AddBuff(target, target, 'DOCHARGE_ACTION_RESTRAIN', 1, 0, 2000, 1)
    end
	local quest_ssn = GetSessionObject(pc, quest_sObj)
	if quest_ssn == nil then
	    return 0
	elseif quest_ssn.QuestInfoValue1 >= quest_ssn.QuestInfoMaxCount1 then
	    return 3
	end
	
	if target == nil or IsDead(target) == 1 then
	    return 0
	end
	

    local xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
	if xac_ssn == nil then
    	CreateSessionObject(pc, 'SSN_EV_STOP', 1)
    	xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
		if xac_ssn == nil then
			return -2;
		end
		xac_ssn.Step1 = (second*1000 + 2000)
    else
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("TryLater"), 1);
        return -2;
    end  

    if sObj_name ~= nil and sObj_name ~= 'None' then
        CreateSessionObject(pc, sObj_name, 1)
        local sObj = GetSessionObject(pc, sObj_name)
        if sObj ~= nil then
            sObj.Count = second
        end
    end

	local result = DoTimeAction(pc, msg, anim, second);
	if result == 0.0 then
		StopScript();
		sleep(10);
		DestroySessionObject(pc, xac_ssn)
		return 0;
	end
 
	while 1 do		
		result = GetTimeActionResult(pc, 1);	
        
		if result == 1 then
			if IsRest(pc) == 1 then
				PlayAnim(pc, 'REST')
			else
				PlayAnim(pc, 'STD')  
			end
           
            DestroySessionObject(pc, xac_ssn)
			return 1;
		end
		
		if result == 0 then
			if IsRest(pc) == 1 then
				PlayAnim(pc, 'REST')
			else 
			    PlayAnim(pc, 'STD')
			end
		    DestroySessionObject(pc, xac_ssn)
			return 0;
		end

        if target ~= nil or IsDead(target) ~= 1 then
            local target_ssn = GetSessionObject(target, 'SSN_DOCHARGE_ACTION')
            if target_ssn ~= nil then
                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                    SCR_PARTY_QUESTPROP_ADD(pc, quest_ssn.ClassName, 'QuestInfoValue1', 1)
--                    quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + add_value
                end
                if target_ssn.Goal1 >= 0 then
                    if target_ssn.Goal2 < 10 then
                        target_ssn.Goal2 = target_ssn.Goal2 + 1
                    else
                        target_ssn.Goal1 = target_ssn.Goal1 - add_value
                        target_ssn.Goal2 = 0
                    end
                else
        			if IsRest(pc) == 1 then
        				PlayAnim(pc, 'REST')
        			else 
        			    PlayAnim(pc, 'STD')
        			end
        			
        		    DestroySessionObject(pc, xac_ssn)
        		    Kill(target)
                end
            end
        end
		sleep(800);
	end
    DestroySessionObject(pc, xac_ssn)
	return 0;	
		
end


function SCR_DOCHARGE_ACTION(self, pc, cnt_value)
    if cnt_value > 0 then
        if self ~= nil or IsDead(self) ~= 1 then
            local target_ssn = GetSessionObject(self, 'SSN_DOCHARGE_ACTION')
            if target_ssn == nil then
                CreateSessionObject(self, 'SSN_DOCHARGE_ACTION')
                target_ssn = GetSessionObject(self, 'SSN_DOCHARGE_ACTION')
                target_ssn.Goal1 = cnt_value
                return target_ssn.Goal1
            else
                if target_ssn.Goal1 > 0 then
                    return target_ssn.Goal1
                else
                    Kill(self)
                end
            end
        end
    end
end

function SCR_CREATE_SSN_DOCHARGE_ACTION(self, sObj)
--    SetTimeSessionObject(self, sObj, 1, 500, 'SSN_DOCHARGE_ACTION_RUN')
end

function SCR_REENTER_SSN_DOCHARGE_ACTION(self, sObj)
--    SetTimeSessionObject(self, sObj, 1, 500, 'SSN_DOCHARGE_ACTION_RUN')
end

function SCR_DESTROY_SSN_DOCHARGE_ACTION(self, sObj)
end

function SSN_DOCHARGE_ACTION_RUN(self, sObj)
    if sObj.Step1 < 10 then
        sObj.Step1 = sObj.Step1 + 1
        return
    end
    if sObj.Goal1 <= 0 then
        DestroySessionObject(self, sObj)
    end
end





-- Caution :: only value1 
function DOTIMEACTION_CHARGE_RNDCNT_ITEM(pc, target, msg, anim, second, quest_sObj, quest_item, add_value, chance_rate, delay_time, sObj_name, ridingAnim)
    CancelMouseMove(pc)
    anim = DOTIMEACTION_RIDING_ANIM_CHANGE(pc,anim, ridingAnim)
   
    if chance_rate > 0 and chance_rate <= 100 then
    else

        return
    end

    if IsBuffApplied(target, 'DOCHARGE_ACTION_RESTRAIN') == 'YES' then
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("TryLater"), 1);
        return 0
    else
        AddBuff(target, target, 'DOCHARGE_ACTION_RESTRAIN', 1, 0, 2000, 1)
    end
	local quest_ssn = GetSessionObject(pc, quest_sObj)
	if quest_ssn == nil then
	    return 0
	elseif quest_ssn.QuestInfoValue1 >= quest_ssn.QuestInfoMaxCount1 then
	    return 3
	end
	
	if target == nil or IsDead(target) == 1 then
	    return 0
	end
	 

    local xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
	if xac_ssn == nil then
    	CreateSessionObject(pc, 'SSN_EV_STOP', 1)
    	xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
		if xac_ssn == nil then
			return -2;
		end
		xac_ssn.Step1 = (second*1000 + 2000)
    else
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("TryLater"), 1);
        return -2;
    end  

    if sObj_name ~= nil and sObj_name ~= 'None' then
        CreateSessionObject(pc, sObj_name, 1)
        local sObj = GetSessionObject(pc, sObj_name)
        if sObj ~= nil then
            sObj.Count = second
        end
    end

	local result = DoTimeAction(pc, msg, anim, second);
	if result == 0.0 then
		StopScript();
		sleep(10);
		DestroySessionObject(pc, xac_ssn)
		return 0;
	end

    if delay_time <= 0 then
        delay_time = 5
    end

	while 1 do		
		result = GetTimeActionResult(pc, 1);	
        
		if result == 1 then
			if IsRest(pc) == 1 then
				PlayAnim(pc, 'REST')
			else
				PlayAnim(pc, 'STD')  
			end
           
            DestroySessionObject(pc, xac_ssn)
			return 1;
		end
		
		if result == 0 then
			if IsRest(pc) == 1 then
				PlayAnim(pc, 'REST')
			else 
			    PlayAnim(pc, 'STD')
			end
		    DestroySessionObject(pc, xac_ssn)
			return 0;
		end
        
        if target ~= nil or IsDead(target) ~= 1 then
            
            local target_ssn = GetSessionObject(target, 'SSN_DOCHARGE_ACTION')
            if target_ssn ~= nil then
            
                if target_ssn.Goal1 >= 0 then
                    
                    if target_ssn.Goal2 < 2 then
                        target_ssn.Goal2 = target_ssn.Goal2 + 1
                    else
                        if target_ssn.Goal3 < delay_time then
                            target_ssn.Goal3 = target_ssn.Goal3 + 1
                        else
                            if IMCRandom(1, 100) < chance_rate then
                                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                                    SCR_PARTY_QUESTPROP_ADD(pc, quest_ssn.ClassName, 'QuestInfoValue1', 1, nil, quest_item..'/1')
                                end
                            end
                            target_ssn.Goal3 = 0
                        end
                        target_ssn.Goal1 = target_ssn.Goal1 - add_value
                        target_ssn.Goal2 = 0
                    end
                else
        			if IsRest(pc) == 1 then
        				PlayAnim(pc, 'REST')
        			else 
        			    PlayAnim(pc, 'STD')
        			end
        			
        		    DestroySessionObject(pc, xac_ssn)
        		    Kill(target)
                end
            end
        end
		sleep(800);
	end
    DestroySessionObject(pc, xac_ssn)
	return 0;	
		
end
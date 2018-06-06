-- monskl_enable.lua

function SKL_CHK_OOBE(self, skl)

    local oobe = GetOOBEObject(self);
    if oobe == nil then
        return 0;
    end
    
    return 1;

end

function SKL_CHECK_FORMATION_STATE(self, skl, checkValue)

    if GetFormationName(self) == "None" then
        if checkValue == 1 then
            return 0;
        end

        return 1;
    end

    if checkValue == 1 then
        return 1;
    end

    return 0;
end

function SKL_CHECK_BUFF_STATE(self, skl, buffName)
    if IsBuffApplied(self, buffName) == "YES" then
        return 1;
    end
    return 0;
end

function SKL_CHECK_BUFF_NO_STATE(self, skl, buffName)
    if IsBuffApplied(self, buffName) == "YES" then
        return 0;
    end
    return 1;
end

function SKL_CHECK_BRING_COMPANION(self, skl, jobID, propName)
    local hawk = GetSummonedPet(self, jobID);
    if hawk == nil then
        return 0;
    end

    if IS_LOCK_HAWK_ACTION(hawk) == 1 then
        return 0;
    end
    return 1;
end


function SKL_CHECK_RIDING_COMPANION(self, skl)
    return GetVehicleState(self);
end


function SKL_CHECK_MOVEING(self, skl)
    return IsMoving(self);
end

function SKL_CHECK_FORMATION_NAME_EQUAL(self, skl, checkName)
    local name = GetFormationName(self);
    if checkName == name then
        return 1;
    end

    return 0;
end

function SKL_CHECK_FORMATION_NAME(self, skl, checkName)
    
    local name = GetFormationName(self);
    if name == "None" or checkName == name then
        return 0;
    end

    return 1;
end

function SKL_CHECK_CHECK_BUFF(self, skl, buffName)
    if GetBuffByName(self, buffName) == nil then
        return 0;
    end

    if buffName == 'IronHook' and nil ~= GetAbility(self, 'Corsair7') then
        return 0;
    end

    return 1;
end

function SKL_CHECK_CHECK_NOBUFF(self, skl, buffName)
    if GetBuffByName(self, buffName) == nil then
        return 1;
    end
    
    return 0;
end

function CHECK_IS_VILLAGE(self, skl)
    if IsVillage(self) == "YES" then
        return 0;
    end
    
    return 1;
end

function SKL_CHECK_HAWK_DIST(self, skl, range)
    local hawk = GetSummonedPet(self, PET_HAWK_JOBID);
    if hawk == nil then
        return 0;
    end

    if GetDistance(self, hawk) > range then
        SendSysMsg(self, "DistanceIsTooFar");
        return 0;
    end

    return 1;
end

function SKL_CHECK_NEAR_PAD(self, skl, padName, isExist, range, padStyle)
    local x, y, z = GetPos(self);
    local padCount = SelectPadCount(self, padName, x, y, z, range, padStyle);
    if isExist == 0 then
        if padCount == 0 then
            return 1;
        end

        return 0;
    else
        if padCount > 0 then
            return 1;
        end

        return 0;
    end
    
    return 0;
end

function SKL_CHECK_SKL_OBJ_CNT(self, skl, checkPVP, propName, value)
    if checkPVP == 1 then
        if IsPVPServer(self) == 1 then
            local cmd = GetMGameCmd(self);
            if cmd ~= nil then
                local handle = GetHandle(self)
                local currentCnt = cmd:GetUserValue(propName..handle);
                if currentCnt >= value then
                    SendSysMsg(self, 'CannotCreateAnyMore');
                    return 0;
                end
            end
        end
        return 1;
    end

    local currentCnt = GetExProp(self, propName)
    if currentCnt >= value then
        SendSysMsg(self, 'CannotCreateAnyMore');
        return 0;
    end

    return 1;
end

function SKL_CHECK_EXARGOBJECT(self, skl, objName)
    if GetExArgObject(self, objName) == nil then
        return 0;
    end

    return 1;
end


function SKL_CHECK_VIS(self, skill, spend)

    local MyMoneyCount = GetInvItemCount(self, 'Vis');
    if MyMoneyCount < spend then
        SysMsg(self, "Item", ScpArgMsg("NOT ENOUGH MONEY"));
        return 0;
    end
    
    RunScript('SKL_SPEND_MONEY', self, spend)
    
    return 1;

end


function SKL_CHECK_ITEM(self, skill, item, spend)
    local itemCnt = GetInvItemCount(self, item);
    if itemCnt  < spend then
        SysMsg(self, "Item", ScpArgMsg("Auto__aiTemi_PilyoLyange_MoJaLapNiDa"));
        return 0;
    end
        
    return 1;
end

function SKL_SPEND_MONEY(self)
    local tx = TxBegin(pc);
    TxTakeItem(tx, 'Vis', spend, 'SKL_SPEND_MONEY');
    local ret = TxCommit(tx);
end



function HAWK_SKILL_PRE_CHECK(self, skl)
    local hawk = GetSummonedPet(self, PET_HAWK_JOBID);
    if hawk == nil then
        SendSysMsg(self, 'SummonedPetDoesNotExist');
        return 0;
    end
    
    if HAWK_CHECK_ACTIVE_STATE(self, skl) ~= 1 then
        SendSysMsg(self, 'CompanionIsNotActive');
        return 0;
    end
    
    local flyingAway = GetExProp(hawk, "FLYING_AWAY");
    if flyingAway == 1 then
        return 0;
    end
    
    local _hide = IsHide(hawk);
    if _hide == 1 then
        return 0;
    end
    
    return 1;
end

function HAWK_CHECK_ACTIVE_STATE(self, skl)
    local hawk = GetSummonedPet(self, PET_HAWK_JOBID);
    if hawk == nil then
        return 0;
    end
    
    local isActive = TryGetProp(hawk, 'IsActivated');
    if isActive ~= 1 then
        return 0;
    end
    
    return 1;
end

function PET_SKILL_PRE_CHECK(self, skl)
    local pet = GetSummonedPet(self, PET_COMMON_JOBID);
    if pet == nil then
        SendSysMsg(self, 'SummonedPetDoesNotExist');
        return 0;
    end
    
    if PET_CHECK_ACTIVE_STATE(self, skl) ~= 1 then
        SendSysMsg(self, 'CompanionIsNotActive');
        return 0;
    end

    if PET_CHECK_PAUSE_PET_SKILL(self, skl) ~= 1 then
        SendSysMsg(self, 'YouCanNotUseSkillCompanionCoolTime');
        return 0;
    end
    
    local _hide = IsHide(pet);
    if _hide == 1 then
        return 0;
    end
    
	local companionClass = GetClass('Companion', pet.ClassName);
	if companionClass ~= nil then
		if TryGetProp(companionClass, 'RidingOnly') == 'YES' then
			SendSysMsg(self, 'ThisCompanionIs NotPossible');
			return 0;
		end
	end
    
    return 1;
end

function PET_CHECK_ACTIVE_STATE(self, skl)
    local pet = GetSummonedPet(self, PET_COMMON_JOBID);
    if pet == nil then
        return 0;
    end
    
    local isActive = TryGetProp(pet, 'IsActivated');
    if isActive ~= 1 then
        return 0;
    end
    return 1;
end

function PET_CHECK_PAUSE_PET_SKILL(self, skl)
    local pet = GetSummonedPet(self, PET_COMMON_JOBID);
    if pet == nil then
        return 0;
    end
    
    local pauseCount = GetExProp(pet, "PAUSE_PET_SKILL");
    if pauseCount == nil or pauseCount > 0 then
        return 0;
    end
    return 1;
end
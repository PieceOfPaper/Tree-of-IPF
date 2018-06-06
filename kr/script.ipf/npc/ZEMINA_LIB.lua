
function ZEMINA_STATUE_ENTER(self, pc)
    if GetMapNPCState(pc, GetGenType(self)) ~= 1 then
        PlayAnimLocal(self, pc, 'HOLD', 0)
    end
end

function ZEMINA_STATUE_LEAVE(self, pc)
    RemoveEffect(self, 'F_light023_orange', 1)
    RemoveEffect(self, 'F_light024_orange', 1)
    RemoveEffect(self, 'statue_zemina_light1', 1)
end

function ZEMINA_STATUE_DIALOG(self, pc)
    local genID = GetGenTypeID(self)
    --print(genID)
    if genID ~= nil then
        local npcState = GetMapNPCState(pc, genID)
        local sObj = GetSessionObject(pc, 'ssn_klapeda')
        local sObj_prop = self.Dialog..'_P'
        local propValue =  TryGetProp(sObj, sObj_prop)
        if npcState == 1 and propValue ~= nil and propValue == 0 then
            PlayAnimLocal(self, pc, 'ON', 0)
            PlayAnimLocal(self, pc, 'HOLD', 0)
            PlayAnimLocal(pc, pc, 'WORSHIP', 1)
            AttachEffect(pc, 'F_pc_statue_wing', 10, "TOP", 0);
            local result2 = DOTIMEACTION_B(pc, ScpArgMsg('Auto_KyeongBae_Jung'), 'WORSHIP', 2, 'SSN_ATTACH_EFF', 'F_pc_statue_wing')
            if result2 == 1 then
                local result1 = GetSessionObject(pc, 'SSN_ATTACH_EFF')
                if result1 ~= nil then
                    local beforeValue = pc.StatByBonus
                    local tx = TxBegin(pc);
                    TxChangeNPCState(tx, genID, 20);
                    --print(npcState)
                    TxAddIESProp(tx, pc, 'StatByBonus', 1)
                    TxSetIESProp(tx, sObj, sObj_prop, 300)
                    local ret = TxCommit(tx);
                    local afterValue = pc.StatByBonus
                    CustomMongoLog(pc, "StatByBonusADD", "Layer", GetLayer(pc), "beforeValue", beforeValue, "afterValue", afterValue, "addValue", 1, "Way", self.Dialog, "Type", "F_ZEMINA")
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("STATUE_STAT_01"), 3)
                    DetachEffect(self, 'F_light024_orange')
                    DestroySessionObject(pc, result1)
                end
                return result2
            else
                PlayAnimLocal(self, pc, 'STD', 0)
                DetachEffect(self, 'F_light023_orange')
                DetachEffect(self, 'F_light024_orange')
                DetachEffect(self, 'statue_zemina_light1')
            end
        end
    end
    
    
end


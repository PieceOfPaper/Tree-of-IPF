function SCR_GOODDESS_ZEMINA(self, pc, argNum, evt)
    if self.ClassName ~= 'statue_zemina' then
        return
    end
    
    PlayAnimLocal(self, pc, 'ON', 0)
    PlayAnimLocal(self, pc, 'HOLD', 0)
    PlayAnimLocal(pc, pc, 'WORSHIP', 1)
    AttachEffect(pc, 'F_pc_statue_wing', 10, "TOP", 0);
    local result2 = DOTIMEACTION_B(pc, ScpArgMsg('Auto_KyeongBae_Jung'), 'WORSHIP', 2, 'SSN_ATTACH_EFF', 'F_pc_statue_wing')
    if result2 == 1 then
        local result1 = GetSessionObject(pc, 'SSN_ATTACH_EFF')
        if result1 ~= nil then
            local tx = TxBegin(pc);
            TxChangeNPCState(tx, evt.genType, 1);
            local beforeValue = pc.StatByBonus
            TxAddIESProp(tx, pc, 'StatByBonus', 1)
            local ret = TxCommit(tx);
            local afterValue = pc.StatByBonus
            CustomMongoLog(pc, "StatByBonusADD", "Layer", GetLayer(pc), "beforeValue", beforeValue, "afterValue", afterValue, "addValue", 1, "Way", "SCR_GOODDESS_ZEMINA", "Type", "F_ZEMINA")
			
            DetachEffect(self, 'F_light024_orange')
            DestroySessionObject(pc, result1)
        end
    else
        PlayAnimLocal(self, pc, 'STD', 0)
        DetachEffect(self, 'F_light023_orange')
        DetachEffect(self, 'F_light024_orange')
        DetachEffect(self, 'statue_zemina_light1')
    end
end



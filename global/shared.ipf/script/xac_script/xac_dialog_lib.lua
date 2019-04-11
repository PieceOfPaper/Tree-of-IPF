--self´Â È¥¶õ½º·¯¿ö¼­ pc·Î ¹Ù²Þ

function EV_KNOCK_LIB(pc, x, y, z, xacClassName, xacModelName)
    local xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
    
    if xac_ssn == nil then
        CreateSessionObject(pc, 'SSN_EV_STOP', 1)
        local xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
        if xac_ssn.Goal1 == 0 then
            xac_ssn.Goal1 = 1
            if GetXacState(pc, xacClassName) == 0 then
                return 1;
            end
        end
        return 0;
    end
end

function EV_KNOCK_LIB_REWARD(pc, x, y, z, xacClassName, xacModelName)
    RunScript('EV_KNOCK_LIB_RUN', pc, x, y, z, xacClassName, xacModelName)
end



function EV_KNOCK_LIB_RUN(pc, x, y, z, xacClassName, xacModelName)
    local result = DOTIMEACTION_R(pc, ScpArgMsg('Auto_NoKeu_Jung'), 'KNOCK', 1)
    if result == 1 then
        
        local tx = TxBegin(pc);
        
        PlaySound(pc, 'money_jackpot')
        
        XAC_EVENTEXPUP(pc, x, y, z, tx)
        
        TxSetXacState(tx, xacClassName, 1)
        
        local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			DROP_XACEVENT(pc, x, y, z, 'Vis', IMCRandom(13, 18))
		end
    end

end



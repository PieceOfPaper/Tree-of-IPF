

g_table_test_zone_evcopy001 = 
{
		{
		},


		{
			{"DIALOG"}, 
		},


		{
			--"LittleGirl_b", 66.066246, -0.013520, -289.089996, 0.126645, "Lv", "1", "Name", ScpArgMsg("Auto_TtaLaHaKiDouMi"), 

		},


		{
			"GenType", "1103001", "STATEANIM_1", "STD", 
		},
};


function SCR_TEST_ZONE_EVCOPY001_DIALOG(self, pc)

		ExecBGEvent(self, pc, 'test_zone_evcopy001');

end

function test_zone_evcopy001_cond(pc, npc, argNum, evt)

    return SCR_evcopy_cond(pc, npc, argNum, evt)


end

function test_zone_evcopy001_act(self, pc, argNum, evt)

    SCR_evcopy_act(self, pc, argNum, evt, 'ABS')


end

function test_zone_evcopy001_quest()

        local pc_obj = RegisterCls('SessionObject', 1103264, 'ssn_test_zone_evcopy001')

        --ChangeClassValue(pc_obj, 'Name', ScpArgMsg("Auto_NPCMalTtaLaHaKi0"))

        ChangeClassValue(pc_obj, 'Script', 'ssn_test_zone_evcopy001')



end



function SCR_CREATE_ssn_test_zone_evcopy001(self, sObj)
    RegisterHookMsg(self, sObj, "Chat", "SCR_ssn_test_zone_evcopy001_Chat", "NO")
end

function SCR_REENTER_ssn_test_zone_evcopy001(self, sObj)
    RegisterHookMsg(self, sObj, "Chat", "SCR_ssn_test_zone_evcopy001_Chat", "NO")
end

function SCR_DESTROY_ssn_test_zone_evcopy001(self, sObj)
    
end

function SCR_ssn_test_zone_evcopy001_Chat(self, sObj, msg, argObj, argStr, argNum)
    SCR_evcopy_Chat(self, sObj, msg, argObj, argStr, argNum, 'test_zone_evcopy001', 'Drug_HP1', 1)
end




g_table_test_zone_evballgame1 = 
{
		{
		},


		{
			{"DIALOG"}, 
		},


		{
			--"HolyArk", 270.000000, -0.000193, -190.000000, -103.400032, "Enter", "None", "Lv", "1", "Name", ScpArgMsg("Auto_yaKuKeim1"), 

		},


		{
			"GenType", "1101010", 
		},
};


function SCR_TEST_ZONE_EVBALLGAME1_DIALOG(self, pc)

		ExecBGEvent(self, pc, 'test_zone_evballgame1');

end



function SCR_TEST_ZONE_EVBALLGAME1_ENTER(self, pc)

		ExecBGEvent(self, pc, 'test_zone_evballgame1');

end

function test_zone_evballgame1_cond(pc, npc, argNum, evt)

    return SCR_EVBALLGAME_COND(pc, npc, evt)



end

function test_zone_evballgame1_act(self, pc, argNum, evt)

    SCR_EVBALLGAME_ACT(self,pc, 300113, argNum)



end

function test_zone_evballgame1_quest()

        local pc_obj = RegisterCls('SessionObject', 1103263, 'ssn_test_zone_evballgame1')

        --ChangeClassValue(pc_obj, 'Name', ScpArgMsg("Auto_yaKuKeim1"))

        ChangeClassValue(pc_obj, 'Script', 'ssn_test_zone_evballgame1')



end



function SCR_CREATE_ssn_test_zone_evballgame1(self, sObj)
    SCR_CREATE_ssn_evballgame(self, sObj)
end

function SCR_REENTER_ssn_test_zone_evballgame1(self, sObj)
    RegisterHookMsg(self, sObj, "Chat", "SCR_"..sObj.Script.."_Chat", "NO")
end

function SCR_DESTROY_ssn_test_zone_evballgame1(self, sObj)
end

function SCR_ssn_test_zone_evballgame1_Chat(self, sObj, msg, argObj, argStr, argNum)
    SCR_ssn_evballgame_Chat(self, sObj, argStr, 'test_zone_evballgame1', 'Drug_HP1', 1)
end

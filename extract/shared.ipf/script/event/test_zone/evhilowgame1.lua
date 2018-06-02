

g_table_test_zone_evhilowgame1 = 
{
		{
		},


		{
			{"DIALOG"}, 
		},


		{
			"HolyArk", 340.000000, -0.000243, -240.000000, 104.481613, "Enter", "None", "Lv", "1", 

		},


		{
			"GenType", "1101011", 
		},
};


function SCR_TEST_ZONE_EVHILOWGAME1_DIALOG(self, pc)

		ExecBGEvent(self, pc, 'test_zone_evhilowgame1');

end



function SCR_TEST_ZONE_EVHILOWGAME1_ENTER(self, pc)

		ExecBGEvent(self, pc, 'test_zone_evhilowgame1');

end

function test_zone_evhilowgame1_cond(pc, npc, argNum, evt)

    return SCR_EVHILOWGAME_COND(pc, npc, evt)



end

function test_zone_evhilowgame1_act(self, pc, argNum, evt)

		SCR_EVHILOWGAME_ACT(self,pc, 300113, argNum)



end

function test_zone_evhilowgame1_quest()

        local pc_obj = RegisterCls('SessionObject', 1103265, 'ssn_test_zone_evhilowgame1')

        ChangeClassValue(pc_obj, 'Name', ScpArgMsg("Auto_HaiLouKeim1"))

        ChangeClassValue(pc_obj, 'Script', 'ssn_test_zone_evhilowgame1')



end



function SCR_CREATE_ssn_test_zone_evhilowgame1(self, sObj)

    SCR_CREATE_ssn_evhilowgame(self, sObj)

end

function SCR_REENTER_ssn_test_zone_evhilowgame1(self, sObj)

    RegisterHookMsg(self, sObj, "Chat", "SCR_"..sObj.Script.."_Chat", "NO")

end

function SCR_DESTROY_ssn_test_zone_evhilowgame1(self, sObj)

end

function SCR_ssn_test_zone_evhilowgame1_Chat(self, sObj, msg, argObj, argStr, argNum)

    SCR_ssn_evhilowgame_Chat(self, sObj, argStr, 'test_zone_evhilowgame1', 'Drug_HP1', 1)

end

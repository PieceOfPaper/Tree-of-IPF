

g_table_test_zone_ev_1_BoardWrite1 = 
{
		{
		},


		{
			{"DIALOG"}, 
		},


		{
			"Board3", 282.553589, -0.013890, 46.784134, -0.000010, "Lv", "1", 

		},


		{
			"GenType", "1101003", 
		},
};




function test_zone_ev_1_BoardWrite1_cond(pc, npc, argNum, evt)
    return SCR_ev_1_BoardWrite_cond(pc, npc, argNum, evt)
end

function test_zone_ev_1_BoardWrite1_act(self, pc, argNum, evt)
    SCR_ev_1_BoardWrite_act(self, pc, argNum, evt)
end


function SCR_TEST_ZONE_EV_1_BOARDWRITE1_DIALOG(self,pc)
    ExecBGEvent(self, pc, GET_EVENT_NAME(self))
end

function test_zone_ev_1_BoardWrite1_quest()

        local pc_obj = RegisterCls('SessionObject', 1103262, 'ssn_test_zone_ev_1_BoardWrite1')

        ChangeClassValue(pc_obj, 'Name', ScpArgMsg("Auto_KeSiPanKeulNamKiKi1"))

        ChangeClassValue(pc_obj, 'Script', 'ssn_test_zone_ev_1_BoardWrite1')



end



function SCR_CREATE_ssn_test_zone_ev_1_BoardWrite1(self, sObj)
    RegisterHookMsg(self, sObj, "Chat", "SCR_"..sObj.Script.."_Chat", "NO")
end

function SCR_REENTER_ssn_test_zone_ev_1_BoardWrite1(self, sObj)
    RegisterHookMsg(self, sObj, "Chat", "SCR_"..sObj.Script.."_Chat", "NO")
end

function SCR_DESTROY_ssn_test_zone_ev_1_BoardWrite1(self, sObj)
end

function SCR_ssn_test_zone_ev_1_BoardWrite1_Chat(self, sObj, msg, argObj, argStr, argNum)
    SCR_ssn_ev_1_BoardWrite_Chat(self, sObj, msg, argObj, argStr, argNum, 'test_zone_ev_1_BoardWrite1', 'Drug_HP2')
end

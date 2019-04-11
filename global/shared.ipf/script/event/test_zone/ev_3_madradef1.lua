

g_table_test_zone_ev_3_madradef1 = 
{
		{
		},


		{
			{"DIALOG"}, 
		},


		{
			"mandragora2", -33.140179, -0.013776, -58.249435, -0.000010, 

		},


		{
			"GenType", "1103003", 
		},
};


function SCR_TEST_ZONE_EV_3_MADRADEF1_DIALOG(self, pc)

		ExecBGEvent(self, pc, 'test_zone_ev_3_madradef1');

end

function test_zone_ev_3_madradef1_cond(pc, npc, argNum, evt)

		if

		GetMapNPCState(pc, evt.genType) == 0

		then

			return 1;

		end;

		return 0;

end

function test_zone_ev_3_madradef1_act(self, pc, argNum, evt)

		DOTIMEACTION(pc, ScpArgMsg('Auto_PpopNeun_Jung'), '#SITGROPESET', 3.5);

		local tx = TxBegin(pc);

		AddBuff(pc, pc, 'CriticalWound');

		TxChangeNPCState(tx, evt.genType, 1);

		local ret = TxCommit(tx);

		HideNPC(pc, 'test_zone_ev_3_madradef1', 0, 0, 0);

end



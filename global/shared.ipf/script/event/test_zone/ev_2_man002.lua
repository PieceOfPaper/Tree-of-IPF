

g_table_test_zone_ev_2_003 = 
{
		{
		},


		{
			{"DIALOG"}, 
		},


		{
			"mandragora1", -10.072178, -0.013773, -60.211685, -0.000010, 

		},


		{
			"GenType", "1102009", 
		},
};


function SCR_TEST_ZONE_EV_2_003_DIALOG(self, pc)

		ExecBGEvent(self, pc, 'test_zone_ev_2_003');

end

function test_zone_ev_2_003_cond(pc, npc, argNum, evt)

		if

		GetMapNPCState(pc, evt.genType) == 0

		then

			return 1;

		end;

		return 0;

end

function test_zone_ev_2_003_act(self, pc, argNum, evt)

		DOTIMEACTION(pc, ScpArgMsg('Auto_PpopNeun_Jung'), '#SITGROPESET', 3.5);

		AddBuff(pc, pc, 'CriticalWound');

		local tx = TxBegin(pc);

		TxChangeNPCState(tx, evt.genType, 1);

		local ret = TxCommit(tx);

		HideNPC(pc, 'test_zone_ev_2_003', 0, 0, 0);

end







g_table_test_zone_ev_3_mand1 = 
{
		{
		},


		{
			{"DIALOG"}, 
		},


		{
			"mandragora1", -26.274061, -0.013875, 32.420151, -0.000010, 

		},


		{
			"RegenTime", "11000", "GenType", "1103002", 
		},
};


function SCR_TEST_ZONE_EV_3_MAND1_DIALOG(self, pc)

		ExecBGEvent(self, pc, 'test_zone_ev_3_mand1');

end

function test_zone_ev_3_mand1_cond(pc, npc, argNum, evt)

		if

		GetMapNPCState(pc, evt.genType) == 0

		

then

			return 1;

		

end;

		return 0;



end

function test_zone_ev_3_mand1_act(self, pc, argNum, evt)

		DOTIMEACTION(pc, ScpArgMsg('Auto_PpopNeun_Jung'), '#SITGROPESET', 3.5);

		local tx = TxBegin(pc);

		TxChangeNPCState(tx, evt.genType, 1);

		local ret = TxCommit(tx);

		HideNPC(pc, 'test_zone_ev_3_mand1', 0, 0, 0);



end





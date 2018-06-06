

g_table_test_zone_ev_2_mandbuff001 = 
{
		{
		},


		{
			{"DIALOG"}, 
		},


		{
			"mandragora2", -67.840454, -0.023892, 22.713867, 124.321426, "", "", "Lv", "1", 

		},


		{
			"GenType", "1102006", 
		},
};


function SCR_TEST_ZONE_EV_2_MANDBUFF001_DIALOG(self, pc)

		ExecBGEvent(self, pc, 'test_zone_ev_2_mandbuff001');

end

function test_zone_ev_2_mandbuff001_cond(pc, npc, argNum, evt)

		if

		GetMapNPCState(pc, evt.genType) == 0

then

			return 1;

end;

		return 0;



end

function test_zone_ev_2_mandbuff001_act(self, pc, argNum, evt)

		DOTIMEACTION(pc, ScpArgMsg('Auto_PpopNeun_Jung'), '#SITGROPESET', 3.5);

		PlayAnim(self, 'DEAD', 1);

		local tx = TxBegin(pc);

		TxChangeNPCState(tx, evt.genType, 1);

		local ret = TxCommit(tx);

		HideNPC(pc, 'test_zone_ev_2_mandbuff001', 0, 0, 0);



end







g_table_test_zone_ev_2_mongen_back_001 = 
{
		{
		},


		{
			
		},


		{
			"Skrik", 65.915939, -0.024075, 214.232666, 67.320641, 

		},


		{
			"CheckAttack", "1", "GenType", "1102003", 
		},
};


function test_zone_ev_2_mongen_back_001_init(self)

	local sObj = CREATE_SOBJ(self, 'ssn_bgevent')
	RegisterHookMsg(self, sObj, 'TakeDamage', 'TAKEDAMAGE_TEST_ZONE_EV_2_MONGEN_BACK_001', 'NO');

end

function TAKEDAMAGE_TEST_ZONE_EV_2_MONGEN_BACK_001(self, sObj, msg, argObj, argStr, argNum)

	ExecBGEvent(self, argObj, 'test_zone_ev_2_mongen_back_001', argNum);

end

function test_zone_ev_2_mongen_back_001_cond(pc, npc, argNum, evt)

		if

		GetMapNPCState(pc, evt.genType) == 0

		

then

			return 1;

		

end;

		return 0;



end

function test_zone_ev_2_mongen_back_001_act(self, pc, argNum, evt)

		local tx = TxBegin(pc);

		TxChangeNPCState(tx, evt.genType, 1);

		local ret = TxCommit(tx);

		SCR_EVENT_AROUND_MONGEN(self, pc, evt, 5)



end




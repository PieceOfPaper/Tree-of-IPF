

g_table_test_zone_evstatup1 = 
{
		{
		},


		{
			{"DIALOG"}, 
		},


		{
			"statue_ausrine", 273.068604, -0.013731, -96.822693, -90.000000, "Enter", "None", "Lv", "1", 

		},


		{
			"GenType", "110010", "STATEANIM_1", "astd", 
		},
};


function SCR_TEST_ZONE_EVSTATUP1_DIALOG(self, pc)

		ExecBGEvent(self, pc, 'test_zone_evstatup1');

end

function SCR_TEST_ZONE_EVSTATUP1_ENTER(self, pc)

		ExecBGEvent(self, pc, 'test_zone_evstatup1');

end

function test_zone_evstatup1_cond(pc, npc, argNum, evt)

		if

		GetMapNPCState(pc, evt.genType) == 0

		

then

			return 1;

		

end;

		return 0;



end

function test_zone_evstatup1_act(self, pc, argNum, evt)

		local tx = TxBegin(pc);
        local beforeValue = pc.StatByBonus
		TxAddIESProp(tx, pc, 'StatByBonus', 1);

		TxChangeNPCState(tx, evt.genType, 1);

		local ret = TxCommit(tx);
		local afterValue = pc.StatByBonus
        CustomMongoLog(pc, "StatByBonusADD", "Layer", GetLayer(pc), "beforeValue", beforeValue, "afterValue", afterValue, "addValue", 1, "Way", "test_zone_evstatup1_act", "Type", "F_ZEMINA")



end




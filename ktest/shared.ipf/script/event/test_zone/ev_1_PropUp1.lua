

g_table_test_zone_ev_1_PropUp1 = 
{
		{
		},


		{
			{"DIALOG"}, 
		},


		{
			"statue_zemina", 339.916779, -0.013794, -39.454391, -90.000000, "Lv", "1", "Range", "250", "Enter", "test_zone_ev_1_PropUp1", "Leave", "test_zone_ev_1_PropUp1", "Tactics", "STOUP_CAMP", 

		},


		{
			"GenType", "1101004", "STATEANIM_1", "astd", 
		},
};


function SCR_TEST_ZONE_EV_1_PROPUP1_DIALOG(self, pc)

		ExecBGEvent(self, pc, 'test_zone_ev_1_PropUp1');

end
function SCR_TEST_ZONE_EV_1_PROPUP1_ENTER(self, pc)
    if GetMapNPCState(pc, GetGenType(self)) ~= 0 then
        PlayAnimLocal(self, pc, 'HOLD', 0)
    end

end

function SCR_TEST_ZONE_EV_1_PROPUP1_LEAVE(self, pc)
    RemoveEffect(self, 'F_light023_orange', 1)
    RemoveEffect(self, 'F_light024_orange', 1)
    RemoveEffect(self, 'statue_zemina_light1', 1)
    
--    SetEmoticon(pc, 'None')
--    RemoveBuff(pc, 'StoupBuff')
end
function test_zone_ev_1_PropUp1_cond(pc, npc, argNum, evt)

		if

		GetMapNPCState(pc, evt.genType) == 0

		

then

			return 1;

		

end;

		return 0;

end

function test_zone_ev_1_PropUp1_act(self, pc, argNum, evt)
SCR_GOODDESS_ZEMINA(self, pc, argNum, evt)

end


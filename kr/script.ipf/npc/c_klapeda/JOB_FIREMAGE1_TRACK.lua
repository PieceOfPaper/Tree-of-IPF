function SCR_MASTER_BOCORS_FIREMAGE1_DIALOG(self,pc)
    local sObj_quest = GetSessionObject(pc, 'SSN_JOB_FIREMAGE1')
    if sObj_quest ~= nil then
        if sObj_quest.Step1 >= 2 then
            ShowOkDlg(pc, 'JOB_FIREMAGE_succ_prognpc1', 1)
            sObj_quest.QuestInfoValue1 = sObj_quest.QuestInfoMaxCount1
            SetLayer(pc, 0)
        else
            ShowOkDlg(pc, 'JOB_FIREMAGE_prog1', 1)
        end
    end
end

function JOB_FIREMAGE1_TRACK(pc)
	local curzoneID = GetZoneInstID(pc);
	local newlayer = GetNewLayer(pc);
    
    local npc1 = CREATE_NPC(pc, 'npc_bocormaster', -23, 0, 31, 290, 'Neutral', newlayer, ScpArgMsg("Auto_BoKoLeu_MaMa"), 'MASTER_BOCORS_FIREMAGE1')
    
	local mon1 = CREATE_TRACK_MON(pc, "spector_F_purple_J1", 0, 0, -82, 0, "Monster", newlayer, 15, "MON_BASIC", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, None);
	local mon2 = CREATE_TRACK_MON(pc, "spector_F_purple_J1", 52, 0, -69, 0, "Monster", newlayer, 15, "MON_BASIC", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, None);
	
	SetTendency(mon1, 'Attack')
    SetTendency(mon2, 'Attack')

	SetLayer(pc, newlayer);
	CREATE_BATTLE_BOX_INLAYER(pc)

	_TRACK(curzoneID, "PLAYER",
	{
		{"RUNSCRIPT", pc, "DIRECT_START"},
		{"SLEEP", 500},
		{"RUNSCRIPT", pc, "LookAt", npc1},
		{"SLEEP", 200},
		{"RUNSCRIPT", npc1, "LookAt", mon1},
		{"SLEEP", 200},
		{"RUNSCRIPT", 	pc, "TargetCamera", npc1, 10, 20},
		{"RUNSCRIPT", 	pc, "ChangeCameraZoom", 5, 600, -300},
		{"SLEEP", 500},
		{"RUNSCRIPT", pc, "LookAt", mon1},
        {"SLEEP", 1000},
        {"RUNSCRIPT", pc, "LookAt", npc1},
		{"SLEEP", 200},
		{"RUNSCRIPT", 	pc, "TargetCamera", mon1, 10, 30},
        {"SLEEP", 500},
		{"RUNSCRIPT", pc, "CAMERA_RESET"},
		{"RUNSCRIPT", pc, "DIRECT_END"},
		{"RUNSCRIPT", pc, "RestartSuspendedThread"},
	}
	);
end
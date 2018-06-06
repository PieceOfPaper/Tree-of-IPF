function SCR_NPC_KUPOLE_TESTSERVER_TS_BORN_ENTER(self)

  if (GetServerNation() == "KOR" and GetServerGroupID() == 9001) then --큐폴 서버
    local NPC = CREATE_NPC(self, 'NPC_GM', -541.93, 169.41, -302.48, 0, GetCurrentFaction(self), GetLayer(self), ScpArgMsg('TEST_SERVER_GM'), 'NPC_KUPOLE_TESTSERVER', nil, 1, 1, 'MON_DUMMY')
  end
end

function SCR_NPC_KUPOLE_TESTSERVER_TS_BORN_UPDATE(self)
end

function SCR_NPC_KUPOLE_TESTSERVER_TS_BORN_LEAVE(self)
end

function SCR_NPC_KUPOLE_TESTSERVER_TS_DEAD_ENTER(self)
end

function SCR_NPC_KUPOLE_TESTSERVER_TS_DEAD_UPDATE(self)
end

function SCR_NPC_KUPOLE_TESTSERVER_TS_DEAD_LEAVE(self)
end

function SCR_NPC_KUPOLE_TESTSERVER_DIALOG(self, pc)

  if ( GetServerNation() == 'KOR' and ( GetServerGroupID() == 9001 or GetServerGroupID() == 9501 )) then --큐폴 서버
    local now_time = os.date('*t')
    local yday = now_time['yday']
  	local aObj = GetAccountObj(pc);
  	local pcEtc = GetETCObject(pc);
  	if yday ~= aObj.TESTSERVER_DAY_REWARD_DATE then
      local tx = TxBegin(pc);
      TxGiveItem(tx, 'Premium_eventTpBox_20', 1, 'KUPOLE_TESTSERVER_DAY');
      TxGiveItem(tx, 'Premium_indunReset_14d', 3, 'KUPOLE_TESTSERVER_DAY');
      TxGiveItem(tx, 'Ability_Point_Stone', 10, 'KUPOLE_TESTSERVER_DAY');
      TxGiveItem(tx, 'Premium_dungeoncount_Event', 6, 'KUPOLE_TESTSERVER_DAY');
      TxGiveItem(tx, 'ChallengeModeReset', 10, 'KUPOLE_TESTSERVER_DAY');
      TxGiveItem(tx, 'Dungeon_Key01', 15, 'KUPOLE_TESTSERVER_DAY');
      TxGiveItem(tx, 'Premium_SkillReset', 1, 'KUPOLE_TESTSERVER_DAY');
      TxGiveItem(tx, 'Vis', 500000, 'KUPOLE_TESTSERVER_DAY');
      TxSetIESProp(tx, aObj, 'TESTSERVER_DAY_REWARD_DATE', yday)
	    TxSetIESProp(tx, pcEtc, 'IS_LEGEND_CARD_OPEN', 1)
      local ret = TxCommit(tx);
      ShowOkDlg(pc, 'NPC_KUPOLE_TESTSERVER_DLG_01', 1)
      SendAddOnMsg(pc, "MSG_PLAY_LEGENDCARD_OPEN_EFFECT", "", 0)
    else
      ShowOkDlg(pc, 'NPC_KUPOLE_TESTSERVER_DLG_02', 1)
    end
  end
end
--- medal.lua

function GetPCByHandle(pc, handle)

	local pc2 = GetByHandle(pc, handle);
	if pc2 == nil then
		return nil;
	end

	if GetObjType(pc2) ~= OT_PC then
		return nil;
	end

	return pc2;
end

-- �Ϸ翡 ���� �� �ִ� ���̾��� ����
function GET_MAX_RECEIVE_GIFTMEDAL_ONEDAY(pc)
	return 5;
end

-- ���ڸ� ��Ȱ�� �ʿ��� ���̾� ��
function GET_NEED_RESTART_MEDAL(pc)

	local etc = GetETCObject(pc);
	local curDeadCount = etc.ContinueDead;
	local consumeMedal = curDeadCount;

	--return consumeMedal;
	return 1; -- ������ �Ѱ��� ��ȹ ����Ǿ���.
end

-- ��Ȱ�Ҷ� ũ����Ż �Ҹ��Ű��
function RESTART_HERE_BY_MEDAL(pc, item)
	-- ����ó���� �ش� ��ũ��Ʈ ȣ���Ű�� �������� ����.
	if item == nil then
		return
	end

	local tx = TxBegin(pc);
	TxEnableInIntegrateIndun(tx);
	TxTakeItemByObject(tx, item, 1, "Restart");
	local ret = TxCommit(tx);
	
	if ret == "SUCCESS" then
		SetMedalResurrect(pc, 1);
		-- �������� 10�ʰ�
		AddBuff(pc, pc, 'Safe', 0, 0, 10000, 1);

		if IsMGameSoulCristalLimit(pc) == 1 then
			AddMGameSoulCount(pc, 1);
		end
	else
		SetMedalResurrect(pc, 0);
	end
end

function ADD_CONTINUE_DEAD_COUNT(pc)
	
	local tx = TxBegin(pc);	
	local etc = GetETCObject(pc);
	TxAddIESProp(tx, etc, "ContinueDead", 1);
	local ret = TxCommit(tx);

	local consumeMedal = GET_NEED_RESTART_MEDAL(pc);
	SendAddOnMsg(pc, "SET_RESTART_NEED_MEDAL", "", consumeMedal);
end

-- ��Ʈī��Ʈ �ʱ�ȭ
function RESET_CONTINUE_DEAD_COUNT(pc)

	local aobj = GetAccountObj(pc);
	local tx = TxBegin(pc);	
	local etc = GetETCObject(pc);
	TxSetIESProp(tx, etc, "ContinueDead", 0);
	local ret = TxCommit(tx);
end

-- ���� ��ü �ʱ�ȭ CBT�� ������ �Ȳ���
function SCR_TX_RESET_STAT_CBTVER(pc)

	local aobj = GetAccountObj(pc);
	local usedStat = pc.UsedStat;

	if usedStat == 0 then
		return;
	end
	
	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end
	
	TxSetIESProp(tx, pc, "UsedStat", 0);
	
	local STR_STAT = pc.STR_STAT;
	local PRE_STR = pc.STR;
	if STR_STAT > 0 then
		TxSetIESProp(tx, pc, "STR_STAT", 0);
	end
	
	local DEX_STAT = pc.DEX_STAT;
	local PRE_DEX = pc.DEX;
	if DEX_STAT > 0 then
		TxSetIESProp(tx, pc, "DEX_STAT", 0);
	end
	
	local CON_STAT = pc.CON_STAT;
	local PRE_CON = pc.CON;
	if CON_STAT > 0 then
		TxSetIESProp(tx, pc, "CON_STAT", 0);
	end

	local INT_STAT = pc.INT_STAT;
	local PRE_INT = pc.INT;
	if INT_STAT > 0 then
		TxSetIESProp(tx, pc, "INT_STAT", 0);
	end
	
	local MNA_STAT = pc.MNA_STAT;
	local PRE_MNA = pc.MNA;
	if MNA_STAT > 0 then
		TxSetIESProp(tx, pc, "MNA_STAT", 0);
	end

	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		local pcPoint = GET_STAT_POINT(pc);
		StatPointMongoLog(pc, "Init", pcPoint, "STR", 0, PRE_STR, pc.STR);
		StatPointMongoLog(pc, "Init", pcPoint, "CON", 0, PRE_CON, pc.CON);
		StatPointMongoLog(pc, "Init", pcPoint, "INT", 0, PRE_INT, pc.INT);
		StatPointMongoLog(pc, "Init", pcPoint, "MNA", 0, PRE_MNA, pc.MNA);
		StatPointMongoLog(pc, "Init", pcPoint, "DEX", 0, PRE_DEX, pc.DEX);
	end
	InvalidateStates(pc);

end


function PARTYLIST_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg("PARTY_HISTORY_UPDATE", "ON_PARTY_HISTORY_LIST_UPDATE");
end


function ON_PARTY_HISTORY_LIST_UPDATE(frame, ctrl, argStr, argNum)

	DESTROY_CHILD_BYNAME(frame, 'PTINFO_');

	local listCnt = session.partyhistorylist.GetPartyHistoryListCount();	
	if listCnt == 0 then
		return;
	end

	local count = 0;
	for i=0, listCnt - 1 do
		local info = session.partyhistorylist.GetPartyHistoryInfo(i);
		if info ~= nil then
			SET_PARTY_HISTORYINFO_ITEM(frame, info, count);
			count = count + 1;
		end
	end
	
	frame:Invalidate();
end

function PARTYLIST_INIT_OPEN(frame, ctrl, argStr, argNum)
	
	ON_PARTY_HISTORY_LIST_UPDATE(frame, ctrl, argStr, argNum);
end

function SET_PARTY_HISTORYINFO_ITEM(frame, info, count)
	
	local partyInfoCtrlSet = frame:CreateOrGetControlSet('partyhistoryinfo', 'PTINFO_'.. count, 0, count * 90);
	
	local levelRichText = GET_CHILD(partyInfoCtrlSet, "level_text", "ui::CRichText");	
	levelRichText:SetText('{@st41}{b}'.. info.level);
		
	local memoRichText = GET_CHILD(partyInfoCtrlSet, "memo_text", "ui::CRichText");	
	memoRichText:SetText('');

	local nameRichText = GET_CHILD(partyInfoCtrlSet, "name_text", "ui::CRichText");
	nameRichText:SetText( info.charName );
	
	local expShareBtn = GET_CHILD(partyInfoCtrlSet, "expShare", "ui::CButton");
	local questShareBtn = GET_CHILD(partyInfoCtrlSet, "questShare", "ui::CButton");
	expShareBtn:ShowWindow(1);
	questShareBtn:ShowWindow(1);


	local questText = GET_CHILD(partyInfoCtrlSet, "quest_Text", "ui::CRichText");
	local expText = GET_CHILD(partyInfoCtrlSet, "exp_Text", "ui::CRichText");
	questText:ShowWindow(1);
	expText:ShowWindow(1);
	
	if info.relationGrade == PARTY_RELATION_VAN then
		expShareBtn:ShowWindow(0);
		questShareBtn:ShowWindow(0);
		questText:ShowWindow(0);
		expText:ShowWindow(0);
		nameRichText:SetText( info.charName .. ScpArgMsg('Auto_(ChaDanJung)') );

	elseif info.relationGrade == PARTY_RELATION_EXP then
		expShareBtn:SetImage('btn_partylink_complete');
		questShareBtn:SetImage('btn_partylink_none');

	elseif info.relationGrade == PARTY_RELATION_QUEST then
		questShareBtn:SetImage('btn_partylink_complete');
		expShareBtn:SetImage('btn_partylink_none');
	
	elseif info.relationGrade == PARTY_RELATION_EXP_QUEST then
		expShareBtn:SetImage('btn_partylink_complete');
		questShareBtn:SetImage('btn_partylink_complete');
	end

	local cid = info:GetCID();
	partyInfoCtrlSet:SetUserValue("MEMBER_CID", cid);	
	partyInfoCtrlSet:SetUserValue("MEMBER_NAME", info.charName);
end

function PARTYMEMBER_LIST_REMOVE(ctrlset, ctrl)

	local name = ctrlset:GetUserValue("MEMBER_NAME");	
	party.ReqChangeRelation(name, PARTY_RELATION_INIT);
end


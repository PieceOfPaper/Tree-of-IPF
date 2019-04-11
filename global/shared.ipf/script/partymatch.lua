
-- 각 평가 항목의 비중
WEIGHT_MEMBER_COUNT = 200 -- 인원수에 의한 점수
WEIGHT_DISTANCE = 2000 -- 거리에 의한 점수
WEIGHT_JOB_VALANCE = 100 -- 직업 균형에 의한 점수
WEIGHT_QUEST = 1000 -- 퀘스트에 의한 점수
WEIGHT_LEVEL = 500 -- 레벨에 의한 점수
WEIGHT_RELATION = 1300 -- 서로간의 친밀도에 의한 점수(음수 가능)
WEIGHT_ITEM_GRADE = 100 -- 아이템 등급에 의한 점수
WEIGHT_REPUTATION = 200 -- 평판에 의한 점수

SUM_OF_ALL_WEIGHT = WEIGHT_MEMBER_COUNT + WEIGHT_DISTANCE + WEIGHT_JOB_VALANCE + WEIGHT_QUEST + WEIGHT_LEVEL + WEIGHT_RELATION + WEIGHT_ITEM_GRADE + WEIGHT_REPUTATION

-- 기타 상수 모음
minus_infinity = -999999
DISTANCE_PENALTY_PER_WARPCOST = 2 -- 게임상의 워프 비용(실버)에 곱해지는 상수. 거리 검사 시 사용
EACH_QUEST_BOUNS = WEIGHT_QUEST/5 -- 각 퀘스트마다 추가점
RELATION_UP_BOUND = 2000 -- 이 이상이면 만점
RELATION_DOWN_BOUND = -2000 -- 이 이하면 최하점
REPUTATION_MAX_DIF = 2000 -- 이 이상 차이나면 0점준다.

-- 페털티 값 상수 모음
ADD_MEMBER_PENALTY = 1000 -- 새 멤버를 추가한지 얼마 안된 파티라면 페널티 점수가 있다.
GAP_OF_LAST_MEMBER_ADDED_MINUTE = 15  --그 기준이 되는 시간.

-- 개발용 로그 출력
PARTY_MATCH_SHOWLOG = false



-- 파티 매치 메이킹 관련 글로벌 서버 함수
-- 파티 멤버 인포는 업데이트 되고 있지 않음. 필요할 경우 되도록 추가해서 쓸 것. ZS_PARTY_BROADCAST 할때 글로벌에 같이 해주면 될 듯.
function PARTY_MATCHMAKING_CALC(pSession, pParty) -- (추천도를 검사할 유저 세션, for문에서 들어오는 각 파티)

	local SUM_OF_MY_WEIGHT = 0
	
	-- 1. 초기화. Bind 및 오브젝트 검사
	local session, sessionPcObj, party, partyobj, partymemberlist = PARTY_MATCHMAKING_INIT_OBJ(pSession,pParty)
	if session == false then
		return minus_infinity, PARTY_RECOMMEND_TYPE_COUNT
	end

	-- 변수 모음
	local SUM_OF_MY_WEIGHT = 0
	local mainreasonAddvalue = 0 
	local matchscore = 0 -- 룰 필터 최종 점수
	local mainreason = PARTY_RECOMMEND_TYPE_COUNT -- 최종 추천 타입
	

	-- 2. 평가 전에 반드시 지켜져야 하는 조건들 검사. 여기서 제외되면 아예 추천하지 않음.
	if PARTY_MATCHMAKING_PRE_CONDITION_CHECK(session, sessionPcObj, party, partyobj, partymemberlist) == false then
		return minus_infinity, PARTY_RECOMMEND_TYPE_COUNT
	end

	--66
	--3. 파티원 수에 따른 점수 계산(+)
	if partyobj["PartyMatch_UseETC"] == 1 then -- 65
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_MEMBER_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_MEMBER_COUNT
	end

	--4. 거리에 따른 점수 계산(+)
	if partyobj["PartyMatch_UseDistance"] == 1 then --63
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_DISTANCE_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_DISTANCE
	end

	--5. 직업 밸런스에 따른 점수 계산(+)
	if partyobj["PartyMatch_UseJob"] == 1 then -- 61
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_JOBVAL_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_JOB_VALANCE
	end

	--6. 퀘스트 진행 상태에 따른 점수 계산(+)
	if partyobj["PartyMatch_UseQuest"] == 1 then -- 41
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_QUEST_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_QUEST
	end

	--7. 레벨 차이에 따른 점수 계산(+)
	if partyobj["PartyMatch_UseLevel"] == 1 then -- 62
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_LEVEL_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_RELATION
	end

	--8. 평판이 비슷하다면 추가 점(+)
	if partyobj["PartyMatch_UseETC"] == 1 then -- 63
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_REPUTATION_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_REPUTATION
	end

	--9. 착용 중 아이템 등급이 비슷하다면 추가점(+)
	if partyobj["PartyMatch_UseETC"] == 1 then --66
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_ITEMGRADE_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_ITEM_GRADE
	end

	--10. 관계 필터 : 서로 간에 좋은 관계였다면 추가/감점 (+-)
	if partyobj["PartyMatch_UseRelation"] == 1 then -- 65
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_RELATION_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_RELATION
	end
	
	if SUM_OF_MY_WEIGHT == 0 or mainreason == PARTY_RECOMMEND_TYPE_COUNT then
		if PARTY_MATCH_SHOWLOG == true then
			print('단 하나의 항목도 체크 안한다면 패스 : ')
		end
		return minus_infinity, PARTY_RECOMMEND_TYPE_COUNT
	end

	matchscore = SUM_OF_ALL_WEIGHT * matchscore / SUM_OF_MY_WEIGHT

	--11. 최근에 새 멤버를 추가했다면 감점 (-)
	local lasetMemberAddTime = partyobj["LastMemberAddedTime"]
	if lasetMemberAddTime < 0 then
		lasetMemberAddTime = 0
	end

	if GetFloatDBTime() < lasetMemberAddTime + GAP_OF_LAST_MEMBER_ADDED_MINUTE then
		matchscore = matchscore - ADD_MEMBER_PENALTY;
		if PARTY_MATCH_SHOWLOG == true then
			print('최근에 새 멤버를 추가했다면 감점. 감점 후 점수 : '..matchscore)
		end
	end
	
	--12. 최근에 새 멤버를 추가했다면 감점 (-)
	matchscore = matchscore + party:IsAlreadyRecommendAccount(session:GetAID());

	if party:IsAlreadyRecommendAccount(session:GetAID()) < 0 then
		if PARTY_MATCH_SHOWLOG == true then
			print('이미 이 파티에 추천했던 사람이라면 횟수당 x점씩 감점. 감점 후 점수 : '..matchscore)
		end
	end
	


	if PARTY_MATCH_SHOWLOG == true then
		print('최종 점수 : '..matchscore..' / 가장 높은 비중 : ' .. mainreason)
		print('=======================================================')
		print('')
		print('')
	end

	return matchscore, mainreason

end

function IS_CTRLTYPE_MATCHING_RECRUIT_WITH_PC(jobname, recruittype)

	local num = recruittype
	local calcresult={}
	local i = 0
	
	while num > 0 do -- 비트연산을 위한 2진수 변환.
		
		calcresult[i] = num%2
		num = math.floor(num/2)
		i = i + 1
		if num < 1 then
			break;
		end
	end

	local pcjobinfo = GetClass('Job', jobname)

	if pcjobinfo == nil then
		return 0
	end

	local ctrlType = 0;
	if pcjobinfo.CtrlType == 'Warrior' and calcresult[0] == 1 then
		return 1
	elseif pcjobinfo.CtrlType == 'Wizard' and calcresult[1] == 1 then
		return 1
	elseif pcjobinfo.CtrlType == 'Archer' and calcresult[2] == 1 then
		return 1
	elseif pcjobinfo.CtrlType == 'Cleric' and calcresult[3] == 1 then
		return 1
	end

	return 0
end


function PARTY_MATCHMAKING_INIT_OBJ(pSession, pParty)
	
	local session = tolua.cast(pSession, "USER_SESSION")

	if pParty == nil or session == nil then
		if PARTY_MATCH_SHOWLOG == true then
			print('FAIL : pParty == nil or session == nil');
		end
		return false
	end

	local party = tolua.cast(pParty, "CParty")
	local pPartyobj = party:GetObject()
	local partyobj = nil
	if pPartyobj ~= nil then
		partyobj = GetIES(pPartyobj)
		if partyobj == nil then
			if PARTY_MATCH_SHOWLOG == true then
				print('FAIL : partyobj == nil');
			end
			return false
		end
	else
		if PARTY_MATCH_SHOWLOG == true then
			print('FAIL : pPartyobj == nil');
		end
		return false
	end


	local sessionPcObj = nil

	local pSessionPcObj = session:GetPcObject()
	if pSessionPcObj ~= nil then
		sessionPcObj = GetIES(pSessionPcObj)
		if sessionPcObj == nil then
			if PARTY_MATCH_SHOWLOG == true then
				print('FAIL : pSessionPcObj == nil');
			end
			return false
		end
		
	else
		if PARTY_MATCH_SHOWLOG == true then
			print('FAIL : pSessionPcObj == nil');
		end
		return false
	end

	local memcount = party:GetMemberCount()
	local memlist = {}

	local memindex = 0

	for i = 0 , memcount - 1 do
		
		local pMeminfo = party:GetMemberByIndex(i);

		if pMeminfo ~= nil then

			local meminfo = tolua.cast(pMeminfo, "PARTY_COMMANDER_INFO")
			local memsession = GetSessionByFamilyName(meminfo:GetName());

			if memsession ~= nil then

				memlist[memindex+1] = {}
				memlist[memindex+1]["Info"] = meminfo
				memlist[memindex+1]["Session"] = memsession

				memindex = memindex + 1

			end
		end
		
	end

	return session, sessionPcObj, party, partyobj, memlist

end


function PARTY_MATCHMAKING_PRE_CONDITION_CHECK(session, sessionPcObj, party, partyobj, partymemberlist)	

	--비공개 파티면 제외
	if partyobj["UsePartyMatch"] == 0 then
		if PARTY_MATCH_SHOWLOG == true then
			print('파티 매치 옵션 사용 안한다면 제외')
		end
		return false
	end

	-- 접속중인 멤버가 없거나 자리가 꽉 찼어도 제외
	if party:GetAliveMemberCount() <= 0 or party:IsFullParty() == true then
		if PARTY_MATCH_SHOWLOG == true then
			--print('접속중인 멤버가 없거나 자리가 꽉 찼어도 제외')
		end
		return false
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('유저 : '..session.familyName..' 파티리더 : '..party:GetLeaderName())
	end

	-- 리더가 접속중이 아니라면 제외
	if party:GetLeaderInfo():GetMapID() == 0 then
		if PARTY_MATCH_SHOWLOG == true then
			print('리더가 접속중이 아니라면 제외')
		end
		return false
	end
	
	-- 파티 옵션에서 레벨 제한 사용 중이고 추천할 유저가 그 조건을 만족하지 못한다면
	if partyobj["UseLevelLimit"] == 1 then
		if sessionPcObj.Lv < partyobj["MinLv"] or sessionPcObj.Lv > partyobj["MaxLv"] then
			if PARTY_MATCH_SHOWLOG == true then
				print('파티 옵션에서 레벨 제한 사용 중이고 추천할 유저가 그 조건을 만족하지 못한다면 제외')
			end
			return false
		end
	end
	
	-- 파티 옵션에서 직업 계열 조건을 사용 중이고 추천할 유저가 그 조건과 어긋난다면 제외
	if IS_CTRLTYPE_MATCHING_RECRUIT_WITH_PC(sessionPcObj.JobName, partyobj["RecruitClassType"]) ~= 1 then
		if PARTY_MATCH_SHOWLOG == true then
			print('파티 옵션에서 직업 계열 조건을 사용 중이고 추천할 유저가 그 조건과 어긋난다면 제외')
		end

		return false
	end
	
	local memcount = #partymemberlist

	--유저와 파티원간에 친구이거나 블럭 상대라도 제외
	for i = 1 , memcount do

		local meminfo = partymemberlist[i]["Info"]
		local memsession = partymemberlist[i]["Session"]

		if memsession ~= nil and session ~= nil then
			if session:IsFriendOrBlock(meminfo:GetAID()) == true or memsession:IsFriendOrBlock(session:GetAID()) then
				if PARTY_MATCH_SHOWLOG == true then
					print('유저와 파티원간에 친구이거나 블럭 상대라도 제외')
				end
				return false
			end
		end
	


	end
	
	return true
end


function PARTY_MATCHMAKING_CALC_MEMBER_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local memcount = #partymemberlist
	local maxMemcountPoint = WEIGHT_MEMBER_COUNT;
	maxMemcountPoint = maxMemcountPoint - (((5 - 1) - memcount) * (maxMemcountPoint / (5 - 1))); --한명 부족시마다 50점씩 감점
	maxMemcountPoint = maxMemcountPoint - ((memcount - party:GetAliveMemberCount()) * ((maxMemcountPoint / 2) / (5 - 1))); --한명 비접속시마다 25점씩 감점


	local matchscore = nowmatchscore + maxMemcountPoint
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if maxMemcountPoint > mainreasonAddvalue then
		mainreasonAddvalue = maxMemcountPoint;
		mainreason = PARTY_RECOMMEND_TYPE_MEMCOUNT;
	end
	
	if PARTY_MATCH_SHOWLOG == true then
		print('파티원 수에 따른 추가점 : '..maxMemcountPoint)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_DISTANCE_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local maxWarpCostPoint = WEIGHT_DISTANCE;

	if session.mapID == party:GetLeaderInfo():GetMapID() and session.channelID == party:GetLeaderInfo():GetChannel() then -- 맵 채널 둘 다 같다면 

		-- 만점
		maxWarpCostPoint = WEIGHT_DISTANCE;

	elseif session.mapID == party:GetLeaderInfo():GetMapID() then -- 맵만 같다면

		-- 만점의 절반
		maxWarpCostPoint = WEIGHT_DISTANCE/2

	else -- 다르다면

		maxWarpCostPoint = WEIGHT_DISTANCE/4

		local depmapcls = GetClassByType("Map", session.mapID);
		local dstmapcls = GetClassByType("Map", party:GetLeaderInfo():GetMapID());
		local warpCost = -999999;
		if depmapcls ~= nil and dstmapcls ~= nil then
			warpCost = CalcWarpCost(dstmapcls.ClassName, depmapcls.ClassName);
		end
		if warpCost < 0 then
			warpCost = -999999;
		end

		if warpCost >= 0 then
			maxWarpCostPoint = maxWarpCostPoint - (warpCost * DISTANCE_PENALTY_PER_WARPCOST);
		else
			maxWarpCostPoint = 0
		end

		if maxWarpCostPoint < 0 then
			maxWarpCostPoint = 0;
		end

	end

	

	
	local matchscore = nowmatchscore + maxWarpCostPoint
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if maxWarpCostPoint > mainreasonAddvalue then
		mainreasonAddvalue = maxWarpCostPoint;
		mainreason = PARTY_RECOMMEND_TYPE_DISTANCE;
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('현재 위치에 따른 추가점 : '..maxWarpCostPoint)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_JOBVAL_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local memcount = #partymemberlist
	local maxJobBalancePoint = WEIGHT_JOB_VALANCE;
	local jobBalanceFactor = maxJobBalancePoint * 5; -- 최악일 경우 0점이 되도록.
	maxJobBalancePoint = maxJobBalancePoint + (((1 / 2) - (2 / 3))*jobBalanceFactor); --최고의 경우를 미리 빼놔서 최대 점수를 맞추도록.
	local nowjobdiffcount = 0;
	local tempstring = "";

	for i = 1 , #partymemberlist do
		local meminfo = partymemberlist[i]["Info"]
		local jobclass = GetClassByType("Job", meminfo:GetIconInfo().job);
		 
		if jobclass ~= nil then
			if string.find(tempstring,jobclass.CtrlType) == nil then
				tempstring = tempstring .. jobclass.CtrlType
				nowjobdiffcount = nowjobdiffcount + 1
			end
		end
	end

	local nowBalancePoint = nowjobdiffcount / memcount;
	local sessionjobclass = GetClass("Job", sessionPcObj.JobName);

	if sessionjobclass == nil then
		maxJobBalancePoint = 0
	else
		if string.find(tempstring, sessionjobclass.CtrlType) == nil then
			tempstring = tempstring .. sessionjobclass.CtrlType
			nowjobdiffcount = nowjobdiffcount + 1
		end
		local newBalancePoint = nowjobdiffcount / (memcount + 1);

		maxJobBalancePoint = maxJobBalancePoint - ( (nowBalancePoint - newBalancePoint) *jobBalanceFactor);

		if maxJobBalancePoint < 0 then
			maxJobBalancePoint = 0;
		end
	end

	local matchscore = nowmatchscore + maxJobBalancePoint
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if maxJobBalancePoint > mainreasonAddvalue then
		mainreasonAddvalue = maxJobBalancePoint;
		mainreason = PARTY_RECOMMEND_TYPE_JOBVAL;
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('직업 벨런스에 의한 추가점 : '..maxJobBalancePoint)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_QUEST_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local maxQuestPoint = WEIGHT_QUEST;
	local nowQuestPoint = 0;
	local questPointFactor = EACH_QUEST_BOUNS; --1개 진행 같을시 마다 200점.

	if partyobj["IsQuestShare"] == 1 then

		local leadersession = GetSessionByFamilyName(party:GetLeaderName());
		if leadersession ~= nil then

			local leaderQGroup = {}
			local sessionQGroup = {}

			for i = 0, 10 -1 do
				local questid = session:GetCheckQuestByIndex(i)
				
				local questIES = GetClassByType("QuestProgressCheck", questid);
				if questIES ~= nil then

					local questclsName = questIES.ClassName
					
					if questclsName ~= "None" and questclsName ~= nil then

						local questGroupName = questIES.ClassName

						if questIES.QuestGroup ~= "None" then
							local strFindStart, strFindEnd = string.find(questIES.QuestGroup, "/");
							if strFindStart ~= nil then
								questGroupName  = string.sub(questclsName, 1, strFindStart-1);
							end
						end

						if sessionQGroup[questGroupName] == nil then
							sessionQGroup[questGroupName] = "Exist"
						end
								
					end

				end
			end

			for i = 0, 10 -1 do
				local questid = leadersession:GetCheckQuestByIndex(i)
				
				local questIES = GetClassByType("QuestProgressCheck", questid);
				if questIES ~= nil then

					local questclsName = questIES.ClassName

					if questclsName ~= "None" and questclsName ~= nil then

						local questGroupName = questIES.ClassName

						if questIES.QuestGroup ~= "None" then
							local strFindStart, strFindEnd = string.find(questIES.QuestGroup, "/");
							if strFindStart ~= nil then
								questGroupName  = string.sub(questclsName, 1, strFindStart-1);
							end
						end

						if leaderQGroup[questGroupName] == nil then
							leaderQGroup[questGroupName] = "Exist"
						end
								
					end

				end
			end

			for k,v in pairs(leaderQGroup) do
				if sessionQGroup[k] ~= nil then
					nowQuestPoint = nowQuestPoint + questPointFactor;
				end
			end

		end
	end

	if nowQuestPoint > maxQuestPoint then
		nowQuestPoint = 0;
	end

	local matchscore = nowmatchscore + nowQuestPoint
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if nowQuestPoint > mainreasonAddvalue then
		mainreasonAddvalue = nowQuestPoint;
		mainreason = PARTY_RECOMMEND_TYPE_QUEST;
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('퀘스트 상태에 의한 추가점 : '..nowQuestPoint)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_LEVEL_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local memcount = #partymemberlist
	local retleveldiff = 0

	for i = 1 , #partymemberlist do
	
		local meminfo = partymemberlist[i]["Info"]
		local memsession = GetSessionByFamilyName(meminfo:GetName());

		if memsession ~= nil then
			local pmemPcObj = memsession:GetPcObject()
			
			if pmemPcObj ~= nil and sessionPcObj ~= nil then
				
				local memsessionpcObj = GetIES(pmemPcObj)
				if memsessionpcObj ~= nil then
					
					local lvdiff = math.abs((memsessionpcObj.Lv*1.1) - sessionPcObj.Lv);

					local lvdiffscore = WEIGHT_LEVEL - (lvdiff/20 * WEIGHT_LEVEL) -- 20레벨 차이 나면 0점.
					if lvdiffscore < 0  then
						lvdiffscore = 0
					end

					retleveldiff = retleveldiff + lvdiffscore
				end
			end
		end
	end

	local levelPoint = retleveldiff / memcount

	local matchscore = nowmatchscore + levelPoint
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if levelPoint > mainreasonAddvalue then
		mainreasonAddvalue = levelPoint
		mainreason = PARTY_RECOMMEND_TYPE_LEVEL
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('레벨 차이에 의한 추가점 : '..levelPoint)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_REPUTATION_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local memcount = #partymemberlist
	local YUYUrelationScoreAvg = 0
	for i = 1 , #partymemberlist do
		
		local meminfo = partymemberlist[i]["Info"]
		local memsession = partymemberlist[i]["Session"]

		local sessionRScore = session:GetAvgRelationScore();
		local memRScore = memsession:GetAvgRelationScore(); 

		YUYUrelationScoreAvg = YUYUrelationScoreAvg + math.abs(sessionRScore - (memRScore*1.1))
	end
	YUYUrelationScoreAvg = YUYUrelationScoreAvg / memcount
	if YUYUrelationScoreAvg > REPUTATION_MAX_DIF then
		YUYUrelationScoreAvg = REPUTATION_MAX_DIF
	end

	local YUYUrelationScore = WEIGHT_REPUTATION - (WEIGHT_REPUTATION * YUYUrelationScoreAvg / REPUTATION_MAX_DIF)

	local matchscore = nowmatchscore + YUYUrelationScore
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if YUYUrelationScore > mainreasonAddvalue then
		mainreasonAddvalue = YUYUrelationScore
		mainreason = PARTY_RECOMMEND_TYPE_REPUTATION -- 명성
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('각자의 게임 내 인망이 비슷하다면 추가점 : '..YUYUrelationScore)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_ITEMGRADE_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local memcount = #partymemberlist
	local totalItemGrade = 0

	local itemgradeavg = 0
	local itemStaravg = 0
	local itemReinforceavg = 0
	
	local itemGradeScore = 0
	local itemStarScore = 0
	local itemReinforceScore = 0

	for i = 1 , #partymemberlist do
		
		local meminfo = partymemberlist[i]["Info"]
		local memsession = partymemberlist[i]["Session"]

		local sessionGrade = session:GetTotalItemGrade();
		local memGrade = memsession:GetTotalItemGrade(); 

		local sessionStar = session:GetTotalStarCount();
		local memStar = memsession:GetTotalStarCount(); 

		local sessionRein = session:GetTotaReinforce();
		local memRein = memsession:GetTotaReinforce(); 

		itemgradeavg = itemgradeavg + (math.abs((sessionGrade) - (memGrade*1.1)) / 8)
		itemStaravg = itemgradeavg + (math.abs((sessionStar) - (memStar*1.1)) / 8)
		itemReinforceavg = itemgradeavg + (math.abs((sessionRein) - (memRein*1.1)) / 8)
	end
	itemgradeavg = itemgradeavg / memcount
	itemStaravg = itemStaravg / memcount
	itemReinforceavg = itemReinforceavg / memcount

	if itemStaravg < 0.375 then
		itemStarScore = WEIGHT_ITEM_GRADE * 5/11
	else
		itemStarScore = 0
	end

	if itemgradeavg < 0.5 then
		itemGradeScore = WEIGHT_ITEM_GRADE * 3/11 * 3/3
	elseif itemgradeavg < 1.0 then
		itemGradeScore = WEIGHT_ITEM_GRADE * 3/11 * 2/3
	elseif itemgradeavg < 1.5 then
		itemGradeScore = WEIGHT_ITEM_GRADE * 3/11 * 1/3
	else
		itemGradeScore = 0
	end

	if itemReinforceavg < 3.25 then
		itemReinforceScore = WEIGHT_ITEM_GRADE * 3/11 * 3/3
	elseif itemReinforceavg < 4.25 then
		itemReinforceScore = WEIGHT_ITEM_GRADE * 3/11 * 2/3
	elseif itemReinforceavg < 5.25 then
		itemReinforceScore = WEIGHT_ITEM_GRADE * 3/11 * 1/3
	else
		itemReinforceScore = 0
	end

	totalItemGrade = itemStarScore + itemGradeScore + itemReinforceScore
	
	local matchscore = nowmatchscore + totalItemGrade
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if totalItemGrade > mainreasonAddvalue then
		mainreasonAddvalue = totalItemGrade
		mainreason = PARTY_RECOMMEND_TYPE_ITEM_GRADE -- 장비 등급으로 바꿔야 함.
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('착용 중 아이템 등급이 비슷하다면 추가점 : '..totalItemGrade)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_RELATION_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local memcount = #partymemberlist
	local relationScoreAvg = 0
	for i = 1 , memcount do
		
		local meminfo = partymemberlist[i]["Info"]
		local memsession = partymemberlist[i]["Session"]

		local sessionToMemRScore = session:GetRelationScore(meminfo:GetAID());
		local memToSessionRScore = memsession:GetRelationScore(session:GetAID());

		local eachscore = ( sessionToMemRScore + memToSessionRScore ) / 2

		relationScoreAvg = relationScoreAvg + eachscore
	end
	relationScoreAvg = relationScoreAvg / memcount

	if relationScoreAvg > RELATION_UP_BOUND then
		relationScoreAvg = RELATION_UP_BOUND
	end

	if relationScoreAvg < RELATION_DOWN_BOUND then
		relationScoreAvg = RELATION_DOWN_BOUND
	end

	local relationScore = (relationScoreAvg * WEIGHT_RELATION) / (RELATION_UP_BOUND - RELATION_DOWN_BOUND) 

	local matchscore = nowmatchscore + relationScore -- 음수가 될 수 있다.
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if relationScore > mainreasonAddvalue then
		mainreasonAddvalue = relationScore
		mainreason = PARTY_RECOMMEND_TYPE_RELATION_POINT
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('서로 간에 좋은 관계였다면 추가점 : '..relationScore)
	end

	return matchscore, mainreason, mainreasonAddvalue
end
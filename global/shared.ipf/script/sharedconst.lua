--DAYCHECK_EVENT_REWARD_HOUR = 30
--DAYCHECK_EVENT_TIME = {{{2016,7,14},{2016,7,27}},{{2016,7,28},{2016,8,10}},{{2016,8,11},{2016,8,25}}}
--DAYCHECK_EVENT_REWARD_ITEM = {{{'160714Event_box1',1},{'160714Event_box2',1},{'160714Event_box3',1},{'160714Event_box4',1},{'160714Event_box5',1},{'160714Event_box6',1},{'160714Event_box7',1},{'160714Event_box8',1},{'160714Event_box9',1},{'160714Event_box10',1}},
--                                {{'160714Event_box11',1},{'160714Event_box12',1},{'160714Event_box13',1},{'160714Event_box14',1},{'160714Event_box15',1},{'160714Event_box16',1},{'160714Event_box17',1},{'160714Event_box18',1},{'160714Event_box19',1},{'160714Event_box20',1}},
--                                {{'160714Event_box21',1},{'160714Event_box22',1},{'160714Event_box23',1},{'160714Event_box24',1},{'160714Event_box25',1},{'160714Event_box26',1},{'160714Event_box27',1},{'160714Event_box28',1},{'160714Event_box29',1},{'160714Event_box30',1}}}

--PLAYTIMEEVENT_REFLASH_HOUR = 6
--PLAYTIMEEVENT_REWARD_TIME = {0, 30, 60}
--PLAYTIMEEVENT_REWARD_BASIC = {{{'Event_160609',1}}, {{'Event_160609',1}}, {{'Event_160609',1}}}
--PLAYTIMEEVENT_REWARD_PREMIUM = {{{'Event_160609',1}}, {{'Event_160609',1}}, {{'Event_160609',1}}}
--PLAYTIMEEVENT_REWARD_ACC_TIME = nil
--PLAYTIMEEVENT_REWARD_ACC = nil

--CITYATTACK_BOSS_EVENT_TIME_TABLE = {{2016,5,26,20,'boss_honeyspider'},
--                                    {2016,5,26,22,'Head_fish'},
--                                    {2016,5,27,20,'boss_honeyspider'},
--                                    {2016,5,27,22,'Head_fish'},
--                                    {2016,5,28,16,'boss_honeyspider'},
--                                    {2016,5,28,18,'Head_fish'},
--                                    {2016,5,28,20,'boss_honeyspider'},
--                                    {2016,5,28,22,'Head_fish'},
--                                    {2016,5,29,16,'boss_honeyspider'},
--                                    {2016,5,29,18,'Head_fish'},
--                                    {2016,5,29,20,'boss_honeyspider'},
--                                    {2016,5,29,22,'Head_fish'},
--                                    {2016,5,30,20,'boss_honeyspider'},
--                                    {2016,5,30,22,'Head_fish'},
--                                    {2016,5,31,20,'boss_honeyspider'},
--                                    {2016,5,31,22,'Head_fish'},
--                                    {2016,6,1,20,'boss_honeyspider'},
--                                    {2016,6,1,22,'Head_fish'},
--                                    {2016,6,2,20,'boss_honeyspider'},
--                                    {2016,6,2,22,'Head_fish'},
--                                    {2016,6,3,20,'boss_honeyspider'},
--                                    {2016,6,3,22,'Head_fish'},
--                                    {2016,6,4,16,'boss_honeyspider'},
--                                    {2016,6,4,18,'Head_fish'},
--                                    {2016,6,4,20,'boss_honeyspider'},
--                                    {2016,6,4,22,'Head_fish'},
--                                    {2016,6,5,16,'boss_honeyspider'},
--                                    {2016,6,5,18,'Head_fish'},
--                                    {2016,6,5,20,'boss_honeyspider'},
--                                    {2016,6,5,22,'Head_fish'},
--                                    {2016,6,6,16,'boss_honeyspider'},
--                                    {2016,6,6,18,'Head_fish'},
--                                    {2016,6,6,20,'boss_honeyspider'},
--                                    {2016,6,6,22,'Head_fish'},
--                                    {2016,6,7,20,'boss_honeyspider'},
--                                    {2016,6,7,22,'Head_fish'},
--                                    {2016,6,8,20,'boss_honeyspider'},
--                                    {2016,6,8,22,'Head_fish'},
--                                    {2016,6,9,20,'boss_honeyspider'},
--                                    {2016,6,9,22,'Head_fish'},
--                                    {2016,6,10,20,'boss_honeyspider'},
--                                    {2016,6,10,22,'Head_fish'},
--                                    {2016,6,11,16,'boss_honeyspider'},
--                                    {2016,6,11,18,'Head_fish'},
--                                    {2016,6,11,20,'boss_honeyspider'},
--                                    {2016,6,11,22,'Head_fish'},
--                                    {2016,6,12,16,'boss_honeyspider'},
--                                    {2016,6,12,18,'Head_fish'},
--                                    {2016,6,12,20,'boss_honeyspider'},
--                                    {2016,6,12,22,'Head_fish'}
--                                    }
                                    
FLASHMOB_EVENT_REWARD_TABLE = {{{'Premium_eventTpBox_5_3',1}}}


WORLD_SIZE = 10240;
MINIMAP_LOC_MULTI = 4;

SESSION_MAX_MAP_POINT_GROUP = 10;
SESSION_MAX_MON_NAME_GROUP = 10;
QUEST_MAX_INVITEM_CHECK = 4;
QUEST_MAX_BUFF_CHECK = 4;
QUEST_MAX_EQUIP_CHECK = 4;
QUEST_MAX_MON_CHECK = 6;
QUEST_MAX_ETC_CNT = 10;
QUEST_MAX_OVERKILL_CHECK = 6;
GUILDQUEST_MAX_CNT = 4;
GUILDQUEST_MAX_MONSTER = 4;
GUILDQUEST_MAX_ITEM = 4;

USE_RECIPE_ITEM_CNT = 0;


QUEST_ABANDON_VALUE = -10
QUEST_FAIL_VALUE = -100
QUEST_SYSTEMCANCEL_VALUE = -1000
QUEST_RANKRESET_VALUE = -10000 -- 랭크 리셋으로 인해서 퀘스트 초기화하는 경우 사용


SKILL_TREE_CNT = 3;

ABILITY_MAX_LINE = 8;

MAX_ACTIVE_ABILITY = 128;

GENTYPE_PREFIX = "GenType_";
ANCHOR_PREFIX = "Anchor_";
MONEY_NAME = "Vis";


MCY_MAP_NAME = "mission_test";

function SCP_MSG_OLD(msg, ...)

	return string.format(ClMsg(msg), ...);

end

function PRINT_UTF8(msg, ...)

	PrintLogLine( string.format(msg, ...) );

end

function SCP_MSG(msg, ...)

	print("SCP_MSG() function is discard. plz use ScpArgMsg() function. - 140422 Ayase")

end

function SCP_MSG_OLD(msg, ...)

	local tempstr = msg
	local testtable = {...}
	
	for i = 1, #testtable do
		local tempchar = '$'..string.char(i+64);
		empstr = string.gsub(tempstr, tempchar, testtable[i],1)
    end

	if tempstr == msg then
		return string.format(ClMsg(msg), ...);
	end

end





function MAX_COLSPRAY_PIXEL()

	return 10000;

end

function SPRAY_LIFE_TIME()

	return 60 * 60 * 24;
	--return 10 * 1000;

end

function GET_PARTY_EXP_RATIO(commcount)


	if commcount <= 1 then
		return 100;
	end

	if commcount == 2 then
		return 120;
	end

	if commcount == 3 then
		return 150;
	end

	if commcount == 4 then
		return 180;
	end

	if commcount == 5 then
		return 220;
	end

	if commcount == 6 then
		return 250;
	end

	if commcount == 7 then
		return 280;
	end

	if commcount == 8 then
		return 300;
	end

	if commcount == 9 then
		return 350;
	end

	return (commcount - 9) * 50 + 350

end

function DUR_DIV(funcName)
	if funcName ~= nil and string.find(funcName, "OpDur_") ~= nil then
		return 1;
	end
	
	return 100;
end


function CAN_ABANDON_STATE(state)

	if state == "PROGRESS" or state == "SUCCESS" then
		return 1;
	end

	return 0;

end



function FAME_LIST_COUNT_PER_PAGE()

	return 10;

end

RETRADE_ADV_VALUE = 5;

function GET_RETRADE_CNT(cls, elapsedTime)
	if elapsedTime < 0 then
		elapsedTime = 0;
	end

	local percentage = math.floor(elapsedTime * 100 / cls.RetradeSec);
	local maxpercent = cls.MaxRetrade * 100;
	if percentage > maxpercent then
		percentage = maxpercent;
	end
	local arg2 = math.floor(percentage / 100);
 	local curpercent = percentage - arg2 * 100;

 	return arg2, curpercent;
end

function G_TOTAL_MON_CNT(cls)

	local cnt = 0;
	for i = 1, GUILDQUEST_MAX_MONSTER do
		local name = cls["MonName" .. i];
		if name == "None" then
			break;
		end

		cnt = cnt + cls["MonCount" .. i];
	end

	return cnt;
end

function SSN_DIALOGCOUNT_ENTER_C()
end
function SSN_DIALOGCOUNT_LEAVE_C()
end

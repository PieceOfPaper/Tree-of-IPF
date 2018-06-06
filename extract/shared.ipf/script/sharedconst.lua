
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

-- 에러가 떠서 더미용으로 넣은 함수
function SSN_DIALOGCOUNT_ENTER_C()
end
function SSN_DIALOGCOUNT_LEAVE_C()
end











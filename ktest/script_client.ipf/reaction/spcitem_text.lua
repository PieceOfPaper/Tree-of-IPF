--- spcitem_text.lua

function SHOW_DMG_DIGIT(arg)
	return ScpArgMsg("ADD_DAMAGE_{Auto_1}!", "Auto_1", arg);
end

function SHOW_DMG_SHIELD(arg)
	return ScpArgMsg("ADD_SHIELD_{Auto_1}!","Auto_1",  arg);
end

function SHOW_BUFF_TEXT(arg)
	local buff = GetClassByType("Buff", arg);
	return ScpArgMsg("ADD_BUFF_{Auto_1}!", "Auto_1",  buff.Name);
end

function EMPOWERING_LEVEL_TEXT(arg)
	return ScpArgMsg("SKILL_EMPOWRING_{Auto_1}","Auto_1", arg);	
end

function VAMP_HP(arg)
	return ScpArgMsg("ABSORB_HP_{Auto_1}!","Auto_1",  arg);	
end

function VAMP_SP(arg)
	return ScpArgMsg("ABSORB_SP_{Auto_1}!","Auto_1",  arg);
end

function COOL_DOWN_HP(arg)
	return ScpArgMsg("COOL_DOWN_HP_{Auto_1}!","Auto_1",  arg);
end

function SHOW_DMG_CRI()
	return ScpArgMsg("ADD_CRI");
end

function SHOW_DMG_BLOCK()
	return ScpArgMsg("ADD_BLOCK");
end

function SHOW_REMOVE_BUFF(arg)
	return ScpArgMsg("REMOVE_BUFF_{Auto_1}","Auto_1", arg);	
end

function SHOW_DMG_COUNTER()
	return ScpArgMsg("ADD_COUNTER");
end


function SHOW_TOURNA_GIFT(arg)
	return ScpArgMsg("GiftPoint+{Auto_1}!","Auto_1",  arg);
end

function SHOW_GUNGHO()
	return ScpArgMsg("SHOW_GUNGHO");
end

function SHOW_PROVOKE()
	return ScpArgMsg("SHOW_PROVOKE");
end

function SHOW_BROADHEAD_LEATHER(arg)
	return ScpArgMsg("SHOW_BROADHEAD_LEATHER_{Auto_1}","Auto_1",  arg);
end

function SHOW_BROADHEAD_IRON(arg)
	return ScpArgMsg("SHOW_BROADHEAD_IRON_{Auto_1}","Auto_1",  arg);
end

function SHOW_BODKIN_BREAK_SHIELD()
	return ScpArgMsg("SHOW_BODKIN_BREAK_SHIELD");
end

function SHOW_REFLECTION()
	return ScpArgMsg("SHOW_REFLECTION");
end

function SHOW_ICE_SHIELD(arg1, argString)
    local buff = GetClassByType("Buff", arg1);
	return string.format("%s (%s)", ScpArgMsg("ADD_ICE_SHIELD_{Auto_1}!","Auto_1", buff.Name), argString);
end

function SHOW_FIRE_DETONATION(arg1, argString)
    local buff = GetClassByType("Buff", arg1);
	return string.format("%s (%s)", ScpArgMsg("ADD_FIRE_DETONATION_{Auto_1}!","Auto_1", buff.Name), argString);
end

function SHOW_HOLY_ENCHANT(arg1, argString)
    local buff = GetClassByType("Buff", arg1);
	return string.format("%s (%s)", ScpArgMsg("ADD_HOLY_ENCHANT_{Auto_1}!","Auto_1", buff.Name), argString);
end

function SHOW_HOLY_BAPTISM(arg1, argString)
    local buff = GetClassByType("Buff", arg1);
	return string.format("%s (%s)", ScpArgMsg("ADD_HOLY_BAPTISM_{Auto_1}!","Auto_1", buff.Name), argString);
end

function SHOW_LIMITATION(arg1, argString)
    local buff = GetClassByType("Buff", arg1);
	return string.format("%s (%s)", ScpArgMsg("ADD_LIMITATION_{Auto_1}!","Auto_1", buff.Name), argString);
end

function SHOW_BLESS(arg1, argString)
    local buff = GetClassByType("Buff", arg1);
	return string.format("%s (%s)", ScpArgMsg("ADD_BLESS_{Auto_1}!","Auto_1", buff.Name), argString);
end

function SHOW_HASTE(arg1, argString)
    local buff = GetClassByType("Buff", arg1);
	return string.format("%s (%s)", ScpArgMsg("ADD_HASTE_{Auto_1}!","Auto_1", buff.Name), argString);
end

function SHOW_MACANGDAL()
	return ScpArgMsg("MackangdalOFF");
end


-- ????? ????
function SHOW_SKILL_ATTRIBUTE(arg, argString)

	local cls = GetClass('skill_attribute', argString)
	if cls == nil then
		return "";
	end

	if cls.TextEffectMsg == 'None' then
		return "";
	end

	local format = "%s ";
	if arg >= 0 then
		format = format .. "+%s";
	else
		format = format .. "%s";
	end

	local value;
	if arg - math.floor(arg) > 0 then
		value = string.format("%.1f", arg);	
	else
		value = string.format("%.0f", arg);	
	end

	return string.format(format, cls.TextEffectMsg, ScpArgMsg("SKILL_ATTRIBUTE_{Auto_1}!", "Auto_1", value));	
end

-- ????? ????
function SHOW_SKILL_ATTRIBUTE_WEAPON(arg, argString)

	local cls = GetClass('skill_attribute', argString)
	if cls == nil then
		return "";
	end

	if cls.TextEffectMsg == 'None' then
		return "";
	end

	return string.format("%s %s", cls.TextEffectMsg, ScpArgMsg("SKILL_ATTRIBUTE_W_{Auto_1}!", "Auto_1", arg));	
end

-- ????????
function SHOW_SKILL_BONUS(arg, argString)
	return string.format("%s +%d", ScpArgMsg(argString), arg);
end

function SHOW_SKILL_BONUS2(arg, skillID)
    local skill = GetClassByType("Skill", skillID);
	return string.format("%s +%d%%", skill.Name, arg);
end

function SHOW_SKILL_BONUS3(arg, argString)
    -- 소수점 둘째 자리까지 표현하기 위함 --------
    arg = math.floor(arg*100)
    return string.format("%s +%.2f%%", ScpArgMsg(argString), arg/100);
end

-- ????????
function SHOW_SKILL_EFFECT(arg, argString)
	return string.format("%s", ScpArgMsg(argString), arg);	
end

-- ????????
function SHOW_ATTRIBUTE_RESIST(arg, argString)
	return string.format("%s +%s", ScpArgMsg(argString), arg);
end

function SHOW_REDUCE_HP(arg, argString)
    return string.format("%s %d", ScpArgMsg("StartUp_Charging_Buff"), arg);
end
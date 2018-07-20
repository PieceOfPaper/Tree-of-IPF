
function MONINFOBYSKILL_ON_INIT(addon, frame)

	
end


function SHOW_MONINFO_BY_SKILL(frame, monhandle, showCount, paramList)

	--local targetinfo = info.GetTargetInfo( monhandle );
	local monactor = world.GetActor(monhandle);
	local montype = monactor:GetType()

	local monclass = GetClassByType("Monster", montype);
	
	if monclass == nil then
		return
	end

	local monname = GET_CHILD(frame,'monname','ui::CRichText')
	monname:SetTextByKey('monname',monclass.Name)

	local gbox = GET_CHILD(frame,'mainBox','ui::CGroupBox')
	gbox:RemoveAllChild();

	local x = 0;
	local ymargin = 0;
	local y = ymargin;

	for i = 1, showCount do

		local paramname = paramList[i]

		local eachcset = gbox:CreateControlSet('moninfobyskill_param', paramname, x, y);
				
		local eachparamtext = GET_CHILD(eachcset,'paramname','ui::CRichText')
		eachparamtext:SetTextByKey('paramname',GET_MON_PROPUINAME_BY_PROPNAME(paramname))

		local eachparamvalue = GET_CHILD(eachcset,'paramvalue','ui::CRichText')
		eachparamvalue:SetTextByKey('paramvalue',GET_MON_PROPVALUE_BY_PROPNAME(monclass, paramname))

		local eachparamicon = GET_CHILD(eachcset,'paramIcon','ui::CPicture')
		eachparamicon:SetImage(GET_MON_PROPICON_BY_PROPNAME(paramname,monclass))

		local labelline = eachcset:GetChild('labelline')
		labelline:SetOffset(eachparamtext:GetX() + eachparamtext:GetWidth() + 15, labelline:GetY())
		labelline:Resize((eachparamvalue:GetX() - 15) - (eachparamtext:GetX() + eachparamtext:GetWidth() + 15), labelline:GetOriginalHeight())

		y = i * 40 + ymargin
	end

	gbox:Resize(gbox:GetOriginalWidth(),y + 50)
	frame:Resize(frame:GetOriginalWidth(),gbox:GetHeight() + 50)

	--위치는 소스에서 컨트롤 함. m_pMonDetailInfo 프레임

end

function GET_MON_PROPUINAME_BY_PROPNAME(paramname)

	return ScpArgMsg('MonInfo_'..paramname);
end

function GET_MON_PROPICON_BY_PROPNAME(paramname, monclass)

	
	if paramname == "RaceType" then 

		local paramvalue = monclass[paramname]

		if paramvalue == "Forester" then
			return 'mon_info_forester'
		elseif paramvalue == "Widling" then
			return 'mon_info_widling'
		elseif paramvalue == "Paramune" then
			return 'mon_info_paramune'
		elseif paramvalue == "Klaida" then
			return 'mon_info_klaida'
		elseif paramvalue == "Velnias" then
			return 'mon_info_velnias'
		end

	elseif paramname == "Size" then 

		local paramvalue = monclass[paramname]

		if paramvalue == "S" then
			return 'mon_info_s'
		elseif paramvalue == "M" then
			return 'mon_info_m'
		elseif paramvalue == "L" then
			return 'mon_info_l'
		elseif paramvalue == "XL" then
			return 'mon_info_xl'
		end

	elseif paramname == "MonRank" then 

		local paramvalue = monclass[paramname]

		if paramvalue == "Normal" then
			return 'mon_info_mon'
		elseif paramvalue == "Elite" then
			return 'mon_info_elite'
		elseif paramvalue == "Boss" then
			return 'mon_info_boss'
		end

	elseif paramname == "ArmorMaterial" then 

		local paramvalue = monclass[paramname]

		if paramvalue == "Cloth" then
			return 'mon_info_cloth'
		elseif paramvalue == "Leather" then
			return 'mon_info_leather'
		elseif paramvalue == "Iron" then
			return 'mon_info_iron'
		elseif paramvalue == "Ghost" then
			return 'mon_info_ghost'
		elseif paramvalue == "None" then
			return 'mon_info_none'
		end

	elseif paramname == "Attribute" then 

		local paramvalue = monclass[paramname]

		if paramvalue == "Fire" then
			return 'mon_info_fire'
		elseif paramvalue == "Ice" then
			return 'mon_info_ice'
		elseif paramvalue == "Lightning" then
			return 'mon_info_lightning'
		elseif paramvalue == "Poison" then
			return 'mon_info_poison'
		elseif paramvalue == "Dark" then
			return 'mon_info_dark'
		elseif paramvalue == "Holy" then
			return 'mon_info_holy'
		elseif paramvalue == "Earth" then
			return 'mon_info_earth'
		elseif paramvalue == "Melee" then
			return 'mon_info_none'
		end

	elseif paramname == "MoveType" then 

		local paramvalue = monclass[paramname]

		if paramvalue == "Holding" then
			return 'mon_info_holding'
		elseif paramvalue == "Normal" then
			return 'mon_info_normal'
		elseif paramvalue == "Flying" then
			return 'mon_info_flying'
		end

	elseif paramname == "EffectiveAtkType" then

		if monclass.ArmorMaterial == "Cloth" then
		--베기가 효과적
			return 'mon_info_slash'
		elseif monclass.ArmorMaterial == "Leather" then
		--찌르기가 효과적
			return 'mon_info_aries'
		elseif monclass.ArmorMaterial == "Iron" then
		--때리기가 효과적
			return 'mon_info_strike'
		else
		--그런거 없다
			return 'mon_info_none'
		end

	end

	print('error : ['..paramname..'] ['..paramvalue..']')

	return ''
end

function GET_MON_PROPVALUE_BY_PROPNAME(monclass,paramname)

	if paramname == "RaceType" or paramname == "Size" or paramname == "ArmorMaterial" or paramname == "Attribute" or paramname == "MoveType" or paramname == "MonRank" then
		return ScpArgMsg('MonInfo_'..paramname..'_'..monclass[paramname] );
	elseif paramname == "EffectiveAtkType" then
		if monclass.ArmorMaterial == "Cloth" then
		--베기가 효과적
			return ScpArgMsg('MonInfo_EffectiveAtkType_Slash')
		elseif monclass.ArmorMaterial == "Leather" then
		--찌르기가 효과적
			return ScpArgMsg('MonInfo_EffectiveAtkType_Aries')
		elseif monclass.ArmorMaterial == "Iron" then
		--때리기가 효과적
			return ScpArgMsg('MonInfo_EffectiveAtkType_Strike')
		else
		--그런거 없다
			return ScpArgMsg('MonInfo_None')
		end
	end

	print('error : ['..paramname..'] ['..paramvalue..']')
		
end

--[[
function GET_MON_PROPVALUE_BY_PROPNAME_OLD(targetinfo,paramname)

	if paramname == "SIZE" then
		return targetinfo.size
	elseif paramname == "RACE" then
		return targetinfo.raceType
	elseif paramname == "ARMOR" then
		return targetinfo.armorType
	elseif paramname == "ATTRIBUTE" then
		return targetinfo.attribute
	elseif paramname == "HP" then
		return targetinfo.stat.HP;
	elseif paramname == "MAXHP" then
		return targetinfo.stat.maxHP;
	elseif paramname == "SP" then
		return targetinfo.stat.SP;
	elseif paramname == "MAXSP" then
		return targetinfo.stat.maxSP;
	elseif paramname == "STAMINA" then
		return targetinfo.stat.Stamina;
	elseif paramname == "MAXSTAMINA" then
		return targetinfo.stat.MaxStamina;
	elseif paramname == "SHIELD" then
		return targetinfo.stat.shield;
	end

	return nil;
		
end]]
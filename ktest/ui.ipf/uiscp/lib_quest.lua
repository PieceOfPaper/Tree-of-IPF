--- lib_quest.lua --

function GET_MAIN_SOBJ()

	local sObj = session.GetSessionObjectByName("ssn_klapeda");
	if nil == sObj then
		return nil;
	end

	return GetIES(sObj:GetIESObject());

end

-- From Class of xml_mongen/gentype_mapname.xml, Get name of monster
function GET_GENCLS_NAME(genCls)

	local name = genCls.Name;
	if name ~= "None" then
		return name;
	end

	return GetClass("Monster", genCls.ClassType).Name;

end
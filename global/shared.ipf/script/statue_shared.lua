--- statue_shared.lua


function GET_PVP_STATUEPOSITION(ranking)

	if ranking == 1 then
		return "c_fedimian", 555, -72, -90;
	elseif ranking == 2 then
		return "c_fedimian", 508, -45, -90;
	elseif ranking == 3 then
		return "c_fedimian", 535, -45, -90;
	elseif ranking == 4 then
		return "c_fedimian", 562, -45, -90;
	else
		return "c_fedimian", 590, -45, -90;
	end	

end

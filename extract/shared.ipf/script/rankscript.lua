--- rankscript.lua

function GET_ELO_DELTA(my, other, win)

	local Kfactor = 25.0;

	local qA = math.pow(10.0, my / 400.0);
	local qB = math.pow(10.0, other / 400.0);

	local eA = (qA) / (qA + qB);
	local eB = (qB) / (qA + qB);

	local sA;
	if win == 1 then
		sA = 1.0;
	 else
		sA = 0.25;
	 end

	local deltaA = Kfactor * (sA - eA);
	return math.floor(deltaA);

end
---- dummypc_shared.lua

function GET_DPC_HIRE_PRICE(pc, dpc)

	--local consumeMedal = 1 + (dpc.Lv / 10);
	local consumeMedal = 30;
	return math.floor(consumeMedal);

end

function GET_DPC_REMAIN_PC_PRICE()

	return 1

end




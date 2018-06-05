

function GUARDGAUGE_ON_INIT(addon, frame)
 
	addon:RegisterMsg('GD_RANK', 'ON_GD_RANK');
	
end 

function GUARDGAUGE_FIRST_OPEN(frame)
	local gauge = GET_CHILD(frame, "gp", "ui::CGauge");
	gauge:SetPoint(500, 500);
end

function ON_GD_RANK(frame, msg, argStr, gp)

	
	local pc = GetMyPCObject();	
	local mgp = pc.MGP;

	local gauge = GET_CHILD(frame, "gp", "ui::CGauge");
	gauge:SetMaxPoint(mgp);
	gauge:SetPointWithTime(mgp - gp, 0.5);
	frame:ShowWindow(1);
	frame:SetDuration((pc.GP_Delay / 1000) + 1);

end




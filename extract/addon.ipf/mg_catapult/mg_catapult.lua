


function MG_CATAPULT_ON_INIT(addon, frame)



end

function MG_CATAPULT_CREATE(addon, frame)

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("MG_CATA_UPDATE");
	timer:Start(0.01);
end

function MG_CATA_GET_GAUGE(frame)

	local child = frame:GetChild("guide_dir"):GetChild("gau");
	return tolua.cast(child, "ui::CGauge");

end

function MG_CATA_SHOT(frame)
	
	local handle = frame:GetValue();
	frame:SetValue2(3);
	local gauge = MG_CATA_GET_GAUGE(frame);
	gauge:StopTimeProcess();
	-- movie.PlayAnim(handle, "ATK", 1.0);
		
	local obj = world.GetObject(frame:GetValue());
	local actor = obj:GetFSMActor();
	local stone = actor:GetRideChild();
	local sActor = stone:GetFSMActor();
	
	local power = gauge:GetCurPoint() * 50;
	mg.ShotCatapult(obj, stone, power);
	
end

function MG_CATA_UPDATE(frame)

	local handle = frame:GetValue();
	local curState = frame:GetValue2();
	
	if curState == 1 then
	
		if 1 == keyboard.IsKeyPressed("LEFT") then
			mg.Rotate(handle, 2);
		elseif 1 == keyboard.IsKeyPressed("RIGHT") then
			mg.Rotate(handle, -2);
		end
		
		if 1 == keyboard.IsKeyDown("SPACE") then
		
			movie.PlayAnim(handle, "ASTD", 1.0);
		
			frame:SetValue2(2);
			local gauge = MG_CATA_GET_GAUGE(frame);
			local time = 5;
			gauge:SetPoint(0, time);
			gauge:SetPointWithTime(time, time);
		
		end
		
	elseif curState == 2 then

		local isEnd = keyboard.IsKeyUp("SPACE");
		if 1 == isEnd then
			MG_CATA_SHOT(frame);
		end
	
	end
	
				
	
	--[[
	print ( "ZZZZ" );
	print ( keyboard.IsKeyPressed("UP") );
	print ( keyboard.IsKeyPressed("DOWN") );
	print ( keyboard.IsKeyPressed("LEFT") );
	print ( keyboard.IsKeyPressed("RIGHT") );
	]]
	
	

end

function START_MG_CATA(handle)

	local frame = ui.GetFrame("mg_catapult");
	frame:ShowWindow(1);
	frame:SetValue(handle);
	frame:SetValue2(1);
	control.EnableControl(0);
	mg.TargetCam(handle);
	
	local gauge = MG_CATA_GET_GAUGE(frame);
	gauge:SetPoint(0, 5);
	
end

function END_MG_CATA(frame)

	control.EnableControl(1);
	mg.NormalCam();

end











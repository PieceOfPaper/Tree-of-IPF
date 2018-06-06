
function  FULLDARK_DO_CLOSE(frame)
	frame:ShowWindow(0)
end

function FULLDARK_OPEN()
	ui.OpenFrame("hair_gacha_skip_btn")
	local frame = ui.GetFrame("hair_gacha_skip_btn")
	frame:ShowWindow(1)
end

function FULLDARK_CLOSE(frame, isLeticia, byContinue)
	local index = 1;
	while index < 12  do 
		local smallframename = "HAIRGACHA_SMALL_"..tostring(index);        
		HAIR_GACHA_SMALL_FRAME_SHOWICON(smallframename);     
        if byContinue == true then
            ui.CloseFrame(smallframename);
        elseif isLeticia ~= true then
		    ReserveScript( string.format("ui.CloseFrame(\"%s\")", smallframename) , 2);
        end

		local bigframename = "HAIRGACHA_BIG_"..tostring(index);
		local eachbigframe = ui.GetFrame(bigframename);
		if eachbigframe ~= nil then
            if byContinue == true then
                CLOSE_N_DESTROY_FRAME(bigframename);
            else
			    eachbigframe:SetUserValue("GACHA_FRAME_INDEX", -1);
			    ReserveScript( string.format("CLOSE_N_DESTROY_FRAME(\"%s\")", bigframename), 0.5);
            end
		end
		index = index + 1;
	end

	ui.CloseFrame("hair_gacha_skip_btn");    
	ui.FlushGachaDelayPacket();
end

-------------------
function DARK_FRAME_DO_OPEN(isLeticia)
    ui.OpenFrame("hair_gacha_skip_btn");
	local frame = ui.GetFrame("hair_gacha_skip_btn");
	frame:ShowWindow(1);

	local darkframe = ui.GetFrame("fulldark");
    darkframe:SetUserValue('IS_LETICIA', isLeticia);
    darkframe:SetLayerLevel(97);
	darkframe:ShowWindow(1);
end

function DARK_FRAME_DO_CLOSE(byContinue)
	local darkframe = ui.GetFrame("fulldark");
    local gachaCnt = darkframe:GetUserIValue('GACHA_COUNT');    
    if darkframe:GetUserIValue('IS_LETICIA') == 1 and gachaCnt > 1 then
        FULLDARK_CLOSE(darkframe, true);
        ui.OpenFrame('leticia_more');
    else
        if byContinue ~= nil then
            FULLDARK_CLOSE(darkframe, true, byContinue);
        else
    	    darkframe:ShowWindow(0);
    	end
    end
end

function SET_BEFORE_GACHA_CLASS_NAME(gachaClassName, itemClassName)
    local fulldark = ui.GetFrame('fulldark');
    fulldark:SetUserValue('BEFORE_GACHA_NAME', gachaClassName);
    fulldark:SetUserValue('BEFORE_ITEM_NAME', itemClassName);
end
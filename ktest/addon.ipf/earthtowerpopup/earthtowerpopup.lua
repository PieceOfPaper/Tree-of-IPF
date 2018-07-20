
function EARTHTOWERPOPUP_ON_INIT(addon, frame)
	addon:RegisterMsg("EARTH_TOWER_POPUP", "ON_UPDATE_EARTH_TOWER_POPUP");
end

function UPDATE_EARTH_TOWER_POPUP(mgameValue)

	local frame = ui.GetFrame("earthtowerpopup");
	ON_UPDATE_EARTH_TOWER_POPUP(frame, "ON_UPDATE_EARTH_TOWER_POPUP", mgameValue);

end

function ON_UPDATE_EARTH_TOWER_POPUP(frame, msg, mgameValue, isLeader)
	local pcparty = session.party.GetPartyInfo(PARTY_NORMAL);
	if pcparty == nil then
		return;
	end	

	frame:ShowWindow(1);

	local partyObj = GetIES(pcparty:GetObject());

	frame:SetUserValue("STARTWAITSEC", 60);

	frame:SetUserValue("MGAME_VALUE", mgameValue);

	frame:SetUserValue("ELAPSED_SEC", 0);
	frame:SetUserValue("START_SEC", imcTime.GetAppTime());

	
	frame:RunUpdateScript("EARTH_TOWER_POPUP_UPDATE_STARTWAITSEC", 0, 0, 0, 1)
end

function EARTH_TOWER_NEXT_FLOOR(parent, ctrl)
	local frame = parent:GetTopParentFrame();	
	local mgameValue = frame:GetUserValue("MGAME_VALUE");
    if mgameValue == 'GT_SELECT_STAGE_20' then
        local list = session.party.GetPartyMemberList(PARTY_NORMAL);
        local count = list:Count();	
        local limit_lv = 310
        local shortfall = 0
        if count > 0 then
            local i
            
            for i = 0, count-1 do
                local partyMemberInfo = list:Element(i);
                local level = partyMemberInfo:GetLevel();
                if level < limit_lv then
                    shortfall = shortfall + 1
                end
            end
        end
    
        if shortfall == 0 or shortfall == nil then

        	local mgameValue = frame:GetUserValue("MGAME_VALUE");
        	pc.ReqExecuteTx("SCR_EARTH_TOWER_NEXT_FLOOR", mgameValue);
            frame:ShowWindow(0);
        else
            addon.BroadMsg("NOTICE_Dm_!", ScpArgMsg("GT_shortfallMember_1"), 10);
            return
        end
        return
    else
    	local mgameValue = frame:GetUserValue("MGAME_VALUE");
    	pc.ReqExecuteTx("SCR_EARTH_TOWER_NEXT_FLOOR", mgameValue);
    	frame:ShowWindow(0);
    end
end

function EARTH_TOWER_STOP(parent, ctrl)
	local frame = parent:GetTopParentFrame();	
	local mgameValue = frame:GetUserValue("MGAME_VALUE");
	pc.ReqExecuteTx("SCR_TX_EARTH_TOWER_STOP", mgameValue);
	frame:ShowWindow(0);		
end

function EARTH_TOWER_POPUP_UPDATE_STARTWAITSEC(frame)
	
	local startWaitSec = frame:GetUserIValue("STARTWAITSEC");
	local elapsedSec = frame:GetUserIValue("ELAPSED_SEC");
	local startSec = frame:GetUserIValue("START_SEC");
	local curSec = imcTime.GetAppTime() -  startSec + elapsedSec;
	local remainSec = startWaitSec - curSec;
	remainSec = math.floor(remainSec);
	if remainSec < 0 then
		local mgameValue = frame:GetUserValue("MGAME_VALUE");
		pc.ReqExecuteTx("SCR_TX_EARTH_TOWER_STOP", mgameValue);
		frame:ShowWindow(0);
		return 0;
	end

	local gauge = GET_CHILD(frame, "gauge");
	gauge:SetPoint(remainSec, startWaitSec);
	local txt_startwaittime = frame:GetChild("txt_startwaittime");	

	local remainMin = math.floor(remainSec / 60);
	local remainSec = remainSec % 60;
	local timeText = string.format("%d : %02d", remainMin, remainSec);
	txt_startwaittime:SetTextByKey("value", timeText);

	return 1;
end


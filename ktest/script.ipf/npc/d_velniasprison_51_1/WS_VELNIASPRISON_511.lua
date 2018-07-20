function VELNIASP_WARP_511_SLEEP(self, pc, x, y, z)
	if  GetExProp(pc, "PLAYING_VELNIAS_WARP") == 1 then
		return;
	end

	SetExProp(pc, "PLAYING_VELNIAS_WARP", 1);
    PlayAnim(pc, 'WARP', 0)
    sleep(1000)
    UIOpenToPC(pc,'fullblack',1)
    SetPos(pc, x, y, z)
    UIOpenToPC(pc,'fullblack',0)
    PlayAnim(pc, 'SLAND', 0)
	SetExProp(pc, "PLAYING_VELNIAS_WARP", 0);
end

function SCR_VELNIASP_511_GROUP_1_1_DIALOG(self, pc)
    RunScript('VELNIASP_WARP_511_SLEEP', self, pc, 72, 260, 901)
end

function SCR_VELNIASP_511_GROUP_1_2_DIALOG(self, pc)
    RunScript('VELNIASP_WARP_511_SLEEP', self, pc, -38, 223, 580)
end

function SCR_VELNIASP_511_GROUP_2_1_DIALOG(self, pc)
    RunScript('VELNIASP_WARP_511_SLEEP', self, pc, -970, 345, 123)
end

function SCR_VELNIASP_511_GROUP_2_2_DIALOG(self, pc)
    RunScript('VELNIASP_WARP_511_SLEEP', self, pc, -623, 223, -11)
end

function SCR_VELNIASP_511_GROUP_3_1_DIALOG(self, pc)
    RunScript('VELNIASP_WARP_511_SLEEP_3_1', self, pc, 908, 947, -3)
end

function SCR_VELNIASP_511_GROUP_3_2_DIALOG(self, pc)
    RunScript('VELNIASP_WARP_511_SLEEP', self, pc, 672, 224, -2)
end

function SCR_VELNIASP_511_GROUP_4_2_DIALOG(self, pc)
    RunScript('VELNIASP_WARP_511_SLEEP', self, pc, 19, 260, -892)
end

function SCR_VELNIASP511_TO_VELNIASP512_DIALOG(self, pc)
    local result = DOTIMEACTION_R(pc, ScpArgMsg("VPRISON_PORTAL_1"), 'WARP', 2)
    if result == 1 then
        SCR_WS_SCRIPT(self, pc,'VELNIASP511_TO_VELNIASP512')
    end
end

function SCR_VELNIASP511_TO_FARM472_DIALOG(self, pc)
    local result = DOTIMEACTION_R(pc, ScpArgMsg("VPRISON_PORTAL_1"), 'WARP', 2)
    if result == 1 then
        if IsProgressColonyWar(self) == 0 then
            SCR_WS_SCRIPT(self, pc,'VELNIASP511_TO_FARM472')
        else
            local check, ZoneName, warpClsName = SCR_GUILD_COLONY_ENTER_CHECK(self, pc) --해당 지역의 콜로니전 채널 입장 체크
            if check == "NORMAL" then
                SCR_WS_SCRIPT(self, pc,'VELNIASP511_TO_FARM472')
            elseif check == "COLONY" then
                MoveColonyWarLocation(pc, ZoneName, warpClsName)
            elseif check == "FAIL" then
            end
        end
    end
end

function VELNIASP_WARP_511_SLEEP_3_1(self, pc, x, y, z)
	if  GetExProp(pc, "PLAYING_VELNIAS_WARP") == 1 then
		return;
	end

	SetExProp(pc, "PLAYING_VELNIAS_WARP", 1);
    PlayAnim(pc, 'WARP', 0)
    UIOpenToPC(pc,'fullblack',1)
    SetPos(pc, x, y, z)
    sleep(2000)
    UIOpenToPC(pc,'fullblack',0)
    PlayAnim(pc, 'SLAND', 0)
	SetExProp(pc, "PLAYING_VELNIAS_WARP", 0);
end
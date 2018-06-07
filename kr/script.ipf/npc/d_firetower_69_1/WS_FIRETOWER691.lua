function FTOWER691_WARP_SLEEP(self, pc, classname)
--    UIOpenToPC(pc,'fullblack',1)
    SCR_WS_SCRIPT(self, pc, classname, 1)
--    sleep(1800)
--    UIOpenToPC(pc,'fullblack',0)
--    PlayAnim(pc, 'SLAND', 0)
end


function FTOWER691_WARP_CHECK(self)
    local result = SCR_QUEST_CHECK(self, 'FIRETOWER691_SQ_3')
    if result == 'COMPLETE' then
        return 1
    end
    return 0
end

function SCR_FIRETOWER691_TO_REMAINS37_ENTER(self, pc)
    SCR_WS_SCRIPT(self, pc, 'FIRETOWER691_TO_REMAINS37')
end

function SCR_FIRETOWER691_TO_FIRETOWER692_DIALOG(self, pc)
--    local result = DOTIMEACTION_R(pc, ScpArgMsg("VPRISON_PORTAL_1"), 'WARP', 2)
--    if result == 1 then
        RunScript('FTOWER691_WARP_SLEEP', self, pc, 'FIRETOWER691_TO_FIRETOWER692')
--    end
end



function SCR_FIRETOWER691_1_TO_FIRETOWER691_2_DIALOG(self, pc)
    if FTOWER691_WARP_CHECK(pc) == 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("VPRISON_PORTAL_1"), 'WARP', 2)
        if result == 1 then
            SCR_SETPOS_FADEOUT(pc, 'd_firetower_69_1', 1253, -870, -1310, 15)
            --RunScript('FTOWER691_WARP_SLEEP', self, pc, 'FIRETOWER691_1_TO_FIRETOWER691_2')
        end
    else
        ShowBalloonText(pc, 'FIRETOWER691_WARP_1', 5)
    end
end

function SCR_FIRETOWER691_2_TO_FIRETOWER691_1_DIALOG(self, pc)
    if FTOWER691_WARP_CHECK(pc) == 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("VPRISON_PORTAL_1"), 'WARP', 2)
        if result == 1 then
            SCR_SETPOS_FADEOUT(pc, 'd_firetower_69_1', -1726, -868, -346, 15)
            --RunScript('FTOWER691_WARP_SLEEP', self, pc, 'FIRETOWER691_2_TO_FIRETOWER691_1')
        end
    else
        ShowBalloonText(pc, 'FIRETOWER691_WARP_1', 5)
    end
end

function SCR_FIRETOWER691_3_TO_FIRETOWER691_4_DIALOG(self, pc)
    if FTOWER691_WARP_CHECK(pc) == 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("VPRISON_PORTAL_1"), 'WARP', 2)
        if result == 1 then
            SCR_SETPOS_FADEOUT(pc, 'd_firetower_69_1', 1492, -792, 669, 15)
            --RunScript('FTOWER691_WARP_SLEEP', self, pc, 'FIRETOWER691_3_TO_FIRETOWER691_4')
        end
    else
        ShowBalloonText(pc, 'FIRETOWER691_WARP_1', 5)
    end
end

function SCR_FIRETOWER691_4_TO_FIRETOWER691_3_DIALOG(self, pc)
    if FTOWER691_WARP_CHECK(pc) == 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("VPRISON_PORTAL_1"), 'WARP', 2)
        if result == 1 then
            SCR_SETPOS_FADEOUT(pc, 'd_firetower_69_1', -1593, -868, -191, 15)
            --RunScript('FTOWER691_WARP_SLEEP', self, pc, 'FIRETOWER691_4_TO_FIRETOWER691_3')
        end
    else
        ShowBalloonText(pc, 'FIRETOWER691_WARP_1', 5)
    end
end




function FTOWER691_MOVING_1(self)
    local x, y, z = GetPos(self)
    RunPad(self, 'FTOWER691_moving_1', nil, x, y, z, 0, 1)
end

function FTOWER691_MOVING_2(self)
    local x, y, z = GetPos(self)
    RunPad(self, 'FTOWER691_moving_2', nil, x, y, z, 0, 1)
end

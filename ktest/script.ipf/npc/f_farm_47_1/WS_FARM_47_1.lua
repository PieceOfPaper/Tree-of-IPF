function SCR_FARM_47_1_TO_FARM_47_4_ENTER(self, pc)
    if IsProgressColonyWar(self) == 0 then
        SCR_WS_SCRIPT(self, pc,'FARM_47_1_TO_FARM_47_4')
    else
        local check, ZoneName, warpClsName = SCR_GUILD_COLONY_ENTER_CHECK(self, pc) --해당 지역의 콜로니전 채널 입장 체크
        if check == "NORMAL" then
            SCR_WS_SCRIPT(self, pc,'FARM_47_1_TO_FARM_47_4')
        elseif check == "COLONY" then
            MoveColonyWarLocation(pc, ZoneName, warpClsName)
        elseif check == "FAIL" then
        end
    end
end

function SCR_FARM_47_1_TO_FARM_47_2_ENTER(self, pc)
    if IsProgressColonyWar(self) == 0 then
        SCR_WS_SCRIPT(self, pc,'FARM_47_1_TO_FARM_47_2')
    else
        local check, ZoneName, warpClsName = SCR_GUILD_COLONY_ENTER_CHECK(self, pc) --해당 지역의 콜로니전 채널 입장 체크
        if check == "NORMAL" then
            SCR_WS_SCRIPT(self, pc,'FARM_47_1_TO_FARM_47_2')
        elseif check == "COLONY" then
            MoveColonyWarLocation(pc, ZoneName, warpClsName)
        elseif check == "FAIL" then
        end
    end
end

function SCR_FARM_47_1_TO_HUEVILL_58_3_ENTER(self, pc)
    SCR_WS_SCRIPT(self, pc,'FARM_47_1_TO_HUEVILL_58_3')
end


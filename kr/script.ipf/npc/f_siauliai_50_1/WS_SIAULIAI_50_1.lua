function SCR_SIAUL50_1_TO_FARM_47_4_ENTER(self, pc)
    if IsProgressColonyWar(self) == 0 then
        SCR_WS_SCRIPT(self, pc,'SIAUL50_1_TO_FARM_47_4')
    else
        local check, ZoneName, warpClsName = SCR_GUILD_COLONY_ENTER_CHECK(self, pc) --해당 지역의 콜로니전 채널 입장 체크
        if check == "NORMAL" then
            SCR_WS_SCRIPT(self, pc,'SIAUL50_1_TO_FARM_47_4')
        elseif check == "COLONY" then
            MoveColonyWarLocation(pc, ZoneName, warpClsName)
        elseif check == "FAIL" then
        end
    end
end

function SCR_SIAUL50_1_TO_KLAPEDA_ENTER(self, pc)
    SCR_WS_SCRIPT(self, pc,'SIAUL50_1_TO_KLAPEDA')
end

function SCR_SIAUL50_1_TO_HUEVILLAGE_58_1_ENTER(self, pc)
    SCR_WS_SCRIPT(self, pc,'SIAUL50_1_TO_HUEVILLAGE_58_1')
end

function SCR_SIAUL50_1_TO_HUEVILLAGE_58_2_ENTER(self, pc)
    SCR_WS_SCRIPT(self, pc,'SIAUL50_1_TO_HUEVILLAGE_58_2')
end


function SCR_SIAULIAI_50_1_TO_PRISON_75_1_DIALOG(self, pc)
    SCR_WS_SCRIPT(self,pc,'SIAULIAI_50_1_TO_PRISON_75_1')
end
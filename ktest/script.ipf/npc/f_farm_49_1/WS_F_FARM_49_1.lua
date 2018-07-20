function SCR_FARM491_TO_FARM472_ENTER(self, pc)
    if IsProgressColonyWar(self) == 0 then
        SCR_WS_SCRIPT(self,pc,'FARM491_TO_FARM472')
    else
        local check, ZoneName, warpClsName = SCR_GUILD_COLONY_ENTER_CHECK(self, pc) --해당 지역의 콜로니전 채널 입장 체크
        if check == "NORMAL" then
            SCR_WS_SCRIPT(self,pc,'FARM491_TO_FARM472')
        elseif check == "COLONY" then
            MoveColonyWarLocation(pc, ZoneName, warpClsName)
        elseif check == "FAIL" then
        end
    end
end

function SCR_FARM491_TO_FARM492_ENTER(self, pc)
    SCR_WS_SCRIPT(self,pc,'FARM491_TO_FARM492')
end

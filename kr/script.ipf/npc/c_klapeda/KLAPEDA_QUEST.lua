function SCR_KLAPEDA_USKA_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end



function CMINE6_TO_KATYN7_2_FUNC(pc)
    local sObj_main = GetSessionObject(pc, 'ssn_klapeda')
    if sObj_main ~= nil then
        if sObj_main.WARP_F_SIAULIAI_OUT < 300 then
            sObj_main.WARP_F_SIAULIAI_OUT = 300
            SaveSessionObject(pc, sObj_main)
        end
    end
end

function SCR_GETBOXBUFF(self, pc, argNum, evt)
-- 추가로 버프 추가 시, Map.xmld의 경험치나 특정 컬럽값을 참고하여 분류하는 방법 고려
        local box_pos = GetZoneName(self)
        
        if box_pos == "f_siauliai_west" or box_pos == "f_siauliai_est" then
            local bufferking = GetClassString("Buff", "beginner_ExpUp_20", "Name");
            SendAddOnMsg(pc, 'NOTICE_Dm_scroll', bufferking..ScpArgMsg("Auto__BeoPeu_HoegDeug"), 4)
    		AddBuff(pc, pc, 'beginner_ExpUp_20');
    	else
            local bufferking = GetClassString("Buff", "Colletor_Etc_Low", "Name");
            SendAddOnMsg(pc, 'NOTICE_Dm_scroll', bufferking..ScpArgMsg("Auto__BeoPeu_HoegDeug"), 4)
    		AddBuff(pc, pc, 'Colletor_Etc_Low');
    	end
end

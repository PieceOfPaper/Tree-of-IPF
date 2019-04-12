function SCR_BUFF_ENTER_Event_FireSongPyeon(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM + 4;
	self.SR_BM = self.SR_BM + 1;
end

function SCR_BUFF_UPDATE_Event_FireSongPyeon(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Event_FireSongPyeon(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM - 4;
    self.SR_BM = self.SR_BM - 1;
end
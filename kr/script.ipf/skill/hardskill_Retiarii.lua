function RETIARII_FISHINGNETSDRAW(self, skill, x, y, z,  speed, accel, ignoreHoldMove, monAiHold, buff, buttTime)
    local targetList = GetHardSkillTargetList(self)
    for i = 1, #targetList do
        local obj = targetList[i]
        SkillCancel(obj);
        Move3D(obj, x, y, z, speed, accel, ignoreHoldMove, monAiHold);  
        AddBuff(self, obj, buff, 1, 0, buttTime, 1)
    end
end


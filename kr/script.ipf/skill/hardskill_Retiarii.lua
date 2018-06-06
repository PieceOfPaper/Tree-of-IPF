function RETIARII_FISHINGNETSDRAW(self, skill, x, y, z,  speed, accel, ignoreHoldMove, monAiHold, buff, buttTime)
    local targetList = GetHardSkillTargetList(self)
    for i = 1, #targetList do
        local obj = targetList[i]
        AddBuff(self, obj, buff, 1, 0, buttTime, 1);
        if IsBuffApplied(obj, "FishingNetsDraw_Debuff") == "YES" then
            SkillCancel(obj);
            Move3D(obj, x, y, z, speed, accel, ignoreHoldMove, monAiHold);  
        end
    end
end


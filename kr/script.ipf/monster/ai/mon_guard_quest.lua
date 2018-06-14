function SCR_MON_GUARD_QUEST_TS_BORN_ENTER(self)
    MON_CREATEPOS_RESET(self)
end

function SCR_MON_GUARD_QUEST_TS_BORN_UPDATE(self)
    
	if self.HP / self.MHP < 0.2 then
        AddHP(self, self.MHP * 0.2)
    end
    if self.NumArg1 + 15 <= os.clock() then
        if self.HP / self.MHP > 0.4 then
            AddHP(self, self.MHP * 0.35 - self.HP )
            self.NumArg1 = math.floor(os.clock())
        end
    end
    
    if self.HP < self.MHP * 0.4 then
        SetEmoticon(self, 'I_emo_hploweffect')
    else
        SetEmoticon(self, 'None')
    end
    
    if IS_CHASING_SKILL(self) ~= 1 then
        local target = GetNearTopHateEnemy(self);
        if target == nil then
            local objList, objCount = SelectObject(self, 150, 'ENEMY');
            
            if objCount > 0 then
                local i
                for i = 1, objCount do
                    if GetCurrentFaction(objList[i]) ~= 'HitMe' and GetCurrentFaction(objList[i]) ~= 'Dice' then
                        target = objList[i]
                    end
                end
            end
        end
        
        if target ~= nil then
            local return_check = 'None'
            return_check = SCR_MON_GUARD_QUEST_CREATE_CHECK(self, target)
            if return_check == 'RETURN' then
                return
            end
            local selectedSkill = SelectMonsterSkillByRatio(self);
			if selectedSkill == 'None' then
			    return
			end
			local skill = GetSkill(self, selectedSkill);
			local splashType = skill.SplType;
			local maxRange = skill.MaxR;
			if splashType == 'Square' then
				maxRange = skill.SklWaveLength;
			elseif splashType == 'Fan' then
				maxRange = skill.SklSplRange;
			elseif splashType == 'Circle' then
				maxRange = skill.SklSplRange;
			end
			
			local dist = GetDistance(self, target);
			
			if dist > maxRange then
				MoveToTarget(self, target, maxRange - 5);
			end
			
			local curHate = GetHate(self, target);
			if curHate == 0 then
				InsertHate(self, target, 1);
				StopMove(self);
				LookAt(self, target);
			end

			if dist <= maxRange then
				UseMonsterSkill(self, target, selectedSkill);
			end
        end
    else
        local target = GetSkillTarget(self)
        SCR_MON_GUARD_QUEST_CREATE_CHECK(self, target)
    end
end

function SCR_MON_GUARD_QUEST_TS_BORN_LEAVE(self)

end


function SCR_MON_GUARD_QUEST_TS_DEAD_ENTER(self)

end

function SCR_MON_GUARD_QUEST_TS_DEAD_UPDATE(self)

end

function SCR_MON_GUARD_QUEST_TS_DEAD_LEAVE(self)

end

function SCR_MON_GUARD_QUEST_CREATE_CHECK(self, target)
    if target ~= nil then
        local tarX, tarY, tarZ = GetPos(target)
        local dist = SCR_POINT_DISTANCE(tarX, tarZ, self.CreateX, self.CreateZ)
        if dist >= 50 then
            SkillCancel(self)
            ResetHate(self)
            MON_GOTO_CREATEPOS(self)
            return 'RETURN'
--                HoldMonScp(self, 2000)
        end
    end
end


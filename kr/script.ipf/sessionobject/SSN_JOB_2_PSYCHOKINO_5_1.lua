function SCR_SSN_JOB_2_PSYCHOKINO_5_1_BASIC_HOOK(self, sObj)
end
function SCR_CREATE_SSN_JOB_2_PSYCHOKINO_5_1(self, sObj)
	SCR_SSN_JOB_2_PSYCHOKINO_5_1_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_JOB_2_PSYCHOKINO_5_1(self, sObj)
	SCR_SSN_JOB_2_PSYCHOKINO_5_1_BASIC_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_JOB_2_PSYCHOKINO_5_1(self, sObj)
end



function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_1_DIALOG(self, pc)
    SCR_JOB_2_PSYCHOKINO_5_1_BOOK_RUN(self, pc, 1)
end

function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_2_DIALOG(self, pc)
    SCR_JOB_2_PSYCHOKINO_5_1_BOOK_RUN(self, pc, 2)
end

function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_3_DIALOG(self, pc)
    SCR_JOB_2_PSYCHOKINO_5_1_BOOK_RUN(self, pc, 3)
end

function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_4_DIALOG(self, pc)
    SCR_JOB_2_PSYCHOKINO_5_1_BOOK_RUN(self, pc, 4)
end

function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_5_DIALOG(self, pc)
    SCR_JOB_2_PSYCHOKINO_5_1_BOOK_RUN(self, pc, 5)
end



function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_RUN(self, pc, num)
    local questCheck1 = SCR_QUEST_CHECK(pc, 'JOB_2_PSYCHOKINO_5_1')
    local questCheck2 = SCR_QUEST_CHECK(pc, 'MASTER_PSYCHOKINO1')
    if questCheck1 == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_JOB_2_PSYCHOKINO_5_1')
        if sObj ~= nil then
            if sObj['QuestInfoValue'..num] == 0 then
                local list, Cnt = SelectObjectByFaction(pc, 200, 'Monster');
                if Cnt >= 1 then
                    for i = 1, Cnt do
                    InsertHate(list[i], pc, 1)
                    end
                end
                
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'JOB_2_PSYCHOKINO_5_1')
                local result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_2_PSYCHOKINO_5_1_MSG01"), 'SITREAD', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(pc, result, animTime, before_time, 'JOB_2_PSYCHOKINO_5_1')
                if result == 1 then
                    ShowBookItem(pc, 'JOB_2_PSYCHOKINO_5_1_BOOK_dlg_'..num);
                    sObj['QuestInfoValue'..num] = sObj['QuestInfoMaxCount'..num];
                    sObj['QuestMapPointView'..num] = 0;
                    SaveSessionObject(pc, sObj)
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("JOB_2_PSYCHOKINO_5_1_MSG02"), 5);
            end
        end
    elseif questCheck2 == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_MASTER_PSYCHOKINO1')
        if sObj ~= nil then
            if sObj['QuestInfoValue'..num] == 0 then
                local list, Cnt = SelectObjectByFaction(pc, 200, 'Monster');
                if Cnt >= 1 then
                    for i = 1, Cnt do
                    InsertHate(list[i], pc, 1)
                    end
                end
                
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'MASTER_PSYCHOKINO1')
                local result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_2_PSYCHOKINO_5_1_MSG01"), 'SITREAD', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(pc, result, animTime, before_time, 'MASTER_PSYCHOKINO1')
                if result == 1 then
                    ShowBookItem(pc, 'JOB_2_PSYCHOKINO_5_1_BOOK_dlg_'..num);
                    sObj['QuestInfoValue'..num] = sObj['QuestInfoMaxCount'..num];
                    sObj['QuestMapPointView'..num] = 0;
                    SaveSessionObject(pc, sObj)
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("JOB_2_PSYCHOKINO_5_1_MSG02"), 5);
            end
        end
    end
end

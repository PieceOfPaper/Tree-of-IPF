-- function SCR_INSTANCE_DUNGEON_DIALOG(self, pc)
--     local result = SCR_QUEST_CHECK(pc, 'TUTO_INSTANT_DUNGEON')
--     if result == 'PROGRESS' then
--         local sObj = GetSessionObject(pc, 'SSN_TUTO_INSTANT_DUNGEON')
--         if GetZoneName(pc) == 'c_Klaipe' then
--             sObj.QuestInfoValue1 = 1
--             COMMON_QUEST_HANDLER(self,pc)
--         end
--     elseif result == 'SUCCESS' then
--             COMMON_QUEST_HANDLER(self,pc)
--     else
--         local indunList = { };
--         local allIndunList, allIndunCount = GetClassList('Indun');  -- 모든 인던 리스트를 불러와서 --
--         for i = 0, allIndunCount - 1 do
--             local indunClass = GetClassByIndexFromList(allIndunList, i);
--             if indunClass ~= nil and TryGetProp(indunClass, 'DungeonType') == 'Indun' then  -- DungeonType 이 Indun 인 리스트만 추가 --
--                 indunList[#indunList + 1] = indunClass;
--             end
--         end
        
--         if #indunList == 0 then
--             return;
--         end
        
--         for i = 1, #indunList - 1 do
--             for j = i + 1, #indunList do
--                 if indunList[i].Level > indunList[j].Level then
--                     local temp = indunList[i];
--                     indunList[i] = indunList[j];
--                     indunList[j] = temp;
--                 end
--             end
--         end
        
--         local indunSelList = { indunList[1] };
        
--         local myLevel = TryGetProp(pc, 'Lv');
--         if myLevel == nil then
--             myLevel = 1;
--         end
        
--         -- 추천인던 검색 --
--         for i = 2, #indunList do
--             local searchIndun = indunList[i];
--             if searchIndun.Level <= myLevel then    -- 비교 인던이 내 레벨 이하면서 --
--                 local recommendIndun = indunSelList[1];
--                 if searchIndun.Level > recommendIndun.Level then    -- 비교 인던이 현재 추천 인던보다 고레벨 인던이라면 --
--                     indunSelList[1] = searchIndun;
--                 end
--             end
--         end
        
--         -- 나머지 인던 정렬 --
--         for j = 1, #indunList do
--             local indunClassName = indunList[j].ClassName;
--             if indunClassName ~= indunSelList[1].ClassName then -- 추천으로 1번에 있는 인던이 아니라면 리스트에 추가 --
--                 indunSelList[#indunSelList + 1] = indunList[j];
--             end
--         end
        
--         local etcObj = GetETCObject(pc);
--         if etcObj ~= nil then
--             local selDialogList = { };
--             for i = 1, #indunSelList do
--                 local indunClass = indunSelList[i];
--                 selDialogList[i] = ScpArgMsg('IndunSelectDialog','ID_NAME',TryGetProp(indunClass, 'Name'),'ID_LV',TryGetProp(indunClass, 'Level'),'PC_RANK',TryGetProp(indunClass, 'PCRank'))
--             end
            
--             local select = SCR_SEL_LIST(pc, selDialogList, 'ID_ENDTER_DIALOG');
--             if select ~= nil and select >= 1 and select <= #selDialogList then
--                 if indunSelList[select] ~= nil then
--                     local selectIndun = indunSelList[select];
--                     local afterSelectDialog = 'INDUN_AFTER_SELECT_DIALOG1\\' .. ScpArgMsg('IndunAfterSelectDialog', 'ID_NAME', selectIndun.Name, 'ID_LV', selectIndun.Level,'ID_NEEDRANK',TryGetProp(selectIndun, 'PCRank'))
                    
--                     if selectIndun.Level == 180 then
--                         afterSelectDialog = 'INDUN_AFTER_SELECT_DIALOG1\\' .. ScpArgMsg('Indun_Enter_msg_180')
--                     elseif selectIndun.Level == 230 then
--                         afterSelectDialog = 'INDUN_AFTER_SELECT_DIALOG1\\' .. ScpArgMsg('Indun_Enter_msg_230')
--                     elseif selectIndun.Level == 300 then
--                         afterSelectDialog = 'INDUN_AFTER_SELECT_DIALOG1\\' .. ScpArgMsg('Indun_Enter_msg_300')
--                     end
--                     AUTOMATCH_INDUN_DIALOG(pc, afterSelectDialog, selectIndun.ClassName);
--                 end
--             end
--         end
--     end
-- end
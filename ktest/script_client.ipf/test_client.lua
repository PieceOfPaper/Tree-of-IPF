-- test_client.lua

function SCR_CLIENTTESTSCP(handle)
    session.friends.TestAddManyFriend(FRIEND_LIST_COMPLETE, 200);
    session.friends.TestAddManyFriend(FRIEND_LIST_BLOCKED, 100);
end

function SCR_OPER_RELOAD_HOTKEY(handle)
	ReloadHotKey();
    SHOW_SOULCRYSTAL_COUNT(nil, 1)
end

function TEST_CLIENT_CHAT_PET_EXP()
    local pet = GET_SUMMONED_PET()
    if pet == nil then
        pet = GET_SUMMONED_PET_HAWK()
    end

    if pet == nil then
        ui.SysMsg(ClMsg("SummonedPetDoesNotExist"));
        return;
    end

    local petInfo = session.pet.GetPetByGUID(summonedPet:GetStrGuid());
    local curTotalExp = petInfo:GetExp();
    local xpInfo = gePetXP.GetXPInfo(gePetXP.EXP_PET, curTotalExp);
    local totalExp = xpInfo.totalExp - xpInfo.startExp;
    local curExp = curTotalExp - xpInfo.startExp;
    local say = curExp..'/'..totalExp;
    ui.Chat(say);
end

function SCR_CLIENT_PRINT(...)
	print(...);
end

function JOB_ABIL_LIST_CLIENT(jobClassName)
    if jobClassName == nil or jobClassName == 0 or jobClassName == "" then
        jobClassName = "ALL";
    end
    
    local classList, classCount = GetClassList("Job");
    if classList == nil or classCount == 0 then
        return;
    end
    
    local abilList = { };
    local jobCategory = { };
    
    for i = 0, classCount - 1 do
        local job = GetClassByIndexFromList(classList, i);
        if job ~= nil then
            if (jobClassName == TryGetProp(job, "ClassName") or jobClassName == "ALL") and 10 >= TryGetProp(job, "Rank") then
                local jobName = TryGetProp(job, "EngName");
                local abilClass, abilCount = GetClassList("Ability_" .. jobName);
                
                if abilClass ~= nil then
                    for j = 0, abilCount - 1 do
                        local abil = GetClassByIndexFromList(abilClass, j);
                        if abil ~= nil then
                            local abilName = TryGetProp(abil, "ClassName");
                            local abilXML = GetClass("Ability", abilName);
                            if abilXML ~= nil then
                                jobCategory[#jobCategory + 1] = TryGetProp(job, "ClassName");
                                
                                abilList[#abilList + 1] = abilXML;
                            end
                        end
                    end
                end
            end
        end
    end
    
    
    
    local file = io.open("C:\\testxml\\JobAbilList_" .. jobClassName .. ".xml", "w");
    if file == nil then
        file = io.open("C:\\JobAbilList_" .. jobClassName .. ".xml", "w");
    end
    
    
    local headText = '<?xml version="1.0" encoding="UTF-8"?>\n<!-- edited with XMLSPY v2004 rel. 2 U (http://www.xmlspy.com) by imc (imc) -->\n    <Category>\n';
    local text = "";
    
    local startLine = '<Class ';
    local endLine = ' />\n';
    
    local jobTemp = nil;
    for k = 1, #abilList do
        if jobTemp == nil then
            text = text .. '<Category Name="' .. GetClass("Job", jobCategory[k]).Name .. '">\n';
        elseif jobCategory[k] ~= jobTemp then
            text = text .. '</Category>\n';
            text = text .. '<Category Name="' .. GetClass("Job", jobCategory[k]).Name .. '">\n';
        end
        
        local jobEngName = GetClass("Job", jobCategory[k]).EngName;
        
        text = text .. startLine
        			.. 'Name="' .. abilList[k].Name .. '"'
        			.. ' ClassName="' .. abilList[k].ClassName .. '"'
        			.. ' Desc="' .. abilList[k].Desc .. '"'
--        			.. ' AlwaysActive="' .. abilList[k].AlwaysActive .. '"'
        			.. ' Icon="' .. abilList[k].Icon .. '"'
        			.. ' MaxLevel="' .. GetClass("Ability_" .. jobEngName, abilList[k].ClassName).MaxLevel .. '"'
        			.. ' UnlockDesc="' .. GetClass("Ability_" .. jobEngName, abilList[k].ClassName).UnlockDesc .. '"'
        			.. ' JobClassID="' .. GetClass("Job", jobCategory[k]).ClassID .. '"'
        			.. endLine;
        
        jobTemp = jobCategory[k];
    end
    
    text = text .. '</Category>\n';
    
    local bottonText = '</Category>';
    
    file:write(headText, text, bottonText);
    io.close(file);
end

function JOB_SKILL_LIST_CLIENT(jobClassName)
    if jobClassName == nil or jobClassName == 0 or jobClassName == "" then
        jobClassName = "ALL";
    end
    
    local classList, classCount = GetClassList("Job");
    if classList == nil or classCount == 0 then
        return;
    end
	
    local skillList = { };
    local skillUnlockClassLevelList = { };
    local skillMaxLevelList = { };
    local jobCategory = { };
    
    for i = 0, classCount - 1 do
        local job = GetClassByIndexFromList(classList, i);
        if job ~= nil then
            if (jobClassName == TryGetProp(job, "ClassName") or jobClassName == "ALL") and 10 >= TryGetProp(job, "Rank") then
                local jobName = TryGetProp(job, "ClassName");
                for j = 1, 99 do
	                local skillTreeClass = GetClass("SkillTree", jobName .. "_" .. j);
	                if skillTreeClass ~= nil then
	                	local skillName = TryGetProp(skillTreeClass, "SkillName");
	                    local skill = GetClass("Skill", skillName);
	                    if skill ~= nil then
                            jobCategory[#jobCategory + 1] = jobName;
                            skillList[#skillList + 1] = skill;
                            skillUnlockClassLevelList[#skillUnlockClassLevelList + 1] = TryGetProp(skillTreeClass, "UnlockClassLevel");
                            skillMaxLevelList[#skillMaxLevelList + 1] = TryGetProp(skillTreeClass, "MaxLevel");
	                    end
	                end
                end
            end
        end
    end
    
    
    
    local file = io.open("C:\\testxml\\JobSkillList_" .. jobClassName .. ".xml", "w");
    if file == nil then
        file = io.open("C:\\JobSkillList_" .. jobClassName .. ".xml", "w");
    end
    
    
    local headText = '<?xml version="1.0" encoding="UTF-8"?>\n<!-- edited with XMLSPY v2004 rel. 2 U (http://www.xmlspy.com) by imc (imc) -->\n    <Category>\n';
    local text = "";
    
    local startLine = '<Class ';
    local endLine = ' />\n';
    
    local jobTemp = nil;
    for k = 1, #skillList do
        if jobTemp == nil then
            text = text .. '<Category Name="' .. GetClass("Job", jobCategory[k]).Name .. '">\n';
        elseif jobCategory[k] ~= jobTemp then
            text = text .. '</Category>\n';
            text = text .. '<Category Name="' .. GetClass("Job", jobCategory[k]).Name .. '">\n';
        end
        
        local jobEngName = GetClass("Job", jobCategory[k]).EngName;
        
        text = text .. startLine
        			.. 'ClassID="' .. skillList[k].ClassID .. '"'
        			.. ' ClassName="' .. skillList[k].ClassName .. '"'
        			.. ' Icon="' .. skillList[k].Icon .. '"'
        			.. ' Name="' .. skillList[k].Name .. '"'
        			.. ' EngName="' .. skillList[k].EngName .. '"'
        			.. ' UnlockClassLevel="' .. skillUnlockClassLevelList[k] .. '"'
        			.. ' MaxLevel="' .. skillMaxLevelList[k] .. '"'
        			.. ' Caption="' .. skillList[k].Caption .. '"'
        			.. ' Job="' .. skillList[k].Job .. '"'
        			.. ' JobClassID="' .. GetClass("Job", jobCategory[k]).ClassID .. '"'
        			.. endLine;
        
        jobTemp = jobCategory[k];
    end
    
    text = text .. '</Category>\n';
    
    local bottonText = '</Category>';
    
    file:write(headText, text, bottonText);
    io.close(file);
end

function TEST_SOUND_EFFECT_FADE_OUT()
    local soundName = "piedpiper_1octave_do";
    local actor = GetMyActor();
    actor:GetEffect():SetSoundFadeOut(soundName);
end


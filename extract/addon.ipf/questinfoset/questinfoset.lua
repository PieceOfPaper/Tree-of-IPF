



function QUESTINFOSET_ON_INIT(addon, frame)	


-- Changed To questinfoset_2

	
	local m1timeObj	= frame:GetChild('m1time');
	local m2timeObj	= frame:GetChild('m2time');
	local s1timeObj	= frame:GetChild('s1time');
	local s2timeObj	= frame:GetChild('s2time');
	QuestInfo_M1Time = tolua.cast(m1timeObj, "ui::CPicture");
	QuestInfo_M2Time = tolua.cast(m2timeObj, "ui::CPicture");
	QuestInfo_S1Time = tolua.cast(s1timeObj, "ui::CPicture");
	QuestInfo_S2Time = tolua.cast(s2timeObj, "ui::CPicture");

end




function QUESTINFOSET_START_ON_MSG(frame, msg, argStr, argNum)

	

		
end

function QUESTINFOSET_NEW_QUEST(frame, msg, argStr, questID)
	
	frame:ShowWindow(1);
	SET_CURRENT_QUESTINFO(questID);

end

function SET_CURRENT_QUESTINFO(questID)

	local questIES = GetClassByType("QuestProgressCheck", questID);
	if questIES == nil then
		session.SetUserConfig("CUR_QUESTSET", 0);
		return;
	end
	
	session.SetUserConfig("CUR_QUESTSET", questID);
	UDT_CURRENT_QUESTSET(questIES);
end



function UDT_CURRENT_QUESTSET(questIES)

	local frame = ui.GetFrame('questinfoset');
	ui.SetQuestName(questIES.Name);
	REMOVE_QUESTSET_INFO();
	
	local pc = GetMyPCObject();
	local result = SCR_QUEST_CHECK_C(pc,questIES.ClassName);

	if result == 'POSSIBLE' and questIES.QuestStartMode ~= 'NPCDIALOG' then
	
	else
    	if IS_SHOW_QUEST_STATE(result) == 0 then
    		ALIGN_QUESTSET_INFO();
    		return;
    	end
	end
	
	frame:ShowWindow(1);
	
	local remaintime = 0;
	local questAutoIES = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
	if questAutoIES ~= nil then
		local s_obj = GetClass("SessionObject", questIES.Quest_SSN);
		if s_obj ~= nil then
			
			local sobjinfo = session.GetSessionObject(s_obj.ClassID);
			if sobjinfo ~= nil then
				remaintime = sobjinfo:GetRemainTime();
			end					
		end		
	end
	
	QUESTINFOSET_TIMER_SET(frame, remaintime);
	QUESTINFOSET_UPDATE_BY_IES(frame, questIES);
	
end



function QUESTINFOSET_UPDATE(frame, msg, argStr, argNum)
	
	local questIES = GetClassByType("QuestProgressCheck", session.GetUserConfig("CUR_QUESTSET", 0));
	if questIES == nil then
		return;
	end
	
	UDT_CURRENT_QUESTSET(questIES);
	
end

function QUESTINFOSET_UPDATE_BY_IES(frame, questIES)

	QUESTINFOSET_UPDATEITEM_BY_IES(frame, questIES);
	
	ALIGN_QUESTSET_INFO();

end

function QUESTINFOSET_UPDATEITEM_BY_IES(frame, questIES)
		
		
	for i = 1 , QUEST_MAX_INVITEM_CHECK do
		local InvItemName = questIES["Succ_InvItemName" .. i];
		local itemclass = GetClass("Item", InvItemName);
		if itemclass ~= nil then
    		local item = session.GetInvItemByName(InvItemName);
    		local itemcount = 0;
    		if item ~= nil then
    			itemcount = item.count;
    		end
    
    		local needcnt = questIES["Succ_InvItemCount" .. i];		
    		if itemcount < needcnt then
    			local itemtxt
    			itemtxt = string.format("%s (%d/%d)", itemclass.Name, itemcount, needcnt);
    --			if needcnt <= 1 then
    --			    itemtxt = itemclass.Name
    --			else
    --    			itemtxt = string.format("%s (%d/%d)", itemclass.Name, itemcount, needcnt);
    --    		end
    			ADD_QUESTSET_INFO(itemtxt);
    		end
    	end
	end	
	
	if questIES.Quest_SSN ~= 'None' then
	    local pc = GetMyPCObject();
        local sObj_quest = GetSessionObject(pc, questIES.Quest_SSN)
        if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
            local itemList = SCR_STRING_CUT(sObj_quest.SSNInvItem, ':')
            local maxCount = math.floor(#itemList/3)
            for i = 1, maxCount do
                local InvItemName = itemList[i*3 - 2]
        		local itemclass = GetClass("Item", InvItemName);
        		if itemclass ~= nil then
            		local item = session.GetInvItemByName(InvItemName);
            		local itemcount = 0;
            		if item ~= nil then
            			itemcount = item.count;
            		end
            		
            		local needcnt = itemList[i*3 - 1]
            		if itemcount < needcnt then
            			local itemtxt
            			itemtxt = string.format("%s (%d/%d)", itemclass.Name, itemcount, needcnt);
            			ADD_QUESTSET_INFO(itemtxt);
            		end
            	end
            end
        end
    end
end

function QUESTINFOSET_END_ON_MSG(frame, msg, argStr, argNum)
	ui.CloseFrame('questinfoset');	
end


function QUESTINFOSET_UPDATE_ON_MSG(frame, msg, argStr, argNum)	

	QUESTINFOSET_UPDATE(frame, msg, argStr, argNum);
	
end

function SET_QUESTINFO_TIME(numMMtime, numSStime)

	SET_QUESTINFO_TIME_TO_PIC(numMMtime, numSStime, QuestInfo_M1Time, QuestInfo_M2Time, QuestInfo_S1Time, QuestInfo_S2Time);
	
end

function QUESTINFOSET_TIMER(frame, msg, argStr, argNum)

	QUESTINFOSET_TIMER_SET(frame, argNum);
	
end

function QUESTINFOSET_TIMER_SET(frame, second)

	local timer = frame:GetChild("addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");
	
	if second == 0 then
		timer:Stop();
		QUESTINFFOSET_USE_TIMER(frame, 0);
		return;
	end	
	
	QUESTINFFOSET_USE_TIMER(frame, 1);
	timer:SetUpdateScript("QUEST_TIME_UPDATE");
	timer:SetArgNum(second);
	timer:Start(1.0);
	
end

function QUEST_TIME_UPDATE(frame, timer, argstr, argnum, passedtime)

	local remainsec = math.ceil(argnum - passedtime);
	local min = math.floor(remainsec / 60);
	local sec = remainsec - min * 60;

	SET_QUESTINFO_TIME(min, sec);
	
end

function REMOVE_QUESTSET_INFO()

	local frame = ui.GetFrame('questinfoset');
	local txt = frame:GetChild("addinfo");
	txt:SetText("");
	QUESTINFOSET_TIMER_SET(frame, 0);

end

function ADD_QUESTSET_INFO(info)

	local frame = ui.GetFrame('questinfoset');
	local txt = frame:GetChild("addinfo");
	local origintexxt = txt:GetText();
	local outtext = "";
	if origintexxt ~= nil then
		outtext = origintexxt .. "{nl}";
	end
	
	outtext = outtext .. info;
	txt:SetText(outtext);

end

function ALIGN_QUESTSET_INFO()

	local frame = ui.GetFrame('questinfoset');
	local timer = frame:GetChild("timer");
	local addtext = frame:GetChild("addinfo");
	
	local usingtimer = timer:IsVisible();
	
	if usingtimer == 1 then
		addtext:SetOffset(addtext:GetOffsetX(), QuestInfo_M2Time:GetOffsetY() + QuestInfo_M2Time:GetImageHeight() + 10);
	else
		addtext:SetOffset(addtext:GetOffsetX(), timer:GetOffsetY());
	end

	local lastmagrin = 30;
	frame:Resize(frame:GetWidth(), addtext:GetOffsetY() + addtext:GetHeight() + lastmagrin);
	
end

function QUESTINFFOSET_USE_TIMER(frame, use)
	
	if use == 0 then
		QuestInfo_M1Time:SetImage("blank");
		QuestInfo_M2Time:SetImage("blank");
		QuestInfo_S1Time:SetImage("blank");
		QuestInfo_S2Time:SetImage("blank");
		
		frame:GetChild("timer"):ShowWindow(0);
	else
		frame:GetChild("timer"):ShowWindow(1);
	end
end



function IS_SHOW_QUEST_STATE(state)
	
	if state == 'PROGRESS' or state == 'SUCCESS' or state == 'COMPLETE' then
		return 1;
	end
	
	return 0;

end







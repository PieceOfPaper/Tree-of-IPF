

function SKILLQUEUE_ON_INIT(addon, frame)

	addon:RegisterMsg("ADD_SKILL_QUEUE", "SKILL_QUEUE_UPDATE_ALL");
	addon:RegisterMsg("UPDATE_SKILL_QUEUE", "SKILL_QUEUE_UPDATE_ALL");

end 

function SKILL_QUEUE_GET_EMPTY_SLOT(frame)
	local slots = GET_CHILD(frame, "slots", "ui::CSlotSet");
	local cnt = slots:GetSlotCount();

	for i = 0 , cnt - 1 do
		local slot = slots:GetSlotByIndex(i);
		if slot:GetUserIValue("SLOT_SET") == 0 then
			return slot;
		end
	end

	return nil;

end

function SKILL_QUEUE_CLEAR_SLOT(slot)
	slot:SetUserValue("SLOT_SET", 0);
	local icon = slot:GetIcon();
	if icon ~= nil then
		slot:ClearIcon();
		slot:SetText('', 'count', 'right', 'bottom', -2, 1);	
	end

	slot:ShowWindow(0);
end

function SKILL_QUEUE_SET_SLOT(slot, iconName, count)
		
	if slot == nil then
		return;
	end

	local icon = CreateIcon(slot);
	icon:SetImage(iconName);
	slot:SetUserValue("SLOT_SET", 1);
	slot:SetText('{s18}{ol}{b}'..count, 'count', 'right', 'bottom', -2, 1);
	slot:ShowWindow(1);	
end

function SKILL_QUEUE_UPDATE_ALL(frame, msg, argstr, argnum)

	local mains = session.GetMainSession();
	if msg == 'UPDATE_SKILL_QUEUE' and argstr == 'PC_ENTER' then
		mains.skillQueues:ClearAllSkillQueue();
	else
		mains.skillQueues:ClearOldSkillQueue();
	end
	
	local slots = GET_CHILD(frame, "slots", "ui::CSlotSet");
	local slotCnt = slots:GetSlotCount();

	for i = 0 , slotCnt - 1 do
		local slot = slots:GetSlotByIndex(i);
		SKILL_QUEUE_CLEAR_SLOT(slot);
	end

	local foresterCnt = 0;
	local widlingCnt = 0;
	local paramuneCnt = 0;

	local cnt =  mains.skillQueues:GetSkillQueueCount();	
	for i = 0 , cnt - 1 do
		local info = mains.skillQueues:GetSkillQueue(i);
		local monRaceType = info:GetMonRaceType();
		if monRaceType == 'Forester' then
			foresterCnt = foresterCnt + 1;
		elseif monRaceType == 'Widling' then
			widlingCnt = widlingCnt + 1;
		elseif monRaceType == 'Paramune' then
			paramuneCnt = paramuneCnt + 1;
		end
	end

	local slotIndex = 0;
	if foresterCnt > 0 then
		local slot = slots:GetSlotByIndex(slotIndex);
		SKILL_QUEUE_SET_SLOT(slot, 'mon_onion', foresterCnt);
		slotIndex = slotIndex + 1;
	end

	if widlingCnt > 0 then
		local slot = slots:GetSlotByIndex(slotIndex);
		SKILL_QUEUE_SET_SLOT(slot, 'mon_poporion_blue', widlingCnt);
		slotIndex = slotIndex + 1;
	end

	if paramuneCnt > 0 then
		local slot = slots:GetSlotByIndex(slotIndex);
		SKILL_QUEUE_SET_SLOT(slot, 'mon_quartz_weaver', paramuneCnt);
		slotIndex = slotIndex + 1;
	end	
end
function STATUS_OVERRIDE_GET_IMGNAME1()
	return "{img 30percent_image %d %d}"
end

function STATUS_OVERRIDE_GET_IMGNAME2()
	return "{img 30percent_image2 %d %d}"
end

function SETEXP_SLOT_ADD_ICON(expupBuffBox, key, expupValue)
    -- info
    local handle = session.GetMyHandle();
    local buffCls = GetClass('Buff', key);
    if buffCls == nil then
        return 0;
    end
    if expupValue == nil then
        local buffExpUp = TryGetProp(buffCls, 'BuffExpUP');
        if buffExpUp == nil then
            expupValue = 0;
        else
            expupValue = math.floor(buffExpUp * 100);
        end
    end

    if expupValue <= 0 then
        return 0;
    end

    -- groupbox
    local numChild = expupBuffBox:GetChildCount();
    local gBox = expupBuffBox:CreateOrGetControl('groupbox', 'expupBox_'..key, 42, 70, ui.LEFT, ui.TOP, 42 * (numChild - 1), 0, 0, 0);
    gBox = tolua.cast(gBox, 'ui::CGroupBox');
    gBox:EnableDrawFrame(0);

    -- slot
    local slot = gBox:CreateOrGetControl('slot', 'slot_'..key, 42, 42, ui.LEFT, ui.TOP, 0, 0, 0, 0);
    slot = tolua.cast(slot, 'ui::CSlot');
    slot:EnableDrop(0);
    slot:EnableDrag(0);

    -- icon
    local icon = CreateIcon(slot);
    icon:SetImage('icon_'..buffCls.Icon);
    if key == "Premium_Nexon" or key =="Premium_Token" then -- premium tooltip
		local buff = info.GetBuff(tonumber(handle), buffCls.ClassID);
		if nil ~= buff then
			icon:SetTooltipType('premium');		
			icon:SetTooltipArg(handle, buffCls.ClassID, buff.arg1);
			icon:SetTooltipOverlap(1);
		end
	else
		icon:SetTooltipType('buff');
		icon:SetTooltipArg(handle, buffCls.ClassID, "");
		icon:SetTooltipOverlap(1);
	end

    -- percent text
    local text = gBox:CreateOrGetControl('richtext', 'text_'..key, 40, 20, ui.CENTER_HORZ, ui.TOP, 0, 45, 0, 0);    
    text:SetFontName('white_18_ol');
    
    if buffCls.ClassName == 'Premium_Token' then
        expupValue = expupValue + 10
        text:SetText('{s13}'.. expupValue ..'%{/}');
    else
        text:SetText('{s13}'.. expupValue ..'%{/}');
    end

    gBox:ShowWindow(1);

    return expupValue;
end

function STATUS_HIDDEN_JOB_UNLOCK_VIEW(pc, opc, frame, gboxctrl, y)
    local jobList, jobListCnt = GetClassList('Job');
    local etcObj = GetMyEtcObject();
   	for i = 0, jobListCnt-1 do
		local jobIES = GetClassByIndexFromList(jobList, i);
		if jobIES ~= nil then
		    if jobIES.HiddenJob == 'YES' then
		        local flag = false
		        if jobIES.ClassName == 'Char4_12' then
		            local jobCircle = session.GetJobGrade(GetClassNumber('Job','Char4_2','ClassID'))
		            if jobCircle >= 3 then
		                flag = true
		            end
		        else
		            flag = true
		        end
		        if flag == true and ( etcObj["HiddenJob_"..jobIES.ClassName] == 300 or IS_KOR_TEST_SERVER()) then
                    local hidden_job = gboxctrl:CreateControl('richtext', 'HIDDEN_JOB_'..jobIES.ClassName, 10, y, 100, 25);
                    hidden_job:SetText('{@sti8}'..ScpArgMsg("HIDDEN_JOB_UNLOCK_VIEW_MSG1","JOBNAME",jobIES.EngName))
                    y = y + 25
                end
		    end
		end
	end
    return y
end
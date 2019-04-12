
function STATUS_OVERRIDE_NEWCONTROLSET1(tokenList)
	local ctrlSet = tokenList:CreateControlSet("tokenDetail", "CTRLSET_" .. 9,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img 1plus_image %d %d}", 55, 45) 
    prop:SetTextByKey("value", imag..ClMsg("Moreindunmission")); 
    local value = ctrlSet:GetChild("value");
    value:ShowWindow(0);
end

function STATUS_OVERRIDE_GET_IMGNAME1()
	return "{img 30percent_image %d %d}"
end

function STATUS_OVERRIDE_GET_IMGNAME2()
	return "{img 30percent_image2 %d %d}"
end

function SETEXP_SLOT(gbox)
	local expupBuffBox = gbox:GetChild('expupBuffBox');	
	DESTROY_CHILD_BYNAME(expupBuffBox, "expBuffslot_");			--EXP_Rate
	
	-- s_buff_ui : cf) buff.lua 
	local slotlist = s_buff_ui["slotlist"][1];
	local slotcount = s_buff_ui["slotcount"][1];
	local captionlist = s_buff_ui["captionlist"][1];
    
	local index = 0;
	local percSum = 0;
	
	if IS_SEASON_SERVER(nil) == "YES" then
		local cls1 = GetClass("SharedConst","JAEDDURY_MON_EXP_RATE");
		local val1 = cls1.Value;
	if val1 ~= nil then
	if val1 > 0.0 then
		local class  = GetClassByType('Buff', 4540);	
		percSum = SETSLOTCTRL_EXP(class, class.Icon, expupBuffBox, index, percSum, val1 * 100);
		index = index + 1;
		end
	end
	end

	if 1 == session.loginInfo.GetPremiumState() then	
	local cls2 = GetClass("SharedConst","JAEDDURY_NEXON_PC_EXP_RATE");
local val2 = cls2.Value;	
		if val2 ~= nil then
	if val2 > 0.0 then
		local class  = GetClassByType('Buff', 4541);	
		percSum = SETSLOTCTRL_EXP(class, class.Icon, expupBuffBox, index, percSum, val2 * 100);
		index = index + 1;
			end
	end
	end
	
	--?¼반 ??티 경험췿계산
	local retParty = false;
	local partyMember, addValue1 =	GET_ONLINE_PARTY_MEMBER_N_ADDEXP();	
	SWITCH(math.floor(partyMember)) {				
		[0] = function() end,
		[1] = function() end,	
		[4] = function() -- 4??260 -> 280
			local addValue2 = 0;
			local cls = GetClass("SharedConst","PARTY_EXP_BONUS_MEMBER_COUNT_FOUR");
			local val = cls.Value;	
			if val ~= nil then
				addValue2 = val;
			end	
			retParty, percSum = SETEXP_SLOT_PARTY(expupBuffBox, addValue2 + addValue1, index, percSum);
		end,
		[5] = function() -- 5??300 -> 350
			local addValue2 = 0;
			local cls = GetClass("SharedConst","PARTY_EXP_BONUS_MEMBER_COUNT_FIVE");
			local val = cls.Value;	
			if val ~= nil then
				addValue2 = val;
			end	
			retParty, percSum = SETEXP_SLOT_PARTY(expupBuffBox, addValue2 + addValue1, index, percSum);
		end,
		default = function() --		1??100. 2??180, 3??220
			retParty, percSum = SETEXP_SLOT_PARTY(expupBuffBox, addValue1, index, percSum);
		end,
		}	
	if retParty == true then
		index = index + 1;
	end
	if slotcount ~= nil and slotcount >= 0 then
    	for i = 0, slotcount - 1 do
    		local slot		= slotlist[i];
			local icon		= slot:GetIcon();
			local info		= icon:GetInfo();
			local type		= info.type;
			if type ~= 0 then
				local class  = GetClassByType('Buff', type);	
				if class ~= nil then
					local exp = TryGetProp(class, "BuffExpUP");
					if nil == exp then
						exp = 0;
					else
						exp = tonumber(exp);
						if config.GetServiceNation() == 'GLOBAL' and type == 70002 then 
							exp = exp + 0.1;
						end;						
					end

					if exp > 0.0 then
						percSum = SETSLOTCTRL_EXP(class, class.Icon, expupBuffBox, index, percSum, exp * 100);
						index = index + 1;					
					else
						SWITCH(class.ClassName) {				
						['TeamLevel'] = function() 
							local account = session.barrack.GetCurrentAccount();
							if account ~= nil then
								local lv = account:GetTeamLevel();
									local expT = account:GetTeamLevel() - 1;
									if expT > 0.0 then
										percSum = SETSLOTCTRL_EXP(class, "teamexpup", expupBuffBox, index, percSum, expT);
										index = index + 1;
									end
								end	
						end,
						['PartyIndunExpBuff'] = function() 
										local cls = GetClass("SharedConst","INDUN_AUTO_FIND_EXP_BONUS");
										local val = cls.Value;
										if val > 0.0 then
											if partyMember > 1 then
												percSum = SETSLOTCTRL_EXP(class, "cler_daino", expupBuffBox, index, percSum, val * 100 * partyMember);
										index = index + 1;
											end
										end
						end,
						default = function() end,
						}	
					end
				end
			end
    	end
    end
			
	local expupTextBox = gbox:GetChild('expupTextBox');	
	local expUP_Dyn = expupTextBox:GetChild('expUP_Dyn');	
		
	expUP_Dyn:SetTextByKey("perc", math.floor(percSum));
	
	expupTextBox:Invalidate();	
end
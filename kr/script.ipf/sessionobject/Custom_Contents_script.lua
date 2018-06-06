
---- SetPos with fade-out/in
-- self : ALL
-- _x, _y, _z : Arrival pos
-- _jump : Arrival pos + _y
function SCR_SETPOS_FADEOUT(self, _zone, _x, _y, _z, _jump, _warp_ani)
    RunScript('SCR_SETPOS_FADEOUT_RUN', self, _zone, _x, _y, _z, _jump, _warp_ani)
end

function SCR_SETPOS_FADEOUT_RUN(self, _zone, _x, _y, _z, _jump, _warp_ani)
    if self ~= nil then
        if _zone ~= nil then
            if _zone == GetZoneName(self) then
                if _jump == nil then
                    _jump = 0;
                end
                
                if _warp_ani == 1 then
--                    EnableControl(self, 0);
                    AddBuff(self, self, 'QUEST_HOLD_MOVE_BUFF', 1, 0, 1500, 1)
                    PlayAnim(self, 'WARP')
                    sleep(1000)
                end
                
                UIOpenToPC(self,'fullblack',1)
                sleep(500)
                if self ~= nil then
                    SetPos(self, _x, _y+_jump, _z)
                    UIOpenToPC(self,'fullblack',0)
                    PlayAnim(self, 'STD')
                    if _warp_ani == 1 then
--                        EnableControl(self, 1);
                        RemoveBuff(self, 'QUEST_HOLD_MOVE_BUFF')
                    end
                end
            end
        end
    end
end



---- SetPos 'Same Layer PC' with fade-out/in
-- self : ALL (Main PC)
function SCR_SAME_LAYER_SETPOS_FADEOUT(self, distance, range)
    RunScript('SCR_SAME_LAYER_SETPOS_FADEOUT_RUN', self, distance, range)
end

function SCR_SAME_LAYER_SETPOS_FADEOUT_RUN(self, distance, range)
    if distance == nil then
        distance = -30;
    end
    
    if range == nil or range < 1 then
        range = 1;
    end
    
    if self ~= nil then
        local zoneID = GetZoneInstID(self)
        local PC_layer = GetLayer(self)
        local list, cnt = GetLayerPCList(zoneID, PC_layer);
        if cnt >= 1 then
            local x, y, z = GetFrontPos(self, distance)
            local i;
            for i = 1, cnt do
                if IsSameObject(self, list[i]) == 0 then
                    UIOpenToPC(list[i],'fullblack',1)
                    sleep(500)
                    if list[i] ~= nil then
                        SetPos(list[i], x+IMCRandom(-range, range), y+5, z+IMCRandom(-range, range))
                        UIOpenToPC(list[i],'fullblack',0)
                    end
                end
            end
        end
    end
end



---- Stop control for the time of MoveEx
-- pc : Only PC
-- argObj : LookAt NPC
-- x, y, z : Arrival pos
-- BreakTime : Functuon Break Time(sec), Prevent infinite loops
function SCR_MOVEEX_HOLD(pc, argObj, x, y, z, BreakTime)
--    RunScript('SCR_MOVEEX_HOLD_RUN', pc, argObj, x, y, z, BreakTime)
    RunScript('SCR_MOVEEX_HOLD_RUN_TEMP', pc, argObj, x, y, z, BreakTime)
end

function SCR_MOVEEX_HOLD_RUN(pc, argObj, x, y, z, BreakTime)

    if IsMoving(pc) == 0 then
        if BreakTime == nil then
            local BreakTime = 5;
        end
    
        EnableControl(pc, 0, "MOVEEX_HOLD_RUN");
        MoveEx(pc, x, y, z, 1)
        local moveTime = 1;
        while 1 do
            if moveTime >= BreakTime*5 then
                break;
            end
            
            sleep(200)
            if pc == nil then
                return 0;
            end
            
            if IsMoving(pc) == 0 then
                break;
            end
            moveTime = moveTime+1;
        end
        
        if argObj ~= nil then
            LookAt(pc, argObj);
            sleep(200);
            if pc == nil then
                return 0;
            end
        end
        
        EnableControl(pc, 1, "MOVEEX_HOLD_RUN");
    end
end

function SCR_MOVEEX_HOLD_RUN_TEMP(pc, argObj, x, y, z, BreakTime)
    if pc ~= nil and argObj ~= nil then
        if GetZoneName(pc) == GetZoneName(argObj) then
            SetPos(pc, x, y+5, z);
        end
    end
end



---- Rotation to the target angle
-- self : Only NPC
-- angle : Target angle(0 ~ 360 or -180 ~ 180)
-- angle2 : Angle of rotation at a time
-- ccw : Turn wise, if ccw = 1 turns in a counterclockwise, Unless turns in a clockwise
-- BreakTime : Functuon Break Time(sec), Prevent infinite loops
function SCR_ROTATE_HOLD(self, angle, angle2, ccw, BreakTime)

    local Gen_Dialog = self.Dialog
    self.Dialog = 'None'

    if BreakTime == nil then
        BreakTime = 10;
    end
    
    if angle < 0 then
        angle = 360 + angle
    end
    
    if angle == 360 then
        angle = 0;
    end
    
    local now_angle = math.floor(GetDirectionByAngle(self))
    if now_angle < 0 then
        now_angle = 360 + now_angle
    end

    if angle2 == nil or angle2 <= 0 then
        angle2 = 5;
    end
    
    if ccw == nil then
        ccw = 0;
    end
    
    local rest_angle = angle % angle2;
    if rest_angle ~= 0 then
        angle = angle + (angle2 - rest_angle)
    end
    
    local rest_now_angle = now_angle % angle2;
    if rest_now_angle ~= 0 then
        now_angle = now_angle + (angle2 - rest_now_angle)
    end

    local rotateTime = 1;

    while 1 do
        if self ~= nil then
            if ccw == 1 then
                now_angle = now_angle + angle2;
            else
                now_angle = now_angle - angle2;
            end
            
            if now_angle >= 360 then
                now_angle = 0;
            end
            
            SetDirectionByAngle(self, now_angle)
            
            if rotateTime >= BreakTime*10 then
                break;
            end
            
            sleep(100)
            if now_angle == angle then
                break;
            end
            rotateTime = rotateTime+1;
        end
    end
    
    self.Dialog = Gen_Dialog
    
end



---- Donut chaped random pos return
-- x, z : Base pos
-- in_limit : Minimum Distance
-- out_limit : Maximun Distance
function SCR_DOUGHNUT_RANDOM_POS(x, z, in_limit, out_limit)
    
    if in_limit > out_limit then
        in_limit = out_limit;
    end
    
    local doughnut_pos = {}
    local lim_switch = IMCRandom(0, 1)
    doughnut_pos['x'] = x + (IMCRandom(lim_switch*in_limit, out_limit) * math.cos(math.pi*IMCRandom(0, 1)))
    doughnut_pos['z'] = z + (IMCRandom(math.abs(lim_switch-1)*in_limit, out_limit) * math.cos(math.pi*IMCRandom(0, 1)))
    
    return doughnut_pos;
end



---- Only once per day check
-- pc : Only PC
-- Prop_Name : Session Property Name (\data\xml\sessionobject_request.xml)
function SCR_SSN_MAIN_DAY_CHECK(pc, Prop_Name)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local yday = now_time['yday']
    local wday = now_time['wday']
    local day = now_time['day']
    local hour = now_time['hour']
    
    if month < 10 then
        month = "0"..month;
    end
    if day < 10 then
        day = "0"..day;
    end
    
    local all_date = tostring(year..month..day)
    
    local sObj = GetSessionObject(pc, 'SSN_REQUEST');
--    local Prop_Name = 'STARTOWER_60_1_DAILY_01'
    
    if sObj ~= nil then
        if sObj[Prop_Name] ~= nil then
            if sObj[Prop_Name] ~= all_date then
                local tx = TxBegin(pc);
                TxSetIESProp(tx, sObj, Prop_Name, all_date);
        	    local ret = TxCommit(tx, 1);
            	
            	if ret == 'FAIL' then
        	        print(Prop_Name, 'SCR_SSN_MAIN_DAY_CHEACK Transaction FAIL')
            	else
            	    return 'YES';
            	end
            else
                return 'NO';
            end
        else
            print(Prop_Name, 'SCR_SSN_MAIN_DAY_CHEACK is nil')
        end
	end
end



---- Give PC the book item
-- self : Interaction NPC
-- pc : Only PC
-- item : Book item
-- hide : Hide Status, if hide == 1 NPC hide
function SCR_BOOK_GET(self, pc, item, hide)
    if hide == nil then
        hide = 0;
    end
    
    if item ~= nil then
    
        local itemCnt = GetInvItemCount(pc, item)
        if itemCnt == 0 then
            local tx1 = TxBegin(pc);
            TxGiveItem(tx1, item, 1, "QuestBook");
            local ret = TxCommit(tx1);
    
            
           	if ret == 'FAIL' then
           	    print('SCR_BOOK_GET TX FAIL!')
           	else
           	    if hide == 1 then
           	        if self.Dialog ~= 'None' then
               	        HideNPC(pc, self.Dialog)
               	    elseif self.Enter ~= 'None' then
               	        HideNPC(pc, self.Enter)
               	    else
               	        print('NPC Hide FAIL : DIALOG and ENTER is None')
               	    end
           	    end
           	end
        end
    else
        print('ITEM is nil!!')
    end
    
    return
end



---- Follow NPC that looks to the PC only
-- mon : Follow NPC
-- pc : Only PC
-- quest_ClassName : Quest ClassName
-- kill_timming : if Quest Staus = kill_timming to kill the Follow NPC
-- isOwnersdead : if PC die, Follow NPC kill (if isOwnersdead == 1, Follow NPC do not kill)
function SET_NPC_BELONGS_TO_PC_LOCAL(mon, pc, quest_ClassName, kill_timming, isOwnersdead)
	SetBroadcastOwner(mon);
	if isOwnersdead == 0 or isOwnersdead == nil then
    	SetOwner(mon, pc, 1);
    elseif isOwnersdead == 1 then
        SetOwner(mon, pc, 0);
    end
	AddVisiblePC(mon, pc, 1);
	SetLayerChangeScp(pc, "CHANGE_FOL_NPC_LAYER");
	SetWarpScp(pc, "BELONGS_NPC_SETPOS");	
	AddScpObjectList(pc, "BELONGED_NPC", mon);
	if kill_timming ~= nil then
	    mon.NumArg4 = kill_timming
    end
	if quest_ClassName ~= nil then
	    mon.StrArg2 = quest_ClassName
	end
end



---- Angle value Conversion (-180 ~ 180 to 0 ~ 360)
-- val : Angle value
function SCR_TRANS_ANGLE_TO_360(val)
    if val < 0 then
        val = 360 + val
    end
    
    return val;
end



-- Check the back
-- self : ALL
-- target : ALL (self check whether the back of the target)
-- angle : Back angle Range (2 ~ 358)
function SCR_IS_BACK_CHECK(self, target, angle)
    if angle > 358 then
        angle = 358;
    elseif angle < 2 then
        angle = 2;
    end
    
    angle = math.floor(angle) / 2;
    
    local target_angle = math.floor(GetDirectionByAngle(target));
    local low_angle = SCR_TRANS_ANGLE_TO_360(target_angle - angle);
    local high_angle = SCR_TRANS_ANGLE_TO_360(target_angle + angle);
    local to_angle = SCR_TRANS_ANGLE_TO_360(math.floor(GetAngleTo(self, target)));
    
    if to_angle < angle then
        to_angle = to_angle + 360;
    end
    
    if low_angle > high_angle then
        high_angle = high_angle + 360;
    end
    
    if to_angle >= low_angle and to_angle <= high_angle then
        return 'YES';
    else
        return 'NO';
    end

end



-- Check Any way
-- self : ALL
-- target : ALL (self check whether the any way of the target)
function SCR_4WAY_SIDE_CHECK(self, target, _corr)
    if _corr == nil then
        _corr = 0;
    end
    
    local target_angle = math.floor(GetDirectionByAngle(target) + _corr);
    local low_angle = SCR_TRANS_ANGLE_TO_360(target_angle - 45);
    local high_angle = SCR_TRANS_ANGLE_TO_360(target_angle + 45);
    local back_angle = SCR_TRANS_ANGLE_TO_360(math.floor(GetAngleTo(self, target)));
    local front_angle = SCR_TRANS_ANGLE_TO_360(math.floor(GetAngleTo(target, self)));
    
    if back_angle < 45 then
        back_angle = back_angle + 360;
    end
    
    if front_angle < 45 then
        front_angle = front_angle + 360;
    end
    
    if low_angle > high_angle then
        high_angle = high_angle + 360;
    end
    
    if back_angle >= low_angle and back_angle <= high_angle then
        return 'BACK';
    elseif front_angle >= low_angle and front_angle <= high_angle then
        return 'FRONT';
    elseif (front_angle > high_angle and back_angle < low_angle) or (front_angle > high_angle and front_angle < back_angle) or (front_angle < low_angle and back_angle < low_angle and front_angle < back_angle) then
        return 'LEFT';
    elseif (back_angle > high_angle and front_angle < low_angle) or (back_angle > high_angle and front_angle > back_angle) or (back_angle < low_angle and front_angle < low_angle and front_angle > back_angle) then
        return 'RIGHT';
    else
        print('ERR!! '..front_angle..' '..back_angle..' '..low_angle..' '..high_angle)
    end
end



---- Unlock hidden job (Change ETCObject of PC to 300)
-- pc : Only PC
-- job_classname : Classname in job.xml (Ex : Char1_13)
function SCR_HIDDEN_JOB_UNLOCK(pc, job_classname)
    if IS_PC(pc) == true then
        local classlist, class_cnt = GetClassList("Job")
        local selct_classlist = GetClassByNameFromList(classlist, job_classname)
        if selct_classlist ~= nil then
            if selct_classlist.HiddenJob == "YES" then
                local etc = GetETCObject(pc);
                if etc["HiddenJob_"..job_classname] ~= 300 then
                    local tx = TxBegin(pc);
                    TxSetIESProp(tx, etc, "HiddenJob_"..job_classname, 300);
                    local ret = TxCommit(tx);
                    if ret == "SUCCESS" then
                        return "SUCCESS"
                    else
                        print("tx FAIL!")
                    end
                else
                    print('The value of '..job_classname..' is already 300')
                    return "SUCCESS"
                end
            else
                print(job_classname.." is Not Hiddenjob")
            end
        else
            print(job_classname.." is nil value")
        end
    end
    return "FAIL"
end



---- Hidden job check that is Unlock (Change ETCObject of PC to 300)
-- pc : Only PC
-- job_classname : Classname in job.xml (Ex : Char1_13)
function SCR_HIDDEN_JOB_IS_UNLOCK(pc, job_classname)
    if IS_PC(pc) == true then
        local classlist, class_cnt = GetClassList("Job")
        local selct_classlist = GetClassByNameFromList(classlist, job_classname)
        if selct_classlist ~= nil then
            if selct_classlist.HiddenJob == "YES" then
                local etc = GetETCObject(pc);
                if etc["HiddenJob_"..job_classname] == 300 then
                    return "YES"
                else
                    return "NO"
                end
            else
                print(job_classname.." is Not Hiddenjob")
            end
        else
            print(job_classname.." is nil value")
        end
    end
    return "FAIL"
end



---- Change hidden job ETCObject value
-- pc : Only PC
-- job_classname : Classname in job.xml (Ex : Char1_13)
-- value : 0 ~ 299
function SCR_SET_HIDDEN_JOB_PROP(pc, job_classname, num)
    if IS_PC(pc) == true then
        if num >= 0 and num < 300 then
            local classlist, class_cnt = GetClassList("Job")
            local selct_classlist = GetClassByNameFromList(classlist, job_classname)
            if selct_classlist ~= nil then
                if selct_classlist.HiddenJob == "YES" then
                    local etc = GetETCObject(pc);
                    if etc["HiddenJob_"..job_classname] ~= num then
                        local tx = TxBegin(pc);
                        TxSetIESProp(tx, etc, "HiddenJob_"..job_classname, num);
                        local ret = TxCommit(tx);
                        if ret == "SUCCESS" then
                            return "SUCCESS"
                        else
                            print("tx FAIL!")
                        end
                    else
                        --print("The value of "..job_classname.." is already the same value")
                        return "SUCCESS"
                    end
                else
                    print(job_classname.." is Not Hiddenjob")
                end
            else
                print(job_classname.." is nil value")
            end
        else
            print("The prop value can be entered only between 0-300! Input value : "..num)
        end
    end
    return "FAIL"
end



---- Check hidden job ETCObject value
-- pc : Only PC
-- job_classname : Classname in job.xml (Ex : Char1_13)
function SCR_GET_HIDDEN_JOB_PROP(pc, job_classname)
    if IS_KOR_TEST_SERVER() then
        return 0
    end
    if IS_PC(pc) == true then
        local classlist, class_cnt = GetClassList("Job")
        local selct_classlist = GetClassByNameFromList(classlist, job_classname)
        if selct_classlist ~= nil then
            if selct_classlist.HiddenJob == "YES" then
                local etc = GetETCObject(pc);
                return etc["HiddenJob_"..job_classname];
            else
                print(job_classname.." is Not Hiddenjob")
            end
        else
            print(job_classname.." is nil value")
        end
    end
    return "FAIL"
end



---- Check that reward is duplicated
-- self : Only NPC or Monster
-- pc : Only PC
-- limit : Maximum reward number
-- id_type : CID or AID (id_type == AID, use PC Account ID), (else use PC Charactor ID)
function SCR_DUPLICATE_REWARD_CHECK(self, pc, limit, id_type)
    if limit == nil or limit == 'None' then
        limit = 50;
    elseif limit > 50 or limit <= 0 then
        print("ERR!! pc count limit must be between 0~50")
        return "FAIL"
    end
    
    local sObj = GetSessionObject(self, 'SSN_REWARD_CHECK');
    if sObj == nil then
        CreateSessionObject(self, 'SSN_REWARD_CHECK', 1)
        sObj = GetSessionObject(self, 'SSN_REWARD_CHECK');
    end
    
    if sObj ~= nil then
        if IS_PC(pc) == true then
            local pc_id = GetPcCIDStr(pc)
            if id_type == 'AID' or id_type == 'aid' then
                pc_id = GetPcAIDStr(pc)
            end
            
            for i = 1, limit do
                if tostring(sObj['StrArg'..i]) == tostring(pc_id) then
                    return "NO", i;
                elseif sObj['StrArg'..i] == nil or sObj['StrArg'..i] == 'None' then
                    return "YES", i;
                end
            end
            if sObj['StrArg'..limit] ~= nil and sObj['StrArg'..limit] ~= 'None' then
                return "OVER", limit;
            end
        end
    end
    return "FAIL"
end



---- Check and Count that reward is duplicated
-- self : Only NPC or Monster
-- pc : Only PC
-- limit : Maximum reward number
function SCR_DUPLICATE_REWARD_COUNTING(self, pc, limit, id_type)
    if limit == nil or limit == 'None' then
        limit = 50;
    elseif limit > 50 or limit <= 0 then
        print("ERR!! pc count limit must be between 0~50")
        return "FAIL"
    end
    
    local sObj = GetSessionObject(self, 'SSN_REWARD_CHECK');
    if sObj == nil then
        CreateSessionObject(self, 'SSN_REWARD_CHECK', 1)
        sObj = GetSessionObject(self, 'SSN_REWARD_CHECK');
    end
    
    if sObj ~= nil then
        if IS_PC(pc) == true then
            local pc_id = GetPcCIDStr(pc)
            if id_type == 'AID' or id_type == 'aid' then
                pc_id = GetPcAIDStr(pc)
            end
            
            for i = 1, limit do
                if tostring(sObj['StrArg'..i]) == tostring(pc_id) then
                    return "NO", i;
                elseif sObj['StrArg'..i] == nil or sObj['StrArg'..i] == 'None' then
                    sObj['StrArg'..i] = tostring(pc_id);
                    return "YES", i;
                end
            end
            if sObj['StrArg'..limit] ~= nil and sObj['StrArg'..limit] ~= 'None' then
                return "OVER", limit;
            end
        end
    end
    return "FAIL"
end



---- Random Number Arrange
-- low_num : Low number
-- high_num : Hight number
-- num : Return value count
function SCR_RANDOM_NUMBERS(low_num, high_num, num)
    if low_num ~= nil and high_num ~= nil then
        if low_num < high_num then
            if num <= (high_num - low_num + 1) then
                if num == nil then
                    num = 1;
                end
                
                local i;
                local num_arr = {};
                for i = 1, (high_num - low_num + 1) do
                    num_arr[i] = low_num + (i - 1);
                end
                
                local j;
                local num_arr2 = {};
                local temp_num;
                local rnd;
                for j = 1, num do
                    rnd = IMCRandom(j, #num_arr);
                    if rnd ~= j then
                        temp_num = num_arr[j];
                        num_arr[j] = num_arr[rnd];
                        num_arr[rnd] = temp_num;
                    end
                    num_arr2[j] = num_arr[j];
                end
                
                return num_arr2;
            else
                print('ERR!! num is too large value')
            end
        else
            print('ERR!! low_num is higher than high_num')
        end
    else
        print('ERR!! Low Number or High number is nil')
    end
    return "FAIL"
end



---- Random Arrange
-- arr_val : Only Arrange Value
function SCR_RANDOM_ARRANGE(arr_val)
    if arr_val ~= nil then
        if type(arr_val) == 'table' then
            local i;
            local temp_arr;
            local rnd;
            for i = 1, #arr_val do
                rnd = IMCRandom(i, #arr_val);
                if rnd ~= i then
                    temp_arr = arr_val[i];
                    arr_val[i] = arr_val[rnd];
                    arr_val[rnd] = temp_arr;
                end
            end
            
            return arr_val;
        else
            print('ERR!! arr_val is not Arrange Value')
        end
    else
        print('ERR!! arr_val is nil')
    end
    return "FAIL"
end



---- Get party list and place pc to arrange[1]
-- pc : Only PC
-- range : Search range
function GET_PARTY_ACTOR_QUEST(pc, range)
    if range == nil then
        range = 0;
    end
    
    if pc.ClassName == 'PC' then
    	local list, cnt = GetPartyMemberList(pc, PARTY_NORMAL, range);
    	if cnt == 0 then
    		list = {};
    		list[1] = pc;
    		return list, 1;
        elseif cnt >= 2 then
            if IsSameActor(pc, list[1]) == 'NO' then
            	local i
            	for i = 1, cnt - 1 do
            	    if IsSameActor(pc, list[cnt - (i - 1)]) == 'YES' then
            	        local _temp
            	        _temp = list[cnt - (i - 1)];
            	        list[cnt - (i - 1)] = list[cnt - i];
            	        list[cnt - i] = _temp;
            	    end
            	end
            end
        end
    	return list, cnt;
    else
        print('ERR!! pc value must always be PC')
    end
    return "FAIL"
end



---- Repeat RunScript by PartyMemberList
-- _func : RunScript Function
-- pc_val : What is number in PC(Base pc of the party) value? (EX : Dialog function is '2', ssession function is '1')
function SCR_RUNSCRIPT_PARTY(_func, pc_val, ...)
    if pc_val == nil or pc_val <= 0 then
        pc_val = 1;
    end
    local _parameter = {...};
    if _parameter[pc_val].ClassName == 'PC' then
        if _func ~= nil then
            local P_list, P_cnt = GET_PARTY_ACTOR_QUEST(_parameter[pc_val])
            local p
            if P_cnt >= 1 then
                for p = 1, P_cnt do
                _parameter[pc_val] = P_list[p];
                    RunScript(_func, unpack(_parameter))
                end
                return "SUCCESS"
            end
        else
            print('ERR!! _func is nil')
        end
    else
        print('ERR!! The second value must always be PC')
    end
    return "FAIL"
end



---- Repeat Script by PartyMemberList
-- _func : Script Function
-- pc_val : What is number in PC(Base pc of the party) value? (EX : Dialog function is '2', ssession function is '1')
function SCR_SCRIPT_PARTY(_func, pc_val, ...)
    if pc_val == nil or pc_val <= 0 then
        pc_val = 1;
    end
    local _parameter = {...};
    if _parameter[pc_val].ClassName == 'PC' then
        if _func ~= nil then
            local P_list, P_cnt = GET_PARTY_ACTOR_QUEST(_parameter[pc_val])
            local p
            if P_cnt >= 1 then
                for p = 1, P_cnt do
                _parameter[pc_val] = P_list[p];
                    _G[_func](unpack(_parameter))
                end
                return "SUCCESS"
            end
        else
            print('ERR!! _func is nil')
        end
    else
        print('ERR!! The second value must always be PC')
    end
    return "FAIL"
end



---- Repeat SendAddOnMsg by PartyMemberList
-- pc : Only PC
-- _msg : ClassName of clientmessage
-- _addon : Addon Marker (Ex : NOTICE_Dm_scroll, NOTICE_Dm_!, NOTICE_Dm_Clear...), Default 'NOTICE_Dm_scroll'
-- _time : Time duration (sec), Default '7'
-- ... : Quest1 ClassName/STATE1/STATE2..3..4, Quest2 ClassName/STATE1/STATE2..3..4
-- Ex1 : SCR_SEND_ADDON_MSG_PARTY(pc, ScpArgMsg("PRISON_78_MQ_3_MSG3"), 'NOTICE_Dm_GetItem', 5, 'PRISON_78_MQ_3/PROGRESS')
-- Ex2 : SCR_SEND_ADDON_MSG_PARTY(self, ScpArgMsg("PRISON_82_SQ_1_MSG2", "COUNT", 55), nil, nil, 'SIAULIAI_46_2_MQ_02/PROGRESS/SUCCESS', 'SIAULIAI_46_2_SQ_01/COMPLETE')
function SCR_SEND_ADDON_MSG_PARTY(pc, _msg, _addon, _time, ...)
    if pc ~= nil then
        if pc.ClassName == 'PC' then
            local _parameter = {...};
            if _msg ~= nil then
                if _addon == nil then
                    _addon = 'NOTICE_Dm_scroll';
                end
                
                if _time == nil then
                    _time = 7;
                end
                
                local P_list, P_cnt = GET_PARTY_ACTOR_QUEST(pc)
                local p
                if P_cnt >= 1 then
                    for p = 1, P_cnt do
                        if #_parameter >= 1 then
                            local _break = 'CONTINUE';
                            local i;
                            for i = 1, #_parameter do
                                local string_cut_list = SCR_STRING_CUT(_parameter[i])
                                local j;
                                for j = 2, #string_cut_list do
                                    if SCR_QUEST_CHECK(P_list[p], string_cut_list[1]) == string_cut_list[j] then
                                        SendAddOnMsg(P_list[p], _addon, _msg, _time);
                                        _break = 'BREAK';
                                        break;
                                    end
                                end
                                
                                if _break == 'BREAK' then
                                    break
                                end
                            end
                        else
                            SendAddOnMsg(P_list[p], _addon, _msg, _time);
                        end
                    end
                    return "SUCCESS"
                end
            else
                print('ERR!! _msg is nil')
            end
        else
            print('ERR!! pc val is not PC')
        end
    end
    return "FAIL"
end



function IS_REAL_PC(actor)
    if IsOOBEDummyPC(actor) == 1 then
        return 'NO';
    end
    
    if IsDummyPC(actor) == 1 then
        return 'NO';
    end
    
    if actor.ClassName == 'PC' then
        return 'YES';
    end
    
    return 'NO';
end



----QUEST NPC HIDE AND CREATE FOLLOW NPC
--NPC_ClassName = Quest NPC's Dialog or Enter Name
--Q_Name = Quest Name
--map_ID = Quest Playing Field(ex: f_siauliai_west)
--Mon_ClassName = Follow NPC's Model ClassName
--CreateFaction = Follow NPC's Faction
--Mon_Setting = Follow NPC's Setting Function(ex: mon.SimpleAI = ???, mon.Name = ???...)
--Mon_Lv = Follow NPC's Level(if you Skip this, it will set same level as PC's level)
--Mon_Session = Follow NPC's Session Object Name(Skip Possible)
function SCR_HIDE_AND_FOLLOWNPC(self, NPC_ClassName, Q_Name, map_ID, x, y, z, ScpObjectName, Mon_ClassName, CreateFaction, Mon_Setting, Hittable, Mon_Lv, Mon_Session, NoDamage)
    if isHideNPC(self, NPC_ClassName) == 'NO' then
        HideNPC(self, NPC_ClassName)
    end
    if GetZoneName(self) == map_ID then
        sleep(500)
        local follower = GetScpObjectList(self, ScpObjectName)
        if #follower == 0 then
            if Mon_Lv == nil or Mon_Lv == 0 then
                local mon = CREATE_MONSTER_EX(self, Mon_ClassName, x, y, z, 0, CreateFaction, self.Lv, Mon_Setting)
                SET_NPC_BELONGS_TO_PC_LOCAL(mon, self, Q_Name, 0)
                AddScpObjectList(self, ScpObjectName, mon)
                EnableAIOutOfPC(mon)
                if Mon_Session ~= nil then
                    local mon_ssn = GetSessionObject(mon, Mon_Session)
                    if mon_ssn == nil then
                        CreateSessionObject(mon, Mon_Session)
                    end
                end
                if Hittable ~= nil and Hittable == 1 then
                    SetHittable(mon, 1)
                end
                if NoDamage ~= nil and NoDamage == 1 then
                    SetNoDamage(mon, 1)
                end
            else
                local mon = CREATE_MONSTER_EX(self, Mon_ClassName, x, y, z, 0, CreateFaction, Mon_Lv, Mon_Setting)
                SET_NPC_BELONGS_TO_PC_LOCAL(mon, self, Q_Name, 0)
                AddScpObjectList(self, ScpObjectName, mon)
                EnableAIOutOfPC(mon)
                if Mon_Session ~= nil then
                    local mon_ssn = GetSessionObject(mon, Mon_Session)
                    if mon_ssn == nil then
                        CreateSessionObject(mon, Mon_Session)
                    end
                end
                if Hittable ~= nil and Hittable == 1 then
                    SetHittable(mon, 1)
                end
            end
        end
    end
end



----TRACK START AND KILLING FOLLOW NPC
function SCR_TRACKSTART_AND_KILLFOLLOWER(self, ScpObjectName, TrackName)
    local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
    local p
    if P_cnt >= 1 then
        for p = 1, P_cnt do
            local follower = GetScpObjectList(P_list[p], ScpObjectName)
            if #follower ~= 0 then
                local i
                for i = 1, #follower do
                    Kill(follower[i])
                end
            end
        end
    end
    PlayDirection(self, TrackName)
end

--//run SCR_SET_HIDDEN_JOB_UNLOCK_PROP Char3_13 270
function SCR_SET_HIDDEN_JOB_UNLOCK_PROP(pc, job_classname, num)
    local prop_num = tonumber(num)
    SCR_SET_HIDDEN_JOB_PROP(pc, job_classname, prop_num)
end

---- limit number of one day check
-- pc : Only PC
-- Prop_Name : Session Property Name (\data\xml\sessionobject_request.xml)
-- num : limit number of one day
function SCR_SSN_MAIN_LIMIT_DAY_CHECK(pc, Prop_Name, num)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local yday = now_time['yday']
    local wday = now_time['wday']
    local day = now_time['day']
    local hour = now_time['hour']
    
    if month < 10 then
        month = "0"..month;
    end
    if day < 10 then
        day = "0"..day;
    end
    
    local all_date = tostring(year..month..day).."/"..tostring(num)
    local sObj = GetSessionObject(pc, 'SSN_REQUEST');
    if sObj ~= nil then
        if sObj[Prop_Name] ~= nil then
            local string_cut_list_day = SCR_STRING_CUT(all_date);
            local string_cut_list_last = SCR_STRING_CUT(sObj[Prop_Name]);
            local to_day = tostring(string_cut_list_day[1]);
            local last_day = tostring(string_cut_list_last[1]);
            local max_count = tostring(string_cut_list_day[2]);
            local now_count = tostring(string_cut_list_last[2]);
            if sObj[Prop_Name] ~= all_date then
                if last_day == 'None' or last_day ~= to_day then
                    local now_count = 1;
                    local all_date_count = tostring(year..month..day).."/"..tostring(now_count)
                    local tx = TxBegin(pc);
                    TxSetIESProp(tx, sObj, Prop_Name, all_date_count);
            	    local ret = TxCommit(tx, 1);

                	if ret == 'FAIL' then
            	        print(Prop_Name, 'SCR_SSN_MAIN_LIMIT_DAY_CHECK Transaction FAIL')
                	else
                	    return 'YES';
                	end
                else
                    local now_count_num = tonumber(now_count)
                    if now_count_num ~= 0 then
                        now_count_num = now_count_num + 1;
                        local all_date_count = tostring(year..month..day).."/"..tostring(now_count_num)
                        local tx = TxBegin(pc);
                        TxSetIESProp(tx, sObj, Prop_Name, all_date_count);
                	    local ret = TxCommit(tx, 1);
                    	
                    	if ret == 'FAIL' then
                	        print(Prop_Name, 'SCR_SSN_MAIN_LIMIT_DAY_CHECK Transaction FAIL')
                    	else
                    	    return 'YES';
                    	end                        
                    end
                end
            else
                return 'NO';
            end
        else
            print(Prop_Name, 'SCR_SSN_MAIN_LIMIT_DAY_CHECK is nil')
        end
	end
end


---- number of counts per day
-- pc : Only PC
-- Prop_Name : Session Property Name (\data\xml\sessionobject_request.xml)
function SCR_SSN_MAIN_LIMIT_DAY_COUNT_CHECK(pc, Prop_Name, num)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local yday = now_time['yday']
    local wday = now_time['wday']
    local day = now_time['day']
    local hour = now_time['hour']
    
    if month < 10 then
        month = "0"..month;
    end
    if day < 10 then
        day = "0"..day;
    end
    
    local all_date = tostring(year..month..day).."/"..tostring(num)
    local sObj = GetSessionObject(pc, 'SSN_REQUEST');
    if sObj ~= nil then
        if sObj[Prop_Name] ~= nil then
            local string_cut_list_day = SCR_STRING_CUT(all_date);
            local string_cut_list_last = SCR_STRING_CUT(sObj[Prop_Name]);
            local to_day = tostring(string_cut_list_day[1]);
            local last_day = tostring(string_cut_list_last[1]);
            local max_count = tostring(string_cut_list_day[2]);
            local now_count = tostring(string_cut_list_last[2]);
            if sObj[Prop_Name] ~= all_date then
                if last_day == 'None' or last_day ~= to_day then
                    local now_count = 0;
           	        return now_count
           	    else
           	        return tonumber(now_count);    	
           	    end
           	else
           	    return tonumber(now_count);    	
            end
        else
            print(Prop_Name, 'SCR_SSN_MAIN_LIMIT_DAY_COUNT_CHECK is nil')
        end
	end
end

--Test function
function JOB_REMOVE_TEST_FUNCTION(self, char)
    local hiddenObj, cnt = GetWorldObjectList(self, "MON", 99000)
    if cnt >= 1 then
        for i = 1, cnt do
            if hiddenObj[i].Tactics == char then
                local remainTime = hiddenObj[i].NumArg3 - hiddenObj[i].NumArg2
                Chat(self, "Setting time : "..hiddenObj[i].NumArg3.." min".." // ".."Remain time : "..remainTime.." min")
                return
            end
        end
        Chat(self, "There is no  "..char.." here.", 4)
    end
end

--Test function
function JOB_REMOVE_OBJECT_WARP_FUNCTION(self, char)
    if char == "WHITETREES231_CHAR119_MSTEP3_4" then
        MoveZone(self, "f_whitetrees_23_1", 451, 147, -286)
    elseif char == "HIDDEN_CHAR318_MSETP3_1" then
        MoveZone(self, "f_pilgrimroad_41_2", 162, 224, 300)
    elseif char == "HIDDEN_CHAR318_MSETP3_2" then
        MoveZone(self, "f_gele_57_3", 263, 292, 248)
    elseif char == "HIDDEN_CHAR318_MSETP3_3" then
        MoveZone(self, "f_pilgrimroad_41_4", 1100, 52, -324)
    end
end

--Test function
function RETIARII_TRAINING_CNT_FUNCTION(self, char, goal_point)
--Goal1 is traning Goal Count(muscular strength) max count : 50
--Goal2 is traning Goal Count(endurande) max count : 50
--Goal3 is traning Goal Count(agility) max count : 50
--Goal4 is traning Goal Count(durability) max count : 50
--Goal5 is traning Goal Count(simulation) max count : 50
    local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
    if sObj ~= nil then
        local point = tonumber(goal_point)
        if char == "all" then
            sObj.Goal1 = 25
            sObj.Goal2 = 3
            sObj.Goal3 = 20
            sObj.Goal5 = 20
        elseif char == "muscularstrength" then
            if point <= 25 then
                sObj.Goal1 = point
                Chat(self, "muscularstrength goal_point : "..point)
            elseif point > 25 then
                Chat(self, "goal_point is less then 25 point")
            end
        elseif char == "endurande" then
            if point <= 3 then
                sObj.Goal2 = point
                Chat(self, "endurande goal_point : "..point)
            elseif point > 3 then
                Chat(self, "goal_point is less then 3 point")
            end
        elseif char == "agility" then
            if point <= 20 then
                sObj.Goal3 = point
                Chat(self, "agility goal_point : "..point)
            elseif point > 20 then
                Chat(self, "goal_point is less then 20 point")
            end
        elseif char == "simulation" then
            if point <= 20 then
                sObj.Goal5 = point
                Chat(self, "simulation goal_point : "..point)
            elseif point > 20 then
                Chat(self, "goal_point is less then 20 point")
            end
        end
        SaveSessionObject(self, sObj)
    end
end

function NAKMUAY_FIND_PEAPLE_FUNCTION(self)
    local sObj = GetSessionObject(self, "SSN_NAKMUAY_UNLOCK")
    for i = 12, 25 do
        if sObj["Step"..i] == 1 then
            if i == 12 then
                Chat(self, "REMAIN37_RAYMOND")
            elseif i == 13 then
                Chat(self, "REMAIN37_SQ6_UNCLE1")
            elseif i == 14 then
                Chat(self, "REMAIN38_SQ_DRASIUS")
            elseif i == 15 then
                Chat(self, "REMAIN38_HUNTER")
            elseif i == 16 then
                Chat(self, "REMAIN39_SQ_MOJE")
            elseif i == 17 then
                Chat(self, "REMAIN39_SQ_MAN")
            elseif i == 18 then
                Chat(self, "REMAINS39_RP_1_NPC")
            elseif i == 19 then
                Chat(self, "REMAINS_40_CANOLIN_01")
            elseif i == 20 then
                Chat(self, "FEDIMIAN_DETECTIVE_GUARD")
            elseif i == 21 then
                Chat(self, "CRIMINAL")
            elseif i == 22 then
                Chat(self, "REMAIN39_SQ03_GIRL")
            elseif i == 23 then
                Chat(self, "FEDIMIAN_OLDMAN1")
            elseif i == 24 then
                Chat(self, "FEDIMIAN_NPC_11")
            elseif i == 25 then
                Chat(self, "FEDIMIAN_NPC_12")
            end
        end
    end
end

function HINTNPC_DLG_TEST_SETTING(self, num)
    local sObj = GetSessionObject(self, "SSN_NAKMUAY_UNLOCK")
    sObj.Step12 = 0
    sObj.Step13 = 0
    sObj.Step14 = 0
    sObj.Step15 = 0
    sObj.Step16 = 0
    sObj.Step17 = 0
    sObj.Step18 = 0
    sObj.Step19 = 0
    sObj.Step20 = 0
    sObj.Step21 = 0
    sObj.Step22 = 0
    sObj.Step23 = 0
    sObj.Step24 = 0
    sObj.Step25 = 0
    sObj["Step"..num] = 1
    SaveSessionObject(self, sObj)
end

function ASANA_UNHIDE_TEST_SETTING(self, num)
    local sObj = GetSessionObject(self, "SSN_NAKMUAY_UNLOCK")
    if tonumber(num) < 4 then
        sObj.Step2 = num
        SaveSessionObject(self, sObj)
        Chat(self, "cheat success.")
    elseif tonumber(num) >= 4 then
        Chat(self, "cheat fail. must be less then 4")
    end
end

function RETIARII_TRAINING_CNT_FUNCTION(self, char, goal_point)
--Goal1 is traning Goal Count(muscular strength) max count : 50
--Goal2 is traning Goal Count(endurande) max count : 50
--Goal3 is traning Goal Count(agility) max count : 50
--Goal4 is traning Goal Count(durability) max count : 50
--Goal5 is traning Goal Count(simulation) max count : 50
    local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
    if sObj ~= nil then
        local point = tonumber(goal_point)
        if char == "all" then
            sObj.Goal1 = 40
            sObj.Goal2 = 15
            sObj.Goal3 = 40
            sObj.Goal5 = 40
        elseif char == "muscularstrength" then
            if point <= 40 then
                sObj.Goal1 = point
                Chat(self, "muscularstrength goal_point : "..point)
            elseif point > 40 then
                Chat(self, "goal_point is less then 40 point")
            end
        elseif char == "endurande" then
            if point <= 15 then
                sObj.Goal2 = point
                Chat(self, "endurande goal_point : "..point)
            elseif point > 15 then
                Chat(self, "goal_point is less then 20 point")
            end
        elseif char == "agility" then
            if point <= 40 then
                sObj.Goal3 = point
                Chat(self, "agility goal_point : "..point)
            elseif point > 40 then
                Chat(self, "goal_point is less then 40 point")
            end
        elseif char == "simulation" then
            if point <= 40 then
                sObj.Goal5 = point
                Chat(self, "simulation goal_point : "..point)
            elseif point > 40 then
                Chat(self, "goal_point is less then 50 point")
            end
        end
        SaveSessionObject(self, sObj)
    end
end
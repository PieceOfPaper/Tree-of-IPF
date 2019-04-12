-- base.lua

function CHAT_OPEN_TEXT_VIEW(frame, control, argStr, argNum)
	ui.SetChatTab(argNum);		
end

function CHAT_OPEN_MENU(frame, control, argStr, argNum)
	tolua.cast(control, "ui::CTabControl");
	local selectedItemIndex = control:GetSelectItemIndex();	
	local posX = control:GetGlobalX() - ui.GetCursorPosX();
	local posY = control:GetGlobalY() + control:GetHeight() - ui.GetCursorPosY();
	local menu = ui.CreateContextMenu("chatmenu", " ", posX  + selectedItemIndex * 54, posY, 200, 200);
	
	--ui.AddContextMenuItem(menu, ScpArgMsg("Auto_Chang_JamKeum_HaeJe"), "CHAT_RESIZE_CHEAK", frame:GetName());
	ui.AddContextMenuItem(menu, ScpArgMsg("Auto_SaeLoun_Chang_SaengSeong"), "CHAT_NEW", frame:GetName());
	ui.AddContextMenuItem(menu, ScpArgMsg("Auto_Chang_SogSeong_ByeonKyeong"), "CHAT_RENAME", frame:GetName());
	ui.AddContextMenuItem(menu, ScpArgMsg("Auto_Chang_JeKeo"), "CHAT_REMOVE", frame:GetName());
	
	ui.OpenContextMenu(menu);
end

function ADD_NEW_CHAT_FRAME(frame, ctrl, str, num)

	local chatnew = ui.GetFrame('createchat');
	SET_CHAT_NEW(chatnew, frame:GetName(), 0);

end

function CHAT_OPEN_NEW_MENU(frame)

	local chatnew = ui.GetFrame('createchat');
	SET_CHAT_NEW(chatnew, frame:GetName(), 1);

end

function CHAT_RESIZE_CHEAK(frame, control, argStr, argNum)
	local chatFrame = ui.GetFrame(argStr);
	if chatFrame:IsEnableResize() == 1 then
		chatFrame:EnableResize(0);
	else
		chatFrame:EnableResize(1);
	end
end

function CHAT_REMOVE(frame, control, argStr, argNum)

	ui.DeleteChat(argStr);

end

function CHAT_RENAME(frame, control, argStr, argNum)
	local chatnew = ui.GetFrame('createchat');
	SET_CHAT_NEW(chatnew, argStr, 1);

end

function CHAT_NEW(frame, control, argStr, argNum)
	local chatnew = ui.GetFrame('createchat');
	SET_CHAT_NEW(chatnew, argStr, 0);
	
end


function ICON_ON_COOLTIMEEND(frame, object, argStr, argNum)

	local iconPt = object;
	if iconPt  ~=  nil then
		local icon 		= tolua.cast(iconPt, 'ui::CIcon');
		local iconInfo 	= icon:GetInfo();
		local x 			= iconPt:GetGlobalX();
		local y 			= iconPt:GetGlobalY();

		-- Create Icon Image To Center

		local screenWidth = ui.GetClientInitialWidth();
		local screenHeight = ui.GetClientInitialHeight();
		local centerX 	= (screenWidth - 32) * 0.5;
		local centerY 	= (screenHeight - 32) * 0.7;

		local imageItem = ui.CreateImageItem("eft_" .. icon:GetDumpArgNum(), x, y);
		imageItem:SetImage('effect_star1');
		imageItem:SetScale(2.0, 2.0);

		local parentObj = iconPt:GetParent();
		if parentObj  ~=  nil then
			local width = parentObj:GetWidth();
			local height = parentObj:GetHeight();
			imageItem:SetSize(width, height);
		 end

		imageItem:SetLifeTime(1.0);
		imageItem:SetAngleSpd(3.0);
		imageItem:SetScaleDest(1.0, 1.0);
		imageItem:SetAlphaBlendDest(0.0);
		imageItem:SetMoveDest(x, y);
	 end
 end

function ICON_ON_ENABLE(frame, object, argStr, argNum)

	local iconPt = object;
	if iconPt  ~=  nil then
		local icon = tolua.cast(iconPt, 'ui::CIcon');
		local iconInfo = icon:GetInfo();

		local x = object:GetGlobalX();
		local y = object:GetGlobalY();

		local imageItem = ui.CreateImageItem("IconOnEnableItem", x, y);
		imageItem:SetImage(iconInfo.imageName);
		imageItem:SetScale(3.0, 3.0);

		imageItem:SetLifeTime(1.0);
		imageItem:SetAngleSpd(5.0);
		imageItem:SetScaleDest(0.1, 0.1);
		imageItem:SetAlphaBlendDest(0.1);
		imageItem:SetMoveDest(x, y);
	 end
 end
 
  function SCR_DISPEL_DEBUFF_TOGGLE(invItem)
	-- debuff dispel on/off ?��?
	if invItem ~= nil then
		local itemobj = GetIES(invItem:GetObject());
		item.ToggleDispelDebuff(itemobj.ClassID);
	end
 end

 function SCR_JUNGTAN_TOGGLE(invItem)
	-- 공격?�탄 on/off ?��?
	if invItem ~= nil then		
		local itemobj = GetIES(invItem:GetObject());
		item.ToggleJungtan(itemobj.ClassID, itemobj.NumberArg1, itemobj.NumberArg2);
		
		local frame = ui.GetFrame('status');		
		STATUS_INFO(frame);
	end
 end

  function SCR_JUNGTAN_DEFENCE_TOGGLE(invItem)
	-- 방어?�탄 on/off ?��?
	if invItem ~= nil then		
		local itemobj = GetIES(invItem:GetObject());
		item.ToggleJungtanDef(itemobj.ClassID, itemobj.NumberArg1, itemobj.NumberArg2);
		
		local frame = ui.GetFrame('status');		
		STATUS_INFO(frame);
	end
 end

 function RUN_CLIENT_SCP(invItem)
	local itemobj = GetIES(invItem:GetObject());
	local clScp = TryGetProp(itemobj, "ClientScp");
	if clScp ~= nil and clScp ~= "None" then
		local scp = _G[itemobj.ClientScp];
		if scp == nil then
			ErrorLog(itemobj.ClientScp);
		end
		scp(invItem);
		return true;
	end

	return false;
 end


 function INV_ICON_USE(invItem)
	if nil == invItem then
		return;
	end
	
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	if true == RUN_CLIENT_SCP(invItem) then
		return;
	end
	
	local stat = info.GetStat(session.GetMyHandle());		
	if stat.HP <= 0 then
		return;
	end
	
	local itemtype = invItem.type;
	local curTime = item.GetCoolDown(itemtype);
	if curTime ~= 0 then
		imcSound.PlaySoundEvent("skill_cooltime");
		return;
	end
	
	local itemCount = invItem.count - 1;
	if itemCount >= 0 then
		local equipSound = GetClassString('Item', invItem.type, 'EquipSound');
		--imcSound.PlaySoundItem(equipSound);
	end

	item.UseByGUID(invItem:GetIESID());

 end

 function GET_ICON_ITEM(iconInfo)
	local invItem = session.GetInvItem(iconInfo.ext);
	if invItem ~= nil then
		return invItem;
	end
	
	return session.GetInvItemByType(iconInfo.type);
 end

--Icon Use
function ICON_USE(object, reAction)	
	local iconPt = object;
	if iconPt  ~=  nil then
		local icon = tolua.cast(iconPt, 'ui::CIcon');
		
		local iconInfo = icon:GetInfo();
		if iconInfo.category == 'Item' then
			local itemObj = GetClassByType('Item', iconInfo.type);
			if IS_EQUIP(itemObj) == true then
				ITEM_EQUIP_BY_ID(icon:GetTooltipIESID());
				return;
			else
				local groupName = itemObj.ItemType;
				if groupName == 'Consume' or groupName == "Quest" then
					local usable = itemObj.Usable;
					if usable ~= 'ITEMTARGET' then						
						local invenItemInfo = GET_ICON_ITEM(iconInfo);
						if false and usable == 'GROUND' then
							
						else
							if invenItemInfo ~= nil then
								local itemtype = iconInfo.type;
								local curTime = item.GetCoolDown(itemtype);
								local stat = info.GetStat(session.GetMyHandle());
								if curTime ~= 0 or stat.HP <= 0 then
									imcSound.PlaySoundEvent("skill_cooltime");
									return;
								end
							
								--[[
								local itemCount = invenItemInfo.count;
								if itemCount >= 0 then
									local equipSound = itemObj.EquipSound;
									imcSound.PlaySoundEvent(equipSound);
									icon:SetOnCoolTimeEndScp('QUICKSLOTNEXPBAR_ICON_COUNT');
									icon:SetOnCoolTimeEndArgNum(itemCount);
									icon:SetText(itemCount, 'quickiconfont', 'right', 'bottom', -2, 1);
								end
								]]
								
								INV_ICON_USE(invenItemInfo);
								return;
							end
							item.UseByInvIndex(iconInfo.ext);
						end
					end
				end
			end
		elseif iconInfo.category == 'Skill' then
			control.Skill(iconInfo.type);
		elseif iconInfo.category == 'ACTION' then
			local script = GetClassString('Action', iconInfo.type, 'Script');
			loadstring(script)();
		elseif iconInfo.category == 'CHEAT' then
			local script = GetClassString('Cheat', iconInfo.type, 'Scp');
			if string.find(script,'//') ~= nil then
				ui.Chat(script);
			else
				loadstring(script)();
			end
		elseif iconInfo.category == 'ITEMCREATE' then
			local msg = '//item ' .. iconInfo.type .. ' 1';
			ui.Chat(msg);
		elseif iconInfo.category == 'MONCREATE' then
			local msg = '//mon ' .. iconInfo.type .. ' 1';
			ui.Chat(msg);	
		end
	end	
end


function CURRENCY(count)

	local TextLen			= string.len(count);
	local arrange		= {};
	local GetCount	= math.floor((TextLen / 3) + 0.9)
	local value = nil;
	local goldText;
	local result;

	if  TextLen < 4  then
		result	= count
	 else
		for  i = 1, GetCount do
			if  i * 3 > TextLen  then
				local x = -( i * 3);
				local y = x + 2;
				arrange[i]	=	string.sub(count, 1, y);
				break;
			 end
			local x = -( i * 3);
			local y = x + 2;
			arrange[i]	=	string.sub(count, x, y);
		 end

		--?�겨�?변?�의 ?�치�?구한??
		GetCount	= table.getn(arrange);

		--?�치??
		for  j = 1, GetCount do
			local ex = GetCount - (j - 1);
			if  value == nil  then
				value = arrange[ex];
			 else
				value = value .. "," .. arrange[ex];
			 end
		 end
		result = value;
	 end
	return result;
 end


function ITEM_DROP(object)

	if true == BEING_TRADING_STATE() then
		return;
	end

	local slot = tolua.cast(object, 'ui::CSlot');
	local iconPt = slot:GetIcon();
	if iconPt  ~=  nil then
		local icon = tolua.cast(iconPt, 'ui::CIcon');
		local iconInfo = icon:GetInfo();
		if iconInfo.category == 'Item' then
			item.Drop(iconInfo.type);
		 end
	 end
 end


 --Skill ToolTip
 function ICON_SET_BUFF_TOOLTIP(icon, buffClass)

	local class 				= GetClassByType('Buff', buffClass)
	local Name					= class.Name;
	local ClassName		= class.ClassName;
	--local Icon					= 'icon_' .. class.Icon;

	local ToolTip				= class.ToolTip;

	local BuffName			= '{#ffffff}{s18}' .. Name;
	local comment			= '{#aaaaaa}' .. ToolTip;

	icon:SetTooltipType('buff')
	icon:SetTooltipData('name', BuffName);
	icon:SetTooltipData('comment', comment);

 end

 function _ICON_UPDATE_LINK_GAUGE(icon)

	local depth = icon:GetUserIValue("_CD_TGT_CNT");
	if depth == 0 then
		icon:RemoveCoolTimeUpdateScp();
		return;
	end

	local frameName = icon:GetUserValue("_CD_TGT_NAME_" .. depth);
	local frame = ui.GetFrame(frameName);
	if frame == nil then
		icon:RemoveCoolTimeUpdateScp();
		return;
	end

	local gauge = frame;
	for i = 1 , depth - 1 do
		local objName = icon:GetUserValue("_CD_TGT_NAME_" .. depth - i);
		gauge = gauge:GetChild(objName);
		if gauge == nil then
			icon:RemoveCoolTimeUpdateScp();
			return;
		end
	end

	gauge = tolua.cast(gauge, "ui::CGauge");
	if gauge:IsTimeProcessing() == 0 then
		icon:RemoveCoolTimeUpdateScp();
		return;
	end

	local cur = gauge:GetCurPoint();
	local max = gauge:GetMaxPoint();
	return cur, max;

 end

 function LINK_ICON_TO_GAUGE(icon, gauge)

	local depth = 1;
	while 1 do
		
		icon:SetUserValue("_CD_TGT_NAME_" .. depth, gauge:GetName());
		local parent = gauge:GetParent();
		if parent == gauge or parent == nil then
			break;
		end

		gauge = parent;
		depth = depth + 1;
	end

	icon:SetUserValue("_CD_TGT_CNT", depth);
	icon:SetOnCoolTimeUpdateScp('_ICON_UPDATE_LINK_GAUGE');
	icon:SetDrawCoolTimeText(0);

 end

 --Item Dump
function ICON_DUMP(frame, object, argStr, argNum)	
	if true == BEING_TRADING_STATE() then
		return;
	end

	local icon = tolua.cast(object, 'ui::CIcon');
	local info = icon:GetInfo();
	
	local FromFrame = icon:GetTopParentFrame();
	
	if FromFrame:GetName() == 'status' then		
		STATUS_EQUIP_SLOT_SET(FromFrame);
		
	elseif FromFrame:GetName() == 'inventory' then
		INVENTORY_DELETE(info:GetIESID(), info.type)
		return;
	end
	
	item.Drop(argNum);
 end

-- Get Tag Text
function GET_TAG_IMAGE(imageName)

   return ' img ' .. imageName .. ' end ';
 end

function GET_TAG_IMAGE_SIZE(imageName, width, height)

   return ' img ' .. imageName .. ' ' .. width .. ' ' .. height .. ' end ';
 end

-- Skill Cooldown Update
function ICON_UPDATE_SKILL_COOLDOWN(icon)

	local totalTime = 0;
	local curTime = 0;
	local iconInfo = icon:GetInfo();
	local skillInfo = session.GetSkill(iconInfo.type);
	if skillInfo ~= nil then
		local remainRefresh = skillInfo:GetRemainRefreshTimeMS();
		if remainRefresh > 0 then
			return remainRefresh, skillInfo:GetMaxRefreshTimeMS();
		end

		curTime = skillInfo:GetCurrentCoolDownTime();
		totalTime = skillInfo:GetTotalCoolDownTime();
	end
	return curTime, totalTime;
 end

 -- Skill Enable Update
 function ICON_UPDATE_SKILL_ENABLE(icon)	
	
	local iconInfo = icon:GetInfo();
	if iconInfo ~= nil then
		local ret = control.IsSkillIconUsable(iconInfo.type);	
		return ret;
	end
end

 function MONSTER_ICON_UPDATE_SKILL_ENABLE(icon)		
	local iconInfo = icon:GetInfo();
	if iconInfo ~= nil then
		local ret = control.IsMonSkillIconUsable(iconInfo.type);	
		return ret;
	end
end



function RETURN_DATATABLE(data, IESName, searchData)
	local datatable = {};

	-- 만약 data??값이 ?�다�?값을 리턴?�다
	if data == nil then
		return datatable;
	end

	-- ?�이?��? 구성
	-- 1. 카테고리�?구성?�다.
	datatable['Category']			= {};
	datatable['CategoryName'] 		= {}
	datatable['searchData']			= 'Find'
	local SearchCheck				= searchData['searchText']
	local NewCategory				= 'NO'
	local count = 1;

	local tablecount					= table.getn(data)

	-- ?�이???�이�?개수만큼 For문을 ?�린??
	for i = 1, tablecount do

			-- i ??Category �?CategoryName 컬럼??값을 ?�?�하?�록 ?�다.
			local Category				= GetClassString(IESName, data[i], 'Category');
			local CategoryName		= GetClassString(IESName, data[i], 'CategoryName');

			-- 첫번�?기록?�소??값이 ?�을 ??먼�? ?�행?�도�??�다.
			if datatable['Category'][1] == nil then
				if SearchCheck == 'Not Data Exist' then
					datatable['Category'][count]					= Category;					-- ?�문 ?�렬??카테고리??카운?�로 ?�?�한??
					datatable['CategoryName'][Category]	= CategoryName;			-- ??��조용 카테고리???�문 카테고리???�름?�로??값을 ?�?�하?�록 ?�다.
					count = count + 1
				else
					local search		= DATA_SEARCH(data[i], IESName, searchData)		-- 찾기??값을 찾았???�에??TRUE�?반환?�도�??�다.

					if search == 'TRUE' then
						datatable['Category'][count]					= Category;					-- ?�문 ?�렬??카테고리??카운?�로 ?�?�한??
						datatable['CategoryName'][Category]	= CategoryName;			-- ??��조용 카테고리???�문 카테고리???�름?�로??값을 ?�?�하?�록 ?�다.
						count = count + 1
					end
				end
			end

			-- 첫번�?기록?�소??값이 ?�어 ?�으므�? ?�음�?부?�는 ?�차?�으�?검???�에 ?�이?��? ?�력?�도�??�다.
			local CategoryCount = table.getn(datatable['Category']);

			if CategoryCount > 0 then
				for j = 1, CategoryCount do
					-- ?�일??값이 ?�는지 검?�하?�록 ?�다.
					if Category == datatable['Category'][j] then
						NewCategory = 'NO';
						break;
					else
						NewCategory = 'YES';
					end
				end
			end

			-- 만약 ?�로??카테고리??값이 검?�되?�다�?추�?
			if NewCategory == 'YES' then
				if SearchCheck == 'Not Data Exist' then
					datatable['Category'][count]					= Category;					-- ?�문 ?�렬??카테고리??카운?�로 ?�?�한??
					datatable['CategoryName'][Category]	= CategoryName;			-- ??��조용 카테고리???�문 카테고리???�름?�로??값을 ?�?�하?�록 ?�다.
					count = count + 1
				else
					local search		= DATA_SEARCH(data[i], IESName, searchData)		-- 찾기??값을 찾았???�에??TRUE�?반환?�도�??�다.

					if search == 'TRUE' then
						datatable['Category'][count]					= Category;					-- ?�문 ?�렬??카테고리??카운?�로 ?�?�한??
						datatable['CategoryName'][Category]	= CategoryName;			-- ??��조용 카테고리???�문 카테고리???�름?�로??값을 ?�?�하?�록 ?�다.
						count = count + 1
					end
				end
			end

		-- 만약 찾는 값이 ?��? ?�을 경우?�는? 값이 ?�다??것을 리턴 ?�다
		if i == tablecount then
			local CategoryCount = table.getn(datatable['Category'])
			if CategoryCount == nil or CategoryCount == 0 then
				datatable['searchData']	= 'TextNotFound'
				return datatable;
			end
		end
	end

	table.sort(datatable['Category']);

	-- 2. Data�?구성?�도�??�자
	datatable['DataTable'] = {}

	for i = 1, table.getn(datatable['Category']) do
		local DataColumn = datatable['Category'][i];
		local count = 1;
		datatable['DataTable'][DataColumn] = {}

		-- ?�이?�의 개수만큼 루프문을 ?�고, 카테고리???�름??같다�? ?�?�한??
		for j = 1, table.getn(data) do
			local Category		= GetClassString(IESName, data[j], 'Category');


			-- OnCheat가 'YES' ?�때�??�이?��? 추�??�다
			local OnCheatCheck		= GetClassString(IESName, data[j], 'OnCheat');

			if OnCheatCheck == 'YES' then

				if DataColumn == Category then
					if SearchCheck == 'Not Data Exist' then
						-- 같�? 카테고리?�면?
						datatable['DataTable'][DataColumn][count] = GetClassString(IESName, data[j], 'ClassName');
						count = count + 1;
					else
						-- 같�? 카테고리?�며, 검?�어가 맞음
						local search		= DATA_SEARCH(data[j], IESName, searchData)		-- 찾기??값을 찾았???�에??TRUE�?반환?�도�??�다.

						if search == 'TRUE' then
							datatable['DataTable'][DataColumn][count] = GetClassString(IESName, data[j], 'ClassName');
							count = count + 1;
						end
					end
				end

			end
		end
	end

	return datatable;
end

function DATA_SEARCH(data, IESName, searchData)

	local SearchTrue					= 'FALSE'

	local SearchColumnCount		= table.getn(searchData['searchColumn'])

	for i = 1, SearchColumnCount do
		-- ?�기??검?�용 ?�을 만든??
		-- 컬럼 종류가 몇�?지 ?�는가???�라 ?�르??
		local ColumnName			= searchData['searchColumn'][i];
		local CheckColumn 			= GetClassString(IESName, data, ColumnName);
		local CheckData				= string.find(CheckColumn, searchData['searchText'])

		if CheckData ~= nil then
			SearchTrue					= 'TRUE'
			break;
		end
	end

	return SearchTrue;
end

function HASIES_RETURN_COUNT(IESName, Sub1Class, Sub2Class)
	-- ?�차??배열??카운?��? 가지�??�다
	local IESData					= imcIES.GetClassList(IESName);
	local returnValue
	if Sub1Class ~= nil then
		local Select1Class			= IESData:GetClass(Sub1Class);							-- ClassID??1�??�이?��? 가지�??�다
		local Sub1ClassList			= Select1Class:GetSubClassList();							-- ?�위 SubClass�?가지�??�다
		local Sub1ClassConut		= Sub1ClassList:Count();
		if Sub2Class ~= nil then
			-- ?�번�??�이?��? ?�다
			local ChangeSubClass		= Sub1ClassList:GetByIndex(Sub2Class - 1)
			local Sub2ClassList			= ChangeSubClass:GetSubClassList();
			local Sub2ClassCount		= Sub2ClassList:Count();

			returnValue = Sub2ClassCount;
		else
			-- ?�번�??�래?�의 값이 nil ?�라�?  마�?�?마운?��? 리턴?�다
			returnValue = Sub1ClassConut
		end
	end
	return returnValue;
end

function HASIES_RETURN_VALUE(IESName, Sub1Class, Sub2Class, Count, ColumnName)
	-- ?�차??배열???�이?�의 값을 반환?�다
	local IESData				= imcIES.GetClassList(IESName);
	local returnValue, class

	if Sub1Class ~= nil then
		local Select1Class			= IESData:GetClass(Sub1Class);					-- ClassID??1�??�이?��? 가지�??�다
		local Sub1ClassList			= Select1Class:GetSubClassList();					-- ?�위 SubClass�?가지�??�다
		if Sub2Class ~= nil then
			-- ?�번�??�이?��? ?�다
			-- ?�직 ?�번�??�이?�는 만들지 ?�았?��?�? 차후 추�??�는 것으�???
		else
			class			= Sub1ClassList:GetByIndex(Count - 1);
		end

		returnValue		= imcIES.GetString(class, ColumnName);
	end
	return returnValue;
end

 function GET_MULTIVALUE(Class)

	local tempString	= Class;
	local MultiValue		= {};

	for w in string.gmatch(tempString, '%d+') do
		MultiValue[#MultiValue + 1] = w;
	end

	return MultiValue;
 end


 function GET_IESTYPE_DATA(IES, DataTable, ClassName)
	local MultiValue		= {};
	local ReturnValue		= '';
	local JoinCheck			= nil;

	if DataTable['MultiValue'] == 'YES' then
		local tempMulti		= ClassName;		-- ?�단 값을 가지�??�다
		-- ?�속??string 값을 가지�??�다. (?�수문자 ?�외)
		for w in string.gmatch(tempMulti, '%a+') do
			MultiValue[#MultiValue + 1] = w;
		end

		-- 조인??and??or?�냐 ?�인 nil = or
		JoinCheck			= string.match(tempMulti, '%;');

		-- ?�속???�자만큼 값을 구해, ?�한??
		for i = 1, #(MultiValue) do
			-- ClassID�?가지�??�다.
			local ClassIDSource		= "local ClassID = GetClassNumber('[IES]', '[ClassName]', 'ClassID' ); return ClassID;";
			ClassIDSource			= string.gsub(ClassIDSource,'%[IES%]', IES);
			ClassIDSource			= string.gsub(ClassIDSource,'%[ClassName%]', MultiValue[i]);
			local GetClassID		= assert(loadstring(ClassIDSource));
			local ClassID			= GetClassID();

			local Subsource			= "local class = GetClassByType('[IES]', [ClassID]); return class.[Column]"
			Subsource				= string.gsub(Subsource, '%[IES%]', IES);
			Subsource				= string.gsub(Subsource, '%[ClassID%]', ClassID);
			Subsource				= string.gsub(Subsource, '%[Column%]', DataTable['SubColumn']);
			local ClassByType		= assert(loadstring(Subsource));

			-- 값을 ??�� ?�운??
			if DataTable['preFix'] ~= 'None' then
				-- ?�두??
				ReturnValue			= ReturnValue .. DataTable['preFix']
			end

			-- 값을 ?�는??
			ReturnValue				= ReturnValue .. ClassByType();

			if DataTable['sufFix'] ~= 'None' then
				-- ?��???
				ReturnValue			= ReturnValue .. DataTable['sufFix']
			end

			if i ~= #(MultiValue) then
				-- 값이 모두 종료?��? ?��? ?�태?�면
				if DataTable['joinFix'] ~= 'None' then
					ReturnValue			= ReturnValue .. DataTable['joinFix'];
				end
			else
				if DataTable['joinOr'] ~= 'None' or DataTable['joinAnd'] ~= 'None' then
					if JoinCheck == nil then
						-- JoinCheck??값이 nil????or ?�태)
						ReturnValue			= ReturnValue .. DataTable['joinOr'];
					else
						-- JoinCheck??값이 nil???�닐??and ?�태)
						ReturnValue			= ReturnValue .. DataTable['joinAnd'];
					end
				end
			end
		end
	else
		-- ClassID�?가지�??�다.
		local ClassIDSource		= "local ClassID = GetClassNumber('[IES]', '[ClassName]', 'ClassID' ); return ClassID;";
		ClassIDSource			= string.gsub(ClassIDSource,'%[IES%]', IES);
		ClassIDSource			= string.gsub(ClassIDSource,'%[ClassName%]', ClassName);
		local GetClassID		= assert(loadstring(ClassIDSource));
		local ClassID			= GetClassID();

		local Subsource			= "local class = GetClassByType('[IES]', [ClassID]); return class.[Column]"
		Subsource				= string.gsub(Subsource, '%[IES%]', IES);
		Subsource				= string.gsub(Subsource, '%[ClassID%]', ClassID);
		Subsource				= string.gsub(Subsource, '%[Column%]', DataTable['SubColumn']);
		local ClassByType		= assert(loadstring(Subsource));

		-- 값을 ??�� ?�운??
		if DataTable['preFix'] ~= 'None' then
			-- ?�두??
			ReturnValue			= ReturnValue .. DataTable[preFix]
		end

		ReturnValue				= ReturnValue .. ClassByType();

		if DataTable['sufFix'] ~= 'None' then
			-- ?��???
			ReturnValue			= ReturnValue .. DataTable['sufFix']
		end
	end

	return ReturnValue;
 end


 function GET_DESC_ARGUMENT(Type, IESName, DataTable)
	-- IES???�이?��? 분석 ?�거???�다.
 	local argDataCount	= #(DataTable);
	local argData		= {};
	local IES			= nil;

	for k = 1, argDataCount do
		local source		= "local class = GetClassByType('[IES]', [ClassID]); return class.[Column]"
		-- local ClassID		= nil;
		local ColumnName	= DataTable[k]['Column'];
		local tempIESName	= DataTable[k]['IES'];

		-- 기본 IES???�이?��? 불러 ?�인??
		IES			= IESName;
		source		= string.gsub(source, '%[IES%]', IES);
		source		= string.gsub(source, '%[ClassID%]', Type);
		source		= string.gsub(source, '%[Column%]', ColumnName);

		if ColumnName ~= 'None' then
			if DataTable[k]['IES']	== 'None' then
				local runLoadString		= assert(loadstring(source));
				local tempClass			= runLoadString();

				-- 만약 MultiValue??값이 YES??경우.
				if DataTable[k]['MultiValue']	== 'YES' then
					local MultiValue		= GET_MULTIVALUE(tempClass)
					local SumValue			= 0;
					--argData[k]				= #(MultiValue);
					argData[k]				= MultiValue;
				else
					argData[k]				= tempClass;
				end

			elseif DataTable[k]['IES']	== 'MyHandle' then
				-- MyHandle ?�경??처리�??�자
				local MyHandleSource 		= "local MySession = session.GetMyHandle(); local CharProperty	= GetProperty(MySession); return CharProperty.[ColumnName]"
				MyHandleSource				= string.gsub(MyHandleSource, '%[ColumnName%]', ColumnName);
				local LoadMyHandleSourece	= assert(loadstring(MyHandleSource));
				local runLoadMyHandle		= LoadMyHandleSourece();
				argData[k]					= runLoadMyHandle;
			else
				-- IES??IES Name가 ?�을 경우. (MultiValue�??�용?????�다)
				local runLoadString		= assert(loadstring(source));
				local ClassName			= runLoadString();
				if ClassName ~='None' then
					argData[k]				= GET_IESTYPE_DATA(tempIESName, DataTable[k], ClassName);
				else
					-- ?�이??값이 None�??�어 ?�다
					argData[k]				= ClassName;
				end
			end
		else
			-- ?�수 ?�이?��? None값이??
			argData[k]	= 'NoData';
		end

		-- ?�기???��??�이?��? ?�도�??�자
		if DataTable[k]['replace'] == 'YES' and DataTable[k]['MultiValue'] == 'NO' and argData[k] ~= nil then
			local replaceCount		= #(DataTable[k]['If'])
			for c = 1, replaceCount do
				-- ReturnComment ???�??Font �?pre,suf Fix ?�기?�에, replace 값을 검?�한??
				local replaceSource		= "if [Compare] then  return 'TRUE'; else return 'FALSE'; end";
				replaceSource			= string.gsub(replaceSource, '%[Compare%]', DataTable[k]['If'][c]['Compare']);
				replaceSource			= string.gsub(replaceSource, '%[Arg%]', argData[k]);
				local Loadreplace		= assert(loadstring(replaceSource));
				local CheckCompare		= Loadreplace();
				if CheckCompare == 'TRUE' then
					if DataTable[k]['If'][c]['reValue'] == 'None' then
						argData[k]			= '';
					else
						local reValue			= DataTable[k]['If'][c]['reValue'];
						reValue					= string.gsub(reValue, '%[Arg%]', argData[k]);
						local reValueSource		= 'return ' .. reValue;
						local LoadreValueSource = assert(loadstring(reValueSource));
						local runreValueSource	= LoadreValueSource();
						argData[k]				= runreValueSource;
					end
					break;
				else
					if DataTable[k]['If'][c]['else'] ~= 'None' then
						-- 만약 else??값이 None가 ?�닌경우
						local elseValue			= DataTable[k]['If'][c]['else']
						elseValue				= string.gsub(elseValue, '%[Arg%]', argData[k]);
						local elseSource		= 'return ' .. elseValue;
						local LoadelseSource	= assert(loadstring(elseSource));
						local runelseSource		= LoadelseSource();
						argData[k]				= runelseSource;
					end
				end
			end
		elseif DataTable[k]['replace'] == 'YES' and DataTable[k]['MultiValue'] == 'YES' and argData[k] ~= nil then
			-- 멀??값이 ?�을 경우
			argData[k]	= #(argData[k])
		end
	end

	return argData;
 end


 function RETURN_FIXDATA(DataTable)
	-- ?�이??변??묶음
	local returnValue		= {}
	if DataTable.ValueFont ~= 'None' then
		returnValue[1]			= DataTable.ValueFont
	else
		returnValue[1]			= ''
	end

	if DataTable.preFix ~= 'None' then
		returnValue[2]			= DataTable.preFix
	else
		returnValue[2]			= ''
	end

	if DataTable.sufFix ~= 'None' then
		returnValue[3]			= DataTable.sufFix
	else
		returnValue[3]			= ''
	end

	return returnValue;
 end

 function GET_DESC_SCRIPT(Type, IESName, TipType, Object)
	local class	 				= GetClassByType(IESName, Type);
	local ToolTipTable			= HASIES_TOOLTIP_TABLE('Tooltipset', TipType);
	local TooltipCount			= #(ToolTipTable);
	local TitleValue			= {};

	-- DESC�?구성?�다
	local Comment				= '';

	for i = 1, TooltipCount do
		if ToolTipTable[i].ToolTipType == 'CaseByType' then
			local WriteValue, Value, CheckCase		= RETURN_TOOLTIPCOMMENT(ToolTipTable, Type, IESName, i)

			-- 계산??�?�?null 값이 ?�는지 ?�인?�보??
			local nullCheck					= 'None'
			local nullCount					= 0;

			-- Node2??Value 값들??비교 ?�는 것으로서, 모든 값이 null ?�라�?리턴 처리?�다.
			for k = 1, #WriteValue do
				--[[
				print(k .. ' - #WriteValue : ' .. #WriteValue);
				print(k .. ' - WriteValue[k] : ' .. WriteValue[k]);
				print(k .. ' - CheckCase[k] : ' .. CheckCase[k]);
				]]--
				if WriteValue[k] == 'null' or CheckCase[k] ~= 'TRUE' then
					nullCount = nullCount + 1;
				end

				if k == nullCount then
					nullCheck = 'CheckOK';
				else
					nullCheck = 'None';
				end
			end


			if nullCheck ~= 'CheckOK' then
				-- 추�? ?�이?��? ?�어 보자
				local Node1Data = RETURN_FIXDATA(ToolTipTable[i]);
				-- CheckCase??값이 TRUE??값을 먼�? 배치?�다.
				local ReturnComment		= '';

				for j = 1, #WriteValue do
					if CheckCase[j] == 'TRUE' then
						ReturnComment	= ReturnComment .. WriteValue[j] .. ToolTipTable[i].ValueFont;
						break;
					end
				end

				ReturnComment			= Node1Data[1] .. Node1Data[2] .. ReturnComment .. Node1Data[3] .. ToolTipTable[i].NameFont
				local Caption			= ToolTipTable[i].NameFont .. ToolTipTable[i].Caption;

				Caption			= string.gsub(Caption, '%[Value%]', ReturnComment)
				TitleValue[#(TitleValue)+1]	= Caption;

				if ToolTipTable[i].TitleArg ~= 'YES' then
					-- 최종 �?
					Comment = Comment .. Caption;

					if ToolTipTable[i].NextLine == 'YES' then
						Comment = Comment .. '{nl}';
					end
				end
			else
				TitleValue[#(TitleValue)+1]	= '';
			end

		elseif ToolTipTable[i].ToolTipType == 'multiValue' then
			local WriteValue, Value, CheckCase		= RETURN_TOOLTIPCOMMENT(ToolTipTable, Type, IESName, i)

			-- 계산??�?�?null 값이 ?�는지 ?�인?�보??
			local nullCheck					= 'None'

			for k = 1, #WriteValue do
				--[[
				print(k .. ' - #WriteValue : ' .. #WriteValue);
				print(k .. ' - WriteValue[k] : ' .. WriteValue[k]);
				print(k .. ' - CheckCase[k] : ' .. CheckCase[k]);
				]]--
				if WriteValue[k] == 'null' or CheckCase[k] ~= 'TRUE' then
					nullCheck = 'CheckOK';
					break;
				else
					nullCheck = 'None';
				end
			end

			if nullCheck ~= 'CheckOK' then
				-- 추�? ?�이?��? ?�어 보자
				local Node1Data = RETURN_FIXDATA(ToolTipTable[i]);
				-- ??집합??결합 ?�보??
				local WriteValueCount	= #WriteValue
				local Caption			= ToolTipTable[i].NameFont .. ToolTipTable[i].Caption;

				for j = 1, WriteValueCount do
					WriteValue[j]		= Node1Data[1] .. Node1Data[2] .. WriteValue[j] .. Node1Data[3] .. ToolTipTable[i].NameFont
					Caption				= string.gsub(Caption, '%[Value' .. j .. '%]', WriteValue[j])
				end

				TitleValue[#(TitleValue)+1]	= Caption;

				if ToolTipTable[i].TitleArg ~= 'YES' then
					Comment					= Comment .. Caption;
					if ToolTipTable[i].NextLine == 'YES' then
						Comment = Comment .. '{nl}';
					end
				end
			else
				TitleValue[#(TitleValue)+1]	= '';
			end
		else
			Comment = Comment .. ScpArgMsg('Auto_{nl}{#ff0000}JiwonHaNeun_KoDeuKa_aNipNiDa_Datatree_tooltipseteul_HwaginHaeJuSeyo{nl}')
		end
	end




	-- Name�?구성?�다
	local ToolTipName			= '';

	local nameValue				= {}
	if ToolTipTable.ValueFont ~= 'None' then
		nameValue[1]			= ToolTipTable.NameFont;
	else
		nameValue[1]			= '';
	end

	if ToolTipTable.ValueFont ~= 'None' then
		nameValue[2]			= ToolTipTable.ValueFont;
	else
		nameValue[2]			= '';
	end

	for i = 1, 4 do
		local RootSource			= "local ArgType = GetClassByType('[IES]', [ClassID]); return ArgType.[Column]";
		local ObjSource				= "local Value = [Object].[Column]; return Value;"
		local SelSource				= nil;

		-- arg1 ~ 4???�??값을 리턴 받는??
		local checkArg			= ToolTipTable['Arg' .. i];
		if checkArg ~= 'None' then
			-- [Object] ?�그가 ?�는지 ?�인?�다
			local ObjText		= string.match(checkArg, '%[Object%]');
			SelSource			= string.gsub(RootSource, '%[IES%]', IESName);
			SelSource			= string.gsub(SelSource, '%[ClassID%]', Type);
			SelSource			= string.gsub(SelSource, '%[Column%]', checkArg);
			
			if Object ~= nil then
				nameValue[i + 2]		= Object[checkArg];
			else	
				local nameTempText		= assert(loadstring(SelSource));
				nameValue[i + 2]		= nameTempText();
			end

			if nameValue[i + 2] == nil then
				nameValue[i + 2]	= ToolTipTable['Arg' .. i];
			end
		else
			nameValue[i + 2]	= 'None';
		end
	end

	-- Value 값을 가지�??�다
	ToolTipName					= ToolTipTable.Value;

	-- Value?� Arg�??�친??
	for o = 1, 4 do
		ToolTipName				= string.gsub(ToolTipName, '%[arg' .. o .. '%]', nameValue[o + 2]);
	end


	-- 값이 ?�별???�류가 ?�다�?무사 ?�과(Value 값이 None?�라 ?�여???�과 ??
	local TempText	= assert(loadstring('local Value = ' .. ToolTipName .. ';' .. 'if Value ~= tostring(Value) then if Value == nil then return ' .. "'" .. ToolTipName .. "'" .. 'else return Value; end end'));
	local TempText2	= TempText()

	if TempText2 == nil then
		-- ?�류가 발생
		TempText2 = '{#ff0000}Value Error'
	end

	-- Value 값에 Font?�보�??�는??
	TempText2 = nameValue[2] .. TempText2 .. nameValue[1];

	-- WriteValue??값이 None가 ?�닐 경우 본래 ?�던 ?�스?�로부??[Value]�?찾아 ?�이?��? ???�는??
	if ToolTipTable.WriteValue ~= 'None' then
		ToolTipName			= string.gsub(ToolTipTable.WriteValue, '%[Value%]', TempText2);
	else
		ToolTipName			= TempText2;
	end

	-- SubValue?� text값을 ?�친??
	for o = 1, #(TitleValue) do
		ToolTipName				= string.gsub(ToolTipName, '%[TitleValue' .. o .. '%]', TitleValue[o]);
	end

	-- Font ?�보?� ?�친??
	ToolTipName				= nameValue[1] .. ToolTipName

	-- Node2.Value & Arg1 ~ 4??값을 WriteValue???�을 ???�도�??�다
	for o = 1, 4 do
		ToolTipName		= string.gsub(ToolTipName, '%[arg' .. o .. '%]', (nameValue[2] .. nameValue[o + 2] .. nameValue[1]));
	end

	return ToolTipName, Comment;
end

-- if 값이 참인지 거짓?��? 반환 ?�는 ?�수
function RETURN_TRUEORFALSE(ifData, arg)

	local CheckArg	= ifData;

	for i = 1, #(arg) do
		if arg[i] ~= 'null' and arg[i] ~= nil then
			-- 값이 null???�닐 ?�에�??�행 ?�도�??�다.
			CheckArg	= string.gsub(CheckArg, '%[arg' .. i .. '%]', arg[i])
		else
			-- 만약 값이 null ?�라�?null??리턴?�다.
			return 'null'
		end
	end

	local replaceSource		= "if [Compare] then  return 'TRUE'; else return 'FALSE'; end";
	replaceSource			= string.gsub(replaceSource, '%[Compare%]', CheckArg);
	local Loadreplace		= assert(loadstring(replaceSource));
	local CheckCompare		= Loadreplace();
	return CheckCompare;
end


function RETURN_TOOLTIPCOMMENT(ToolTipTable, Type, IESName, count)
	local class	 				= GetClassByType(IESName, Type);
	local SubDataCount			= #ToolTipTable[count];
	local Value					= {};
	local WriteValue			= {};
	local CheckCase				= {};

	for j = 1, SubDataCount do
		local Node2Value 			= RETURN_FIXDATA(ToolTipTable[count][j]);
		-- ?�기가 Node3 ?�이?��? ?�어 ?�는 �?
		Node2Value['arg']			= GET_DESC_ARGUMENT(Type, IESName, ToolTipTable[count][j]['arg'])
		local nullCheck				= 'None'

		-- 만약 Node3value 로�????�어 ??값이 ?�나?�도 null ?�면 null 처리
		for l =1, #(Node2Value['arg']) do
			if Node2Value['arg'][l] == 'null' then
				nullCheck = 'CheckOK';
				break;
			end
		end

		-- 개별??null 체크 ?�여; 만약 값이 TRUE?�면 null 처리;
		if ToolTipTable[count][j].nullCheck ~= 'None' then
			local nullCheckIf	= RETURN_TRUEORFALSE(ToolTipTable[count][j].nullCheck, Node2Value['arg']);
			if nullCheckIf == 'TRUE' or nullCheckIf == 'null' then
				nullCheck = 'CheckOK';
			end
		end


		if nullCheck ~= 'CheckOK' then
			WriteValue[j]			= '';

			-- CheckCase
			if ToolTipTable[count][j].CheckCase ~= 'None' then
				local CheckCaseIf	= RETURN_TRUEORFALSE(ToolTipTable[count][j].CheckCase, Node2Value['arg']);
				CheckCase[j]		= CheckCaseIf;
			else
				CheckCase[j] 		= 'TRUE';
			end

			if ToolTipTable[count][j].Value ~= 'None' then
				-- Value?� Arg�??�친??
				local tempValue 				= ToolTipTable[count][j].Value;
				for o = 1, #(Node2Value['arg']) do
					tempValue			= string.gsub(tempValue, '%[arg' .. o .. '%]', Node2Value['arg'][o]);
				end

				local ValueSource			= nil
				local GetType				= type(loadstring(tempValue));

				if GetType == 'string' then
					ValueSource					= "local Value = '[Value]'; return Value;"
				else
					ValueSource					= "local Value = [Value]; return Value;"
				end

				ValueSource					= string.gsub(ValueSource, '%[Value%]', tempValue);
				local RunSource				= assert(loadstring(ValueSource));
				local TempText2				= RunSource()

				if TempText2 == nil then
					-- ?�류가 발생
					TempText2 = '{#ff0000}Value Error'
				end

				Value[j]	= TempText2;
			else
				Value[j]	= 'None'
			end

			-- Node2.WriteValue??값이 None가 ?�닐 경우 본래 ?�던 ?�스?�로부??[Value]�?찾아 ?�이?��? ???�는??
			if ToolTipTable[count][j].WriteValue ~= 'None' and ToolTipTable[count][j].Value ~= 'None' then
				WriteValue[j]			= string.gsub(ToolTipTable[count][j].WriteValue, '%[Value%]', Value[j]);
			elseif ToolTipTable[count][j].WriteValue ~= 'None' and ToolTipTable[count][j].Value == 'None' then
				WriteValue[j]			= ToolTipTable[count][j].WriteValue;
			end

			-- Font ?�보?� ?�친??
			WriteValue[j]			= Node2Value[1] .. Node2Value[2] .. WriteValue[j] .. Node2Value[3]

			-- Node2.Value & Arg1 ~ 4??값을 WriteValue???�을 ???�도�??�다
			for o = 1, #(Node2Value['arg']) do
				WriteValue[j]		= string.gsub(WriteValue[j], '%[arg' .. o .. '%]', Node2Value['arg'][o])
			end
		else
			-- nullCheck == 'CheckOK' ?�다
			CheckCase[j]			= 'FALSE';
			WriteValue[j]			= 'null'
		end
	end

	return WriteValue, Value, CheckCase;
end


function HASIES_TOOLTIP_TABLE(IESName, ClassID)

	-- ?�차??배열??가�?IES ?�이?��? 가지�??�다
	local IESData					= imcIES.GetClassList(IESName);

	-- 초기 ?�래?��? 가지�??�다
	local Selectclass				= IESData:GetClass(ClassID);
	local Sub1ClassList				= Selectclass:GetSubClassList();				-- ?�위 SubClass�?가지�??�다
	-- Node1??몇개??Class�?가지�??�는가
	local Sub1ClassCount			= Sub1ClassList:Count();

	-- Class??�?개수??몇개 ?��?
	local IESCount					= IESData:Count();								-- 1??리턴?�다
	local NodeName					= imcIES.GetString(Selectclass, 'ClassName');	-- SkillToolTip �?가지�???것이??

	-- 배열??만들??보자
	local returnTable	= {}

	-- 기본 ?�보(Name 출력???�용??
	returnTable['NameFont']		= imcIES.GetString(Selectclass, 'NameFont');
	returnTable['ValueFont']	= imcIES.GetString(Selectclass, 'ValueFont');
	returnTable['Value']		= imcIES.GetString(Selectclass, 'Value');
	returnTable['WriteValue']	= imcIES.GetString(Selectclass, 'WriteValue');
	returnTable['Arg1']			= imcIES.GetString(Selectclass, 'Arg1');
	returnTable['Arg2']			= imcIES.GetString(Selectclass, 'Arg2');
	returnTable['Arg3']			= imcIES.GetString(Selectclass, 'Arg3');
	returnTable['Arg4']			= imcIES.GetString(Selectclass, 'Arg4');

	for i = 1, Sub1ClassCount do
		local Sub1Class					= Sub1ClassList:GetByIndex(i - 1);

		-- ?�위 리스??구조�??�어 ?�인??(Node2)
		local Sub2ClassList					= Sub1Class:GetSubClassList();		-- Node2�??�어 ?�다
		local Sub2ClassCount				= Sub2ClassList:Count();			-- Node2?�는 몇개�?가지�??�는가

		returnTable[i]							= {}
		returnTable[i]['ClassName']				= imcIES.GetString(Sub1Class, 'ClassName');
		returnTable[i]['NameFont']				= imcIES.GetString(Sub1Class, 'NameFont');
		returnTable[i]['ValueFont']				= imcIES.GetString(Sub1Class, 'ValueFont');
		returnTable[i]['Caption']				= imcIES.GetString(Sub1Class, 'Caption');
		returnTable[i]['ToolTipType']			= imcIES.GetString(Sub1Class, 'ToolTipType');
		returnTable[i]['preFix']				= imcIES.GetString(Sub1Class, 'preFix');
		returnTable[i]['sufFix']				= imcIES.GetString(Sub1Class, 'sufFix');
		returnTable[i]['joinFix']				= imcIES.GetString(Sub1Class, 'joinFix');
		returnTable[i]['TitleArg']				= imcIES.GetString(Sub1Class, 'TitleArg');
		returnTable[i]['NextLine']				= imcIES.GetString(Sub1Class, 'NextLine');

		for j = 1, Sub2ClassCount do
			local Sub2Class							= Sub2ClassList:GetByIndex(j - 1);
			returnTable[i][j]						= {};
			returnTable[i][j]['ClassName']			= imcIES.GetString(Sub2Class, 'ClassName');
			returnTable[i][j]['Value']				= imcIES.GetString(Sub2Class, 'Value');
			returnTable[i][j]['WriteValue']			= imcIES.GetString(Sub2Class, 'WriteValue');
			returnTable[i][j]['ValueFont']			= imcIES.GetString(Sub2Class, 'ValueFont');
			returnTable[i][j]['preFix']				= imcIES.GetString(Sub2Class, 'preFix');
			returnTable[i][j]['sufFix']				= imcIES.GetString(Sub2Class, 'sufFix');
			returnTable[i][j]['CheckCase']			= imcIES.GetString(Sub2Class, 'CheckCase');
			returnTable[i][j]['nullCheck']			= imcIES.GetString(Sub2Class, 'nullCheck');


			-- Node3???�??arg 값들??처리?�다
			-- ?�위 리스??구조�??�어 ?�인??(Node3)
			local Sub3ClassList					= Sub2Class:GetSubClassList();		-- Node2�??�어 ?�다
			local Sub3ClassCount				= Sub3ClassList:Count();			-- Node2?�는 몇개�?가지�??�는가
			returnTable[i][j]['arg']			= {}

			for n = 1, Sub3ClassCount do
				local Sub3Class						= Sub3ClassList:GetByIndex(n - 1);
				returnTable[i][j]['arg'][n]					= {}
				returnTable[i][j]['arg'][n]['IES']			= imcIES.GetString(Sub3Class, 'IES');
				returnTable[i][j]['arg'][n]['Column']		= imcIES.GetString(Sub3Class, 'Column');
				returnTable[i][j]['arg'][n]['SubColumn']	= imcIES.GetString(Sub3Class, 'SubColumn');
				returnTable[i][j]['arg'][n]['preFix']		= imcIES.GetString(Sub3Class, 'preFix');
				returnTable[i][j]['arg'][n]['sufFix']		= imcIES.GetString(Sub3Class, 'sufFix');
				returnTable[i][j]['arg'][n]['joinFix']		= imcIES.GetString(Sub3Class, 'joinFix');
				returnTable[i][j]['arg'][n]['joinOr']		= imcIES.GetString(Sub3Class, 'joinOr');
				returnTable[i][j]['arg'][n]['joinAnd']		= imcIES.GetString(Sub3Class, 'joinAnd');
				returnTable[i][j]['arg'][n]['MultiValue']	= imcIES.GetString(Sub3Class, 'MultiValue');
				returnTable[i][j]['arg'][n]['replace']		= imcIES.GetString(Sub3Class, 'replace');

				if returnTable[i][j]['arg'][n]['replace'] == 'YES' then
					-- Node4???�??arg 값들??처리?�다
					local Sub4ClassList					= Sub3Class:GetSubClassList();			-- Node2�??�어 ?�다
					local Sub4ClassCount				= Sub4ClassList:Count();				-- Node2?�는 몇개�?가지�??�는가
					returnTable[i][j]['arg'][n]['If']			= {}
					for w = 1, Sub4ClassCount do
						local Sub4Class							= Sub4ClassList:GetByIndex(w - 1);
						returnTable[i][j]['arg'][n]['If'][w]	= {}
						returnTable[i][j]['arg'][n]['If'][w]['Compare']			= imcIES.GetString(Sub4Class, 'Compare');
						returnTable[i][j]['arg'][n]['If'][w]['reValue']			= imcIES.GetString(Sub4Class, 'reValue');
						returnTable[i][j]['arg'][n]['If'][w]['else']			= imcIES.GetString(Sub4Class, 'else');
					end
				end
			end

		end
	end

	return returnTable;
end





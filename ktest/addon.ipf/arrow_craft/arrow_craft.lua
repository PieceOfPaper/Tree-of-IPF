function ARROW_CRAFT_ON_INIT(addon, frame)
	
	addon:RegisterMsg('CREATED_ARROW_ITEM', 'ON_NEXT_CREATE_ITEM');	
	addon:RegisterMsg('FAIL_CREATE_ARROW_ITEM', 'ON_ARROW_CRAFT_CANCEL');	
	
end

TARGET_ARROW_CRAFT_ITEM1 = 'arrow_01'
TARGET_ARROW_CRAFT_ITEM2 = 'arrow_02'
TARGET_ARROW_CRAFT_ITEM3 = 'arrow_03'
NEED_ARROW_CRAFT_ITEM1 = 'rsc_arrow_01'
NEED_ARROW_CRAFT_ITEM2 = 'rsc_arrow_02'
NEED_ARROW_CRAFT_ITEM3 = 'rsc_arrow_03'

function ARROW_CRAFT_FIRST_OPEN(frame)
	local arrowlist = GET_CHILD(frame, "arrowlist", "ui::CDropList");
	arrowlist:ClearItems();
	arrowlist:AddItem("0",  ClMsg("list_rsc_arrow_01"), 0);
	arrowlist:AddItem("1",  ClMsg("list_rsc_arrow_02"), 0);
	arrowlist:AddItem("2",  ClMsg("list_rsc_arrow_03"), 0);
	arrowlist:SelectItem(0);
	INIT_ARROW_CRAFT(frame);
end

function INIT_ARROW_CRAFT(frame)
	-- 초기화
	frame:SetUserValue("INPUT_ARROW_COUNT", '0');
	frame:SetUserValue("CREATED_ARROW_COUNT", '0');
	frame:SetUserValue("SELECT_ARROW_NAME", 'None');
	
	local arrowlist = GET_CHILD(frame, "arrowlist", "ui::CDropList");
	arrowlist:SelectItem(config.GetConfigInt("ArrowCraftType", 0));
	SHOW_ARROW_CRAFT(frame);
	local gauge = GET_CHILD(frame, "casting", "ui::CGauge");
	gauge:SetTotalTime(-1);
end

function SHOW_ARROW_CRAFT(frame)
	
	local arrowlist = GET_CHILD(frame, "arrowlist", "ui::CDropList");
	local selecIndex = arrowlist:GetSelItemIndex();
	local targetItemName = 'None';
	local needItemName = 'None';
	if selecIndex == 0 then
		targetItemName = TARGET_ARROW_CRAFT_ITEM1;
		needItemName = NEED_ARROW_CRAFT_ITEM1;
	elseif selecIndex == 1 then
		targetItemName = TARGET_ARROW_CRAFT_ITEM2;
		needItemName = NEED_ARROW_CRAFT_ITEM2;
	elseif selecIndex == 2 then
		targetItemName = TARGET_ARROW_CRAFT_ITEM3;
		needItemName = NEED_ARROW_CRAFT_ITEM3;
	end
	
	local slot1 = GET_CHILD(frame, "invItem", "ui::CSlot");
	if slot1 ~= nil then

		local invItemList = session.GetInvItemList();
		local index = invItemList:Head();
		local itemCount = session.GetInvItemList():Count();

		for i = 0, itemCount - 1 do

			local invItem			= invItemList:Element(index);

			if invItem ~= nil then
				local itemobj = GetIES(invItem:GetObject());
				if itemobj.ClassName == needItemName then
				
					SET_SLOT_INVITEM(slot1, invItem);
					break;
				end
			end

			index = invItemList:Next(index);
		end

	end

	local itemCls = GetClass("Item", targetItemName);
	local slot2 = GET_CHILD(frame, "targetItem", "ui::CSlot");
	if itemCls ~= nil and slot2 ~= nil then
		SET_SLOT_ITEM_CLS(slot2, itemCls);
		SET_SLOT_COUNT_TEXT(slot2, 1);
	end
end


function ARROW_TYPE_CHANGE(frame, ctrl)
	local list = tolua.cast(ctrl, "ui::CDropList");
	config.SetConfig("ArrowCraftType", list:GetSelItemIndex());
	SHOW_ARROW_CRAFT(frame);	
end

function ON_NEXT_CREATE_ITEM(frame, msg, str, num)
	local itemName = frame:GetUserValue("SELECT_ARROW_NAME");
	
	if itemName == str then
		SHOW_ARROW_CRAFT(frame);
		local inputCount = tonumber( frame:GetUserValue("INPUT_ARROW_COUNT") );
		local createdCount = tonumber( frame:GetUserValue("CREATED_ARROW_COUNT") );
		createdCount = createdCount + 1;
		frame:SetUserValue("CREATED_ARROW_COUNT", createdCount);
	
		if inputCount > createdCount then				
			EXE_CREATE_ARROW_CRAFT(frame, itemName);

		elseif inputCount == createdCount then
			INIT_ARROW_CRAFT(frame);
		end
	end
end

function EXE_CREATE_ARROW_CRAFT(frame, itemName)

	-- 만들수있는지 수량 체크


	
	item.ReqCreateArrowCraft(itemName);

	-- 게이지 연출
	local createtime = 5.0;
	local gauge = GET_CHILD(frame, "casting", "ui::CGauge");
	gauge:SetTotalTime(createtime);	
end

function ON_ARROW_CRAFT_CANCEL(frame, msg, str, num)
	INIT_ARROW_CRAFT(frame);
end

function CANCEL_ARROW_CRAFT(frame)
	INIT_ARROW_CRAFT(frame);
	item.ReqCancelArrowCraft();
end

function CREATE_ARROW_CRAFT_ONE(frame)

	frame:SetUserValue("INPUT_ARROW_COUNT", 1);
	CREATE_ARROW_CRAFT(frame);
end

function CREATE_ARROW_CRAFT_ALL(frame)

	frame:SetUserValue("INPUT_ARROW_COUNT", 9999);
	CREATE_ARROW_CRAFT(frame);
end

function CREATE_ARROW_CRAFT(frame)
	local arrowlist = GET_CHILD(frame, "arrowlist", "ui::CDropList");
	local selecIndex = arrowlist:GetSelItemIndex();

	local itemName = 'None';
	if selecIndex == 0 then
		itemName = TARGET_ARROW_CRAFT_ITEM1;
	elseif selecIndex == 1 then
		itemName = TARGET_ARROW_CRAFT_ITEM2;
	elseif selecIndex == 2 then
		itemName = TARGET_ARROW_CRAFT_ITEM3;
	end
	
	if itemName ~= 'None' then
		frame:SetUserValue("SELECT_ARROW_NAME", itemName);
		frame:SetUserValue("CREATED_ARROW_COUNT", '0');
		EXE_CREATE_ARROW_CRAFT(frame, itemName);
	end
end
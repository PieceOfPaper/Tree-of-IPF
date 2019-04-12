

function INIT_KEYCONFIG_CATEGORY(tree, cateName, imgName)

	local mouse = GET_CHILD(tree, cateName);
	local img = GET_CHILD(mouse, "img");
	img:SetImage(imgName);
	
	local handle = tree:FindByObject(mouse);
	
	tree:SetFitToChild(true,50);
	tree:SetFoldingScript(handle, "KEYCONFIG_UPDATE_FOLDING");

end

function KEYCONFIG_UPDATE_KEY_TEXT(txt_key)

	local useShift = txt_key:GetUserValue("UseShift");
	local useAlt = txt_key:GetUserValue("UseAlt");
	local useCtrl = txt_key:GetUserValue("UseCtrl");
	local key = txt_key:GetUserValue("Key");
	local pressedKey = txt_key:GetUserValue("PressedKey");
	
	local txt = "";
	if useShift == "YES" then
		txt = txt .. "SHIFT + ";
	end

	if useAlt == "YES" then
		txt = txt .. "ALT + ";
	end

	if useCtrl == "YES" then
		txt = txt .. "CTRL + ";
	end

	if pressedKey ~= "None" and pressedKey ~= "" then
		txt = txt .. pressedKey .." + ";
	end

	txt = txt .. key;
	txt_key:SetTextByKey("value", txt);
	
end
function KEYCONFIG_RESTORE_KEY_TEXT(txt_key)
	local parent = txt_key:GetParent();
	local id = parent:GetUserValue("ID");
	local idx = config.GetHotKeyElementIndex("ID", id);

	local useShift = config.GetHotKeyElementAttributeForConfig(idx, "UseShift");
	local useAlt = config.GetHotKeyElementAttributeForConfig(idx, "UseAlt");
	local useCtrl = config.GetHotKeyElementAttributeForConfig(idx, "UseCtrl");
	local key = config.GetHotKeyElementAttributeForConfig(idx, "Key");
	
	txt_key:SetUserValue("UseShift", useShift);
	txt_key:SetUserValue("UseAlt", useAlt);
	txt_key:SetUserValue("UseCtrl", useCtrl);
	txt_key:SetUserValue("Key", key);	
	
	KEYCONFIG_UPDATE_KEY_TEXT(txt_key);
end
function KEYCONFIG_OPEN_CATEGORY(frame, fileName, category)

	frame:SetUserValue("FILENAME", fileName);
	local bg_key = GET_CHILD(frame, "bg_key");
	local bg_keylist = GET_CHILD(bg_key, "bg_keylist");
	bg_keylist:RemoveAllChild();

	local joyStickMode;
	if string.find(fileName, "joystick") ~= nil then
		joyStickMode = true;
	else
		joyStickMode = false;
	end

	local cnt = config.CreateHotKeyElementsForConfig(fileName, category);

	for i = 0 , cnt - 1 do
		local id = config.GetHotKeyElementAttributeForConfig(i, "ID");
		local key = config.GetHotKeyElementAttributeForConfig(i, "Key");
		local useShift = config.GetHotKeyElementAttributeForConfig(i, "UseShift");
		local useAlt = config.GetHotKeyElementAttributeForConfig(i, "UseAlt");
		local useCtrl = config.GetHotKeyElementAttributeForConfig(i, "UseCtrl");
		local ctrlSet = bg_keylist:CreateControlSet("keyconfig_right", "KEY_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);
		ctrlSet:SetUserValue("ID", id);

		local txt_actionname = GET_CHILD(ctrlSet, "txt_actionname");

		txt_actionname:SetTextByKey("value", GET_HOTKEY_TITLE_STR(id));

		local txt_key = GET_CHILD(ctrlSet, "txt_key");
		txt_key:SetUserValue("Key", key);

		if joyStickMode == true then
			local pressedKey = config.GetHotKeyElementAttributeForConfig(i, "PressedKey");
			txt_key:SetUserValue("PressedKey", pressedKey);
		end

		txt_key:SetUserValue("UseShift", useShift);
		txt_key:SetUserValue("UseAlt", useAlt);
		txt_key:SetUserValue("UseCtrl", useCtrl);
		KEYCONFIG_UPDATE_KEY_TEXT(txt_key);

	end

	GBOX_AUTO_ALIGN(bg_keylist, 0, 0, 0, true, true);
	bg_key:UpdateData();
	
end

function KEYCONFIG_EDIT_START(parent, ctrl, str, num)

	local frame = parent:GetTopParentFrame();
	if frame:HaveUpdateScript("KEYCONFIG_CHECKING_INPUT") == true then
		KEYCONFIG_END_INPUT(frame);		
	end

	KEYCONFIG_SAVE_INPUT(frame);

	frame:SetUserValue("EDITING", "YES");
	local hotkeyID = parent:GetUserValue("ID");
	frame:SetUserValue("EXIT_TIME", imcTime.GetAppTime() + 2.0);
	frame:RunUpdateScript("KEYCONFIG_CHECKING_INPUT", 0, 0, 0, 1);
	frame:SetUserValue("ID", hotkeyID);
	keyboard.EnableHotKey(false);

	ctrl:SetUserValue("Key", "");
	ctrl:SetUserValue("PressedKey", "");
	ctrl:SetUserValue("UseShift", "NO");
	ctrl:SetUserValue("UseAlt", "NO");
	ctrl:SetUserValue("UseCtrl", "NO");

	ctrl:SetSkinName("baseyellow_btn");
	
	KEYCONFIG_UPDATE_KEY_TEXT(ctrl);

	

end

function KEYCONFIG_SAVE_INPUT(frame)
	if frame:GetUserValue("EDITING") ~= "YES" then
		return;
	end

	frame:SetUserValue("EDITING", "NO");

	local id = frame:GetUserValue("ID");
	local bg_key = GET_CHILD(frame, "bg_key");
	local bg_keylist = GET_CHILD(bg_key, "bg_keylist");
	local ctrlSet = GET_CHILD_BY_USERVALUE(bg_keylist, "ID", id);
	if ctrlSet ~= nil then

		local fileName = frame:GetUserValue("FILENAME");
		local joyStickMode;
		if string.find(fileName, "joystick") ~= nil then
			joyStickMode = true;
		else
			joyStickMode = false;
		end

		local idx = config.GetHotKeyElementIndex("ID", id);
		
		local txt_key = GET_CHILD(ctrlSet, "txt_key");

		local useShift = txt_key:GetUserValue("UseShift");
		local useAlt = txt_key:GetUserValue("UseAlt");
		local useCtrl = txt_key:GetUserValue("UseCtrl");
		local key = txt_key:GetUserValue("Key");        
		if key == "" then
			KEYCONFIG_RESTORE_KEY_TEXT(txt_key);
			return;
		end

		config.SetHotKeyElementAttributeForConfig(idx, "Key", key);
		if joyStickMode == true then
			local pressedKey = txt_key:GetUserValue("PressedKey");
			config.SetHotKeyElementAttributeForConfig(idx, "PressedKey", pressedKey);
		end
		config.SetHotKeyElementAttributeForConfig(idx, "UseAlt", useAlt);
		config.SetHotKeyElementAttributeForConfig(idx, "UseCtrl", useCtrl);
		config.SetHotKeyElementAttributeForConfig(idx, "UseShift", useShift);	
		
		KEYCONFIG_UPDATE_KEY_TEXT(txt_key);
		config.SaveHotKey(fileName);
		
		KEYCONFIG_ALERT_DUPLICATED_KEY(frame, id);
	end
end

function KEYCONFIG_ALERT_DUPLICATED_KEY(frame, newKey_id)
	if frame == nil or newKey_id == nil then
		return;
	end

	local fileName =  frame:GetUserValue("FILENAME");
	local currentCategory = frame:GetUserValue("CATEGORY");
	if fileName == nil or currentCategory == nil then
		return;
	end

	local newKey = {}
	newKey.id = newKey_id;
	newKey.idx = config.GetHotKeyElementIndex("ID", newKey_id);
	newKey.useShift = config.GetHotKeyElementAttributeForConfig(newKey.idx, "UseShift");
	newKey.useAlt = config.GetHotKeyElementAttributeForConfig(newKey.idx, "UseAlt");
	newKey.useCtrl = config.GetHotKeyElementAttributeForConfig(newKey.idx, "UseCtrl");
	newKey.key = config.GetHotKeyElementAttributeForConfig(newKey.idx, "Key");

	local result = false;
	result = KEYCONFIG_ALERT_DUPLICATED_KEY_IN_CATEGORY(fileName, "BASIC", newKey)
	
	if result == false then
		result = KEYCONFIG_ALERT_DUPLICATED_KEY_IN_CATEGORY(fileName, "BATTLE", newKey)
	end
	
	if result == false then
		result = KEYCONFIG_ALERT_DUPLICATED_KEY_IN_CATEGORY(fileName, "SYSTEM", newKey)
	end

	config.CreateHotKeyElementsForConfig(fileName, currentCategory);
end

function KEYCONFIG_ALERT_DUPLICATED_KEY_IN_CATEGORY(fileName, category, newKey)
	if fileName == nil or category == nil or newKey == nil then
		return false;
	end

	if newKey.id == nil or newKey.idx == nil or newKey.useShift == nil or newKey.useAlt == nil or newKey.useCtrl == nil or newKey.key == nil then
		return false;
	end
	
	local count = config.CreateHotKeyElementsForConfig(fileName, category);
	if count <= 0 then
		return false;
	end
	for keyIDX = 0, count -1 do
		local id = config.GetHotKeyElementAttributeForConfig(keyIDX, "ID");
		if newKey.id ~= id then
			local useShift = config.GetHotKeyElementAttributeForConfig(keyIDX, "UseShift");
			local useAlt = config.GetHotKeyElementAttributeForConfig(keyIDX, "UseAlt");
			local useCtrl = config.GetHotKeyElementAttributeForConfig(keyIDX, "UseCtrl");
			local key = config.GetHotKeyElementAttributeForConfig(keyIDX, "Key");
	
			if newKey.key == key and newKey.useShift == useShift and newKey.useAlt == useAlt and newKey.useCtrl == useCtrl then
				local name_new = GET_HOTKEY_TITLE_STR(newKey.id)
				local name = GET_HOTKEY_TITLE_STR(id)
				local keyCombination = ""
				if useCtrl == "YES" then
					keyCombination = keyCombination .. "Ctrl + "
				end				
				if useAlt == "YES" then
					keyCombination = keyCombination .. "Alt + "
				end				
				if useShift == "YES" then
					keyCombination = keyCombination .. "Shift + "
				end				
				keyCombination = keyCombination .. key;

				ui.SysMsg(ScpArgMsg("AlertDuplicatedKeys{Key1}And{Key2}Are{Key}", "Key1", name_new, "Key2", name, "Key", keyCombination));
				return true;
			end
		end
	end	
	return false;
end

function KEYCONFIG_END_INPUT(frame)

		keyboard.EnableHotKey(true);
		KEYCONFIG_SAVE_INPUT(frame);

		local id = frame:GetUserValue("ID");
		local bg_key = GET_CHILD(frame, "bg_key");
		local bg_keylist = GET_CHILD(bg_key, "bg_keylist");
		local ctrlSet = GET_CHILD_BY_USERVALUE(bg_keylist, "ID", id);
		if ctrlSet ~= nil then
			local txt_key = GET_CHILD(ctrlSet, "txt_key");
			txt_key:SetSkinName("base_btn");
		end

		if string.find(id, "QuickSlotExecute") ~= nil then
			local quickSlotFrame = ui.GetFrame("quickslotnexpbar");
			QUICKSLOTNEXPBAR_UPDATE_HOTKEYNAME(quickSlotFrame);
			quickSlotFrame:Invalidate();
		end

end

function KEYCONFIG_CHECKING_INPUT(frame)

	local fileName = frame:GetUserValue("FILENAME");

	local exitTime = tonumber(frame:GetUserValue("EXIT_TIME"));
	if imcTime.GetAppTime() > exitTime then
		KEYCONFIG_END_INPUT(frame);
		return 0;
	end
	 
	 local downKey = nil;
	 local joyStickMode;
	 if string.find(fileName, "joystick") ~= nil then
		downKey = joystick.GetDownJoyStickBtn();
		joyStickMode = true;
	 else
		downKey = keyboard.GetDownKey();
		joyStickMode = false;
	 end

	local id = frame:GetUserValue("ID");
	if downKey ~= nil then
		
		local bg_key = GET_CHILD(frame, "bg_key");
		local bg_keylist = GET_CHILD(bg_key, "bg_keylist");
		local ctrlSet = GET_CHILD_BY_USERVALUE(bg_keylist, "ID", id);
		if ctrlSet ~= nil then
			local txt_key = GET_CHILD(ctrlSet, "txt_key");
			
			local normalKey = true;
			if downKey == "LALT" or downKey == "RALT" then
				txt_key:SetUserValue("UseAlt", "YES");
				normalKey = false;
			end

			if downKey == "LCTRL" or downKey == "RCTRL" then
				txt_key:SetUserValue("UseCtrl", "YES");
				normalKey = false;
			end

			if downKey == "LSHIFT" or downKey == "RSHIFT" then
				txt_key:SetUserValue("UseShift", "YES");
				normalKey = false;
			end

			if joyStickMode == true then
				local curValue = txt_key:GetUserValue("Key");
				local curPressedKey = txt_key:GetUserValue("PressedKey");
				if curValue ~= "" and (curPressedKey == "" or curPressedKey == "None") then
					txt_key:SetUserValue("PressedKey", curValue);
				end

				txt_key:SetUserValue("Key", downKey);
			else
				if normalKey == true then
					txt_key:SetUserValue("Key", downKey);
				end
			end

			
			
			

			KEYCONFIG_UPDATE_KEY_TEXT(txt_key);
		end
	end

	return 1;
end

function KEYCONFIG_UPDATE_FOLDING(ctrl, isOpened)

	local foldimg = GET_CHILD(ctrl, "foldimg");
	if isOpened == 1 then
		foldimg:SetImage("spreadclose");
	else
		foldimg:SetImage("viewunfold");
	end	
	
end

function KEYCONFIG_INSERT_CATEGORY_ITEM(tree, childName, title, fileName, category)
	local htreeitem = tree:FindByName(childName);
	local key = fileName .. "#" .. category;
	tree:Add(htreeitem, "{@st42b}" .. ScpArgMsg(title), key, "{#000000}");
end

function KEYCONFIG_TREE_CLICK(parent, ctrl, str, num)

	local tree = AUTO_CAST(ctrl);
	local tnode = tree:GetLastSelectedNode();
	if tnode == nil then
		return;
	end

	local selValue = tnode:GetValue();
	local sList = StringSplit(selValue, "#");
	if #sList ~= 2 then
		return;
	end

	local fileName = sList[1];
	local categoryName = sList[2];

	local frame = parent:GetTopParentFrame();
	frame:SetUserValue("FILENAME", fileName);
	frame:SetUserValue("CATEGORY", categoryName);
	KEYCONFIG_OPEN_CATEGORY(frame, fileName, categoryName);
	
end

function OPEN_KEYCONFIG(frame)
	local tree = GET_CHILD(frame, "tree");

	INIT_KEYCONFIG_CATEGORY(tree, "keyboard", "keyboard_img");
	INIT_KEYCONFIG_CATEGORY(tree, "mouse", "mouse_img");
	INIT_KEYCONFIG_CATEGORY(tree, "joypad", "joypad_img");
	
	KEYCONFIG_INSERT_CATEGORY_ITEM(tree, "keyboard", "DefaultMove", "hotkey.xml", "Basic");
	KEYCONFIG_INSERT_CATEGORY_ITEM(tree, "keyboard", "Battle", "hotkey.xml", "Battle");
	KEYCONFIG_INSERT_CATEGORY_ITEM(tree, "keyboard", "SystemMenu", "hotkey.xml", "System");
	
	KEYCONFIG_INSERT_CATEGORY_ITEM(tree, "mouse", "DefaultMove", "hotkey_mousemode.xml", "Basic");
	KEYCONFIG_INSERT_CATEGORY_ITEM(tree, "mouse", "Battle", "hotkey_mousemode.xml", "Battle");
	KEYCONFIG_INSERT_CATEGORY_ITEM(tree, "mouse", "SystemMenu", "hotkey_mousemode.xml", "System");

	-- KEYCONFIG_INSERT_CATEGORY_ITEM(tree, "joypad", "Battle", "hotkey_joystick.xml", "Basic");
	-- KEYCONFIG_INSERT_CATEGORY_ITEM(tree, "joypad", "Battle", "hotkey_joystick.xml", "Battle");
	-- KEYCONFIG_INSERT_CATEGORY_ITEM(tree, "joypad", "Battle", "hotkey_joystick.xml", "System");

	tree:OpenNodeAll();
end

function CLOSE_KEYCONFIG(frame)
	keyboard.EnableHotKey(true);
end

function GET_HOTKEY_TITLE_STR(id)
	
	local digitIndex = GetDigitIndex(id);
	if digitIndex ~= -1 then
		local name = string.sub(id, 1, digitIndex);
		local digit = string.sub(id, digitIndex + 1, string.len(id));
		
		if IsExistMsg(name) == 1 then
			return ClMsg(name) .. " " .. digit;
		else
			return name .. " " .. digit;
		end
	else
		if IsExistMsg(id) == 1 then
			return ClMsg(id);
		else
			return id;
		end
	end
	
end

function KEYCONFIG_RESTORE_DEFAULT(parent)

	local frame = parent:GetTopParentFrame();
	local bg_key = GET_CHILD(frame, "bg_key");
	local bg_keylist = GET_CHILD(bg_key, "bg_keylist");
	bg_keylist:RemoveAllChild();	

	config.RestoreHotKey("hotkey.xml");
	config.RestoreHotKey("hotkey_mousemode.xml");
	config.RestoreHotKey("hotkey_joystick.xml");
	ReloadHotKey();
	


	
	
end





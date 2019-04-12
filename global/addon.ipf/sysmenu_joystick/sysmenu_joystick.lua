function SYSMENU_JOYSTICK_ON_INIT(addon, frame)
	addon:RegisterMsg("SYSMENU_CHANGED", 'SYSMENU_JOYSTICK_ON_MSG');
	addon:RegisterMsg("SYSMENU_JOYSTICK_OPEN", 'SYSMENU_JOYSTICK_OPEN');
	addon:RegisterMsg("SYSMENU_JOYSTICK_CLOSE", 'SYSMENU_JOYSTICK_CLOSE');
	addon:RegisterMsg("SYSMENU_JOYSTICK_ROLL_LEFT", 'SYSMENU_JOYSTICK_MOVE_LEFT');
	addon:RegisterMsg("SYSMENU_JOYSTICK_ROLL_RIGHT", 'SYSMENU_JOYSTICK_MOVE_RIGHT');
	
----------------------------------------------------------------------
-- 전역 변수 
----------------------------------------------------------------------
	CURRENT_OFFSET = 0;
----------------------------------------------------------------------
	SYSMENU_JOYSTICK_CLOSE();
end

function SYSMENU_JOYSTICK_ON_MSG()
	if SYSMENU_JOYSTICK_IS_OPENED() == 1 then
		--SYSMENU_JOYSTICK_ROLL_RESTORE();
		SYSMENU_JOYSTICK_LOAD();
	end
end

 function SYSMENU_JOYSTICK_LOAD_PIC(pic, button)
	if pic == nil or button == nil then
		return;
	end
	pic = tolua.cast(pic, pic:GetClassString());
	button = tolua.cast(button, "ui::CButton");

	pic:SetImage(button:GetImageName());

	if pic:GetName() == 'slot_center' then
		pic:SetEventScript(ui.LBUTTONUP, button:GetEventScript(ui.LBUTTONUP));
	end
 end

function SYSMENU_JOYSTICK_LOAD()
	local frame = ui.GetFrame("sysmenu_joystick");
	local sysmenu = ui.GetFrame('sysmenu');
	if sysmenu == nil then
		return;
	end

	local buttonTable = GET_SYSMENU_BUTTONS();
	
	local sideCount=3;
	for side = 1, sideCount do
		SYSMENU_JOYSTICK_LOAD_PIC(frame:GetChild('slot_left' .. side), GET_SYSMENU_BUTTON_BY_INDEX(CURRENT_OFFSET - side, buttonTable));
		SYSMENU_JOYSTICK_LOAD_PIC(frame:GetChild('slot_right' .. side), GET_SYSMENU_BUTTON_BY_INDEX(CURRENT_OFFSET + side, buttonTable));
	end
	SYSMENU_JOYSTICK_LOAD_PIC(frame:GetChild('slot_center'), GET_SYSMENU_BUTTON_BY_INDEX(CURRENT_OFFSET, buttonTable));
	SYSMENU_JOYSTICK_LOAD_TEXT();
end

function SYSMENU_JOYSTICK_LOAD_TEXT()
	local frame = ui.GetFrame("sysmenu_joystick");
	local menuText = GET_CHILD(frame, "menu_text", "ui::CRichText");
	local tooltip = GET_SYSMENU_BUTTON_BY_INDEX(CURRENT_OFFSET):GetTooltipStrArg();
	menuText:SetTextByKey("text",  tooltip);
end

function SYSMENU_JOYSTICK_MOVE_PIC(pic, width, direction)
	if pic ~= nil then
		if direction == 'left' or direction == 'LEFT' then
			pic:Move(-1*width, 0);
		elseif direction == 'right' or direction == 'RIGHT' then
			pic:Move(width, 0);
		end
	end
end
function SYSMENU_JOYSTICK_ROLL(direction)
	local frame = ui.GetFrame("sysmenu_joystick");
	local centerWidth = 60;
	local width = 55;
	
	if direction == 'left' or direction == 'LEFT' then
		SYSMENU_JOYSTICK_MOVE_PIC(frame:GetChild('slot_right1'), centerWidth-width, direction);
	elseif direction == 'right' or direction == 'RIGHT' then
		SYSMENU_JOYSTICK_MOVE_PIC(frame:GetChild('slot_left1'), centerWidth-width, direction);
	else
		return;
	end

	SYSMENU_JOYSTICK_MOVE_PIC(frame:GetChild('slot_center'), centerWidth, direction);
	local sideCount=3;
	for side = 1, sideCount do
		SYSMENU_JOYSTICK_MOVE_PIC(frame:GetChild("slot_left" .. side), width, direction);
		SYSMENU_JOYSTICK_MOVE_PIC(frame:GetChild("slot_right" .. side), width, direction);
	end

end
function SYSMENU_JOYSTICK_ROLL_LEFT()
	SYSMENU_JOYSTICK_ROLL('left');
end
function SYSMENU_JOYSTICK_ROLL_RIGHT()
	SYSMENU_JOYSTICK_ROLL('right');
end
-- sysmenu의 버튼을 읽어와서 순서맞춰서 table반환. 0이 status.
function GET_SYSMENU_BUTTONS()
	local sysmenu = ui.GetFrame("sysmenu");
	local indexTable = {};

	-- sysmenu의 원래 자식 갯수. 그리고 alarmqueue 건너뜀.
	for i=0, 11 do
		indexTable[i] = sysmenu:GetChildByIndex(i);
	end
	
	index = 12;
	for i=sysmenu:GetChildCount()-1, index, -1 do
		indexTable[index] = sysmenu:GetChildByIndex(i);
		index = index+1;
	end
	return indexTable;
end

function GET_SYSMENU_BUTTON_BY_INDEX(index, buttonTable)

	if buttonTable == nil then
		buttonTable = GET_SYSMENU_BUTTONS();
	end
	
	local modIndex = index % #buttonTable;

	return buttonTable[modIndex];	
end

function SYSMENU_JOYSTICK_MOVE(direction)
	local frame = ui.GetFrame("sysmenu_joystick");

	if direction == 'left' or direction == 'LEFT' then
		CURRENT_OFFSET = CURRENT_OFFSET-1;
	elseif direction == 'right' or direction == 'RIGHT' then
		CURRENT_OFFSET = CURRENT_OFFSET+1;
	else
		return;
	end
	
	local sideCount=3;
	for side = 1, sideCount do
		SYSMENU_JOYSTICK_LOAD_PIC(frame:GetChild("slot_left" .. side), GET_SYSMENU_BUTTON_BY_INDEX(CURRENT_OFFSET - side, buttonTable));
		SYSMENU_JOYSTICK_LOAD_PIC(frame:GetChild("slot_right" .. side), GET_SYSMENU_BUTTON_BY_INDEX(CURRENT_OFFSET + side, buttonTable));
	end	
	SYSMENU_JOYSTICK_LOAD_PIC(frame:GetChild("slot_center"), GET_SYSMENU_BUTTON_BY_INDEX(CURRENT_OFFSET, buttonTable));
	SYSMENU_JOYSTICK_LOAD_TEXT()
end
function SYSMENU_JOYSTICK_MOVE_LEFT()
	SYSMENU_JOYSTICK_MOVE('left');
end
function SYSMENU_JOYSTICK_MOVE_RIGHT()
	SYSMENU_JOYSTICK_MOVE('right');
end

function SYSMENU_JOYSTICK_ROLL_RESTORE_PIC(picture)
	if picture ~= nil then
		picture:SetPos(picture:GetOriginalX(), picture:GetOriginalY());
		picture:SetScale(picture:GetOriginalWidth(), picture:GetOriginalHeight());
	end	
end
function SYSMENU_JOYSTICK_ROLL_RESTORE()
	local frame = ui.GetFrame("sysmenu_joystick");

	local sideCount=3;
	for side = 1, sideCount do
		SYSMENU_JOYSTICK_ROLL_RESTORE_PIC(frame:GetChild("slot_left" .. side));
		SYSMENU_JOYSTICK_ROLL_RESTORE_PIC(frame:GetChild("slot_right" .. side));
	end
	SYSMENU_JOYSTICK_ROLL_RESTORE_PIC(frame:GetChild("slot_center"));
end

function SYSMENU_JOYSTICK_TEST()
	
end

function SYSMENU_JOYSTICK_OPEN()
	if IsJoyStickMode() == 0 then
		return;
	end

	SYSMENU_JOYSTICK_LOAD()

	local frame = ui.GetFrame("sysmenu_joystick");
	ui.OpenFrame("sysmenu_joystick");
end

function SYSMENU_JOYSTICK_CLOSE()
	ui.CloseFrame("sysmenu_joystick");
end

function SYSMENU_JOYSTICK_IS_OPENED()
	local frame = ui.GetFrame("sysmenu_joystick");
	return frame:IsVisible();
end
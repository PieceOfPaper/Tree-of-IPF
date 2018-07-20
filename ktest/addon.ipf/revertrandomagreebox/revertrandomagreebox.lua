-- revertrandomagreebox.lua

function REVERTRANDOM_AGREEBOX_ON_INIT(addon, frame)
	addon:RegisterMsg("DO_OPEN_REVERTRANDOM_AGREEBOX_UI", "REVERTRANDOM_AGREEBOX_FRAME_OPEN");
end

function REVERTRANDOM_AGREEBOX_FRAME_OPEN(clmsg, obj, yesScp, argStr)
	ui.OpenFrame("revertrandomagreebox")
	
	local frame = ui.GetFrame('revertrandomagreebox')	
	local gBox = GET_CHILD_RECURSIVELY(frame, "randomGbox")
	DESTROY_CHILD_BYNAME(gBox, "PROPERTY_CSET_")
	local randomtext = GET_CHILD_RECURSIVELY(frame, "randomtext")
	randomtext:SetText(clmsg)

	local selectGboxName = "bodyGbox1_1"

	if argStr == "Yes" then
		selectGboxName = "bodyGbox2_1"
	end

	local itemRevertRandomFrame = ui.GetFrame('itemrevertrandom')
	if itemRevertRandomFrame == nil then
		return
	end

	local selectGbox = GET_CHILD_RECURSIVELY(itemRevertRandomFrame, selectGboxName)
	if selectGbox == nil then
		return
	end

	local index = 1
	for i = 1 , MAX_RANDOM_OPTION_COUNT do
		local optionControlSet = selectGbox:GetControlSet('eachproperty_in_itemrandomreset', 'PROPERTY_CSET_'..i);
		if optionControlSet ~= nil then
			local msgGbox = GET_CHILD_RECURSIVELY(frame, "randomGbox")
			local msgboxControlset = msgGbox:CreateOrGetControlSet('eachproperty_in_itemrandomreset', 'PROPERTY_CSET_'..index, 0, 0);
			msgboxControlset = AUTO_CAST(msgboxControlset)
			local pos_y = msgboxControlset:GetUserConfig("POS_Y")
			msgboxControlset:Move(0, index * pos_y)
			
			local optionText = GET_CHILD_RECURSIVELY(optionControlSet, "property_name", "ui::CRichText")
			local optionStr = optionText:GetText()

			local msgboxOptionText = GET_CHILD_RECURSIVELY(msgboxControlset, "property_name", "ui::CRichText");
			msgboxOptionText:SetText(optionStr)
			index = index + 1
		end
	end


	local yesBtn = GET_CHILD_RECURSIVELY(frame, "yes")
	tolua.cast(yesBtn, "ui::CButton");

	yesBtn:SetEventScript(ui.LBUTTONUP, yesScp);
	yesBtn:SetEventScriptArgString(ui.LBUTTONUP, argStr);

	local noBtn = GET_CHILD_RECURSIVELY(frame, "no")
	tolua.cast(noBtn, "ui::CButton");

	noBtn:SetEventScript(ui.LBUTTONUP, "REVERTRANDOM_AGREEBOX_FRAME_CLOSE");

end

function _REVERTRANDOM_AGREEBOX_FRAME_OPEN_YES(parent, ctrl, argStr, argNum)
	ITEMREVERTRANDOM_SEND_ANSWER("Yes")
	ui.CloseFrame("revertrandomagreebox")
end


function _REVERTRANDOM_AGREEBOX_FRAME_OPEN_NO(parent, ctrl, argStr, argNum)
	ITEMREVERTRANDOM_SEND_ANSWER("No")
	ui.CloseFrame("revertrandomagreebox")
end

function REVERTRANDOM_AGREEBOX_FRAME_CLOSE(frame)
	ui.CloseFrame("revertrandomagreebox")
end




function POST_BOX_MESSAGE_COUNT()

	local frame = ui.GetFrame("barrack_exit");
	if frame == nil then
		return;
	end

	local postbox = GET_CHILD(frame, "postbox");
	local postbox_new = GET_CHILD(frame, "postbox_new");


	local cnt = session.postBox.GetMessageCount();

	local drawnewicon = false

	for i = 0 , cnt - 1 do

		local msgInfo = session.postBox.GetMessageByIndex(i);
		if msgInfo ~= nil then
			if msgInfo:GetItemCount() > 0 and msgInfo:GetItemTakeCount() == 0 then
				drawnewicon = true
				break;
			end
		end
	end


	if drawnewicon == true then
		postbox_new:ShowWindow(1);
	else
		postbox_new:ShowWindow(0);
	end


end

function OPEN_BARRACK_POSTBOX(parent, ctrl)

	ui.OpenFrame("postbox");

end


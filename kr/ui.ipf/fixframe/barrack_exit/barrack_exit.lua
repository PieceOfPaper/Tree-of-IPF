

function POST_BOX_MESSAGE_COUNT(count)

  local frame = ui.GetFrame("barrack_exit");
  if frame == nil then
		return;
  end

  local postbox = GET_CHILD(frame, "postbox");
  local postbox_new = GET_CHILD(frame, "postbox_new");
  if count > 0 then
		postbox_new:ShowWindow(1);
	end


end

function OPEN_BARRACK_POSTBOX(parent, ctrl)

	ui.OpenFrame("postbox");

end


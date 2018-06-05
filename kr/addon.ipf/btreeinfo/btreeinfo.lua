


function BTREEINFO_ON_INIT(addon)

	
end

function OPEN_BTREE(frame)

	
end

function CLOSE_BTREEINFO(frame)

	local handle = frame:GetValue();
	local chatStr = string.format( "//stopscp TEST_BTREE %d", handle);
	ui.Chat(chatStr);

	chatStr = string.format( "ui.Chat(\"//runscp UIOpenToPC %s 0\")", frame:GetName());	
	ReserveScript(chatStr, 0.5);
	
	frame:ShowWindow(0);

end

function UPDATE_BTREE(frame, info, handle)

	frame:SetValue(handle);
	frame:SetTitleName("{@st44}" .. info:GetScpName());
	frame:ShowWindow(1);
	local gbox = GET_CHILD(frame, "gbox", "ui::CGroupBox");
	gbox:DeleteAllControl();
	local list = info.childList;
	local width = gbox:GetWidth() * (list:Count() - 0.5) / list:Count();
	local depth = 0;
	CREATE_BTREE_NODES(gbox, 10, width, list, "_BL_", depth);
	
end

function CREATE_BTREE_NODES(gbox, startX, width, list, depthName, depth)

	local cnt = list:Count();
	if cnt == 0 then
		return;
	end
	
	local xwidth = width / cnt;
	local height = ui.GetControlSetAttribute('btree', 'height') + 5;

	for i = 0, cnt - 1 do
		local btinfo = list:Element(i);
		local x = startX + xwidth * i;
		local ctrlX = x + xwidth * 0.5;
		local childName = depthName .. "_" .. i;
		local ctrl = gbox:CreateControlSet("btree", childName, ctrlX, 10 + depth * height);
		BTREE_SET_NODE(ctrl, btinfo);
				
		CREATE_BTREE_NODES(gbox, x, xwidth, btinfo.childList, childName, depth + 1);
	end
end

function BTREE_SET_NODE(ctrlset, btinfo)

	local btreeicon = GET_CHILD(ctrlset, "btreeicon", "ui::CPicture");
	btreeicon:SetTextTooltip(btinfo:GetScpName());
	local state = btinfo:GetState();
	
	local colorTone = "FFFFFFFF";
	if state == BT_SUCCESS then
		colorTone = "FF0000FF"
	elseif state == BT_FAILED then
		colorTone = "FFFF0000"
	elseif state == BT_RUNNING then
		colorTone = "FFFFFF00"
	elseif state == BT_READY then
		colorTone = "FF00FF00"
	end
	
	btreeicon:SetColorTone(colorTone);
	
	

end









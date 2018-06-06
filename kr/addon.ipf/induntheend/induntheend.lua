function INDUNTHEEND_ON_INIT(addon, frame)

end

function BEFORE_APPLIED_INDUNTHEEND_OPEN(invItem)
	local frame = ui.GetFrame("induntheend");
	if invItem.isLockState then 
		frame:ShowWindow(0)
		return;
	end

	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end

	local middle = GET_CHILD(frame, "middleImg", "ui::CPicture");
	middle:SetImage("indunticket_middle");

	local itemobj = GetIES(invItem:GetObject());
	local starCount = itemobj.NumberArg1;		
	local star_mark = GET_CHILD_RECURSIVELY(frame,'star_mark')
	local starMarkString = "";

	for i = 1, starCount do
		starMarkString = starMarkString.."{img star_mark 40 40}";
	end
	
	star_mark:SetTextByKey("value", starMarkString);
	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
	frame:Resize(frame:GetWidth(), 640);
end

function REQ_CLEAR_INDUN_ITEM(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	SELEC_CANCLE(frame);
	
	local itemIES = frame:GetUserValue("itemIES");
	local argList = string.format("%s", frame:GetUserValue("ClassName"));
	local itemName = ClMsg(argList);

	pc.ReqExecuteTx_Item("SCR_USE_INDUN_CLEAR", itemIES, argList);
end

function SELEC_CANCLE(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	frame:ShowWindow(0);
end

function SPRAYLIKER_ON_INIT(addon, frame)


	
end


function VIEW_SPRAY_LIKER(frame)

	VIEW_SPRAY_LIKER_SCROLLTEXT(frame);
	
end

function VIEW_SPRAY_LIKER_SCROLLTEXT(frame)

	local list = session.GetSprayLikeList();

	local txt = "{s16}{ol}{ul}";
	
	local cnt = list:Count();
	for i = 0 , cnt -1  do
		local fName = list:PtrAt(i):c_str();
		local addTxt = string.format("{a WHISPER_TO %s}%s{/}", fName , fName );
		
		txt = txt .. addTxt .. "{nl}";
	end

	frame:GetChild("likers"):SetText(txt);
	frame:ShowWindow(1);


end

function VIEW_SPRAY_LIKER_ADVBOX(frame)

	local list = session.GetSprayLikeList();

	local advBox = GET_CHILD(frame, "AdvBox", "ui::CAdvListBox");
	advBox:ClearUserItems();
	
	local cnt = list:Count();
	for i = 0 , cnt -1  do
	
		local fName = list:PtrAt(i):c_str();
		SET_ADVBOX_ITEM(advBox, fName, 0, fName, "white_16_ol");
	end

	advBox:UpdateAdvBox();
	frame:ShowWindow(1);

end




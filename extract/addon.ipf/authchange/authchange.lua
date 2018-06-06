function AUTHCHANGE_ON_INIT(addon, frame)


end


function REQ_SAVE_MEMBER_AUTH(frame)


	local itemCtrl = GET_CHILD(frame, "item_0" , "ui::CRadioButton");
	local surveyCtrl = GET_CHILD(frame, "survey_0", "ui::CRadioButton");
	
	local item = GET_RADIOBTN_NUMBER(itemCtrl);
	local survey = GET_RADIOBTN_NUMBER(surveyCtrl);
	
	local type = frame:GetValue();
	local name = frame:GetSValue();
	local memberInfo = session.party.GetPartyMemberInfo(type, name);
	local obj = GetIES(memberInfo:GetObject());
	if obj.Auth_Inv ~= item then
		ui.Chat(string.format("/pmp %d %s %s %d", type, name, "Auth_Inv", item));
	end
	
	if obj.Auth_Survey ~= survey then
		ui.Chat(string.format("/pmp %d %s %s %d", type, name, "Auth_Survey", survey));
	end
	
	frame:ShowWindow(0);

end




function PARTY_RECOMMEND_POPUP_ON_INIT(addon, frame)

end


function PARTY_RECOMMEND_POPUP_OPEN(frame)
	
end


function PARTY_RECOMMEND_POPUP_CLOSE(frame)

	local frame = ui.GetFrame("party_recommend_popup");
	local fname = frame:GetUserValue("RECOMMEND_LEADER_FNAME");
	local isack = frame:GetUserValue("IS_ACK");
	
	if isack ~= "true" then
		party.CancelInvite(0, fname, 2)
	end
end

function PARTY_RECOMMEND_INVITE_ACCEPT()

	local frame = ui.GetFrame("party_recommend_popup");
	local fname = frame:GetUserValue("RECOMMEND_LEADER_FNAME");
	local fAid = frame:GetUserValue("RECOMMEND_LEADER_AID");
	frame:SetUserValue("IS_ACK", "true");

	party.AcceptInvite(0, fAid, fname, 2)

	frame:ShowWindow(0)

end

function PARTY_RECOMMEND_INVITE_DECLINE()

	local frame = ui.GetFrame("party_recommend_popup");
	local fname = frame:GetUserValue("RECOMMEND_LEADER_FNAME");
	frame:SetUserValue("IS_ACK", "true");

	party.CancelInvite(0, fname, 2)

	frame:ShowWindow(0)

end
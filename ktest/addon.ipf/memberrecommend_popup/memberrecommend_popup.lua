

function MEMBERRECOMMEND_POPUP_ON_INIT(addon, frame)

end


function MEMBERRECOMMEND_POPUP_OPEN(frame)

end


function MEMBERRECOMMEND_POPUP_CLOSE(frame)

end

function MEMBER_RECOMMEND_INVITE()

	local frame = ui.GetFrame("memberrecommend_popup");
	local fname = frame:GetUserValue("RECOMMEND_FNAME");
	local recommendType = frame:GetUserValue("RECOMMEND_TYPE");

	if recommendType == "0" then
		party.AcceptReqInvite(fname, true);
	else
	party.ReqRecommendInvite(fname,recommendType);
	end

	frame:ShowWindow(0)

end

function MEMBER_RECOMMEND_REFUSE()
	local frame = ui.GetFrame("memberrecommend_popup");
	local fname = frame:GetUserValue("RECOMMEND_FNAME");
	local recommendType = frame:GetUserValue("RECOMMEND_TYPE");

	if recommendType == "0" then
		party.AcceptReqInvite(fname, false);
	end
	frame:ShowWindow(0);	
end
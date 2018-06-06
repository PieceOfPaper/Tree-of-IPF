

function MEMBERRECOMMEND_ON_INIT(addon, frame)

end


function MEMBERRECOMMEND_OPEN(frame)

end


function MEMBERRECOMMEND_CLOSE(frame)

end


function SHOW_MEMBER_RECOMMEND(cid, recommendType)

	--팝업프레임 세팅
	local popupframe = ui.GetFrame("memberrecommend_popup");
	if popupframe:IsVisible() == 1 then
		return
	end

	local otherpcinfo = session.otherPC.GetByStrCID(cid);

	local imagename = nil
	imagename = ui.CaptureSomeonesFullStdImage(otherpcinfo:GetAppearance())	
	local charImage = GET_CHILD_RECURSIVELY(popupframe,"shihouette");
	if imagename ~= nil then
		charImage:SetImage(imagename)
	end

	local fnametext = GET_CHILD_RECURSIVELY(popupframe,"fname")
	local fname		= otherpcinfo:GetAppearance():GetFamilyName()
	fnametext:SetText(fname);

	local cnametext = GET_CHILD_RECURSIVELY(popupframe,"cname")
	local cname		= otherpcinfo:GetAppearance():GetName()
	cnametext:SetText(cname);

	local lvtext = GET_CHILD_RECURSIVELY(popupframe,"lv")
	local lv		= otherpcinfo:GetAppearance():GetLv()
	lvtext:SetTextByKey("level",lv);

	local jobhistory = otherpcinfo.jobHistory;
	local nowjobinfo = jobhistory:GetJobHistory(jobhistory:GetJobHistoryCount()-1);
	local clslist, cnt  = GetClassList("Job");
	local nowjobcls = GetClassByTypeFromList(clslist, nowjobinfo.jobID);
	local jobRank		= nowjobinfo.grade
	local jobName		= nowjobcls.Name
	local jobtext = GET_CHILD_RECURSIVELY(popupframe,"job")
	jobtext:SetTextByKey("jobname",jobName);
	jobtext:SetTextByKey("jobrank",jobRank);

	popupframe:SetUserValue("RECOMMEND_TYPE",recommendType);
	popupframe:SetUserValue("RECOMMEND_FNAME", fname);
	


	local frame = ui.GetFrame("memberrecommend");

	local description = GET_CHILD_RECURSIVELY(frame,"description")

	if recommendType ~= 0 then
	local matchmakerCls = GetClassByType("PartyMatchMaker",recommendType)
	description:SetText(matchmakerCls.RecommendMent)
		local btn = GET_CHILD_RECURSIVELY(popupframe, "invite")
		btn:SetText(ScpArgMsg("JustInvite"))
	else
		local desctext = ScpArgMsg("{Name}WantInviteMe","Name",fname )
		description:SetText(desctext)
		local btn = GET_CHILD_RECURSIVELY(popupframe, "invite")
		btn:SetText(ScpArgMsg("JustReqOK"))
	end


	local charname = GET_CHILD_RECURSIVELY(frame,"name")
	charname:SetText(fname);

	local charImage_nonpopup = GET_CHILD_RECURSIVELY(frame,"shihouette");
	if charImage_nonpopup ~= nil then
		charImage_nonpopup:SetImage(imagename)
	end

	local duration = tonumber(frame:GetUserConfig("POPUP_DURATION"))
	
	frame:ShowWindow(1);
	frame:SetDuration(duration);

end

function POPUP_MEMBER_RECOMMEND_UI()
	imcSound.PlaySoundEvent("button_v_click")
	ui.CloseFrame('memberrecommend')
	ui.OpenFrame('memberrecommend_popup')
end
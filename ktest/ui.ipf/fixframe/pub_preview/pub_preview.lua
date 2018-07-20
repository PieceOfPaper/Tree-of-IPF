
function PUB_PREVIEW_ON_INIT(addon, frame)
	
	

end

function PUB_PREVIEW_FIRST_OPEN(frame)
	SET_FRAME_AUTO_MOUSEPOS(frame, 30, 30);

end

function PUB_PREVIEW_ACTOR(actor)
	local frame = ui.GetFrame("pub_preview");
	if actor:GetObjType() ~= GT_PC then
		frame:ShowWindow(0);
		return;
	end

	frame:ShowWindow(1);
	local apc = actor:GetPCApc();

	local gender = apc:GetGender();
	local genderStr = "{#46c8ff}(" .. ScpArgMsg("Male")  .. ")";
	if gender == 2 then
		genderStr = "{#ff6699}(" .. ScpArgMsg("Female") .. ")";
	end

	local job = apc:GetJob();
	local headType = apc:GetHeadType();

	local jobCls = GetClassByType("Job", job);

	local job_title = frame:GetChild("job_title");
	job_title:SetTextByKey("value", string.format("%s %s", jobCls.Name, genderStr));

	local classImage = GET_CHILD(frame, "classImage", "ui::CPicture");
	local imgName= jobCls.Icon;
	classImage:SetImage(imgName);
end
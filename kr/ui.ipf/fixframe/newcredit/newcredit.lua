

g_credintimageNum = 1
MAX_IMAGE_NUM = 13



function NEWCREDIT_ON_INIT(addon, frame)
	
end

function NEWCREDIT_DO_CLOSE()

	local frame = ui.GetFrame("newcredit")
	frame:ShowWindow(0)

end

function NEWCREDIT_ON_CLOSEBTN()

	NEWCREDIT_FADEOUT()
	ReserveScript("NEWCREDIT_DO_CLOSE()", 1.3);
	
end

function NEWCREDIT_NEXT_PAGE()

	local frame = ui.GetFrame("newcredit")

	
	
	g_credintimageNum = g_credintimageNum + 1

	if g_credintimageNum > MAX_IMAGE_NUM then
		g_credintimageNum = 1;
	end



	for i = 1, MAX_IMAGE_NUM do

		local imgname = "nameimg"..tostring(i)
		
		local eachImage = GET_CHILD_RECURSIVELY(frame,imgname);
		eachImage:ShowWindow(0)

	end

	
	local imgname = "nameimg"..tostring(g_credintimageNum)
	
	local nowimage = GET_CHILD_RECURSIVELY(frame,imgname);
	nowimage:ShowWindow(1)

	local maskimg = GET_CHILD_RECURSIVELY(frame,"maskimg");

	NEWCREDIT_FADEIN()
	
end

function NEWCREDIT_FADEIN()

	local frame = ui.GetFrame("newcredit")

	local fadein = GET_CHILD_RECURSIVELY(frame,"fadein");
	fadein:ShowWindow(0)
	fadein:ShowWindow(1)

end

function NEWCREDIT_FADEOUT()

	local frame = ui.GetFrame("newcredit")

	local fadeout = GET_CHILD_RECURSIVELY(frame,"fadeout");
	
	fadeout:ShowWindow(1)

end

function OPEN_NEWCREDIT(frame)
	
	local loginFrame = ui.GetFrame("loginui_idpw");
	if loginFrame ~= nil then
	  local loginButton = GET_CHILD_RECURSIVELY(loginFrame, "OK");
	  loginButton:StopActiveUIEffect();
	end
	
	g_credintimageNum = 1

	local fadein = GET_CHILD_RECURSIVELY(frame,"fadein");
	fadein:SetAnimation("openAnim", "fade_out2");

	local fadeout = GET_CHILD_RECURSIVELY(frame,"fadeout");
	fadeout:SetAnimation("openAnim", "fade_in2");
	fadeout:ShowWindow(0)
	fadein:ShowWindow(0)



	local firstImage = GET_CHILD_RECURSIVELY(frame,"nameimg1");
	firstImage:ShowWindow(1)

	for i = g_credintimageNum + 1, MAX_IMAGE_NUM do

		local imgname = "nameimg"..tostring(i)
		
		local eachImage = GET_CHILD_RECURSIVELY(frame,imgname);
		eachImage:ShowWindow(0)
	end


	NEWCREDIT_FADEIN()
	

end

function CLOSE_NEWCREDIT()
	
end
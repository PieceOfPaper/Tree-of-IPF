
function GET_LOADING_IMG_RANDOM_CLSID(clsList, cnt, loadingType)

	local list = {};
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if cls.LoadingType == loadingType then
			list[#list+1] = cls.ClassID;
		end
	end

	if #list > 0 then
		local index = OSRandom(1, #list);
		return list[index];
	end

	return 0;
end

function CHANGE_LOADING_IMG_URLSTR()

	local clsList, cnt  = GetClassList("loading_img");
	local currentLoadingType = 'LoadingDefault';
	if session.GetWasBarrack() == true then 
		currentLoadingType = 'LoadingFirst'
	elseif GetClass("Map", GetZoneName(pc)).MapType == 'City' then
		currentLoadingType = 'LoadingCity'
	end
	
	local clsID = GET_LOADING_IMG_RANDOM_CLSID(clsList, cnt, currentLoadingType);

	if clsID == 0 and currentLoadingType == 'LoadingFirst' then
		currentLoadingType = 'LoadingCity';
		clsID = GET_LOADING_IMG_RANDOM_CLSID(clsList, cnt, currentLoadingType);
	end

	if clsID == 0 then
		currentLoadingType = 'LoadingDefault';
		clsID = GET_LOADING_IMG_RANDOM_CLSID(clsList, cnt, currentLoadingType);
	end
	local cls = GetClassByTypeFromList(clsList, clsID);
	local url = config.GetLoadingImgURL();
	local urlStr = string.format("%s%s", url, cls.FileName);
	return urlStr;
end

function LOADINGBG_ON_INIT(addon, frame)

	addon:RegisterMsg('START_LOADING', 'DO_RESIZE_BY_CLIENT_SIZE');
	
	if frame == nil then
		return;
	end

	-- FRAME_FULLSCREEN(frame);
	frame:Resize(option.GetClientWidth() ,option.GetClientHeight() );
	
	local pic = GET_CHILD(frame, "pic", "ui::CWebPicture");
	pic:Resize(frame:GetWidth(), frame:GetHeight());

	local urlStr = CHANGE_LOADING_IMG_URLSTR();
	pic:SetUrlInfo(urlStr);

	local tipGroupbox 		= frame:GetChild('tip');
    local tipCtl 			= tipGroupbox:GetChild('gametip');

	local gauge = frame:GetChild("gauge");
	gauge:Resize(frame:GetWidth(), gauge:GetHeight());

	
	local nowjobtype = config.GetConfig("LastJobCtrltype");
	local nowlevel = config.GetConfigInt("LastPCLevel", 0);

	local clsList, cnt  = GetClassList('LoadingText');
	local tipClass  = nil;

	for i = 1, cnt*5 do -- 그냥 무한루프�?막기 ?�함. 조건??맞는 ?�이 ?�올?�까지 골라본다.
	
		tipClass = GetClassByIndexFromList(clsList, OSRandom(0, cnt  - 1));
		if tipClass.MinLv <= nowlevel and tipClass.MaxLv >= nowlevel then
			if tipClass.Job == 'All' or tipClass.Job == nowjobtype then
				break;
			end
		end

	end

	local txt = '{#f0dcaa}{s20}{ol}{gr gradation2}'..ScpArgMsg("Todays_Tip") ..tipClass.Text;
	tipCtl:SetText(txt);
	tipGroupbox:Resize(tipCtl:GetWidth()+40, tipGroupbox:GetHeight());
	

	local faqclsList, faqcnt  = GetClassList('LoadingFAQ');
	local faqClass  = GetClassByIndexFromList(faqclsList, OSRandom(0, faqcnt  - 1));
	local faqtxt = '{#f0dcaa}{s18}{ol}{gr gradation2}'..faqClass.Text;

	local faqCtl 			= GET_CHILD_RECURSIVELY(frame,'gamefaq')
	faqCtl:SetText(faqtxt);
	local faqGroupbox 		= GET_CHILD_RECURSIVELY(frame,'faq')
	faqGroupbox:Resize(faqCtl:GetWidth()+70, faqCtl:GetHeight() + 50);
	
	frame:Invalidate();

 end


function DO_RESIZE_BY_CLIENT_SIZE(frame)

	local width, height = FRAME_FULLSCREEN(frame);

	local webpic = frame:GetChild('pic');
	if webpic ~= nil then
		webpic:Resize(width, height);
	end

	local picture = frame:GetChild('screenmask');
	if picture ~= nil then
		picture:Resize(width, height);
	end

	local gauge = frame:GetChild('gauge');
	if gauge ~= nil then
		gauge:Resize(width, gauge:GetHeight());
	end
	
	frame:Invalidate();
end


-- hair_gacha_start.lua --

g_hairgacharresult = {}



function HAIR_GACHA_POPUP_ON_INIT(addon, frame)

	addon:RegisterMsg("HAIR_GACHA_POPUP", "GACHA_POPUP_MSG");
	addon:RegisterMsg("HAIR_GACHA_POPUP_10", "GACHA_POPUP_MSG");
	addon:RegisterMsg("RBOX_GACHA_POPUP", "GACHA_POPUP_MSG");
	addon:RegisterMsg("RBOX_GACHA_POPUP_10", "GACHA_POPUP_MSG");
    addon:RegisterMsg("LETICIA_POPUP", "GACHA_POPUP_MSG");
    addon:RegisterMsg("LETICIA_POPUP_10", "GACHA_POPUP_MSG");

end

function INIT_HAIR_GACHA_RET_TABLE(itemliststr)
	
	local itemnametable = {}
	local itemcnttable = {}
	local itemranktable = {}

	local myTable = itemliststr:split("&")
		
	for i = 1, #myTable - 1 do -- �Ϻη� -1 �Ѱ���
		if i % 2 ~= 0 then
			table.insert(itemnametable, myTable[i])
		else
			local substr = myTable[i]
			local grade = math.floor(tonumber(substr) / 1000)
			local cnt = tonumber(substr) % 1000

			table.insert(itemcnttable, cnt )
			table.insert(itemranktable, grade )
		end 
	end
	if #itemcnttable ~= 11 then
		return false;
	end
	

	local count = #g_hairgacharresult
	for i = 0, count do 
		g_hairgacharresult[i] = nil 
	end

	local defsmallpoptime = 0

	for i = 1, 11 do
		g_hairgacharresult[i] = {}
		g_hairgacharresult[i]["name"] = itemnametable[i]
		g_hairgacharresult[i]["cnt"] = itemcnttable[i]
		g_hairgacharresult[i]["poptime"] = defsmallpoptime
		g_hairgacharresult[i]["grade"] = itemranktable[i]
		defsmallpoptime = defsmallpoptime + 0.1
	end

	g_hairgacharresult[1]["xindex"] = -2
	g_hairgacharresult[1]["yindex"] = -1

	g_hairgacharresult[2]["xindex"] = -1
	g_hairgacharresult[2]["yindex"] = -1

	g_hairgacharresult[3]["xindex"] = 0
	g_hairgacharresult[3]["yindex"] = -1

	g_hairgacharresult[4]["xindex"] = 1
	g_hairgacharresult[4]["yindex"] = -1

	g_hairgacharresult[5]["xindex"] = 2
	g_hairgacharresult[5]["yindex"] = -1

	g_hairgacharresult[6]["xindex"] = -2.5
	g_hairgacharresult[6]["yindex"] = 0

	g_hairgacharresult[7]["xindex"] = -1.5
	g_hairgacharresult[7]["yindex"] = 0

	g_hairgacharresult[8]["xindex"] = -0.5
	g_hairgacharresult[8]["yindex"] = 0

	g_hairgacharresult[9]["xindex"] = 0.5
	g_hairgacharresult[9]["yindex"] = 0

	g_hairgacharresult[10]["xindex"] = 1.5
	g_hairgacharresult[10]["yindex"] = 0

	g_hairgacharresult[11]["xindex"] = 2.5
	g_hairgacharresult[11]["yindex"] = 0

	return true;

end


function GACHA_POPUP_MSG(frame, msg, itemname, itemcnt)

	local type = nil
    local isLeticia = 0;
    if string.find(msg, 'LETICIA_POPUP') ~= nil then
        isLeticia = 1;
    end
    local fulldark = ui.GetFrame('fulldark');
    fulldark:SetUserValue('GACHA_COUNT', 0);  

	if msg == "HAIR_GACHA_POPUP" or msg == "HAIR_GACHA_POPUP_10"  then
		type = "hair"
	elseif msg == "RBOX_GACHA_POPUP" or  msg == "RBOX_GACHA_POPUP_10" or isLeticia == 1 then
		type = "rbox"
	end

	if msg == "HAIR_GACHA_POPUP" or msg == "RBOX_GACHA_POPUP" or msg == 'LETICIA_POPUP' then

		local count = #g_hairgacharresult
		for i = 0, count do 
			g_hairgacharresult[i] = nil 
		end

		local grade = math.floor(itemcnt / 1000)
		local cnt = itemcnt % 1000

		g_hairgacharresult[11] = {}
		g_hairgacharresult[11]["name"] = itemname
		g_hairgacharresult[11]["grade"] = grade
		g_hairgacharresult[11]["cnt"] = cnt

		DARK_FRAME_DO_OPEN(isLeticia);
		HAIR_GACHA_POP_BIG_FRAME(11, type, true, isLeticia);

	elseif msg == "HAIR_GACHA_POPUP_10" or  msg == "RBOX_GACHA_POPUP_10" or msg == 'LETICIA_POPUP_10' then

		local isAlreadyPlaying = false;	
		for i = 1, 11 do
			local bigframename = "HAIRGACHA_BIG_"..tostring(i);
			local bigframe = ui.GetFrame(bigframename);
			if bigframe ~= nil then
				isAlreadyPlaying = true;
				break;
			end
		end

		if isAlreadyPlaying == true then
			DARK_FRAME_DO_CLOSE();
			
			local reserveScp = string.format("SHOW_GACHA(%d, '%s', '%s')", isLeticia, itemname, type);
			ReserveScript(reserveScp , 3.5);
		else
			SHOW_GACHA(isLeticia, itemname, type);
		end
	end
end

function SHOW_GACHA(isLeticia, itemliststr, type)
	if INIT_HAIR_GACHA_RET_TABLE(itemliststr) == false then
		return;
	end

	for i = 1, 11 do 
		HAIR_GACHA_RESERVE_POP_SMALL_FRAME(i, type)
	end

	local reserveScp = string.format('DARK_FRAME_DO_OPEN(%d)', isLeticia);
	ReserveScript(reserveScp , 1.5);
	ReserveScript( string.format("HAIR_GACHA_POP_BIG_FRAME(%d, '%s', %d)", 1, type, isLeticia), 1.5);
end

function HAIR_GACHA_RESERVE_POP_SMALL_FRAME(frameindex, type)
	local itemname = g_hairgacharresult[frameindex]["name"]
	local grade = g_hairgacharresult[frameindex]["grade"]
	local xindex = g_hairgacharresult[frameindex]["xindex"]
	local yindex = g_hairgacharresult[frameindex]["yindex"]
	local smallpoptime = g_hairgacharresult[frameindex]["poptime"]

	local itemclass = GetClass("Item",itemname)
	if itemclass == nil then
		return;
	end
	
	local itemiconname = itemclass.Icon

	local smallframename = "HAIRGACHA_SMALL_"..tostring(frameindex);
	local smallframe = ui.GetFrame(smallframename);
	if smallframe ~= nil then
        smallframe:CancelReserveScript( string.format("ui.CloseFrame(\"%s\")", smallframename) );
    end
    
    local bigframename = "HAIRGACHA_BIG_"..tostring(frameindex);
    local bigframe = ui.GetFrame(bigframename);
    if bigframe ~= nil then
        bigframe:CancelReserveScript( string.format("CLOSE_N_DESTROY_FRAME(\"%s\")", bigframename) );
    end
	
	ui.DestroyFrame(smallframename);

    local fulldark = ui.GetFrame('fulldark');
    fulldark:SetUserValue('GACHA_COUNT', frameindex);
	ReserveScript( string.format("HAIR_GACHA_POP_SMALL_FRAME(\"%s\", \"%s\", %d, %f, %f, \"%s\")", smallframename, itemiconname, grade, xindex, yindex, type) , smallpoptime);
	
end

function HAIR_GACHA_POP_SMALL_FRAME(smallframename, itemiconname, grade, xindex, yindex, type)
	local smallframe = ui.CreateNewFrame("hair_gacha_popup", smallframename);
	if smallframe == nil then
		return nil;
	end
	smallframe:ShowWindow(0)
	smallframe:MoveFrame(smallframe:GetX() + (xindex * 120), smallframe:GetY() + (yindex * 125));

	local itembgimg = GET_CHILD_RECURSIVELY(smallframe, "itembgimg")
	if grade == 1 then
		if type == "hair" then
			itembgimg:SetImage("gacha_01")
		else
			itembgimg:SetImage("random_01")
		end
	elseif grade == 2 then
		if type == "hair" then
			itembgimg:SetImage("gacha_02")
		else
			itembgimg:SetImage("random_02")
		end
	else
		if type == "hair" then
			itembgimg:SetImage("gacha_03")
		else
			itembgimg:SetImage("random_03")
		end
	end



	local itemimg = GET_CHILD_RECURSIVELY(smallframe, "itemimg")
	itemimg:SetImage(itemiconname)
	itemimg:SetColorTone("44000000");

	local bonusimg = GET_CHILD_RECURSIVELY(smallframe, "bonusimg")
	if xindex == 2.5 and yindex == 0 then
		bonusimg:ShowWindow(1)
	else
		bonusimg:ShowWindow(0)
	end


	smallframe:ShowWindow(1)
	
end

function HAIR_GACHA_SMALL_FRAME_SHOWICON(smallframename)
	local frame = ui.GetFrame(smallframename)
	if frame == nil then
		return;
	end

	local smallitemimg = GET_CHILD_RECURSIVELY(frame,"itemimg");
	smallitemimg:SetColorTone("FFFFFFFF");

	frame:Invalidate()
end

function HAIR_GACHA_POP_BIG_FRAME(frameindex, type, nobonus, isLeticia)
	local itemname = g_hairgacharresult[frameindex]["name"]
	local grade = g_hairgacharresult[frameindex]["grade"]
	local cnt = g_hairgacharresult[frameindex]["cnt"]
	
	local itemclass = GetClass("Item",itemname)
	if itemclass == nil then
		return;
	end

	local bigframename = "HAIRGACHA_BIG_"..tostring(frameindex);
	ui.DestroyFrame(bigframename);

	local bigframe = ui.CreateNewFrame("hair_gacha_fullscreen", bigframename);
	if bigframe == nil then
		return;
	end
    local leticiaBox = bigframe:GetChild('leticiaBox');
    local skip_gacha_btn = bigframe:GetChild('skip_gacha_btn');
    if isLeticia == 1 then
        skip_gacha_btn:ShowWindow(0);
        leticiaBox:ShowWindow(1);
    else
        skip_gacha_btn:ShowWindow(1);
        leticiaBox:ShowWindow(0);
    end

	bigframe:SetUserValue("GACHA_FRAME_INDEX",frameindex)
	bigframe:SetUserValue("GACHA_FRAME_TYPE",type)

	local itembgimg = GET_CHILD_RECURSIVELY(bigframe, "bigitembgimg")
	if grade == 1 then
		if type == "hair" then
			itembgimg:SetImage("gacha_big_01")
		else
			itembgimg:SetImage("random_big_01")
		end
	elseif grade == 2 then
		if type == "hair" then
			itembgimg:SetImage("gacha_big_02")
		else
			itembgimg:SetImage("random_big_02")
		end
	else
		if type == "hair" then
			itembgimg:SetImage("gacha_big_03")
		else
			itembgimg:SetImage("random_big_03")
		end
	end

	local itemimg = GET_CHILD_RECURSIVELY(bigframe, "bigitemimg")
	itemimg:SetImage(itemclass.Icon)

	local itemnamectl = GET_CHILD_RECURSIVELY(bigframe, "itemname")
	if cnt == 1 then
		itemnamectl:SetTextByKey("name",itemclass.Name)
	else
		itemnamectl:SetTextByKey("name",ScpArgMsg("ItemNameNCnt","Name",itemclass.Name,"Cnt",tostring(cnt)))
	end

	local bonusimg = GET_CHILD_RECURSIVELY(bigframe, "bonusimg")
	if frameindex == 11 and nobonus ~= true then
		bonusimg:ShowWindow(1)
	else
		bonusimg:ShowWindow(0)
	end

	bigframe:ShowWindow(1)

	local posX = ui.GetSceneWidth() / 2;
	local posY = ui.GetSceneHeight() / 2;
	
	if grade == 1 then
		movie.PlayUIEffect(bigframe:GetUserConfig("GACHA_EFT_1"), posX, posY, tonumber(bigframe:GetUserConfig("GACHA_EFT_SCALE_1")));
	elseif grade == 2 then
		movie.PlayUIEffect(bigframe:GetUserConfig("GACHA_EFT_2"), posX, posY, tonumber(bigframe:GetUserConfig("GACHA_EFT_SCALE_2")));
	else
		movie.PlayUIEffect(bigframe:GetUserConfig("GACHA_EFT_3"), posX, posY, tonumber(bigframe:GetUserConfig("GACHA_EFT_SCALE_3")));
	end

	local smallframename = "HAIRGACHA_SMALL_"..tostring(frameindex);
	HAIR_GACHA_SMALL_FRAME_SHOWICON(smallframename)

end

function CLOSE_N_DESTROY_FRAME(framename)
	local frame = ui.GetFrame(framename)
	if frame == nil then
		return
	end
	frame:ShowWindow(0)
	
    ui.DestroyFrame(framename);
end

function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  local cnt = 0
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	cnt = cnt + 1
	if cnt > 1000 then
		break
	end
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end
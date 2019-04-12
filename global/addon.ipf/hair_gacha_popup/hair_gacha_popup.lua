-- hair_gacha_start.lua --

g_hairgacharresult = {}



function HAIR_GACHA_POPUP_ON_INIT(addon, frame)

	addon:RegisterMsg("HAIR_GACHA_POPUP", "GACHA_POPUP_MSG");
	addon:RegisterMsg("HAIR_GACHA_POPUP_10", "GACHA_POPUP_MSG");
	addon:RegisterMsg("RBOX_GACHA_POPUP", "GACHA_POPUP_MSG");
	addon:RegisterMsg("RBOX_GACHA_POPUP_10", "GACHA_POPUP_MSG");

end

function GET_GACHA_GRADE_BY_ITEMNAME(itemname)

	local grade = 0;
	local rewardlist, rewardlistcnt =  GetClassList("reward_tp")
	for j = 0 , rewardlistcnt - 1 do
		local rewardcls = GetClassByIndexFromList(rewardlist, j);
			
		if rewardcls.ItemName == itemname then

			if rewardcls.Rank == "A" then
				grade = 1
			elseif rewardcls.Rank == "B" then
				grade = 2
			elseif rewardcls.Rank == "C" then
				grade = 3
			end

			break;
		end
	end

	return grade;

end

function INIT_HAIR_GACHA_RET_TABLE(itemliststr)

	local itemnametable = {}
	local itemcnttable = {}

	local myTable = itemliststr:split("&")
		
	for i = 1, #myTable - 1 do -- 일부러 -1 한거임
		if i % 2 ~= 0 then
			table.insert(itemnametable, myTable[i])
		else
			table.insert(itemcnttable, tonumber(myTable[i]) )
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
		g_hairgacharresult[i]["grade"] = GET_GACHA_GRADE_BY_ITEMNAME(itemnametable[i])
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

	if msg == "HAIR_GACHA_POPUP" or msg == "HAIR_GACHA_POPUP_10"  then
		type = "hair"
	elseif msg == "RBOX_GACHA_POPUP" or  msg == "RBOX_GACHA_POPUP_10" then
		type = "rbox"
	end

	if msg == "HAIR_GACHA_POPUP" or msg == "RBOX_GACHA_POPUP"  then

		local count = #g_hairgacharresult
		for i = 0, count do 
			g_hairgacharresult[i] = nil 
		end

		g_hairgacharresult[11] = {}
		g_hairgacharresult[11]["name"] = itemname
		g_hairgacharresult[11]["grade"] = GET_GACHA_GRADE_BY_ITEMNAME(itemname)
		g_hairgacharresult[11]["cnt"] = itemcnt

		DARK_FRAME_DO_OPEN()
		HAIR_GACHA_POP_BIG_FRAME(11, type, true)

	elseif msg == "HAIR_GACHA_POPUP_10" or  msg == "RBOX_GACHA_POPUP_10" then

		local itemliststr = itemname;
		if INIT_HAIR_GACHA_RET_TABLE(itemliststr) == false then
			return;
		end

		for i = 1, 11 do 
			HAIR_GACHA_RESERVE_POP_SMALL_FRAME(i, type)
		end

		ReserveScript( "DARK_FRAME_DO_OPEN()" , 1.5);
		ReserveScript( string.format("HAIR_GACHA_POP_BIG_FRAME(%d, \"%s\")", 1, type) , 1.5);
	end
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
	ui.DestroyFrame(smallframename);

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



function HAIR_GACHA_POP_BIG_FRAME(frameindex, type, nobonus)

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

	ReserveScript( string.format("ui.DestroyFrame(\"%s\")", framename) , 3);

end

function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end





















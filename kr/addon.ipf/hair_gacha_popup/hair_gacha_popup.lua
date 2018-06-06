-- hair_gacha_start.lua --


HAIR_GACHA_FRAME_COUNT = 0;
HAIR_GACHA_FRAME_CANCEL_COUNT = 0;

function HAIR_GACHA_POPUP_ON_INIT(addon, frame)

	addon:RegisterMsg("HAIR_GACHA_POPUP", "HAIR_GACHA_POPUP_MSG");
	addon:RegisterMsg("HAIR_GACHA_POPUP_10", "HAIR_GACHA_POPUP_MSG");

	HAIR_GACHA_FRAME_COUNT = 0;
	HAIR_GACHA_FRAME_CANCEL_COUNT= 0;

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

function HAIR_GACHA_POPUP_MSG(frame, msg, itemname, itemcnt)

	if msg == "HAIR_GACHA_POPUP" then

		local grade = 0;
		local rewardlist, rewardlistcnt =  GetClassList("reward_tp")
		for i = 0 , rewardlistcnt - 1 do
			local rewardcls = GetClassByIndexFromList(rewardlist, i);
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

		MAKE_HAIR_GACHA_SHOW_EACH_ITEM(itemname, itemcnt, grade, 0, 1.5, 3.5, 3.5, 0, 0, false)
		ReserveScript( "DARK_FRAME_POP()" , 1.5);
		ReserveScript( "DARK_FRAME_CLOSE()" , 4.7);

	elseif msg == "HAIR_GACHA_POPUP_10" then

		local itemnametable = {}
		local itemcnttable = {}

		local itemliststr = itemname;

		local myTable = itemliststr:split("&")
		for i = 1, #myTable - 1 do -- 일부러 -1 한거임
			if i % 2 ~= 0 then
				table.insert(itemnametable, myTable[i])
			else
				table.insert(itemcnttable, tonumber(myTable[i]) )
			end 
		end
		
		if #itemcnttable ~= 10 then
			return;
		end

		local defsmallopentime = 0
		local defsmallclosetime = 39.0
		local defbigopentime = 1.5
		local defbigclosetime = 3.5
		local xindex = -2
		local yindex = -1

		ReserveScript( "DARK_FRAME_POP()" , defbigopentime);

		for i = 1, 10 do 

			local grade = 0;
			local rewardlist, rewardlistcnt =  GetClassList("reward_tp")
			for j = 0 , rewardlistcnt - 1 do
				local rewardcls = GetClassByIndexFromList(rewardlist, j);
			
				if rewardcls.ItemName == itemnametable[i] then

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

			if grade == 1 then
				defbigclosetime = defbigclosetime + 1
			elseif grade == 2 then
				defbigclosetime = defbigclosetime + 0.5
			end

			MAKE_HAIR_GACHA_SHOW_EACH_ITEM(itemnametable[i], itemcnttable[i], grade, defsmallopentime, defbigopentime, defsmallclosetime, defbigclosetime, xindex, yindex, true)

			if grade == 1 then
				defbigopentime = defbigopentime + 1
			elseif grade == 2 then
				defbigopentime = defbigopentime + 0.5
			end

			if i == 10 then
				break;
			end

			defsmallopentime = defsmallopentime + 0.1
			defsmallclosetime = defsmallclosetime + 0.1
			defbigopentime = defbigopentime + 2.2
			defbigclosetime = defbigopentime + 2.2
			
			xindex = xindex + 1
			if i == 5 then
				xindex = -2
				yindex = 0
			end
			
		end

		ReserveScript( "DARK_FRAME_CLOSE()" , defbigclosetime);
	end
end

function MAKE_HAIR_GACHA_SHOW_EACH_ITEM(itemname, itemcnt, grade, smallpoptime, bigpoptime, smallclosetime, bigclosetime, xindex, yindex, showsmallframe)

	local itemclass = GetClass("Item",itemname)
	if itemclass == nil then
		return;
	end
	
	local itemiconname = itemclass.Icon


	HAIR_GACHA_FRAME_COUNT = HAIR_GACHA_FRAME_COUNT + 1
	local smallframename = "HAIRGACHA_SMALL_"..tostring(HAIR_GACHA_FRAME_COUNT);
	ui.DestroyFrame(smallframename);
	local bigframename = "HAIRGACHA_BIG_"..tostring(HAIR_GACHA_FRAME_COUNT);
	ui.DestroyFrame(bigframename);

	if showsmallframe then
		ReserveScript( string.format("SMALL_FRAME_POP(\"%s\", \"%s\", %d, %d, %d)", smallframename, itemiconname, grade, xindex, yindex) , smallpoptime);
		ReserveScript( string.format("SMALL_FRAME_SHOWICON(\"%s\")", smallframename) , bigpoptime);
	end
	
	ReserveScript( string.format("BIG_FRAME_POP(\"%s\", \"%s\", %d, \"%s\", %d, %d)", bigframename, itemiconname, grade, itemclass.Name, itemcnt, HAIR_GACHA_FRAME_COUNT) , bigpoptime);
	
	
	ReserveScript( string.format("GACHA_FRAME_CLOSE(\"%s\")", smallframename), smallclosetime);
	ReserveScript( string.format("GACHA_FRAME_CLOSE(\"%s\")", bigframename), bigclosetime);
	
	
end


-------------------
function DARK_FRAME_POP()

	local darkframe = ui.GetFrame("fulldark")
	darkframe:ShowWindow(1)

end

function DARK_FRAME_CLOSE()

	local darkframe = ui.GetFrame("fulldark")
	darkframe:ShowWindow(0)

end

function SMALL_FRAME_POP(smallframename, itemiconname, grade, xindex, yindex)

	local smallframe = ui.CreateNewFrame("hair_gacha_popup", smallframename);
	if smallframe == nil then
		return nil;
	end
	smallframe:ShowWindow(0)
	smallframe:MoveFrame(smallframe:GetX() + (xindex * 120), smallframe:GetY() + (yindex * 125));

	local itembgimg = GET_CHILD_RECURSIVELY(smallframe, "itembgimg")
	if grade == 1 then
		itembgimg:SetImage("gacha_01")
	elseif grade == 2 then
		itembgimg:SetImage("gacha_02")
	else
		itembgimg:SetImage("gacha_03")
	end

	local itemimg = GET_CHILD_RECURSIVELY(smallframe, "itemimg")
	itemimg:SetImage(itemiconname)
	itemimg:SetColorTone("CC000000");


	smallframe:ShowWindow(1)
	
end

function SMALL_FRAME_SHOWICON(smallframename)

	local frame = ui.GetFrame(smallframename)
	if frame == nil then
		return;
	end

	local smallitemimg = GET_CHILD_RECURSIVELY(frame,"itemimg");
	smallitemimg:SetColorTone("FFFFFFFF");

	frame:Invalidate()
end

function BIG_FRAME_POP(bigframename, itemiconname, grade, itemname, cnt, frameno)

	if frameno <= HAIR_GACHA_FRAME_CANCEL_COUNT then
		return;
	end

	local bigframe = ui.CreateNewFrame("hair_gacha_fullscreen", bigframename);
	if bigframe == nil then
		return;
	end

	local itembgimg = GET_CHILD_RECURSIVELY(bigframe, "bigitembgimg")
	if grade == 1 then
		itembgimg:SetImage("gacha_big_01")
	elseif grade == 2 then
		itembgimg:SetImage("gacha_big_02")
	else
		itembgimg:SetImage("gacha_big_03")
	end

	local itemimg = GET_CHILD_RECURSIVELY(bigframe, "bigitemimg")
	itemimg:SetImage(itemiconname)

	local itemnamectl = GET_CHILD_RECURSIVELY(bigframe, "itemname")
	if cnt == 1 then
		itemnamectl:SetTextByKey("name",itemname)
	else
		itemnamectl:SetTextByKey("name",ScpArgMsg("ItemNameNCnt","Name",itemname,"Cnt",tostring(cnt)))
	end

	bigframe:ShowWindow(1)

	--이펙트 테스트
	local posX = ui.GetSceneWidth() / 2;
	local posY = ui.GetSceneHeight() / 2;
	
	if grade == 1 then
		movie.PlayUIEffect(bigframe:GetUserConfig("GACHA_EFT_1"), posX, posY, tonumber(bigframe:GetUserConfig("GACHA_EFT_SCALE_1")));
	elseif grade == 2 then
		movie.PlayUIEffect(bigframe:GetUserConfig("GACHA_EFT_2"), posX, posY, tonumber(bigframe:GetUserConfig("GACHA_EFT_SCALE_2")));
	else
		movie.PlayUIEffect(bigframe:GetUserConfig("GACHA_EFT_3"), posX, posY, tonumber(bigframe:GetUserConfig("GACHA_EFT_SCALE_3")));
	end
	
end

function GACHA_FRAME_CLOSE(framename)
	local frame = ui.GetFrame(framename)
	if frame == nil then
		return
	end

	frame:ShowWindow(0)

	ReserveScript( string.format("ui.DestroyFrame(\"%s\")", framename) , 3);
end





















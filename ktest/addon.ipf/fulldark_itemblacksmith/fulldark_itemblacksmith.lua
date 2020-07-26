-- fulldark_legendcardslot_open.lua

function PLAY_BLACKSMITH_SUCCESS_EFFECT(targetItemClassName, craftType, classID)
	ui.OpenFrame("fulldark_itemblacksmith")
	local frame = ui.GetFrame("fulldark_itemblacksmith")

	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox");
	local itemCls = GetClass("Item", targetItemClassName)
	if itemCls == nil then
		return
	end
	
	local clsList = nil;
	local obj = nil;
	if craftType == "SPECIAL_MISC_CRAFT" then
		obj = GetClassByType("SpecialMiscRecipe", classID);
	else
		clsList = GetClassList("legendrecipe");
		obj = GetClassByNameFromList(clsList, targetItemClassName);
	end
	
	local bgname = TryGetProp(obj, "RecipeBgImg");

	local recipebg = GET_CHILD_RECURSIVELY(frame, "image");
	recipebg:SetImage(bgname)

	local itemIcon = GET_CHILD_RECURSIVELY(resultGbox, "itemIcon")
	itemIcon:SetImage(itemCls.Icon)
	local screenWidth = ui.GetSceneWidth();
	local screenHeight = ui.GetSceneHeight();
	movie.PlayUIEffect(frame:GetUserConfig("BLACKSMITH_RESULT_EFFECT"), screenWidth / 2, screenHeight / 2, tonumber(frame : GetUserConfig("BLACKSMITH_RESULT_EFFECT_SCALE")))
		
	local duration = frame:GetUserConfig("FRAME_DURATION")
	frame:SetDuration(duration);
end
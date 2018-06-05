function BOSSLIST_ON_INIT(addon, frame)
	


end

function TEST_BOSS_LIST()

	local frame = ui.GetFrame("bosslist");
	frame:ShowWindow(1);
	UPDATE_BOSS_LIST(frame);	

end

function SET_BOSS_PICTURE(item, bossName)

	local picUrl = config.GetToolConfig("BossWebAddr");
	picUrl = picUrl .. "/image/" .. bossName .. ".jpg";
	local monCls = GetClass("Monster", bossName);
	item = tolua.cast(item, "ui::CWebPicture");
	
	item:SetImage("fullblack");
	item:SetUrlInfo(picUrl);
	item:SetEnableStretch(1);
	item:EnableHitTest(1);
	item:SetTextTooltip(monCls.Name);
	item:SetEventScript(ui.LBUTTONUP, "RUN_BOSS_TEST");
	item:SetEventScriptArgNumber(ui.LBUTTONUP, monCls.ClassID);

end

function UPDATE_BOSS_LIST(frame)

	local bList = debug.GetWebBossList();
	local sList = StringSplit(bList, "#");
	
	local advBox = GET_CHILD(frame, "AdvBox", "ui::CAdvListBox");
	local wp = advBox:GetWidthPerCol();
	local hc = advBox:GetHeightperrow();

	local row = advBox:GetMaxColumn();
	advBox:ClearUserItems();
	local i = 1;
	local currow = 0;
	while 1 do

		if i > #sList then
			break;
		end

		local key = sList[i - currow];
		local bossName = sList[i];
		local item = advBox:SetItemByType(key, currow, "webpicture", wp, hc, 0);
		SET_BOSS_PICTURE(item, bossName);
		currow = currow + 1;
		if currow >= row then
			currow = 0;
		end

		i = i + 1;
	end	

end

function RUN_BOSS_TEST(frame, ctrl, argStr, clsID)

	control.CustomCommand("TEST_BOSS_RUN", clsID);
	frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);

end


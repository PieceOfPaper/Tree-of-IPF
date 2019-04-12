function SKILLSCP_Warrior_Guard()

	control.Guard(1);
	return 0;
end


--function SKILLSCP_Warrior_CrossGuard()

--	control.Guard(1);
	--return 0;
--end

function START_CYCLONE(actor)

	game.LoopSkillSound(actor, "skl_fgt_whirlwind", 0.14);
	return 0;
end


function MSL_DEAD_C(actor, eft, eftScale)

	actor:GetEffect():StopAllEffect(1, 0);
	actor:GetEffect():PlayEffect(eft, eftScale);

end

function MSL_MOVE_SINE(elapsedSec, totalSec, angle, pos, duration, ampl, startPos)

	local timeAdjust = math.asin(startPos);
	pos.y = (-startPos + math.sin(totalSec / duration + timeAdjust)) * ampl;

end

function MSL_MOVE_HOR(elapsedSec, totalSec, angle, pos, angleFix, radius)

	local fixedAngle = angle + math.rad(angleFix);
	pos.x = radius * math.cos(fixedAngle);
	pos.z = radius * math.sin(fixedAngle);

end

function C_SCP_PRECHECK_SHOVEL(skillType)
	local mapName = session.GetMapName();
	local zoneIES = GetClass('Map', mapName);

	if nil == zoneIES then
		return;
	end

	if "YES" == zoneIES.isVillage then
		ui.SysMsg(ClMsg("NotAllowedInTown"));
		return 0;
	end
	return 1;
end

function SKILLSCP_CART(skillType)

	local mobj = GetMyPCObject();
	local posString = GetExProp_Str(mobj, "SkillPosString");
	if posString ~= "None" then
		SetExProp_Str(mobj, "SkillPosString", "None");
		return 1;
	end


	local mapFrame = ui.GetFrame("map");
	mapFrame:ShowWindow(1);
	local eftFrame = ui.GetFrame("uieffect");
	-- 여러개 UI가 생성되는걸 방지
	if eftFrame:GetUserIValue("MAP_CHECKING") == 1 then
		return 0;
	end

	local text = EFT_FRAME_CREATE_CTRL(eftFrame, "richtext", 0, ui.GetClientInitialHeight() / 4, 600, 80);
	text = tolua.cast(text, "ui::CRichText");
	text:SetGravity(ui.CENTER_HORZ, ui.TOP);
	text:EnableResizeByText(1);
	
	text:SetText("{@st44}" .. ScpArgMsg("Auto_iDongHaKi_wonHaNeun_wiChiLeul_MaepeSeo_KeulLigHaeJuSeyo."));
	text:ShowWindow(1);
	text:RunUpdateScript("UPDATE_MAP_COOR_CHECK");
	text:SetUserValue("SkillType", skillType);
	eftFrame:SetUserValue("MAP_CHECKING", 1);
	return 0;

end

function UPDATE_MAP_COOR_CHECK(text)

	local mapFrame = ui.GetFrame("map");
	if mapFrame:IsVisible() == 0 then
		text:GetParent():SetUserValue("MAP_CHECKING", 0);
		return UI_UPDATE_DESTROY;
	end

	if mouse.IsLBtnDown() == 1 then
		local pic = mapFrame:GetChild("map");
		local x, y = GET_LOCAL_MOUSE_POS(pic);
		
		mapFrame:ShowWindow(0);
		text:GetParent():SetUserValue("MAP_CHECKING", 0);

		local posi = info.GetWorldPosByMinimapPos(x, y, 1000, nil, pic:GetWidth(), pic:GetHeight());
		local posString = "".. posi.x..' '..posi.cell .. ' ' .. posi.y;
		if posi.x ~= -1 then
			local posString = "".. posi.x..' '..posi.cell .. ' ' .. posi.y;

			local skillType = text:GetUserIValue("SkillType");
			local mobj = GetMyPCObject();
			SetExProp_Str(mobj, "SkillPosString", posString);
			control.SendSpcSkillLocation(posi.x, posi.cell, posi.y);
			control.Skill(skillType);
		end		
		
		return UI_UPDATE_DESTROY;
	end
	
	return UI_UPDATE_CONTINUE;

end





-------------------------

function SCP_SKL_IMPALER_SUBANIM(aniName)

	-- 일단 내pc에서만 보이도록 내꺼만 체크. 영상용
	local mains = session.GetMainSession();
	local buffCount = info.GetBuffCount(mains:GetHandle());
	for i = 0, buffCount - 1 do
		local buff = info.GetBuffIndexed(mains:GetHandle(), i);

		if buff.buffID == 162 then
			aniName = 'SKL_IMPALER_THROW';
			break;
		end
	end

	return aniName;
end

function SCR_SKILL_RECIPE(skillType)

	local skl = session.GetSkill(skillType);
	if skl == nil then
		return;
	end

	local obj = GetIES(skl:GetObject());

	local frame = ui.GetFrame("itemcraft_alchemist");
	SET_ITEM_CRAFT_UINAME("itemcraft_alchemist");
	SET_CRAFT_IDSPACE(frame, "Recipe_ItemCraft", obj.ClassName, obj.LevelByDB);
	CREATE_CRAFT_ARTICLE(frame);
	ui.ToggleFrame("itemcraft_alchemist");

	return 0;

end

function SCR_SKILL_PUZZLECRAFT(skillType)
    if session.colonywar.GetIsColonyWarMap() == true then
        ui.SysMsg(ClMsg('ThisLocalUseNot'));
        return 0;
    end

	local skl = session.GetSkill(skillType);
	if skl == nil then
		return;
	end

	local obj = GetIES(skl:GetObject());
	local row = 1 + math.floor(obj.LevelByDB);
	local col = 1 + math.floor(obj.LevelByDB);
	PUZZLECRAFT_SET_MAXSIZE(row, col);
	ui.ToggleFrame("puzzlecraft");
	return 0;

end

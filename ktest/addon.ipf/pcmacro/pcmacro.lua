function PCMACRO_ON_INIT(addon, frame)



end

function CLOSE_PC_MACRO(frame)

	ui.OpenFrame('quit');

end

function REFRESH_PCMACRO(frame)

	local macro = session.GetEditingPCMacro();
	local list = nil;

	local condbox = frame:GetChild("AdvBox");
	tolua.cast(condbox, "ui::CAdvListBox");
	condbox:ClearUserItems();

	local actbox = frame:GetChild("AdvBox2");
	tolua.cast(actbox, "ui::CAdvListBox");
	actbox:ClearUserItems();

	local clslist, cnt  = GetClassList("PCMacro");

	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		local key = cls.ClassID;

		local box = nil;
		if cls.Type == "Cond" then
			box = condbox;
			list = macro.condlist;
		else
			box = actbox;
			list = macro.actlist;
		end

		local ccheckbox = box:SetItemByType(key, 0, "checkbox", 12, 12, 10);
		tolua.cast(ccheckbox, "ui::CCheckBox");

		local info = session.GetPCMacroSet(list, key);
		if info ~= nil then
			ccheckbox:SetCheck(1);
		end


		ccheckbox:SetLBtnDownScp("CHECK_PCMACRO");
		ccheckbox:SetLBtnDownArgNum(key);



		box:SetItem(key, 1, GET_MACRO_EXAMPLE_TEXT(cls), "white_16");

	end

		UPDATE_PCMACRO_TXT(frame);

end


--[[
function PCMACRO_FIRST_OPEN(frame)


	local macro = session.GetEditingPCMacro();
	session.ResetMacro(macro);
	REFRESH_PCMACRO(frame);


end
--]]

function GET_MACRO_EXAMPLE_TEXT(cls)

	return cls.Example;

end

function UPDATE_PCMACRO_TXT(frame)

	frame = frame:GetTopParentFrame();

	local result = frame:GetChild("result");

	local condbox = frame:GetChild("AdvBox");
	tolua.cast(condbox, "ui::CAdvListBox");
	local actbox = frame:GetChild("AdvBox2");
	tolua.cast(actbox, "ui::CAdvListBox");

	local condcnt = condbox:GetRowItemCnt() - 1;
	local actcnt = actbox:GetRowItemCnt() - 1;

	local resulttxt = "";
	for i = 1 , condcnt do
		local ccheckbox = condbox:GetObjectXY(i, 0);
		tolua.cast(ccheckbox, "ui::CCheckBox");
		if ccheckbox:IsChecked() == 1 then

			local clsid = condbox:GetKeyByRow(i);
			local cls = GetClassByType("PCMacro", clsid);

			if resulttxt == "" then
				resulttxt = GET_MACRO_COMPLETE_TEXT(cls);
			else
				resulttxt = string.format("%s{nl}%s %s", resulttxt, GET_PCMACRO_COND(), GET_MACRO_COMPLETE_TEXT(cls));
			end
		end
	end

	if resulttxt == "" then
		result:SetText(ScpArgMsg("Auto_JoKeoneul_1Kae_iSang_SeonTaegHaeJuSeyo."));
		return;
	end

	resulttxt = ScpArgMsg("Auto_{Auto_1}{nl}ManJogSie_DaeumKyuChig_Jeogyong","Auto_1", resulttxt);

	for i = 1 , actcnt do
		local ccheckbox = actbox:GetObjectXY(i, 0);
		tolua.cast(ccheckbox, "ui::CCheckBox");
		if ccheckbox:IsChecked() == 1 then

			local clsid = actbox:GetKeyByRow(i);
			local cls = GetClassByType("PCMacro", clsid);

			if resulttxt == "" then
				resulttxt = GET_MACRO_COMPLETE_TEXT(cls);
			else
				resulttxt = string.format("%s{nl}%s", resulttxt, GET_MACRO_COMPLETE_TEXT(cls));
			end
		end
	end


	result:SetText(resulttxt);

end

function GET_MACRO_COMPLETE_TEXT(cls)

	local macro = session.GetEditingPCMacro();

	local list = nil;
	if cls.Type == "Cond" then
		list = macro.condlist;
	else
		list = macro.actlist;
	end

	local clsid = cls.ClassID;
	local info = session.GetPCMacroSet(list, clsid);

	if cls.ArgType1 == "None" then
		return cls.Name;
	elseif cls.ArgType2 == "None" then
		return string.format( cls.Name, GET_ARG_STRING(info.arg1, cls, 1) );
	else
		return string.format( cls.Name, GET_ARG_STRING(info.arg1, cls, 1), GET_ARG_STRING(info.arg2, cls, 2) );
	end

	return cls.Name;
end

function GET_ARG_STRING(arg, cls, argnum)

	local argtype = cls["ArgType" .. argnum];
	local default = nil;

	if argtype == "String" then
		default = cls["ArgDefault" .. argnum];
	elseif argtype == "Number" then
		default = cls["ArgMax" .. argnum];
	end

	local clsid = cls.ClassID;

	if arg == "None" then
		return string.format("{a EDIT_MACRO %d %d}{ul}{#3333FF}%s{/}{/}{/}", clsid, argnum, default);
	else
		return string.format("{a EDIT_MACRO %d %d}{ul}{#33FF33}%s{/}{/}{/}", clsid, argnum, arg);
	end

end

function EDIT_MACRO(type, argnum)

	local newframe = ui.CreateNewFrame("inputstring", "inputstr");
	newframe:ShowWindow(1);
	newframe:SetEnable(1);

	local title = newframe:GetChild('title');
	local edit = newframe:GetChild('input');
	tolua.cast(edit, "ui::CEditControl");

	local cls = GetClassByType("PCMacro", type);
	local macro = session.GetEditingPCMacro();
	local list = nil;
	if cls.Type == "Cond" then
		list = macro.condlist;
	else
		list = macro.actlist;
	end

	local info = session.GetPCMacroSet(list, type);
	local inittext = "";
	if info ~= nil then
		if argnum == 1 then
			inittext = info.arg1;
		else
			inittext = info.arg2;
		end
	end

	if inittext == "None" then
		inittext = "";
	end

	local argtype = cls["ArgType" .. argnum];
	if argtype == "String" then
		edit:SetNumberMode(0);
		edit:SetMaxLen(128);
		edit:SetText(inittext);

		title:SetText(ScpArgMsg("Auto_Kapeul_ipLyeogHaSeyo."));
	else
		local minnum = cls["ArgMin" .. argnum];
		local maxnum = cls["ArgMax" .. argnum];
		edit:SetNumberMode(1);
		edit:SetMinNumber(minnum);
		edit:SetMaxNumber(maxnum);
		if inittext == "" then
			edit:SetText(maxnum);
		else
			edit:SetText(inittext);
		end

		local titletxt = ScpArgMsg("Auto_{Auto_1}~_{Auto_2}_Saiui_Kapeul_ipLyeogHaSeyo", "Auto_1",minnum,"Auto_2", maxnum);
		title:SetText(titletxt);
	end


	local strscp = string.format("CONFIRM_EDIT(%d, %d)", type, argnum);

	local confirm = newframe:GetChild("confirm");
	confirm:SetLBtnUpScp(strscp);
	newframe:SetEnterKeyScript(strscp);

	ui.SetTopMostFrame(newframe);
	edit:AcquireFocus();

end

function CONFIRM_EDIT(clsid, argnum)

	local inputframe= ui.GetFrame("inputstr");
	local edit = inputframe:GetChild('input');

	local txt = edit:GetText();
	if txt == "" then
		txt = "None";
	end

	local macro = session.GetEditingPCMacro();

	local cls = GetClassByType("PCMacro", clsid);
	local list = nil;
	if cls.Type == "Cond" then
		list = macro.condlist;
	else
		list = macro.actlist;
	end

	local info = session.GetPCMacroSet(list, clsid);
	session.SetMacroArg(info, txt, argnum);

	local frame = ui.GetFrame("pcmacro");
	UPDATE_PCMACRO_TXT(frame);
	inputframe:ShowWindow(0);

end

function CHECK_PCMACRO(frame, ctrl, arg1, clsid)

	frame = frame:GetTopParentFrame();

	local macro = session.GetEditingPCMacro();
	local cls = GetClassByType("PCMacro", clsid);

	local list = nil;
	if cls.Type == "Cond" then
		list = macro.condlist;
	else
		list = macro.actlist;
	end

	local type = cls.ClassID;
	if arg1 == "true" then
		session.AddPCMacroSet(list, type);
	else
		session.RemovePCMacroSet(list, type);
	end

	UPDATE_PCMACRO_TXT(frame);

end

function GET_PCMACRO_COND()

	local macro = session.GetEditingPCMacro();
	local state = macro.condtype;
	if state == 1 then
		return ScpArgMsg("Auto_{a_TOGGLE_PCMACRO_COND}{ul}TtoNeun{/}{/}");
	else
		return ScpArgMsg("Auto_{a_TOGGLE_PCMACRO_COND}{ul}KeuLiKo{/}{/}");
	end

end

function TOGGLE_PCMACRO_COND()

	local macro = session.GetEditingPCMacro();
	if macro.condtype == 1 then
		macro.condtype = 0;
	else
		macro.condtype = 1;
	end

	local frame = ui.GetFrame("pcmacro");
	UPDATE_PCMACRO_TXT(frame);

end


function REGISTER_MACRO_SET(frame, ctrl, arg1, arg2)

	local macro = session.GetEditingPCMacro();
	if macro.condlist:Count() == 0 then
		ui.MsgBox(ScpArgMsg("Auto_JoKeoneul_1Kae_iSang_SeonTaegHaeJuSeyo."));
		return;
	end

	if macro.actlist:Count() == 0 then
		ui.MsgBox(ScpArgMsg("Auto_DongJageul_1Kae_iSang_SeonTaegHaeJuSeyo."));
		return;
	end

	frame = frame:GetTopParentFrame();
	name = frame:GetChild("input");
	tolua.cast(name, "ui::CEditControl");

	local txt = name:GetText();
	if txt == "" then
		ui.MsgBox(ScpArgMsg("Auto_KyuChig_iLeumeul_1Ja_iSang_ipLyeogHaeJuSeyo."));
		return;
	end

	local isnewmode = name:IsEnable();

	if isnewmode == 1 then
		local list = session.GetEditSetList();
		local cnt = list:Count();
		for i = 0 , cnt - 1 do

			local set = list:Element(i);
			local macroname = set.macroname;
			if macroname == txt then
				local msgstr = ScpArgMsg("Auto_[{Auto_1}]_:_iMi_JonJaeHaNeun_KyuChig_iLeumipNiDa.","Auto_1", txt);
				ui.MsgBox(msgstr);
				return;
			end

		end
	end

	pcmacro.RegisterMacroSet(txt);

	local quitframe = ui.GetFrame("quit");
	QUIT_UPDATE_MACROLIST(quitframe);

	ui.ToggleFrame("pcmacro");

end


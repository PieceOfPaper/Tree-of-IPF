
function FILEFIND_ON_INIT(addon, frame)


	
end


function DELETE_FILEFIND(frame)

	ui.MsgBox(ClientMsg(10232), "EXEC_DELETE_FILEFIND", "None");
		
end

function EXEC_DELETE_FILEFIND()

	local frame = ui.GetFrame("filefind");
	local fName = FILE_FIND_GET_FULLNAME(frame);
	filefind.DeleteFileByName(fName);
	FILE_FIND_DIR(frame, frame:GetSValue());
	
end


function SELECT_FILEFIND(frame)

	local func = _G[ frame:GetChild("t_end"):GetSValue() ];
	func( FILE_FIND_GET_FULLNAME(frame) );
	frame:ShowWindow(0);

end

function FILE_FIND_GET_FULLNAME(frame)

	local dir = frame:GetSValue();
	dir = dir .. "\\";
	local advBox = GET_CHILD(frame, "AdvBox", "ui::CAdvListBox");
	if frame:GetValue() == 0 then
		dir = dir .. advBox:GetSelectedKey();
	else
		dir = dir .. frame:GetChild("input"):GetText();
	end
	
	return dir;	

end

function FILE_FIND_BINDIR(frame, dirName, scpName, saveMode, findStr)

	if findStr ~= nil then
		frame:SetUserValue("FINDSTR", findStr);
	end

	local fullPath = filefind.GetBinPath(dirName);
	FILE_FIND_DIR(frame, fullPath:c_str());
	frame:GetChild("t_end"):SetSValue(scpName);

	if saveMode == 1 then
		frame:GetChild("input"):ShowWindow(1);
		frame:GetChild("t_end"):SetText(ScpArgMsg("Auto_{@st49}JeoJang"));
		frame:SetValue(1);
	else
		frame:GetChild("input"):ShowWindow(0);
		frame:GetChild("t_end"):SetText(ScpArgMsg("Auto_{@st49}SeonTaeg"));
		frame:SetValue(0);		
	end

end

function FILE_FIND_DIR(frame, fullPath)

	frame:SetSValue(fullPath);
	local pathTxt = filefind.GetFilenameFromFullPath(fullPath);
	frame:GetChild("t_path"):SetTextByKey("curDir", pathTxt);
	
	local advBox = GET_CHILD(frame, "AdvBox", "ui::CAdvListBox");
	advBox:ClearUserItems();
	
	local topFrame = frame:GetTopParentFrame(); 
	local findStr = topFrame:GetUserValue("FINDSTR");
	local fileList = filefind.FindDir(fullPath);
	local cnt = fileList:Count();
	for i = 0 , cnt -1  do
	
		local fName = fileList:Element(i):c_str();
		if findStr == "None" or string.find(fName, findStr) ~= nil then
			SET_ADVBOX_ITEM(advBox, fName, 0, fName, "white_16_ol");
		end
	end

	filefind.DeleteFileList(fileList);
	
	advBox:UpdateAdvBox();
	CLICK_FILE_PATH_ITEM(frame);

end

function SELECT_FILE_PATH_ITEM(frame)

	SELECT_FILEFIND(frame);

end

function CLICK_FILE_PATH_ITEM(frame)
	
	if frame:GetValue() == 0 then
		return;
	end
	
	local advBox = GET_CHILD(frame, "AdvBox", "ui::CAdvListBox");
	if advBox:GetSelectedKey() == nil then
		return;
	end
	
	frame:GetChild("input"):SetText(advBox:GetSelectedKey());
	
end

function ENTER_FILE_FIND(frame)

	if frame:GetChild("input"):IsVisible() == 0 then
		return;
	end
	
	SELECT_FILEFIND(frame);

end

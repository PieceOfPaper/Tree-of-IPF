function LOGFRAME_ON_INIT(addon, frame)
 
	local count = frame:GetChildCount();
	local isFirst = 1;
	for  i = 0, count-1 do 
		local child = frame:GetChildByIndex(i);
		if  string.find(child:GetName(), "textview")  ~=  nil  then 
			child:ShowWindow(0);
		 end 
	 end 
	
	local textViewLog = frame:GetChild("textview_log");
	textViewLog:ShowWindow(1);
 end 

function LOGFRAME_OPEN_TEXT_VIEW(frame, control, argStr, argNum)
 
	local count = frame:GetChildCount();
	for  i = 0, count-1 do 
		local child = frame:GetChildByIndex(i);
		if  string.find(child:GetName(), "textview")  ~=  nil then
			child:ShowWindow(0);
		end
	 end 

	local textView = frame:GetChild(argStr);
	textView:ShowWindow(1);
 end 

function LOGFRAME_ENTER_KEY(frame, control, argStr, argNum)
	local listbox = frame:GetChild('executelist');
	if listbox ~= nil then		
		local editbox = frame:GetChild('input');
		if editbox ~= nil then
			tolua.cast(editbox,'ui::CEditControl');			
			tolua.cast(listbox,'ui::CListBox');
			local text = editbox:GetText();
			if text ~= nil then
				loadstring(text)();
				listbox:AddItem(text, 0);
			end
		end
	end
end
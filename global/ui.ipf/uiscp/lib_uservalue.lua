---- lib_uservalue.lua --

function RUN_FUNC_BY_USRVALUE(frame, valueName, value, func)
	
	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local slot = frame:GetChildByIndex(i);
		if slot:GetUserValue(valueName) == value then
			func(slot);
		end
	end
end


function DESTROY_CHILD_BY_USERVALUE(frame, valueName, value)

	local i = 0;
	
	while i < frame:GetChildCount() do
		local slot = frame:GetChildByIndex(i);
		if slot:GetUserValue(valueName) == value then
			frame:RemoveChildByIndex(i);
		else
			i = i + 1;
		end

	end

end

function GET_CHILD_COUNT_BY_USERVALUE(frame, valueName, value)

	local retCnt = 0;
	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local slot = frame:GetChildByIndex(i);
		if slot:GetUserValue(valueName) == value then
			retCnt = retCnt + 1;
		end
	end

	return retCnt;
end

function GET_CHILD_BY_USERVALUE(frame, valueName, value)

	local retCnt = 0;
	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local slot = frame:GetChildByIndex(i);
		if slot:GetUserValue(valueName) == value then
			return slot;
		end
	end

	return nil;
end


function GET_CHILD_LIST_BY_USERVALUE(frame, valueName, value)
	local list = {}
	local retCnt = 0;
	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local slot = frame:GetChildByIndex(i);
		if slot:GetUserValue(valueName) == value then
			list[#list+1] = slot
		end
	end

	return list;
end
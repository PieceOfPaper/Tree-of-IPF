
local pvpScoreType ={
	CRYSTAL = 0,
	BATTLE = 1,
}

function MINEPVPMYSCOREBOARD_ON_INIT(addon, frame)
	
end

function SHOW_MINEPVPMYSCOREBOARD()
	ui.OpenFrame("minepvpmyscoreboard")
	local frame = ui.GetFrame("minepvpmyscoreboard")
	frame:ShowWindow(1)
end

function CLOSE_MINEPVPMYSCOREBOARD()
	ui.CloseFrame("minepvpmyscoreboard");
end

function MINEPVPMYSCOREBOARD_MAKE_NUMBER_TO_DIGIT(number)
	
	-- 최대값 제한.
	local copyNumber = number
	if copyNumber > 999999999 then
		copyNumber = 999999999
	end

	local digitList ={}
	local strNum = tostring(copyNumber)
	for digit in string.gmatch(strNum, "%d") do
		table.insert(digitList, digit)
	end

	--reverse list
	local reverseDigitList ={}
	for i = #digitList , 1, -1 do		
		table.insert(reverseDigitList, digitList[i])
	end

	return reverseDigitList;
end


function MINEPVPMYSCOREBOARD_SET_MY_SCORE(type, number)
	local frame = ui.GetFrame("minepvpmyscoreboard")
	if frame == nil then
		return
	end
	
	local gbDigit = GET_CHILD_RECURSIVELY(frame,"gbCrystal");
	local prefix = 'crystal_digit_'
	if type == pvpScoreType.BATTLE then
		prefix = 'battle_digit_'
		gbDigit = GET_CHILD_RECURSIVELY(frame,"gbBattle");
	end

	if gbDigit == nil then
		return
	end
	
	local digitList = MINEPVPMYSCOREBOARD_MAKE_NUMBER_TO_DIGIT(number)
	local digitIndex = 0
	local count = #digitList

	local picDigitDot_0 = GET_CHILD(gbDigit, prefix.."dot_0", "ui::CPicture");
	local picDigitDot_1 = GET_CHILD(gbDigit, prefix.."dot_1", "ui::CPicture");
	if picDigitDot_0 ~= nil and picDigitDot_1 ~= nil then
		-- 먼저 dot를 찍는다.
		if count > 6 then
			-- 6 보다 크면 두개를 찍음.
			picDigitDot_0:ShowWindow(1)
			picDigitDot_1:ShowWindow(1)
		elseif count > 3 then
			-- 3보다 크면 dot_0은 찍고 dot_1은 끔
			picDigitDot_0:ShowWindow(1)
			picDigitDot_1:ShowWindow(0)
		else 
			-- 둘다 끔
			picDigitDot_0:ShowWindow(0)
			picDigitDot_1:ShowWindow(0)

		end
	end
	
	local maxDigit = 8
	-- 모든 Digit을 순회 하면서 값이 있는것은 찍고 없는것(nil)이면 끔.
	for i=0, maxDigit do
		local picDigit = GET_CHILD(gbDigit, prefix..tostring(i), "ui::CPicture");
		local value = digitList[i+1]
		if picDigit ~= nil then		
			if value ~= nil then
				picDigit:SetImage("mine_pvp_imgfont_"..value);
				picDigit:ShowWindow(1)
			else
				picDigit:ShowWindow(0)
			end
		end
	end
end

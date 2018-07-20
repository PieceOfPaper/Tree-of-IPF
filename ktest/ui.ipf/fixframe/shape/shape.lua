function SHAPE_ON_INIT(addon, frame)
	
	
end


function SHAPE_PREVIOUS_VALUE()
	-- 기존 값을 가지고 온다
	local DefaultColorChannel				= CREATECHAR_DEFAULT_COLOR()
	local ColorClass	= {}
	local ClassNum;
	
	for i = 1, 4 do
		ClassNum	= 200 + i
		if barrack.GetValue(ClassNum) ~= nil then
			-- 설정된 초기 값이 있다
			ColorClass[ClassNum]	= barrack.GetValue(ClassNum)
		else
			-- 설정된 초기 값이 없으므로 본래의 값으로 돌린다
			ColorClass[ClassNum]	= DefaultColorChannel[ClassNum]['Default']
		end
	end
	
	for i = 1, 4 do
		ClassNum	= 210 + i
		if barrack.GetValue(ClassNum) ~= nil then
			-- 설정된 초기 값이 있다
			ColorClass[ClassNum]	= barrack.GetValue(ClassNum)
		else
			-- 설정된 초기 값이 없으므로 본래의 값으로 돌린다
			ColorClass[ClassNum]	= DefaultColorChannel[ClassNum]['Default']
		end
	end
	
	return ColorClass;
end

function SHAPE_COLOR_RESET(frame, object, argStr, argNum)
	-- 컬러를 초기화 한다
	

end

function SHAPE_SLIDEVALUE(frame, object, argStr, argNum)
	-- 컬러에 대한 Value 값을 적용
	local DefaultColorChannel				= CREATECHAR_DEFAULT_COLOR();
	
	-- 현재 설정 모드를 가지고 온다
	local DataName 							= CREATECHAR_EXTERANL_EditData;
	
	-- 컨트롤을 등록한다
	local slidebar_Color_Red				= frame:GetChild('Color_Red');
	local slidebar_Color_Green				= frame:GetChild('Color_Green');
	local slidebar_Color_Blue				= frame:GetChild('Color_Blue');
	local slidebar_Color_Density			= frame:GetChild('Color_Density');
	
	local slidebar_Color_RedCtrl			= tolua.cast(slidebar_Color_Red, "ui::CSlideBar");
	local slidebar_Color_GreenCtrl		= tolua.cast(slidebar_Color_Green, "ui::CSlideBar");
	local slidebar_Color_BlueCtrl			= tolua.cast(slidebar_Color_Blue, "ui::CSlideBar");
	local slidebar_Color_DensityCtrl		= tolua.cast(slidebar_Color_Density, "ui::CSlideBar");
	
	local ClassLine;

	if DataName == 'Hair'	then
		ClassLine		=	200;
	elseif DataName == 'Face' then
		ClassLine		=	210;
	else
		print(ScpArgMsg("Auto_SeulLaiDeuui_KiBon_Kapeul_SeolJeongHal_Su_eopSeupNiDa"));
		return 0;
	end
	
	-- 최소 값은 0으로 통일 시킨다
	slidebar_Color_RedCtrl:SetMinSlideLevel(0);
	slidebar_Color_GreenCtrl:SetMinSlideLevel(0);
	slidebar_Color_BlueCtrl:SetMinSlideLevel(0);
	slidebar_Color_DensityCtrl:SetMinSlideLevel(0);
	
	-- 기본 값에 대한 것은 따로 설정	(이전 설정되어 있는 값을 불러 온다)
	-- (역수에 의한 오프셋을 준다)
	local SetColorValue	= SHAPE_PREVIOUS_VALUE();
	slidebar_Color_RedCtrl:SetLevel(SetColorValue[ClassLine + 1] - DefaultColorChannel[ClassLine + 1]['Min']);
	slidebar_Color_GreenCtrl:SetLevel(SetColorValue[ClassLine + 2] - DefaultColorChannel[ClassLine + 2]['Min']);
	slidebar_Color_BlueCtrl:SetLevel(SetColorValue[ClassLine + 3] - DefaultColorChannel[ClassLine + 3]['Min']);
	slidebar_Color_DensityCtrl:SetLevel(SetColorValue[ClassLine + 4] - DefaultColorChannel[ClassLine + 4]['Min']);
	
	-- 맥스 값을 위한 역수 계산
	local inverse_R		= DefaultColorChannel[ClassLine + 1 ]['Max'] - (DefaultColorChannel[ClassLine + 1]['Min'])
	local inverse_G		= DefaultColorChannel[ClassLine + 2 ]['Max'] - (DefaultColorChannel[ClassLine + 2]['Min'])
	local inverse_B		= DefaultColorChannel[ClassLine + 3 ]['Max'] - (DefaultColorChannel[ClassLine + 3]['Min'])
	local inverse_D		= DefaultColorChannel[ClassLine + 4 ]['Max'] - (DefaultColorChannel[ClassLine + 4]['Min'])
	
	-- 슬라이드 바의 최대치를 적용 한다.
	slidebar_Color_RedCtrl:SetMaxSlideLevel(inverse_R);
	slidebar_Color_GreenCtrl:SetMaxSlideLevel(inverse_G);
	slidebar_Color_BlueCtrl:SetMaxSlideLevel(inverse_B);
	slidebar_Color_DensityCtrl:SetMaxSlideLevel(inverse_D);
	
	-- 텍스트 오브젝트를 등록한다
	local RichTextObj_Red					= frame:GetChild('Color_Red_Value');
	local RichTextObj_Green				= frame:GetChild('Color_Green_Value');
	local RichTextObj_Blue					= frame:GetChild('Color_Blue_Value');
	local RichTextObj_Density				= frame:GetChild('Color_Density_Value');
	
	local RichTextCtrl_Red					= tolua.cast(RichTextObj_Red, "ui::CEditControl");
	local RichTextCtrl_Green				= tolua.cast(RichTextObj_Green, "ui::CEditControl");
	local RichTextCtrl_Blue					= tolua.cast(RichTextObj_Blue, "ui::CEditControl");
	local RichTextCtrl_Density				= tolua.cast(RichTextObj_Density, "ui::CEditControl");

	-- 현재 설정된 값을 TextObject에 적용한다 
	RichTextCtrl_Red:SetText(SetColorValue[ClassLine + 1]);
	RichTextCtrl_Green:SetText(SetColorValue[ClassLine + 2]);
	RichTextCtrl_Blue:SetText(SetColorValue[ClassLine + 3]);
	RichTextCtrl_Density:SetText(SetColorValue[ClassLine + 4]);
end



function SHAPE_RESET(frame, object, argStr, argNum)

	-- 모든 값을 리셋한다. (초기 값을 먼저 적용 시킨다)
	-- 값을 적용 시킨다
	local DefaultColorChannel				= CREATECHAR_DEFAULT_COLOR()		-- 본래의 정보를 긁어온다
	print(ScpArgMsg("Auto_HyeonJae_TaeiBeului_Kap_KaeSu_:_") .. table.getn(DefaultColorChannel));
	
	local ClassLine;
	
	for i = 1, 4 do
		ClassLine = 200 + i
		barrack.SelectColor(DefaultColorChannel[ClassLine]['ClassID'], DefaultColorChannel[ClassLine]['Default']);
	end
	
	for i = 1, 4 do
		ClassLine = 210 + i
		barrack.SelectColor(DefaultColorChannel[ClassLine]['ClassID'], DefaultColorChannel[ClassLine]['Default']);
	end
	
	-- 현재 편집 중인 데이터의 기본 슬라이드 값을 적용 시킨다
	if SHAPE_frame ~= nil then	
		SHAPE_SLIDEVALUE(frame, object, argStr, argNum)
	end
end


function SHAPE_RANDOM(frame, object, argSrg, argNum)
	-- 모든 값을 랜덤
	-- 값을 적용 시킨다
	local DefaultColorChannel				= CREATECHAR_DEFAULT_COLOR()		-- 본래의 정보를 긁어온다
	print(ScpArgMsg("Auto_HyeonJae_TaeiBeului_Kap_KaeSu_:_") .. table.getn(DefaultColorChannel));
	
	local ClassLine;
	
	for i = 1, 4 do
		ClassLine = 200 + i
		local Random	= IMCRandom(DefaultColorChannel[ClassLine]['Min'], DefaultColorChannel[ClassLine]['Max']);
		barrack.SelectColor(DefaultColorChannel[ClassLine]['ClassID'], Random);
	end
	
	for i = 1, 4 do
		ClassLine = 210 + i
		local Random	= IMCRandom(DefaultColorChannel[ClassLine]['Min'], DefaultColorChannel[ClassLine]['Max']);
		barrack.SelectColor(DefaultColorChannel[ClassLine]['ClassID'], Random);
	end

	-- 현재 편집 중인 데이터의 기본 슬라이드 값을 적용 시킨다
	if SHAPE_frame ~= nil then	
		SHAPE_SLIDEVALUE(frame, object, argStr, argNum)
	end
end


function SHAPE_CONTROLSET(frame, object, argStr, argNum)

	-- 리셋이 아닌 기존 편집 값을 가지고 오도록 한다.
	-- SHAPE_RESET(frame, object, argStr, argNum);
	
	SHAPE_frame			= frame;
	SHAPE_SLIDEVALUE(SHAPE_frame, object, argStr, argNum)
	
	print(ScpArgMsg("Auto_KeonTeuLol_Seseul_ChulLyeogHapNiDa"));
	local Data		 			= CREATECHAR_EXTERANL_Datatable;
	local DataName 		= CREATECHAR_EXTERANL_EditData;
	
	-- 그룹을 등록한다
	local CharExteranlSetListBoxObj			= frame:GetChild('ItemGroup');
	local CharExteranlSetListBoxCtrl			= tolua.cast(CharExteranlSetListBoxObj, "ui::CGroupBox");
	local PrintCount								= 1
	local GetDataCount							= table.getn(Data[DataName]['Data']);
	print(GetDataCount .. ScpArgMsg('Auto_SeonTaegDoen_aiTemui_SusJaya'));

	-- 여기에 기존 리스트를 초기화 하는 것을 넣는다.
	CharExteranlSetListBoxCtrl:DeleteAllControl();		-- 일단 초기화를 한다
	
	-- 일단 기존 아이템을 등록하자
	CREATECHAR_controlsetItem		=	nil

	for i = 1, GetDataCount do
		local ControlSetName		= 'ControlSet' .. DataName .. i;
		local VerticalPoint;
				
		if PrintCount > 3 then
			VerticalPoint = 4
		else
			VerticalPoint = 0
		end
		
		if CREATECHAR_controlsetItem == nil then
			VerticalPoint = 4
		end
		
		local ControlSetObj			= CharExteranlSetListBoxCtrl:CreateControlSet('CreateSet_Type01', ControlSetName, 4, VerticalPoint);
		local ControlSetCtrl			= tolua.cast(ControlSetObj, "ui::CControlSet");
		ControlSetCtrl:SetEnableSelect(1);
		ControlSetCtrl:SetSelectGroupName("ControlSet");
		
		-- 정렬을 위해 한줄당 아이템이 몇개나 들어 갈 수 있는지 확인해라
		local PrintNum = math.floor((CharExteranlSetListBoxCtrl:GetWidth() / (ControlSetCtrl:GetWidth() + 4)) - 0.2)
		
		-- 데이터 정렬에 따른 알고리즘을 넣어라
		if  CREATECHAR_controlsetItem == nil  then 
			-- 일단 아무 값이 없다면 왼쪽위에 아이템을 출력해라
			ControlSetCtrl:SetGravity(ui.LEFT, ui.TOP);
		 else   
			-- 아이템 정렬에 대한 알고리즘
			if PrintCount > PrintNum - 1 then
				-- 찍을 개수가 한줄의 양보다 초과 하면, 다음줄로 내려라
				ControlSetCtrl:SetSnap(CREATECHAR_controlsetItem, ui.AS_BOTTOM, ui.AS_NONE);				
				PrintCount = 1
			else
				-- PrintCount개수가 아직 한줄이 넘어가지 않을 정도라면 오른쪽에 프린트 한다
				ControlSetCtrl:SetSnap(CREATECHAR_controlsetItem, ui.AS_RIGHT, ui.AS_TOP);
				PrintCount = PrintCount + 1
			end
		 end 
		 
		-- 슬롯의 정보를 넣는다
		local ConSetBySlot 		= ControlSetCtrl:GetChild('slot');
		local slot						= tolua.cast(ConSetBySlot, "ui::CSlot");
		local icon = CreateIcon(slot);
		local itemIcon				= 'icon_' .. CREATECHAR_selectgendernum .. '_' .. Data[DataName]['Data'][i]['Icon']
		local Caption				= Data[DataName]['Data'][i]['Caption']
	
		icon:SetImage(itemIcon);
		
		-- 반활할 데이터
		-- 패턴을 정의하도록 하자
		local returnArgStr = 'PartsNum:' .. Data[DataName]['PartsNum'] .. 'Value:' .. i .. 'Caption:' .. Caption..'.DataName:' .. DataName
		
		
		-- 클릭 관련 이벤트를 넣는다
		-- slot을 클릭하더라도, 컨트롤 셋이 선택되도록 한다
		slot:SetEventScript(ui.LBUTTONDOWN, 'SHAPE_CLICK_ITEM')
		slot:SetEventScriptArgString(ui.LBUTTONDOWN, returnArgStr);
		
		-- 기존 아이템을 등록한다
		CREATECHAR_controlsetItem		= ControlSetCtrl;
	end
	CharExteranlSetListBoxCtrl:UpdateData();	
end

-- 아이템 클릭 관련 함수를 넣어라
function SHAPE_CLICK_ITEM(frame, data, argStr, argNum)
	CREATECHAR_CUSTOMIZE_Check		= 'YES'
	print(argStr);
	
	-- 정의된 패턴을 해석한다
	print (argStr .. ScpArgMsg('Auto_KiBon_Kap'));
	local PartsNum, dataNum, Caption, SlotName		= string.match(argStr, 'PartsNum:(%d+)Value:(%d+)Caption:(.+)%.DataName:(.+)');
	
	PartsNum			= tonumber(PartsNum);
	dataNum			= tonumber(dataNum);
	Caption			= tostring(Caption);
	SlotName			= tostring(SlotName);
	
	-- 아이콘을 정의 한다
	if SlotName ==  'Hair' then
		CREATECHAR_HairSlotCtrl:SetText(Caption);
	elseif SlotName == 'Face' then
		CREATECHAR_FaceSlotCtrl:SetText(Caption);
	elseif SlotName == 'Tatoo1' then
		CREATECHAR_TatooSlot01Ctrl:SetText(Caption);
	elseif SlotName == 'Tatoo2' then
		CREATECHAR_TatooSlot02Ctrl:SetText(Caption);
	end
	
	barrack.SelectParts(PartsNum, dataNum);
	-- SelectframeOpenAnim = 'FALSE'
	-- ui.CloseFrame('shape')
end

-- 프레임을 닫는다
function SHAPE_CLOSE_BUTTON(frame, data, argStr, argNum)
	SelectframeOpenAnim = 'FALSE'
	SHAPE_frame = nil
	barrack.SetFaceMode(0);					-- 카메라 축소
	ui.CloseFrame('shape')
end


-- 컬러 변경
function SHAPE_COLOR_R(frame, slot, argStr, argNum)
	local RichTextObj_Red			= frame:GetChild('Color_Red_Value');
	local RichTextCtrl_Red			= tolua.cast(RichTextObj_Red, "ui::CEditControl");
	local DefaultColorChannel		= CREATECHAR_DEFAULT_COLOR();

	local Modify_ClassID;
	
	if CREATECHAR_EXTERANL_EditData == 'Hair' then
		Modify_ClassID	= 201;
	else
		Modify_ClassID	= 211;
	end
	
	-- 텍스트 오브젝트에 출력
	local Value		= argNum + DefaultColorChannel[Modify_ClassID]['Min'];		-- 실질적으로 적용 되는 데이터는 슬라이드바의 값 - 최소 값이 된다
	
	RichTextCtrl_Red:SetText(Value);
	barrack.SelectColor(Modify_ClassID, Value);		
end


function SHAPE_COLOR_G(frame, slot, argStr, argNum)
	local RichTextObj_Green		= frame:GetChild('Color_Green_Value');
	local RichTextCtrl_Green		= tolua.cast(RichTextObj_Green, "ui::CEditControl");
	local DefaultColorChannel		= CREATECHAR_DEFAULT_COLOR();
	
	local Modify_ClassID;
	
	if CREATECHAR_EXTERANL_EditData == 'Hair'  then
		Modify_ClassID	= 202;
	elseif CREATECHAR_EXTERANL_EditData =='Face' then
		Modify_ClassID	= 212;
	end
	
	-- 텍스트 오브젝트에 출력
	local Value		= argNum + DefaultColorChannel[Modify_ClassID]['Min'];		-- 실질적으로 적용 되는 데이터는 슬라이드바의 값 - 최소 값이 된다
	
	RichTextCtrl_Green:SetText(Value);
	barrack.SelectColor(Modify_ClassID, Value )
end

function SHAPE_COLOR_B(frame, slot, argStr, argNum)
	local RichTextObj_Blue		= frame:GetChild('Color_Blue_Value');
	local RichTextCtrl_Blue		= tolua.cast(RichTextObj_Blue, "ui::CEditControl");
	local DefaultColorChannel		= CREATECHAR_DEFAULT_COLOR();
	
	local Modify_ClassID;
	
	if CREATECHAR_EXTERANL_EditData == 'Hair' then
		Modify_ClassID	= 203;
	elseif CREATECHAR_EXTERANL_EditData =='Face' then
		Modify_ClassID	= 213;
	end	

	-- 텍스트 오브젝트에 출력
	local Value		= argNum + DefaultColorChannel[Modify_ClassID]['Min'];		-- 실질적으로 적용 되는 데이터는 슬라이드바의 값 - 최소 값이 된다
	
	RichTextCtrl_Blue:SetText(Value);
	barrack.SelectColor(Modify_ClassID, Value )
end

function SHAPE_COLOR_D(frame, slot, argStr, argNum)
	local RichTextObj_Density	= frame:GetChild('Color_Density_Value');
	local RichTextCtrl_Density	= tolua.cast(RichTextObj_Density, "ui::CEditControl");
	local DefaultColorChannel		= CREATECHAR_DEFAULT_COLOR();
	
	local Modify_ClassID;
	
	if CREATECHAR_EXTERANL_EditData == 'Hair' then
		Modify_ClassID	= 204;
	elseif CREATECHAR_EXTERANL_EditData =='Face' then
		Modify_ClassID	= 214;
	end

	-- 텍스트 오브젝트에 출력
	local Value		= argNum + DefaultColorChannel[Modify_ClassID]['Min'];		-- 실질적으로 적용 되는 데이터는 슬라이드바의 값 - 최소 값이 된다
	
	RichTextCtrl_Density:SetText(Value);
	barrack.SelectColor(Modify_ClassID, Value )
end


-- EditBox를 통한 값 변경
function SHAPE_COLOR_R_EDITBOX(frame, slot, argStr, argNum)
	
	local DefaultColorChannel				= CREATECHAR_DEFAULT_COLOR();
	local RichTextObj_Red					= frame:GetChild('Color_Red_Value');
	local RichTextCtrl_Red					= tolua.cast(RichTextObj_Red, "ui::CEditControl");	
	local Value									= RichTextCtrl_Red:GetText();
	
	if pcall(function ()	
		Value	= tonumber(Value)
		Value	= Value + 0;
	end) then
		-- 오류나지 않음
		Value	= tonumber(Value);
	else
		-- 오류났음
		print(ScpArgMsg("Auto_oLyuKa_BalSaengHayeo_BonLaeui_KapeuLo_DolLim"));
		Value	= DefaultColorChannel[1]['Default']
	end
	
	if Value < DefaultColorChannel[1]['Min'] or Value > DefaultColorChannel[1]['Max'] then
		if Value < DefaultColorChannel[1]['Min'] then
			Value = DefaultColorChannel[1]['Min'];
		elseif Value > DefaultColorChannel[1]['Max'] then
			Value = DefaultColorChannel[1]['Max']
		else
			Value = DefaultColorChannel[1]['Default']
			print(ScpArgMsg("Auto_Kapeul_ByeonKyeongHal_Su_eopeum"));
		end
	end
	
	-- 변경된 값을 적용 시킨다
	RichTextCtrl_Red:SetText(Value);	
	SHAPE_SLIDEVALUE(frame, object, argStr, argNum);		-- 슬라이드바에 값을 적용 시킨다

	local Modify_ClassID;
	
	if CREATECHAR_EXTERANL_EditData == 'Hair' then
		Modify_ClassID	= 201;
	else
		Modify_ClassID	= 211;
	end
	
	barrack.SelectColor(Modify_ClassID, Value);
end


function SHAPE_COLOR_G_EDITBOX(frame, slot, argStr, argNum)

	local DefaultColorChannel				= CREATECHAR_DEFAULT_COLOR();
	local RichTextObj_Green				= frame:GetChild('Color_Green_Value');
	local RichTextCtrl_Green				= tolua.cast(RichTextObj_Green, "ui::CEditControl");
	local Value									= RichTextCtrl_Green:GetText();
	
	if pcall(function ()	
		Value	= tonumber(Value)
		Value	= Value + 0;
	end) then
		-- 오류나지 않음
		Value	= tonumber(Value);
	else
		-- 오류났음
		print(ScpArgMsg("Auto_oLyuKa_BalSaengHayeo_BonLaeui_KapeuLo_DolLim"));
		Value	= DefaultColorChannel[2]['Default']
	end
	
	if Value < DefaultColorChannel[2]['Min'] or Value > DefaultColorChannel[2]['Max'] then
		if Value < DefaultColorChannel[2]['Min'] then
			Value = DefaultColorChannel[2]['Min'];
		elseif Value > DefaultColorChannel[2]['Max'] then
			Value = DefaultColorChannel[2]['Max']
		else
			Value = DefaultColorChannel[2]['Default']
			print(ScpArgMsg("Auto_Kapeul_ByeonKyeongHal_Su_eopeum"));
		end
	end
	
	-- 변경된 값을 적용 시킨다
	RichTextCtrl_Green:SetText(Value);
	SHAPE_SLIDEVALUE(frame, object, argStr, argNum);		-- 슬라이드바에 값을 적용 시킨다
	
	local Modify_ClassID;
	
	if CREATECHAR_EXTERANL_EditData == 'Hair'  then
		Modify_ClassID	= 202;
	elseif CREATECHAR_EXTERANL_EditData =='Face' then
		Modify_ClassID	= 212;
	end
	
	barrack.SelectColor(Modify_ClassID, Value )
end

function SHAPE_COLOR_B_EDITBOX(frame, slot, argStr, argNum)

	local DefaultColorChannel				= CREATECHAR_DEFAULT_COLOR();
	local RichTextObj_Blue		= frame:GetChild('Color_Blue_Value');
	local RichTextCtrl_Blue		= tolua.cast(RichTextObj_Blue, "ui::CEditControl");
	local Value						= RichTextCtrl_Blue:GetText();

	if pcall(function ()	
		Value	= tonumber(Value)
		Value	= Value + 0;
	end) then
		-- 오류나지 않음
		Value	= tonumber(Value);
	else
		-- 오류났음
		print(ScpArgMsg("Auto_oLyuKa_BalSaengHayeo_BonLaeui_KapeuLo_DolLim"));
		Value	= DefaultColorChannel[3]['Default']
	end
	
	if Value < DefaultColorChannel[3]['Min'] or Value > DefaultColorChannel[3]['Max'] then
		if Value < DefaultColorChannel[3]['Min'] then
			Value = DefaultColorChannel[3]['Min'];
		elseif Value > DefaultColorChannel[3]['Max'] then
			Value = DefaultColorChannel[3]['Max']
		else
			Value = DefaultColorChannel[3]['Default']
			print(ScpArgMsg("Auto_Kapeul_ByeonKyeongHal_Su_eopeum"));
		end
	end
	
	-- 변경된 값을 적용 시킨다
	RichTextCtrl_Blue:SetText(Value);
	SHAPE_SLIDEVALUE(frame, object, argStr, argNum);		-- 슬라이드바에 값을 적용 시킨다
	
	local Modify_ClassID;
	
	if CREATECHAR_EXTERANL_EditData == 'Hair' then
		Modify_ClassID	= 203;
	elseif CREATECHAR_EXTERANL_EditData =='Face' then
		Modify_ClassID	= 213;
	end	
	
	barrack.SelectColor(Modify_ClassID, Value )
end

function SHAPE_COLOR_D_EDITBOX(frame, slot, argStr, argNum)

	local DefaultColorChannel				= CREATECHAR_DEFAULT_COLOR();
	local RichTextObj_Density	= frame:GetChild('Color_Density_Value');
	local RichTextCtrl_Density	= tolua.cast(RichTextObj_Density, "ui::CEditControl");
	local Value						= RichTextCtrl_Density:GetText();
	
	if pcall(function ()	
		Value	= tonumber(Value)
		Value	= Value + 0;
	end) then
		-- 오류나지 않음
		Value	= tonumber(Value);
	else
		-- 오류났음
		print(ScpArgMsg("Auto_oLyuKa_BalSaengHayeo_BonLaeui_KapeuLo_DolLim"));
		Value	= DefaultColorChannel[4]['Default']
	end
	
	if Value < DefaultColorChannel[4]['Min'] or Value > DefaultColorChannel[4]['Max'] then
		if Value < DefaultColorChannel[4]['Min'] then
			Value = DefaultColorChannel[4]['Min'];
		elseif Value > DefaultColorChannel[4]['Max'] then
			Value = DefaultColorChannel[4]['Max']
		else
			Value = DefaultColorChannel[4]['Default']
			print(ScpArgMsg("Auto_Kapeul_ByeonKyeongHal_Su_eopeum"));
		end
	end
	
	-- 변경된 값을 적용 시킨다
	RichTextCtrl_Density:SetText(Value);
	SHAPE_SLIDEVALUE(frame, object, argStr, argNum);		-- 슬라이드바에 값을 적용 시킨다
		
	local Modify_ClassID;
	
	if CREATECHAR_EXTERANL_EditData == 'Hair' then
		Modify_ClassID	= 204;
	elseif CREATECHAR_EXTERANL_EditData =='Face' then
		Modify_ClassID	= 214;
	end
	
	barrack.SelectColor(Modify_ClassID, Value )
end


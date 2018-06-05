function PROPERTYCOMPARE_ON_INIT(addon, frame)
end

function PROPERTYCOMPARE_RESPONSE(frame, name, lv, money, grade, rating)

	frame = tolua.cast(frame, "ui::CFrame");

	local targetName = GET_CHILD(frame, 'target', 'ui::CRichText')

	targetName:SetText('{@st43}'..name)


	local myLv = GET_CHILD(frame, 'my_level', 'ui::CRichText')
	local targetLv = GET_CHILD(frame, 'target_level', 'ui::CRichText')

	myLv:SetText('{@st43}'..info.GetLevel(session.GetMyHandle()));
	targetLv:SetText('{@st43}'..lv);
	

	local myMoney = GET_CHILD(frame, 'my_money', 'ui::CRichText')
	local targetMoney = GET_CHILD(frame, 'target_money', 'ui::CRichText')

	myMoney:SetText('{@st43}'..GET_TOTAL_MONEY())
	targetMoney:SetText('{@st43}'..money);


	--local myGrade = GET_CHILD(frame, 'my_grade', 'ui::CRichText')
	--local targetGrade = GET_CHILD(frame, 'target_grade', 'ui::CRichText')


end
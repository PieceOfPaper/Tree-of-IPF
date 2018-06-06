function OPTION_ON_INIT(addon, frame)										
 	
	addon:RegisterMsg("OPTION_UPDATE", "OPTION_ON_MSG")
 end 
 
 function OPTION_ON_MSG(frame, msg, argStr, argNum)	
	
	if (msg == "OPTION_UPDATE") then
		OPTION_UPDATEALL(frame, nil, argStr, argNum)
	end
 end

 function OPTION_UPDATEALL(frame, obj, argStr, argNum)	
 	
	local currentValue 	= option.GetCamType();
	local maxValue 		= 5; -- 최대 시야에 대한 고정값
	OPTION_UPDATE_SLIDER(frame, 'VisibleRange', currentValue, maxValue);
	OPTION_UPDATE_TEXT(frame, 'VisibleRangeText', currentValue, maxValue);
	
--	maxValue 		= geScene.option.GetMaxViewDistance();
--	currentValue 	= option.GetDynamicObjectViewDistance();
	maxValue		= 1000;	
	currentValue		= 1000;
	OPTION_UPDATE_SLIDER(frame, 'ObjectVisibleRange', currentValue, maxValue);
	OPTION_UPDATE_TEXT(frame, 'ObjectVisibleRangeText', currentValue, maxValue);

--	currentValue 	= geScene.option.GetStaticObjectViewDistance();
	maxValue		= 3000;	
	currentValue		= 3000;
	OPTION_UPDATE_SLIDER(frame, 'StaticObjectVisibleRange', currentValue, maxValue);
	OPTION_UPDATE_TEXT(frame, 'StaticObjectVisibleRangeText', currentValue, maxValue);	
		
	maxValue 		= 100; -- 최대 시야에 대한 비율값
	currentValue = geScene.option.GetTerrainDetailRange("GRASS");	
	OPTION_UPDATE_SLIDER(frame, 'Slider_TerrainGrass', currentValue, maxValue);
	OPTION_UPDATE_TEXT(frame, 'RangeText_TerrainGrass', currentValue, maxValue);
	
	currentValue = geScene.option.GetTerrainDetailRange("TREE");
	OPTION_UPDATE_SLIDER(frame, 'Slider_TerrainTree', currentValue, maxValue);
	OPTION_UPDATE_TEXT(frame, 'RangeText_TerrainTree', currentValue, maxValue);	
	
	currentValue = geScene.option.GetTerrainDetailRange("OBJECT");
	OPTION_UPDATE_SLIDER(frame, 'Slider_TerrainObject', currentValue, maxValue);
	OPTION_UPDATE_TEXT(frame, 'RangeText_TerrainObject', currentValue, maxValue);	
	
	-- 섀도우맵 옵션 업데이트
	local isChecked = geScene.option.IsUseShadowMap();	
	local Obj_Shadow 	= frame:GetChild('Toggle_Shadow');
	local Check_Shadow 	= tolua.cast(Obj_Shadow, "ui::CCheckBox");	
	Check_Shadow:SetCheck(isChecked);

	-- SSAO 옵션 업데이트
	local isChecked = geScene.option.IsUseSSAO();	
	local Obj_SSAO = frame:GetChild('Toggle_SSAO');
	local Check_SSAO = tolua.cast(Obj_SSAO, "ui::CCheckBox");	
	Check_SSAO:SetCheck(isChecked);
			
	-- 물반사 옵션 업데이트
	isChecked = option.IsUseCharacterWaterReflection();
	local Obj_ObjectReflection		= frame:GetChild('Toggle_ObjectReflection');
	local Check_ObjectReflection 	= tolua.cast(Obj_ObjectReflection, "ui::CCheckBox");	
	Check_ObjectReflection:SetCheck(isChecked);
		
	isChecked = geScene.option.IsUseBGWaterReflection();
	local Obj_BackGroundReflection 		= frame:GetChild('Toggle_BackgroundReflection');
	local Check_BackGroundReflection 	= tolua.cast(Obj_BackGroundReflection, "ui::CCheckBox");	
	Check_BackGroundReflection:SetCheck(isChecked);	
	
 end
 
 function OPTION_UPDATE_SLIDER(frame, name, value, maxValue) 
	local obj 		= frame:GetChild(name);	
	local slideBar 	= tolua.cast(obj, "ui::CSlideBar");	
	slideBar:SetMaxSlideLevel(maxValue);	
	slideBar:SetLevel(value);
 end 
 
 function OPTION_UPDATE_TEXT(frame, name, value, maxValue) 
	local textObject = frame:GetChild(name);
	local text = '{#8888FF}' .. value .. '{/} / ' .. maxValue;
	textObject:SetText(text);
 end 
 
 -- 시야거리
 function OPTION_VIEWDISTANCE(frame, obj, argStr, argNum)
 
	local slideBar = tolua.cast(obj, "ui::CSlideBar");	
	local currentValue 	= slideBar:GetLevel();
	local maxValue 		= slideBar:GetMaxLevel();
	
	option.SetCamType(currentValue);	
	OPTION_UPDATE_TEXT(frame, 'VisibleRangeText', currentValue, maxValue);
 end
 
 
 function OPTION_VIEWDISTANCE_DYNAMIC_OBJECT(frame, obj, argStr, argNum)
 
	local slideBar = tolua.cast(obj, "ui::CSlideBar");	
	local currentValue 	= slideBar:GetLevel();
	local maxValue 		= slideBar:GetMaxLevel();
	
	option.SetDynamicObjectViewDistance(currentValue);	
	OPTION_UPDATE_TEXT(frame, 'ObjectVisibleRangeText', currentValue, maxValue);	
 end
 
 function OPTION_VIEWDISTANCE_STATIC_OBJECT(frame, obj, argStr, argNum)
  
	local slideBar = tolua.cast(obj, "ui::CSlideBar");	
	local currentValue 	= slideBar:GetLevel();
	local maxValue 		= slideBar:GetMaxLevel();
	
	geScene.option.SetStaticObjectViewDistance(currentValue);
	OPTION_UPDATE_TEXT(frame, 'StaticObjectVisibleRangeText', currentValue, maxValue);	
 end
 
 function OPTION_VIEWDISTANCE_GRASS(frame, obj, argStr, argNum)
  
	local slideBar = tolua.cast(obj, "ui::CSlideBar");	
	local currentValue 	= slideBar:GetLevel();
	local maxValue 		= slideBar:GetMaxLevel();
	
	geScene.option.SetTerrainDetailRange("GRASS", currentValue);		
	OPTION_UPDATE_TEXT(frame, 'RangeText_TerrainGrass', currentValue, maxValue);
 end
  
 function OPTION_VIEWDISTANCE_TREE(frame, obj, argStr, argNum)
  
	local slideBar = tolua.cast(obj, "ui::CSlideBar");	
	local currentValue 	= slideBar:GetLevel();
	local maxValue 		= slideBar:GetMaxLevel();
	
	geScene.option.SetTerrainDetailRange("TREE", currentValue);		
	OPTION_UPDATE_TEXT(frame, 'RangeText_TerrainTree', currentValue, maxValue);
 end
 
 function OPTION_VIEWDISTANCE_OBJECT(frame, obj, argStr, argNum)
  
	local slideBar = tolua.cast(obj, "ui::CSlideBar");	
	local currentValue 	= slideBar:GetLevel();
	local maxValue 		= slideBar:GetMaxLevel();
	
	geScene.option.SetTerrainDetailRange("OBJECT", currentValue);		
	OPTION_UPDATE_TEXT(frame, 'RangeText_TerrainObject', currentValue, maxValue);
 end
 
 -- 섀도우맵 사용
 function OPTION_CHECK_SHADOW(frame, obj, argStr, argNum)
 
	local checkBox = tolua.cast(obj, "ui::CCheckBox");	
	local isChecked = checkBox:IsChecked();
	
	geScene.option.SetUseShadowMap(isChecked);		
 end
 
 function OPTION_SHADOW_QUALITY(frame, obj, argStr, argNum)
 
	local slideBar 		= tolua.cast(obj, "ui::CSlideBar");	
	local currentValue 	= slideBar:GetLevel();
	local maxValue 		= slideBar:GetMaxLevel();
	
	geScene.option.SetShadowMapSize(currentValue);		
	OPTION_UPDATE_TEXT(frame, 'ShadowText_Quality', currentValue, maxValue);
 end
 
 -- SSAO 사용 
 function OPTION_CHECK_SSAO(frame, obj, argStr, argNum)
 
	local checkBox = tolua.cast(obj, "ui::CCheckBox");	
	local isChecked = checkBox:IsChecked();
	
	geScene.option.SetUseSSAO(isChecked);		
 end
 
 function OPTION_SSAO_METHOD(frame, obj, argStr, argNum)
 
	local slideBar 		= tolua.cast(obj, "ui::CSlideBar");	
	local currentValue 	= slideBar:GetLevel();
	local maxValue 		= slideBar:GetMaxLevel();
	
	geScene.option.SetSSAOMethod(currentValue);		
	OPTION_UPDATE_TEXT(frame, 'SSAO_Method', currentValue, maxValue);
 end 
 
 function OPTION_SSAO_RESOLUTION(frame, obj, argStr, argNum)
 
	local slideBar 		= tolua.cast(obj, "ui::CSlideBar");	
	local currentValue 	= slideBar:GetLevel();
	local maxValue 		= slideBar:GetMaxLevel();
	
	geScene.option.SetSSAOResolution(currentValue);		
	OPTION_UPDATE_TEXT(frame, 'SSAO_Resolution', currentValue, maxValue);
 end
 
-- 물반사 사용
 function OPTION_CHECK_REFLECTION_OBJECT(frame, obj, argStr, argNum)
 
	local checkBox = tolua.cast(obj, "ui::CCheckBox");	
	local isChecked = checkBox:IsChecked();
		
	option.SetUseCharacterWaterReflection(isChecked);
 end
 
 function OPTION_CHECK_REFLECTION_BG(frame, obj, argStr, argNum)
 
	local checkBox = tolua.cast(obj, "ui::CCheckBox");	
	local isChecked = checkBox:IsChecked();
		
	geScene.option.SetUseBGWaterReflection(isChecked);
 end

 function OPTION_CHECK_GLOW(frame, obj, argStr, argNum)
 
	local checkBox = tolua.cast(obj, "ui::CCheckBox");	
	local isChecked = checkBox:IsChecked();
		
	option.EnableGlow(isChecked);	
 end

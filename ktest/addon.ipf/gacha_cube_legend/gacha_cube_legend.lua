-- gacha_cube_legend.lua --

function GACHA_CUBE_LEGEND_ON_INIT(addon, frame)	
    addon:RegisterMsg('CLOSE_GACHA_CUBE_LEGEND', 'CANCEL_GACHA_CUBE_LEGEND')
end

-- 뽑기 성공 후, 결과 UI창 생성하여 띄우기 
function GACHA_CUBE_LEGEND_SUCEECD(invItemClsID, rewardItem, btnVisible, reopenCount)
	-- UI창 얻어와서	 초기화    
	local gachaCubeFrame = ui.GetFrame("gacha_cube_legend");	
	GHACHA_CUBE_UI_RESET(gachaCubeFrame);	
	GACHA_CUBE_SUCEECD_UI(gachaCubeFrame, invItemClsID, rewardItem, btnVisible, reopenCount);
end

-- 뽑기 성공 후, 결과 UI창 요소 바꾸기　
function GACHA_LEGEND_CUBE_LEGEND_SUCEECD_EX(invItemClsID, rewardItem, btnVisible, reopenCount)	
	-- UI창 얻어와서	     
	local gachaCubeFrame = ui.GetFrame("gacha_cube_legend");	
	GACHA_CUBE_SUCEECD_UI(gachaCubeFrame, invItemClsID, rewardItem, btnVisible, reopenCount);
end

function CLICK_CLOSE_BUTTON()
    local frame = ui.GetFrame('gacha_cube_legend');
    local close = GET_CHILD_RECURSIVELY(frame, 'close');
    CANCEL_GACHA_CUBE_LEGEND(frame, close, 'close_btn', nil);
end

function CANCEL_GACHA_CUBE_LEGEND(frame, msg, argStr, argNum)    
    if argStr == 'close_btn' then
        CancelGachaCube()
        return
    end

    if argStr ~= 'close_btn' and msg ~= 'CLOSE_GACHA_CUBE_LEGEND' then return end
    
	SET_MOUSE_FOLLOW_BALLOON(nil);
	ui.SetEscapeScp("");
    
    if argStr ~= 'NO' then        
	    CancelGachaCube();
    end

	local gachaCubeFrame = ui.GetFrame("gacha_cube_legend");
	GHACHA_CUBE_UI_RESET(gachaCubeFrame); -- UI 리셋

    if argNum ~= nil then
       local itemobj = GetClassByType("Item", tonumber(argNum))
       DiscoverVelcofferLegendCubeUse(itemobj.ClassName)    -- 사용 가능 복구       
    end
end

-- 버튼 클릭 (2, 3번째 뽑기)
function GACHA_CUBE_LEGEND_OK_BTN(frame, ctrl)
	item.DoPremiumItemGachaCubeLegend(false);	-- 1번째와 다르게 서버에 null값 직접 전송
	DISABLE_BUTTON_DOUBLECLICK("gacha_cube_legend",ctrl:GetName(), 2);
end

function GACHA_CUBE_LEGEND_USE_COUPON_BTN(frame, ctrl)
    item.DoPremiumItemGachaCubeLegend(true)
end

function discover_velcoffer_cube_use(className)
    sleep(10);
    DiscoverVelcofferLegendCubeUse(className);
end
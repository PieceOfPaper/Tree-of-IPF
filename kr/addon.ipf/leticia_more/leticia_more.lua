function LETICIA_MORE_OPEN(frame)
    local fulldark = ui.GetFrame('fulldark');
    fulldark:SetLayerLevel(80);
end

function LETICIA_MORE_CLOSE(frame, byContinue)
    local leticiaFrame = ui.GetFrame('leticia_more')
    local leticiaFrame2 = ui.GetFrame('hair_gacha_fullscreen')
    if leticiaFrame:IsVisible() == 1  then 
        ui.CloseFrame('leticia_more');
        local fulldark = ui.GetFrame('fulldark');
        
        if byContinue == true then
            FULLDARK_CLOSE(fulldark, true, byContinue);
        else
            ui.CloseFrame('fulldark');
        end
    end
    
    if  leticiaFrame2:IsVisible() == 1 then
          ui.CloseFrame('hair_gacha_fullscreen');
        local fulldark = ui.GetFrame('fulldark');
        
        if byContinue == true then
            FULLDARK_CLOSE(fulldark, true, byContinue);
        else
            ui.CloseFrame('fulldark');
        end
    end
    
end

function LETICIA_MORE_CLICK_CONTINUE(parent, ctrl)
    local fulldark = ui.GetFrame('fulldark');
	
    local leticia_cube = ui.GetFrame('leticia_cube');
    local beforeGachaName = fulldark:GetUserValue('BEFORE_GACHA_NAME');
    local beforeItemName = fulldark:GetUserValue('BEFORE_ITEM_NAME');
    LETICIA_CUBE_OPEN_BUTTON(leticia_cube, nil, '', 0, beforeGachaName, beforeItemName);
    LETICIA_MORE_CLOSE(parent, true);
--    FULLDARK_CLOSE(fulldark, true, byContinue);
end

function LETICIA_MORE_CLICK_CONTINUE_ONE(parent, ctrl)
    local fulldark = ui.GetFrame('fulldark');
	
    local leticia_cube = ui.GetFrame('leticia_cube');
    local beforeGachaName = fulldark:GetUserValue('BEFORE_GACHA_NAME');
    local beforeItemName = fulldark:GetUserValue('BEFORE_ITEM_NAME');
    LETICIA_CUBE_OPEN_BUTTON(leticia_cube, nil, '', 0, beforeGachaName, beforeItemName);
    
    -- ONE CLOSE
     HAIR_GACHA_SKIP_BTN_CLICK(parent, ctrl, '', 0, true);
end

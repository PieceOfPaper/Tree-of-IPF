
function FISH_RUBBING_PAPER_ON_INIT(addon, frame)
    addon:RegisterMsg('FISH_RUBBING_PAPER_FISH', 'FISH_RUBBING_PAPER_ON_FISH');
end

function FISH_RUBBING_PAPER_ON_FISH(frame, msg, argStr, argNum)
    local fishPic = GET_CHILD(frame, "fish_pic");
    local desc_text = GET_CHILD(frame, "desc_text");
    local size_text = GET_CHILD(frame, "size_text");
    local rate = FISH_RUBBING_GET_FISH_PIC_SIZE(argNum);
    fishPic:Resize(fishPic:GetOriginalWidth()*rate, fishPic:GetOriginalHeight()*rate);
    desc_text:SetTextByKey('value', argStr)
    size_text:SetTextByKey('value', string.format("%.2f", argNum / 100));
    ui.OpenFrame('fish_rubbing_paper');
end

function FISH_RUBBING_PAPER_BTN_OK(frame)
    frame:CloseFrame('fish_rubbing_paper');
end

function FISH_RUBBING_GET_FISH_PIC_SIZE(score)
    local maxScore = 99999;
    if score > maxScore then
        score = maxScore;
    end
    
    local rate = (score / maxScore);
    
    return rate;
end

-- sound_adjust.lua --

function SOUND_EFFECT_FADE_OUT(soundName, startVolume, fadingTime)
    
    local maxFadingMS = 250;
    local rate = fadingTime / maxFadingMS;
    
    if rate > 1 then
        rate = 1;
    end
    
    local val = startVolume * (1 - rate);
    return val;
end


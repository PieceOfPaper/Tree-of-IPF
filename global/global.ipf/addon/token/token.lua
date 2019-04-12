
function ADD_2PLUS_IMAGE(gBox)
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 8,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img 1plus_image %d %d}", 55, 45) 
    prop:SetTextByKey("value", imag..ClMsg("Moreindunmission")); 
    local value = ctrlSet:GetChild("value");
    value:ShowWindow(0);
end

function TOKEN_GET_IMGNAME1()
	return "{img 30percent_image %d %d}"
end

function TOKEN_GET_IMGNAME2()
	return "{img 30percent_image2 %d %d}"
end
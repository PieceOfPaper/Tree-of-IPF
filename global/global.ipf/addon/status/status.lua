
function STATUS_OVERRIDE_NEWCONTROLSET1(tokenList)
	local ctrlSet = tokenList:CreateControlSet("tokenDetail", "CTRLSET_" .. 9,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img 1plus_image %d %d}", 55, 45) 
    prop:SetTextByKey("value", imag..ClMsg("Moreindunmission")); 
    local value = ctrlSet:GetChild("value");
    value:ShowWindow(0);
end

function STATUS_OVERRIDE_GET_IMGNAME1()
	return "{img 30percent_image %d %d}"
end

function STATUS_OVERRIDE_GET_IMGNAME2()
	return "{img 30percent_image2 %d %d}"
end
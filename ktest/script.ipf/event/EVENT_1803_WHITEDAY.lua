
--set item option
function SCR_set_052_WHITE2_ENTER(pc)
    pc.PATK_BM = pc.PATK_BM + 60;
    pc.MATK_BM = pc.MATK_BM + 60;
end

function SCR_set_052_WHITE2_LEAVE(pc)
    pc.PATK_BM = pc.PATK_BM - 60;
    pc.MATK_BM = pc.MATK_BM - 60;
end

function SCR_set_052_WHITE3_ENTER(pc)
    pc.MSPD_BM = pc.MSPD_BM + 2;
end

function SCR_set_052_WHITE3_LEAVE(pc)
    pc.MSPD_BM = pc.MSPD_BM - 2;
end

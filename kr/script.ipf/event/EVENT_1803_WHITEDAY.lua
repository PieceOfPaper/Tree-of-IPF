
--set item option
function SCR_set_052_WHITE2_ENTER(pc)
    pc.DEF_BM = pc.DEF_BM + 60
    pc.MDEF_BM = pc.MDEF_BM + 60
end

function SCR_set_052_WHITE2_LEAVE(pc)
    pc.DEF_BM = pc.DEF_BM - 60
    pc.MDEF_BM = pc.MDEF_BM - 60
end

function SCR_set_052_WHITE3_ENTER(pc)
    pc.MSPD_BM = pc.MSPD_BM + 2;
end

function SCR_set_052_WHITE3_LEAVE(pc)
    pc.MSPD_BM = pc.MSPD_BM - 2;
end

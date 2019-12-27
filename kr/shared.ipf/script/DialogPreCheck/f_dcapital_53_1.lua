function SCR_DCAPITAL53_1_SUB_OWL_STATUE01_PRE_DIALOG(pc, dialog)
    return "NO"
end


function SCR_DCAPITAL53_1_SUB_OWL_STATUE02_PRE_DIALOG(pc, dialog)
    return "NO"
end


function SCR_DCAPITAL53_1_SUB_OWL_STATUE03_PRE_DIALOG(pc, dialog)
    return "NO"
end


function SCR_DCAPITAL53_1_SUB_OWL_STATUE04_PRE_DIALOG(pc, dialog)
    return "NO"
end


function SCR_DCAPITAL53_1_SUB_OWL_STATUE05_PRE_DIALOG(pc, dialog)
    return "NO"
end


function SCR_DCAPITAL53_1_SUB_OWL_STATUE06_PRE_DIALOG(pc, dialog)
    return "NO"
end


function SCR_DCAPITAL53_1_SUB_OWL_STATUE07_PRE_DIALOG(pc, dialog)
    return "NO"
end


function SCR_DCAPITAL53_1_MAIN_NPC01_PRE_DIALOG(pc, dialog)
    return "YES"
end


function SCR_DCAPITAL53_1_MAIN_NPC02_PRE_DIALOG(pc, dialog)
    return "YES"
end


function SCR_DCAPITAL53_1_MAIN_NPC03_PRE_DIALOG(pc, dialog)
    return "YES"
end


-- Back Ground NPC


function SCR_DCAPITAL53_1_SUB_NPC01_PRE_DIALOG(pc, dialog)
    return "YES"
end


function SCR_DCAPITAL53_1_SUB_NPC02_PRE_DIALOG(pc, dialog)
    return "YES"
end


function SCR_DCAPITAL53_1_SUB_NPC03_PRE_DIALOG(pc, dialog)
    return "YES"
end


function SCR_DCAPITAL53_1_SUB_NPC04_PRE_DIALOG(pc, dialog)
    return "YES"
end


function SCR_DCAPITAL53_1_SUB_NPC05_PRE_DIALOG(pc, dialog)
    return "YES"
end


function SCR_DCAPITAL53_1_SUB_NPC06_PRE_DIALOG(pc, dialog)
    return "YES"
end


function SCR_DCAPITAL53_1_SUB_NPC07_PRE_DIALOG(pc, dialog)
    return "YES"
end


function SCR_DCAPITAL53_1_SUB_NPC08_PRE_DIALOG(pc, dialog)
    return "YES"
end


function SCR_DCAPITAL53_1_SUB_NPC09_PRE_DIALOG(pc, dialog)
    return "YES"
end


function SCR_DCAPITAL53_1_SUB_NPC10_PRE_DIALOG(pc, dialog)
    return "YES"
end


--DCAPITAL_53_1_MQ_04
function SCR_DCAPITAL53_1_MQ_04_OBJ_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "DCAPITAL53_1_MQ_04")
    if questCheck == "SUCCESS" then
        return "YES"
    end
    return "NO"
end

function SCR_ELE_JOB_CONDITION(pc)

    local pcJobLv_pyro = GetJobGradeByName(pc, 'Char2_2')
    local pcJobLv_cryo = GetJobGradeByName(pc, 'Char2_3')
    
    if pcJobLv_pyro >= 1 and pcJobLv_cryo >= 1 then
        return "YES"
    end
end



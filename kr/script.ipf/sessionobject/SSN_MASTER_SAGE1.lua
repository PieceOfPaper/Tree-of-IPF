function SCR_SSN_MASTER_SAGE1_BASIC_HOOK(self, sObj)
	SCR_REGISTER_QUEST_PROP_HOOK(self, sObj)
end

function SCR_CREATE_SSN_MASTER_SAGE1(self, sObj)
	SCR_SSN_MASTER_SAGE1_BASIC_HOOK(self, sObj)
    
    local i = IMCRandom(1, 4)
    local Ftower_Book = {
                            "SAGE_JOBQ_IN_FTOWER1",
                            "SAGE_JOBQ_IN_FTOWER2",
                            "SAGE_JOBQ_IN_FTOWER3",
                            "SAGE_JOBQ_IN_FTOWER4"
                        }
    sObj.String1 = Ftower_Book[i]
    
    local j = IMCRandom(1, 4)
    local Abbey354_Book = {
                            "SAGE_JOBQ_IN_ABBEY354_1",
                            "SAGE_JOBQ_IN_ABBEY354_2",
                            "SAGE_JOBQ_IN_ABBEY354_3",
                            "SAGE_JOBQ_IN_ABBEY354_4"
                          }
    sObj.String2 = Abbey354_Book[j]
    
    local t = IMCRandom(1, 4)
    local Castle201_Book = {
                            "SAGE_JOBQ_IN_CASTLE202_1",
                            "SAGE_JOBQ_IN_CASTLE202_2",
                            "SAGE_JOBQ_IN_CASTLE202_3",
                            "SAGE_JOBQ_IN_CASTLE202_4"
                          }
    sObj.String3 = Castle201_Book[t]
    
    SaveSessionObject(self, sObj)
end

function SCR_REENTER_SSN_MASTER_SAGE1(self, sObj)
	SCR_SSN_MASTER_SAGE1_BASIC_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_MASTER_SAGE1(self, sObj)
end
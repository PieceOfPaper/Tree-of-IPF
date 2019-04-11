function SCR_PRE_REQ_03_ITEM(self, argstring, argnum1, argnum2)
    local request_ssn = GetSessionObject(self, "SSN_REQUEST")
    if request_ssn.REQ_SEMPLE_03 == 100 then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'f_pilgrimroad_50' then
    	        local list, cnt = SelectObjectByClassName(self, 100, 'HiddenTrigger6')
    	        local i
    	        for i = 1, cnt do
    	            if list[i].Enter == 'REQ_SEMPLE_03_01' or list[i].Enter == 'REQ_SEMPLE_03_02' or list[i].Enter == 'REQ_SEMPLE_03_03' then
    	                return GetHandle(list[i])
        	        end
                end
            end
        end
    end
    return 0
end
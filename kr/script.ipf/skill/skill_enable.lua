function BUFFAPPLIED_CHECK(self)
    if IsPVPServer(self) == 1 or IsJoinColonyWarMap(self) == 1 then
        if IsBuffApplied(self, "Cloaking_Buff") == 'YES' then
            SendSysMsg(self, "NotYetAvailable");
            return; 
        else
            return 1;
        end
    else
        return 1;
    end
end

function ITEMFORGE_CHECK(self)
    local forgeCnt = GetInvItemCount(self, "Guild_Forge01")
    local list, cnt = SelectObjectByClassName(self, 100, 'Forge')
    if forgeCnt <= 0 then
        SendSysMsg(self, "NotYetAvailable");
        return;
    elseif cnt >= 1 then
        SendSysMsg(self, "NotYetAvailable");
        return;
    else
        return 1;
    end
end

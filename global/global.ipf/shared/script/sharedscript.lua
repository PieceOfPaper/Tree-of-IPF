function IMCLOG_CONTENT_SPACING(tag, ...)
    local logMsg = "";
    for i, v in ipairs{...} do
        logMsg = logMsg.." "..tostring(v);
    end

    ImcContentLog(tag,logMsg)
end
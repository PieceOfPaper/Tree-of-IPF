--- monpcskill_client.lua

function MON_PCSKILL_BLINK_C(actor, buff, argStr, isEnter)

	if isEnter == 1 then
		actor:GetEffect():SetColorBlink(1, 0.3, 0.3, 1, 1, 1, 1, 1, 1.2, 0, 0.2);
	else
		actor:GetEffect():SetColorBlink(1, 0.3, 0.3, 1, 0, 0, 0, 1, 0.0, 0, 0);

	end
end



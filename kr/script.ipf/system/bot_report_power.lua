

function CALC_BOT_REPORT_POWER(truecount, falsecount)

	local thresold = 10 -- 몇 이상 누적되면 신고할 것인가?


	if truecount < 1 and falsecount < 1 then
		return thresold, 1
	end

	local ret = truecount / (falsecount + 1);
	
	return  thresold, ret;

end

function ADD_REPORTED_POWER_TO_BOT(reportedPC, reportedAObj, newpower)

	local tx = TxBegin(reportedPC);
	if nil == tx then
		return;
	end

	TxSetIESProp(tx, reportedAObj, 'AccumulatedRepotedPoint', newpower);
		
	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
	
	end

end

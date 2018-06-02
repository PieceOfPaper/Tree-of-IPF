-- lib_picture.lua --

function GET_PORTRAIT_IMG_NAME(job, gender)

	local ret = job;
	if gender == 1 then
		return ret .. "_M";
	else
		return ret .. "_F";
	end

end




-- ui/uiscp/wiki/wiki_tooltip.lua

function UPDATE_JOURNAL_RANK_TOOLTIP(frame, strArg, num, arg2) -- 아마 지금은 안쓰는 함수가 아닐까.

	local ranking = geServerWiki.GetWikiServRank();
	local info = ranking:GetByStrCID(strArg);
	if info == nil then
		return 0;
	end

	local caption = frame:GetChild("caption");	
	local txt = "";
	for i = 0 , WIKI_COUNT - 1 do
		if i ~= WIKI_CONTENTS and i ~= WIKI_ETC and i ~= WIKI_SETITEM then
			local cateName = GetWikiEnumName(i);
			local langName = GetWikiCategoryLangName(i);
			if langName ~= "" then
				local msg = ClMsg(cateName) .. " " .. info:GetScore(i);
				if i > 0 then
					txt = txt .. "{nl}";
				end

				txt = txt .. msg ;
			end
		end
	end

	caption:SetText(txt);
	frame:Resize(frame:GetWidth(), caption:GetHeight() + 16);

	return 1;
end
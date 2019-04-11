-- lib_gauge.lua

function LINK_OBJ_TO_GAUGE(parent, obj, gauge, isDynamic)

	if obj:GetUserIValue("LINKED_GAUGE") == 1 then
		return;
	end

	if nil == isDynamic then
		isDynamic = 0;
	end
	obj:SetUserValue("LINKED_GAUGE", 1);
	obj:SetUserValue("GAUGE_NAME", gauge:GetName());
	obj:SetUserValue("IS_DYNAMIC", isDynamic);
	obj:RunUpdateScript("_LINK_OBJ_TO_GAUGE", 0, 0, 0, 1);
	_LINK_OBJ_TO_GAUGE(obj);

end

function _LINK_OBJ_TO_GAUGE(obj)

	local parent = obj:GetParent();
	local gaugeName = obj:GetUserValue("GAUGE_NAME");
	local gauge = GET_CHILD_RECURSIVELY(parent:GetTopParentFrame(), gaugeName);
	local x = 0;
	if 1 == obj:GetUserIValue("IS_DYNAMIC") then
		x =	gauge:GetX() + (gauge:GetCurPoint() / gauge:GetMaxPoint()) * gauge:GetWidth() - obj:GetWidth() * 2.3;
	else
		x =	gauge:GetX() + (gauge:GetCurPoint() / gauge:GetMaxPoint()) * gauge:GetWidth() - obj:GetWidth() / 2;
end
	obj:SetOffset(x, obj:GetY());

	return 1;
end

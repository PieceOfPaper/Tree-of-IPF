function HOUSING_SHOP_PAYMENT_COUPON_LIST()
	return
	{
		"PersonalHousing_Item_voucher_3",	-- 100만원
		"PersonalHousing_Item_voucher_4",	-- 50만원
		"PersonalHousing_Item_voucher_1",	-- 10만원
		"PersonalHousing_Item_voucher_2"	-- 1만원
	};
end

function HOUSING_SHOP_PAYMENT_AUTO_COUPON_COUNT(couponList, price, hasCouponCount)
	local sortedCoupon = couponList;

	local function SortCoupon(a, b)
		local itemClassA = GetClass("Item", a);
		local itemClassB = GetClass("Item", b);

		local discountA = TryGetProp(itemClassA, "NumberArg1", 0);
		local discountB = TryGetProp(itemClassB, "NumberArg1", 0);

		return discountA > discountB;
	end
	table.sort(sortedCoupon, SortCoupon);
	
	local couponCount = {};
	for i = 1, #sortedCoupon do
		local itemClassA = GetClass("Item", sortedCoupon[i]);
		local discountSilver = TryGetProp(itemClassA, "NumberArg1", 0);
		local enableUseCouponCount = math.floor(price / discountSilver);
		
		if hasCouponCount ~= nil then
			enableUseCouponCount = CLAMP(enableUseCouponCount, 0, hasCouponCount[sortedCoupon[i]]);
		end

		couponCount[#couponCount + 1] = enableUseCouponCount;

		price = price - discountSilver * enableUseCouponCount;
	end

	return sortedCoupon, couponCount;
end
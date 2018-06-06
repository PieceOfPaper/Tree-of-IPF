-- ability_price.lua

function ABIL_1RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 500 + (4 - maxLevel + abilLevel) * 30;
    local time = 4 + (4 - maxLevel + abilLevel) * 4;

	return price, time;
	
end

function ABIL_2RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 1670 + (4 - maxLevel + abilLevel) * 100;
    local time = 8 + (4 - maxLevel + abilLevel) * 4;

	return price, time;
	
end

function ABIL_3RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 4600 + (4 - maxLevel + abilLevel) * 280;
    local time = 12 + (4 - maxLevel + abilLevel) * 4;

	return price, time;
	
end

function ABIL_4RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 10820 + (4 - maxLevel + abilLevel) * 650;
    local time = 16 + (4 - maxLevel + abilLevel) * 4;

	return price, time;
	
end

function ABIL_5RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 22180 + (4 - maxLevel + abilLevel) * 1490;
    local time = 20 + (4 - maxLevel + abilLevel) * 4;

	return price, time;
	
end


function ABIL_6RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 41050 + (4 - maxLevel + abilLevel) * 3300;
    local time = 24 + (4 - maxLevel + abilLevel) * 4;

	return price, time;
	
end

function ABIL_7RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 70580 + (4 - maxLevel + abilLevel) * 7000;
    local time = 28 + (4 - maxLevel + abilLevel) * 4;

	return price, time;
	
end

function ABIL_8RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 571250 + (4 - maxLevel + abilLevel) * 71000;
    local time = 240 + (4 - maxLevel + abilLevel) * 100;

	return price, time;
	
end

function ABIL_1RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 500 + (abilLevel - 1) * 30;
    local time = 4 + (abilLevel - 1);

	return price, time;
	
end

function ABIL_2RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 1670 + (abilLevel - 1) * 100;
    local time = 8 + (abilLevel - 1);

	return price, time;
	
end

function ABIL_3RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 4600 + (abilLevel - 1) * 280;
    local time = 12 + (abilLevel - 1);

	return price, time;
	
end

function ABIL_4RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 10820 + (abilLevel - 1) * 650;
    local time = 16 + (abilLevel - 1);

	return price, time;
	
end

function ABIL_5RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 22180 + (abilLevel - 1) * 1490;
    local time = 20 + (abilLevel - 1);

	return price, time;
	
end

function ABIL_6RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 41050 + (abilLevel - 1) * 3300;
    local time = 24 + (abilLevel - 1);

	return price, time;
	
end

function ABIL_7RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 70580 + (abilLevel - 1) * 7000;
    local time = 28 + (abilLevel - 1);

	return price, time;
	
end

function ABIL_8RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 571250 + (abilLevel - 1) * 71000;
    local time = 240 + (abilLevel - 1) * 20;

	return price, time;
	
end

function ABIL_1RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 1000);
    local time = 0;

	return price, time;
	
end

function ABIL_2RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 2000);
    local time = 0;

	return price, time;
	
end

function ABIL_3RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 3000);
    local time = 0;

	return price, time;
	
end

function ABIL_4RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 4000);
    local time = 0;

	return price, time;
	
end

function ABIL_5RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 5000);
    local time = 0;

	return price, time;
	
end

function ABIL_6RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 6000);
    local time = 0;

	return price, time;
	
end

function ABIL_7RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 7000);
    local time = 0;

	return price, time;
	
end

function ABIL_8RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.085^(abilLevel-1) * 8000);
    local time = 0;

	return price, time;
	
end

function ABIL_3RANK_MASTER_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 22000
    local time = 0;

	return price, time;
	
end

function ABIL_SWAPWEAPON_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 2500
    local time = 10;

	return price, time;
	
end

function ABIL_MASTERY_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 3000 + 500 * (abilLevel - 1);
    local time = 30;

	return price, time;
	
end

function ABIL_UNIQUEMASTERY_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 6000 + 750 * (abilLevel - 1);
    local time = 60;

	return price, time;
	
end

function ABIL_BOKOR21_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 60000 + math.floor(1.05^(abilLevel-1) * 7800);
    local time = math.floor(1 + (abilLevel * 0.1));

	return price, time;
	
end

function ABIL_BOKOR22_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 60000 + math.floor(1.05^(abilLevel-1) * 7800);
    local time = math.floor(1 + (abilLevel * 0.1));

	return price, time;
	
end

function ABIL_SAVEPOISON_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 5500);
    local time = 0;

	return price, time;
	
end

function ABIL_SORCERER2_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.05^(abilLevel-1) * 35000);
    local time = 0;

	return price, time;
	
end

function ABIL_SQUIRE_TOUCHUP_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = math.floor(1.04^(abilLevel-1) * 15000);
    local time = 0;
    
	return price, time;
	
end

function ABIL_SQUIRE_FOODTABLE_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = 10000 + 10000 * (abilLevel - 1);
    local time = 10;
    
	return price, time;
	
end

function ABIL_BOKOR17_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = math.floor(1.04^(abilLevel-1) * 9900);
    local time = 0;
    
	return price, time;
	
end


function ABIL_PARDONER5_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = abilLevel * 1000 + IMCRandom(0, 99)
    local time = 0;
    
	return price, time;
	
end

function ABIL_TINCTURINGPOTION_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = abilLevel * 10000;
    local time = 60 + abilLevel * 4;
    
	return price, time;
end


function ABIL_HIGHLANDER28_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 15000;
    local time = 0;

	return price, time;
	
end

function ABIL_CATAPHRACT28_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 70000;
    local time = 0;

	return price, time;
	
end

function ABIL_CATAPHRACT30_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 100000;
    local time = 0;

	return price, time;
	
end

function ABIL_NECROMANCER8_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 80000 + math.floor(1.05^(abilLevel-1) * 8800);
    local time = math.floor(1 + (abilLevel * 0.1));

	return price, time;
	
end

function ABIL_PROVOKE_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 500 + (abilLevel-1) * 50
    local time = 0

	return price, time;
	
end

function ABIL_UNLOCKCHEST_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 32500 * abilLevel
    local time = 1;

	return price, time;
	
end

function ABIL_TAXPAYMENT_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = math.floor(1.09^(abilLevel-1) * 1000);
    local time = 1;
    
	return price, time;
	
end

function ABIL_FEATHERFOOTBLOOD_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = math.floor(1.055^(abilLevel-1) * 20000);
    local time = 1;
    
	return price, time;
	
end

function ABIL_FEATHERFOOTREGENERATE_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = 500000;
    local time = 40 + (abilLevel-1) * 5;
    
	return price, time;
	
end

function ABIL_QUARRELSHOOTER9_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = 1100 + (abilLevel-1) * 100;
    local time = 60 + (abilLevel-1) * 10;
    
	return price, time;
	
end

function ABIL_RODELERO29_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = 41050 + (abilLevel - 1) * 3300;
    local time = 24 + (abilLevel - 1) * 4;
    
	return price, time;
	
end

function ABIL_CLERIC18_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = 1670 + (abilLevel - 1) * 100;
    local time = 1;
    
	return price, time;
	
end

function ABIL_ADDBUFFCOUNT_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 10000
    local time = 0

	return price, time;
end

function ABIL_DOPPELSOELDNER20_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 713250
    local time = 1440
    
	return price, time;
end

function ABIL_ALCHEMIST10_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 2000000
    local time = 3000
    
	return price, time;
end

function ABIL_TOTALDEADPARTS_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 600000 + (abilLevel - 1) * 200000;
    local time = 300 * abilLevel;
    
	return price, time;
end

function ABIL_HIGHERROTTEN_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 2000000
    local time = 1500
    
	return price, time;
end

function ABIL_WARLOCK14_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 571250 + math.floor(1.1^(abilLevel-1) * 80000);
    local time = 600 + (abilLevel-1) * 100;

	return price, time;
	
end

function ABIL_SAGE8_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 2000000
    local time = 2000

	return price, time;
	
end

function ABIL_SAGE9_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 1600000 + (abilLevel-1) * 100000;
    local time = 2000 + (abilLevel-1) * 200;

	return price, time;
	
end

function ABIL_FALCONER11_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 1000000 + (abilLevel-1) * 100000;
    local time = 1000 + (abilLevel-1) * 100;

	return price, time;
end

function ABIL_SHINOBIARUKI_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 1800000
    local time = 1440;

	return price, time;
end

function ABIL_SCHWARZEREITER17_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 1658400
    local time = 1440;

	return price, time;
end

function ABIL_DRUID12_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 954400 + (abilLevel-1) * 98510;
    local time = 700 + (abilLevel-1) * 100;

	return price, time;
end

function ABIL_INQUISITOR9_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = math.floor(1.09^(abilLevel-1) * 1000000);
    local time = 100;

	return price, time;
end

function ABIL_CLERIC9_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 4600 + (4 - maxLevel + abilLevel) * 280;
    local time = 12 + (9 - maxLevel + abilLevel) * 4;

	return price, time;
	
end
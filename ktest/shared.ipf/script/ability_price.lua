-- ability_price.lua

function ABIL_1RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 1 + (4 - maxLevel + abilLevel) * 1;
    local time = 4 + (4 - maxLevel + abilLevel) * 4;

    return price, time;
    
end

function ABIL_2RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 2 + (4 - maxLevel + abilLevel) * 1;
    local time = 8 + (4 - maxLevel + abilLevel) * 4;

    return price, time;
    
end

function ABIL_3RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 5 + (4 - maxLevel + abilLevel) * 1;
    local time = 12 + (4 - maxLevel + abilLevel) * 4;

    return price, time;
    
end

function ABIL_4RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 11 + (4 - maxLevel + abilLevel) * 1;
    local time = 16 + (4 - maxLevel + abilLevel) * 4;

    return price, time;
    
end

function ABIL_5RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 22 + (4 - maxLevel + abilLevel) * 2;
    local time = 20 + (4 - maxLevel + abilLevel) * 4;

    return price, time;
    
end


function ABIL_6RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 41 + (4 - maxLevel + abilLevel) * 3;
    local time = 24 + (4 - maxLevel + abilLevel) * 4;

    return price, time;
    
end

function ABIL_7RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 70 + (4 - maxLevel + abilLevel) * 7;
    local time = 28 + (4 - maxLevel + abilLevel) * 4;

    return price, time;
    
end

function ABIL_8RANK_NORMAL_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 571 + (4 - maxLevel + abilLevel) * 71;
    local time = 240 + (4 - maxLevel + abilLevel) * 100;

    return price, time;
    
end

function ABIL_1RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 1 + (abilLevel - 1) * 1;
    local time = 4 + (abilLevel - 1);

    return price, time;
    
end

function ABIL_2RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 2 + (abilLevel - 1) * 1;
    local time = 8 + (abilLevel - 1);

    return price, time;
    
end

function ABIL_3RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 5 + (abilLevel - 1) * 1;
    local time = 12 + (abilLevel - 1);

    return price, time;
    
end

function ABIL_4RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 11 + (abilLevel - 1) * 1;
    local time = 16 + (abilLevel - 1);

    return price, time;
    
end

function ABIL_5RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 22 + (abilLevel - 1) * 2;
    local time = 20 + (abilLevel - 1);

    return price, time;
    
end

function ABIL_6RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 41 + (abilLevel - 1) * 3;
    local time = 24 + (abilLevel - 1);

    return price, time;
    
end

function ABIL_7RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 70 + (abilLevel - 1) * 7;
    local time = 28 + (abilLevel - 1);

    return price, time;
    
end

function ABIL_8RANK_BUFF_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 571 + (abilLevel - 1) * 71;
    local time = 240 + (abilLevel - 1) * 20;

    return price, time;
    
end

function ABIL_1RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 1);
    local time = 0;

    return price, time;
    
end

function ABIL_2RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 2);
    local time = 0;

    return price, time;
    
end

function ABIL_3RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 3);
    local time = 0;

    return price, time;
    
end

function ABIL_4RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 4);
    local time = 0;

    return price, time;
    
end

function ABIL_5RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 5);
    local time = 0;

    return price, time;
    
end

function ABIL_6RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 6);
    local time = 0;

    return price, time;
    
end

function ABIL_7RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 7);
    local time = 0;

    return price, time;
    
end

function ABIL_8RANK_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.085^(abilLevel-1) * 8);
    local time = 0;

    return price, time;
    
end

function ABIL_3RANK_MASTER_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 3
    local time = 0;

    return price, time;
    
end

function ABIL_SWAPWEAPON_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 3
    local time = 10;

    return price, time;
    
end

function ABIL_MASTERY_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 3 + 1 * (abilLevel - 1);
    local time = 30;

    return price, time;
    
end

function ABIL_UNIQUEMASTERY_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 6 + 1 * (abilLevel - 1);
    local time = 60;

    return price, time;
    
end

function ABIL_BOKOR21_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 60 + math.floor(1.05^(abilLevel-1) * 7);
    local time = math.floor(1 + (abilLevel * 0.1));

    return price, time;
    
end

function ABIL_BOKOR22_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 60 + math.floor(1.05^(abilLevel-1) * 7);
    local time = math.floor(1 + (abilLevel * 0.1));

    return price, time;
    
end

function ABIL_SAVEPOISON_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.07^(abilLevel-1) * 6);
    local time = 0;

    return price, time;
    
end

function ABIL_SORCERER2_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = math.floor(1.05^(abilLevel-1) * 35);
    local time = 0;

    return price, time;
    
end

function ABIL_SQUIRE_TOUCHUP_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = math.floor(1.04^(abilLevel-1) * 15);
    local time = 0;
    
    return price, time;
    
end

function ABIL_SQUIRE_FOODTABLE_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = 10 + 10 * (abilLevel - 1);
    local time = 10;
    
    return price, time;
    
end

function ABIL_BOKOR17_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = math.floor(1.04^(abilLevel-1) * 10);
    local time = 0;
    
    return price, time;
    
end


function ABIL_PARDONER5_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = abilLevel * 1 + IMCRandom(0, 99)
    local time = 0;
    
    return price, time;
    
end

function ABIL_TINCTURINGPOTION_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = abilLevel * 10;
    local time = 60 + abilLevel * 4;
    
    return price, time;
end


function ABIL_HIGHLANDER28_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 15;
    local time = 0;

    return price, time;
    
end

function ABIL_CATAPHRACT28_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 70;
    local time = 0;

    return price, time;
    
end

function ABIL_CATAPHRACT30_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 100;
    local time = 0;

    return price, time;
    
end

function ABIL_NECROMANCER8_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 80 + math.floor(1.05^(abilLevel-1) * 9);
    local time = math.floor(1 + (abilLevel * 0.1));

    return price, time;
    
end

function ABIL_PROVOKE_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 1 + (abilLevel-1) * 1
    local time = 0

    return price, time;
    
end

function ABIL_UNLOCKCHEST_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 32 * abilLevel
    local time = 1;

    return price, time;
    
end

function ABIL_TAXPAYMENT_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = math.floor(1.09^(abilLevel-1) * 1);
    local time = 1;
    
    return price, time;
    
end

function ABIL_FEATHERFOOTBLOOD_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = math.floor(1.055^(abilLevel-1) * 20);
    local time = 1;
    
    return price, time;
    
end

function ABIL_FEATHERFOOTREGENERATE_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = 500;
    local time = 40 + (abilLevel-1) * 5;
    
    return price, time;
    
end

function ABIL_QUARRELSHOOTER9_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = 1 + (abilLevel-1) * 1;
    local time = 60 + (abilLevel-1) * 10;
    
    return price, time;
    
end

function ABIL_RODELERO29_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = 41 + (abilLevel - 1) * 3;
    local time = 24 + (abilLevel - 1) * 4;
    
    return price, time;
    
end

function ABIL_CLERIC18_PRICE(pc, abilName, abilLevel, maxLevel)
    
    local price = 2 + (abilLevel - 1) * 1;
    local time = 1;
    
    return price, time;
    
end

function ABIL_ADDBUFFCOUNT_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 10
    local time = 0

    return price, time;
end

function ABIL_DOPPELSOELDNER20_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 713
    local time = 1440
    
    return price, time;
end

function ABIL_ALCHEMIST10_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 3000
    local time = 3000
    
    return price, time;
end

function ABIL_TOTALDEADPARTS_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 1670 + (abilLevel - 1) * 200;
    local time = 300 * abilLevel;
    
    return price, time;
end

function ABIL_HIGHERROTTEN_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 2000
    local time = 1500
    
    return price, time;
end

function ABIL_WARLOCK14_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 571 + math.floor(1.1^(abilLevel-1) * 80);
    local time = 600 + (abilLevel-1) * 100;

    return price, time;
    
end

function ABIL_SAGE8_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 2000
    local time = 2000

    return price, time;
    
end

function ABIL_SAGE9_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 1600 + (abilLevel-1) * 100;
    local time = 2000 + (abilLevel-1) * 200;

    return price, time;
    
end

function ABIL_FALCONER11_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 1000 + (abilLevel-1) * 100;
    local time = 1000 + (abilLevel-1) * 100;

    return price, time;
end

function ABIL_SHINOBIARUKI_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 1800
    local time = 1440;

    return price, time;
end

function ABIL_SCHWARZEREITER17_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 1658
    local time = 1440;

    return price, time;
end

function ABIL_DRUID12_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = 954 + (abilLevel-1) * 99;
    local time = 700 + (abilLevel-1) * 100;

    return price, time;
end

function ABIL_INQUISITOR9_PRICE(pc, abilName, abilLevel, maxLevel)
    local price = math.floor(1.09^(abilLevel-1) * 1000);
    local time = 100;

    return price, time;
end

function ABIL_CLERIC9_PRICE(pc, abilName, abilLevel, maxLevel)

    local price = 3 + (abilLevel - 1) * 1;
    local time = 12 + (9 - maxLevel + abilLevel) * 4;

    return price, time;
end

function GET_TOTAL_ABILITY_PRICE(pc, scrCalcPrice, abilName, abilLevel, maxLevel)
    local price = 0;
    if pc == nil or abilName == nil or abilLevel == nil or maxLevel == nil or scrCalcPrice == nil or scrCalcPrice == 'None' then
        return price;
    end

    for i = 1, abilLevel do
        local GetCalcPriceScript = _G[scrCalcPrice];
        price = price + GetCalcPriceScript(pc, abilName, i, maxLevel);
    end

    return price;
end
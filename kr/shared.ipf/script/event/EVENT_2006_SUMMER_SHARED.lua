-- EVENT_2006_SUMMER_SHARED.lua

function EVENT_2006_SUMMER_BUFF_TABLE(itemName)
    -- common
    local table = {'EXPUP', 'HPSPUP', 'LOOTCHANCE'}

    -- unique
    local table_unique = 
    {
        ['brochette']   = 'FISHING',
        ['mojito']      = 'MSPD',
        ['coconut']     = 'REGEN',
        ['bingsu']      = 'STA',
        ['softice']     = 'ATK',
    }

    table[#table+1] = table_unique[itemName]

    return table
end

function EVENT_2006_SUMMER_BUFF_ARG_TABLE()
    local table = 
    {
        -- common
        ['EXPUP']       = 30,
        ['HPSPUP']      = 1000,
        ['LOOTCHANCE']  = 300,

        -- unique
        ['FISHING']     = 20,
        ['MSPD']        = 3,
        ['REGEN']       = 500,
        ['STA']         = 2,
        ['ATK']         = 1000,
    }

    return table
end
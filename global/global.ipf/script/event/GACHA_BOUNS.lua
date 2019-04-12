function SCR_GACHA_BOUNS_VALUE(self, pc)
    local aObj = GetAccountObj(pc);
    local count = aObj.GACHA_HAIRACC_COUNT;
    local bouns = aObj.GACHA_HAIRACC_BOUNS;
    local cubetype = 2;
    local next_count, next_bouns = 0, 0;
    local rewardlist = {}
    local rewardtext = ''

    local bounslist = {
        {25, 55, 85, 115, 200,      'GACHA_TP_COUNT',      'GACHA_TP_BOUNS', 100}, -- tp
        {15, 25, 35,  50, 100, 'GACHA_HAIRACC_COUNT', 'GACHA_HAIRACC_BOUNS', 50} -- hairacc
    }

    -- next count
    if count > bounslist[cubetype][5] then
        for a = 1, 20 do
            if count < bounslist[cubetype][5] + (bounslist[cubetype][8] * a) then
                next_bouns = bounslist[cubetype][5] + (bounslist[cubetype][8] * a)
                next_count = bounslist[cubetype][5] + (bounslist[cubetype][8] * a) - count
                break;
            end
        end
    else
        for j = 1, 5 do
            if count < bounslist[cubetype][j] then
                next_bouns = bounslist[cubetype][j]
                next_count = bounslist[cubetype][j] - count
                break;
            end
        end
    end

    -- reward
    for i = bouns + 1, bouns + 5 do
        if i <= 5 then
            if count >= bounslist[cubetype][i] then
                table.insert(rewardlist, bounslist[cubetype][i])
                if rewardtext == '' then
                    rewardtext = bounslist[cubetype][i]
                else
                    rewardtext = rewardtext.."/"..bounslist[cubetype][i]
                end
            end
        else
            local bouns_count = bounslist[cubetype][5] + (bounslist[cubetype][8] * (i - 5))
            if count >= bouns_count then
                table.insert(rewardlist, bouns_count)
                if rewardtext == '' then
                    rewardtext = bouns_count
                else
                    rewardtext = rewardtext.."/"..bouns_count
                end
            end
        end
    end

    return count, bouns, cubetype, next_count, next_bouns, rewardlist, rewardtext
end

function SCR_GACHA_BOUNS_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);

    local count, bouns, cubetype, next_count, next_bouns, rewardlist, rewardtext = SCR_GACHA_BOUNS_VALUE(self, pc)

    local cube_name = 'Leticia Secret Cube'

    if cubetype == 2 then
        cube_name = 'Goddess Blessed Cube'
    end

    if rewardtext == '' then
        ShowOkDlg(pc, ScpArgMsg('GACHA_BOUNS_SEL2', "CUBE", cube_name, "SUM", count, "COUNT", next_count, "BOUNS", next_bouns), 1)
        return
    else
        local select = ShowSelDlg(pc, 0, ScpArgMsg('GACHA_BOUNS_SEL1', "CUBE", cube_name,"SUM", count, "COUNT", next_count, "BOUNS", next_bouns, "REWARD", rewardtext), ScpArgMsg("No"), ScpArgMsg("Yes"))

        if select == 1 or select == nil then
            return;
        elseif select == 2 then
            local bounslist = {'GACHA_HAIRACC_BOUNS01', 'GACHA_HAIRACC_BOUNS02', 'GACHA_HAIRACC_BOUNS03', 'GACHA_HAIRACC_BOUNS04', 'GACHA_HAIRACC_BOUNS05'}

            if bouns >= 4 then
                bouns = 4;
            end

            SCR_ITEM_GACHA_TP(pc, bounslist[bouns + 1], bounslist[bouns + 1], 1, 'Bouns', 'rbox') -- give bouns item
        end
    end
end
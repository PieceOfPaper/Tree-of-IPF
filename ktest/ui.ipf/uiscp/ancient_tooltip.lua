-- ancient_tooltip.lua --
function UPDATE_ANCIENT_CARD_TOOLTIP(frame,guid)
    local card = session.pet.GetAncientCardByGuid(guid);
    if card == nil then
        return;
    end
    local monCls = GetClass("Monster",card:GetClassName())
    if monCls == nil then
        return;
    end
    local exp = card:GetStrExp();
    local xpInfo = gePetXP.GetXPInfo(gePetXP.EXP_ANCIENT, tonumber(exp))
    local level = xpInfo.level
    --set rarity
    local infoCls = GetClass("Ancient_Info", monCls.ClassName)
    local nameBox = frame:GetChild("name_box")
    local rarityText = nameBox:GetChild("rarity")
    local rarity = infoCls.Rarity
    
    if rarity == 1 then
		rarityText:SetText(frame:GetUserConfig("NORMAL_GRADE_TEXT"))
	elseif rarity == 2 then
		rarityText:SetText(frame:GetUserConfig("MAGIC_GRADE_TEXT"))
	elseif rarity == 3 then
		rarityText:SetText(frame:GetUserConfig("UNIQUE_GRADE_TEXT"))
	elseif rarity == 4 then
		rarityText:SetText(frame:GetUserConfig("LEGEND_GRADE_TEXT"))
	end
    --set name
    local name = nameBox:GetChild("name")
    name:SetText('{@st42b}{s16}[Lv.'..level..'] '.. monCls.Name..'{/}')
    
    --set image
    local monsterInfo = frame:GetChild("monster_info")
    local monsterImg = monsterInfo:GetChild("img")
    local iconName = TryGetProp(monCls, "Icon");
    AUTO_CAST(monsterImg)
    monsterImg:SetImage(iconName)
    --set star
    local starrankText = monsterImg:GetChild("starrank")
    local starrank = card.starrank
    local starStr = ""
    for i = 1, starrank do
        starStr = starStr ..string.format("{img monster_card_starmark %d %d}", 21, 20)
    end
    starrankText:SetText(starStr)
    --exp gauge
    local expGauge = monsterInfo:GetChild("exp")
    AUTO_CAST(expGauge)
    local totalExp = xpInfo.totalExp - xpInfo.startExp;
    local curExp = exp - xpInfo.startExp;
    expGauge:SetPoint(curExp, totalExp);

    --stat load
    local mon1obj = CreateGCIES('Monster', monCls.ClassName);
    mon1obj.Lv = level;
    SetExProp(mon1obj,'STARRANK',card.starrank)
    local statList = {'MHP','PATK','MATK','DEF','MDEF','HR','DR'}
    local monsterStat = frame:GetChild("monster_stat")
    monsterStat:RemoveAllChild()
    
    local statBaseText = monsterStat:CreateControl("richtext","monster_stat_1",100,31,ui.LEFT,ui.TOP,10,0,0,0);
    local font = "{@st66b}{s16}"
    statBaseText:SetText(font..ScpArgMsg("DetailInfo").."{/}")
    statBaseText:SetFontName("brown_16")
    
    local height = 31
    for i = 1,#statList do
        local statName = statList[i]
        local statNameCtrl = monsterStat:CreateControl("richtext",statName.."_name",100,30,ui.LEFT,ui.TOP,10,height,0,0);
        statNameCtrl:SetFontName("brown_18")
        statNameCtrl:SetText(ScpArgMsg(statName))
        local statValueCtrl = monsterStat:CreateControl("richtext",statName.."_val",100,30,ui.RIGHT,ui.TOP,0,height,10,0)
        statValueCtrl:SetFontName("brown_18")
        if statName == "MATK" or statName == "PATK" then
            local statMinFunc = _G["SCR_Get_MON_MIN"..statName]
            local statMaxFunc = _G["SCR_Get_MON_MAX"..statName]
            local statMin = statMinFunc(mon1obj)
            local statMax = statMaxFunc(mon1obj)
            statValueCtrl:SetText(font..statMin..'~'.. statMax.."{/}")
        else
            local statFunc = _G["SCR_Get_MON_"..statName]
            local statVal = statFunc(mon1obj);
            statValueCtrl:SetText(font..statVal.."{/}")
        end
        height = height + 25
    end

    local exStatList = {"RaceType", "Attribute"}
    for i = 1,#exStatList do
        local exStat = exStatList[i]
        local exstatNameCtrl = monsterStat:CreateControl("richtext",exStat.."_name",100,30,ui.LEFT,ui.TOP,10,height,0,0);
        exstatNameCtrl:SetText(font..ClMsg(exStat).."{/}")
        local exstatValueCtrl = monsterStat:CreateControl("richtext",exStat.."_val",100,30,ui.RIGHT,ui.TOP,0,height,10,0)
        exstatValueCtrl:SetText(font..ScpArgMsg("MonInfo_"..exStat.."_"..TryGetProp(monCls,exStat)).."{/}")
        height = height + 25
    end

    local monster_cost = frame:GetChild("monster_cost")
    local costValueCtrl = monster_cost:GetChild("cost_val")
    costValueCtrl:SetText(font..card:GetCost().."{/}")
    local caption, parsed = TRY_PARSE_ANCIENT_PROPERTY(infoCls, infoCls.Tooltop, card);
    local monster_passive = frame:GetChild("monster_passive")
    local passiveValueCtrl = monster_passive:GetChild("passive_val")
    passiveValueCtrl:SetText(caption)

    do 
        local costName = monster_cost:GetChild("cost_name")
        costName:Invalidate()
        local passive_name = monster_passive:GetChild("passive_name")
        passive_name:Invalidate()
    end

    monster_passive:Resize(monster_passive:GetWidth(),30+passiveValueCtrl:GetHeight())
    
    frame:Resize(frame:GetWidth(),500 + monster_passive:GetHeight())
end

function UPDATE_ANCIENT_CARD_PASSIVE_TOOLTIP(frame, handle, numarg1, numarg2)
    local width = 420
    local height = 20
    local yellow_font = "{s14}{#f9e38d}"
    local green_font = "{s14}{#2dcd37}-"
    local bg = GET_CHILD(frame,"bg")
    local passive_title = GET_CHILD(bg,'passive_title')
    passive_title:Invalidate()
    --help text
    local passive_help = GET_CHILD(bg,'passive_help')
    passive_help:SetText(ClMsg("AncientBuffHelp"))
    height = height + passive_help:GetHeight() + 25

    --monster_passive
    local monster_passive_gbox = GET_CHILD(bg,'monster_passive_gbox')
    monster_passive_gbox:SetMargin(0,height,0,0)
    --help
    local monster_passive_help = GET_CHILD(monster_passive_gbox,'monster_passive_help')
    monster_passive_help:SetText(ClMsg("AncientMonsterBuffHelp"))
    local monster_passive_height = monster_passive_help:GetHeight() + 40
    --text invalidate
    local monster_passive = GET_CHILD(monster_passive_gbox,"monster_passive")
    monster_passive:Invalidate()
    --passive
    local monster_passive_list_gbox = GET_CHILD(monster_passive_gbox,'monster_passive_list_gbox')
    monster_passive_list_gbox:RemoveAllChild()
    local card = session.pet.GetAncientCardBySlot(0)
    if card ~= nil then
        local ctrlHeight = 0
        local infoCls = GetClass("Ancient_Info",card:GetClassName())
        local monNameCtrl = monster_passive_list_gbox:CreateControl("richtext","monstername",100,30,ui.LEFT,ui.TOP,5,0,0,0);
        monNameCtrl:SetText(yellow_font..infoCls.Name..' '..ClMsg("AncientMonsterBuff"))
        monNameCtrl:SetFontName("yellow_16_ol")
        ctrlHeight = ctrlHeight + monNameCtrl:GetHeight() + 3

        local caption, parsed = TRY_PARSE_ANCIENT_PROPERTY(infoCls, infoCls.Tooltop, card);
        local passiveCtrl = monster_passive_list_gbox:CreateControl("richtext","monster",100,30,ui.LEFT,ui.TOP,5,ctrlHeight,0,0);
        passiveCtrl:SetText(green_font..caption)
        ctrlHeight = ctrlHeight + passiveCtrl:GetHeight() + 3

        monster_passive_list_gbox:Resize(40,monster_passive_height,width,ctrlHeight)
        height = height + ctrlHeight
    end
    height = height + monster_passive_height
    monster_passive_gbox:Resize(width,height)

    --combo_passive
    local combo_passive_gbox = GET_CHILD(bg,'combo_passive_gbox')
    combo_passive_gbox:SetMargin(0,height,0,0)
    --line
    -- local combo_passive_line = GET_CHILD(combo_passive_gbox,"combo_passive_line")
    -- combo_passive_line:SetAlpha(50)
    --help
    local combo_passive_help = GET_CHILD(combo_passive_gbox,'combo_passive_help')
    combo_passive_help:SetText(ClMsg("AncientComboBuffHelp"))
    local combo_passive_height = combo_passive_help:GetHeight() + 40
    --text invalidate
    local combo_passive = GET_CHILD(combo_passive_gbox,"combo_passive")
    combo_passive:Invalidate()
    --passive
    local combo_passive_list_gbox = GET_CHILD(combo_passive_gbox,'combo_passive_list_gbox')
    combo_passive_list_gbox:RemoveAllChild()

    local cardList = GetAncientMainCardList()
    local comboList = GET_ANCIENT_COMBO_LIST(cardList)
    local comboBoxHeight = 0
    for i = 1,#comboList do
        local comboCls = comboList[i][1]
        local comboCardList = comboList[i][2]
        local comboNameCtrl = combo_passive_list_gbox:CreateControl("richtext","comboname_"..i,100,30,ui.LEFT,ui.TOP,5,comboBoxHeight,0,0);
        comboNameCtrl:SetText(yellow_font..comboCls.Name..' '..ClMsg("AncientComboBuff"))
        comboNameCtrl:SetFontName("yellow_16_ol")
        comboBoxHeight = comboBoxHeight + comboNameCtrl:GetHeight() + 3

        local caption, parsed = TRY_PARSE_ANCIENT_PROPERTY(comboCls, comboCls.Tooltop,comboCardList);
        local passiveCtrl = combo_passive_list_gbox:CreateControl("richtext","combo_"..i,100,31,ui.LEFT,ui.TOP,5,comboBoxHeight,0,0);
        passiveCtrl:SetText(green_font..caption)
        comboBoxHeight = comboBoxHeight + passiveCtrl:GetHeight() + 3
    end
    combo_passive_list_gbox:Resize(40,combo_passive_height,width,comboBoxHeight)

    combo_passive_gbox:Resize(width,comboBoxHeight+combo_passive_height)
    combo_passive_list_gbox:Resize(width,comboBoxHeight)

    height = height + comboBoxHeight + combo_passive_height + 15
    frame:Resize(width, height)
    bg:Resize(width, height)
end

function TRY_PARSE_ANCIENT_PROPERTY(obj, caption, extraArg)
    local tagStart = string.find(caption, "#{");
    if tagStart ~= nil then
        local nextStr = string.sub(caption, tagStart + 2, string.len(caption));
        local tagEnd = string.find(nextStr, "}#");
        if tagEnd ~= nil then
            local tagText = string.sub(caption, tagStart + 2, tagStart + tagEnd);
            local beforeStr = string.sub(caption, 1, tagStart - 1);
            local endStr = string.sub(caption, tagStart + tagEnd + 3, string.len(caption));

            local propValueScript = _G[obj[tagText]]
            local propValue = propValueScript(obj,extraArg)

            if propValue % 1 ~= 0 then
                propValue = string.format("%.1f", propValue);
            end
            return (beforeStr .. propValue .. endStr), 1;
        end

    end
    return caption, 0;
end
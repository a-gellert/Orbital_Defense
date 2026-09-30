local config = require "main.game_config"

local M = {}
M.data = {
	gold = 100, -- Р”Р°РґРёРј РЅРµРјРЅРѕРіРѕ РґРµРЅРµРі РЅР° СЃС‚Р°СЂС‚ РґР»СЏ С‚РµСЃС‚Р°
	diamonds = 0,
	is_paused =true,
	has_free_slot = true,
	click_state = 0,
	-- РЎРѕСЃС‚РѕСЏРЅРёРµ С‚СѓСЂРµР»РµР№

	turrets = {
		blaster = { unlocked = true, level_dmg = 1, level_rate = 1, price = 100, base_price = 100 },
		pulse  = { unlocked = true, level_dmg = 1, level_rate = 1, price = 250, base_price = 250 },
		rocket  = { unlocked = true, level_dmg = 1, level_rate = 1, price = 600, base_price = 600 },
		laser   = { unlocked = false, level_dmg = 1, level_rate = 1, price = 2000, base_price = 2000 },
		plasma  = { unlocked = false, level_dmg = 1, level_rate = 1, price = 10000, base_price = 10000 },
		tesla   = { unlocked = false, level_dmg = 1, level_rate = 1, price = 50000, base_price = 50000 }
	},
	-- РћСЂР±РёС‚С‹ (Р­С‚РѕРіРѕ Р±Р»РѕРєР° РЅРµ С…РІР°С‚Р°Р»Рѕ!)

	orbits = {
		count = 1,
		level_speed = 1,
	},

	orbits_data = {
		or1 = { id = hash("/orbit_1"), radius = 75,  speed = 1.5, slots = 4,  price = 0,     unlocked = true },
		or2 = { id = hash("/orbit_2"), radius = 105, speed = 1,   slots = 6,  price = 1000,  unlocked = true },
		or3 = { id = hash("/orbit_3"), radius = 135, speed = 0.8, slots = 10, price = 5000,  unlocked = false },
		or4 = { id = hash("/orbit_4"), radius = 165, speed = 0.6, slots = 16, price = 15000, unlocked = false },
		or5 = { id = hash("/orbit_5"), radius = 195, speed = 0.4, slots = 24, price = 50000, unlocked = false },
		or6 = { id = hash("/orbit_6"), radius = 225, speed = 0.2, slots = 32, price = 150000,unlocked = false }
	},
	active_upgrades = {},
	rarity_colors = {},
	-- РџР»Р°РЅРµС‚Р° Рё Р­РєРѕРЅРѕРјРёРєР°

	economy = {
		level_gpk = 1,     
		level_hp = 1,      -- РЈСЂРѕРІРµРЅСЊ Р·РґРѕСЂРѕРІСЊСЏ РїР»Р°РЅРµС‚С‹
		base_gold_per_kill = 10,
		gold_per_kill = 10,
		passive_income = 0,
		planet_max_hp = 100,
		planet_hp = 100,
		planet_dmg = 10,
		planet_damage_radius = 250
	}

}
M.data.active_upgrades = {}
M.active_enemies = {}
M.rarity_colors = {
	[1] = vmath.vector4(0.8, 0.8, 0.8, 1), -- РћР±С‹С‡РЅС‹Р№ (РЎРµСЂС‹Р№)
	[2] = vmath.vector4(0.2, 0.8, 0.2, 1), -- Р­Р»РёС‚РЅС‹Р№ (Р—РµР»РµРЅС‹Р№)
	[3] = vmath.vector4(0.2, 0.5, 1, 1),   -- Р РµРґРєРёР№ (РЎРёРЅРёР№)
	[4] = vmath.vector4(0.8, 0.2, 0.8, 1), -- Р­РїРёС‡РµСЃРєРёР№ (Р¤РёРѕР»РµС‚РѕРІС‹Р№)
}

-- РџРѕР»СѓС‡РёС‚СЊ Р·РЅР°С‡РµРЅРёРµ РєРѕРЅРєСЂРµС‚РЅРѕРіРѕ Р°РєС‚РёРІРЅРѕРіРѕ Р°РїРіСЂРµР№РґР°
function M.get_upgrade_value(upgrade_id, default_val)
	local lvl = M.data.active_upgrades[upgrade_id]
	if not lvl or lvl == 0 then return default_val end
	local upg = config.upgrades[upgrade_id]
	if upg and upg.levels and upg.levels[lvl] then
		return upg.levels[lvl]
	end
	return default_val
end

-- Overdrive State
M.overdrive = 0
M.is_overdrive = false
M.overdrive_timer = 0

function M.add_overdrive(amount)
	if M.is_overdrive then return end
	local charge_mult = M.get_upgrade_value("click_overdrive_charge", 1.0)
	M.overdrive = math.min(100, M.overdrive + (amount * charge_mult))

	-- РўСЂРёРіРіРµСЂ РїРµСЂРµС…РѕРґР° РІ Overdrive РїСЂРё 100%
	if M.overdrive >= 100 then
		M.is_overdrive = true
		local dur_mult = M.get_upgrade_value("overdrive_duration", 1.0)
		M.overdrive_timer = 6.0 * dur_mult
		msg.post("main:/camera_root#camera_shake", "shake", { intensity = 12, duration = 0.4 })
		if msg.url("main:/gui#game") then
			msg.post("main:/gui#game", "overdrive_started")
		end
		if msg.url("main:/planet#planet") then
			msg.post("main:/planet#planet", "overdrive_started")
		end
	end
end

function M.update_overdrive(dt)
	if M.is_overdrive then
		M.overdrive_timer = M.overdrive_timer - dt
		local dur_mult = M.get_upgrade_value("overdrive_duration", 1.0)
		M.overdrive = math.max(0, (M.overdrive_timer / (6.0 * dur_mult)) * 100)

		if M.overdrive_timer <= 0 then
			M.is_overdrive = false
			M.overdrive = 0
			if msg.url("main:/gui#game") then
				msg.post("main:/gui#game", "overdrive_ended")
			end
			if msg.url("main:/planet#planet") then
				msg.post("main:/planet#planet", "overdrive_ended")
			end
		end
	end
end

-- Р’СЃРїРѕРјРѕРіР°С‚РµР»СЊРЅС‹Рµ РіРµС‚С‚РµСЂС‹ РґР»СЏ РїРµСЂРєРѕРІ
function M.get_fire_rate_multiplier()
	local base = M.get_upgrade_value("increase_fire_rate", 1.0)
	return M.is_overdrive and (base * 2.3) or base
end

function M.get_damage_multiplier()
	return M.is_overdrive and 1.5 or 1.0
end

function M.get_projectile_speed_multiplier()
	return M.get_upgrade_value("projectile_speed", 1.0)
end

function M.get_multishot_chance()
	-- Р•СЃР»Рё СѓСЂРѕРІРµРЅСЊ 0, С€Р°РЅСЃ 0. Р•СЃР»Рё СѓСЂРѕРІРЅРё 1.05..1.25, СЌС‚Рѕ С€Р°РЅСЃ 5%..25%
	local val = M.get_upgrade_value("multishot_chance", 1.0)
	return math.max(0, val - 1.0)
end

function M.get_splash_radius_mult()
	return M.get_upgrade_value("splash_radius", 1.0)
end

function M.get_pierce_count()
	return math.floor(M.get_upgrade_value("piercing_shots", 1)) - 1
end

function M.get_gold_per_kill()
	local mult = M.get_upgrade_value("gold_per_kill", 1.0)
	return math.floor(M.data.economy.base_gold_per_kill * mult)
end

function M.get_max_hp()
	local base_hp = M.data.economy.planet_max_hp or 100
	local mult = M.get_upgrade_value("planet_hp", 1.0)
	return math.floor(base_hp * mult)
end

function M.get_hp_regen()
	local meta_regen = (M.meta.regen_level or 0) * 0.8
	return meta_regen + M.get_upgrade_value("planet_hp_regen", 0)
end

-- Р’ progression.lua РІС‹Р±РѕСЂ РєР°СЂС‚РѕС‡РµРє
function M.get_random_upgrades(count)
	local upgrades = config.upgrades
	local weights = { [1] = 60, [2] = 25, [3] = 10, [4] = 5 }

	local available = {}
	for key, upgrade in pairs(upgrades) do
		local current_lvl = M.data.active_upgrades[key] or 0
		if current_lvl < #upgrade.levels then
			table.insert(available, key)
		end
	end

	if #available == 0 then return {} end

	local result = {}
	local selected = {}
	local attempts = 0

	while #result < count and #result < #available and attempts < 100 do
		attempts = attempts + 1
		local key = available[math.random(#available)]
		if not selected[key] then
			local upgrade = upgrades[key]
			if math.random(1, 100) <= (weights[upgrade.type] or 50) then
				selected[key] = true
				table.insert(result, { id = key, data = upgrade })
			end
		end
	end

	-- Р•СЃР»Рё РёР·-Р·Р° РІРµСЃРѕРІ РЅРµ РґРѕР±СЂР°Р»Рё РґРѕ РЅСѓР¶РЅРѕРіРѕ РєРѕР»РёС‡РµСЃС‚РІР°, РґРѕР±РёСЂР°РµРј Р»СЋР±С‹Рµ РґРѕСЃС‚СѓРїРЅС‹Рµ
	if #result < count and #result < #available then
		for _, key in ipairs(available) do
			if not selected[key] then
				selected[key] = true
				table.insert(result, { id = key, data = upgrades[key] })
				if #result >= count then break end
			end
		end
	end

	return result
end

-- РњР•РўРђ-РџР РћР“Р Р•РЎРЎРРЇ Р РЎРћРҐР РђРќР•РќРРЇ (РЎРѕС…СЂР°РЅСЏРµС‚СЃСЏ РјРµР¶РґСѓ Р·Р°Р±РµРіР°РјРё)
M.meta = {
	total_coins = 0,
	best_wave = 1,
	hp_level = 0,
	dmg_level = 0,
	gold_level = 0,
	regen_level = 0
}

function M.load_save()
	local save_path = sys.get_save_file("orbital_defense", "meta_save")
	local loaded = sys.load(save_path)
	if loaded and next(loaded) then
		for k, v in pairs(loaded) do
			M.meta[k] = v
		end
		M.meta.best_wave = tonumber(M.meta.best_wave) or tonumber(tostring(M.meta.best_wave or ""):match("%d+")) or 1
		M.meta.total_coins = tonumber(M.meta.total_coins) or 0
		print("💾 Save Loaded! Total Coins:", M.meta.total_coins, "Best Wave:", M.meta.best_wave)
	else
		print("🆕 No save found. Created fresh save.")
	end
end

function M.save_progress()
	local save_path = sys.get_save_file("orbital_defense", "meta_save")
	sys.save(save_path, M.meta)
	print("рџ’ѕ Progress Saved! Total Coins:", M.meta.total_coins)
end

function M.get_meta_price(upgrade_type)
	local current_lvl = M.meta[upgrade_type .. "_level"] or 0
	local base_price = 100
	if upgrade_type == "dmg" then base_price = 120
	elseif upgrade_type == "gold" then base_price = 150
	elseif upgrade_type == "regen" then base_price = 200
	end
	return math.floor(base_price * (1.35 ^ current_lvl))
end

function M.buy_meta_upgrade(upgrade_type)
	local current_lvl = M.meta[upgrade_type .. "_level"] or 0
	local price = M.get_meta_price(upgrade_type)
	if (M.meta.total_coins or 0) >= price then
		M.meta.total_coins = M.meta.total_coins - price
		M.meta[upgrade_type .. "_level"] = current_lvl + 1
		M.save_progress()

		-- РЎСЂР°Р·Сѓ РїСЂРёРјРµРЅСЏРµРј Рє С‚РµРєСѓС‰РµР№ СЃРµСЃСЃРёРё
		if upgrade_type == "hp" then
			M.data.economy.planet_max_hp = (M.data.economy.planet_max_hp or 100) + 25
			M.data.economy.planet_hp = (M.data.economy.planet_hp or 100) + 25
		elseif upgrade_type == "dmg" then
			M.data.economy.planet_dmg = (M.data.economy.planet_dmg or 10) + 3
		elseif upgrade_type == "gold" then
			M.data.gold = (M.data.gold or 0) + 80
		end
		return true, price
	end
	return false, price
end

function M.reset_progress()
	M.data.active_upgrades = {}
	M.active_enemies = {}
	M.overdrive = 0
	M.is_overdrive = false
	M.overdrive_timer = 0
	M.is_paused = false
	M.has_free_slot = true

	-- РџСЂРёРјРµРЅСЏРµРј РјРµС‚Р°-РїСЂРѕРіСЂРµСЃСЃРёСЋ
	local start_gold = 100 + (M.meta.gold_level or 0) * 80
	local base_hp = 100 + (M.meta.hp_level or 0) * 25
	local base_dmg = 10 + (M.meta.dmg_level or 0) * 3

	M.data.gold = start_gold
	M.data.economy.planet_max_hp = base_hp
	M.data.economy.planet_hp = base_hp
	M.data.economy.planet_dmg = base_dmg

	for id, turret in pairs(M.data.turrets) do
		turret.owned = false
		turret.count = 0
		turret.level_dmg = 1
		turret.price = turret.base_price or turret.price
	end

	for id, orbit in pairs(M.data.orbits_data) do
		orbit.unlocked = (id == "or1")
	end
	print("рџ§№ Р—Р°Р±РµРі РЅР°С‡Р°С‚! Gold:", start_gold, "HP:", base_hp, "DMG:", base_dmg)
end

-- РђРІС‚РѕР·Р°РіСЂСѓР·РєР° РїСЂРё СЃС‚Р°СЂС‚Рµ
M.load_save()
M.reset_progress()

M.has_free_slot = true
M.is_paused = true

-- Р¤РѕСЂРјСѓР»Р° СЃРѕРєСЂР°С‰РµРЅРёСЏ С‡РёСЃРµР»
function M.format_num(n)
	if not n then return "0" end
	if n >= 10^9 then return string.format("%.2fB", n/10^9) end
	if n >= 10^6 then return string.format("%.2fM", n/10^6) end
	if n >= 10^3 then return string.format("%.1fK", n/10^3) end
	return tostring(math.floor(n))
end

return M
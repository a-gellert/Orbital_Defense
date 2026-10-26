local config = require "main.game_config"

local M = {}
M.data = {
	gold = 250,
	diamonds = 0,
	is_paused = true,
	has_free_slot = true,
	click_state = 0,

	-- Turret states
	turrets = {
		blaster = { unlocked = true, level_dmg = 1, level_rate = 1, price = 100, base_price = 100 },
		pulse   = { unlocked = true, level_dmg = 1, level_rate = 1, price = 250, base_price = 250 },
		rocket  = { unlocked = true, level_dmg = 1, level_rate = 1, price = 600, base_price = 600 },
		laser   = { unlocked = true, level_dmg = 1, level_rate = 1, price = 1400, base_price = 1400 },
		plasma  = { unlocked = true, level_dmg = 1, level_rate = 1, price = 3000, base_price = 3000 },
		tesla   = { unlocked = true, level_dmg = 1, level_rate = 1, price = 6000, base_price = 6000 }
	},

	orbits = {
		count = 1,
		level_speed = 1,
	},

	orbits_data = {
		or1 = { id = hash("/orbit_1"), radius = 75,  speed = 1.5, slots = 4,  price = 0,     unlocked = true },
		or2 = { id = hash("/orbit_2"), radius = 105, speed = 1,   slots = 6,  price = 600,   unlocked = true },
		or3 = { id = hash("/orbit_3"), radius = 135, speed = 0.8, slots = 10, price = 2500,  unlocked = false },
		or4 = { id = hash("/orbit_4"), radius = 165, speed = 0.6, slots = 16, price = 8000,  unlocked = false },
		or5 = { id = hash("/orbit_5"), radius = 195, speed = 0.4, slots = 24, price = 25000, unlocked = false },
		or6 = { id = hash("/orbit_6"), radius = 225, speed = 0.2, slots = 32, price = 80000, unlocked = false }
	},
	active_upgrades = {},
	rarity_colors = {},

	-- Planet and Economy
	economy = {
		level_gpk = 1,     
		level_hp = 1,
		base_gold_per_kill = 10,
		gold_per_kill = 10,
		passive_income = 0,
		shield_max = 20,
		shield = 20,
		planet_max_hp = 150,
		planet_hp = 150,
		planet_dmg = 15,
		planet_damage_radius = 165
	}
}

M.data.active_upgrades = {}
M.rarity_colors = {
	[1] = vmath.vector4(0.8, 0.8, 0.8, 1), -- Common (Gray)
	[2] = vmath.vector4(0.2, 0.8, 0.2, 1), -- Elite (Green)
	[3] = vmath.vector4(0.2, 0.5, 1, 1),   -- Rare (Blue)
	[4] = vmath.vector4(0.8, 0.2, 0.8, 1), -- Epic (Purple)
}

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

-- Perk Multiplier Getters
M.hyper_fire_timer = 0

function M.get_fire_rate_multiplier()
	local base = M.get_upgrade_value("increase_fire_rate", 1.0)
	local hyper = (M.hyper_fire_timer and M.hyper_fire_timer > 0) and 2.0 or 1.0
	return base * (M.is_overdrive and 2.2 or 1.0) * hyper
end

function M.get_damage_multiplier()
	local base = 1.0
	return base * (M.is_overdrive and 1.5 or 1.0)
end

function M.get_projectile_speed_multiplier()
	return M.get_upgrade_value("projectile_speed", 1.0)
end

function M.get_multishot_chance()
	local val = M.get_upgrade_value("multishot_chance", 1.0)
	return math.max(0, val - 1.0)
end

function M.get_splash_radius_mult()
	return M.get_upgrade_value("splash_radius", 1.0)
end

function M.get_pierce_count()
	return math.floor(M.get_upgrade_value("piercing_shots", 1)) - 1
end

function M.get_chain_count()
	return math.floor(M.get_upgrade_value("chain_lightning", 0))
end

-- Шанс удвоить золото за убийство (перк LUCKY DROP: 1.05 -> 5%)
function M.get_lucky_chance()
	return math.max(0, M.get_upgrade_value("lucky_drop", 1.0) - 1.0)
end

function M.get_gold_per_kill()
	local mult = M.get_upgrade_value("gold_per_kill", 1.0)
	return math.floor(M.data.economy.base_gold_per_kill * mult)
end

function M.get_max_hp()
	local base_hp = M.data.economy.planet_max_hp or 150
	local mult = M.get_upgrade_value("planet_hp", 1.0)
	return math.floor(base_hp * mult)
end

function M.get_max_shield()
	local base_shield = M.data.economy.shield_max or 20
	local mult = M.get_upgrade_value("planet_shield", 1.0)
	return math.floor(base_shield * mult)
end

function M.get_hp_regen()
	local meta_u = M.meta and M.meta.upgrades or {}
	local hard_meta_regen = (meta_u.planet_regen or 0) * 1.0
	local vault_regen = (M.meta.regen_level or 0) * 0.8
	return hard_meta_regen + vault_regen + M.get_upgrade_value("planet_hp_regen", 0)
end

-- Perk Card Selector
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

-- Meta Progression and Saves
M.meta_upgrades_def = {
	{
		id = "orbits_start",
		name = "STARTER ORBITS",
		sprite = "m_orbit",
		prices = { 30, 80, 180 },
		get_info = function(lvl) return string.format("%d Orbit(s)", lvl) end
	},
	{
		id = "orbit_speed",
		name = "ORBIT SPEED",
		sprite = "m_speed",
		prices = { 20, 50, 110 },
		get_info = function(lvl) return string.format("+%d%% Speed", (lvl-1)*15) end
	},
	{
		id = "planet_dmg",
		name = "PLANET DAMAGE",
		sprite = "m_dmg",
		prices = { 25, 60, 130 },
		get_info = function(lvl) return string.format("+%d%% Core Dmg", (lvl-1)*25) end
	},
	{
		id = "planet_shield",
		name = "ENERGY SHIELD",
		sprite = "m_shield",
		prices = { 20, 50, 110 },
		get_info = function(lvl)
			local sh = 20 + (lvl - 1) * 15
			return string.format("%d Max Shield", sh)
		end
	},
	{
		id = "planet_hp",
		name = "PLANET MAX HP",
		sprite = "m_hp",
		prices = { 15, 40, 90 },
		get_info = function(lvl) return string.format("+%d Max HP", (lvl-1)*30) end
	},
	{
		id = "planet_regen",
		name = "HP REGEN",
		sprite = "m_regen",
		prices = { 30, 75, 160 },
		get_info = function(lvl) return string.format("+%.1f HP/s", (lvl-1)*1.0) end
	},
	{
		id = "planet_range",
		name = "RADAR RANGE",
		sprite = "m_radar",
		prices = { 20, 50, 110 },
		get_info = function(lvl) return string.format("+%d%% Range", (lvl-1)*15) end
	}
}

M.meta = {
	total_coins = 0,
	diamonds = 50,
	best_wave = 1,
	hp_level = 0,
	dmg_level = 0,
	gold_level = 0,
	regen_level = 0,
	upgrades = {
		orbits_start  = 0,
		orbit_speed   = 0,
		planet_dmg    = 0,
		planet_shield = 0,
		planet_hp     = 0,
		planet_regen  = 0,
		planet_range  = 0
	},
	tutorial_completed = false,
	quests = {
		kills_done = false,
		turrets_done = false,
		wave5_done = false
	}
}

M.session_stats = {
	kills = 0,
	turrets = 0,
	waves = 1
}

function M.load_save()
	local save_path = sys.get_save_file("orbital_defense", "meta_save")
	local loaded = sys.load(save_path)
	if loaded and next(loaded) then
		for k, v in pairs(loaded) do
			if k == "quests" and type(v) == "table" then
				for qk, qv in pairs(v) do
					M.meta.quests[qk] = qv
				end
			elseif k == "upgrades" and type(v) == "table" then
				for uk, uv in pairs(v) do
					if not M.meta.upgrades then M.meta.upgrades = {} end
					M.meta.upgrades[uk] = uv
				end
			else
				M.meta[k] = v
			end
		end
		M.meta.best_wave = tonumber(M.meta.best_wave) or tonumber(tostring(M.meta.best_wave or ""):match("%d+")) or 1
		M.meta.total_coins = tonumber(M.meta.total_coins) or 0
		M.meta.diamonds = tonumber(M.meta.diamonds) or 50
		print("Save Loaded! Diamonds:", M.meta.diamonds, "Total Coins:", M.meta.total_coins, "Best Wave:", M.meta.best_wave)
	else
		print("No save found. Created fresh save.")
	end
end

function M.save_progress()
	local save_path = sys.get_save_file("orbital_defense", "meta_save")
	sys.save(save_path, M.meta)
	print("Progress Saved! Diamonds:", M.meta.diamonds, "Total Coins:", M.meta.total_coins)
end

function M.buy_hard_meta_upgrade(id)
	if not M.meta.upgrades then M.meta.upgrades = {} end
	local cur_upg_lvl = M.meta.upgrades[id] or 0
	if cur_upg_lvl >= 3 then return false end

	for _, def in ipairs(M.meta_upgrades_def) do
		if def.id == id then
			local price = def.prices[cur_upg_lvl + 1]
			if (M.meta.diamonds or 0) >= price then
				M.meta.diamonds = M.meta.diamonds - price
				M.meta.upgrades[id] = cur_upg_lvl + 1
				M.save_progress()
				return true, cur_upg_lvl + 1
			end
		end
	end
	return false
end

function M.complete_tutorial()
	if not M.meta.tutorial_completed then
		M.meta.tutorial_completed = true
		M.save_progress()
	end
end

function M.check_quest(quest_type, param)
	if not M.meta.quests then M.meta.quests = {} end
	if quest_type == "kill" then
		M.session_stats.kills = (M.session_stats.kills or 0) + 1
		if not M.meta.quests.kills_done and M.session_stats.kills >= 50 then
			M.meta.quests.kills_done = true
			M.meta.diamonds = (M.meta.diamonds or 0) + 30
			M.save_progress()
			return 30
		end
	elseif quest_type == "turret" then
		M.session_stats.turrets = (M.session_stats.turrets or 0) + 1
		if not M.meta.quests.turrets_done and M.session_stats.turrets >= 3 then
			M.meta.quests.turrets_done = true
			M.meta.diamonds = (M.meta.diamonds or 0) + 40
			M.save_progress()
			return 40
		end
	elseif quest_type == "wave" then
		local wave = param or 1
		if not M.meta.quests.wave5_done and wave >= 5 then
			M.meta.quests.wave5_done = true
			M.meta.diamonds = (M.meta.diamonds or 0) + 60
			M.save_progress()
			return 60
		end
	end
	return nil
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

		if upgrade_type == "hp" then
			M.data.economy.planet_max_hp = (M.data.economy.planet_max_hp or 120) + 25
			M.data.economy.planet_hp = (M.data.economy.planet_hp or 120) + 25
		elseif upgrade_type == "dmg" then
			M.data.economy.planet_dmg = (M.data.economy.planet_dmg or 15) + 3
		elseif upgrade_type == "gold" then
			M.data.gold = (M.data.gold or 0) + 80
		end
		return true, price
	end
	return false, price
end

function M.reset_progress()
	M.data.active_upgrades = {}
	M.overdrive = 0
	M.is_overdrive = false
	M.overdrive_timer = 0
	M.is_paused = false
	M.has_free_slot = true
	M.hyper_fire_timer = 0

	M.session_stats = {
		kills = 0,
		turrets = 0,
		waves = 1
	}

	local meta_u = M.meta and M.meta.upgrades or {}

	local starter_orbits = 1 + (meta_u.orbits_start or 0)
	local orbit_speed_mult = 1.0 + (meta_u.orbit_speed or 0) * 0.15

	for id, orbit in pairs(M.data.orbits_data) do
		local num = tonumber(id:sub(3)) or 1
		orbit.unlocked = (num <= starter_orbits)
		if not orbit.base_speed then orbit.base_speed = orbit.speed end
		orbit.speed = orbit.base_speed * orbit_speed_mult
	end

	local base_hp = 150 + (meta_u.planet_hp or 0) * 30 + (M.meta.hp_level or 0) * 30
	local base_shield = 20 + (meta_u.planet_shield or 0) * 15
	local base_dmg = math.floor((15 + (M.meta.dmg_level or 0) * 4) * (1 + (meta_u.planet_dmg or 0) * 0.25))
	local base_range = math.floor(165 * (1 + (meta_u.planet_range or 0) * 0.15))

	local start_gold = 250 + (M.meta.gold_level or 0) * 100

	M.data.gold = start_gold
	M.data.economy.shield_max = base_shield
	M.data.economy.shield = base_shield
	M.data.economy.planet_max_hp = base_hp
	M.data.economy.planet_hp = base_hp
	M.data.economy.planet_dmg = base_dmg
	M.data.economy.planet_damage_radius = base_range
	M.data.economy.level_shield = 1
	M.data.economy.level_dmg = 1
	M.data.economy.level_hp = 1
	M.data.economy.level_gpk = 1
	M.data.economy.level_radar = 1
	M.data.economy.repair_count = 0
	M.data.economy.base_gold_per_kill = 10
	M.data.economy.gold_per_kill = 10

	for id, turret in pairs(M.data.turrets) do
		turret.owned = false
		turret.count = 0
		turret.level_dmg = 1
		turret.price = turret.base_price or turret.price
	end

	print("Run started! Starter Orbits:", starter_orbits, "Speed Mult:", orbit_speed_mult, "Gold:", start_gold, "HP:", base_hp, "Shield:", base_shield, "DMG:", base_dmg)
end

M.load_save()
M.reset_progress()

M.has_free_slot = true
M.is_paused = true

function M.format_num(n)
	if not n then return "0" end
	if n >= 10^9 then return string.format("%.2fB", n/10^9) end
	if n >= 10^6 then return string.format("%.2fM", n/10^6) end
	if n >= 10^3 then return string.format("%.1fK", n/10^3) end
	return tostring(math.floor(n))
end

return M
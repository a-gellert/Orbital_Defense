-- game_config.lua
local M = {}

-- 6 Turrets: Balanced stats, unique roles & projectile behaviors
M.turret_stats = {
	blaster = { damage = 24, rate = 1.50, range = 150, bullet_speed = 480 }, -- Rapid Kinetic Cannon
	pulse   = { damage = 11, rate = 0.4, range = 140, bullet_speed = 560 }, -- Ultra-Rapid Stream
	rocket  = { damage = 90, rate = 2.50, range = 170, bullet_speed = 220 }, -- Homing Splash Missile
	laser   = { damage = 38, rate = 0.45, range = 160, bullet_speed = 750 }, -- High-Energy Piercing Beam
	plasma  = { damage = 150, rate = 3.90, range = 150, bullet_speed = 210 }, -- Heavy Explosive Mortar
	tesla   = { damage = 60, rate = 1.85, range = 150, bullet_speed = 650 }  -- Chain Lightning Arc
}

-- 12 Distinct Enemy Types: Varied silhouettes, behaviors, shields & roles
M.enemy_stats = {
	kamikaze      = { type = 1, unlock_wave = 1,  hp = 14,  damage = 10, speed = 34, is_fireable = false, shield = 0, move = "straight" },
	swarmer       = { type = 1, unlock_wave = 1,  hp = 6,   damage = 4,  speed = 50, is_fireable = false, shield = 0, move = "straight" },
	swing         = { type = 2, unlock_wave = 3,  hp = 14,  damage = 8,  speed = 36, is_fireable = false, shield = 0, move = "sinuos" },
	shooter       = { type = 2, unlock_wave = 4,  hp = 20,  damage = 6,  speed = 28, is_fireable = true,  shield = 0, move = "straight" },
	tank          = { type = 2, unlock_wave = 6,  hp = 45,  damage = 14, speed = 18, is_fireable = false, shield = 2, move = "straight" },
	splitter      = { type = 3, unlock_wave = 8,  hp = 30,  damage = 10, speed = 26, is_fireable = false, shield = 0, move = "straight" },
	mini_splitter = { type = 1, unlock_wave = 30, hp = 8,   damage = 4,  speed = 44, is_fireable = false, shield = 0, move = "straight" },
	warp          = { type = 3, unlock_wave = 10, hp = 26,  damage = 12, speed = 26, is_fireable = true,  shield = 1, move = "warp" },
	speeder       = { type = 2, unlock_wave = 12, hp = 16,  damage = 8,  speed = 60, is_fireable = false, shield = 0, move = "speeder" },
	ghost         = { type = 3, unlock_wave = 15, hp = 28,  damage = 12, speed = 32, is_fireable = false, shield = 0, move = "ghost" },
	shield_bearer = { type = 3, unlock_wave = 18, hp = 55,  damage = 10, speed = 20, is_fireable = false, shield = 4, move = "straight" },
	dreadnought   = { type = 4, unlock_wave = 22, hp = 130, damage = 25, speed = 16, is_fireable = true,  shield = 3, move = "straight" },
	gold_asteroid = { type = 3, unlock_wave = 999, hp = 20,  damage = 0,  speed = 32, is_fireable = false, shield = 0, move = "drift" }
}

M.upgrades = {}
-- Rarity Types: 1 - Common, 2 - Elite, 3 - Rare, 4 - Epic

-- ATTACK & SPEED
M.upgrades.increase_fire_rate = { type = 1, levels = {1.1, 1.2, 1.35, 1.5, 1.8}, owner = "turret", sprite = "u_t_atk_spd", info = "+ATK SPEED" }
M.upgrades.projectile_speed   = { type = 1, levels = {1.2, 1.4, 1.7, 2.0}, owner = "all", sprite = "u_a_prj_spd", info = "+BULLET SPD" }
M.upgrades.multishot_chance   = { type = 3, levels = {1.05, 1.1, 1.15, 1.25}, owner = "turret", sprite = "u_t_multi", info = "MULTISHOT" }

-- SPECIAL MECHANICS
M.upgrades.splash_radius   = { type = 2, levels = {1.2, 1.4, 1.6, 2.0}, owner = "rocket", sprite = "u_r_splash", info = "ROCKET SPLASH" }
M.upgrades.chain_lightning = { type = 4, levels = {2, 3, 4}, owner = "tesla", sprite = "u_te_chain", info = "TESLA CHAIN" }
M.upgrades.piercing_shots  = { type = 3, levels = {2, 3, 5}, owner = "blaster", sprite = "u_b_pierce", info = "PIERCING SHOT" }

-- ECONOMY
M.upgrades.gold_per_kill   = { type = 1, levels = {1.2, 1.5, 2.0, 3.0}, owner = "planet", sprite = "u_p_gold", info = "+GOLD / KILL" }
M.upgrades.lucky_drop      = { type = 2, levels = {1.05, 1.1, 1.15}, owner = "all", sprite = "u_a_lucky", info = "LUCKY DROP" }
M.upgrades.planet_orbit    = { type = 2, levels = {2, 3, 4, 5, 6}, owner = "all", sprite = "u_a_orbit", info = "+ORBIT SLOT" }
M.upgrades.planet_hp       = { type = 3, levels = {1.2, 1.5, 1.8, 2.2, 3.0}, owner = "planet", sprite = "u_p_hp", info = "+MAX HP" }
M.upgrades.planet_hp_regen = { type = 2, levels = {1, 2, 4, 7, 12}, owner = "planet", sprite = "u_p_hp_regen", info = "+HP REGEN" }

-- CLICKER MECHANICS (Overdrive)
M.upgrades.click_overdrive_charge = { type = 2, levels = {1.15, 1.3, 1.6}, owner = "planet", sprite = "u_p_charge", info = "+RAGE CHARGE" }
M.upgrades.overdrive_duration     = { type = 3, levels = {1.2, 1.5, 2.0}, owner = "planet", sprite = "u_p_dur", info = "+RAGE TIME" }

-- SYNERGY & COMBO SPECIALS
M.upgrades.cryo_rounds            = { type = 3, levels = {1, 2, 3}, owner = "all", sprite = "u_b_pierce", info = "CRYO SLOW 40%" }
M.upgrades.chain_reaction         = { type = 4, levels = {1, 2, 3}, owner = "all", sprite = "u_r_splash", info = "CORPSE EXPLODE" }
M.upgrades.singularity            = { type = 4, levels = {1, 2, 3}, owner = "planet", sprite = "u_a_orbit", info = "GRAVITY VORTEX" }

-- Damage level multiplier (+50% per upgrade level)
M.level_multiplier = function(level)
	return 1 + (level - 1) * 0.5
end

return M

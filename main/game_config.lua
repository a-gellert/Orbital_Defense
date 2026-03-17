-- game_config.lua
local M = {}

--турели
M.turret_stats = {
	blaster = { damage = 20, rate = 0.5,range = 70, bullet_speed = 600 },
	pulse = { damage = 8, rate = 0.15,range = 70, bullet_speed = 800 },
	sniper = { damage = 150, rate = 2.5,range = 70, bullet_speed = 1200 },
	rocket = { damage = 80, rate = 1.5,range = 150, bullet_speed = 200 }, -- Тут скорость ниже, т.к. ракета наводится
	laser = { damage = 5, rate = 0.1,range = 70, bullet_speed = 0 },     -- Для лазера скорость не важна
	plasma = { damage = 100, rate = 2.0,range = 70, bullet_speed = 250 },
	tesla = { damage = 45, rate = 1.2,range = 70, bullet_speed = 1000 }
}
--враги
M.enemy_stats = {
	kamikaze = {type = 1, unlock_wave = 1, hp = 15, damage = 10, speed = 60, is_fireable = false, shield = 0, move = "straight" },
	swarmer = {type = 1, unlock_wave = 1, hp = 5, damage = 5, speed = 90, is_fireable = false, shield = 0 , move = "straight"},
	swing = {type = 2, unlock_wave = 3,hp = 10, damage = 10, speed = 90, is_fireable = false, shield = 0 , move = "sinuos"},
	shooter = {type = 2, unlock_wave = 5, speed = 80, is_fireable = true, shield = 0 , move = "straight"},
	tank = {type = 2, unlock_wave = 8,hp = 30, damage = 10, speed = 40, is_fireable = false, shield = 3 , move = "straight"},
	splitter = {type = 3, unlock_wave = 12,hp = 30, damage = 10, speed = 70, is_fireable = true, shield = 0 , move = "straight"},
	mini_splitter = {type = 3, unlock_wave = 30, hp = 10, damage = 5, speed = 90, is_fireable = false, shield = 0 , move = "straight"},
	warp = {type = 3, unlock_wave = 20, hp = 20, damage = 15, speed = 50, is_fireable = true, shield = 2 , move = "warp"}
}


M.upgrades = {}
-- Добавляем в твою таблицу M.upgradess
-- Типы: 1 - Обычный, 2 - Элитный, 3 - Редкий, 4 - Эпический

-- АТАКА И СКОРОСТЬ
M.upgrades.increase_fire_rate = { type = 1, levels = {1.1, 1.2, 1.35, 1.5, 1.8}, owner = "turret", sprite = "u_t_atk_spd", info = "Fire rate for all turrets" }
M.upgrades.projectile_speed = { type = 1, levels = {1.2, 1.4, 1.7, 2.0}, owner = "all", sprite = "u_a_prj_spd", info = "Projectiles travel faster (less misses)" }
M.upgrades.multishot_chance = { type = 3, levels = {1.05, 1.1, 1.15, 1.25}, owner = "turret", sprite = "u_t_multi", info = "Chance to fire an additional projectile" }

-- SPECIAL MECHANICS
M.upgrades.splash_radius = { type = 2, levels = {1.2, 1.4, 1.6, 2.0}, owner = "rocket", sprite = "u_r_splash", info = "Rocket explosion radius" }
M.upgrades.chain_lightning = { type = 4, levels = {2, 3, 4}, owner = "tesla", sprite = "u_te_chain", info = "Number of targets for Tesla discharge" }
M.upgrades.piercing_shots = { type = 3, levels = {2, 3, 5}, owner = "blaster", sprite = "u_b_pierce", info = "Projectiles pierce through enemies" }

-- ECONOMY (Critical for Idle)
M.upgrades.gold_per_kill = { type = 1, levels = {1.2, 1.5, 2.0, 3.0}, owner = "planet", sprite = "u_p_gold", info = "More gold for each enemy defeated" }
M.upgrades.lucky_drop = { type = 2, levels = {1.05, 1.1, 1.15}, owner = "all", sprite = "u_a_lucky", info = "Chance to drop a bonus chest from enemies" }
M.upgrades.planet_orbit = { type = 2, levels = {2, 3, 4, 5, 6}, owner = "all", sprite = "u_a_orbit", info = "Add new orbit" }
M.upgrades.planet_hp = { type = 3, levels = {1.1, 1.2, 1.5, 2, 3}, owner = "planet", sprite = "u_p_hp", info = "Increase the planet's HP" }
M.upgrades.planet_hp = { type = 2, levels = {1.01, 1.05, 1.1, 1.2, 1.3}, owner = "planet", sprite = "u_p_hp_regen", info = "HP regeneration rate" }

-- CLICKER MECHANICS (Overdrive)
M.upgrades.click_overdrive_charge = { type = 2, levels = {1.15, 1.3, 1.6}, owner = "planet", sprite = "u_p_charge", info = "Overdrive gauge fills faster" }
M.upgrades.overdrive_duration = { type = 3, levels = {1.2, 1.5, 2.0}, owner = "planet", sprite = "u_p_dur", info = "Overdrive mode duration" }




-- Прогрессия урона от уровня (множитель)
M.level_multiplier = function(level)
	return 1 + (level - 1) * 0.5 -- +50% урона за уровень
end

return M

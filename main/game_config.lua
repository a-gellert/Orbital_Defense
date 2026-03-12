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

M.upgrades = {}
-- Добавляем в твою таблицу M.upgrades
-- Типы: 1 - Обычный, 2 - Элитный, 3 - Редкий, 4 - Эпический

-- АТАКА И СКОРОСТЬ
M.upgrades.increase_fire_rate = { type = 1, levels = {1.1, 1.2, 1.35, 1.5, 1.8}, owner = "turret", sprite = "u_t_atk_spd", info = "Скорость стрельбы всех турелей" }
M.upgrades.projectile_speed = { type = 1, levels = {1.2, 1.4, 1.7, 2.0}, owner = "all", sprite = "u_a_prj_spd", info = "Пули летят быстрее (меньше промахов)" }
M.upgrades.multishot_chance = { type = 3, levels = {1.05, 1.1, 1.15, 1.25}, owner = "turret", sprite = "u_t_multi", info = "Шанс выпустить дополнительный снаряд" }

-- СПЕЦ-МЕХАНИКИ
M.upgrades.splash_radius = { type = 2, levels = {1.2, 1.4, 1.6, 2.0}, owner = "rocket", sprite = "u_r_splash", info = "Радиус взрыва ракет" }
M.upgrades.chain_lightning = { type = 4, levels = {2, 3, 4}, owner = "tesla", sprite = "u_te_chain", info = "Количество целей для разряда Теслы" }
M.upgrades.piercing_shots = { type = 3, levels = {2, 3, 5}, owner = "blaster", sprite = "u_b_pierce", info = "Пули прошивают врагов насквозь" }

-- ЭКОНОМИКА (Критически важно для Idle)
M.upgrades.gold_per_kill = { type = 1, levels = {1.2, 1.5, 2.0, 3.0}, owner = "planet", sprite = "u_p_gold", info = "Больше золота за каждого сбитого врага" }
M.upgrades.lucky_drop = { type = 2, levels = {1.05, 1.1, 1.15}, owner = "all", sprite = "u_a_lucky", info = "Шанс выбить бонусный сундук из врага" }

-- КЛИКЕРНЫЕ МЕХАНИКИ (Overdrive)
M.upgrades.click_overdrive_charge = { type = 2, levels = {1.15, 1.3, 1.6}, owner = "planet", sprite = "u_p_charge", info = "Шкала ярости заполняется быстрее" }
M.upgrades.overdrive_duration = { type = 3, levels = {1.2, 1.5, 2.0}, owner = "planet", sprite = "u_p_dur", info = "Длительность режима ярости" }

-- Прогрессия урона от уровня (множитель)
M.level_multiplier = function(level)
	return 1 + (level - 1) * 0.5 -- +50% урона за уровень
end

return M

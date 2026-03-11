-- game_config.lua
local M = {}

M.turret_stats = {
	blaster = { damage = 20, rate = 0.5,range = 70, bullet_speed = 600 },
	pulse = { damage = 8, rate = 0.15,range = 70, bullet_speed = 800 },
	sniper = { damage = 150, rate = 2.5,range = 70, bullet_speed = 1200 },
	rocket = { damage = 80, rate = 1.5,range = 150, bullet_speed = 200 }, -- Тут скорость ниже, т.к. ракета наводится
	laser = { damage = 5, rate = 0.1,range = 70, bullet_speed = 0 },     -- Для лазера скорость не важна
	plasma = { damage = 100, rate = 2.0,range = 70, bullet_speed = 250 },
	tesla = { damage = 45, rate = 1.2,range = 70, bullet_speed = 1000 }
}
-- Прогрессия урона от уровня (множитель)
M.level_multiplier = function(level)
	return 1 + (level - 1) * 0.5 -- +50% урона за уровень
end

return M

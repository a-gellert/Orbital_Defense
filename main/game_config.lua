-- game_config.lua
local M = {}

M.turret_stats = {
	blaster = {
		damage = 10,
		rate = 0.4,          -- Секунды между выстрелами
		range = 60,         -- Радиус (должен совпадать с триггером на карте)
		bullet_speed = 200,
		turn_speed = 10.0,
		color = {0.2, 0.6, 1, 1}, -- Синий
		max_level = 5
	},
	sniper = {
		damage = 40,
		rate = 1.5,
		range = 60,
		bullet_speed = 300,
		turn_speed = 5.0,
		color = {1, 0.2, 0.2, 1}, -- Красный
		max_level = 5
	}
}

-- Прогрессия урона от уровня (множитель)
M.level_multiplier = function(level)
	return 1 + (level - 1) * 0.5 -- +50% урона за уровень
end

return M

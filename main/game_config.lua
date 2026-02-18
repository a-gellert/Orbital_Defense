local M = {}

M.turret_stats = {
	blaster = {
		damage = 10,
		rate = 0.5,      -- Скорострельность (сек)
		range = 50,     -- Радиус обнаружения
		bullet_speed = 60,
		turn_speed = 5.0 -- Скорость поворота башни
	},
	sniper = { -- Пример расширяемости
		damage = 50,
		rate = 2.0,
		range = 50,
		bullet_speed = 100,
		turn_speed = 2.0
	}
}

return M
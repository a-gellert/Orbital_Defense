local M = {}

M.turret_stats = {
	blaster = {
		damage = 10,
		rate = 0.5,      -- Скорострельность (сек)
		range = 200,     -- Радиус обнаружения
		bullet_speed = 600,
		turn_speed = 5.0 -- Скорость поворота башни
	},
	sniper = { -- Пример расширяемости
		damage = 50,
		rate = 2.0,
		range = 400,
		bullet_speed = 1000,
		turn_speed = 2.0
	}	
}

return M
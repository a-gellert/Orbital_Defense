local M = {}

M.data = {
	gold = 1000, -- Дадим немного денег на старт для теста
	diamonds = 0,

	-- Состояние турелей
	turrets = {
		blaster = { unlocked = true, level_dmg = 1, level_rate = 1, price = 100 },
		sniper  = { unlocked = false, level_dmg = 1, level_rate = 1, price = 500 },
		rocket  = { unlocked = false, level_dmg = 1, level_rate = 1, price = 2500 },
		laser   = { unlocked = false, level_dmg = 1, level_rate = 1, price = 10000 },
		plasma  = { unlocked = false, level_dmg = 1, level_rate = 1, price = 50000 },
		laser2   = { unlocked = false, level_dmg = 1, level_rate = 1, price = 10000 },
		plasma2  = { unlocked = false, level_dmg = 1, level_rate = 1, price = 50000 },
	},

	-- Орбиты (Этого блока не хватало!)
	orbits = {
		count = 1,
		level_speed = 1,
	},

	-- Планета и Экономика
	economy = {
		level_gpk = 1,     
		level_hp = 1,      -- Уровень здоровья планеты
		gold_per_kill = 10,
		passive_income = 0,
		planet_hp = 100,
		planet_dmg = 10
	}
}

-- Формула сокращения чисел
function M.format_num(n)
	if not n then return "0" end
	if n >= 10^9 then return string.format("%.2fB", n/10^9) end
	if n >= 10^6 then return string.format("%.2fM", n/10^6) end
	if n >= 10^3 then return string.format("%.1fK", n/10^3) end
	return tostring(math.floor(n))
end

return M
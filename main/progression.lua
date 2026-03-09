local M = {}

M.data = {
	gold = 100, -- Дадим немного денег на старт для теста
	diamonds = 0,
	is_paused =true,
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
	orbits_data = {
		or1 = { id = hash("/orbit_1"), radius = 75,  speed = 1.5, slots = 4,  price = 0,     unlocked = true },
		or2 = { id = hash("/orbit_2"), radius = 105, speed = 1,   slots = 6,  price = 1000,  unlocked = false },
		or3 = { id = hash("/orbit_3"), radius = 135, speed = 0.8, slots = 10, price = 5000,  unlocked = false },
		or4 = { id = hash("/orbit_4"), radius = 165, speed = 0.6, slots = 16, price = 15000, unlocked = false },
		or5 = { id = hash("/orbit_5"), radius = 195, speed = 0.4, slots = 24, price = 50000, unlocked = false },
		or6 = { id = hash("/orbit_6"), radius = 225, speed = 0.2, slots = 32, price = 150000,unlocked = false }
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
function M.reset_progress()
	M.data.gold = 100 -- Начальная сумма
	M.data.economy.planet_hp = 100
	M.is_paused = false
	-- Сброс турелей (оставляем только бластер)
	for id, turret in pairs(M.data.turrets) do
		turret.owned = (id == "blaster")
		turret.level_dmg = 1
		turret.level_rate = 1
	end

	-- Сброс орбит (оставляем только первую)
	for id, orbit in pairs(M.data.orbits_data) do
		orbit.unlocked = (id == "or1")
	end

	print("🧹 Прогресс сброшен")
end
M.is_paused = true
-- Формула сокращения чисел
function M.format_num(n)
	if not n then return "0" end
	if n >= 10^9 then return string.format("%.2fB", n/10^9) end
	if n >= 10^6 then return string.format("%.2fM", n/10^6) end
	if n >= 10^3 then return string.format("%.1fK", n/10^3) end
	return tostring(math.floor(n))
end

return M
local config = require "main.game_config"

local M = {}
M.data = {
	gold = 100, -- Дадим немного денег на старт для теста
	diamonds = 0,
	is_paused =true,
	has_free_slot = true,
	click_state = 0,
	-- Состояние турелей

	turrets = {
		blaster = { unlocked = true, level_dmg = 1, level_rate = 1, price = 100 },
		pulse  = { unlocked = false, level_dmg = 1, level_rate = 1, price = 500 },
		rocket  = { unlocked = false, level_dmg = 1, level_rate = 1, price = 2500 },
		laser   = { unlocked = false, level_dmg = 1, level_rate = 1, price = 10000 },
		plasma  = { unlocked = false, level_dmg = 1, level_rate = 1, price = 50000 },
		tesla   = { unlocked = false, level_dmg = 1, level_rate = 1, price = 150000 }
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
	active_upgrades = {},
	rarity_colors = {},
	-- Планета и Экономика

	economy = {
		level_gpk = 1,     
		level_hp = 1,      -- Уровень здоровья планеты
		gold_per_kill = 10,
		passive_income = 0,
		planet_hp = 100,
		planet_dmg = 10,
		planet_damage_radius = 200
	}

}
M.data.active_upgrades = {}
M.rarity_colors = {
	[1] = vmath.vector4(0.8, 0.8, 0.8, 1), -- Обычный (Серый)
	[2] = vmath.vector4(0.2, 0.8, 0.2, 1), -- Элитный (Зеленый)
	[3] = vmath.vector4(0.2, 0.5, 1, 1),   -- Редкий (Синий)
	[4] = vmath.vector4(0.8, 0.2, 0.8, 1), -- Эпический (Фиолетовый)
}
-- В progression.lua или отдельном модуле logic.lua
function M.get_random_upgrades(count)
	local pool = {}
	local upgrades = config.upgrades

	-- Создаем "веса" для редкости (чем выше тип, тем меньше шансов)
	-- Type 1: вес 60, Type 2: 25, Type 3: 10, Type 4: 5
	local weights = { [1] = 60, [2] = 25, [3] = 10, [4] = 5 }

	local result = {}
	local keys = {}
	for k, _ in pairs(upgrades) do table.insert(keys, k) end

	while #result < count do
		local key = keys[math.random(#keys)]
		local upgrade = upgrades[key]

		-- Простая проверка шанса
		if math.random(1, 100) <= weights[upgrade.type] then
			-- Проверяем, не выбрали ли мы уже эту карту и не макс. ли она уровня
			local current_lvl = M.data.active_upgrades[key] or 0
			if current_lvl < #upgrade.levels then
				table.insert(result, { id = key, data = upgrade })
			end
		end
	end
	return result
end

function M.reset_progress()
	M.data.gold = 100 -- Начальная сумма
	M.data.economy.planet_hp = 100
	M.is_paused = false
	M.has_free_slot = true
	M.data.active_upgrades = {}
	-- Сброс орбит (оставляем только первую)

	for id, orbit in pairs(M.data.orbits_data) do
		orbit.unlocked = (id == "or1")
	end
	print("🧹 Прогресс сброшен")
end

M.has_free_slot = true

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
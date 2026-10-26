local M = {}
-- Кривая сложности. Цель: 5+ минут даже у игрока, который почти не пользуется магазином,
-- и 12-20 минут у активного игрока. Раньше каждая 5-я волна удваивала HP ВСЕХ врагов
-- (а 10-я - учетверяла), и большинство забегов обрывалось на 5-й волне (~2 мин).

-- Орда: врагов много, но каждый слабый. Плотность дает "сочность" и давление с первой волны,
-- сплеш и тапы по толпе ощущаются мощно.
M.hp_scale = 0.5        -- общий множитель HP рядовых врагов
M.reward_scale = 0.38   -- врагов ~2.5x больше, поэтому золото за каждого меньше
M.hp_growth = 1.17      -- рост HP врагов за волну
M.late_wave = 10        -- с этой волны включается дополнительный рост (стена для сильных билдов)
M.late_ramp = 0.6       -- +60% HP за каждую волну после late_wave
M.reward_growth = 1.08  -- рост награды за убийство
M.max_alive = 120       -- предохранитель производительности: больше врагов одновременно не спавним

M.boss_every = 5
M.boss_reward_mult = 5  -- босс дает золото за 5 обычных врагов
M.boss_contact_mult = 3 -- урон планете, если босс долетел

function M.get_hp_multiplier(wave)
	local late = 1 + math.max(0, wave - M.late_wave) * M.late_ramp
	return math.pow(M.hp_growth, wave - 1) * late * M.hp_scale
end

function M.get_reward_multiplier(wave)
	return math.pow(M.reward_growth, wave - 1) * M.reward_scale
end

-- Урон врагов по планете растет медленно, чтобы прокачка HP/реген не обнуляла угрозу
function M.get_damage_multiplier(wave)
	return 1 + (wave - 1) * 0.04
end

-- Отталкивание от попаданий слабеет с волнами, иначе толпа турелей "запирает" врагов навсегда
function M.get_knockback_multiplier(wave)
	return math.max(0.3, 1 - (wave - 1) * 0.04)
end

function M.is_boss_wave(wave)
	return wave % M.boss_every == 0
end

-- Множитель HP босса относительно обычного врага этой волны (с учетом hp_scale босс прежней силы)
function M.get_boss_hp_multiplier(wave)
	return wave >= 10 and 18 or 12
end

function M.get_wave_duration(wave)
	return math.min(40, 18 + 1.5 * wave)
end

function M.get_spawn_interval(wave)
	local interval = math.max(0.25, 0.85 * math.pow(0.955, wave - 1))
	-- На волне с боссом обычных врагов чуть меньше
	if M.is_boss_wave(wave) then
		interval = interval * 1.25
	end
	return interval
end

-- Свармеры прилетают стаями, и стаи растут с волнами
function M.get_pack_size(wave)
	return math.random(3, 5 + math.floor(wave / 4))
end

return M

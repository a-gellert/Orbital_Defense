local M = {}

M.base_hp = 10
M.base_reward = 5
M.hp_growth = 1.15
M.reward_growth = 1.1

function M.get_enemy_stats(wave)
	local hp = M.base_hp * math.pow(M.hp_growth, wave - 1)
	local reward = M.base_reward * math.pow(M.reward_growth, wave - 1)

	-- Каждый 10-й уровень — Босс
	if wave % 10 == 0 then
		hp = hp * 8
		reward = reward * 5
	end

	return hp, reward
end

return M
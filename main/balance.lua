local M = {}
--характеристики врагов
M.base_hp = 10
M.base_reward = 10
M.hp_growth = 1.08  -- Smooth growth for 5-10+ min survival
M.reward_growth = 1.12 -- Generous gold scaling for steady purchases

function M.get_enemy_stats(wave)
	local hp = M.base_hp * math.pow(M.hp_growth, wave - 1)
	local reward = M.base_reward * math.pow(M.reward_growth, wave - 1)

	-- Wave 5 Mini-Boss (challenging but beatable), Wave 10 Mega-Boss
	if wave % 10 == 0 then
		hp = hp * 4.0
		reward = reward * 4.0
	elseif wave % 5 == 0 then
		hp = hp * 2.0
		reward = reward * 2.5
	end

	return hp, reward
end

return M
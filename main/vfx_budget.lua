-- vfx_budget.lua
-- Лимиты на одновременно живые декоративные объекты. В орде каждое попадание и каждый
-- быстрый враг порождают объекты; без лимита их число растет с количеством турелей.
local M = {}

M.limits = {
	damage_label = 60, -- всплывающие цифры урона
	trail = 80         -- шлейфы-призраки быстрых врагов и боссов
}

local alive = {}

-- true, если объект можно создать (место занято до release)
function M.acquire(kind)
	local n = alive[kind] or 0
	if n >= (M.limits[kind] or math.huge) then
		return false
	end
	alive[kind] = n + 1
	return true
end

function M.release(kind)
	alive[kind] = math.max(0, (alive[kind] or 0) - 1)
end

-- При перезапуске коллекции объекты удаляются без release
function M.reset()
	alive = {}
end

return M

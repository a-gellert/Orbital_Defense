-- enemy_registry.lua
-- Единый реестр живых врагов с кэшем позиций.
-- Враги сами пишут сюда свою позицию раз в кадр. Турели, планета и снаряды ищут цели здесь,
-- на чистом Lua, вместо go.exists() + go.get_world_position() по каждому врагу.
-- Позиции мировые: враги не имеют родителя.
local M = {}

local xs = {}
local ys = {}
local count = 0

function M.add(id, pos)
	if not xs[id] then
		count = count + 1
	end
	xs[id] = pos.x
	ys[id] = pos.y
end

function M.remove(id)
	if xs[id] then
		count = count - 1
		xs[id] = nil
		ys[id] = nil
	end
end

function M.set_pos(id, pos)
	if xs[id] then
		xs[id] = pos.x
		ys[id] = pos.y
	end
end

function M.has(id)
	return id ~= nil and xs[id] ~= nil
end

-- Возвращает x, y (или nil, если врага уже нет)
function M.get_pos(id)
	if id == nil then return nil end
	return xs[id], ys[id]
end

function M.count()
	return count
end

function M.clear()
	for id in pairs(xs) do
		xs[id] = nil
		ys[id] = nil
	end
	count = 0
end

-- Ближайший враг к точке (x, y) в радиусе range
function M.find_closest(x, y, range, exclude)
	local best = nil
	local best_d2 = range * range
	for id, ex in pairs(xs) do
		if id ~= exclude then
			local dx = ex - x
			local dy = ys[id] - y
			local d2 = dx * dx + dy * dy
			if d2 < best_d2 then
				best = id
				best_d2 = d2
			end
		end
	end
	return best
end

-- Список врагов в радиусе. max ограничивает количество (например, звенья цепной молнии)
function M.query_radius(x, y, radius, exclude, max)
	local result = {}
	local r2 = radius * radius
	local n = 0
	for id, ex in pairs(xs) do
		if id ~= exclude then
			local dx = ex - x
			local dy = ys[id] - y
			if dx * dx + dy * dy <= r2 then
				n = n + 1
				result[n] = id
				if max and n >= max then break end
			end
		end
	end
	return result
end

-- Снимок всех врагов (для массовых эффектов: EMP, гравитация)
function M.all()
	local result = {}
	local n = 0
	for id in pairs(xs) do
		n = n + 1
		result[n] = id
	end
	return result
end

return M

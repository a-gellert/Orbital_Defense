local M = {}

-- Проверяем, существует ли нативное расширение (доступно только в HTML5)
local has_sdk = (poki_sdk ~= nil)
local is_gameplay = false

-- Внутренняя функция для логирования
local function log(message)
	print("[POKI WRAPPER]: " .. message)
end

function M.init()
	-- В расширении Defold PokiSDK.init() вызывается автоматически в index.html
	log("Poki SDK is auto-initialized by Defold HTML5 template")
end

function M.gameplay_start()
	if is_gameplay then return end
	is_gameplay = true
	if has_sdk then
		poki_sdk.gameplay_start()
	else
		log("Mock Gameplay Start")
	end
end

function M.gameplay_stop()
	if not is_gameplay then return end
	is_gameplay = false
	if has_sdk then
		poki_sdk.gameplay_stop()
	else
		log("Mock Gameplay Stop")
	end
end

-- Реклама за вознаграждение
-- callback() выполнится, если игрок успешно досмотрел рекламу
function M.rewarded_break(callback)
	if has_sdk then
		poki_sdk.rewarded_break(function(self, success)
			local ok = (success == true or success == 1 or success == poki_sdk.REWARDED_BREAK_SUCCESS)
			if ok and callback then
				callback()
			end
		end)
	else
		log("Mock Rewarded Break (Giving reward)")
		if callback then callback() end
	end
end

-- Обычная реклама между забегами / при рестарте
function M.commercial_break(callback)
	if has_sdk then
		if is_gameplay then
			M.gameplay_stop()
		end
		poki_sdk.commercial_break(function(...)
			if callback then callback() end
		end)
	else
		log("Mock Commercial Break")
		if callback then callback() end
	end
end

return M
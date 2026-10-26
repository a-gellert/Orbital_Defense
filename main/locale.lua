local M = {}

M.current_lang = "en"

M.strings = {
	en = {
		-- Header & HUD
		wave = "WAVE %d",
		boss_wave = "BOSS WAVE %d",
		overdrive = "OVERDRIVE",
		tutorial_shoot = "TAP ANYWHERE TO SHOOT",
		tutorial_shop = "<< BUY MORE TURRETS",
		tutorial_upgrades = "<< SLOTS FULL? OPEN UPGRADES",
		revive = "2ND CHANCE",
		hp_shield = "HP %d/%d | SHIELD %d",
		hp_only = "HP %d/%d",
		upgrades = "UPGRADES",
		orbits = "ORBITS",
		turrets = "TURRETS",
		planet = "PLANET",
		restart = "RESTART",
		defeat = "DEFEAT",
		best_wave = "BEST: %d",
		run_gold = "EARNED: %s",
		vault_total = "VAULT: %s",

		-- Shop & Upgrades
		unlock_orbit = "ORBIT %s",
		repair_hp = "REPAIR +%d",
		hp_full = "HP FULL",
		all_orbits = "ALL ORBITS UNLOCKED",
		core_dmg = "CORE DMG +4 (L%d)",
		max_shield = "MAX SHIELD +15 (L%d)",
		max_hp = "MAX HP +35 (L%d)",
		gold_kill = "GOLD +3 (L%d)",
		radar = "RADAR +15 (L%d)",
		perma_hp = "[*] PERMA HP (L%d)",
		perma_dmg = "[*] PERMA DMG (L%d)",
		perma_regen = "[*] REGEN (L%d)",
		perma_gold = "[*] START GOLD (L%d)",
		turret_dmg = "%s DMG (L%d)",

		-- Perks
		perk_fire_rate = "+ATK SPEED",
		perk_prj_speed = "+BULLET SPD",
		perk_multishot = "MULTISHOT",
		perk_splash = "ROCKET SPLASH",
		perk_chain = "TESLA CHAIN",
		perk_pierce = "PIERCING SHOT",
		perk_gold = "+GOLD / KILL",
		perk_lucky = "LUCKY DROP",
		perk_orbit = "+ORBIT SLOT",
		perk_hp = "+MAX HP",
		perk_regen = "+HP REGEN",
		perk_overdrive_charge = "+RAGE CHARGE",
		perk_overdrive_dur = "+RAGE TIME",
		perk_cryo_rounds = "CRYO SLOW 40%",
		perk_chain_reaction = "CORPSE EXPLODE",
		perk_singularity = "GRAVITY VORTEX",

		-- Events & Quests
		event_gold = "+%d GOLD!",
		event_shield = "+%d SHIELD!",
		event_hyper = "HYPER-FIRE (6s)!",
		quest_complete = "QUEST COMPLETE! +%d V",
		emp_ready = "EMP",
		emp_cd = "EMP %ds",
		boss_countdown = "BOSS IN %d WAVES",
		boss_approaching = "WARNING: BOSS APPROACHING!"
	}
}

function M.t(key, ...)
	local lang_table = M.strings[M.current_lang] or M.strings.en
	local str = lang_table[key] or M.strings.en[key] or key
	if ... then
		local ok, formatted = pcall(string.format, str, ...)
		if ok then return formatted end
	end
	return str
end

return M

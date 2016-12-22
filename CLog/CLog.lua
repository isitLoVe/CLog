local msdiff = 0

local function onCLEvent()
	truems = string.sub(string.format("%03d", 1000 + string.sub(string.format("%.3f", GetTime()),-3) - msdiff),-3)
	if event == "ADDON_LOADED" and arg1 == "CLog" then
		DEFAULT_CHAT_FRAME:AddMessage("CLog loaded. \"/clog\" to start\/stop recording. \"/clog clear\" to erase the log file.", 1, 1, 0);
		GetTrueMS()
		if not CLogEvents then
			CLogEvents = {}	
		end
		if not CLogSettingsChar then
			CLogSettingsChar = 0
		end
		if CLogSettingsChar == 1 then
			CLog_Register();
			CLog_State = true;
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		if CLog_State then
			if getn(CLogEvents) == 0 then
				CLogEvents[1] = date().."."..truems.." You enter combat. "..event
			else
				CLogEvents[getn(CLogEvents)+1] = date().."."..truems.." You enter combat. "..event
			end
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if CLog_State then
			if getn(CLogEvents) == 0 then
				CLogEvents[1] = date().."."..truems.." You exit combat. "..event
			else
				CLogEvents[getn(CLogEvents)+1] = date().."."..truems.." You exit combat. "..event
			end
		end
	elseif event == "CHAT_MSG_MONSTER_SAY" then
		if CLog_State then
			if getn(CLogEvents) == 0 then
				CLogEvents[1] = date().."."..truems.." "..arg2 .." says: "..arg1.." "..event
			else
				CLogEvents[getn(CLogEvents)+1] = date().."."..truems.." "..arg2 .." says: "..arg1.." "..event
			end
		end
	elseif event == "CHAT_MSG_MONSTER_YELL" then
		if CLog_State then
			if getn(CLogEvents) == 0 then
				CLogEvents[1] = date().."."..truems.." "..arg2 .." yells: "..arg1.." "..event
			else
				CLogEvents[getn(CLogEvents)+1] = date().."."..truems.." "..arg2 .." yells: "..arg1.." "..event
			end
		end
	elseif event == "CHAT_MSG_MONSTER_EMOTE" then
		if CLog_State then
			if getn(CLogEvents) == 0 then
				CLogEvents[1] = date().."."..truems.." "..string.gsub(arg1, "%%s", arg2).." "..event
			else
				CLogEvents[getn(CLogEvents)+1] = date().."."..truems.." "..string.gsub(arg1, "%%s", arg2).." "..event
			end
		end
	elseif event == "CHAT_MSG_RAID_BOSS_EMOTE" then
		if CLog_State then
			if getn(CLogEvents) == 0 then
				if arg2 then
					CLogEvents[1] = date().."."..truems.." "..string.gsub(arg1, "%%s", arg2).." "..event
				else
					CLogEvents[1] = date().."."..truems.." "..arg1.." "..event
				end
			else
				if arg2 then
					CLogEvents[getn(CLogEvents)+1] = date().."."..truems.." "..string.gsub(arg1, "%%s", arg2).." "..event
				else
					CLogEvents[1] = date().."."..truems.." "..arg1.." "..event
				end
			end
		end
	elseif (event ~= "ADDON_LOADED" and arg1) then
		if CLog_State then
			if getn(CLogEvents) == 0 then
				CLogEvents[1] =  date().."."..truems.." "..arg1.." "..event
			else
				CLogEvents[getn(CLogEvents)+1] = date().."."..truems.." "..arg1.." "..event
			end
		end
	end	
end

function GetTrueMS()
	local comparetothis = date("%S")
	while 0 == 0 do
		if date("%S") ~= comparetothis then
			msdiff = string.sub(string.format("%.3f", GetTime()),-3)
			break
		end
	end
end

local CLogFrame = CreateFrame("frame")
	CLogFrame:RegisterEvent("ADDON_LOADED")
	CLogFrame:RegisterEvent("VARIABLES_LOADED")
	CLogFrame:SetScript("OnEvent", onCLEvent)

SLASH_CLOG1 = "/clog"
function SlashCmdList.CLOG(var)
	if var == "" then
		if not CLog_State then
			CLog_State = true;
			CLogSettingsChar = 1;
			CLog_Register();
			if getn(CLogEvents) ~= 0 and CLogEvents[getn(CLogEvents)] ~= "" then
				CLogEvents[getn(CLogEvents)+1] = ""
			end
			DEFAULT_CHAT_FRAME:AddMessage("Combat Log recording to \\WTF\\Account\\ACCOUNTNAME\\SavedVariables\\CLog.lua", 1, 1, 0);
		else
			CLog_State = false;
			CLog_Unregister();
			CLogSettingsChar = 0;
			DEFAULT_CHAT_FRAME:AddMessage("Combat Log recording stopped.", 1, 1, 0);
		end
	elseif var == "clear" then
		CLogEvents = {}
		DEFAULT_CHAT_FRAME:AddMessage("Combat Log has been cleared.", 1, 1, 0);
	else
		Print("\"\/clog\" or \"\/clog clear\"")
	end
end

function CLog_Register()
	CLogFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
	CLogFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
	CLogFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE");
	CLogFrame:RegisterEvent("CHAT_MSG_MONSTER_SAY");
	CLogFrame:RegisterEvent("CHAT_MSG_MONSTER_YELL");
	CLogFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_MISC_INFO");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_PET_HITS");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_PET_MISSES");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_PARTY_HITS");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_PARTY_MISSES");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PET_BUFF");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_TRADESKILLS");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_ITEM_ENCHANTMENTS");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_BREAK_AURA");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS");
	CLogFrame:RegisterEvent("CHAT_MSG_SPELL_FAILED_LOCALPLAYER");
	CLogFrame:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE");
end

function CLog_Unregister()
	CLogFrame:UnregisterEvent("PLAYER_REGEN_ENABLED");
	CLogFrame:UnregisterEvent("PLAYER_REGEN_DISABLED");
	CLogFrame:UnregisterEvent("CHAT_MSG_MONSTER_EMOTE");
	CLogFrame:UnregisterEvent("CHAT_MSG_MONSTER_SAY");
	CLogFrame:UnregisterEvent("CHAT_MSG_MONSTER_YELL");
	CLogFrame:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_MISC_INFO");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_PET_HITS");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_PET_MISSES");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_PARTY_HITS");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_PARTY_MISSES");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PET_BUFF");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PARTY_BUFF");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_TRADESKILLS");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_ITEM_ENCHANTMENTS");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_BREAK_AURA");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS");
	CLogFrame:UnregisterEvent("CHAT_MSG_SPELL_FAILED_LOCALPLAYER");
	CLogFrame:UnregisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE");
end

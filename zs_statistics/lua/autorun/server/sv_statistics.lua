//ZS Statistics by mka0207.

AddCSLuaFile( 'autorun/client/cl_statistics.lua' )
AddCSLuaFile( 'vgui/pstats_zs.lua' )
AddCSLuaFile( 'vgui/dexroundedframe.lua' )
AddCSLuaFile( 'vgui/dexroundedpanel.lua' )

print("Loaded ZS Statistics by mka0207")

resource.AddFile( "materials/icon16/stat_human.png" )
resource.AddFile( "materials/icon16/stat_human_selection.png" )
resource.AddFile( "materials/icon16/stat_zombie.png" )
resource.AddFile( "materials/icon16/stat_zombie_selection.png" )

local function LoadStatistics( pl, steamid, uniqueid )
	if !IsValid( pl ) || !pl:IsPlayer() then return end

	pl:SetNWInt( "assistcounter", pl:GetPData( "assistcounter", 0 ) )
	pl:SetNWInt( "humancounter", pl:GetPData( "humancounter", 0 ) )
	pl:SetNWInt( "zombiecounter", pl:GetPData( "zombiecounter", 0 ) )
	pl:SetNWInt( "headshotcounter", pl:GetPData( "headshotcounter", 0 ) )
	pl:SetNWInt( "zombiedeaths", pl:GetPData( "zombiedeaths", 0 ) )
	pl:SetNWInt( "humandeaths", pl:GetPData( "humandeaths", 0 ) )
	pl:SetNWInt( "humanwins", pl:GetPData( "humanwins", 0 ) )
	pl:SetNWInt( "zombiewins", pl:GetPData( "zombiewins", 0 ) )
	pl:SetNWInt( "propkills", pl:GetPData( "propkills", 0 ) )
end
hook.Add( 'PlayerAuthed', 'FWKZT.PlayerAuthedStats.TTT', LoadStatistics )

local function SaveStatistics( pl )
	if !IsValid( pl ) || !pl:IsPlayer() then return end

	pl:SetPData( "assistcounter", pl:GetNWInt( "assistcounter" ) )
	pl:SetPData( "humancounter", pl:GetNWInt( "humancounter" ) )
	pl:SetPData( "zombiecounter", pl:GetNWInt( "zombiecounter" ) )
	pl:SetPData( "propkills", pl:GetNWInt( "propkills" ) )
	pl:SetPData( "headshotcounter", pl:GetNWInt( "headshotcounter" ) )
	pl:SetPData( "zombiedeaths", pl:GetNWInt( "zombiedeaths" ) )
	pl:SetPData( "humandeaths", pl:GetNWInt( "humandeaths" ) )	
	pl:SetPData( "humanwins", pl:GetNWInt( "humanwins" ) )
	pl:SetPData( "zombiewins", pl:GetNWInt( "zombiewins" ) )
	
end
hook.Add( 'PlayerDisconnected', 'FWKZT.PlayerDisconnectedStats.TTT', SaveStatistics )

local function ZS_HumanKilledZombie( pl, attacker, inflictor, dmginfo, headshot, suicide )
	if !( IsValid(pl) && IsValid(attacker) ) then return end

	attacker:SetNWInt( "humancounter", attacker:GetNWInt( "humancounter" ) + 1 )
	attacker:SetPData( "humancounter", attacker:GetNWInt( "humancounter" ) )
end	

local function ZS_PostHumanKilledZombie( pl, attacker, inflictor, dmginfo, assistpl, assistamount, headshot )
	if !( IsValid(pl) && IsValid(attacker) ) then return end

	if IsValid( assistpl ) then
		assistpl:SetNWInt( "assistcounter", assistpl:GetNWInt( "assistcounter" ) + 1 )
		assistpl:SetPData( "assistcounter", assistpl:GetNWInt( "assistcounter" ) )
	end	
end	

local function ZS_PostZombieKilledHuman( pl, attacker, inflictor, dmginfo, headshot, suicide )
	if !( IsValid(pl) && IsValid(attacker) ) then return end

	attacker:SetNWInt( "zombiecounter", attacker:GetNWInt( "zombiecounter" ) + 1 )
	attacker:SetPData( "zombiecounter", attacker:GetNWInt( "zombiecounter" ) )
end	

local function ZS_PlayerDeath( pl, inflictor, attacker )
	if !( IsValid(pl) && IsValid(attacker) ) then return end

	if attacker:IsPlayer() && pl:IsPlayer() then
		if pl:Team() == TEAM_HUMAN && attacker:Team() == TEAM_UNDEAD then
			if inflictor:GetClass() == "prop_physics" then
				attacker:SetNWInt( "propkills", attacker:GetNWInt( "propkills" ) + 1 )	
				attacker:SetPData( "propkills", attacker:GetNWInt( "propkills" ) )
			end
		end
	end
end	

local function ZS_DoPlayerDeath( pl, attacker, dmginfo)
	if !( IsValid(pl) && IsValid(attacker) ) then return end

	local headshot = pl:LastHitGroup() == HITGROUP_HEAD
	local myteam = pl:Team()
	
	if headshot then
		attacker:SetNWInt( "headshotcounter", attacker:GetNWInt( "headshotcounter" ) + 1 )
		attacker:SetPData( "headshotcounter", attacker:GetNWInt( "headshotcounter" ) )
	end
	
	if myteam == TEAM_UNDEAD then
		pl:SetNWInt( "zombiedeaths", pl:GetNWInt( "zombiedeaths" ) + 1 )	
		pl:SetPData( "zombiedeaths", pl:GetNWInt( "zombiedeaths" ) )
	elseif myteam == TEAM_HUMAN then	
		pl:SetNWInt( "humandeaths", pl:GetNWInt( "humandeaths" ) + 1 )	
		pl:SetPData( "humandeaths", pl:GetNWInt( "humandeaths" ) )
	end	
end

local function ZS_EndRound( winner )
	for _, pl in pairs( player.GetAll() ) do
		if !IsValid(pl) then continue end
	
		if winner == TEAM_HUMAN then
			if pl:Team() == TEAM_HUMAN then
				pl:SetNWInt( "humanwins", pl:GetNWInt( "humanwins" ) + 1 )
				pl:SetPData( "humanwins", pl:GetNWInt( "humanwins" ) )
			end
		elseif winner == TEAM_UNDEAD then
			if pl:Team() == TEAM_UNDEAD then
				pl:SetNWInt( "zombiewins", pl:GetNWInt( "zombiewins" ) + 1 )
				pl:SetPData( "zombiewins", pl:GetNWInt( "zombiewins" ) )
			end
		end
	end		
end

local function ZS_Command( pl, text, teamchat )
	if ! IsValid(pl) then return end
	
	if ( text == "!stats" ) then
		pl:SendLua( "MakepSelectionZS()" )
		for k, v in pairs(player.GetAll()) do v:ChatPrint( "" .. pl:Nick() .. " is checking out ZS Statistics! (Type !stats)" ) end
	end
	return
end	

local function AddHooks()
	if GAMEMODE_NAME == 'zombiesurvival' then
		hook.Add( 'PlayerSay', 'FWKZT.ChatCommandStats.ZS', ZS_Command )
		hook.Add( 'EndRound', 'FWKZT.EndRoundStats.ZS', ZS_EndRound )
		hook.Add( 'DoPlayerDeath', 'FWKZT.DoPlayerDeathStats.ZS', ZS_DoPlayerDeath )
		hook.Add( 'PlayerDeath', 'FWKZT.PlayerDeathStats.ZS', ZS_PlayerDeath )
		hook.Add( 'PostZombieKilledHuman', 'FWKZT.PostZombieKilledHumanStats.ZS', ZS_PostZombieKilledHuman )
		hook.Add( 'PostHumanKilledZombie', 'FWKZT.PostHumanKilledZombieStats.ZS', ZS_PostHumanKilledZombie )
		hook.Add( 'HumanKilledZombie', 'FWKZT.HumanKilledZombieStats.ZS', ZS_HumanKilledZombie )
	end
end
hook.Add( "Initialize", "FWKZT.Statistics.AddHooks", AddHooks )
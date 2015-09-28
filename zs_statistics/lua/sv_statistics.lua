--[[MKA0207 SCRIPT LICENSE


VERSION 1.0 , 9 August 2015


Copyright © 2015 Scott (Mka0207) Grissinger


Anyone is allowed to copy, upload, or distribute copies of this license, but changing it is not allowed.


The precise terms and conditions for copying, distribution and modification follow.

TERMS AND CONDITIONS


0. Definitions



"License" refers to this file. The version at <https://www.dropbox.com/s/3zaim0sc78l8qs9/license.txt> is always correct and up-to-date.



"Author" refers to the person Scott "Mka0207" Grissinger <g4.tyler@yahoo.com> 



"Content" refers to all files and folders that the license came with as well as the intellectual property and all derivative works.



"Copyright" refers to the laws on intellectual property and the legal rights automatically granted to the Author during the creation of the Content.



"Modify" refers to editing the Content as well as creating programs or code which depends on the Content to run. For the purpose of this license, deleting things without deleting the entire Content is ALSO considered editing.



1. For any conditions not outlined in the License, refer to your country or state laws for Copyright.

2. You may NOT freely copy, distribute, create derivative works and distribute derivative works of the Content.

[do NOT to make edits.]

3. You will not Modify the Content in such a way that it will, directly or indirectly, generate revenue without explicit, written permission from the Author.

[For example: Sell my work to some poor sap who doesn't know any better.]

4. You will not deny access to the Author to anything in such a way that it would not allow the Author to see if the Addon/Script was Modified.

[For example: banning my Steam groups from your server.]

5. You will not host, distribute, Modify, or otherwise copy the Content if you are affiliated with Void Resonance Survival <steamcommunity.com/groups/voidresonance> or HeLLsGamers <hellsgamers.com>.

6. If you do not agree to any of the above conditions you must delete the Content in its entirety as well as all copies of the Content and derivative works of the Content that you have made.



END TERMS AND CONDITIONS]]--


AddCSLuaFile("vgui/pstats.lua")

--Please don't edit any of this.

concommand.Add( "zs_reset_stats", function( pl )

	pl:SetNWInt( "assistcounter", 0 )
	pl:SetNWInt( "humancounter", 0 )
	pl:SetNWInt( "zombiecounter", 0 )
	
	pl:SetNWInt( "headshotcounter", 0 )
	pl:SetNWInt( "zombiedeaths", 0 )
	pl:SetNWInt( "humandeaths", 0 )
	
	pl:SetNWInt( "humanwins", 0 )
	pl:SetNWInt( "zombiewins", 0 )
	pl:SetNWInt( "propkills", 0 )
	
end )

concommand.Add( "zs_load_stats", function( pl )

	pl:SetNWInt( "assistcounter", pl:GetPData( "assistcounter", 0 ) )
	pl:SetNWInt( "humancounter", pl:GetPData( "humancounter", 0 ) )
	pl:SetNWInt( "zombiecounter", pl:GetPData( "zombiecounter", 0 ) )
	
	pl:SetNWInt( "headshotcounter", pl:GetPData( "headshotcounter", 0 ) )
	pl:SetNWInt( "zombiedeaths", pl:GetPData( "zombiedeaths", 0 ) )
	pl:SetNWInt( "humandeaths", pl:GetPData( "humandeaths", 0 ) )
	
	pl:SetNWInt( "humanwins", pl:GetPData( "humanwins", 0 ) )
	pl:SetNWInt( "zombiewins", pl:GetPData( "zombiewins", 0 ) )
	pl:SetNWInt( "propkills", pl:GetPData( "propkills", 0 ) )
	
end )

local function SaveStatistics(pl)

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

local function LoadStatistics(pl)

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

hook.Add( "PlayerAuthed", "PlyAthed", function( pl, steamid, uniqueid )

	LoadStatistics(pl)

end)

hook.Add( "PlayerDisconnected", "PlyDiscon", function( pl )

	SaveStatistics(pl)

end)

hook.Add( "HumanKilledZombie", "HumanKillZ", function( pl, attacker, inflictor, dmginfo, headshot, suicide ) 
	if (pl:GetZombieClassTable().Points or 0) == 0 or GAMEMODE.RoundEnded then return end

	local totaldamage = 0
	for otherpl, dmg in pairs(pl.DamagedBy) do
		if otherpl:IsValid() and otherpl:Team() == TEAM_HUMAN then
			totaldamage = totaldamage + dmg
		end
	end

	local mostassistdamage = 0
	local halftotaldamage = totaldamage / 2
	local mostdamager
	for otherpl, dmg in pairs(pl.DamagedBy) do
		if otherpl ~= attacker and otherpl:IsValid() and otherpl:Team() == TEAM_HUMAN and dmg > mostassistdamage and dmg >= halftotaldamage then
			mostassistdamage = dmg
			mostdamager = otherpl
		end
	end
		
	if mostdamager then

		mostdamager:SetNWInt( "assistcounter", mostdamager:GetNWInt( "assistcounter" ) + 1 )
		SaveStatistics(mostdamager)
	
	else
		--do nothing
	end

	attacker:SetNWInt("humancounter", attacker:GetNWInt( "humancounter" ) + 1 )
	SaveStatistics(attacker)
	
	gamemode.Call("PostHumanKilledZombie", pl, attacker, inflictor, dmginfo, mostdamager, mostassistdamage, headshot)
	
	return mostdamager

end)

hook.Add( "ZombieKilledHuman", "ZombieKillH", function( pl, attacker, inflictor, dmginfo, headshot, suicide )

	attacker:SetNWInt( "zombiecounter", attacker:GetNWInt( "zombiecounter" ) + 1 )
	SaveStatistics(attacker)

end)

hook.Add( "PlayerDeath", "PlyDeath", function( pl, inflictor, attacker )


	if attacker:IsValid() and pl:IsValid() and pl:Team() == TEAM_HUMAN then
	
		if attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
		
			if inflictor:GetClass() == "prop_physics" then
			
				attacker:SetNWInt( "propkills", attacker:GetNWInt( "propkills" ) + 1 )
				SaveStatistics(attacker)
				
			end
			
		end
	
	end

end)

hook.Add( "DoPlayerDeath", "DoPlyDeath", function( pl, attacker, dmginfo )

	local headshot = pl:LastHitGroup() == HITGROUP_HEAD
	
	local myteam = pl:Team()

	if headshot then
	
		attacker:SetNWInt( "headshotcounter", attacker:GetNWInt( "headshotcounter" ) + 1 )
		SaveStatistics(attacker)
		
	end
	
	if myteam == TEAM_UNDEAD then
		
		pl:SetNWInt( "zombiedeaths", pl:GetNWInt( "zombiedeaths" ) + 1 )
		
	end
	
	if myteam == TEAM_HUMAN then
		
		pl:SetNWInt( "humandeaths", pl:GetNWInt( "humandeaths" ) + 1 )
		
	end	
	
	SaveStatistics(pl)
	
end)

hook.Add( "EndRound", "EndRnd", function( winner )

	if winner == TEAM_HUMAN then
	
		for _, pl in pairs(player.GetAll(TEAM_HUMAN)) do
			
				pl:SetNWInt( "humanwins", pl:GetNWInt( "humanwins" ) + 1 )
				SaveStatistics(pl)
			
		end
		
	end	
	
	if winner == TEAM_UNDEAD then

		for _, pl in pairs(player.GetAll(TEAM_UNDEAD)) do
			
				pl:SetNWInt( "zombiewins", pl:GetNWInt( "zombiewins" ) + 1 )
				SaveStatistics(pl)
			
		end	
		
	end
	
	
end)

hook.Add( "PlayerSay", "PlySay", function( pl, text, teamchat )

	if ( text == "!stats" ) then
		if not gamemode.Get("zombiesurvival") then
			pl:ChatPrint( "You cannot use this script outside of Zombie Survival!" )
		else
			pl:SendLua( "MakepSelection()" )
			for k, v in pairs(player.GetAll()) do v:ChatPrint( "" .. pl:Nick() .. " is checking out zs statistics! (Type !stats)" ) end
		end
	end
	
	return
	
end)

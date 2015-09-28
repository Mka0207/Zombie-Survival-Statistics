if SERVER then

	AddCSLuaFile()

	AddCSLuaFile('vgui/pstats.lua')

	include('sv_statistics.lua')
	
	resource.AddFile( "materials/icon16/stat_human.png" )
	resource.AddFile( "materials/icon16/stat_human_selection.png" )
	resource.AddFile( "materials/icon16/stat_zombie.png" )
	resource.AddFile( "materials/icon16/stat_zombie_selection.png" )
	
end
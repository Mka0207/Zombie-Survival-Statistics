//ZS Statistics by mka0207.

local COLOR_GRAY = Color(190, 190, 190, 100)
local COLOR_TRANSPARENT = Color(0, 0, 0, 0)
local COLOR_LIMEGREEN = Color(50, 255, 50)
local COLOR_BLACK_ALPHA = Color(0, 0, 0, 180)

local SKIN = {}

function SKIN:PaintPropertySheet(panel, w, h)
	local ActiveTab = panel:GetActiveTab()
	local Offset = 0
	if ActiveTab then Offset = ActiveTab:GetTall() - 8 end

	draw.RoundedBox(8, 0, 0, w, h, COLOR_GRAY)
end

function SKIN:PaintTab(panel, w, h)
	if panel:GetPropertySheet():GetActiveTab() == panel then
		return self:PaintActiveTab(panel, w, h)
	end

	draw.RoundedBox(8, 4, 4, w - 4, h - 4, COLOR_TRANSPARENT)
end

function SKIN:PaintActiveTab(panel, w, h)
	draw.RoundedBox(8, 0, 0, w, h, COLOR_TRANSPARENT)
	
end

derma.DefineSkin("zs_stats", "TEST", SKIN, "Default")

local function StatCenterMouse(self)
	local x, y = self:GetPos()
	local w, h = self:GetSize()
	gui.SetMousePos(x + w * 0.5, y + h * 0.5)
end

local function RefreshList(self) -- called on line 200
	--print( "Refresh Debug!" )

	self.RefreshTime = 5
	self.NextRefresh = self.NextRefresh || 0

	if CurTime() >= self.NextRefresh then
		self.NextRefresh = CurTime() + self.RefreshTime
		self:Refresh()
	end


end

local function DoStatsThink(Window)
	
	if Window and Window:Valid() and Window:IsVisible() then
		local mx, my = gui.MousePos()
		local x, y = Window:GetPos()
		if mx < x - 16 or my < y - 16 or mx > x + Window:GetWide() + 16 or my > y + Window:GetTall() + 16 then
			Window:SetVisible(false)
			surface.PlaySound("npc/dog/dog_idle3.wav")
		end
	end
	
end

function MakepSelectionZS(silent)
	if Window and Window:Valid() then
		Window:MakePopup()
		Window:CenterMouse()
		return
	end

	local wide, tall = 500, 200
	
	local pl = LocalPlayer()
	
	local Window = vgui.Create("DFrame")
	Window.Paint = function()
	
		Derma_DrawBackgroundBlur( Window )
		draw.RoundedBox( 16, 0, 0, Window:GetWide(), Window:GetTall(), COLOR_GRAY )
		
	end
	Window:SetSize( wide, tall )
	Window:Center()
	Window:SetTitle("")
	Window:SetDraggable(true)
	Window.CenterMouse = StatCenterMouse
	
	local Panel = vgui.Create( "DPanel", Window )
	Panel:SetSize( wide - 20, tall - 20 )
	Panel:Center()
	Panel.Paint = function()
	
		draw.RoundedBox( 16, 0, 0, Panel:GetWide(), Panel:GetTall(), COLOR_BLACK_ALPHA )
	
	end
	
	if Window.btnMinim and Window.btnMinim:Valid() then Window.btnMinim:SetVisible(false) end
	if Window.btnMaxim and Window.btnMaxim:Valid() then Window.btnMaxim:SetVisible(false) end
	if Window.btnClose and Window.btnClose:Valid() then Window.btnClose:SetVisible(false) end
	
	local headertext = vgui.Create( "DButton", Window )
	headertext:SetText( "ZS Statistics by Mka0207" )
	headertext:SetFont( "ZSHUDFont" )
	headertext:SetTextColor( COLOR_WHITE )
	headertext:SizeToContents() 
	headertext:SetPos(wide * 0.5 - headertext:GetWide() * 0.5, 25)
	headertext:SetToolTip( "Learn more about Mka0207?" )
	headertext.DoClick = function()
		Window:Remove()
		gui.OpenURL("http://steamcommunity.com/id/mka0207/myworkshopfiles/")
	end
	headertext.Paint = function() end
	
	
	DermaImageButtonPanel = vgui.Create( "DPanel", Window )
	DermaImageButtonPanel:AlignLeft( 125 )
	DermaImageButtonPanel:CenterVertical()
	DermaImageButtonPanel:SetSize( 80, 80 )
	DermaImageButtonPanel.Paint = function()
		DisableClipping( true )
			draw.RoundedBox( 16, -5, -5, 74, 74, COLOR_GRAY )
			draw.RoundedBox( 16, 0, 0, 64, 64, team.GetColor( TEAM_HUMAN ) )
		DisableClipping( false )
	end
	
	--[[local closebutton = vgui.Create( "DImageButton", Panel )
	closebutton:SetImage( "icon16/cancel.png" )	
	closebutton:AlignBottom()
	closebutton:AlignRight()
	closebutton:SizeToContents()
	closebutton:SetToolTip( "Close this window?" )
	closebutton.DoClick = function()
		Window:Remove()
	end]]
	
	
	DermaImageButtonPanel2 = vgui.Create( "DPanel", Window )
	DermaImageButtonPanel2:AlignRight( 125 )
	DermaImageButtonPanel2:CenterVertical()
	DermaImageButtonPanel2:SetSize( 64, 64 )
	DermaImageButtonPanel2.Paint = function()
		DisableClipping( true )
			draw.RoundedBox( 16, -5, -5, 74, 74, COLOR_GRAY )
			draw.RoundedBox( 16, 0, 0, 64, 64, team.GetColor( TEAM_UNDEAD ) )
		DisableClipping( false )
	end
	
	DermaImageButton = vgui.Create( "DImageButton", DermaImageButtonPanel )
	DermaImageButton:SetImage( "icon16/stat_human_selection.png" )	
	DermaImageButton:SetPos( 5, 5 )
	DermaImageButton:SetSize( 54, 54 )
	DermaImageButton:SetToolTip( "Open the Human Statistics?" )
	DermaImageButton.DoClick = function()
		Window:Remove()
		MakepHumanStats()
	end
	
	DermaImageButton2 = vgui.Create( "DImageButton", DermaImageButtonPanel2 )
	DermaImageButton2:SetImage( "icon16/stat_zombie_selection.png" )	
	DermaImageButton2:SetPos( 5, 5 )
	DermaImageButton2:SetSize( 54, 54 )
	DermaImageButton2:SetToolTip( "Open the Zombie Statistics?" )
	DermaImageButton2.DoClick = function()
		Window:Remove()
		MakepZombieStats()
	end
	
	hook.Add("Think", "MakepSelectionZS_Think", function() DoStatsThink(Window) end)
	
	Window:MakePopup()
end

function MakepHumanStats(silent)
	if Window and Window:Valid() then
		Window:MakePopup()
		Window:CenterMouse()
		return
	end

	local wide, tall = 800, 480
	
	local pl = LocalPlayer()

	local Window = vgui.Create("DFrame")
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle("")
	Window:SetDraggable(false)
	Window:SetDeleteOnClose(true)
	Window:SetKeyboardInputEnabled(false)
	Window:SetCursor( "pointer" )
	Window.CenterMouse = StatCenterMouse
		Window.Paint = function()
	
		Derma_DrawBackgroundBlur( Window )
		draw.RoundedBox( 16, 0, 0, Window:GetWide(), Window:GetTall(), COLOR_GRAY )
		
	end	
	
	if Window.btnMinim and Window.btnMinim:Valid() then Window.btnMinim:SetVisible(false) end
	if Window.btnMaxim and Window.btnMaxim:Valid() then Window.btnMaxim:SetVisible(false) end
	if Window.btnClose and Window.btnClose:Valid() then Window.btnClose:SetVisible(false) end
	
	local Panel = vgui.Create( "DPanel", Window )
	Panel:SetSize( wide - 20, tall - 20 )
	Panel:Center()
	Panel.Paint = function()
	
		draw.RoundedBox( 16, 0, 0, Panel:GetWide(), Panel:GetTall(), COLOR_BLACK_ALPHA )
	
	end
	
	local returnbutton = vgui.Create( "DImageButton", Panel )
	returnbutton:SetImage( "icon16/arrow_undo.png" )	
	returnbutton:AlignBottom(10)
	returnbutton:AlignLeft(25)
	returnbutton:SizeToContents()
	returnbutton:SetToolTip( "Return to Statistics Selection?" )
	returnbutton.DoClick = function()
		Window:Remove()
		MakepSelectionZS()
		Window:CenterMouse()
	end
	
		local closebutton = vgui.Create( "DImageButton", Panel )
	closebutton:SetImage( "icon16/cancel.png" )	
	closebutton:AlignBottom(10)
	closebutton:AlignRight(-25)
	closebutton:SizeToContents()
	closebutton:SetToolTip( "Close this window?" )
	closebutton.DoClick = function()
		Window:Remove()
	end

	local propertysheet = vgui.Create( "DPropertySheet", Window )
	propertysheet:StretchToParent( 40, 40, 40, 64 )

	local DermaListView_HUMAN = vgui.Create("DListView")
	DermaListView_HUMAN:SetParent(propertysheet)
	DermaListView_HUMAN:SetPos( 25, 50 )
	DermaListView_HUMAN:SetSize( 600, 625 )
	DermaListView_HUMAN:SetMultiSelect(false)
	DermaListView_HUMAN:AddColumn("Name")
	DermaListView_HUMAN:AddColumn("Total Zombies Killed")
	DermaListView_HUMAN:AddColumn("Total Headshots")
	DermaListView_HUMAN:AddColumn("Total Assists")
	DermaListView_HUMAN:AddColumn("Total Wins")
	DermaListView_HUMAN:AddColumn("Total Deaths")
	DermaListView_HUMAN:SetSortable( true )
	--DermaListView_HUMAN.Think = RefreshList
	
	DermaListView_HUMAN.Paint = 
	function( self )
	
		--self:RefreshList()
		draw.RoundedBox( 16, 1, -5, DermaListView_HUMAN:GetWide() - 4, DermaListView_HUMAN:GetTall(), team.GetColor( TEAM_HUMAN ) )
	end
 
	DermaListView_HUMAN.RefreshList = function(self)
	
		self:Clear()
			
		for k,v in pairs(player.GetAll()) do
			local name = v:Name()
			local zkills = tonumber( v:GetNWInt( "humancounter" ) )
			local headshots = tonumber( v:GetNWInt( "headshotcounter" ) )
			local assists = tonumber( v:GetNWInt( "assistcounter" ) )
			local humanwins = tonumber( v:GetNWInt( "humanwins" ) )
			local humandeaths = tonumber( v:GetNWInt( "humandeaths" ) )

			local line = self:AddLine(name, string.Comma(zkills), string.Comma(headshots), string.Comma(assists), string.Comma(humanwins), string.Comma(humandeaths))
			
			line:SetSortValue( 2, zkills )
			line:SetSortValue( 3, headshots )
			line:SetSortValue( 4, assists )
			line:SetSortValue( 5, humanwins )
			line:SetSortValue( 6, humandeaths )
		end
		
	end
	
	DermaListView_HUMAN.DoDoubleClick = DermaListView_HUMAN.RefreshList

	DermaListView_HUMAN:RefreshList()

	
	propertysheet:AddSheet( "Human Statistics", DermaListView_HUMAN, "icon16/stat_human.png", false, false, "Normal Stats for all Human players." )
	propertysheet:SetSkin( "zs_stats" )
	
	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.5, 0)
	Window:MakePopup()
end

function MakepZombieStats(silent)
	if Window and Window:Valid() then
		Window:MakePopup()
		Window:CenterMouse()
		return
	end


	local wide, tall = 800, 480
	
	local pl = LocalPlayer()

	local Window = vgui.Create("DFrame")
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle("")
	Window:SetDraggable(false)
	Window:SetDeleteOnClose(true)
	Window:SetKeyboardInputEnabled(false)
	Window:SetCursor("pointer")
	Window.CenterMouse = StatCenterMouse
	Window.Paint = function()
	
		Derma_DrawBackgroundBlur( Window )
		draw.RoundedBox( 16, 0, 0, Window:GetWide(), Window:GetTall(), COLOR_GRAY )
		
	end	
	
	
	if Window.btnMinim and Window.btnMinim:Valid() then Window.btnMinim:SetVisible(false) end
	if Window.btnMaxim and Window.btnMaxim:Valid() then Window.btnMaxim:SetVisible(false) end
	if Window.btnClose and Window.btnClose:Valid() then Window.btnClose:SetVisible(false) end
	
	local Panel = vgui.Create( "DPanel", Window )
	Panel:SetSize( wide - 20, tall - 20 )
	Panel:Center()
	Panel.Paint = function()
	
		draw.RoundedBox( 16, 0, 0, Panel:GetWide(), Panel:GetTall(), COLOR_BLACK_ALPHA )
	
	end
	
	local returnbutton = vgui.Create( "DImageButton", Panel )
	returnbutton:SetImage( "icon16/arrow_undo.png" )	
	returnbutton:AlignBottom(10)
	returnbutton:AlignLeft(25)
	returnbutton:SizeToContents()
	returnbutton:SetToolTip( "Return to Statistics Selection?" )
	returnbutton.DoClick = function()
		Window:Remove()
		MakepSelectionZS()
		Window:CenterMouse()
	end
	
		local closebutton = vgui.Create( "DImageButton", Panel )
	closebutton:SetImage( "icon16/cancel.png" )	
	closebutton:AlignBottom(10)
	closebutton:AlignRight(-25)
	closebutton:SizeToContents()
	closebutton:SetToolTip( "Close this window?" )
	closebutton.DoClick = function()
		Window:Remove()
	end
	
	local propertysheet = vgui.Create("DPropertySheet", Window)
	propertysheet:StretchToParent( 40, 40, 40, 64 )

	local DermaListView_UNDEAD = vgui.Create("DListView")
	DermaListView_UNDEAD:SetParent(Window)
	DermaListView_UNDEAD:SetPos(25, 50)
	DermaListView_UNDEAD:SetSize(64, 64)
	DermaListView_UNDEAD:SetMultiSelect(false)
	DermaListView_UNDEAD:AddColumn("Name")
	DermaListView_UNDEAD:AddColumn("Total Brains Eaten")
	DermaListView_UNDEAD:AddColumn("Total Prop Kills")
	DermaListView_UNDEAD:AddColumn("Total Wins")
	DermaListView_UNDEAD:AddColumn("Total Deaths")
	DermaListView_UNDEAD:SetSortable( true )
	
	DermaListView_UNDEAD.Paint = 
	function(self)
	
		--self:RefreshList()
		draw.RoundedBox( 16, 1, -5, DermaListView_UNDEAD:GetWide() - 6, DermaListView_UNDEAD:GetTall(), team.GetColor( TEAM_UNDEAD ) )
	end
	
	DermaListView_UNDEAD.RefreshList = function(self)
	
		self:Clear()
 
		for k,v in pairs(player.GetAll()) do
			local name = v:Name()
			local hkills = tonumber( v:GetNWInt( "zombiecounter" ) )
			local zombiedeaths = tonumber( v:GetNWInt( "zombiedeaths" ) )
			local propkills = tonumber( v:GetNWInt( "propkills" ) )
			local zombiewins = tonumber( v:GetNWInt( "zombiewins" ) )

			local line = self:AddLine(name, string.Comma(hkills), string.Comma(propkills), string.Comma(zombiewins), string.Comma(zombiedeaths))

			line:SetSortValue( 2, hkills )
			line:SetSortValue( 3, zombiedeaths )
			line:SetSortValue( 4, propkills )
			line:SetSortValue( 5, zombiewins )
		end
	
		
	end
	
	DermaListView_UNDEAD.DoDoubleClick = DermaListView_UNDEAD.RefreshList

	DermaListView_UNDEAD:RefreshList()

	propertysheet:AddSheet( "Zombie Statistics", DermaListView_UNDEAD, "icon16/stat_zombie.png", false, false, "Normal Stats for all Undead players." )
	propertysheet:SetSkin( "zs_stats" )
	


	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.5, 0)
	Window:MakePopup()
end

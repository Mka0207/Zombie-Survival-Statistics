--Please don't edit any of this.

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


function MakepSelection(silent)
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
		draw.RoundedBox( 16, 0, 0, Window:GetWide(), Window:GetTall(), Color( 0, 0, 0, 255 ) )
		
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
	
		draw.RoundedBox( 16, 0, 0, Panel:GetWide(), Panel:GetTall(), Color( 50, 50, 50, 120 ) )
	
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
		gui.OpenURL("http://steamcommunity.com/id/mka0207/")
	end
	
	
	DermaImageButtonPanel = vgui.Create( "DPanel", Window )
	DermaImageButtonPanel:AlignLeft( 125 )
	DermaImageButtonPanel:CenterVertical()
	DermaImageButtonPanel:SetSize( 64, 64 )
	DermaImageButtonPanel.Paint = function()
		draw.RoundedBox( 16, 0, 0, DermaImageButtonPanel:GetWide(), DermaImageButtonPanel:GetTall(), Color( 46, 181, 239, 100 ) )
	end
	
	local closebutton = vgui.Create( "DImageButton", Panel )
	closebutton:SetImage( "icon16/cancel.png" )	
	closebutton:AlignBottom()
	closebutton:AlignRight()
	closebutton:SizeToContents()
	closebutton:SetToolTip( "Close this window?" )
	closebutton.DoClick = function()
		Window:Remove()
	end
	
	
	DermaImageButtonPanel2 = vgui.Create( "DPanel", Window )
	DermaImageButtonPanel2:AlignRight( 125 )
	DermaImageButtonPanel2:CenterVertical()
	DermaImageButtonPanel2:SetSize( 64, 64 )
	DermaImageButtonPanel2.Paint = function()
		draw.RoundedBox( 16, 0, 0, DermaImageButtonPanel2:GetWide(), DermaImageButtonPanel2:GetTall(), Color( 255, 0, 0, 100 ) )
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
	
	
	Window:MakePopup()
end

function MakepHumanStats(silent)
	if Window and Window:Valid() then
		Window:MakePopup()
		Window:CenterMouse()
		return
	end

	local wide, tall = ScrW() / 1.5, ScrH() / 1.5
	
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
		draw.RoundedBox( 16, 0, 0, Window:GetWide(), Window:GetTall(), Color( 0, 0, 0, 255 ) )
		
	end	
	
	if Window.btnMinim and Window.btnMinim:Valid() then Window.btnMinim:SetVisible(false) end
	if Window.btnMaxim and Window.btnMaxim:Valid() then Window.btnMaxim:SetVisible(false) end
	if Window.btnClose and Window.btnClose:Valid() then Window.btnClose:SetVisible(false) end
	
	local Panel = vgui.Create( "DPanel", Window )
	Panel:SetSize( wide - 20, tall - 20 )
	Panel:Center()
	Panel.Paint = function()
	
		draw.RoundedBox( 16, 0, 0, Panel:GetWide(), Panel:GetTall(), Color( 50, 50, 50, 120 ) )
	
	end
	
	local returnbutton = vgui.Create( "DImageButton", Panel )
	returnbutton:SetImage( "icon16/arrow_undo.png" )	
	returnbutton:AlignBottom(10)
	returnbutton:AlignLeft(25)
	returnbutton:SizeToContents()
	returnbutton:SetToolTip( "Return to Statistics Selection?" )
	returnbutton.DoClick = function()
		Window:Remove()
		MakepSelection()
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
	propertysheet:StretchToParent( 12, 52, 12, 64 )

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
		
		draw.RoundedBox( 16, 0, 0, DermaListView_HUMAN:GetWide(), DermaListView_HUMAN:GetTall(), Color( 46, 181, 239, 100 ) )

	end
 
	DermaListView_HUMAN.RefreshList = function(self)
	
		self:Clear()
			
		for k,v in pairs(player.GetAll( TEAM_HUMAN )) do
			local name = v:Name()
			local zkills = tonumber( v:GetNWInt( "humancounter" ) )
			local headshots = tonumber( v:GetNWInt( "headshotcounter" ) )
			local assists = tonumber( v:GetNWInt( "assistcounter" ) )
			local humanwins = tonumber( v:GetNWInt( "humanwins" ) )
			local humandeaths = tonumber( v:GetNWInt( "humandeaths" ) )

			self:AddLine(name, zkills, headshots, assists, humanwins, humandeaths)
		end
		
	end
	
	DermaListView_HUMAN.DoDoubleClick = DermaListView_HUMAN.RefreshList

	DermaListView_HUMAN:RefreshList()

	
	propertysheet:AddSheet( "Human Statistics", DermaListView_HUMAN, "icon16/stat_human.png", false, false, "Normal Stats for all Human players." )

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


	local wide, tall = ScrW() / 1.5, ScrH() / 1.5
	
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
		draw.RoundedBox( 16, 0, 0, Window:GetWide(), Window:GetTall(), Color( 0, 0, 0, 255 ) )
		
	end	
	
	
	if Window.btnMinim and Window.btnMinim:Valid() then Window.btnMinim:SetVisible(false) end
	if Window.btnMaxim and Window.btnMaxim:Valid() then Window.btnMaxim:SetVisible(false) end
	if Window.btnClose and Window.btnClose:Valid() then Window.btnClose:SetVisible(false) end
	
	local Panel = vgui.Create( "DPanel", Window )
	Panel:SetSize( wide - 20, tall - 20 )
	Panel:Center()
	Panel.Paint = function()
	
		draw.RoundedBox( 16, 0, 0, Panel:GetWide(), Panel:GetTall(), Color( 50, 50, 50, 120 ) )
	
	end
	
	local returnbutton = vgui.Create( "DImageButton", Panel )
	returnbutton:SetImage( "icon16/arrow_undo.png" )	
	returnbutton:AlignBottom(10)
	returnbutton:AlignLeft(25)
	returnbutton:SizeToContents()
	returnbutton:SetToolTip( "Return to Statistics Selection?" )
	returnbutton.DoClick = function()
		Window:Remove()
		MakepSelection()
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
	propertysheet:StretchToParent(12, 52, 12, 64)

	local DermaListView_UNDEAD = vgui.Create("DListView")
	DermaListView_UNDEAD:SetParent(Window)
	DermaListView_UNDEAD:SetPos(25, 50)
	DermaListView_UNDEAD:SetSize(64, 64)
	DermaListView_UNDEAD:SetMultiSelect(false)
	DermaListView_UNDEAD:AddColumn("Name")
	DermaListView_UNDEAD:AddColumn("Total Human Kills")
	DermaListView_UNDEAD:AddColumn("Total Prop Kills")
	DermaListView_UNDEAD:AddColumn("Total Wins")
	DermaListView_UNDEAD:AddColumn("Total Deaths")
	DermaListView_UNDEAD:SetSortable( true )
	
	DermaListView_UNDEAD.Paint = 
	function(self)
	
		--self:RefreshList()
		
		draw.RoundedBox( 16, 0, 0, DermaListView_UNDEAD:GetWide(), DermaListView_UNDEAD:GetTall(), Color( 255, 0, 0, 100 ) )
		
	end
	
	DermaListView_UNDEAD.RefreshList = function(self)
	
		self:Clear()
 
		for k,v in pairs(player.GetAll( TEAM_UNDEAD )) do
	
			local name = v:Name()
			local hkills = tonumber( v:GetNWInt( "zombiecounter" ) )
			local zombiedeaths = tonumber( v:GetNWInt( "zombiedeaths" ) )
			local propkills = tonumber( v:GetNWInt( "propkills" ) )
			local zombiewins = tonumber( v:GetNWInt( "zombiewins" ) )

			self:AddLine(name, hkills, propkills, zombiewins, zombiedeaths)

		end
	
		
	end
	
	DermaListView_UNDEAD.DoDoubleClick = DermaListView_UNDEAD.RefreshList

	DermaListView_UNDEAD:RefreshList()

	propertysheet:AddSheet( "Zombie Statistics", DermaListView_UNDEAD, "icon16/stat_zombie.png", false, false, "Normal Stats for all Undead players." )
	
	


	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.5, 0)
	Window:MakePopup()
end


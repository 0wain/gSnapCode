gSnapCodes = {}

if CLIENT then

	surface.CreateFont( "snap_main", {
		font = "HelveticaNeue-Light",
		size = 50,
		weight = 100
	})

	surface.CreateFont( "snap_user", {
		font = "HelveticaNeue-Light",
		size = 40,
		weight = 100
	})

	gSnapCodes.users = {}

	if !file.Exists("gs_date", "DATA") then
		file.CreateDir("gs_data")
	end	

	local function saveImage(data, name)
		file.Write( "gs_data/"..name..".png", data )
		print(name.." saved")
	end

	local function checkImage(name)
		if file.Exists( "gs_data/"..name..".png", "DATA" ) then
			return true
		else
			return false
		end
	end

	local function cacheUser(ply, name)
		gSnapCodes.users[ply:SteamID64()] = {path = "gs_data/"..name..".png", code = name}
	end

	local function cacheUserByID(id, name)
		gSnapCodes.users[id] = {path = "gs_data/"..name..".png", code = name}
	end

	local function getUser(ply)
		return gSnapCodes.users[ply]
	end

	local function getUserSnapCode(ply)
		return gSnapCodes.users[ply].code
	end

	local function getUserByID(id)
		return gSnapCodes.users[id]
	end

	local function addUser(ply, name)
		if checkImage(name) then
			cacheUser(ply, name)
		else
			registerSnapCode(ply, name)
		end
	end

	local function addUserByID(id, name)
		if checkImage(name) then
			cacheUserByID(id, name)
		else
			registerSnapCodeByID(id, name)
		end
	end

	local function registerSnapCode(ply, name)
		local userURL = "https://feelinsonice-hrd.appspot.com/web/deeplink/snapcode?username="..name.."&type=PNG&bitmoji=enable"
		http.Fetch( userURL,
			function( body, len, headers, code )
				saveImage(body, name)
				cacheUser(ply, name)
			end
		)
	end

	local function registerSnapCodeByID(id, name)
		local userURL = "https://feelinsonice-hrd.appspot.com/web/deeplink/snapcode?username="..name.."&type=PNG&bitmoji=enable"
		http.Fetch( userURL,
			function( body, len, headers, code )
				saveImage(body, name)
				cacheUserByID(id, name)
			end
		)
	end

	local function downloadSnapCode(name)
		local userURL = "https://feelinsonice-hrd.appspot.com/web/deeplink/snapcode?username="..name.."&type=PNG&bitmoji=enable"
		http.Fetch( userURL,
			function( body, len, headers, code )
				saveImage(body, name)
			end
		)
	end

	local function openSnapCodes()
		local frame = vgui.Create("DFrame")
		frame:SetSize(ScrW()*0.75, ScrH()*0.75)
		frame:Center()
		frame:ShowCloseButton(false)
		frame:MakePopup()
		frame.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0))
			draw.SimpleText("Registered SnapCodes", "snap_main", w/2, 25, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.RoundedBox(0, w/2-220, 50, 440, 5, Color(0, 0, 0))
		end

		local close = vgui.Create("DButton", frame)
		close:SetPos(frame:GetWide()-40, 0)
		close:SetSize(40, 40)
		close:SetText("")
		close.DoClick = function() frame:Close() end
		close.Paint = function(self, w, h)
			draw.SimpleText("x", "snap_user", w/2, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local shell = vgui.Create("DPanel", frame)
		shell:SetSize(frame:GetWide()-20, frame:GetTall()-70)
		shell:SetPos(10, 65)
		shell.Paint = function(self, w, h)
		end

		local shelllist = vgui.Create("DPanelList", shell)
		shelllist:SetSize(shell:GetWide()+13, shell:GetTall())
		shelllist:SetPos(0, 0)
		shelllist:EnableHorizontal(true)
		shelllist:EnableVerticalScrollbar(false)
		shelllist:SetSpacing(15)

		for k, v in pairs(gSnapCodes.users) do
			local snappanel = vgui.Create("DButton", shelllist)
			snappanel:SetSize((shelllist:GetWide()/5)-15, (shelllist:GetWide()/5)+40)
			snappanel:SetText("")
			local rancolor = Color(math.Clamp(math.random(255), 55, 255), math.Clamp(math.random(255), 55, 255), math.Clamp(math.random(255), 55, 255))
			snappanel.Paint = function(self, w, h)
				draw.RoundedBox(50, 0, 0, w, h, Color(0, 0, 0))
				draw.RoundedBox(50, 3, 3, w-6, h-6, rancolor)
				draw.SimpleText(v.code, "snap_user", w/2, h-60, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
			
			local snapcode = vgui.Create("DImage", snappanel)
			snapcode:SetSize(snappanel:GetWide()-20, snappanel:GetWide()-20)
			snapcode:SetPos(10, 10)
			snapcode:SetImage( "data/"..v.path )

			shelllist:AddItem(snappanel)
		end
	end

	local function openSnapRegister()
		local frame = vgui.Create("DFrame")
		frame:SetSize(ScrW()*0.75, ScrH()*0.75)
		frame:Center()
		frame:ShowCloseButton(false)
		frame:MakePopup()
		frame.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0))
			draw.SimpleText("Register a SnapCode", "snap_main", w/2, 25, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.RoundedBox(0, w/2-220, 50, 440, 5, Color(0, 0, 0))
		end

		local close = vgui.Create("DButton", frame)
		close:SetPos(frame:GetWide()-40, 0)
		close:SetSize(40, 40)
		close:SetText("")
		close.DoClick = function() frame:Close() end
		close.Paint = function(self, w, h)
			draw.SimpleText("x", "snap_user", w/2, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local shell = vgui.Create("DPanel", frame)
		shell:SetSize(frame:GetWide()-20, frame:GetTall()-70)
		shell:SetPos(10, 65)
		shell.Paint = function(self, w, h)
		end

		local username = vgui.Create("DTextEntry", shell)
		username:SetSize(shell:GetWide()/2, 40)
		username:SetPos(shell:GetWide()/4, 20)
		username.Paint = function(self, w, h)
			draw.RoundedBox(15, 0, 0, w, h, Color(0, 0, 0))
			draw.RoundedBox(15, 2, 2, w-4, h-4, Color(255, 255, 255))
			draw.SimpleText(self:GetText(), "snap_user", w/2, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local checkuser = vgui.Create("DButton", shell)
		checkuser:SetSize(shell:GetWide()/2, 40)
		checkuser:SetPos(shell:GetWide()/4, 70)
		checkuser:SetText("")
		checkuser.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0))
			draw.RoundedBox(10, 2, 2, w-4, h-4, Color(200, 0, 200))
			draw.SimpleText("Check Username?", "snap_user", w/2, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local snapcode = vgui.Create("DImage", shell)
		snapcode:SetSize(shell:GetWide()/3, shell:GetWide()/3)
		snapcode:SetPos(shell:GetWide()/3, 120)
		snapcode:SetImage( "data/gs_data/logo.png" )


		checkuser.DoClick = function()
			local cacheText = username:GetText()
			downloadSnapCode(cacheText)
			timer.Simple(1, function()
				if checkImage(cacheText) then
					print("data/gs_data/"..cacheText)
					snapcode:SetImage( "data/gs_data/"..cacheText..".png" )
				else
					snapcode:SetImage( "data/gs_data/logo.png" )
				end
			end)
		end

		local submituser = vgui.Create("DButton", shell)
		submituser:SetSize(shell:GetWide()/2, shell:GetTall()-(120+shell:GetWide()/3+5))
		submituser:SetPos(shell:GetWide()/4, 120+(shell:GetWide()/3)+5)
		submituser:SetText("")
		submituser.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0))
			draw.RoundedBox(10, 2, 2, w-4, h-4, Color(0, 200, 200))
			draw.SimpleText("Register SnapCode?", "snap_user", w/2, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		submituser.DoClick = function()
			net.Start("gsc_registeruser")
				net.WriteString(username:GetText())
			net.SendToServer()
			timer.Simple(0.25, function()
				frame:Close()
				openSnapCodes()
			end)
		end
	end

	local function openInterface()
		local frame = vgui.Create("DFrame")
		frame:SetSize(ScrW()*0.75, ScrH()*0.75)
		frame:Center()
		frame:ShowCloseButton(false)
		frame:MakePopup()
		local fadein = 0
		frame.Paint = function(self, w, h)
			fadein = Lerp(0.007, fadein, 255)
			draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, fadein))
		end

		local close = vgui.Create("DButton", frame)
		close:SetPos(frame:GetWide()-40, 0)
		close:SetSize(40, 40)
		close:SetText("")
		close.DoClick = function() frame:Close() end
		close.Paint = function(self, w, h)
			draw.SimpleText("x", "snap_user", w/2, h/2, Color(0, 0, 0, fadein), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local logo = vgui.Create("DImage", frame)
		logo:SetSize(frame:GetTall()/2, frame:GetTall()/2)
		logo:SetPos(frame:GetWide()/2-((frame:GetTall()/2)/2), frame:GetTall()/3-((frame:GetTall()/2)/2))
		logo:SetImage( "data/gs_data/logo.png" )
		local oldPaint = logo.Paint
		logo.Paint = function(self, w, h)
			oldPaint(self, w, h)
			if fadein != 255 then
				logo:SetImageColor( Color( 255, 255, 255, fadein ) )
			end
		end

		local opencodes = vgui.Create("DButton", frame)
		opencodes:SetSize(frame:GetWide()/5, frame:GetTall()/5)
		opencodes:SetPos(frame:GetWide()/2-((frame:GetWide()/4)*1.5), (frame:GetTall()/3)*2)
		opencodes:SetText("")
		opencodes.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(203, 81, 203, fadein))
			draw.SimpleText("VIEW", "snap_main", w/2, h/2+5, Color(255, 255, 255,fadein), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText("SNAPCODES", "snap_main", w/2, h/2-5, Color(255, 255, 255, fadein), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
		opencodes.DoClick = function()
			frame:Close()
			openSnapCodes()
		end

		local registercodes = vgui.Create("DButton", frame)
		registercodes:SetSize(frame:GetWide()/5, frame:GetTall()/5)
		registercodes:SetPos(frame:GetWide()/2+(((frame:GetWide()/4)*1.5)-opencodes:GetWide()), (frame:GetTall()/3)*2)
		registercodes:SetText("")
		registercodes.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(20, 136, 213, fadein))
			draw.SimpleText("REGISTER", "snap_main", w/2, h/2+5, Color(255, 255, 255,fadein), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText("SNAPCODE", "snap_main", w/2, h/2-5, Color(255, 255, 255, fadein), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
		registercodes.DoClick = function()
			frame:Close()
			openSnapRegister()
		end
	end

	net.Receive("gsc_updateuser", function()
		local ply = net.ReadEntity()
		local snapcode = net.ReadString()
		addUser(ply, snapcode)
	end)

	net.Receive("gsc_loadusers", function()
		local codes = net.ReadTable()
		for k, v in pairs(codes) do
			addUserByID(v.SteamID, v.SnapCode)
		end
	end)

	net.Receive("gsc_msg", function()
		chat.AddText( Color(255, 255, 0), "[gSnapCode]: ", Color( 255, 255, 255 ), net.ReadString() )
	end)

	concommand.Add("gsc_openui", function()
		openInterface()
	end)
end


if SERVER then
	gSnapCodes.CoolDown = gSnapCodes.CoolDown or {}
	util.AddNetworkString("gsc_registeruser")
	util.AddNetworkString("gsc_updateuser")
	util.AddNetworkString("gsc_loadusers")
	util.AddNetworkString("gsc_msg")

	if !sql.TableExists("gsc_users") then
		sql.Query( "CREATE TABLE gsc_users( SteamID TEXT, UserName TEXT, SnapCode TEXT )" )
	end

	local function RefreshUser(ply, snapcode)
		net.Start("gsc_updateuser")
			net.WriteEntity(ply)
			net.WriteString(snapcode)
		net.Broadcast()
	end

	local function LoadUsers(ply)
		local usersCodes = sql.Query("SELECT SteamID, UserName, SnapCode FROM gsc_users")
		PrintTable(usersCodes)
		if !usersCodes then return end

		net.Start("gsc_loadusers")
			net.WriteTable(usersCodes)
		net.Send(ply)
	end

	local function AddUser(ply, snapcode)
		local usersCode = sql.Query("SELECT SteamID, UserName, SnapCode FROM gsc_users WHERE SteamID="..ply:SteamID64())
		if !usersCode then
			sql.Query("INSERT INTO gsc_users(SteamID, UserName, SnapCode) VALUES('"..ply:SteamID64().."', '"..ply:GetName().."', "..sql.SQLStr(snapcode)..")")
		else
			sql.Query("UPDATE gsc_users SET UserName='"..ply:GetName().."', SnapCode="..sql.SQLStr(snapcode).." WHERE SteamID='"..ply:SteamID64().."'")
		end
		RefreshUser(ply, snapcode)
	end

	net.Receive("gsc_registeruser", function(_, ply)
		print(gSnapCodes.CoolDown[ply:SteamID64()])
		if gSnapCodes.CoolDown[ply:SteamID64()] > CurTime() then
			net.Start("gsc_msg")
				net.WriteString("Please wait "..math.Round(gSnapCodes.CoolDown[ply:SteamID64()]-CurTime()).."s before trying to re-register a snap code")
			net.Send(ply)
			return 
		end
		gSnapCodes.CoolDown[ply:SteamID64()] = CurTime() + 60
		local Snapcode = net.ReadString()
		if Snapcode == "" then return end
		AddUser(ply, Snapcode)
	end)

	hook.Add("PlayerInitialSpawn", "gs_loadsnaps", function(ply)
		LoadUsers(ply)
		gSnapCodes.CoolDown[ply:SteamID64()] = 0
	end)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    game_spawn.lua
--  brief:   spawns start unit and sets storage levels
--  author:  Tobi Vollebregt
--
--  Copyright (C) 2010.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Spawn",
		desc      = "spawns start unit and sets storage levels",
		author    = "Tobi Vollebregt",
		date      = "January, 2010",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local modOptions = Spring.GetModOptions()

-- Need the raw sidedata for short names
local sideData = VFS.Include("gamedata/sidedata.lua", nil, VFS.ZIP)
local SideNames = {}
for sideNum, data in pairs(sideData) do
	SideNames[data.name:lower()] = data.shortName:lower()
end
GG.SideNames = SideNames

local sideStartUnits = {}

local function GetStartUnit(teamID)
	-- get the team startup info
	local side = select(5, Spring.GetTeamInfo(teamID))
	local startUnit
	if (side == "") then
		-- startscript didn't specify a side for this team
		local sidedata = Spring.GetSideData()
		if (sidedata and #sidedata > 0) then
			local sideNum = math.random(1,#Spring.GetSideData()) --TODO: 2 + teamID % #sidedata
			startUnit = sidedata[sideNum].startUnit
			side = sidedata[sideNum].sideName
		end
		-- set the gamerules param to notify other gadgets it was a direct launch
		Spring.SetGameRulesParam("runningWithoutScript", 1)
	else
		startUnit = Spring.GetSideData(side)
	end
	-- Check for GM / Random team
	--[[if startUnit == "gmtoolbox" then
		local randSide = math.random(1,#GetSideData())	-- TODO: start at 2 to avoid picking random side again
		if (modOptions.gm_team_enable == "0") then
			side, startUnit = GetSideData(randSide)
		else
			side = GetSideData(randSide)
		end
	end--]]
	GG.teamSide[teamID] = SideNames[side]
	Spring.SetTeamRulesParam(teamID, "side", SideNames[side])
	return startUnit
end

local function SpawnStartUnit(teamID)
	local startUnit = sideStartUnits[teamID]
	if (startUnit and startUnit ~= "") then
		-- spawn the specified start unit
		local x,y,z = Spring.GetTeamStartPosition(teamID)
		-- snap to 16x16 grid
		x, z = 16*math.floor((x+8)/16), 16*math.floor((z+8)/16)
		y = Spring.GetGroundHeight(x, z)
		-- facing toward map center
		local facing=math.abs(Game.mapSizeX/2 - x) > math.abs(Game.mapSizeZ/2 - z)
			and ((x>Game.mapSizeX/2) and "west" or "east")
			or ((z>Game.mapSizeZ/2) and "north" or "south")
		local unitID = Spring.CreateUnit(startUnit, x, y, z, facing, teamID)
	end

	-- set start resources, either from mod options or custom team keys
	local teamOptions = select(7, Spring.GetTeamInfo(teamID))
	local m = teamOptions.startmetal  or modOptions.startmetal  or 5000
	local e = teamOptions.startenergy or modOptions.startenergy or 200

	-- using SetTeamResource to get rid of any existing resource without affecting stats
	-- using AddTeamResource to add starting resource and counting it as income
	if (m and tonumber(m) ~= 0) then
		-- remove the pre-existing storage
		--   must be done after the start unit is spawned,
		--   otherwise the starting resources are lost!
		Spring.SetTeamResource(teamID, "ms", tonumber(m * 100))
		Spring.SetTeamResource(teamID, "m", 0)
		Spring.AddTeamResource(teamID, "m", tonumber(m))
	end
	if (e and tonumber(e) ~= 0) then
		-- remove the pre-existing storage
		--   must be done after the start unit is spawned,
		--   otherwise the starting resources are lost!
		Spring.SetTeamResource(teamID, "es", tonumber(e))
		Spring.SetTeamResource(teamID, "e", 0)
		Spring.AddTeamResource(teamID, "e", tonumber(e))
	end
end

function gadget:Initialize()
	GG.teamSide = {}
	local gaiaTeamID = Spring.GetGaiaTeamID()
	local teams = Spring.GetTeamList()
	for i = 1,#teams do
		local teamID = teams[i]
		-- don't spawn a start unit for the Gaia team
		if (teamID ~= gaiaTeamID) then
			sideStartUnits[teamID] = GetStartUnit(teamID)
		end
	end
end

function gadget:GameStart()
	Spring.PlaySoundFile("BB_All_Systems_Nominal", 1, "ui")
	-- spawn start units
	local gaiaTeamID = Spring.GetGaiaTeamID()
	local teams = Spring.GetTeamList()
	for i = 1,#teams do
		local teamID = teams[i]
		-- don't spawn a start unit for the Gaia team
		if (teamID ~= gaiaTeamID) then
			SpawnStartUnit(teamID)
		end
	end
end
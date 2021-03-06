function gadget:GetInfo()
	return {
		name      = "Beacon Manager",
		desc      = "Populates maps with flags and handles control",
		author    = "FLOZi",
		date      = "Adopted from S44 flagManager 10/02/2011",
		license   = "GNU GPL v2",
		layer     = -2,
		enabled   = true  --  loaded by default?
	}
end

-- function localisations
local floor						= math.floor
-- Synced Read
local AreTeamsAllied			= Spring.AreTeamsAllied
local GetFeatureDefID			= Spring.GetFeatureDefID
local GetFeaturePosition		= Spring.GetFeaturePosition
local GetFeaturesInRectangle	= Spring.GetFeaturesInRectangle
local GetGroundHeight			= Spring.GetGroundHeight
local GetGroundInfo				= Spring.GetGroundInfo
local GetUnitHeading			= Spring.GetUnitHeading
local GetUnitPosition			= Spring.GetUnitPosition
local GetUnitsInCylinder		= Spring.GetUnitsInCylinder
local GetUnitTeam				= Spring.GetUnitTeam
local GetTeamInfo 				= Spring.GetTeamInfo
local GetTeamRulesParam			= Spring.GetTeamRulesParam
local GetTeamUnitDefCount 		= Spring.GetTeamUnitDefCount

-- Synced Ctrl
local CallCOBScript				= Spring.CallCOBScript
local CreateUnit				= Spring.CreateUnit
local DestroyFeature			= Spring.DestroyFeature
local GameOver					= Spring.GameOver
local GiveOrderToUnit			= Spring.GiveOrderToUnit
local KillTeam					= Spring.KillTeam
local SetGameRulesParam 		= Spring.SetGameRulesParam
local SetTeamRulesParam			= Spring.SetTeamRulesParam
local SetUnitAlwaysVisible		= Spring.SetUnitAlwaysVisible
local SetUnitMetalExtraction	= Spring.SetUnitMetalExtraction
local SetUnitNeutral			= Spring.SetUnitNeutral
local SetUnitNoSelect			= Spring.SetUnitNoSelect
local SetUnitResourcing			= Spring.SetUnitResourcing
local SetUnitRulesParam			= Spring.SetUnitRulesParam
local TransferUnit				= Spring.TransferUnit

-- constants
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
local GAIA_ALLY_ID = select(6, GetTeamInfo(GAIA_TEAM_ID))
local PROFILE_PATH = "maps/flagConfig/" .. Game.mapName .. "_profile.lua"
local DEBUG	= false -- enable to print out flag locations in profile format

local CAP_MULT = 1 --multiplies against the FBI defined CapRate
local DEF_MULT = 1 --multiplies against the FBI defined DefRate

local BEACON_ID = UnitDefNames["beacon"].id 

-- variables

local unitDefsToIgnore = {}
local flagTypes = {"beacon"}
local flags = {} -- flags[flagType][index] == flagUnitID
local numFlags = {} -- numFlags[flagType] == numberOfFlagsOfType
local totalFlags = 0
local flagTypeData = {} -- flagTypeData[flagType] = {radius = radius, etc}
local flagTypeSpots = {} -- flagTypeSpots[flagType][metalSpotCount] == {x = x_coord, z = z_coord}
local flagTypeCappers = {} -- cappers[flagType][unitID] = true
local flagTypeDefenders	= {} -- defenders[flagType][unitID] = true

for _, flagType in pairs(flagTypes) do
	local cp = UnitDefNames[flagType].customParams
	flagTypeData[flagType] = {
		radius = tonumber(cp.flagradius) or 460, -- radius of flagTypes capping area
		capThreshold = tonumber(cp.capthreshold) or 20, -- number of capping points needed for flagType to switch teams
		regen = tonumber(cp.flagregen) or 1, -- how fast a flagType with no defenders or attackers will reduce capping statuses
		tooltip = UnitDefNames[flagType].tooltip or "Beacon", -- what to call the flagType when it switches teams
		limit = cp.flaglimit or Game.maxUnits, -- How many of this flagType a player can hold at once
	}
	flags[flagType] = {}
	numFlags[flagType] = 0
	flagTypeSpots[flagType] = {}
	flagTypeCappers[flagType] = {}
	flagTypeDefenders[flagType] = {}
end

local flagCapStatuses = {} -- table of flag's capping statuses
local teams	= Spring.GetTeamList()
local teamUnitCounts = {}

for _, teamID in pairs(Spring.GetTeamList()) do
	teamUnitCounts[teamID] = 0
end

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end
local metalMake = tonumber(modOptions.map_command_per_player) or -1

-- BEACON TICKET DECLARATIONS
local START_TICKETS = tonumber(modOptions.start_tickets) or 100
local TICKET_LOSS_PER_BEACON = 1
local beaconsPerAllyTeam = {}
local tickets = {}
local bleedTimes = {}
local allyTeamAlive = {}
local deadAllyTeams = 0
local allyTeams = Spring.GetAllyTeamList()
for i = 1, #allyTeams do
	local allyTeam = allyTeams[i]
	if allyTeam == GAIA_ALLY_ID then 
		allyTeams[i] = nil
	else
		tickets[allyTeam] = START_TICKETS
		bleedTimes[allyTeam] = 0
		beaconsPerAllyTeam[allyTeam] = 0
		allyTeamAlive[allyTeam] = true
	end
end

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

local DelayCall = GG.Delay.DelayCall

function UpdateBeacons(teamID, num)
	if teamID == GAIA_TEAM_ID then return end -- Gaia does not have tickets
	local allyTeam = select(6, GetTeamInfo(teamID))
	beaconsPerAllyTeam[allyTeam] = beaconsPerAllyTeam[allyTeam] + num
end

function DecrementTickets(allyTeam)
	if allyTeam == GAIA_ALLY_ID then return end -- Gaia does not have tickets
	if tickets[allyTeam] > 0 then
		tickets[allyTeam] = tickets[allyTeam] - 1
		--Spring.Echo("AllyTeam " .. allyTeam .. ": " .. tickets[allyTeam])
		SetGameRulesParam("tickets" .. allyTeam, tickets[allyTeam], {public = true})
	elseif tickets[allyTeam] == 0 then
		if allyTeamAlive[allyTeam] then
			local teams = Spring.GetTeamList(allyTeam)
			for i = 1, #teams do
				local teamID = teams[i]
				local teamUnits = Spring.GetTeamUnits(teamID)
				for i = 1, #teamUnits do
					TransferUnit(teamUnits[i], GAIA_TEAM_ID, false)
				end
				KillTeam(teamID)
			end
			allyTeamAlive[allyTeam] = false
			deadAllyTeams = deadAllyTeams + 1
			if deadAllyTeams == (#allyTeams - 1) then
				for team, alive in pairs(allyTeamAlive) do
					if alive then GameOver({team}) break end
				end
			end
		end
	end
end


-- this function is used to add any additional flagType specific behaviour
function FlagSpecialBehaviour(action, flagType, flagID, flagTeamID, teamID)
	--[[if action == "placed" then

	elseif action == "capped" then

	end]]
end


function PlaceFlag(spot, flagType, newFlag)
	if DEBUG then
		Spring.Echo("{")
		Spring.Echo("	x = " .. spot.x .. ",")
		Spring.Echo("	z = " .. spot.z .. ",")
		Spring.Echo("},")
	end
	
	if not newFlag then
		newFlag = CreateUnit(flagType, spot.x, Spring.GetGroundHeight(spot.x, spot.z), spot.z, 0, GAIA_TEAM_ID)
	end
	numFlags[flagType] = numFlags[flagType] + 1
	totalFlags = totalFlags + 1
	flags[flagType][numFlags[flagType]] = newFlag
	flagCapStatuses[newFlag] = {}
	
	SetUnitNeutral(newFlag, true)
	SetUnitAlwaysVisible(newFlag, true)
	
	local squareSize = 100
	local features = GetFeaturesInRectangle(spot.x - squareSize, spot.z - squareSize, spot.x + squareSize, spot.z + squareSize)
	for i = 1, #features do
		DestroyFeature(features[i])
	end
	FlagSpecialBehaviour("placed", flagType, newFlag, GAIA_TEAM_ID, GAIA_TEAM_ID)
end


function gadget:GamePreload()
	if DEBUG then Spring.Echo(PROFILE_PATH) end
	-- CHECK FOR PROFILES
	if VFS.FileExists(PROFILE_PATH) then
		local flagSpots, temps = VFS.Include(PROFILE_PATH)
		if flagSpots and #flagSpots > 0 then 
			Spring.Echo("Map Beacon Profile found. Loading " .. (#flagSpots or 0) .. " Beacon positions...")
			flagTypeSpots["beacon"] = flagSpots 
		end
		-- setup default ambient temps
		if not temps then temps = {} end
		temps.ambient = temps.ambient or 20
		temps.water = temps.water or 10
		GG.MapTemperatures = temps
		Spring.SetGameRulesParam("MAP_TEMP_AMBIENT", temps.ambient)
		Spring.SetGameRulesParam("MAP_TEMP_WATER", temps.water)
	else
		for i=1,20 do
			Spring.Echo("NO MAP PROFILE FOUND FOR " .. Game.mapName)
		end
		local temps = {ambient = 20, water = 10}
		GG.MapTemperatures = temps
		Spring.SetGameRulesParam("MAP_TEMP_AMBIENT", temps.ambient)
		Spring.SetGameRulesParam("MAP_TEMP_WATER", temps.water)
	end
	for unitDefID, ud in pairs(UnitDefs) do -- cache ignored unitDefIDs
		if ud.canFly or string.tobool(ud.customParams.ignoreatbeacon) then
			unitDefsToIgnore[unitDefID] = true
		end
	end
end


function gadget:GameStart()
	-- FLAG PLACEMENT
	for _, flagType in pairs(flagTypes) do
		if DEBUG then Spring.Echo("-- flagType is " .. flagType) end
		for i = 1, #flagTypeSpots[flagType] do
			PlaceFlag(flagTypeSpots[flagType][i], flagType)
		end
		GG[flagType .. "s"] = flags[flagType] -- nicer to have GG.flags rather than GG.flag
	end
end

function StripUnits(unitsAtFlag)
	for i = #unitsAtFlag, 1, -1 do -- iterate over list in reverse so removing doesn't screw with index
		local unitID = unitsAtFlag[i]
		local unitDefID = Spring.GetUnitDefID(unitID)
		 -- bad defs are cached, but also ignore any units currently being transported
		if unitDefsToIgnore[unitDefID] or Spring.GetUnitTransporter(unitID) then
			table.remove(unitsAtFlag, i)
		end
	end
end

function gadget:GameFrame(n)
	local maxBeacon = 0
	-- FLAG CONTROL
	if n % 30 == 5 then -- every second with a 5 frame offset
		for _, flagType in pairs(flagTypes) do
			local flagData = flagTypeData[flagType]
			--for spotNum, flagID in pairs(flags[flagType]) do
			for spotNum = 1, numFlags[flagType] do -- WARNING: Assumes flags are placed in order they exist in flags[flagType]
				local flagID = flags[flagType][spotNum]
				local flagTeamID = GetUnitTeam(flagID)
				local spots = flagTypeSpots[flagType]
				local cappers = flagTypeCappers[flagType]
				local capTotals = {}
				local defenders = flagTypeDefenders[flagType]
				local defendTotal = 0
				local unitsAtFlag = GetUnitsInCylinder(spots[spotNum].x, spots[spotNum].z, flagData.radius)
				StripUnits(unitsAtFlag) -- strips table (in place) of ignored unitdefs
				--Spring.Echo ("There are " .. #unitsAtFlag .. " units at flag " .. flagID)
				if #unitsAtFlag == 0 then -- no combat units
					for teamID = 0, #teams-1 do
						if teamID ~= flagTeamID then
							--Spring.Echo(teamID, flagCapStatuses[flagID][teamID])
							if (flagCapStatuses[flagID][teamID] or 0) > 0 then
								flagCapStatuses[flagID][teamID] = flagCapStatuses[flagID][teamID] - flagData.regen
								SetUnitRulesParam(flagID, "cap" .. tostring(teamID), flagCapStatuses[flagID][teamID], {public = true})
								if flagCapStatuses[flagID][teamID] <= 0 then
									GG.PlaySoundForTeam(flagTeamID, "BB_NavBeacon_Secured", 1)
									SetUnitRulesParam(flagID, "secure", 1, {public = true})
								end
							end
						end
					end
				else -- Attackers or defenders (or both) present
					for i = 1, #unitsAtFlag do
						local unitID = unitsAtFlag[i]
						local unitTeamID = GetUnitTeam(unitID)
						if defenders[unitID] then -- and (AreTeamsAllied(unitTeamID, flagTeamID) or flagTeamID == GAIA_TEAM_ID) then
							--Spring.Echo("Defender at flag " .. flagID .. " Value is: " .. defenders[unitID], UnitDefs[Spring.GetUnitDefID(unitID)].name)
							defendTotal = defendTotal + defenders[unitID]
						end
						if cappers[unitID] then -- nd (not AreTeamsAllied(unitTeamID, flagTeamID)) then
							--Spring.Echo("Capper at flag " .. flagID .. " Value is: " .. cappers[unitID], UnitDefs[Spring.GetUnitDefID(unitID)].name)
							capTotals[unitTeamID] = (capTotals[unitTeamID] or 0) + cappers[unitID]
						end
					end
					for teamID, capTotal in pairs(capTotals) do
						if capTotal == defendTotal and teamID ~= flagTeamID then -- implies only one set of mechs here
							if (flagCapStatuses[flagID][teamID] or 0) == 1 then -- first cap step
								GG.PlaySoundForTeam(flagTeamID, "BB_NavBeacon_UnderAttack", 1)
								SetUnitRulesParam(flagID, "secure", 0, {public = true})
							end
							flagCapStatuses[flagID][teamID] = (flagCapStatuses[flagID][teamID] or 0) + capTotal
							SetUnitRulesParam(flagID, "cap" .. tostring(teamID), flagCapStatuses[flagID][teamID], {public = true})
						end
					end
					for j = 1, #teams do
						teamID = teams[j]
						if teamID ~= flagTeamID then -- defending
							if (flagCapStatuses[flagID][teamID] or 0) > 0 and capTotals[teamID] ~= defendTotal and flagTeamID ~= GAIA_TEAM_ID then
								--Spring.Echo("Capping: " .. flagCapStatuses[flagID][teamID] .. " Defending: " .. defendTotal)
								flagCapStatuses[flagID][teamID] = flagCapStatuses[flagID][teamID] - flagData.regen
								if flagCapStatuses[flagID][teamID] <= 0 then
									GG.PlaySoundForTeam(flagTeamID, "BB_NavBeacon_Secured", 1)
									flagCapStatuses[flagID][teamID] = 0
									SetUnitRulesParam(flagID, "secure", 1, {public = true})
								end
								SetUnitRulesParam(flagID, "cap" .. tostring(teamID), flagCapStatuses[flagID][teamID], {public = true})
							end
						end
						if (flagCapStatuses[flagID][teamID] or 0) > flagData.capThreshold and teamID ~= flagTeamID then
							-- Flag is ready to change team
							if (flagTeamID == GAIA_TEAM_ID) then
								-- Neutral flag being capped
								Spring.SendMessageToTeam(teamID, flagData.tooltip .. " Captured!")
								Spring.AddTeamResource(teamID, "metal", 2000)
								GG.PlaySoundForTeam(teamID, "BB_NavBeacon_Captured", 1)
								SetUnitRulesParam(flagID, "secure", 1, {public = true})
								TransferUnit(flagID, teamID, false)
								UpdateBeacons(teamID, 1)
								SetTeamRulesParam(teamID, flagType .. "s", (GetTeamRulesParam(teamID, flagType .. "s") or 0) + 1, {public = true})
								SendToUnsynced("BEACONCAP", teamID, 1)
							else
								-- Team flag being neutralised
								Spring.SendMessageToTeam(teamID, flagData.tooltip .. " Neutralised!")
								Spring.AddTeamResource(teamID, "metal", 2000)
								GG.PlaySoundForTeam(flagTeamID, "BB_NavBeacon_Lost", 1)
								TransferUnit(flagID, GAIA_TEAM_ID, false)
								UpdateBeacons(flagTeamID, -1)
								SetTeamRulesParam(teamID, flagType .. "s", (GetTeamRulesParam(teamID, flagType .. "s") or 0) - 1, {public = true})
								SendToUnsynced("BEACONCAP", flagTeamID, -1)
							end
							-- Perform any flagType specific behaviours
							FlagSpecialBehaviour("capped", flagType, flagID, flagTeamID, teamID)
							-- Turn flag back on
							GiveOrderToUnit(flagID, CMD.ONOFF, {1}, {})
							-- Flag has changed team, reset capping statuses
							for cleanTeamID = 0, #teams-1 do
								flagCapStatuses[flagID][cleanTeamID] = 0
								SetUnitRulesParam(flagID, "cap" .. tostring(cleanTeamID), 0, {public = true})
							end
						end
						-- cleanup defenders
						flagCapStatuses[flagID][flagTeamID] = 0
					end
				end
			end
		end
		-- manage tickets

		
		for allyTeam, numBeacon in pairs(beaconsPerAllyTeam) do
			maxBeacon = math.max(numBeacon, maxBeacon)
		end
		for allyTeam, numBeacon in pairs(beaconsPerAllyTeam) do
			if numBeacon < maxBeacon then
				bleedTimes[allyTeam] = totalFlags / (maxBeacon - numBeacon)
			else
				bleedTimes[allyTeam] = 0
			end
		end
	end
	for allyTeam, i in pairs(bleedTimes) do
		if i > 0 and n % (30 * i) == 0 then
			DecrementTickets(allyTeam)
		end
	end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	if cp.unittype == "mech" or cp.flagdefendrate then -- only mechs & garrision should be in cappers/defenders tables
		local flagCapRate = cp.flagcaprate or 1
		local flagDefendRate = cp.flagdefendrate or flagCapRate

		for _, flagCapType in pairs(flagTypes) do
			flagTypeCappers[flagCapType][unitID] = (CAP_MULT * flagCapRate)
			flagTypeDefenders[flagCapType][unitID] = (DEF_MULT * flagDefendRate)
		end
		if ud.customParams.unittype == "mech" then -- only count mechs
			teamUnitCounts[unitTeam] = teamUnitCounts[unitTeam] + 1
		end
	end
	if unitDefID == BEACON_ID and unitTeam ~= GAIA_TEAM_ID then
		local x,_, z = Spring.GetUnitPosition(unitID)
		local newSpot = {["x"] = x, ["z"] = z}
		table.insert(flagTypeSpots["beacon"], newSpot)
		PlaceFlag(newSpot, "beacon", unitID)
	end
end


function CheckAllyTeamUnits(unitTeam)
	if unitTeam == GAIA_TEAM_ID then return end -- Gaia does not have tickets
	if teamUnitCounts[unitTeam] + Spring.GetTeamUnitDefCount(unitTeam, BEACON_ID) == 0 then
		-- Check if this was last unit on whole allyteam
		local allyTeam = select(6, Spring.GetTeamInfo(unitTeam))
		local allyTeamUnitCount = 0
		for _, teamID in pairs(Spring.GetTeamList(allyTeam)) do
			allyTeamUnitCount = allyTeamUnitCount + teamUnitCounts[teamID] + Spring.GetTeamUnitDefCount(teamID, BEACON_ID)
		end
		-- If it was, this implies they lost all beacons and DZ so can't get any more
		if allyTeamUnitCount == 0 then
			-- Therefore deduct (nearly) all their remaining tickets
			tickets[allyTeam] = math.min(5, tickets[allyTeam])
			DecrementTickets(allyTeam)
		end
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	local ud = UnitDefs[unitDefID]
	if ud.speed > 0 and not ud.canFly then
		for _, flagCapType in pairs(flagTypes) do
			flagTypeCappers[flagCapType][unitID] = nil
			flagTypeDefenders[flagCapType][unitID] = nil
		end
	end
	
	if ud.customParams.unittype == "mech" then
		teamUnitCounts[unitTeam] = teamUnitCounts[unitTeam] - 1
		-- Remove 1 ticket for each mech killed
		local allyTeam = select(6, Spring.GetTeamInfo(unitTeam))
		DelayCall(DecrementTickets, {allyTeam}, 1)
		DelayCall(CheckAllyTeamUnits, {unitTeam}, 1)
	end
end

function gadget:UnitGiven(unitID, unitDefID, newTeam, oldTeam)
	--Spring.Echo("Unit Given: " .. unitID)
	local ud = UnitDefs[unitDefID]
	if ud.customParams.unittype == "mech" then
		teamUnitCounts[oldTeam] = teamUnitCounts[oldTeam] - 1
		teamUnitCounts[newTeam] = teamUnitCounts[newTeam] + 1
	end
	DelayCall(CheckAllyTeamUnits, {oldTeam}, 1)
end

function gadget:Initialize()
	if Spring.GetGameFrame() >  1 then
		gadget:GamePreload()
		--[[for _,unitID in ipairs(Spring.GetAllUnits()) do
			local teamID = Spring.GetUnitTeam(unitID)
			local unitDefID = Spring.GetUnitDefID(unitID)
			gadget:UnitCreated(unitID, unitDefID, teamID)
		end]]
	end
end

else
-- UNSYNCED

function PassToUI(eventID, teamID, change)
	if Script.LuaUI.BeaconCap then
		local allyTeamID = select(6, Spring.GetTeamInfo(teamID))
		Script.LuaUI.BeaconCap(allyTeamID, change)
	end
end

function gadget:Initialize()
	gadgetHandler:AddSyncAction("BEACONCAP", PassToUI)
end

end

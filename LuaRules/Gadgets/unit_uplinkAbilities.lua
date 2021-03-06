function gadget:GetInfo()
	return {
		name		= "Uplink Abilities",
		desc		= "Controls Orbital Uplink's abilities",
		author		= "FLOZi (C. Lawrence)",
		date		= "22/08/13",
		license 	= "GNU GPL v2",
		layer		= 0,
		enabled	= true	--	loaded by default?
	}
end

if gadgetHandler:IsSyncedCode() then
--	SYNCED

-- localisations
--SyncedRead
local GetGameFrame			= Spring.GetGameFrame
local GetUnitPosition		= Spring.GetUnitPosition
local GetTeamResources		= Spring.GetTeamResources
--SyncedCtrl
local CreateUnit			= Spring.CreateUnit
local DestroyUnit			= Spring.DestroyUnit
local EditUnitCmdDesc		= Spring.EditUnitCmdDesc
local InsertUnitCmdDesc		= Spring.InsertUnitCmdDesc
local FindUnitCmdDesc		= Spring.FindUnitCmdDesc
local RemoveUnitCmdDesc		= Spring.RemoveUnitCmdDesc
local SetUnitRulesParam		= Spring.SetUnitRulesParam
local SetTeamRulesParam		= Spring.SetTeamRulesParam
local SpawnProjectile		= Spring.SpawnProjectile
local UseTeamResource 		= Spring.UseTeamResource

-- GG
local FramesToMinutesAndSeconds = GG.FramesToMinutesAndSeconds
local DelayCall				 = GG.Delay.DelayCall

-- Constants
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
local BEACON_ID = UnitDefNames["beacon"].id
local UPLINK_ID = UnitDefNames["upgrade_uplink"].id
local MECHBAY_ID = UnitDefNames["upgrade_mechbay"].id

local ARTY_WEAPON_ID = WeaponDefNames["sniper"].id
local ARTY_HEIGHT = 10000
local ARTY_SALVO = 10
local ARTY_RADIAL_SPREAD = 500
local ARTY_COST = 10000
local ARTY_COOLDOWN = 75 * 30 -- 75s
local ARTY_DELAY = 10 * 30 -- 10s
local artyLastFired = {} -- artyLastFired[teamID] = gameFrame

-- Variables
local artyCmdDesc = {
	id 		= GG.CustomCommands.GetCmdID("CMD_UPLINK_ARTILLERY", ARTY_COST),
	type	= CMDTYPE.ICON_MAP, -- UNIT_OR_MAP?
	name 	= " Artillery \n Strike",
	action	= "uplink_arty",
	tooltip = "C-Bill cost: " .. ARTY_COST,
	cursor	= "Attack",
}

local getOutCmdDesc = {
	id 		= GG.CustomCommands.GetCmdID("CMD_MECHBAY_GETOUT", ARTY_COST),
	type	= CMDTYPE.ICON,
	name 	= " Get  \n Out  ",
	action	= "mechbay_out",
	tooltip = "Emergency unload",
}


function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
	local unitDef = UnitDefs[unitDefID]
	local cp = unitDef.customParams
	if unitDefID == UPLINK_ID then
		InsertUnitCmdDesc(unitID, artyCmdDesc)
	elseif unitDefID == MECHBAY_ID then
		InsertUnitCmdDesc(unitID, getOutCmdDesc)
	end
end

local function ArtyShot(x,y,z)
	local projParams = {}
	projParams.gravity = -3 + math.random()
	projParams.pos = {x, y, z}
	SpawnProjectile(ARTY_WEAPON_ID, projParams)
end

local function ArtyStrike(teamID, x, y, z)
	local lastFrame = artyLastFired[teamID]
	local currFrame = GetGameFrame()
	if lastFrame and lastFrame > currFrame - ARTY_COOLDOWN then -- still cooling
		local minutes, seconds = FramesToMinutesAndSeconds(ARTY_COOLDOWN - (currFrame - lastFrame))
		Spring.Echo("Not yet! " .. minutes .. " min " .. seconds .. " seconds left")
		return false
	end
	local money = GetTeamResources(teamID, "metal")
	if money < ARTY_COST then  -- not enough C-Bills (Should never get this far, button disabled by game_money.lua)
		Spring.Echo("Not enough C-Bills!")
		return false 
	end
	UseTeamResource(teamID, "metal", ARTY_COST)
	artyLastFired[teamID] = currFrame
	SetTeamRulesParam(teamID, "UPLINK_ARTILLERY", currFrame + ARTY_COOLDOWN) -- frame this team can fire arty again
	local dx, dz
	for i = 1, ARTY_SALVO do
		local angle = math.random(360)
		local length = math.random(ARTY_RADIAL_SPREAD)
		dx = math.sin(angle) * length
		dz = math.cos(angle) * length
		DelayCall(ArtyShot, {x + dx, y + ARTY_HEIGHT, z + dz}, ARTY_DELAY + math.random(150))
	end
	GG.PlaySoundForTeam(teamID, "BB_OrbitalStrike_Inbound", 1)
	DelayCall(GG.PlaySoundForTeam, {teamID, "BB_OrbitalStrike_Available_In_60", 1}, ARTY_COOLDOWN - 62 * 30) -- fudge
	DelayCall(GG.PlaySoundForTeam, {teamID, "BB_OrbitalStrike_Available", 1}, ARTY_COOLDOWN)
	return true
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if unitDefID == UPLINK_ID then
		if cmdID == artyCmdDesc.id then
			local x,y,z = unpack(cmdParams)
			return ArtyStrike(teamID, x, y, z)
		end
	elseif unitDefID == MECHBAY_ID then
		if cmdID == getOutCmdDesc.id then
			env = Spring.UnitScript.GetScriptEnv(unitID)
			if env and env.script and env.script.TransportDrop then
				local transporting = Spring.GetUnitIsTransporting(unitID)
				if transporting then
					Spring.UnitScript.CallAsUnit(unitID, env.script.TransportDrop, transporting[1])
					return true
				end
			end
			return false
		end
	end
	return true
end

function gadget:Initialize()
	for _,unitID in ipairs(Spring.GetAllUnits()) do
		local teamID = Spring.GetUnitTeam(unitID)
		local unitDefID = Spring.GetUnitDefID(unitID)
		gadget:UnitCreated(unitID, unitDefID, teamID)
	end
end

else
--	UNSYNCED

end

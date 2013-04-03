function gadget:GetInfo()
	return {
		name      = "Turn Command",
		desc      = "Implements Turn command for vehicles",
		author    = "FLOZi, yuritch", -- yuritch is magical
		date      = "5/02/10",
		license   = "PD",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

-- SyncedCtrl
local SetUnitCOBValue = Spring.SetUnitCOBValue
-- SyncedRead
local GetUnitCOBValue = Spring.GetUnitCOBValue
local GetUnitPosition = Spring.GetUnitPosition
-- Constants
local CMD_TURN = GG.CustomCommands.GetCmdID("CMD_TURN")
local COB_ANGULAR = 182

local turnCmdDesc = {
	id = CMD_TURN,
	type = CMDTYPE.ICON_MAP,
	name = "   Turn    ",
	action = "turn",
	tooltip = "Turn to face a given point",
	cursor = "Patrol",
}

-- Variables
local turning = {} -- structure: turning = {unitID={turnRate=number COB units to rotate per frame, numFrames=number of frames left to rotate in, currHeading= current heading}}

if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

local function StartTurn(unitID, unitDefID, tx, tz)
	local ud = UnitDefs[unitDefID]
	local turnRate = ud.turnRate
	local ux, _, uz = GetUnitPosition(unitID)
	local dx, dz = tx - ux, tz - uz

	local newHeading = math.deg(math.atan2(dx, dz)) * COB_ANGULAR	
	local currHeading = GetUnitCOBValue(unitID, COB.HEADING)
	local deltaHeading = newHeading - currHeading;
	--  find the direction for shortest turn
	if deltaHeading > (180 * COB_ANGULAR) then deltaHeading = deltaHeading - (360 * COB_ANGULAR) end
	if deltaHeading < (-180 * COB_ANGULAR) then deltaHeading = deltaHeading + (360 * COB_ANGULAR) end
	-- how many frames the turn should take
	local numFrames = deltaHeading / turnRate
	if numFrames < 0 then
		numFrames = -numFrames
		turnRate = - turnRate
	end
	local turnTable = {}
	turnTable["turnRate"] = turnRate
	turnTable["numFrames"] = numFrames
	turnTable["currHeading"] = currHeading
	turning[unitID] = turnTable
end

function gadget:GameFrame(n)
	for unitID, turnTable in pairs(turning) do
		if turnTable.numFrames > 0 then
			turnTable.currHeading = turnTable.currHeading + turnTable.turnRate
			if turnTable.currHeading < -180 * COB_ANGULAR then turnTable.currHeading = turnTable.currHeading + 360 * COB_ANGULAR end
			if turnTable.currHeading > 180 * COB_ANGULAR then turnTable.currHeading = turnTable.currHeading - 360 * COB_ANGULAR end
			turnTable.numFrames = turnTable.numFrames - 1
			SetUnitCOBValue(unitID, COB.HEADING, turnTable.currHeading)
		end
	end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if ud.customParams.hasturnbutton then
		Spring.InsertUnitCmdDesc(unitID, 500, turnCmdDesc)
	end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	local ud = UnitDefs[unitDefID]
	if cmdID == CMD_TURN and not ud.customParams.hasturnbutton then
		return false
	end
	turning[unitID] = nil -- Abort turn if another command issued directly (not queued)
	return true
end

function gadget:CommandFallback(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
	local ud = UnitDefs[unitDefID]
	if cmdID == CMD_TURN then
		if turning[unitID] == nil then
			local tx, _, tz = cmdParams[1], cmdParams[2], cmdParams[3]
			StartTurn(unitID, unitDefID, tx, tz)
			return true, false -- start turn and continue
		else
			if turning[unitID].numFrames > 0 then
				return true, false -- still turning
			else
				turning[unitID] = nil
				return true, true -- turn finished
			end
		end
	end
	return false
end

else
-- UNSYNCED
function gadget:Initialize()
	Spring.SetCustomCommandDrawData(CMD_TURN, "Patrol", {0,1,0,.8})
	Spring.SendCommands({"bind t turn"})
end

end

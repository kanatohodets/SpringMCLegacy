-- Common pieces
local base = piece ("base")
local crate_base, crate_top, crate_right, crate_left, crate_front, crate_back = piece ("crate_base", "crate_top", "crate_right", "crate_left", "crate_front", "crate_back")
-- C3 pieces
local antennarot, antenna1, antenna2, antenna3, emitter, geo = piece ("antennarot", "antenna1", "antenna2", "antenna3", "emitter", "geo")
-- Mechbay pieces
local rampr, rampl, ramprfoldrear, ramprfoldfront, ramplfoldrear, ramplfoldfront = piece ("rampr", "rampl", "ramprfoldrear", "ramprfoldfront", "ramplfoldrear", "ramplfoldfront")
local supportrlower, supportllower, supportrupper, supportlupper = piece ("supportrlower", "supportllower", "supportrupper", "supportlupper")
local ramprtoolupper, ramprtoolmid, ramprtoollower, ramprtoolfinger1, ramprtoolfinger2 = piece ("ramprtoolupper", "ramprtoolmid", "ramprtoollower", "ramprtoolfinger1", "ramprtoolfinger2")
local rampltoolupper, rampltoolmid, rampltoollower, rampltoolfinger1, rampltoolfinger2 = piece ("rampltoolupper", "rampltoolmid", "rampltoollower", "rampltoolfinger1", "rampltoolfinger2")
-- Orbital Uplink pieces
local antennabase, antennamast, antennareceiver, antennapole = piece ("antennabase", "antennamast", "antennareceiver", "antennapole")
local dishs = {}
for i = 1, 15 do
	dishs[i] = piece("dish" .. i)
end

-- Constants
local unitDefID = Spring.GetUnitDefID(unitID)
local unitDef = UnitDefs[unitDefID]
local name = unitDef.name
local rad = math.rad
local CRATE_SPEED = math.rad(50)
local RANDOM_ROT = math.random(-180, 180)

function script.Create()
	Sleep(100) -- wait a few frames
	if not Spring.GetUnitTransporter(unitID) then
		Unloaded()
	end
end

function Unloaded()
	StartThread(Unpack)
end

function Unpack()
	-- Wait for delivery van to bug out
	Sleep(2000)
	-- Unpack the crate
	Turn(crate_front, x_axis, rad(45), CRATE_SPEED)
	Turn(crate_back, x_axis, rad(-45), CRATE_SPEED)
	Turn(crate_left, z_axis, rad(45), CRATE_SPEED)
	Turn(crate_right, z_axis, rad(-45), CRATE_SPEED)
	WaitForTurn(crate_right, z_axis)
	WaitForTurn(crate_left, z_axis)
	WaitForTurn(crate_back, x_axis)
	WaitForTurn(crate_front, x_axis)
	Turn(crate_front, x_axis, rad(90), CRATE_SPEED * 2)
	Turn(crate_back, x_axis, rad(-90), CRATE_SPEED * 2)
	Turn(crate_left, z_axis, rad(90), CRATE_SPEED * 2)
	Turn(crate_right, z_axis, rad(-90), CRATE_SPEED * 2)
	WaitForTurn(crate_right, z_axis)
	WaitForTurn(crate_left, z_axis)
	WaitForTurn(crate_back, x_axis)
	WaitForTurn(crate_front, x_axis)
	Turn(crate_top, z_axis, rad(-45), CRATE_SPEED)
	WaitForTurn(crate_top, z_axis)
	Turn(crate_top, z_axis, rad(-90), CRATE_SPEED * 2)
	
	-- Begin upgrade-specific anims
	if name == "upgrade_c3array" then
		Move(emitter, y_axis, 30, CRATE_SPEED * 5)
		Turn(antennarot, x_axis, rad(-90), CRATE_SPEED)
		WaitForTurn(antennarot, x_axis)
		Move(antenna1, z_axis, 20, CRATE_SPEED * 10)
		Move(antenna2, z_axis, 20, CRATE_SPEED * 10)
		Move(antenna3, z_axis, 20, CRATE_SPEED * 10)
		WaitForMove(emitter, y_axis)
		Spin(geo, y_axis, math.rad(20), math.rad(5))
		-- We're deployed, grant the extra tonnage
		Spring.AddTeamResource(Spring.GetUnitTeam(unitID), "energy", 200)
	elseif name == "upgrade_mechbay" then
		Move(rampr, x_axis, 10, CRATE_SPEED * 10)
		Move(ramprtoolupper, x_axis, 10, CRATE_SPEED * 5)
		Move(rampl, x_axis, -10, CRATE_SPEED * 10)
		Move(rampltoolupper, x_axis, -10, CRATE_SPEED * 5)
		Sleep(100)
		Turn(ramprtoolupper, x_axis, rad(90), CRATE_SPEED)
		Turn(rampltoolupper, x_axis, rad(-90), CRATE_SPEED)
		Turn(ramprtoolmid, z_axis, rad(-70), CRATE_SPEED)
		Turn(rampltoolmid, z_axis, rad(70), CRATE_SPEED)
		Turn(ramprtoollower, x_axis, rad(-90), CRATE_SPEED)
		Turn(rampltoollower, x_axis, rad(90), CRATE_SPEED)
		Turn(ramprtoolfinger1, y_axis, rad(-45), CRATE_SPEED)
		Turn(ramprtoolfinger2, y_axis, rad(45), CRATE_SPEED)
		Turn(rampltoolfinger1, y_axis, rad(-30), CRATE_SPEED)
		Turn(rampltoolfinger2, y_axis, rad(30), CRATE_SPEED)
		Move(supportrupper, y_axis, 22, CRATE_SPEED * 10)
		Move(supportlupper, y_axis, 22, CRATE_SPEED * 10)
		Sleep(100)
		Turn(ramplfoldfront, x_axis, rad(179), CRATE_SPEED)
		Turn(ramprfoldfront, x_axis, rad(179), CRATE_SPEED)
		Turn(ramplfoldrear, x_axis, rad(-179), CRATE_SPEED)
		Turn(ramprfoldrear, x_axis, rad(-179), CRATE_SPEED)
	elseif name == "upgrade_uplink" then
		Move(antennabase, z_axis, -15, CRATE_SPEED * 5)
		Turn(antennamast, x_axis, rad(90), CRATE_SPEED)
		Turn(antennareceiver, x_axis, rad(-45), CRATE_SPEED * 2)
		WaitForTurn(antennamast, x_axis)
		WaitForTurn(antennareceiver, x_axis)
		Move(antennapole, y_axis, 10, CRATE_SPEED * 10)
		for i = 2,15 do
			Turn(dishs[i], y_axis, rad(24), CRATE_SPEED / 4)
		end
		Turn(antennabase, y_axis, rad(RANDOM_ROT), CRATE_SPEED)
	end
	
	-- Let the sands of time cover the crate
	Sleep(10000)
	Move(crate_base, y_axis, -5, CRATE_SPEED)
	Sleep (5000)
	RecursiveHide(crate_base, true)
end

function script.Killed(recentDamage, maxHealth)
end
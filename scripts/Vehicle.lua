-- Vehicle Script
-- useful global stuff
unitDefID = Spring.GetUnitDefID(unitID)
unitDef = UnitDefs[unitDefID]
info = GG.lusHelper[unitDefID]

-- localised API functions
local SetUnitRulesParam = Spring.SetUnitRulesParam
local GetUnitSeparation = Spring.GetUnitSeparation
local GetUnitCommands   = Spring.GetUnitCommands
local GetUnitLastAttackedPiece = Spring.GetUnitLastAttackedPiece
-- localised GG functions
local GetUnitDistanceToPoint = GG.GetUnitDistanceToPoint
local GetUnitUnderJammer = GG.GetUnitUnderJammer
local IsUnitNARCed = GG.IsUnitNARCed
function PlaySound(sound, volume, channel)
	GG.PlaySoundAtUnit(unitID, sound, volume, channel)
end

-- includes
include "smokeunit.lua"

-- Info from lusHelper gadget
local heatLimit = info.heatLimit
local coolRate = info.coolRate * 2
local inWater = false
local missileWeaponIDs = info.missileWeaponIDs
local jammableIDs = info.jammableIDs
local launcherIDs = info.launcherIDs
local barrelRecoils = info.barrelRecoilDist
local burstLengths = info.burstLengths
local firingHeats = info.firingHeats
local ammoTypes = info.ammoTypes
local minRanges = info.minRanges
local spinSpeeds = info.spinSpeeds
local maxAmmo = info.maxAmmo
local currAmmo = {} -- copy maxAmmo table into currAmmo
for k,v in pairs(maxAmmo) do 
	currAmmo[k] = v 
	SetUnitRulesParam(unitID, "ammo_" .. k .. "_limit", v)
end
local amsID = info.amsID
local hover = info.hover
local vtol = info.vtol
local aero = info.aero
local turretIDs = info.turretIDs
local limbHPs = {}
for k,v in pairs(info.limbHPs) do -- copy table from defaults
	limbHPs[k] = v
end

--Turning/Movement Locals
local TURRET_SPEED = info.turretTurnSpeed
local TURRET_2_SPEED = info.turret2TurnSpeed
local ELEVATION_SPEED = info.elevationSpeed
local BARREL_SPEED = info.barrelRecoilSpeed
local WHEEL_SPEED = info.wheelSpeed
local WHEEL_ACCEL = info.wheelAccel
local RESTORE_DELAY = Spring.UnitScript.GetLongestReloadTime(unitID) * 2

local currLaunchPoint = 1
local currHeatLevel = 0

--piece defines
local body, turret = piece ("body", "turret")

local wheels = {}
local trackr, trackl, wakepoint, rotor
if hover then
	wakepoint = piece ("wakepoint")
elseif vtol then
	rotor = piece ("rotor")
elseif aero then
	--what?!?!
else
	trackr, trackl = piece ("trackr", "trackl")
	for i = 1, info.numWheels do
		wheels[i] = piece ("wheel"..i)
	end
end

local flares = {}
local turrets = info.turrets
local mantlets = {}
local barrels = {}
local launchers = {}
local launchPoints = {}
local currPoints = {}
local spinPieces = {}
local spinPiecesState = {}
for weaponID = 1, info.numWeapons do
	if missileWeaponIDs[weaponID] then
		if launcherIDs[weaponID] then
			launchers[weaponID] = piece("launcher_" .. weaponID)
		end
		launchPoints[weaponID] = {}
		currPoints[weaponID] = 1
		for i = 1, burstLengths[weaponID] do
			launchPoints[weaponID][i] = piece("launchpoint_" .. weaponID .. "_" .. i)
		end	
	elseif weaponID ~= amsID then
		flares[weaponID] = piece ("flare_" .. weaponID)
	end
	--[[if info.turretIDs[weaponID] then
		turrets[weaponID] = piece("turret_" .. weaponID)
	end]]
	if info.mantletIDs[weaponID] then
		mantlets[weaponID] = piece("mantlet_" .. weaponID)
	end
	if spinSpeeds[weaponID] then
		spinPieces[weaponID] = piece("barrels_" .. weaponID)
		spinPiecesState[weaponID] = false
	elseif info.barrelIDs[weaponID] then
		barrels[weaponID] = piece("barrel_" .. weaponID)
	end
end

local function RestoreAfterDelay(unitID)
	Sleep(RESTORE_DELAY)
	if turret then
		Turn(turret, y_axis, 0, TURRET_SPEED)
	end
	for id in pairs(mantlets) do
		Turn(mantlets[id], x_axis, 0, ELEVATION_SPEED)
	end
	for id in pairs(launchers) do
		Turn(launchers[id], x_axis, 0, ELEVATION_SPEED)
	end
end

-- non-local function called by gadgets/game_ammo.lua
function ChangeAmmo(ammoType, amount) 
	local newAmmoLevel = currAmmo[ammoType] + amount
	if newAmmoLevel <= maxAmmo[ammoType] then
		currAmmo[ammoType] = newAmmoLevel
		SetUnitRulesParam(unitID, "ammo_" .. ammoType, newAmmoLevel)
		return true -- Ammo was changed
	end
	return false -- Ammo was not changed
end

local function SpinBarrels(weaponID, start)
	Signal(spinSpeeds)
	SetSignalMask(spinSpeeds)
	if start  then
		Spin(spinPieces[weaponID], z_axis, spinSpeeds[weaponID], spinSpeeds[weaponID] / 5)
	else
		Sleep(2000)
		StopSpin(spinPieces[weaponID], z_axis, spinSpeeds[weaponID]/10)
	end
	spinPiecesState[weaponID] = start -- must come after the Sleep
end

local function CoolOff()
	local max = math.max
	-- localised API functions
	local GetGameFrame = Spring.GetGameFrame
	local GetGroundHeight = Spring.GetGroundHeight
	local GetUnitBasePosition = Spring.GetUnitBasePosition
	local SetUnitWeaponState = Spring.SetUnitWeaponState
	-- lusHelper info
	local reloadTimes = info.reloadTimes
	local numWeapons = info.numWeapons
	local baseCoolRate = info.coolRate
	-- variables	
	local heatElevatedLimit = 0.5 * heatLimit
	local heatElevated = false
	local heatCritical = false
	while true do
		if inWater then
			local x, _, z = GetUnitBasePosition(unitID)
			local depth = max(4, GetGroundHeight(x, z) / -3)
			coolRate = baseCoolRate * depth
		end
		currHeatLevel = currHeatLevel - coolRate
		if currHeatLevel < 0 then 
			currHeatLevel = 0 
		end
		if currHeatLevel > heatLimit then 
			if not heatCritical then -- either elevated->critical or normal->critical
				heatElevated = false
				heatCritical = true
				-- halt weapon fire here
				for weaponID = 1, numWeapons do
					SetUnitWeaponState(unitID, weaponID, {reloadTime = 99999, reloadFrame = 99999})
				end
			end
		elseif currHeatLevel > heatElevatedLimit then
			if heatCritical and not heatElevated then -- critical -> elevated
				heatElevated = true
			elseif not heatElevated then -- normal -> elevated
				heatElevated = true
				-- reduce weapon rate here
				for weaponID = 1, numWeapons do
					local reload = reloadTimes[weaponID] * 2
					SetUnitWeaponState(unitID, weaponID, {reloadTime = reload})
				end
			end
		else
			if heatCritical then -- critical->elevated->normal
				-- reset weapon rate here
				for weaponID = 1, numWeapons do
					local currFrame = GetGameFrame()
					SetUnitWeaponState(unitID, weaponID, {reloadTime = reloadTimes[weaponID], reloadFrame = currFrame + reloadTimes[weaponID] * 30})
				end
			elseif heatElevated then -- elevated->normal
				-- reset weapon rate here
				for weaponID = 1, numWeapons do
					SetUnitWeaponState(unitID, weaponID, {reloadTime = reloadTimes[weaponID]})
				end
			end
			heatCritical = false
			heatElevated = false
		end
		SetUnitRulesParam(unitID, "heat", currHeatLevel)
		Sleep(1000) -- cools once per second
	end
end

function script.setSFXoccupy(terrainType)
	if terrainType == 2 or terrainType == 1 then -- water
		inWater = true
	else
		inWater = false
		coolRate = info.coolRate * 2
	end
end

function SmokeLimb(limb, piece)
	local maxHealth = info.limbHPs[limb] / 100
	while true do
		local health = limbHPs[limb]/maxHealth
		if (health <= 66) then -- only smoke if less then 2/3rd limb maxhealth left
			EmitSfx(piece, SFX.CEG + info.numWeapons + 2)
			EmitSfx(piece, SFX.CEG + info.numWeapons + 3)
		end
		Sleep(20*health + 150)
	end
end

function hideLimbPieces(limb)
	if limb == "turret" then
		RecursiveHide(turret)
		EmitSfx(turret, SFX.CEG + info.numWeapons + 1)
		Explode(turret, SFX.FIRE + SFX.SMOKE)
		for id, valid in pairs(turretIDs) do
			if valid then
				local weapDef = WeaponDefs[unitDef.weapons[id].weaponDef]
				Spring.Echo(unitDef.humanName .. ": " .. weapDef.name .. " destroyed!")
			end
		end
	else -- asumme limb is a wing or rotor
		local wingPiece = piece(limb) -- asuume pieces are lwing, rwing, rotor
		RecursiveHide(wingPiece)
		EmitSfx(wingPiece, SFX.CEG + info.numWeapons + 1)
		Explode(wingPiece, SFX.FIRE + SFX.SMOKE)
		SetUnitValue(COB.CRASHING, 1)
	end
end

function limbHPControl(limb, damage)
	local currHP = limbHPs[limb]
	if currHP > 0 then
		local newHP = limbHPs[limb] - damage
		--Spring.Echo(unitDef.name, limb, newHP)
		if newHP < 0 then 
			hideLimbPieces(limb)
			newHP = 0
		end
		limbHPs[limb] = newHP
	end
end

function script.HitByWeapon(x, z, weaponID, damage)
	local wd = WeaponDefs[weaponID]
	if not wd then return damage end
	local heatDamage = wd.customParams.heatdamage or 0
	--Spring.Echo(wd.customParams.heatdamage)
	currHeatLevel = currHeatLevel + heatDamage
	SetUnitRulesParam(unitID, "heat", currHeatLevel)
	local hitPiece = GetUnitLastAttackedPiece(unitID) or ""
	Spring.Echo("HIT ON ", hitPiece)
	if hitPiece == "body" then 
		return damage
	elseif hitPiece == "turret" or hitPiece == "launcher_1" or hitPiece == "turret_2" then
		--deduct Turret HP
		limbHPControl("turret", damage)
	elseif hitPiece == "lwing" or hitPiece == "rwing" or hitPiece == "rotor" then
		limbHPControl(hitPiece, damage) -- asumes wings are single pieces
	end
	return 0
end

function script.Create()
	StartThread(SmokeUnit, {body})
	StartThread(SmokeLimb, "turret", turret)
	StartThread(CoolOff)
	if rotor then
		Spin(rotor, y_axis, 20 * WHEEL_SPEED, WHEEL_ACCEL)
	end
end

function script.StartMoving()
	for i = 1, #wheels do
		Spin(wheels[i], x_axis, WHEEL_SPEED, WHEEL_ACCEL)
	end
end

function script.StopMoving()
	for i = 1, #wheels do
		StopSpin(wheels[i], x_axis, WHEEL_ACCEL)
	end
end

function script.Activate()
	Spring.SetUnitStealth(unitID, false)
end

function script.Deactivate()
	Spring.SetUnitStealth(unitID, true)
end

local function WeaponCanFire(weaponID)
	if weaponID == amsID then
		return true
	end
	-- TODO: Disable turret weapons, will require recursively checking parents or children?
	if turretIDs[weaponID] and limbHPs["turret"] <= 0 then
		return false
	end
	local ammoType = ammoTypes[weaponID]
	if ammoType and (currAmmo[ammoType] or 0) < (burstLengths[weaponID] or 0) then
		if spinSpeeds[weaponID] then
			StartThread(SpinBarrels, weaponID, false)
		end
		return false
	else
		if spinSpeeds[weaponID] and not spinPiecesState[weaponID] then
			StartThread(SpinBarrels, weaponID, true)
		end
		return true
	end
end

function script.AimWeapon(weaponID, heading, pitch)
	Signal(2 ^ weaponID) -- 2 'to the power of' weapon ID
	SetSignalMask(2 ^ weaponID)
	-- use a weapon-specific turret if it exists
	if turrets[weaponID] then
		Turn(turrets[weaponID], y_axis, heading, TURRET_2_SPEED)
	elseif turret then -- otherwise use main
		Turn(turret, y_axis, heading, TURRET_SPEED)
	end
	if mantlets[weaponID] then
		Turn(mantlets[weaponID], x_axis, -pitch, TURRET_SPEED)
	elseif missileWeaponIDs[weaponID] then
		if launchers[weaponID] then
			Turn(launchers[weaponID], x_axis, -pitch, ELEVATION_SPEED)
		else
			for i = 1, burstLengths[weaponID] do
				Turn(launchPoints[weaponID][i], x_axis, -pitch, ELEVATION_SPEED)
			end
		end
	else
		Turn(flares[weaponID], x_axis, -pitch, ELEVATION_SPEED)
	end
	if turrets[weaponID] then
		WaitForTurn(turrets[weaponID], y_axis)
	elseif turret then 
		WaitForTurn(turret, y_axis) -- CL_Mars shouldn't really wait here for missiles
	end
	if mantlets[weaponID] then
		WaitForTurn(mantlets[weaponID], x_axis)
	end
	StartThread(RestoreAfterDelay)
	return WeaponCanFire(weaponID)
end

function script.BlockShot(weaponID, targetID, userTarget)
	local jammable = jammableIDs[weaponID]
	if jammable then
		if targetID then
			local jammed = GetUnitUnderJammer(targetID) and (not IsUnitNARCed(targetID))
			if jammed then
				Spring.Echo("Can't fire weapon " .. weaponID .. " as target is jammed")
				return true 
			end
		end
	end
	local minRange = minRanges[weaponID]
	if minRange then
		local distance
		if targetID then
			distance = GetUnitSeparation(unitID, targetID, true)
		elseif userTarget then
			local cmd = GetUnitCommands(unitID, 1)[1]
			if cmd.id == CMD.ATTACK then
				local tx,ty,tz = unpack(cmd.params)
				distance = GetUnitDistanceToPoint(unitID, tx, ty, tz, false)
			end
		end
		if distance < minRange then return true end
	end
	return false
end

function script.FireWeapon(weaponID)
	currHeatLevel = currHeatLevel + firingHeats[weaponID]
	SetUnitRulesParam(unitID, "heat", currHeatLevel)
	if barrels[weaponID] and barrelRecoils[weaponID] then
		Move(barrels[weaponID], z_axis, -barrelRecoils[weaponID], BARREL_SPEED)
		WaitForMove(barrels[weaponID], z_axis)
		Move(barrels[weaponID], z_axis, 0, 10)
	end
	local ammoType = ammoTypes[weaponID]
	if ammoType then
		ChangeAmmo(ammoType, -burstLengths[weaponID])
	end
	if not missileWeaponIDs[weaponID] and weaponID ~= amsID then
		EmitSfx(flares[weaponID], SFX.CEG + weaponID)
	end
end

function script.Shot(weaponID)
	if missileWeaponIDs[weaponID] then
		EmitSfx(launchPoints[weaponID][currPoints[weaponID]], SFX.CEG + weaponID)
        currPoints[weaponID] = currPoints[weaponID] + 1
        if currPoints[weaponID] > burstLengths[weaponID] then 
			currPoints[weaponID] = 1
        end
	end
end

function script.EndBurst(weaponID)
	if spinSpeeds[weaponID] then
		StartThread(SpinBarrels, weaponID, false)
	end
end

function script.AimFromWeapon(weaponID) 
	return turret or body
end

function script.QueryWeapon(weaponID) 
	if missileWeaponIDs[weaponID] then
		return launchPoints[weaponID][currPoints[weaponID]]
	elseif weaponID == amsID then
		return turret
	else
		return flares[weaponID]
	end
end

function script.Killed(recentDamage, maxHealth)
	--local severity = recentDamage / maxHealth * 100
	--if severity <= 25 then
	--	Explode(body, math.bit_or({SFX.BITMAPONLY, SFX.BITMAP1}))
	--	return 1
	--elseif severity <= 50 then
	--	Explode(body, math.bit_or({SFX.FALL, SFX.BITMAP1}))
	--	return 2
	--else
	--	Explode(body, math.bit_or({SFX.FALL, SFX.SMOKE, SFX.FIRE, SFX.EXPLODE_ON_HIT, SFX.BITMAP1}))
	--	return 3
	--end
	return 1
end

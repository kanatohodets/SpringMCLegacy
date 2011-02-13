weaponDef = {
	name                    = "Advanced Tactical Missile-6",
	weaponType              = "MissileLauncher",
	renderType				= 1,
	explosionGenerator    	= "custom:HE_MEDIUM",
--	cegTag					= "BazookaTrail",
	smokeTrail				= true,
	smokeDelay				= "0.05",
	soundHit              	= [[GEN_Explode3]],
	soundStart            	= [[ATM_Fire]],
--	soundTrigger			= 0,
	burnblow				= true, 	--Bullets explode at range limit.
	collideFriendly			= true,
	noSelfDamage            = true,
	turret                  = true,
	range                   = 1800,
	accuracy                = 100,
	wobble					= 700,
	dance					= 80,
	guidance				= true,
	selfprop				= true,
	lineOfSight				= true,
	tracks					= true,
	turnRate				= 4000,
	weaponTimer				= 10,
	areaOfEffect            = 20,
	startVelocity			= 700,
	weaponVelocity          = 900,
	reloadtime              = 10,
	burst					= 6,
	burstrate				= 0.1,
	sprayAngle 				= 100,
	model					= "Missile.s3o",
	interceptedByShieldType	= 1,
	damage = {
		default = 167,--15 DPS
		beacons = 0,
	},
	customparams = {
		heatgenerated		= "60",--6/sec
    },
}

return lowerkeys({ ATM6 = weaponDef })
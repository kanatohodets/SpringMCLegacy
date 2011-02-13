weaponDef = {
	name                    = "Long Range Missile 20",
	weaponType              = "MissileLauncher",
	renderType				= 1,
	explosionGenerator    	= "custom:HE_MEDIUM",
--	cegTag					= "RocketTrail",
	smokeTrail				= true,
	smokeDelay				= "0.05",
	soundHit              	= [[GEN_Explode2]],
	soundStart            	= [[LRM_Fire]],
--	soundTrigger			= 0,
	burnblow				= false, 	--Bullets explode at range limit.
	collideFriendly			= true,
	noSelfDamage            = true,
	turret                  = true,
	range                   = 2100,
	accuracy                = 1000,
	wobble					= 1300,
	dance 					= 100,
	guidance				= true,
	selfprop				= true,
	ballistic				= false,
	trajectoryHeight		= 1,
	tracks					= true,
	turnRate				= 3500,
	flightTime				= 10,
	weaponTimer				= 20,
	areaOfEffect            = 20,
	startVelocity			= 500,
	weaponVelocity          = 700,
	reloadtime              = 10,
	burst					= 15,
	burstrate				= 0.1,
	model					= "Missile.s3o",
	interceptedByShieldType	= 1,
	damage = {
		default = 100,--10 DPS
		beacons = 0,
	},
	customparams = {
		heatgenerated		= "50",--5/sec
    },
}

return lowerkeys({ LRM15 = weaponDef })
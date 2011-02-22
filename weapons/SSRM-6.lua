weaponDef = {
	name                    = "Streak Short Range Missile 6",
	weaponType              = "MissileLauncher",
	renderType				= 1,
	explosionGenerator    	= "custom:HE_MEDIUM",
--	cegTag					= "BazookaTrail",
	smokeTrail				= true,
	smokeDelay				= "0.05",
	soundHit              	= [[GEN_Explode3]],
	soundStart            	= [[SRM_Fire]],
--	soundTrigger			= 0,
	burnblow				= true, 	--Bullets explode at range limit.
	collideFriendly			= true,
	noSelfDamage            = true,
	turret                  = true,
	range                   = 600,
	accuracy                = 100,
	wobble					= 700,
	dance					= 45,
	guidance				= true,
	selfprop				= true,
	lineOfSight				= true,
	tracks					= true,
	turnRate				= 10000,
	weaponTimer				= 5,
	areaOfEffect            = 20,
	startVelocity			= 700,
	weaponVelocity          = 900,
	reloadtime              = 10,
	burst					= 6,
	burstrate				= 0.1,
	sprayAngle 				= 100,
	model					= "Missile.s3o",
	damage = {
		default = 200,--20 DPS
		beacons = 0,
		light = 200,
		medium = 170,
		heavy = 140,
		assault = 100,
		vehicle = 300,
	},
	customparams = {
		heatgenerated		= "40",--4/sec
    },
}

return lowerkeys({ SSRM6 = weaponDef })
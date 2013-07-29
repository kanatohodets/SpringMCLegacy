weaponDef = {
	name                    = "eXperimental Streak Short Range Missile 6 - Disrupted Guidance",
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
	range                   = 800,
	accuracy                = 2000,
	sprayangle				= 8000,
	wobble					= 700,
	dance					= 45,
	guidance				= true,
	selfprop				= true,
	lineOfSight				= true,
	tracks					= true,
	turnRate				= 10000,
	weaponTimer				= 5,
	areaOfEffect            = 20,
	startVelocity			= 1000,
	weaponVelocity          = 600,
	reloadtime              = 7.5,
	burst					= 6,
	burstrate				= 0.1,
	sprayAngle 				= 100,
	model					= "Missile.s3o",
	interceptedByShieldType	= 32,
	damage = {
		default = 150,--10 DPS
	},
	customparams = {
		heatgenerated		= "30",--4/sec
		cegflare			= "MISSILE_MUZZLEFLASH",
		weaponclass			= "missile",
		ammotype			= "srm",
    },
}

return lowerkeys({ xSSRM6 = weaponDef })
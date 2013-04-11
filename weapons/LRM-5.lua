weaponDef = {
	name                    = "Long Range Missile 5",
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
	canAttackGround			= false,
	turret                  = true,
	range                   = 2600,
	accuracy                = 2000,
	sprayangle				= 5000,
	wobble					= 2000,
	dance 					= 100,
	guidance				= true,
	selfprop				= true,
	ballistic				= false,
	trajectoryHeight		= 1,
	tracks					= true,
	turnRate				= 1000,
	flightTime				= 10,
	weaponTimer				= 20,
	areaOfEffect            = 20,
	startVelocity			= 1000,
	weaponVelocity          = 800,
	reloadtime              = 15,
	burst					= 5,
	burstrate				= 0.1,
	model					= "Missile.s3o",
	interceptedByShieldType	= 32,
	damage = {
		default = 150,--10 DPS
	},
	customparams = {
		heatgenerated		= "30", --6/sec
		cegflare			= "MISSILE_MUZZLEFLASH",
		weaponclass			= "missile",
		ammotype			= "lrm",
		minrange			= "500",
    },
}

return lowerkeys({ LRM5 = weaponDef })
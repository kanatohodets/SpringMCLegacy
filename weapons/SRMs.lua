local SRM_Class = Weapon:New{
	weaponType              = "MissileLauncher",
	explosionGenerator    	= "custom:HE_MEDIUM",
	cegTag					= "SRMTrail",
	smokeTrail				= false,
	soundHit              	= "SRM_Hit",
	soundStart            	= "SRM_Fire",
	burnblow				= true, 	--Bullets explode at range limit.
	collideFriendly			= true,
	noSelfDamage            = true,
	turret                  = true,
	range                   = 600,
	accuracy                = 1000,
	sprayangle				= 2000,
	wobble					= 900,
	dance					= 65,
	tracks					= true,
	turnRate				= 2000,
	weaponTimer				= 5,
	areaOfEffect            = 20,
	startVelocity			= 1000,
	weaponVelocity          = 1000,
	reloadtime              = 5,
	burstrate				= 0.1,
	model					= "Missile.s3o",
	damage = {
		default = 100,--10 DPS
	},
	customparams = {
		cegflare			= "MISSILE_MUZZLEFLASH",
		weaponclass			= "missile",
		jammable			= false,
		ammotype			= "srm",
    },
}

local SRM2 = SRM_Class:New{
	name                    = "SRM-2",
	burst					= 2,
	customparams = {
		heatgenerated		= "15",--3/sec
	}
}

local SRM4 = SRM_Class:New{
	name                    = "SRM-4",
	burst					= 4,
	customparams = {
		heatgenerated		= "15",--3/sec
	}
}

local SRM6 = SRM_Class:New{
	name                    = "SRM-6",
	burst					= 6,
	customparams = {
		heatgenerated		= "20",--4/sec
	}
}

return lowerkeys({ 
	SRM2 = SRM2,
	SRM4 = SRM4,
	SRM6 = SRM6,
})
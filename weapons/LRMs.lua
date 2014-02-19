local LRM_Class = Weapon:New{
	weaponType              = "MissileLauncher",
	explosionGenerator    	= "custom:HE_SMALL",
	cegTag					= "LRMTrail",
	soundHit              	= "LRM_Hit",
	soundStart            	= "LRM_Fire",
	burnblow				= false, 	--Bullets explode at range limit.
	collideFriendly			= true,
	noSelfDamage            = true,
	turret                  = true,
	range                   = 3000,
	accuracy                = 2000,
	sprayangle				= 5000,
	wobble					= 2000,
	dance 					= 100,
	trajectoryHeight		= 1,
	tracks					= true,
	turnRate				= 2500,
	flightTime				= 10,
	weaponTimer				= 20,
	areaOfEffect            = 20,
	startVelocity			= 600,
	weaponVelocity          = 800,
	reloadtime              = 15,
	burstrate				= 0.1,
	model					= "Missile.s3o",
	damage = {
		default = 150,--10 DPS
	},
	customparams = {
		cegflare			= "MISSILE_MUZZLEFLASH",
		lupsribbon			= {size = 1, width = 2, color = {0.95, 0.65, 0,0.6}},
		weaponclass			= "missile",
		ammotype			= "lrm",
		minrange			= 500,
    },
}

local LRM5 = LRM_Class:New{
	name                    = "LRM-5",
	burst					= 5,
	customparams = {
		heatgenerated		= 30, --6/sec
	},
}

local LRM10 = LRM_Class:New{
	name                    = "LRM-10",
	burst					= 10,
	customparams = {
		heatgenerated		= 60, --6/sec
    },
}	

local LRM15 = LRM_Class:New{
	name                    = "LRM-15",
	burst					= 15,
	customparams = {
		heatgenerated		= 75, --6/sec
    },
}

local LRM20 = LRM_Class:New{
	name                    = "LRM-20",
	burst					= 20,
	customparams = {
		heatgenerated		= 90, --6/sec
    },
}

return lowerkeys({ 
	LRM5 = LRM5,
	LRM10 = LRM10,
	LRM15 = LRM15,
	LRM20 = LRM20,
})
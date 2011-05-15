weaponDef = {
	name                    = "Gauss Rifle",
	weaponType              = "Cannon",
	explosionGenerator    	= "custom:HE_SMALL",
	cegTag					= "RailTrail",
	soundHit              	= [[GEN_Explode1]],
	soundStart            	= [[Gauss_Fire]],
	burnblow				= false, 	--Bullets explode at range limit.
	collideFriendly			= true,
	noSelfDamage            = true,
	turret                  = true,
	ballistic				= 1,
	range                   = 2200,
	accuracy                = 10,
	targetMoveError			= 0.01,
	areaOfEffect            = 5,
	weaponVelocity          = 2500,
	reloadtime              = 6,
	renderType				= 1,
	size					= 2,
	sizeDecay				= 0,
	separation				= 2, 		--Distance between each plasma particle.
	stages					= 250, 		--Number of particles used in one plasma shot.
--	AlphaDecay				= 0.05, 		--How much a plasma particle is more transparent than the previous particle. 
	rgbcolor				= "0.75 0.75 1.0",
	intensity				= 0.5,
	damage = {
		default = 900, --150 DPS
		beacons = 0,
		light = 900,
		medium = 810, --90%
		heavy = 720, --80%
		assault = 630, --70%
		vehicle = 1350, --150%
		vtol = 1350, --150%
	},
	customparams = {
		heatgenerated		= "6",--1/s
		cegflare			= "GAUSS_MUZZLEFLASH",
    },
}

return lowerkeys({ Gauss = weaponDef })
weaponDef = {
	name                    = "Small Pulse Laser",
	weaponType              = "BeamLaser",
	beamLaser				= true,
	beamLaser				= 1,
--	beamWeapon				= true,
--	largeBeamLaser			= true,
	renderType				= 0,
	lineOfSight				= true,
	explosionGenerator    	= "custom:AP_SMALL",
	soundHit              	= [[GEN_Pulse_Explode1]],
	soundStart           	= [[SPL_Fire]],
	burnblow				= true, 	--Bullets explode at range limit.
	collideFriendly			= true,
	noSelfDamage            = true,
	turret                  = true,
	range                   = 300,
	accuracy                = 10,
	tollerance				= 100,
	areaOfEffect            = 5,
	weaponVelocity          = 2000,
	weaponTimer				= 0.8,
	reloadtime              = 0.33,
	size 					= 0.075,
	laserFlareSize			= 0.075,
	thickness				= 0.75,
	coreThickness			= 0.075,
	beamDecay          		= 1,
	beamTime           		= 0.01,
	beamTTL           		= 1,
	minIntensity			= 1,
	rgbcolor				= "1.0 0.4 0.4",
	intensity				= 0.5,
	damage = {
		default = 9, --30 DPS
		beacons = 0,
		light = 9,
		medium = 7.65,
		heavy = 6.3,
		assault = 4.5,
		vehicle = 13.5,
	},
	customparams = {
		heatgenerated		= "0.66",--2/sec
		cegflare			= "SPL_MUZZLEFLASH",
    },
}

return lowerkeys({ SPL = weaponDef })
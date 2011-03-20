local CL_Huit = {
	name              	= "Huitzilopochtli",
	description         = "Heavy Artillery Support Vehicle",
	objectName        	= "CL_Huit.s3o",
	script				= "CL_Huit.lua",
	explodeAs          	= "mechexplode",
	category 			= "tank ground notbeacon",
	sightDistance       = 800,
	radarDistance      	= 1500,
		activateWhenBuilt   = true,
		onoffable           = true,
	maxDamage           = 2750,
	mass                = 8500,
	footprintX			= 2,
	footprintZ 			= 2,
	collisionVolumeType = "box",
	collisionVolumeScales = "24 18 38",
	collisionVolumeOffsets = "0 1 0",
	collisionVolumeTest = 1,
	leaveTracks			= 1,
	trackOffset			= 10,--no idea what this does
	trackStrength		= 8.5,--how visible the tracks are
	trackStretch		= 1,-- how much the tracks stretch, the higher the number the more "compact" they become
	trackType			= "Thin",--graphics file to use for the track decal, from \bitmaps\tracks\ folder
	trackWidth			= 22,--width to render the decal
	buildCostEnergy     = 0,
	buildCostMetal      = 7500,
	buildTime           = 0,
	canMove				= true,
		movementClass   = "TANK",
		maxVelocity		= 1.06, --32kph/30
		maxReverseVelocity= 0.8,
		acceleration    = 0.9,
		brakeRate       = 0.1,
		turnRate 		= 500,
	
	canAttack 			= true,
		--Makes unit use weapon from /weapons folder
		weapons 		= {	
			[1] = {
				name	= "ArrowIV",
				OnlyTargetCategory = "notbeacon",
			},
			[2] = {
				name	= "ArrowIV",
				OnlyTargetCategory = "notbeacon",
				WeaponSlaveTo = 1,
			},
			[3] = {
				name	= "CMPL",
				OnlyTargetCategory = "notbeacon",
				WeaponSlaveTo = 1,
			},
			[3] = {
				name	= "CMPL",
				OnlyTargetCategory = "notbeacon",
				WeaponSlaveTo = 1,
			},
		},
	--Gets CEG effects from /gamedata/explosions folder
	sfxtypes = {
		explosiongenerators = {
		"custom:ARROW_MUZZLEFLASH",
		"custom:LASER_MUZZLEFLASH",
		},
	},
	customparams = {
		hasturnbutton	= "1",
		helptext		= "Armament: 2 x Arrow IV Artillery Missle, 2 x Medium Pulse Laser - Armor: 5.5 tons",
    },
}

return lowerkeys({ ["CL_Huit"] = CL_Huit })
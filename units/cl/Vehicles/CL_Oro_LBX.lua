local CL_Oro_LBX = {
	name              	= "Oro (LBX/20)",
	description         = "Medium Brawler Tank",
	objectName        	= "CL_Oro_LBX.s3o",
	script				= "CL_Oro_LBX.lua",
	explodeAs          	= "mechexplode",
	category 			= "tank ground notbeacon",
	sightDistance       = 800,
	radarDistance      	= 1500,
		activateWhenBuilt   = true,
		onoffable           = true,
	maxDamage           = 2750,--5500
	mass                = 6500,
	footprintX			= 3,
	footprintZ 			= 3,
	collisionVolumeType = "box",
	collisionVolumeScales = "30 20 48",
	collisionVolumeOffsets = "0 3 0",
	collisionVolumeTest = 1,
	leaveTracks			= 1,
	trackOffset			= 10,--no idea what this does
	trackStrength		= 6.5,--how visible the tracks are
	trackStretch		= 1,-- how much the tracks stretch, the higher the number the more "compact" they become
	trackType			= "Thick",--graphics file to use for the track decal, from \bitmaps\tracks\ folder
	trackWidth			= 24,--width to render the decal
	buildCostEnergy     = 65,
	buildCostMetal      = 3000,
	buildTime           = 0,
	canMove				= true,
		movementClass   = "TANK",
		maxVelocity		= 2.13, --64kph/30
		maxReverseVelocity= 1.5,
		acceleration    = 0.8,
		brakeRate       = 0.1,
		turnRate 		= 400,
	
	canAttack 			= true,
		--Makes unit use weapon from /weapons folder
		weapons 		= {	
			[1] = {
				name	= "LBX20",
				OnlyTargetCategory = "notbeacon",
			},
			[2] = {
				name	= "CLPL",
				OnlyTargetCategory = "notbeacon",
				WeaponSlaveTo = 1,
			},
			[3] = {
				name	= "CERMBL",
				OnlyTargetCategory = "notbeacon",
				WeaponSlaveTo = 1,
			},
		},
	--Gets CEG effects from /gamedata/explosions folder
	sfxtypes = {
		explosiongenerators = {
		"custom:AC20_MUZZLEFLASH",
		"custom:LASER_MUZZLEFLASH",
		},
	},
	customparams = {
		hasturnbutton	= "1",
		helptext		= "Armament: 1 x LBX Autocannon/20, 1 x Large Pulse Laser, 1 x ER Medium Beam Laser - Armor: 11 tons",
    },
}

return lowerkeys({ ["CL_Oro_LBX"] = CL_Oro_LBX })
local CL_Morrigu = {
	name              	= "Morrigu",
	description         = "Heavy Sniper Tank",
	objectName        	= "CL_Morrigu.s3o",
	script				= "CL_Morrigu.lua",
	explodeAs          	= "mechexplode",
	category 			= "tank ground notbeacon",
	sightDistance       = 800,
	radarDistance      	= 1500,
		activateWhenBuilt   = true,
		onoffable           = true,
	maxDamage           = 6500,
	mass                = 8000,
	footprintX			= 3,
	footprintZ 			= 3,
	collisionVolumeType = "box",
	collisionVolumeScales = "28 25 50",
	collisionVolumeOffsets = "0 2 0",
	collisionVolumeTest = 1,
	leaveTracks			= 1,
	trackOffset			= 10,--no idea what this does
	trackStrength		= 8,--how visible the tracks are
	trackStretch		= 1,-- how much the tracks stretch, the higher the number the more "compact" they become
	trackType			= "Thick",--graphics file to use for the track decal, from \bitmaps\tracks\ folder
	trackWidth			= 28,--width to render the decal
	buildCostEnergy     = 80,
	buildCostMetal      = 6750,
	buildTime           = 0,
	canMove				= true,
		movementClass   = "TANK",
		maxVelocity		= 1.8, --54kph/30
		maxReverseVelocity= 1.6,
		acceleration    = 0.9,
		brakeRate       = 0.1,
		turnRate 		= 350,
	
	canAttack 			= true,
		--Makes unit use weapon from /weapons folder
		weapons 		= {	
			[1] = {
				name	= "CERLBL",
				OnlyTargetCategory = "notbeacon",
			},
			[2] = {
				name	= "CERLBL",
				OnlyTargetCategory = "notbeacon",
				WeaponSlaveTo = 1,
			},
			[3] = {
				name	= "LRM15",
				OnlyTargetCategory = "notbeacon",
				WeaponSlaveTo = 1,
			},
			[4] = {
				name	= "LRM15",
				OnlyTargetCategory = "notbeacon",
				WeaponSlaveTo = 1,
			},
		},
	--Gets CEG effects from /gamedata/explosions folder
	sfxtypes = {
		explosiongenerators = {
		"custom:MISSILE_MUZZLEFLASH",
		"custom:LASER_MUZZLEFLASH",
		},
	},
	customparams = {
		hasturnbutton	= "1",
		helptext		= "Armament: 2 x ER Large Beam Laser, 2 x LRM-15 - Armor: 13 tons",
    },
}

return lowerkeys({ ["CL_Morrigu"] = CL_Morrigu })
local IS_Chimera = {
	name              	= "Chimera",
	description         = "Medium Combat Mech",
	objectName        	= "IS_Chimera.s3o",
	script				= "IS_Chimera.lua",
	category 			= "mech ground",
	sightDistance       = 1000,
	radarDistance      	= 1500,
		activateWhenBuilt   = true,
		onoffable           = true,
	maxDamage           = 7000,
	mass                = 4000,
	footprintX			= 2,
	footprintZ 			= 2,
	collisionVolumeType = "box",
	collisionVolumeScales = "30 50 25",
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeTest = 1,
--	leaveTracks			= 1,
--	trackOffset			= 10,--no idea what this does
--	trackStrength		= 2.5,--how visible the tracks are
--	trackStretch		= 1,-- how much the tracks stretch, the higher the number the more "compact" they become
--	trackType			= "Thick",--graphics file to use for the track decal, from \bitmaps\tracks\ folder
--	trackWidth			= 20,--width to render the decal
	buildCostEnergy     = 0,
	buildCostMetal      = 3500,
	buildTime           = 0,
	upright				= true,
	canMove				= true,
		movementClass   = "SMALLMECH",
		maxVelocity		= 4.85, --97kph/10/2
		maxReverseVelocity= 3.0,
		acceleration    = 1.5,
		brakeRate       = 0.1,
		turnRate 		= 800,
		smoothAnim		= 1,
	
	canAttack 			= true,
		--Makes unit use weapon from /weapons folder
		weapons 		= {	
			[1] = {
				name	= "LPL",
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[2] = {
				name	= "CMPL",
				--weaponSlaveTo2 = 1,
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[3] = {
				name	= "CMPL",
				--weaponSlaveTo2 = 1,
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[4] = {
				name	= "MRM10",
				--weaponSlaveTo4 = 1,
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
		},
		
	--Gets CEG effects from /gamedata/explosions folder

	sfxtypes = {
		explosiongenerators = {
		"custom:MEDIUM_MUZZLEFLASH",
		"custom:MG_MUZZLEFLASH",
		},
	},
    customparams = {
		hasturnbutton	= "1",
		helptext		= "Armament: 1 x Large Pulse Laser, 2 x ER Medium Pulse Laser, 1 x MRM-10 - Armor: 7 tons",
    },
}

return lowerkeys({ ["IS_Chimera"] = IS_Chimera })
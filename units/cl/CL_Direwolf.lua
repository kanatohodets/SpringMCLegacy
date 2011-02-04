local CL_Direwolf = {
	name              	= "Dire Wolf (Daishi)",
	description         = "Assault Mech",
	objectName        	= "CL_Direwolf.s3o",
	script				= "CL_Direwolf.lua",
	category 			= "mech ground",
	sightDistance       = 1000,
	radarDistance      	= 1500,
		activateWhenBuilt   = true,
		onoffable           = true,
	maxDamage           = 19000,
	mass                = 10000,
	footprintX			= 3,
	footprintZ 			= 3,
	collisionVolumeType = "box",
	collisionVolumeScales = "40 50 40",
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeTest = 1,
--	leaveTracks			= 1,
--	trackOffset			= 10,--no idea what this does
--	trackStrength		= 2.5,--how visible the tracks are
--	trackStretch		= 1,-- how much the tracks stretch, the higher the number the more "compact" they become
--	trackType			= "Thick",--graphics file to use for the track decal, from \bitmaps\tracks\ folder
--	trackWidth			= 20,--width to render the decal
	buildCostEnergy     = 0,
	buildCostMetal      = 16000,
	buildTime           = 0,
	upright				= true,
	canMove				= true,
		movementClass   = "LARGEMECH",
		maxVelocity		= 2.7, --54kph/10/2
		maxReverseVelocity= 0.85,
		acceleration    = .80,
		brakeRate       = 0.1,
		turnRate 		= 600,
		smoothAnim		= 1,
	
	canAttack 			= true,
		--Makes unit use weapon from /weapons folder
		weapons 		= {	
			[1] = {
				name	= "CERLBL",
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[2] = {
				name	= "CERLBL",
				--weaponSlaveTo2 = 1,
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[3] = {
				name	= "CMPL",
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[4] = {
				name	= "CMPL",
				--weaponSlaveTo2 = 1,
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[5] = {
				name	= "UAC5",
				--weaponSlaveTo2 = 1,
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[6] = {
				name	= "CERLBL",
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[7] = {
				name	= "CERLBL",
				--weaponSlaveTo2 = 1,
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[8] = {
				name	= "CMPL",
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[9] = {
				name	= "CMPL",
				--weaponSlaveTo2 = 1,
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[10] = {
				name	= "UAC5",
				--weaponSlaveTo2 = 1,
				mainDir = "0 0 1",
				maxAngleDif = 270,
			},
			[11] = {
				name	= "ATM9",
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
		helptext		= "Armament: 4 x ER Large Beam Laser, 4 x ER Medium Pulse Laser, 2 x UAC/5, 1 x ATM-9 - Armor: 19 tons",
    },
}

return lowerkeys({ ["CL_Direwolf"] = CL_Direwolf })
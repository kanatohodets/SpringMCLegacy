local IS_Devastator_DVS2 = {
	name              	= "Devastator",
	description         = "Assault-class Long Range Fire Support/Sniper",
	objectName        	= "IS_Devastator_DVS2.s3o",
	iconType			= "assaultmech",
	script				= "Mech.lua",
	corpse				= "IS_Devastator_X",
	explodeAs          	= "mechexplode",
	category 			= "mech ground notbeacon",
	noChaseCategory		= "beacon air",
		activateWhenBuilt   = true,
		onoffable           = true,
	maxDamage           = 29600,
	mass                = 10000,
	footprintX			= 3,
	footprintZ 			= 3,
	collisionVolumeType = "box",
	collisionVolumeScales = "40 60 40",
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeTest = 1,
--	leaveTracks			= 1,
--	trackOffset			= 10,--no idea what this does
--	trackStrength		= 2.5,--how visible the tracks are
--	trackStretch		= 1,-- how much the tracks stretch, the higher the number the more "compact" they become
--	trackType			= "Thick",--graphics file to use for the track decal, from \bitmaps\tracks\ folder
--	trackWidth			= 20,--width to render the decal
	buildCostEnergy     = 100, -- in tons
	buildCostMetal        = 0,--      = 36100,
	buildTime           = 0,
	upright				= true,
	canMove				= true,
		movementClass   = "LARGEMECH",
		maxVelocity		= 2.5, --50kph/20
		smoothAnim		= 1,
	
	canAttack 			= true,
		--Makes unit use weapon from /weapons folder
		weapons 		= {	
			[1] = {
				name	= "Gauss",
				--mainDir = "0 0 1",
				--maxAngleDif = 200,
				OnlyTargetCategory = "notbeacon",
			},
			[2] = {
				name	= "Gauss",
				--mainDir = "0 0 1",
				--maxAngleDif = 200,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
			[3] = {
				name	= "PPC",
				--mainDir = "0 0 1",
				--maxAngleDif = 200,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
			[4] = {
				name	= "PPC",
				--mainDir = "0 0 1",
				--maxAngleDif = 200,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
			[5] = {
				name	= "MBL",
				--mainDir = "0 0 1",
				--maxAngleDif = 200,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
			[6] = {
				name	= "MBL",
				--mainDir = "0 0 1",
				--maxAngleDif = 200,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
			[7] = {
				name	= "MBL",
				--mainDir = "0 0 1",
				--maxAngleDif = 200,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
			[8] = {
				name	= "MBL",
				--mainDir = "0 0 1",
				--maxAngleDif = 200,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
		},
		
	--Gets CEG effects from /gamedata/explosions folder
    customparams = {
		hasturnbutton	= "1",
		helptext		= "Armament: 2 x Gauss Rifle, 2 x PPC, 4 x Medium Beam Laser - Armor: 18.5 tons Standard",
		heatlimit		= "28",
		torsoturnspeed	= "100",
		unittype		= "mech",
		maxammo 		= {gauss = 60},
    },
}

return lowerkeys({ ["IS_Devastator_DVS2"] = IS_Devastator_DVS2 })
local IS_Hollander_BZKG1 = {
	name              	= "Hollander BZK-G1",
	description         = "Light-class Close Range Brawler",
	objectName        	= "IS_Hollander_BZKG1.s3o",
	iconType			= "mediummech",
	script				= "Mech.lua",
	corpse				= "IS_Hollander_X",
	explodeAs          	= "mechexplode",
	category 			= "mech ground notbeacon",
	noChaseCategory		= "beacon air",
		activateWhenBuilt   = true,
		onoffable           = true,
	maxDamage           = 10700,
	mass                = 4500,
	footprintX			= 2,
	footprintZ 			= 2,
	collisionVolumeType = "box",
	collisionVolumeScales = "35 50 20",
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeTest = 1,
--	leaveTracks			= 1,
--	trackOffset			= 10,--no idea what this does
--	trackStrength		= 2.5,--how visible the tracks are
--	trackStretch		= 1,-- how much the tracks stretch, the higher the number the more "compact" they become
--	trackType			= "Thick",--graphics file to use for the track decal, from \bitmaps\tracks\ folder
--	trackWidth			= 20,--width to render the decal
	buildCostEnergy     = 45,
	buildCostMetal      = 14900,
	buildTime           = 0,
	upright				= true,
	canMove				= true,
		movementClass   = "SMALLMECH",
		maxVelocity		= 4, --80kph/20
		smoothAnim		= 1,
	
	canAttack 			= true,
		--Makes unit use weapon from /weapons folder
		weapons 		= {	
			[1] = {
				name	= "LBX10",
				mainDir = "0 0 1",
				maxAngleDif = 270,
				OnlyTargetCategory = "notbeacon",
			},
			[2] = {
				name	= "MBL",
				--mainDir = "0 0 1",
				--maxAngleDif = 270,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
			[3] = {
				name	= "MBL",
				--mainDir = "0 0 1",
				--maxAngleDif = 270,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
--			[4] = {
--				name	= "SPL",
--				--mainDir = "0 0 1",
--				--maxAngleDif = 270,
--				OnlyTargetCategory = "notbeacon",
--				SlaveTo = 1,
--			},
--			[5] = {
--				name	= "SPL",
--				--mainDir = "0 0 1",
--				--maxAngleDif = 270,
--				OnlyTargetCategory = "notbeacon",
--				SlaveTo = 1,
--			},
		},
    customparams = {
		hasturnbutton	= "1",
		helptext		= "Armament: 1 x LBX-10, 2 x Medium Laser - Armor: 6 tons Ferro-Fibrous",
		heatlimit		= "10",
		torsoturnspeed	= "140",
		leftarmid 		= "2",
		rightarmid 		= "3",
		unittype		= "mech",
		maxammo 		= {ac10 = 30},
    },
}

return lowerkeys({ ["IS_Hollander_BZKG1"] = IS_Hollander_BZKG1 })
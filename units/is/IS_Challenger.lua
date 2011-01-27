local IS_Challenger = {
	name              	= "Challenger",
	description         = "Heavy Combat Tank",
	objectName        	= "IS_Challenger.s3o",
	script				= "IS_Challenger.lua",
	category 			= "tank ground",
	sightDistance       = 1000,
	maxDamage           = 14000,
	mass                = 9000,
	footprintX			= 3,
	footprintZ 			= 3,
	collisionVolumeType = "box",
	collisionVolumeScales = "33 22 45",
	collisionVolumeOffsets = "0 5 0",
	collisionVolumeTest = 1,
	buildCostEnergy     = 0,
	buildCostMetal      = 0,
	buildTime           = 0,
	canMove				= true,
		movementClass   = "TANK",
		maxVelocity		= 2.6, --54kph/10/2
		maxReverseVelocity= 1.3,
		acceleration    = 0.6,
		brakeRate       = 0.1,
		turnRate 		= 425,
	
	canAttack 			= true,
		--Makes unit use weapon from /weapons folder
		weapons 		= {	
			[1] = {
				name	= "Gauss",
			},
			[2] = {
				name	= "LBX10",
				weaponslaveto2 = 1,
			},
			[3] = {
				name	= "LRM10",
				weaponslaveto3 = 1,
			},
			[4] = {
				name	= "MPL",
				weaponslaveto4 = 1,
			},
			[5] = {
				name	= "MPL",
				weaponslaveto5 = 1,
			},
			--[6] = {
			--	name	= "LAMS",
			--},
		},
	--Gets CEG effects from /gamedata/explosions folder
	sfxtypes = {
		explosiongenerators = {
		"custom:SMALL_MUZZLEFLASH",
		"custom:MEDIUM_MUZZLEFLASH",
		"custom:MG_MUZZLEFLASH",
		},
	},
	customparams = {
		hasturnbutton	= "1",
	},
}

return lowerkeys({ ["IS_Challenger"] = IS_Challenger })
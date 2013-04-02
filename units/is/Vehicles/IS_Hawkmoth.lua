local IS_Hawkmoth = {
	collide = false,
	name              	= "Hawk Moth",
	description         = "Light Attack VTOL",
	objectName        	= "IS_Hawkmoth.s3o",
	iconType			= "aero",
	script				= "Vehicle.lua",
	corpse				= "IS_Hawkmoth_X",
	explodeAs          	= "mechexplode",
	category 			= "vtol air notbeacon",
	noChaseCategory		= "beacon air",
	sightDistance       = 1200,
	radarDistance      	= 2000,
		activateWhenBuilt   = true,
		onoffable           = true,
	maxDamage           = 3500,
	mass                = 2000,
	footprintX			= 2,
	footprintZ 			= 2,
	collisionVolumeType = "box",
	collisionVolumeScales = "25 25 35",
	collisionVolumeOffsets = "0 1 0",
	collisionVolumeTest = 1,
	buildCostEnergy     = 20,
	buildCostMetal      = 8000,
	buildTime           = 0,
	canFly				= true,
		cruiseAlt		= 300,
		bankScale		= "1",
		hoverAttack		= true,
		steeringMode	= "1",
		defaultmissiontype  = "VTOL_standby",
		maneuverLeashLength = "2000",
		factoryHeadingTakeoff = false, 
	canMove				= true,
		movementClass   = "VTOL",
		maxVelocity		= 8.1, --86kph/30
		maxReverseVelocity= 4,
		acceleration    = 0.8,
		brakeRate       = 8.1,
		turnRate 		= 810,
	
	canAttack 			= true,
		--Makes unit use weapon from /weapons folder
		weapons 		= {	
			[1] = {
				name	= "LightGauss",
				OnlyTargetCategory = "notbeacon",
				mainDir = "0 0 1",
				maxAngleDif = 180,
			},
			[2] = {
				name	= "LRM5",
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
				mainDir = "0 0 1",
				maxAngleDif = 90,
			},
			[3] = {
				name	= "LRM5",
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
				mainDir = "0 0 1",
				maxAngleDif = 90,
			},
		},
	customparams = {
		hasturnbutton	= "1",
		helptext		= "Armament: 1 x Light Gauss Rifle, 2 x Artemis IV-enhanced LRM-5 - Armor: 2 tons",
		flagcaprate		= "0",
		flagdefendrate	= "0",
		heatlimit		= "15",
		unittype		= "vehicle",
    },
}

return lowerkeys({ ["IS_Hawkmoth"] = IS_Hawkmoth })
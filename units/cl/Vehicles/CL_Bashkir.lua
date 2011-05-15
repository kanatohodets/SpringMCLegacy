local CL_Bashkir = {
	name              	= "Bashkir",
	description         = "Light Interceptor ASF",
	objectName        	= "CL_Bashkir.s3o",
	script				= "Vehicle.lua",
	explodeAs          	= "mechexplode",
	category 			= "air notbeacon",
	noChaseCategory		= "beacon",
	sightDistance       = 1200,
	radarDistance      	= 1500,
		activateWhenBuilt   = true,
		onoffable           = true,
	maxDamage           = 2600,
	mass                = 2000,
	footprintX			= 2,
	footprintZ 			= 2,
	collisionVolumeType = "box",
	collisionVolumeScales = "25 25 35",
	collisionVolumeOffsets = "0 1 0",
	collisionVolumeTest = 1,
	buildCostEnergy     = 20,
	buildCostMetal      = 4500,
	buildTime           = 0,
	canFly				= true,
		cruiseAlt		= 300,
		bankScale		= "1",
		steeringMode	= "1",
		defaultmissiontype  = "VTOL_standby",
		maneuverLeashLength = "2000",
	canMove				= true,
		movementClass   = "AERO",
		maxVelocity		= 21.3, --280kph/15
		maxReverseVelocity= 4,
		acceleration    = 0.9,
		brakeRate       = 8.3,
		turnRate 		= 800,
		myGravity		= 0.5,
	
	canAttack 			= true,
		--Makes unit use weapon from /weapons folder
		weapons 		= {	
			[1] = {
				name	= "CERMBL",
				OnlyTargetCategory = "notbeacon",
				mainDir = "0 0 1",
				maxAngleDif = 35,
			},
			[2] = {
				name	= "CERMBL",
				OnlyTargetCategory = "notbeacon",
				WeaponSlaveTo = 1,
				mainDir = "0 0 1",
				maxAngleDif = 35,
			},
			[3] = {
				name	= "CERSBL",
				OnlyTargetCategory = "notbeacon",
				WeaponSlaveTo = 1,
				mainDir = "0 0 1",
				maxAngleDif = 35,
			},
			[4] = {
				name	= "SSRM4",
				OnlyTargetCategory = "notbeacon",
				WeaponSlaveTo = 1,
				mainDir = "0 0 1",
				maxAngleDif = 35,
			},
		},
	customparams = {
		hasturnbutton	= "1",
		helptext		= "Armament: 2 x Medium Pulse Laser, 1 x ER Small Beam Laser, 1 x SSRM-4 - Armor: 2 tons",
		flagcaprate		= "0",
		flagdefendrate	= "0",
		heatlimit		= "15",
		unittype		= "vehicle",
    },
}

return lowerkeys({ ["CL_Bashkir"] = CL_Bashkir })
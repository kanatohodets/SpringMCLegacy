local CL_Oro_HAG = {
	name              	= "Oro (HAG/30)",
	description         = "Heavy Strike Tank",
	objectName        	= "CL_Oro_HAG.s3o",
	iconType			= "vehicle",
	script				= "Vehicle.lua",
	explodeAs          	= "mechexplode",
	category 			= "tank ground notbeacon",
	noChaseCategory		= "beacon",
	sightDistance       = 800,
	radarDistance      	= 1500,
		activateWhenBuilt   = true,
		onoffable           = true,
	maxDamage           = 19700,
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
	buildCostMetal      = 5500,
	buildTime           = 0,
	canMove				= true,
		movementClass   = "TANK",
		maxVelocity		= 2.13, --64kph/10/2
		maxReverseVelocity= 1.5,
		acceleration    = 0.8,
		brakeRate       = 0.1,
		turnRate 		= 400,
	
	canAttack 			= true,
		--Makes unit use weapon from /weapons folder
		weapons 		= {	
			[1] = {
				name	= "HAG30",
				OnlyTargetCategory = "notbeacon",
			},
			[2] = {
				name	= "CLPL",
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
		},
	customparams = {
		hasturnbutton	= "1",
		helptext		= "Armament: 1 x Hyper Assault Gauss 30, 1 x Large Pulse Laser - Armor: 11 tons",
		heatlimit		= "20",
		unittype		= "vehicle",
		turretturnspeed = "85",
		elevationspeed  = "200",
		wheelspeed      = "200",
		barrelrecoildist = "{[1] = 5}",
    },
}

return lowerkeys({ ["CL_Oro_HAG"] = CL_Oro_HAG })
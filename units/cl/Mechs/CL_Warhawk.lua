local CL_Warhawk = {
	name              	= "War Hawk (Masakari)",
	description         = "Assault-class Sniper Mech",
	objectName        	= "CL_Warhawk.s3o",
	iconType			= "assaultmech",
	script				= "Mech.lua",
	corpse				= "CL_Warhawk_X",
	explodeAs          	= "mechexplode",
	category 			= "mech ground notbeacon",
	noChaseCategory		= "beacon air",
	sightDistance       = 1200,
	radarDistance      	= 2000,
		activateWhenBuilt   = true,
		onoffable           = true,
	maxDamage           = 25900,
	mass                = 8500,
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
	buildCostEnergy     = 85,
	buildCostMetal      = 39900,
	buildTime           = 0,
	upright				= true,
	canMove				= true,
		movementClass   = "LARGEMECH",
		maxVelocity		= 3.2, --64kph/10/2
		maxReverseVelocity= 1.6,
		acceleration    = 1.0,
		brakeRate       = 0.15,
		turnRate 		= 700,
		smoothAnim		= 1,
	
	canAttack 			= true,
		--Makes unit use weapon from /weapons folder
		weapons 		= {	
			[1] = {
				name	= "CERPPC",
				mainDir = "0 0 1",
				maxAngleDif = 270,
				OnlyTargetCategory = "notbeacon",
			},
			[2] = {
				name	= "CERPPC",
				mainDir = "0 0 1",
				maxAngleDif = 200,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
			[3] = {
				name	= "CERPPC",
				mainDir = "0 0 1",
				maxAngleDif = 200,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
			[4] = {
				name	= "CERPPC",
				mainDir = "0 0 1",
				maxAngleDif = 200,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
			[5] = {
				name	= "ATM6",
				mainDir = "0 0 1",
				maxAngleDif = 200,
				OnlyTargetCategory = "notbeacon",
				SlaveTo = 1,
			},
		},

    customparams = {
		hasturnbutton	= "1",
		helptext		= "Armament: 4 x ER Particle Cannon, 1 x ATM-9 - Armor: 13.5 tons Ferro-Fibrous",
		heatlimit		= "50",
		torsoturnspeed	= "100",
		unittype		= "mech",
    },
}

return lowerkeys({ ["CL_Warhawk"] = CL_Warhawk })
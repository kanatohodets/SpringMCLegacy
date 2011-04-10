local Outpost_C3Center = {
	name              	= "C3 Command Center",
	description         = "Relays targeting and sensor data",
	objectName        	= "Outpost_C3Center.s3o",
	script				= "Outpost_C3Center.lua",
	category 			= "structure beacon",
	sightDistance       = 1200,
	radarDistance      	= 2000,
		activateWhenBuilt   = true,
	maxDamage           = 22000,
	mass                = 5000,
	footprintX			= 3,
	footprintZ 			= 3,
	collisionVolumeType = "box",
	collisionVolumeScales = "75 75 75",
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeTest = 1,
	buildCostEnergy     = 0,
	buildCostMetal      = 0,
	buildTime           = 0,
	canMove				= false,
	maxVelocity			= 0,
	idleAutoHeal		= 0,
	maxSlope			= 50,
	builder				= false,
	TEDClass			= "FORT",
		--Makes unit use weapon from /weapons folder
	customparams = {
		ammosupplier	= "0",
		supplyradius	= "0",
		helptext		= "Boosts accuracy and range of nearby units.",
    },
	--sounds = {
    --underattack        = "Dropship_Alarm",
	--},
}

return lowerkeys({ ["Outpost_C3Center"] = Outpost_C3Center })
local Outpost_VehicleDepot = {
	name              	= "Vehicle Depot",
	description         = "Grants access to Vehicles",
	objectName        	= "Outpost_VehicleDepot.s3o",
	script				= "Outpost_VehicleDepot.lua",
	iconType			= "beacon",
	category 			= "structure beacon",
	sightDistance       = 1000,
	radarDistance      	= 1500,
		--activateWhenBuilt   = true,
	maxDamage           = 45000,
	mass                = 9000,
	footprintX			= 8,
	footprintZ 			= 8,
	collisionVolumeType = "box",
	collisionVolumeScales = "75 75 75",
	collisionVolumeOffsets = "0 0 0",
	buildCostEnergy     = 0,
	buildCostMetal      = 0,
	buildTime           = 0,
	canMove				= true,
	maxVelocity			= 0,
	energyStorage		= 0,
	metalMake			= 0,
	metalStorage		= 0,
	idleAutoHeal		= 0,
	maxSlope			= 50,
	builder				= true,
	moveState			= 0,
		showNanoFrame		= 0,
		showNanoSpray		= 0,
		workerTime			= 1,
		canBeAssisted	= false,
		yardmap			= "oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo ",
	TEDClass			= PLANT,
	
	customparams = {
		ammosupplier	= "0",
		supplyradius	= "0",
		helptext		= "A Vehicle Depot",
    },
	sounds = {
    underattack        = "Dropship_Alarm",
	},
}

return lowerkeys({ ["Outpost_VehicleDepot"] = Outpost_VehicleDepot })
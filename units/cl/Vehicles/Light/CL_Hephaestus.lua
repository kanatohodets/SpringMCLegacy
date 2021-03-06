local CL_Hephaestus = Hover:New{
	name              	= "Hephaestus",
	description         = "Light Scout Hovercraft",
	objectName        	= "CL_Hephaestus.s3o",
	corpse				= "CL_Hephaestus_X",
	sightDistance       = 1200,
	radarDistance      	= 2000,
	radarDistanceJam    = 500,
	maxDamage           = 6000,
	mass                = 3000,
	buildCostEnergy     = 30,
	buildCostMetal      = 9270,
	maxVelocity		= 6.5, --130kph/30
	maxReverseVelocity= 3.25,
	acceleration    = 1.8,
	brakeRate       = 0.1,
	turnRate 		= 450,
	
	weapons 		= {	
		[1] = {
			name	= "CMPL",
		},
		[2] = {
			name	= "CMPL",
		},
		[3] = {
			name	= "TAG",
		},
	},
	customparams = {
		helptext		= "Armament: 2 x Medium Pulse Laser, 1 x TAG Laser - Armor: 5 tons FF",
		heatlimit		= 20,
		turretturnspeed = 75,
		elevationspeed  = 200,
		maxammo = {narc = 10},
		squadsize 		= 3,
    },
}

return lowerkeys({
	["CL_Hephaestus"] = CL_Hephaestus,
})
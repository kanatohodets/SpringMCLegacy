local CL_Zorya = LightTank:New{
	name              	= "Zorya",
	description         = "Light Strike Tank",
	objectName        	= "CL_Zorya.s3o",
	corpse				= "CL_Zorya_X",
	maxDamage           = 4200,
	mass                = 3500,
	trackWidth			= 24,--width to render the decal
	buildCostEnergy     = 40,
	buildCostMetal      = 10530,
	maxVelocity		= 2.8, --64kph/30
	maxReverseVelocity= 1.2,
	acceleration    = 0.8,
	brakeRate       = 0.1,
	turnRate 		= 450,

	weapons = {	
		[1] = {
			name	= "LBX5",
		},
		[2] = {
			name	= "ATM6",
		},
	},
	customparams = {
		helptext		= "Armament: 1 x LBX AC/5, 1 x ATM-6 - Armor: 3.5 tons",
		heatlimit		= 26,
		turretturnspeed = 75,
		elevationspeed  = 100,
		maxammo = {ac5 = 100, lrm = 120},
		barrelrecoildist = {[1] = 5},
		squadsize 		= 4,
    },
}

return lowerkeys({
	["CL_Zorya"] = CL_Zorya,
})
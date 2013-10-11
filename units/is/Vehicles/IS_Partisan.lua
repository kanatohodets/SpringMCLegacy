local IS_Partisan = Tank:New{
	name              	= "Partisan",
	description         = "Heavy Anti-Aircraft Tank",
	objectName        	= "IS_Partisan.s3o",
	corpse				= "IS_Partisan_X",
	maxDamage           = 11200,
	mass                = 8000,
	trackWidth			= 32,--width to render the decal
	buildCostEnergy     = 70,
	buildCostMetal      = 11880,
	maxVelocity		= 1.8, --54kph/30
	maxReverseVelocity= 1.3,
	acceleration    = 0.6,
	brakeRate       = 0.1,
	turnRate 		= 425,
	
	weapons	= {	
		[1] = {
			name	= "AC5_AA",
			badTargetCategory = "ground",
		},
		[2] = {
			name	= "AC5_AA",
			badTargetCategory = "ground",
		},
		[3] = {
			name	= "AC5_AA",
			badTargetCategory = "ground",
		},
		[4] = {
			name	= "AC5_AA",
			badTargetCategory = "ground",
		},
	},

	customparams = {
		helptext		= "Armament: 4 x AC/5 (Anti-Aircraft) - Armor: 7 tons",
		heatlimit		= 20,
		turretturnspeed = 250,
		elevationspeed  = 300,
		wheelspeed      = 200,
		maxammo 		= {ac5 = 200},
	},
}

return lowerkeys({
	["IS_Partisan"] = IS_Partisan,
})
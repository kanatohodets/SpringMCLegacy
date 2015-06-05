local Po = Tank:New{
	name              	= "Po",
	description         = "Heavy Strike Tank",
	trackWidth			= 23,--width to render the decal

	weapons	= {	
		[1] = {
			name	= "AC10",
		},
		[2] = {
			name	= "MG",
		},
		[3] = {
			name	= "MG",
		},
	},
	
	customparams = {
		tonnage			= 60,
		variant         = "",
		speed			= 60,
		price			= 7190,
		heatlimit 		= 20,
		armor			= {type = "standard", tons = 10.5},
		maxammo 		= {ac10 = 3},
		barrelrecoildist = {[1] = 5},
		squadsize 		= 3,
    },
}

return lowerkeys({
	["CC_Po"] = Po,
})
local Demolisher = Tank:New{
	name              	= "Demolisher",
	description         = "Heavy Brawler Tank",
	
	trackWidth			= 28,--width to render the decal
	
	weapons = {	
		[1] = {
			name	= "AC20",
		},
		[2] = {
			name	= "AC20",
		},
	},

	customparams = {
		tonnage			= 80,
		variant         = "",
		speed			= 50,
		price			= 6090,
		heatlimit 		= 20,
		armor			= {type = "standard", tons = 12},
		maxammo 		= {ac20 = 2},
		barrelrecoildist = {[1] = 5, [2] = 5},
		squadsize 		= 1,
    },
}

return lowerkeys({
	["FS_Demolisher"] = Demolisher:New(),
	["CC_Demolisher"] = Demolisher:New(),
})
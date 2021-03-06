local Scorpion = LightTank:New{
	name              	= "Scorpion",
	name				= "Light Striker Tank",
	
	weapons 		= {	
		[1] = {
			name	= "AC5",
		},
		[2] = {
			name	= "MG",
		},
	},
	
	customparams = {
		tonnage			= 25,
		variant         = "",
		speed			= 80,
		price			= 4130,
		heatlimit 		= 10,
		armor			= {type = "standard", tons = 4},
		maxammo 		= {ac5 = 2},
		squadsize 		= 2,
    },
}

return lowerkeys({
	["FS_Scorpion"] = Scorpion:New(),
	["LA_Scorpion"] = Scorpion:New(),
	["CC_Scorpion"] = Scorpion:New(),
})
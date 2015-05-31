local Blackjack = Medium:New{
	name				= "Blackjack",

	customparams = {
		tonnage			= 50,
    },	
}

local BJ2 = Blackjack:New{
	description         = "Medium Striker",
	weapons	= {	
		[1] = {
			name	= "ERLBL",
		},
		[2] = {
			name	= "ERLBL",
		},
		[3] = {
			name	= "SSRM2",
		},
		[4] = {
			name	= "SSRM2",
		},
	},
		
	customparams = {
		variant			= "BJ-2",
		speed			= 60,
		price			= 16000,
		heatlimit 		= 22,
		jumpjets		= 4,
		armor			= {type = "standard", tons = 8.5},
		maxammo 		= {srm = 1},
    },
}

local BJ3 = Blackjack:New{
	description         = "Medium Striker",
	weapons	= {	
		[1] = {
			name	= "PPC",
		},
		[2] = {
			name	= "PPC",
		},
		[3] = {
			name	= "MBL",
		},
		[4] = {
			name	= "MBL",
		},
		[5] = {
			name	= "MBL",
		},
		[6] = {
			name	= "MBL",
		},
	},
		
	customparams = {
		variant			= "BJ-3",
		speed			= 60,
		price			= 18000,
		heatlimit 		= 20,
		jumpjets		= 4,
		armor			= {type = "standard", tons = 8.5},
    },
}

local BJ4 = Blackjack:New{
	description         = "Medium Striker",
	weapons	= {	
		[1] = {
			name	= "AC5",
		},
		[2] = {
			name	= "AC5",
		},
		[3] = {
			name	= "MBL",
		},
		[4] = {
			name	= "MBL",
		},
	},
		
	customparams = {
		variant			= "BJ-4",
		speed			= 60,
		price			= 16000,
		heatlimit 		= 22,
		jumpjets		= 4,
		armor			= {type = "ferro", tons = 8},--should be light ferro
		maxammo 		= {ac5 = 4},
    },
}

local BJ2O = Blackjack:New{
	description         = "Medium Striker",
	weapons	= {	
		[1] = {
			name	= "UAC5",
		},
		[2] = {
			name	= "UAC5",
		},
		[3] = {
			name	= "MBL",
		},
		[4] = {
			name	= "MBL",
		},
		[5] = {
			name	= "MBL",
		},
		[6] = {
			name	= "MBL",
		},
		[7] = {
			name	= "MG",
		},
		[8] = {
			name	= "MG",
		},
		[9] = {
			name	= "MG",
		},
		[10] = {
			name	= "MG",
		},
	},
		
	customparams = {
		variant			= "BJ2-O",
		speed			= 60,
		price			= 19000,
		heatlimit 		= 20,
		jumpjets		= 4,
		armor			= {type = "standard", tons = 9.5},--should be light ferro
		maxammo 		= {ac5 = 2},
    },
}


return lowerkeys({
	["FS_Blackjack_BJ2"] = BJ2:New(),
	["CC_Blackjack_BJ3"] = BJ3:New(),
	["FS_Blackjack_BJ4"] = BJ4:New(),
	["DC_Blackjack_BJ2O"] = BJ2O:New(),
	["FW_Blackjack_BJ2O"] = BJ2O:New(),
})
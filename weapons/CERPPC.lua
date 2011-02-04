weaponDef = {
	name                    = "Clan Extended Range Particle Projector Cannon",
	weaponType              = "Cannon",
	explosionGenerator    	= "custom:AP_MEDIUM",
--	cegTag					= "RailTrail",
	soundHit              	= [[PPC_Hit]],
	soundStart            	= [[PPC_Fire]],
	burnblow				= false, 	--Bullets explode at range limit.
	collideFriendly			= true,
	noSelfDamage            = true,
	turret                  = true,
--	ballistic				= 1,
	lineOfSight				= 1,
	range                   = 2300,
	accuracy                = 200,
	areaOfEffect            = 10,
	weaponVelocity          = 2000,
	reloadtime              = 7.5,
	renderType				= 1,
	size					= 3,
	sizeDecay				= 0,
	separation				= 1.5, 		--Distance between each plasma particle.
	stages					= 100, 		--Number of particles used in one plasma shot.
--	AlphaDecay				= 0.05, 		--How much a plasma particle is more transparent than the previous particle. 
	rgbcolor				= "0.5 0.5 1.0",
	intensity				= 0.5,
	damage = {
		default = 1125, --150 DPS
	},
	
	
	
}

return lowerkeys({ CERPPC = weaponDef })
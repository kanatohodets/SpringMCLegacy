function widget:GetInfo()
  return {
    name      = "MC:L - Minimum Ranges",
    desc      = "Draws minimum range rings",
    author    = "FLOZi (C. Lawrence)",
    date      = "28/07/2013",
    license   = "GNU GPL v2",
    layer     = 10000,
    enabled   = true,
  }
end

-- localisations

-- OGL
local glBillboard	 		= gl.Billboard
local glColor 				= gl.Color
local glDrawGroundCircle 	= gl.DrawGroundCircle
local glTranslate			= gl.Translate
-- SyncedRead
local GetUnitPosition 		= Spring.GetUnitPosition
local GetUnitDefID			= Spring.GetUnitDefID
-- UnsyncedRead
local GetActiveCommand		= Spring.GetActiveCommand
local GetSelectedUnits		= Spring.GetSelectedUnits

local AttackRed = {1.0, 0.2, 0.2, 0.7}
local BuildGreen = {0.3, 1.0, 0.3, 0.5} -- doesn't match engine for some reason so make less opaque

local minRanges = {} -- minRange[unitDefID] = {weapName = range, ...}
local buildRanges = {} -- buildRange[unitDefID] = minRange

function widget:Initialize()
	-- Change default command menu font
	local currentFont = Spring.GetConfigString("FontFile")
	local currentFontSmall = Spring.GetConfigString("SmallFontFile")
	Spring.SendCommands("font Handel Gothic.ttf")
	Spring.SetConfigString("FontFile", currentFont)
	Spring.SetConfigString("SmallFontFile", currentFontSmall)
	-- Cache ranges
	for unitDefID, unitDef in pairs(UnitDefs) do
		local weapons = unitDef.weapons
		for i = 1, #weapons do 
			local weaponDef = WeaponDefs[weapons[i].weaponDef]
			local minRange = tonumber(weaponDef.customParams.minrange) or nil
			if minRange then
				if not minRanges[unitDefID] then
					minRanges[unitDefID] = {}
				end
				minRanges[unitDefID][weaponDef.name] = minRange
			end
		end
		local buildRange = unitDef.customParams.minbuildrange or nil
		if buildRange then
			buildRanges[unitDefID] = buildRange
		end
	end
	-- Setup fonts for drawing
	btFont = gl.LoadFont("LuaUI/Fonts/bt_oldstyle.ttf", 24, 2, 30)
	btFont:SetTextColor(AttackRed)
	--btFont:SetAutoOutlineColor(false)
	--btFont:SetOutlineColor(0,1,0)
end

function widget:DrawWorldPreUnit()
	for _,unitID in ipairs(GetSelectedUnits()) do
		local unitDefID = GetUnitDefID(unitID)
		if select(4, GetActiveCommand()) == "Attack" then
			glColor(AttackRed)
			local rangesToDraw = minRanges[unitDefID]
			if rangesToDraw then
				local x, y, z = GetUnitPosition(unitID)
				for weapName, radius in pairs(rangesToDraw) do
					gl.PushMatrix()
					glDrawGroundCircle(x,y,z, radius,24)
					glTranslate(x, y + 40, z + radius - 40)
					glBillboard()
					btFont:Print("Min Range: " .. weapName, 0, 0, 24, "c")
					gl.PopMatrix()
				end
			end
		--[[elseif UnitDefNames[select(4, GetActiveCommand())] then -- command is a valid unitname i.e. build command
			rangesToDraw = buildRanges[unitDefID]
			if rangesToDraw then
				local x, y, z = GetUnitPosition(unitID)
				glColor(BuildGreen)
				gl.PushMatrix()
					glDrawGroundCircle(x,y,z, rangesToDraw,24)
				gl.PopMatrix()
			end--]]
		end
		glColor(1,1,1,1)
	end
end
local Players = game:GetService"Players"

local dataScripts = script.Parent
local dataFolder = dataScripts.Parent
local DataStore2 = require(dataFolder:WaitForChild"DataStore2")
local DS2Utilities = require(dataFolder:WaitForChild"DataStore2 Utilities")

local masterKey = "DevelopmentData"

--[[

KeysData Order:

key || value's parent name || value's name || value's Class Name || starter Value || Value's MinValue || Value's MaxValue

Min and Max Value only used if the Value's ClassName is DoubleConstrainedValue

]]

local dataKeys = {
	{"level", -- Key
		"PlayerStats", -- Value's Parent Name
		"Level", -- Value's Name
		"IntValue", -- Value's Class Name
		1 -- Starter Value
	},
	{"experience", -- Key
		"PlayerStats", -- Value's Parent Name
		"Experience", -- Value's Name
		"IntValue", -- Value's Class Name
		0 -- Starter Value
	}
}

--// tableKey, player, tableName, data
local tableDataKeys = {
	{"inventory", -- Table's Key
		"PlayerInventory", -- Table's Name
		{ -- Default data
			{
				"StringValue", -- Class Name
				"Part Item", -- Name
				"Template Item", -- Value
				{ -- Attributes {["attribute name"] = "attributeValue"},
					["Class"] = "Consumable",
					["OriginalOwner"] = "Unknown Owner",
					["Rarity"] = "Common",
					["Tags"] = "Beta,Starter Item"
				}
			}
		}
	},
	{"stats", -- Table's Key
		"CharacterStats", -- Table's Name
		{ -- Default data
			{
				"IntValue", -- Class Name
				"Strength", -- Name
				1 -- Value
			},
			{
				"IntValue", -- Class Name
				"Defense", -- Name
				1 -- Value
			},
			{
				"IntValue", -- Class Name
				"Agility", -- Name
				1 -- Value
			}
		}
	}
}

for _, dataKey in pairs(dataKeys)do
	local key = dataKey[1]
	
	DataStore2.Combine(masterKey, key)
end

Players.PlayerAdded:Connect(function(player)
	local values = {}
	local tableValues = {}
	
	--// Data
	for _, dataKey in pairs(dataKeys)do
		local value = DS2Utilities.createData(
			dataKey[1],
			player,
			dataKey[2],
			dataKey[3],
			dataKey[4],
			dataKey[5],
			dataKey[6],
			dataKey[7]
		)

		table.insert(values, value)
	end
	
	--// Table data
	for _, tableDataKey in pairs(tableDataKeys)do
		local value = DS2Utilities.createDataTable(
			tableDataKey[1],
			player,
			tableDataKey[2],
			tableDataKey[3]
		)

		table.insert(tableValues, value)
	end
end)


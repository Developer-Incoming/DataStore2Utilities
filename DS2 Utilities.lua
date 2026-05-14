local module = {}


local dataFolder = script.Parent
local DataStore2 = require(dataFolder:WaitForChild"DataStore2")

function module.createFolder(parent, name)
	local folder = Instance.new("Folder", parent)
	folder.Name = name

	return folder
end

function module.packADataTableFolder(dataTableFolder)
	local packedDataTable = {}

	for _, obj in pairs(dataTableFolder:GetChildren())do
		local objectData = {
			obj.ClassName,
			obj.Name,
			obj.Value,
			obj:GetAttributes()
		}
		
		print("attr: ", obj:GetAttributes())
		
		table.insert(packedDataTable, objectData)
	end

	return packedDataTable
end

--[[

KeysData Order:
key || value's parent name || value's name || value's Class Name || starter Value || Value's MinValue || Value's MaxValue

Min and Max Value only used if the Value's ClassName is DoubleConstrainedValue

]]

--// Data creation

function module.createData(key, player, folder, name, className, starterValue, minValue, maxValue)
	local value

	if starterValue then
		value = Instance.new(className)

		local parent = player:FindFirstChild(folder)
		if not parent then
			parent = Instance.new("Folder", player)
			parent.Name = folder
		end

		value.Parent = parent
		value.Name = name
		if className == "DoubleConstrainedValue"then
			value.MinValue = minValue
			value.MaxValue = maxValue
		end

		--| Data Saving Updating
		local valueStore = DataStore2(key, player)

		-- updates the value and if the player is new it'll give him the starterValue
		value.Value = valueStore:Get(starterValue)

		-- Updates the value when the data value gets changed
		--valueStore:OnUpdate(function(newValue)
		--	value.Value = newValue
		--end)

		-- Updates the data value when the value gets changed
		value:GetPropertyChangedSignal"Value":Connect(function()
			valueStore:Set(value.Value)
		end)
	else

		value = Instance.new(className)

		local parent = player:FindFirstChild(folder)
		if not parent then
			parent = Instance.new("Folder", player)
			parent.Name = folder
		end

		value.Parent = parent
		value.Name = name
	end

	return value
end


--// Data Table Creation:

function module.createDataTable(tableKey, player, tableName, defaultDataTable)
	local dataTable
	local dataTableFolder

	dataTableFolder = Instance.new("Folder", player)
	dataTableFolder.Name = tableName

	-- Data table loading
	local dataTableStore = DataStore2(tableKey, player)

	-- updates the table and if the player is new it'll give him the defaultDataTable
	dataTable = dataTableStore:Get(defaultDataTable)

	-- Updates the data table when anything in the table gets changed
	local function updateDataTable()
		dataTableStore:Set(module.packADataTableFolder(dataTableFolder))
	end
	
	-- Loops through table's data
	for _, data in pairs(dataTable) do
		local dataObject = Instance.new(data[1], dataTableFolder)
		dataObject.Name = data[2]
		dataObject.Value = data[3]
		
		-- Creating data attributes
		if data[4]then
			for attributeName, attributeValue in pairs(data[4])do
				dataObject:SetAttribute(attributeName, attributeValue)
			end
		end
		
		dataObject:GetPropertyChangedSignal("Name"):Connect(updateDataTable)
		dataObject.Changed:Connect(updateDataTable)
		dataObject.AttributeChanged:Connect(updateDataTable)
	end

	-- Updates the value when the data value gets changed
	--valueStore:OnUpdate(function(newValue)
	--	value.Value = newValue
	--end)
	
	dataTableFolder.DescendantRemoving:Connect(updateDataTable)
	dataTableFolder.DescendantAdded:Connect(updateDataTable)

	return dataTableFolder
end


return module


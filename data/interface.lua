Table = AllocTable()
local def = QTABLE_DEFAULT_COLOR

function loadWindowCoordinatesFromFile(path, reg)
	local s = {}
	local file = io.open(path, reg)
	for line in file:lines() do		
		table.insert(s,tonumber(line))
	end
	file:close()	
	if #s<4 then
		return 0,0,300,300 -- default coordinates
	end
	return s[1],s[2],s[3],s[4]
end

function destroyTables()
	if Table ~= nil then
		DestroyTable(Table)
	end
end

function saveWindowCoordinates(t)
	TabY1,TabX1,TabY2,TabX2 = GetWindowRect(t)
	if TabY1 ~= nil and TabX1 ~= nil and TabY2 ~= nil and TabX2 ~= nil then
		return TabY1,TabX1,TabY2,TabX2
	end
end

function writeWindowCoordinatesToFile(t, path, reg, y, x ,y2, x2)
	local file = io.open(path, reg)
	file:write(x,"\n",y,"\n",(x2-x),"\n",(y2-y))
	file:close()
end

function setWindow(t, name, path, reg, rowsNumber)
	CreateWindow(t)
	SetWindowCaption(t, name)
	SetWindowPos(t, loadWindowCoordinatesFromFile(path, reg))
	for i = 1, rowsNumber do
		InsertRow(t, -1)
	end
	SetColor(t, 1, QTABLE_NO_INDEX, RGB (212, 230, 239), def, def, def)
end

function PrintTable(t, name, path, reg)
	AddColumn(t, 1,"Column1", true, QTABLE_STRING_TYPE, 20)
	AddColumn(t, 2,"Среднее", true, QTABLE_STRING_TYPE, 25)
	AddColumn(t, 3,"Bid", true, QTABLE_STRING_TYPE, 20)
	setWindow(t, name, path, reg, rows)
end

function SetCells(t, list)
	for i = 1, #list do
		SetCell(t, i+1, 1, list[i]['EMIT'])
		SetCell(t, i+1, 2, tostring(list[i]['REQUIRED_QUANTITY']))
		SetCell(t, i+1, 3, list[i]['ISIN'])
	end
	SetCell(Table, 1, 1, "N млн. рублей:")
	SetCell(Table, 1, 2, tostring(N))
end

f_cb_Table = function(t, msg,  par1, par2)	
	if msg==QTABLE_LBUTTONDOWN then
		activeLine = par1
		activeCol = par2
		if activeLine == 1 and activeCol == 2 then
			SetColor(t, activeLine, activeCol, RGB (255, 248, 165), def, def, def)
			edit = true
		end
	end
	
	if msg == QTABLE_CHAR then
		if activeLine == 1 and activeCol == 2 and edit == true then
			N = characterInputHandler(N,par2,4)
		end
	end
	
	if msg == QTABLE_VKEY then
		
		-- Enter
		if par2 == 13 then
			SetColor(t, 1, 2, def, def, def, def)
			edit = false
			
		-- DEL
		elseif par2 == 46 then
			SetColor(t, i, 1, def, def, def, def)
			N = 0
			edit = false
		end
	end
end
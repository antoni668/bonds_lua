Table = AllocTable()

function loadWindowCoordinatesFromFile(path, reg)
	local s = {}
	local file = io.open(path, reg)
	for line in file:lines() do		
		table.insert(s,tonumber(line))
	end
	file:close()	
	if #s<4 then
		return 0,0,300,300 -- default values
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
		if i%2>0 then
			SetColor(t, i, QTABLE_NO_INDEX, RGB (212, 230, 239), def, def, def)	
		end
	end
end

function PrintTable(t, name, path, reg)
	AddColumn(t, 1,"Column1", true, QTABLE_STRING_TYPE, 14)
	AddColumn(t, 2,"Column2", true, QTABLE_STRING_TYPE, 14)
	AddColumn(t, 3,"Column3", true, QTABLE_STRING_TYPE, 10)
	setWindow(t, name, path, reg, rows)
end

function SetCells(t)
	for i = 1, #sec_list do
		SetCell(t, i, 1, tostring(sec_list[i]))
	end
	SetCell(t, 1, 2, tostring(A))
	SetCell(t, 2, 2, tostring(B))
	SetCell(t, 3, 2, tostring(C))
	SetCell(t, 4, 2, tostring(D))
	SetCell(t, 5, 2, tostring(E))
	SetCell(t, 6, 2, tostring(F))
end
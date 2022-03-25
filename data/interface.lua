local def = QTABLE_DEFAULT_COLOR
local edit = false

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
	AddColumn(t, 1,"Код эмитента", true, QTABLE_STRING_TYPE, 20)
	AddColumn(t, 2,"ISIN", true, QTABLE_STRING_TYPE, 20)
	AddColumn(t, 3,"Объемный бид", true, QTABLE_STRING_TYPE, 20)
	AddColumn(t, 4,"Объемный аск", true, QTABLE_STRING_TYPE, 20)
	AddColumn(t, 5,"Средний бид", true, QTABLE_STRING_TYPE, 20)
	AddColumn(t, 6,"Средний аск", true, QTABLE_STRING_TYPE, 20)
	
	setWindow(t, name, path, reg, rows)
end

function SetCells(t, l)
	for i = 1, #l do
		SetCell(t, i+1, 1, l[i]['EMIT'])
		SetCell(t, i+1, 2, l[i]['ISIN'])
		SetCell(t, i+1, 3, tostring(round(l[i]['TARGET_BID_PRICE'], 4)))
		SetCell(t, i+1, 4, tostring(round(l[i]['TARGET_ASK_PRICE'], 4)))
		SetCell(t, i+1, 5, tostring(round(l[i]['AVERAGE_BID_PRICE'], 4)))
		SetCell(t, i+1, 6, round(l[i]['AVERAGE_ASK_PRICE'], 4))
	end
	
	SetCell(Table, 1, 1, "N млн. рублей:")
	SetCell(Table, 1, 2, tostring(N))
end

f_cb_Table = function(t, msg,  par1, par2)	
	if msg==QTABLE_LBUTTONDOWN then
		activeLine = par1
		activeCol = par2
		
		if activeLine == 1 and activeCol == 2 then			
			edit = true
		end
	end
	
	if msg == QTABLE_CHAR then
		if activeLine == 1 and activeCol == 2 and edit == true then
			N = characterInputHandler(N,par2,4)
		end
	end
	--[[
	if msg == QTABLE_VKEY then
		if par2 == 13 then -- Enter
			SetColor(t, 1, 2, def, def, def, def)
			
			edit = false	
		elseif par2 == 46 then -- DEL
			SetColor(t, i, 1, def, def, def, def)
			
			N = 0
			
			edit = false
		end
	end]]
end
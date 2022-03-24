function characterInputHandler(str,char,param)
--[[
param == 1 - All letters and numbers
param == 2 - Integers only
param == 3 - Negative and positive integers
param == 4 - Only positive fractional numbers
param == 5 - Negative and positive fractional numbers
--]]
	local permission = false
	
	if param == 1 then
		if (char > 60 and char < 91) or (char > 96 and char < 123) or (char >= 44 and char <= 58) or char == 8 or char == 32 or char == 95 then
			permission = true
		end
	elseif param == 2 then
		if (char > 47 and char < 58) or char == 8 then
			permission = true
		end
	elseif param == 3 then
		if (char > 47 and char < 58) or char == 8 or char == 45 then
			permission = true
		end
	elseif param == 4 then
		if (char > 47 and char < 58) or char == 8 or char == 46 or char == 44 then
			permission = true
		end
	elseif param == 5 then
		if (char >= 44 and char < 58) or char == 8  then --or char == 46 or char == 45
			permission = true
		end
	elseif param == 6 then
		if (char > 64 and char < 91) or (char > 96 and char < 123) or (char >= 44 and char <= 58) or char == 8 or char == 32 or char == 95 or (char >= 192 and char <= 255) or char == 168 then
			permission = true
		end
	end
	str = str or ""
	str = tostring(str)
	
	if permission then
		if char ~= 8 and char ~= 32 and char ~= 44 then
			str = str..string.char(char)
		elseif char == 8 then
			str = string.sub(str, 1, -2)
		end
	end
	
	if param ~= 1 then
		if #str == 2 then
			if string.sub(str,1,1) == "0" then
				str = string.sub(str,2,2)
			end
		end
		
		if str == "" then
			str = "0"
		elseif str == "." then
			str = "0."
		end
	end
	
	return str
end

function loadN(path)
	local file = io.open(path, 'r')
	
	local N = file:read('*n')
	
	file:close()
	
	if N ~= nil and N ~= '' then
		return tonumber(N)
	else
		return 1
	end
	
	return tonumber(N)
end

function saveN(path, N)
	local file = io.open(path, 'w+')
	
	file:write(N)
	
	file:close()
end

function stopExecution()
	stopped = true
	
	writeWindowCoordinatesToFile(Table, getScriptPath().."\\data\\WinPos.txt", "w+", y1,x1,h1,w1)
	
	saveN(getScriptPath().."\\data\\N.txt", N)
	
	destroyTables()
	
	return 3000
end

function split(str, sep)
	if sep == nil then
		sep = "%s"
	end
	
	local t={}
	local i=1
	
	for str in string.gmatch(str, "([^"..sep.."]+)") do
		t[i] = str
		
		i = i + 1
	end
	
	return t
end

function tabConcat(t1, t2)
	for i = 1, #t2 do
		table.insert(t1, t2[i])
	end

	return t1
end

function round(num, accuracy)
	if num ~= nil and type(num) ~= 'string' then
		if accuracy > 0 then
			return math.floor(num * 10^accuracy + 0.5)/10^accuracy
		end
		
		return math.floor(num + 0.5)
	elseif type(num) == 'string' then
		return num
	else
		return ''
	end
end
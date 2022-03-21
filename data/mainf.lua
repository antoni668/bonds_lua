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
			--str = "0"
		elseif str == "." then
			str = "0."
		end
	end
	return str
end

function stopExecution()
	stopped = true
	writeWindowCoordinatesToFile(Table, getScriptPath().."\\data\\WinPos.txt", "w+", y1,x1,h1,w1)
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
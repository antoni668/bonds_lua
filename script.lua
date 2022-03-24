
-- cd ../../#MyProjects/lua/bonds

dofile (getScriptPath() .. "\\data\\interface.lua")
dofile (getScriptPath() .. "\\data\\mainf.lua")

function OnInit()
	N = loadN(getScriptPath().."\\data\\N.txt")
	Table = AllocTable()
	
	local stopped = false
	local rows = 0
	local list = {}
end

function OnStop()
	stopExecution()
end

function OnClose()
	stopExecution()
end

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

function main()
	rows = #getList('TQOB') + 1 -- Добавить 'TQIR', 'TQCB'
	
	PrintTable(Table, "Достижимые цены", getScriptPath().."\\data\\WinPos.txt", "r")
	while not stopped do

		list = getList('TQOB') -- Добавить 'TQIR', 'TQCB'
		
		y1,x1,h1,w1 = saveWindowCoordinates(Table)
		
		SetCells(Table, list)
		
		SetTableNotificationCallback(Table, f_cb_Table)
		
		sleep(200)
	end
end

---------------------------------------------------------------------------------------------------------------------=
---------------------------------------------------------------------------------------------------------------------

function getAskPrice(t, rows, row)
	local vol
	local price
	
	if rows > 0 then
		vol = tonumber(t.offer[row].quantity) or 0
		price = tonumber(t.offer[row].price) or 0
	end
	
	return price, vol
end

function getBidPrice(t, rows, row)
	local vol
	local price
	
	if rows > 0 then
		vol = tonumber(t.bid[row].quantity)
		price = tonumber(t.bid[row].price)
	end
	
	return price, vol
end

function AverageOfAllAskPrices(t,nom, rows)
	local volume = 0
	local calc = 0
	
	for i = 1, rows do
		local p, v = getAskPrice(t, rows, i)
		
		volume = volume + v
	
		calc = calc + v * p
	end
	
	local result = calc/volume
	
	return result
end

function AverageOfAllBidPrices(t,nom, rows)
	local volume = 0
	local calc = 0
	local j
	
	for i = rows, 1, -1 do
		j = i
		local p, v = getBidPrice(t, rows, i)
		
		volume = volume + v

		calc = calc + v * p
	end
	
	local result = calc/volume

	return result
end

function TargetAverageAskPrice(t, nom, rows, vol)
	local volume = 0
	local volume_sum = 0
	local i = 1
	local calc = 0
	local x = false

	while not x do
		if i > rows then
			return '---'
		end
		
		local p, v = getAskPrice(t, rows, i)
		
		volume_sum = volume_sum + v
		
		if volume_sum > vol then
			v = vol - volume
			
			x = true
		else
			volume = volume_sum
		end

		i = i + 1
		
		calc = calc + v * p		
	end
	
	return calc/vol
end

function TargetAverageBidPrice(t, nom, rows, vol)
	local volume = 0
	local volume_sum = 0
	local i = rows
	local calc = 0
	local x = false
	
	while not x do
		if i < 1 then
			return '---'
		end
		
		local p, v = getBidPrice(t, rows, i)
		
		volume_sum = volume_sum + v
		
		if volume_sum > vol then
			v = vol - volume
			
			x = true
		else
			volume = volume_sum
		end
		
		i = i - 1

		calc = calc + v * p
	end
	
	return calc/vol	
end


-- return list of emitent parameters
function getEmitInfo(ClassCode, SecCode)
	
	local ISIN = getSecurityInfo(ClassCode, SecCode).isin_code
	local nominal = getSecurityInfo(ClassCode, SecCode).face_value
	local reqyired_vol = math.floor((N * 1000000)/nominal)
	local Quotes = getQuoteLevel2(ClassCode, SecCode)
	local ask_rows = tonumber(Quotes.offer_count)
	local bid_rows = tonumber(Quotes.bid_count)
	local best_ask_price, best_ask_vol = getAskPrice(Quotes, ask_rows, 1)
	local best_bid_price, best_bid_vol = getBidPrice(Quotes, bid_rows, bid_rows)
	
	local list = {
			['EMIT'] = SecCode,
			['CLASS'] = ClassCode,
			['ISIN'] = ISIN,
			['NOMINAL'] = nominal,
			['REQUIRED_VOL'] = reqyired_vol,
			['ASK_BEST_PRICE'] = best_ask_price,
			['ASK_ROWS'] = ask_rows,
			['ASK_BEST_VOL'] = best_ask_vol,
			['BID_BEST_PRICE'] = best_bid_price,
			['BID_BEST_VOL'] = best_bid_vol,
			['BID_ROWS'] = bid_rows,
		}

	local average_ask_price
	local average_bid_price	
	local target_average_ask_price = TargetAverageAskPrice(Quotes, nominal, ask_rows, reqyired_vol)
	local target_average_bid_price = TargetAverageBidPrice(Quotes, nominal, bid_rows, reqyired_vol)
	
	if ask_rows > 0 then
		average_ask_price = AverageOfAllAskPrices(Quotes, nominal, ask_rows)
	else
		average_ask_price = '---'
	end
	
	if ask_rows > 0 then
		average_bid_price = AverageOfAllBidPrices(Quotes, nominal, bid_rows)
	else
		average_bid_price = '---'
	end
	
	list['AVERAGE_ASK_PRICE'] = average_ask_price
	list['AVERAGE_BID_PRICE'] = average_bid_price
	list['TARGET_ASK_PRICE'] = target_average_ask_price
	list['TARGET_BID_PRICE'] = target_average_bid_price

	return list
end

-- return list of parameters of all emitents 
function getList(...)
	local list = {}
	local args = table.pack(...)
	
	for i = 1, args.n do
		local classCode = args[i]   
		
		local emit_list = split(getClassSecurities(classCode), ',')
		
		for j = 1, #emit_list do
			local secCode = emit_list[j]
			
			local x = Subscribe_Level_II_Quotes(classCode, secCode) -- order quotes from server
			
			list[j] = getEmitInfo(classCode, secCode)
		end
	end
	
	return list
end


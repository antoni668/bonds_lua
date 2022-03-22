
-- cd ../../#MyProjects/lua/bonds

dofile (getScriptPath() .. "\\data\\interface.lua")
dofile (getScriptPath() .. "\\data\\mainf.lua")

function OnInit()
	edit = false
	N = loadN(getScriptPath().."\\data\\N.txt")
	
	local stopped = false
	local rows = 0
	local list = {}
	local Quotes = {}
	A = 0
end

function OnStop()
	stopExecution()
end

function OnClose()
	stopExecution()
end

--===================================================================================================================
--===================================================================================================================

function main()
	rows = #getList('TQOB') -- Добавить 'TQIR', 'TQCB'
	PrintTable(Table, "Table", getScriptPath().."\\data\\WinPos.txt", "r")
	while not stopped do

		list = getList('TQOB') -- Добавить 'TQIR', 'TQCB'
		y1,x1,h1,w1 = saveWindowCoordinates(Table)
		SetCells(Table, list)
		SetTableNotificationCallback(Table, f_cb_Table)

		sleep(200)
	end
end

--===================================================================================================================
--===================================================================================================================

function getAskPrice(t, rows, row)
	local vol
	local price
	
	if rows > 0 then
		vol = tonumber(t.offer[row].quantity)
		price = tonumber(t.offer[row].price)
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

function AverageOfAllAskPrices(t)
	local nom = t['NOMINAL']
	local rows = t['ASK_ROWS']
	
	local volues = 0
	local i = 1
	local calc = 0
	
	for i = 1, rows do
		local p, v = getAskPrice(t, rows, i)
		volues = volues + v
		i = i + 1
		calc = calc + v * p
	end
	
	return calc/volues
end

function AverageOfAllBidPrices(t)
	local nom = t['NOMINAL']
	local rows = t['ASK_ROWS']
	
	local volues = 0
	local i = 1
	local calc = 0
	
	for i = rows, 1 do
		local p, v = getAskPrice(t, rows, i)
		volues = volues + v
		i = i - 1
		calc = calc + v * p
	end
	
	return calc/volues
end

function TargetAverageAskPrice(t)

	local nom = t['NOMINAL']
	local rows = t['ASK_ROWS']
	local vol = t['REQUIRED_VOL']
	
	local volues = 0
	local i = 1
	local calc = 0
	while volues < vol do
		local p, v = getAskPrice(t, rows, i)
		volues_sum = volues_sum + v
		
		if volues_sum > vol then
			v = vol - volues
		else
			volues = volues_sum
		end
		
		i = i + 1

		calc = calc + v * p
	end
	
	return calc/vol	
end

function TargetAverageBidPrice(t)

	local nom = t['NOMINAL']
	local rows = t['ASK_ROWS']
	local vol = t['REQUIRED_VOL']
	
	local volues = 0
	local i = rows
	local calc = 0
	while volues < vol do
		local p, v = getAskPrice(t, rows, i)
		volues_sum = volues_sum + v
		
		if volues_sum > vol then
			v = vol - volues
		else
			volues = volues_sum
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
	local best_bid_price, best_bid_vol = getABidPrice(Quotes, bid_rows, bid_rows)

	list = {
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
			list[j] = getEmitInfo(classCode, secCode)
		end
	end

	return list
end



--cd ../../#MyProjects/lua/bonds

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

-- Quotation table data

function getEmitParams (ClassCode, SecCode, line)
	
	local Offer_vol
	local Offer_price
	local Offer_count
	
	local Bid_vol
	local Bid_price
	local Bid_count
	
	local Quotes = {}
	
	Quotes = getQuoteLevel2(ClassCode, SecCode)
	Offer_count = tonumber(Quotes.offer_count)
	Bid_count = tonumber(Quotes.bid_count)
	
	if Offer_count > 0 then
		Offer_vol = tonumber(Quotes.offer[1].quantity)
		Offer_price = tonumber(Quotes.offer[1].price)
	end
	
	if Bid_count > 0 then
		Bid_vol = tonumber(Quotes.bid[Bid_count].quantity)
		Bid_price = tonumber(Quotes.bid[Bid_count].price)
	end
	
	return Offer_count, Offer_vol, Offer_price, Bid_count, Bid_vol, Bid_price
end


--Required target level for buying
--[[
function calculateLevel(t, nominal, quantity, operation)
	
	for
	
	Средняя цена аск по которой достижим объем = (1000*94.10+1000*94.15)/2000 = 94.125
end
--]]

-- return list of emitent parameters

function getEmitInfo(ClassCode, SecCode)
	local ISIN = getSecurityInfo(ClassCode, SecCode).isin_code
	local nominal = getSecurityInfo(ClassCode, SecCode).face_value
	local reqyired_quantity = math.floor((N * 1000000)/nominal)

	list = {
		['EMIT'] = SecCode,
		['CLASS'] = ClassCode,
		['ISIN'] = ISIN,
		['NOMINAL'] = nominal,
		['REQUIRED_QUANTITY'] = reqyired_quantity
	}
	
	return list
end


-- return list of all emitents parameters

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


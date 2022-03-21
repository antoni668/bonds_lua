dofile (getScriptPath() .. "\\data\\interface.lua")
dofile (getScriptPath() .. "\\data\\mainf.lua")

function OnInit()
	local stopped = false
	local accS = "NL0011100043"
	local rows = 0
	local sec_list = {}
	local N = 0 -- необходимое количество облигаций
	local Quotes = {}
	A, B, C, D, E, F = 0,0,0,0,0,0
end

function OnStop()
	stopExecution()
end

function OnClose()
	stopExecution()
end

function main()
	--rows = #split(getClassSecurities('TQOB')..getClassSecurities('TQIR'), ',') -- To add 'TQCB'
	rows = #split(getClassSecurities('CETS'), ',')
	PrintTable(Table, "Table", getScriptPath().."\\data\\WinPos.txt", "r")
	while not stopped do

		--sec_list = split(getClassSecurities('TQOB')..getClassSecurities('TQIR'), ',') -- To add 'TQCB'
		sec_list = split(getClassSecurities('CETS'), ',')
		y1,x1,h1,w1 = saveWindowCoordinates(Table)
		A, B, C, D, E, F = getEmitParams ("CETS", "EUR_RUB__TOM") --TEST
		SetCells(Table, ValuesForOutput)

		sleep(200)
	end
end


function getEmitParams (ClassCode, SecCode) -- Данные из стакана по инструменту
	
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

function getTargetLevel (count)
	
end

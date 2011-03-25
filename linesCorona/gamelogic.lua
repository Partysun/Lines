require 'middleclass'
require 'pathfind'
-------------------------------------------------------------------
-- GameLogic - is a main game class , which describe game logic ;)
-- Argument:
--   sides:
--     sides - xCount , yCount - Size of x and y sides of game screen.
--   maxTypes:
--	 	desribe how much types of ball. Standart for classic Lines - 7 types ob ball
--	 addCountBalls:
--		describe how much add balls on the game tabel after each step
-------------------------------------------------------------------
Gamelogic = class('Gamelogic') --this is the same as class('Person', Object) or Object:subclass('Person')

-- Default game screen size in Lines = 9x9
Gamelogic.xCount =  9
Gamelogic.yCount =  9
-- Default ball types = 7
Gamelogic.maxTypes = 7
-- Default Max added Count Balls
Gamelogic.addCountBalls = 3
-- DEFAULT STATIC GAME ARIFACTS VALUE
Gamelogic.MAIN_HERO = 8
Gamelogic.KEY = 9
Gamelogic.CHEST = 10
--
Gamelogic.isHaveKey = false
Gamelogic.isGame = "Process"

Gamelogic.path = 0
-- ќснавна€ таблица всех объектов игрового пол€
local _body = {}
-- ¬спомогательна€ таблица дл€ вычислени€ поиска путей
local _paths = {}

-- ‘лаг описывающий состо€ние выделен ли шар или нет
local ballClick = false

local _spawn = {}

-- ћетод обнулени€ и создани€ таблицы игрового пол€
local _initGameTable = function()
	local body = {}
	for i=1,Gamelogic.xCount do
		-- вставл€ем новую "строку" в двухмерный массив, т.е. заполнение по вертикали
		table.insert(body,{})
		for j=1,Gamelogic.yCount do
			-- заполн€ем массив по горизонтали
			table.insert(body[i],0)
		end
	end
return (body)
end

-- Gamelogic constructor
function Gamelogic:initialize(sides,maxTypes,addCountBalls)
	self.xCount , self.yCount = sides[1], sides[2]
	if maxTypes<=7 then
		self.maxTypes = maxTypes
	end
	self.addCountBalls = addCountBalls
	_body = _initGameTable()

	_paths = setup()--_initGameTable()
	Gamelogic:genArtefacts()
	Gamelogic:print()
end

local count_spawn = 1
----------------------------------
-- Generator game objects block --
----------------------------------
-- Temp fuction for set new value in any position of game table
function Gamelogic:setNewBall( i, j, typeBall)
	if _body[i][j] == 0 then
		print("Spawn ball: ",i,j,typeBall)
--~ 		if count_spawn <= self.addCountBalls then
--~ 			_spawn[count_spawn] = {i,j}
--~ 			count_spawn = count_spawn + 1
--~ 		else
--~ 			count_spawn = 1
--~ 		end
		_body[i][j] = typeBall
		return true
	end
	return false
end

-- √арантированно генерирует в рандомной области объект
function Gamelogic:setNewGarant(ballType)
	local _count = 0
	repeat
		if Gamelogic:setNewBall( math.random(1,self.xCount), math.random(1,self.yCount), ballType) then
			_count = _count + 1
		end
	until _count == 1
end

--Generate balls on the game table
-- Max Count of balls = self.addCountBalls
function Gamelogic:genBalls()
	local _count = 0
	repeat
		local x = math.random(1,self.xCount)
		local y = math.random(1,self.yCount)
		local ballType = math.random(1,self.maxTypes)
		if self:setNewBall( x, y, ballType) then
			_count = _count + 1
		end
	until _count == self.addCountBalls
end

--Generate artefacts on the game table
function Gamelogic:genArtefacts()
	Gamelogic:setNewGarant(Gamelogic.MAIN_HERO)
	Gamelogic:setNewGarant(Gamelogic.KEY)
	Gamelogic:setNewGarant(Gamelogic.CHEST)
end

function Gamelogic:getGameTable()
	return(_body)
end

function Gamelogic:getPathTable()
	return(_paths)
end

-- Check all lines  for delete
local _deleteBallLine = function()
	print("Check game table...")
	-- Delete line or not
	local isDelLine = false
local _temp = _initGameTable()
	-- vertical line check:
	for i=1,7 do
		for j=1,9 do
			if (_body[i][j]==_body[i+1][j]) and (_body[i][j]==_body[i+2][j]) and (_body[i][j]>0) then
				_temp[i][j] = -1
				_temp[i+1][j] = -1
				_temp[i+2][j] = -1
			end
		end
	end
	-- horizontal line check:
	for i=1,9 do
		for j=1,7 do
			if (_body[i][j]==_body[i][j+1]) and (_body[i][j]==_body[i][j+2]) and (_body[i][j]>0) then
				_temp[i][j] = -1
				_temp[i][j+1] = -1
				_temp[i][j+2] = -1
			end
		end
	end
	-- main diagonal line check:
	for i=1,7 do
		for j=1,7 do
			if (_body[i][j]==_body[i+1][j+1]) and (_body[i][j]==_body[i+2][j+2]) and (_body[i][j]>0) then
				_temp[i][j] = -1
				_temp[i+1][j+1] = -1
				_temp[i+2][j+2] = -1
			end
		end
	end

	-- not main diagonal line check:
	for i=1,7 do
		for j=2,9 do
			if (_body[i][j]==_body[i+1][j-1]) and (_body[i][j]==_body[i+2][j-2]) and (_body[i][j]>0) then
				_temp[i][j] = -1
				_temp[i+1][j-1] = -1
				_temp[i+2][j-2] = -1
			end
		end
	end



	for i=1,9 do
		for j=1,9 do
			if _temp[i][j] == -1 then
				_body[i][j] = 0
				_temp[i][j] = 0
				isDelLine = true
				print("Delete ball")
			end
		end
	end
	return (isDelLine)
end

-- Move Ball
function Gamelogic:moveBall(xPosBall,yPosBall,xTarget,yTarget)
	--CHECK VALID INPUT VALUE
	--if _body[xPosBall][yPosBall] ~= 0 and _body[xTarget][yTarget] == 0 then
		--MOVE BALL
		print("Move ball")
		_body[xTarget][yTarget] = _body[xPosBall][yPosBall]
		_body[xPosBall][yPosBall] = 0
		if _deleteBallLine() == false then
			--generate new balls
			Gamelogic:genBalls()
		end
	--end
end

-- –екурсивна€ функци€ обхода €чеек таблицы.
-- ѕровер€ем соседнии и если €чейки зан€ты то ставим 1
-- ѕродолжаем провер€ть пока не пройдем все возможные варианты.
pathFinder = function(x,y)
	for i=x-1,x+1 do
		for j=y-1,y+1 do
			if (i >= 1) and (i <= Gamelogic.xCount) and (j >= 1) and (j <= Gamelogic.yCount)
			and (_body[i][j]==0) and (_paths[i][j].isObstacle == 0) then
				 local continue = false
				 if (i==x-1) and (j==y-1) then continue = true
				 end
				 if (i==x+1) and (j==y-1) then continue = true
				 end
				 if (i==x+1) and (j==y+1) then continue = true
				 end
			     if (i==x-1) and (j==y+1) then continue = true
				 end
				 if continue ~= true then
					_paths[i][j].isObstacle = 1
					pathFinder(i,j)
				 end
			end
		end
	end
end

-- Event onClickTable , when smb click on the game table ;) Yes! Click!!!
function Gamelogic:onClickTable(i,j)
	x , y = j , i
	print ("MouseClick",x,y)
	print (_body[x][y])
	--local xTemp = 0
	--local yTemp = 0
	-- If ball?
	if _body[x][y]>0 and _body[x][y] <= Gamelogic.MAIN_HERO then
		self.path = 0
		--//очистка массива дл€ последующего поиска пути
		_paths = setup()
		xTemp = x
		yTemp = y
		ballClick = true
		--
		-- path find for x,y ball..
		--
		pathFinder(x,y)
		Gamelogic:printTemp()
		return true
	end
--check step by hero
	if ballClick == true and _body[xTemp][yTemp] == Gamelogic.MAIN_HERO and _paths[x][y].isObstacle == 1 then
		if _body[x][y] == Gamelogic.KEY then
			self.path = getPath(_paths,xTemp,yTemp,x,y)
			Gamelogic:moveBall(xTemp,yTemp,x,y)
			self.isHaveKey = true
		end
		if _body[x][y] == Gamelogic.CHEST and self.isHaveKey == true then
			self.path = getPath(_paths,xTemp,yTemp,x,y)
			Gamelogic:moveBall(xTemp,yTemp,x,y)
			self.isGame = "Win"
		end
	end
	-- If Zero?
	if _body[x][y]==0 and ballClick == true and _paths[x][y].isObstacle == 1 then
		ballClick = false
		self.path = getPath(_paths,xTemp,yTemp,x,y)
		Gamelogic:moveBall(xTemp,yTemp,x,y)
		return false
	end

	return false
end

getPath = function(board,xs,ys,xf,yf)
	local path = CalcPath(CalcMoves(board, xs, ys, xf, yf))
	if path ~= nil then
	for i = 1, table.getn(path) do
		local newX = path[i].x
		local newY = path[i].y
		print("X: " .. newX .. "    Y: " .. newY)
		--local marker = display.newCircle((newX*32 - 16), (newY*32 - 16), 8)
		--marker:setFillColor(255, 174, 0)
	end
	return path
	end
end

-- ¬ыводит таблицу путей дл€ ball
function Gamelogic:printTemp()
	-- выводим содержимое двухмерного массива
	local str = "";
	for i=1,self.xCount do
	-- каждую "строку" массива будем сначала собирать в строку, чтобы
	-- привести ее к удобочитаемому табличному виду
	for j=1,self.yCount do
		str = str.."\t".._paths[i][j].isObstacle
	end
	-- выводим строку
	str= str.."\r\n"
	end
	print("\r\n"..str,"")
	--
end

function Gamelogic:print()
	--print('{' .. self.xCount ..'.'.. self.yCount .. '}')
	--print('maxTypes = ' .. self.maxTypes)
	-- выводим содержимое двухмерного массива
	local str = "";
	for i=1,self.xCount do
	-- каждую "строку" массива будем сначала собирать в строку, чтобы
	-- привести ее к удобочитаемому табличному виду
	for j=1,self.yCount do
		str = str.."\t".._body[i][j]
	end
	-- выводим строку
	str= str.."\r\n"
	end
	print("\r\n"..str,"")
	--
end

print("Gamelogic class init...")





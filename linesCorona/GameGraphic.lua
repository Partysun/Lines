require 'middleclass'
require 'gamelogic'
-------------------------------------------------------------------
-- GameGraphic - is a game graphic class , which describe game out graphic ;)
-- Argument:
-------------------------------------------------------------------
GameGraphic = class('GameGraphic') --this is the same as class('Person', Object) or Object:subclass('Person')

GameGraphic.isUpdate = true

-- Логическая таблица содержащая игровые объекты.
local _bodyTable = {}

-- floor - Пол игровой сцены: содержащий плитки
local _floor = display.newGroup()
--_gameTable - игровая доска: содержит шарики и игрока с артефактами
local _gameTable = display.newGroup()

pathTableView = {}

-- TEXTURE PATH
local textures_path = ""

-- Статики цветов
--               Желтый ,    Голубой ,    Синий ,      Зеленый ,    Оранжевый ,   Розовый ,      Красный
local typeColors = { {255,255,0},{0,255,255},{0,51,255},{51,255,51},{255,153,0},{255,51,102},{255,0,0}}

-- GameGraphic constructor
function GameGraphic:initialize()
	print("Init Game Graphic...")
end

function GameGraphic:setGameTable(bodyTable)
	_bodyTable = bodyTable
end

function GameGraphic:initGameScreen()
	if _bodyTable ~= nil then
	for i=1,Gamelogic.xCount do
			for j=1,Gamelogic.yCount do
					local rect = display.newRect(53.5*j, 30*i, 51, 28)
					rect:setFillColor(170, 170, 170)
					_floor:insert(rect)
					_typeBalls = _bodyTable[i][j]
				if _typeBalls == 8 then
					local heroImage = display.newImageRect(textures_path.."hero.png", 26, 26)
					heroImage.x = 53.5*j+27
					heroImage.y = 30*i+15
					heroImage.description = "hero"
					heroImage.xfoo = i
					heroImage.yfoo = j
					_gameTable:insert(heroImage)
				end
				if _typeBalls == 9 then
					local keyImage = display.newImageRect(textures_path.."key.png", 26, 26)
					keyImage.x = 53.5*j+27
					keyImage.y = 30*i+15
					keyImage.description = "key"
					keyImage.xfoo = i
					keyImage.yfoo = j
					_gameTable:insert(keyImage)
				end
				if _typeBalls == 10 then
					local chestImage = display.newImageRect(textures_path.."chest.png", 26, 32)
					chestImage.x = 53.5*j+27
					chestImage.y = 30*i+15
					chestImage.description = "chest"
					chestImage.xfoo = i
					chestImage.yfoo = j
					_gameTable:insert(chestImage)
				end
				if _typeBalls ~= 0 and _typeBalls <= 7 then
					local circle = display.newCircle(53.5*j+27, 30*i+15, 12)
					circle:setFillColor(typeColors[_typeBalls][1],typeColors[_typeBalls][2],typeColors[_typeBalls][3])
					circle.description = "ball"
					circle.xfoo = i
					circle.yfoo = j
					_gameTable:insert(circle)
				end
			end
		end
	end

	_floor.x = -53
	_floor.y = 20.5
	_gameTable.x = -53
	_gameTable.y = 20.5
end

-- Появление новых игровых шаров
function GameGraphic:spawnBalls()
	for i=1,Gamelogic.xCount do
		for j=1,Gamelogic.yCount do
				_typeBalls = _bodyTable[i][j]
				if _typeBalls ~= 0 and _typeBalls <= 7 then
					local circle = display.newCircle(53.5*j+27, 30*i+15, 12)
					circle:setFillColor(typeColors[_typeBalls][1],typeColors[_typeBalls][2],typeColors[_typeBalls][3])
					circle.description = "ball"
					circle.xfoo = i
					circle.yfoo = j
					_gameTable:insert(circle)
				end
		end
	end
end
-- Все графические изменения после действий игрока
function GameGraphic:update()

end

function GameGraphic:drawScreen(gameTable, pathTableView, body, pathTable)
	print"startdraw"

	--               Желтый ,    Голубой ,    Синий ,      Зеленый ,    Оранжевый ,   Розовый ,      Красный
	typeColors = { {255,255,0},{0,255,255},{0,51,255},{51,255,51},{255,153,0},{255,51,102},{255,0,0}}

	for i=1,Gamelogic.xCount do
		for j=1,Gamelogic.yCount do
			local rect = display.newRect(53.5*j, 30*i, 51, 28)
			rect:setFillColor(170, 170, 170)
					gameTable:insert(rect)
				_typeBalls =body[i][j]
			if _typeBalls ~= 0 and _typeBalls <= 7 then
				local circle = display.newCircle(53.5*j+27, 30*i+15, 12)
				circle:setFillColor(typeColors[_typeBalls][1],typeColors[_typeBalls][2],typeColors[_typeBalls][3])
				gameTable:insert(circle)
			end
			if _typeBalls == 8 then
				local heroImage = display.newImageRect(textures_path.."hero.png", 26, 26)
				heroImage.x = 53.5*j+27
				heroImage.y = 30*i+15
				gameTable:insert(heroImage)
			end
			if _typeBalls == 9 then
				local keyImage = display.newImageRect(textures_path.."key.png", 26, 26)
				keyImage.x = 53.5*j+27
				keyImage.y = 30*i+15
				gameTable:insert(keyImage)
			end
			if _typeBalls == 10 then
				local keyImage = display.newImageRect(textures_path.."chest.png", 26, 32)
				keyImage.x = 53.5*j+27
				keyImage.y = 30*i+15
				gameTable:insert(keyImage)
			end
			if pathTable[i][j].isObstacle == 1 then
				local rect = display.newRect(53.5*j, 30*i, 51, 28)
				rect:setFillColor(0, 180, 255)
				pathTableView:insert(rect)
			end
			if pathTable[i][j].isObstacle == 1 and (body[i][j] == Gamelogic.KEY or body[i][j] == Gamelogic.CHEST) then
				local border = display.newRect(53.5*j, 30*i, 51, 28)
				border.strokeWidth = 2
				border:setStrokeColor(255, 0, 0)
				pathTableView:insert(border)
				local rect = display.newRect(53.5*j, 30*i, 51, 28)
				rect:setFillColor(0, 180, 255)
				pathTableView:insert(rect)
			end
		end
	end
	gameTable.x = -53
	gameTable.y = 20.5
	pathTableView.x = -53
	pathTableView.y = 20.5
		for i=1,gameTable.numChildren do
  local child = gameTable[i]
  local description = (gameTable.isVisible and "visible") or "not visible"
  print( "child["..i.."] is " .. tostring(gameTable[i].x) )
  end
	print "stopdraw"
end

-- Отрисовывает анимацию движения объектов
function GameGraphic:animate(path)

	if path ~= 0 then
	print "CHANGE ISUPDATE"
self.isUpdate = false
		local i = 1
		local marker
		local max_path = table.getn(path)
		for i=1,_gameTable.numChildren do
		  local child = _gameTable[i]
		  if child.xfoo == path[1].x and child.yfoo == path[1].y then
			marker = child
			child.xfoo = path[max_path].x
			child.yfoo = path[max_path].y
		  end
		end
			listener = function()
				i = i + 1
				if i<=max_path then
					local newX = path[i].y
					local newY = path[i].x
					transition.to( marker, { time=500, x=((newX*53.5 + 27)), y=(newY*30 + 15), onComplete=listener } )
				else
					GameGraphic:updatescreen()
					self.isUpdate = true
				end
			end
		listener()
	else
		self.isUpdate = true
	end
end

-- Отрисовывает изменения в игровом поле после хода
-- Удаление, появление новых.
function GameGraphic:updatescreen()
	for i=1,Gamelogic.xCount do
			for j=1,Gamelogic.yCount do
				local _typeBalls = _bodyTable[i][j]
				local continue = false
				for n=1,_gameTable.numChildren do
				  local child = _gameTable[n]
				  print ("CHISLO:" .. _gameTable.numChildren)
				  if child ~= nil then
					  if child.xfoo == i and child.yfoo == j then
						if _typeBalls == 0 then
							--print ("NULL: " .. i .. " .. " .. j)
							child:removeSelf()
							-- Сделать анимацию уничтожения игровых шаров
							child = nil
						end
						continue = true
					  end
					end
				end
				if continue ~= true then
					if _typeBalls ~= 0 and _typeBalls <= 7 then
						-- Сделать анимацию спавна игровых шаров
						local circle = display.newCircle(53.5*j+27, 30*i+15, 12)
						circle:setFillColor(typeColors[_typeBalls][1],typeColors[_typeBalls][2],typeColors[_typeBalls][3])
						circle.description = "ball"
						circle.xfoo = i
						circle.yfoo = j
						_gameTable:insert(circle)
					end
				end
			end
	end
	self.isUpdate = true
end




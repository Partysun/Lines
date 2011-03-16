require 'middleclass'
require 'gamelogic'
-------------------------------------------------------------------
-- GameGraphic - is a game graphic class , which describe game out graphic ;)
-- Argument:
-------------------------------------------------------------------
GameGraphic = class('GameGraphic') --this is the same as class('Person', Object) or Object:subclass('Person')

-- TEXTURE PATH
local textures_path = ""

-- GameGraphic constructor
function GameGraphic:initialize()
	print("Init Game Graphic...")
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
			if pathTable[i][j] == 1 then
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
	print "stopdraw"
end

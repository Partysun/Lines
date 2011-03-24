require 'gamelogic'


function love.load()	
    -- GL - Model of Game
    gl = Gamelogic:new({9,9},6,4)
    gl:genBalls()
    love.graphics.setBackgroundColor(200, 200, 200)
    local textures_path = "textures/"
    heroImg = love.graphics.newImage(textures_path.."hero.png")
    keyImg = love.graphics.newImage(textures_path.."key.png")
    chestImg = love.graphics.newImage(textures_path.."chest.png")
    --touch = ""
end



local drawscreen = function()
	--               Желтый ,    Голубой ,    Синий ,      Зеленый ,    Оранжевый ,   Розовый ,      Красный
	typeColors = { {255,255,0},{0,255,255},{0,51,255},{51,255,51},{255,153,0},{255,51,102},{255,0,0}}
	for i=1,gl.xCount do
		for j=1,gl.yCount do
			love.graphics.setColor(160, 160, 160, 255)
			love.graphics.rectangle("fill", 53.5*j, 30*i, 51, 28 )
			_typeBalls =gl:getGameTable()[i][j]
			if _typeBalls ~= 0 and _typeBalls <= 7 then
				love.graphics.setColor(typeColors[_typeBalls][1],typeColors[_typeBalls][2],typeColors[_typeBalls][3], 255)				
				love.graphics.circle("fill", 53.5*j+27, 30*i+15, 12)
			end
			if _typeBalls == 8 then
				love.graphics.setColor(255, 255, 255, 255)
				love.graphics.draw(heroImg, 53.5*j +12, 30*i, 0, 1, 1)
			end
			if _typeBalls == 9 then
				love.graphics.setColor(255, 255, 255, 255)
				love.graphics.draw(keyImg, 53.5*j +15, 30*i+3, 0, 1, 1)
			end

			if _typeBalls == 10 then
				love.graphics.setColor(255, 255, 255, 255)
				love.graphics.draw(chestImg, 53.5*j +15, 30*i-5, 0, 1, 1)
			end
		end
	end
end    

function love.mousepressed( x, y, button )
 if love.mouse.isDown("l") then
        local x, y = love.mouse.getPosition( )        
	x = math.floor(x / 53.5)
	y = math.floor(y / 30)
	--love.graphics.print('Event: touch: ' .. x .. " , " .. y, 150, 10)
	gl:onClickTable(x,y)
	--love.graphics.print('Game state: '.. gl.isGame, 150, 10)
        drawscreen()
	
	
        --pathTableView.isVisible = gl:onClickTable(x,y)
    end
end

function love.draw()
    love.graphics.setColor(255, 40, 40, 100)
    love.graphics.print('Lines ALPHA VER: 0.04', 10, 10)
    love.graphics.setColor(40, 40, 40, 100)
    drawscreen()
	if gl.isGame == "Win" then 
		love.graphics.clear()
		love.graphics.setColor(255, 40, 40, 255)
		love.graphics.print('GAME WIN! ;)', 150, 50)
	elseif 	gl.isGame == "Process" then 
		love.graphics.print('Game Process...',50,50)
	elseif gl.isGame == "Lose" then 
		love.graphics.print('Game Lose ;(',50,50)
	end	
end

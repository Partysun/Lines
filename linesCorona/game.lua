require 'gamelogic'
require 'GameGraphic'


module(..., package.seeall)

-- Main function - MUST return a display.newGroup()
function new()
	local localGroup = display.newGroup()


-- GL - Model of Game
local gl = Gamelogic:new({9,9},6,4)
-- GG - View of Game
local gg = GameGraphic:new()

gl:genBalls()

--print all gamelogic information.
gl:print()

local timer = 10 * 1000 -- in millsec 220 second

--display.setStatusBar( display.HiddenStatusBar )

-- Create a gray background
--local background = display.newRect(display.screenOriginX,display.screenOriginY, 480-2*display.screenOriginX, 320-display.screenOriginY )
--background:setFillColor(0, 80)
--local background = display.newRect(0,0, 480, 320)
--background:setFillColor(255, 80)
local backgroundUp = display.newImage( "wall.png" )
--display.newRect(0,0, 480, 50)
--backgroundUp:setFillColor(20, 80)

 --local gameTable = display.newGroup()
 local pathTableView = display.newGroup()
 pathTableView.isVisible = false
 --gg:drawScreen(gameTable, pathTableView, gl:getGameTable(), gl:getPathTable())

 gg:setGameTable(gl:getGameTable())
 -- Отрисовываем игровое поле
 gg:initGameScreen()

-- Touch event on gameTable
function touch(event)
	if event.phase == "began" then
	if (event.y > 50) then
		pathTableView.isVisible = false
		pathTableView = nil
		pathTableView = display.newGroup()
		if gg.isUpdate == true then
			local temp_y = event.y - 50
			local x = math.floor(event.x / 53.5)+1
			local y = math.floor(temp_y / 30)+1
			gg.isUpdate = false
			pathTableView.isVisible = gl:onClickTable(x,y)
			if pathTableView.isVisible == true then
				pathTableView = gg:renderpath(gl:getPathTable())
			end
			gg:animate(gl.path)
			gl.path = nil
		end
	end
	end
end

local function gameLoop(event)
--~ 	print("Timer: " .. timer - system.getTimer())
--~ 	if system.getTimer() > timer then
--~ 		print("Time is over! ;)")
--~ 	end
	--print (gg.isUpdate)
 end

 -- Call the gameLoop function EVERY frame,
 -- e.g. gameLoop() will be called 30 times per second ir our case.
	Runtime:addEventListener("enterFrame", gameLoop)
	Runtime:addEventListener("touch", touch)


	-- MUST return a display.newGroup()
	return localGroup
end





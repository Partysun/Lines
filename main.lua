require 'gamelogic'
require 'GameGraphic'

-- GL - Model of Game
local gl = Gamelogic:new({9,9},6,4)
-- GG - View of Game
local gg = GameGraphic:new()

gl:genBalls()

--print all gamelogic information.
gl:print()

--display.setStatusBar( display.HiddenStatusBar )


-- Create a gray background
--local background = display.newRect(display.screenOriginX,display.screenOriginY, 480-2*display.screenOriginX, 320-display.screenOriginY )
--background:setFillColor(0, 80)

local background = display.newRect(0,0, 480, 320)
background:setFillColor(255, 80)
local backgroundUp = display.newRect(0,0, 480, 50)
backgroundUp:setFillColor(20, 80)

 local gameTable = display.newGroup()
 local pathTableView = display.newGroup()
 pathTableView.isVisible = false
 gg:drawScreen(gameTable, pathTableView, gl:getGameTable(), gl:getPathTable())

-- Touch event on gameTable
function gameTable:touch(event)
	if event.phase == "began" then
		local temp_y = event.y - 50
		local x = math.floor(event.x / 53.5)+1
		local y = math.floor(temp_y / 30)+1
		pathTableView.isVisible = gl:onClickTable(x,y)
		gg:drawScreen(gameTable, pathTableView, gl:getGameTable(), gl:getPathTable())
		end
	if event.phase == "ended" then
		pathTableView.isVisible = false
		pathTableView = display.newGroup()
	end
end

 gameTable:addEventListener("touch", gameTable)

 local function gameLoop(event)
 --print("frame")
 end

 -- Call the gameLoop function EVERY frame,
 -- e.g. gameLoop() will be called 30 times per second ir our case.
	Runtime:addEventListener("enterFrame", gameLoop)

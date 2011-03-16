require 'gamelogic'

local gl = Gamelogic:new({9,9},6,4)

--print all gamelogic information.
gl:genBalls()

gl:setNewBall( 1, 1, 4)
gl:setNewBall( 2, 1, 4)
gl:setNewBall( 3, 1, 0)
gl:setNewBall( 4, 1, 4)

gl:print()

local answer
repeat
   io.write(">>")
   io.flush()
   answer=io.read()
    if answer == "move" then
		io.write(">>x == ")
		xPos = io.read()
		io.write(">>y == ")
		yPos = io.read()
		io.write(">>x2 == ")
		x2 = io.read()
		io.write(">>y2 == ")
		y2 = io.read()
		gl:moveBall( xPos+0, yPos+0, x2+0, y2+0)
	end
	if answer == "table" then
		gl:print()
	end
until answer=="quit" or answer=="quit()"

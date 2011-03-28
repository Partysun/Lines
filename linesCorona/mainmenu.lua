
--
-- Abstract: Ghosts Vs Monsters sample project
-- Designed and created by Jonathan and Biffy Beebe of Beebe Games exclusively for Ansca, Inc.
-- http://beebegamesonline.appspot.com/

-- (This is easiest to play on iPad or other large devices, but should work on all iOS and Android devices)
--
-- Version: 1.0
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.





module(..., package.seeall)

--***********************************************************************************************--
--***********************************************************************************************--

-- mainmenu

--***********************************************************************************************--
--***********************************************************************************************--

-- Main function - MUST return a display.newGroup()
function new()
	local menuGroup = display.newGroup()

	local ui = require("ui")
	local ghostTween
	local ofTween
	local playTween
	local isLevelSelection = false

	-- AUDIO
	--local tapSound = audio.loadSound( "tapsound.wav" )
	--local backgroundSound = audio.loadStream( "rainsound.mp3" )	--> This is how you'd load music

	local drawScreen = function()
		-- BACKGROUND IMAGE
		local backgroundImage = display.newImageRect( "mainmenu.png", 480, 320 )
		backgroundImage.x = 240; backgroundImage.y = 160

 		menuGroup:insert( backgroundImage )

		-- Title : WIZARD
 		local menutitle1 = display.newImageRect("title1.png", 328, 102)
 		menutitle1.x = 160; menutitle1.y =50

		menuGroup:insert( menutitle1 )

		-- Title 2 : GOLD OF KINGS
 		local menutitle2 = display.newImageRect("title2.png", 146, 83)
 		menutitle2.x = 235; menutitle2.y = 135

		menuGroup:insert( menutitle2 )

		-- Wall for buttons
 		local wall = display.newImageRect("wallmenu.png", 190, 320)
 		wall.x = 600; wall.y = 160

		-- PLAY BUTTON
		local playBtn
		-- SETTINGS BUTTON
		local setBtn
		-- QUIT BUTTON
		local quitBtn

		-- SLIDE PLAY AND OPENFEINT BUTTON FROM THE BOTTOM:
		local setPlayBtn = function()
			local quitBtnAnim = function()
				quitSet = transition.to( quitBtn, { time=100, x=407 } )
			end

			local setBtnAnim = function()
				playSet = transition.to( setBtn, { time=100, x=407 ,onComplete=quitBtnAnim} )
			end

			playTween = transition.to( playBtn, { time=100, x=407 ,onComplete=setBtnAnim} )
--~ 			local setOfBtn = function()
--~ 				ofTween = transition.to( ofBtn, { time=100, x=268, y=325 } )
--~ 			end
--~			ofTween = transition.to( ofBtn, { time=500, y=320, onComplete=setOfBtn, transition=easing.inOutExpo } )
		end

		local onPlayTouch = function( event )
			if event.phase == "release" then
				director:changeScene( "loadgame" )
			end
		end

		menuGroup:insert( wall )
		playTween = transition.to( wall, { time=1200, x=385, onComplete=setPlayBtn, transition=easing.inOutExpo } )

		playBtn = ui.newButton{
			defaultSrc = "playbtn.png",
			defaultX = 145,
			defaultY = 73,
			overSrc = "playbtn.png",
			overX = 145,
			overY = 73,
			onEvent = onPlayTouch,
			id = "PlayButton",
			text = "",
			font = "Helvetica",
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}

		playBtn.x = 700 playBtn.y = 50

		menuGroup:insert( playBtn )

		setBtn = ui.newButton{
			defaultSrc = "settings.png",
			defaultX = 145,
			defaultY = 73,
			overSrc = "settings.png",
			overX = 145,
			overY = 73,
			onEvent = onPlayTouch,
			id = "SettingsButton",
			text = "",
			font = "Helvetica",
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}

		setBtn.x = 700 setBtn.y = 130

		menuGroup:insert( setBtn )

		quitBtn = ui.newButton{
			defaultSrc = "quit.png",
			defaultX = 145,
			defaultY = 73,
			overSrc = "quit.png",
			overX = 145,
			overY = 73,
			onEvent = onPlayTouch,
			id = "QuitButton",
			text = "",
			font = "Helvetica",
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}

		quitBtn.x = 700 quitBtn.y = 210

		menuGroup:insert( quitBtn )


	end

	drawScreen()
	--audio.play( backgroundSound, { channel=1, loops=-1, fadein=5000 }  )

	unloadMe = function()
		if ghostTween then transition.cancel( ghostTween ); end
		if ofTween then transition.cancel( ofTween ); end
		if playTween then transition.cancel( playTween ); end

		--if tapSound then audio.dispose( tapSound ); end
	end

	-- MUST return a display.newGroup()
	return menuGroup
end

-- example program 

local dialog = require("lib/dialog")
local cursor = require("lib/cursor")

function love.load()
	math.randomseed(os.time())
	love.graphics.setBackgroundColor(120,120,120)
	
	field = love.graphics.newImage("tiles/field.png")
	tux = love.graphics.newImage("tiles/tux.png")
	
	cursor:new("cursors/2.png")
	dialog:newmenu(
		{
		[1] = { name = "Text dialog", action = function() dialog:new("Message", "This is a test!",love.mouse.getX(),love.mouse.getY(),100,"left",true) end },
		[2] = { name = "Image 1", action = function() dialog:new("Grass",field,love.mouse.getX(),love.mouse.getY(),field:getWidth(),nil,true) end },
		[3] = { name = "Image 2", action = function() dialog:new("Tux",tux,love.mouse.getX(),love.mouse.getY(),tux:getWidth(),nil,true) end },
		[4] = { name = "Dummy", action = function() return end },
		[5] = { name = "Cancel", action = function() dialog.menu.active = false end },
		}
	)
	

end

function love.draw()
	
	
	dialog:draw()


	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Press [space] to spawn a dialog, [right click] for menu.",5,5)
end


function love.update(dt)
	dialog:update(dt)
end


function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	
	if key == " " then
		
		local n = math.random(0,2)
		local align = (n == 0 and "left" or n == 1 and "center" or n == 2 and "right")

		dialog:new(
		"Hello!",																--title text
		"This is a test message.\n\nYou can close this by clicking the button.",--message text
		math.random(0,love.graphics.getWidth()),								--x
		math.random(0,love.graphics.getHeight()), 								--y
		math.random(50,250),													--maximum width
		align,																	--alignment
		true																	--can shade?
		)
		
	end
end

function love.mousepressed(x,y,button)
	dialog:mousepressed(x,y,button)
end

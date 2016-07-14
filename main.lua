-- example program for dialog library

require("lib/dialog")

function love.load()
	math.randomseed(os.time())
	love.graphics.setBackgroundColor(100,100,100)
end

function love.draw()
	dialog:draw()
	
	love.graphics.setColor(0,0,0,100)
	love.graphics.rectangle("fill", 0,0,215,25)
	love.graphics.setColor(255,255,255,200)
	love.graphics.print("Press [space] to spawn a dialog",5,5)
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

		dialog:create(
		"Warning!",																--title text
		"This is a test message.\n\nYou can close this by clicking the button.",--message text
		math.random(0,love.graphics.getWidth()),								--x
		math.random(0,love.graphics.getHeight()), 								--y
		math.random(50,250),													--maximum width
		align
		)
		
	end
end

function love.mousepressed(x,y,button)
	dialog:mousepressed(x,y,button)
end

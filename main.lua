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
		dialog:create(
			"Test",
			"This is a test message.\n\nYou can close this message by clicking the button",
			math.random(0,love.graphics.getWidth()),
			math.random(0,love.graphics.getHeight()),
			150,
			math.random(50,200),
			0,
			0
		)
	end
end

function love.mousepressed(x,y,button)
	dialog:mousepressed(x,y,button)
end

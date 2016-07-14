
cursor = {}
cursor.list = {}

function cursor:new(image)
	local c = love.mouse.newCursor(image, 0, 0 )
	love.mouse.setCursor(c)
end


function cursor:draw()
	--TODO
	--used for click effect animation
end

function cursor:update(dt)
	--TODO
	--used for click effect animation
end

return cursor

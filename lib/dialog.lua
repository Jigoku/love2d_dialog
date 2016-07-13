--[[
 * Copyright (C) 2016 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 
 ------------
    Setup
 ------------
 place dialog:draw() in your love.draw() routine
 place dialog:update(dt) in your love.update() routine
 place dialog:mousepressed(x,y,button) in your love.mousepressed() routine
 
 spawn a dialog message:
 	dialog:create("Test","This is a test message",100,150,200)
 
 
 --]]
 
dialog = {
	title_padding = 5,
	message_padding = 10,
	title_height = 25,
	title_font = love.graphics.newFont(14),
	message_font = love.graphics.newFont(12),
	min_width = 150,
	fade_speed = 1000,
	opacity = 200,
	
	colours = {
		background = { 30,30,30,255 },
		title = { 120,40,40,255 },
		button = { 130,130,130,255 },
		border = { 0,0,0,255 },
		title_text = { 200,200,200,255 },
		message_text = { 200,200,200,255 }
	}
}



dialog.list = {}


function dialog:setColour(t)
	love.graphics.setColor(t[1],t[2],t[3],t[4])
end

function dialog:create(title,message,x,y,w)
	if w < self.min_width then w = self.min_width end
	
	local _,lines  = self.message_font:getWrap(message, w-self.message_padding*2)
	local h = self.message_font:getHeight() * lines+ self.title_height + self.title_padding*4

	table.insert(self.list, {
		--title = title,
		title = title,
		message = message,
		x = x,
		y = y,
		w = w,
		h = h,
		state = 0,
		canvas = love.graphics.newCanvas(w,h),
		opacity = 0,
	})
end

function dialog:draw()

		
	for _,d in ipairs(self.list) do
		love.graphics.setCanvas(d.canvas)
		d.canvas:clear()
			
		--background
		self:setColour(self.colours.background)
		love.graphics.rectangle("fill", 0,0,d.w,d.h )
			
		--frame
		self:setColour(self.colours.border)
		love.graphics.rectangle("line", 0,0,d.w,d.h )
			
		--title
		self:setColour(self.colours.title)
		love.graphics.rectangle("fill", 0,0,d.w,self.title_height)
			
		--frame
		self:setColour(self.colours.border)
		love.graphics.rectangle("line", 0,0,d.w,self.title_height )
				
		--button
		self:setColour(self.colours.button)
		local s = self.title_height-(self.title_padding*2)
		local x = d.w-s-self.title_padding
		local y = self.title_padding
			
		love.graphics.rectangle("fill", x,y,s,s )
		self:setColour(self.colours.border)
		love.graphics.rectangle("line", x,y,s,s )
			
		local pad = 5
		love.graphics.line(x+pad,y+pad,x+s-pad,y+s-pad)
		love.graphics.line(x+s-pad,y+pad,x+pad,y+s-pad)
		
		--title text
		self:setColour(self.colours.title_text)	
			
		love.graphics.setFont(self.title_font)
		love.graphics.printf(d.title, self.title_padding,self.title_padding,0,"left",0,1,1)
		
		--message text
		self:setColour(self.colours.message_text)
		love.graphics.setFont(self.message_font)
		love.graphics.printf(
			d.message, 
			self.message_padding,
			self.message_padding+self.title_height,
			d.w-self.message_padding*2,
			"left",0,1,1
		)
		
		love.graphics.setCanvas()
			
		--draw the message box
		love.graphics.setColor(255,255,255,d.opacity)
		love.graphics.draw(d.canvas, d.x,d.y)
	end
end


function dialog:update(dt)
	for i=#self.list,1,-1 do
		local d = self.list[i]
		if d.state == 0 then	
			d.opacity = d.opacity + self.fade_speed *dt
			if d.opacity > self.opacity then
				d.opacity = self.opacity 
				d.state = 1
			end
		end
		if d.state == 2 then
			d.opacity = d.opacity - self.fade_speed *dt
			if d.opacity < 0 then
				table.remove(self.list, i)
			end
		end
	end
end

function dialog:mousepressed(x,y,button)
	if #self.list < 1 then return end
	
	for i=#self.list,1,-1 do
		local d = self.list[i]
		local s = self.title_height-(self.title_padding*2)
		local x2 = d.x+d.w-s-self.title_padding
		local y2 = d.y+self.title_padding
		
		if self:check_collision(x,y,0,0,d.x,d.y,d.w,d.h) then
			if button == "l" then
				if self:check_collision(x,y,0,0,x2,y2,s,s) then
					d.state = 2
				end
				return
			end
		end
		
	end
	
end

function dialog:check_collision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
		 x2 < x1+w1 and
		 y1 < y2+h2 and
		 y2 < y1+h1
end

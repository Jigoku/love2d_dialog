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
 	dialog:new("Test","This is a test message",100,150,200,"left")
 
 
 --]]

dialog = {
	title_padding = 5,
	message_padding = 10,
	menu_padding = 10,
	title_height = 25,
	title_font = love.graphics.newFont(13),
	message_font = love.graphics.newFont(11),
	menu_font = love.graphics.newFont(12),
	min_width = 50,
	fade_speed = 1000,
	opacity = 255,
	
	-- title_image = nil,
	title_image = love.graphics.newImage("titlebars/3.png"),
	
	colours = {
		background = { 30,30,30,200 },
		title = { 120,255,120,200 },
		button = { 130,130,130,255 },
		border = { 0,0,0,255 },
		title_text = { 200,200,200,255 },
		message_text = { 200,200,200,255 }
	}
}



dialog.list = {}


dialog.menu = {
	x = nil,
	y = nil,
	active = false,
	w = 120,
	title = "Menu",
	proximity = 150,
}
	
dialog.menu.colours = {
	item = { 70,70,70,125 },
	separator = { 170,170,170,125 },
	hover = {10,10,10,255 },
}
dialog.menu.list = {  }



local setColour = function(t)
	love.graphics.setColor(t[1],t[2],t[3],t[4])
end

function dialog:getMessageHeight(w,message)
	local _,lines  = self.message_font:getWrap(message, w-self.message_padding*2)
	return self.message_font:getHeight() * lines+ self.title_height + self.title_padding*4
end

function dialog:new(title,message,x,y,w,align,canshade)

	local w = (type(message) == "userdata" 
			and message:getWidth()+(self.menu_padding*2) or w)
	
	local h = (type(message) == "userdata" 
			and message:getHeight()+self.menu_padding*2+self.title_height 
			or self:getMessageHeight(w, message))
			
	if w < self.min_width then w = self.min_width end
	
	print (type(message))
	table.insert(self.list, {
		title = title,
		message = message,
		x = x,
		y = y,
		w = w,
		h = h,
		state = 0,
		canvas = love.graphics.newCanvas(w,h),
		opacity = 0,
		align = align or "left",
		canshade = canshade,
	})
end

function dialog:newmenu(table)
	self.menu.list = table
	self.menu.h = #self.menu.list*self.menu_font:getHeight()+self.menu_padding+self.title_height
	self.menu.canvas = love.graphics.newCanvas(self.menu.w,self.menu.h)

	for i,m in ipairs(self.menu.list) do
		m.x = self.menu_padding
		m.y = self.menu_padding+self.menu_font:getHeight()*(i)
		m.w = self.menu.w
		m.h = self.menu_font:getHeight()
		m.active = false
	end		

end

function dialog:drawTitleBar(d)
	--title
	setColour(self.colours.title)
	love.graphics.rectangle("fill", 0,0,d.w,self.title_height)
		
	if type(self.title_image) == "userdata" then
		for x=0,d.w,self.title_image:getWidth() do
			love.graphics.draw(self.title_image,x,0,0,1,self.title_height/self.title_image:getHeight())
		end
	end
	
	--title text
	setColour(self.colours.title_text)	
			
	love.graphics.setFont(self.title_font)
	love.graphics.printf(d.title, self.title_padding,self.title_padding,0,"left",0,1,1)
	--frame
	setColour(self.colours.border)
	love.graphics.rectangle("line", 0,0,d.w,self.title_height )
end

function dialog:draw()

		
	for _,d in ipairs(self.list) do
		love.graphics.setColor(255,255,255,255)
		love.graphics.setCanvas(d.canvas)
		d.canvas:clear()
			
		--background
		setColour(self.colours.background)
		love.graphics.rectangle("fill", 0,0,d.w,d.h )

		--frame
		setColour(self.colours.border)
		love.graphics.rectangle("line", 0,0,d.w,d.h )
		
		--message text
		if not d.shaded then
			if type(d.message) == "userdata" then
				love.graphics.setColor(255,255,255,255)
				love.graphics.draw(d.message,self.message_padding,self.message_padding+self.title_height)
			else
			love.graphics.setFont(self.message_font)
			setColour(self.colours.message_text)
			love.graphics.printf(
				d.message, 
				self.message_padding,
				self.message_padding+self.title_height,
				d.w-self.message_padding*2,
				d.align,0,1,1
			)
			end
		end
		
		--titlebar
		self:drawTitleBar(d)
		
		--button
		setColour(self.colours.button)
		local s = self.title_height-(self.title_padding*2)
		local x = d.w-s-self.title_padding
		local y = self.title_padding
			
		love.graphics.rectangle("fill", x,y,s,s )
		setColour(self.colours.border)
		love.graphics.rectangle("line", x,y,s,s )
			
		local pad = 5
		love.graphics.line(x+pad,y+pad,x+s-pad,y+s-pad)
		love.graphics.line(x+s-pad,y+pad,x+pad,y+s-pad)
		
		
		
		love.graphics.setCanvas()
			
		--draw the message box
		love.graphics.setColor(255,255,255,d.opacity)
		love.graphics.draw(d.canvas, d.x,d.y)
		
	end
	
	
	-- draw action menu
	
	if self.menu.active then
		love.graphics.setColor(255,255,255,255)
		love.graphics.setCanvas(self.menu.canvas)
		self.menu.canvas:clear()
		
		setColour(self.colours.background)
		love.graphics.rectangle(
		"fill", 
			0,
			0,
			self.menu.w, 
			self.menu.h
		)
		
		--frame
		setColour(self.colours.border)
		love.graphics.rectangle("line", 0,0,self.menu.w,self.menu.h )
				
		
		love.graphics.setFont(self.menu_font)
		
		local switch = false
		for i,m in ipairs(self.menu.list) do
			
			if m.active then 
				setColour(self.menu.colours.hover)
			else
				if switch then 
					love.graphics.setColor(0,0,0,0)
				else
					setColour(self.menu.colours.item)
				end
			end
			switch = not switch 	
			
			love.graphics.rectangle("fill", m.x,m.y,m.w,m.h)
			
			if m.type == "separator" then
				setColour(self.menu.colours.separator)
				love.graphics.line(m.x,m.y+m.h/2,m.x+m.w,m.y+m.h/2)
			elseif m.type == "button" then
				setColour(self.colours.message_text)
				love.graphics.printf(m.name, m.x,m.y,m.w,"left",0,1,1)	
			end
			
		end
		--titlebar
		self:drawTitleBar(self.menu)
		
		love.graphics.setCanvas()
		
		love.graphics.setColor(255,255,255,self.opacity)
		love.graphics.draw(self.menu.canvas, self.menu.x,self.menu.y)
		
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
	
	if self.menu.active then
		if not self:check_collision(
			love.mouse.getX(),love.mouse.getY(),
			0,0,
			self.menu.x-self.menu.proximity,self.menu.y-self.menu.proximity,
			self.menu.w+(self.menu.proximity*2),self.menu.h+(self.menu.proximity*2)
		) then
			
			self.menu.active = false
		else
			for i,m in ipairs(self.menu.list) do
				if m.type == "button" then
					if self:check_collision(love.mouse.getX(),love.mouse.getY(),1,1,self.menu.x+m.x,self.menu.y+m.y,m.w,m.h) then
						m.active = true
					else
						m.active = false
					end
				end
			end
		end
	end
end

function dialog:mousepressed(x,y,button)
	
	if self.menu.active then
		if self:check_collision(x,y,0,0,self.menu.x,self.menu.y,self.menu.w,self.menu.h) then
			if button == "l" then
					for i,m in ipairs(self.menu.list) do
						if m.type == "button" then
							if self:check_collision(love.mouse.getX(),love.mouse.getY(),1,1,self.menu.x+m.x,self.menu.y+m.y,m.w,m.h) then
								self.menu.active = false
								m.action()
								return
							end
						end
					end
			end
			return
		else
			self.menu.active = false
		end
	end
	

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
			if button == "r" then
				if self:check_collision(x,y,0,0,d.x,d.y,d.w,self.title_height) then
					d.shaded = (d.canshade and not d.shaded)
					if d.shaded then 
						d.h = self.title_height
					else
						d.h = (type(d.message) == "userdata" and  d.message:getHeight()+self.menu_padding*2+self.title_height or self:getMessageHeight(d.w, d.message))
					end
				end
				return
			end
		end
	end
	
	if button == "r" then
		self.menu.x = x -self.menu_padding
		self.menu.y = y -self.menu_padding
		self.menu.active = true
	end
	
end

function dialog:check_collision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
		 x2 < x1+w1 and
		 y1 < y2+h2 and
		 y2 < y1+h1
end


dialog:newmenu(
	{
	[1] = { name = "Cancel", action = function() dialog.menu.active = false end },
	}
)

return dialog

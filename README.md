# love2d_dialog
a menu/dialog library for love2d

![screenshot_20160715_214425](https://cloud.githubusercontent.com/assets/1535179/16887993/55a18ab2-4ad5-11e6-82fc-c19c56fa1d41.png)


### Setup

* place dialog:draw() in your love.draw() routine
* place dialog:update(dt) in your love.update() routine
* place dialog:mousepressed(x,y,button) in your love.mousepressed() routine
 
### Usage
Create a dialog window:
``dialog:new("Hello","Hello World!",100,150,100,"left")``

Create a userdata window:
``dialog:new("Userdata",canvas,100,100,canvas:getWidth(),nil,true)``

Create a menu (right click)
``
dialog:newmenu(
	{
	[1] = { name = "Text dialog", action = function() dialog:new("Message", "This is a message",love.mouse.getX(),love.mouse.getY(),100,"left",true) end },
	[2] = { name = "Image", action = function() dialog:new("Image",imagedata,love.mouse.getX(),love.mouse.getY(),imagedata:getWidth(),nil,true) end },
	[3] = { name = "Cancel", action = function() dialog.menu.active = false end },
	}
)
``
See `main.lua` for an example.

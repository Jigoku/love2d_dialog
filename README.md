# love2d_dialog
a simple library for spawning dialog boxes

![screenshot_20160715_214425](https://cloud.githubusercontent.com/assets/1535179/16887993/55a18ab2-4ad5-11e6-82fc-c19c56fa1d41.png)


### Setup

* place dialog:draw() in your love.draw() routine
* place dialog:update(dt) in your love.update() routine
* place dialog:mousepressed(x,y,button) in your love.mousepressed() routine
 
### Usage
``dialog:new("Test","This is a test message",100,150,100,"left")``
 
See `main.lua` for an example.

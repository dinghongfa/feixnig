
require("config")
require("cocos.init")
require("framework.init")
require("app.layers.BackgroundLayer")
local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()

	--加载声音文件
	audio.preloadMusic("sound/background.mp3")
	audio.preloadSound("sound/button.wav")
	audio.preloadSound("sound/ground.mp3")
    audio.preloadSound("sound/heart.mp3")
    audio.preloadSound("sound/hit.mp3")

    --其中math.random(-40, 40)可以产生-40到40的随机数。为了不产生相同的随机数
    --我们需要在MyApp:run()中“种”一棵随机数种子
    math.randomseed(os.time())

    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.Director:getInstance():setContentScaleFactor(640 / CONFIG_SCREEN_HEIGHT)
    self:enterScene("MainScene")

  


end

return MyApp

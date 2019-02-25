
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    display.newSprite("image/bg.jpg"):center():addTo(self)
    display.addSpriteFrames("image/player.plist", "image/player.png")

    --标签
    local title = display.newSprite("#title.png")
    :pos(display.cx / 2 * 3, display.cy)
    :addTo(self)
    --标签动作
    local move1 = cc.MoveBy:create(1, cc.p(0,10))
    local move2 = cc.MoveBy:create(1, cc.p(0,-10))
    local sequence = cc.Sequence:create(move1,move2)
    transition.execute(title, cc.RepeatForever:create(sequence))

    --开始按钮
    cc.ui.UIPushButton.new({normal = "#start1.png", pressed = "image/but2.png"}, {scale9 = true})
    :onButtonClicked(function()
    	local scene1 = import("app.scenes.GameScene").new()
    	display.replaceScene(scene1, "splitCols", 0.5)

    end)
    :pos(display.cx / 2 , display.cy+7)
    :addTo(self)
end


    
    
    


function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene

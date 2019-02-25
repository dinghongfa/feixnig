

local Player = require("app.objects.Player")

local GameScene = class("GameScene", function()

    return display.newPhysicsScene("GameScene")

end)



function GameScene:ctor()  
        
    
	self.backgroundLayer = BackgroundLayer.new():addTo(self)
    
    self.world = self:getPhysicsWorld()
    self.world:setGravity(cc.p(0, -98.0))
    --调试模式
    --self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    
    --创建一个 Player 对象
    self.player = Player.new()

    self:addChild(self.player)
 
    self:playerFlyToScene()

    self.player:createProgress() --用Player创建 血条

    self:addCollision() --调用碰撞检测

    audio.playMusic("sound/background.mp3", false)

    self:checkEnd()

    

end

   

function GameScene:onTouch(event, x, y)

	if event == "began" then 

		self.player:getPhysicsBody():setVelocity(cc.p(0,98))
        self.player:flying()
       
        return true  --必须要的

    elseif event == "ended" then

        self.player:drop() 

    end

end



--将使创建的 Player 对象移动到场景指定位置
function GameScene:playerFlyToScene()

    --Player开始受重力并且播放下降的动画方法
	local function startDrop()
		
		self.player:getPhysicsBody():setGravityEnable(true)

		self.player:drop()

		self.backgroundLayer:startGame()--下降时背景开始移动

		self.backgroundLayer:setTouchEnabled(true)  --下降时设置触摸
		self.backgroundLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			return self:onTouch(event.name, event.x, event.y)
		end)
	end

    --Player执行飞的动画
    self.player:flying()

    --player移动中间，后开始startDrop（）
    local action = transition.sequence({
    	cc.MoveTo:create(4, cc.p(display.cx, display.height * 2/3)),

    	cc.CallFunc:create(startDrop)

    	})

    self.player:runAction(action)

end


--碰撞检测
function GameScene:addCollision()

	local function contactLogic(node)
	    
    	if node:getTag() == HEART_TAG then
    		--加血，消除心特效
    		if self.player.blood < 100  then

                self.player.blood = self.player.blood + 5
                self.player:setProPercentage(self.player.blood)

            elseif  self.player.blood >= 100 then
            	self.player.blood = 100
            	self.player:setProPercentage(self.player.blood)
            end
             
    			
    		local emtter = cc.ParticleSystemQuad:create("particles/stars.plist")
    		emtter:setPosition(node:getPosition()):addTo(self.backgroundLayer.map)
            emtter:setBlendAdditive(false)--关闭混合模式
    		audio.playSound("sound/heart.mp3")

    		node:removeFromParent()
                

    	elseif node:getTag() == AIRSHIP_TAG then
    		--减少玩家20点血量，并添加玩家受伤动画
    		self.player.blood = self.player.blood - 20
    		self.player:setProPercentage(self.player.blood)
    		audio.playSound("sound/hit.mp3")
    		self.player:hit()
         
        elseif node:getTag() == GROUND_TAG then
            --
            self.player.blood = self.player.blood - 10
    		self.player:setProPercentage(self.player.blood)
    		audio.playSound("sound/ground.mp3")
    		self.player:hit()  
    		      
 
    	elseif node:getTag() == BIRD_TAG then
    		--减少玩家5点血量，并添加玩家受伤动画
    		self.player.blood = self.player.blood - 15
    		self.player:setProPercentage(self.player.blood)
    		audio.playSound("sound/hit.mp3")
    		self.player:hit()
            
        elseif node:getTag() == BIGOBSTACLE then
            --减少玩家20点血量，并添加玩家受伤动画和障碍物动画
            self.player.blood = self.player.blood - 20
            self.player:setProPercentage(self.player.blood)
            audio.playSound("sound/hit.mp3")
            self.player:hit()
            
            
    	end

    end

    local function onContactBegin(contact)
    	--
    	local a = contact:getShapeA():getBody():getNode()

    	local b = contact:getShapeB():getBody():getNode()

    	contactLogic(a) --碰撞逻辑

    	contactLogic(b)

    end


    local function onContactSeperate(contact)
    	-- 检测player血量 0 就结束游戏
    	if self.player.blood <= 0 then
            self:performWithDelay(function()
                self:gameOver()
            end, 1)
            self.player:die()
    	    
    	    
    	end


    end

    --设置监听器
	local contactListener = cc.EventListenerPhysicsContact:create()

	contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)

    contactListener:registerScriptHandler(onContactSeperate, cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE)

    --监听器设置完毕，需要把它加入到引擎导演的事件分发器中。所以这里获取游戏的事件分发器
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()

    eventDispatcher:addEventListenerWithFixedPriority(contactListener, 1)   


end

function GameScene:gameOver()

	local resultLayer = display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self)

    resultLayer:setTouchEnabled(true)
    resultLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then 
    	   return true 
        end 
    end)

    audio.playSound("sound/button.wav")
    self.player:getPhysicsBody():setGravityEnable(false)
    self.backgroundLayer:unscheduleUpdate()  
    
    cc.ui.UIPushButton.new({normal = "image/over.png"}, {scale9 = true})
    :onButtonClicked(function()
    	local scene = require("app.scenes.MainScene").new()
    	display.replaceScene(scene, "splitCols", 1)
    end)
    :pos(display.cx, display.cy)
    :addTo(resultLayer)
    :setScale(0.5)

end

function GameScene:checkEnd()
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
      --地图完调用gameOver（）
      if self.backgroundLayer.map:getPositionX() <= (display.width - self.backgroundLayer.map:getContentSize().width) then
          self:gameOver()
          self:unscheduleUpdate()

      end 
      
    end)
     self:scheduleUpdate()
end

function GameScene:onEnter()

end



function GameScene:onExit()

end



return GameScene
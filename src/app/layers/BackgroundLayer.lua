

local Heart = require("app.objects.Heart")
local Airship = require("app.objects.Airship")
local Bird = require("app.objects.Bird")
local BigObstacle = require("app.objects.BigObstacle")

BackgroundLayer = class("BackgroundLayer",function()

    return display.newLayer()

end)



function BackgroundLayer:ctor()
	self.distanceBg = {}

    self.nearbyBg = {}


    self.bird = {}

    self:createBackgrounds()
    
    self:addBody("heart", Heart)
    self:addBody("airship", Airship)
    self:addBody("bird", Bird)
    self:addBody("bigObstacle", BigObstacle)

    

    --
    local emitter = cc.ParticleSystemQuad:create("particles/dirt.plist")

    emitter:setPosition(display.cx, display.top):addTo(self, -3)

    --添加 无重力约束的线
    local width = self.map:getContentSize().width
    local height1 = self.map:getContentSize().height 
    local height2 = self.map:getContentSize().height * 3 / 16

    local sky = display.newNode()
    local bodyTop = cc.PhysicsBody:createEdgeSegment(cc.p(0, height1), cc.p(width, height1))
    sky:setPhysicsBody(bodyTop):addTo(self)
    sky:getPhysicsBody():setCategoryBitmask(0x1000):setContactTestBitmask(0x0000)
    :setCollisionBitmask(0x0001)


    local gyound = display.newNode()
    local bodyBottom = cc.PhysicsBody:createEdgeSegment(cc.p(0, height2), cc.p(width, height2))
    gyound:setPhysicsBody(bodyBottom):addTo(self)
    gyound:getPhysicsBody():setCategoryBitmask(0x1000):setContactTestBitmask(0x0001)
    :setCollisionBitmask(0x0011)
    gyound:setTag(GROUND_TAG)

    local gyound1 = display.newNode()
    local bodyBottom1 = cc.PhysicsBody:createEdgeSegment(cc.p(0, height2-5), cc.p(width, height2-5))
    gyound1:setPhysicsBody(bodyBottom1):addTo(self)

    
end


function BackgroundLayer:startGame()
    
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,function(dt)
        
        self:scrollBackgrounds(dt)
    end)

    self:scheduleUpdate()
end

function BackgroundLayer:createBackgrounds()

    -- 创建布幕背景

    local bg = display.newSprite("image/bj1.jpg")

        :pos(display.cx, display.cy)

        :addTo(self, -4)

    -- 创建远景背景

    local bg1 = display.newSprite("image/b1.png")

        :align(display.BOTTOM_LEFT, display.left , display.bottom + 10)

        :addTo(self,-3)

    local bg2 = display.newSprite("image/b2.png")

        :align(display.BOTTOM_LEFT, display.left + bg1:getContentSize().width, display.bottom + 10)

        :addTo(self,-3)


        table.insert(self.distanceBg, bg1) -- 把创建的bg1插入到了 self.distanceBg 中

        table.insert(self.distanceBg, bg2) -- 把创建的bg2插入到了 self.distanceBg 中


    --创建近景背景

    local bg3 = display.newSprite("image/b3.png")

        :align(display.BOTTOM_LEFT, display.left , display.bottom + 10)

        :addTo(self,-2)

    local bg4 = display.newSprite("image/b4.png")

        :align(display.BOTTOM_LEFT, display.left + bg1:getContentSize().width, display.bottom + 10)

        :addTo(self,-2)


        table.insert(self.nearbyBg, bg3) -- 把创建的bg3插入到了 self.nearbyBg 中

        table.insert(self.nearbyBg, bg4) -- 把创建的bg4插入到了 self.nearbyBg 中

    --创建最上层TMX背景
    self.map = cc.TMXTiledMap:create("image/map.tmx")
    self.map:align(display.BOTTOM_LEFT, display.left, display.bottom)
    self.map:addTo(self, -1)

end
---------------------------------------------
 --添加心心到地图上的心心 object上

function BackgroundLayer:addAirship()

    local object = self.map:getObjectGroup("airship"):getObjects()

    for _, coin in pairs(object) do
        local x = coin.x
        local y = coin.y
        local airshipSprite = Airship.new(x,y)
        self.map:addChild(airshipSprite)
    end
end

--------------------------------------------------
--封装addBody

function BackgroundLayer:addBody(objectGroupName, class)

    local object = self.map:getObjectGroup(objectGroupName):getObjects()
    
    local x = nil
    local coinSprite = nil
    local y = nil

    for _, coin in pairs(object)  do
      
        x = coin.x
        y = coin.y

        coinSprite = class.new(x,y)

        self.map:addChild(coinSprite)

        if objectGroupName == "bird" then 
            table.insert(self.bird, coinSprite)
        end
            
    end
end


 function BackgroundLayer:addVelocityToBird()  

    for _, coin in pairs(self.bird) do
       
        if coin:getPositionX() <= display.width - self.map:getPositionX() then  --<= map当前屏幕最右边的x坐标
            if coin:getPhysicsBody():getVelocity().x == 0 then
                coin:getPhysicsBody():setVelocity(cc.p(-70, math.random(-40,40)))

            end
        end
    end

end




 --滚动背景图方法
function BackgroundLayer:scrollBackgrounds( dt )

	if self.distanceBg[2]:getPositionX() <= 0 then 
		self.distanceBg[1]:setPositionX(0)
	end

    local x1 = self.distanceBg[1]:getPositionX() - 50 * dt
    local x2 = x1 + self.distanceBg[1]:getContentSize().width

    self.distanceBg[1]:setPositionX(x1)
    self.distanceBg[2]:setPositionX(x2)

    --
    if self.nearbyBg[2]:getPositionX() <= 0 then
    	self.nearbyBg[1]:setPositionX(0)
    end

    local y1 = self.nearbyBg[1]:getPositionX() - 80 * dt
    local y2 = y1 + self.nearbyBg[1]:getContentSize().width

    self.nearbyBg[1]:setPositionX(y1)
    self.nearbyBg[2]:setPositionX(y2)

    --
    if self.map:getPositionX() <= (display.width - self.map:getContentSize().width) then

    	self:unscheduleUpdate()
    end

    local z1 = self.map:getPositionX() - 150 * dt
    
    self.map:setPositionX(z1)

    self:addVelocityToBird() --启动小鸟给速度

end





return BackgroundLayer
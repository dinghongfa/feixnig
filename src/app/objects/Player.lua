

local Player = class("Player", function()

    return display.newSprite("#flying1.png")

end)



function Player:ctor()

	local body = cc.PhysicsBody:createBox(self:getContentSize(),
	 cc.PHYSICSBODY_MATERIAL_DEFAULT, cc.p(0,0))

	self:setPhysicsBody(body)

    self:getPhysicsBody():setGravityEnable(false)

    self:setPosition(-20, display.height* 2/3)

    self:addAnimationCache()

    self:getPhysicsBody():setCategoryBitmask(0x0111):setContactTestBitmask(0x1111)
    :setCollisionBitmask(0x1001):setRotationEnable(false)--不偏转重心
    self:setTag(PLAYER_TAG)

    self.blood = 100

    
end

--Player 添加血量条，这可以用引擎中已经封装好的进度条（ProgressTimer）来实现
function Player:createProgress()

    local progressbg = display.newSprite("#progress1.png") 
    local bar = display.newSprite("#progress2.png")
    self.fill = display.newProgressTimer(bar, display.PROGRESS_TIMER_BAR)  


    self.fill:setMidpoint(cc.p(0, 0.5)) --设置进度条的起始点左中  

    self.fill:setBarChangeRate(cc.p(1.0, 0))  --向右变化

    

    --设置坐标，在progress上中间显示，设置进度条数值
    self.fill:setPosition(progressbg:getContentSize().width/2, progressbg:getContentSize().height/2) 

    progressbg:addChild(self.fill)

    self.fill:setPercentage(self.blood) 


    progressbg:setAnchorPoint(cc.p(0, 1))

    self:getParent():addChild(progressbg)  --不能在ctor()调用self:createProgress()

    progressbg:setPosition(display.left, display.top)

end



function Player:setProPercentage(Percentage)

    self.fill:setPercentage(Percentage)  

end

--缓存动画
function Player:addAnimationCache()

	local animations = {"flying", "drop", "die", "attack"}
	local animationFrameNum = {4,3,4,6}

	for i=1, #animations do

		local frames = display.newFrames(animations[i].."%d.png", 1, animationFrameNum[i])
	
        local animation = display.newAnimation(frames, 0.3/animationFrameNum[i])

        display.setAnimationCache(animations[i], animation) --缓存在display上
    
    end

end

function Player:flying()

    transition.stopTarget(self)

    transition.playAnimationForever(self, display.getAnimationCache("flying"))

end



function Player:drop()

    transition.stopTarget(self)

    transition.playAnimationForever(self, display.getAnimationCache("drop"))

end



function Player:die()

    transition.stopTarget(self)

    transition.playAnimationForever(self, display.getAnimationCache("die"))

end

function Player:hit()

    local hit = display.newSprite("#attack1.png")
    hit:setPosition(self:getContentSize().width/2, self:getContentSize().height/2)
    hit:setScale(0.6)
    hit:addTo(self)

    local animate = cc.Animate:create(display.getAnimationCache("attack"))

    local sequence = transition.sequence({animate,
        cc.CallFunc:create(function()
            self:removeChild(hit)
        end)
        })

    hit:runAction(sequence)

end

return Player
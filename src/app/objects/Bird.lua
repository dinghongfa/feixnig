--
-- Author: new
-- Date: 2019-02-15 08:31:45

local Bird = class("Bird", function()
	local sprite =  display.newSprite("#bird1.png")
	 
	return sprite
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0,0,0)--碰撞后不变形

function Bird:ctor(x,y)
	
	local birdSize = self:getContentSize()

	local body = cc.PhysicsBody:createCircle(birdSize.width/2, MATERIAL_DEFAULT)

	self:setPhysicsBody(body)

	self:setPosition(x, y)

	self:getPhysicsBody():setGravityEnable(false)

	local frames = display.newFrames("bird%d.png", 1, 9)

	local animation = display.newAnimation(frames, 0.5 / 9)

	local animate = cc.Animate:create(animation)

	self:runAction(cc.RepeatForever:create(animate))

	self:getPhysicsBody():setCategoryBitmask(0x0010):setContactTestBitmask(0x0100)
    :setCollisionBitmask(0x1000)
    self:setTag(BIRD_TAG)

    
end

return Bird
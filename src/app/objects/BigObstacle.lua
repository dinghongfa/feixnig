--
-- Author: new
-- Date: 2019-02-18 23:13:37
--
local BigObstacle = class("BigObstacle", function()
	local sprite =  display.newSprite("#bigObstacle1.png")
	 
	return sprite
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0,0,0)

function BigObstacle:ctor(x,y)

	local body = cc.PhysicsBody:createBox(self:getContentSize(), MATERIAL_DEFAULT, cc.p(0,0))

    self:setPhysicsBody(body)
    self:setPosition(x, y):setTag(BIGOBSTACLE)

	self:getPhysicsBody():setGravityEnable(false):setCategoryBitmask(0x0011)
	:setContactTestBitmask(0x0100)
    :setCollisionBitmask(0x1000)
    
    
    

end


return BigObstacle
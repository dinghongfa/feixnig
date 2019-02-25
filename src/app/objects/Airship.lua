--
-- Author: new
-- Date: 2019-02-15 07:41:58
--
local Airship = class("Airship", function()

    return display.newSprite("#airship.png")

end)


local MATERIAL_DEFAULT = cc.PhysicsMaterial(0,0,0)

function Airship:ctor(x,y)

	local airshipSize = self:getContentSize()
	
	local airshipbody = cc.PhysicsBody:createCircle(airshipSize.width/2, MATERIAL_DEFAULT)

	self:setPhysicsBody(airshipbody)

	self:setPosition(x, y)

	self:getPhysicsBody():setGravityEnable(false)

	self:getPhysicsBody():setCategoryBitmask(0x0100):setContactTestBitmask(0x0100)
    :setCollisionBitmask(0x1000)
    self:setTag(AIRSHIP_TAG)

	local move1 = cc.MoveBy:create(2, cc.p(0,60))
	local move2 = cc.MoveBy:create(2, cc.p(0,-60))
	local sequence = cc.Sequence:create(move1, move2)
	transition.execute(self, cc.RepeatForever:create(sequence))

end

return Airship
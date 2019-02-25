--奖励品心心类


local Heart = class("Heart", function()

    return display.newSprite("image/heart.png")

end)


--密度，反弹力，摩擦力 为0，0，0  碰撞的时候不发生任何物理形变
local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)



function Heart:ctor(x, y)
    --圆body
    local heartBody = cc.PhysicsBody:createCircle(self:getContentSize().width / 2,

        MATERIAL_DEFAULT)


    self:setPhysicsBody(heartBody)

    self:getPhysicsBody():setGravityEnable(false)    

    self:setPosition(x, y)

    self:getPhysicsBody():setCategoryBitmask(0x0001):setContactTestBitmask(0x0100)
    :setCollisionBitmask(0x0001)
    
    self:setTag(HEART_TAG)

end



return Heart
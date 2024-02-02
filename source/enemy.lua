import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd  <const> = playdate
local gfx <const> = pd.graphics

local tileSize <const> = 32

-- enemy
class("Enemy").extends()

-- create enemy
function Enemy:init(posY, health, speed)
    self.health = health
    self.speed  = speed

    self.invincible = false

    -- create sprite
    local image = images:get("images/enemy")
    self.sprite = gfx.sprite.new(image)

    self.sprite:setTag(3)
    self.sprite:setCollideRect(0, 0, self.sprite:getSize())
    self.sprite:moveTo(
        12.5 * tileSize,
        (posY * tileSize) - (tileSize / 2)
    )
    self.sprite:add()
end

-- update enemy
function Enemy:update()
    self.sprite:moveBy(-self.speed, 0)
    self:collision()
end

-- handle collision
function Enemy:collision()
    local overlapping = self.sprite:overlappingSprites()

    local stopped = false
    local damaged = false

    for _, overlapped in ipairs(overlapping) do
        -- stop when colliding with tile
        if overlapped:getTag() == 1 then
            stopped = true
        -- take damage from bullets
        elseif not self.invincible and self.health > 0 and overlapped:getTag() == 2 then
            damaged = true

            self.health -= 1
            overlapped:setVisible(false)
        end
    end

    if stopped then
        -- stop enemy
        self.sprite:moveBy(self.speed - 0.1, 0)
    end

    if damaged then
        -- start invincibility
        self.invincible = true

        pd.timer.performAfterDelay(250, function()
            -- end invincibility
            self.invincible = false
        end)
    end
end

-- check if enemy should be removed
function Enemy:shouldRemove()
    -- remove if enemy has no health or is offscreen
    if self.health <= 0 or self.sprite.x < -tileSize / 2 then
        self.sprite:remove()
        return true
    end

    return false
end

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd  <const> = playdate
local gfx <const> = pd.graphics

local tileSize <const> = 32

-- bullet
class("Bullet").extends()

-- create bullet
function Bullet:init(posX, posY, dirX, dirY)
    self.dirX = dirX
    self.dirY = dirY

    local image = images:get("images/bullet")
    self.sprite = gfx.sprite.new(image)

    self.sprite:setTag(2)
    self.sprite:setCollideRect(0, 0, self.sprite:getSize())
    self.sprite:moveTo(
        (posX * tileSize) - (tileSize / 2),
        (posY * tileSize) - (tileSize / 2)
    )
    self.sprite:add()
end

-- update bullet
function Bullet:update()
    self.sprite:moveBy(self.dirX, self.dirY)
end

-- check if bullet should be removed
function Bullet:shouldRemove()
    local overlapping = self.sprite:overlappingSprites()

    -- remove if overlapping with tile
    for _, overlapped in ipairs(overlapping) do
        if overlapped:getTag() == 1 then
            self.sprite:remove()
            return true
        end
    end

    -- remove if collided with enemy or offscreen
    if not self.sprite:isVisible() or
       self.sprite.x < 0   - tileSize or
       self.sprite.x > 400 + tileSize or
       self.sprite.y < 0   - tileSize or
       self.sprite.y > tileSize * 6 then
       self.sprite:remove()
        return true
    end

    return false
end

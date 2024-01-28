import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

import 'bullet'

local pd  <const> = playdate
local gfx <const> = pd.graphics

local tileSize <const> = 32

-- tile
class('Tile').extends()

-- create new tile
function Tile:init(posX, posY, health, imagePath)
    self.health     = health
    self.invincible = false

    -- set position
    self.posX = posX
    self.posY = posY

    -- create sprite
    local image = images:get(imagePath)
    self.sprite = gfx.sprite.new(image)

    self.sprite:setTag(1)
    self.sprite:setCollideRect(0, 0, self.sprite:getSize())
    self.sprite:moveTo(
        (self.posX * tileSize) - (tileSize / 2),
        (self.posY * tileSize) - (tileSize / 2)
    )
    self.sprite:add()
end

-- update tile
function Tile:update()
    self:collision()
    self:updateHook()
end

-- handle collision
function Tile:collision()
    local overlapping = self.sprite:overlappingSprites()
    local damaged = false

    for _, overlapped in ipairs(overlapping) do
        -- take damage from enemy
        if not self.invincible and self.health > 0 and overlapped:getTag() == 3 then
            damaged = true
            self.health -= 1
        end
    end

    if damaged then
        -- start invincibility
        self.invincible = true

        pd.timer.performAfterDelay(1000, function()
            -- stop invincibility
            self.invincible = false
        end)
    end
end

-- check if tile should be removed
function Tile:shouldRemove()
    -- remove if tile has no health
    if self.health <= 0 then
        self.sprite:remove()
        self:removeHook()

        return true
    end

    return false
end

-- get tile position
function Tile:position()
    return self.posX, self.posY
end

-- hooks
function Tile:updateHook() end
function Tile:removeHook() end

-- pencil tile
class('PencilTile').extends(Tile)

-- create new pencil tile
function PencilTile:init(posX, posY)
    PencilTile.super.init(self, posX, posY, 5, 'images/tiles/pencil')

    self.bullets = {}

    -- spawn bullets at intervals
    local interval = 1750
    self.bulletTimer = pd.timer.keyRepeatTimerWithDelay(
        interval,
        interval,
        function()
            table.insert(self.bullets, Bullet(self.posX + 0.75, self.posY, 10, 0))
        end
    )
end

-- update pencil tile
function PencilTile:updateHook()
    for index, bullet in ipairs(self.bullets) do
        -- update bullet
        bullet:update()

        if bullet:shouldRemove() then
            -- remove bullet
            table.remove(self.bullets, index)
        end
    end
end

-- remove pencil tile
function PencilTile:removeHook()
    -- remove bullet sprites
    for _, bullet in ipairs(self.bullets) do
        bullet.sprite:remove()
    end

    -- pause bullet timer
    self.bulletTimer:pause()
end

-- eraser tile
class('ErasersTile').extends(Tile)

-- create new eraser tile
function ErasersTile:init(posX, posY)
    ErasersTile.super.init(self, posX, posY, 10, 'images/tiles/erasers')
end

-- pens tile
class('PensTile').extends(Tile)

-- create new pens tile
function PensTile:init(posX, posY)
    PensTile.super.init(self, posX, posY, 10, 'images/tiles/pens')

    self.bullets = {}

    -- spawn bullets at intervals
    local interval = 1500
    self.bulletTimer = pd.timer.keyRepeatTimerWithDelay(
        interval,
        interval,
        function()
            table.insert(self.bullets, Bullet(self.posX, self.posY + 0.75, 0, 10))
            table.insert(self.bullets, Bullet(self.posX, self.posY - 0.75, 0, -10))
        end
    )
end

-- update pens tile
function PensTile:updateHook()
    for index, bullet in ipairs(self.bullets) do
        -- update bullet
        bullet:update()

        if bullet:shouldRemove() then
            -- remove bullet
            table.remove(self.bullets, index)
        end
    end
end

-- remove pens tile
function PensTile:removeHook()
    -- remove bullet sprites
    for _, bullet in ipairs(self.bullets) do
        bullet.sprite:remove()
    end

    -- pause bullet timer
    self.bulletTimer:pause()
end

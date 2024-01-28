import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

local pd  <const> = playdate
local gfx <const> = pd.graphics

-- card
class('Card').extends()

-- create card
function Card:init(index, imagePath, tile, waitTime)
    self.tile     = tile
    self.waitTime = waitTime

    -- create sprite
    local image = images:get(imagePath)
    self.sprite = gfx.sprite.new(image)

    self:updateIndex(index)
    self.sprite:add()
end

-- toggle selecting card
function Card:toggleSelect()
    local image = self.sprite:getImage():invertedImage()
    self.sprite:setImage(image)
end

-- update card index
function Card:updateIndex(index)
    local width, height = self.sprite:getSize()

    -- move to new index
    self.sprite:moveTo(
        (index * width) - (width / 2) + 8,
        240 - (height / 2)
    )
end

-- remove sprite
function Card:removeSprite()
    self.sprite:remove()
end

-- get tile
function Card:getTile()
    return self.tile
end

-- get wait time
function Card:getWaitTime()
    return self.waitTime
end

import 'CoreLibs/object'
import 'CoreLibs/graphics'

local pd  <const> = playdate
local gfx <const> = pd.graphics

-- image loader
class('Images').extends()

-- create image loader
function Images:init()
    self.images = {}
end

-- get image
function Images:get(image)
    if self.images[image] == nil then
        -- load new image
        self.images[image] = gfx.image.new(image)
    end

    return self.images[image]
end

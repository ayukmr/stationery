import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

local pd  <const> = playdate
local gfx <const> = pd.graphics

local tileSize <const> = 32

-- tiles
class('Tiles').extends()

-- create tiles
function Tiles:init()
    self.tiles = {}
    self.selectedTile = { x = 1, y = 1 }

    -- tile selector
    local selectorImage = images:get('images/selector')
    self.selector = gfx.sprite.new(selectorImage)

    self:moveSelector()
    self.selector:add()

    -- draw background tiles
    gfx.sprite.setBackgroundDrawingCallback(function()
        local backgroundImage = images:get('images/tiles/background')

        for y = 0, 5 do
            for x = 0, 12 do
                -- draw background
                backgroundImage:draw(x * tileSize, y * tileSize)
            end
        end
    end)
end

-- update tiles
function Tiles:update(selectingTile)
    for index, tile in ipairs(self.tiles) do
        -- update tile
        tile:update()

        if tile:shouldRemove() then
            -- remove tile
            table.remove(self.tiles, index)
        end
    end

    if selectingTile then
        self:selectorMovement()
    end
end

-- selector movement
function Tiles:selectorMovement()
    -- move up
    if pd.buttonJustPressed(pd.kButtonUp) then
        self.selectedTile.y = math.max(self.selectedTile.y - 1, 1)
        self:moveSelector()
    end

    -- move down
    if pd.buttonJustPressed(pd.kButtonDown) then
        self.selectedTile.y = math.min(self.selectedTile.y + 1, 6)
        self:moveSelector()
    end

    -- move left
    if pd.buttonJustPressed(pd.kButtonLeft) then
        self.selectedTile.x = math.max(self.selectedTile.x - 1, 1)
        self:moveSelector()
    end

    -- move right
    if pd.buttonJustPressed(pd.kButtonRight) then
        self.selectedTile.x = math.min(self.selectedTile.x + 1, 12)
        self:moveSelector()
    end
end

-- move selector sprite
function Tiles:moveSelector()
    self.selector:moveTo(
        self.selectedTile.x * tileSize - (tileSize / 2),
        self.selectedTile.y * tileSize - (tileSize / 2)
    )
end

-- add tile
function Tiles:addTile(tileClass)
    for _, tile in ipairs(self.tiles) do
        local tileX, tileY = tile:position()

        -- only add if space isn't occupied
        if self.selectedTile.x == tileX and self.selectedTile.y == tileY then
            return false
        end
    end

    -- create tile and add to tiles
    local tile = tileClass(self.selectedTile.x, self.selectedTile.y)
    table.insert(self.tiles, tile)

    return true
end

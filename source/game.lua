import 'CoreLibs/object'

import 'images'

images = Images()

import 'tiles'
import 'cards'
import 'enemies'

local pd  <const> = playdate
local gfx <const> = pd.graphics

-- game
class('Game').extends()

-- create game
function Game:init()
    -- create game classes
    self.tiles   = Tiles()
    self.cards   = Cards()
    self.enemies = Enemies()

    self.selectingCard = true

    self.selectedCard      = nil
    self.selectedCardIndex = nil

    -- seed random
    math.randomseed(playdate.getSecondsSinceEpoch())
end

function Game:update()
    -- update game classes
    self.cards:update(self.selectingCard)
    self.tiles:update(not self.selectingCard)
    self.enemies:update()

    if self.selectingCard then
        -- select card
        if not self.cards:getWaiting() and pd.buttonJustPressed(pd.kButtonA) then
            self.selectingCard = false
            self.selectedCard, self.selectedCardIndex =
                self.cards:getSelectedCard()
        end
    else
        -- place tile
        if pd.buttonJustPressed(pd.kButtonA) and self.tiles:addTile(self.selectedCard:getTile()) then
            self.cards:removeCard(self.selectedCardIndex)
            self.selectingCard = true

            self.selectedCard      = nil
            self.selectedCardIndex = nil
        end

        -- unselect card
        if pd.buttonJustPressed(pd.kButtonB) then
            self.selectingCard = true

            self.selectedCard      = nil
            self.selectedCardIndex = nil
        end
    end
end

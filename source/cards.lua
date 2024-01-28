import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

import 'card'
import 'tile'

local pd  <const> = playdate
local gfx <const> = pd.graphics

-- cards
class('Cards').extends()

-- create cards
function Cards:init()
    self.cards = {}
    self.selectedCard = 1

    self.waiting = false

    -- create overlay
    local image  = images:get('images/overlay')
    self.overlay = gfx.sprite.new(image)

    local width, height = self.overlay:getSize()

    self.overlay:setZIndex(5)
    self.overlay:setVisible(false)
    self.overlay:moveTo(width / 2, 240 - (height / 2))
    self.overlay:add()

    -- add starting cards
    for _ = 1, 12 do
        self:addCard()
    end

    self.cards[self.selectedCard]:toggleSelect()

    -- add cards at intervals
    local interval = 5000
    self.cardTimer = pd.timer.keyRepeatTimerWithDelay(
        interval,
        interval,
        function()
            if #self.cards < 12 then
                self:addCard()
            end
        end
    )

    -- draw card slots
    gfx.sprite.setBackgroundDrawingCallback(function()
        local slotImage     = images:get('images/cards/slot')
        local width, height = slotImage:getSize()

        for x = 0, 11 do
            -- draw slot
            slotImage:draw(x * width + 8, 240 - height)
        end
    end)
end

-- update cards
function Cards:update(selectingCard)
    if selectingCard then
        self:cardMovement()
    end
end

-- select card
function Cards:cardMovement()
    if not self.waiting then
        -- select card to the left
        if pd.buttonJustPressed(pd.kButtonLeft) then
            self.cards[self.selectedCard]:toggleSelect()

            self.selectedCard = math.max(self.selectedCard - 1, 1)
            self.cards[self.selectedCard]:toggleSelect()
        end

        -- select card to the right
        if pd.buttonJustPressed(pd.kButtonRight) then
            self.cards[self.selectedCard]:toggleSelect()

            self.selectedCard = math.min(self.selectedCard + 1, #self.cards)
            self.cards[self.selectedCard]:toggleSelect()
        end
    end
end

-- add card
function Cards:addCard()
    local cards = {
        { image = 'images/cards/pencil',  tile = PencilTile,  waitTime = 1000 },
        { image = 'images/cards/erasers', tile = ErasersTile, waitTime = 2000 },
        { image = 'images/cards/pens',    tile = PensTile,    waitTime = 2000 },
    }

    local card = cards[math.random(#cards)]

    table.insert(
        self.cards,
        Card(#self.cards + 1, card.image, card.tile, card.waitTime)
    )
end

-- remove card
function Cards:removeCard(index)
    self.waiting = true
    self.overlay:setVisible(true)

    -- disable overlay after delay
    pd.timer.performAfterDelay(self.cards[index]:getWaitTime(), function()
        self.waiting = false
        self.overlay:setVisible(false)
    end)

    self.cards[index]:removeSprite()
    table.remove(self.cards, index)

    self.selectedCard = math.max(self.selectedCard - 1, 1)
    self.cards[self.selectedCard]:toggleSelect()

    -- update card indexes
    for index, card in ipairs(self.cards) do
        card:updateIndex(index)
    end
end

-- get selected card
function Cards:getSelectedCard()
    return self.cards[self.selectedCard], self.selectedCard
end

-- get if cards are waiting
function Cards:getWaiting()
    return self.waiting
end

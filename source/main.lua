import "CoreLibs/graphics"
import "CoreLibs/timer"

import "game"

local pd  <const> = playdate
local gfx <const> = pd.graphics

-- create game
local game = Game()

-- playdate update hook
function pd.update()
    -- update game
    game:update()

    -- update internals
    gfx.sprite.update()
    pd.timer.updateTimers()
end

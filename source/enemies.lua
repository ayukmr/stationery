import "CoreLibs/object"
import "enemy"

local pd <const> = playdate

-- enemies
class("Enemies").extends()

-- create enemies
function Enemies:init()
    self.enemies    = {}
    self.enemyTimer = nil
    self.speedIncrease = -0.25

    pd.timer.performAfterDelay(10000, function()
        -- spawn enemies at intervals
        local interval = 1500
        self.enemyTimer = pd.timer.keyRepeatTimerWithDelay(
            interval,
            interval,
            function()
                self.speedIncrease += 0.05
                local enemy = Enemy(math.random(1, 6), 3, 1 + (math.random() / 2) + self.speedIncrease)
                table.insert(self.enemies, enemy)
            end
        )
    end)
end

-- update enemies
function Enemies:update()
    for index, enemy in ipairs(self.enemies) do
        -- update enemy
        enemy:update()

        if enemy:shouldRemove() then
            -- remove enemy
            table.remove(self.enemies, index)
        end
    end
end

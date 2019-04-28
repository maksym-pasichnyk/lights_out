-- Screen = {}

-- local Field = require 'field'
-- local field = Field(6, 6)

-- function love.load()
--     Screen.width = love.graphics.getWidth()
--     Screen.height = love.graphics.getHeight()

--     field:resize(Screen.width, Screen.height)
--     field:mix()
--     -- field:solve()
-- end

-- function love.resize(width, height)
--     Screen.width = width
--     Screen.height = heighth

--     field:resize(width, height)
-- end

-- function love.mousepressed(x, y, button, istouch)
--     field:touch(x, y)
-- end

-- function love.mousereleased(x, y, button, istouch, presses)
-- end

-- function love.mousemoved(x, y, dx, dy)
-- end

-- function love.update(dt)
--     field:update(dt)
-- end

-- function love.draw()
--     field:draw()
-- end



-------------------------------------------------------------------------
package.path = package.path..';src/?.lua'
love.filesystem.setRequirePath(package.path)

class = require 'general/class'

require 'general/module'

--------------------------------------------------------

import 'general/scene/scene-manager'
import 'general/graphics/screen'
import 'general/input'
import 'general/timer'

function love.load()
    love.keyboard.setKeyRepeat(true)

    module.load('game/init')
end

function love.resize(w, h)
    Screen.width = w
    Screen.height = h
    SceneManager:resize(w, h)
end

function love.keypressed(key, scancode, isrepeat)
    SceneManager:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
    SceneManager:keyreleased(key)
end

function love.mousepressed(x, y, button, istouch)
    SceneManager:mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch, presses)
    SceneManager:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy)
    SceneManager:mousemoved(x, y, dx, dy)
end

function love.textinput(text)
    SceneManager:textinput(text)
end

-------------------------------------------------------

function love.update(dt)
    Timer:update(dt)
    SceneManager:update(dt)
end

function love.draw()
    love.graphics.reset()
    SceneManager:render()
end
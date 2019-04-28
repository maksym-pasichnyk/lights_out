import 'general/timer'
import 'general/ui/graphics-scene'

local input = module.load 'general/input'
local InputEvent = input.InputEvent
local KeyEvent = input.KeyEvent
local MouseEvent = input.MouseEvent

Scene = class(GraphicsScene)
function Scene:new()
    GraphicsScene.new(self)
    self.block_counter = 0
    self.timer = Timer()
end

function Scene:destroy()

end

function Scene:enter()
    self.block_counter = 0
    self:reset()
end

function Scene:block()
    self.block_counter = self.block_counter + 1
end

function Scene:unblock()
    assert(self.block_counter > 0)
    self.block_counter = self.block_counter - 1
end

function Scene:exit()

end

function Scene:update(dt)
    GraphicsScene.update(self, dt)
    self.timer:update(dt)
end

function Scene:mousepressed(x, y, button, istouch)
    if self.block_counter > 0 then
        return
    end

    local event = MouseEvent(x, y, button)
    self:mousePressEvent(event)
    if event.target then
        event.target.isPressed = true
    end
    self.pressed = event.target
    self:setFocus(event.target)
end

function Scene:mousereleased(x, y, button, istouch, presses)
    if self.block_counter > 0 then
        return
    end

    local event = MouseEvent(x, y, button)
    self:mouseReleaseEvent(event)
    if event.target and event.target.isPressed then
        event.target.isPressed = false
        event.target:mouseClickEvent(event)
    end
    self.pressed = nil
end

function Scene:mousemoved(x, y, dx, dy)
    if self.block_counter > 0 then
        return
    end

    local element = self:itemAt(x, y)

    if not rawequal(self.hovered, element) then
        local hovered = self.hovered
        if hovered then
            hovered.isPressed   = false
            hovered.isMouseOver = false  
            hovered:mouseLeaveEvent()
        end

        self.hovered = element

        if element then
            element.isMouseOver = true
            element:mouseEnterEvent()
        end
    end

    if self.pressed then
        self.pressed:mouseMoveEvent(InputEvent { x = x, y = y, dx = dx, dy = dy, drag = true })
    else
        self:mouseMoveEvent(InputEvent { x = x, y = y, dx = dx, dy = dy })
    end
end

function Scene:keypressed(key, scancode, isrepeat)
    if self.block_counter > 0 then
        return
    end

    self:keyPressEvent(KeyEvent(key, scancode, '', isrepeat))
end

function Scene:keyreleased(key, scancode)
    if self.block_counter > 0 then
        return
    end

    self:keyReleaseEvent(KeyEvent(key, scancode, '', false))
end

function Scene:textinput(text)
    if self.block_counter > 0 then
        return
    end

    self:inputTextEvent(InputEvent { text = text })
end

function Scene:joystickpressed(joystick, button)
    if self.block_counter > 0 then
        return
    end

    self:joystickPressEvent(InputEvent { joystick = joystick, button = button })
end

function Scene:joystickreleased(joystick, button)
    if self.block_counter > 0 then
        return
    end

    self:joystickReleaseEvent(InputEvent { joystick = joystick, button = button })
end

function Scene:joystickaxis(joystick, axis, value)
    if self.block_counter > 0 then
        return
    end

    self:joystickAxisEvent(InputEvent { joystick = joystick, axis = axis, value = value })
end

function Scene:joystickhat(joystick, hat, direction)
    if self.block_counter > 0 then
        return
    end

    self:joystickHatEvent(InputEvent { joystick = joystick, hat = hat, direction = direction })
end

function Scene:setFocus(element)
    if rawequal(self.focused, element) then
        return
    end

    if self.focused then
        self.focused.isFocused = false
        self.focused:lostFocusEvent()
    end

    self.focused = element

    if self.focused then
        self.focused.isFocused = true
        self.focused:gainFocusEvent()
    end
end
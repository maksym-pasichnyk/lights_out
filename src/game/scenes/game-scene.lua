import 'general/list'
import 'general/input'
import 'general/scene/scene'
import 'general/scene/scene-manager'
import 'general/ui/controls/checkbox'
import 'general/ui/controls/label'

import 'game/field'

local CheckboxText = class(Checkbox)
function CheckboxText:new(parent, x, y, w, h, text)
    Checkbox.new(self, parent, x, y, w, h)

    self.text = text
    self.align = 'center'
end

function CheckboxText:paintEvent()
    love.graphics.setColor(self:get_background_color())
    love.graphics.rectangle('line', 0, 0, self.w, self.h, 4, 4)  

    if self.value then
        love.graphics.setColor(self:get_thumb_color())
        love.graphics.rectangle('fill', 0, 0, self.w, self.h, 4, 4)        
    end

    Label.paintEvent(self)
end

function CheckboxText:get_text_color()
    if self.value then
        return {0/255, 0/255, 0/255}
    else
        return {255/255, 255/255, 255/255}
    end
end

GameScene = class(Scene)
function GameScene:new()
    Scene.new(self)

    self.field = Field(6, 6)

    local function solve_button(info)
        self.field.solve_mode = info.value

        if info.value then
            self.field:solve()
        end

        self.field.edit_mode = false
        self.Edit.value = false
    end

    local function edit_button(info)
        self.field.edit_mode = info.value
        self.field.solve_mode = false
        self.Solve.value = false
    end

    self.buttons = {
        {'Solve', solve_button},
        {'Edit', edit_button}
    }

    self:add(self.field)

    local w = 70
    local s = 10
    local start_x = (Screen.width - (w + s) * #self.buttons + s) * 0.5

    local x = start_x
    for i, button in ipairs(self.buttons) do
        local item = CheckboxText(self, x, 10, w, 30, button[1])
        item.onToggle:add(button[2])
        self:add(item)
        self[button[1]] = item
        x = x + w + s
    end
end

function GameScene:enter()
    Scene.enter(self)
    self.field:mix()
end

function GameScene:keyPressEvent(event)
    Scene.keyPressEvent(self, event)

    if event.accepted then
        return
    end

    if event:single() then
        local key = event.key
        if key == 'escape' then
            event:accept()
            SceneManager:switch('main')
        end
    end
end

function GameScene:updateEvent()
end
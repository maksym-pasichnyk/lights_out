import 'general/ui/controls/button'
import 'general/event/event'

Checkbox = class(Button)
function Checkbox:new(parent, x, y, w, h)
    Button.new(self, parent, x, y, w or 30, h or 30)

    self.value = false
    self.onToggle = Event()
end

function Checkbox:paintEvent()
    love.graphics.setColor(self:get_background_color())
    love.graphics.rectangle('line', 0, 0, self.w, self.h, 4, 4)  

    if self.value then
        love.graphics.setColor(self:get_thumb_color())
        love.graphics.rectangle('fill', 5, 5, self.w - 10, self.h - 10, 4, 4)        
    end
end

function Checkbox:get_thumb_color()
    return {200/255, 200/255, 200/255}
end

function Checkbox:mouseClickEvent(event)
    self.value = not self.value
    self.onToggle:invoke(self)
end
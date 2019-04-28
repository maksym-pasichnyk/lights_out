import 'general/ui/controls/button'
import 'general/ui/controls/label'

local DefaultStyle = require 'general/ui/style/default'
local Style = DefaultStyle.button

TextButton = class(Button)
function TextButton:new(parent, text, x, y, w, h)
    Button.new(self, parent, x, y, w, h)
    
    self.text = text
    self.align = 'center'
end

function TextButton:paintEvent()
    Button.paintEvent(self)
    Label.paintEvent(self)
end

function TextButton:get_text_color()
    if self.isPressed then
        return Style.pressed.text_color
    elseif self.isMouseOver then
        return Style.hover.text_color
    else
        return Style.normal.text_color
    end
end
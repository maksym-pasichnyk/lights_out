import 'general/scene/scene-manager'
import 'general/graphics/screen'
import 'general/ui/graphics-item'

Field = class(GraphicsItem)

function Field:new(cols, rows)
    GraphicsItem.new(self)

    self.scene = getScene()
    self.space = 10
    self.size = 30
    self.offset = self.size + self.space
    self.cols = cols
    self.rows = rows
    self.data = {}
    self.hints = {}
    
    self:resizeEvent(Screen.width, Screen.height)
end

function Field:mix()
    for i = 1, self.cols do
        for j = 1, self.cols do
            if love.math.random() > 0.5 then
                self:toggle(i - 1, j - 1)
            end
        end
    end
end

function Field:get(i, j)
    return self.data[i * self.cols + j + 1]
end

function Field:flip(i, j)
    if i >= 0 and i < self.cols and j >= 0 and j < self.cols then
        local ij = i * self.cols + j + 1
        self.data[ij] = not self.data[ij]
    end
end

function Field:resizeEvent(width, height)
    self:setSize(width, height)

    self.sx = (width - self.offset * self.cols + self.space) / 2
    self.sy = (height - self.offset * self.rows + self.space) / 2
end

function Field:check()
    local ij = 1
    for i = 1, self.rows do
        for j = 1, self.cols do
            if self.data[ij] then
                return
            end
            ij = ij + 1
        end
    end

    self.scene:block()
    self.scene.timer:after(0.5, function()
        SceneManager:switch('main')
    end)
end

function Field:toggle_hint(i, j)
    local ij = i * self.cols + j + 1
    self.hints[ij] = not self.hints[ij]
end

function Field:toggle(i, j)
    self:toggle_hint(i, j)

    self:flip(i - 1, j)
    self:flip(i, j - 1)
    self:flip(i, j)
    self:flip(i, j + 1)
    self:flip(i + 1, j)
end

local Set = class()
function Set:new()
    self.data = {}
    self.size = 0
end

function Set:add(value)
    for i = 0, self.size - 1 do
        if self.data[i] == value then
            return
        end
    end

    self.data[self.size] = value
    self.size = self.size + 1
end

function Set:has(value)
    for i = 0, self.size - 1 do
        if self.data[i] == value then
            return true
        end
    end
    return false
end

function Field:solve()
    local function unique(t1, t2)
        local t = Set()
        for k, v in pairs(t1.data) do
            if not t2:has(v) then
                t:add(v)
            end
        end
        for k, v in pairs(t2.data) do
            if not t1:has(v) then
                t:add(v)
            end
        end
        return t
    end

    local N = self.cols
    local M = self.cols
    local NM = N * M

    local eqs = {}

    local ij = 0
    for i = 0, N - 1 do
        for j = 0, M - 1 do
            local eq = Set()

            for d = -1, 1 do
                if (i + d) >= 0 and (i + d) < N then
                    eq:add(ij + d * M)
                end

                if d ~= 0 then
                    if (j + d) >= 0 and (j + d) < M then
                        eq:add(ij + d)
                    end
                end
            end

            eqs[ij] = {
                first = self.data[ij + 1] or false,
                second = eq
            }
            ij = ij + 1
        end

    end

    for i = 0, NM - 1 do
        for j = i, NM - 1 do
            if eqs[j].second:has(i) then
                eqs[i], eqs[j] = eqs[j], eqs[i]
                break
            end
        end

        for j = i + 1, NM - 1 do
            if eqs[j].second:has(i) then
                eqs[j].first = (eqs[j].first ~= eqs[i].first)
                eqs[j].second = unique(eqs[j].second, eqs[i].second)
            end
        end
    end

    for i = NM - 1, 0, -1 do
        for j = 0, i - 1 do
            if eqs[j].second:has(i) then
                eqs[j].first = (eqs[j].first ~= eqs[i].first)
                eqs[j].second = unique(eqs[j].second, eqs[i].second)
            end
        end
    end

    ij = 0
    for i = 1, N do
        for j = 1, M do
            self.hints[ij + 1] = eqs[ij].first
            ij = ij + 1
        end
    end
end

function Field:mousePressEvent(event)
    event:accept()

    local px, py = event.x, event.y

    local y = self.sy
    for i = 1, self.rows do
        local x = self.sx
        for j = 1, self.cols do
            if x <= px and px <= (x + self.size) and y <= py and py <= (y + self.size) then
                if self.edit_mode then
                    self:flip(i - 1, j - 1)
                else
                    self:toggle(i - 1, j - 1)
                    self:check()
                end
                return
            end
            x = x + self.offset
        end
        y = y + self.offset
    end
end

function Field:paintEvent()
    local ij = 1
    local y = self.sy
    for i = 1, self.rows do
        local x = self.sx
        for j = 1, self.cols do
            if self.solve_mode and self.hints[ij] then
                local r, g, b, a = love.graphics.getColor()
                love.graphics.setColor(255, 204, 0)
                love.graphics.rectangle('fill', x, y, self.size, self.size)
                love.graphics.setColor(r, g, b, a)
            else
                if self.data[ij] then
                    love.graphics.rectangle('fill', x, y, self.size, self.size)
                else
                    love.graphics.rectangle('line', x, y, self.size, self.size)
                end
            end
            x = x + self.offset
            ij = ij + 1
        end
        y = y + self.offset
    end
end

function Field:updateEvent(dt)
end
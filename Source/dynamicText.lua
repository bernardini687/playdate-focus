import 'CoreLibs/sprites'

--[[
	Usage:

		txt = DynamicText(x, y, 'font_name')
		txt:setContent('hello world')
		playdate.graphics.sprite.update()
]]
class('DynamicText').extends(sprite)

function DynamicText:init(x, y, font)
	DynamicText.super.init(self)

	self.font = gfx.font.new('Fonts/'..font)

	self:moveTo(x, y)
	self:setContent()
	self:add()
end

function DynamicText:setContent(content)
	self.content = content or 'test'

	self:setSize(self.font:getTextWidth(self.content), self.font:getHeight())
	-- self:markDirty()
end

function DynamicText:draw()
	gfx.pushContext()
		gfx.setFont(self.font)
		gfx.drawText(self.content, 0, 0)
	gfx.popContext()
end

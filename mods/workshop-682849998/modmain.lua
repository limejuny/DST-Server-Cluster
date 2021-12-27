
local require = GLOBAL.require

local TextEdit = require "widgets/textedit"
local Text = require "widgets/text"
local HangulIME = require "hangul"
local Hangul = nil

local han_yeong_keys = {
	["pageup"] = GLOBAL.KEY_PAGEUP,
	["pagedown"] = GLOBAL.KEY_PAGEDOWN,
	["commandR"] = 319,
	["f10"] = GLOBAL.KEY_F10,
	["f11"] = GLOBAL.KEY_F11,
	["__ctrlspace"] = GLOBAL.KEY_LCTRL .. GLOBAL.KEY_SPACE,
	["__shiftspace"] = GLOBAL.KEY_LSHIFT .. GLOBAL.KEY_SPACE,
}
local han_yeong_key = han_yeong_keys[GetModConfigData("han_yeong_key")];
local han_yeong_toggle = GetModConfigData("default_han_yeong")
local pressed_opt_key = false

AddClassPostConstruct("widgets/textedit", function(self)
	local DoSelectedImage = self.DoSelectedImage or function() end
	function self:DoSelectedImage()
		Hangul = HangulIME()
		if not self.han_yeong_toggle_widget then
			self.han_yeong_toggle_widget = self:AddChild( Text( GLOBAL.DEFAULTFONT, 30 ) )
			self:UpdateHanYeongWidget()
			self.han_yeong_toggle_widget:SetPosition( 0,0,0 )
			self.han_yeong_toggle_widget:SetHAlign(GLOBAL.ANCHOR_RIGHT)
			self.han_yeong_toggle_widget:SetRegionSize(self:GetRegionSize())
		else
			self:UpdateHanYeongWidget()
			self.han_yeong_toggle_widget:Show()
		end

		DoSelectedImage(self)
	end

	local DoIdleImage = self.DoIdleImage or function() end
	function TextEdit:DoIdleImage()
		if self.han_yeong_toggle_widget then
			self.han_yeong_toggle_widget:Hide()
		end
		DoIdleImage(self)
	end

	local OnTextInput = self.OnTextInput or function() end
	function self:OnTextInput(text)
		local key_code = string.byte(text);

		if pressed_opt_key and key_code == GLOBAL.KEY_SPACE then 
			return false
		end

		if han_yeong_toggle then
			if key_code == GLOBAL.KEY_BACKSPACE and not Hangul.jamo:isEmpty() then
				Hangul:Delete()

				if not Hangul.jamo:isEmpty() then
					self.inst.TextEditWidget:OnKeyDown(GLOBAL.KEY_BACKSPACE)
					OnTextInput(self, Hangul.jamo:toString() .. ' ')
				end

			elseif key_code ~= GLOBAL.KEY_SPACE and self:ValidateChar(text) then
				if not Hangul.jamo:isEmpty() then
					self.inst.TextEditWidget:OnKeyDown(GLOBAL.KEY_BACKSPACE)
				end
	
				Hangul:Input(text)
				if Hangul.pre_jamo ~= nil and Hangul.pre_jamo.unknown == nil then
					OnTextInput(self,Hangul.pre_jamo:toString())
				end
				
				text = Hangul.jamo:toString() or text
			end
		end

		OnTextInput(self,text)
	end

	function self:ToggleHanYeong()
		han_yeong_toggle = not han_yeong_toggle
		self:UpdateHanYeongWidget()
	end
	
	function self:UpdateHanYeongWidget()
		local widget = self.han_yeong_toggle_widget

		if han_yeong_toggle then 
			widget:SetString("가")
			widget:SetColour(0,0,1,0.5)
		else
			widget:SetString("A")
			widget:SetColour(1,0,0,0.5)
		end
	end
end)

local OnRawKey = TextEdit.OnRawKey or function () end
function TextEdit:OnRawKey(key, down)
	if self.editing then
		if down then
			if key == han_yeong_key then
				self:ToggleHanYeong()
			elseif key == GLOBAL.KEY_BACKSPACE and GLOBAL.PLATFORM ~= 'WIN32_STEAM' then
				self:OnTextInput(string.char(GLOBAL.KEY_BACKSPACE))
			elseif (han_yeong_key == han_yeong_keys.__ctrlspace or han_yeong_key == han_yeong_keys.__shiftspace) and key == GLOBAL.KEY_SPACE and pressed_opt_key then
				self:ToggleHanYeong()
				Hangul = HangulIME()
			elseif ValidateKeyForInit(key) then
				Hangul = HangulIME()
			elseif 
				(han_yeong_key == han_yeong_keys.__ctrlspace and key == GLOBAL.KEY_LCTRL) or
				(han_yeong_key == han_yeong_keys.__shiftspace and key == GLOBAL.KEY_LSHIFT)
			then
				pressed_opt_key = true
			end
		else
			if
				(han_yeong_key == han_yeong_keys.__ctrlspace and key == GLOBAL.KEY_LCTRL) or
				(han_yeong_key == han_yeong_keys.__shiftspace and key == GLOBAL.KEY_LSHIFT)
			then
				pressed_opt_key = false
			end
		end
	end

	return OnRawKey(self,key,down)
end

function ValidateKeyForInit(key)
	for i,v in ipairs({
		"KEY_UP",
		"KEY_DOWN",
		"KEY_RIGHT",
		"KEY_LEFT",
		"KEY_DELETE",
		"KEY_HOME",
		"KEY_END",
		"KEY_SPACE"
	}) do
		if GLOBAL[v] == key then
			return true
		end
	end
	return false
end
-- This file is loaded from "GuildBankExport.toc"

--Send message to chatlog when Guild Bank is opened
local frame = CreateFrame("Frame")
frame:RegisterEvent("GUILDBANKFRAME_OPENED")
frame:SetScript(
   "OnEvent",
   function(self, event, ...)
      print("|cffff0000 GuildExport: |r Type |cffffff00 /guildbankexport |r to export your gbank into CSV format.")
   end
)

--Create parent frame with default "BasicFrameTemplate" template
local frame = CreateFrame("Frame", "GuildExportFrame", UIParent, "BasicFrameTemplate")
frame:SetSize(600, 600)
frame:SetPoint("CENTER")
frame:Hide()
--Make this frame close when ESC is hit
tinsert(UISpecialFrames, "GuildExportFrame")

--Create scrollable editbox with default "InputScrollFrameTemplate" template
frame.scrollFrame = CreateFrame("ScrollFrame", "GuildExportScrollFrame", frame, "InputScrollFrameTemplate")
frame.scrollFrame:SetPoint("TOPLEFT", 8, -30)
frame.scrollFrame:SetPoint("BOTTOMRIGHT", -12, 9)

--Set up the editbox defined above
local editBox = frame.scrollFrame.EditBox --Already created in above template
editBox:SetFontObject("ChatFontNormal")
editBox:SetAllPoints(true)
editBox:SetWidth(frame.scrollFrame:GetWidth()) --Multiline editboxes need a width declared!!
--When ESC is hit while editbox has focus, clear focus (a second ESC closes window)
editBox:SetScript("OnEscapePressed", editBox.ClearFocus)

-- set up /guildexport slash command to dump guildbank to editbox
SLASH_GUILDEXPORT1 = "/guildbankexport"
--SlashCmdList["GUILDEXPORT"] = handler;

function SlashCmdList.GUILDEXPORT(msg)

   --Tab Check/hide
TabConfig.tab1CheckBox:Hide()
TabConfig.tab2CheckBox:Hide()
TabConfig.tab3CheckBox:Hide()
TabConfig.tab4CheckBox:Hide()
TabConfig.tab5CheckBox:Hide()
TabConfig.tab6CheckBox:Hide()
TabConfig.tab7CheckBox:Hide()
TabConfig.tab8CheckBox:Hide()

local numTabs = GetNumGuildBankTabs()

if numTabs >= 1 then
   TabConfig.tab1CheckBox:Show()
   TabConfig.tab1CheckBox:SetChecked(true)
end

if numTabs >= 2 then
   TabConfig.tab2CheckBox:Show()
   TabConfig.tab2CheckBox:SetChecked(true)
end

if numTabs >= 3 then
   TabConfig.tab3CheckBox:Show()
   TabConfig.tab3CheckBox:SetChecked(true)
end

if numTabs >= 4 then
   TabConfig.tab4CheckBox:Show()
   TabConfig.tab4CheckBox:SetChecked(true)
end

if numTabs >= 5 then
   TabConfig.tab5CheckBox:Show()
   TabConfig.tab5CheckBox:SetChecked(true)
end

if numTabs >= 6 then
   TabConfig.tab6CheckBox:Show()
   TabConfig.tab6CheckBox:SetChecked(true)
end

if numTabs >= 7 then
   TabConfig.tab7CheckBox:Show()
   TabConfig.tab7CheckBox:SetChecked(true)
end

if numTabs >= 8 then
   TabConfig.tab8CheckBox:Show()
   TabConfig.tab8CheckBox:SetChecked(true)
end

   TabConfig:Show()
end

local function runExport()
   --Hide Config Frame
   TabConfig:Hide()
   local tabs = {
      TabConfig.tab1CheckBox:GetChecked(),
      TabConfig.tab2CheckBox:GetChecked(),
      TabConfig.tab3CheckBox:GetChecked(),
      TabConfig.tab4CheckBox:GetChecked(),
      TabConfig.tab5CheckBox:GetChecked(),
      TabConfig.tab6CheckBox:GetChecked(),
      TabConfig.tab7CheckBox:GetChecked(),
      TabConfig.tab8CheckBox:GetChecked()
   }
   local list = {}
   tinsert(list, "Gold;")
   tinsert(list, GetGuildBankMoney())
   tinsert(list, "\n")
   for i = 1, 8 do
      if tabs[i] then
         for j = 1, (7 * 14) do
            local tab = i
            local slot = j
            if GetGuildBankItemLink(tab, slot) then
               local itemName = select(1, GetItemInfo(GetGuildBankItemLink(tab, slot)))
               local quantity = select(2, GetGuildBankItemInfo(tab, slot))

               tinsert(list, itemName)
               tinsert(list, ";")
               tinsert(list, quantity)
               tinsert(list, "\n")
            end
         end
      end
   end
   --Send them to editbox
   editBox:SetText(table.concat(list))
   --Show frame and highlight text just added for copy-pasting
   frame:Show()
   editBox:HighlightText()
   editBox:SetFocus(true)
end

---------------Create Tab Config Frame-------------------------
--Tab Selection Frame
TabConfig = CreateFrame("Frame", "Tab Selection", UIParent, "BasicFrameTemplateWithInset")
TabConfig:SetSize(200, 350)
TabConfig:SetPoint("Center", UIParent, "Center")

--Title
TabConfig.title = TabConfig:CreateFontString(nil, "OVERLAY")
TabConfig.title:SetFontObject("GameFontHighlight")
TabConfig.title:SetPoint("Left", TabConfig.TitleBg, "Left", 5, 0)
TabConfig.title:SetText("Tab Selection")

--Checkboxes
TabConfig.tab1CheckBox = CreateFrame("CheckButton", nil, TabConfig, "UICheckButtonTemplate")
TabConfig.tab1CheckBox:SetPoint("TOPLEFT", TabConfig, "TOPLEFT", 10, -30)
TabConfig.tab1CheckBox.text:SetText("Tab 1")
TabConfig.tab1CheckBox.text:SetFontObject("GameFontNormalLarge")
TabConfig.tab1CheckBox:SetSize(40, 40)
TabConfig.tab1CheckBox:SetChecked(false)

TabConfig.tab2CheckBox = CreateFrame("CheckButton", nil, TabConfig, "UICheckButtonTemplate")
TabConfig.tab2CheckBox:SetPoint("TOPLEFT", TabConfig.tab1CheckBox, "TOPLEFT", 0, -30)
TabConfig.tab2CheckBox.text:SetText("Tab 2")
TabConfig.tab2CheckBox.text:SetFontObject("GameFontNormalLarge")
TabConfig.tab2CheckBox:SetSize(40, 40)
TabConfig.tab2CheckBox:SetChecked(false)

TabConfig.tab3CheckBox = CreateFrame("CheckButton", nil, TabConfig, "UICheckButtonTemplate")
TabConfig.tab3CheckBox:SetPoint("TOPLEFT", TabConfig.tab2CheckBox, "TOPLEFT", 0, -30)
TabConfig.tab3CheckBox.text:SetText("Tab 3")
TabConfig.tab3CheckBox.text:SetFontObject("GameFontNormalLarge")
TabConfig.tab3CheckBox:SetSize(40, 40)
TabConfig.tab3CheckBox:SetChecked(false)

TabConfig.tab4CheckBox = CreateFrame("CheckButton", nil, TabConfig, "UICheckButtonTemplate")
TabConfig.tab4CheckBox:SetPoint("TOPLEFT", TabConfig.tab3CheckBox, "TOPLEFT", 0, -30)
TabConfig.tab4CheckBox.text:SetText("Tab 4")
TabConfig.tab4CheckBox.text:SetFontObject("GameFontNormalLarge")
TabConfig.tab4CheckBox:SetSize(40, 40)
TabConfig.tab4CheckBox:SetChecked(false)

TabConfig.tab5CheckBox = CreateFrame("CheckButton", nil, TabConfig, "UICheckButtonTemplate")
TabConfig.tab5CheckBox:SetPoint("TOPLEFT", TabConfig.tab4CheckBox, "TOPLEFT", 0, -30)
TabConfig.tab5CheckBox.text:SetText("Tab 5")
TabConfig.tab5CheckBox.text:SetFontObject("GameFontNormalLarge")
TabConfig.tab5CheckBox:SetSize(40, 40)
TabConfig.tab5CheckBox:SetChecked(false)

TabConfig.tab6CheckBox = CreateFrame("CheckButton", nil, TabConfig, "UICheckButtonTemplate")
TabConfig.tab6CheckBox:SetPoint("TOPLEFT", TabConfig.tab5CheckBox, "TOPLEFT", 0, -30)
TabConfig.tab6CheckBox.text:SetText("Tab 6")
TabConfig.tab6CheckBox.text:SetFontObject("GameFontNormalLarge")
TabConfig.tab6CheckBox:SetSize(40, 40)
TabConfig.tab6CheckBox:SetChecked(false)

TabConfig.tab7CheckBox = CreateFrame("CheckButton", nil, TabConfig, "UICheckButtonTemplate")
TabConfig.tab7CheckBox:SetPoint("TOPLEFT", TabConfig.tab6CheckBox, "TOPLEFT", 0, -30)
TabConfig.tab7CheckBox.text:SetText("Tab 7")
TabConfig.tab7CheckBox.text:SetFontObject("GameFontNormalLarge")
TabConfig.tab7CheckBox:SetSize(40, 40)
TabConfig.tab7CheckBox:SetChecked(false)

TabConfig.tab8CheckBox = CreateFrame("CheckButton", nil, TabConfig, "UICheckButtonTemplate")
TabConfig.tab8CheckBox:SetPoint("TOPLEFT", TabConfig.tab7CheckBox, "TOPLEFT", 0, -30)
TabConfig.tab8CheckBox.text:SetText("Tab 8")
TabConfig.tab8CheckBox.text:SetFontObject("GameFontNormalLarge")
TabConfig.tab8CheckBox:SetSize(40, 40)
TabConfig.tab8CheckBox:SetChecked(false)
--[[
--Tab Check/hide
TabConfig.tab1CheckBox:Hide()
TabConfig.tab2CheckBox:Hide()
TabConfig.tab3CheckBox:Hide()
TabConfig.tab4CheckBox:Hide()
TabConfig.tab5CheckBox:Hide()
TabConfig.tab6CheckBox:Hide()
TabConfig.tab7CheckBox:Hide()
TabConfig.tab8CheckBox:Hide()

local numTabs = GetNumGuildBankTabs()

if numTabs >= 1 then
   TabConfig.tab1CheckBox:Show()
   TabConfig.tab1CheckBox:SetChecked(true)
end

if numTabs >= 2 then
   TabConfig.tab2CheckBox:Show()
   TabConfig.tab2CheckBox:SetChecked(true)
end

if numTabs >= 3 then
   TabConfig.tab3CheckBox:Show()
   TabConfig.tab3CheckBox:SetChecked(true)
end

if numTabs >= 4 then
   TabConfig.tab4CheckBox:Show()
   TabConfig.tab4CheckBox:SetChecked(true)
end

if numTabs >= 5 then
   TabConfig.tab5CheckBox:Show()
   TabConfig.tab5CheckBox:SetChecked(true)
end

if numTabs >= 6 then
   TabConfig.tab6CheckBox:Show()
   TabConfig.tab6CheckBox:SetChecked(true)
end

if numTabs >= 7 then
   TabConfig.tab7CheckBox:Show()
   TabConfig.tab7CheckBox:SetChecked(true)
end

if numTabs >= 8 then
   TabConfig.tab8CheckBox:Show()
   TabConfig.tab8CheckBox:SetChecked(true)
end--]]


--OK Button
TabConfig.OKButton = CreateFrame("Button", nil, TabConfig, "GameMenuButtonTemplate")
TabConfig.OKButton:SetPoint("BOTTOMLEFT", TabConfig, "BOTTOMLEFT", 15, 10)
TabConfig.OKButton:SetSize(140, 40)
TabConfig.OKButton:SetText("OK")
TabConfig.OKButton:SetNormalFontObject("GameFontNormalLarge")
TabConfig.OKButton:SetHighlightFontObject("GameFontHighlightLarge")
TabConfig.OKButton:SetScript(
   "OnClick",
   function()
      runExport()
   end
)

TabConfig:Hide()

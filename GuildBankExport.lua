-- This file is loaded from "Banking-Tools.toc"

--Send message to chatlog when Guild Bank is opened
local guildbankexportmessage = true;
local frame = CreateFrame("Frame")
frame:RegisterEvent("GUILDBANK_UPDATE_TABS") --This isn't firing consistantly
frame:SetScript(
   "OnEvent",
   function(self, event, ...)
      if guildbankexportmessage then
         print("|cffff0000 Banking-Tools: |r Type |cffffff00 /guildbankexport |r to export your gbank into CSV format.")
         guildbankexportmessage = false;
      end
   end
)

--[[Create parent frame with default "BasicFrameTemplate" template
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
editBox:SetScript("OnEscapePressed", editBox.ClearFocus)--]]

-- Frame code largely adapted from https://www.wowinterface.com/forums/showpost.php?p=323901&postcount=2
    -- Main Frame
    local f = CreateFrame("Frame", "GuildBankExportFrame", UIParent, "DialogBoxFrame")
    f:ClearAllPoints()
    -- load position from local DB
    f:SetPoint("CENTER")
    f:SetSize(600,600)
    f:SetBackdrop({
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
      edgeSize = 16,
      insets = { left = 8, right = 8, top = 8, bottom = 8 },
    })
    f:SetMovable(true)
    f:SetClampedToScreen(true)
    f:SetScript("OnMouseDown", function(self, button)
      if button == "LeftButton" then
        self:StartMoving()
      end
    end)

    -- scroll frame
    local sf = CreateFrame("ScrollFrame", "GuildBankExportScrollFrame", f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("LEFT", 16, 0)
    sf:SetPoint("RIGHT", -32, 0)
    sf:SetPoint("TOP", 0, -32)
    sf:SetPoint("BOTTOM", GuildBankExportFrameButton, "TOP", 0, 0)

    -- edit box
    local eb = CreateFrame("EditBox", "GuildBankExportEditBox", GuildBankExportScrollFrame)
    eb:SetSize(sf:GetSize())
    eb:SetMultiLine(true)
    eb:SetAutoFocus(true)
    eb:SetFontObject("ChatFontNormal")
    eb:SetScript("OnEscapePressed", function() f:Hide() end)
    sf:SetScrollChild(eb)

    -- resizing
    f:SetResizable(false)
    local rb = CreateFrame("Button", "GuildBankExportResizeButton", f)
    rb:SetPoint("BOTTOMRIGHT", -6, 7)
    rb:SetSize(16, 16)

    rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

    rb:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            f:StartSizing("BOTTOMRIGHT")
            self:GetHighlightTexture():Hide() -- more noticeable
        end
    end)
    rb:SetScript("OnMouseUp", function(self, button)
        f:StopMovingOrSizing()
        self:GetHighlightTexture():Show()
        eb:SetWidth(sf:GetWidth())
    end)

    GuildBankExportFrame = f

-- set up /guildexport slash command to dump guildbank to editbox
SLASH_GUILDEXPORT1 = "/guildbankexport"
--SlashCmdList["GUILDEXPORT"] = handler;

function SlashCmdList.GUILDEXPORT(msg)

   --Tab Check/hide
   TabConfig.goldCheckBox:Show()
   TabConfig.goldCheckBox:SetChecked(true)
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
      TabConfig.tab1CheckBox.text:SetText(select(1,GetGuildBankTabInfo(1)))
      TabConfig.tab1CheckBox:Show()
      TabConfig.tab1CheckBox:SetChecked(true)
   end

   if numTabs >= 2 then
      TabConfig.tab2CheckBox.text:SetText(select(1,GetGuildBankTabInfo(2)))
      TabConfig.tab2CheckBox:Show()
      TabConfig.tab2CheckBox:SetChecked(true)
   end

   if numTabs >= 3 then
      TabConfig.tab3CheckBox.text:SetText(select(1,GetGuildBankTabInfo(3)))
      TabConfig.tab3CheckBox:Show()
      TabConfig.tab3CheckBox:SetChecked(true)
   end

   if numTabs >= 4 then
      TabConfig.tab4CheckBox.text:SetText(select(1,GetGuildBankTabInfo(4)))
      TabConfig.tab4CheckBox:Show()
      TabConfig.tab4CheckBox:SetChecked(true)
   end

   if numTabs >= 5 then
      TabConfig.tab5CheckBox.text:SetText(select(1,GetGuildBankTabInfo(5)))
      TabConfig.tab5CheckBox:Show()
      TabConfig.tab5CheckBox:SetChecked(true)
   end

   if numTabs >= 6 then
      TabConfig.tab6CheckBox.text:SetText(select(1,GetGuildBankTabInfo(6)))
      TabConfig.tab6CheckBox:Show()
      TabConfig.tab6CheckBox:SetChecked(true)
   end

   if numTabs >= 7 then
      TabConfig.tab7CheckBox.text:SetText(select(1,GetGuildBankTabInfo(7)))
      TabConfig.tab7CheckBox:Show()
      TabConfig.tab7CheckBox:SetChecked(true)
   end

   if numTabs >= 8 then
      TabConfig.tab8CheckBox.text:SetText(select(1,GetGuildBankTabInfo(8)))
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
   if TabConfig.goldCheckBox:GetChecked() then
      tinsert(list, "Gold;Gold;")
      tinsert(list, GetGuildBankMoney())
      tinsert(list, "\n")
   end
   for i = 1, 8 do
      if tabs[i] then
         for j = 1, (7 * 14) do
            local tab = i
            local slot = j
            if GetGuildBankItemLink(tab, slot) then
               local itemName = select(1, C_Item.GetItemInfo(GetGuildBankItemLink(tab, slot)))
               local quantity = select(2, GetGuildBankItemInfo(tab, slot))
               local itemID = C_Item.GetItemIDForItemInfo(select(2,C_Item.GetItemInfo(GetGuildBankItemLink(tab, slot))))

               tinsert(list,itemID)
               tinsert(list,";")
               tinsert(list, itemName)
               tinsert(list, ";")
               tinsert(list, quantity)
               tinsert(list, "\n")
            end
         end
      end
   end
   --Send them to editbox
   GuildBankExportEditBox:SetText(table.concat(list))
   --Show frame and highlight text just added for copy-pasting
   f:Show()
   GuildBankExportEditBox:HighlightText()
   GuildBankExportEditBox:SetFocus(true)
end

---------------Create Tab Config Frame-------------------------
--Tab Selection Frame
TabConfig = CreateFrame("Frame", "Tab Selection", UIParent, "BasicFrameTemplateWithInset")
TabConfig:SetSize(200, 370)
TabConfig:SetPoint("Center", UIParent, "Center")

--Title
TabConfig.title = TabConfig:CreateFontString(nil, "OVERLAY")
TabConfig.title:SetFontObject("GameFontHighlight")
TabConfig.title:SetPoint("Left", TabConfig.TitleBg, "Left", 5, 0)
TabConfig.title:SetText("Tab Selection")

--Checkboxes
TabConfig.goldCheckBox = CreateFrame("CheckButton", nil, TabConfig, "UICheckButtonTemplate")
TabConfig.goldCheckBox:SetPoint("TOPLEFT", TabConfig, "TOPLEFT", 10, -30)
TabConfig.goldCheckBox.text:SetText("Gold")
TabConfig.goldCheckBox.text:SetFontObject("GameFontNormalLarge")
TabConfig.goldCheckBox:SetSize(40, 40)
TabConfig.goldCheckBox:SetChecked(false)

TabConfig.tab1CheckBox = CreateFrame("CheckButton", nil, TabConfig, "UICheckButtonTemplate")
TabConfig.tab1CheckBox:SetPoint("TOPLEFT", TabConfig.goldCheckBox, "TOPLEFT", 0, -30)
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

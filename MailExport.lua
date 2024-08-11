-- This file is loaded from "Banking-Tools.toc"

--SLASH_MAILEXPORT1, SLASH_MAILEXPORT2 = '/mex', '/mailexport';
--function SlashCmdList.MAILEXPORT(msg, editBox)
--    for i = 1, GetInboxNumItems() do
--   -- An underscore is commonly used to name variables you aren't going to use in your code:
--   local _, _, sender, subject, money, _, daysLeft, hasItem, _, _, _, canReply = GetInboxHeaderInfo(i)
--      print(date("%a %b %d %H:%M:%S %Y"), canReply, subject, money,"from", sender, "has attachments:")
--      for j = 1, ATTACHMENTS_MAX_RECEIVE do
--         local name, itemID, texture, count, quality, canUse = GetInboxItem(i, j)
--         if name then
--            -- Construct an inline texture sequence:
--            print(name, "x", count)
--         end
--      end
--    end
--end

local mailexportmessage = true;
local frame = CreateFrame("Frame")
frame:RegisterEvent("MAIL_SHOW")
frame:SetScript("OnEvent", function(self, event, ...)
  if mailexportmessage then
    print("|cffff0000 Banking-Tools: |r Type |cffffff00 /mailexport |r to export your mail into CSV format.")
    mailexportmessage = false;
  end
end)

--[[ create parent frame with default "BasicFrameTemplate" template
local frame = CreateFrame("Frame","MailExportFrame",UIParent,"BasicFrameTemplate")
frame:SetSize(600,600)
frame:SetPoint("CENTER")
frame:Hide()
-- make this frame close when ESC is hit
tinsert(UISpecialFrames,"MailExportFrame")

-- create scrollable editbox with default "InputScrollFrameTemplate" template
frame.scrollFrame = CreateFrame("ScrollFrame","MailExportScrollFrame",frame,"WowScrollBoxList")
frame.scrollFrame:SetPoint("TOPLEFT",8,-30)
frame.scrollFrame:SetPoint("BOTTOMRIGHT",-12,9)

-- set up the editbox defined above
local editBox = frame.scrollFrame.EditBox -- already created in above template
editBox:SetFontObject("ChatFontNormal")
editBox:SetAllPoints(true)
editBox:SetWidth(frame.scrollFrame:GetWidth()) -- multiline editboxes need a width declared!!
-- when ESC is hit while editbox has focus, clear focus (a second ESC closes window)
editBox:SetScript("OnEscapePressed",editBox.ClearFocus)--]]

  -- Frame code largely adapted from https://www.wowinterface.com/forums/showpost.php?p=323901&postcount=2
    -- Main Frame
    local f = CreateFrame("Frame", "MailExportFrame", UIParent, "DialogBoxFrame")
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
    local sf = CreateFrame("ScrollFrame", "MailExportScrollFrame", f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("LEFT", 16, 0)
    sf:SetPoint("RIGHT", -32, 0)
    sf:SetPoint("TOP", 0, -32)
    sf:SetPoint("BOTTOM", MailExportFrameButton, "TOP", 0, 0)

    -- edit box
    local eb = CreateFrame("EditBox", "MailExportEditBox", MailExportScrollFrame)
    eb:SetSize(sf:GetSize())
    eb:SetMultiLine(true)
    eb:SetAutoFocus(true)
    eb:SetFontObject("ChatFontNormal")
    eb:SetScript("OnEscapePressed", function() f:Hide() end)
    sf:SetScrollChild(eb)

    -- resizing
    f:SetResizable(false)
    local rb = CreateFrame("Button", "MailExportResizeButton", f)
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

    MailExportFrame = f
    
SLASH_MAILEXPORT1 = "/mailexport"
SlashCmdList["MAILEXPORT"] = function(msg)
  local playerName = UnitName("player");
  local list = {}
  for i = 1, GetInboxNumItems() do
 -- An underscore is commonly used to name variables you aren't going to use in your code:
 local _, _, sender, subject, money, _, daysLeft, hasItem, _, _, _, canReply = GetInboxHeaderInfo(i)
    tinsert(list,date("%a %b %d %H:%M:%S %Y"))
    tinsert(list,";")
    tinsert(list,sender)
    tinsert(list,";")
    tinsert(list,playerName)
    tinsert(list,";")
    tinsert(list,subject)
    tinsert(list,";")
    tinsert(list,money)
    for j = 1, ATTACHMENTS_MAX_RECEIVE do
      local name, itemID, texture, count, quality, canUse = GetInboxItem(i, j)
        if name then
          -- Construct an inline texture sequence:
          tinsert(list,";")
          tinsert(list,itemID)
          tinsert(list,";")
          tinsert(list,name)
          tinsert(list,";")
          tinsert(list,count)
        end
end
tinsert(list,"\n")
end


  -- send them to editbox
  MailExportEditBox:SetText(table.concat(list))
  -- show frame and highlight text just added for copy-pasting
  MailExportFrame:Show()
  MailExportEditBox:HighlightText()
  MailExportEditBox:SetFocus(true)
end

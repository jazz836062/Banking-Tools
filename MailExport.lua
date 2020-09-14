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

local frame = CreateFrame("Frame")
frame:RegisterEvent("MAIL_SHOW")
frame:SetScript("OnEvent", function(self, event, ...)
 print("|cffff0000 MailExport: |r Type |cffffff00 /mailexport |r to export your mail into CSV format.")
end)

-- create parent frame with default "BasicFrameTemplate" template
local frame = CreateFrame("Frame","MailExportFrame",UIParent,"BasicFrameTemplate")
frame:SetSize(600,600)
frame:SetPoint("CENTER")
frame:Hide()
-- make this frame close when ESC is hit
tinsert(UISpecialFrames,"MailExportFrame")

-- create scrollable editbox with default "InputScrollFrameTemplate" template
frame.scrollFrame = CreateFrame("ScrollFrame","MailExportScrollFrame",frame,"InputScrollFrameTemplate")
frame.scrollFrame:SetPoint("TOPLEFT",8,-30)
frame.scrollFrame:SetPoint("BOTTOMRIGHT",-12,9)

-- set up the editbox defined above
local editBox = frame.scrollFrame.EditBox -- already created in above template
editBox:SetFontObject("ChatFontNormal")
editBox:SetAllPoints(true)
editBox:SetWidth(frame.scrollFrame:GetWidth()) -- multiline editboxes need a width declared!!
-- when ESC is hit while editbox has focus, clear focus (a second ESC closes window)
editBox:SetScript("OnEscapePressed",editBox.ClearFocus)

-- set up /listraidroster slash command to dump raid roster to above editbox
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
        tinsert(list,name)
        tinsert(list,";")
        tinsert(list,count)
        end
end
tinsert(list,"\n")
end


  -- send them to editbox
  editBox:SetText(table.concat(list))
  -- show frame and highlight text just added for copy-pasting
  frame:Show()
  editBox:HighlightText()
  editBox:SetFocus(true)
end

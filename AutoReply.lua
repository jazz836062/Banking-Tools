-- This file is loaded from "Banking-Tools.toc"

local frame = CreateFrame("Frame")
frame:RegisterEvent("MAIL_SHOW")
frame:SetScript("OnEvent", function(self, event, ...)
 print("|cffff0000 Banking-Tools: |r Type |cffffff00 /autoreply |r to reply to all your mail with a thank you.")
end)

SLASH_AUTOREPLY1 = "/autoreply"
SlashCmdList["AUTOREPLY"] = function(msg)
  local playerName = UnitName("player");
  local list = {}
  for i = 1, GetInboxNumItems() do
    -- An underscore is commonly used to name variables you aren't going to use in your code:
    local _, _, sender, subject, money, _, daysLeft, hasItem, _, _, _, canReply = GetInboxHeaderInfo(i)
    local message = "Thank you, "..sender..", for your donation of:\n\n"   ;
    if money>0 then
      local gold = math.floor(money/10000);
      local silver = math.floor((money-(gold*10000))/100)
      local copper = money-((gold*10000)+(silver*100))
      message = message..gold.."g"..silver.."s"..copper.."c\n";
    end
    for j = 1, ATTACHMENTS_MAX_RECEIVE do
      local name, itemID, texture, count, quality, canUse = GetInboxItem(i, j)
      if name then
        message = message..count.." - "..name.."\n";
      end
    end
  message = message.."\nThe banking team appreciates your support.\n\nSincerely,\n"..playerName;
  SendMail(sender,"Thank you for your donation",message)
  end
end

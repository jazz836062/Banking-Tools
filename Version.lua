-- This file is loaded from "Banking-Tools.toc"

SLASH_BANKTOOLSVERSION1 = "/banktoolsversion"
SlashCmdList["BANKTOOLSVERSION"] = function(msg)
    local version = GetAddOnMetadata("Banking-Tools","version")

    print("Banking-Tools Version: "..version)
end
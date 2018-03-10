function PartyTom()
  print("PartyTom Loaded")

  if not PartyTomFrame then
    PartyTomFrame = CreateFrame("Frame", "PartyTomFrame");
  end

  local counter = {}
  local coordsMatch = "[0-9]?[0-9] [0-9]?[0-9]"

  local function processMsg(origin,msg,author)
    if (counter[author] == nil) then
      counter[author] = 1
    end
    local match = string.match(msg,"way "..coordsMatch)
    if (match) then
      local coords = string.match(match, coordsMatch)
      print("PartyTomFrame ["..origin.."]: /way "..coords)
      SlashCmdList["TOMTOM_WAY"](coords.." "..author.."("..origin..") #"..counter[author])
      couter[author] = counter[author]+1
    end
  end

  local frame = PartyTomFrame
  frame:RegisterEvent("CHAT_MSG_SAY");
  frame:RegisterEvent("CHAT_MSG_PARTY");
  frame:RegisterEvent("CHAT_MSG_PARTY_LEADER");
  frame:SetScript("OnEvent", function(self, event, msg, author )
    if (event == "CHAT_MSG_SAY") then
      processMsg("SAY",msg,author)
    elseif (event == "CHAT_MSG_PARTY") then
      processMsg("PARTY",msg,author)
    elseif (event == "CHAT_MSG_PARTY_LEADER") then
      processMsg("LEADER",msg,author)
    end
  end)
end

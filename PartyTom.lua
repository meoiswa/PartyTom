function PartyTom()
  print("PartyTom Loaded")

  if not PartyTomFrame then
    PartyTomFrame = CreateFrame("Frame", "PartyTomFrame");
  end

  local counter = {}
  local coordsMatch = "[0-9]?[0-9](\.[0-9]?[0-9])? [0-9]?[0-9](\.[0-9]?[0-9])?"

  local function split(str,pat)
    local tbl={}
    str:gsub(pat,function(x) tbl[#tbl+1]=x end)
    return tbl
  end

  local function parseCoords(msg)

    local pat = "[^ ]*"
    local cpat = "%d?%d%.?%d?%d?"

    local matches = 0
    local x = 0
    local y = 0
    for i, j in ipairs(split(msg,pat)) do
      if (string.len(j) > 0) then
      	local match = string.match(j,cpat)
      	local number = tonumber(match)
      	if (matches == 0 and j == "way") then
      		matches = 1
      	elseif (
      		matches > 0
      		and string.len(j) > 0
      		and string.len(j) <= 5
      		and match
      		and number
      		and number > 0
      		and number < 100
      	) then
      		if (matches == 1) then
      			matches = 2
      			x = number
      		else
      			matches = 3
      			y = number
      		end
      	else
      		matches = 0
      	end
      	if (matches == 3) then
          return {
            x = x,
            y = y
          }
      	end
      end
    end
  end

  local function processMsg(origin,msg,author)

    local coords = parseCoords(msg)

    if (coords) then
      if (counter[author] == nil) then
        counter[author] = 1
      end
      print("PartyTomFrame ["..origin.."]: /way "..coords.x.." "..coords.y)
      SlashCmdList["TOMTOM_WAY"](coords.x.." "..coords.y.." "..author.."("..origin..") #"..counter[author])
      counter[author] = counter[author]+1
    end
  end

  local frame = PartyTomFrame
  frame:RegisterEvent("CHAT_MSG_SAY");
  frame:RegisterEvent("CHAT_MSG_PARTY");
  frame:RegisterEvent("CHAT_MSG_PARTY_LEADER");
  frame:RegisterEvent("CHAT_MSG_GUILD");
  frame:SetScript("OnEvent", function(self, event, msg, author )
    if (event == "CHAT_MSG_SAY") then
      processMsg("SAY",msg,author)
    elseif (event == "CHAT_MSG_PARTY") then
      processMsg("PARTY",msg,author)
    elseif (event == "CHAT_MSG_PARTY_LEADER") then
      processMsg("LEADER",msg,author)
    elseif (event == "CHAT_MSG_GUILD") then
      processMsg("GUILD",msg,author)
    end
  end)
end

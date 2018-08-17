PartyTom = LibStub("AceAddon-3.0"):NewAddon("PartyTom", "AceConsole-3.0", "AceEvent-3.0")

local defaults = {
  profile = {
    enabled = true,
    party = true,
    guild = true,
    whisper = true,
    raid = false,
    say = false,
    yell = false,
  }
}

local options = {
  name = "PartyTom",
  handler = PartyTom,
  type = 'group',
  args = {
    options = {
      type = "execute",
      name = "Options",
      desc = "Open the options GUI",
      func = "OpenOptions",
      guiHidden = true,
      order = 0
    },
    enabled = {
      type = "toggle",
      name = "Enabled",
      desc = function() return PartyTom:DescToggleEnabled() end,
      get = "GetToggleEnabled",
      set = "SetToggleEnabled",
      cmdHidden = true,
      order = 1,
    },
    help = {
      type = "description",
      name = "Enabled channels will be scanned for messages containing coordinates in the form of 'way X Y', and will be automatically input into TomTom",
      order = 2,
    },
    toggle = {
      type = "toggle",
      name = "Toggle",
      desc = function() return PartyTom:DescToggleEnabled() end,
      get = "GetToggleEnabled",
      set = "SetToggleEnabled",
      guiHidden = true,
      dialogHidden = true,
      dropdownHidden = true,
      order = 3,
    },
    enable = {
      type = "execute",
      name = "Enable",
      desc = "Enables the addon.",
      func = "SetEnabled",
      guiHidden = true,
      dialogHidden = true,
      dropdownHidden = true,
      order = 4,
    },
    disable = {
      type = "execute",
      name = "Disable",
      desc = "Disables the addon.",
      func = "SetDisabled",
      set = "Disable",
      guiHidden = true,
      dialogHidden = true,
      dropdownHidden = true,
      order = 5,
    },
    channels = {
      type = "group",
      name = "Channels",
      order = 6,
      guiInline = true,
      args = {
        party = {
          type = "toggle",
          name = "Party",
          desc = function() return PartyTom:DescParty() end,
          get = "GetParty",
          set = "SetParty",
        },
        guild = {
          type = "toggle",
          name = "Guild",
          desc = function() return PartyTom:DescGuild() end,
          get = "GetGuild",
          set = "SetGuild",
        },
        say = {
          type = "toggle",
          name = "Say",
          desc = function() return PartyTom:DescSay() end,
          get = "GetSay",
          set = "SetSay",
        },
        yell = {
          type = "toggle",
          name = "Yell",
          desc = function() return PartyTom:DescYell() end,
          get = "GetYell",
          set = "SetYell",
        },
        raid = {
          type = "toggle",
          name = "Raid",
          desc = function() return PartyTom:DescRaid() end,
          get = "GetRaid",
          set = "SetRaid",
        },
        whisper = {
          type = "toggle",
          name = "Whisper",
          desc = function() return PartyTom:DescWhisper() end,
          get = "GetWhisper",
          set = "SetWhisper",
        },
      }
    }
  },
}

function PartyTom:OpenOptions(info)
  InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
end


function PartyTom:SetEnabled(info)
  self:SetToggleEnabled(info, true)
end

function PartyTom:SetDisabled(info)
  self:SetToggleEnabled(info, false)
end

function PartyTom:DescToggleEnabled(info)
  return (self.db.profile.enabled and "Disables" or "Enables") .. " the addon."
end

function PartyTom:GetToggleEnabled(info)
  return self.db.profile.enabled
end

function PartyTom:SetToggleEnabled(info, newValue)
  self.db.profile.enabled = newValue
  if (newValue) then
    self:Enable()
  else
    self:Disable()
  end
end



function PartyTom:DescGuild(info)
  return (self.db.profile.guild and "Disables" or "Enables") .. " listening to /g (/o) messages."
end

function PartyTom:GetGuild(info)
  return self.db.profile. guild
end

function PartyTom:SetGuild(info, newValue)
  self.db.profile.guild = newValue
  self:Print("Guild " .. (newValue and "Enabled" or "Disabled"))
end



function PartyTom:DescParty(info)
  return (self.db.profile.party and "Disables" or "Enables") .. " listening to /p messages."
end

function PartyTom:GetParty(info)
  return self.db.profile. party
end

function PartyTom:SetParty(info, newValue)
  self.db.profile.party = newValue
  self:Print("Party " .. (newValue and "Enabled" or "Disabled"))
end


function PartyTom:DescSay(info)
  return (self.db.profile.say and "Disables" or "Enables") .. " listening to /s messages."
end

function PartyTom:GetSay(info)
  return self.db.profile.say
end

function PartyTom:SetSay(info, newValue)
  self.db.profile.say = newValue
  self:Print("Say " .. (newValue and "Enabled" or "Disabled"))
end



function PartyTom:DescRaid(info)
  return (self.db.profile.raid and "Disables" or "Enables") .. " listening to /r (/rw) messages."
end

function PartyTom:GetRaid(info)
  return self.db.profile.raid
end

function PartyTom:SetRaid(info, newValue)
  self.db.profile.raid = newValue
  self:Print("Raid " .. (newValue and "Enabled" or "Disabled"))
end



function PartyTom:DescYell(info)
  return (self.db.profile.yell and "Disables" or "Enables") .. " listening to /y messages."
end

function PartyTom:GetYell(info)
  return self.db.profile.yell
end

function PartyTom:SetYell(info, newValue)
  self.db.profile.yell = newValue
  self:Print("Yell " .. (newValue and "Enabled" or "Disabled"))
end



function PartyTom:DescWhisper(info)
  return (self.db.profile.whisper and "Disables" or "Enables") .. " listening to /w messages."
end

function PartyTom:GetWhisper(info)
  return self.db.profile.whisper
end

function PartyTom:SetWhisper(info, newValue)
  self.db.profile.whisper = newValue
  self:Print("Whisper " .. (newValue and "Enabled" or "Disabled"))
end




local function split(str,pat)
  local tbl={}
  str:gsub(pat,function(x) tbl[#tbl+1]=x end)
  return tbl
end

function PartyTom:ParseCoordinates(msg)

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

function PartyTom:ProcessMessage(channel, message, author)
  local coordinates = self:ParseCoordinates(message)

  if (coordinates) then
    if (self.counter == nil) then
      self.counter = {}
    end
    if (self.counter[author] == nil) then
      self.counter[author] = 1
    end
    self:Print("["..channel.."]: /way "..coordinates.x.." "..coordinates.y)
    SlashCmdList["TOMTOM_WAY"](coordinates.x.." "..coordinates.y.." "..author.." ("..channel..") #"..self.counter[author])
    self.counter[author] = self.counter[author]+1
  end
end

function PartyTom:OnEvent(event, message, author)
  if (self.db.profile.enabled) then
    if (event == "CHAT_MSG_SAY" and self.db.profile.say) then
      self:ProcessMessage("s", message, author)
    elseif ((event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER") and self.db.profile.party) then
      self:ProcessMessage("p", message, author)
    elseif ((event == "CHAT_MSG_GUILD" or event == "CHAT_MSG_OFFICER") and self.db.profile.guild) then
      self:ProcessMessage("g", message, author)
    elseif (event == "CHAT_MSG_YELL" and self.db.profile.yell) then
      self:ProcessMessage("y", message, author)
    elseif ((event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_RAID_WARNING") and self.db.profile.raid) then
      self:ProcessMessage("r", message, author)
    elseif ((event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER") and self.db.profile.whisper) then
      self:ProcessMessage("w", message, author)
    end
  else
    self:Disable()
  end
end


function PartyTom:OnInitialize()
  -- Called when the addon is loaded
  self.db = LibStub("AceDB-3.0"):New("PartyTomDB", defaults, true)

  LibStub("AceConfig-3.0"):RegisterOptionsTable("PartyTom", options, {"partytom", "ptom"})
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PartyTom", "PartyTom")
end

function PartyTom:RegisterEvents()

  self:RegisterEvent("CHAT_MSG_SAY", "OnEvent")
  self:RegisterEvent("CHAT_MSG_PARTY", "OnEvent")
  self:RegisterEvent("CHAT_MSG_PARTY_LEADER", "OnEvent")
  self:RegisterEvent("CHAT_MSG_GUILD", "OnEvent")
  self:RegisterEvent("CHAT_MSG_OFFICER", "OnEvent")
  self:RegisterEvent("CHAT_MSG_YELL", "OnEvent")
  self:RegisterEvent("CHAT_MSG_RAID", "OnEvent")
  self:RegisterEvent("CHAT_MSG_RAID_LEADER", "OnEvent")
  self:RegisterEvent("CHAT_MSG_RAID_WARNING", "OnEvent")
  self:RegisterEvent("CHAT_MSG_WHISPER", "OnEvent")
  self:RegisterEvent("CHAT_MSG_BN_WHISPER", "OnEvent")

end

function PartyTom:OnEnable()
  -- Called when the addon is enabled
  self:RegisterEvents()

  self:Print("Enabled")
end

function PartyTom:OnDisable()
  -- Called when the addon is disabled
  self:Print("Disabled")
end

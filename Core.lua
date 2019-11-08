local _, SRT = ...

SRT.Core = {}

local Core = SRT.Core

SRT.commands = {
  config = SRT.Config.Toggle,
}

function HandleSlashCommands(str)
  if (#str == 0) then
    print("Type '/srt config' for addon settings.")
    return
  end

  local f = SRT.commands[string.lower(str)]
  if type(f) == "function" then
    f()
  else
    print("Type '/srt config' for addon settings.")
  end
end

function Core:ShowHideButton()
  if SRT_SETTINGS.enabled then
    Core.UI.recallButton:Show()
  else
    Core.UI.recallButton:Hide()
  end
end

function Core:UpdatePosition(pt, rp, xo, yo)
  SRT_SETTINGS.position.point = pt
  SRT_SETTINGS.position.rel_point = rp
  SRT_SETTINGS.position.x_offset = xo
  SRT_SETTINGS.position.y_offset = yo
end

function Core:FrameDragStart(event, ...)
  Core.UI.recallButton:StartMoving()
end

function Core:FrameDragStop(event, ...)
  Core.UI.recallButton:StopMovingOrSizing()

  point, parent, rel_point, x_offset, y_offset = Core.UI.recallButton:GetPoint()
  if x_offset < 20 and x_offset > -20 then
      x_offset = 0
  end

  Core.UI.recallButton:SetPoint(point, parent, rel_point, x_offset, y_offset)
  --Core.UI:SetPoint("CENTER", Core.UI.recallButton, "CENTER", 0, 0)
  Core:UpdatePosition(point, rel_point, x_offset, y_offset)
end

function Core:Init(event, name)
  if (name ~= "SimpleRecallTotems") then return end
  print("SimpleRecallTotems Loaded...")
  -- Initialize persistent settings
  if type(SRT_SETTINGS) ~= "table" then
    SRT_SETTINGS = {
      move = true,
      enabled = true,
      position = {
        point = "CENTER",
        rel_point = "CENTER",
        x_offset = 0,
        y_offset = 0
      }
    }
  end

  -- main addon frame
  Core.UI = CreateFrame("Frame", "SRT_Frame", UIParent)

  local UI = Core.UI
  UI:SetSize(125, 25)
  UI:SetPoint("CENTER", UIParent, "CENTER")


  -- destroy totem frames
  for i = 1,4 do
    CreateFrame("Button", "SRT_totem"..i, UIParent, "SecureActionButtonTemplate")
    _G["SRT_totem"..i]:SetAttribute("type1", "destroytotem")
    _G["SRT_totem"..i]:SetAttribute("totem-slot", i)
  end

  -- main button
  UI.recallButton = CreateFrame("Button", nil, UI, "SecureActionButtonTemplate")
  UI.recallButton:SetPoint(SRT_SETTINGS.position.point, UI, SRT_SETTINGS.position.rel_point, SRT_SETTINGS.position.x_offset, SRT_SETTINGS.position.y_offset)
  UI.recallButton:SetSize(125, 50)
  UI.recallButton:SetText("Recall All Totems")
  UI.recallButton:SetNormalFontObject("GameFontNormal")
  UI.recallButton:SetHighlightFontObject("GameFontHighlight")
  UI.recallButton:SetAttribute("type1", "macro")
  UI.recallButton:SetAttribute("macrotext1", "/click SRT_totem1\n/click SRT_totem2\n/click SRT_totem3\n/click SRT_totem4")
  Core:ShowHideButton()

  -- turn on ability to drag and register for mouse drag events
  UI.recallButton:SetMovable(true)
  UI.recallButton:EnableMouse(true)
  UI.recallButton:RegisterForDrag("RightButton")
  UI.recallButton:SetScript("OnDragStart", Core.FrameDragStart)
  UI.recallButton:SetScript("OnDragStop", Core.FrameDragStop)

  -- Slash commands
  SLASH_SimpleRecallTotems1 = "/srt"
  SlashCmdList.SimpleRecallTotems = HandleSlashCommands
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", Core.Init)

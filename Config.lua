local _, SRT = ...
SRT.Config = {}

local Config = SRT.Config
local UIConfig

function Config:Toggle()
  local menu = UIConfig or Config:CreateMenu()
  UIConfig.macroText:SetText("/click SRT_totem1\n/click SRT_totem2\n/click SRT_totem3\n/click SRT_totem4")
  menu:SetShown(not menu:IsShown())
end

function Config:ClickReset()
  SRT.Core.UI.recallButton:SetPoint("CENTER", SRT.Core.UI, "CENTER", 0, 0)
  SRT.Core:UpdatePosition("CENTER", "CENTER", 0, 0)
end

function Config:CreateMenu()

  UIConfig = CreateFrame("Frame", "SRT_Config", UIParent, "BasicFrameTemplateWithInset")
  UIConfig:SetSize(200, 350)
  UIConfig:SetPoint("TOPLEFT", 50, -150)

  UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 10, 0)
  UIConfig.title:SetText("Simple Recall Totems")

  UIConfig.checkBtnEnabled = CreateFrame("CheckButton", nil, UIConfig, "UICheckButtonTemplate")
  UIConfig.checkBtnEnabled:SetPoint("CENTER", UIConfig, "CENTER", -25, 75)
  UIConfig.checkBtnEnabled.text:SetText("Button Enabled")
  UIConfig.checkBtnEnabled:SetChecked(SRT_SETTINGS.enabled)
  UIConfig.checkBtnEnabled:SetScript("OnClick",
  function()
    if UIConfig.checkBtnEnabled:GetChecked() then
      SRT_SETTINGS.enabled = true
    else
      SRT_SETTINGS.enabled = false
    end
    SRT.Core:ShowHideButton()
  end)

  -- UIConfig.checkBtnMoveable = CreateFrame("CheckButton", nil, UIConfig, "UICheckButtonTemplate")
  -- UIConfig.checkBtnMoveable:SetPoint("CENTER", UIConfig, "CENTER", -25, 25)
  -- UIConfig.checkBtnMoveable.text:SetText("Moveable")

  UIConfig.resetBtn = CreateFrame("CheckButton", nil, UIConfig, "GameMenuButtonTemplate")
  UIConfig.resetBtn:SetSize(120, 30)
  UIConfig.resetBtn:SetPoint("CENTER", UIConfig, "CENTER", 0, -25)
  UIConfig.resetBtn:SetText("Reset Position")
  UIConfig.resetBtn:SetScript("OnClick", Config.ClickReset)

  -- instructions and code to make macro
  UIConfig.macroInstructions = CreateFrame("Frame", nil, UIConfig)
  local macroInstructions = UIConfig.macroInstructions:CreateFontString("SRTMacroInstructions", "ARTWORK", "GameFontNormal")
  macroInstructions:SetPoint("CENTER", UIConfig, "CENTER", 0, -75)
  macroInstructions:SetText("Create a new macro \nwith the text below:")
  UIConfig.macroText = CreateFrame("EditBox", nil, UIConfig, "InputBoxTemplate")
  UIConfig.macroText:SetSize(100, 300)
  UIConfig.macroText:SetPoint("CENTER", UIConfig, "CENTER", 0, -100)
  UIConfig.macroText:SetText("/click SRT_totem1\n/click SRT_totem2\n/click SRT_totem3\n/click SRT_totem4")

  UIConfig:SetShown(false)
  return UIConfig
end

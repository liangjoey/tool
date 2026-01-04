local function focusChrome()
  hs.application.launchOrFocus("Google Chrome")
end

local function focusChromeTabByURL(urlPart)
  focusChrome()

  local escaped = urlPart:gsub('"', '\\"')
  local script = string.format([[
    tell application "Google Chrome"
      if not (exists window 1) then return "NO_WINDOW"
      repeat with w in windows
        set ti to 1
        repeat with t in tabs of w
          if (URL of t) contains "%s" then
            set active tab index of w to ti
            set index of w to 1
            activate
            return "OK"
          end if
          set ti to ti + 1
        end repeat
      end repeat
      return "NOT_FOUND"
    end tell
  ]], escaped)

  local ok, result = hs.osascript.applescript(script)
  if not ok then
    hs.alert.show("AppleScript 失敗: " .. tostring(result))
  elseif result == "NO_WINDOW" then
    hs.alert.show("Chrome 沒有視窗")
  elseif result == "NOT_FOUND" then
    hs.alert.show("找不到 tab: " .. urlPart)
  end
end

-- 兩段式：如果目前不在 Chrome，就只切到 Chrome；如果已在 Chrome，才切 tab
local function focusChromeOrTab(urlPart)
  local front = hs.application.frontmostApplication()
  if not front or front:name() ~= "Google Chrome" then
    focusChrome()
    hs.alert.show("Chrome")
    return
  end
  focusChromeTabByURL(urlPart)
end

-- =========================
-- Hotkeys
-- =========================

-- 1) 通用：先切到 Chrome
hs.hotkey.bind({"shift","cmd"}, "g", function()
  focusChrome()
  hs.alert.show("Chrome")
end)

-- 2) 精準切 tab
hs.hotkey.bind({"shift","cmd"}, "y", function()
  focusChromeOrTab("youtube.com")
end)

hs.hotkey.bind({"shift","cmd"}, "o", function()
  focusChromeOrTab("http://8.8.8.8") -- 你的 Outline URL
end)

hs.hotkey.bind({"shift","cmd"}, "j", function()
  focusChromeOrTab("jenkins") -- 建議改成你實際 Jenkins 網域更精準
  -- 例如：focusChromeOrTab("jenkins.yq-ops.top")
end)

hs.hotkey.bind({"shift","cmd"}, "d", function()
  focusChromeOrTab("ChatGPT") 
  -- 例如：focusChromeOrTab("chatgpt.com")
end)

hs.hotkey.bind({"shift","cmd"}, "a", function()
  focusChromeOrTab("sg.larksuite.com") 
  -- 例如：focusChromeOrTab("https://sg.larksuite.com/base/")
end)
-- template



-- Slack：開啟或切到前景
hs.hotkey.bind({"shift","cmd"}, "s", function()
  hs.application.launchOrFocus("Slack")
end)

-- Lark：開啟或切到前景
hs.hotkey.bind({"shift","cmd"}, "l", function()
  hs.application.launchOrFocus("LarkSuite")
end)

-- Telegram：開啟或切到前景
hs.hotkey.bind({"shift","cmd"}, "t", function()
  hs.application.launchOrFocus("Telegram")
end)

-- VS code：開啟或切到前景
hs.hotkey.bind({"shift","cmd"}, "e", function()
  hs.application.launchOrFocus("Visual Studio Code")
end)

-- Monitask：開啟或切到前景
hs.hotkey.bind({"shift","cmd"}, "m", function()
  hs.application.launchOrFocus("Monitask")
end)

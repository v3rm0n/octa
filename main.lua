--[[============================================================================
main.lua
============================================================================]]--

--[[--
Simplify importing audio tracks from Digitakt/Digitone or other 8 track machines.
--]]

---------------------------------------------------------------------------------------------------
-- Require files (app+libraries)
---------------------------------------------------------------------------------------------------

-- where to find the vLib/cLib classes (required)
_clibroot = 'source/cLib/classes/'
_vlibroot = 'source/vLib/classes/'

-- debug/trace filters can be configured here
-- (see cDebug for more details)
--_trace_filters = nil  -- no tracing
_trace_filters = {".*"} -- trace everything

require (_clibroot..'cLib')
require (_clibroot..'cDebug')

cLib.require (_vlibroot..'vLib')
cLib.require (_vlibroot..'vDialog')
cLib.require (_vlibroot..'vTable')
cLib.require (_vlibroot.."vFileBrowser")
cLib.require (_vlibroot.."vButton")

require ('source/Octa_UI')
require ('source/Octa_Prefs')

---------------------------------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------------------------------

-- this string is assigned as the dialog title
APP_DISPLAY_NAME = "Octa"

-- reference to the vDialog that contains the application UI
-- (you don't _have_ to use vDialog, but it's convenient as it
-- makes it easy to create a dialog that will display when the
-- Renoise is launched)
local vdialog

-- implementing preferences as a class only has benefits
-- (you can still use renoise.tool().preferences from anywhere...)
local prefs = Octa_Prefs()
renoise.tool().preferences = prefs

-- vLib requires a global reference to renoise.song(),
-- the variable is set when show() is called
rns = nil



---------------------------------------------------------------------------------------------------
-- Menu entries & MIDI/Key mappings
---------------------------------------------------------------------------------------------------

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:"..APP_DISPLAY_NAME.."...",
  invoke = function()
    show()
  end
}
renoise.tool():add_keybinding {
  name = "Global:"..APP_DISPLAY_NAME..":Show dialog...",
  invoke = function(repeated)
    if (not repeated) then
      show()
    end
  end
}

---------------------------------------------------------------------------------------------------
-- Show the application UI ---------------------------------------------------------------------------------------------------

function show()

  -- set global reference to the renoise song
  rns = renoise.song()

  -- create dialog if it doesn't exist
  if not vdialog then
    vdialog = Octa_UI{
      dialog_title = APP_DISPLAY_NAME,
      waiting_to_show_dialog = prefs.autostart.value,
    }
  end

  vdialog:show()

end

---------------------------------------------------------------------------------------------------
-- Notifications

renoise.tool().app_new_document_observable:add_notifier(function()
  if prefs.autostart.value then
    show()
  end

end)

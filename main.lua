--[[============================================================================
main.lua
============================================================================]]--

--[[--
Simplify importing audio tracks from Digitakt/Digitone or other 8 track machines.
--]]

--==============================================================================

--_trace_filters = nil
_trace_filters = {".*"}

_clibroot = "source/cLib/classes/"
_vlibroot = "source/vLib/classes/"

require (_clibroot.."cLib")
require (_clibroot.."cDebug")
require (_clibroot.."cString")
require (_clibroot.."cColor")
require (_clibroot.."cValue")

require (_vlibroot.."vLib")
require (_vlibroot.."helpers/vSelection")
require (_vlibroot.."parsers/vXML")
require (_vlibroot.."vArrowButton")
require (_vlibroot.."vButton")
require (_vlibroot.."vButtonStrip")
require (_vlibroot.."vDialog")
require (_vlibroot.."vEditField")
require (_vlibroot.."vTextField")
require (_vlibroot.."vSearchField")
require (_vlibroot.."vFileBrowser")
require (_vlibroot.."vGraph")
require (_vlibroot.."vLogView")
require (_vlibroot.."vPathSelector")
require (_vlibroot.."vPopup")
require (_vlibroot.."vTable")
require (_vlibroot.."vTabs")
require (_vlibroot.."vToggleButton")
require (_vlibroot.."vTree")

--------------------------------------------------------------------------------
-- variables etc.
--------------------------------------------------------------------------------


local vb = renoise.ViewBuilder()
local dialog,dialog_content

--------------------------------------------------------------------------------

local function start()
  TRACE("start()")

  if not dialog or not dialog.visible then
    if not dialog_content then
      dialog_content = build()
    end

    local function keyhandler(dialog, key)
      --print("key",rprint(key))
    end

    dialog = renoise.app():show_custom_dialog("Octa",
            dialog_content, keyhandler)

  else
    dialog:show()
  end

end

--------------------------------------------------------------------------------
-- build user interface
--------------------------------------------------------------------------------

function build()
  TRACE("build()")

  -- skeleton
  local content = vb:row{
    margin = 6,
    spacing = 4,
    vb:column{
      vb:row{
        spacing = 4,
        vb:column{
          style = "panel",
          vb:text{
            text = "Select widget",
            font = "bold",
          },
          vb:chooser{
            id = "control_chooser",
            notifier = function(idx)
              prefs.active_ctrl_idx.value = idx
            end
          },
        },
        vb:column{
          id = "basic_row",
        },
      },
      vb:column{
        vb:row{
          vb:space{
            width = 6,
          },
          vb:button{
            id = "ruler_width",
            color = {0x00,0xFF,0xFF},
            height = 6,
          },
        },
        vb:row{
          vb:button{
            id = "ruler_height",
            color = {0x00,0xFF,0xFF},
            width = 6,
          },
          vb:column{
            id = "controls_col",
            spacing = 6,
            -- controls goes here
          },
        },
      },
    },
    vb:column{
      id = "props_row",
      -- control properties
    }
  }
  return content

end

--------------------------------------------------------------------------------
-- menu entries
--------------------------------------------------------------------------------

renoise.tool():add_menu_entry{
  name = "Main Menu:Tools:Octa",
  invoke = start
}

--------------------------------------------------------------------------------
-- keybindings
--------------------------------------------------------------------------------

renoise.tool():add_keybinding{
  name = "Global:Tools:Octa",
  invoke = start
}

TRACE("Loaded")

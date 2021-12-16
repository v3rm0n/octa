--[[===============================================================================================
Octa_UI
===============================================================================================]]--

--[[
User interface for Octa. Extends the vDialog class, which provides
methods for launching the window automatically on startup
]]

--=================================================================================================

class 'Octa_UI'(vDialog)

---------------------------------------------------------------------------------------------------
-- Constructor method

function Octa_UI:__init(...)

    -- when extending a class, it's constructor needs to be called
    -- we also pass the arguments (...) along to the vDialog constructor
    vDialog.__init(self, ...)

    self.vb = renoise.ViewBuilder()

    self.selections = {}

    self:build()

end

---------------------------------------------------------------------------------------------------
-- Build the UI (executed once)

function Octa_UI:build()
    TRACE("Octa_UI:build()")

    local function get_selections()
        TRACE("get_selections")
        local selected = {}
        for name, checked in pairs(self.selections) do
            if checked then
                table.insert(selected, name)
            end
        end
        return selected
    end

    local function create_tracks()
        local selected_files = get_selections()
        local track_group = renoise.song():insert_group_at(1)
        track_group.name = "Octa"

        for i, name in ipairs(selected_files) do
            local track = renoise.song():insert_track_at(1)
            track.name = name
            renoise.song():add_track_to_group(1, i+1)
        end
    end

    local function create_instruments()
        local selected_files = get_selections()
        local instrument = renoise.song():insert_instrument_at(1)
        instrument.name = "Octa"
        local sample = instrument:insert_sample_at(1)
        sample.sample_buffer:load_from("/home/maidok/Digitakt/obdump_20211216-153706-00.wav")

    end

    local vb = self.vb
    local vb_content = vb:column {
        vb:row {
            id = "filebrowser",
            margin = 5,
        },
        vb:horizontal_aligner {
            mode = "right",
            vb:row {
                margin = 5,
                id = "controls",
            }
        }
    }

    TRACE("build_filebrowser()")

    local vbrowser

    vbrowser = vFileBrowser {
        vb = vb,
        id = "vFileBrowser",
        width = 340,
        height = 300,
        num_rows = 12,
        path = "/",
        file_ext = { '*.wav' },

        on_checked = function(_, item)
            TRACE("Octa_UI:item checked")
            self.selections[item.name] = item.checked
        end,

    }

    vb.views.filebrowser:add_child(vbrowser.view)

    vbrowser:refresh()

    TRACE("build_controls()")

    local controls

    controls = vButton {
        vb = vb,
        id = "loadButton",
        text = "Load",
        width = 100,
        released = function()
            TRACE("RELEASED")
            --create_tracks()
            create_instruments()
        end,
    }

    vb.views.controls:add_child(controls.view)

    self.vb_content = vb_content

end

---------------------------------------------------------------------------------------------------
-- methods required by vDialog
---------------------------------------------------------------------------------------------------
-- return the UI which was previously created with build()

function Octa_UI:create_dialog()
    TRACE("Octa_UI:create_dialog()")

    return self.vb:column {
        self.vb_content,
    }

end

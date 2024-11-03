if not settings then -- settings stage -- in this stage, settings is not defined
   -- add loaders-snap setting if not exist
   if not (data["string-setting"] and data["string-setting"]["loaders-snap"]) then
      data:extend {
         {
            name = "loaders-snap",
            order = "zz",
            setting_type = "startup",
            type = "string-setting",
            allow_blank = false,
            allowed_values = { "none" },
            default_value = "none",
         },
      }
   end

   -- add entry for loaders-snap
   -- add this in data-updates or data-final-fixes
   if data.raw["string-setting"] and data.raw["string-setting"]["loaders-snap"] then
      table.insert(data.raw["string-setting"]["loaders-snap"].allowed_values, "loaders-snap")
   end
   -- print(serpent.block(data))
elseif data then   -- data stage -- in this stage, data is defined
elseif script then -- control stage -- in this stage, script is defined
   if settings.startup["loaders-snap"].value == "loaders-snap" then
      -- enable loaders snapping logic from loaders-snap

      local Events = require("lib.Events")
      local Loader = require("lib.BeltLoader")
      local Belt = require("lib.Belt")
      local UBelt = require("lib.BeltUnder")
      local Splitter = require("lib.BeltSplitter")

      local function on_changed_entity(ev)
         -- get entity
         local entity = ev.created_entity or ev.entity or ev.destination
         local builder = ev.player_index and game.get_player(ev.player_index) or ev.robot or entity
         if Loader.valid(entity) then
            Loader.autoconnect(entity, builder, ev.created and "input" or nil, true)
         elseif Belt.valid(entity) then
            local entities = Belt.connectable(entity)
            for _, neighbor in ipairs(entities) do
               if Loader.valid(neighbor) then
                  Loader.autoconnect(neighbor, builder)
               end
            end
         elseif UBelt.valid(entity) then
            local neightbours = UBelt.connectable(entity)
            for _, neighbor in ipairs(neightbours) do
               if Loader.valid(neighbor) then
                  Loader.autoconnect(neighbor, builder)
               end
            end
         elseif Splitter.valid(entity) then
            local entities = Splitter.connectable(entity)
            for _, neighbor in ipairs(entities) do
               if Loader.valid(neighbor) then
                  Loader.autoconnect(neighbor, builder)
               end
            end
         end
      end

      local function on_created_entity(event)
         event.created = true
         on_changed_entity(event)
      end

      Events.register { name = "on_built_entity", handler = on_created_entity }
      Events.register { name = "on_robot_built_entity", handler = on_created_entity }
      Events.register { name = "script_raised_built", handler = on_created_entity }
      Events.register { name = "script_raised_revive", handler = on_created_entity }
      Events.register { name = "on_entity_cloned", handler = on_created_entity }
      Events.register { name = "on_player_rotated_entity", handler = on_changed_entity }
   end
end

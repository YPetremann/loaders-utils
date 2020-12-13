if not settings then -- settings stage -- in this stage, settings is not defined

   -- add loaders-work setting if not exist
   if not (data["string-setting"] and data["string-setting"]["loaders-work"]) then
      data:extend{
         {
            name = "loaders-work",
            order = "zz",
            setting_type = "runtime-global",
            type = "string-setting",
            allow_blank = false,
            allowed_values = {"none"},
            default_value = "none",
         },
      }
   end

   -- add entry for loaders-work
   local loaders_snap = data.raw["string-setting"]["loaders-work"]
   -- table.insert(loaders_snap.allowed_values, "loaders-work")
   loaders_snap.default_value = loaders_snap.allowed_values[2] or loaders_snap.allowed_values[1]

elseif data then -- data stage -- in this stage, data is defined
   -- not used
elseif script then -- control stage -- in this stage, script is defined

   -- enable loaders snapping logic for loaders-work
   if settings.global["loaders-work"].value == "loaders-work" then
      -- you can put here your own logic
      local Events = require("lib.Events")
   end
end

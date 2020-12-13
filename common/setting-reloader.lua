if not settings then -- settings stage -- in this stage, settings is not defined
elseif data then -- data stage -- in this stage, data is defined
elseif script then -- control stage -- in this stage, script is defined
   script.on_event(
      defines.events.on_runtime_mod_setting_changed, function(e)
         if game.mod_setting_prototypes[e.setting].mod == script.mod_name then
            game.reload_mods()
         end
      end
   )
end

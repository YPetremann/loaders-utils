local lib = {}
local loaders = { ["loader"] = true, ["loader-1x1"] = true }
function lib.valid(entity)
   return loaders[entity.type] or false
end

function lib.switch(loader)
   loader.loader_type = loader.loader_type == "input" and "output" or "input"
end

function lib.connectable(loader)
   local marks = {}
   local neighbours = {}
   for i = 1, 2 do
      for _, c in pairs(loader.belt_neighbours) do
         for _, e in ipairs(c) do
            if e.unit_number and not marks[e.unit_number] then
               marks[e.unit_number] = true
               table.insert(neighbours, e)
            end
         end
      end
      lib.switch(loader)
   end
   return neighbours
end

function lib.try_rotate(builder, loader, direction)
   if loader.loader_type == direction then
   elseif not loader.rotatable then
      if builder.is_player() then
         loader.rotate { by_player = builder }
      end
   elseif not (loader.force.name == "neutral" or loader.force == builder.force or loader.force.get_friend(builder.force)) then
      if builder.is_player() then
         loader.rotate { by_player = builder }
      end
   else
      loader.loader_type = direction
   end
end

function lib.autoconnect(loader, builder, default, manual)
   local input = 0
   local output = 0
   if manual then
      -- temporay set nearby loaders to input
      local sub_loaders = {}
      table.insert(sub_loaders, { dir = loader.loader_type, ent = loader })
      loader.loader_type = "output"
      local neighbours = lib.connectable(loader)
      for _, l in ipairs(neighbours) do
         if lib.valid(l) then
            table.insert(sub_loaders, { dir = l.loader_type, ent = l })
            l.loader_type = "input"
         end
      end

      -- check loaders reciprocity
      local facing = loader.belt_neighbours.outputs[1]
      if facing and lib.valid(facing) then
         loader.loader_type = "input"
         facing.loader_type = "output"
         if facing.belt_neighbours.outputs[1] == loader then
            input = 1
            output = 1
         else
            facing = nil
         end
      else
         facing = nil
      end

      -- restore loaders direction
      for _, l in ipairs(sub_loaders) do
         l.ent.loader_type = l.dir
      end
      if facing then
         local new_dir = (default or loader.loader_type) == "input" and "output" or "input"
         lib.try_rotate(builder, facing, new_dir)
      end
   end
   for i = 1, 2 do
      input = input + #loader.belt_neighbours.inputs
      output = output + #loader.belt_neighbours.outputs
      lib.switch(loader)
   end
   if input > 1 then
      input = 1
   end
   if output > 1 then
      output = 1
   end
   if input > output then
      lib.try_rotate(builder, loader, "input")
      -- game.print(game.tick.." "..input.." >> "..output.." : input >> "..loader.loader_type)
   elseif output > input then
      lib.try_rotate(builder, loader, "output")
      -- game.print(game.tick.." "..input.." >> "..output.." : output >> "..loader.loader_type)
   elseif default then
      lib.try_rotate(builder, loader, default)
      -- game.print(game.tick.." "..input.." >> "..output.." : default "..default.." >> "..loader.loader_type)
   else
      -- game.print(game.tick.." "..input.." >> "..output.." : keep >> "..loader.loader_type)
   end
end

return lib

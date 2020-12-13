local lib = {}

local belts = {["transport-belt"] = true}
function lib.valid(entity)
   return belts[entity.type] or false
end

function lib.rotate(belt)
   belt.direction = (belt.direction + 2) % 8
end

function lib.connectable(belt, default)
   local marks = {}
   local neighbours = {}
   for i = 1, 4 do
      for _, c in pairs(belt.belt_neighbours) do
         for _, e in ipairs(c) do
            if e.unit_number and not marks[e.unit_number] then
               marks[e.unit_number] = true
               table.insert(neighbours, e)
            end
         end
      end
      lib.rotate(belt)
   end
   return neighbours
end

return lib

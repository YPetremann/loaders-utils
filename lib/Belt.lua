local lib = {}

local belts = { ["transport-belt"] = true }
function lib.valid(entity)
   return belts[entity.type] or false
end

function lib.rotate(belt)
   belt.direction = (belt.direction + 4) % 16
end

function lib.connectable(belt, default)
   local marks = {}
   local neighbours = {}
   for i = 1, 4 do
      for _, groups in pairs(belt.belt_neighbours) do
         for _, neighbor in ipairs(groups) do
            if neighbor.unit_number and not marks[neighbor.unit_number] then
               marks[neighbor.unit_number] = true
               table.insert(neighbours, neighbor)
            end
         end
      end
      lib.rotate(belt)
   end
   return neighbours
end

return lib

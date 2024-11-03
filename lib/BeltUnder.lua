local lib = {}

local undergrounds = { ["underground-belt"] = true }
function lib.valid(entity)
   return undergrounds[entity.type] or false
end

function lib.rotate(ubelt)
   ubelt.direction = (ubelt.direction + 4) % 16
end

function lib.switch(ubelt)
   ubelt.rotate()
end

function lib.connectable(ubelt, default)
   local marks = {}
   local neighbours = {}
   local sibling = ubelt.neighbours
   for i = 1, 2 do
      for _, groups in pairs(ubelt.belt_neighbours) do
         for _, neighbor in ipairs(groups) do
            if neighbor.unit_number and not marks[neighbor.unit_number] then
               marks[neighbor.unit_number] = true
               table.insert(neighbours, neighbor)
            end
         end
      end
      if sibling then
         for _, groups in pairs(sibling.belt_neighbours) do
            for _, neighbour in ipairs(groups) do
               if neighbour.unit_number and not marks[neighbour.unit_number] then
                  marks[neighbour.unit_number] = true
                  table.insert(neighbours, neighbour)
               end
            end
         end
      end
      lib.switch(ubelt)
   end
   return neighbours
end

return lib

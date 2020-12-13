local lib = {}

local undergrounds = {["underground-belt"] = true}
function lib.valid(entity)
   return undergrounds[entity.type] or false
end

function lib.rotate(ubelt)
   ubelt.direction = (ubelt.direction + 2) % 8
end

function lib.switch(ubelt)
   ubelt.rotate()
end

function lib.connectable(ubelt, default)
   local marks = {}
   local neighbours = {}
   for i = 1, 2 do
      for _, c in pairs(ubelt.belt_neighbours) do
         for _, e in ipairs(c) do
            if e.unit_number and not marks[e.unit_number] then
               marks[e.unit_number] = true
               table.insert(neighbours, e)
            end
         end
      end
      lib.switch(ubelt)
   end
   return neighbours
end

return lib

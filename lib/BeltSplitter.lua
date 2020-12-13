local lib = {}

local splitter = {["splitter"] = true}
function lib.valid(entity)
   return splitter[entity.type] or false
end

function lib.rotate(splitter)
   splitter.direction = (splitter.direction + 2) % 8
end

function lib.switch(splitter)
   splitter.rotate()
end

function lib.connectable(splitter, default)
   local marks = {}
   local neighbours = {}
   for i = 1, 2 do
      for _, c in pairs(splitter.belt_neighbours) do
         for _, e in ipairs(c) do
            if e.unit_number and not marks[e.unit_number] then
               marks[e.unit_number] = true
               table.insert(neighbours, e)
            end
         end
      end
      lib.switch(splitter)
   end
   return neighbours
end

return lib

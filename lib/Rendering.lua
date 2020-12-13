local lib = {}
lib.styles = {
   line = {
      color = {r = 0, g = 0.5, b = 0.5, a = 0.5},
      width = 2,
      gap_length = 0.1,
      dash_length = 0.1,
      draw_on_ground = true,
      only_in_alt_mode = true,
   },
}
function lib.draw_line(p)
   local style = lib.styles[p.style] or p.style or lib.styles["line"]
   p.color = p.color or style.color or {}
   p.width = p.width or style.width or 1
   p.gap_length = p.gap_length or style.gap_length or 0 -- optional
   p.dash_length = p.dash_length or style.dash_length or 0 -- optional
   p.draw_on_ground = p.draw_on_ground or style.draw_on_ground or false -- optional
   p.only_in_alt_mode = p.only_in_alt_mode or style.only_in_alt_mode or false -- optional
   -- p.from
   -- p.from_offset --optional
   -- p.to
   -- p.to_offset --optional
   p.surface = p.surface or p.from.surface or p.to.surface
   -- p.time_to_live --optional
   -- p.forces --optional
   -- p.players --optional
   -- p.visible --optional
   return rendering.draw_line(p)
end

--- Create a text.
function lib.draw_text(p)
   local style = lib.styles[p.style] or p.style or lib.styles["line"]
   -- p.text
   -- p.target
   -- p.target_offset --optional
   p.surface = p.surface or p.target.surface -- optional
   p.color = p.color or style.color or {}
   p.scale = p.scale or style.scale or 32
   p.font = p.font or style.font or nil
   -- p.time_to_live --optional
   -- p.forces --optional
   -- p.players --optional
   -- p.visible --optional
   p.draw_on_ground = p.draw_on_ground or style.draw_on_ground or false -- optional
   p.orientation = p.orientation or style.orientation or 0
   p.alignment = p.alignment or style.alignment or "left"
   p.scale_with_zoom = p.scale_with_zoom or style.scale_with_zoom or false
   p.only_in_alt_mode = p.only_in_alt_mode or style.only_in_alt_mode or false -- optional
   return rendering.draw_text(p)
end
function lib.circle(p)
end
function lib.rect(p)
end
function lib.arc(p)
end
function lib.poly(p)
end
function lib.sprite(p)
end
function lib.light(p)
end
function lib.anim(p)
end
function lib.destroy(p)
end
function lib.clear(p)
end
return lib

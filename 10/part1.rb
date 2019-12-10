asteroids = Hash.new
y = 0
width = 0
until (line = gets.strip).empty?
  line.chars.each_with_index { |v, x| asteroids[[x, y]] = 0 if v == '#' }
  width = line.length
  y += 1
end
height = y

puts asteroids.to_s

asteroids.keys.each_with_index do |a, i|
  ax, ay = a
  asteroids.keys[(i+1)..-1].each_with_index do |b, j|
    bx, by = b

    dx, dy = bx - ax, by - ay
    m = if dx == 0 then 0.to_f else dy.to_f / dx.to_f end
    c = ay.to_f - m * ax.to_f
    blocked = false
    for x in if ax < bx then (ax+1)...bx else (ax-1).downto(bx) end
      y = m * x.to_f + c
      puts "#{i}: #{ax},#{ay} to #{j}: #{x},#{y}: #{if asteroids.has_key? [x,y] then 'blocked' else '' end}"
      next if y % 1 != 0
      y = y.to_i
      blocked = true if asteroids.has_key? [x, y]
    end
    unless blocked
      asteroids[a] += 1
      asteroids[b] += 1
    end
  end
end

puts asteroids.to_s

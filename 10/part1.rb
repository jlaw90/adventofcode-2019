asteroids = Hash.new
y = 0
width = 0
until (line = gets.strip).empty?
  line.chars.each_with_index { |v, x| asteroids[[x, y]] = 0 if v == '#' }
  width = line.length
  y += 1
end
height = y

asteroids.keys.each_with_index do |a, i|
  ax, ay = a
  asteroids.keys[(i+1)..-1].each_with_index do |b, j|
    bx, by = b

    dx, dy = bx - ax, by - ay
    m = if dx == 0 then 0.to_f else dy.to_f / dx.to_f end
    c = ay.to_f - m * ax.to_f
    sparse = dx < dy

    range = if sparse then if ay < by then (ay+1)...by else (ay-1).downto(by+1) end elsif ax < bx then (ax+1)...bx else (ax-1).downto(bx+1) end
    transform = lambda { |v| if sparse then [if m == 0 then ax else (v.to_f - c) / m end, v] else [v, m * v.to_f + c] end }

    if range.all? do |v|
        x, y = transform.call(v)
        possible = x % 1 == 0 && y % 1 == 0
        blocked = possible && asteroids.has_key?([x.to_i, y.to_i])
        !blocked
    end

      asteroids[a] += 1
      asteroids[b] += 1
    end
  end
end

winner = asteroids.keys[asteroids.values.each_with_index.max[1]]
puts "#{winner[0]},#{winner[1]}"

chars = 4
format = "%#{chars}.#{chars}s"
for y in 0...height
  for x in 0...width
    print(if asteroids[[x, y]]
            format % asteroids[[x, y]].to_s
          else
            format % '.'
          end)
  end
  puts
end

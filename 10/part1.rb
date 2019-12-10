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
  asteroids.keys[(i+1)..-1].each do |b|
    bx, by = b

    dx, dy = bx - ax, by - ay
    slope = if dx == 0 then dy / dx else 0 end
    b = ay-slope*ax

  end
end

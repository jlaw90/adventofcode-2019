asteroids = Hash.new
y = 0
name = 'a'

until (line = gets.strip).empty?
  line.chars.each_with_index do |v, x|
    if v == '#'
      asteroids[[x, y]] = {:name => name, :perception => []}
      name = name.next
    end
  end
  y += 1
end

asteroids.keys.each_with_index do |a, i|
  x1, y1 = a
  asteroids.keys[(i+1)..-1].each_with_index do |b, j|
    x2, y2 = b

    dx, dy = x2 - x1, y2 - y1
    angle = Math.atan2(dy, dx)
    distance = Math.sqrt(dx*dx + dy*dy)

    asteroids[a][:perception] << [asteroids[b][:name], angle, distance]
    asteroids[b][:perception] << [asteroids[a][:name], Math.atan2(y1 - y2, x1 - x2), distance]
  end
end

# Now we can filter by which asteroids we can see!
asteroids.each do |k, v|
  grouped = v[:perception].group_by{|v| v[1]}
  v[:visible] = grouped.length
end

winner = asteroids.values.each_with_index.max{|a, b| a[0][:visible] <=> b[0][:visible]}

puts asteroids.keys[winner[1]] * ','
puts winner[0]

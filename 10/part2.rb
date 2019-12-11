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

# We need to align the angle so 0 is pointing directly up, this will allow us to sort
correct_angle = lambda { |a| (360 + ((a + (Math::PI) / 2) * 180 / Math::PI)) % 360 }

asteroids.keys.each_with_index do |a, i|
  x1, y1 = a
  asteroids.keys[(i+1)..-1].each_with_index do |b, j|
    x2, y2 = b

    dx, dy = x2 - x1, y2 - y1
    angle = correct_angle.call(Math.atan2(dy, dx))
    distance = Math.sqrt(dx*dx + dy*dy)

    asteroids[a][:perception] << [b, angle, distance]
    asteroids[b][:perception] << [a, correct_angle.call(Math.atan2(y1 - y2, x1 - x2)), distance]
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


# Station co-ordinate is:
station_coords = asteroids.keys[winner[1]]

# Vaporise asteroids in order
order = asteroids[station_coords][:perception].sort{|a, b| a[2] <=> b[2]}.group_by{ |a| a[1] }.map{|k, v| v}.sort{|a, b| a[0][1] <=> b[0][1]}

i = 0
total = 0
vaporised = []
until order.empty?
  angle = order[i]
  total += 1
  asteroid = angle.shift
  order.delete_at(i) if angle.empty?
  i = i + 1 unless angle.empty?
  i %= order.length unless order.empty?
  vaporised << asteroid
end

puts "200th: #{vaporised[199][0] * ','} #{vaporised[199][0][0] * 100 + vaporised[199][0][1]}"

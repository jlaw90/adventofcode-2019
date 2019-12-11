require 'rmagick'

asteroids = Hash.new
y = 0
width = 0
name = 'a'
until (line = gets.strip).empty?
  line.chars.each_with_index do |v, x|
    if v == '#'
      asteroids[[x, y]] = {:name => name, :visible => [], :blocked => []}
      name = name.next
    end
  end
  width = line.length
  y += 1
end
height = y

chars = name.length + 1
format = "%#{chars}.#{chars}s"
for y in 0...height
  for x in 0...width
    print(if asteroids[[x, y]]
            format % asteroids[[x, y]][:name]
          else
            format % '.'
          end)
  end
  puts
end

asteroids.keys.each_with_index do |a, i|
  ax, ay = a
  asteroids.keys[(i+1)..-1].each_with_index do |b, j|
    bx, by = b

    dx, dy = bx - ax, by - ay
    m = if dx == 0 then Float::INFINITY else dy.to_f / dx.to_f end
    c = ay.to_f - m * ax.to_f
    iterate_y = dx < dy

    range = if iterate_y
              # we never draw upwards!
              ((ay+1)...by).map{|y| [if m == Float::INFINITY then ax else (y.to_f - c.to_f) / m end, y]}
            else
              (if ax < bx
                (ax + 1)...bx
              else
                (ax - 1).downto(bx + 1)
              end).map{|x| [x, m.to_f * x.to_f + c.to_f]}
            end

    blocked_by = nil
    if range.all? { |v|
        x, y = v
        possible = x % 1 == 0 && y % 1 == 0
        coords = [x.to_i, y.to_i]
        blocked = possible && asteroids.has_key?(coords)
        blocked_by = asteroids[coords][:name] if blocked
        puts "#{asteroids[a][:name]} to #{asteroids[b][:name]}: (#{x},#{y}): #{blocked_by}"
        !blocked
      }

      asteroids[a][:visible] << b
      asteroids[b][:visible] << a
    elsif !blocked_by.nil?
      asteroids[a][:blocked] << [b, blocked_by]
      asteroids[b][:blocked] << [a, blocked_by]
    end
  end
end

winner = asteroids.keys[asteroids.values.map{|v| v[:visible].length}.each_with_index.max[1]]
puts "#{asteroids[winner][:name]} can see #{asteroids[winner][:visible].length} from #{winner[0]},#{winner[1]}"



# canvas = Magick::ImageList.new
# canvas_size = 20
# canvas.new_image(width * canvas_size, height * canvas_size, Magick::SolidFill.new('black'))
#
#
# alter_point = lambda { |x, y| [x * canvas_size + (canvas_size/2), y * canvas_size + (canvas_size / 2)] }
#
# drawer = Magick::Draw.new
# asteroids.keys.each do |a|
#   x, y = alter_point.call(*a)
#
#   asteroids[a][:visible].each do |b|
#     drawer.stroke('yellow')
#     drawer.fill_opacity(0)
#     drawer.stroke_opacity(0.2)
#     drawer.stroke_width(1)
#
#     bx, by = alter_point.call(*b)
#     drawer.line(x, y, bx, by)
#   end
#
#   asteroids[a][:blocked].each do |b|
#     drawer.stroke('red')
#     drawer.fill_opacity(0)
#     drawer.stroke_opacity(0.2)
#     drawer.stroke_width(1)
#
#     bx, by = alter_point.call(*b[0])
#     drawer.line(x, y, bx, by)
#   end
#
#   drawer.fill_opacity(1)
#   drawer.fill(if a == winner then 'red' else 'white' end)
#   drawer.pointsize(10)
#
#
#   drawer.point(x, y)
# end
#
# # drawer.draw(canvas)
# # canvas.write('test.png')
#
# asteroids.keys.each do |coord|
#   a = asteroids[coord]
#   puts "#{a[:name]}: can  see #{a[:visible].map{|v|asteroids[v][:name]}.join(',')}"
#   puts "#{' ' * a[:name].length}  cant see #{a[:blocked].map{|v| "#{asteroids[v[0]][:name]} (#{v[1]})"}.join(',')}"
# end

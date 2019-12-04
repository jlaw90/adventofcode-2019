path1 = gets.strip.split ','
path2 = gets.strip.split ','

def points_for(path)
  x, y = 0, 0
  points = [[0, 0]]
  i = 1
  puts 'start 0, 0'
  path.each do |move|
    num = move[1..-1].to_i
    case move[0]
    when 'U'
      y -= num
    when 'D'
      y += num
    when 'R'
      x += num
    when 'L'
      x -= num
    end
    points[i] = [x, y]
    i += 1

    puts "#{move} #{x}, #{y}"
  end

  points
end

points1 = points_for(path1)
points2 = points_for(path2)

points1x = points1.map { |p| p[0] }
points2x = points2.map { |p| p[0] }
points1y = points1.map { |p| p[1] }
points2y = points2.map { |p| p[1] }

$xmin = [points1x.min, points2x.min].min
$xmax = [points1x.max, points2x.max].max
$ymin = [points1y.min, points2y.min].min
$ymax = [points1y.max, points2y.max].max

$width = $xmax - $xmin
$height = $ymax - $ymin

$grid = Array.new($width * $height)

def draw(points)
  startx = -$xmin
  starty = -$ymin

  lp = [startx, starty]
  points.each do |n|
    puts "#{lp[0]},#{lp[1]} to #{n[0]},#{n[1]}"
    if lp[0] == n[0]
      x = lp[0]
      (lp[1]..n[1]).each do |y|
        $grid[y * $width + x] = '|'
      end
    else
      y = lp[1]
      (lp[0]..n[0]).each do |x|
        $grid[y * $width + x] = '-'
      end
    end
    lp = n
  end
end

draw(points1.map { |a| [a[0] - $xmin, a[1] - $ymin] })
# draw(points2.map{|a| [a[0] - xmin, a[1] - ymin]})


# Print the grid
puts "#{$width} x #{$height}"
i = 0
(0...$height).each do |y|
  line = ''
  (0...$width).each do |x|
    line += case $grid[i]
            when '|' then
              '|'
            when '-' then
              '-'
            else
              '.'
            end
    i += 1
  end
  puts line
end

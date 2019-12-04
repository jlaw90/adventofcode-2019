path1 = gets.strip.split ','
path2 = gets.strip.split ','

def points_for(path)
  x, y = 0, 0
  grid = Hash.new
  steps = 0
  hit = lambda do |x,y|
    grid[[x,y]] ||= steps if x != 0 and y != 0
    steps += 1
  end

  def iterate_between(a, b, &blk)
    if a >= b
      a.downto(b, &blk)
    else
      (a..b).each(&blk)
    end

    b
  end

  path.each do |move|
    num = move[1..-1].to_i
    case move[0]
    when 'U'
      y = iterate_between(y-1, y - num) {|y| hit.call(x, y)}
    when 'D'
      y = iterate_between(y+1, y + num) {|y| hit.call(x, y)}
    when 'R'
      x = iterate_between(x+1, x + num) {|x| hit.call(x, y)}
    when 'L'
      x = iterate_between(x-1, x - num) {|x| hit.call(x, y)}
    end
  end

  grid
end

points1 = points_for(path1)
points2 = points_for(path2)
intersect = points1.keys & points2.keys

steps = intersect.map{|p| points1[p] + points2[p]}.min
puts steps + 2

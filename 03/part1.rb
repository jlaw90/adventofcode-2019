path1 = gets.strip.split ','
path2 = gets.strip.split ','

def points_for(path)
  x, y = 0, 0
  grid = Hash.new
  hit = lambda {|x,y| grid[[x,y]] = 1}

  path.each do |move|
    num = move[1..-1].to_i
    case move[0]
    when 'U'
      ((y-num)..y).each {|y| hit.call(x, y)}
      y -= num
    when 'D'
      (y..(y+num)).each {|y| hit.call(x, y)}
      y += num
    when 'R'
      (x..(x+num)).each {|x| hit.call(x, y)}
      x += num
    when 'L'
      ((x-num)..x).each {|x| hit.call(x, y)}
      x -= num
    end
  end

  # Remove 0, 0
  grid.keys - [[0,0]]
end

puts (points_for(path1) & points_for(path2)).map{|p| p[0].abs + p[1].abs}.min

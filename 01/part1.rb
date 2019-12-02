total = 0
until (line = gets.strip).empty? do
  mass = line.to_i
  total += (mass / 3).floor - 2
end

puts total

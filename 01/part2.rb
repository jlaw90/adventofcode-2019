total = 0

def fuel_for(mass)
  [(mass / 3).floor - 2, 0].max
end

until (line = gets.strip).empty? do
  mass = line.to_i
  fuel = fuel_for(mass)
  total += fuel

  while (fuel = fuel_for(fuel)) != 0 do
    total += fuel
  end
end

puts total

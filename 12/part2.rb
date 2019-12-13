moons = []

regexp = /^<x=(-?\d+),\s*y=(-?\d+),\s*z=(-?\d+)>$/
until (line = gets.strip).empty?
  moons << { :position => regexp.match(line).captures.map(&:to_i), :velocity => [0,0,0] }
end

1000.times do |v|
  # Apply gravity
  moons.each_with_index do |a, i|
    ap, av = a[:position], a[:velocity]
    moons[(i+1)..-1].each do |b|
      bp, bv = b[:position], b[:velocity]
      3.times do |j|
        d = ap[j] <=> bp[j]
        av[j] -= d
        bv[j] += d
      end
    end
  end

  # Update positions
  moons.each do |a|
    ap, av = a[:position], a[:velocity]
    3.times {|i| ap[i] += av[i]}
  end
end

# Calculate energy
potential_energy = moons.map{|m| m[:position].map(&:abs).sum}
kinetic_energy = moons.map{|m| m[:velocity].map(&:abs).sum}
total_energy = moons.length.times.map {|i| potential_energy[i] * kinetic_energy[i]}
puts total_energy.sum

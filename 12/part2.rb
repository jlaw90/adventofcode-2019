moons = []

regexp = /^<x=(-?\d+),\s*y=(-?\d+),\s*z=(-?\d+)>$/
until (line = gets.strip).empty?
  moons << { :position => regexp.match(line).captures.map(&:to_i), :velocity => [0,0,0] }
end

initial_positions = moons.map{ |m| m[:position].dup }

solve_time = []
3.times do |axis|
  iterations = 0
  until iterations > 0 && moons.each_with_index.all?{ |m, i| m[:position] == initial_positions[i] && m[:velocity][axis] == 0 } do
    # Apply gravity
    moons.each_with_index do |a, i|
      ap, av = a[:position][axis], a[:velocity]
      moons[(i+1)..-1].each do |b|
        bv = b[:velocity]
        d = ap <=> b[:position][axis]
        av[axis] -= d
        bv[axis] += d
      end
    end

    # Update positions
    moons.each do |a|
      a[:position][axis] += a[:velocity][axis]
    end

    iterations += 1
  end

  solve_time << iterations
end

# Print solve time
puts "Orbital repetition time: #{solve_time.reduce(:lcm)}"

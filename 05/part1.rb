$memory = (gets.strip.split ',').map(&:to_i)
$pc = 0

ops = {}

ops[1] = lambda { |a, b, dest| $memory[dest] = a + b }
ops[2] = lambda { |a, b, dest| $memory[dest] = a * b }
ops[3] = lambda { |dest| $memory[dest] = gets.strip.to_i }
ops[4] = lambda { |src| puts src }

while $pc < $memory.length do
  instruction = $memory[$pc]

  break if instruction == 99

  $pc += 1

  op = instruction % 100
  f = ops[op]
  parameters = f.parameters
  mode = (instruction / 100).floor
  args = (0...f.arity).map do |i|
    amode = (mode / (10 ** i)) % 10
    value = $memory[$pc + i]
    value = $memory[value] if amode == 0 and parameters[i][1] != :dest
    value
  end

  f.(*args)
  $pc += f.arity
end

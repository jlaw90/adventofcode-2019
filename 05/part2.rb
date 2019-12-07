$memory = (gets.strip.split ',').map(&:to_i)
$pc = 0

ops = {}

ops[1] = ['add', lambda { |a, b, dest| $memory[dest] = a + b }]
ops[2] = ['mlt', lambda { |a, b, dest| $memory[dest] = a * b }]
ops[3] = ['get', lambda { |dest| $memory[dest] = gets.strip.to_i }]
ops[4] = ['put', lambda { |src| puts src }]
ops[5] = ['jit', lambda { |test, target| $pc = target if test != 0 }]
ops[6] = ['jif', lambda { |test, target| $pc = target if test == 0 }]
ops[7] = ['clt', lambda { |a, b, dest| $memory[dest] = if a < b then 1 else 0 end }]
ops[8] = ['ceq', lambda { |a, b, dest| $memory[dest] = if a == b then 1 else 0 end }]

while $pc < $memory.length do
  instruction = $memory[$pc]

  break if instruction == 99

  $pc += 1

  op = instruction % 100
  name, f = ops[op]
  parameters = f.parameters
  mode = (instruction / 100).floor
  args = (0...f.arity).map do |i|
    amode = (mode / (10 ** i)) % 10
    value = $memory[$pc + i]
    value = $memory[value] if amode == 0 and parameters[i][1] != :dest
    value
  end

  $pc += f.arity
  f.(*args)
end

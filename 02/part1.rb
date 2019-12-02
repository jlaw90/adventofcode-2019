$memory = (gets.strip.split ',').map(&:to_i)
$pc = 0

$memory[1] = 12
$memory[2] = 2

ops = {}

ops[1] = lambda do
  a, b, dest = $memory[$pc..($pc+2)]
  $pc += 3
  $memory[dest] = $memory[a] + $memory[b]
end

ops[2] = lambda do
  a, b, dest = $memory[$pc..($pc+2)]
  $pc += 3
  $memory[dest] = $memory[a] * $memory[b]
end

while $pc < $memory.length do
  op = $memory[$pc]
  $pc += 1
  f = ops[op]
  if f.nil?
    break
  end
  f.()
end

puts $memory.join ','

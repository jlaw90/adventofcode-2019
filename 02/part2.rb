$input = (gets.strip.split ',').map(&:to_i)
$memory = $input.clone
$pc = 0

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

a = -1
b = 0
until $memory[0] == 19690720 or b > 99 do
  a = a + 1
  if a == 100
    a = 0
    b = b + 1
  end
  $memory = $input.clone
  $pc = 0
  $memory[1] = a
  $memory[2] = b
  puts $memory.join ','

  while $pc < $memory.length do
    op = $memory[$pc]
    $pc += 1
    f = ops[op]
    if f.nil?
      break
    end
    f.()
  end

  puts "#{100 * a + b}"
end

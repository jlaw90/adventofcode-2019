$instructions = (gets.strip.split ',').map(&:to_i)
$memory = []
$pc = 0

$input = lambda { gets.strip.to_i }
$output = lambda { |v| puts v }

$ops = {}
$ops[1] = ['add', lambda { |a, b, dest| $memory[dest] = a + b }]
$ops[2] = ['mlt', lambda { |a, b, dest| $memory[dest] = a * b }]
$ops[3] = ['get', lambda { |dest| $memory[dest] = $input.call }]
$ops[4] = ['put', lambda { |src| $output.call src }]
$ops[5] = ['jit', lambda { |test, target| $pc = target if test != 0 }]
$ops[6] = ['jif', lambda { |test, target| $pc = target if test == 0 }]
$ops[7] = ['clt', lambda { |a, b, dest| $memory[dest] = if a < b then 1 else 0 end }]
$ops[8] = ['ceq', lambda { |a, b, dest| $memory[dest] = if a == b then 1 else 0 end }]

def evaluate(instructions, stdin = $input, stdout = $output)
  $pc = 0
  $memory = instructions.dup

  $input, $output = stdin, stdout

  while $pc < $memory.length do
    instruction = $memory[$pc]

    break if instruction == 99

    $pc += 1

    op = instruction % 100
    name, f = $ops[op]
    parameters = f.parameters
    mode = (instruction / 100).floor
    args = (0...f.arity).map do |i|
      amode = (mode / (10 ** i)) % 10
      value = $memory[$pc + i]
      value = $memory[value] if amode == 0 and parameters[i][1] != :dest
      value
    end

    puts "#{$pc-1}: #{name} #{args.each_with_index.map{|a, i| "#{parameters[i][1].to_s}=#{a}"}.join ', '}"

    $pc += f.arity
    f.(*args)
  end
end

eval_step = lambda do |input, phase|
  ridx, result = 0, -1
  stdin = lambda { ridx += 1; if ridx == 1 then phase else input end }
  stdout = lambda {|i| result = i}
  evaluate($instructions, stdin, stdout)
  result
end

phases = [4, 3, 2, 1, 0]
max_value = 0
max = [0,0,0,0]

looping = true
while looping
  previous = 0
  phases.each_with_index {|p| previous = eval_step.call(previous, p)}
  if previous > max_value
    max_value = previous
    max = phases.dup
  end

  increment = true
  while increment
    i = 0
    loop do
      phases[i] += 1
      break if phases[i] <= 4
      phases[i] = 0
      i += 1
      if i >= 5
        looping = false
        break
      end
    end
    increment = phases.uniq.length != phases.length
  end
end

puts "#{max_value} from phases: #{max.join}"

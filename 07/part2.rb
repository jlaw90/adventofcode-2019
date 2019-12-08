class IntCodeVM
  OPERATIONS = [nil, :add, :multiply, :read, :write, :jump_if_true, :jump_if_false, :less_than, :equal]

  attr_accessor :name, :stdin, :stdout, :debug
  attr_reader :pc, :memory, :halted

  @stdin = lambda { gets.strip.to_i }
  @stdout = lambda { |v| puts v }
  @debug = false

  def initialize(instructions, name = 'VM')
    @instructions = instructions.dup
    @name = name
  end

  def step
    if @halted
      puts "#{vm.name} attempted to step while halted"  if @debug
      return false
    end
    # fetch and decode
    insn = @memory[@pc]
    @pc += 1
    if insn == 99
      @halted = true
      puts "#{@name}[#{@pc-1}]: HALT" if @debug
      return false
    end

    op = OPERATIONS[insn % 100]
    method = IntCodeVM.instance_method(op)
    parameters = method.parameters
    name = method.name
    mode = (insn / 100).floor
    args = (0...parameters.length).map do |i|
      amode = (mode / (10 ** i)) % 10
      value = @memory[@pc + i]
      value = @memory[value] if amode == 0 and parameters[i][1] != :dest
      value
    end

    if @debug
      puts "#{@name}[#{@pc-1}]: #{name} #{args.each_with_index.map{|a, i| "#{parameters[i][1].to_s}=#{a}"}.join ', '}"
    end

    @pc += args.length
    self.send(op, *args)
    true
  end

  def execute
    reset
    loop do
      break unless step
    end
  end

  def reset
    @memory = @instructions.dup
    @halted = false
    @pc = 0
    true
  end

  def add(a, b, dest)
    @memory[dest] = a + b
  end

  def multiply(a, b, dest)
    @memory[dest] = a * b
  end

  def read(dest)
    @memory[dest] = @stdin.call
  end

  def write(src)
    @stdout.call(src)
  end

  def jump_if_true(test, target)
    @pc = target if test != 0
  end

  def jump_if_false(test, target)
    @pc = target if test == 0
  end

  def less_than(a, b, dest)
    @memory[dest] = if a < b then 1 else 0 end
  end

  def equal(a, b, dest)
    @memory[dest] = if a == b then 1 else 0 end
  end

  def dup
    IntCodeVM.new(@instructions)
  end
end

input = ''
input += gets.strip until input.length > 0 and input[-1] != ','
instructions = input.split(',').map(&:to_i)
vms = [
    IntCodeVM.new(instructions, 'A'),
    IntCodeVM.new(instructions, 'B'),
    IntCodeVM.new(instructions, 'C'),
    IntCodeVM.new(instructions, 'D'),
    IntCodeVM.new(instructions, 'E'),
]
max_value = 0
max = [0,0,0,0]

[5, 6, 7, 8, 9].permutation do |phases|
  current_vm = 0
  previous = 0

  vms.each_with_index do |vm, i|
    vm.debug = true
    vm.reset
    vm.stdout = lambda do |v|
      previous = v
      puts "#{vm.name}: #{v}" if vm.debug
      # When one VM writes, now execute the next VM in sequence
      current_vm = (current_vm + 1) % vms.length
    end
    vm.stdin = lambda do
      puts "#{vm.name} read" if vm.debug
      puts "#{vm.name} tried to read when there is no output" unless previous != nil
      v = previous
      previous = nil
      return v
    end

    # Preload each VM with it's phase input
    previous = phases[i]
    vm.step
  end

  # Input 0 for VM 0
  previous = 0

  loop do
    vm = vms[current_vm]
    unless vm.step
      puts "HALT ON #{vm.name} (#{current_vm})" if vm.debug
      break if vms.all?{|v| v.halted}
      current_vm = (current_vm + 1) % vms.length
    end
  end

  puts "#{phases.join}: #{previous}"

  if previous > max_value
    max_value = previous
    max = phases.dup
  end
end

puts "#{max_value} from phases: #{max.join}"

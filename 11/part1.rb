class IntCodeVM
  OPERATIONS = [nil, :add, :multiply, :read, :write, :jump_if_true, :jump_if_false, :less_than, :equal, :adjust_relative_base]

  attr_accessor :name, :stdin, :stdout, :debug
  attr_reader :pc, :memory, :halted, :relative_base

  def initialize(instructions, name = 'VM')
    @instructions = instructions.dup
    @name = name
    @stdin = lambda { gets.strip.to_i }
    @stdout = lambda { |v| puts v }
    @debug = false
    self.reset
  end

  def memfetch(address)
    @memory[address] || 0
  end

  def memset(address, value)
    @memory[address] = value
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
      value = memfetch(@pc + i)
      if amode != 1
        is_dest = parameters[i][1] == :dest
        value = memfetch(value) if amode == 0 and !is_dest
        value = @relative_base + value if amode == 2
        value = memfetch(value) if amode == 2 and !is_dest

      end
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
    @relative_base = 0
    true
  end

  def add(a, b, dest)
    memset(dest, a + b)
  end

  def multiply(a, b, dest)
    memset(dest, a * b)
  end

  def read(dest)
    memset(dest, @stdin.call)
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
    memset(dest, if a < b then 1 else 0 end)
  end

  def equal(a, b, dest)
    memset(dest, if a == b then 1 else 0 end)
  end

  def adjust_relative_base(input)
    @relative_base += input
  end

  def dup
    IntCodeVM.new(@instructions)
  end
end

puts 'before read'
puts gets

input = gets.strip

puts 'lol'

instructions = input.split(',').map(&:to_i)

puts 'yay'

vm = IntCodeVM.new(instructions)
panels = Hash.new
location = [0,0]
panels[location] = 0 # All panels are initially black
directions = %w(up right down left)
direction = 0
paint = -1
turn = -1


vm.stdin = lambda { panels[location] }
vm.stdout = lambda do |v|
  turn = v if paint != -1
  paint = v if paint == -1
end

vm.debug = true

while vm.step do
  if paint != -1 and turn != -1
    puts "Paint #{location * ','} #{paint}"
    panels[location] = paint
    direction += if turn == 0 then -1 else 1 end
    direction %= directions.length
    direction = 3 if direction < 0
    location[0] += case direction when :left then -1 when :right then 1 else 0 end
    location[1] += case direction when :up then -1 when :down then 1 else 0 end
    puts "Move #{direction} to #{location * ','}"
    paint, turn = -1, -1
  end
end

puts panels

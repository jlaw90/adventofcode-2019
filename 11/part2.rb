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

input = '3,8,1005,8,291,1106,0,11,0,0,0,104,1,104,0,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,1002,8,1,28,1,1003,20,10,2,1103,19,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,1001,8,0,59,1,1004,3,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1001,8,0,84,1006,0,3,1,1102,12,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,114,3,8,1002,8,-1,10,101,1,10,10,4,10,108,1,8,10,4,10,101,0,8,135,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,102,1,8,158,2,9,9,10,2,2,10,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,1,10,4,10,101,0,8,188,1006,0,56,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,212,1006,0,76,2,1005,8,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,241,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,0,10,4,10,1002,8,1,264,1006,0,95,1,1001,12,10,101,1,9,9,1007,9,933,10,1005,10,15,99,109,613,104,0,104,1,21102,838484206484,1,1,21102,1,308,0,1106,0,412,21102,1,937267929116,1,21101,0,319,0,1105,1,412,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,206312598619,1,1,21102,366,1,0,1105,1,412,21101,179410332867,0,1,21102,377,1,0,1105,1,412,3,10,104,0,104,0,3,10,104,0,104,0,21101,0,709580595968,1,21102,1,400,0,1106,0,412,21102,868389384552,1,1,21101,411,0,0,1106,0,412,99,109,2,21202,-1,1,1,21102,1,40,2,21102,1,443,3,21101,0,433,0,1106,0,476,109,-2,2105,1,0,0,1,0,0,1,109,2,3,10,204,-1,1001,438,439,454,4,0,1001,438,1,438,108,4,438,10,1006,10,470,1102,0,1,438,109,-2,2106,0,0,0,109,4,1202,-1,1,475,1207,-3,0,10,1006,10,493,21102,0,1,-3,21202,-3,1,1,21201,-2,0,2,21101,0,1,3,21102,1,512,0,1106,0,517,109,-4,2105,1,0,109,5,1207,-3,1,10,1006,10,540,2207,-4,-2,10,1006,10,540,22101,0,-4,-4,1106,0,608,21201,-4,0,1,21201,-3,-1,2,21202,-2,2,3,21101,0,559,0,1106,0,517,21201,1,0,-4,21102,1,1,-1,2207,-4,-2,10,1006,10,578,21101,0,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,600,21201,-1,0,1,21102,600,1,0,106,0,475,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2106,0,0'

instructions = input.strip.split(',').map(&:to_i)

vm = IntCodeVM.new(instructions)
panels = Hash.new
location = [0,0]
panels[location] = 1 # All panels are initially black, except the first panel!
directions = %i(up right down left)
direction = 0
paint = -1
turn = -1


vm.stdin = lambda { panels[location] }
vm.stdout = lambda do |v|
  turn = v if paint != -1
  paint = v if paint == -1
end

minx, miny, maxx, maxy = 0,0,0,0

while vm.step do
  if paint != -1 and turn != -1
    panels[location] = paint
    direction += if turn == 0 then -1 else 1 end
    direction %= directions.length
    direction = 3 if direction < 0
    location[0] += case directions[direction] when :left then -1 when :right then 1 else 0 end
    location[1] += case directions[direction] when :up then -1 when :down then 1 else 0 end
    minx = [minx, location[0]].min
    miny = [miny, location[1]].min
    maxx = [maxx, location[0]].max
    maxy = [maxy, location[1]].max
    paint, turn = -1, -1
  end
end

for y in miny..maxy
  for x in minx..maxx
    print(if panels[[x,y]] === 1 then ' ' else '#' end)
  end
  puts
end

puts panels.length

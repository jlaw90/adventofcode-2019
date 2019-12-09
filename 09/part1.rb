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

input = ''
input += gets.strip until input.length > 0 and input[-1] != ','
instructions = input.split(',').map(&:to_i)

IntCodeVM.new(instructions).execute


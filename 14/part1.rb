recipes = {}
dependencies = {}

lines = '10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL'.split "\n"

# until (line = gets.strip).empty?
lines.each do |line|
  captures = /^((?:\d+ \w+(?:, )?)+) => (\d+) (\w+)$/.match(line).captures
  inputs = captures[0].split(/,\s*/).map do |inp|
    count, element = /^(\d+) (\w+)$/.match(inp).captures
    { :element => element, :count => count.to_i }
  end
  output = {
      :element => captures[-1],
      :count => captures[-2].to_i,
      :inputs => inputs
  }
  output[:ore_cost] = inputs[0][:count] if inputs.length == 1 and inputs[0][:element] == 'ORE'

  arr = recipes[output[:element]]
  arr = recipes[output[:element]] = [] if arr.nil?

  # Track dependencies
  inputs.each do |input|
    deps = dependencies[input[:element]]
    deps = dependencies[input[:element]] = [] if deps.nil?
    deps << output[:element]
    deps.uniq!
  end
  arr << output
end

until recipes.values.all?{|r| r.all?{|o| !o[:ore_cost].nil? && !o[:inputs].any?{|i| i[:ore_cost].nil?}}}
  # We want to calculate the minimum amount of ore it will cost to make something!
  recipes.values.each do |recipe|
    recipe.each do |r|
      next if r

    end
  end
  break

end

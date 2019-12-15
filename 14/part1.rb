recipes = {}

until (line = gets.strip).empty?
  captures = /^((?:\d+ \w+(?:, )?)+) => (\d+) (\w+)$/.match(line).captures
  inputs = captures[0].split(/,\s*/).map do |inp|
    count, element = /^(\d+) (\w+)$/.match(inp).captures
    {:element => element, :count => count.to_i}
  end
  output = {
      :element => captures[-1],
      :count => captures[-2].to_i,
      :inputs => inputs
  }
  output[:ore_cost] = inputs[0][:count] if inputs.length == 1 and inputs[0][:element] == 'ORE'

  arr = recipes[output[:element]]
  arr = recipes[output[:element]] = [] if arr.nil?
  arr << output
end

until recipes.values.all?{|r| r.all?{|o| !o[:ore_cost].nil? && !o[:inputs].any?{|i| i[:ore_cost].nil?}}}

end

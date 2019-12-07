map = {}

until (line=gets.strip).empty?
  a, b = line.split ')'
  map[b] = a
end

def walk(map, node)
  parent = map[node]
  if parent == "COM"
    return *["COM"]
  end

  return *[*walk(map, parent), parent]
end

# Need to find the shortest path
a = walk(map, 'SAN')
b = walk(map, 'YOU')

backtrack = (b - a).reverse
totarget = (a - b)
transfer = backtrack + [a[-totarget.length-1]] + totarget

puts "#{transfer.length - 1} transfers: #{transfer.join ' -> '}"

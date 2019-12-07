map = {}

until (line=gets.strip).empty?
  a, b = line.split ')'
  map[b] = a
end

def walk(map, cache, node)
  unless cache[node]
    parent = map[node]

    cache[node] = if parent == "COM"
      1
    else
      walk(map, cache, parent) + 1
    end
  end
  cache[node]
end

cache = {}
map.keys.each{|p| walk(map, cache, p)}
puts cache.values.sum

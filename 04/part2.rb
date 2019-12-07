start = 356261
finish = 846303

def count(start, finish, single_increment=false)
  zeroes = Math.log10(start)

  passwords = []
  while start <= finish
    increment = 1
    current_repeat = [-1, 0]
    repeats = []
    in_order = true
    ld = 9

    (0..zeroes).each do |i|
      mult = 10 ** i
      sd = (start / mult) % 10
      # Each number must be <= than the previous number
      if sd > ld
        increment = (mult / 10) * (sd - ld) unless single_increment
        in_order = false
      end
      if sd == current_repeat[0]
        current_repeat[1] += 1
      else
        repeats.pop if current_repeat[1] == 1
        current_repeat = [sd, 1]
        repeats << current_repeat
      end
      ld = sd
    end

    has_repeat = repeats.any?{|c| c[1] == 2}

    puts "#{start}, #{has_repeat}"

    if in_order and has_repeat
      passwords << start
    end

    start += increment
  end

  passwords
end


puts "#{count(start, finish).length} valid passwords"

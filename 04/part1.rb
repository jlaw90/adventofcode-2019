start = 356261
finish = 846303

def count(start, finish, single_increment=false)
  zeroes = Math.log10(start)

  passwords = []
  while start <= finish
    increment = 1
    has_repeat = false
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
      has_repeat ||= (i != 0 and sd == ld)
      # puts "#{start}, #{in_order}, #{has_repeat}, #{increment}"
      ld = sd
    end

    if in_order and has_repeat
      passwords << start
    end

    start += increment
  end

  passwords
end


puts "#{count(start, finish).length} valid passwords"


class Fraccion
    attr_accessor :num, :den
    
    def euclid(x,y)
        if y==0
            return x
        end
        return euclid(y,x%y)
    end

    def simplificar()
        f = Fraccion.new
        tmp = euclid(@num,@den)
        f.num = @num/tmp
        f.den = @den/tmp
        return f
    end

    def +(f2)
        ans = Fraccion.new
        ans.num = @num*f2.den + @den*f2.num
        ans.den = @den * f2.den
        return ans.simplificar
    end

    def -(f2)
        ans = Fraccion.new
        ans.num = @num*f2.den - @den*f2.num
        ans.den = @den * f2.den
        return ans.simplificar
    end

    def <=>(f2)
        return @num*f2.den <=> @den*f2.num
    end

    def to_s()
        return @num.to_s<<"/"<<@den.to_s
    end

end

x = Fraccion.new
x.den=4
x.num=6
puts x.num,x.den
y = Fraccion.new
y.num=2
y.den=3

z = x-y
a = [x,y,z]
puts z.num,z.den
puts a
puts a.sort

class String

  def palindrome?
    return self.reverse == self
  end
end

puts "hola".palindrome?
puts "dabalearrozalazorraelabad".palindrome?
puts "anitalavalatina".palindrome?

class Integer

  def each_prime_factor
    i = self
    p=2
    while p*p<i
      if i%p == 0
        yield p
        while (i%p == 0)
          i = i / p
        end
      end
      p += 1
    end
    if (i!=1)
      yield i
    end
  end
end

30.each_prime_factor do |x|
  puts x
end


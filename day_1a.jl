function fuel(m)
    needed = floor(m/3.0) - 2

    if needed <= 0
        return 0
    end

    if needed > 0
        needed += fuel(needed)
    end
end

println(fuel(14) == 2)
println(fuel(1969) == 966)
println(fuel(100756) == 50346)

data  = read("input_d1.txt", String)
total = sum(map(fuel ∘ (s -> parse(Int, s)), split(data)))
println(total)

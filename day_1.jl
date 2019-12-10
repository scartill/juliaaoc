function fuel(m)
    needed = floor(m/3.0) - 2
    return needed
end

println(fuel(12) == 2)
println(fuel(14) == 2)
println(fuel(1969) == 654)
println(fuel(100756) == 33583)

data  = read("input_d1.txt", String)
total = sum(map(fuel ∘ (s -> parse(Int, s)), split(data)))
println(total)

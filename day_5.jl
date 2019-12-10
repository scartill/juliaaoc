include("intcode.jl")

code = read("input_d5.txt", String)

output = []
run(code, input=[1], output=output)
println(output[end])
run(code, input=[5], output=output)
println(output[end])
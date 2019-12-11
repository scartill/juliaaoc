include("intcode.jl")

input = [1]
output = []
run(loadcode("input_d9.txt"), input=input, output=output)
println(output)

input = [2]
output = []
run(loadcode("input_d9.txt"), input=input, output=output)
println(output)
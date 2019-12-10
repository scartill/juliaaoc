include("intcode.jl")

function iterate(code, phases)
    output = []    
    insignal = 0
    nextphase = function(phase)
        ampcode = copy(code)
        run(ampcode, input=[insignal,phase], output=output)
        insignal = output[end]
    end
    map(nextphase, phases)
    return output[end]
end

test_a = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"
test_b = """3,23,3,24,1002,24,10,24,1002,23,-1,23,
            101,5,23,23,1,24,23,23,4,23,99,0,0"""
test_c = """3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
            1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"""

println(iterate(parsecode(test_a), [4,3,2,1,0]) == 43210)
println(iterate(parsecode(test_b), [0,1,2,3,4]) == 54321)
println(iterate(parsecode(test_c), [1,0,4,3,2]) == 65210)

code = loadcode("input_d7.txt")

th = []
range = 0:4
for a in range
    for b in [i for i in range if i ∉ [a]]
        for c in [i for i in range if i ∉ [a,b]]
            for d in [i for i in range if i ∉ [a,b,c]]
                for e in [i for i in range if i ∉ [a,b,c,d]]
                    phases = [a,b,c,d,e]
                    result = iterate(code, phases)
                    push!(th, result)
                end
            end
        end
    end
end

println(maximum(th))
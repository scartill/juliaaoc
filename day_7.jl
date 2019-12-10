using Base

include("intcode.jl")

function iterate(code, phases)
    cap = 1
    ia = Channel(cap)
    ab = Channel(cap)
    bc = Channel(cap)
    cd = Channel(cap)
    de = Channel(cap)
    tasks = [
        @async run(copy(code), input=ia, output=ab)
        @async run(copy(code), input=ab, output=bc)
        @async run(copy(code), input=bc, output=cd)
        @async run(copy(code), input=cd, output=de)
        @async run(copy(code), input=de, output=ia)
    ]
    put!(ia, phases[1])
    put!(ab, phases[2])
    put!(bc, phases[3])
    put!(cd, phases[4])
    put!(de, phases[5])
    put!(ia, 0)
    map(wait, tasks)
    result = take!(ia)
    return result
end

function search(range)
    th = []
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
    return maximum(th)
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

range = 0:4
println(search(range))

test_fb_a = """
    3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
    27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5
"""

test_fb_b = """
    3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
    -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
    53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10
"""

println(iterate(parsecode(test_fb_a), [9,8,7,6,5]) == 139629729)
println(iterate(parsecode(test_fb_b), [9,7,8,5,6]) == 18216)

range = 5:9
println(search(range))
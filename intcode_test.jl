using Base

include("intcode.jl")

function testsimple(code, ans, input = [])
    println(run(code, input=input) == ans)
end

function testlastout(code, ans, input=[])
    output = []
    run(code, input=input, output=output) 
    println(output[end] == ans)
end

function testoutasync(code, ans, input)
    inchan = Channel()
    outchan = Channel()
    task = @async run(code, input=inchan, output=outchan)
    for val in input
        put!(inchan, val)
    end
    result = take!(outchan)
    wait(task)
    close(inchan)
    close(outchan)
    println(result == ans)
end    

testsimple("1,9,10,3,2,3,11,0,99,30,40,50", 3500)
testsimple("1,0,0,0,99", 2)
testsimple("1,1,1,4,99,5,6,0,99", 30)

testsimple("3,0,4,5,99,77", 66, [66])
testlastout("3,0,4,5,99,77", 77, [66])

println(fetch(1002) == (2, [false, true, false]))

testsimple("1101,100,-1,4,0", 1101)

testlastout("3,9,8,9,10,9,4,9,99,-1,8", 1, [8])
testlastout("3,9,8,9,10,9,4,9,99,-1,8", 0, [6])
testlastout("3,9,7,9,10,9,4,9,99,-1,8", 1, [7])
testlastout("3,9,7,9,10,9,4,9,99,-1,8", 0, [9])

testlastout("3,3,1108,-1,8,3,4,3,99", 1, [8])
testlastout("3,3,1108,-1,8,3,4,3,99", 0, [6])
testlastout("3,3,1107,-1,8,3,4,3,99", 1, [7])
testlastout("3,3,1107,-1,8,3,4,3,99", 0, [9])

io_test = """
    3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
    1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
    999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
"""

testlastout(io_test, 999, [6])
testlastout(io_test, 1000, [8])
testlastout(io_test, 1001, [15])

testoutasync(io_test, 999, [6])

test_self = parsecode("""
109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99
""")
output = []
run(test_self, output=output)
println(output == test_self)

test_16digit =  """
1102,34915192,34915192,7,4,7,99,0
"""
output = []
run(test_16digit, output=output)
println(output)

test_large = """
104,1125899906842624,99
"""
output = []
run(test_large, output=output)
println(output)

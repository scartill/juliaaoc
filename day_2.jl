include("intcode.jl")

prog = loadcode("input_d2.txt")

clearprog = copy(prog)
clearprog[2] = 12
clearprog[3] = 2

println(run(clearprog))

target = 19690720

function search()
    for noun in 0:99
        for verb in 0:99
            clearprog = copy(prog)
            clearprog[2] = noun
            clearprog[3] = verb
            result = run(clearprog)
            if result == target
                return 100*noun + verb
            end
        end
    end
end

println(search())

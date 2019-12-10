using Base

function fetch(inst)
    opcode = inst % 100
    inst ÷= 100
    im1 = (inst % 10) == 1
    inst ÷= 10
    im2 = (inst % 10) == 1
    inst ÷= 10
    im3 = (inst % 10) == 1
    return (opcode, [im1, im2, im3])
end

function param(prog, ip, num, modes)
    if modes[num]
        return prog[ip + num]
    else
        inx = prog[ip + num] + 1
        return prog[inx]
    end
end

function save(prog, ip, num, val)
    inx = prog[ip + num] + 1
    prog[inx] = val
end

function doinput(input)
    if typeof(input) <: Array
        return pop!(input)
    else
        return take!(input)
    end
end

function dooutput(output, val)
    if typeof(output) <: Array    
        push!(output, val)
    else
        put!(output, val)
    end
end

function run(prog :: Array{Int}; input=[], output=[])
    ip = 1

    while true
        opcode, modes = fetch(prog[ip])

        if opcode == 99
            break
        end

        if opcode in [1,2]
            x = param(prog, ip, 1, modes)
            y = param(prog, ip, 2, modes)
            t = if opcode == 1
                x + y
            elseif opcode == 2
                x * y
            end
            save(prog, ip, 3, t)
            ip += 4
        end

        if opcode in [3,4]
            if opcode == 3
                x = doinput(input)
                save(prog, ip, 1, x)
            elseif opcode == 4
                x = param(prog, ip, 1, modes)
                dooutput(output, x)
            end                   
            ip += 2
        end

        if opcode in [5,6]
            test = param(prog, ip, 1, modes)
            target = param(prog, ip, 2, modes) + 1
            jump = opcode == 5 && test != 0 ||
                   opcode == 6 && test == 0
            if jump
                ip = target
            else
                ip += 3
            end
        end

        if opcode in [7,8]
            a = param(prog, ip, 1, modes)
            b = param(prog, ip, 2, modes)
            flag = opcode == 7 && a < b ||
                   opcode == 8 && a == b
            save(prog, ip, 3, flag ? 1 : 0)
            ip += 4
        end
    end

    return prog[1]
end

function parsecode(code :: String)
    return map(s -> parse(Int, s), split(code, ","))
end    

function run(code :: String; input=[], output=[])
    run(parsecode(code), input=input, output=output)
end

function loadcode(filename)
    return parsecode(read(filename, String))
end

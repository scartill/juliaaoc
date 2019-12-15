using Base

function fetch(inst)
    opcode = inst % 100
    inst ÷= 100
    m1 = (inst % 10)
    inst ÷= 10
    m2 = (inst % 10)
    inst ÷= 10
    m3 = (inst % 10)
    return (opcode, [m1, m2, m3])
end

function param(prog, ip, num, modes, rb)
    if modes[num] == 1 # immediate
        return prog[ip + num]
    elseif modes[num] == 0 # position
        inx = prog[ip + num] + 1
        return prog[inx] 
    else # relative
        inx = prog[ip + num] + 1 + rb
        return prog[inx]
    end
end

function save(prog, ip, num, val, modes, rb)
    offset = modes[num] == 2 ? rb : 0
    inx = prog[ip + num] + 1 + offset
    prog[inx] = val
end

function doinput(input)
    if typeof(input) <: Array
        return pop!(input)
    elseif !isempty(methods(input))
        return input()
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
    rb = 0

    prog = [prog; zeros(Int, 1024)]

    while true
        opcode, modes = fetch(prog[ip])

        if opcode == 99
            break
        end

        if opcode in [1,2]
            x = param(prog, ip, 1, modes, rb)
            y = param(prog, ip, 2, modes, rb)
            t = if opcode == 1
                x + y
            elseif opcode == 2
                x * y
            end
            save(prog, ip, 3, t, modes, rb)
            ip += 4
        end

        if opcode in [3,4]
            if opcode == 3
                x = doinput(input)
                save(prog, ip, 1, x, modes, rb)
            elseif opcode == 4
                x = param(prog, ip, 1, modes, rb)
                dooutput(output, x)
            end                   
            ip += 2
        end

        if opcode in [5,6]
            test = param(prog, ip, 1, modes, rb)
            target = param(prog, ip, 2, modes, rb) + 1
            jump = opcode == 5 && test != 0 ||
                   opcode == 6 && test == 0
            if jump
                ip = target
            else
                ip += 3
            end
        end

        if opcode in [7,8]
            a = param(prog, ip, 1, modes, rb)
            b = param(prog, ip, 2, modes, rb)
            flag = opcode == 7 && a < b ||
                   opcode == 8 && a == b
            save(prog, ip, 3, flag ? 1 : 0, modes, rb)
            ip += 4
        end

        if opcode == 9
            a = param(prog, ip, 1, modes, rb)
            rb += a
            ip += 2
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

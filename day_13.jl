using Base.Iterators
using Match

include("intcode.jl")

function getout(code)
    output = []
    run(code; output=output)
    return output
end

function update!(screen, t)
    if t[1] == -1 && t[2] == 0
        screen[2] = t[3]
    else
        screen[1][t[2] + 1, t[1] + 1] = t[3]
    end
end

function mkscreen(output)
    triples = partition(output, 3)
    mx = (map(t -> t[1], triples) |> maximum) + 1
    my = (map(t -> t[2], triples) |> maximum) + 1
    screen = [zeros(Int, (my, mx)), 0]
    foreach(triples) do t
        update!(screen, t)
    end
    return screen
end

function render(screen)
    (my, mx) = size(screen[1])
    print("+")
    print("-" ^ mx)
    println("+")
    for y in 1:my
        print("|")
        for x in 1:mx
            @match screen[1][y, x] begin
                1 => print("█")
                2 => print("▒")
                3 => print("=")
                4 => print("∘")
                _ => print(".")
            end
        end
        println("|")
    end
    print("+")
    print("-" ^ mx)
    println("+")
    println("         Highscore $(screen[2])")
end

function playgame!(code, screensize)
    screen = [zeros(Int, screensize), 0]
    code[1] = 2

    input = function()
        yield()
        ball = findall(t -> t == 4, screen[1]) |> first
        paddle = findall(t -> t == 3, screen[1]) |> first

        if count(isequal(2), screen[1]) == 1
            render(screen)            
            exit(0)
        end

        if ball[2] > paddle[2]
            return 1
        elseif ball[2] < paddle[2]
            return -1
        else
            return 0
        end
    end

    output = Channel(3)
    task = @async run(code; input=input, output=output)
    while true
        x = take!(output)
        y = take!(output)
        id = take!(output)
        update!(screen, [x, y, id])
        if istaskdone(task)
            return
        end
    end
end

[1,2,3,6,5,4] |> mkscreen |> render

code = loadcode("input_d13.txt")
initscreen = copy(code) |> getout |> mkscreen 
initscreen |> sc -> count(isequal(2), sc[1]) |> println
playgame!(code, size(initscreen[1]))




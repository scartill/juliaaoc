using Base

include("intcode.jl")

function paint(filename, startcolor)
    input = Channel(1)
    output = Channel()
    code = loadcode(filename)
    task = @async run(code; input=input, output=output)
    board = zeros(Int, 101, 101)
    inxboard = zeros(Bool, 101, 101)
    xy = [50, 50]
    board[50, 50] = startcolor
    dir = [0, -1]
    right = [0 -1; 1 0]
    left = [0 1; -1 0]

    while true
        (x, y) = (xy[1], xy[2])
        put!(input, board[y, x])

        if(istaskdone(task))            
            return (board, count(inxboard))
        end

        color = take!(output)
        board[y, x] = color
        inxboard[y, x] = true
        turn = take!(output)
        dir = ((turn == 1) ? right : left)*dir
        xy .+= dir
        yield()
    end
end

function render(board)
    println()
    for y in 1:size(board, 1)
        for x in 1:size(board, 2)
            print(board[y, x] == 1 ? "▓" : " ")
        end
        println()
    end
end

paint("input_d11.txt", 0) |> last |> println
paint("input_d11.txt", 1) |> first |> render


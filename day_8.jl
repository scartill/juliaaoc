function parseimage(code, width, height)
    array = map(s -> parse(Int, s), split(code, "")[1:end-1])
    layers = length(array)/(width*height)
    image = []
    inx = 1
    for ln in 1:layers
        layer = zeros(height, width)
        for i in 1:height
            for j in 1:width
                layer[i, j] = array[inx]
                inx += 1
            end
        end
        push!(image, layer)
    end
    return image
end

function decodeimage(image)
    layers = length(image)
    (height, width) = size(image[1]) 
    bitmap = zeros(height, width)
    for l in layers:-1:1
        for i in 1:height
            for j in 1:width
                if image[l][i, j] == 0
                    bitmap[i, j] = 0
                elseif image[l][i, j] == 1
                    bitmap[i, j] = 1
                end
            end
        end
    end
    return bitmap
end

function render(bitmap)
    (height, width) = size(bitmap) 
    print("+")
    print("-" ^ width)
    print("+")
    println()
    for i in 1:height
        print("|")
        for j in 1:width
            print(bitmap[i, j] == 1 ? "▓" : " ")
        end
        print("|")
        println("")
    end
    print("+")
    print("-" ^ width)
    print("+")
    println()
end

println(parseimage("123456789012\n", 3, 2))

image = parseimage(read("input_d8.txt", String), 25, 6)
zerodigits = map(image) do layer
    count(d -> d == 0, layer)
end
target = image[argmin(zerodigits)]
checksum = count(d -> d == 1, target)*count(d -> d == 2, target)
println(checksum)

test_image = [
    [0 2; 2 2],
    [1 1; 2 2],
    [2 2; 1 2],
    [0 0; 0 0]
]

render(decodeimage(test_image))

bitmap = decodeimage(image)
render(bitmap)

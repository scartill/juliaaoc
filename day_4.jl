function isvalidpass(val)
    hasthesame = false
    cur = 10
    for _ in 1:6
        next = val % 10
        val = val ÷ 10
        
        if next == cur
            hasthesame = true
        end

        if next > cur
            return false
        end

        cur = next
    end
    return hasthesame
end

println(isvalidpass(111111))
println(isvalidpass(223450))
println(isvalidpass(123789))

range = 137683:596253
valids = count(isvalidpass, range)
println(valids)

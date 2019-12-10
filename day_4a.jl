function isvalidpass(val)
    hasthesame = false
    cur = 10
    samecount = 1
    for _ in 1:6
        next = val % 10
        val = val ÷ 10
        
        if next == cur
            samecount += 1
        else
            if samecount == 2
                hasthesame = true
            end
            samecount = 1
        end

        if next > cur
            return false
        end

        cur = next
    end
    return hasthesame || samecount == 2
end

println(isvalidpass(111111))
println(isvalidpass(223450))
println(isvalidpass(123789))
println(isvalidpass(112233))
println(isvalidpass(123444))
println(isvalidpass(111122))

range = 137683:596253
valids = count(isvalidpass, range)
println(valids)

# open inputs/input.txt and print every line
open("inputs/input.txt") do f
    lines = readlines(f)
    prev_line = ""
    next_line = ""
    sumNums = 0
    for (i, line) in enumerate(lines)
        try
            prev_line = lines[i-1]
        catch
            prev_line = ""
        end
        try
            next_line = lines[i+1]
        catch
            next_line = ""
        end
        number_regex = r"\d+"
        for number in eachmatch(number_regex, line)
            indexleft = max(1, number.offset-1)
            indexright = min(length(line), number.offset+length(number.match))
            charsaround = ""
            if (prev_line != "") 
                charsaround = charsaround * prev_line[indexleft:indexright]
            end
            if (next_line != "")
                charsaround = charsaround * next_line[indexleft:indexright]
            end
            if indexleft < number.offset
                charsaround = charsaround * line[indexleft]
            end
            if indexright > number.offset+length(number.match)-1
                charsaround = charsaround * line[indexright]
            end
            if match(r"[^\.]", charsaround) != nothing
                sumNums += parse(Int64, number.match)
            end
        end
    end
    println(sumNums)
end
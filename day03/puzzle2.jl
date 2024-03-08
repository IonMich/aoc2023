open("inputs/input.txt") do f
    lines = readlines(f)
    prev_line, next_line, sumNums = "", "", 0
    for (i, line) in enumerate(lines)
        prev_line = (i-1 > 0) ? lines[i-1] : ""
        next_line = (i+1 <= length(lines)) ? lines[i+1] : ""
        asterisk_regex = r"\*"
        for asterisk in eachmatch(asterisk_regex, line)
            count_numbers, numberproduct = 0, 1
            indexleft = max(1, asterisk.offset-1)
            indexright = min(length(line), asterisk.offset+length(asterisk.match))
            for line_j in [line, prev_line, next_line]
                (line_j == "") && continue
                startingnumber_regex = r"\d+"
                startingnumber = match(startingnumber_regex, line_j[asterisk.offset:length(line_j)])
                if startingnumber != nothing && startingnumber.offset <= 2
                    count_numbers += 1
                end
                endingnumber_regex = r"\d+$"
                endingnumber = match(endingnumber_regex, line_j[1:asterisk.offset-1])
                if endingnumber != nothing
                    count_numbers += 1
                end
                if startingnumber != nothing && endingnumber != nothing && startingnumber.offset == 1
                    # merge startingnumber and endingnumber
                    count_numbers -= 1
                    numberproduct *= parse(Int64, endingnumber.match * startingnumber.match)
                else
                    if startingnumber != nothing && startingnumber.offset <= 2
                        numberproduct *= parse(Int64, startingnumber.match)
                    end
                    if endingnumber != nothing
                        numberproduct *= parse(Int64, endingnumber.match)
                    end
                end
            end
            (count_numbers == 2) && (sumNums += numberproduct)
        end
    end
    println(sumNums)
end
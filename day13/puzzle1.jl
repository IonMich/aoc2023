blocks = Dict()
line_matches = Dict()
v_mirrors_found = Dict()
h_mirrors_found = Dict()
open("inputs/input.txt") do f
    lines = readlines(f)
    len_lines = length(lines)
    block_x_len = -1
    block_line_matches = []
    prev_line = ""
    block_idx = 1
    line_block_idx = 1
    impossible_mirror_v_after = []
    block = []
    for (line_idx, line) in enumerate(lines)
        if line_block_idx == 1
            impossible_mirror_v_after = []
            block = []
            block_line_matches = []
            block_x_len = length(line)
        end
        if line == "" || line_idx == len_lines
            if length(impossible_mirror_v_after) < block_x_len - 1
                mirror = setdiff(1:block_x_len-1, impossible_mirror_v_after)[1]
                v_mirrors_found[block_idx] = mirror
            elseif length(block_line_matches) == 1
                h_mirrors_found[block_idx] = block_line_matches[1]
            else
                blocks[block_idx] = block
                line_matches[block_idx] = block_line_matches
            end
            block_idx += 1
            line_block_idx = 1
            continue
        end
        push!(block, line)
        line_block_idx += 1
        skip = false
        if prev_line == line
            push!(block_line_matches, line_block_idx-2)
            skip = true
        elseif length(impossible_mirror_v_after) == block_x_len - 1
            skip = true
        end 
        prev_line = line
        if skip
            continue
        end
        for i in 1:block_x_len
            if i in impossible_mirror_v_after
                continue
            end
            min_len = min(i, block_x_len - i)
            start_left = i-min_len+1
            end_left = i
            start_right = i + 1
            end_right = i + min_len
            for j in 1:min_len
                if line[start_left+j-1] != line[end_right-j+1]
                    push!(impossible_mirror_v_after, i)
                    break
                end
            end
        end
    end
end

for block_idx in keys(blocks)
    block = blocks[block_idx]
    block_line_matches = line_matches[block_idx]
    found = false
    for possible_h_mirror in block_line_matches[1:end-1]
        min_len = min(possible_h_mirror, length(block) - possible_h_mirror)
        start_top = possible_h_mirror - min_len + 1
        end_top = possible_h_mirror
        start_bottom = possible_h_mirror + 1
        end_bottom = possible_h_mirror + min_len
        if block[start_top:end_top] == reverse(block[start_bottom:end_bottom])
            h_mirrors_found[block_idx] = possible_h_mirror
            found = true
        end
    end
    if (!found)
        h_mirrors_found[block_idx] = block_line_matches[end]
    end
end

println(sum(values(h_mirrors_found))*100 + sum(values(v_mirrors_found)))
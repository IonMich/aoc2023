blocks = Dict()
line_matches = Dict()
v_mirrors_found = Dict{Int, Int}()
h_mirrors_found = Dict{Int, Int}()

function num_string_diff(s1, s2)
    return sum([s1[i] != s2[i] for i in 1:length(s1)])
end

open("inputs/input.txt") do f
    lines = readlines(f)
    block_x_len, prev_line, len_lines = 0, "", length(lines)
    num_block_v_collisions = Dict()
    block_line_possible, block = [], []
    block_idx, line_block_idx = 1, 1
    for (line_idx, line) in enumerate(lines)
        if line_block_idx == 1
            block = []
            num_block_v_collisions = Dict()
            block_line_possible = []
            block_x_len = length(line)
        end
        if line == "" || line_idx == len_lines
            i_one_collision = -1
            for i in 1:block_x_len
                if get(num_block_v_collisions, i, 0) == 1
                    i_one_collision = i
                    break
                end
            end
            if i_one_collision != -1
                v_mirrors_found[block_idx] = i_one_collision
            elseif length(block_line_possible) == 1
                h_mirrors_found[block_idx] = block_line_possible[1]
            else
                blocks[block_idx] = block
                line_matches[block_idx] = block_line_possible
            end
            block_idx, line_block_idx = block_idx + 1, 1
            continue
        end
        push!(block, line)
        line_block_idx += 1
        skip = false
        if line_block_idx > 2 && num_string_diff(prev_line, line) <= 1
            push!(block_line_possible, line_block_idx-2)
        elseif all(get(num_block_v_collisions, i, 0) > 1 for i in 1:block_x_len)
            skip = true
        end 
        prev_line = line
        (skip) && continue
        for i in 1:block_x_len-1
            (get(num_block_v_collisions, i, 0) == 0) > 1 && continue
            min_len = min(i, block_x_len - i)
            start_left, start_right = i - min_len + 1, i + 1
            end_left, end_right = i, i + min_len
            num_chars_diff = num_string_diff(
                line[start_left:end_left],
                reverse(line[start_right:end_right]))
            num_block_v_collisions[i] = get(num_block_v_collisions, i, 0) + num_chars_diff
        end
    end
end

for block_idx in keys(blocks)
    block = blocks[block_idx]
    block_line_matches = line_matches[block_idx]
    found = false
    for possible_h_mirror in block_line_matches[1:end-1]
        min_len = min(possible_h_mirror, length(block) - possible_h_mirror)
        start_top, start_bottom = possible_h_mirror - min_len + 1, possible_h_mirror + 1
        end_top, end_bottom = possible_h_mirror, possible_h_mirror + min_len
        num_mismatch_chars = num_string_diff(
            block[start_top:end_top], 
            reverse(block[start_bottom:end_bottom])
            )
        if num_mismatch_chars > 1
            continue
        elseif num_mismatch_chars == 1
            h_mirrors_found[block_idx] = possible_h_mirror
            found = true
            break
        end
    end
    (!found) && (h_mirrors_found[block_idx] = block_line_matches[end])
end
println(sum(values(h_mirrors_found))*100 + sum(values(v_mirrors_found)))
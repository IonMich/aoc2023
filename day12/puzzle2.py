import re

def parse_row(row):
    matches = re.match(r'(.*)\s(.*)', row)
    if not matches:
        return None
    pattern = matches.group(1)
    pattern = pattern + '?'
    pattern = pattern * 5
    pattern = pattern[:-1]
    groups = matches.group(2)

    groups = (groups +",") * 5
    contiguous_groups_str = groups.split(',')
    contiguous_groups_str = contiguous_groups_str[:-1]
    group_counts = tuple(int(x) for x in contiguous_groups_str)
    return (pattern, group_counts)

def get_num_valid_combinations(pattern, group_counts):
    if (pattern, group_counts) in memo:
        return memo[(pattern, group_counts)]
    if pattern == '':
        memo[(pattern, group_counts)] = 1 if len(group_counts) == 0 else 0
        return 1 if len(group_counts) == 0 else 0
    count_h = pattern.count('#')
    if len(group_counts) == 0:
        return 1 if count_h == 0 else 0
    count_q = pattern.count('?')
    if len(pattern) < sum(group_counts) + len(group_counts) - 1:
        memo[(pattern, group_counts)] = 0
        return 0
    if count_h + count_q < sum(group_counts):
        memo[(pattern, group_counts)] = 0
        return 0
    
    max_group_count = max(group_counts)
    max_group_index = group_counts.index(max_group_count)
    group_counts_before = group_counts[:max_group_index]
    group_counts_after = group_counts[max_group_index+1:]
    min_chars_before = 0 if not group_counts_before else sum(group_counts_before) + len(group_counts_before)
    min_chars_after = 0 if not group_counts_after else sum(group_counts_after) + len(group_counts_after)
    all_valid_combinations = 0
    for i in range(min_chars_before, len(pattern) + 1 - min_chars_after - max_group_count):
        if "." not in pattern[i:i+max_group_count]:
            pattern_before = pattern[:i]
            if pattern_before != '':
                if pattern_before[-1] == '#':
                    continue
                pattern_before = pattern_before[:-1]
            valid_combinations_before = get_num_valid_combinations(pattern_before, group_counts_before)
            if valid_combinations_before == 0:
                continue
            pattern_after = pattern[i+max_group_count:]
            if pattern_after != '':
                if pattern_after[0] == '#':
                    continue
                pattern_after = pattern_after[1:]
            valid_combinations_after = get_num_valid_combinations(pattern_after, group_counts_after)
            all_valid_combinations += valid_combinations_before*valid_combinations_after
    memo[(pattern, group_counts)] = all_valid_combinations
    return all_valid_combinations




with open("inputs/input.txt") as file:
    rows = file.read().splitlines()

memo: dict = {}
total = 0
for i, row in enumerate(rows):
    parsed = parse_row(row)
    if not parsed:
        continue
    pattern, group_counts = parsed
    
    num_valid_combinations = get_num_valid_combinations(pattern, group_counts)
    total += num_valid_combinations
print(total)
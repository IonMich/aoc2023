DIGIT_NAMES = {
    "one": "1", 
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5", 
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
}

DIGIT_NAMES_REVERSED = {name[::-1]: value for name, value in DIGIT_NAMES.items()}

def get_sum(filepath='inputs/input.txt'):
    with open(filepath) as f:
        return sum(get_line_number(line) for line in f)

def get_line_number(line):
    firstdigit = lastdigit = get_first_digit_from_line(line)
    lastdigit = get_last_digit_from_line(line)
    linenumber = int(firstdigit + lastdigit)
    return linenumber

def _get_first_digit_from_string(string, digit_names=DIGIT_NAMES):
    substring_match = {k: [] for k in digit_names.keys()}
    for char in string:
        if char.isdigit():
            return char
        for name in substring_match.keys():
            i = 0
            while i < len(substring_match[name]):
                if char != name[substring_match[name][i]]:
                    del substring_match[name][i]
                else:
                    substring_match[name][i] += 1
                    if substring_match[name][i] == len(name):
                        return digit_names[name]
                    i += 1
            if char == name[0]:
                substring_match[name].append(1)
    
def get_first_digit_from_line(line):
    return _get_first_digit_from_string(line, digit_names=DIGIT_NAMES)
        
def get_last_digit_from_line(line):
    return _get_first_digit_from_string(reversed(line), digit_names=DIGIT_NAMES_REVERSED)

if __name__ == '__main__':
    print(get_sum())
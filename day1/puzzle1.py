def get_sum(filepath='inputs/input.txt'):
    mysum = 0
    with open(filepath, 'r') as f:
        mysum = sum(get_line_number(line) for line in f)
    return mysum

def get_line_number(line):
    firstdigit = lastdigit = get_first_digit_from_line(line)
    lastdigit = get_last_digit_from_line(line)
    linenumber = int(firstdigit + lastdigit)
    return linenumber

def _get_first_digit_from_string(string):
    for char in string:
        if char.isdigit():
            return char
    
def get_first_digit_from_line(line):
    return _get_first_digit_from_string(line)
        
def get_last_digit_from_line(line):
    return _get_first_digit_from_string(reversed(line))

if __name__ == '__main__':
    print(get_sum())

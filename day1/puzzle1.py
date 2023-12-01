def get_first_last_digits(filepath='inputs/input.txt'):
    sum = 0
    with open(filepath, 'r') as f:
        for line in f:
            for char in line:
                if not char.isdigit():
                    continue
                firstdigit = lastdigit = char
                break
            for char in reversed(line):
                if not char.isdigit():
                    continue
                lastdigit = char
                break
            linenumber = int(firstdigit + lastdigit)
            sum += linenumber
    return sum

if __name__ == '__main__':
    print(get_first_last_digits())

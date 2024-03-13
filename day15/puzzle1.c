#include <stdio.h>
#include <string.h>

#define EXTRA_BYTES 10

int char_hash(char *str) {
    int hash = 0;
    for (int i = 0; i < strlen(str); i++) {
        if (str[i] == '\n') {
            break;
        }
        // ascii value of the character
        hash += (int)str[i];
        // multiply by 17
        hash *= 17;
        // mod 256
        hash %= 256;
    }
    return hash;
}

int print_file(char *filename) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        printf("Error: File not found\n");
        return 1;
    }
    fseek(file, 0, SEEK_END);
    int max = ftell(file);
    fseek(file, 0, SEEK_SET);
    max += EXTRA_BYTES; // Add extra bytes to the buffer
    char line[max];
    int total_hash=0;
    int seed_hash=0;
    fgets(line, max, file);
    char *token = strtok(line, ",");
    while (token != NULL) {
        int hash = char_hash(token);
        total_hash += hash;
        token = strtok(NULL, ",");
    }
    printf("%d\n", total_hash);
    fclose(file);
    return 0;
}

int main() {
    print_file("inputs/input.txt");
    return 0;
}
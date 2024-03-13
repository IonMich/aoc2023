#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define EXTRA_BYTES 10

struct Lens {
    char label[10];
    int value;
    struct Lens *next;
};

struct Lens *hash_table[256];

void print_hash_table() {
    for (int i = 0; i < 256; i++) {
        if (hash_table[i] != NULL) {
            printf("Box %d: ", i);
            struct Lens *current = hash_table[i];
            while (current != NULL) {
                printf("[%s %d] ", current->label, current->value);
                current = current->next;
            }
            printf("\n");
        }
    }
}

int char_hash(char *str) {
    int hash = 0;
    for (int i = 0; i < strlen(str); i++) {
        hash += (int)str[i];
        hash *= 17;
        hash %= 256;
    }
    return hash;
}

int get_file_length(char *filename) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        printf("Error: File not found\n");
        return 1;
    }
    fseek(file, 0, SEEK_END);
    int max = ftell(file);
    fclose(file);
    return max;
}

void parse_token(char *token, char *label, char *op_code, int *lens_value) {
    char *dup_token = strdup(token);
    // probably cursed, but it works
    if (dup_token[strlen(dup_token) - 1] == '-') {
        dup_token[strlen(dup_token) - 1] = '\0';
        strcpy(label, dup_token);
        *op_code = '-';
        *lens_value = -1;
    } else {
        *op_code = '=';
        *lens_value = atoi(&dup_token[strlen(dup_token) - 1]);
        dup_token[strlen(dup_token) - 1] = '\0';
        dup_token[strlen(dup_token) - 1] = '\0';
        strcpy(label, dup_token);
    }
    return;
}

int calculate_lens_power(int lens_value, int hash, int slot) {
    return lens_value * (hash+1) * (slot+1);
}

int calculate_box_power(int hash) {
    int box_power = 0;
    struct Lens *current = hash_table[hash];
    int slot = 0;
    while (current != NULL) {
        box_power += calculate_lens_power(current->value, hash, slot);
        slot++;
        current = current->next;
    }
    return box_power;
}

int calculate_total_power() {
    int total_power = 0;
    for (int i = 0; i < 256; i++) {
        if (hash_table[i] != NULL) {
            total_power += calculate_box_power(i);
        }
    }
    return total_power;
}

int print_file(char *filename) {
    int max = get_file_length(filename);
    max += EXTRA_BYTES; // Add extra bytes to the buffer
    FILE *file = fopen(filename, "r");
    char line[max];
    fgets(line, max, file);
    char label[10];
    char op_code[1];
    int lens_value;
    
    for (char *token = strtok(line, ","); token != NULL; token = strtok(NULL, ",")) {
        int tok_len = strlen(token);
        if (token[tok_len - 1] == '\n') {
            token[tok_len - 1] = '\0';
        }
        parse_token(token, label, op_code, &lens_value);
        int hash = char_hash(label);
        if (*op_code == '=') {
            struct Lens *current = hash_table[hash];
            struct Lens *prev = NULL;
            while (current != NULL) {
                if (strcmp(current->label, label) == 0) {
                    current->value = lens_value;
                    break;
                }
                current = current->next;
            }
            if (current == NULL) {
                struct Lens *new_lens = (struct Lens *)malloc(sizeof(struct Lens));
                strcpy(new_lens->label, label);
                new_lens->value = lens_value;
                new_lens->next = NULL;
                if (hash_table[hash] == NULL) {
                    hash_table[hash] = new_lens;
                } else {
                    current = hash_table[hash];
                    while (current != NULL) {
                        prev = current;
                        current = current->next;
                    }
                    prev->next = new_lens;
                }
            }
        } else {
            struct Lens *current = hash_table[hash];
            struct Lens *prev = NULL;
            while (current != NULL) {
                if (strcmp(current->label, label) == 0) {
                    if (prev == NULL) {
                        hash_table[hash] = current->next;
                    } else {
                        prev->next = current->next;
                    }
                    free(current);
                    break;
                }
                prev = current;
                current = current->next;
            }
        }
    }
    printf("%d\n", calculate_total_power());
    fclose(file);
    return 0;
}

int main() {
    print_file("inputs/input.txt");
    return 0;
}
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CAPACITY 3

static void list_records(char *const records[])
{
    for (int i = 0; i < CAPACITY; i++) {
        if (records[i])
            printf("%d: %s\n", i + 1, records[i]);
    }
}

static int add_record(char *records[], const char *input)
{
    char name[32];
    size_t len = strlen(input);

    if (len == 0 || len >= sizeof(name)) {
        fputs("Invalid record length\n", stderr);
        return 2;
    }

    memcpy(name, input, len + 1);

    for (int i = 0; i < CAPACITY; i++) {
        if (!records[i]) {
            records[i] = strdup(name);
            if (!records[i])
                return 1;

            printf("Added: %s\n", records[i]);
            return 0;
        }
    }

    return 1;
}

static int search_record(char *records[], const char *input)
{
    char *query = malloc(strlen(input) + 1);
    if (!query)
        return 1;

    strcpy(query, input);

    for (int i = 0; i < CAPACITY; i++) {
        if (records[i] && strstr(records[i], query))
            printf("Found: %s\n", records[i]);
    }

    free(query);
    return 0;
}

static int delete_record(char *records[], const char *input)
{
    for (int i = 0; i < CAPACITY; i++) {
        if (records[i] && strcmp(records[i], input) == 0) {
            char *name = records[i];
            printf("Deleted: %s\n", name);
            free(name);
            records[i] = NULL;
            return 0;
        }
    }

    return 1;
}

int main(int argc, char *argv[])
{
    char *records[CAPACITY] = {
        strdup("Laptop"),
        strdup("Monitor"),
        NULL
    };

    int result = 1;

    if (!records[0] || !records[1])
        goto cleanup;

    if (argc == 2 && strcmp(argv[1], "list") == 0) {
        list_records(records);
        result = 0;
    } else if (argc == 3) {
        if (strcmp(argv[1], "add") == 0)
            result = add_record(records, argv[2]);
        else if (strcmp(argv[1], "search") == 0)
            result = search_record(records, argv[2]);
        else if (strcmp(argv[1], "delete") == 0)
            result = delete_record(records, argv[2]);
    } else {
        puts("Usage: records list|add|search|delete [name]");
    }

cleanup:
    for (int i = 0; i < CAPACITY; i++)
        free(records[i]);

    return result;
}

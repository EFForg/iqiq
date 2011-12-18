#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    FILE *fp;
    if (argc != 2) {
        fprintf(stderr, "Usage: disiq FILE.pro\n");
        return 1;
    }
    if (!(fp = fopen(argv[1], "r"))) {
        perror("open");
        return 1;
    }
    while (!feof(fp)) {
        int c = fgetc(fp);
        if (c == EOF) {
            break;
        } else if (c == 0) {
            putchar('\n');
        } else if (isprint(c)) {
            putchar(c);
        } else if (c == 0x0a) {
            printf("\n\t");
        } else {
            printf("\\x%02x", c);
        }
    }
    putchar('\n');
    fclose(fp);
}


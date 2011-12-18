#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    FILE *fp;
    int n = 0;
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
        n++;
        if (c == EOF) {
            break;
        }
        if (n < 12) {  // header
            printf("%02x ", c);
            continue;
        } else if (n == 12) {
            putchar('\n');
        }
        if (c == 0) {
            putchar('\n');
        } else if (c == 3) {
            printf("   :    ");
        } else if (isprint(c)) {
            putchar(c);
        } else {
            printf("%02x ", c);
        }
    }
    putchar('\n');
    fclose(fp);
    return 0;
}

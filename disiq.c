/**
 * Dumps information from a CarrierIQ OTA profile.
 */
#include <stdio.h>
#include <stdlib.h>
#include <wbxml.h>

static char *slurp(const char *file, long *size)
{
    FILE *fp;
    char *text = NULL;
    *size = 0;
    if (!(fp = fopen(file, "r"))) {
        return NULL;
    }
    if (fseek(fp, 0, SEEK_END) < 0 ||
        (*size = ftell(fp)) <= 0 ||
        fseek(fp, 0, SEEK_SET) < 0 ||
        !(text = (char *)malloc(*size))) {
        fclose(fp);
        return NULL;
    }
    if (fread(text, *size, 1, fp) != 1) {
        free(text);
        fclose(fp);
        return NULL;
    }
    fclose(fp);
    return text;
}

static int parse(char *data, long size)
{
    WBXMLParser *parser;
    WBXMLError err;
    if (!(parser = wbxml_parser_create())) {
        return 1;
    }
    err = wbxml_parser_parse(parser, (WB_UTINY *)data, (WB_ULONG)size);
    if (err != WBXML_OK) {
        fprintf(stderr, "wbxml: %s\n", wbxml_errors_string(err));
        return 1;
    }
    wbxml_parser_destroy(parser);
    return 0;
}

int main(int argc, char **argv)
{
    char *data;
    long size;
    if (argc != 2) {
        fprintf(stderr, "Usage: disiq FILE.pro\n");
        return 1;
    }
    data = slurp(argv[1], &size);
    parse(data, size);
    free(data);
    return 0;
}

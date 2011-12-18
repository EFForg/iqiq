/**
 * Dumps information from a CarrierIQ OTA profile.
 */
#include <stdio.h>
#include <stdlib.h>
#include <wbxml.h>

/* Number of header bytes before WBXML-encoded data. */
#define HEADER_LENGTH 6

/* Reads contents of file.
 * Returns newly allocated data and size in *size, or NULL on failure. */
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

/* Changes the character set of a WBXML stream to ASCII. */
static void patch_charset(char *data, long size)
{
    /* Skip header. */
    data += HEADER_LENGTH, size -= HEADER_LENGTH;
    /* Skip version byte. */
    data++, size--;
    /* Skip document public identifier. */
    while (size > 0 && *data & 0x80) {
        data++, size--;
    }
    data++, size--;
    /* Now pointing to charset field. */
    if (size > 0) {
        *data = WBXML_CHARSET_US_ASCII;       
    }
}

/* Parses a wrapped WBXML document in data. */
static int parse(char *data, long size)
{
    WBXMLParser *parser;
    WBXMLError err;
    if (!(parser = wbxml_parser_create())) {
        return 1;
    }
    /* Ubuntu's libwbxml2 only accepts ASCII or UTF-8. Most profiles seem to
     * use ISO-8859-1, and have only basic ASCII strings, so just treat input
     * as ASCII. */
    patch_charset(data, size);
    err = wbxml_parser_parse(parser, (WB_UTINY *)(data + HEADER_LENGTH),
                (WB_ULONG)(size - HEADER_LENGTH));
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

/**
 * Dumps information from a CarrierIQ OTA profile.
 */
#include <assert.h>
#include <ctype.h>
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

/* Returns 1 if a string is printable, 0 otherwise. */
static int printable(const char *s)
{
    while (*s)
        if (!isprint(*s++))
            return 0;
    return 1;
}

/* Called after header is loaded. */
static void start_document(
        void *ctx,
        WBXMLCharsetMIBEnum charset,
        const WBXMLLangEntry *lang)
{
    const char *charset_name = NULL;
    wbxml_charset_get_name(charset, &charset_name);
    assert(charset_name != NULL);  /* We patched it to ASCII. */
    printf("charset: %s (patched)\n", charset_name);
    if (lang != NULL) {
        switch (lang->langID) {
        case WBXML_LANG_WML10:
            printf("dtd: WML/1.0 (%d)\n", lang->langID);
            break;
        case WBXML_LANG_WML11:
            printf("dtd: WML/1.1 (%d)\n", lang->langID);
            break;
        case WBXML_LANG_WML12:
            printf("dtd: WML/1.2 (%d)\n", lang->langID);
            break;
        case WBXML_LANG_WML13:
            printf("dtd: WML/1.3 (%d)\n", lang->langID);
            break;
        default:
            printf("dtd: standard, but unexpected (%d)\n", lang->langID);
            break;
        }
    } else {
        printf("dtd: unknown\n");
    }
}

/**
 * Called at the start of an element.
 */
static void start_element(
        void *ctx,
        WBXMLTag *local_name,
        WBXMLAttribute **attrs,
        WB_BOOL empty)
{
    assert(local_name);
    if (local_name->type == WBXML_VALUE_TOKEN) {
        printf("tag: token `%s' (%02x)\n",
               local_name->u.token->xmlName,
               local_name->u.token->wbxmlToken);
    } else if (local_name->type == WBXML_VALUE_LITERAL) {
        const char *name = (const char *)wbxml_buffer_get_cstr(
                local_name->u.literal);
        if (!name || !printable(name)) {
            printf("tag: literal ?\n");
        } else {
            printf("tag: literal `%s'\n", name);
        }
    }
    if (attrs) {
        WBXMLAttribute *attr;
        int i;
        for (i = 0; (attr = attrs[i]); i++) {
            if (attr->name->type == WBXML_VALUE_TOKEN) {
                printf("- attr: token `%s' (%02x)\n",
                       attr->name->u.token->xmlName,
                       attr->name->u.token->wbxmlToken);
            } else {
                const char *name = (const char *)wbxml_buffer_get_cstr(
                        attr->name->u.literal);
                if (!name || !printable(name)) {
                    printf("- attr: literal ?\n");
                } else {
                    printf("- attr: literal `%s'\n", name);
                }
            }
            if (attr->value) {
                const char *value = (const char *)wbxml_buffer_get_cstr(
                        attr->value);
                assert(value);
                if (printable(value)) {
                    printf("  = `%s'\n", value);
                } else {
                    if (wbxml_buffer_binary_to_hex(attr->value,
                                FALSE) == TRUE) {
                        printf("  = `%s'\n", value);
                    } else {
                        printf("  = ?\n");
                    }
                }
            } else {
                printf("  [no value]\n");
            }
        }
    } else {
        printf("  (no attrs)\n");
    }
}

/* Called to handle character data. */
static void cdata(void *ctx,
                  WB_UTINY *ch,
                  WB_ULONG start,
                  WB_ULONG length)
{
    int i;
    printf("- CDATA:\n");
    for (i = start; i != start + length; i++) {
        putchar(ch[i]);
    }
}

/* Parses a wrapped WBXML document in data. */
static int parse(char *data, long size)
{
    WBXMLParser *parser;
    WBXMLError err;
    static WBXMLContentHandler content_handler = {
        start_document,  /* Start document handler. */
        NULL,            /* End document handler. */
        start_element,   /* Start element handler. */
        NULL,            /* End element handler. */
        cdata,           /* Characters handler. */
        NULL,            /* Processing instruction handler. */
    };
    if (!(parser = wbxml_parser_create())) {
        return 1;
    }
    wbxml_parser_set_content_handler(parser, &content_handler);
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

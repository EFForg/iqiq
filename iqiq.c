/**
 * Dumps information from a CarrierIQ OTA profile.
 * Copyright 2011 Jered Wierzbicki (with assistance from Peter Eckersley)
 * Licensed Under the GNU General Public License version 2.0 or later
 */
#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <wbxml.h>

/* Spaces to tab when printing output. */
#define TAB_WIDTH 4

/* Number of header bytes before WBXML-encoded data. */
#define HEADER_LENGTH 6

/* libwbxml needs this magic number to override the table properly. */
#define LANG_CIQ_OTA 666

/* Bogus public id entry. */
const WBXMLPublicIDEntry sv_ciq_ota_public_id = {
    WBXML_PUBLIC_ID_UNKNOWN, NULL, "config", "ciq10.dtd"
};

/* Tag names and ids. */
const WBXMLTagEntry sv_ciq_ota_tag_table[] = {
    { "CollectionProfiles",   0x00, 0x05 },
    { "SchedulerProfile",     0x00, 0x06 },
    { "UploadSchedule",       0x00, 0x07 },
    { "MetricsBufferProfile", 0x00, 0x08 },
    { "MetricBufferItem",     0x00, 0x09 },
    { "PackageProfiles",      0x00, 0x0a },
    { "PackageProfile",       0x00, 0x0b },
    { "SnapshotStartList",    0x00, 0x0c },
    { "SnapshotStartItem",    0x00, 0x0d },
    { "SnapshotEndList",      0x00, 0x0e },
    { "SnapshotEndItem",      0x00, 0x0f },
    { "AggregateList",        0x00, 0x10 },
    { "AggregateItem",        0x00, 0x11 },
    { "ScriptFSM",            0x00, 0x12 },
    { "ScriptState",          0x00, 0x13 },
    { "StartAction",          0x00, 0x14 },
    { "Transitions",          0x00, 0x15 },
    { "Transition",           0x00, 0x16 },
    { "ParameterMap",         0x00, 0x17 },
    { "Param",                0x00, 0x18 },
    { "Connections",          0x00, 0x19 },
    { "Connection",           0x00, 0x1a },
    { "DefaultSettings",      0x00, 0x1b },

    { NULL,                   0x00, 0x00 }
};

/* Attribute names and ids. */
const WBXMLAttrEntry sv_ciq_ota_attr_table[] = {
    { "RetryCount",                 NULL, 0x00, 0x05 },
    { "RetryTimer",                 NULL, 0x00, 0x06 },
    { "UploadDays",                 NULL, 0x00, 0x07 },
    { "UploadPeriod",               NULL, 0x00, 0x08 },
    { "StartTime",                  NULL, 0x00, 0x09 },
    { "Duration",                   NULL, 0x00, 0x0a },
    { "HoldoffTime",                NULL, 0x00, 0x0b },
    { "MetricID",                   NULL, 0x00, 0x0c },
    { "BufferSize",                 NULL, 0x00, 0x0d },
    { "SamplingRate",               NULL, 0x00, 0x0e },
    { "BufferPriority",             NULL, 0x00, 0x0f },
    { "StartTrigger",               NULL, 0x00, 0x10 },
    { "EndTrigger",                 NULL, 0x00, 0x11 },
    { "AbortTrigger",               NULL, 0x00, 0x12 },
    { "ArchiveBufferPriority",      NULL, 0x00, 0x13 },
    { "ReservedArchiveSpace",       NULL, 0x00, 0x14 },
    { "UploadPriority",             NULL, 0x00, 0x15 },
    { "NumBefore",                  NULL, 0x00, 0x16 },
    { "NumAfter",                   NULL, 0x00, 0x17 },
    { "NumType",                    NULL, 0x00, 0x18 },
    { "Offset",                     NULL, 0x00, 0x19 },
    { "Size",                       NULL, 0x00, 0x1a },
    { "CauseImmediateUpload",       NULL, 0x00, 0x1b },
    { "MaxWaitForCount",            NULL, 0x00, 0x1c },
    { "UploadReasons",              NULL, 0x00, 0x1d },
    { "UploadUrl",                  NULL, 0x00, 0x1e },
    { "PackageName",                NULL, 0x00, 0x1f },
    { "ScriptStateId",              NULL, 0x00, 0x20 },
    { "ActionType",                 NULL, 0x00, 0x21 },
    { "ActionKey",                  NULL, 0x00, 0x22 },
    { "ActionInterval",             NULL, 0x00, 0x23 },
    { "ActionTimer",                NULL, 0x00, 0x24 },
    { "TransitionEvent",            NULL, 0x00, 0x25 },
    { "TransitionNextStateId",      NULL, 0x00, 0x26 },
    { "MinValue",                   NULL, 0x00, 0x27 },
    { "BucketSize",                 NULL, 0x00, 0x28 },
    { "NumBuckets",                 NULL, 0x00, 0x29 },
    { "TransitionLoopCount",        NULL, 0x00, 0x2a },
    { "TransitionLoopStateId",      NULL, 0x00, 0x2b },
    { "AddUniqueKey",               NULL, 0x00, 0x2c },
    { "ActionTimerMin",             NULL, 0x00, 0x2d },
    { "ActionTimerMax",             NULL, 0x00, 0x2e },
    { "TransitionLoopCountMin",     NULL, 0x00, 0x2f },
    { "TransitionLoopCountMax",     NULL, 0x00, 0x30 },
    { "DeleteAfterFailureCount",    NULL, 0x00, 0x31 },
    { "MaxConnectCount",            NULL, 0x00, 0x32 },
    { "DisableExternalMetrics",     NULL, 0x00, 0x33 },
    { "Flags",                      NULL, 0x00, 0x34 },
    { "DiscardIf",                  NULL, 0x00, 0x35 },
    { "Version",                    NULL, 0x00, 0x36 },
    { "Compression",                NULL, 0x00, 0x37 },
    { "Name",                       NULL, 0x00, 0x38 },
    { "MetricCount",                NULL, 0x00, 0x39 },
    { "AvgMetricSize",              NULL, 0x00, 0x3a },
    { "Value",                      NULL, 0x00, 0x3b },
    { "PackageTimeout",             NULL, 0x00, 0x3c },
    { "MaxPackageSize",             NULL, 0x00, 0x3d },
    { "SnapshotTriggers",           NULL, 0x00, 0x3e },
    { "InactivityTimeout",          NULL, 0x00, 0x3f },
    { "Reserved_x40_ExtI0",         NULL, 0x00, 0x40 },
    { "Reserved_x41_ExtI1",         NULL, 0x00, 0x41 },
    { "Reserved_x42_ExtI2",         NULL, 0x00, 0x42 },
    { "Reserved_x43_Pi",            NULL, 0x00, 0x43 },
    { "Reserved_x44_LiteralC",      NULL, 0x00, 0x44 },
    { "Proxy",                      NULL, 0x00, 0x45 },
    { "KeepFirst",                  NULL, 0x00, 0x46 },
    { "KeepLast",                   NULL, 0x00, 0x47 },
    { "ArchiveFullHeadroom",        NULL, 0x00, 0x48 },
    { "NetworkAvailableRetryCount", NULL, 0x00, 0x49 },
    { "ProxyAuthentication",        NULL, 0x00, 0x4a },
    { "BridgePackageTimeout",       NULL, 0x00, 0x4b },
    { "Anonymous",                  NULL, 0x00, 0x4c },

    { NULL,                         NULL, 0x00, 0x00 }
};

/* Enumerated attribute value strings and ids. */
const WBXMLAttrValueEntry sv_ciq_ota_attr_value_table[] = {
    { "Week",         0x00, 0x85 },
    { "Month",        0x00, 0x86 },
    { "Year",         0x00, 0x87 },
    { "Once",         0x00, 0x88 },
    { "Seconds",      0x00, 0x89 },
    { "Metrics",      0x00, 0x8a },
    { "val_true",     0x00, 0x8b },
    { "val_false",    0x00, 0x8c },
    { "HashWeek",     0x00, 0x8d },
    { "Press",        0x00, 0x8e },
    { "Hold",         0x00, 0x8f },
    { "Release",      0x00, 0x90 },
    { "Trigger",      0x00, 0x91 },
    { "TIME",         0x00, 0x92 },
    { "Empty",        0x00, 0x93 },
    { "Insufficient", 0x00, 0x94 },
    { "InArchive",    0x00, 0x95 },
    { "OTA",          0x00, 0x96 },

    { NULL,           0x00, 0x00 }
};

/* A bogus table to drive libwbxml's parser. */
const WBXMLLangEntry sv_ciq_ota_table[] = {
    {
      LANG_CIQ_OTA,
      &sv_ciq_ota_public_id,
      sv_ciq_ota_tag_table,
      NULL,
      sv_ciq_ota_attr_table,
      sv_ciq_ota_attr_value_table,
      NULL,
    },
};

/* Context to carry along through parse callbacks. */
typedef struct {
    int indent;  /* Current indentation level. */
} ParseContext;

/* Print spaces. */
static void indent(int n)
{
    int i = 0;
    for (i = 0; i < n; i++) {
        putchar(' ');
    }
}

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

/**
 * Called at the start of an element.
 */
static void start_element(
        void *vctx,
        WBXMLTag *local_name,
        WBXMLAttribute **attrs,
        WB_BOOL empty)
{
    ParseContext *ctx = (ParseContext *)vctx;
    int start_col;
    assert(local_name);
    assert(local_name->type == WBXML_VALUE_TOKEN);
    indent(ctx->indent);
    printf("<%s", wbxml_tag_get_xml_name(local_name));
    start_col = ctx->indent +
        strlen((const char *)wbxml_tag_get_xml_name(local_name)) + 2;
    if (attrs) {
        WBXMLAttribute *attr;
        int i;
        for (i = 0; (attr = attrs[i]); i++) {
            assert(attr->name->type == WBXML_VALUE_TOKEN);
            if (i == 0) {
                indent(1);
            } else {
                putchar('\n');
                indent(start_col);
            }
            printf("%s=\"%s\"",
                   wbxml_attribute_name_get_xml_name(attr->name),
                   wbxml_attribute_get_xml_value(attr));
        }
    }
    if (empty) {
        printf(" />\n");
    } else {
        printf(">\n");
        ctx->indent += TAB_WIDTH;
    }
}

/* Called when an element is closed. */
static void end_element(void *vctx,
                        WBXMLTag *local_name,
                        WB_BOOL empty)
{
    ParseContext *ctx = (ParseContext *)vctx;
    if (empty) {
        return;
    }
    assert(local_name);
    assert(local_name->type == WBXML_VALUE_TOKEN);
    ctx->indent -= TAB_WIDTH;
    indent(ctx->indent);
    printf("</%s>\n", wbxml_tag_get_xml_name(local_name));
}

/* Called to handle character data. */
static void cdata(void *vctx,
                  WB_UTINY *ch,
                  WB_ULONG start,
                  WB_ULONG length)
{
    int i, new_line = 0;
    ParseContext *ctx = (ParseContext *)vctx;
    indent(ctx->indent);
    for (i = start; i != start + length; i++) {
        if (new_line && ch[i] != 0x0a) {
            indent(ctx->indent);
        }
        putchar(ch[i]);
        new_line = ch[i] == 0x0a;
    }
}

/* Parses a wrapped WBXML document in data. */
static int parse(char *data, long size)
{
    WBXMLParser *parser;
    WBXMLError err;
    ParseContext ctx = { 0 };
    static WBXMLContentHandler content_handler = {
        NULL,            /* Start document handler. */
        NULL,            /* End document handler. */
        start_element,   /* Start element handler. */
        end_element,     /* End element handler. */
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
    wbxml_parser_set_user_data(parser, &ctx);
    /* The public id in these files is bogus. They use a custom DTD. */
    wbxml_parser_set_main_table(parser, sv_ciq_ota_table);
    wbxml_parser_set_language(parser, LANG_CIQ_OTA);
    err = wbxml_parser_parse(parser, (WB_UTINY *)(data + HEADER_LENGTH),
                (WB_ULONG)(size - HEADER_LENGTH));
    wbxml_parser_destroy(parser);
    if (err != WBXML_OK) {
        fprintf(stderr, "wbxml: %s\n", wbxml_errors_string(err));
        return 1;
    }
    return 0;
}

int main(int argc, char **argv)
{
    char *data;
    long size;
    if (argc != 2) {
        fprintf(stderr, "Usage: iqiq FILE.pro\n");
        return 1;
    }
    if (!(data = slurp(argv[1], &size))) {
        fprintf(stderr, "Error reading file %s\n", argv[1]);
        return 1;
    }
    parse(data, size);
    free(data);
    return 0;
}

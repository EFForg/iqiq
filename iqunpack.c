/*
 * Carrier IQ archived profile decompressor
 * Copyright (c) 2011 Dan Rosenberg (@djrbliss)
 * Licensed Under the GNU General Public License version 2.0
 *
 * This tool will iterate through the files contained in an "archive.img" whefs
 * container, identify if any of them are compressed Carrier IQ profiles, and if
 * so, will decompress the profile and write it to the specified output file.
 *
 * Must be linked against libwhefs with WHEFS_ID_TYPE_BITS defined as 32
 *
 * Usage: ./IQunpack [archive.img] [outfile]
 */

#include <sys/fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "whio/whio_config.h"
#include "whefs/whefs.h"
#include "whefs_inode.h"

/* Decompression routine */
int lzUncompress(unsigned char *input, unsigned char *output, int len, int outlen)
{

	unsigned char *inptr, *outptr, *end, c, tmp;
	unsigned int num;
	unsigned long offset;
	int i;

	inptr = input + 4;	/* Skip magic number */
	outptr = output;
	end = input + len;

	/* Skip initial length value */
	while (*inptr > 0x7f) inptr++;
	inptr++;

	/* Main decompression loop */	
	while (inptr < end) {

		c = *inptr++;

		if (c > 0x7f) {

			tmp = *inptr++;

			offset = tmp & 0x7f;

			if (tmp > 0x7f) {

				tmp = *inptr++;
				offset |= ((tmp & 0x7f) << 7);

				if (tmp > 0x7f) {
					tmp = *inptr++;
					offset |= ((tmp & 0x7f) << 15);
				}
			}
			
			offset = ~offset;

			for (i = 0; i <= ((c & 0x7f) + 1); i++) {

				if (&outptr[i] > &output[outlen - 1])
					return 1;

				outptr[i] = outptr[offset + i];
			}

			outptr += ((c & 0x7f) + 2);

		} else {

			num = 0x55 + (inptr - input);

			for (i = 0; i < c; i++) {
				
				if (outptr > &output[outlen - 1])
					return 1;
				
				*outptr++ = (*inptr++) ^ num;
				num++;
			}
		}
	}

	return 0;

}

/* Parse out how large this will be when decompressed. */
int lzParseSize(unsigned char *input)
{

	int total;

	total = input[0] & 0x7f;

	if (input[0] < 0x80)
		return total;

	total |= ((input[1] & 0x7f) << 7);

	if (input[1] < 0x80)
		return total;

	total |= ((input[2] & 0x7f) << 15);

	return total;

}
			
int handleProfile(whefs_file *file, const char *outfile)
{

	int ret, len, fd;
	unsigned char *input, *output;
	whefs_file_stats st;

	ret = whefs_fstat(file, &st);

	if (ret != whefs_rc.OK) {
		printf("[-] fstat on profile failed.\n");
		return 1;
	}

	input = malloc(st.bytes);

	if (!input) {
		printf("[-] Failed to allocate input buffer.\n");
		return 1;
	}

	ret = whefs_fseek(file, 0, SEEK_SET);
				
	if (ret != whefs_rc.OK) {
		printf("[-] fseek on profile failed.\n");
		return 1;
	}

	ret = whefs_fread(file, 1, st.bytes, input);

	if (ret != st.bytes) {
		printf("[-] Failed to read profile.\n");
		return 1;
	}

	len = lzParseSize(input + 8);

	printf("[+] Decompressed length is %u bytes.\n", len);

	output = malloc(len + 4);

	if (!output) {
		printf("[-] Failed to allocate output buffer.\n");
		return 1;
	}

	/* Preserve the first four characters of the file */
	memcpy(output, "\x82\x29\x09\x00", 4);

	ret = lzUncompress(input + 4, output + 4, st.bytes - 4, len);

	if (ret) {
		printf("[-] Failed to decompress buffer.\n");
		free(output);
		free(input);
		return 1;
	}

	free(input);

	fd = open(outfile, O_WRONLY | O_CREAT, 0644);

	if (fd < 0) {
		printf("[-] Failed to open output file.\n");
		free(output);
		return 1;
	}

	if (write(fd, output, len + 4) != len + 4) {
		printf("[-] Writing to output file failed.\n");
		free(output);
		return 1;
	}

	close(fd);
	free(output);

	printf("[+] Successfully wrote decompressed profile to %s.\n", outfile);

	return 0;
}

int main(int argc, const char **argv)
{

	int i, ret;
	char buf[WHEFS_MAX_FILENAME_LENGTH + 1] = {0};
	unsigned char header[8];
	whefs_inode n;
	whefs_fs *fs;
	whefs_string name;
	whefs_file *file;

	if (argc != 3) {
		printf("[-] Usage: ./IQunpack [archive.img] [output]\n");
		return 1;
	}

	/* Initialize whefs */
	ret = whefs_openfs(argv[1], &fs, 0);
	
	if (ret != whefs_rc.OK) {
		printf("[-] Failed to open archive.img.\n");
		return 1;
	}

	/* Iterate over all the inodes in the filesystem */
	for (i = 0; i <= whefs_fs_options_get(fs)->inode_count; i++) {

		ret = whefs_inode_id_read(fs, i, &n);

		/* For some reason some of the inodes return an error... */		
		if (whefs_rc.OK != ret)
			continue;

		name.string = buf;
		name.alloced = WHEFS_MAX_FILENAME_LENGTH + 1;

		/* Get the inode name */
		ret = whefs_inode_name_get(fs, n.id, &name);

		if (ret != whefs_rc.OK)
			continue;

		/* We have a file, let's check it out... */
		if (name.length) {

			file = whefs_fopen(fs, name.string, "rb");

			if (!file) {
				printf("[-] Failed to open file.\n");
				continue;
			}

			ret = whefs_fread(file, 1, 8, header);

			if (ret != 8) {
				whefs_fclose(file);
				continue;
			}

			/* Found it! */
			if (!memcmp(&header[4], "ZLQI", 4)) {
				
				printf("[+] Found profile in \"%s\"!\n", name.string);

				ret = handleProfile(file, argv[2]);

				if (ret) {
					printf("[-] Failed to parse profile.\n");
					whefs_fclose(file);
					return 1;
				}
			}
			whefs_fclose(file);
		}
	}
	return 0;
}

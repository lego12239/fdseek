/*
 * Version 1.0.1
 *
 * Copyright 2023 Oleg Nemanov <lego12239@yandex.ru>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#define _FILE_OFFSET_BITS 64
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <strings.h>
#include <errno.h>
#include <stdlib.h>


#define VERSION "1.0.1"
#define ERR_OUT(fmt, ...) fprintf(stderr, fmt "\n", ##__VA_ARGS__)
#define ERR_EXIT(fmt, ...) do {\
  ERR_OUT(fmt, ##__VA_ARGS__);\
  exit(1);\
  } while (0)


void
show_usage(void)
{
	printf("Usage: fdseek FD [OFFSET [WHENCE]]\n");
	printf("Usage: fdseek [OPTIONS]\n\n");
	printf("If OFFSET and WHENCE are absent, then show current fd offset.\n");
	printf("If OFFSET is present, then set fd offset relative to WHENCE.\n");
	printf("WHENCE is one of START|start, CUR|cur or END|end.\n");
	printf("WHENCE by default is 'start'.\n");
	printf("OPTIONS:\n");
	printf("  -h    show this help\n");
	printf("  -v    show a version\n\n");
	printf("License: BSD-3-Clause\n");
}

void
show_version(void)
{
	printf("%s\n", VERSION);
}

void
main(int argc, char **argv)
{
	char *ptr;
	long int fd;
	off_t off = 0;
	int whence = SEEK_CUR;

	if ((argc < 2) || (argc > 4)) {
		show_usage();
		exit(1);
	}

	if (argv[1][0] == '-') {
		if (strcmp(argv[1], "-h") == 0) {
			show_usage();
			exit(0);
		}
		if (strcmp(argv[1], "-v") == 0) {
			show_version();
			exit(0);
		}
		ERR_EXIT("Wrong option: %s", argv[1]);
	}

	fd = strtol(argv[1], &ptr, 10);
	if (*ptr != '\0') {
		ERR_EXIT("fd should be a number: %s", argv[1]);
	}
	if (fd < 0) {
		ERR_EXIT("fd can't be negative: %ld", fd);
	}
	if (argc > 2) {
		off = strtol(argv[2], &ptr, 10);
		if (*ptr != '\0') {
			ERR_EXIT("Offset should be a number: %s", argv[2]);
		}
		whence = SEEK_SET;
	}
	if (argc == 4) {
		if (strcasecmp(argv[3], "start") == 0) {
			whence = SEEK_SET;
		} else if (strcasecmp(argv[3], "cur") == 0) {
			whence = SEEK_CUR;
		} else if (strcasecmp(argv[3], "end") == 0) {
			whence = SEEK_END;
		} else {
			ERR_EXIT("Whence should be one of 'start', 'cur' or 'end': %s", argv[3]);
		}
	}

	off = lseek(fd, off, whence);
	if (off == -1) {
		ERR_EXIT("lseek() error: %s", strerror(errno));
	}
	printf("%ld\n", off);

	exit(0);
}


#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/errno.h>
#include <sys/stat.h>

/*
  argv[0] = pgm name
  argv[1] = data file name
  argv[2] = output file name
*/
int main(int argc, char **argv)
{
    if (argc < 3) {
        fprintf(stderr, "Missing file args: datafile, outfile\n");
        exit(EXIT_FAILURE);
    }

    FILE *data_fp, *out_fp;
    unsigned char buf[1];
    size_t bytes = 0;

    errno = 0;
    data_fp = fopen(argv[1], "rb");
    if (data_fp == NULL) {
        fprintf(stderr, "fopen %s failure: %s\n",
                argv[1],
                strerror(errno));
        exit(EXIT_FAILURE);
    }
    struct stat st;
    int data_fd = fileno(data_fp);    // get file descriptor
    fstat(data_fd, &st);
    off_t char_ct = st.st_size;

    errno = 0;
    out_fp = fopen(argv[2], "w");
    if (out_fp == NULL) {
        fprintf(stderr, "fopen %s failure: %s\n",
                argv[2],
                strerror(errno));
        exit(EXIT_FAILURE);
    }

    fprintf(out_fp, "#include \"passes/intrinsics-module.h\"\n");
    fprintf(out_fp, "\n");
    fprintf(out_fp, "static const char theModule[%lld] = {\n", char_ct + 1);

    while ((bytes = fread(buf, 1, 1, data_fp)) == 1) {
        fprintf(out_fp, "0x%02x,", *buf);
        /* fprintf(out_fp, "%02d,", buf[0]); */
    }
    fprintf(out_fp, "0x00\n");
    /* fprintf(out_fp, "0\n"); */
    fprintf(out_fp, "};\n");

    fprintf(out_fp, "\n");
    fprintf(out_fp, "namespace wasm {\n");
    fprintf(out_fp, "const char* IntrinsicsModuleWast = theModule;\n");
    fprintf(out_fp, "}\n");

    fclose(data_fp);
    fclose(out_fp);
    exit(EXIT_SUCCESS);
}

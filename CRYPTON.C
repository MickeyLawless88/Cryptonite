#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <conio.h>

/* --- Function Prototypes --- */
/* Fixes warnings about functions called with no prototype. */
void print_banner(void);
void show_usage(void);


void print_banner() {
    printf(" *********************************************************** \n");
    printf(" *                                                         * \n");
    printf(" *  ###  ####  #   # ####  #####  ###  #   # # ##### ##### * \n");
    printf(" * #   # #   #  # #  #   #   #   #   # ##  # #   #   #     * \n");
    printf(" * #     ####    #   ####    #   #   # # # # #   #   ###   * \n");
    printf(" * #   # #   #   #   #       #   #   # #  ## #   #   #     * \n");
    printf(" *  ###  #   #   #   #       #    ###  #   # #   #   ##### * \n");
    printf(" *                                                         * \n");
    printf(" *********************************************************** \n");
}

void show_usage() {
    printf("\n-> Coder <-   v2.0    September 25, 2025  Mickey Lawless.\n\n");
    printf("This program will encode and then decode an ASCII file\n\n");
    printf("Usage: CODER mode filename.ext password\n\n");
    printf("Example: CRYPTON DECODE MYFILE.TXT MYPASSWORD\n");
    printf("         CRYPTON ENCODE MYFILE.TXT MYPASSWORD\n");
}

int main(int argc, char *argv[]) {
    /* --- Variable Declarations --- */
    /* All variables must be declared at the top in old C compilers. */
    char md[10], nme[256], pwd_str[256];
    char temp_name[] = "COPY.DAT";
    long pwd = 0;
    char a;
    FILE *in_file, *out_file;
    int lne = 0;
    char line_buffer[1024];
    int i; /* Fixes "Undefined symbol 'i'" error. */


    print_banner();

    if (argc != 4) {
        show_usage();
        return 1;
    }

    strcpy(md, argv[1]);
    strcpy(nme, argv[2]);
    strcpy(pwd_str, argv[3]);

    /* This loop syntax is correct. The error was from declaring 'i' later. */
    for (i = 0; pwd_str[i] != '\0'; i++) {
        pwd += pwd_str[i];
    }

    printf("\n\n-> Coder <-  v2.0    September 15, 2025 Mickey L.\n\n");
    printf("Mode:       %s\n", md);
    printf("Filename:   %s\n", nme);
    printf("Password:   %s\n\n", pwd_str);
    printf("Is this correct? (Y/N)? ");

    do {
        a = getch();
    } while (toupper(a) != 'Y' && toupper(a) != 'N');

    if (toupper(a) == 'N') {
        printf("No\n");
        return 1;
    }
    printf("Yes\n");

    if (stricmp(md, "ENCODE") == 0) {
        printf("\nEncoding %s\n\n", nme);
        out_file = fopen(temp_name, "w");
        in_file = fopen(nme, "r");

        if (in_file == NULL) {
            printf("Error opening input file.\n");
            if(out_file) fclose(out_file);
            return 1;
        }

        while (fgets(line_buffer, sizeof(line_buffer), in_file) != NULL) {
            int x = strlen(line_buffer);
            if(x > 0 && line_buffer[x-1] == '\n') {
                 line_buffer[x-1] = '\0';
                 x--;
            }

            for (i = 0; i < x; i++) {
                int start = (unsigned char)line_buffer[i];
                if (start > 126 || start < 32) {
                    fputc(start, out_file);
                } else {
                    /* Explicit cast (int)pwd fixes "Conversion may lose digits" warning */
                    int cdd = start + (int)pwd + (i + 1);
                    while (cdd > 220) cdd -= 188;
                    while (cdd > 126) cdd -= 94;
                    fputc(cdd, out_file);
                }
            }
            fputc('\n', out_file);
            lne++;
            printf("\rLine: %d", lne);
        }

        fclose(in_file);
        fclose(out_file);
        remove(nme); /* Using remove() which is standard and declared in stdio.h */
        rename(temp_name, nme);

        printf("\n\nEncoding Complete!\n");
        printf("-> Coder <-\n");

    } else if (stricmp(md, "DECODE") == 0) {
        printf("\nDECODING %s\n\n", nme);
        out_file = fopen(temp_name, "w");
        in_file = fopen(nme, "r");

        if (in_file == NULL) {
            printf("Error opening input file.\n");
            if(out_file) fclose(out_file);
            return 1;
        }

        while (fgets(line_buffer, sizeof(line_buffer), in_file) != NULL) {
            int x = strlen(line_buffer);
             if(x > 0 && line_buffer[x-1] == '\n') {
                 line_buffer[x-1] = '\0';
                 x--;
            }

            for (i = 0; i < x; i++) {
                int start = (unsigned char)line_buffer[i];
                if (start > 126 || start < 32) {
                    fputc(start, out_file);
                } else {
                    /* Explicit cast (int)pwd fixes "Conversion may lose digits" warning */
                    int ucdd = start - (int)pwd - (i + 1);
                    if (ucdd < -250) ucdd += 282;
                    if (ucdd < -156) ucdd += 188;
                    while (ucdd < 32) ucdd += 94;
                    fputc(ucdd, out_file);
                }
            }
             fputc('\n', out_file);
            lne++;
            printf("\rLine: %d", lne);
        }

        fclose(in_file);
        fclose(out_file);
        remove(nme); /* Using remove() to fix 'unlink' warning */
        rename(temp_name, nme);

        printf("\n\nDECODING COMPLETE\n");
        printf("-> Coder <-\n");

    } else {
        show_usage();
        return 1;
    }

    return 0;
}
#include <stdio.h>
#include <zint.h>
#include <string.h>
int main(int argc, char **argv)
{
    struct zint_symbol *my_symbol;
    int error = 0;
    int row, col, i;
    int r, g, b;
    my_symbol = ZBarcode_Create();
    my_symbol->symbology = BARCODE_QRCODE;
    error = ZBarcode_Encode(my_symbol,(unsigned char*)"我是二维码哦我是二维码哦我是二维码哦我是二维码哦我是二维码哦我是二维码哦我是二维码哦", 0);
    error = ZBarcode_Buffer(my_symbol, 0);

    i = 0;
    for (row = 0; row < my_symbol->bitmap_height; row++){
        for(col = 0; col < my_symbol->bitmap_width; col++){
            r = my_symbol->bitmap[i];
            g = my_symbol->bitmap[i+1];
            b = my_symbol->bitmap[i+2];
            i += 3;
        }
    }

    printf("data length:%d, width:%d, height:%d\n", i, my_symbol->bitmap_width, my_symbol->bitmap_height);

    if(error != 0){
        /* some error occurred */
        printf("%s\n", my_symbol->errtxt);
    }

    if(error > WARN_INVALID_OPTION){
        ZBarcode_Delete(my_symbol);
        return 1;
    }
    /* otherwise carry on with the rest of the application */
    ZBarcode_Delete(my_symbol);
    return 0;
}

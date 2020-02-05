// pch.cpp: 与预编译标头对应的源文件

#include "pch.h"

// 当使用预编译的头时，需要使用此源文件，编译才能成功。
int Capture(LPCSTR filename, int x, int y, int w, int h)
{
    int ret = 0;

    HDC hdcScreen = GetDC(NULL);                        // 全屏幕DC
    HDC hdcMemDC = CreateCompatibleDC(hdcScreen);       // 创建兼容内存DC


    if (!hdcMemDC)
    {

        //if (0 != hbmScreen) { DeleteObject(hbmScreen); }
        if (0 != hdcMemDC) { DeleteObject(hdcMemDC); }
        ReleaseDC(NULL, hdcScreen);
        return 1;
    }

    //int width = GetSystemMetrics(SM_CXSCREEN);          // 屏幕宽
    //int height = GetSystemMetrics(SM_CYSCREEN);         // 屏幕高

    HBITMAP hbmScreen = CreateCompatibleBitmap(hdcScreen, w, h);   // 通过窗口DC 创建一个兼容位图
    if (!hbmScreen)
    {
        ret = 2;
        if (0 != hbmScreen) { DeleteObject(hbmScreen); }
        if (0 != hdcMemDC) { DeleteObject(hdcMemDC); }
        ReleaseDC(NULL, hdcScreen);
        return 2;
    }

    SelectObject(hdcMemDC, hbmScreen);

    //-----------------------------------------------------


    if (!BitBlt(
        hdcMemDC,    // 目的DC
        0, 0,        // 目的DC的 x,y 坐标
        w, h,         //width, height, // 目的 DC 的宽高
        hdcScreen,   // 来源DC
        x, y,        //0, 0,        // 来源DC的 x,y 坐标
        SRCCOPY))    // 粘贴方式
    {
        ret = 3;
        if (0 != hbmScreen) { DeleteObject(hbmScreen); }
        if (0 != hdcMemDC) { DeleteObject(hdcMemDC); }
        ReleaseDC(NULL, hdcScreen);
        return 3;
    }


    BITMAP bmpScreen;
    GetObject(hbmScreen, sizeof(BITMAP), &bmpScreen);       // 获取位图信息并存放在 bmpScreen 中


    //-----------------------------------------------------
    BITMAPINFOHEADER bi;
    bi.biSize = sizeof(BITMAPINFOHEADER);
    //bi.biWidth = bmpScreen.bmWidth;
    //bi.biHeight = bmpScreen.bmHeight;
    bi.biWidth = w;
    bi.biHeight = h;
    bi.biPlanes = 1;
    bi.biBitCount = 32;
    bi.biCompression = BI_RGB;
    bi.biSizeImage = 0;
    bi.biXPelsPerMeter = 0;
    bi.biYPelsPerMeter = 0;
    bi.biClrUsed = 0;
    bi.biClrImportant = 0;


    //-----------------------------------------------------
    //DWORD dwBmpSize = ((bmpScreen.bmWidth * bi.biBitCount + 31) / 32) * bmpScreen.bmHeight * 4;             //计算出占用字节大小
    DWORD dwBmpSize = ((w * bi.biBitCount + 31) / 32) * h * 4;             //计算出占用字节大小
    HANDLE hDIB = GlobalAlloc(GHND, dwBmpSize);

    if (0 == hDIB)
    {
        if (0 != hbmScreen) { DeleteObject(hbmScreen); }
        if (0 != hdcMemDC) { DeleteObject(hdcMemDC); }
        return 4;
    }

    char* lpbitmap = (char*)GlobalLock(hDIB);

    

    GetDIBits(
        hdcScreen,                  // 设备环境句柄
        hbmScreen,                   // 位图句柄
        0,                          // 指定检索的第一个扫描线
        //(UINT)bmpScreen.bmHeight,   // 指定检索的扫描线数
        h,
        lpbitmap,                    // 指向用来检索位图数据的缓冲区的指针
        (BITMAPINFO*)&bi,           // 该结构体保存位图的数据格式
        DIB_RGB_COLORS              // 颜色表由红、绿、蓝（RGB）三个直接值构成
    );



    //-----------------------------------------------------
    /*
    
     HANDLE hFile = CreateFile(
        filename,
        GENERIC_WRITE,
        0,
        NULL,
        CREATE_ALWAYS,
        FILE_ATTRIBUTE_NORMAL,
        NULL
    );   
    */

    HANDLE hFile = CreateFileA(
        filename,
        GENERIC_WRITE,
        0,
        NULL,
        CREATE_ALWAYS,
        FILE_ATTRIBUTE_NORMAL,
        NULL
    );

    if ((HANDLE)-1 == hFile)
    {

        GlobalUnlock(hDIB);
        GlobalFree(hDIB);
        if (0 != hbmScreen) { DeleteObject(hbmScreen); }
        if (0 != hdcMemDC) { DeleteObject(hdcMemDC); }
        ReleaseDC(NULL, hdcScreen);
        return 5;
    }


    BITMAPFILEHEADER    bmfHeader;
    DWORD               dwBytesWritten;
    DWORD               dwSizeofDIB;

    dwBytesWritten = 0;
    dwSizeofDIB = dwBmpSize + sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);              // 将 图片头(headers)的大小, 加上位图的大小来获得整个文件的大小
    bmfHeader.bfOffBits = (DWORD)sizeof(BITMAPFILEHEADER) + (DWORD)sizeof(BITMAPINFOHEADER);    // 设置 Offset 偏移至位图的位(bitmap bits)实际开始的地方
    bmfHeader.bfSize = dwSizeofDIB;                                                          // 文件大小
    bmfHeader.bfType = 0x4D42;                                                                   //BM 位图的 bfType 必须是字符串 "BM"


    WriteFile(hFile, (LPSTR)&bmfHeader, sizeof(BITMAPFILEHEADER), &dwBytesWritten, NULL);
    WriteFile(hFile, (LPSTR)&bi, sizeof(BITMAPINFOHEADER), &dwBytesWritten, NULL);
    WriteFile(hFile, (LPSTR)lpbitmap, dwBmpSize, &dwBytesWritten, NULL);

    GlobalUnlock(hDIB);
    GlobalFree(hDIB);
    CloseHandle(hFile);
    DeleteObject(hbmScreen);
    DeleteObject(hdcMemDC);
    ReleaseDC(NULL, hdcScreen);
    return 0;
}
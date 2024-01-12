#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <stdarg.h>
#include "utils.h"
#include "libsce_defs.h"

void prefault(void *address, size_t size) {
    for(uint64_t i = 0; i < size; i++) {
        volatile uint8_t c;
        (void)c;
        
        c = ((char *)address)[i];
    }
}

void *pfmalloc(size_t size) {
    void *p = malloc(size);
    prefault(p, size);
    return p;
}

void printf_notification(const char* fmt, ...) {
    notify_request_t noti_buffer;

    va_list args;
    va_start(args, fmt);
    vsprintf(noti_buffer.message, fmt, args);
    va_end(args);

    sceKernelSendNotificationRequest(0, (notify_request_t * ) & noti_buffer, sizeof(noti_buffer), 0);
}
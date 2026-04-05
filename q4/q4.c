#include <stdio.h>      // input output
#include <dlfcn.h>      // dlopen dlsym dlclose

int main() {

    char op[20];         // op
    int a, b;           // numbers

    while (scanf("%s %d %d", op, &a, &b) == 3) {   // read

        char path[20];                          // path
        sprintf(path, "./lib%s.so", op);        // make path

        void *handle;                           // handle
        handle = dlopen(path, RTLD_LAZY);       // open
        if (handle == NULL) {
    printf("library not found\n");
    continue;
}

        int (*func)(int, int);                  // function pointer
        func = (int (*)(int, int)) dlsym(handle, op);   // get function

        int ans;                                // result
        ans = func(a, b);                       // call

        printf("%d\n", ans);                    // print

        dlclose(handle);                        // close
    }

    return 0;
}
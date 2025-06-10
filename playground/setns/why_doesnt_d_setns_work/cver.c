#define _GNU_SOURCE
#include <stdio.h>
#include <fcntl.h>
#include <sched.h>
#include <unistd.h>

void changeNetNs()
{
    int fd = open("/proc/12135/ns/net", O_RDONLY | O_CLOEXEC);

    printf("%d\n", fd);

    int result = setns(fd, 0);

    printf("%d\n", result);
}

int main(int argc, char *argv[])
{
    changeNetNs();
    while (1){}
    execvp(argv[1], &argv[1]);
    return 1;
}


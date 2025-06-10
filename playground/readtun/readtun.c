#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <linux/if.h>
#include <linux/if_tun.h>
#include <errno.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int opentap(char *ifn)
{
    int fd;
    struct ifreq ifr = { 0 };
    if (snprintf(ifr.ifr_name, sizeof ifr.ifr_name, "%s", ifn)
            >= sizeof ifr.ifr_name) {
        errno = ENAMETOOLONG; return -1;
    }
    if ((fd = open("/dev/net/tun", O_RDWR)) == -1) return -1;
    ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
    if (ioctl(fd, TUNSETIFF, &ifr) == -1) {
        int e = errno; close(fd); errno = e; return -1;
    }
    return fd;
}

int main()
{
    int tapfd = opentap("netsim-tap");
    printf("fd: %d\n\n", tapfd);

    unsigned char buf[64];
    while (1)
    {
        int result = read(tapfd, &buf, 64);
        if (result == -1)
            break;

        for (int i = 0; i < result; i++)
            printf("%x", buf[i]);
        printf("\n");
    }
}

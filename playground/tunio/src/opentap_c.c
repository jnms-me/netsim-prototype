#include <linux/if.h>
#include <linux/if_tun.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>

const size_t OPENTAP_C_IFNAME_MAXSIZE = IFNAMSIZ;

/*
 * Return values:
 * -3 - ifname too long
 * -2 - open failed
 * -1 - ioctl failed
 *  0 - Success
 */
int opentap_c(char* ifname)
{
    int fd;

    struct ifreq ifr = { 0 };
    if (snprintf(ifr.ifr_name, sizeof ifr.ifr_name, "%s", ifname) >= sizeof ifr.ifr_name) {
        return -3;
    }
    ifr.ifr_flags = IFF_TAP | IFF_NO_PI;

    if ((fd = open("/dev/net/tun", O_RDWR)) == -1) {
        return -2;
    }

    if (ioctl(fd, TUNSETIFF, &ifr) == -1) {
        close(fd);
        return -1;
    }

    return fd;
}

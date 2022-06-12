module netsim.network.nodes.docker_utils.tap_dpp;


        import core.stdc.config;
        import core.stdc.stdarg: va_list;
        static import core.simd;
        static import std.conv;

        struct Int128 { long lower; long upper; }
        struct UInt128 { ulong lower; ulong upper; }

        struct __locale_data { int dummy; } // FIXME



alias _Bool = bool;
struct dpp {
    static struct Opaque(int N) {
        void[N] bytes;
    }
    // Replacement for the gcc/clang intrinsic
    static bool isEmpty(T)() {
        return T.tupleof.length == 0;
    }
    static struct Move(T) {
        T* ptr;
    }
    // dmd bug causes a crash if T is passed by value.
    // Works fine with ldc.
    static auto move(T)(ref T value) {
        return Move!T(&value);
    }
    mixin template EnumD(string name, T, string prefix) if(is(T == enum)) {
        private static string _memberMixinStr(string member) {
            import std.conv: text;
            import std.array: replace;
            return text(` `, member.replace(prefix, ""), ` = `, T.stringof, `.`, member, `,`);
        }
        private static string _enumMixinStr() {
            import std.array: join;
            string[] ret;
            ret ~= "enum " ~ name ~ "{";
            static foreach(member; __traits(allMembers, T)) {
                ret ~= _memberMixinStr(member);
            }
            ret ~= "}";
            return ret.join("\n");
        }
        mixin(_enumMixinStr());
    }
}

extern(C)
{

    alias size_t = c_ulong;

    int getentropy(void*, c_ulong) @nogc nothrow;

    char* crypt(const(char)*, const(char)*) @nogc nothrow;

    int fdatasync(int) @nogc nothrow;

    c_long syscall(c_long, ...) @nogc nothrow;

    void* sbrk(c_long) @nogc nothrow;

    int brk(void*) @nogc nothrow;

    int ftruncate(int, c_long) @nogc nothrow;

    int truncate(const(char)*, c_long) @nogc nothrow;

    int getdtablesize() @nogc nothrow;

    int getpagesize() @nogc nothrow;

    void sync() @nogc nothrow;

    c_long gethostid() @nogc nothrow;

    int fsync(int) @nogc nothrow;

    char* getpass(const(char)*) @nogc nothrow;

    int chroot(const(char)*) @nogc nothrow;

    int daemon(int, int) @nogc nothrow;

    void setusershell() @nogc nothrow;

    void endusershell() @nogc nothrow;

    char* getusershell() @nogc nothrow;

    int acct(const(char)*) @nogc nothrow;

    int profil(ushort*, c_ulong, c_ulong, uint) @nogc nothrow;

    int revoke(const(char)*) @nogc nothrow;

    int vhangup() @nogc nothrow;

    int setdomainname(const(char)*, c_ulong) @nogc nothrow;

    int getdomainname(char*, c_ulong) @nogc nothrow;

    int sethostid(c_long) @nogc nothrow;

    int sethostname(const(char)*, c_ulong) @nogc nothrow;

    int gethostname(char*, c_ulong) @nogc nothrow;

    int setlogin(const(char)*) @nogc nothrow;

    int getlogin_r(char*, c_ulong) @nogc nothrow;

    char* getlogin() @nogc nothrow;

    int tcsetpgrp(int, int) @nogc nothrow;

    int tcgetpgrp(int) @nogc nothrow;

    int rmdir(const(char)*) @nogc nothrow;

    int unlinkat(int, const(char)*, int) @nogc nothrow;

    int unlink(const(char)*) @nogc nothrow;

    c_long readlinkat(int, const(char)*, char*, c_ulong) @nogc nothrow;

    int symlinkat(const(char)*, int, const(char)*) @nogc nothrow;

    c_long readlink(const(char)*, char*, c_ulong) @nogc nothrow;

    int symlink(const(char)*, const(char)*) @nogc nothrow;

    int linkat(int, const(char)*, int, const(char)*, int) @nogc nothrow;

    int link(const(char)*, const(char)*) @nogc nothrow;

    int ttyslot() @nogc nothrow;

    int isatty(int) @nogc nothrow;

    int ttyname_r(int, char*, c_ulong) @nogc nothrow;

    char* ttyname(int) @nogc nothrow;

    int vfork() @nogc nothrow;

    int fork() @nogc nothrow;

    int setegid(uint) @nogc nothrow;

    int setregid(uint, uint) @nogc nothrow;

    int setgid(uint) @nogc nothrow;

    int seteuid(uint) @nogc nothrow;

    int setreuid(uint, uint) @nogc nothrow;

    int setuid(uint) @nogc nothrow;

    int getgroups(int, uint*) @nogc nothrow;

    uint getegid() @nogc nothrow;

    uint getgid() @nogc nothrow;

    uint geteuid() @nogc nothrow;

    uint getuid() @nogc nothrow;

    int getsid(int) @nogc nothrow;

    int setsid() @nogc nothrow;

    int setpgrp() @nogc nothrow;

    int setpgid(int, int) @nogc nothrow;

    int getpgid(int) @nogc nothrow;

    int __getpgid(int) @nogc nothrow;

    int getpgrp() @nogc nothrow;

    int getppid() @nogc nothrow;

    int getpid() @nogc nothrow;

    c_ulong confstr(int, char*, c_ulong) @nogc nothrow;

    c_long sysconf(int) @nogc nothrow;

    c_long fpathconf(int, int) @nogc nothrow;

    c_long pathconf(const(char)*, int) @nogc nothrow;

    void _exit(int) @nogc nothrow;

    int nice(int) @nogc nothrow;

    int execlp(const(char)*, const(char)*, ...) @nogc nothrow;

    int execvp(const(char)*, char**) @nogc nothrow;

    int execl(const(char)*, const(char)*, ...) @nogc nothrow;

    int execle(const(char)*, const(char)*, ...) @nogc nothrow;

    int execv(const(char)*, char**) @nogc nothrow;

    int fexecve(int, char**, char**) @nogc nothrow;

    int execve(const(char)*, char**, char**) @nogc nothrow;

    extern __gshared char** __environ;

    int dup2(int, int) @nogc nothrow;

    int dup(int) @nogc nothrow;

    char* getwd(char*) @nogc nothrow;

    char* getcwd(char*, c_ulong) @nogc nothrow;

    int fchdir(int) @nogc nothrow;

    int chdir(const(char)*) @nogc nothrow;

    int fchownat(int, const(char)*, uint, uint, int) @nogc nothrow;

    int lchown(const(char)*, uint, uint) @nogc nothrow;

    int fchown(int, uint, uint) @nogc nothrow;

    int chown(const(char)*, uint, uint) @nogc nothrow;

    int pause() @nogc nothrow;

    int usleep(uint) @nogc nothrow;

    uint ualarm(uint, uint) @nogc nothrow;

    uint sleep(uint) @nogc nothrow;

    uint alarm(uint) @nogc nothrow;

    int pipe(int*) @nogc nothrow;

    c_long pwrite(int, const(void)*, c_ulong, c_long) @nogc nothrow;

    c_long pread(int, void*, c_ulong, c_long) @nogc nothrow;

    c_long write(int, const(void)*, c_ulong) @nogc nothrow;

    c_long read(int, void*, c_ulong) @nogc nothrow;

    void closefrom(int) @nogc nothrow;

    int close(int) @nogc nothrow;

    c_long lseek(int, c_long, int) @nogc nothrow;

    int faccessat(int, const(char)*, int, int) @nogc nothrow;

    int access(const(char)*, int) @nogc nothrow;

    alias intptr_t = c_long;

    alias useconds_t = uint;

    alias fsfilcnt_t = c_ulong;

    alias fsblkcnt_t = c_ulong;

    alias blkcnt_t = c_long;

    alias blksize_t = c_long;

    alias register_t = c_long;

    alias u_int64_t = c_ulong;

    alias u_int32_t = uint;

    alias u_int16_t = ushort;

    alias u_int8_t = ubyte;

    alias key_t = int;

    alias caddr_t = char*;

    alias daddr_t = int;

    alias ssize_t = c_long;

    alias id_t = uint;

    alias pid_t = int;

    alias off_t = c_long;

    alias uid_t = uint;

    alias nlink_t = c_ulong;

    alias mode_t = uint;

    alias gid_t = uint;

    alias dev_t = c_ulong;

    alias ino_t = c_ulong;

    alias loff_t = c_long;

    alias fsid_t = __fsid_t;

    alias u_quad_t = c_ulong;

    alias quad_t = c_long;

    alias u_long = c_ulong;

    alias u_int = uint;

    alias u_short = ushort;

    alias u_char = ubyte;

    int isfdtype(int, int) @nogc nothrow;

    int sockatmark(int) @nogc nothrow;

    int shutdown(int, int) @nogc nothrow;

    int accept(int, sockaddr*, uint*) @nogc nothrow;

    int listen(int, int) @nogc nothrow;

    int setsockopt(int, int, int, const(void)*, uint) @nogc nothrow;

    alias __s8 = byte;

    alias __u8 = ubyte;

    alias __s16 = short;

    alias __u16 = ushort;

    alias __s32 = int;

    alias __u32 = uint;

    alias __s64 = long;

    alias __u64 = ulong;

    int getsockopt(int, int, int, void*, uint*) @nogc nothrow;

    c_long recvmsg(int, msghdr*, int) @nogc nothrow;

    c_long sendmsg(int, const(msghdr)*, int) @nogc nothrow;

    c_long recvfrom(int, void*, c_ulong, int, sockaddr*, uint*) @nogc nothrow;

    c_long sendto(int, const(void)*, c_ulong, int, const(sockaddr)*, uint) @nogc nothrow;

    c_long recv(int, void*, c_ulong, int) @nogc nothrow;

    c_long send(int, const(void)*, c_ulong, int) @nogc nothrow;

    int getpeername(int, sockaddr*, uint*) @nogc nothrow;

    int connect(int, const(sockaddr)*, uint) @nogc nothrow;

    int getsockname(int, sockaddr*, uint*) @nogc nothrow;

    int bind(int, const(sockaddr)*, uint) @nogc nothrow;

    int socketpair(int, int, int, int*) @nogc nothrow;

    int socket(int, int, int) @nogc nothrow;

    enum _Anonymous_0
    {

        SHUT_RD = 0,

        SHUT_WR = 1,

        SHUT_RDWR = 2,
    }
    enum SHUT_RD = _Anonymous_0.SHUT_RD;
    enum SHUT_WR = _Anonymous_0.SHUT_WR;
    enum SHUT_RDWR = _Anonymous_0.SHUT_RDWR;

    int pselect(int, fd_set*, fd_set*, fd_set*, const(timespec)*, const(__sigset_t)*) @nogc nothrow;

    int select(int, fd_set*, fd_set*, fd_set*, timeval*) @nogc nothrow;

    alias fd_mask = c_long;

    struct fd_set
    {

        c_long[16] __fds_bits;
    }

    alias __fd_mask = c_long;

    alias suseconds_t = c_long;

    int ioctl(int, c_ulong, ...) @nogc nothrow;

    alias __kernel_long_t = c_long;

    alias __kernel_ulong_t = c_ulong;

    alias __kernel_ino_t = c_ulong;

    alias __kernel_mode_t = uint;

    alias __kernel_pid_t = int;

    alias __kernel_ipc_pid_t = int;

    alias __kernel_uid_t = uint;

    alias __kernel_gid_t = uint;

    alias __kernel_suseconds_t = c_long;

    alias __kernel_daddr_t = int;

    alias __kernel_uid32_t = uint;

    alias __kernel_gid32_t = uint;

    alias __kernel_size_t = c_ulong;

    alias __kernel_ssize_t = c_long;

    alias __kernel_ptrdiff_t = c_long;

    struct __kernel_fsid_t
    {

        int[2] val;
    }

    alias __kernel_off_t = c_long;

    alias __kernel_loff_t = long;

    alias __kernel_old_time_t = c_long;

    alias __kernel_time_t = c_long;

    alias __kernel_time64_t = long;

    alias __kernel_clock_t = c_long;

    alias __kernel_timer_t = int;

    alias __kernel_clockid_t = int;

    alias __kernel_caddr_t = char*;

    alias __kernel_uid16_t = ushort;

    alias __kernel_gid16_t = ushort;

    int __overflow(_IO_FILE*, int) @nogc nothrow;

    int __uflow(_IO_FILE*) @nogc nothrow;

    void funlockfile(_IO_FILE*) @nogc nothrow;

    int ftrylockfile(_IO_FILE*) @nogc nothrow;

    void flockfile(_IO_FILE*) @nogc nothrow;

    char* ctermid(char*) @nogc nothrow;

    _IO_FILE* popen(const(char)*, const(char)*) @nogc nothrow;

    int pclose(_IO_FILE*) @nogc nothrow;

    int fileno_unlocked(_IO_FILE*) @nogc nothrow;

    int fileno(_IO_FILE*) @nogc nothrow;

    void perror(const(char)*) @nogc nothrow;

    int ferror_unlocked(_IO_FILE*) @nogc nothrow;

    int feof_unlocked(_IO_FILE*) @nogc nothrow;

    void clearerr_unlocked(_IO_FILE*) @nogc nothrow;

    int ferror(_IO_FILE*) @nogc nothrow;

    int feof(_IO_FILE*) @nogc nothrow;

    void clearerr(_IO_FILE*) @nogc nothrow;

    int fsetpos(_IO_FILE*, const(_G_fpos_t)*) @nogc nothrow;

    int fgetpos(_IO_FILE*, _G_fpos_t*) @nogc nothrow;

    c_long ftello(_IO_FILE*) @nogc nothrow;

    alias __kernel_old_uid_t = ushort;

    alias __kernel_old_gid_t = ushort;

    int fseeko(_IO_FILE*, c_long, int) @nogc nothrow;

    alias __kernel_old_dev_t = c_ulong;

    void rewind(_IO_FILE*) @nogc nothrow;

    union __atomic_wide_counter
    {

        ulong __value64;

        static struct _Anonymous_1
        {

            uint __low;

            uint __high;
        }

        _Anonymous_1 __value32;
    }

    c_long ftell(_IO_FILE*) @nogc nothrow;

    static ushort __bswap_16(ushort) @nogc nothrow;

    int fseek(_IO_FILE*, c_long, int) @nogc nothrow;

    static uint __bswap_32(uint) @nogc nothrow;

    c_ulong fwrite_unlocked(const(void)*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;

    static c_ulong __bswap_64(c_ulong) @nogc nothrow;

    enum _Anonymous_2
    {

        _PC_LINK_MAX = 0,

        _PC_MAX_CANON = 1,

        _PC_MAX_INPUT = 2,

        _PC_NAME_MAX = 3,

        _PC_PATH_MAX = 4,

        _PC_PIPE_BUF = 5,

        _PC_CHOWN_RESTRICTED = 6,

        _PC_NO_TRUNC = 7,

        _PC_VDISABLE = 8,

        _PC_SYNC_IO = 9,

        _PC_ASYNC_IO = 10,

        _PC_PRIO_IO = 11,

        _PC_SOCK_MAXBUF = 12,

        _PC_FILESIZEBITS = 13,

        _PC_REC_INCR_XFER_SIZE = 14,

        _PC_REC_MAX_XFER_SIZE = 15,

        _PC_REC_MIN_XFER_SIZE = 16,

        _PC_REC_XFER_ALIGN = 17,

        _PC_ALLOC_SIZE_MIN = 18,

        _PC_SYMLINK_MAX = 19,

        _PC_2_SYMLINKS = 20,
    }
    enum _PC_LINK_MAX = _Anonymous_2._PC_LINK_MAX;
    enum _PC_MAX_CANON = _Anonymous_2._PC_MAX_CANON;
    enum _PC_MAX_INPUT = _Anonymous_2._PC_MAX_INPUT;
    enum _PC_NAME_MAX = _Anonymous_2._PC_NAME_MAX;
    enum _PC_PATH_MAX = _Anonymous_2._PC_PATH_MAX;
    enum _PC_PIPE_BUF = _Anonymous_2._PC_PIPE_BUF;
    enum _PC_CHOWN_RESTRICTED = _Anonymous_2._PC_CHOWN_RESTRICTED;
    enum _PC_NO_TRUNC = _Anonymous_2._PC_NO_TRUNC;
    enum _PC_VDISABLE = _Anonymous_2._PC_VDISABLE;
    enum _PC_SYNC_IO = _Anonymous_2._PC_SYNC_IO;
    enum _PC_ASYNC_IO = _Anonymous_2._PC_ASYNC_IO;
    enum _PC_PRIO_IO = _Anonymous_2._PC_PRIO_IO;
    enum _PC_SOCK_MAXBUF = _Anonymous_2._PC_SOCK_MAXBUF;
    enum _PC_FILESIZEBITS = _Anonymous_2._PC_FILESIZEBITS;
    enum _PC_REC_INCR_XFER_SIZE = _Anonymous_2._PC_REC_INCR_XFER_SIZE;
    enum _PC_REC_MAX_XFER_SIZE = _Anonymous_2._PC_REC_MAX_XFER_SIZE;
    enum _PC_REC_MIN_XFER_SIZE = _Anonymous_2._PC_REC_MIN_XFER_SIZE;
    enum _PC_REC_XFER_ALIGN = _Anonymous_2._PC_REC_XFER_ALIGN;
    enum _PC_ALLOC_SIZE_MIN = _Anonymous_2._PC_ALLOC_SIZE_MIN;
    enum _PC_SYMLINK_MAX = _Anonymous_2._PC_SYMLINK_MAX;
    enum _PC_2_SYMLINKS = _Anonymous_2._PC_2_SYMLINKS;

    c_ulong fread_unlocked(void*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;

    c_ulong fwrite(const(void)*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;

    c_ulong fread(void*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;

    int ungetc(int, _IO_FILE*) @nogc nothrow;

    int puts(const(char)*) @nogc nothrow;

    int fputs(const(char)*, _IO_FILE*) @nogc nothrow;

    c_long getline(char**, c_ulong*, _IO_FILE*) @nogc nothrow;

    c_long getdelim(char**, c_ulong*, int, _IO_FILE*) @nogc nothrow;

    c_long __getdelim(char**, c_ulong*, int, _IO_FILE*) @nogc nothrow;

    char* fgets(char*, int, _IO_FILE*) @nogc nothrow;

    enum _Anonymous_3
    {

        _SC_ARG_MAX = 0,

        _SC_CHILD_MAX = 1,

        _SC_CLK_TCK = 2,

        _SC_NGROUPS_MAX = 3,

        _SC_OPEN_MAX = 4,

        _SC_STREAM_MAX = 5,

        _SC_TZNAME_MAX = 6,

        _SC_JOB_CONTROL = 7,

        _SC_SAVED_IDS = 8,

        _SC_REALTIME_SIGNALS = 9,

        _SC_PRIORITY_SCHEDULING = 10,

        _SC_TIMERS = 11,

        _SC_ASYNCHRONOUS_IO = 12,

        _SC_PRIORITIZED_IO = 13,

        _SC_SYNCHRONIZED_IO = 14,

        _SC_FSYNC = 15,

        _SC_MAPPED_FILES = 16,

        _SC_MEMLOCK = 17,

        _SC_MEMLOCK_RANGE = 18,

        _SC_MEMORY_PROTECTION = 19,

        _SC_MESSAGE_PASSING = 20,

        _SC_SEMAPHORES = 21,

        _SC_SHARED_MEMORY_OBJECTS = 22,

        _SC_AIO_LISTIO_MAX = 23,

        _SC_AIO_MAX = 24,

        _SC_AIO_PRIO_DELTA_MAX = 25,

        _SC_DELAYTIMER_MAX = 26,

        _SC_MQ_OPEN_MAX = 27,

        _SC_MQ_PRIO_MAX = 28,

        _SC_VERSION = 29,

        _SC_PAGESIZE = 30,

        _SC_RTSIG_MAX = 31,

        _SC_SEM_NSEMS_MAX = 32,

        _SC_SEM_VALUE_MAX = 33,

        _SC_SIGQUEUE_MAX = 34,

        _SC_TIMER_MAX = 35,

        _SC_BC_BASE_MAX = 36,

        _SC_BC_DIM_MAX = 37,

        _SC_BC_SCALE_MAX = 38,

        _SC_BC_STRING_MAX = 39,

        _SC_COLL_WEIGHTS_MAX = 40,

        _SC_EQUIV_CLASS_MAX = 41,

        _SC_EXPR_NEST_MAX = 42,

        _SC_LINE_MAX = 43,

        _SC_RE_DUP_MAX = 44,

        _SC_CHARCLASS_NAME_MAX = 45,

        _SC_2_VERSION = 46,

        _SC_2_C_BIND = 47,

        _SC_2_C_DEV = 48,

        _SC_2_FORT_DEV = 49,

        _SC_2_FORT_RUN = 50,

        _SC_2_SW_DEV = 51,

        _SC_2_LOCALEDEF = 52,

        _SC_PII = 53,

        _SC_PII_XTI = 54,

        _SC_PII_SOCKET = 55,

        _SC_PII_INTERNET = 56,

        _SC_PII_OSI = 57,

        _SC_POLL = 58,

        _SC_SELECT = 59,

        _SC_UIO_MAXIOV = 60,

        _SC_IOV_MAX = 60,

        _SC_PII_INTERNET_STREAM = 61,

        _SC_PII_INTERNET_DGRAM = 62,

        _SC_PII_OSI_COTS = 63,

        _SC_PII_OSI_CLTS = 64,

        _SC_PII_OSI_M = 65,

        _SC_T_IOV_MAX = 66,

        _SC_THREADS = 67,

        _SC_THREAD_SAFE_FUNCTIONS = 68,

        _SC_GETGR_R_SIZE_MAX = 69,

        _SC_GETPW_R_SIZE_MAX = 70,

        _SC_LOGIN_NAME_MAX = 71,

        _SC_TTY_NAME_MAX = 72,

        _SC_THREAD_DESTRUCTOR_ITERATIONS = 73,

        _SC_THREAD_KEYS_MAX = 74,

        _SC_THREAD_STACK_MIN = 75,

        _SC_THREAD_THREADS_MAX = 76,

        _SC_THREAD_ATTR_STACKADDR = 77,

        _SC_THREAD_ATTR_STACKSIZE = 78,

        _SC_THREAD_PRIORITY_SCHEDULING = 79,

        _SC_THREAD_PRIO_INHERIT = 80,

        _SC_THREAD_PRIO_PROTECT = 81,

        _SC_THREAD_PROCESS_SHARED = 82,

        _SC_NPROCESSORS_CONF = 83,

        _SC_NPROCESSORS_ONLN = 84,

        _SC_PHYS_PAGES = 85,

        _SC_AVPHYS_PAGES = 86,

        _SC_ATEXIT_MAX = 87,

        _SC_PASS_MAX = 88,

        _SC_XOPEN_VERSION = 89,

        _SC_XOPEN_XCU_VERSION = 90,

        _SC_XOPEN_UNIX = 91,

        _SC_XOPEN_CRYPT = 92,

        _SC_XOPEN_ENH_I18N = 93,

        _SC_XOPEN_SHM = 94,

        _SC_2_CHAR_TERM = 95,

        _SC_2_C_VERSION = 96,

        _SC_2_UPE = 97,

        _SC_XOPEN_XPG2 = 98,

        _SC_XOPEN_XPG3 = 99,

        _SC_XOPEN_XPG4 = 100,

        _SC_CHAR_BIT = 101,

        _SC_CHAR_MAX = 102,

        _SC_CHAR_MIN = 103,

        _SC_INT_MAX = 104,

        _SC_INT_MIN = 105,

        _SC_LONG_BIT = 106,

        _SC_WORD_BIT = 107,

        _SC_MB_LEN_MAX = 108,

        _SC_NZERO = 109,

        _SC_SSIZE_MAX = 110,

        _SC_SCHAR_MAX = 111,

        _SC_SCHAR_MIN = 112,

        _SC_SHRT_MAX = 113,

        _SC_SHRT_MIN = 114,

        _SC_UCHAR_MAX = 115,

        _SC_UINT_MAX = 116,

        _SC_ULONG_MAX = 117,

        _SC_USHRT_MAX = 118,

        _SC_NL_ARGMAX = 119,

        _SC_NL_LANGMAX = 120,

        _SC_NL_MSGMAX = 121,

        _SC_NL_NMAX = 122,

        _SC_NL_SETMAX = 123,

        _SC_NL_TEXTMAX = 124,

        _SC_XBS5_ILP32_OFF32 = 125,

        _SC_XBS5_ILP32_OFFBIG = 126,

        _SC_XBS5_LP64_OFF64 = 127,

        _SC_XBS5_LPBIG_OFFBIG = 128,

        _SC_XOPEN_LEGACY = 129,

        _SC_XOPEN_REALTIME = 130,

        _SC_XOPEN_REALTIME_THREADS = 131,

        _SC_ADVISORY_INFO = 132,

        _SC_BARRIERS = 133,

        _SC_BASE = 134,

        _SC_C_LANG_SUPPORT = 135,

        _SC_C_LANG_SUPPORT_R = 136,

        _SC_CLOCK_SELECTION = 137,

        _SC_CPUTIME = 138,

        _SC_THREAD_CPUTIME = 139,

        _SC_DEVICE_IO = 140,

        _SC_DEVICE_SPECIFIC = 141,

        _SC_DEVICE_SPECIFIC_R = 142,

        _SC_FD_MGMT = 143,

        _SC_FIFO = 144,

        _SC_PIPE = 145,

        _SC_FILE_ATTRIBUTES = 146,

        _SC_FILE_LOCKING = 147,

        _SC_FILE_SYSTEM = 148,

        _SC_MONOTONIC_CLOCK = 149,

        _SC_MULTI_PROCESS = 150,

        _SC_SINGLE_PROCESS = 151,

        _SC_NETWORKING = 152,

        _SC_READER_WRITER_LOCKS = 153,

        _SC_SPIN_LOCKS = 154,

        _SC_REGEXP = 155,

        _SC_REGEX_VERSION = 156,

        _SC_SHELL = 157,

        _SC_SIGNALS = 158,

        _SC_SPAWN = 159,

        _SC_SPORADIC_SERVER = 160,

        _SC_THREAD_SPORADIC_SERVER = 161,

        _SC_SYSTEM_DATABASE = 162,

        _SC_SYSTEM_DATABASE_R = 163,

        _SC_TIMEOUTS = 164,

        _SC_TYPED_MEMORY_OBJECTS = 165,

        _SC_USER_GROUPS = 166,

        _SC_USER_GROUPS_R = 167,

        _SC_2_PBS = 168,

        _SC_2_PBS_ACCOUNTING = 169,

        _SC_2_PBS_LOCATE = 170,

        _SC_2_PBS_MESSAGE = 171,

        _SC_2_PBS_TRACK = 172,

        _SC_SYMLOOP_MAX = 173,

        _SC_STREAMS = 174,

        _SC_2_PBS_CHECKPOINT = 175,

        _SC_V6_ILP32_OFF32 = 176,

        _SC_V6_ILP32_OFFBIG = 177,

        _SC_V6_LP64_OFF64 = 178,

        _SC_V6_LPBIG_OFFBIG = 179,

        _SC_HOST_NAME_MAX = 180,

        _SC_TRACE = 181,

        _SC_TRACE_EVENT_FILTER = 182,

        _SC_TRACE_INHERIT = 183,

        _SC_TRACE_LOG = 184,

        _SC_LEVEL1_ICACHE_SIZE = 185,

        _SC_LEVEL1_ICACHE_ASSOC = 186,

        _SC_LEVEL1_ICACHE_LINESIZE = 187,

        _SC_LEVEL1_DCACHE_SIZE = 188,

        _SC_LEVEL1_DCACHE_ASSOC = 189,

        _SC_LEVEL1_DCACHE_LINESIZE = 190,

        _SC_LEVEL2_CACHE_SIZE = 191,

        _SC_LEVEL2_CACHE_ASSOC = 192,

        _SC_LEVEL2_CACHE_LINESIZE = 193,

        _SC_LEVEL3_CACHE_SIZE = 194,

        _SC_LEVEL3_CACHE_ASSOC = 195,

        _SC_LEVEL3_CACHE_LINESIZE = 196,

        _SC_LEVEL4_CACHE_SIZE = 197,

        _SC_LEVEL4_CACHE_ASSOC = 198,

        _SC_LEVEL4_CACHE_LINESIZE = 199,

        _SC_IPV6 = 235,

        _SC_RAW_SOCKETS = 236,

        _SC_V7_ILP32_OFF32 = 237,

        _SC_V7_ILP32_OFFBIG = 238,

        _SC_V7_LP64_OFF64 = 239,

        _SC_V7_LPBIG_OFFBIG = 240,

        _SC_SS_REPL_MAX = 241,

        _SC_TRACE_EVENT_NAME_MAX = 242,

        _SC_TRACE_NAME_MAX = 243,

        _SC_TRACE_SYS_MAX = 244,

        _SC_TRACE_USER_EVENT_MAX = 245,

        _SC_XOPEN_STREAMS = 246,

        _SC_THREAD_ROBUST_PRIO_INHERIT = 247,

        _SC_THREAD_ROBUST_PRIO_PROTECT = 248,

        _SC_MINSIGSTKSZ = 249,

        _SC_SIGSTKSZ = 250,
    }
    enum _SC_ARG_MAX = _Anonymous_3._SC_ARG_MAX;
    enum _SC_CHILD_MAX = _Anonymous_3._SC_CHILD_MAX;
    enum _SC_CLK_TCK = _Anonymous_3._SC_CLK_TCK;
    enum _SC_NGROUPS_MAX = _Anonymous_3._SC_NGROUPS_MAX;
    enum _SC_OPEN_MAX = _Anonymous_3._SC_OPEN_MAX;
    enum _SC_STREAM_MAX = _Anonymous_3._SC_STREAM_MAX;
    enum _SC_TZNAME_MAX = _Anonymous_3._SC_TZNAME_MAX;
    enum _SC_JOB_CONTROL = _Anonymous_3._SC_JOB_CONTROL;
    enum _SC_SAVED_IDS = _Anonymous_3._SC_SAVED_IDS;
    enum _SC_REALTIME_SIGNALS = _Anonymous_3._SC_REALTIME_SIGNALS;
    enum _SC_PRIORITY_SCHEDULING = _Anonymous_3._SC_PRIORITY_SCHEDULING;
    enum _SC_TIMERS = _Anonymous_3._SC_TIMERS;
    enum _SC_ASYNCHRONOUS_IO = _Anonymous_3._SC_ASYNCHRONOUS_IO;
    enum _SC_PRIORITIZED_IO = _Anonymous_3._SC_PRIORITIZED_IO;
    enum _SC_SYNCHRONIZED_IO = _Anonymous_3._SC_SYNCHRONIZED_IO;
    enum _SC_FSYNC = _Anonymous_3._SC_FSYNC;
    enum _SC_MAPPED_FILES = _Anonymous_3._SC_MAPPED_FILES;
    enum _SC_MEMLOCK = _Anonymous_3._SC_MEMLOCK;
    enum _SC_MEMLOCK_RANGE = _Anonymous_3._SC_MEMLOCK_RANGE;
    enum _SC_MEMORY_PROTECTION = _Anonymous_3._SC_MEMORY_PROTECTION;
    enum _SC_MESSAGE_PASSING = _Anonymous_3._SC_MESSAGE_PASSING;
    enum _SC_SEMAPHORES = _Anonymous_3._SC_SEMAPHORES;
    enum _SC_SHARED_MEMORY_OBJECTS = _Anonymous_3._SC_SHARED_MEMORY_OBJECTS;
    enum _SC_AIO_LISTIO_MAX = _Anonymous_3._SC_AIO_LISTIO_MAX;
    enum _SC_AIO_MAX = _Anonymous_3._SC_AIO_MAX;
    enum _SC_AIO_PRIO_DELTA_MAX = _Anonymous_3._SC_AIO_PRIO_DELTA_MAX;
    enum _SC_DELAYTIMER_MAX = _Anonymous_3._SC_DELAYTIMER_MAX;
    enum _SC_MQ_OPEN_MAX = _Anonymous_3._SC_MQ_OPEN_MAX;
    enum _SC_MQ_PRIO_MAX = _Anonymous_3._SC_MQ_PRIO_MAX;
    enum _SC_VERSION = _Anonymous_3._SC_VERSION;
    enum _SC_PAGESIZE = _Anonymous_3._SC_PAGESIZE;
    enum _SC_RTSIG_MAX = _Anonymous_3._SC_RTSIG_MAX;
    enum _SC_SEM_NSEMS_MAX = _Anonymous_3._SC_SEM_NSEMS_MAX;
    enum _SC_SEM_VALUE_MAX = _Anonymous_3._SC_SEM_VALUE_MAX;
    enum _SC_SIGQUEUE_MAX = _Anonymous_3._SC_SIGQUEUE_MAX;
    enum _SC_TIMER_MAX = _Anonymous_3._SC_TIMER_MAX;
    enum _SC_BC_BASE_MAX = _Anonymous_3._SC_BC_BASE_MAX;
    enum _SC_BC_DIM_MAX = _Anonymous_3._SC_BC_DIM_MAX;
    enum _SC_BC_SCALE_MAX = _Anonymous_3._SC_BC_SCALE_MAX;
    enum _SC_BC_STRING_MAX = _Anonymous_3._SC_BC_STRING_MAX;
    enum _SC_COLL_WEIGHTS_MAX = _Anonymous_3._SC_COLL_WEIGHTS_MAX;
    enum _SC_EQUIV_CLASS_MAX = _Anonymous_3._SC_EQUIV_CLASS_MAX;
    enum _SC_EXPR_NEST_MAX = _Anonymous_3._SC_EXPR_NEST_MAX;
    enum _SC_LINE_MAX = _Anonymous_3._SC_LINE_MAX;
    enum _SC_RE_DUP_MAX = _Anonymous_3._SC_RE_DUP_MAX;
    enum _SC_CHARCLASS_NAME_MAX = _Anonymous_3._SC_CHARCLASS_NAME_MAX;
    enum _SC_2_VERSION = _Anonymous_3._SC_2_VERSION;
    enum _SC_2_C_BIND = _Anonymous_3._SC_2_C_BIND;
    enum _SC_2_C_DEV = _Anonymous_3._SC_2_C_DEV;
    enum _SC_2_FORT_DEV = _Anonymous_3._SC_2_FORT_DEV;
    enum _SC_2_FORT_RUN = _Anonymous_3._SC_2_FORT_RUN;
    enum _SC_2_SW_DEV = _Anonymous_3._SC_2_SW_DEV;
    enum _SC_2_LOCALEDEF = _Anonymous_3._SC_2_LOCALEDEF;
    enum _SC_PII = _Anonymous_3._SC_PII;
    enum _SC_PII_XTI = _Anonymous_3._SC_PII_XTI;
    enum _SC_PII_SOCKET = _Anonymous_3._SC_PII_SOCKET;
    enum _SC_PII_INTERNET = _Anonymous_3._SC_PII_INTERNET;
    enum _SC_PII_OSI = _Anonymous_3._SC_PII_OSI;
    enum _SC_POLL = _Anonymous_3._SC_POLL;
    enum _SC_SELECT = _Anonymous_3._SC_SELECT;
    enum _SC_UIO_MAXIOV = _Anonymous_3._SC_UIO_MAXIOV;
    enum _SC_IOV_MAX = _Anonymous_3._SC_IOV_MAX;
    enum _SC_PII_INTERNET_STREAM = _Anonymous_3._SC_PII_INTERNET_STREAM;
    enum _SC_PII_INTERNET_DGRAM = _Anonymous_3._SC_PII_INTERNET_DGRAM;
    enum _SC_PII_OSI_COTS = _Anonymous_3._SC_PII_OSI_COTS;
    enum _SC_PII_OSI_CLTS = _Anonymous_3._SC_PII_OSI_CLTS;
    enum _SC_PII_OSI_M = _Anonymous_3._SC_PII_OSI_M;
    enum _SC_T_IOV_MAX = _Anonymous_3._SC_T_IOV_MAX;
    enum _SC_THREADS = _Anonymous_3._SC_THREADS;
    enum _SC_THREAD_SAFE_FUNCTIONS = _Anonymous_3._SC_THREAD_SAFE_FUNCTIONS;
    enum _SC_GETGR_R_SIZE_MAX = _Anonymous_3._SC_GETGR_R_SIZE_MAX;
    enum _SC_GETPW_R_SIZE_MAX = _Anonymous_3._SC_GETPW_R_SIZE_MAX;
    enum _SC_LOGIN_NAME_MAX = _Anonymous_3._SC_LOGIN_NAME_MAX;
    enum _SC_TTY_NAME_MAX = _Anonymous_3._SC_TTY_NAME_MAX;
    enum _SC_THREAD_DESTRUCTOR_ITERATIONS = _Anonymous_3._SC_THREAD_DESTRUCTOR_ITERATIONS;
    enum _SC_THREAD_KEYS_MAX = _Anonymous_3._SC_THREAD_KEYS_MAX;
    enum _SC_THREAD_STACK_MIN = _Anonymous_3._SC_THREAD_STACK_MIN;
    enum _SC_THREAD_THREADS_MAX = _Anonymous_3._SC_THREAD_THREADS_MAX;
    enum _SC_THREAD_ATTR_STACKADDR = _Anonymous_3._SC_THREAD_ATTR_STACKADDR;
    enum _SC_THREAD_ATTR_STACKSIZE = _Anonymous_3._SC_THREAD_ATTR_STACKSIZE;
    enum _SC_THREAD_PRIORITY_SCHEDULING = _Anonymous_3._SC_THREAD_PRIORITY_SCHEDULING;
    enum _SC_THREAD_PRIO_INHERIT = _Anonymous_3._SC_THREAD_PRIO_INHERIT;
    enum _SC_THREAD_PRIO_PROTECT = _Anonymous_3._SC_THREAD_PRIO_PROTECT;
    enum _SC_THREAD_PROCESS_SHARED = _Anonymous_3._SC_THREAD_PROCESS_SHARED;
    enum _SC_NPROCESSORS_CONF = _Anonymous_3._SC_NPROCESSORS_CONF;
    enum _SC_NPROCESSORS_ONLN = _Anonymous_3._SC_NPROCESSORS_ONLN;
    enum _SC_PHYS_PAGES = _Anonymous_3._SC_PHYS_PAGES;
    enum _SC_AVPHYS_PAGES = _Anonymous_3._SC_AVPHYS_PAGES;
    enum _SC_ATEXIT_MAX = _Anonymous_3._SC_ATEXIT_MAX;
    enum _SC_PASS_MAX = _Anonymous_3._SC_PASS_MAX;
    enum _SC_XOPEN_VERSION = _Anonymous_3._SC_XOPEN_VERSION;
    enum _SC_XOPEN_XCU_VERSION = _Anonymous_3._SC_XOPEN_XCU_VERSION;
    enum _SC_XOPEN_UNIX = _Anonymous_3._SC_XOPEN_UNIX;
    enum _SC_XOPEN_CRYPT = _Anonymous_3._SC_XOPEN_CRYPT;
    enum _SC_XOPEN_ENH_I18N = _Anonymous_3._SC_XOPEN_ENH_I18N;
    enum _SC_XOPEN_SHM = _Anonymous_3._SC_XOPEN_SHM;
    enum _SC_2_CHAR_TERM = _Anonymous_3._SC_2_CHAR_TERM;
    enum _SC_2_C_VERSION = _Anonymous_3._SC_2_C_VERSION;
    enum _SC_2_UPE = _Anonymous_3._SC_2_UPE;
    enum _SC_XOPEN_XPG2 = _Anonymous_3._SC_XOPEN_XPG2;
    enum _SC_XOPEN_XPG3 = _Anonymous_3._SC_XOPEN_XPG3;
    enum _SC_XOPEN_XPG4 = _Anonymous_3._SC_XOPEN_XPG4;
    enum _SC_CHAR_BIT = _Anonymous_3._SC_CHAR_BIT;
    enum _SC_CHAR_MAX = _Anonymous_3._SC_CHAR_MAX;
    enum _SC_CHAR_MIN = _Anonymous_3._SC_CHAR_MIN;
    enum _SC_INT_MAX = _Anonymous_3._SC_INT_MAX;
    enum _SC_INT_MIN = _Anonymous_3._SC_INT_MIN;
    enum _SC_LONG_BIT = _Anonymous_3._SC_LONG_BIT;
    enum _SC_WORD_BIT = _Anonymous_3._SC_WORD_BIT;
    enum _SC_MB_LEN_MAX = _Anonymous_3._SC_MB_LEN_MAX;
    enum _SC_NZERO = _Anonymous_3._SC_NZERO;
    enum _SC_SSIZE_MAX = _Anonymous_3._SC_SSIZE_MAX;
    enum _SC_SCHAR_MAX = _Anonymous_3._SC_SCHAR_MAX;
    enum _SC_SCHAR_MIN = _Anonymous_3._SC_SCHAR_MIN;
    enum _SC_SHRT_MAX = _Anonymous_3._SC_SHRT_MAX;
    enum _SC_SHRT_MIN = _Anonymous_3._SC_SHRT_MIN;
    enum _SC_UCHAR_MAX = _Anonymous_3._SC_UCHAR_MAX;
    enum _SC_UINT_MAX = _Anonymous_3._SC_UINT_MAX;
    enum _SC_ULONG_MAX = _Anonymous_3._SC_ULONG_MAX;
    enum _SC_USHRT_MAX = _Anonymous_3._SC_USHRT_MAX;
    enum _SC_NL_ARGMAX = _Anonymous_3._SC_NL_ARGMAX;
    enum _SC_NL_LANGMAX = _Anonymous_3._SC_NL_LANGMAX;
    enum _SC_NL_MSGMAX = _Anonymous_3._SC_NL_MSGMAX;
    enum _SC_NL_NMAX = _Anonymous_3._SC_NL_NMAX;
    enum _SC_NL_SETMAX = _Anonymous_3._SC_NL_SETMAX;
    enum _SC_NL_TEXTMAX = _Anonymous_3._SC_NL_TEXTMAX;
    enum _SC_XBS5_ILP32_OFF32 = _Anonymous_3._SC_XBS5_ILP32_OFF32;
    enum _SC_XBS5_ILP32_OFFBIG = _Anonymous_3._SC_XBS5_ILP32_OFFBIG;
    enum _SC_XBS5_LP64_OFF64 = _Anonymous_3._SC_XBS5_LP64_OFF64;
    enum _SC_XBS5_LPBIG_OFFBIG = _Anonymous_3._SC_XBS5_LPBIG_OFFBIG;
    enum _SC_XOPEN_LEGACY = _Anonymous_3._SC_XOPEN_LEGACY;
    enum _SC_XOPEN_REALTIME = _Anonymous_3._SC_XOPEN_REALTIME;
    enum _SC_XOPEN_REALTIME_THREADS = _Anonymous_3._SC_XOPEN_REALTIME_THREADS;
    enum _SC_ADVISORY_INFO = _Anonymous_3._SC_ADVISORY_INFO;
    enum _SC_BARRIERS = _Anonymous_3._SC_BARRIERS;
    enum _SC_BASE = _Anonymous_3._SC_BASE;
    enum _SC_C_LANG_SUPPORT = _Anonymous_3._SC_C_LANG_SUPPORT;
    enum _SC_C_LANG_SUPPORT_R = _Anonymous_3._SC_C_LANG_SUPPORT_R;
    enum _SC_CLOCK_SELECTION = _Anonymous_3._SC_CLOCK_SELECTION;
    enum _SC_CPUTIME = _Anonymous_3._SC_CPUTIME;
    enum _SC_THREAD_CPUTIME = _Anonymous_3._SC_THREAD_CPUTIME;
    enum _SC_DEVICE_IO = _Anonymous_3._SC_DEVICE_IO;
    enum _SC_DEVICE_SPECIFIC = _Anonymous_3._SC_DEVICE_SPECIFIC;
    enum _SC_DEVICE_SPECIFIC_R = _Anonymous_3._SC_DEVICE_SPECIFIC_R;
    enum _SC_FD_MGMT = _Anonymous_3._SC_FD_MGMT;
    enum _SC_FIFO = _Anonymous_3._SC_FIFO;
    enum _SC_PIPE = _Anonymous_3._SC_PIPE;
    enum _SC_FILE_ATTRIBUTES = _Anonymous_3._SC_FILE_ATTRIBUTES;
    enum _SC_FILE_LOCKING = _Anonymous_3._SC_FILE_LOCKING;
    enum _SC_FILE_SYSTEM = _Anonymous_3._SC_FILE_SYSTEM;
    enum _SC_MONOTONIC_CLOCK = _Anonymous_3._SC_MONOTONIC_CLOCK;
    enum _SC_MULTI_PROCESS = _Anonymous_3._SC_MULTI_PROCESS;
    enum _SC_SINGLE_PROCESS = _Anonymous_3._SC_SINGLE_PROCESS;
    enum _SC_NETWORKING = _Anonymous_3._SC_NETWORKING;
    enum _SC_READER_WRITER_LOCKS = _Anonymous_3._SC_READER_WRITER_LOCKS;
    enum _SC_SPIN_LOCKS = _Anonymous_3._SC_SPIN_LOCKS;
    enum _SC_REGEXP = _Anonymous_3._SC_REGEXP;
    enum _SC_REGEX_VERSION = _Anonymous_3._SC_REGEX_VERSION;
    enum _SC_SHELL = _Anonymous_3._SC_SHELL;
    enum _SC_SIGNALS = _Anonymous_3._SC_SIGNALS;
    enum _SC_SPAWN = _Anonymous_3._SC_SPAWN;
    enum _SC_SPORADIC_SERVER = _Anonymous_3._SC_SPORADIC_SERVER;
    enum _SC_THREAD_SPORADIC_SERVER = _Anonymous_3._SC_THREAD_SPORADIC_SERVER;
    enum _SC_SYSTEM_DATABASE = _Anonymous_3._SC_SYSTEM_DATABASE;
    enum _SC_SYSTEM_DATABASE_R = _Anonymous_3._SC_SYSTEM_DATABASE_R;
    enum _SC_TIMEOUTS = _Anonymous_3._SC_TIMEOUTS;
    enum _SC_TYPED_MEMORY_OBJECTS = _Anonymous_3._SC_TYPED_MEMORY_OBJECTS;
    enum _SC_USER_GROUPS = _Anonymous_3._SC_USER_GROUPS;
    enum _SC_USER_GROUPS_R = _Anonymous_3._SC_USER_GROUPS_R;
    enum _SC_2_PBS = _Anonymous_3._SC_2_PBS;
    enum _SC_2_PBS_ACCOUNTING = _Anonymous_3._SC_2_PBS_ACCOUNTING;
    enum _SC_2_PBS_LOCATE = _Anonymous_3._SC_2_PBS_LOCATE;
    enum _SC_2_PBS_MESSAGE = _Anonymous_3._SC_2_PBS_MESSAGE;
    enum _SC_2_PBS_TRACK = _Anonymous_3._SC_2_PBS_TRACK;
    enum _SC_SYMLOOP_MAX = _Anonymous_3._SC_SYMLOOP_MAX;
    enum _SC_STREAMS = _Anonymous_3._SC_STREAMS;
    enum _SC_2_PBS_CHECKPOINT = _Anonymous_3._SC_2_PBS_CHECKPOINT;
    enum _SC_V6_ILP32_OFF32 = _Anonymous_3._SC_V6_ILP32_OFF32;
    enum _SC_V6_ILP32_OFFBIG = _Anonymous_3._SC_V6_ILP32_OFFBIG;
    enum _SC_V6_LP64_OFF64 = _Anonymous_3._SC_V6_LP64_OFF64;
    enum _SC_V6_LPBIG_OFFBIG = _Anonymous_3._SC_V6_LPBIG_OFFBIG;
    enum _SC_HOST_NAME_MAX = _Anonymous_3._SC_HOST_NAME_MAX;
    enum _SC_TRACE = _Anonymous_3._SC_TRACE;
    enum _SC_TRACE_EVENT_FILTER = _Anonymous_3._SC_TRACE_EVENT_FILTER;
    enum _SC_TRACE_INHERIT = _Anonymous_3._SC_TRACE_INHERIT;
    enum _SC_TRACE_LOG = _Anonymous_3._SC_TRACE_LOG;
    enum _SC_LEVEL1_ICACHE_SIZE = _Anonymous_3._SC_LEVEL1_ICACHE_SIZE;
    enum _SC_LEVEL1_ICACHE_ASSOC = _Anonymous_3._SC_LEVEL1_ICACHE_ASSOC;
    enum _SC_LEVEL1_ICACHE_LINESIZE = _Anonymous_3._SC_LEVEL1_ICACHE_LINESIZE;
    enum _SC_LEVEL1_DCACHE_SIZE = _Anonymous_3._SC_LEVEL1_DCACHE_SIZE;
    enum _SC_LEVEL1_DCACHE_ASSOC = _Anonymous_3._SC_LEVEL1_DCACHE_ASSOC;
    enum _SC_LEVEL1_DCACHE_LINESIZE = _Anonymous_3._SC_LEVEL1_DCACHE_LINESIZE;
    enum _SC_LEVEL2_CACHE_SIZE = _Anonymous_3._SC_LEVEL2_CACHE_SIZE;
    enum _SC_LEVEL2_CACHE_ASSOC = _Anonymous_3._SC_LEVEL2_CACHE_ASSOC;
    enum _SC_LEVEL2_CACHE_LINESIZE = _Anonymous_3._SC_LEVEL2_CACHE_LINESIZE;
    enum _SC_LEVEL3_CACHE_SIZE = _Anonymous_3._SC_LEVEL3_CACHE_SIZE;
    enum _SC_LEVEL3_CACHE_ASSOC = _Anonymous_3._SC_LEVEL3_CACHE_ASSOC;
    enum _SC_LEVEL3_CACHE_LINESIZE = _Anonymous_3._SC_LEVEL3_CACHE_LINESIZE;
    enum _SC_LEVEL4_CACHE_SIZE = _Anonymous_3._SC_LEVEL4_CACHE_SIZE;
    enum _SC_LEVEL4_CACHE_ASSOC = _Anonymous_3._SC_LEVEL4_CACHE_ASSOC;
    enum _SC_LEVEL4_CACHE_LINESIZE = _Anonymous_3._SC_LEVEL4_CACHE_LINESIZE;
    enum _SC_IPV6 = _Anonymous_3._SC_IPV6;
    enum _SC_RAW_SOCKETS = _Anonymous_3._SC_RAW_SOCKETS;
    enum _SC_V7_ILP32_OFF32 = _Anonymous_3._SC_V7_ILP32_OFF32;
    enum _SC_V7_ILP32_OFFBIG = _Anonymous_3._SC_V7_ILP32_OFFBIG;
    enum _SC_V7_LP64_OFF64 = _Anonymous_3._SC_V7_LP64_OFF64;
    enum _SC_V7_LPBIG_OFFBIG = _Anonymous_3._SC_V7_LPBIG_OFFBIG;
    enum _SC_SS_REPL_MAX = _Anonymous_3._SC_SS_REPL_MAX;
    enum _SC_TRACE_EVENT_NAME_MAX = _Anonymous_3._SC_TRACE_EVENT_NAME_MAX;
    enum _SC_TRACE_NAME_MAX = _Anonymous_3._SC_TRACE_NAME_MAX;
    enum _SC_TRACE_SYS_MAX = _Anonymous_3._SC_TRACE_SYS_MAX;
    enum _SC_TRACE_USER_EVENT_MAX = _Anonymous_3._SC_TRACE_USER_EVENT_MAX;
    enum _SC_XOPEN_STREAMS = _Anonymous_3._SC_XOPEN_STREAMS;
    enum _SC_THREAD_ROBUST_PRIO_INHERIT = _Anonymous_3._SC_THREAD_ROBUST_PRIO_INHERIT;
    enum _SC_THREAD_ROBUST_PRIO_PROTECT = _Anonymous_3._SC_THREAD_ROBUST_PRIO_PROTECT;
    enum _SC_MINSIGSTKSZ = _Anonymous_3._SC_MINSIGSTKSZ;
    enum _SC_SIGSTKSZ = _Anonymous_3._SC_SIGSTKSZ;

    int putw(int, _IO_FILE*) @nogc nothrow;

    int getw(_IO_FILE*) @nogc nothrow;

    int putchar_unlocked(int) @nogc nothrow;

    int putc_unlocked(int, _IO_FILE*) @nogc nothrow;

    int fputc_unlocked(int, _IO_FILE*) @nogc nothrow;

    int putchar(int) @nogc nothrow;

    int putc(int, _IO_FILE*) @nogc nothrow;

    int fputc(int, _IO_FILE*) @nogc nothrow;

    int fgetc_unlocked(_IO_FILE*) @nogc nothrow;

    int getchar_unlocked() @nogc nothrow;

    int getc_unlocked(_IO_FILE*) @nogc nothrow;

    int getchar() @nogc nothrow;

    int getc(_IO_FILE*) @nogc nothrow;

    int fgetc(_IO_FILE*) @nogc nothrow;

    int vsscanf(const(char)*, const(char)*, va_list*) @nogc nothrow;

    int vscanf(const(char)*, va_list*) @nogc nothrow;

    int vfscanf(_IO_FILE*, const(char)*, va_list*) @nogc nothrow;

    int sscanf(const(char)*, const(char)*, ...) @nogc nothrow;

    int scanf(const(char)*, ...) @nogc nothrow;

    int fscanf(_IO_FILE*, const(char)*, ...) @nogc nothrow;

    int dprintf(int, const(char)*, ...) @nogc nothrow;

    int vdprintf(int, const(char)*, va_list*) @nogc nothrow;

    int vsnprintf(char*, c_ulong, const(char)*, va_list*) @nogc nothrow;

    int snprintf(char*, c_ulong, const(char)*, ...) @nogc nothrow;

    int vsprintf(char*, const(char)*, va_list*) @nogc nothrow;

    int vprintf(const(char)*, va_list*) @nogc nothrow;

    int vfprintf(_IO_FILE*, const(char)*, va_list*) @nogc nothrow;

    int sprintf(char*, const(char)*, ...) @nogc nothrow;

    int printf(const(char)*, ...) @nogc nothrow;

    int fprintf(_IO_FILE*, const(char)*, ...) @nogc nothrow;

    void setlinebuf(_IO_FILE*) @nogc nothrow;

    void setbuffer(_IO_FILE*, char*, c_ulong) @nogc nothrow;

    int setvbuf(_IO_FILE*, char*, int, c_ulong) @nogc nothrow;

    void setbuf(_IO_FILE*, char*) @nogc nothrow;

    _IO_FILE* open_memstream(char**, c_ulong*) @nogc nothrow;

    _IO_FILE* fmemopen(void*, c_ulong, const(char)*) @nogc nothrow;

    _IO_FILE* fdopen(int, const(char)*) @nogc nothrow;

    _IO_FILE* freopen(const(char)*, const(char)*, _IO_FILE*) @nogc nothrow;

    _IO_FILE* fopen(const(char)*, const(char)*) @nogc nothrow;

    int fflush_unlocked(_IO_FILE*) @nogc nothrow;

    int fflush(_IO_FILE*) @nogc nothrow;

    char* tempnam(const(char)*, const(char)*) @nogc nothrow;

    char* tmpnam_r(char*) @nogc nothrow;

    char* tmpnam(char*) @nogc nothrow;

    _IO_FILE* tmpfile() @nogc nothrow;

    int fclose(_IO_FILE*) @nogc nothrow;

    int renameat(int, const(char)*, int, const(char)*) @nogc nothrow;

    int rename(const(char)*, const(char)*) @nogc nothrow;

    int remove(const(char)*) @nogc nothrow;

    extern __gshared _IO_FILE* stderr;

    extern __gshared _IO_FILE* stdout;

    extern __gshared _IO_FILE* stdin;

    alias fpos_t = _G_fpos_t;

    alias __poll_t = uint;

    alias __wsum = uint;

    alias __sum16 = ushort;

    alias __be64 = ulong;

    alias __le64 = ulong;

    alias __be32 = uint;

    alias __le32 = uint;

    alias __be16 = ushort;

    alias __le16 = ushort;

    struct __kernel_sockaddr_storage
    {

        static union _Anonymous_4
        {

            static struct _Anonymous_5
            {

                ushort ss_family;

                char[126] __data;
            }
            _Anonymous_5 _anonymous_6;
            ref auto ss_family() @property @nogc pure nothrow { return _anonymous_6.ss_family; }
            void ss_family(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_6.ss_family = val; }
            ref auto __data() @property @nogc pure nothrow { return _anonymous_6.__data; }
            void __data(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_6.__data = val; }

            void* __align;
        }
        _Anonymous_4 _anonymous_7;
        ref auto ss_family() @property @nogc pure nothrow { return _anonymous_7.ss_family; }
        void ss_family(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_7.ss_family = val; }
        ref auto __data() @property @nogc pure nothrow { return _anonymous_7.__data; }
        void __data(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_7.__data = val; }
        ref auto __align() @property @nogc pure nothrow { return _anonymous_7.__align; }
        void __align(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_7.__align = val; }
    }

    alias __kernel_sa_family_t = ushort;

    alias __kernel_mqd_t = int;

    alias __kernel_key_t = int;
    alias __kernel_sighandler_t = void function(int);

    struct __kernel_fd_set
    {

        c_ulong[16] fds_bits;
    }

    struct tun_filter
    {

        ushort flags;

        ushort count;

        ubyte[6][0] addr;
    }

    struct tun_pi
    {

        ushort flags;

        ushort proto;
    }

    struct ethhdr
    {
    align(1):

        ubyte[6] h_dest;

        ubyte[6] h_source;

        ushort h_proto;
    }

    struct ifconf
    {

        int ifc_len;

        static union _Anonymous_8
        {

            char* ifcu_buf;

            ifreq* ifcu_req;
        }

        _Anonymous_8 ifc_ifcu;
    }

    struct ifreq
    {

        static union _Anonymous_9
        {

            char[16] ifrn_name;
        }

        _Anonymous_9 ifr_ifrn;

        static union _Anonymous_10
        {

            sockaddr ifru_addr;

            sockaddr ifru_dstaddr;

            sockaddr ifru_broadaddr;

            sockaddr ifru_netmask;

            sockaddr ifru_hwaddr;

            short ifru_flags;

            int ifru_ivalue;

            int ifru_mtu;

            ifmap ifru_map;

            char[16] ifru_slave;

            char[16] ifru_newname;

            void* ifru_data;

            if_settings ifru_settings;
        }

        _Anonymous_10 ifr_ifru;
    }

    struct if_settings
    {

        uint type;

        uint size;

        static union _Anonymous_11
        {

            raw_hdlc_proto* raw_hdlc;

            cisco_proto* cisco;

            fr_proto* fr;

            fr_proto_pvc* fr_pvc;

            fr_proto_pvc_info* fr_pvc_info;

            x25_hdlc_proto* x25;

            sync_serial_settings* sync;

            te1_settings* te1;
        }

        _Anonymous_11 ifs_ifsu;
    }

    struct ifmap
    {

        c_ulong mem_start;

        c_ulong mem_end;

        ushort base_addr;

        ubyte irq;

        ubyte dma;

        ubyte port;
    }

    enum _Anonymous_12
    {

        IF_LINK_MODE_DEFAULT = 0,

        IF_LINK_MODE_DORMANT = 1,

        IF_LINK_MODE_TESTING = 2,
    }
    enum IF_LINK_MODE_DEFAULT = _Anonymous_12.IF_LINK_MODE_DEFAULT;
    enum IF_LINK_MODE_DORMANT = _Anonymous_12.IF_LINK_MODE_DORMANT;
    enum IF_LINK_MODE_TESTING = _Anonymous_12.IF_LINK_MODE_TESTING;

    enum _Anonymous_13
    {

        IF_OPER_UNKNOWN = 0,

        IF_OPER_NOTPRESENT = 1,

        IF_OPER_DOWN = 2,

        IF_OPER_LOWERLAYERDOWN = 3,

        IF_OPER_TESTING = 4,

        IF_OPER_DORMANT = 5,

        IF_OPER_UP = 6,
    }
    enum IF_OPER_UNKNOWN = _Anonymous_13.IF_OPER_UNKNOWN;
    enum IF_OPER_NOTPRESENT = _Anonymous_13.IF_OPER_NOTPRESENT;
    enum IF_OPER_DOWN = _Anonymous_13.IF_OPER_DOWN;
    enum IF_OPER_LOWERLAYERDOWN = _Anonymous_13.IF_OPER_LOWERLAYERDOWN;
    enum IF_OPER_TESTING = _Anonymous_13.IF_OPER_TESTING;
    enum IF_OPER_DORMANT = _Anonymous_13.IF_OPER_DORMANT;
    enum IF_OPER_UP = _Anonymous_13.IF_OPER_UP;
    /**
 * enum net_device_flags - &struct net_device flags
 *
 * These are the &struct net_device flags, they can be set by drivers, the
 * kernel and some can be triggered by userspace. Userspace can query and
 * set these flags using userspace utilities but there is also a sysfs
 * entry available for all dev flags which can be queried and set. These flags
 * are shared for all types of net_devices. The sysfs entries are available
 * via /sys/class/net/<dev>/flags. Flags which can be toggled through sysfs
 * are annotated below, note that only a few flags can be toggled and some
 * other flags are always preserved from the original net_device flags
 * even if you try to set them via sysfs. Flags which are always preserved
 * are kept under the flag grouping @IFF_VOLATILE. Flags which are __volatile__
 * are annotated below as such.
 *
 * You should have a pretty good reason to be extending these flags.
 *
 * @IFF_UP: interface is up. Can be toggled through sysfs.
 * @IFF_BROADCAST: broadcast address valid. Volatile.
 * @IFF_DEBUG: turn on debugging. Can be toggled through sysfs.
 * @IFF_LOOPBACK: is a loopback net. Volatile.
 * @IFF_POINTOPOINT: interface is has p-p link. Volatile.
 * @IFF_NOTRAILERS: avoid use of trailers. Can be toggled through sysfs.
 *	Volatile.
 * @IFF_RUNNING: interface RFC2863 OPER_UP. Volatile.
 * @IFF_NOARP: no ARP protocol. Can be toggled through sysfs. Volatile.
 * @IFF_PROMISC: receive all packets. Can be toggled through sysfs.
 * @IFF_ALLMULTI: receive all multicast packets. Can be toggled through
 *	sysfs.
 * @IFF_MASTER: master of a load balancer. Volatile.
 * @IFF_SLAVE: slave of a load balancer. Volatile.
 * @IFF_MULTICAST: Supports multicast. Can be toggled through sysfs.
 * @IFF_PORTSEL: can set media type. Can be toggled through sysfs.
 * @IFF_AUTOMEDIA: auto media select active. Can be toggled through sysfs.
 * @IFF_DYNAMIC: dialup device with changing addresses. Can be toggled
 *	through sysfs.
 * @IFF_LOWER_UP: driver signals L1 up. Volatile.
 * @IFF_DORMANT: driver signals dormant. Volatile.
 * @IFF_ECHO: echo sent packets. Volatile.
 */
    enum net_device_flags
    {

        IFF_UP = 1,

        IFF_BROADCAST = 2,

        IFF_DEBUG = 4,

        IFF_LOOPBACK = 8,

        IFF_POINTOPOINT = 16,

        IFF_NOTRAILERS = 32,

        IFF_RUNNING = 64,

        IFF_NOARP = 128,

        IFF_PROMISC = 256,

        IFF_ALLMULTI = 512,

        IFF_MASTER = 1024,

        IFF_SLAVE = 2048,

        IFF_MULTICAST = 4096,

        IFF_PORTSEL = 8192,

        IFF_AUTOMEDIA = 16384,

        IFF_DYNAMIC = 32768,

        IFF_LOWER_UP = 65536,

        IFF_DORMANT = 131072,

        IFF_ECHO = 262144,
    }
    enum IFF_UP = net_device_flags.IFF_UP;
    enum IFF_BROADCAST = net_device_flags.IFF_BROADCAST;
    enum IFF_DEBUG = net_device_flags.IFF_DEBUG;
    enum IFF_LOOPBACK = net_device_flags.IFF_LOOPBACK;
    enum IFF_POINTOPOINT = net_device_flags.IFF_POINTOPOINT;
    enum IFF_NOTRAILERS = net_device_flags.IFF_NOTRAILERS;
    enum IFF_RUNNING = net_device_flags.IFF_RUNNING;
    enum IFF_NOARP = net_device_flags.IFF_NOARP;
    enum IFF_PROMISC = net_device_flags.IFF_PROMISC;
    enum IFF_ALLMULTI = net_device_flags.IFF_ALLMULTI;
    enum IFF_MASTER = net_device_flags.IFF_MASTER;
    enum IFF_SLAVE = net_device_flags.IFF_SLAVE;
    enum IFF_MULTICAST = net_device_flags.IFF_MULTICAST;
    enum IFF_PORTSEL = net_device_flags.IFF_PORTSEL;
    enum IFF_AUTOMEDIA = net_device_flags.IFF_AUTOMEDIA;
    enum IFF_DYNAMIC = net_device_flags.IFF_DYNAMIC;
    enum IFF_LOWER_UP = net_device_flags.IFF_LOWER_UP;
    enum IFF_DORMANT = net_device_flags.IFF_DORMANT;
    enum IFF_ECHO = net_device_flags.IFF_ECHO;

    enum _Anonymous_14
    {

        _CS_PATH = 0,

        _CS_V6_WIDTH_RESTRICTED_ENVS = 1,

        _CS_GNU_LIBC_VERSION = 2,

        _CS_GNU_LIBPTHREAD_VERSION = 3,

        _CS_V5_WIDTH_RESTRICTED_ENVS = 4,

        _CS_V7_WIDTH_RESTRICTED_ENVS = 5,

        _CS_LFS_CFLAGS = 1000,

        _CS_LFS_LDFLAGS = 1001,

        _CS_LFS_LIBS = 1002,

        _CS_LFS_LINTFLAGS = 1003,

        _CS_LFS64_CFLAGS = 1004,

        _CS_LFS64_LDFLAGS = 1005,

        _CS_LFS64_LIBS = 1006,

        _CS_LFS64_LINTFLAGS = 1007,

        _CS_XBS5_ILP32_OFF32_CFLAGS = 1100,

        _CS_XBS5_ILP32_OFF32_LDFLAGS = 1101,

        _CS_XBS5_ILP32_OFF32_LIBS = 1102,

        _CS_XBS5_ILP32_OFF32_LINTFLAGS = 1103,

        _CS_XBS5_ILP32_OFFBIG_CFLAGS = 1104,

        _CS_XBS5_ILP32_OFFBIG_LDFLAGS = 1105,

        _CS_XBS5_ILP32_OFFBIG_LIBS = 1106,

        _CS_XBS5_ILP32_OFFBIG_LINTFLAGS = 1107,

        _CS_XBS5_LP64_OFF64_CFLAGS = 1108,

        _CS_XBS5_LP64_OFF64_LDFLAGS = 1109,

        _CS_XBS5_LP64_OFF64_LIBS = 1110,

        _CS_XBS5_LP64_OFF64_LINTFLAGS = 1111,

        _CS_XBS5_LPBIG_OFFBIG_CFLAGS = 1112,

        _CS_XBS5_LPBIG_OFFBIG_LDFLAGS = 1113,

        _CS_XBS5_LPBIG_OFFBIG_LIBS = 1114,

        _CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = 1115,

        _CS_POSIX_V6_ILP32_OFF32_CFLAGS = 1116,

        _CS_POSIX_V6_ILP32_OFF32_LDFLAGS = 1117,

        _CS_POSIX_V6_ILP32_OFF32_LIBS = 1118,

        _CS_POSIX_V6_ILP32_OFF32_LINTFLAGS = 1119,

        _CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = 1120,

        _CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = 1121,

        _CS_POSIX_V6_ILP32_OFFBIG_LIBS = 1122,

        _CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS = 1123,

        _CS_POSIX_V6_LP64_OFF64_CFLAGS = 1124,

        _CS_POSIX_V6_LP64_OFF64_LDFLAGS = 1125,

        _CS_POSIX_V6_LP64_OFF64_LIBS = 1126,

        _CS_POSIX_V6_LP64_OFF64_LINTFLAGS = 1127,

        _CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = 1128,

        _CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = 1129,

        _CS_POSIX_V6_LPBIG_OFFBIG_LIBS = 1130,

        _CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS = 1131,

        _CS_POSIX_V7_ILP32_OFF32_CFLAGS = 1132,

        _CS_POSIX_V7_ILP32_OFF32_LDFLAGS = 1133,

        _CS_POSIX_V7_ILP32_OFF32_LIBS = 1134,

        _CS_POSIX_V7_ILP32_OFF32_LINTFLAGS = 1135,

        _CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = 1136,

        _CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = 1137,

        _CS_POSIX_V7_ILP32_OFFBIG_LIBS = 1138,

        _CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS = 1139,

        _CS_POSIX_V7_LP64_OFF64_CFLAGS = 1140,

        _CS_POSIX_V7_LP64_OFF64_LDFLAGS = 1141,

        _CS_POSIX_V7_LP64_OFF64_LIBS = 1142,

        _CS_POSIX_V7_LP64_OFF64_LINTFLAGS = 1143,

        _CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = 1144,

        _CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = 1145,

        _CS_POSIX_V7_LPBIG_OFFBIG_LIBS = 1146,

        _CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS = 1147,

        _CS_V6_ENV = 1148,

        _CS_V7_ENV = 1149,
    }
    enum _CS_PATH = _Anonymous_14._CS_PATH;
    enum _CS_V6_WIDTH_RESTRICTED_ENVS = _Anonymous_14._CS_V6_WIDTH_RESTRICTED_ENVS;
    enum _CS_GNU_LIBC_VERSION = _Anonymous_14._CS_GNU_LIBC_VERSION;
    enum _CS_GNU_LIBPTHREAD_VERSION = _Anonymous_14._CS_GNU_LIBPTHREAD_VERSION;
    enum _CS_V5_WIDTH_RESTRICTED_ENVS = _Anonymous_14._CS_V5_WIDTH_RESTRICTED_ENVS;
    enum _CS_V7_WIDTH_RESTRICTED_ENVS = _Anonymous_14._CS_V7_WIDTH_RESTRICTED_ENVS;
    enum _CS_LFS_CFLAGS = _Anonymous_14._CS_LFS_CFLAGS;
    enum _CS_LFS_LDFLAGS = _Anonymous_14._CS_LFS_LDFLAGS;
    enum _CS_LFS_LIBS = _Anonymous_14._CS_LFS_LIBS;
    enum _CS_LFS_LINTFLAGS = _Anonymous_14._CS_LFS_LINTFLAGS;
    enum _CS_LFS64_CFLAGS = _Anonymous_14._CS_LFS64_CFLAGS;
    enum _CS_LFS64_LDFLAGS = _Anonymous_14._CS_LFS64_LDFLAGS;
    enum _CS_LFS64_LIBS = _Anonymous_14._CS_LFS64_LIBS;
    enum _CS_LFS64_LINTFLAGS = _Anonymous_14._CS_LFS64_LINTFLAGS;
    enum _CS_XBS5_ILP32_OFF32_CFLAGS = _Anonymous_14._CS_XBS5_ILP32_OFF32_CFLAGS;
    enum _CS_XBS5_ILP32_OFF32_LDFLAGS = _Anonymous_14._CS_XBS5_ILP32_OFF32_LDFLAGS;
    enum _CS_XBS5_ILP32_OFF32_LIBS = _Anonymous_14._CS_XBS5_ILP32_OFF32_LIBS;
    enum _CS_XBS5_ILP32_OFF32_LINTFLAGS = _Anonymous_14._CS_XBS5_ILP32_OFF32_LINTFLAGS;
    enum _CS_XBS5_ILP32_OFFBIG_CFLAGS = _Anonymous_14._CS_XBS5_ILP32_OFFBIG_CFLAGS;
    enum _CS_XBS5_ILP32_OFFBIG_LDFLAGS = _Anonymous_14._CS_XBS5_ILP32_OFFBIG_LDFLAGS;
    enum _CS_XBS5_ILP32_OFFBIG_LIBS = _Anonymous_14._CS_XBS5_ILP32_OFFBIG_LIBS;
    enum _CS_XBS5_ILP32_OFFBIG_LINTFLAGS = _Anonymous_14._CS_XBS5_ILP32_OFFBIG_LINTFLAGS;
    enum _CS_XBS5_LP64_OFF64_CFLAGS = _Anonymous_14._CS_XBS5_LP64_OFF64_CFLAGS;
    enum _CS_XBS5_LP64_OFF64_LDFLAGS = _Anonymous_14._CS_XBS5_LP64_OFF64_LDFLAGS;
    enum _CS_XBS5_LP64_OFF64_LIBS = _Anonymous_14._CS_XBS5_LP64_OFF64_LIBS;
    enum _CS_XBS5_LP64_OFF64_LINTFLAGS = _Anonymous_14._CS_XBS5_LP64_OFF64_LINTFLAGS;
    enum _CS_XBS5_LPBIG_OFFBIG_CFLAGS = _Anonymous_14._CS_XBS5_LPBIG_OFFBIG_CFLAGS;
    enum _CS_XBS5_LPBIG_OFFBIG_LDFLAGS = _Anonymous_14._CS_XBS5_LPBIG_OFFBIG_LDFLAGS;
    enum _CS_XBS5_LPBIG_OFFBIG_LIBS = _Anonymous_14._CS_XBS5_LPBIG_OFFBIG_LIBS;
    enum _CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = _Anonymous_14._CS_XBS5_LPBIG_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V6_ILP32_OFF32_CFLAGS = _Anonymous_14._CS_POSIX_V6_ILP32_OFF32_CFLAGS;
    enum _CS_POSIX_V6_ILP32_OFF32_LDFLAGS = _Anonymous_14._CS_POSIX_V6_ILP32_OFF32_LDFLAGS;
    enum _CS_POSIX_V6_ILP32_OFF32_LIBS = _Anonymous_14._CS_POSIX_V6_ILP32_OFF32_LIBS;
    enum _CS_POSIX_V6_ILP32_OFF32_LINTFLAGS = _Anonymous_14._CS_POSIX_V6_ILP32_OFF32_LINTFLAGS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = _Anonymous_14._CS_POSIX_V6_ILP32_OFFBIG_CFLAGS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = _Anonymous_14._CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_LIBS = _Anonymous_14._CS_POSIX_V6_ILP32_OFFBIG_LIBS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS = _Anonymous_14._CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V6_LP64_OFF64_CFLAGS = _Anonymous_14._CS_POSIX_V6_LP64_OFF64_CFLAGS;
    enum _CS_POSIX_V6_LP64_OFF64_LDFLAGS = _Anonymous_14._CS_POSIX_V6_LP64_OFF64_LDFLAGS;
    enum _CS_POSIX_V6_LP64_OFF64_LIBS = _Anonymous_14._CS_POSIX_V6_LP64_OFF64_LIBS;
    enum _CS_POSIX_V6_LP64_OFF64_LINTFLAGS = _Anonymous_14._CS_POSIX_V6_LP64_OFF64_LINTFLAGS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = _Anonymous_14._CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = _Anonymous_14._CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_LIBS = _Anonymous_14._CS_POSIX_V6_LPBIG_OFFBIG_LIBS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS = _Anonymous_14._CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V7_ILP32_OFF32_CFLAGS = _Anonymous_14._CS_POSIX_V7_ILP32_OFF32_CFLAGS;
    enum _CS_POSIX_V7_ILP32_OFF32_LDFLAGS = _Anonymous_14._CS_POSIX_V7_ILP32_OFF32_LDFLAGS;
    enum _CS_POSIX_V7_ILP32_OFF32_LIBS = _Anonymous_14._CS_POSIX_V7_ILP32_OFF32_LIBS;
    enum _CS_POSIX_V7_ILP32_OFF32_LINTFLAGS = _Anonymous_14._CS_POSIX_V7_ILP32_OFF32_LINTFLAGS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = _Anonymous_14._CS_POSIX_V7_ILP32_OFFBIG_CFLAGS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = _Anonymous_14._CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_LIBS = _Anonymous_14._CS_POSIX_V7_ILP32_OFFBIG_LIBS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS = _Anonymous_14._CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V7_LP64_OFF64_CFLAGS = _Anonymous_14._CS_POSIX_V7_LP64_OFF64_CFLAGS;
    enum _CS_POSIX_V7_LP64_OFF64_LDFLAGS = _Anonymous_14._CS_POSIX_V7_LP64_OFF64_LDFLAGS;
    enum _CS_POSIX_V7_LP64_OFF64_LIBS = _Anonymous_14._CS_POSIX_V7_LP64_OFF64_LIBS;
    enum _CS_POSIX_V7_LP64_OFF64_LINTFLAGS = _Anonymous_14._CS_POSIX_V7_LP64_OFF64_LINTFLAGS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = _Anonymous_14._CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = _Anonymous_14._CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_LIBS = _Anonymous_14._CS_POSIX_V7_LPBIG_OFFBIG_LIBS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS = _Anonymous_14._CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS;
    enum _CS_V6_ENV = _Anonymous_14._CS_V6_ENV;
    enum _CS_V7_ENV = _Anonymous_14._CS_V7_ENV;

    struct x25_hdlc_proto
    {

        ushort dce;

        uint modulo;

        uint window;

        uint t1;

        uint t2;

        uint n2;
    }

    struct cisco_proto
    {

        uint interval;

        uint timeout;
    }

    struct fr_proto_pvc_info
    {

        uint dlci;

        char[16] master;
    }

    struct fr_proto_pvc
    {

        uint dlci;
    }

    struct fr_proto
    {

        uint t391;

        uint t392;

        uint n391;

        uint n392;

        uint n393;

        ushort lmi;

        ushort dce;
    }

    struct raw_hdlc_proto
    {

        ushort encoding;

        ushort parity;
    }

    struct te1_settings
    {

        uint clock_rate;

        uint clock_type;

        ushort loopback;

        uint slot_map;
    }

    struct sync_serial_settings
    {

        uint clock_rate;

        uint clock_type;

        ushort loopback;
    }

    struct sock_fprog
    {

        ushort len;

        sock_filter* filter;
    }

    struct sock_filter
    {

        ushort code;

        ubyte jt;

        ubyte jf;

        uint k;
    }

    int posix_fallocate(int, c_long, c_long) @nogc nothrow;

    int posix_fadvise(int, c_long, c_long, int) @nogc nothrow;

    int lockf(int, int, c_long) @nogc nothrow;

    int creat(const(char)*, uint) @nogc nothrow;

    int openat(int, const(char)*, int, ...) @nogc nothrow;

    int open(const(char)*, int, ...) @nogc nothrow;

    int fcntl(int, int, ...) @nogc nothrow;

    int* __errno_location() @nogc nothrow;

    static c_ulong __uint64_identity(c_ulong) @nogc nothrow;

    static uint __uint32_identity(uint) @nogc nothrow;

    static ushort __uint16_identity(ushort) @nogc nothrow;

    alias timer_t = void*;

    alias time_t = c_long;

    struct timeval
    {

        c_long tv_sec;

        c_long tv_usec;
    }

    struct flock
    {

        short l_type;

        short l_whence;

        c_long l_start;

        c_long l_len;

        int l_pid;
    }

    struct timespec
    {

        c_long tv_sec;

        c_long tv_nsec;
    }

    struct osockaddr
    {

        ushort sa_family;

        ubyte[14] sa_data;
    }

    struct iovec
    {

        void* iov_base;

        c_ulong iov_len;
    }

    alias _IO_lock_t = void;
    struct _IO_wide_data;
    struct _IO_codecvt;
    struct _IO_marker;

    alias sigset_t = __sigset_t;

    alias clockid_t = int;

    alias clock_t = c_long;

    alias _Float32 = float;

    struct __sigset_t
    {

        c_ulong[16] __val;
    }

    alias _Float64 = double;

    struct __mbstate_t
    {

        int __count;

        static union _Anonymous_15
        {

            uint __wch;

            char[4] __wchb;
        }

        _Anonymous_15 __value;
    }

    alias _Float32x = double;

    struct _G_fpos_t
    {

        c_long __pos;

        __mbstate_t __state;
    }

    alias __fpos_t = _G_fpos_t;

    alias _Float64x = real;

    struct _G_fpos64_t
    {

        c_long __pos;

        __mbstate_t __state;
    }

    alias __fpos64_t = _G_fpos64_t;

    alias __FILE = _IO_FILE;

    struct _IO_FILE
    {

        int _flags;

        char* _IO_read_ptr;

        char* _IO_read_end;

        char* _IO_read_base;

        char* _IO_write_base;

        char* _IO_write_ptr;

        char* _IO_write_end;

        char* _IO_buf_base;

        char* _IO_buf_end;

        char* _IO_save_base;

        char* _IO_backup_base;

        char* _IO_save_end;

        _IO_marker* _markers;

        _IO_FILE* _chain;

        int _fileno;

        int _flags2;

        c_long _old_offset;

        ushort _cur_column;

        byte _vtable_offset;

        char[1] _shortbuf;

        void* _lock;

        c_long _offset;

        _IO_codecvt* _codecvt;

        _IO_wide_data* _wide_data;

        _IO_FILE* _freeres_list;

        void* _freeres_buf;

        c_ulong __pad5;

        int _mode;

        char[20] _unused2;
    }

    alias FILE = _IO_FILE;

    alias __sig_atomic_t = int;

    extern __gshared char* optarg;

    extern __gshared int optind;

    extern __gshared int opterr;

    extern __gshared int optopt;

    int getopt(int, char**, const(char)*) @nogc nothrow;

    struct winsize
    {

        ushort ws_row;

        ushort ws_col;

        ushort ws_xpixel;

        ushort ws_ypixel;
    }

    struct termio
    {

        ushort c_iflag;

        ushort c_oflag;

        ushort c_cflag;

        ushort c_lflag;

        ubyte c_line;

        ubyte[8] c_cc;
    }

    alias __socklen_t = uint;

    alias __intptr_t = c_long;

    alias __caddr_t = char*;

    alias __loff_t = c_long;

    alias __syscall_ulong_t = c_ulong;

    alias __syscall_slong_t = c_long;

    alias __ssize_t = c_long;

    alias __fsword_t = c_long;

    alias __fsfilcnt64_t = c_ulong;

    alias __fsfilcnt_t = c_ulong;

    alias __fsblkcnt64_t = c_ulong;

    alias __fsblkcnt_t = c_ulong;

    alias __blkcnt64_t = c_long;

    alias __blkcnt_t = c_long;

    alias __blksize_t = c_long;

    alias __timer_t = void*;

    alias __clockid_t = int;

    alias __key_t = int;

    alias __daddr_t = int;

    alias __suseconds64_t = c_long;

    alias __suseconds_t = c_long;

    alias __useconds_t = uint;

    alias __time_t = c_long;

    alias __id_t = uint;

    alias __rlim64_t = c_ulong;

    alias __rlim_t = c_ulong;

    alias __clock_t = c_long;

    struct __fsid_t
    {

        int[2] __val;
    }

    alias __pid_t = int;

    alias __off64_t = c_long;

    alias __off_t = c_long;

    alias __nlink_t = c_ulong;

    alias __mode_t = uint;

    alias __ino64_t = c_ulong;

    alias __ino_t = c_ulong;

    alias __gid_t = uint;

    alias __uid_t = uint;

    alias __dev_t = c_ulong;

    alias __uintmax_t = c_ulong;

    alias __intmax_t = c_long;

    alias __u_quad_t = c_ulong;

    alias __quad_t = c_long;

    alias __uint_least64_t = c_ulong;

    alias __int_least64_t = c_long;

    alias __uint_least32_t = uint;

    alias __int_least32_t = int;

    alias __uint_least16_t = ushort;

    alias __int_least16_t = short;

    alias __uint_least8_t = ubyte;

    alias __int_least8_t = byte;

    alias __uint64_t = c_ulong;

    alias __int64_t = c_long;

    alias __uint32_t = uint;

    alias __int32_t = int;

    alias __uint16_t = ushort;

    alias __int16_t = short;

    alias __uint8_t = ubyte;

    alias __int8_t = byte;

    alias __u_long = c_ulong;

    alias __u_int = uint;

    alias __u_short = ushort;

    alias __u_char = ubyte;

    struct __once_flag
    {

        int __data;
    }

    alias __thrd_t = c_ulong;

    alias __tss_t = uint;

    struct __pthread_cond_s
    {

        __atomic_wide_counter __wseq;

        __atomic_wide_counter __g1_start;

        uint[2] __g_refs;

        uint[2] __g_size;

        uint __g1_orig_size;

        uint __wrefs;

        uint[2] __g_signals;
    }

    struct __pthread_internal_slist
    {

        __pthread_internal_slist* __next;
    }

    alias __pthread_slist_t = __pthread_internal_slist;

    struct __pthread_internal_list
    {

        __pthread_internal_list* __prev;

        __pthread_internal_list* __next;
    }

    alias __pthread_list_t = __pthread_internal_list;

    alias pthread_t = c_ulong;

    union pthread_mutexattr_t
    {

        char[4] __size;

        int __align;
    }

    union pthread_condattr_t
    {

        char[4] __size;

        int __align;
    }

    alias pthread_key_t = uint;

    alias pthread_once_t = int;

    union pthread_attr_t
    {

        char[56] __size;

        c_long __align;
    }

    union pthread_mutex_t
    {

        __pthread_mutex_s __data;

        char[40] __size;

        c_long __align;
    }

    union pthread_cond_t
    {

        __pthread_cond_s __data;

        char[48] __size;

        long __align;
    }

    union pthread_rwlock_t
    {

        __pthread_rwlock_arch_t __data;

        char[56] __size;

        c_long __align;
    }

    union pthread_rwlockattr_t
    {

        char[8] __size;

        c_long __align;
    }

    alias pthread_spinlock_t = int;

    union pthread_barrier_t
    {

        char[32] __size;

        c_long __align;
    }

    union pthread_barrierattr_t
    {

        char[4] __size;

        int __align;
    }

    alias sa_family_t = ushort;

    struct stat
    {

        c_ulong st_dev;

        c_ulong st_ino;

        c_ulong st_nlink;

        uint st_mode;

        uint st_uid;

        uint st_gid;

        int __pad0;

        c_ulong st_rdev;

        c_long st_size;

        c_long st_blksize;

        c_long st_blocks;

        timespec st_atim;

        timespec st_mtim;

        timespec st_ctim;

        c_long[3] __glibc_reserved;
    }

    alias socklen_t = uint;

    struct __pthread_rwlock_arch_t
    {

        uint __readers;

        uint __writers;

        uint __wrphase_futex;

        uint __writers_futex;

        uint __pad3;

        uint __pad4;

        int __cur_writer;

        int __shared;

        byte __rwelision;

        ubyte[7] __pad1;

        c_ulong __pad2;

        uint __flags;
    }

    struct __pthread_mutex_s
    {

        int __lock;

        uint __count;

        int __owner;

        uint __nusers;

        int __kind;

        short __spins;

        short __elision;

        __pthread_internal_list __list;
    }

    alias int64_t = c_long;

    alias int32_t = int;

    alias int16_t = short;

    alias int8_t = byte;

    enum __socket_type
    {

        SOCK_STREAM = 1,

        SOCK_DGRAM = 2,

        SOCK_RAW = 3,

        SOCK_RDM = 4,

        SOCK_SEQPACKET = 5,

        SOCK_DCCP = 6,

        SOCK_PACKET = 10,

        SOCK_CLOEXEC = 524288,

        SOCK_NONBLOCK = 2048,
    }
    enum SOCK_STREAM = __socket_type.SOCK_STREAM;
    enum SOCK_DGRAM = __socket_type.SOCK_DGRAM;
    enum SOCK_RAW = __socket_type.SOCK_RAW;
    enum SOCK_RDM = __socket_type.SOCK_RDM;
    enum SOCK_SEQPACKET = __socket_type.SOCK_SEQPACKET;
    enum SOCK_DCCP = __socket_type.SOCK_DCCP;
    enum SOCK_PACKET = __socket_type.SOCK_PACKET;
    enum SOCK_CLOEXEC = __socket_type.SOCK_CLOEXEC;
    enum SOCK_NONBLOCK = __socket_type.SOCK_NONBLOCK;

    struct linger
    {

        int l_onoff;

        int l_linger;
    }

    enum _Anonymous_16
    {

        SCM_RIGHTS = 1,
    }
    enum SCM_RIGHTS = _Anonymous_16.SCM_RIGHTS;

    cmsghdr* __cmsg_nxthdr(msghdr*, cmsghdr*) @nogc nothrow;

    struct cmsghdr
    {

        c_ulong cmsg_len;

        int cmsg_level;

        int cmsg_type;

        ubyte[0] __cmsg_data;
    }

    struct msghdr
    {

        void* msg_name;

        uint msg_namelen;

        iovec* msg_iov;

        c_ulong msg_iovlen;

        void* msg_control;

        c_ulong msg_controllen;

        int msg_flags;
    }

    enum _Anonymous_17
    {

        MSG_OOB = 1,

        MSG_PEEK = 2,

        MSG_DONTROUTE = 4,

        MSG_CTRUNC = 8,

        MSG_PROXY = 16,

        MSG_TRUNC = 32,

        MSG_DONTWAIT = 64,

        MSG_EOR = 128,

        MSG_WAITALL = 256,

        MSG_FIN = 512,

        MSG_SYN = 1024,

        MSG_CONFIRM = 2048,

        MSG_RST = 4096,

        MSG_ERRQUEUE = 8192,

        MSG_NOSIGNAL = 16384,

        MSG_MORE = 32768,

        MSG_WAITFORONE = 65536,

        MSG_BATCH = 262144,

        MSG_ZEROCOPY = 67108864,

        MSG_FASTOPEN = 536870912,

        MSG_CMSG_CLOEXEC = 1073741824,
    }
    enum MSG_OOB = _Anonymous_17.MSG_OOB;
    enum MSG_PEEK = _Anonymous_17.MSG_PEEK;
    enum MSG_DONTROUTE = _Anonymous_17.MSG_DONTROUTE;
    enum MSG_CTRUNC = _Anonymous_17.MSG_CTRUNC;
    enum MSG_PROXY = _Anonymous_17.MSG_PROXY;
    enum MSG_TRUNC = _Anonymous_17.MSG_TRUNC;
    enum MSG_DONTWAIT = _Anonymous_17.MSG_DONTWAIT;
    enum MSG_EOR = _Anonymous_17.MSG_EOR;
    enum MSG_WAITALL = _Anonymous_17.MSG_WAITALL;
    enum MSG_FIN = _Anonymous_17.MSG_FIN;
    enum MSG_SYN = _Anonymous_17.MSG_SYN;
    enum MSG_CONFIRM = _Anonymous_17.MSG_CONFIRM;
    enum MSG_RST = _Anonymous_17.MSG_RST;
    enum MSG_ERRQUEUE = _Anonymous_17.MSG_ERRQUEUE;
    enum MSG_NOSIGNAL = _Anonymous_17.MSG_NOSIGNAL;
    enum MSG_MORE = _Anonymous_17.MSG_MORE;
    enum MSG_WAITFORONE = _Anonymous_17.MSG_WAITFORONE;
    enum MSG_BATCH = _Anonymous_17.MSG_BATCH;
    enum MSG_ZEROCOPY = _Anonymous_17.MSG_ZEROCOPY;
    enum MSG_FASTOPEN = _Anonymous_17.MSG_FASTOPEN;
    enum MSG_CMSG_CLOEXEC = _Anonymous_17.MSG_CMSG_CLOEXEC;

    struct sockaddr_storage
    {

        ushort ss_family;

        char[118] __ss_padding;

        c_ulong __ss_align;
    }

    struct sockaddr
    {

        ushort sa_family;

        char[14] sa_data;
    }



    static if(!is(typeof(PF_PHONET))) {
        private enum enumMixinStr_PF_PHONET = `enum PF_PHONET = 35;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_PHONET); }))) {
            mixin(enumMixinStr_PF_PHONET);
        }
    }




    static if(!is(typeof(PF_IEEE802154))) {
        private enum enumMixinStr_PF_IEEE802154 = `enum PF_IEEE802154 = 36;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_IEEE802154); }))) {
            mixin(enumMixinStr_PF_IEEE802154);
        }
    }




    static if(!is(typeof(PF_CAIF))) {
        private enum enumMixinStr_PF_CAIF = `enum PF_CAIF = 37;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_CAIF); }))) {
            mixin(enumMixinStr_PF_CAIF);
        }
    }




    static if(!is(typeof(PF_ALG))) {
        private enum enumMixinStr_PF_ALG = `enum PF_ALG = 38;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_ALG); }))) {
            mixin(enumMixinStr_PF_ALG);
        }
    }




    static if(!is(typeof(PF_NFC))) {
        private enum enumMixinStr_PF_NFC = `enum PF_NFC = 39;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_NFC); }))) {
            mixin(enumMixinStr_PF_NFC);
        }
    }




    static if(!is(typeof(PF_VSOCK))) {
        private enum enumMixinStr_PF_VSOCK = `enum PF_VSOCK = 40;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_VSOCK); }))) {
            mixin(enumMixinStr_PF_VSOCK);
        }
    }




    static if(!is(typeof(PF_KCM))) {
        private enum enumMixinStr_PF_KCM = `enum PF_KCM = 41;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_KCM); }))) {
            mixin(enumMixinStr_PF_KCM);
        }
    }




    static if(!is(typeof(PF_QIPCRTR))) {
        private enum enumMixinStr_PF_QIPCRTR = `enum PF_QIPCRTR = 42;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_QIPCRTR); }))) {
            mixin(enumMixinStr_PF_QIPCRTR);
        }
    }




    static if(!is(typeof(PF_SMC))) {
        private enum enumMixinStr_PF_SMC = `enum PF_SMC = 43;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_SMC); }))) {
            mixin(enumMixinStr_PF_SMC);
        }
    }




    static if(!is(typeof(PF_XDP))) {
        private enum enumMixinStr_PF_XDP = `enum PF_XDP = 44;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_XDP); }))) {
            mixin(enumMixinStr_PF_XDP);
        }
    }




    static if(!is(typeof(PF_MCTP))) {
        private enum enumMixinStr_PF_MCTP = `enum PF_MCTP = 45;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_MCTP); }))) {
            mixin(enumMixinStr_PF_MCTP);
        }
    }




    static if(!is(typeof(PF_MAX))) {
        private enum enumMixinStr_PF_MAX = `enum PF_MAX = 46;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_MAX); }))) {
            mixin(enumMixinStr_PF_MAX);
        }
    }




    static if(!is(typeof(AF_UNSPEC))) {
        private enum enumMixinStr_AF_UNSPEC = `enum AF_UNSPEC = PF_UNSPEC;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_UNSPEC); }))) {
            mixin(enumMixinStr_AF_UNSPEC);
        }
    }




    static if(!is(typeof(AF_LOCAL))) {
        private enum enumMixinStr_AF_LOCAL = `enum AF_LOCAL = PF_LOCAL;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_LOCAL); }))) {
            mixin(enumMixinStr_AF_LOCAL);
        }
    }




    static if(!is(typeof(AF_UNIX))) {
        private enum enumMixinStr_AF_UNIX = `enum AF_UNIX = PF_UNIX;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_UNIX); }))) {
            mixin(enumMixinStr_AF_UNIX);
        }
    }




    static if(!is(typeof(AF_FILE))) {
        private enum enumMixinStr_AF_FILE = `enum AF_FILE = PF_FILE;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_FILE); }))) {
            mixin(enumMixinStr_AF_FILE);
        }
    }




    static if(!is(typeof(AF_INET))) {
        private enum enumMixinStr_AF_INET = `enum AF_INET = PF_INET;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_INET); }))) {
            mixin(enumMixinStr_AF_INET);
        }
    }




    static if(!is(typeof(AF_AX25))) {
        private enum enumMixinStr_AF_AX25 = `enum AF_AX25 = PF_AX25;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_AX25); }))) {
            mixin(enumMixinStr_AF_AX25);
        }
    }




    static if(!is(typeof(AF_IPX))) {
        private enum enumMixinStr_AF_IPX = `enum AF_IPX = PF_IPX;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_IPX); }))) {
            mixin(enumMixinStr_AF_IPX);
        }
    }




    static if(!is(typeof(AF_APPLETALK))) {
        private enum enumMixinStr_AF_APPLETALK = `enum AF_APPLETALK = PF_APPLETALK;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_APPLETALK); }))) {
            mixin(enumMixinStr_AF_APPLETALK);
        }
    }




    static if(!is(typeof(AF_NETROM))) {
        private enum enumMixinStr_AF_NETROM = `enum AF_NETROM = PF_NETROM;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_NETROM); }))) {
            mixin(enumMixinStr_AF_NETROM);
        }
    }




    static if(!is(typeof(AF_BRIDGE))) {
        private enum enumMixinStr_AF_BRIDGE = `enum AF_BRIDGE = PF_BRIDGE;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_BRIDGE); }))) {
            mixin(enumMixinStr_AF_BRIDGE);
        }
    }




    static if(!is(typeof(AF_ATMPVC))) {
        private enum enumMixinStr_AF_ATMPVC = `enum AF_ATMPVC = PF_ATMPVC;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_ATMPVC); }))) {
            mixin(enumMixinStr_AF_ATMPVC);
        }
    }




    static if(!is(typeof(AF_X25))) {
        private enum enumMixinStr_AF_X25 = `enum AF_X25 = PF_X25;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_X25); }))) {
            mixin(enumMixinStr_AF_X25);
        }
    }




    static if(!is(typeof(AF_INET6))) {
        private enum enumMixinStr_AF_INET6 = `enum AF_INET6 = PF_INET6;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_INET6); }))) {
            mixin(enumMixinStr_AF_INET6);
        }
    }




    static if(!is(typeof(AF_ROSE))) {
        private enum enumMixinStr_AF_ROSE = `enum AF_ROSE = PF_ROSE;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_ROSE); }))) {
            mixin(enumMixinStr_AF_ROSE);
        }
    }




    static if(!is(typeof(AF_DECnet))) {
        private enum enumMixinStr_AF_DECnet = `enum AF_DECnet = PF_DECnet;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_DECnet); }))) {
            mixin(enumMixinStr_AF_DECnet);
        }
    }




    static if(!is(typeof(AF_NETBEUI))) {
        private enum enumMixinStr_AF_NETBEUI = `enum AF_NETBEUI = PF_NETBEUI;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_NETBEUI); }))) {
            mixin(enumMixinStr_AF_NETBEUI);
        }
    }




    static if(!is(typeof(AF_SECURITY))) {
        private enum enumMixinStr_AF_SECURITY = `enum AF_SECURITY = PF_SECURITY;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_SECURITY); }))) {
            mixin(enumMixinStr_AF_SECURITY);
        }
    }




    static if(!is(typeof(AF_KEY))) {
        private enum enumMixinStr_AF_KEY = `enum AF_KEY = PF_KEY;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_KEY); }))) {
            mixin(enumMixinStr_AF_KEY);
        }
    }




    static if(!is(typeof(AF_NETLINK))) {
        private enum enumMixinStr_AF_NETLINK = `enum AF_NETLINK = PF_NETLINK;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_NETLINK); }))) {
            mixin(enumMixinStr_AF_NETLINK);
        }
    }




    static if(!is(typeof(AF_ROUTE))) {
        private enum enumMixinStr_AF_ROUTE = `enum AF_ROUTE = PF_ROUTE;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_ROUTE); }))) {
            mixin(enumMixinStr_AF_ROUTE);
        }
    }




    static if(!is(typeof(AF_PACKET))) {
        private enum enumMixinStr_AF_PACKET = `enum AF_PACKET = PF_PACKET;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_PACKET); }))) {
            mixin(enumMixinStr_AF_PACKET);
        }
    }




    static if(!is(typeof(AF_ASH))) {
        private enum enumMixinStr_AF_ASH = `enum AF_ASH = PF_ASH;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_ASH); }))) {
            mixin(enumMixinStr_AF_ASH);
        }
    }




    static if(!is(typeof(AF_ECONET))) {
        private enum enumMixinStr_AF_ECONET = `enum AF_ECONET = PF_ECONET;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_ECONET); }))) {
            mixin(enumMixinStr_AF_ECONET);
        }
    }




    static if(!is(typeof(AF_ATMSVC))) {
        private enum enumMixinStr_AF_ATMSVC = `enum AF_ATMSVC = PF_ATMSVC;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_ATMSVC); }))) {
            mixin(enumMixinStr_AF_ATMSVC);
        }
    }




    static if(!is(typeof(AF_RDS))) {
        private enum enumMixinStr_AF_RDS = `enum AF_RDS = PF_RDS;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_RDS); }))) {
            mixin(enumMixinStr_AF_RDS);
        }
    }




    static if(!is(typeof(AF_SNA))) {
        private enum enumMixinStr_AF_SNA = `enum AF_SNA = PF_SNA;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_SNA); }))) {
            mixin(enumMixinStr_AF_SNA);
        }
    }




    static if(!is(typeof(AF_IRDA))) {
        private enum enumMixinStr_AF_IRDA = `enum AF_IRDA = PF_IRDA;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_IRDA); }))) {
            mixin(enumMixinStr_AF_IRDA);
        }
    }




    static if(!is(typeof(AF_PPPOX))) {
        private enum enumMixinStr_AF_PPPOX = `enum AF_PPPOX = PF_PPPOX;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_PPPOX); }))) {
            mixin(enumMixinStr_AF_PPPOX);
        }
    }




    static if(!is(typeof(AF_WANPIPE))) {
        private enum enumMixinStr_AF_WANPIPE = `enum AF_WANPIPE = PF_WANPIPE;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_WANPIPE); }))) {
            mixin(enumMixinStr_AF_WANPIPE);
        }
    }




    static if(!is(typeof(AF_LLC))) {
        private enum enumMixinStr_AF_LLC = `enum AF_LLC = PF_LLC;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_LLC); }))) {
            mixin(enumMixinStr_AF_LLC);
        }
    }




    static if(!is(typeof(AF_IB))) {
        private enum enumMixinStr_AF_IB = `enum AF_IB = PF_IB;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_IB); }))) {
            mixin(enumMixinStr_AF_IB);
        }
    }




    static if(!is(typeof(AF_MPLS))) {
        private enum enumMixinStr_AF_MPLS = `enum AF_MPLS = PF_MPLS;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_MPLS); }))) {
            mixin(enumMixinStr_AF_MPLS);
        }
    }




    static if(!is(typeof(AF_CAN))) {
        private enum enumMixinStr_AF_CAN = `enum AF_CAN = PF_CAN;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_CAN); }))) {
            mixin(enumMixinStr_AF_CAN);
        }
    }




    static if(!is(typeof(AF_TIPC))) {
        private enum enumMixinStr_AF_TIPC = `enum AF_TIPC = PF_TIPC;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_TIPC); }))) {
            mixin(enumMixinStr_AF_TIPC);
        }
    }




    static if(!is(typeof(AF_BLUETOOTH))) {
        private enum enumMixinStr_AF_BLUETOOTH = `enum AF_BLUETOOTH = PF_BLUETOOTH;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_BLUETOOTH); }))) {
            mixin(enumMixinStr_AF_BLUETOOTH);
        }
    }




    static if(!is(typeof(AF_IUCV))) {
        private enum enumMixinStr_AF_IUCV = `enum AF_IUCV = PF_IUCV;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_IUCV); }))) {
            mixin(enumMixinStr_AF_IUCV);
        }
    }




    static if(!is(typeof(AF_RXRPC))) {
        private enum enumMixinStr_AF_RXRPC = `enum AF_RXRPC = PF_RXRPC;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_RXRPC); }))) {
            mixin(enumMixinStr_AF_RXRPC);
        }
    }




    static if(!is(typeof(AF_ISDN))) {
        private enum enumMixinStr_AF_ISDN = `enum AF_ISDN = PF_ISDN;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_ISDN); }))) {
            mixin(enumMixinStr_AF_ISDN);
        }
    }




    static if(!is(typeof(AF_PHONET))) {
        private enum enumMixinStr_AF_PHONET = `enum AF_PHONET = 35;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_PHONET); }))) {
            mixin(enumMixinStr_AF_PHONET);
        }
    }




    static if(!is(typeof(AF_IEEE802154))) {
        private enum enumMixinStr_AF_IEEE802154 = `enum AF_IEEE802154 = 36;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_IEEE802154); }))) {
            mixin(enumMixinStr_AF_IEEE802154);
        }
    }




    static if(!is(typeof(AF_CAIF))) {
        private enum enumMixinStr_AF_CAIF = `enum AF_CAIF = 37;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_CAIF); }))) {
            mixin(enumMixinStr_AF_CAIF);
        }
    }




    static if(!is(typeof(AF_ALG))) {
        private enum enumMixinStr_AF_ALG = `enum AF_ALG = 38;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_ALG); }))) {
            mixin(enumMixinStr_AF_ALG);
        }
    }




    static if(!is(typeof(AF_NFC))) {
        private enum enumMixinStr_AF_NFC = `enum AF_NFC = 39;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_NFC); }))) {
            mixin(enumMixinStr_AF_NFC);
        }
    }




    static if(!is(typeof(AF_VSOCK))) {
        private enum enumMixinStr_AF_VSOCK = `enum AF_VSOCK = 40;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_VSOCK); }))) {
            mixin(enumMixinStr_AF_VSOCK);
        }
    }




    static if(!is(typeof(AF_KCM))) {
        private enum enumMixinStr_AF_KCM = `enum AF_KCM = 41;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_KCM); }))) {
            mixin(enumMixinStr_AF_KCM);
        }
    }




    static if(!is(typeof(AF_QIPCRTR))) {
        private enum enumMixinStr_AF_QIPCRTR = `enum AF_QIPCRTR = 42;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_QIPCRTR); }))) {
            mixin(enumMixinStr_AF_QIPCRTR);
        }
    }




    static if(!is(typeof(AF_SMC))) {
        private enum enumMixinStr_AF_SMC = `enum AF_SMC = 43;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_SMC); }))) {
            mixin(enumMixinStr_AF_SMC);
        }
    }




    static if(!is(typeof(AF_XDP))) {
        private enum enumMixinStr_AF_XDP = `enum AF_XDP = 44;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_XDP); }))) {
            mixin(enumMixinStr_AF_XDP);
        }
    }




    static if(!is(typeof(AF_MCTP))) {
        private enum enumMixinStr_AF_MCTP = `enum AF_MCTP = 45;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_MCTP); }))) {
            mixin(enumMixinStr_AF_MCTP);
        }
    }




    static if(!is(typeof(AF_MAX))) {
        private enum enumMixinStr_AF_MAX = `enum AF_MAX = 46;`;
        static if(is(typeof({ mixin(enumMixinStr_AF_MAX); }))) {
            mixin(enumMixinStr_AF_MAX);
        }
    }




    static if(!is(typeof(SOL_RAW))) {
        private enum enumMixinStr_SOL_RAW = `enum SOL_RAW = 255;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_RAW); }))) {
            mixin(enumMixinStr_SOL_RAW);
        }
    }




    static if(!is(typeof(SOL_DECNET))) {
        private enum enumMixinStr_SOL_DECNET = `enum SOL_DECNET = 261;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_DECNET); }))) {
            mixin(enumMixinStr_SOL_DECNET);
        }
    }




    static if(!is(typeof(SOL_X25))) {
        private enum enumMixinStr_SOL_X25 = `enum SOL_X25 = 262;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_X25); }))) {
            mixin(enumMixinStr_SOL_X25);
        }
    }




    static if(!is(typeof(SOL_PACKET))) {
        private enum enumMixinStr_SOL_PACKET = `enum SOL_PACKET = 263;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_PACKET); }))) {
            mixin(enumMixinStr_SOL_PACKET);
        }
    }




    static if(!is(typeof(SOL_ATM))) {
        private enum enumMixinStr_SOL_ATM = `enum SOL_ATM = 264;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_ATM); }))) {
            mixin(enumMixinStr_SOL_ATM);
        }
    }




    static if(!is(typeof(SOL_AAL))) {
        private enum enumMixinStr_SOL_AAL = `enum SOL_AAL = 265;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_AAL); }))) {
            mixin(enumMixinStr_SOL_AAL);
        }
    }




    static if(!is(typeof(SOL_IRDA))) {
        private enum enumMixinStr_SOL_IRDA = `enum SOL_IRDA = 266;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_IRDA); }))) {
            mixin(enumMixinStr_SOL_IRDA);
        }
    }




    static if(!is(typeof(SOL_NETBEUI))) {
        private enum enumMixinStr_SOL_NETBEUI = `enum SOL_NETBEUI = 267;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_NETBEUI); }))) {
            mixin(enumMixinStr_SOL_NETBEUI);
        }
    }




    static if(!is(typeof(SOL_LLC))) {
        private enum enumMixinStr_SOL_LLC = `enum SOL_LLC = 268;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_LLC); }))) {
            mixin(enumMixinStr_SOL_LLC);
        }
    }




    static if(!is(typeof(SOL_DCCP))) {
        private enum enumMixinStr_SOL_DCCP = `enum SOL_DCCP = 269;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_DCCP); }))) {
            mixin(enumMixinStr_SOL_DCCP);
        }
    }




    static if(!is(typeof(SOL_NETLINK))) {
        private enum enumMixinStr_SOL_NETLINK = `enum SOL_NETLINK = 270;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_NETLINK); }))) {
            mixin(enumMixinStr_SOL_NETLINK);
        }
    }




    static if(!is(typeof(SOL_TIPC))) {
        private enum enumMixinStr_SOL_TIPC = `enum SOL_TIPC = 271;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_TIPC); }))) {
            mixin(enumMixinStr_SOL_TIPC);
        }
    }




    static if(!is(typeof(SOL_RXRPC))) {
        private enum enumMixinStr_SOL_RXRPC = `enum SOL_RXRPC = 272;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_RXRPC); }))) {
            mixin(enumMixinStr_SOL_RXRPC);
        }
    }




    static if(!is(typeof(SOL_PPPOL2TP))) {
        private enum enumMixinStr_SOL_PPPOL2TP = `enum SOL_PPPOL2TP = 273;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_PPPOL2TP); }))) {
            mixin(enumMixinStr_SOL_PPPOL2TP);
        }
    }




    static if(!is(typeof(SOL_BLUETOOTH))) {
        private enum enumMixinStr_SOL_BLUETOOTH = `enum SOL_BLUETOOTH = 274;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_BLUETOOTH); }))) {
            mixin(enumMixinStr_SOL_BLUETOOTH);
        }
    }




    static if(!is(typeof(SOL_PNPIPE))) {
        private enum enumMixinStr_SOL_PNPIPE = `enum SOL_PNPIPE = 275;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_PNPIPE); }))) {
            mixin(enumMixinStr_SOL_PNPIPE);
        }
    }




    static if(!is(typeof(SOL_RDS))) {
        private enum enumMixinStr_SOL_RDS = `enum SOL_RDS = 276;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_RDS); }))) {
            mixin(enumMixinStr_SOL_RDS);
        }
    }




    static if(!is(typeof(SOL_IUCV))) {
        private enum enumMixinStr_SOL_IUCV = `enum SOL_IUCV = 277;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_IUCV); }))) {
            mixin(enumMixinStr_SOL_IUCV);
        }
    }




    static if(!is(typeof(SOL_CAIF))) {
        private enum enumMixinStr_SOL_CAIF = `enum SOL_CAIF = 278;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_CAIF); }))) {
            mixin(enumMixinStr_SOL_CAIF);
        }
    }




    static if(!is(typeof(SOL_ALG))) {
        private enum enumMixinStr_SOL_ALG = `enum SOL_ALG = 279;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_ALG); }))) {
            mixin(enumMixinStr_SOL_ALG);
        }
    }




    static if(!is(typeof(SOL_NFC))) {
        private enum enumMixinStr_SOL_NFC = `enum SOL_NFC = 280;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_NFC); }))) {
            mixin(enumMixinStr_SOL_NFC);
        }
    }




    static if(!is(typeof(SOL_KCM))) {
        private enum enumMixinStr_SOL_KCM = `enum SOL_KCM = 281;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_KCM); }))) {
            mixin(enumMixinStr_SOL_KCM);
        }
    }




    static if(!is(typeof(SOL_TLS))) {
        private enum enumMixinStr_SOL_TLS = `enum SOL_TLS = 282;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_TLS); }))) {
            mixin(enumMixinStr_SOL_TLS);
        }
    }




    static if(!is(typeof(SOL_XDP))) {
        private enum enumMixinStr_SOL_XDP = `enum SOL_XDP = 283;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_XDP); }))) {
            mixin(enumMixinStr_SOL_XDP);
        }
    }




    static if(!is(typeof(SOL_MPTCP))) {
        private enum enumMixinStr_SOL_MPTCP = `enum SOL_MPTCP = 284;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_MPTCP); }))) {
            mixin(enumMixinStr_SOL_MPTCP);
        }
    }




    static if(!is(typeof(SOL_MCTP))) {
        private enum enumMixinStr_SOL_MCTP = `enum SOL_MCTP = 285;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_MCTP); }))) {
            mixin(enumMixinStr_SOL_MCTP);
        }
    }




    static if(!is(typeof(SOMAXCONN))) {
        private enum enumMixinStr_SOMAXCONN = `enum SOMAXCONN = 4096;`;
        static if(is(typeof({ mixin(enumMixinStr_SOMAXCONN); }))) {
            mixin(enumMixinStr_SOMAXCONN);
        }
    }




    static if(!is(typeof(PF_ISDN))) {
        private enum enumMixinStr_PF_ISDN = `enum PF_ISDN = 34;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_ISDN); }))) {
            mixin(enumMixinStr_PF_ISDN);
        }
    }




    static if(!is(typeof(PF_RXRPC))) {
        private enum enumMixinStr_PF_RXRPC = `enum PF_RXRPC = 33;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_RXRPC); }))) {
            mixin(enumMixinStr_PF_RXRPC);
        }
    }




    static if(!is(typeof(PF_IUCV))) {
        private enum enumMixinStr_PF_IUCV = `enum PF_IUCV = 32;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_IUCV); }))) {
            mixin(enumMixinStr_PF_IUCV);
        }
    }




    static if(!is(typeof(__ss_aligntype))) {
        private enum enumMixinStr___ss_aligntype = `enum __ss_aligntype = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___ss_aligntype); }))) {
            mixin(enumMixinStr___ss_aligntype);
        }
    }




    static if(!is(typeof(_SS_PADSIZE))) {
        private enum enumMixinStr__SS_PADSIZE = `enum _SS_PADSIZE = ( _SS_SIZE - __SOCKADDR_COMMON_SIZE - ( unsigned long int ) .sizeof );`;
        static if(is(typeof({ mixin(enumMixinStr__SS_PADSIZE); }))) {
            mixin(enumMixinStr__SS_PADSIZE);
        }
    }




    static if(!is(typeof(PF_BLUETOOTH))) {
        private enum enumMixinStr_PF_BLUETOOTH = `enum PF_BLUETOOTH = 31;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_BLUETOOTH); }))) {
            mixin(enumMixinStr_PF_BLUETOOTH);
        }
    }




    static if(!is(typeof(PF_TIPC))) {
        private enum enumMixinStr_PF_TIPC = `enum PF_TIPC = 30;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_TIPC); }))) {
            mixin(enumMixinStr_PF_TIPC);
        }
    }




    static if(!is(typeof(PF_CAN))) {
        private enum enumMixinStr_PF_CAN = `enum PF_CAN = 29;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_CAN); }))) {
            mixin(enumMixinStr_PF_CAN);
        }
    }




    static if(!is(typeof(PF_MPLS))) {
        private enum enumMixinStr_PF_MPLS = `enum PF_MPLS = 28;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_MPLS); }))) {
            mixin(enumMixinStr_PF_MPLS);
        }
    }




    static if(!is(typeof(PF_IB))) {
        private enum enumMixinStr_PF_IB = `enum PF_IB = 27;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_IB); }))) {
            mixin(enumMixinStr_PF_IB);
        }
    }




    static if(!is(typeof(MSG_OOB))) {
        private enum enumMixinStr_MSG_OOB = `enum MSG_OOB = MSG_OOB;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_OOB); }))) {
            mixin(enumMixinStr_MSG_OOB);
        }
    }




    static if(!is(typeof(MSG_PEEK))) {
        private enum enumMixinStr_MSG_PEEK = `enum MSG_PEEK = MSG_PEEK;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_PEEK); }))) {
            mixin(enumMixinStr_MSG_PEEK);
        }
    }




    static if(!is(typeof(MSG_DONTROUTE))) {
        private enum enumMixinStr_MSG_DONTROUTE = `enum MSG_DONTROUTE = MSG_DONTROUTE;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_DONTROUTE); }))) {
            mixin(enumMixinStr_MSG_DONTROUTE);
        }
    }




    static if(!is(typeof(MSG_CTRUNC))) {
        private enum enumMixinStr_MSG_CTRUNC = `enum MSG_CTRUNC = MSG_CTRUNC;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_CTRUNC); }))) {
            mixin(enumMixinStr_MSG_CTRUNC);
        }
    }




    static if(!is(typeof(MSG_PROXY))) {
        private enum enumMixinStr_MSG_PROXY = `enum MSG_PROXY = MSG_PROXY;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_PROXY); }))) {
            mixin(enumMixinStr_MSG_PROXY);
        }
    }




    static if(!is(typeof(MSG_TRUNC))) {
        private enum enumMixinStr_MSG_TRUNC = `enum MSG_TRUNC = MSG_TRUNC;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_TRUNC); }))) {
            mixin(enumMixinStr_MSG_TRUNC);
        }
    }




    static if(!is(typeof(MSG_DONTWAIT))) {
        private enum enumMixinStr_MSG_DONTWAIT = `enum MSG_DONTWAIT = MSG_DONTWAIT;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_DONTWAIT); }))) {
            mixin(enumMixinStr_MSG_DONTWAIT);
        }
    }




    static if(!is(typeof(MSG_EOR))) {
        private enum enumMixinStr_MSG_EOR = `enum MSG_EOR = MSG_EOR;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_EOR); }))) {
            mixin(enumMixinStr_MSG_EOR);
        }
    }




    static if(!is(typeof(MSG_WAITALL))) {
        private enum enumMixinStr_MSG_WAITALL = `enum MSG_WAITALL = MSG_WAITALL;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_WAITALL); }))) {
            mixin(enumMixinStr_MSG_WAITALL);
        }
    }




    static if(!is(typeof(MSG_FIN))) {
        private enum enumMixinStr_MSG_FIN = `enum MSG_FIN = MSG_FIN;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_FIN); }))) {
            mixin(enumMixinStr_MSG_FIN);
        }
    }




    static if(!is(typeof(MSG_SYN))) {
        private enum enumMixinStr_MSG_SYN = `enum MSG_SYN = MSG_SYN;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_SYN); }))) {
            mixin(enumMixinStr_MSG_SYN);
        }
    }




    static if(!is(typeof(MSG_CONFIRM))) {
        private enum enumMixinStr_MSG_CONFIRM = `enum MSG_CONFIRM = MSG_CONFIRM;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_CONFIRM); }))) {
            mixin(enumMixinStr_MSG_CONFIRM);
        }
    }




    static if(!is(typeof(MSG_RST))) {
        private enum enumMixinStr_MSG_RST = `enum MSG_RST = MSG_RST;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_RST); }))) {
            mixin(enumMixinStr_MSG_RST);
        }
    }




    static if(!is(typeof(MSG_ERRQUEUE))) {
        private enum enumMixinStr_MSG_ERRQUEUE = `enum MSG_ERRQUEUE = MSG_ERRQUEUE;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_ERRQUEUE); }))) {
            mixin(enumMixinStr_MSG_ERRQUEUE);
        }
    }




    static if(!is(typeof(MSG_NOSIGNAL))) {
        private enum enumMixinStr_MSG_NOSIGNAL = `enum MSG_NOSIGNAL = MSG_NOSIGNAL;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_NOSIGNAL); }))) {
            mixin(enumMixinStr_MSG_NOSIGNAL);
        }
    }




    static if(!is(typeof(MSG_MORE))) {
        private enum enumMixinStr_MSG_MORE = `enum MSG_MORE = MSG_MORE;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_MORE); }))) {
            mixin(enumMixinStr_MSG_MORE);
        }
    }




    static if(!is(typeof(MSG_WAITFORONE))) {
        private enum enumMixinStr_MSG_WAITFORONE = `enum MSG_WAITFORONE = MSG_WAITFORONE;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_WAITFORONE); }))) {
            mixin(enumMixinStr_MSG_WAITFORONE);
        }
    }




    static if(!is(typeof(MSG_BATCH))) {
        private enum enumMixinStr_MSG_BATCH = `enum MSG_BATCH = MSG_BATCH;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_BATCH); }))) {
            mixin(enumMixinStr_MSG_BATCH);
        }
    }




    static if(!is(typeof(MSG_ZEROCOPY))) {
        private enum enumMixinStr_MSG_ZEROCOPY = `enum MSG_ZEROCOPY = MSG_ZEROCOPY;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_ZEROCOPY); }))) {
            mixin(enumMixinStr_MSG_ZEROCOPY);
        }
    }




    static if(!is(typeof(MSG_FASTOPEN))) {
        private enum enumMixinStr_MSG_FASTOPEN = `enum MSG_FASTOPEN = MSG_FASTOPEN;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_FASTOPEN); }))) {
            mixin(enumMixinStr_MSG_FASTOPEN);
        }
    }




    static if(!is(typeof(MSG_CMSG_CLOEXEC))) {
        private enum enumMixinStr_MSG_CMSG_CLOEXEC = `enum MSG_CMSG_CLOEXEC = MSG_CMSG_CLOEXEC;`;
        static if(is(typeof({ mixin(enumMixinStr_MSG_CMSG_CLOEXEC); }))) {
            mixin(enumMixinStr_MSG_CMSG_CLOEXEC);
        }
    }




    static if(!is(typeof(PF_LLC))) {
        private enum enumMixinStr_PF_LLC = `enum PF_LLC = 26;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_LLC); }))) {
            mixin(enumMixinStr_PF_LLC);
        }
    }




    static if(!is(typeof(PF_WANPIPE))) {
        private enum enumMixinStr_PF_WANPIPE = `enum PF_WANPIPE = 25;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_WANPIPE); }))) {
            mixin(enumMixinStr_PF_WANPIPE);
        }
    }




    static if(!is(typeof(PF_PPPOX))) {
        private enum enumMixinStr_PF_PPPOX = `enum PF_PPPOX = 24;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_PPPOX); }))) {
            mixin(enumMixinStr_PF_PPPOX);
        }
    }




    static if(!is(typeof(PF_IRDA))) {
        private enum enumMixinStr_PF_IRDA = `enum PF_IRDA = 23;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_IRDA); }))) {
            mixin(enumMixinStr_PF_IRDA);
        }
    }




    static if(!is(typeof(PF_SNA))) {
        private enum enumMixinStr_PF_SNA = `enum PF_SNA = 22;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_SNA); }))) {
            mixin(enumMixinStr_PF_SNA);
        }
    }
    static if(!is(typeof(PF_RDS))) {
        private enum enumMixinStr_PF_RDS = `enum PF_RDS = 21;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_RDS); }))) {
            mixin(enumMixinStr_PF_RDS);
        }
    }




    static if(!is(typeof(PF_ATMSVC))) {
        private enum enumMixinStr_PF_ATMSVC = `enum PF_ATMSVC = 20;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_ATMSVC); }))) {
            mixin(enumMixinStr_PF_ATMSVC);
        }
    }




    static if(!is(typeof(PF_ECONET))) {
        private enum enumMixinStr_PF_ECONET = `enum PF_ECONET = 19;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_ECONET); }))) {
            mixin(enumMixinStr_PF_ECONET);
        }
    }




    static if(!is(typeof(SCM_RIGHTS))) {
        private enum enumMixinStr_SCM_RIGHTS = `enum SCM_RIGHTS = SCM_RIGHTS;`;
        static if(is(typeof({ mixin(enumMixinStr_SCM_RIGHTS); }))) {
            mixin(enumMixinStr_SCM_RIGHTS);
        }
    }




    static if(!is(typeof(PF_ASH))) {
        private enum enumMixinStr_PF_ASH = `enum PF_ASH = 18;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_ASH); }))) {
            mixin(enumMixinStr_PF_ASH);
        }
    }




    static if(!is(typeof(PF_PACKET))) {
        private enum enumMixinStr_PF_PACKET = `enum PF_PACKET = 17;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_PACKET); }))) {
            mixin(enumMixinStr_PF_PACKET);
        }
    }




    static if(!is(typeof(PF_ROUTE))) {
        private enum enumMixinStr_PF_ROUTE = `enum PF_ROUTE = PF_NETLINK;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_ROUTE); }))) {
            mixin(enumMixinStr_PF_ROUTE);
        }
    }




    static if(!is(typeof(PF_NETLINK))) {
        private enum enumMixinStr_PF_NETLINK = `enum PF_NETLINK = 16;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_NETLINK); }))) {
            mixin(enumMixinStr_PF_NETLINK);
        }
    }




    static if(!is(typeof(PF_KEY))) {
        private enum enumMixinStr_PF_KEY = `enum PF_KEY = 15;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_KEY); }))) {
            mixin(enumMixinStr_PF_KEY);
        }
    }




    static if(!is(typeof(PF_SECURITY))) {
        private enum enumMixinStr_PF_SECURITY = `enum PF_SECURITY = 14;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_SECURITY); }))) {
            mixin(enumMixinStr_PF_SECURITY);
        }
    }




    static if(!is(typeof(SOCK_STREAM))) {
        private enum enumMixinStr_SOCK_STREAM = `enum SOCK_STREAM = SOCK_STREAM;`;
        static if(is(typeof({ mixin(enumMixinStr_SOCK_STREAM); }))) {
            mixin(enumMixinStr_SOCK_STREAM);
        }
    }




    static if(!is(typeof(SOCK_DGRAM))) {
        private enum enumMixinStr_SOCK_DGRAM = `enum SOCK_DGRAM = SOCK_DGRAM;`;
        static if(is(typeof({ mixin(enumMixinStr_SOCK_DGRAM); }))) {
            mixin(enumMixinStr_SOCK_DGRAM);
        }
    }




    static if(!is(typeof(SOCK_RAW))) {
        private enum enumMixinStr_SOCK_RAW = `enum SOCK_RAW = SOCK_RAW;`;
        static if(is(typeof({ mixin(enumMixinStr_SOCK_RAW); }))) {
            mixin(enumMixinStr_SOCK_RAW);
        }
    }




    static if(!is(typeof(SOCK_RDM))) {
        private enum enumMixinStr_SOCK_RDM = `enum SOCK_RDM = SOCK_RDM;`;
        static if(is(typeof({ mixin(enumMixinStr_SOCK_RDM); }))) {
            mixin(enumMixinStr_SOCK_RDM);
        }
    }




    static if(!is(typeof(SOCK_SEQPACKET))) {
        private enum enumMixinStr_SOCK_SEQPACKET = `enum SOCK_SEQPACKET = SOCK_SEQPACKET;`;
        static if(is(typeof({ mixin(enumMixinStr_SOCK_SEQPACKET); }))) {
            mixin(enumMixinStr_SOCK_SEQPACKET);
        }
    }




    static if(!is(typeof(SOCK_DCCP))) {
        private enum enumMixinStr_SOCK_DCCP = `enum SOCK_DCCP = SOCK_DCCP;`;
        static if(is(typeof({ mixin(enumMixinStr_SOCK_DCCP); }))) {
            mixin(enumMixinStr_SOCK_DCCP);
        }
    }




    static if(!is(typeof(SOCK_PACKET))) {
        private enum enumMixinStr_SOCK_PACKET = `enum SOCK_PACKET = SOCK_PACKET;`;
        static if(is(typeof({ mixin(enumMixinStr_SOCK_PACKET); }))) {
            mixin(enumMixinStr_SOCK_PACKET);
        }
    }




    static if(!is(typeof(SOCK_CLOEXEC))) {
        private enum enumMixinStr_SOCK_CLOEXEC = `enum SOCK_CLOEXEC = SOCK_CLOEXEC;`;
        static if(is(typeof({ mixin(enumMixinStr_SOCK_CLOEXEC); }))) {
            mixin(enumMixinStr_SOCK_CLOEXEC);
        }
    }




    static if(!is(typeof(SOCK_NONBLOCK))) {
        private enum enumMixinStr_SOCK_NONBLOCK = `enum SOCK_NONBLOCK = SOCK_NONBLOCK;`;
        static if(is(typeof({ mixin(enumMixinStr_SOCK_NONBLOCK); }))) {
            mixin(enumMixinStr_SOCK_NONBLOCK);
        }
    }




    static if(!is(typeof(PF_NETBEUI))) {
        private enum enumMixinStr_PF_NETBEUI = `enum PF_NETBEUI = 13;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_NETBEUI); }))) {
            mixin(enumMixinStr_PF_NETBEUI);
        }
    }




    static if(!is(typeof(_BITS_STAT_H))) {
        private enum enumMixinStr__BITS_STAT_H = `enum _BITS_STAT_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_STAT_H); }))) {
            mixin(enumMixinStr__BITS_STAT_H);
        }
    }




    static if(!is(typeof(PF_DECnet))) {
        private enum enumMixinStr_PF_DECnet = `enum PF_DECnet = 12;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_DECnet); }))) {
            mixin(enumMixinStr_PF_DECnet);
        }
    }




    static if(!is(typeof(__S_IFMT))) {
        private enum enumMixinStr___S_IFMT = `enum __S_IFMT = /+converted from octal '170000'+/ 61440;`;
        static if(is(typeof({ mixin(enumMixinStr___S_IFMT); }))) {
            mixin(enumMixinStr___S_IFMT);
        }
    }




    static if(!is(typeof(__S_IFDIR))) {
        private enum enumMixinStr___S_IFDIR = `enum __S_IFDIR = /+converted from octal '40000'+/ 16384;`;
        static if(is(typeof({ mixin(enumMixinStr___S_IFDIR); }))) {
            mixin(enumMixinStr___S_IFDIR);
        }
    }




    static if(!is(typeof(__S_IFCHR))) {
        private enum enumMixinStr___S_IFCHR = `enum __S_IFCHR = /+converted from octal '20000'+/ 8192;`;
        static if(is(typeof({ mixin(enumMixinStr___S_IFCHR); }))) {
            mixin(enumMixinStr___S_IFCHR);
        }
    }




    static if(!is(typeof(__S_IFBLK))) {
        private enum enumMixinStr___S_IFBLK = `enum __S_IFBLK = /+converted from octal '60000'+/ 24576;`;
        static if(is(typeof({ mixin(enumMixinStr___S_IFBLK); }))) {
            mixin(enumMixinStr___S_IFBLK);
        }
    }




    static if(!is(typeof(__S_IFREG))) {
        private enum enumMixinStr___S_IFREG = `enum __S_IFREG = /+converted from octal '100000'+/ 32768;`;
        static if(is(typeof({ mixin(enumMixinStr___S_IFREG); }))) {
            mixin(enumMixinStr___S_IFREG);
        }
    }




    static if(!is(typeof(__S_IFIFO))) {
        private enum enumMixinStr___S_IFIFO = `enum __S_IFIFO = /+converted from octal '10000'+/ 4096;`;
        static if(is(typeof({ mixin(enumMixinStr___S_IFIFO); }))) {
            mixin(enumMixinStr___S_IFIFO);
        }
    }




    static if(!is(typeof(__S_IFLNK))) {
        private enum enumMixinStr___S_IFLNK = `enum __S_IFLNK = /+converted from octal '120000'+/ 40960;`;
        static if(is(typeof({ mixin(enumMixinStr___S_IFLNK); }))) {
            mixin(enumMixinStr___S_IFLNK);
        }
    }




    static if(!is(typeof(__S_IFSOCK))) {
        private enum enumMixinStr___S_IFSOCK = `enum __S_IFSOCK = /+converted from octal '140000'+/ 49152;`;
        static if(is(typeof({ mixin(enumMixinStr___S_IFSOCK); }))) {
            mixin(enumMixinStr___S_IFSOCK);
        }
    }
    static if(!is(typeof(__S_ISUID))) {
        private enum enumMixinStr___S_ISUID = `enum __S_ISUID = /+converted from octal '4000'+/ 2048;`;
        static if(is(typeof({ mixin(enumMixinStr___S_ISUID); }))) {
            mixin(enumMixinStr___S_ISUID);
        }
    }




    static if(!is(typeof(__S_ISGID))) {
        private enum enumMixinStr___S_ISGID = `enum __S_ISGID = /+converted from octal '2000'+/ 1024;`;
        static if(is(typeof({ mixin(enumMixinStr___S_ISGID); }))) {
            mixin(enumMixinStr___S_ISGID);
        }
    }




    static if(!is(typeof(__S_ISVTX))) {
        private enum enumMixinStr___S_ISVTX = `enum __S_ISVTX = /+converted from octal '1000'+/ 512;`;
        static if(is(typeof({ mixin(enumMixinStr___S_ISVTX); }))) {
            mixin(enumMixinStr___S_ISVTX);
        }
    }




    static if(!is(typeof(__S_IREAD))) {
        private enum enumMixinStr___S_IREAD = `enum __S_IREAD = /+converted from octal '400'+/ 256;`;
        static if(is(typeof({ mixin(enumMixinStr___S_IREAD); }))) {
            mixin(enumMixinStr___S_IREAD);
        }
    }




    static if(!is(typeof(__S_IWRITE))) {
        private enum enumMixinStr___S_IWRITE = `enum __S_IWRITE = /+converted from octal '200'+/ 128;`;
        static if(is(typeof({ mixin(enumMixinStr___S_IWRITE); }))) {
            mixin(enumMixinStr___S_IWRITE);
        }
    }




    static if(!is(typeof(__S_IEXEC))) {
        private enum enumMixinStr___S_IEXEC = `enum __S_IEXEC = /+converted from octal '100'+/ 64;`;
        static if(is(typeof({ mixin(enumMixinStr___S_IEXEC); }))) {
            mixin(enumMixinStr___S_IEXEC);
        }
    }




    static if(!is(typeof(PF_ROSE))) {
        private enum enumMixinStr_PF_ROSE = `enum PF_ROSE = 11;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_ROSE); }))) {
            mixin(enumMixinStr_PF_ROSE);
        }
    }




    static if(!is(typeof(UTIME_NOW))) {
        private enum enumMixinStr_UTIME_NOW = `enum UTIME_NOW = ( ( 1L << 30 ) - 1L );`;
        static if(is(typeof({ mixin(enumMixinStr_UTIME_NOW); }))) {
            mixin(enumMixinStr_UTIME_NOW);
        }
    }




    static if(!is(typeof(UTIME_OMIT))) {
        private enum enumMixinStr_UTIME_OMIT = `enum UTIME_OMIT = ( ( 1L << 30 ) - 2L );`;
        static if(is(typeof({ mixin(enumMixinStr_UTIME_OMIT); }))) {
            mixin(enumMixinStr_UTIME_OMIT);
        }
    }




    static if(!is(typeof(_BITS_STDINT_INTN_H))) {
        private enum enumMixinStr__BITS_STDINT_INTN_H = `enum _BITS_STDINT_INTN_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_STDINT_INTN_H); }))) {
            mixin(enumMixinStr__BITS_STDINT_INTN_H);
        }
    }




    static if(!is(typeof(PF_INET6))) {
        private enum enumMixinStr_PF_INET6 = `enum PF_INET6 = 10;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_INET6); }))) {
            mixin(enumMixinStr_PF_INET6);
        }
    }




    static if(!is(typeof(PF_X25))) {
        private enum enumMixinStr_PF_X25 = `enum PF_X25 = 9;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_X25); }))) {
            mixin(enumMixinStr_PF_X25);
        }
    }




    static if(!is(typeof(PF_ATMPVC))) {
        private enum enumMixinStr_PF_ATMPVC = `enum PF_ATMPVC = 8;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_ATMPVC); }))) {
            mixin(enumMixinStr_PF_ATMPVC);
        }
    }




    static if(!is(typeof(PF_BRIDGE))) {
        private enum enumMixinStr_PF_BRIDGE = `enum PF_BRIDGE = 7;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_BRIDGE); }))) {
            mixin(enumMixinStr_PF_BRIDGE);
        }
    }




    static if(!is(typeof(PF_NETROM))) {
        private enum enumMixinStr_PF_NETROM = `enum PF_NETROM = 6;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_NETROM); }))) {
            mixin(enumMixinStr_PF_NETROM);
        }
    }




    static if(!is(typeof(_BITS_STDIO_LIM_H))) {
        private enum enumMixinStr__BITS_STDIO_LIM_H = `enum _BITS_STDIO_LIM_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_STDIO_LIM_H); }))) {
            mixin(enumMixinStr__BITS_STDIO_LIM_H);
        }
    }




    static if(!is(typeof(PF_APPLETALK))) {
        private enum enumMixinStr_PF_APPLETALK = `enum PF_APPLETALK = 5;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_APPLETALK); }))) {
            mixin(enumMixinStr_PF_APPLETALK);
        }
    }




    static if(!is(typeof(L_tmpnam))) {
        private enum enumMixinStr_L_tmpnam = `enum L_tmpnam = 20;`;
        static if(is(typeof({ mixin(enumMixinStr_L_tmpnam); }))) {
            mixin(enumMixinStr_L_tmpnam);
        }
    }




    static if(!is(typeof(TMP_MAX))) {
        private enum enumMixinStr_TMP_MAX = `enum TMP_MAX = 238328;`;
        static if(is(typeof({ mixin(enumMixinStr_TMP_MAX); }))) {
            mixin(enumMixinStr_TMP_MAX);
        }
    }




    static if(!is(typeof(FILENAME_MAX))) {
        private enum enumMixinStr_FILENAME_MAX = `enum FILENAME_MAX = 4096;`;
        static if(is(typeof({ mixin(enumMixinStr_FILENAME_MAX); }))) {
            mixin(enumMixinStr_FILENAME_MAX);
        }
    }




    static if(!is(typeof(PF_IPX))) {
        private enum enumMixinStr_PF_IPX = `enum PF_IPX = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_IPX); }))) {
            mixin(enumMixinStr_PF_IPX);
        }
    }




    static if(!is(typeof(L_ctermid))) {
        private enum enumMixinStr_L_ctermid = `enum L_ctermid = 9;`;
        static if(is(typeof({ mixin(enumMixinStr_L_ctermid); }))) {
            mixin(enumMixinStr_L_ctermid);
        }
    }




    static if(!is(typeof(PF_AX25))) {
        private enum enumMixinStr_PF_AX25 = `enum PF_AX25 = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_AX25); }))) {
            mixin(enumMixinStr_PF_AX25);
        }
    }




    static if(!is(typeof(FOPEN_MAX))) {
        private enum enumMixinStr_FOPEN_MAX = `enum FOPEN_MAX = 16;`;
        static if(is(typeof({ mixin(enumMixinStr_FOPEN_MAX); }))) {
            mixin(enumMixinStr_FOPEN_MAX);
        }
    }




    static if(!is(typeof(_THREAD_MUTEX_INTERNAL_H))) {
        private enum enumMixinStr__THREAD_MUTEX_INTERNAL_H = `enum _THREAD_MUTEX_INTERNAL_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__THREAD_MUTEX_INTERNAL_H); }))) {
            mixin(enumMixinStr__THREAD_MUTEX_INTERNAL_H);
        }
    }




    static if(!is(typeof(PF_INET))) {
        private enum enumMixinStr_PF_INET = `enum PF_INET = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_INET); }))) {
            mixin(enumMixinStr_PF_INET);
        }
    }




    static if(!is(typeof(PF_FILE))) {
        private enum enumMixinStr_PF_FILE = `enum PF_FILE = PF_LOCAL;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_FILE); }))) {
            mixin(enumMixinStr_PF_FILE);
        }
    }




    static if(!is(typeof(PF_UNIX))) {
        private enum enumMixinStr_PF_UNIX = `enum PF_UNIX = PF_LOCAL;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_UNIX); }))) {
            mixin(enumMixinStr_PF_UNIX);
        }
    }




    static if(!is(typeof(__PTHREAD_MUTEX_HAVE_PREV))) {
        private enum enumMixinStr___PTHREAD_MUTEX_HAVE_PREV = `enum __PTHREAD_MUTEX_HAVE_PREV = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___PTHREAD_MUTEX_HAVE_PREV); }))) {
            mixin(enumMixinStr___PTHREAD_MUTEX_HAVE_PREV);
        }
    }




    static if(!is(typeof(PF_LOCAL))) {
        private enum enumMixinStr_PF_LOCAL = `enum PF_LOCAL = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_LOCAL); }))) {
            mixin(enumMixinStr_PF_LOCAL);
        }
    }
    static if(!is(typeof(PF_UNSPEC))) {
        private enum enumMixinStr_PF_UNSPEC = `enum PF_UNSPEC = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_PF_UNSPEC); }))) {
            mixin(enumMixinStr_PF_UNSPEC);
        }
    }






    static if(!is(typeof(__PTHREAD_RWLOCK_ELISION_EXTRA))) {
        private enum enumMixinStr___PTHREAD_RWLOCK_ELISION_EXTRA = `enum __PTHREAD_RWLOCK_ELISION_EXTRA = 0 , { 0 , 0 , 0 , 0 , 0 , 0 , 0 };`;
        static if(is(typeof({ mixin(enumMixinStr___PTHREAD_RWLOCK_ELISION_EXTRA); }))) {
            mixin(enumMixinStr___PTHREAD_RWLOCK_ELISION_EXTRA);
        }
    }
    static if(!is(typeof(_BITS_STRUCT_STAT_H))) {
        private enum enumMixinStr__BITS_STRUCT_STAT_H = `enum _BITS_STRUCT_STAT_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_STRUCT_STAT_H); }))) {
            mixin(enumMixinStr__BITS_STRUCT_STAT_H);
        }
    }




    static if(!is(typeof(_SS_SIZE))) {
        private enum enumMixinStr__SS_SIZE = `enum _SS_SIZE = 128;`;
        static if(is(typeof({ mixin(enumMixinStr__SS_SIZE); }))) {
            mixin(enumMixinStr__SS_SIZE);
        }
    }




    static if(!is(typeof(__SOCKADDR_COMMON_SIZE))) {
        private enum enumMixinStr___SOCKADDR_COMMON_SIZE = `enum __SOCKADDR_COMMON_SIZE = ( ( unsigned short int ) .sizeof );`;
        static if(is(typeof({ mixin(enumMixinStr___SOCKADDR_COMMON_SIZE); }))) {
            mixin(enumMixinStr___SOCKADDR_COMMON_SIZE);
        }
    }






    static if(!is(typeof(_BITS_SOCKADDR_H))) {
        private enum enumMixinStr__BITS_SOCKADDR_H = `enum _BITS_SOCKADDR_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_SOCKADDR_H); }))) {
            mixin(enumMixinStr__BITS_SOCKADDR_H);
        }
    }
    static if(!is(typeof(__have_pthread_attr_t))) {
        private enum enumMixinStr___have_pthread_attr_t = `enum __have_pthread_attr_t = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___have_pthread_attr_t); }))) {
            mixin(enumMixinStr___have_pthread_attr_t);
        }
    }




    static if(!is(typeof(st_atime))) {
        private enum enumMixinStr_st_atime = `enum st_atime = st_atim . tv_sec;`;
        static if(is(typeof({ mixin(enumMixinStr_st_atime); }))) {
            mixin(enumMixinStr_st_atime);
        }
    }




    static if(!is(typeof(st_mtime))) {
        private enum enumMixinStr_st_mtime = `enum st_mtime = st_mtim . tv_sec;`;
        static if(is(typeof({ mixin(enumMixinStr_st_mtime); }))) {
            mixin(enumMixinStr_st_mtime);
        }
    }




    static if(!is(typeof(st_ctime))) {
        private enum enumMixinStr_st_ctime = `enum st_ctime = st_ctim . tv_sec;`;
        static if(is(typeof({ mixin(enumMixinStr_st_ctime); }))) {
            mixin(enumMixinStr_st_ctime);
        }
    }




    static if(!is(typeof(_BITS_PTHREADTYPES_COMMON_H))) {
        private enum enumMixinStr__BITS_PTHREADTYPES_COMMON_H = `enum _BITS_PTHREADTYPES_COMMON_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_PTHREADTYPES_COMMON_H); }))) {
            mixin(enumMixinStr__BITS_PTHREADTYPES_COMMON_H);
        }
    }
    static if(!is(typeof(_THREAD_SHARED_TYPES_H))) {
        private enum enumMixinStr__THREAD_SHARED_TYPES_H = `enum _THREAD_SHARED_TYPES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__THREAD_SHARED_TYPES_H); }))) {
            mixin(enumMixinStr__THREAD_SHARED_TYPES_H);
        }
    }
    static if(!is(typeof(__SIZEOF_PTHREAD_BARRIERATTR_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_BARRIERATTR_T = `enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_BARRIERATTR_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_BARRIERATTR_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_RWLOCKATTR_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_RWLOCKATTR_T = `enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_RWLOCKATTR_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_RWLOCKATTR_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_CONDATTR_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_CONDATTR_T = `enum __SIZEOF_PTHREAD_CONDATTR_T = 4;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_CONDATTR_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_CONDATTR_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_COND_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_COND_T = `enum __SIZEOF_PTHREAD_COND_T = 48;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_COND_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_COND_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_MUTEXATTR_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_MUTEXATTR_T = `enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_MUTEXATTR_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_MUTEXATTR_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_BARRIER_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_BARRIER_T = `enum __SIZEOF_PTHREAD_BARRIER_T = 32;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_BARRIER_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_BARRIER_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_RWLOCK_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_RWLOCK_T = `enum __SIZEOF_PTHREAD_RWLOCK_T = 56;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_RWLOCK_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_RWLOCK_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_ATTR_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_ATTR_T = `enum __SIZEOF_PTHREAD_ATTR_T = 56;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_ATTR_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_ATTR_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_MUTEX_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_MUTEX_T = `enum __SIZEOF_PTHREAD_MUTEX_T = 40;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_MUTEX_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_MUTEX_T);
        }
    }




    static if(!is(typeof(_BITS_PTHREADTYPES_ARCH_H))) {
        private enum enumMixinStr__BITS_PTHREADTYPES_ARCH_H = `enum _BITS_PTHREADTYPES_ARCH_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_PTHREADTYPES_ARCH_H); }))) {
            mixin(enumMixinStr__BITS_PTHREADTYPES_ARCH_H);
        }
    }




    static if(!is(typeof(_POSIX_TYPED_MEMORY_OBJECTS))) {
        private enum enumMixinStr__POSIX_TYPED_MEMORY_OBJECTS = `enum _POSIX_TYPED_MEMORY_OBJECTS = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_TYPED_MEMORY_OBJECTS); }))) {
            mixin(enumMixinStr__POSIX_TYPED_MEMORY_OBJECTS);
        }
    }




    static if(!is(typeof(_POSIX_TRACE_LOG))) {
        private enum enumMixinStr__POSIX_TRACE_LOG = `enum _POSIX_TRACE_LOG = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_TRACE_LOG); }))) {
            mixin(enumMixinStr__POSIX_TRACE_LOG);
        }
    }




    static if(!is(typeof(_POSIX_TRACE_INHERIT))) {
        private enum enumMixinStr__POSIX_TRACE_INHERIT = `enum _POSIX_TRACE_INHERIT = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_TRACE_INHERIT); }))) {
            mixin(enumMixinStr__POSIX_TRACE_INHERIT);
        }
    }




    static if(!is(typeof(__ONCE_FLAG_INIT))) {
        private enum enumMixinStr___ONCE_FLAG_INIT = `enum __ONCE_FLAG_INIT = { 0 };`;
        static if(is(typeof({ mixin(enumMixinStr___ONCE_FLAG_INIT); }))) {
            mixin(enumMixinStr___ONCE_FLAG_INIT);
        }
    }




    static if(!is(typeof(_POSIX_TRACE_EVENT_FILTER))) {
        private enum enumMixinStr__POSIX_TRACE_EVENT_FILTER = `enum _POSIX_TRACE_EVENT_FILTER = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_TRACE_EVENT_FILTER); }))) {
            mixin(enumMixinStr__POSIX_TRACE_EVENT_FILTER);
        }
    }




    static if(!is(typeof(_BITS_TIME64_H))) {
        private enum enumMixinStr__BITS_TIME64_H = `enum _BITS_TIME64_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TIME64_H); }))) {
            mixin(enumMixinStr__BITS_TIME64_H);
        }
    }




    static if(!is(typeof(_POSIX_TRACE))) {
        private enum enumMixinStr__POSIX_TRACE = `enum _POSIX_TRACE = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_TRACE); }))) {
            mixin(enumMixinStr__POSIX_TRACE);
        }
    }




    static if(!is(typeof(__TIME64_T_TYPE))) {
        private enum enumMixinStr___TIME64_T_TYPE = `enum __TIME64_T_TYPE = __TIME_T_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___TIME64_T_TYPE); }))) {
            mixin(enumMixinStr___TIME64_T_TYPE);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_SPORADIC_SERVER))) {
        private enum enumMixinStr__POSIX_THREAD_SPORADIC_SERVER = `enum _POSIX_THREAD_SPORADIC_SERVER = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_SPORADIC_SERVER); }))) {
            mixin(enumMixinStr__POSIX_THREAD_SPORADIC_SERVER);
        }
    }




    static if(!is(typeof(_POSIX_SPORADIC_SERVER))) {
        private enum enumMixinStr__POSIX_SPORADIC_SERVER = `enum _POSIX_SPORADIC_SERVER = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SPORADIC_SERVER); }))) {
            mixin(enumMixinStr__POSIX_SPORADIC_SERVER);
        }
    }




    static if(!is(typeof(_POSIX2_CHAR_TERM))) {
        private enum enumMixinStr__POSIX2_CHAR_TERM = `enum _POSIX2_CHAR_TERM = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_CHAR_TERM); }))) {
            mixin(enumMixinStr__POSIX2_CHAR_TERM);
        }
    }




    static if(!is(typeof(_POSIX_RAW_SOCKETS))) {
        private enum enumMixinStr__POSIX_RAW_SOCKETS = `enum _POSIX_RAW_SOCKETS = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_RAW_SOCKETS); }))) {
            mixin(enumMixinStr__POSIX_RAW_SOCKETS);
        }
    }




    static if(!is(typeof(__TIMESIZE))) {
        private enum enumMixinStr___TIMESIZE = `enum __TIMESIZE = __WORDSIZE;`;
        static if(is(typeof({ mixin(enumMixinStr___TIMESIZE); }))) {
            mixin(enumMixinStr___TIMESIZE);
        }
    }




    static if(!is(typeof(_BITS_TYPES_H))) {
        private enum enumMixinStr__BITS_TYPES_H = `enum _BITS_TYPES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TYPES_H); }))) {
            mixin(enumMixinStr__BITS_TYPES_H);
        }
    }




    static if(!is(typeof(_POSIX_IPV6))) {
        private enum enumMixinStr__POSIX_IPV6 = `enum _POSIX_IPV6 = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_IPV6); }))) {
            mixin(enumMixinStr__POSIX_IPV6);
        }
    }




    static if(!is(typeof(_POSIX_ADVISORY_INFO))) {
        private enum enumMixinStr__POSIX_ADVISORY_INFO = `enum _POSIX_ADVISORY_INFO = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_ADVISORY_INFO); }))) {
            mixin(enumMixinStr__POSIX_ADVISORY_INFO);
        }
    }




    static if(!is(typeof(_POSIX_CLOCK_SELECTION))) {
        private enum enumMixinStr__POSIX_CLOCK_SELECTION = `enum _POSIX_CLOCK_SELECTION = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_CLOCK_SELECTION); }))) {
            mixin(enumMixinStr__POSIX_CLOCK_SELECTION);
        }
    }




    static if(!is(typeof(_POSIX_MONOTONIC_CLOCK))) {
        private enum enumMixinStr__POSIX_MONOTONIC_CLOCK = `enum _POSIX_MONOTONIC_CLOCK = 0;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_MONOTONIC_CLOCK); }))) {
            mixin(enumMixinStr__POSIX_MONOTONIC_CLOCK);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_PROCESS_SHARED))) {
        private enum enumMixinStr__POSIX_THREAD_PROCESS_SHARED = `enum _POSIX_THREAD_PROCESS_SHARED = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_PROCESS_SHARED); }))) {
            mixin(enumMixinStr__POSIX_THREAD_PROCESS_SHARED);
        }
    }




    static if(!is(typeof(_POSIX_MESSAGE_PASSING))) {
        private enum enumMixinStr__POSIX_MESSAGE_PASSING = `enum _POSIX_MESSAGE_PASSING = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_MESSAGE_PASSING); }))) {
            mixin(enumMixinStr__POSIX_MESSAGE_PASSING);
        }
    }




    static if(!is(typeof(_POSIX_BARRIERS))) {
        private enum enumMixinStr__POSIX_BARRIERS = `enum _POSIX_BARRIERS = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_BARRIERS); }))) {
            mixin(enumMixinStr__POSIX_BARRIERS);
        }
    }




    static if(!is(typeof(_POSIX_TIMERS))) {
        private enum enumMixinStr__POSIX_TIMERS = `enum _POSIX_TIMERS = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_TIMERS); }))) {
            mixin(enumMixinStr__POSIX_TIMERS);
        }
    }




    static if(!is(typeof(_POSIX_SPAWN))) {
        private enum enumMixinStr__POSIX_SPAWN = `enum _POSIX_SPAWN = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SPAWN); }))) {
            mixin(enumMixinStr__POSIX_SPAWN);
        }
    }




    static if(!is(typeof(_POSIX_SPIN_LOCKS))) {
        private enum enumMixinStr__POSIX_SPIN_LOCKS = `enum _POSIX_SPIN_LOCKS = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SPIN_LOCKS); }))) {
            mixin(enumMixinStr__POSIX_SPIN_LOCKS);
        }
    }




    static if(!is(typeof(_POSIX_TIMEOUTS))) {
        private enum enumMixinStr__POSIX_TIMEOUTS = `enum _POSIX_TIMEOUTS = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_TIMEOUTS); }))) {
            mixin(enumMixinStr__POSIX_TIMEOUTS);
        }
    }




    static if(!is(typeof(_POSIX_SHELL))) {
        private enum enumMixinStr__POSIX_SHELL = `enum _POSIX_SHELL = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SHELL); }))) {
            mixin(enumMixinStr__POSIX_SHELL);
        }
    }




    static if(!is(typeof(_POSIX_READER_WRITER_LOCKS))) {
        private enum enumMixinStr__POSIX_READER_WRITER_LOCKS = `enum _POSIX_READER_WRITER_LOCKS = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_READER_WRITER_LOCKS); }))) {
            mixin(enumMixinStr__POSIX_READER_WRITER_LOCKS);
        }
    }




    static if(!is(typeof(_POSIX_REGEXP))) {
        private enum enumMixinStr__POSIX_REGEXP = `enum _POSIX_REGEXP = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_REGEXP); }))) {
            mixin(enumMixinStr__POSIX_REGEXP);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_CPUTIME))) {
        private enum enumMixinStr__POSIX_THREAD_CPUTIME = `enum _POSIX_THREAD_CPUTIME = 0;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_CPUTIME); }))) {
            mixin(enumMixinStr__POSIX_THREAD_CPUTIME);
        }
    }




    static if(!is(typeof(_POSIX_CPUTIME))) {
        private enum enumMixinStr__POSIX_CPUTIME = `enum _POSIX_CPUTIME = 0;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_CPUTIME); }))) {
            mixin(enumMixinStr__POSIX_CPUTIME);
        }
    }




    static if(!is(typeof(_POSIX_SHARED_MEMORY_OBJECTS))) {
        private enum enumMixinStr__POSIX_SHARED_MEMORY_OBJECTS = `enum _POSIX_SHARED_MEMORY_OBJECTS = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SHARED_MEMORY_OBJECTS); }))) {
            mixin(enumMixinStr__POSIX_SHARED_MEMORY_OBJECTS);
        }
    }




    static if(!is(typeof(_LFS64_STDIO))) {
        private enum enumMixinStr__LFS64_STDIO = `enum _LFS64_STDIO = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__LFS64_STDIO); }))) {
            mixin(enumMixinStr__LFS64_STDIO);
        }
    }




    static if(!is(typeof(_LFS64_LARGEFILE))) {
        private enum enumMixinStr__LFS64_LARGEFILE = `enum _LFS64_LARGEFILE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__LFS64_LARGEFILE); }))) {
            mixin(enumMixinStr__LFS64_LARGEFILE);
        }
    }




    static if(!is(typeof(_LFS_LARGEFILE))) {
        private enum enumMixinStr__LFS_LARGEFILE = `enum _LFS_LARGEFILE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__LFS_LARGEFILE); }))) {
            mixin(enumMixinStr__LFS_LARGEFILE);
        }
    }




    static if(!is(typeof(_LFS64_ASYNCHRONOUS_IO))) {
        private enum enumMixinStr__LFS64_ASYNCHRONOUS_IO = `enum _LFS64_ASYNCHRONOUS_IO = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__LFS64_ASYNCHRONOUS_IO); }))) {
            mixin(enumMixinStr__LFS64_ASYNCHRONOUS_IO);
        }
    }




    static if(!is(typeof(_POSIX_PRIORITIZED_IO))) {
        private enum enumMixinStr__POSIX_PRIORITIZED_IO = `enum _POSIX_PRIORITIZED_IO = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_PRIORITIZED_IO); }))) {
            mixin(enumMixinStr__POSIX_PRIORITIZED_IO);
        }
    }




    static if(!is(typeof(_LFS_ASYNCHRONOUS_IO))) {
        private enum enumMixinStr__LFS_ASYNCHRONOUS_IO = `enum _LFS_ASYNCHRONOUS_IO = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__LFS_ASYNCHRONOUS_IO); }))) {
            mixin(enumMixinStr__LFS_ASYNCHRONOUS_IO);
        }
    }




    static if(!is(typeof(_POSIX_ASYNC_IO))) {
        private enum enumMixinStr__POSIX_ASYNC_IO = `enum _POSIX_ASYNC_IO = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_ASYNC_IO); }))) {
            mixin(enumMixinStr__POSIX_ASYNC_IO);
        }
    }




    static if(!is(typeof(_POSIX_ASYNCHRONOUS_IO))) {
        private enum enumMixinStr__POSIX_ASYNCHRONOUS_IO = `enum _POSIX_ASYNCHRONOUS_IO = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_ASYNCHRONOUS_IO); }))) {
            mixin(enumMixinStr__POSIX_ASYNCHRONOUS_IO);
        }
    }




    static if(!is(typeof(_POSIX_REALTIME_SIGNALS))) {
        private enum enumMixinStr__POSIX_REALTIME_SIGNALS = `enum _POSIX_REALTIME_SIGNALS = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_REALTIME_SIGNALS); }))) {
            mixin(enumMixinStr__POSIX_REALTIME_SIGNALS);
        }
    }




    static if(!is(typeof(_POSIX_SEMAPHORES))) {
        private enum enumMixinStr__POSIX_SEMAPHORES = `enum _POSIX_SEMAPHORES = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SEMAPHORES); }))) {
            mixin(enumMixinStr__POSIX_SEMAPHORES);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_ROBUST_PRIO_PROTECT))) {
        private enum enumMixinStr__POSIX_THREAD_ROBUST_PRIO_PROTECT = `enum _POSIX_THREAD_ROBUST_PRIO_PROTECT = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_ROBUST_PRIO_PROTECT); }))) {
            mixin(enumMixinStr__POSIX_THREAD_ROBUST_PRIO_PROTECT);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_ROBUST_PRIO_INHERIT))) {
        private enum enumMixinStr__POSIX_THREAD_ROBUST_PRIO_INHERIT = `enum _POSIX_THREAD_ROBUST_PRIO_INHERIT = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_ROBUST_PRIO_INHERIT); }))) {
            mixin(enumMixinStr__POSIX_THREAD_ROBUST_PRIO_INHERIT);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_PRIO_PROTECT))) {
        private enum enumMixinStr__POSIX_THREAD_PRIO_PROTECT = `enum _POSIX_THREAD_PRIO_PROTECT = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_PRIO_PROTECT); }))) {
            mixin(enumMixinStr__POSIX_THREAD_PRIO_PROTECT);
        }
    }




    static if(!is(typeof(__S16_TYPE))) {
        private enum enumMixinStr___S16_TYPE = `enum __S16_TYPE = short int;`;
        static if(is(typeof({ mixin(enumMixinStr___S16_TYPE); }))) {
            mixin(enumMixinStr___S16_TYPE);
        }
    }




    static if(!is(typeof(__U16_TYPE))) {
        private enum enumMixinStr___U16_TYPE = `enum __U16_TYPE = unsigned short int;`;
        static if(is(typeof({ mixin(enumMixinStr___U16_TYPE); }))) {
            mixin(enumMixinStr___U16_TYPE);
        }
    }




    static if(!is(typeof(__S32_TYPE))) {
        private enum enumMixinStr___S32_TYPE = `enum __S32_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___S32_TYPE); }))) {
            mixin(enumMixinStr___S32_TYPE);
        }
    }




    static if(!is(typeof(__U32_TYPE))) {
        private enum enumMixinStr___U32_TYPE = `enum __U32_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___U32_TYPE); }))) {
            mixin(enumMixinStr___U32_TYPE);
        }
    }




    static if(!is(typeof(__SLONGWORD_TYPE))) {
        private enum enumMixinStr___SLONGWORD_TYPE = `enum __SLONGWORD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SLONGWORD_TYPE); }))) {
            mixin(enumMixinStr___SLONGWORD_TYPE);
        }
    }




    static if(!is(typeof(__ULONGWORD_TYPE))) {
        private enum enumMixinStr___ULONGWORD_TYPE = `enum __ULONGWORD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___ULONGWORD_TYPE); }))) {
            mixin(enumMixinStr___ULONGWORD_TYPE);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_PRIO_INHERIT))) {
        private enum enumMixinStr__POSIX_THREAD_PRIO_INHERIT = `enum _POSIX_THREAD_PRIO_INHERIT = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_PRIO_INHERIT); }))) {
            mixin(enumMixinStr__POSIX_THREAD_PRIO_INHERIT);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_ATTR_STACKADDR))) {
        private enum enumMixinStr__POSIX_THREAD_ATTR_STACKADDR = `enum _POSIX_THREAD_ATTR_STACKADDR = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_ATTR_STACKADDR); }))) {
            mixin(enumMixinStr__POSIX_THREAD_ATTR_STACKADDR);
        }
    }




    static if(!is(typeof(__SQUAD_TYPE))) {
        private enum enumMixinStr___SQUAD_TYPE = `enum __SQUAD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SQUAD_TYPE); }))) {
            mixin(enumMixinStr___SQUAD_TYPE);
        }
    }




    static if(!is(typeof(__UQUAD_TYPE))) {
        private enum enumMixinStr___UQUAD_TYPE = `enum __UQUAD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___UQUAD_TYPE); }))) {
            mixin(enumMixinStr___UQUAD_TYPE);
        }
    }




    static if(!is(typeof(__SWORD_TYPE))) {
        private enum enumMixinStr___SWORD_TYPE = `enum __SWORD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SWORD_TYPE); }))) {
            mixin(enumMixinStr___SWORD_TYPE);
        }
    }




    static if(!is(typeof(__UWORD_TYPE))) {
        private enum enumMixinStr___UWORD_TYPE = `enum __UWORD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___UWORD_TYPE); }))) {
            mixin(enumMixinStr___UWORD_TYPE);
        }
    }




    static if(!is(typeof(__SLONG32_TYPE))) {
        private enum enumMixinStr___SLONG32_TYPE = `enum __SLONG32_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___SLONG32_TYPE); }))) {
            mixin(enumMixinStr___SLONG32_TYPE);
        }
    }




    static if(!is(typeof(__ULONG32_TYPE))) {
        private enum enumMixinStr___ULONG32_TYPE = `enum __ULONG32_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___ULONG32_TYPE); }))) {
            mixin(enumMixinStr___ULONG32_TYPE);
        }
    }




    static if(!is(typeof(__S64_TYPE))) {
        private enum enumMixinStr___S64_TYPE = `enum __S64_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___S64_TYPE); }))) {
            mixin(enumMixinStr___S64_TYPE);
        }
    }




    static if(!is(typeof(__U64_TYPE))) {
        private enum enumMixinStr___U64_TYPE = `enum __U64_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___U64_TYPE); }))) {
            mixin(enumMixinStr___U64_TYPE);
        }
    }




    static if(!is(typeof(__STD_TYPE))) {
        private enum enumMixinStr___STD_TYPE = `enum __STD_TYPE = typedef;`;
        static if(is(typeof({ mixin(enumMixinStr___STD_TYPE); }))) {
            mixin(enumMixinStr___STD_TYPE);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_ATTR_STACKSIZE))) {
        private enum enumMixinStr__POSIX_THREAD_ATTR_STACKSIZE = `enum _POSIX_THREAD_ATTR_STACKSIZE = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_ATTR_STACKSIZE); }))) {
            mixin(enumMixinStr__POSIX_THREAD_ATTR_STACKSIZE);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_PRIORITY_SCHEDULING))) {
        private enum enumMixinStr__POSIX_THREAD_PRIORITY_SCHEDULING = `enum _POSIX_THREAD_PRIORITY_SCHEDULING = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_PRIORITY_SCHEDULING); }))) {
            mixin(enumMixinStr__POSIX_THREAD_PRIORITY_SCHEDULING);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_SAFE_FUNCTIONS))) {
        private enum enumMixinStr__POSIX_THREAD_SAFE_FUNCTIONS = `enum _POSIX_THREAD_SAFE_FUNCTIONS = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_SAFE_FUNCTIONS); }))) {
            mixin(enumMixinStr__POSIX_THREAD_SAFE_FUNCTIONS);
        }
    }




    static if(!is(typeof(_POSIX_REENTRANT_FUNCTIONS))) {
        private enum enumMixinStr__POSIX_REENTRANT_FUNCTIONS = `enum _POSIX_REENTRANT_FUNCTIONS = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_REENTRANT_FUNCTIONS); }))) {
            mixin(enumMixinStr__POSIX_REENTRANT_FUNCTIONS);
        }
    }




    static if(!is(typeof(_POSIX_THREADS))) {
        private enum enumMixinStr__POSIX_THREADS = `enum _POSIX_THREADS = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREADS); }))) {
            mixin(enumMixinStr__POSIX_THREADS);
        }
    }




    static if(!is(typeof(_XOPEN_SHM))) {
        private enum enumMixinStr__XOPEN_SHM = `enum _XOPEN_SHM = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__XOPEN_SHM); }))) {
            mixin(enumMixinStr__XOPEN_SHM);
        }
    }




    static if(!is(typeof(_XOPEN_REALTIME_THREADS))) {
        private enum enumMixinStr__XOPEN_REALTIME_THREADS = `enum _XOPEN_REALTIME_THREADS = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__XOPEN_REALTIME_THREADS); }))) {
            mixin(enumMixinStr__XOPEN_REALTIME_THREADS);
        }
    }




    static if(!is(typeof(_XOPEN_REALTIME))) {
        private enum enumMixinStr__XOPEN_REALTIME = `enum _XOPEN_REALTIME = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__XOPEN_REALTIME); }))) {
            mixin(enumMixinStr__XOPEN_REALTIME);
        }
    }




    static if(!is(typeof(_POSIX_NO_TRUNC))) {
        private enum enumMixinStr__POSIX_NO_TRUNC = `enum _POSIX_NO_TRUNC = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_NO_TRUNC); }))) {
            mixin(enumMixinStr__POSIX_NO_TRUNC);
        }
    }




    static if(!is(typeof(_POSIX_VDISABLE))) {
        private enum enumMixinStr__POSIX_VDISABLE = `enum _POSIX_VDISABLE = '\0';`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_VDISABLE); }))) {
            mixin(enumMixinStr__POSIX_VDISABLE);
        }
    }




    static if(!is(typeof(_POSIX_CHOWN_RESTRICTED))) {
        private enum enumMixinStr__POSIX_CHOWN_RESTRICTED = `enum _POSIX_CHOWN_RESTRICTED = 0;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_CHOWN_RESTRICTED); }))) {
            mixin(enumMixinStr__POSIX_CHOWN_RESTRICTED);
        }
    }




    static if(!is(typeof(_POSIX_MEMORY_PROTECTION))) {
        private enum enumMixinStr__POSIX_MEMORY_PROTECTION = `enum _POSIX_MEMORY_PROTECTION = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_MEMORY_PROTECTION); }))) {
            mixin(enumMixinStr__POSIX_MEMORY_PROTECTION);
        }
    }




    static if(!is(typeof(_POSIX_MEMLOCK_RANGE))) {
        private enum enumMixinStr__POSIX_MEMLOCK_RANGE = `enum _POSIX_MEMLOCK_RANGE = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_MEMLOCK_RANGE); }))) {
            mixin(enumMixinStr__POSIX_MEMLOCK_RANGE);
        }
    }




    static if(!is(typeof(_POSIX_MEMLOCK))) {
        private enum enumMixinStr__POSIX_MEMLOCK = `enum _POSIX_MEMLOCK = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_MEMLOCK); }))) {
            mixin(enumMixinStr__POSIX_MEMLOCK);
        }
    }




    static if(!is(typeof(_POSIX_MAPPED_FILES))) {
        private enum enumMixinStr__POSIX_MAPPED_FILES = `enum _POSIX_MAPPED_FILES = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_MAPPED_FILES); }))) {
            mixin(enumMixinStr__POSIX_MAPPED_FILES);
        }
    }




    static if(!is(typeof(_POSIX_FSYNC))) {
        private enum enumMixinStr__POSIX_FSYNC = `enum _POSIX_FSYNC = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_FSYNC); }))) {
            mixin(enumMixinStr__POSIX_FSYNC);
        }
    }




    static if(!is(typeof(_POSIX_SYNCHRONIZED_IO))) {
        private enum enumMixinStr__POSIX_SYNCHRONIZED_IO = `enum _POSIX_SYNCHRONIZED_IO = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SYNCHRONIZED_IO); }))) {
            mixin(enumMixinStr__POSIX_SYNCHRONIZED_IO);
        }
    }




    static if(!is(typeof(_POSIX_PRIORITY_SCHEDULING))) {
        private enum enumMixinStr__POSIX_PRIORITY_SCHEDULING = `enum _POSIX_PRIORITY_SCHEDULING = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_PRIORITY_SCHEDULING); }))) {
            mixin(enumMixinStr__POSIX_PRIORITY_SCHEDULING);
        }
    }




    static if(!is(typeof(_POSIX_SAVED_IDS))) {
        private enum enumMixinStr__POSIX_SAVED_IDS = `enum _POSIX_SAVED_IDS = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SAVED_IDS); }))) {
            mixin(enumMixinStr__POSIX_SAVED_IDS);
        }
    }




    static if(!is(typeof(_POSIX_JOB_CONTROL))) {
        private enum enumMixinStr__POSIX_JOB_CONTROL = `enum _POSIX_JOB_CONTROL = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_JOB_CONTROL); }))) {
            mixin(enumMixinStr__POSIX_JOB_CONTROL);
        }
    }




    static if(!is(typeof(_BITS_POSIX_OPT_H))) {
        private enum enumMixinStr__BITS_POSIX_OPT_H = `enum _BITS_POSIX_OPT_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_POSIX_OPT_H); }))) {
            mixin(enumMixinStr__BITS_POSIX_OPT_H);
        }
    }




    static if(!is(typeof(__LDOUBLE_REDIRECTS_TO_FLOAT128_ABI))) {
        private enum enumMixinStr___LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = `enum __LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___LDOUBLE_REDIRECTS_TO_FLOAT128_ABI); }))) {
            mixin(enumMixinStr___LDOUBLE_REDIRECTS_TO_FLOAT128_ABI);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_TYPES_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_TYPES_EXT = `enum __GLIBC_USE_IEC_60559_TYPES_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_TYPES_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_TYPES_EXT);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT_C2X))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = `enum __GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT_C2X); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT_C2X);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT = `enum __GLIBC_USE_IEC_60559_FUNCS_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_EXT = `enum __GLIBC_USE_IEC_60559_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_EXT);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_BFP_EXT_C2X))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT_C2X = `enum __GLIBC_USE_IEC_60559_BFP_EXT_C2X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT_C2X); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT_C2X);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_BFP_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT = `enum __GLIBC_USE_IEC_60559_BFP_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT);
        }
    }




    static if(!is(typeof(__GLIBC_USE_LIB_EXT2))) {
        private enum enumMixinStr___GLIBC_USE_LIB_EXT2 = `enum __GLIBC_USE_LIB_EXT2 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_LIB_EXT2); }))) {
            mixin(enumMixinStr___GLIBC_USE_LIB_EXT2);
        }
    }




    static if(!is(typeof(SIOCPROTOPRIVATE))) {
        private enum enumMixinStr_SIOCPROTOPRIVATE = `enum SIOCPROTOPRIVATE = 0x89E0;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCPROTOPRIVATE); }))) {
            mixin(enumMixinStr_SIOCPROTOPRIVATE);
        }
    }




    static if(!is(typeof(SIOCDEVPRIVATE))) {
        private enum enumMixinStr_SIOCDEVPRIVATE = `enum SIOCDEVPRIVATE = 0x89F0;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCDEVPRIVATE); }))) {
            mixin(enumMixinStr_SIOCDEVPRIVATE);
        }
    }




    static if(!is(typeof(SIOCDELDLCI))) {
        private enum enumMixinStr_SIOCDELDLCI = `enum SIOCDELDLCI = 0x8981;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCDELDLCI); }))) {
            mixin(enumMixinStr_SIOCDELDLCI);
        }
    }




    static if(!is(typeof(SIOCADDDLCI))) {
        private enum enumMixinStr_SIOCADDDLCI = `enum SIOCADDDLCI = 0x8980;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCADDDLCI); }))) {
            mixin(enumMixinStr_SIOCADDDLCI);
        }
    }




    static if(!is(typeof(SIOCSIFMAP))) {
        private enum enumMixinStr_SIOCSIFMAP = `enum SIOCSIFMAP = 0x8971;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFMAP); }))) {
            mixin(enumMixinStr_SIOCSIFMAP);
        }
    }




    static if(!is(typeof(SIOCGIFMAP))) {
        private enum enumMixinStr_SIOCGIFMAP = `enum SIOCGIFMAP = 0x8970;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFMAP); }))) {
            mixin(enumMixinStr_SIOCGIFMAP);
        }
    }




    static if(!is(typeof(SIOCSRARP))) {
        private enum enumMixinStr_SIOCSRARP = `enum SIOCSRARP = 0x8962;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSRARP); }))) {
            mixin(enumMixinStr_SIOCSRARP);
        }
    }




    static if(!is(typeof(SIOCGRARP))) {
        private enum enumMixinStr_SIOCGRARP = `enum SIOCGRARP = 0x8961;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGRARP); }))) {
            mixin(enumMixinStr_SIOCGRARP);
        }
    }




    static if(!is(typeof(SIOCDRARP))) {
        private enum enumMixinStr_SIOCDRARP = `enum SIOCDRARP = 0x8960;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCDRARP); }))) {
            mixin(enumMixinStr_SIOCDRARP);
        }
    }




    static if(!is(typeof(SIOCSARP))) {
        private enum enumMixinStr_SIOCSARP = `enum SIOCSARP = 0x8955;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSARP); }))) {
            mixin(enumMixinStr_SIOCSARP);
        }
    }




    static if(!is(typeof(SIOCGARP))) {
        private enum enumMixinStr_SIOCGARP = `enum SIOCGARP = 0x8954;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGARP); }))) {
            mixin(enumMixinStr_SIOCGARP);
        }
    }




    static if(!is(typeof(SIOCDARP))) {
        private enum enumMixinStr_SIOCDARP = `enum SIOCDARP = 0x8953;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCDARP); }))) {
            mixin(enumMixinStr_SIOCDARP);
        }
    }




    static if(!is(typeof(SIOCSIFTXQLEN))) {
        private enum enumMixinStr_SIOCSIFTXQLEN = `enum SIOCSIFTXQLEN = 0x8943;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFTXQLEN); }))) {
            mixin(enumMixinStr_SIOCSIFTXQLEN);
        }
    }




    static if(!is(typeof(SIOCGIFTXQLEN))) {
        private enum enumMixinStr_SIOCGIFTXQLEN = `enum SIOCGIFTXQLEN = 0x8942;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFTXQLEN); }))) {
            mixin(enumMixinStr_SIOCGIFTXQLEN);
        }
    }




    static if(!is(typeof(SIOCSIFBR))) {
        private enum enumMixinStr_SIOCSIFBR = `enum SIOCSIFBR = 0x8941;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFBR); }))) {
            mixin(enumMixinStr_SIOCSIFBR);
        }
    }




    static if(!is(typeof(SIOCGIFBR))) {
        private enum enumMixinStr_SIOCGIFBR = `enum SIOCGIFBR = 0x8940;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFBR); }))) {
            mixin(enumMixinStr_SIOCGIFBR);
        }
    }




    static if(!is(typeof(SIOCGIFCOUNT))) {
        private enum enumMixinStr_SIOCGIFCOUNT = `enum SIOCGIFCOUNT = 0x8938;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFCOUNT); }))) {
            mixin(enumMixinStr_SIOCGIFCOUNT);
        }
    }




    static if(!is(typeof(SIOCSIFHWBROADCAST))) {
        private enum enumMixinStr_SIOCSIFHWBROADCAST = `enum SIOCSIFHWBROADCAST = 0x8937;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFHWBROADCAST); }))) {
            mixin(enumMixinStr_SIOCSIFHWBROADCAST);
        }
    }




    static if(!is(typeof(SIOCDIFADDR))) {
        private enum enumMixinStr_SIOCDIFADDR = `enum SIOCDIFADDR = 0x8936;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCDIFADDR); }))) {
            mixin(enumMixinStr_SIOCDIFADDR);
        }
    }




    static if(!is(typeof(SIOCGIFPFLAGS))) {
        private enum enumMixinStr_SIOCGIFPFLAGS = `enum SIOCGIFPFLAGS = 0x8935;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFPFLAGS); }))) {
            mixin(enumMixinStr_SIOCGIFPFLAGS);
        }
    }




    static if(!is(typeof(SIOCSIFPFLAGS))) {
        private enum enumMixinStr_SIOCSIFPFLAGS = `enum SIOCSIFPFLAGS = 0x8934;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFPFLAGS); }))) {
            mixin(enumMixinStr_SIOCSIFPFLAGS);
        }
    }




    static if(!is(typeof(SIOGIFINDEX))) {
        private enum enumMixinStr_SIOGIFINDEX = `enum SIOGIFINDEX = SIOCGIFINDEX;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOGIFINDEX); }))) {
            mixin(enumMixinStr_SIOGIFINDEX);
        }
    }




    static if(!is(typeof(SIOCGIFINDEX))) {
        private enum enumMixinStr_SIOCGIFINDEX = `enum SIOCGIFINDEX = 0x8933;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFINDEX); }))) {
            mixin(enumMixinStr_SIOCGIFINDEX);
        }
    }




    static if(!is(typeof(SIOCDELMULTI))) {
        private enum enumMixinStr_SIOCDELMULTI = `enum SIOCDELMULTI = 0x8932;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCDELMULTI); }))) {
            mixin(enumMixinStr_SIOCDELMULTI);
        }
    }




    static if(!is(typeof(SIOCADDMULTI))) {
        private enum enumMixinStr_SIOCADDMULTI = `enum SIOCADDMULTI = 0x8931;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCADDMULTI); }))) {
            mixin(enumMixinStr_SIOCADDMULTI);
        }
    }




    static if(!is(typeof(SIOCSIFSLAVE))) {
        private enum enumMixinStr_SIOCSIFSLAVE = `enum SIOCSIFSLAVE = 0x8930;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFSLAVE); }))) {
            mixin(enumMixinStr_SIOCSIFSLAVE);
        }
    }




    static if(!is(typeof(SIOCGIFSLAVE))) {
        private enum enumMixinStr_SIOCGIFSLAVE = `enum SIOCGIFSLAVE = 0x8929;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFSLAVE); }))) {
            mixin(enumMixinStr_SIOCGIFSLAVE);
        }
    }




    static if(!is(typeof(SIOCGIFHWADDR))) {
        private enum enumMixinStr_SIOCGIFHWADDR = `enum SIOCGIFHWADDR = 0x8927;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFHWADDR); }))) {
            mixin(enumMixinStr_SIOCGIFHWADDR);
        }
    }




    static if(!is(typeof(SIOCSIFENCAP))) {
        private enum enumMixinStr_SIOCSIFENCAP = `enum SIOCSIFENCAP = 0x8926;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFENCAP); }))) {
            mixin(enumMixinStr_SIOCSIFENCAP);
        }
    }




    static if(!is(typeof(SIOCGIFENCAP))) {
        private enum enumMixinStr_SIOCGIFENCAP = `enum SIOCGIFENCAP = 0x8925;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFENCAP); }))) {
            mixin(enumMixinStr_SIOCGIFENCAP);
        }
    }




    static if(!is(typeof(SIOCSIFHWADDR))) {
        private enum enumMixinStr_SIOCSIFHWADDR = `enum SIOCSIFHWADDR = 0x8924;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFHWADDR); }))) {
            mixin(enumMixinStr_SIOCSIFHWADDR);
        }
    }




    static if(!is(typeof(SIOCSIFNAME))) {
        private enum enumMixinStr_SIOCSIFNAME = `enum SIOCSIFNAME = 0x8923;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFNAME); }))) {
            mixin(enumMixinStr_SIOCSIFNAME);
        }
    }




    static if(!is(typeof(SIOCSIFMTU))) {
        private enum enumMixinStr_SIOCSIFMTU = `enum SIOCSIFMTU = 0x8922;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFMTU); }))) {
            mixin(enumMixinStr_SIOCSIFMTU);
        }
    }




    static if(!is(typeof(SIOCGIFMTU))) {
        private enum enumMixinStr_SIOCGIFMTU = `enum SIOCGIFMTU = 0x8921;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFMTU); }))) {
            mixin(enumMixinStr_SIOCGIFMTU);
        }
    }




    static if(!is(typeof(SIOCSIFMEM))) {
        private enum enumMixinStr_SIOCSIFMEM = `enum SIOCSIFMEM = 0x8920;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFMEM); }))) {
            mixin(enumMixinStr_SIOCSIFMEM);
        }
    }




    static if(!is(typeof(SIOCGIFMEM))) {
        private enum enumMixinStr_SIOCGIFMEM = `enum SIOCGIFMEM = 0x891f;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFMEM); }))) {
            mixin(enumMixinStr_SIOCGIFMEM);
        }
    }




    static if(!is(typeof(SIOCSIFMETRIC))) {
        private enum enumMixinStr_SIOCSIFMETRIC = `enum SIOCSIFMETRIC = 0x891e;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFMETRIC); }))) {
            mixin(enumMixinStr_SIOCSIFMETRIC);
        }
    }




    static if(!is(typeof(SIOCGIFMETRIC))) {
        private enum enumMixinStr_SIOCGIFMETRIC = `enum SIOCGIFMETRIC = 0x891d;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFMETRIC); }))) {
            mixin(enumMixinStr_SIOCGIFMETRIC);
        }
    }




    static if(!is(typeof(SIOCSIFNETMASK))) {
        private enum enumMixinStr_SIOCSIFNETMASK = `enum SIOCSIFNETMASK = 0x891c;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFNETMASK); }))) {
            mixin(enumMixinStr_SIOCSIFNETMASK);
        }
    }




    static if(!is(typeof(SIOCGIFNETMASK))) {
        private enum enumMixinStr_SIOCGIFNETMASK = `enum SIOCGIFNETMASK = 0x891b;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFNETMASK); }))) {
            mixin(enumMixinStr_SIOCGIFNETMASK);
        }
    }




    static if(!is(typeof(SIOCSIFBRDADDR))) {
        private enum enumMixinStr_SIOCSIFBRDADDR = `enum SIOCSIFBRDADDR = 0x891a;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFBRDADDR); }))) {
            mixin(enumMixinStr_SIOCSIFBRDADDR);
        }
    }




    static if(!is(typeof(SIOCGIFBRDADDR))) {
        private enum enumMixinStr_SIOCGIFBRDADDR = `enum SIOCGIFBRDADDR = 0x8919;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFBRDADDR); }))) {
            mixin(enumMixinStr_SIOCGIFBRDADDR);
        }
    }




    static if(!is(typeof(SIOCSIFDSTADDR))) {
        private enum enumMixinStr_SIOCSIFDSTADDR = `enum SIOCSIFDSTADDR = 0x8918;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFDSTADDR); }))) {
            mixin(enumMixinStr_SIOCSIFDSTADDR);
        }
    }




    static if(!is(typeof(SIOCGIFDSTADDR))) {
        private enum enumMixinStr_SIOCGIFDSTADDR = `enum SIOCGIFDSTADDR = 0x8917;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFDSTADDR); }))) {
            mixin(enumMixinStr_SIOCGIFDSTADDR);
        }
    }




    static if(!is(typeof(SIOCSIFADDR))) {
        private enum enumMixinStr_SIOCSIFADDR = `enum SIOCSIFADDR = 0x8916;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFADDR); }))) {
            mixin(enumMixinStr_SIOCSIFADDR);
        }
    }




    static if(!is(typeof(SIOCGIFADDR))) {
        private enum enumMixinStr_SIOCGIFADDR = `enum SIOCGIFADDR = 0x8915;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFADDR); }))) {
            mixin(enumMixinStr_SIOCGIFADDR);
        }
    }




    static if(!is(typeof(SIOCSIFFLAGS))) {
        private enum enumMixinStr_SIOCSIFFLAGS = `enum SIOCSIFFLAGS = 0x8914;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFFLAGS); }))) {
            mixin(enumMixinStr_SIOCSIFFLAGS);
        }
    }




    static if(!is(typeof(SIOCGIFFLAGS))) {
        private enum enumMixinStr_SIOCGIFFLAGS = `enum SIOCGIFFLAGS = 0x8913;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFFLAGS); }))) {
            mixin(enumMixinStr_SIOCGIFFLAGS);
        }
    }




    static if(!is(typeof(SIOCGIFCONF))) {
        private enum enumMixinStr_SIOCGIFCONF = `enum SIOCGIFCONF = 0x8912;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFCONF); }))) {
            mixin(enumMixinStr_SIOCGIFCONF);
        }
    }




    static if(!is(typeof(SIOCSIFLINK))) {
        private enum enumMixinStr_SIOCSIFLINK = `enum SIOCSIFLINK = 0x8911;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSIFLINK); }))) {
            mixin(enumMixinStr_SIOCSIFLINK);
        }
    }




    static if(!is(typeof(SIOCGIFNAME))) {
        private enum enumMixinStr_SIOCGIFNAME = `enum SIOCGIFNAME = 0x8910;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGIFNAME); }))) {
            mixin(enumMixinStr_SIOCGIFNAME);
        }
    }




    static if(!is(typeof(SIOCRTMSG))) {
        private enum enumMixinStr_SIOCRTMSG = `enum SIOCRTMSG = 0x890D;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCRTMSG); }))) {
            mixin(enumMixinStr_SIOCRTMSG);
        }
    }




    static if(!is(typeof(SIOCDELRT))) {
        private enum enumMixinStr_SIOCDELRT = `enum SIOCDELRT = 0x890C;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCDELRT); }))) {
            mixin(enumMixinStr_SIOCDELRT);
        }
    }




    static if(!is(typeof(SIOCADDRT))) {
        private enum enumMixinStr_SIOCADDRT = `enum SIOCADDRT = 0x890B;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCADDRT); }))) {
            mixin(enumMixinStr_SIOCADDRT);
        }
    }




    static if(!is(typeof(N_HCI))) {
        private enum enumMixinStr_N_HCI = `enum N_HCI = 15;`;
        static if(is(typeof({ mixin(enumMixinStr_N_HCI); }))) {
            mixin(enumMixinStr_N_HCI);
        }
    }




    static if(!is(typeof(N_SYNC_PPP))) {
        private enum enumMixinStr_N_SYNC_PPP = `enum N_SYNC_PPP = 14;`;
        static if(is(typeof({ mixin(enumMixinStr_N_SYNC_PPP); }))) {
            mixin(enumMixinStr_N_SYNC_PPP);
        }
    }




    static if(!is(typeof(N_HDLC))) {
        private enum enumMixinStr_N_HDLC = `enum N_HDLC = 13;`;
        static if(is(typeof({ mixin(enumMixinStr_N_HDLC); }))) {
            mixin(enumMixinStr_N_HDLC);
        }
    }




    static if(!is(typeof(N_SMSBLOCK))) {
        private enum enumMixinStr_N_SMSBLOCK = `enum N_SMSBLOCK = 12;`;
        static if(is(typeof({ mixin(enumMixinStr_N_SMSBLOCK); }))) {
            mixin(enumMixinStr_N_SMSBLOCK);
        }
    }




    static if(!is(typeof(N_IRDA))) {
        private enum enumMixinStr_N_IRDA = `enum N_IRDA = 11;`;
        static if(is(typeof({ mixin(enumMixinStr_N_IRDA); }))) {
            mixin(enumMixinStr_N_IRDA);
        }
    }




    static if(!is(typeof(N_PROFIBUS_FDL))) {
        private enum enumMixinStr_N_PROFIBUS_FDL = `enum N_PROFIBUS_FDL = 10;`;
        static if(is(typeof({ mixin(enumMixinStr_N_PROFIBUS_FDL); }))) {
            mixin(enumMixinStr_N_PROFIBUS_FDL);
        }
    }




    static if(!is(typeof(N_R3964))) {
        private enum enumMixinStr_N_R3964 = `enum N_R3964 = 9;`;
        static if(is(typeof({ mixin(enumMixinStr_N_R3964); }))) {
            mixin(enumMixinStr_N_R3964);
        }
    }




    static if(!is(typeof(N_MASC))) {
        private enum enumMixinStr_N_MASC = `enum N_MASC = 8;`;
        static if(is(typeof({ mixin(enumMixinStr_N_MASC); }))) {
            mixin(enumMixinStr_N_MASC);
        }
    }




    static if(!is(typeof(N_6PACK))) {
        private enum enumMixinStr_N_6PACK = `enum N_6PACK = 7;`;
        static if(is(typeof({ mixin(enumMixinStr_N_6PACK); }))) {
            mixin(enumMixinStr_N_6PACK);
        }
    }




    static if(!is(typeof(N_X25))) {
        private enum enumMixinStr_N_X25 = `enum N_X25 = 6;`;
        static if(is(typeof({ mixin(enumMixinStr_N_X25); }))) {
            mixin(enumMixinStr_N_X25);
        }
    }




    static if(!is(typeof(N_AX25))) {
        private enum enumMixinStr_N_AX25 = `enum N_AX25 = 5;`;
        static if(is(typeof({ mixin(enumMixinStr_N_AX25); }))) {
            mixin(enumMixinStr_N_AX25);
        }
    }




    static if(!is(typeof(N_STRIP))) {
        private enum enumMixinStr_N_STRIP = `enum N_STRIP = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_N_STRIP); }))) {
            mixin(enumMixinStr_N_STRIP);
        }
    }




    static if(!is(typeof(N_PPP))) {
        private enum enumMixinStr_N_PPP = `enum N_PPP = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_N_PPP); }))) {
            mixin(enumMixinStr_N_PPP);
        }
    }




    static if(!is(typeof(N_MOUSE))) {
        private enum enumMixinStr_N_MOUSE = `enum N_MOUSE = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_N_MOUSE); }))) {
            mixin(enumMixinStr_N_MOUSE);
        }
    }




    static if(!is(typeof(N_SLIP))) {
        private enum enumMixinStr_N_SLIP = `enum N_SLIP = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_N_SLIP); }))) {
            mixin(enumMixinStr_N_SLIP);
        }
    }




    static if(!is(typeof(N_TTY))) {
        private enum enumMixinStr_N_TTY = `enum N_TTY = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_N_TTY); }))) {
            mixin(enumMixinStr_N_TTY);
        }
    }




    static if(!is(typeof(TIOCM_RI))) {
        private enum enumMixinStr_TIOCM_RI = `enum TIOCM_RI = TIOCM_RNG;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCM_RI); }))) {
            mixin(enumMixinStr_TIOCM_RI);
        }
    }




    static if(!is(typeof(TIOCM_CD))) {
        private enum enumMixinStr_TIOCM_CD = `enum TIOCM_CD = TIOCM_CAR;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCM_CD); }))) {
            mixin(enumMixinStr_TIOCM_CD);
        }
    }




    static if(!is(typeof(TIOCM_DSR))) {
        private enum enumMixinStr_TIOCM_DSR = `enum TIOCM_DSR = 0x100;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCM_DSR); }))) {
            mixin(enumMixinStr_TIOCM_DSR);
        }
    }




    static if(!is(typeof(TIOCM_RNG))) {
        private enum enumMixinStr_TIOCM_RNG = `enum TIOCM_RNG = 0x080;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCM_RNG); }))) {
            mixin(enumMixinStr_TIOCM_RNG);
        }
    }




    static if(!is(typeof(TIOCM_CAR))) {
        private enum enumMixinStr_TIOCM_CAR = `enum TIOCM_CAR = 0x040;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCM_CAR); }))) {
            mixin(enumMixinStr_TIOCM_CAR);
        }
    }




    static if(!is(typeof(TIOCM_CTS))) {
        private enum enumMixinStr_TIOCM_CTS = `enum TIOCM_CTS = 0x020;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCM_CTS); }))) {
            mixin(enumMixinStr_TIOCM_CTS);
        }
    }




    static if(!is(typeof(TIOCM_SR))) {
        private enum enumMixinStr_TIOCM_SR = `enum TIOCM_SR = 0x010;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCM_SR); }))) {
            mixin(enumMixinStr_TIOCM_SR);
        }
    }




    static if(!is(typeof(TIOCM_ST))) {
        private enum enumMixinStr_TIOCM_ST = `enum TIOCM_ST = 0x008;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCM_ST); }))) {
            mixin(enumMixinStr_TIOCM_ST);
        }
    }




    static if(!is(typeof(TIOCM_RTS))) {
        private enum enumMixinStr_TIOCM_RTS = `enum TIOCM_RTS = 0x004;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCM_RTS); }))) {
            mixin(enumMixinStr_TIOCM_RTS);
        }
    }




    static if(!is(typeof(TIOCM_DTR))) {
        private enum enumMixinStr_TIOCM_DTR = `enum TIOCM_DTR = 0x002;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCM_DTR); }))) {
            mixin(enumMixinStr_TIOCM_DTR);
        }
    }




    static if(!is(typeof(TIOCM_LE))) {
        private enum enumMixinStr_TIOCM_LE = `enum TIOCM_LE = 0x001;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCM_LE); }))) {
            mixin(enumMixinStr_TIOCM_LE);
        }
    }




    static if(!is(typeof(NCC))) {
        private enum enumMixinStr_NCC = `enum NCC = 8;`;
        static if(is(typeof({ mixin(enumMixinStr_NCC); }))) {
            mixin(enumMixinStr_NCC);
        }
    }




    static if(!is(typeof(_GETOPT_POSIX_H))) {
        private enum enumMixinStr__GETOPT_POSIX_H = `enum _GETOPT_POSIX_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__GETOPT_POSIX_H); }))) {
            mixin(enumMixinStr__GETOPT_POSIX_H);
        }
    }




    static if(!is(typeof(_GETOPT_CORE_H))) {
        private enum enumMixinStr__GETOPT_CORE_H = `enum _GETOPT_CORE_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__GETOPT_CORE_H); }))) {
            mixin(enumMixinStr__GETOPT_CORE_H);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT64X_LONG_DOUBLE))) {
        private enum enumMixinStr___HAVE_FLOAT64X_LONG_DOUBLE = `enum __HAVE_FLOAT64X_LONG_DOUBLE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT64X_LONG_DOUBLE); }))) {
            mixin(enumMixinStr___HAVE_FLOAT64X_LONG_DOUBLE);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT64X))) {
        private enum enumMixinStr___HAVE_FLOAT64X = `enum __HAVE_FLOAT64X = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT64X); }))) {
            mixin(enumMixinStr___HAVE_FLOAT64X);
        }
    }




    static if(!is(typeof(__FILE_defined))) {
        private enum enumMixinStr___FILE_defined = `enum __FILE_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___FILE_defined); }))) {
            mixin(enumMixinStr___FILE_defined);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT128))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT128 = `enum __HAVE_DISTINCT_FLOAT128 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT128); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT128);
        }
    }




    static if(!is(typeof(____FILE_defined))) {
        private enum enumMixinStr_____FILE_defined = `enum ____FILE_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_____FILE_defined); }))) {
            mixin(enumMixinStr_____FILE_defined);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT128))) {
        private enum enumMixinStr___HAVE_FLOAT128 = `enum __HAVE_FLOAT128 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT128); }))) {
            mixin(enumMixinStr___HAVE_FLOAT128);
        }
    }






    static if(!is(typeof(_____fpos64_t_defined))) {
        private enum enumMixinStr______fpos64_t_defined = `enum _____fpos64_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr______fpos64_t_defined); }))) {
            mixin(enumMixinStr______fpos64_t_defined);
        }
    }
    static if(!is(typeof(_____fpos_t_defined))) {
        private enum enumMixinStr______fpos_t_defined = `enum _____fpos_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr______fpos_t_defined); }))) {
            mixin(enumMixinStr______fpos_t_defined);
        }
    }
    static if(!is(typeof(____mbstate_t_defined))) {
        private enum enumMixinStr_____mbstate_t_defined = `enum ____mbstate_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_____mbstate_t_defined); }))) {
            mixin(enumMixinStr_____mbstate_t_defined);
        }
    }
    static if(!is(typeof(_SIGSET_NWORDS))) {
        private enum enumMixinStr__SIGSET_NWORDS = `enum _SIGSET_NWORDS = ( 1024 / ( 8 * ( unsigned long int ) .sizeof ) );`;
        static if(is(typeof({ mixin(enumMixinStr__SIGSET_NWORDS); }))) {
            mixin(enumMixinStr__SIGSET_NWORDS);
        }
    }
    static if(!is(typeof(__clock_t_defined))) {
        private enum enumMixinStr___clock_t_defined = `enum __clock_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___clock_t_defined); }))) {
            mixin(enumMixinStr___clock_t_defined);
        }
    }






    static if(!is(typeof(__CFLOAT64X))) {
        private enum enumMixinStr___CFLOAT64X = `enum __CFLOAT64X = _Complex long double;`;
        static if(is(typeof({ mixin(enumMixinStr___CFLOAT64X); }))) {
            mixin(enumMixinStr___CFLOAT64X);
        }
    }




    static if(!is(typeof(__clockid_t_defined))) {
        private enum enumMixinStr___clockid_t_defined = `enum __clockid_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___clockid_t_defined); }))) {
            mixin(enumMixinStr___clockid_t_defined);
        }
    }




    static if(!is(typeof(__CFLOAT32X))) {
        private enum enumMixinStr___CFLOAT32X = `enum __CFLOAT32X = _Complex double;`;
        static if(is(typeof({ mixin(enumMixinStr___CFLOAT32X); }))) {
            mixin(enumMixinStr___CFLOAT32X);
        }
    }




    static if(!is(typeof(__CFLOAT64))) {
        private enum enumMixinStr___CFLOAT64 = `enum __CFLOAT64 = _Complex double;`;
        static if(is(typeof({ mixin(enumMixinStr___CFLOAT64); }))) {
            mixin(enumMixinStr___CFLOAT64);
        }
    }




    static if(!is(typeof(__sigset_t_defined))) {
        private enum enumMixinStr___sigset_t_defined = `enum __sigset_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___sigset_t_defined); }))) {
            mixin(enumMixinStr___sigset_t_defined);
        }
    }




    static if(!is(typeof(__CFLOAT32))) {
        private enum enumMixinStr___CFLOAT32 = `enum __CFLOAT32 = _Complex float;`;
        static if(is(typeof({ mixin(enumMixinStr___CFLOAT32); }))) {
            mixin(enumMixinStr___CFLOAT32);
        }
    }






    static if(!is(typeof(__struct_FILE_defined))) {
        private enum enumMixinStr___struct_FILE_defined = `enum __struct_FILE_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___struct_FILE_defined); }))) {
            mixin(enumMixinStr___struct_FILE_defined);
        }
    }
    static if(!is(typeof(__HAVE_FLOATN_NOT_TYPEDEF))) {
        private enum enumMixinStr___HAVE_FLOATN_NOT_TYPEDEF = `enum __HAVE_FLOATN_NOT_TYPEDEF = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOATN_NOT_TYPEDEF); }))) {
            mixin(enumMixinStr___HAVE_FLOATN_NOT_TYPEDEF);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT128_UNLIKE_LDBL))) {
        private enum enumMixinStr___HAVE_FLOAT128_UNLIKE_LDBL = `enum __HAVE_FLOAT128_UNLIKE_LDBL = ( 0 && 64 != 113 );`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT128_UNLIKE_LDBL); }))) {
            mixin(enumMixinStr___HAVE_FLOAT128_UNLIKE_LDBL);
        }
    }
    static if(!is(typeof(_IO_EOF_SEEN))) {
        private enum enumMixinStr__IO_EOF_SEEN = `enum _IO_EOF_SEEN = 0x0010;`;
        static if(is(typeof({ mixin(enumMixinStr__IO_EOF_SEEN); }))) {
            mixin(enumMixinStr__IO_EOF_SEEN);
        }
    }






    static if(!is(typeof(_IO_ERR_SEEN))) {
        private enum enumMixinStr__IO_ERR_SEEN = `enum _IO_ERR_SEEN = 0x0020;`;
        static if(is(typeof({ mixin(enumMixinStr__IO_ERR_SEEN); }))) {
            mixin(enumMixinStr__IO_ERR_SEEN);
        }
    }






    static if(!is(typeof(_IO_USER_LOCK))) {
        private enum enumMixinStr__IO_USER_LOCK = `enum _IO_USER_LOCK = 0x8000;`;
        static if(is(typeof({ mixin(enumMixinStr__IO_USER_LOCK); }))) {
            mixin(enumMixinStr__IO_USER_LOCK);
        }
    }




    static if(!is(typeof(__iovec_defined))) {
        private enum enumMixinStr___iovec_defined = `enum __iovec_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___iovec_defined); }))) {
            mixin(enumMixinStr___iovec_defined);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT128X))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT128X = `enum __HAVE_DISTINCT_FLOAT128X = __HAVE_FLOAT128X;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT128X); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT128X);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT64X))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT64X = `enum __HAVE_DISTINCT_FLOAT64X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT64X); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT64X);
        }
    }




    static if(!is(typeof(__osockaddr_defined))) {
        private enum enumMixinStr___osockaddr_defined = `enum __osockaddr_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___osockaddr_defined); }))) {
            mixin(enumMixinStr___osockaddr_defined);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT32X))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT32X = `enum __HAVE_DISTINCT_FLOAT32X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT32X); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT32X);
        }
    }




    static if(!is(typeof(_STRUCT_TIMESPEC))) {
        private enum enumMixinStr__STRUCT_TIMESPEC = `enum _STRUCT_TIMESPEC = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__STRUCT_TIMESPEC); }))) {
            mixin(enumMixinStr__STRUCT_TIMESPEC);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT64))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT64 = `enum __HAVE_DISTINCT_FLOAT64 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT64); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT64);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT32))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT32 = `enum __HAVE_DISTINCT_FLOAT32 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT32); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT32);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT16))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT16 = `enum __HAVE_DISTINCT_FLOAT16 = __HAVE_FLOAT16;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT16); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT16);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT128X))) {
        private enum enumMixinStr___HAVE_FLOAT128X = `enum __HAVE_FLOAT128X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT128X); }))) {
            mixin(enumMixinStr___HAVE_FLOAT128X);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT32X))) {
        private enum enumMixinStr___HAVE_FLOAT32X = `enum __HAVE_FLOAT32X = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT32X); }))) {
            mixin(enumMixinStr___HAVE_FLOAT32X);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT64))) {
        private enum enumMixinStr___HAVE_FLOAT64 = `enum __HAVE_FLOAT64 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT64); }))) {
            mixin(enumMixinStr___HAVE_FLOAT64);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT32))) {
        private enum enumMixinStr___HAVE_FLOAT32 = `enum __HAVE_FLOAT32 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT32); }))) {
            mixin(enumMixinStr___HAVE_FLOAT32);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT16))) {
        private enum enumMixinStr___HAVE_FLOAT16 = `enum __HAVE_FLOAT16 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT16); }))) {
            mixin(enumMixinStr___HAVE_FLOAT16);
        }
    }




    static if(!is(typeof(__timeval_defined))) {
        private enum enumMixinStr___timeval_defined = `enum __timeval_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___timeval_defined); }))) {
            mixin(enumMixinStr___timeval_defined);
        }
    }






    static if(!is(typeof(F_SETLKW64))) {
        private enum enumMixinStr_F_SETLKW64 = `enum F_SETLKW64 = 7;`;
        static if(is(typeof({ mixin(enumMixinStr_F_SETLKW64); }))) {
            mixin(enumMixinStr_F_SETLKW64);
        }
    }




    static if(!is(typeof(__time_t_defined))) {
        private enum enumMixinStr___time_t_defined = `enum __time_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___time_t_defined); }))) {
            mixin(enumMixinStr___time_t_defined);
        }
    }




    static if(!is(typeof(F_SETLK64))) {
        private enum enumMixinStr_F_SETLK64 = `enum F_SETLK64 = 6;`;
        static if(is(typeof({ mixin(enumMixinStr_F_SETLK64); }))) {
            mixin(enumMixinStr_F_SETLK64);
        }
    }




    static if(!is(typeof(F_GETLK64))) {
        private enum enumMixinStr_F_GETLK64 = `enum F_GETLK64 = 5;`;
        static if(is(typeof({ mixin(enumMixinStr_F_GETLK64); }))) {
            mixin(enumMixinStr_F_GETLK64);
        }
    }




    static if(!is(typeof(__timer_t_defined))) {
        private enum enumMixinStr___timer_t_defined = `enum __timer_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___timer_t_defined); }))) {
            mixin(enumMixinStr___timer_t_defined);
        }
    }




    static if(!is(typeof(__O_LARGEFILE))) {
        private enum enumMixinStr___O_LARGEFILE = `enum __O_LARGEFILE = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___O_LARGEFILE); }))) {
            mixin(enumMixinStr___O_LARGEFILE);
        }
    }




    static if(!is(typeof(POSIX_FADV_NOREUSE))) {
        private enum enumMixinStr_POSIX_FADV_NOREUSE = `enum POSIX_FADV_NOREUSE = __POSIX_FADV_NOREUSE;`;
        static if(is(typeof({ mixin(enumMixinStr_POSIX_FADV_NOREUSE); }))) {
            mixin(enumMixinStr_POSIX_FADV_NOREUSE);
        }
    }




    static if(!is(typeof(POSIX_FADV_DONTNEED))) {
        private enum enumMixinStr_POSIX_FADV_DONTNEED = `enum POSIX_FADV_DONTNEED = __POSIX_FADV_DONTNEED;`;
        static if(is(typeof({ mixin(enumMixinStr_POSIX_FADV_DONTNEED); }))) {
            mixin(enumMixinStr_POSIX_FADV_DONTNEED);
        }
    }




    static if(!is(typeof(_BITS_TYPESIZES_H))) {
        private enum enumMixinStr__BITS_TYPESIZES_H = `enum _BITS_TYPESIZES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TYPESIZES_H); }))) {
            mixin(enumMixinStr__BITS_TYPESIZES_H);
        }
    }




    static if(!is(typeof(POSIX_FADV_WILLNEED))) {
        private enum enumMixinStr_POSIX_FADV_WILLNEED = `enum POSIX_FADV_WILLNEED = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_POSIX_FADV_WILLNEED); }))) {
            mixin(enumMixinStr_POSIX_FADV_WILLNEED);
        }
    }




    static if(!is(typeof(__SYSCALL_SLONG_TYPE))) {
        private enum enumMixinStr___SYSCALL_SLONG_TYPE = `enum __SYSCALL_SLONG_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_SLONG_TYPE); }))) {
            mixin(enumMixinStr___SYSCALL_SLONG_TYPE);
        }
    }




    static if(!is(typeof(__SYSCALL_ULONG_TYPE))) {
        private enum enumMixinStr___SYSCALL_ULONG_TYPE = `enum __SYSCALL_ULONG_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_ULONG_TYPE); }))) {
            mixin(enumMixinStr___SYSCALL_ULONG_TYPE);
        }
    }




    static if(!is(typeof(__DEV_T_TYPE))) {
        private enum enumMixinStr___DEV_T_TYPE = `enum __DEV_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___DEV_T_TYPE); }))) {
            mixin(enumMixinStr___DEV_T_TYPE);
        }
    }




    static if(!is(typeof(__UID_T_TYPE))) {
        private enum enumMixinStr___UID_T_TYPE = `enum __UID_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___UID_T_TYPE); }))) {
            mixin(enumMixinStr___UID_T_TYPE);
        }
    }




    static if(!is(typeof(__GID_T_TYPE))) {
        private enum enumMixinStr___GID_T_TYPE = `enum __GID_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___GID_T_TYPE); }))) {
            mixin(enumMixinStr___GID_T_TYPE);
        }
    }




    static if(!is(typeof(__INO_T_TYPE))) {
        private enum enumMixinStr___INO_T_TYPE = `enum __INO_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___INO_T_TYPE); }))) {
            mixin(enumMixinStr___INO_T_TYPE);
        }
    }




    static if(!is(typeof(__INO64_T_TYPE))) {
        private enum enumMixinStr___INO64_T_TYPE = `enum __INO64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___INO64_T_TYPE); }))) {
            mixin(enumMixinStr___INO64_T_TYPE);
        }
    }




    static if(!is(typeof(__MODE_T_TYPE))) {
        private enum enumMixinStr___MODE_T_TYPE = `enum __MODE_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___MODE_T_TYPE); }))) {
            mixin(enumMixinStr___MODE_T_TYPE);
        }
    }




    static if(!is(typeof(POSIX_FADV_SEQUENTIAL))) {
        private enum enumMixinStr_POSIX_FADV_SEQUENTIAL = `enum POSIX_FADV_SEQUENTIAL = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_POSIX_FADV_SEQUENTIAL); }))) {
            mixin(enumMixinStr_POSIX_FADV_SEQUENTIAL);
        }
    }




    static if(!is(typeof(__NLINK_T_TYPE))) {
        private enum enumMixinStr___NLINK_T_TYPE = `enum __NLINK_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___NLINK_T_TYPE); }))) {
            mixin(enumMixinStr___NLINK_T_TYPE);
        }
    }




    static if(!is(typeof(__FSWORD_T_TYPE))) {
        private enum enumMixinStr___FSWORD_T_TYPE = `enum __FSWORD_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSWORD_T_TYPE); }))) {
            mixin(enumMixinStr___FSWORD_T_TYPE);
        }
    }




    static if(!is(typeof(__OFF_T_TYPE))) {
        private enum enumMixinStr___OFF_T_TYPE = `enum __OFF_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF_T_TYPE); }))) {
            mixin(enumMixinStr___OFF_T_TYPE);
        }
    }




    static if(!is(typeof(__OFF64_T_TYPE))) {
        private enum enumMixinStr___OFF64_T_TYPE = `enum __OFF64_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF64_T_TYPE); }))) {
            mixin(enumMixinStr___OFF64_T_TYPE);
        }
    }




    static if(!is(typeof(__PID_T_TYPE))) {
        private enum enumMixinStr___PID_T_TYPE = `enum __PID_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___PID_T_TYPE); }))) {
            mixin(enumMixinStr___PID_T_TYPE);
        }
    }




    static if(!is(typeof(__RLIM_T_TYPE))) {
        private enum enumMixinStr___RLIM_T_TYPE = `enum __RLIM_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM_T_TYPE); }))) {
            mixin(enumMixinStr___RLIM_T_TYPE);
        }
    }




    static if(!is(typeof(__RLIM64_T_TYPE))) {
        private enum enumMixinStr___RLIM64_T_TYPE = `enum __RLIM64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM64_T_TYPE); }))) {
            mixin(enumMixinStr___RLIM64_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKCNT_T_TYPE))) {
        private enum enumMixinStr___BLKCNT_T_TYPE = `enum __BLKCNT_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKCNT_T_TYPE); }))) {
            mixin(enumMixinStr___BLKCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKCNT64_T_TYPE))) {
        private enum enumMixinStr___BLKCNT64_T_TYPE = `enum __BLKCNT64_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___BLKCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__FSBLKCNT_T_TYPE))) {
        private enum enumMixinStr___FSBLKCNT_T_TYPE = `enum __FSBLKCNT_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSBLKCNT_T_TYPE); }))) {
            mixin(enumMixinStr___FSBLKCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__FSBLKCNT64_T_TYPE))) {
        private enum enumMixinStr___FSBLKCNT64_T_TYPE = `enum __FSBLKCNT64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSBLKCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___FSBLKCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__FSFILCNT_T_TYPE))) {
        private enum enumMixinStr___FSFILCNT_T_TYPE = `enum __FSFILCNT_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSFILCNT_T_TYPE); }))) {
            mixin(enumMixinStr___FSFILCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__FSFILCNT64_T_TYPE))) {
        private enum enumMixinStr___FSFILCNT64_T_TYPE = `enum __FSFILCNT64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSFILCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___FSFILCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__ID_T_TYPE))) {
        private enum enumMixinStr___ID_T_TYPE = `enum __ID_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___ID_T_TYPE); }))) {
            mixin(enumMixinStr___ID_T_TYPE);
        }
    }




    static if(!is(typeof(__CLOCK_T_TYPE))) {
        private enum enumMixinStr___CLOCK_T_TYPE = `enum __CLOCK_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___CLOCK_T_TYPE); }))) {
            mixin(enumMixinStr___CLOCK_T_TYPE);
        }
    }




    static if(!is(typeof(__TIME_T_TYPE))) {
        private enum enumMixinStr___TIME_T_TYPE = `enum __TIME_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___TIME_T_TYPE); }))) {
            mixin(enumMixinStr___TIME_T_TYPE);
        }
    }




    static if(!is(typeof(__USECONDS_T_TYPE))) {
        private enum enumMixinStr___USECONDS_T_TYPE = `enum __USECONDS_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___USECONDS_T_TYPE); }))) {
            mixin(enumMixinStr___USECONDS_T_TYPE);
        }
    }




    static if(!is(typeof(__SUSECONDS_T_TYPE))) {
        private enum enumMixinStr___SUSECONDS_T_TYPE = `enum __SUSECONDS_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SUSECONDS_T_TYPE); }))) {
            mixin(enumMixinStr___SUSECONDS_T_TYPE);
        }
    }




    static if(!is(typeof(__SUSECONDS64_T_TYPE))) {
        private enum enumMixinStr___SUSECONDS64_T_TYPE = `enum __SUSECONDS64_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SUSECONDS64_T_TYPE); }))) {
            mixin(enumMixinStr___SUSECONDS64_T_TYPE);
        }
    }




    static if(!is(typeof(__DADDR_T_TYPE))) {
        private enum enumMixinStr___DADDR_T_TYPE = `enum __DADDR_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___DADDR_T_TYPE); }))) {
            mixin(enumMixinStr___DADDR_T_TYPE);
        }
    }




    static if(!is(typeof(__KEY_T_TYPE))) {
        private enum enumMixinStr___KEY_T_TYPE = `enum __KEY_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___KEY_T_TYPE); }))) {
            mixin(enumMixinStr___KEY_T_TYPE);
        }
    }




    static if(!is(typeof(__CLOCKID_T_TYPE))) {
        private enum enumMixinStr___CLOCKID_T_TYPE = `enum __CLOCKID_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___CLOCKID_T_TYPE); }))) {
            mixin(enumMixinStr___CLOCKID_T_TYPE);
        }
    }




    static if(!is(typeof(__TIMER_T_TYPE))) {
        private enum enumMixinStr___TIMER_T_TYPE = `enum __TIMER_T_TYPE = void *;`;
        static if(is(typeof({ mixin(enumMixinStr___TIMER_T_TYPE); }))) {
            mixin(enumMixinStr___TIMER_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKSIZE_T_TYPE))) {
        private enum enumMixinStr___BLKSIZE_T_TYPE = `enum __BLKSIZE_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKSIZE_T_TYPE); }))) {
            mixin(enumMixinStr___BLKSIZE_T_TYPE);
        }
    }




    static if(!is(typeof(__FSID_T_TYPE))) {
        private enum enumMixinStr___FSID_T_TYPE = `enum __FSID_T_TYPE = { int __val [ 2 ] ; };`;
        static if(is(typeof({ mixin(enumMixinStr___FSID_T_TYPE); }))) {
            mixin(enumMixinStr___FSID_T_TYPE);
        }
    }




    static if(!is(typeof(__SSIZE_T_TYPE))) {
        private enum enumMixinStr___SSIZE_T_TYPE = `enum __SSIZE_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SSIZE_T_TYPE); }))) {
            mixin(enumMixinStr___SSIZE_T_TYPE);
        }
    }




    static if(!is(typeof(__CPU_MASK_TYPE))) {
        private enum enumMixinStr___CPU_MASK_TYPE = `enum __CPU_MASK_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___CPU_MASK_TYPE); }))) {
            mixin(enumMixinStr___CPU_MASK_TYPE);
        }
    }




    static if(!is(typeof(POSIX_FADV_RANDOM))) {
        private enum enumMixinStr_POSIX_FADV_RANDOM = `enum POSIX_FADV_RANDOM = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_POSIX_FADV_RANDOM); }))) {
            mixin(enumMixinStr_POSIX_FADV_RANDOM);
        }
    }




    static if(!is(typeof(__OFF_T_MATCHES_OFF64_T))) {
        private enum enumMixinStr___OFF_T_MATCHES_OFF64_T = `enum __OFF_T_MATCHES_OFF64_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF_T_MATCHES_OFF64_T); }))) {
            mixin(enumMixinStr___OFF_T_MATCHES_OFF64_T);
        }
    }




    static if(!is(typeof(__INO_T_MATCHES_INO64_T))) {
        private enum enumMixinStr___INO_T_MATCHES_INO64_T = `enum __INO_T_MATCHES_INO64_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___INO_T_MATCHES_INO64_T); }))) {
            mixin(enumMixinStr___INO_T_MATCHES_INO64_T);
        }
    }




    static if(!is(typeof(__RLIM_T_MATCHES_RLIM64_T))) {
        private enum enumMixinStr___RLIM_T_MATCHES_RLIM64_T = `enum __RLIM_T_MATCHES_RLIM64_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM_T_MATCHES_RLIM64_T); }))) {
            mixin(enumMixinStr___RLIM_T_MATCHES_RLIM64_T);
        }
    }




    static if(!is(typeof(__STATFS_MATCHES_STATFS64))) {
        private enum enumMixinStr___STATFS_MATCHES_STATFS64 = `enum __STATFS_MATCHES_STATFS64 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___STATFS_MATCHES_STATFS64); }))) {
            mixin(enumMixinStr___STATFS_MATCHES_STATFS64);
        }
    }




    static if(!is(typeof(__KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64))) {
        private enum enumMixinStr___KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64 = `enum __KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64); }))) {
            mixin(enumMixinStr___KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64);
        }
    }




    static if(!is(typeof(__FD_SETSIZE))) {
        private enum enumMixinStr___FD_SETSIZE = `enum __FD_SETSIZE = 1024;`;
        static if(is(typeof({ mixin(enumMixinStr___FD_SETSIZE); }))) {
            mixin(enumMixinStr___FD_SETSIZE);
        }
    }




    static if(!is(typeof(POSIX_FADV_NORMAL))) {
        private enum enumMixinStr_POSIX_FADV_NORMAL = `enum POSIX_FADV_NORMAL = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_POSIX_FADV_NORMAL); }))) {
            mixin(enumMixinStr_POSIX_FADV_NORMAL);
        }
    }




    static if(!is(typeof(_BITS_UINTN_IDENTITY_H))) {
        private enum enumMixinStr__BITS_UINTN_IDENTITY_H = `enum _BITS_UINTN_IDENTITY_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_UINTN_IDENTITY_H); }))) {
            mixin(enumMixinStr__BITS_UINTN_IDENTITY_H);
        }
    }




    static if(!is(typeof(__POSIX_FADV_NOREUSE))) {
        private enum enumMixinStr___POSIX_FADV_NOREUSE = `enum __POSIX_FADV_NOREUSE = 5;`;
        static if(is(typeof({ mixin(enumMixinStr___POSIX_FADV_NOREUSE); }))) {
            mixin(enumMixinStr___POSIX_FADV_NOREUSE);
        }
    }




    static if(!is(typeof(__POSIX_FADV_DONTNEED))) {
        private enum enumMixinStr___POSIX_FADV_DONTNEED = `enum __POSIX_FADV_DONTNEED = 4;`;
        static if(is(typeof({ mixin(enumMixinStr___POSIX_FADV_DONTNEED); }))) {
            mixin(enumMixinStr___POSIX_FADV_DONTNEED);
        }
    }




    static if(!is(typeof(FNDELAY))) {
        private enum enumMixinStr_FNDELAY = `enum FNDELAY = O_NDELAY;`;
        static if(is(typeof({ mixin(enumMixinStr_FNDELAY); }))) {
            mixin(enumMixinStr_FNDELAY);
        }
    }




    static if(!is(typeof(FNONBLOCK))) {
        private enum enumMixinStr_FNONBLOCK = `enum FNONBLOCK = O_NONBLOCK;`;
        static if(is(typeof({ mixin(enumMixinStr_FNONBLOCK); }))) {
            mixin(enumMixinStr_FNONBLOCK);
        }
    }




    static if(!is(typeof(FASYNC))) {
        private enum enumMixinStr_FASYNC = `enum FASYNC = O_ASYNC;`;
        static if(is(typeof({ mixin(enumMixinStr_FASYNC); }))) {
            mixin(enumMixinStr_FASYNC);
        }
    }




    static if(!is(typeof(FFSYNC))) {
        private enum enumMixinStr_FFSYNC = `enum FFSYNC = O_FSYNC;`;
        static if(is(typeof({ mixin(enumMixinStr_FFSYNC); }))) {
            mixin(enumMixinStr_FFSYNC);
        }
    }




    static if(!is(typeof(FAPPEND))) {
        private enum enumMixinStr_FAPPEND = `enum FAPPEND = O_APPEND;`;
        static if(is(typeof({ mixin(enumMixinStr_FAPPEND); }))) {
            mixin(enumMixinStr_FAPPEND);
        }
    }




    static if(!is(typeof(LOCK_UN))) {
        private enum enumMixinStr_LOCK_UN = `enum LOCK_UN = 8;`;
        static if(is(typeof({ mixin(enumMixinStr_LOCK_UN); }))) {
            mixin(enumMixinStr_LOCK_UN);
        }
    }




    static if(!is(typeof(LOCK_NB))) {
        private enum enumMixinStr_LOCK_NB = `enum LOCK_NB = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_LOCK_NB); }))) {
            mixin(enumMixinStr_LOCK_NB);
        }
    }




    static if(!is(typeof(LOCK_EX))) {
        private enum enumMixinStr_LOCK_EX = `enum LOCK_EX = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_LOCK_EX); }))) {
            mixin(enumMixinStr_LOCK_EX);
        }
    }




    static if(!is(typeof(LOCK_SH))) {
        private enum enumMixinStr_LOCK_SH = `enum LOCK_SH = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_LOCK_SH); }))) {
            mixin(enumMixinStr_LOCK_SH);
        }
    }




    static if(!is(typeof(F_SHLCK))) {
        private enum enumMixinStr_F_SHLCK = `enum F_SHLCK = 8;`;
        static if(is(typeof({ mixin(enumMixinStr_F_SHLCK); }))) {
            mixin(enumMixinStr_F_SHLCK);
        }
    }




    static if(!is(typeof(__WORDSIZE))) {
        private enum enumMixinStr___WORDSIZE = `enum __WORDSIZE = 64;`;
        static if(is(typeof({ mixin(enumMixinStr___WORDSIZE); }))) {
            mixin(enumMixinStr___WORDSIZE);
        }
    }




    static if(!is(typeof(F_EXLCK))) {
        private enum enumMixinStr_F_EXLCK = `enum F_EXLCK = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_F_EXLCK); }))) {
            mixin(enumMixinStr_F_EXLCK);
        }
    }




    static if(!is(typeof(F_UNLCK))) {
        private enum enumMixinStr_F_UNLCK = `enum F_UNLCK = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_F_UNLCK); }))) {
            mixin(enumMixinStr_F_UNLCK);
        }
    }




    static if(!is(typeof(F_WRLCK))) {
        private enum enumMixinStr_F_WRLCK = `enum F_WRLCK = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_F_WRLCK); }))) {
            mixin(enumMixinStr_F_WRLCK);
        }
    }




    static if(!is(typeof(F_RDLCK))) {
        private enum enumMixinStr_F_RDLCK = `enum F_RDLCK = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_F_RDLCK); }))) {
            mixin(enumMixinStr_F_RDLCK);
        }
    }




    static if(!is(typeof(FD_CLOEXEC))) {
        private enum enumMixinStr_FD_CLOEXEC = `enum FD_CLOEXEC = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_FD_CLOEXEC); }))) {
            mixin(enumMixinStr_FD_CLOEXEC);
        }
    }




    static if(!is(typeof(F_DUPFD_CLOEXEC))) {
        private enum enumMixinStr_F_DUPFD_CLOEXEC = `enum F_DUPFD_CLOEXEC = 1030;`;
        static if(is(typeof({ mixin(enumMixinStr_F_DUPFD_CLOEXEC); }))) {
            mixin(enumMixinStr_F_DUPFD_CLOEXEC);
        }
    }




    static if(!is(typeof(__F_GETOWN_EX))) {
        private enum enumMixinStr___F_GETOWN_EX = `enum __F_GETOWN_EX = 16;`;
        static if(is(typeof({ mixin(enumMixinStr___F_GETOWN_EX); }))) {
            mixin(enumMixinStr___F_GETOWN_EX);
        }
    }




    static if(!is(typeof(__WORDSIZE_TIME64_COMPAT32))) {
        private enum enumMixinStr___WORDSIZE_TIME64_COMPAT32 = `enum __WORDSIZE_TIME64_COMPAT32 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___WORDSIZE_TIME64_COMPAT32); }))) {
            mixin(enumMixinStr___WORDSIZE_TIME64_COMPAT32);
        }
    }




    static if(!is(typeof(__SYSCALL_WORDSIZE))) {
        private enum enumMixinStr___SYSCALL_WORDSIZE = `enum __SYSCALL_WORDSIZE = 64;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_WORDSIZE); }))) {
            mixin(enumMixinStr___SYSCALL_WORDSIZE);
        }
    }




    static if(!is(typeof(_ENDIAN_H))) {
        private enum enumMixinStr__ENDIAN_H = `enum _ENDIAN_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__ENDIAN_H); }))) {
            mixin(enumMixinStr__ENDIAN_H);
        }
    }




    static if(!is(typeof(__F_SETOWN_EX))) {
        private enum enumMixinStr___F_SETOWN_EX = `enum __F_SETOWN_EX = 15;`;
        static if(is(typeof({ mixin(enumMixinStr___F_SETOWN_EX); }))) {
            mixin(enumMixinStr___F_SETOWN_EX);
        }
    }




    static if(!is(typeof(__F_GETSIG))) {
        private enum enumMixinStr___F_GETSIG = `enum __F_GETSIG = 11;`;
        static if(is(typeof({ mixin(enumMixinStr___F_GETSIG); }))) {
            mixin(enumMixinStr___F_GETSIG);
        }
    }




    static if(!is(typeof(__F_SETSIG))) {
        private enum enumMixinStr___F_SETSIG = `enum __F_SETSIG = 10;`;
        static if(is(typeof({ mixin(enumMixinStr___F_SETSIG); }))) {
            mixin(enumMixinStr___F_SETSIG);
        }
    }




    static if(!is(typeof(LITTLE_ENDIAN))) {
        private enum enumMixinStr_LITTLE_ENDIAN = `enum LITTLE_ENDIAN = __LITTLE_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr_LITTLE_ENDIAN); }))) {
            mixin(enumMixinStr_LITTLE_ENDIAN);
        }
    }




    static if(!is(typeof(BIG_ENDIAN))) {
        private enum enumMixinStr_BIG_ENDIAN = `enum BIG_ENDIAN = __BIG_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr_BIG_ENDIAN); }))) {
            mixin(enumMixinStr_BIG_ENDIAN);
        }
    }




    static if(!is(typeof(PDP_ENDIAN))) {
        private enum enumMixinStr_PDP_ENDIAN = `enum PDP_ENDIAN = __PDP_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr_PDP_ENDIAN); }))) {
            mixin(enumMixinStr_PDP_ENDIAN);
        }
    }




    static if(!is(typeof(BYTE_ORDER))) {
        private enum enumMixinStr_BYTE_ORDER = `enum BYTE_ORDER = __BYTE_ORDER;`;
        static if(is(typeof({ mixin(enumMixinStr_BYTE_ORDER); }))) {
            mixin(enumMixinStr_BYTE_ORDER);
        }
    }




    static if(!is(typeof(F_GETOWN))) {
        private enum enumMixinStr_F_GETOWN = `enum F_GETOWN = __F_GETOWN;`;
        static if(is(typeof({ mixin(enumMixinStr_F_GETOWN); }))) {
            mixin(enumMixinStr_F_GETOWN);
        }
    }




    static if(!is(typeof(F_SETOWN))) {
        private enum enumMixinStr_F_SETOWN = `enum F_SETOWN = __F_SETOWN;`;
        static if(is(typeof({ mixin(enumMixinStr_F_SETOWN); }))) {
            mixin(enumMixinStr_F_SETOWN);
        }
    }




    static if(!is(typeof(__F_GETOWN))) {
        private enum enumMixinStr___F_GETOWN = `enum __F_GETOWN = 9;`;
        static if(is(typeof({ mixin(enumMixinStr___F_GETOWN); }))) {
            mixin(enumMixinStr___F_GETOWN);
        }
    }




    static if(!is(typeof(__F_SETOWN))) {
        private enum enumMixinStr___F_SETOWN = `enum __F_SETOWN = 8;`;
        static if(is(typeof({ mixin(enumMixinStr___F_SETOWN); }))) {
            mixin(enumMixinStr___F_SETOWN);
        }
    }




    static if(!is(typeof(F_SETFL))) {
        private enum enumMixinStr_F_SETFL = `enum F_SETFL = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_F_SETFL); }))) {
            mixin(enumMixinStr_F_SETFL);
        }
    }
    static if(!is(typeof(_ERRNO_H))) {
        private enum enumMixinStr__ERRNO_H = `enum _ERRNO_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__ERRNO_H); }))) {
            mixin(enumMixinStr__ERRNO_H);
        }
    }




    static if(!is(typeof(F_GETFL))) {
        private enum enumMixinStr_F_GETFL = `enum F_GETFL = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_F_GETFL); }))) {
            mixin(enumMixinStr_F_GETFL);
        }
    }




    static if(!is(typeof(F_SETFD))) {
        private enum enumMixinStr_F_SETFD = `enum F_SETFD = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_F_SETFD); }))) {
            mixin(enumMixinStr_F_SETFD);
        }
    }




    static if(!is(typeof(F_GETFD))) {
        private enum enumMixinStr_F_GETFD = `enum F_GETFD = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_F_GETFD); }))) {
            mixin(enumMixinStr_F_GETFD);
        }
    }




    static if(!is(typeof(F_DUPFD))) {
        private enum enumMixinStr_F_DUPFD = `enum F_DUPFD = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_F_DUPFD); }))) {
            mixin(enumMixinStr_F_DUPFD);
        }
    }




    static if(!is(typeof(O_RSYNC))) {
        private enum enumMixinStr_O_RSYNC = `enum O_RSYNC = O_SYNC;`;
        static if(is(typeof({ mixin(enumMixinStr_O_RSYNC); }))) {
            mixin(enumMixinStr_O_RSYNC);
        }
    }




    static if(!is(typeof(O_DSYNC))) {
        private enum enumMixinStr_O_DSYNC = `enum O_DSYNC = __O_DSYNC;`;
        static if(is(typeof({ mixin(enumMixinStr_O_DSYNC); }))) {
            mixin(enumMixinStr_O_DSYNC);
        }
    }




    static if(!is(typeof(errno))) {
        private enum enumMixinStr_errno = `enum errno = ( * __errno_location ( ) );`;
        static if(is(typeof({ mixin(enumMixinStr_errno); }))) {
            mixin(enumMixinStr_errno);
        }
    }




    static if(!is(typeof(O_CLOEXEC))) {
        private enum enumMixinStr_O_CLOEXEC = `enum O_CLOEXEC = __O_CLOEXEC;`;
        static if(is(typeof({ mixin(enumMixinStr_O_CLOEXEC); }))) {
            mixin(enumMixinStr_O_CLOEXEC);
        }
    }




    static if(!is(typeof(_FCNTL_H))) {
        private enum enumMixinStr__FCNTL_H = `enum _FCNTL_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__FCNTL_H); }))) {
            mixin(enumMixinStr__FCNTL_H);
        }
    }




    static if(!is(typeof(O_NOFOLLOW))) {
        private enum enumMixinStr_O_NOFOLLOW = `enum O_NOFOLLOW = __O_NOFOLLOW;`;
        static if(is(typeof({ mixin(enumMixinStr_O_NOFOLLOW); }))) {
            mixin(enumMixinStr_O_NOFOLLOW);
        }
    }




    static if(!is(typeof(O_DIRECTORY))) {
        private enum enumMixinStr_O_DIRECTORY = `enum O_DIRECTORY = __O_DIRECTORY;`;
        static if(is(typeof({ mixin(enumMixinStr_O_DIRECTORY); }))) {
            mixin(enumMixinStr_O_DIRECTORY);
        }
    }




    static if(!is(typeof(F_SETLKW))) {
        private enum enumMixinStr_F_SETLKW = `enum F_SETLKW = 7;`;
        static if(is(typeof({ mixin(enumMixinStr_F_SETLKW); }))) {
            mixin(enumMixinStr_F_SETLKW);
        }
    }




    static if(!is(typeof(F_SETLK))) {
        private enum enumMixinStr_F_SETLK = `enum F_SETLK = 6;`;
        static if(is(typeof({ mixin(enumMixinStr_F_SETLK); }))) {
            mixin(enumMixinStr_F_SETLK);
        }
    }




    static if(!is(typeof(F_GETLK))) {
        private enum enumMixinStr_F_GETLK = `enum F_GETLK = 5;`;
        static if(is(typeof({ mixin(enumMixinStr_F_GETLK); }))) {
            mixin(enumMixinStr_F_GETLK);
        }
    }






    static if(!is(typeof(__O_TMPFILE))) {
        private enum enumMixinStr___O_TMPFILE = `enum __O_TMPFILE = ( /+converted from octal '20000000'+/ 4194304 | __O_DIRECTORY );`;
        static if(is(typeof({ mixin(enumMixinStr___O_TMPFILE); }))) {
            mixin(enumMixinStr___O_TMPFILE);
        }
    }




    static if(!is(typeof(__O_DSYNC))) {
        private enum enumMixinStr___O_DSYNC = `enum __O_DSYNC = /+converted from octal '10000'+/ 4096;`;
        static if(is(typeof({ mixin(enumMixinStr___O_DSYNC); }))) {
            mixin(enumMixinStr___O_DSYNC);
        }
    }




    static if(!is(typeof(__O_PATH))) {
        private enum enumMixinStr___O_PATH = `enum __O_PATH = /+converted from octal '10000000'+/ 2097152;`;
        static if(is(typeof({ mixin(enumMixinStr___O_PATH); }))) {
            mixin(enumMixinStr___O_PATH);
        }
    }




    static if(!is(typeof(__O_NOATIME))) {
        private enum enumMixinStr___O_NOATIME = `enum __O_NOATIME = /+converted from octal '1000000'+/ 262144;`;
        static if(is(typeof({ mixin(enumMixinStr___O_NOATIME); }))) {
            mixin(enumMixinStr___O_NOATIME);
        }
    }




    static if(!is(typeof(__O_DIRECT))) {
        private enum enumMixinStr___O_DIRECT = `enum __O_DIRECT = /+converted from octal '40000'+/ 16384;`;
        static if(is(typeof({ mixin(enumMixinStr___O_DIRECT); }))) {
            mixin(enumMixinStr___O_DIRECT);
        }
    }




    static if(!is(typeof(__O_CLOEXEC))) {
        private enum enumMixinStr___O_CLOEXEC = `enum __O_CLOEXEC = /+converted from octal '2000000'+/ 524288;`;
        static if(is(typeof({ mixin(enumMixinStr___O_CLOEXEC); }))) {
            mixin(enumMixinStr___O_CLOEXEC);
        }
    }




    static if(!is(typeof(__O_NOFOLLOW))) {
        private enum enumMixinStr___O_NOFOLLOW = `enum __O_NOFOLLOW = /+converted from octal '400000'+/ 131072;`;
        static if(is(typeof({ mixin(enumMixinStr___O_NOFOLLOW); }))) {
            mixin(enumMixinStr___O_NOFOLLOW);
        }
    }




    static if(!is(typeof(S_IFMT))) {
        private enum enumMixinStr_S_IFMT = `enum S_IFMT = /+converted from octal '170000'+/ 61440;`;
        static if(is(typeof({ mixin(enumMixinStr_S_IFMT); }))) {
            mixin(enumMixinStr_S_IFMT);
        }
    }




    static if(!is(typeof(S_IFDIR))) {
        private enum enumMixinStr_S_IFDIR = `enum S_IFDIR = /+converted from octal '40000'+/ 16384;`;
        static if(is(typeof({ mixin(enumMixinStr_S_IFDIR); }))) {
            mixin(enumMixinStr_S_IFDIR);
        }
    }




    static if(!is(typeof(S_IFCHR))) {
        private enum enumMixinStr_S_IFCHR = `enum S_IFCHR = /+converted from octal '20000'+/ 8192;`;
        static if(is(typeof({ mixin(enumMixinStr_S_IFCHR); }))) {
            mixin(enumMixinStr_S_IFCHR);
        }
    }




    static if(!is(typeof(S_IFBLK))) {
        private enum enumMixinStr_S_IFBLK = `enum S_IFBLK = /+converted from octal '60000'+/ 24576;`;
        static if(is(typeof({ mixin(enumMixinStr_S_IFBLK); }))) {
            mixin(enumMixinStr_S_IFBLK);
        }
    }




    static if(!is(typeof(S_IFREG))) {
        private enum enumMixinStr_S_IFREG = `enum S_IFREG = /+converted from octal '100000'+/ 32768;`;
        static if(is(typeof({ mixin(enumMixinStr_S_IFREG); }))) {
            mixin(enumMixinStr_S_IFREG);
        }
    }




    static if(!is(typeof(__O_DIRECTORY))) {
        private enum enumMixinStr___O_DIRECTORY = `enum __O_DIRECTORY = /+converted from octal '200000'+/ 65536;`;
        static if(is(typeof({ mixin(enumMixinStr___O_DIRECTORY); }))) {
            mixin(enumMixinStr___O_DIRECTORY);
        }
    }




    static if(!is(typeof(S_IFIFO))) {
        private enum enumMixinStr_S_IFIFO = `enum S_IFIFO = /+converted from octal '10000'+/ 4096;`;
        static if(is(typeof({ mixin(enumMixinStr_S_IFIFO); }))) {
            mixin(enumMixinStr_S_IFIFO);
        }
    }




    static if(!is(typeof(O_ASYNC))) {
        private enum enumMixinStr_O_ASYNC = `enum O_ASYNC = /+converted from octal '20000'+/ 8192;`;
        static if(is(typeof({ mixin(enumMixinStr_O_ASYNC); }))) {
            mixin(enumMixinStr_O_ASYNC);
        }
    }




    static if(!is(typeof(S_IFLNK))) {
        private enum enumMixinStr_S_IFLNK = `enum S_IFLNK = /+converted from octal '120000'+/ 40960;`;
        static if(is(typeof({ mixin(enumMixinStr_S_IFLNK); }))) {
            mixin(enumMixinStr_S_IFLNK);
        }
    }




    static if(!is(typeof(O_FSYNC))) {
        private enum enumMixinStr_O_FSYNC = `enum O_FSYNC = O_SYNC;`;
        static if(is(typeof({ mixin(enumMixinStr_O_FSYNC); }))) {
            mixin(enumMixinStr_O_FSYNC);
        }
    }




    static if(!is(typeof(O_SYNC))) {
        private enum enumMixinStr_O_SYNC = `enum O_SYNC = /+converted from octal '4010000'+/ 1052672;`;
        static if(is(typeof({ mixin(enumMixinStr_O_SYNC); }))) {
            mixin(enumMixinStr_O_SYNC);
        }
    }




    static if(!is(typeof(S_IFSOCK))) {
        private enum enumMixinStr_S_IFSOCK = `enum S_IFSOCK = /+converted from octal '140000'+/ 49152;`;
        static if(is(typeof({ mixin(enumMixinStr_S_IFSOCK); }))) {
            mixin(enumMixinStr_S_IFSOCK);
        }
    }




    static if(!is(typeof(S_ISUID))) {
        private enum enumMixinStr_S_ISUID = `enum S_ISUID = /+converted from octal '4000'+/ 2048;`;
        static if(is(typeof({ mixin(enumMixinStr_S_ISUID); }))) {
            mixin(enumMixinStr_S_ISUID);
        }
    }




    static if(!is(typeof(S_ISGID))) {
        private enum enumMixinStr_S_ISGID = `enum S_ISGID = /+converted from octal '2000'+/ 1024;`;
        static if(is(typeof({ mixin(enumMixinStr_S_ISGID); }))) {
            mixin(enumMixinStr_S_ISGID);
        }
    }




    static if(!is(typeof(O_NDELAY))) {
        private enum enumMixinStr_O_NDELAY = `enum O_NDELAY = O_NONBLOCK;`;
        static if(is(typeof({ mixin(enumMixinStr_O_NDELAY); }))) {
            mixin(enumMixinStr_O_NDELAY);
        }
    }




    static if(!is(typeof(S_ISVTX))) {
        private enum enumMixinStr_S_ISVTX = `enum S_ISVTX = /+converted from octal '1000'+/ 512;`;
        static if(is(typeof({ mixin(enumMixinStr_S_ISVTX); }))) {
            mixin(enumMixinStr_S_ISVTX);
        }
    }




    static if(!is(typeof(S_IRUSR))) {
        private enum enumMixinStr_S_IRUSR = `enum S_IRUSR = /+converted from octal '400'+/ 256;`;
        static if(is(typeof({ mixin(enumMixinStr_S_IRUSR); }))) {
            mixin(enumMixinStr_S_IRUSR);
        }
    }




    static if(!is(typeof(S_IWUSR))) {
        private enum enumMixinStr_S_IWUSR = `enum S_IWUSR = /+converted from octal '200'+/ 128;`;
        static if(is(typeof({ mixin(enumMixinStr_S_IWUSR); }))) {
            mixin(enumMixinStr_S_IWUSR);
        }
    }




    static if(!is(typeof(S_IXUSR))) {
        private enum enumMixinStr_S_IXUSR = `enum S_IXUSR = /+converted from octal '100'+/ 64;`;
        static if(is(typeof({ mixin(enumMixinStr_S_IXUSR); }))) {
            mixin(enumMixinStr_S_IXUSR);
        }
    }




    static if(!is(typeof(S_IRWXU))) {
        private enum enumMixinStr_S_IRWXU = `enum S_IRWXU = ( /+converted from octal '400'+/ 256 | /+converted from octal '200'+/ 128 | /+converted from octal '100'+/ 64 );`;
        static if(is(typeof({ mixin(enumMixinStr_S_IRWXU); }))) {
            mixin(enumMixinStr_S_IRWXU);
        }
    }




    static if(!is(typeof(S_IRGRP))) {
        private enum enumMixinStr_S_IRGRP = `enum S_IRGRP = ( /+converted from octal '400'+/ 256 >> 3 );`;
        static if(is(typeof({ mixin(enumMixinStr_S_IRGRP); }))) {
            mixin(enumMixinStr_S_IRGRP);
        }
    }




    static if(!is(typeof(S_IWGRP))) {
        private enum enumMixinStr_S_IWGRP = `enum S_IWGRP = ( /+converted from octal '200'+/ 128 >> 3 );`;
        static if(is(typeof({ mixin(enumMixinStr_S_IWGRP); }))) {
            mixin(enumMixinStr_S_IWGRP);
        }
    }




    static if(!is(typeof(S_IXGRP))) {
        private enum enumMixinStr_S_IXGRP = `enum S_IXGRP = ( /+converted from octal '100'+/ 64 >> 3 );`;
        static if(is(typeof({ mixin(enumMixinStr_S_IXGRP); }))) {
            mixin(enumMixinStr_S_IXGRP);
        }
    }




    static if(!is(typeof(S_IRWXG))) {
        private enum enumMixinStr_S_IRWXG = `enum S_IRWXG = ( ( /+converted from octal '400'+/ 256 | /+converted from octal '200'+/ 128 | /+converted from octal '100'+/ 64 ) >> 3 );`;
        static if(is(typeof({ mixin(enumMixinStr_S_IRWXG); }))) {
            mixin(enumMixinStr_S_IRWXG);
        }
    }




    static if(!is(typeof(S_IROTH))) {
        private enum enumMixinStr_S_IROTH = `enum S_IROTH = ( ( /+converted from octal '400'+/ 256 >> 3 ) >> 3 );`;
        static if(is(typeof({ mixin(enumMixinStr_S_IROTH); }))) {
            mixin(enumMixinStr_S_IROTH);
        }
    }




    static if(!is(typeof(S_IWOTH))) {
        private enum enumMixinStr_S_IWOTH = `enum S_IWOTH = ( ( /+converted from octal '200'+/ 128 >> 3 ) >> 3 );`;
        static if(is(typeof({ mixin(enumMixinStr_S_IWOTH); }))) {
            mixin(enumMixinStr_S_IWOTH);
        }
    }




    static if(!is(typeof(S_IXOTH))) {
        private enum enumMixinStr_S_IXOTH = `enum S_IXOTH = ( ( /+converted from octal '100'+/ 64 >> 3 ) >> 3 );`;
        static if(is(typeof({ mixin(enumMixinStr_S_IXOTH); }))) {
            mixin(enumMixinStr_S_IXOTH);
        }
    }




    static if(!is(typeof(S_IRWXO))) {
        private enum enumMixinStr_S_IRWXO = `enum S_IRWXO = ( ( ( /+converted from octal '400'+/ 256 | /+converted from octal '200'+/ 128 | /+converted from octal '100'+/ 64 ) >> 3 ) >> 3 );`;
        static if(is(typeof({ mixin(enumMixinStr_S_IRWXO); }))) {
            mixin(enumMixinStr_S_IRWXO);
        }
    }




    static if(!is(typeof(O_NONBLOCK))) {
        private enum enumMixinStr_O_NONBLOCK = `enum O_NONBLOCK = /+converted from octal '4000'+/ 2048;`;
        static if(is(typeof({ mixin(enumMixinStr_O_NONBLOCK); }))) {
            mixin(enumMixinStr_O_NONBLOCK);
        }
    }




    static if(!is(typeof(R_OK))) {
        private enum enumMixinStr_R_OK = `enum R_OK = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_R_OK); }))) {
            mixin(enumMixinStr_R_OK);
        }
    }




    static if(!is(typeof(W_OK))) {
        private enum enumMixinStr_W_OK = `enum W_OK = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_W_OK); }))) {
            mixin(enumMixinStr_W_OK);
        }
    }




    static if(!is(typeof(X_OK))) {
        private enum enumMixinStr_X_OK = `enum X_OK = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_X_OK); }))) {
            mixin(enumMixinStr_X_OK);
        }
    }




    static if(!is(typeof(F_OK))) {
        private enum enumMixinStr_F_OK = `enum F_OK = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_F_OK); }))) {
            mixin(enumMixinStr_F_OK);
        }
    }




    static if(!is(typeof(O_APPEND))) {
        private enum enumMixinStr_O_APPEND = `enum O_APPEND = /+converted from octal '2000'+/ 1024;`;
        static if(is(typeof({ mixin(enumMixinStr_O_APPEND); }))) {
            mixin(enumMixinStr_O_APPEND);
        }
    }




    static if(!is(typeof(SEEK_SET))) {
        private enum enumMixinStr_SEEK_SET = `enum SEEK_SET = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_SEEK_SET); }))) {
            mixin(enumMixinStr_SEEK_SET);
        }
    }




    static if(!is(typeof(SEEK_CUR))) {
        private enum enumMixinStr_SEEK_CUR = `enum SEEK_CUR = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_SEEK_CUR); }))) {
            mixin(enumMixinStr_SEEK_CUR);
        }
    }




    static if(!is(typeof(SEEK_END))) {
        private enum enumMixinStr_SEEK_END = `enum SEEK_END = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_SEEK_END); }))) {
            mixin(enumMixinStr_SEEK_END);
        }
    }




    static if(!is(typeof(O_TRUNC))) {
        private enum enumMixinStr_O_TRUNC = `enum O_TRUNC = /+converted from octal '1000'+/ 512;`;
        static if(is(typeof({ mixin(enumMixinStr_O_TRUNC); }))) {
            mixin(enumMixinStr_O_TRUNC);
        }
    }




    static if(!is(typeof(AT_FDCWD))) {
        private enum enumMixinStr_AT_FDCWD = `enum AT_FDCWD = - 100;`;
        static if(is(typeof({ mixin(enumMixinStr_AT_FDCWD); }))) {
            mixin(enumMixinStr_AT_FDCWD);
        }
    }




    static if(!is(typeof(AT_SYMLINK_NOFOLLOW))) {
        private enum enumMixinStr_AT_SYMLINK_NOFOLLOW = `enum AT_SYMLINK_NOFOLLOW = 0x100;`;
        static if(is(typeof({ mixin(enumMixinStr_AT_SYMLINK_NOFOLLOW); }))) {
            mixin(enumMixinStr_AT_SYMLINK_NOFOLLOW);
        }
    }




    static if(!is(typeof(AT_REMOVEDIR))) {
        private enum enumMixinStr_AT_REMOVEDIR = `enum AT_REMOVEDIR = 0x200;`;
        static if(is(typeof({ mixin(enumMixinStr_AT_REMOVEDIR); }))) {
            mixin(enumMixinStr_AT_REMOVEDIR);
        }
    }




    static if(!is(typeof(AT_SYMLINK_FOLLOW))) {
        private enum enumMixinStr_AT_SYMLINK_FOLLOW = `enum AT_SYMLINK_FOLLOW = 0x400;`;
        static if(is(typeof({ mixin(enumMixinStr_AT_SYMLINK_FOLLOW); }))) {
            mixin(enumMixinStr_AT_SYMLINK_FOLLOW);
        }
    }




    static if(!is(typeof(AT_EACCESS))) {
        private enum enumMixinStr_AT_EACCESS = `enum AT_EACCESS = 0x200;`;
        static if(is(typeof({ mixin(enumMixinStr_AT_EACCESS); }))) {
            mixin(enumMixinStr_AT_EACCESS);
        }
    }




    static if(!is(typeof(O_NOCTTY))) {
        private enum enumMixinStr_O_NOCTTY = `enum O_NOCTTY = /+converted from octal '400'+/ 256;`;
        static if(is(typeof({ mixin(enumMixinStr_O_NOCTTY); }))) {
            mixin(enumMixinStr_O_NOCTTY);
        }
    }




    static if(!is(typeof(O_EXCL))) {
        private enum enumMixinStr_O_EXCL = `enum O_EXCL = /+converted from octal '200'+/ 128;`;
        static if(is(typeof({ mixin(enumMixinStr_O_EXCL); }))) {
            mixin(enumMixinStr_O_EXCL);
        }
    }




    static if(!is(typeof(O_CREAT))) {
        private enum enumMixinStr_O_CREAT = `enum O_CREAT = /+converted from octal '100'+/ 64;`;
        static if(is(typeof({ mixin(enumMixinStr_O_CREAT); }))) {
            mixin(enumMixinStr_O_CREAT);
        }
    }




    static if(!is(typeof(O_RDWR))) {
        private enum enumMixinStr_O_RDWR = `enum O_RDWR = /+converted from octal '2'+/ 2;`;
        static if(is(typeof({ mixin(enumMixinStr_O_RDWR); }))) {
            mixin(enumMixinStr_O_RDWR);
        }
    }




    static if(!is(typeof(O_WRONLY))) {
        private enum enumMixinStr_O_WRONLY = `enum O_WRONLY = /+converted from octal '1'+/ 1;`;
        static if(is(typeof({ mixin(enumMixinStr_O_WRONLY); }))) {
            mixin(enumMixinStr_O_WRONLY);
        }
    }




    static if(!is(typeof(O_RDONLY))) {
        private enum enumMixinStr_O_RDONLY = `enum O_RDONLY = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_O_RDONLY); }))) {
            mixin(enumMixinStr_O_RDONLY);
        }
    }




    static if(!is(typeof(O_ACCMODE))) {
        private enum enumMixinStr_O_ACCMODE = `enum O_ACCMODE = /+converted from octal '3'+/ 3;`;
        static if(is(typeof({ mixin(enumMixinStr_O_ACCMODE); }))) {
            mixin(enumMixinStr_O_ACCMODE);
        }
    }




    static if(!is(typeof(ENOTSUP))) {
        private enum enumMixinStr_ENOTSUP = `enum ENOTSUP = EOPNOTSUPP;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOTSUP); }))) {
            mixin(enumMixinStr_ENOTSUP);
        }
    }




    static if(!is(typeof(_BITS_ERRNO_H))) {
        private enum enumMixinStr__BITS_ERRNO_H = `enum _BITS_ERRNO_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_ERRNO_H); }))) {
            mixin(enumMixinStr__BITS_ERRNO_H);
        }
    }




    static if(!is(typeof(__LP64_OFF64_LDFLAGS))) {
        private enum enumMixinStr___LP64_OFF64_LDFLAGS = `enum __LP64_OFF64_LDFLAGS = "-m64";`;
        static if(is(typeof({ mixin(enumMixinStr___LP64_OFF64_LDFLAGS); }))) {
            mixin(enumMixinStr___LP64_OFF64_LDFLAGS);
        }
    }




    static if(!is(typeof(F_ULOCK))) {
        private enum enumMixinStr_F_ULOCK = `enum F_ULOCK = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_F_ULOCK); }))) {
            mixin(enumMixinStr_F_ULOCK);
        }
    }




    static if(!is(typeof(F_LOCK))) {
        private enum enumMixinStr_F_LOCK = `enum F_LOCK = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_F_LOCK); }))) {
            mixin(enumMixinStr_F_LOCK);
        }
    }




    static if(!is(typeof(F_TLOCK))) {
        private enum enumMixinStr_F_TLOCK = `enum F_TLOCK = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_F_TLOCK); }))) {
            mixin(enumMixinStr_F_TLOCK);
        }
    }




    static if(!is(typeof(F_TEST))) {
        private enum enumMixinStr_F_TEST = `enum F_TEST = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_F_TEST); }))) {
            mixin(enumMixinStr_F_TEST);
        }
    }




    static if(!is(typeof(__LP64_OFF64_CFLAGS))) {
        private enum enumMixinStr___LP64_OFF64_CFLAGS = `enum __LP64_OFF64_CFLAGS = "-m64";`;
        static if(is(typeof({ mixin(enumMixinStr___LP64_OFF64_CFLAGS); }))) {
            mixin(enumMixinStr___LP64_OFF64_CFLAGS);
        }
    }




    static if(!is(typeof(__ILP32_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr___ILP32_OFFBIG_LDFLAGS = `enum __ILP32_OFFBIG_LDFLAGS = "-m32";`;
        static if(is(typeof({ mixin(enumMixinStr___ILP32_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr___ILP32_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(__ILP32_OFFBIG_CFLAGS))) {
        private enum enumMixinStr___ILP32_OFFBIG_CFLAGS = `enum __ILP32_OFFBIG_CFLAGS = "-m32 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64";`;
        static if(is(typeof({ mixin(enumMixinStr___ILP32_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr___ILP32_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(__ILP32_OFF32_LDFLAGS))) {
        private enum enumMixinStr___ILP32_OFF32_LDFLAGS = `enum __ILP32_OFF32_LDFLAGS = "-m32";`;
        static if(is(typeof({ mixin(enumMixinStr___ILP32_OFF32_LDFLAGS); }))) {
            mixin(enumMixinStr___ILP32_OFF32_LDFLAGS);
        }
    }




    static if(!is(typeof(__ILP32_OFF32_CFLAGS))) {
        private enum enumMixinStr___ILP32_OFF32_CFLAGS = `enum __ILP32_OFF32_CFLAGS = "-m32";`;
        static if(is(typeof({ mixin(enumMixinStr___ILP32_OFF32_CFLAGS); }))) {
            mixin(enumMixinStr___ILP32_OFF32_CFLAGS);
        }
    }




    static if(!is(typeof(_XBS5_LP64_OFF64))) {
        private enum enumMixinStr__XBS5_LP64_OFF64 = `enum _XBS5_LP64_OFF64 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__XBS5_LP64_OFF64); }))) {
            mixin(enumMixinStr__XBS5_LP64_OFF64);
        }
    }




    static if(!is(typeof(_POSIX_V6_LP64_OFF64))) {
        private enum enumMixinStr__POSIX_V6_LP64_OFF64 = `enum _POSIX_V6_LP64_OFF64 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_V6_LP64_OFF64); }))) {
            mixin(enumMixinStr__POSIX_V6_LP64_OFF64);
        }
    }




    static if(!is(typeof(_POSIX_V7_LP64_OFF64))) {
        private enum enumMixinStr__POSIX_V7_LP64_OFF64 = `enum _POSIX_V7_LP64_OFF64 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_V7_LP64_OFF64); }))) {
            mixin(enumMixinStr__POSIX_V7_LP64_OFF64);
        }
    }




    static if(!is(typeof(_XBS5_LPBIG_OFFBIG))) {
        private enum enumMixinStr__XBS5_LPBIG_OFFBIG = `enum _XBS5_LPBIG_OFFBIG = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__XBS5_LPBIG_OFFBIG); }))) {
            mixin(enumMixinStr__XBS5_LPBIG_OFFBIG);
        }
    }




    static if(!is(typeof(_POSIX_V6_LPBIG_OFFBIG))) {
        private enum enumMixinStr__POSIX_V6_LPBIG_OFFBIG = `enum _POSIX_V6_LPBIG_OFFBIG = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_V6_LPBIG_OFFBIG); }))) {
            mixin(enumMixinStr__POSIX_V6_LPBIG_OFFBIG);
        }
    }




    static if(!is(typeof(_FEATURES_H))) {
        private enum enumMixinStr__FEATURES_H = `enum _FEATURES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__FEATURES_H); }))) {
            mixin(enumMixinStr__FEATURES_H);
        }
    }






    static if(!is(typeof(_POSIX_V7_LPBIG_OFFBIG))) {
        private enum enumMixinStr__POSIX_V7_LPBIG_OFFBIG = `enum _POSIX_V7_LPBIG_OFFBIG = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_V7_LPBIG_OFFBIG); }))) {
            mixin(enumMixinStr__POSIX_V7_LPBIG_OFFBIG);
        }
    }




    static if(!is(typeof(__BYTE_ORDER))) {
        private enum enumMixinStr___BYTE_ORDER = `enum __BYTE_ORDER = __LITTLE_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr___BYTE_ORDER); }))) {
            mixin(enumMixinStr___BYTE_ORDER);
        }
    }






    static if(!is(typeof(_BITS_ENDIANNESS_H))) {
        private enum enumMixinStr__BITS_ENDIANNESS_H = `enum _BITS_ENDIANNESS_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_ENDIANNESS_H); }))) {
            mixin(enumMixinStr__BITS_ENDIANNESS_H);
        }
    }
    static if(!is(typeof(_DEFAULT_SOURCE))) {
        private enum enumMixinStr__DEFAULT_SOURCE = `enum _DEFAULT_SOURCE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__DEFAULT_SOURCE); }))) {
            mixin(enumMixinStr__DEFAULT_SOURCE);
        }
    }




    static if(!is(typeof(__FLOAT_WORD_ORDER))) {
        private enum enumMixinStr___FLOAT_WORD_ORDER = `enum __FLOAT_WORD_ORDER = __LITTLE_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr___FLOAT_WORD_ORDER); }))) {
            mixin(enumMixinStr___FLOAT_WORD_ORDER);
        }
    }




    static if(!is(typeof(__PDP_ENDIAN))) {
        private enum enumMixinStr___PDP_ENDIAN = `enum __PDP_ENDIAN = 3412;`;
        static if(is(typeof({ mixin(enumMixinStr___PDP_ENDIAN); }))) {
            mixin(enumMixinStr___PDP_ENDIAN);
        }
    }




    static if(!is(typeof(__GLIBC_USE_ISOC2X))) {
        private enum enumMixinStr___GLIBC_USE_ISOC2X = `enum __GLIBC_USE_ISOC2X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_ISOC2X); }))) {
            mixin(enumMixinStr___GLIBC_USE_ISOC2X);
        }
    }




    static if(!is(typeof(__BIG_ENDIAN))) {
        private enum enumMixinStr___BIG_ENDIAN = `enum __BIG_ENDIAN = 4321;`;
        static if(is(typeof({ mixin(enumMixinStr___BIG_ENDIAN); }))) {
            mixin(enumMixinStr___BIG_ENDIAN);
        }
    }




    static if(!is(typeof(__LITTLE_ENDIAN))) {
        private enum enumMixinStr___LITTLE_ENDIAN = `enum __LITTLE_ENDIAN = 1234;`;
        static if(is(typeof({ mixin(enumMixinStr___LITTLE_ENDIAN); }))) {
            mixin(enumMixinStr___LITTLE_ENDIAN);
        }
    }




    static if(!is(typeof(__USE_ISOC11))) {
        private enum enumMixinStr___USE_ISOC11 = `enum __USE_ISOC11 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ISOC11); }))) {
            mixin(enumMixinStr___USE_ISOC11);
        }
    }




    static if(!is(typeof(_BITS_ENDIAN_H))) {
        private enum enumMixinStr__BITS_ENDIAN_H = `enum _BITS_ENDIAN_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_ENDIAN_H); }))) {
            mixin(enumMixinStr__BITS_ENDIAN_H);
        }
    }




    static if(!is(typeof(_CS_V7_ENV))) {
        private enum enumMixinStr__CS_V7_ENV = `enum _CS_V7_ENV = _CS_V7_ENV;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_V7_ENV); }))) {
            mixin(enumMixinStr__CS_V7_ENV);
        }
    }




    static if(!is(typeof(__USE_ISOC99))) {
        private enum enumMixinStr___USE_ISOC99 = `enum __USE_ISOC99 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ISOC99); }))) {
            mixin(enumMixinStr___USE_ISOC99);
        }
    }




    static if(!is(typeof(_CS_V6_ENV))) {
        private enum enumMixinStr__CS_V6_ENV = `enum _CS_V6_ENV = _CS_V6_ENV;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_V6_ENV); }))) {
            mixin(enumMixinStr__CS_V6_ENV);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS = `enum _CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS = _CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS);
        }
    }




    static if(!is(typeof(__USE_ISOC95))) {
        private enum enumMixinStr___USE_ISOC95 = `enum __USE_ISOC95 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ISOC95); }))) {
            mixin(enumMixinStr___USE_ISOC95);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LPBIG_OFFBIG_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LIBS = `enum _CS_POSIX_V7_LPBIG_OFFBIG_LIBS = _CS_POSIX_V7_LPBIG_OFFBIG_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LIBS);
        }
    }




    static if(!is(typeof(__USE_POSIX_IMPLICITLY))) {
        private enum enumMixinStr___USE_POSIX_IMPLICITLY = `enum __USE_POSIX_IMPLICITLY = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX_IMPLICITLY); }))) {
            mixin(enumMixinStr___USE_POSIX_IMPLICITLY);
        }
    }




    static if(!is(typeof(_POSIX_SOURCE))) {
        private enum enumMixinStr__POSIX_SOURCE = `enum _POSIX_SOURCE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SOURCE); }))) {
            mixin(enumMixinStr__POSIX_SOURCE);
        }
    }




    static if(!is(typeof(_POSIX_C_SOURCE))) {
        private enum enumMixinStr__POSIX_C_SOURCE = `enum _POSIX_C_SOURCE = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_C_SOURCE); }))) {
            mixin(enumMixinStr__POSIX_C_SOURCE);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = `enum _CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = _CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = `enum _CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = _CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LP64_OFF64_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_LP64_OFF64_LINTFLAGS = `enum _CS_POSIX_V7_LP64_OFF64_LINTFLAGS = _CS_POSIX_V7_LP64_OFF64_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LP64_OFF64_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V7_LP64_OFF64_LIBS = `enum _CS_POSIX_V7_LP64_OFF64_LIBS = _CS_POSIX_V7_LP64_OFF64_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LP64_OFF64_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_LP64_OFF64_LDFLAGS = `enum _CS_POSIX_V7_LP64_OFF64_LDFLAGS = _CS_POSIX_V7_LP64_OFF64_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LP64_OFF64_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_LP64_OFF64_CFLAGS = `enum _CS_POSIX_V7_LP64_OFF64_CFLAGS = _CS_POSIX_V7_LP64_OFF64_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS = `enum _CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS = _CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS);
        }
    }




    static if(!is(typeof(__USE_POSIX))) {
        private enum enumMixinStr___USE_POSIX = `enum __USE_POSIX = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX); }))) {
            mixin(enumMixinStr___USE_POSIX);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFFBIG_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LIBS = `enum _CS_POSIX_V7_ILP32_OFFBIG_LIBS = _CS_POSIX_V7_ILP32_OFFBIG_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = `enum _CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = _CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(__USE_POSIX2))) {
        private enum enumMixinStr___USE_POSIX2 = `enum __USE_POSIX2 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX2); }))) {
            mixin(enumMixinStr___USE_POSIX2);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFFBIG_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = `enum _CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = _CS_POSIX_V7_ILP32_OFFBIG_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFF32_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LINTFLAGS = `enum _CS_POSIX_V7_ILP32_OFF32_LINTFLAGS = _CS_POSIX_V7_ILP32_OFF32_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LINTFLAGS);
        }
    }




    static if(!is(typeof(__USE_POSIX199309))) {
        private enum enumMixinStr___USE_POSIX199309 = `enum __USE_POSIX199309 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX199309); }))) {
            mixin(enumMixinStr___USE_POSIX199309);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFF32_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LIBS = `enum _CS_POSIX_V7_ILP32_OFF32_LIBS = _CS_POSIX_V7_ILP32_OFF32_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFF32_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LDFLAGS = `enum _CS_POSIX_V7_ILP32_OFF32_LDFLAGS = _CS_POSIX_V7_ILP32_OFF32_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LDFLAGS);
        }
    }




    static if(!is(typeof(__USE_POSIX199506))) {
        private enum enumMixinStr___USE_POSIX199506 = `enum __USE_POSIX199506 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX199506); }))) {
            mixin(enumMixinStr___USE_POSIX199506);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFF32_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFF32_CFLAGS = `enum _CS_POSIX_V7_ILP32_OFF32_CFLAGS = _CS_POSIX_V7_ILP32_OFF32_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS = `enum _CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS = _CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS);
        }
    }




    static if(!is(typeof(__USE_XOPEN2K))) {
        private enum enumMixinStr___USE_XOPEN2K = `enum __USE_XOPEN2K = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_XOPEN2K); }))) {
            mixin(enumMixinStr___USE_XOPEN2K);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LPBIG_OFFBIG_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LIBS = `enum _CS_POSIX_V6_LPBIG_OFFBIG_LIBS = _CS_POSIX_V6_LPBIG_OFFBIG_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = `enum _CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = _CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(__USE_XOPEN2K8))) {
        private enum enumMixinStr___USE_XOPEN2K8 = `enum __USE_XOPEN2K8 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_XOPEN2K8); }))) {
            mixin(enumMixinStr___USE_XOPEN2K8);
        }
    }




    static if(!is(typeof(_ATFILE_SOURCE))) {
        private enum enumMixinStr__ATFILE_SOURCE = `enum _ATFILE_SOURCE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__ATFILE_SOURCE); }))) {
            mixin(enumMixinStr__ATFILE_SOURCE);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = `enum _CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = _CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LP64_OFF64_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_LP64_OFF64_LINTFLAGS = `enum _CS_POSIX_V6_LP64_OFF64_LINTFLAGS = _CS_POSIX_V6_LP64_OFF64_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_LINTFLAGS);
        }
    }




    static if(!is(typeof(__USE_MISC))) {
        private enum enumMixinStr___USE_MISC = `enum __USE_MISC = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_MISC); }))) {
            mixin(enumMixinStr___USE_MISC);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LP64_OFF64_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V6_LP64_OFF64_LIBS = `enum _CS_POSIX_V6_LP64_OFF64_LIBS = _CS_POSIX_V6_LP64_OFF64_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_LIBS);
        }
    }




    static if(!is(typeof(__USE_ATFILE))) {
        private enum enumMixinStr___USE_ATFILE = `enum __USE_ATFILE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ATFILE); }))) {
            mixin(enumMixinStr___USE_ATFILE);
        }
    }




    static if(!is(typeof(__USE_FORTIFY_LEVEL))) {
        private enum enumMixinStr___USE_FORTIFY_LEVEL = `enum __USE_FORTIFY_LEVEL = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_FORTIFY_LEVEL); }))) {
            mixin(enumMixinStr___USE_FORTIFY_LEVEL);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LP64_OFF64_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_LP64_OFF64_LDFLAGS = `enum _CS_POSIX_V6_LP64_OFF64_LDFLAGS = _CS_POSIX_V6_LP64_OFF64_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_LDFLAGS);
        }
    }




    static if(!is(typeof(__GLIBC_USE_DEPRECATED_GETS))) {
        private enum enumMixinStr___GLIBC_USE_DEPRECATED_GETS = `enum __GLIBC_USE_DEPRECATED_GETS = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_DEPRECATED_GETS); }))) {
            mixin(enumMixinStr___GLIBC_USE_DEPRECATED_GETS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LP64_OFF64_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_LP64_OFF64_CFLAGS = `enum _CS_POSIX_V6_LP64_OFF64_CFLAGS = _CS_POSIX_V6_LP64_OFF64_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS = `enum _CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS = _CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS);
        }
    }




    static if(!is(typeof(__GLIBC_USE_DEPRECATED_SCANF))) {
        private enum enumMixinStr___GLIBC_USE_DEPRECATED_SCANF = `enum __GLIBC_USE_DEPRECATED_SCANF = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_DEPRECATED_SCANF); }))) {
            mixin(enumMixinStr___GLIBC_USE_DEPRECATED_SCANF);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFFBIG_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LIBS = `enum _CS_POSIX_V6_ILP32_OFFBIG_LIBS = _CS_POSIX_V6_ILP32_OFFBIG_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LIBS);
        }
    }




    static if(!is(typeof(__GNU_LIBRARY__))) {
        private enum enumMixinStr___GNU_LIBRARY__ = `enum __GNU_LIBRARY__ = 6;`;
        static if(is(typeof({ mixin(enumMixinStr___GNU_LIBRARY__); }))) {
            mixin(enumMixinStr___GNU_LIBRARY__);
        }
    }




    static if(!is(typeof(__GLIBC__))) {
        private enum enumMixinStr___GLIBC__ = `enum __GLIBC__ = 2;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC__); }))) {
            mixin(enumMixinStr___GLIBC__);
        }
    }




    static if(!is(typeof(__GLIBC_MINOR__))) {
        private enum enumMixinStr___GLIBC_MINOR__ = `enum __GLIBC_MINOR__ = 35;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_MINOR__); }))) {
            mixin(enumMixinStr___GLIBC_MINOR__);
        }
    }






    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = `enum _CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = _CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFFBIG_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = `enum _CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = _CS_POSIX_V6_ILP32_OFFBIG_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFF32_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LINTFLAGS = `enum _CS_POSIX_V6_ILP32_OFF32_LINTFLAGS = _CS_POSIX_V6_ILP32_OFF32_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFF32_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LIBS = `enum _CS_POSIX_V6_ILP32_OFF32_LIBS = _CS_POSIX_V6_ILP32_OFF32_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFF32_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LDFLAGS = `enum _CS_POSIX_V6_ILP32_OFF32_LDFLAGS = _CS_POSIX_V6_ILP32_OFF32_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFF32_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFF32_CFLAGS = `enum _CS_POSIX_V6_ILP32_OFF32_CFLAGS = _CS_POSIX_V6_ILP32_OFF32_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_CFLAGS);
        }
    }
    static if(!is(typeof(_CS_XBS5_LPBIG_OFFBIG_LINTFLAGS))) {
        private enum enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = `enum _CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = _CS_XBS5_LPBIG_OFFBIG_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LPBIG_OFFBIG_LIBS))) {
        private enum enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LIBS = `enum _CS_XBS5_LPBIG_OFFBIG_LIBS = _CS_XBS5_LPBIG_OFFBIG_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LIBS); }))) {
            mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LIBS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LPBIG_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LDFLAGS = `enum _CS_XBS5_LPBIG_OFFBIG_LDFLAGS = _CS_XBS5_LPBIG_OFFBIG_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LPBIG_OFFBIG_CFLAGS))) {
        private enum enumMixinStr__CS_XBS5_LPBIG_OFFBIG_CFLAGS = `enum _CS_XBS5_LPBIG_OFFBIG_CFLAGS = _CS_XBS5_LPBIG_OFFBIG_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LP64_OFF64_LINTFLAGS))) {
        private enum enumMixinStr__CS_XBS5_LP64_OFF64_LINTFLAGS = `enum _CS_XBS5_LP64_OFF64_LINTFLAGS = _CS_XBS5_LP64_OFF64_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LP64_OFF64_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_LP64_OFF64_LINTFLAGS);
        }
    }
    static if(!is(typeof(BPF_LD))) {
        private enum enumMixinStr_BPF_LD = `enum BPF_LD = 0x00;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_LD); }))) {
            mixin(enumMixinStr_BPF_LD);
        }
    }




    static if(!is(typeof(BPF_LDX))) {
        private enum enumMixinStr_BPF_LDX = `enum BPF_LDX = 0x01;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_LDX); }))) {
            mixin(enumMixinStr_BPF_LDX);
        }
    }




    static if(!is(typeof(BPF_ST))) {
        private enum enumMixinStr_BPF_ST = `enum BPF_ST = 0x02;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_ST); }))) {
            mixin(enumMixinStr_BPF_ST);
        }
    }




    static if(!is(typeof(BPF_STX))) {
        private enum enumMixinStr_BPF_STX = `enum BPF_STX = 0x03;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_STX); }))) {
            mixin(enumMixinStr_BPF_STX);
        }
    }




    static if(!is(typeof(BPF_ALU))) {
        private enum enumMixinStr_BPF_ALU = `enum BPF_ALU = 0x04;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_ALU); }))) {
            mixin(enumMixinStr_BPF_ALU);
        }
    }




    static if(!is(typeof(BPF_JMP))) {
        private enum enumMixinStr_BPF_JMP = `enum BPF_JMP = 0x05;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_JMP); }))) {
            mixin(enumMixinStr_BPF_JMP);
        }
    }




    static if(!is(typeof(BPF_RET))) {
        private enum enumMixinStr_BPF_RET = `enum BPF_RET = 0x06;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_RET); }))) {
            mixin(enumMixinStr_BPF_RET);
        }
    }




    static if(!is(typeof(BPF_MISC))) {
        private enum enumMixinStr_BPF_MISC = `enum BPF_MISC = 0x07;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_MISC); }))) {
            mixin(enumMixinStr_BPF_MISC);
        }
    }






    static if(!is(typeof(BPF_W))) {
        private enum enumMixinStr_BPF_W = `enum BPF_W = 0x00;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_W); }))) {
            mixin(enumMixinStr_BPF_W);
        }
    }




    static if(!is(typeof(BPF_H))) {
        private enum enumMixinStr_BPF_H = `enum BPF_H = 0x08;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_H); }))) {
            mixin(enumMixinStr_BPF_H);
        }
    }




    static if(!is(typeof(BPF_B))) {
        private enum enumMixinStr_BPF_B = `enum BPF_B = 0x10;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_B); }))) {
            mixin(enumMixinStr_BPF_B);
        }
    }






    static if(!is(typeof(BPF_IMM))) {
        private enum enumMixinStr_BPF_IMM = `enum BPF_IMM = 0x00;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_IMM); }))) {
            mixin(enumMixinStr_BPF_IMM);
        }
    }




    static if(!is(typeof(BPF_ABS))) {
        private enum enumMixinStr_BPF_ABS = `enum BPF_ABS = 0x20;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_ABS); }))) {
            mixin(enumMixinStr_BPF_ABS);
        }
    }




    static if(!is(typeof(BPF_IND))) {
        private enum enumMixinStr_BPF_IND = `enum BPF_IND = 0x40;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_IND); }))) {
            mixin(enumMixinStr_BPF_IND);
        }
    }




    static if(!is(typeof(BPF_MEM))) {
        private enum enumMixinStr_BPF_MEM = `enum BPF_MEM = 0x60;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_MEM); }))) {
            mixin(enumMixinStr_BPF_MEM);
        }
    }




    static if(!is(typeof(BPF_LEN))) {
        private enum enumMixinStr_BPF_LEN = `enum BPF_LEN = 0x80;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_LEN); }))) {
            mixin(enumMixinStr_BPF_LEN);
        }
    }




    static if(!is(typeof(BPF_MSH))) {
        private enum enumMixinStr_BPF_MSH = `enum BPF_MSH = 0xa0;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_MSH); }))) {
            mixin(enumMixinStr_BPF_MSH);
        }
    }






    static if(!is(typeof(BPF_ADD))) {
        private enum enumMixinStr_BPF_ADD = `enum BPF_ADD = 0x00;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_ADD); }))) {
            mixin(enumMixinStr_BPF_ADD);
        }
    }




    static if(!is(typeof(BPF_SUB))) {
        private enum enumMixinStr_BPF_SUB = `enum BPF_SUB = 0x10;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_SUB); }))) {
            mixin(enumMixinStr_BPF_SUB);
        }
    }




    static if(!is(typeof(BPF_MUL))) {
        private enum enumMixinStr_BPF_MUL = `enum BPF_MUL = 0x20;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_MUL); }))) {
            mixin(enumMixinStr_BPF_MUL);
        }
    }




    static if(!is(typeof(BPF_DIV))) {
        private enum enumMixinStr_BPF_DIV = `enum BPF_DIV = 0x30;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_DIV); }))) {
            mixin(enumMixinStr_BPF_DIV);
        }
    }




    static if(!is(typeof(BPF_OR))) {
        private enum enumMixinStr_BPF_OR = `enum BPF_OR = 0x40;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_OR); }))) {
            mixin(enumMixinStr_BPF_OR);
        }
    }




    static if(!is(typeof(BPF_AND))) {
        private enum enumMixinStr_BPF_AND = `enum BPF_AND = 0x50;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_AND); }))) {
            mixin(enumMixinStr_BPF_AND);
        }
    }




    static if(!is(typeof(BPF_LSH))) {
        private enum enumMixinStr_BPF_LSH = `enum BPF_LSH = 0x60;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_LSH); }))) {
            mixin(enumMixinStr_BPF_LSH);
        }
    }




    static if(!is(typeof(BPF_RSH))) {
        private enum enumMixinStr_BPF_RSH = `enum BPF_RSH = 0x70;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_RSH); }))) {
            mixin(enumMixinStr_BPF_RSH);
        }
    }




    static if(!is(typeof(BPF_NEG))) {
        private enum enumMixinStr_BPF_NEG = `enum BPF_NEG = 0x80;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_NEG); }))) {
            mixin(enumMixinStr_BPF_NEG);
        }
    }




    static if(!is(typeof(BPF_MOD))) {
        private enum enumMixinStr_BPF_MOD = `enum BPF_MOD = 0x90;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_MOD); }))) {
            mixin(enumMixinStr_BPF_MOD);
        }
    }




    static if(!is(typeof(BPF_XOR))) {
        private enum enumMixinStr_BPF_XOR = `enum BPF_XOR = 0xa0;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_XOR); }))) {
            mixin(enumMixinStr_BPF_XOR);
        }
    }




    static if(!is(typeof(BPF_JA))) {
        private enum enumMixinStr_BPF_JA = `enum BPF_JA = 0x00;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_JA); }))) {
            mixin(enumMixinStr_BPF_JA);
        }
    }




    static if(!is(typeof(BPF_JEQ))) {
        private enum enumMixinStr_BPF_JEQ = `enum BPF_JEQ = 0x10;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_JEQ); }))) {
            mixin(enumMixinStr_BPF_JEQ);
        }
    }




    static if(!is(typeof(BPF_JGT))) {
        private enum enumMixinStr_BPF_JGT = `enum BPF_JGT = 0x20;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_JGT); }))) {
            mixin(enumMixinStr_BPF_JGT);
        }
    }




    static if(!is(typeof(BPF_JGE))) {
        private enum enumMixinStr_BPF_JGE = `enum BPF_JGE = 0x30;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_JGE); }))) {
            mixin(enumMixinStr_BPF_JGE);
        }
    }




    static if(!is(typeof(BPF_JSET))) {
        private enum enumMixinStr_BPF_JSET = `enum BPF_JSET = 0x40;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_JSET); }))) {
            mixin(enumMixinStr_BPF_JSET);
        }
    }






    static if(!is(typeof(BPF_K))) {
        private enum enumMixinStr_BPF_K = `enum BPF_K = 0x00;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_K); }))) {
            mixin(enumMixinStr_BPF_K);
        }
    }




    static if(!is(typeof(BPF_X))) {
        private enum enumMixinStr_BPF_X = `enum BPF_X = 0x08;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_X); }))) {
            mixin(enumMixinStr_BPF_X);
        }
    }




    static if(!is(typeof(BPF_MAXINSNS))) {
        private enum enumMixinStr_BPF_MAXINSNS = `enum BPF_MAXINSNS = 4096;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_MAXINSNS); }))) {
            mixin(enumMixinStr_BPF_MAXINSNS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LP64_OFF64_LIBS))) {
        private enum enumMixinStr__CS_XBS5_LP64_OFF64_LIBS = `enum _CS_XBS5_LP64_OFF64_LIBS = _CS_XBS5_LP64_OFF64_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LP64_OFF64_LIBS); }))) {
            mixin(enumMixinStr__CS_XBS5_LP64_OFF64_LIBS);
        }
    }






    static if(!is(typeof(_CS_XBS5_LP64_OFF64_LDFLAGS))) {
        private enum enumMixinStr__CS_XBS5_LP64_OFF64_LDFLAGS = `enum _CS_XBS5_LP64_OFF64_LDFLAGS = _CS_XBS5_LP64_OFF64_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LP64_OFF64_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_LP64_OFF64_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LP64_OFF64_CFLAGS))) {
        private enum enumMixinStr__CS_XBS5_LP64_OFF64_CFLAGS = `enum _CS_XBS5_LP64_OFF64_CFLAGS = _CS_XBS5_LP64_OFF64_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LP64_OFF64_CFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_LP64_OFF64_CFLAGS);
        }
    }




    static if(!is(typeof(BPF_MAJOR_VERSION))) {
        private enum enumMixinStr_BPF_MAJOR_VERSION = `enum BPF_MAJOR_VERSION = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_MAJOR_VERSION); }))) {
            mixin(enumMixinStr_BPF_MAJOR_VERSION);
        }
    }




    static if(!is(typeof(BPF_MINOR_VERSION))) {
        private enum enumMixinStr_BPF_MINOR_VERSION = `enum BPF_MINOR_VERSION = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_MINOR_VERSION); }))) {
            mixin(enumMixinStr_BPF_MINOR_VERSION);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFFBIG_LINTFLAGS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFFBIG_LINTFLAGS = `enum _CS_XBS5_ILP32_OFFBIG_LINTFLAGS = _CS_XBS5_ILP32_OFFBIG_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFFBIG_LIBS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFFBIG_LIBS = `enum _CS_XBS5_ILP32_OFFBIG_LIBS = _CS_XBS5_ILP32_OFFBIG_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_LIBS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_LIBS);
        }
    }






    static if(!is(typeof(BPF_A))) {
        private enum enumMixinStr_BPF_A = `enum BPF_A = 0x10;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_A); }))) {
            mixin(enumMixinStr_BPF_A);
        }
    }






    static if(!is(typeof(BPF_TAX))) {
        private enum enumMixinStr_BPF_TAX = `enum BPF_TAX = 0x00;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_TAX); }))) {
            mixin(enumMixinStr_BPF_TAX);
        }
    }




    static if(!is(typeof(BPF_TXA))) {
        private enum enumMixinStr_BPF_TXA = `enum BPF_TXA = 0x80;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_TXA); }))) {
            mixin(enumMixinStr_BPF_TXA);
        }
    }
    static if(!is(typeof(BPF_MEMWORDS))) {
        private enum enumMixinStr_BPF_MEMWORDS = `enum BPF_MEMWORDS = 16;`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_MEMWORDS); }))) {
            mixin(enumMixinStr_BPF_MEMWORDS);
        }
    }




    static if(!is(typeof(SKF_AD_OFF))) {
        private enum enumMixinStr_SKF_AD_OFF = `enum SKF_AD_OFF = ( - 0x1000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_OFF); }))) {
            mixin(enumMixinStr_SKF_AD_OFF);
        }
    }




    static if(!is(typeof(SKF_AD_PROTOCOL))) {
        private enum enumMixinStr_SKF_AD_PROTOCOL = `enum SKF_AD_PROTOCOL = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_PROTOCOL); }))) {
            mixin(enumMixinStr_SKF_AD_PROTOCOL);
        }
    }




    static if(!is(typeof(SKF_AD_PKTTYPE))) {
        private enum enumMixinStr_SKF_AD_PKTTYPE = `enum SKF_AD_PKTTYPE = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_PKTTYPE); }))) {
            mixin(enumMixinStr_SKF_AD_PKTTYPE);
        }
    }




    static if(!is(typeof(SKF_AD_IFINDEX))) {
        private enum enumMixinStr_SKF_AD_IFINDEX = `enum SKF_AD_IFINDEX = 8;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_IFINDEX); }))) {
            mixin(enumMixinStr_SKF_AD_IFINDEX);
        }
    }




    static if(!is(typeof(SKF_AD_NLATTR))) {
        private enum enumMixinStr_SKF_AD_NLATTR = `enum SKF_AD_NLATTR = 12;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_NLATTR); }))) {
            mixin(enumMixinStr_SKF_AD_NLATTR);
        }
    }




    static if(!is(typeof(SKF_AD_NLATTR_NEST))) {
        private enum enumMixinStr_SKF_AD_NLATTR_NEST = `enum SKF_AD_NLATTR_NEST = 16;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_NLATTR_NEST); }))) {
            mixin(enumMixinStr_SKF_AD_NLATTR_NEST);
        }
    }




    static if(!is(typeof(SKF_AD_MARK))) {
        private enum enumMixinStr_SKF_AD_MARK = `enum SKF_AD_MARK = 20;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_MARK); }))) {
            mixin(enumMixinStr_SKF_AD_MARK);
        }
    }




    static if(!is(typeof(SKF_AD_QUEUE))) {
        private enum enumMixinStr_SKF_AD_QUEUE = `enum SKF_AD_QUEUE = 24;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_QUEUE); }))) {
            mixin(enumMixinStr_SKF_AD_QUEUE);
        }
    }




    static if(!is(typeof(SKF_AD_HATYPE))) {
        private enum enumMixinStr_SKF_AD_HATYPE = `enum SKF_AD_HATYPE = 28;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_HATYPE); }))) {
            mixin(enumMixinStr_SKF_AD_HATYPE);
        }
    }




    static if(!is(typeof(SKF_AD_RXHASH))) {
        private enum enumMixinStr_SKF_AD_RXHASH = `enum SKF_AD_RXHASH = 32;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_RXHASH); }))) {
            mixin(enumMixinStr_SKF_AD_RXHASH);
        }
    }




    static if(!is(typeof(SKF_AD_CPU))) {
        private enum enumMixinStr_SKF_AD_CPU = `enum SKF_AD_CPU = 36;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_CPU); }))) {
            mixin(enumMixinStr_SKF_AD_CPU);
        }
    }




    static if(!is(typeof(SKF_AD_ALU_XOR_X))) {
        private enum enumMixinStr_SKF_AD_ALU_XOR_X = `enum SKF_AD_ALU_XOR_X = 40;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_ALU_XOR_X); }))) {
            mixin(enumMixinStr_SKF_AD_ALU_XOR_X);
        }
    }




    static if(!is(typeof(SKF_AD_VLAN_TAG))) {
        private enum enumMixinStr_SKF_AD_VLAN_TAG = `enum SKF_AD_VLAN_TAG = 44;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_VLAN_TAG); }))) {
            mixin(enumMixinStr_SKF_AD_VLAN_TAG);
        }
    }




    static if(!is(typeof(SKF_AD_VLAN_TAG_PRESENT))) {
        private enum enumMixinStr_SKF_AD_VLAN_TAG_PRESENT = `enum SKF_AD_VLAN_TAG_PRESENT = 48;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_VLAN_TAG_PRESENT); }))) {
            mixin(enumMixinStr_SKF_AD_VLAN_TAG_PRESENT);
        }
    }




    static if(!is(typeof(SKF_AD_PAY_OFFSET))) {
        private enum enumMixinStr_SKF_AD_PAY_OFFSET = `enum SKF_AD_PAY_OFFSET = 52;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_PAY_OFFSET); }))) {
            mixin(enumMixinStr_SKF_AD_PAY_OFFSET);
        }
    }




    static if(!is(typeof(SKF_AD_RANDOM))) {
        private enum enumMixinStr_SKF_AD_RANDOM = `enum SKF_AD_RANDOM = 56;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_RANDOM); }))) {
            mixin(enumMixinStr_SKF_AD_RANDOM);
        }
    }




    static if(!is(typeof(SKF_AD_VLAN_TPID))) {
        private enum enumMixinStr_SKF_AD_VLAN_TPID = `enum SKF_AD_VLAN_TPID = 60;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_VLAN_TPID); }))) {
            mixin(enumMixinStr_SKF_AD_VLAN_TPID);
        }
    }




    static if(!is(typeof(SKF_AD_MAX))) {
        private enum enumMixinStr_SKF_AD_MAX = `enum SKF_AD_MAX = 64;`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_AD_MAX); }))) {
            mixin(enumMixinStr_SKF_AD_MAX);
        }
    }




    static if(!is(typeof(SKF_NET_OFF))) {
        private enum enumMixinStr_SKF_NET_OFF = `enum SKF_NET_OFF = ( - 0x100000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_NET_OFF); }))) {
            mixin(enumMixinStr_SKF_NET_OFF);
        }
    }




    static if(!is(typeof(SKF_LL_OFF))) {
        private enum enumMixinStr_SKF_LL_OFF = `enum SKF_LL_OFF = ( - 0x200000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SKF_LL_OFF); }))) {
            mixin(enumMixinStr_SKF_LL_OFF);
        }
    }




    static if(!is(typeof(BPF_NET_OFF))) {
        private enum enumMixinStr_BPF_NET_OFF = `enum BPF_NET_OFF = ( - 0x100000 );`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_NET_OFF); }))) {
            mixin(enumMixinStr_BPF_NET_OFF);
        }
    }




    static if(!is(typeof(BPF_LL_OFF))) {
        private enum enumMixinStr_BPF_LL_OFF = `enum BPF_LL_OFF = ( - 0x200000 );`;
        static if(is(typeof({ mixin(enumMixinStr_BPF_LL_OFF); }))) {
            mixin(enumMixinStr_BPF_LL_OFF);
        }
    }






    static if(!is(typeof(GENERIC_HDLC_VERSION))) {
        private enum enumMixinStr_GENERIC_HDLC_VERSION = `enum GENERIC_HDLC_VERSION = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_GENERIC_HDLC_VERSION); }))) {
            mixin(enumMixinStr_GENERIC_HDLC_VERSION);
        }
    }




    static if(!is(typeof(CLOCK_DEFAULT))) {
        private enum enumMixinStr_CLOCK_DEFAULT = `enum CLOCK_DEFAULT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_DEFAULT); }))) {
            mixin(enumMixinStr_CLOCK_DEFAULT);
        }
    }




    static if(!is(typeof(CLOCK_EXT))) {
        private enum enumMixinStr_CLOCK_EXT = `enum CLOCK_EXT = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_EXT); }))) {
            mixin(enumMixinStr_CLOCK_EXT);
        }
    }




    static if(!is(typeof(CLOCK_INT))) {
        private enum enumMixinStr_CLOCK_INT = `enum CLOCK_INT = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_INT); }))) {
            mixin(enumMixinStr_CLOCK_INT);
        }
    }




    static if(!is(typeof(CLOCK_TXINT))) {
        private enum enumMixinStr_CLOCK_TXINT = `enum CLOCK_TXINT = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_TXINT); }))) {
            mixin(enumMixinStr_CLOCK_TXINT);
        }
    }




    static if(!is(typeof(CLOCK_TXFROMRX))) {
        private enum enumMixinStr_CLOCK_TXFROMRX = `enum CLOCK_TXFROMRX = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_TXFROMRX); }))) {
            mixin(enumMixinStr_CLOCK_TXFROMRX);
        }
    }




    static if(!is(typeof(ENCODING_DEFAULT))) {
        private enum enumMixinStr_ENCODING_DEFAULT = `enum ENCODING_DEFAULT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_ENCODING_DEFAULT); }))) {
            mixin(enumMixinStr_ENCODING_DEFAULT);
        }
    }




    static if(!is(typeof(ENCODING_NRZ))) {
        private enum enumMixinStr_ENCODING_NRZ = `enum ENCODING_NRZ = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_ENCODING_NRZ); }))) {
            mixin(enumMixinStr_ENCODING_NRZ);
        }
    }




    static if(!is(typeof(ENCODING_NRZI))) {
        private enum enumMixinStr_ENCODING_NRZI = `enum ENCODING_NRZI = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_ENCODING_NRZI); }))) {
            mixin(enumMixinStr_ENCODING_NRZI);
        }
    }




    static if(!is(typeof(ENCODING_FM_MARK))) {
        private enum enumMixinStr_ENCODING_FM_MARK = `enum ENCODING_FM_MARK = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_ENCODING_FM_MARK); }))) {
            mixin(enumMixinStr_ENCODING_FM_MARK);
        }
    }




    static if(!is(typeof(ENCODING_FM_SPACE))) {
        private enum enumMixinStr_ENCODING_FM_SPACE = `enum ENCODING_FM_SPACE = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_ENCODING_FM_SPACE); }))) {
            mixin(enumMixinStr_ENCODING_FM_SPACE);
        }
    }




    static if(!is(typeof(ENCODING_MANCHESTER))) {
        private enum enumMixinStr_ENCODING_MANCHESTER = `enum ENCODING_MANCHESTER = 5;`;
        static if(is(typeof({ mixin(enumMixinStr_ENCODING_MANCHESTER); }))) {
            mixin(enumMixinStr_ENCODING_MANCHESTER);
        }
    }




    static if(!is(typeof(PARITY_DEFAULT))) {
        private enum enumMixinStr_PARITY_DEFAULT = `enum PARITY_DEFAULT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_PARITY_DEFAULT); }))) {
            mixin(enumMixinStr_PARITY_DEFAULT);
        }
    }




    static if(!is(typeof(PARITY_NONE))) {
        private enum enumMixinStr_PARITY_NONE = `enum PARITY_NONE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_PARITY_NONE); }))) {
            mixin(enumMixinStr_PARITY_NONE);
        }
    }




    static if(!is(typeof(PARITY_CRC16_PR0))) {
        private enum enumMixinStr_PARITY_CRC16_PR0 = `enum PARITY_CRC16_PR0 = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_PARITY_CRC16_PR0); }))) {
            mixin(enumMixinStr_PARITY_CRC16_PR0);
        }
    }




    static if(!is(typeof(PARITY_CRC16_PR1))) {
        private enum enumMixinStr_PARITY_CRC16_PR1 = `enum PARITY_CRC16_PR1 = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_PARITY_CRC16_PR1); }))) {
            mixin(enumMixinStr_PARITY_CRC16_PR1);
        }
    }




    static if(!is(typeof(PARITY_CRC16_PR0_CCITT))) {
        private enum enumMixinStr_PARITY_CRC16_PR0_CCITT = `enum PARITY_CRC16_PR0_CCITT = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_PARITY_CRC16_PR0_CCITT); }))) {
            mixin(enumMixinStr_PARITY_CRC16_PR0_CCITT);
        }
    }




    static if(!is(typeof(PARITY_CRC16_PR1_CCITT))) {
        private enum enumMixinStr_PARITY_CRC16_PR1_CCITT = `enum PARITY_CRC16_PR1_CCITT = 5;`;
        static if(is(typeof({ mixin(enumMixinStr_PARITY_CRC16_PR1_CCITT); }))) {
            mixin(enumMixinStr_PARITY_CRC16_PR1_CCITT);
        }
    }




    static if(!is(typeof(PARITY_CRC32_PR0_CCITT))) {
        private enum enumMixinStr_PARITY_CRC32_PR0_CCITT = `enum PARITY_CRC32_PR0_CCITT = 6;`;
        static if(is(typeof({ mixin(enumMixinStr_PARITY_CRC32_PR0_CCITT); }))) {
            mixin(enumMixinStr_PARITY_CRC32_PR0_CCITT);
        }
    }




    static if(!is(typeof(PARITY_CRC32_PR1_CCITT))) {
        private enum enumMixinStr_PARITY_CRC32_PR1_CCITT = `enum PARITY_CRC32_PR1_CCITT = 7;`;
        static if(is(typeof({ mixin(enumMixinStr_PARITY_CRC32_PR1_CCITT); }))) {
            mixin(enumMixinStr_PARITY_CRC32_PR1_CCITT);
        }
    }




    static if(!is(typeof(LMI_DEFAULT))) {
        private enum enumMixinStr_LMI_DEFAULT = `enum LMI_DEFAULT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_LMI_DEFAULT); }))) {
            mixin(enumMixinStr_LMI_DEFAULT);
        }
    }




    static if(!is(typeof(LMI_NONE))) {
        private enum enumMixinStr_LMI_NONE = `enum LMI_NONE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_LMI_NONE); }))) {
            mixin(enumMixinStr_LMI_NONE);
        }
    }




    static if(!is(typeof(LMI_ANSI))) {
        private enum enumMixinStr_LMI_ANSI = `enum LMI_ANSI = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_LMI_ANSI); }))) {
            mixin(enumMixinStr_LMI_ANSI);
        }
    }




    static if(!is(typeof(LMI_CCITT))) {
        private enum enumMixinStr_LMI_CCITT = `enum LMI_CCITT = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_LMI_CCITT); }))) {
            mixin(enumMixinStr_LMI_CCITT);
        }
    }




    static if(!is(typeof(LMI_CISCO))) {
        private enum enumMixinStr_LMI_CISCO = `enum LMI_CISCO = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_LMI_CISCO); }))) {
            mixin(enumMixinStr_LMI_CISCO);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFFBIG_LDFLAGS = `enum _CS_XBS5_ILP32_OFFBIG_LDFLAGS = _CS_XBS5_ILP32_OFFBIG_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFFBIG_CFLAGS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFFBIG_CFLAGS = `enum _CS_XBS5_ILP32_OFFBIG_CFLAGS = _CS_XBS5_ILP32_OFFBIG_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFF32_LINTFLAGS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFF32_LINTFLAGS = `enum _CS_XBS5_ILP32_OFF32_LINTFLAGS = _CS_XBS5_ILP32_OFF32_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFF32_LIBS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFF32_LIBS = `enum _CS_XBS5_ILP32_OFF32_LIBS = _CS_XBS5_ILP32_OFF32_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_LIBS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_LIBS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFF32_LDFLAGS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFF32_LDFLAGS = `enum _CS_XBS5_ILP32_OFF32_LDFLAGS = _CS_XBS5_ILP32_OFF32_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFF32_CFLAGS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFF32_CFLAGS = `enum _CS_XBS5_ILP32_OFF32_CFLAGS = _CS_XBS5_ILP32_OFF32_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_CFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_LFS64_LINTFLAGS))) {
        private enum enumMixinStr__CS_LFS64_LINTFLAGS = `enum _CS_LFS64_LINTFLAGS = _CS_LFS64_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS64_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_LFS64_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_LFS64_LIBS))) {
        private enum enumMixinStr__CS_LFS64_LIBS = `enum _CS_LFS64_LIBS = _CS_LFS64_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS64_LIBS); }))) {
            mixin(enumMixinStr__CS_LFS64_LIBS);
        }
    }




    static if(!is(typeof(_CS_LFS64_LDFLAGS))) {
        private enum enumMixinStr__CS_LFS64_LDFLAGS = `enum _CS_LFS64_LDFLAGS = _CS_LFS64_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS64_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_LFS64_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_LFS64_CFLAGS))) {
        private enum enumMixinStr__CS_LFS64_CFLAGS = `enum _CS_LFS64_CFLAGS = _CS_LFS64_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS64_CFLAGS); }))) {
            mixin(enumMixinStr__CS_LFS64_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_LFS_LINTFLAGS))) {
        private enum enumMixinStr__CS_LFS_LINTFLAGS = `enum _CS_LFS_LINTFLAGS = _CS_LFS_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_LFS_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_LFS_LIBS))) {
        private enum enumMixinStr__CS_LFS_LIBS = `enum _CS_LFS_LIBS = _CS_LFS_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS_LIBS); }))) {
            mixin(enumMixinStr__CS_LFS_LIBS);
        }
    }




    static if(!is(typeof(_CS_LFS_LDFLAGS))) {
        private enum enumMixinStr__CS_LFS_LDFLAGS = `enum _CS_LFS_LDFLAGS = _CS_LFS_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_LFS_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_LFS_CFLAGS))) {
        private enum enumMixinStr__CS_LFS_CFLAGS = `enum _CS_LFS_CFLAGS = _CS_LFS_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS_CFLAGS); }))) {
            mixin(enumMixinStr__CS_LFS_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_WIDTH_RESTRICTED_ENVS))) {
        private enum enumMixinStr__CS_POSIX_V7_WIDTH_RESTRICTED_ENVS = `enum _CS_POSIX_V7_WIDTH_RESTRICTED_ENVS = _CS_V7_WIDTH_RESTRICTED_ENVS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_WIDTH_RESTRICTED_ENVS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_WIDTH_RESTRICTED_ENVS);
        }
    }




    static if(!is(typeof(_CS_V7_WIDTH_RESTRICTED_ENVS))) {
        private enum enumMixinStr__CS_V7_WIDTH_RESTRICTED_ENVS = `enum _CS_V7_WIDTH_RESTRICTED_ENVS = _CS_V7_WIDTH_RESTRICTED_ENVS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_V7_WIDTH_RESTRICTED_ENVS); }))) {
            mixin(enumMixinStr__CS_V7_WIDTH_RESTRICTED_ENVS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V5_WIDTH_RESTRICTED_ENVS))) {
        private enum enumMixinStr__CS_POSIX_V5_WIDTH_RESTRICTED_ENVS = `enum _CS_POSIX_V5_WIDTH_RESTRICTED_ENVS = _CS_V5_WIDTH_RESTRICTED_ENVS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V5_WIDTH_RESTRICTED_ENVS); }))) {
            mixin(enumMixinStr__CS_POSIX_V5_WIDTH_RESTRICTED_ENVS);
        }
    }






    static if(!is(typeof(_CS_V5_WIDTH_RESTRICTED_ENVS))) {
        private enum enumMixinStr__CS_V5_WIDTH_RESTRICTED_ENVS = `enum _CS_V5_WIDTH_RESTRICTED_ENVS = _CS_V5_WIDTH_RESTRICTED_ENVS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_V5_WIDTH_RESTRICTED_ENVS); }))) {
            mixin(enumMixinStr__CS_V5_WIDTH_RESTRICTED_ENVS);
        }
    }




    static if(!is(typeof(_CS_GNU_LIBPTHREAD_VERSION))) {
        private enum enumMixinStr__CS_GNU_LIBPTHREAD_VERSION = `enum _CS_GNU_LIBPTHREAD_VERSION = _CS_GNU_LIBPTHREAD_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_GNU_LIBPTHREAD_VERSION); }))) {
            mixin(enumMixinStr__CS_GNU_LIBPTHREAD_VERSION);
        }
    }




    static if(!is(typeof(_CS_GNU_LIBC_VERSION))) {
        private enum enumMixinStr__CS_GNU_LIBC_VERSION = `enum _CS_GNU_LIBC_VERSION = _CS_GNU_LIBC_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_GNU_LIBC_VERSION); }))) {
            mixin(enumMixinStr__CS_GNU_LIBC_VERSION);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_WIDTH_RESTRICTED_ENVS))) {
        private enum enumMixinStr__CS_POSIX_V6_WIDTH_RESTRICTED_ENVS = `enum _CS_POSIX_V6_WIDTH_RESTRICTED_ENVS = _CS_V6_WIDTH_RESTRICTED_ENVS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_WIDTH_RESTRICTED_ENVS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_WIDTH_RESTRICTED_ENVS);
        }
    }




    static if(!is(typeof(_CS_V6_WIDTH_RESTRICTED_ENVS))) {
        private enum enumMixinStr__CS_V6_WIDTH_RESTRICTED_ENVS = `enum _CS_V6_WIDTH_RESTRICTED_ENVS = _CS_V6_WIDTH_RESTRICTED_ENVS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_V6_WIDTH_RESTRICTED_ENVS); }))) {
            mixin(enumMixinStr__CS_V6_WIDTH_RESTRICTED_ENVS);
        }
    }




    static if(!is(typeof(IFNAMSIZ))) {
        private enum enumMixinStr_IFNAMSIZ = `enum IFNAMSIZ = 16;`;
        static if(is(typeof({ mixin(enumMixinStr_IFNAMSIZ); }))) {
            mixin(enumMixinStr_IFNAMSIZ);
        }
    }




    static if(!is(typeof(IFALIASZ))) {
        private enum enumMixinStr_IFALIASZ = `enum IFALIASZ = 256;`;
        static if(is(typeof({ mixin(enumMixinStr_IFALIASZ); }))) {
            mixin(enumMixinStr_IFALIASZ);
        }
    }




    static if(!is(typeof(ALTIFNAMSIZ))) {
        private enum enumMixinStr_ALTIFNAMSIZ = `enum ALTIFNAMSIZ = 128;`;
        static if(is(typeof({ mixin(enumMixinStr_ALTIFNAMSIZ); }))) {
            mixin(enumMixinStr_ALTIFNAMSIZ);
        }
    }




    static if(!is(typeof(_CS_PATH))) {
        private enum enumMixinStr__CS_PATH = `enum _CS_PATH = _CS_PATH;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_PATH); }))) {
            mixin(enumMixinStr__CS_PATH);
        }
    }




    static if(!is(typeof(_SC_SIGSTKSZ))) {
        private enum enumMixinStr__SC_SIGSTKSZ = `enum _SC_SIGSTKSZ = _SC_SIGSTKSZ;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SIGSTKSZ); }))) {
            mixin(enumMixinStr__SC_SIGSTKSZ);
        }
    }




    static if(!is(typeof(_SC_MINSIGSTKSZ))) {
        private enum enumMixinStr__SC_MINSIGSTKSZ = `enum _SC_MINSIGSTKSZ = _SC_MINSIGSTKSZ;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MINSIGSTKSZ); }))) {
            mixin(enumMixinStr__SC_MINSIGSTKSZ);
        }
    }




    static if(!is(typeof(_SC_THREAD_ROBUST_PRIO_PROTECT))) {
        private enum enumMixinStr__SC_THREAD_ROBUST_PRIO_PROTECT = `enum _SC_THREAD_ROBUST_PRIO_PROTECT = _SC_THREAD_ROBUST_PRIO_PROTECT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_ROBUST_PRIO_PROTECT); }))) {
            mixin(enumMixinStr__SC_THREAD_ROBUST_PRIO_PROTECT);
        }
    }




    static if(!is(typeof(_SC_THREAD_ROBUST_PRIO_INHERIT))) {
        private enum enumMixinStr__SC_THREAD_ROBUST_PRIO_INHERIT = `enum _SC_THREAD_ROBUST_PRIO_INHERIT = _SC_THREAD_ROBUST_PRIO_INHERIT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_ROBUST_PRIO_INHERIT); }))) {
            mixin(enumMixinStr__SC_THREAD_ROBUST_PRIO_INHERIT);
        }
    }




    static if(!is(typeof(_SC_XOPEN_STREAMS))) {
        private enum enumMixinStr__SC_XOPEN_STREAMS = `enum _SC_XOPEN_STREAMS = _SC_XOPEN_STREAMS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_STREAMS); }))) {
            mixin(enumMixinStr__SC_XOPEN_STREAMS);
        }
    }




    static if(!is(typeof(_SC_TRACE_USER_EVENT_MAX))) {
        private enum enumMixinStr__SC_TRACE_USER_EVENT_MAX = `enum _SC_TRACE_USER_EVENT_MAX = _SC_TRACE_USER_EVENT_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_USER_EVENT_MAX); }))) {
            mixin(enumMixinStr__SC_TRACE_USER_EVENT_MAX);
        }
    }




    static if(!is(typeof(IFF_UP))) {
        private enum enumMixinStr_IFF_UP = `enum IFF_UP = IFF_UP;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_UP); }))) {
            mixin(enumMixinStr_IFF_UP);
        }
    }




    static if(!is(typeof(IFF_BROADCAST))) {
        private enum enumMixinStr_IFF_BROADCAST = `enum IFF_BROADCAST = IFF_BROADCAST;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_BROADCAST); }))) {
            mixin(enumMixinStr_IFF_BROADCAST);
        }
    }




    static if(!is(typeof(IFF_DEBUG))) {
        private enum enumMixinStr_IFF_DEBUG = `enum IFF_DEBUG = IFF_DEBUG;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_DEBUG); }))) {
            mixin(enumMixinStr_IFF_DEBUG);
        }
    }




    static if(!is(typeof(IFF_LOOPBACK))) {
        private enum enumMixinStr_IFF_LOOPBACK = `enum IFF_LOOPBACK = IFF_LOOPBACK;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_LOOPBACK); }))) {
            mixin(enumMixinStr_IFF_LOOPBACK);
        }
    }




    static if(!is(typeof(IFF_POINTOPOINT))) {
        private enum enumMixinStr_IFF_POINTOPOINT = `enum IFF_POINTOPOINT = IFF_POINTOPOINT;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_POINTOPOINT); }))) {
            mixin(enumMixinStr_IFF_POINTOPOINT);
        }
    }




    static if(!is(typeof(IFF_NOTRAILERS))) {
        private enum enumMixinStr_IFF_NOTRAILERS = `enum IFF_NOTRAILERS = IFF_NOTRAILERS;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_NOTRAILERS); }))) {
            mixin(enumMixinStr_IFF_NOTRAILERS);
        }
    }




    static if(!is(typeof(IFF_RUNNING))) {
        private enum enumMixinStr_IFF_RUNNING = `enum IFF_RUNNING = IFF_RUNNING;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_RUNNING); }))) {
            mixin(enumMixinStr_IFF_RUNNING);
        }
    }




    static if(!is(typeof(IFF_NOARP))) {
        private enum enumMixinStr_IFF_NOARP = `enum IFF_NOARP = IFF_NOARP;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_NOARP); }))) {
            mixin(enumMixinStr_IFF_NOARP);
        }
    }




    static if(!is(typeof(IFF_PROMISC))) {
        private enum enumMixinStr_IFF_PROMISC = `enum IFF_PROMISC = IFF_PROMISC;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_PROMISC); }))) {
            mixin(enumMixinStr_IFF_PROMISC);
        }
    }




    static if(!is(typeof(IFF_ALLMULTI))) {
        private enum enumMixinStr_IFF_ALLMULTI = `enum IFF_ALLMULTI = IFF_ALLMULTI;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_ALLMULTI); }))) {
            mixin(enumMixinStr_IFF_ALLMULTI);
        }
    }




    static if(!is(typeof(IFF_MASTER))) {
        private enum enumMixinStr_IFF_MASTER = `enum IFF_MASTER = IFF_MASTER;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_MASTER); }))) {
            mixin(enumMixinStr_IFF_MASTER);
        }
    }




    static if(!is(typeof(IFF_SLAVE))) {
        private enum enumMixinStr_IFF_SLAVE = `enum IFF_SLAVE = IFF_SLAVE;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_SLAVE); }))) {
            mixin(enumMixinStr_IFF_SLAVE);
        }
    }




    static if(!is(typeof(IFF_MULTICAST))) {
        private enum enumMixinStr_IFF_MULTICAST = `enum IFF_MULTICAST = IFF_MULTICAST;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_MULTICAST); }))) {
            mixin(enumMixinStr_IFF_MULTICAST);
        }
    }




    static if(!is(typeof(IFF_PORTSEL))) {
        private enum enumMixinStr_IFF_PORTSEL = `enum IFF_PORTSEL = IFF_PORTSEL;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_PORTSEL); }))) {
            mixin(enumMixinStr_IFF_PORTSEL);
        }
    }




    static if(!is(typeof(IFF_AUTOMEDIA))) {
        private enum enumMixinStr_IFF_AUTOMEDIA = `enum IFF_AUTOMEDIA = IFF_AUTOMEDIA;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_AUTOMEDIA); }))) {
            mixin(enumMixinStr_IFF_AUTOMEDIA);
        }
    }




    static if(!is(typeof(IFF_DYNAMIC))) {
        private enum enumMixinStr_IFF_DYNAMIC = `enum IFF_DYNAMIC = IFF_DYNAMIC;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_DYNAMIC); }))) {
            mixin(enumMixinStr_IFF_DYNAMIC);
        }
    }




    static if(!is(typeof(_SC_TRACE_SYS_MAX))) {
        private enum enumMixinStr__SC_TRACE_SYS_MAX = `enum _SC_TRACE_SYS_MAX = _SC_TRACE_SYS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_SYS_MAX); }))) {
            mixin(enumMixinStr__SC_TRACE_SYS_MAX);
        }
    }




    static if(!is(typeof(IFF_LOWER_UP))) {
        private enum enumMixinStr_IFF_LOWER_UP = `enum IFF_LOWER_UP = IFF_LOWER_UP;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_LOWER_UP); }))) {
            mixin(enumMixinStr_IFF_LOWER_UP);
        }
    }




    static if(!is(typeof(IFF_DORMANT))) {
        private enum enumMixinStr_IFF_DORMANT = `enum IFF_DORMANT = IFF_DORMANT;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_DORMANT); }))) {
            mixin(enumMixinStr_IFF_DORMANT);
        }
    }




    static if(!is(typeof(IFF_ECHO))) {
        private enum enumMixinStr_IFF_ECHO = `enum IFF_ECHO = IFF_ECHO;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_ECHO); }))) {
            mixin(enumMixinStr_IFF_ECHO);
        }
    }




    static if(!is(typeof(IFF_VOLATILE))) {
        private enum enumMixinStr_IFF_VOLATILE = `enum IFF_VOLATILE = ( IFF_LOOPBACK | IFF_POINTOPOINT | IFF_BROADCAST | IFF_ECHO | IFF_MASTER | IFF_SLAVE | IFF_RUNNING | IFF_LOWER_UP | IFF_DORMANT );`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_VOLATILE); }))) {
            mixin(enumMixinStr_IFF_VOLATILE);
        }
    }




    static if(!is(typeof(IF_GET_IFACE))) {
        private enum enumMixinStr_IF_GET_IFACE = `enum IF_GET_IFACE = 0x0001;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_GET_IFACE); }))) {
            mixin(enumMixinStr_IF_GET_IFACE);
        }
    }




    static if(!is(typeof(IF_GET_PROTO))) {
        private enum enumMixinStr_IF_GET_PROTO = `enum IF_GET_PROTO = 0x0002;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_GET_PROTO); }))) {
            mixin(enumMixinStr_IF_GET_PROTO);
        }
    }




    static if(!is(typeof(IF_IFACE_V35))) {
        private enum enumMixinStr_IF_IFACE_V35 = `enum IF_IFACE_V35 = 0x1000;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_IFACE_V35); }))) {
            mixin(enumMixinStr_IF_IFACE_V35);
        }
    }




    static if(!is(typeof(IF_IFACE_V24))) {
        private enum enumMixinStr_IF_IFACE_V24 = `enum IF_IFACE_V24 = 0x1001;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_IFACE_V24); }))) {
            mixin(enumMixinStr_IF_IFACE_V24);
        }
    }




    static if(!is(typeof(IF_IFACE_X21))) {
        private enum enumMixinStr_IF_IFACE_X21 = `enum IF_IFACE_X21 = 0x1002;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_IFACE_X21); }))) {
            mixin(enumMixinStr_IF_IFACE_X21);
        }
    }




    static if(!is(typeof(IF_IFACE_T1))) {
        private enum enumMixinStr_IF_IFACE_T1 = `enum IF_IFACE_T1 = 0x1003;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_IFACE_T1); }))) {
            mixin(enumMixinStr_IF_IFACE_T1);
        }
    }




    static if(!is(typeof(IF_IFACE_E1))) {
        private enum enumMixinStr_IF_IFACE_E1 = `enum IF_IFACE_E1 = 0x1004;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_IFACE_E1); }))) {
            mixin(enumMixinStr_IF_IFACE_E1);
        }
    }




    static if(!is(typeof(IF_IFACE_SYNC_SERIAL))) {
        private enum enumMixinStr_IF_IFACE_SYNC_SERIAL = `enum IF_IFACE_SYNC_SERIAL = 0x1005;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_IFACE_SYNC_SERIAL); }))) {
            mixin(enumMixinStr_IF_IFACE_SYNC_SERIAL);
        }
    }




    static if(!is(typeof(IF_IFACE_X21D))) {
        private enum enumMixinStr_IF_IFACE_X21D = `enum IF_IFACE_X21D = 0x1006;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_IFACE_X21D); }))) {
            mixin(enumMixinStr_IF_IFACE_X21D);
        }
    }




    static if(!is(typeof(IF_PROTO_HDLC))) {
        private enum enumMixinStr_IF_PROTO_HDLC = `enum IF_PROTO_HDLC = 0x2000;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_HDLC); }))) {
            mixin(enumMixinStr_IF_PROTO_HDLC);
        }
    }




    static if(!is(typeof(IF_PROTO_PPP))) {
        private enum enumMixinStr_IF_PROTO_PPP = `enum IF_PROTO_PPP = 0x2001;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_PPP); }))) {
            mixin(enumMixinStr_IF_PROTO_PPP);
        }
    }




    static if(!is(typeof(IF_PROTO_CISCO))) {
        private enum enumMixinStr_IF_PROTO_CISCO = `enum IF_PROTO_CISCO = 0x2002;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_CISCO); }))) {
            mixin(enumMixinStr_IF_PROTO_CISCO);
        }
    }




    static if(!is(typeof(IF_PROTO_FR))) {
        private enum enumMixinStr_IF_PROTO_FR = `enum IF_PROTO_FR = 0x2003;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_FR); }))) {
            mixin(enumMixinStr_IF_PROTO_FR);
        }
    }




    static if(!is(typeof(IF_PROTO_FR_ADD_PVC))) {
        private enum enumMixinStr_IF_PROTO_FR_ADD_PVC = `enum IF_PROTO_FR_ADD_PVC = 0x2004;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_FR_ADD_PVC); }))) {
            mixin(enumMixinStr_IF_PROTO_FR_ADD_PVC);
        }
    }




    static if(!is(typeof(IF_PROTO_FR_DEL_PVC))) {
        private enum enumMixinStr_IF_PROTO_FR_DEL_PVC = `enum IF_PROTO_FR_DEL_PVC = 0x2005;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_FR_DEL_PVC); }))) {
            mixin(enumMixinStr_IF_PROTO_FR_DEL_PVC);
        }
    }




    static if(!is(typeof(IF_PROTO_X25))) {
        private enum enumMixinStr_IF_PROTO_X25 = `enum IF_PROTO_X25 = 0x2006;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_X25); }))) {
            mixin(enumMixinStr_IF_PROTO_X25);
        }
    }




    static if(!is(typeof(IF_PROTO_HDLC_ETH))) {
        private enum enumMixinStr_IF_PROTO_HDLC_ETH = `enum IF_PROTO_HDLC_ETH = 0x2007;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_HDLC_ETH); }))) {
            mixin(enumMixinStr_IF_PROTO_HDLC_ETH);
        }
    }




    static if(!is(typeof(IF_PROTO_FR_ADD_ETH_PVC))) {
        private enum enumMixinStr_IF_PROTO_FR_ADD_ETH_PVC = `enum IF_PROTO_FR_ADD_ETH_PVC = 0x2008;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_FR_ADD_ETH_PVC); }))) {
            mixin(enumMixinStr_IF_PROTO_FR_ADD_ETH_PVC);
        }
    }




    static if(!is(typeof(IF_PROTO_FR_DEL_ETH_PVC))) {
        private enum enumMixinStr_IF_PROTO_FR_DEL_ETH_PVC = `enum IF_PROTO_FR_DEL_ETH_PVC = 0x2009;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_FR_DEL_ETH_PVC); }))) {
            mixin(enumMixinStr_IF_PROTO_FR_DEL_ETH_PVC);
        }
    }




    static if(!is(typeof(IF_PROTO_FR_PVC))) {
        private enum enumMixinStr_IF_PROTO_FR_PVC = `enum IF_PROTO_FR_PVC = 0x200A;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_FR_PVC); }))) {
            mixin(enumMixinStr_IF_PROTO_FR_PVC);
        }
    }




    static if(!is(typeof(IF_PROTO_FR_ETH_PVC))) {
        private enum enumMixinStr_IF_PROTO_FR_ETH_PVC = `enum IF_PROTO_FR_ETH_PVC = 0x200B;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_FR_ETH_PVC); }))) {
            mixin(enumMixinStr_IF_PROTO_FR_ETH_PVC);
        }
    }




    static if(!is(typeof(IF_PROTO_RAW))) {
        private enum enumMixinStr_IF_PROTO_RAW = `enum IF_PROTO_RAW = 0x200C;`;
        static if(is(typeof({ mixin(enumMixinStr_IF_PROTO_RAW); }))) {
            mixin(enumMixinStr_IF_PROTO_RAW);
        }
    }




    static if(!is(typeof(_SC_TRACE_NAME_MAX))) {
        private enum enumMixinStr__SC_TRACE_NAME_MAX = `enum _SC_TRACE_NAME_MAX = _SC_TRACE_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_NAME_MAX); }))) {
            mixin(enumMixinStr__SC_TRACE_NAME_MAX);
        }
    }




    static if(!is(typeof(_SC_TRACE_EVENT_NAME_MAX))) {
        private enum enumMixinStr__SC_TRACE_EVENT_NAME_MAX = `enum _SC_TRACE_EVENT_NAME_MAX = _SC_TRACE_EVENT_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_EVENT_NAME_MAX); }))) {
            mixin(enumMixinStr__SC_TRACE_EVENT_NAME_MAX);
        }
    }




    static if(!is(typeof(_SC_SS_REPL_MAX))) {
        private enum enumMixinStr__SC_SS_REPL_MAX = `enum _SC_SS_REPL_MAX = _SC_SS_REPL_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SS_REPL_MAX); }))) {
            mixin(enumMixinStr__SC_SS_REPL_MAX);
        }
    }




    static if(!is(typeof(_SC_V7_LPBIG_OFFBIG))) {
        private enum enumMixinStr__SC_V7_LPBIG_OFFBIG = `enum _SC_V7_LPBIG_OFFBIG = _SC_V7_LPBIG_OFFBIG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V7_LPBIG_OFFBIG); }))) {
            mixin(enumMixinStr__SC_V7_LPBIG_OFFBIG);
        }
    }




    static if(!is(typeof(_SC_V7_LP64_OFF64))) {
        private enum enumMixinStr__SC_V7_LP64_OFF64 = `enum _SC_V7_LP64_OFF64 = _SC_V7_LP64_OFF64;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V7_LP64_OFF64); }))) {
            mixin(enumMixinStr__SC_V7_LP64_OFF64);
        }
    }




    static if(!is(typeof(_SC_V7_ILP32_OFFBIG))) {
        private enum enumMixinStr__SC_V7_ILP32_OFFBIG = `enum _SC_V7_ILP32_OFFBIG = _SC_V7_ILP32_OFFBIG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V7_ILP32_OFFBIG); }))) {
            mixin(enumMixinStr__SC_V7_ILP32_OFFBIG);
        }
    }




    static if(!is(typeof(_SC_V7_ILP32_OFF32))) {
        private enum enumMixinStr__SC_V7_ILP32_OFF32 = `enum _SC_V7_ILP32_OFF32 = _SC_V7_ILP32_OFF32;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V7_ILP32_OFF32); }))) {
            mixin(enumMixinStr__SC_V7_ILP32_OFF32);
        }
    }




    static if(!is(typeof(IFHWADDRLEN))) {
        private enum enumMixinStr_IFHWADDRLEN = `enum IFHWADDRLEN = 6;`;
        static if(is(typeof({ mixin(enumMixinStr_IFHWADDRLEN); }))) {
            mixin(enumMixinStr_IFHWADDRLEN);
        }
    }




    static if(!is(typeof(_SC_RAW_SOCKETS))) {
        private enum enumMixinStr__SC_RAW_SOCKETS = `enum _SC_RAW_SOCKETS = _SC_RAW_SOCKETS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_RAW_SOCKETS); }))) {
            mixin(enumMixinStr__SC_RAW_SOCKETS);
        }
    }




    static if(!is(typeof(_SC_IPV6))) {
        private enum enumMixinStr__SC_IPV6 = `enum _SC_IPV6 = _SC_IPV6;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_IPV6); }))) {
            mixin(enumMixinStr__SC_IPV6);
        }
    }




    static if(!is(typeof(_SC_LEVEL4_CACHE_LINESIZE))) {
        private enum enumMixinStr__SC_LEVEL4_CACHE_LINESIZE = `enum _SC_LEVEL4_CACHE_LINESIZE = _SC_LEVEL4_CACHE_LINESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL4_CACHE_LINESIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL4_CACHE_LINESIZE);
        }
    }




    static if(!is(typeof(ifr_name))) {
        private enum enumMixinStr_ifr_name = `enum ifr_name = ifr_ifrn . ifrn_name;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_name); }))) {
            mixin(enumMixinStr_ifr_name);
        }
    }




    static if(!is(typeof(ifr_hwaddr))) {
        private enum enumMixinStr_ifr_hwaddr = `enum ifr_hwaddr = ifr_ifru . ifru_hwaddr;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_hwaddr); }))) {
            mixin(enumMixinStr_ifr_hwaddr);
        }
    }




    static if(!is(typeof(ifr_addr))) {
        private enum enumMixinStr_ifr_addr = `enum ifr_addr = ifr_ifru . ifru_addr;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_addr); }))) {
            mixin(enumMixinStr_ifr_addr);
        }
    }




    static if(!is(typeof(ifr_dstaddr))) {
        private enum enumMixinStr_ifr_dstaddr = `enum ifr_dstaddr = ifr_ifru . ifru_dstaddr;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_dstaddr); }))) {
            mixin(enumMixinStr_ifr_dstaddr);
        }
    }




    static if(!is(typeof(ifr_broadaddr))) {
        private enum enumMixinStr_ifr_broadaddr = `enum ifr_broadaddr = ifr_ifru . ifru_broadaddr;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_broadaddr); }))) {
            mixin(enumMixinStr_ifr_broadaddr);
        }
    }




    static if(!is(typeof(ifr_netmask))) {
        private enum enumMixinStr_ifr_netmask = `enum ifr_netmask = ifr_ifru . ifru_netmask;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_netmask); }))) {
            mixin(enumMixinStr_ifr_netmask);
        }
    }




    static if(!is(typeof(ifr_flags))) {
        private enum enumMixinStr_ifr_flags = `enum ifr_flags = ifr_ifru . ifru_flags;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_flags); }))) {
            mixin(enumMixinStr_ifr_flags);
        }
    }




    static if(!is(typeof(ifr_metric))) {
        private enum enumMixinStr_ifr_metric = `enum ifr_metric = ifr_ifru . ifru_ivalue;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_metric); }))) {
            mixin(enumMixinStr_ifr_metric);
        }
    }




    static if(!is(typeof(ifr_mtu))) {
        private enum enumMixinStr_ifr_mtu = `enum ifr_mtu = ifr_ifru . ifru_mtu;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_mtu); }))) {
            mixin(enumMixinStr_ifr_mtu);
        }
    }




    static if(!is(typeof(ifr_map))) {
        private enum enumMixinStr_ifr_map = `enum ifr_map = ifr_ifru . ifru_map;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_map); }))) {
            mixin(enumMixinStr_ifr_map);
        }
    }




    static if(!is(typeof(ifr_slave))) {
        private enum enumMixinStr_ifr_slave = `enum ifr_slave = ifr_ifru . ifru_slave;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_slave); }))) {
            mixin(enumMixinStr_ifr_slave);
        }
    }




    static if(!is(typeof(ifr_data))) {
        private enum enumMixinStr_ifr_data = `enum ifr_data = ifr_ifru . ifru_data;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_data); }))) {
            mixin(enumMixinStr_ifr_data);
        }
    }




    static if(!is(typeof(ifr_ifindex))) {
        private enum enumMixinStr_ifr_ifindex = `enum ifr_ifindex = ifr_ifru . ifru_ivalue;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_ifindex); }))) {
            mixin(enumMixinStr_ifr_ifindex);
        }
    }




    static if(!is(typeof(ifr_bandwidth))) {
        private enum enumMixinStr_ifr_bandwidth = `enum ifr_bandwidth = ifr_ifru . ifru_ivalue;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_bandwidth); }))) {
            mixin(enumMixinStr_ifr_bandwidth);
        }
    }




    static if(!is(typeof(ifr_qlen))) {
        private enum enumMixinStr_ifr_qlen = `enum ifr_qlen = ifr_ifru . ifru_ivalue;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_qlen); }))) {
            mixin(enumMixinStr_ifr_qlen);
        }
    }




    static if(!is(typeof(ifr_newname))) {
        private enum enumMixinStr_ifr_newname = `enum ifr_newname = ifr_ifru . ifru_newname;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_newname); }))) {
            mixin(enumMixinStr_ifr_newname);
        }
    }




    static if(!is(typeof(ifr_settings))) {
        private enum enumMixinStr_ifr_settings = `enum ifr_settings = ifr_ifru . ifru_settings;`;
        static if(is(typeof({ mixin(enumMixinStr_ifr_settings); }))) {
            mixin(enumMixinStr_ifr_settings);
        }
    }




    static if(!is(typeof(_SC_LEVEL4_CACHE_ASSOC))) {
        private enum enumMixinStr__SC_LEVEL4_CACHE_ASSOC = `enum _SC_LEVEL4_CACHE_ASSOC = _SC_LEVEL4_CACHE_ASSOC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL4_CACHE_ASSOC); }))) {
            mixin(enumMixinStr__SC_LEVEL4_CACHE_ASSOC);
        }
    }




    static if(!is(typeof(_SC_LEVEL4_CACHE_SIZE))) {
        private enum enumMixinStr__SC_LEVEL4_CACHE_SIZE = `enum _SC_LEVEL4_CACHE_SIZE = _SC_LEVEL4_CACHE_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL4_CACHE_SIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL4_CACHE_SIZE);
        }
    }




    static if(!is(typeof(ifc_buf))) {
        private enum enumMixinStr_ifc_buf = `enum ifc_buf = ifc_ifcu . ifcu_buf;`;
        static if(is(typeof({ mixin(enumMixinStr_ifc_buf); }))) {
            mixin(enumMixinStr_ifc_buf);
        }
    }




    static if(!is(typeof(ifc_req))) {
        private enum enumMixinStr_ifc_req = `enum ifc_req = ifc_ifcu . ifcu_req;`;
        static if(is(typeof({ mixin(enumMixinStr_ifc_req); }))) {
            mixin(enumMixinStr_ifc_req);
        }
    }






    static if(!is(typeof(_SC_LEVEL3_CACHE_LINESIZE))) {
        private enum enumMixinStr__SC_LEVEL3_CACHE_LINESIZE = `enum _SC_LEVEL3_CACHE_LINESIZE = _SC_LEVEL3_CACHE_LINESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL3_CACHE_LINESIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL3_CACHE_LINESIZE);
        }
    }




    static if(!is(typeof(ETH_ALEN))) {
        private enum enumMixinStr_ETH_ALEN = `enum ETH_ALEN = 6;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_ALEN); }))) {
            mixin(enumMixinStr_ETH_ALEN);
        }
    }




    static if(!is(typeof(ETH_TLEN))) {
        private enum enumMixinStr_ETH_TLEN = `enum ETH_TLEN = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_TLEN); }))) {
            mixin(enumMixinStr_ETH_TLEN);
        }
    }




    static if(!is(typeof(ETH_HLEN))) {
        private enum enumMixinStr_ETH_HLEN = `enum ETH_HLEN = 14;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_HLEN); }))) {
            mixin(enumMixinStr_ETH_HLEN);
        }
    }




    static if(!is(typeof(ETH_ZLEN))) {
        private enum enumMixinStr_ETH_ZLEN = `enum ETH_ZLEN = 60;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_ZLEN); }))) {
            mixin(enumMixinStr_ETH_ZLEN);
        }
    }




    static if(!is(typeof(ETH_DATA_LEN))) {
        private enum enumMixinStr_ETH_DATA_LEN = `enum ETH_DATA_LEN = 1500;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_DATA_LEN); }))) {
            mixin(enumMixinStr_ETH_DATA_LEN);
        }
    }




    static if(!is(typeof(ETH_FRAME_LEN))) {
        private enum enumMixinStr_ETH_FRAME_LEN = `enum ETH_FRAME_LEN = 1514;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_FRAME_LEN); }))) {
            mixin(enumMixinStr_ETH_FRAME_LEN);
        }
    }




    static if(!is(typeof(ETH_FCS_LEN))) {
        private enum enumMixinStr_ETH_FCS_LEN = `enum ETH_FCS_LEN = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_FCS_LEN); }))) {
            mixin(enumMixinStr_ETH_FCS_LEN);
        }
    }




    static if(!is(typeof(ETH_MIN_MTU))) {
        private enum enumMixinStr_ETH_MIN_MTU = `enum ETH_MIN_MTU = 68;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_MIN_MTU); }))) {
            mixin(enumMixinStr_ETH_MIN_MTU);
        }
    }




    static if(!is(typeof(ETH_MAX_MTU))) {
        private enum enumMixinStr_ETH_MAX_MTU = `enum ETH_MAX_MTU = 0xFFFFU;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_MAX_MTU); }))) {
            mixin(enumMixinStr_ETH_MAX_MTU);
        }
    }




    static if(!is(typeof(ETH_P_LOOP))) {
        private enum enumMixinStr_ETH_P_LOOP = `enum ETH_P_LOOP = 0x0060;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_LOOP); }))) {
            mixin(enumMixinStr_ETH_P_LOOP);
        }
    }




    static if(!is(typeof(ETH_P_PUP))) {
        private enum enumMixinStr_ETH_P_PUP = `enum ETH_P_PUP = 0x0200;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_PUP); }))) {
            mixin(enumMixinStr_ETH_P_PUP);
        }
    }




    static if(!is(typeof(ETH_P_PUPAT))) {
        private enum enumMixinStr_ETH_P_PUPAT = `enum ETH_P_PUPAT = 0x0201;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_PUPAT); }))) {
            mixin(enumMixinStr_ETH_P_PUPAT);
        }
    }




    static if(!is(typeof(ETH_P_TSN))) {
        private enum enumMixinStr_ETH_P_TSN = `enum ETH_P_TSN = 0x22F0;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_TSN); }))) {
            mixin(enumMixinStr_ETH_P_TSN);
        }
    }




    static if(!is(typeof(ETH_P_ERSPAN2))) {
        private enum enumMixinStr_ETH_P_ERSPAN2 = `enum ETH_P_ERSPAN2 = 0x22EB;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_ERSPAN2); }))) {
            mixin(enumMixinStr_ETH_P_ERSPAN2);
        }
    }




    static if(!is(typeof(ETH_P_IP))) {
        private enum enumMixinStr_ETH_P_IP = `enum ETH_P_IP = 0x0800;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_IP); }))) {
            mixin(enumMixinStr_ETH_P_IP);
        }
    }




    static if(!is(typeof(ETH_P_X25))) {
        private enum enumMixinStr_ETH_P_X25 = `enum ETH_P_X25 = 0x0805;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_X25); }))) {
            mixin(enumMixinStr_ETH_P_X25);
        }
    }




    static if(!is(typeof(ETH_P_ARP))) {
        private enum enumMixinStr_ETH_P_ARP = `enum ETH_P_ARP = 0x0806;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_ARP); }))) {
            mixin(enumMixinStr_ETH_P_ARP);
        }
    }




    static if(!is(typeof(ETH_P_BPQ))) {
        private enum enumMixinStr_ETH_P_BPQ = `enum ETH_P_BPQ = 0x08FF;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_BPQ); }))) {
            mixin(enumMixinStr_ETH_P_BPQ);
        }
    }




    static if(!is(typeof(ETH_P_IEEEPUP))) {
        private enum enumMixinStr_ETH_P_IEEEPUP = `enum ETH_P_IEEEPUP = 0x0a00;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_IEEEPUP); }))) {
            mixin(enumMixinStr_ETH_P_IEEEPUP);
        }
    }




    static if(!is(typeof(ETH_P_IEEEPUPAT))) {
        private enum enumMixinStr_ETH_P_IEEEPUPAT = `enum ETH_P_IEEEPUPAT = 0x0a01;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_IEEEPUPAT); }))) {
            mixin(enumMixinStr_ETH_P_IEEEPUPAT);
        }
    }




    static if(!is(typeof(ETH_P_BATMAN))) {
        private enum enumMixinStr_ETH_P_BATMAN = `enum ETH_P_BATMAN = 0x4305;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_BATMAN); }))) {
            mixin(enumMixinStr_ETH_P_BATMAN);
        }
    }




    static if(!is(typeof(ETH_P_DEC))) {
        private enum enumMixinStr_ETH_P_DEC = `enum ETH_P_DEC = 0x6000;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_DEC); }))) {
            mixin(enumMixinStr_ETH_P_DEC);
        }
    }




    static if(!is(typeof(ETH_P_DNA_DL))) {
        private enum enumMixinStr_ETH_P_DNA_DL = `enum ETH_P_DNA_DL = 0x6001;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_DNA_DL); }))) {
            mixin(enumMixinStr_ETH_P_DNA_DL);
        }
    }




    static if(!is(typeof(ETH_P_DNA_RC))) {
        private enum enumMixinStr_ETH_P_DNA_RC = `enum ETH_P_DNA_RC = 0x6002;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_DNA_RC); }))) {
            mixin(enumMixinStr_ETH_P_DNA_RC);
        }
    }




    static if(!is(typeof(ETH_P_DNA_RT))) {
        private enum enumMixinStr_ETH_P_DNA_RT = `enum ETH_P_DNA_RT = 0x6003;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_DNA_RT); }))) {
            mixin(enumMixinStr_ETH_P_DNA_RT);
        }
    }




    static if(!is(typeof(ETH_P_LAT))) {
        private enum enumMixinStr_ETH_P_LAT = `enum ETH_P_LAT = 0x6004;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_LAT); }))) {
            mixin(enumMixinStr_ETH_P_LAT);
        }
    }




    static if(!is(typeof(ETH_P_DIAG))) {
        private enum enumMixinStr_ETH_P_DIAG = `enum ETH_P_DIAG = 0x6005;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_DIAG); }))) {
            mixin(enumMixinStr_ETH_P_DIAG);
        }
    }




    static if(!is(typeof(ETH_P_CUST))) {
        private enum enumMixinStr_ETH_P_CUST = `enum ETH_P_CUST = 0x6006;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_CUST); }))) {
            mixin(enumMixinStr_ETH_P_CUST);
        }
    }




    static if(!is(typeof(ETH_P_SCA))) {
        private enum enumMixinStr_ETH_P_SCA = `enum ETH_P_SCA = 0x6007;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_SCA); }))) {
            mixin(enumMixinStr_ETH_P_SCA);
        }
    }




    static if(!is(typeof(ETH_P_TEB))) {
        private enum enumMixinStr_ETH_P_TEB = `enum ETH_P_TEB = 0x6558;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_TEB); }))) {
            mixin(enumMixinStr_ETH_P_TEB);
        }
    }




    static if(!is(typeof(ETH_P_RARP))) {
        private enum enumMixinStr_ETH_P_RARP = `enum ETH_P_RARP = 0x8035;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_RARP); }))) {
            mixin(enumMixinStr_ETH_P_RARP);
        }
    }




    static if(!is(typeof(ETH_P_ATALK))) {
        private enum enumMixinStr_ETH_P_ATALK = `enum ETH_P_ATALK = 0x809B;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_ATALK); }))) {
            mixin(enumMixinStr_ETH_P_ATALK);
        }
    }




    static if(!is(typeof(ETH_P_AARP))) {
        private enum enumMixinStr_ETH_P_AARP = `enum ETH_P_AARP = 0x80F3;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_AARP); }))) {
            mixin(enumMixinStr_ETH_P_AARP);
        }
    }




    static if(!is(typeof(ETH_P_8021Q))) {
        private enum enumMixinStr_ETH_P_8021Q = `enum ETH_P_8021Q = 0x8100;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_8021Q); }))) {
            mixin(enumMixinStr_ETH_P_8021Q);
        }
    }




    static if(!is(typeof(ETH_P_ERSPAN))) {
        private enum enumMixinStr_ETH_P_ERSPAN = `enum ETH_P_ERSPAN = 0x88BE;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_ERSPAN); }))) {
            mixin(enumMixinStr_ETH_P_ERSPAN);
        }
    }




    static if(!is(typeof(ETH_P_IPX))) {
        private enum enumMixinStr_ETH_P_IPX = `enum ETH_P_IPX = 0x8137;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_IPX); }))) {
            mixin(enumMixinStr_ETH_P_IPX);
        }
    }




    static if(!is(typeof(ETH_P_IPV6))) {
        private enum enumMixinStr_ETH_P_IPV6 = `enum ETH_P_IPV6 = 0x86DD;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_IPV6); }))) {
            mixin(enumMixinStr_ETH_P_IPV6);
        }
    }




    static if(!is(typeof(ETH_P_PAUSE))) {
        private enum enumMixinStr_ETH_P_PAUSE = `enum ETH_P_PAUSE = 0x8808;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_PAUSE); }))) {
            mixin(enumMixinStr_ETH_P_PAUSE);
        }
    }




    static if(!is(typeof(ETH_P_SLOW))) {
        private enum enumMixinStr_ETH_P_SLOW = `enum ETH_P_SLOW = 0x8809;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_SLOW); }))) {
            mixin(enumMixinStr_ETH_P_SLOW);
        }
    }




    static if(!is(typeof(ETH_P_WCCP))) {
        private enum enumMixinStr_ETH_P_WCCP = `enum ETH_P_WCCP = 0x883E;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_WCCP); }))) {
            mixin(enumMixinStr_ETH_P_WCCP);
        }
    }




    static if(!is(typeof(ETH_P_MPLS_UC))) {
        private enum enumMixinStr_ETH_P_MPLS_UC = `enum ETH_P_MPLS_UC = 0x8847;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_MPLS_UC); }))) {
            mixin(enumMixinStr_ETH_P_MPLS_UC);
        }
    }




    static if(!is(typeof(ETH_P_MPLS_MC))) {
        private enum enumMixinStr_ETH_P_MPLS_MC = `enum ETH_P_MPLS_MC = 0x8848;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_MPLS_MC); }))) {
            mixin(enumMixinStr_ETH_P_MPLS_MC);
        }
    }




    static if(!is(typeof(ETH_P_ATMMPOA))) {
        private enum enumMixinStr_ETH_P_ATMMPOA = `enum ETH_P_ATMMPOA = 0x884c;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_ATMMPOA); }))) {
            mixin(enumMixinStr_ETH_P_ATMMPOA);
        }
    }




    static if(!is(typeof(ETH_P_PPP_DISC))) {
        private enum enumMixinStr_ETH_P_PPP_DISC = `enum ETH_P_PPP_DISC = 0x8863;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_PPP_DISC); }))) {
            mixin(enumMixinStr_ETH_P_PPP_DISC);
        }
    }




    static if(!is(typeof(ETH_P_PPP_SES))) {
        private enum enumMixinStr_ETH_P_PPP_SES = `enum ETH_P_PPP_SES = 0x8864;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_PPP_SES); }))) {
            mixin(enumMixinStr_ETH_P_PPP_SES);
        }
    }




    static if(!is(typeof(ETH_P_LINK_CTL))) {
        private enum enumMixinStr_ETH_P_LINK_CTL = `enum ETH_P_LINK_CTL = 0x886c;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_LINK_CTL); }))) {
            mixin(enumMixinStr_ETH_P_LINK_CTL);
        }
    }




    static if(!is(typeof(ETH_P_ATMFATE))) {
        private enum enumMixinStr_ETH_P_ATMFATE = `enum ETH_P_ATMFATE = 0x8884;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_ATMFATE); }))) {
            mixin(enumMixinStr_ETH_P_ATMFATE);
        }
    }




    static if(!is(typeof(ETH_P_PAE))) {
        private enum enumMixinStr_ETH_P_PAE = `enum ETH_P_PAE = 0x888E;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_PAE); }))) {
            mixin(enumMixinStr_ETH_P_PAE);
        }
    }




    static if(!is(typeof(ETH_P_REALTEK))) {
        private enum enumMixinStr_ETH_P_REALTEK = `enum ETH_P_REALTEK = 0x8899;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_REALTEK); }))) {
            mixin(enumMixinStr_ETH_P_REALTEK);
        }
    }




    static if(!is(typeof(ETH_P_AOE))) {
        private enum enumMixinStr_ETH_P_AOE = `enum ETH_P_AOE = 0x88A2;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_AOE); }))) {
            mixin(enumMixinStr_ETH_P_AOE);
        }
    }




    static if(!is(typeof(ETH_P_8021AD))) {
        private enum enumMixinStr_ETH_P_8021AD = `enum ETH_P_8021AD = 0x88A8;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_8021AD); }))) {
            mixin(enumMixinStr_ETH_P_8021AD);
        }
    }




    static if(!is(typeof(ETH_P_802_EX1))) {
        private enum enumMixinStr_ETH_P_802_EX1 = `enum ETH_P_802_EX1 = 0x88B5;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_802_EX1); }))) {
            mixin(enumMixinStr_ETH_P_802_EX1);
        }
    }




    static if(!is(typeof(ETH_P_PREAUTH))) {
        private enum enumMixinStr_ETH_P_PREAUTH = `enum ETH_P_PREAUTH = 0x88C7;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_PREAUTH); }))) {
            mixin(enumMixinStr_ETH_P_PREAUTH);
        }
    }




    static if(!is(typeof(ETH_P_TIPC))) {
        private enum enumMixinStr_ETH_P_TIPC = `enum ETH_P_TIPC = 0x88CA;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_TIPC); }))) {
            mixin(enumMixinStr_ETH_P_TIPC);
        }
    }




    static if(!is(typeof(ETH_P_LLDP))) {
        private enum enumMixinStr_ETH_P_LLDP = `enum ETH_P_LLDP = 0x88CC;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_LLDP); }))) {
            mixin(enumMixinStr_ETH_P_LLDP);
        }
    }




    static if(!is(typeof(ETH_P_MRP))) {
        private enum enumMixinStr_ETH_P_MRP = `enum ETH_P_MRP = 0x88E3;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_MRP); }))) {
            mixin(enumMixinStr_ETH_P_MRP);
        }
    }




    static if(!is(typeof(ETH_P_MACSEC))) {
        private enum enumMixinStr_ETH_P_MACSEC = `enum ETH_P_MACSEC = 0x88E5;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_MACSEC); }))) {
            mixin(enumMixinStr_ETH_P_MACSEC);
        }
    }




    static if(!is(typeof(ETH_P_8021AH))) {
        private enum enumMixinStr_ETH_P_8021AH = `enum ETH_P_8021AH = 0x88E7;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_8021AH); }))) {
            mixin(enumMixinStr_ETH_P_8021AH);
        }
    }




    static if(!is(typeof(ETH_P_MVRP))) {
        private enum enumMixinStr_ETH_P_MVRP = `enum ETH_P_MVRP = 0x88F5;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_MVRP); }))) {
            mixin(enumMixinStr_ETH_P_MVRP);
        }
    }




    static if(!is(typeof(ETH_P_1588))) {
        private enum enumMixinStr_ETH_P_1588 = `enum ETH_P_1588 = 0x88F7;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_1588); }))) {
            mixin(enumMixinStr_ETH_P_1588);
        }
    }




    static if(!is(typeof(ETH_P_NCSI))) {
        private enum enumMixinStr_ETH_P_NCSI = `enum ETH_P_NCSI = 0x88F8;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_NCSI); }))) {
            mixin(enumMixinStr_ETH_P_NCSI);
        }
    }




    static if(!is(typeof(ETH_P_PRP))) {
        private enum enumMixinStr_ETH_P_PRP = `enum ETH_P_PRP = 0x88FB;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_PRP); }))) {
            mixin(enumMixinStr_ETH_P_PRP);
        }
    }




    static if(!is(typeof(ETH_P_CFM))) {
        private enum enumMixinStr_ETH_P_CFM = `enum ETH_P_CFM = 0x8902;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_CFM); }))) {
            mixin(enumMixinStr_ETH_P_CFM);
        }
    }




    static if(!is(typeof(ETH_P_FCOE))) {
        private enum enumMixinStr_ETH_P_FCOE = `enum ETH_P_FCOE = 0x8906;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_FCOE); }))) {
            mixin(enumMixinStr_ETH_P_FCOE);
        }
    }




    static if(!is(typeof(ETH_P_IBOE))) {
        private enum enumMixinStr_ETH_P_IBOE = `enum ETH_P_IBOE = 0x8915;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_IBOE); }))) {
            mixin(enumMixinStr_ETH_P_IBOE);
        }
    }




    static if(!is(typeof(ETH_P_TDLS))) {
        private enum enumMixinStr_ETH_P_TDLS = `enum ETH_P_TDLS = 0x890D;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_TDLS); }))) {
            mixin(enumMixinStr_ETH_P_TDLS);
        }
    }




    static if(!is(typeof(ETH_P_FIP))) {
        private enum enumMixinStr_ETH_P_FIP = `enum ETH_P_FIP = 0x8914;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_FIP); }))) {
            mixin(enumMixinStr_ETH_P_FIP);
        }
    }




    static if(!is(typeof(ETH_P_80221))) {
        private enum enumMixinStr_ETH_P_80221 = `enum ETH_P_80221 = 0x8917;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_80221); }))) {
            mixin(enumMixinStr_ETH_P_80221);
        }
    }




    static if(!is(typeof(ETH_P_HSR))) {
        private enum enumMixinStr_ETH_P_HSR = `enum ETH_P_HSR = 0x892F;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_HSR); }))) {
            mixin(enumMixinStr_ETH_P_HSR);
        }
    }




    static if(!is(typeof(ETH_P_NSH))) {
        private enum enumMixinStr_ETH_P_NSH = `enum ETH_P_NSH = 0x894F;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_NSH); }))) {
            mixin(enumMixinStr_ETH_P_NSH);
        }
    }




    static if(!is(typeof(ETH_P_LOOPBACK))) {
        private enum enumMixinStr_ETH_P_LOOPBACK = `enum ETH_P_LOOPBACK = 0x9000;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_LOOPBACK); }))) {
            mixin(enumMixinStr_ETH_P_LOOPBACK);
        }
    }




    static if(!is(typeof(ETH_P_QINQ1))) {
        private enum enumMixinStr_ETH_P_QINQ1 = `enum ETH_P_QINQ1 = 0x9100;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_QINQ1); }))) {
            mixin(enumMixinStr_ETH_P_QINQ1);
        }
    }




    static if(!is(typeof(ETH_P_QINQ2))) {
        private enum enumMixinStr_ETH_P_QINQ2 = `enum ETH_P_QINQ2 = 0x9200;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_QINQ2); }))) {
            mixin(enumMixinStr_ETH_P_QINQ2);
        }
    }




    static if(!is(typeof(ETH_P_QINQ3))) {
        private enum enumMixinStr_ETH_P_QINQ3 = `enum ETH_P_QINQ3 = 0x9300;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_QINQ3); }))) {
            mixin(enumMixinStr_ETH_P_QINQ3);
        }
    }




    static if(!is(typeof(ETH_P_EDSA))) {
        private enum enumMixinStr_ETH_P_EDSA = `enum ETH_P_EDSA = 0xDADA;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_EDSA); }))) {
            mixin(enumMixinStr_ETH_P_EDSA);
        }
    }




    static if(!is(typeof(ETH_P_DSA_8021Q))) {
        private enum enumMixinStr_ETH_P_DSA_8021Q = `enum ETH_P_DSA_8021Q = 0xDADB;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_DSA_8021Q); }))) {
            mixin(enumMixinStr_ETH_P_DSA_8021Q);
        }
    }




    static if(!is(typeof(ETH_P_IFE))) {
        private enum enumMixinStr_ETH_P_IFE = `enum ETH_P_IFE = 0xED3E;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_IFE); }))) {
            mixin(enumMixinStr_ETH_P_IFE);
        }
    }




    static if(!is(typeof(ETH_P_AF_IUCV))) {
        private enum enumMixinStr_ETH_P_AF_IUCV = `enum ETH_P_AF_IUCV = 0xFBFB;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_AF_IUCV); }))) {
            mixin(enumMixinStr_ETH_P_AF_IUCV);
        }
    }




    static if(!is(typeof(ETH_P_802_3_MIN))) {
        private enum enumMixinStr_ETH_P_802_3_MIN = `enum ETH_P_802_3_MIN = 0x0600;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_802_3_MIN); }))) {
            mixin(enumMixinStr_ETH_P_802_3_MIN);
        }
    }




    static if(!is(typeof(ETH_P_802_3))) {
        private enum enumMixinStr_ETH_P_802_3 = `enum ETH_P_802_3 = 0x0001;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_802_3); }))) {
            mixin(enumMixinStr_ETH_P_802_3);
        }
    }




    static if(!is(typeof(ETH_P_AX25))) {
        private enum enumMixinStr_ETH_P_AX25 = `enum ETH_P_AX25 = 0x0002;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_AX25); }))) {
            mixin(enumMixinStr_ETH_P_AX25);
        }
    }




    static if(!is(typeof(ETH_P_ALL))) {
        private enum enumMixinStr_ETH_P_ALL = `enum ETH_P_ALL = 0x0003;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_ALL); }))) {
            mixin(enumMixinStr_ETH_P_ALL);
        }
    }




    static if(!is(typeof(ETH_P_802_2))) {
        private enum enumMixinStr_ETH_P_802_2 = `enum ETH_P_802_2 = 0x0004;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_802_2); }))) {
            mixin(enumMixinStr_ETH_P_802_2);
        }
    }




    static if(!is(typeof(ETH_P_SNAP))) {
        private enum enumMixinStr_ETH_P_SNAP = `enum ETH_P_SNAP = 0x0005;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_SNAP); }))) {
            mixin(enumMixinStr_ETH_P_SNAP);
        }
    }




    static if(!is(typeof(ETH_P_DDCMP))) {
        private enum enumMixinStr_ETH_P_DDCMP = `enum ETH_P_DDCMP = 0x0006;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_DDCMP); }))) {
            mixin(enumMixinStr_ETH_P_DDCMP);
        }
    }




    static if(!is(typeof(ETH_P_WAN_PPP))) {
        private enum enumMixinStr_ETH_P_WAN_PPP = `enum ETH_P_WAN_PPP = 0x0007;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_WAN_PPP); }))) {
            mixin(enumMixinStr_ETH_P_WAN_PPP);
        }
    }




    static if(!is(typeof(ETH_P_PPP_MP))) {
        private enum enumMixinStr_ETH_P_PPP_MP = `enum ETH_P_PPP_MP = 0x0008;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_PPP_MP); }))) {
            mixin(enumMixinStr_ETH_P_PPP_MP);
        }
    }




    static if(!is(typeof(ETH_P_LOCALTALK))) {
        private enum enumMixinStr_ETH_P_LOCALTALK = `enum ETH_P_LOCALTALK = 0x0009;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_LOCALTALK); }))) {
            mixin(enumMixinStr_ETH_P_LOCALTALK);
        }
    }




    static if(!is(typeof(ETH_P_CAN))) {
        private enum enumMixinStr_ETH_P_CAN = `enum ETH_P_CAN = 0x000C;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_CAN); }))) {
            mixin(enumMixinStr_ETH_P_CAN);
        }
    }




    static if(!is(typeof(ETH_P_CANFD))) {
        private enum enumMixinStr_ETH_P_CANFD = `enum ETH_P_CANFD = 0x000D;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_CANFD); }))) {
            mixin(enumMixinStr_ETH_P_CANFD);
        }
    }




    static if(!is(typeof(ETH_P_PPPTALK))) {
        private enum enumMixinStr_ETH_P_PPPTALK = `enum ETH_P_PPPTALK = 0x0010;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_PPPTALK); }))) {
            mixin(enumMixinStr_ETH_P_PPPTALK);
        }
    }




    static if(!is(typeof(ETH_P_TR_802_2))) {
        private enum enumMixinStr_ETH_P_TR_802_2 = `enum ETH_P_TR_802_2 = 0x0011;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_TR_802_2); }))) {
            mixin(enumMixinStr_ETH_P_TR_802_2);
        }
    }




    static if(!is(typeof(ETH_P_MOBITEX))) {
        private enum enumMixinStr_ETH_P_MOBITEX = `enum ETH_P_MOBITEX = 0x0015;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_MOBITEX); }))) {
            mixin(enumMixinStr_ETH_P_MOBITEX);
        }
    }




    static if(!is(typeof(ETH_P_CONTROL))) {
        private enum enumMixinStr_ETH_P_CONTROL = `enum ETH_P_CONTROL = 0x0016;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_CONTROL); }))) {
            mixin(enumMixinStr_ETH_P_CONTROL);
        }
    }




    static if(!is(typeof(ETH_P_IRDA))) {
        private enum enumMixinStr_ETH_P_IRDA = `enum ETH_P_IRDA = 0x0017;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_IRDA); }))) {
            mixin(enumMixinStr_ETH_P_IRDA);
        }
    }




    static if(!is(typeof(ETH_P_ECONET))) {
        private enum enumMixinStr_ETH_P_ECONET = `enum ETH_P_ECONET = 0x0018;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_ECONET); }))) {
            mixin(enumMixinStr_ETH_P_ECONET);
        }
    }




    static if(!is(typeof(ETH_P_HDLC))) {
        private enum enumMixinStr_ETH_P_HDLC = `enum ETH_P_HDLC = 0x0019;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_HDLC); }))) {
            mixin(enumMixinStr_ETH_P_HDLC);
        }
    }




    static if(!is(typeof(ETH_P_ARCNET))) {
        private enum enumMixinStr_ETH_P_ARCNET = `enum ETH_P_ARCNET = 0x001A;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_ARCNET); }))) {
            mixin(enumMixinStr_ETH_P_ARCNET);
        }
    }




    static if(!is(typeof(ETH_P_DSA))) {
        private enum enumMixinStr_ETH_P_DSA = `enum ETH_P_DSA = 0x001B;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_DSA); }))) {
            mixin(enumMixinStr_ETH_P_DSA);
        }
    }




    static if(!is(typeof(ETH_P_TRAILER))) {
        private enum enumMixinStr_ETH_P_TRAILER = `enum ETH_P_TRAILER = 0x001C;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_TRAILER); }))) {
            mixin(enumMixinStr_ETH_P_TRAILER);
        }
    }




    static if(!is(typeof(ETH_P_PHONET))) {
        private enum enumMixinStr_ETH_P_PHONET = `enum ETH_P_PHONET = 0x00F5;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_PHONET); }))) {
            mixin(enumMixinStr_ETH_P_PHONET);
        }
    }




    static if(!is(typeof(ETH_P_IEEE802154))) {
        private enum enumMixinStr_ETH_P_IEEE802154 = `enum ETH_P_IEEE802154 = 0x00F6;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_IEEE802154); }))) {
            mixin(enumMixinStr_ETH_P_IEEE802154);
        }
    }




    static if(!is(typeof(ETH_P_CAIF))) {
        private enum enumMixinStr_ETH_P_CAIF = `enum ETH_P_CAIF = 0x00F7;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_CAIF); }))) {
            mixin(enumMixinStr_ETH_P_CAIF);
        }
    }




    static if(!is(typeof(ETH_P_XDSA))) {
        private enum enumMixinStr_ETH_P_XDSA = `enum ETH_P_XDSA = 0x00F8;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_XDSA); }))) {
            mixin(enumMixinStr_ETH_P_XDSA);
        }
    }




    static if(!is(typeof(ETH_P_MAP))) {
        private enum enumMixinStr_ETH_P_MAP = `enum ETH_P_MAP = 0x00F9;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_MAP); }))) {
            mixin(enumMixinStr_ETH_P_MAP);
        }
    }




    static if(!is(typeof(ETH_P_MCTP))) {
        private enum enumMixinStr_ETH_P_MCTP = `enum ETH_P_MCTP = 0x00FA;`;
        static if(is(typeof({ mixin(enumMixinStr_ETH_P_MCTP); }))) {
            mixin(enumMixinStr_ETH_P_MCTP);
        }
    }




    static if(!is(typeof(__UAPI_DEF_ETHHDR))) {
        private enum enumMixinStr___UAPI_DEF_ETHHDR = `enum __UAPI_DEF_ETHHDR = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_ETHHDR); }))) {
            mixin(enumMixinStr___UAPI_DEF_ETHHDR);
        }
    }




    static if(!is(typeof(_SC_LEVEL3_CACHE_ASSOC))) {
        private enum enumMixinStr__SC_LEVEL3_CACHE_ASSOC = `enum _SC_LEVEL3_CACHE_ASSOC = _SC_LEVEL3_CACHE_ASSOC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL3_CACHE_ASSOC); }))) {
            mixin(enumMixinStr__SC_LEVEL3_CACHE_ASSOC);
        }
    }




    static if(!is(typeof(_SC_LEVEL3_CACHE_SIZE))) {
        private enum enumMixinStr__SC_LEVEL3_CACHE_SIZE = `enum _SC_LEVEL3_CACHE_SIZE = _SC_LEVEL3_CACHE_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL3_CACHE_SIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL3_CACHE_SIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL2_CACHE_LINESIZE))) {
        private enum enumMixinStr__SC_LEVEL2_CACHE_LINESIZE = `enum _SC_LEVEL2_CACHE_LINESIZE = _SC_LEVEL2_CACHE_LINESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL2_CACHE_LINESIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL2_CACHE_LINESIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL2_CACHE_ASSOC))) {
        private enum enumMixinStr__SC_LEVEL2_CACHE_ASSOC = `enum _SC_LEVEL2_CACHE_ASSOC = _SC_LEVEL2_CACHE_ASSOC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL2_CACHE_ASSOC); }))) {
            mixin(enumMixinStr__SC_LEVEL2_CACHE_ASSOC);
        }
    }






    static if(!is(typeof(_SC_LEVEL2_CACHE_SIZE))) {
        private enum enumMixinStr__SC_LEVEL2_CACHE_SIZE = `enum _SC_LEVEL2_CACHE_SIZE = _SC_LEVEL2_CACHE_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL2_CACHE_SIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL2_CACHE_SIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL1_DCACHE_LINESIZE))) {
        private enum enumMixinStr__SC_LEVEL1_DCACHE_LINESIZE = `enum _SC_LEVEL1_DCACHE_LINESIZE = _SC_LEVEL1_DCACHE_LINESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL1_DCACHE_LINESIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL1_DCACHE_LINESIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL1_DCACHE_ASSOC))) {
        private enum enumMixinStr__SC_LEVEL1_DCACHE_ASSOC = `enum _SC_LEVEL1_DCACHE_ASSOC = _SC_LEVEL1_DCACHE_ASSOC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL1_DCACHE_ASSOC); }))) {
            mixin(enumMixinStr__SC_LEVEL1_DCACHE_ASSOC);
        }
    }




    static if(!is(typeof(TUN_READQ_SIZE))) {
        private enum enumMixinStr_TUN_READQ_SIZE = `enum TUN_READQ_SIZE = 500;`;
        static if(is(typeof({ mixin(enumMixinStr_TUN_READQ_SIZE); }))) {
            mixin(enumMixinStr_TUN_READQ_SIZE);
        }
    }




    static if(!is(typeof(TUN_TUN_DEV))) {
        private enum enumMixinStr_TUN_TUN_DEV = `enum TUN_TUN_DEV = IFF_TUN;`;
        static if(is(typeof({ mixin(enumMixinStr_TUN_TUN_DEV); }))) {
            mixin(enumMixinStr_TUN_TUN_DEV);
        }
    }




    static if(!is(typeof(TUN_TAP_DEV))) {
        private enum enumMixinStr_TUN_TAP_DEV = `enum TUN_TAP_DEV = IFF_TAP;`;
        static if(is(typeof({ mixin(enumMixinStr_TUN_TAP_DEV); }))) {
            mixin(enumMixinStr_TUN_TAP_DEV);
        }
    }




    static if(!is(typeof(TUN_TYPE_MASK))) {
        private enum enumMixinStr_TUN_TYPE_MASK = `enum TUN_TYPE_MASK = 0x000f;`;
        static if(is(typeof({ mixin(enumMixinStr_TUN_TYPE_MASK); }))) {
            mixin(enumMixinStr_TUN_TYPE_MASK);
        }
    }




    static if(!is(typeof(TUNSETNOCSUM))) {
        private enum enumMixinStr_TUNSETNOCSUM = `enum TUNSETNOCSUM = _IOW ( 'T' , 200 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETNOCSUM); }))) {
            mixin(enumMixinStr_TUNSETNOCSUM);
        }
    }




    static if(!is(typeof(TUNSETDEBUG))) {
        private enum enumMixinStr_TUNSETDEBUG = `enum TUNSETDEBUG = _IOW ( 'T' , 201 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETDEBUG); }))) {
            mixin(enumMixinStr_TUNSETDEBUG);
        }
    }




    static if(!is(typeof(TUNSETIFF))) {
        private enum enumMixinStr_TUNSETIFF = `enum TUNSETIFF = _IOW ( 'T' , 202 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETIFF); }))) {
            mixin(enumMixinStr_TUNSETIFF);
        }
    }




    static if(!is(typeof(TUNSETPERSIST))) {
        private enum enumMixinStr_TUNSETPERSIST = `enum TUNSETPERSIST = _IOW ( 'T' , 203 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETPERSIST); }))) {
            mixin(enumMixinStr_TUNSETPERSIST);
        }
    }




    static if(!is(typeof(TUNSETOWNER))) {
        private enum enumMixinStr_TUNSETOWNER = `enum TUNSETOWNER = _IOW ( 'T' , 204 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETOWNER); }))) {
            mixin(enumMixinStr_TUNSETOWNER);
        }
    }




    static if(!is(typeof(TUNSETLINK))) {
        private enum enumMixinStr_TUNSETLINK = `enum TUNSETLINK = _IOW ( 'T' , 205 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETLINK); }))) {
            mixin(enumMixinStr_TUNSETLINK);
        }
    }




    static if(!is(typeof(TUNSETGROUP))) {
        private enum enumMixinStr_TUNSETGROUP = `enum TUNSETGROUP = _IOW ( 'T' , 206 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETGROUP); }))) {
            mixin(enumMixinStr_TUNSETGROUP);
        }
    }




    static if(!is(typeof(TUNGETFEATURES))) {
        private enum enumMixinStr_TUNGETFEATURES = `enum TUNGETFEATURES = _IOR ( 'T' , 207 , unsigned int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNGETFEATURES); }))) {
            mixin(enumMixinStr_TUNGETFEATURES);
        }
    }




    static if(!is(typeof(TUNSETOFFLOAD))) {
        private enum enumMixinStr_TUNSETOFFLOAD = `enum TUNSETOFFLOAD = _IOW ( 'T' , 208 , unsigned int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETOFFLOAD); }))) {
            mixin(enumMixinStr_TUNSETOFFLOAD);
        }
    }




    static if(!is(typeof(TUNSETTXFILTER))) {
        private enum enumMixinStr_TUNSETTXFILTER = `enum TUNSETTXFILTER = _IOW ( 'T' , 209 , unsigned int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETTXFILTER); }))) {
            mixin(enumMixinStr_TUNSETTXFILTER);
        }
    }




    static if(!is(typeof(TUNGETIFF))) {
        private enum enumMixinStr_TUNGETIFF = `enum TUNGETIFF = _IOR ( 'T' , 210 , unsigned int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNGETIFF); }))) {
            mixin(enumMixinStr_TUNGETIFF);
        }
    }




    static if(!is(typeof(TUNGETSNDBUF))) {
        private enum enumMixinStr_TUNGETSNDBUF = `enum TUNGETSNDBUF = _IOR ( 'T' , 211 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNGETSNDBUF); }))) {
            mixin(enumMixinStr_TUNGETSNDBUF);
        }
    }




    static if(!is(typeof(TUNSETSNDBUF))) {
        private enum enumMixinStr_TUNSETSNDBUF = `enum TUNSETSNDBUF = _IOW ( 'T' , 212 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETSNDBUF); }))) {
            mixin(enumMixinStr_TUNSETSNDBUF);
        }
    }




    static if(!is(typeof(TUNATTACHFILTER))) {
        private enum enumMixinStr_TUNATTACHFILTER = `enum TUNATTACHFILTER = _IOW ( 'T' , 213 , sock_fprog );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNATTACHFILTER); }))) {
            mixin(enumMixinStr_TUNATTACHFILTER);
        }
    }




    static if(!is(typeof(TUNDETACHFILTER))) {
        private enum enumMixinStr_TUNDETACHFILTER = `enum TUNDETACHFILTER = _IOW ( 'T' , 214 , sock_fprog );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNDETACHFILTER); }))) {
            mixin(enumMixinStr_TUNDETACHFILTER);
        }
    }




    static if(!is(typeof(TUNGETVNETHDRSZ))) {
        private enum enumMixinStr_TUNGETVNETHDRSZ = `enum TUNGETVNETHDRSZ = _IOR ( 'T' , 215 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNGETVNETHDRSZ); }))) {
            mixin(enumMixinStr_TUNGETVNETHDRSZ);
        }
    }




    static if(!is(typeof(TUNSETVNETHDRSZ))) {
        private enum enumMixinStr_TUNSETVNETHDRSZ = `enum TUNSETVNETHDRSZ = _IOW ( 'T' , 216 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETVNETHDRSZ); }))) {
            mixin(enumMixinStr_TUNSETVNETHDRSZ);
        }
    }




    static if(!is(typeof(TUNSETQUEUE))) {
        private enum enumMixinStr_TUNSETQUEUE = `enum TUNSETQUEUE = _IOW ( 'T' , 217 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETQUEUE); }))) {
            mixin(enumMixinStr_TUNSETQUEUE);
        }
    }




    static if(!is(typeof(TUNSETIFINDEX))) {
        private enum enumMixinStr_TUNSETIFINDEX = `enum TUNSETIFINDEX = _IOW ( 'T' , 218 , unsigned int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETIFINDEX); }))) {
            mixin(enumMixinStr_TUNSETIFINDEX);
        }
    }




    static if(!is(typeof(TUNGETFILTER))) {
        private enum enumMixinStr_TUNGETFILTER = `enum TUNGETFILTER = _IOR ( 'T' , 219 , sock_fprog );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNGETFILTER); }))) {
            mixin(enumMixinStr_TUNGETFILTER);
        }
    }




    static if(!is(typeof(TUNSETVNETLE))) {
        private enum enumMixinStr_TUNSETVNETLE = `enum TUNSETVNETLE = _IOW ( 'T' , 220 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETVNETLE); }))) {
            mixin(enumMixinStr_TUNSETVNETLE);
        }
    }




    static if(!is(typeof(TUNGETVNETLE))) {
        private enum enumMixinStr_TUNGETVNETLE = `enum TUNGETVNETLE = _IOR ( 'T' , 221 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNGETVNETLE); }))) {
            mixin(enumMixinStr_TUNGETVNETLE);
        }
    }




    static if(!is(typeof(TUNSETVNETBE))) {
        private enum enumMixinStr_TUNSETVNETBE = `enum TUNSETVNETBE = _IOW ( 'T' , 222 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETVNETBE); }))) {
            mixin(enumMixinStr_TUNSETVNETBE);
        }
    }




    static if(!is(typeof(TUNGETVNETBE))) {
        private enum enumMixinStr_TUNGETVNETBE = `enum TUNGETVNETBE = _IOR ( 'T' , 223 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNGETVNETBE); }))) {
            mixin(enumMixinStr_TUNGETVNETBE);
        }
    }




    static if(!is(typeof(TUNSETSTEERINGEBPF))) {
        private enum enumMixinStr_TUNSETSTEERINGEBPF = `enum TUNSETSTEERINGEBPF = _IOR ( 'T' , 224 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETSTEERINGEBPF); }))) {
            mixin(enumMixinStr_TUNSETSTEERINGEBPF);
        }
    }




    static if(!is(typeof(TUNSETFILTEREBPF))) {
        private enum enumMixinStr_TUNSETFILTEREBPF = `enum TUNSETFILTEREBPF = _IOR ( 'T' , 225 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETFILTEREBPF); }))) {
            mixin(enumMixinStr_TUNSETFILTEREBPF);
        }
    }




    static if(!is(typeof(TUNSETCARRIER))) {
        private enum enumMixinStr_TUNSETCARRIER = `enum TUNSETCARRIER = _IOW ( 'T' , 226 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNSETCARRIER); }))) {
            mixin(enumMixinStr_TUNSETCARRIER);
        }
    }




    static if(!is(typeof(TUNGETDEVNETNS))) {
        private enum enumMixinStr_TUNGETDEVNETNS = `enum TUNGETDEVNETNS = _IO ( 'T' , 227 );`;
        static if(is(typeof({ mixin(enumMixinStr_TUNGETDEVNETNS); }))) {
            mixin(enumMixinStr_TUNGETDEVNETNS);
        }
    }




    static if(!is(typeof(IFF_TUN))) {
        private enum enumMixinStr_IFF_TUN = `enum IFF_TUN = 0x0001;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_TUN); }))) {
            mixin(enumMixinStr_IFF_TUN);
        }
    }




    static if(!is(typeof(IFF_TAP))) {
        private enum enumMixinStr_IFF_TAP = `enum IFF_TAP = 0x0002;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_TAP); }))) {
            mixin(enumMixinStr_IFF_TAP);
        }
    }




    static if(!is(typeof(IFF_NAPI))) {
        private enum enumMixinStr_IFF_NAPI = `enum IFF_NAPI = 0x0010;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_NAPI); }))) {
            mixin(enumMixinStr_IFF_NAPI);
        }
    }




    static if(!is(typeof(IFF_NAPI_FRAGS))) {
        private enum enumMixinStr_IFF_NAPI_FRAGS = `enum IFF_NAPI_FRAGS = 0x0020;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_NAPI_FRAGS); }))) {
            mixin(enumMixinStr_IFF_NAPI_FRAGS);
        }
    }




    static if(!is(typeof(IFF_NO_PI))) {
        private enum enumMixinStr_IFF_NO_PI = `enum IFF_NO_PI = 0x1000;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_NO_PI); }))) {
            mixin(enumMixinStr_IFF_NO_PI);
        }
    }




    static if(!is(typeof(IFF_ONE_QUEUE))) {
        private enum enumMixinStr_IFF_ONE_QUEUE = `enum IFF_ONE_QUEUE = 0x2000;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_ONE_QUEUE); }))) {
            mixin(enumMixinStr_IFF_ONE_QUEUE);
        }
    }




    static if(!is(typeof(IFF_VNET_HDR))) {
        private enum enumMixinStr_IFF_VNET_HDR = `enum IFF_VNET_HDR = 0x4000;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_VNET_HDR); }))) {
            mixin(enumMixinStr_IFF_VNET_HDR);
        }
    }




    static if(!is(typeof(IFF_TUN_EXCL))) {
        private enum enumMixinStr_IFF_TUN_EXCL = `enum IFF_TUN_EXCL = 0x8000;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_TUN_EXCL); }))) {
            mixin(enumMixinStr_IFF_TUN_EXCL);
        }
    }




    static if(!is(typeof(IFF_MULTI_QUEUE))) {
        private enum enumMixinStr_IFF_MULTI_QUEUE = `enum IFF_MULTI_QUEUE = 0x0100;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_MULTI_QUEUE); }))) {
            mixin(enumMixinStr_IFF_MULTI_QUEUE);
        }
    }




    static if(!is(typeof(IFF_ATTACH_QUEUE))) {
        private enum enumMixinStr_IFF_ATTACH_QUEUE = `enum IFF_ATTACH_QUEUE = 0x0200;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_ATTACH_QUEUE); }))) {
            mixin(enumMixinStr_IFF_ATTACH_QUEUE);
        }
    }




    static if(!is(typeof(IFF_DETACH_QUEUE))) {
        private enum enumMixinStr_IFF_DETACH_QUEUE = `enum IFF_DETACH_QUEUE = 0x0400;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_DETACH_QUEUE); }))) {
            mixin(enumMixinStr_IFF_DETACH_QUEUE);
        }
    }




    static if(!is(typeof(IFF_PERSIST))) {
        private enum enumMixinStr_IFF_PERSIST = `enum IFF_PERSIST = 0x0800;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_PERSIST); }))) {
            mixin(enumMixinStr_IFF_PERSIST);
        }
    }




    static if(!is(typeof(IFF_NOFILTER))) {
        private enum enumMixinStr_IFF_NOFILTER = `enum IFF_NOFILTER = 0x1000;`;
        static if(is(typeof({ mixin(enumMixinStr_IFF_NOFILTER); }))) {
            mixin(enumMixinStr_IFF_NOFILTER);
        }
    }




    static if(!is(typeof(TUN_TX_TIMESTAMP))) {
        private enum enumMixinStr_TUN_TX_TIMESTAMP = `enum TUN_TX_TIMESTAMP = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_TUN_TX_TIMESTAMP); }))) {
            mixin(enumMixinStr_TUN_TX_TIMESTAMP);
        }
    }




    static if(!is(typeof(TUN_F_CSUM))) {
        private enum enumMixinStr_TUN_F_CSUM = `enum TUN_F_CSUM = 0x01;`;
        static if(is(typeof({ mixin(enumMixinStr_TUN_F_CSUM); }))) {
            mixin(enumMixinStr_TUN_F_CSUM);
        }
    }




    static if(!is(typeof(TUN_F_TSO4))) {
        private enum enumMixinStr_TUN_F_TSO4 = `enum TUN_F_TSO4 = 0x02;`;
        static if(is(typeof({ mixin(enumMixinStr_TUN_F_TSO4); }))) {
            mixin(enumMixinStr_TUN_F_TSO4);
        }
    }




    static if(!is(typeof(TUN_F_TSO6))) {
        private enum enumMixinStr_TUN_F_TSO6 = `enum TUN_F_TSO6 = 0x04;`;
        static if(is(typeof({ mixin(enumMixinStr_TUN_F_TSO6); }))) {
            mixin(enumMixinStr_TUN_F_TSO6);
        }
    }




    static if(!is(typeof(TUN_F_TSO_ECN))) {
        private enum enumMixinStr_TUN_F_TSO_ECN = `enum TUN_F_TSO_ECN = 0x08;`;
        static if(is(typeof({ mixin(enumMixinStr_TUN_F_TSO_ECN); }))) {
            mixin(enumMixinStr_TUN_F_TSO_ECN);
        }
    }




    static if(!is(typeof(TUN_F_UFO))) {
        private enum enumMixinStr_TUN_F_UFO = `enum TUN_F_UFO = 0x10;`;
        static if(is(typeof({ mixin(enumMixinStr_TUN_F_UFO); }))) {
            mixin(enumMixinStr_TUN_F_UFO);
        }
    }




    static if(!is(typeof(TUN_PKT_STRIP))) {
        private enum enumMixinStr_TUN_PKT_STRIP = `enum TUN_PKT_STRIP = 0x0001;`;
        static if(is(typeof({ mixin(enumMixinStr_TUN_PKT_STRIP); }))) {
            mixin(enumMixinStr_TUN_PKT_STRIP);
        }
    }




    static if(!is(typeof(_SC_LEVEL1_DCACHE_SIZE))) {
        private enum enumMixinStr__SC_LEVEL1_DCACHE_SIZE = `enum _SC_LEVEL1_DCACHE_SIZE = _SC_LEVEL1_DCACHE_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL1_DCACHE_SIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL1_DCACHE_SIZE);
        }
    }




    static if(!is(typeof(TUN_FLT_ALLMULTI))) {
        private enum enumMixinStr_TUN_FLT_ALLMULTI = `enum TUN_FLT_ALLMULTI = 0x0001;`;
        static if(is(typeof({ mixin(enumMixinStr_TUN_FLT_ALLMULTI); }))) {
            mixin(enumMixinStr_TUN_FLT_ALLMULTI);
        }
    }




    static if(!is(typeof(_SC_LEVEL1_ICACHE_LINESIZE))) {
        private enum enumMixinStr__SC_LEVEL1_ICACHE_LINESIZE = `enum _SC_LEVEL1_ICACHE_LINESIZE = _SC_LEVEL1_ICACHE_LINESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL1_ICACHE_LINESIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL1_ICACHE_LINESIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL1_ICACHE_ASSOC))) {
        private enum enumMixinStr__SC_LEVEL1_ICACHE_ASSOC = `enum _SC_LEVEL1_ICACHE_ASSOC = _SC_LEVEL1_ICACHE_ASSOC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL1_ICACHE_ASSOC); }))) {
            mixin(enumMixinStr__SC_LEVEL1_ICACHE_ASSOC);
        }
    }






    static if(!is(typeof(_SC_LEVEL1_ICACHE_SIZE))) {
        private enum enumMixinStr__SC_LEVEL1_ICACHE_SIZE = `enum _SC_LEVEL1_ICACHE_SIZE = _SC_LEVEL1_ICACHE_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL1_ICACHE_SIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL1_ICACHE_SIZE);
        }
    }






    static if(!is(typeof(_SC_TRACE_LOG))) {
        private enum enumMixinStr__SC_TRACE_LOG = `enum _SC_TRACE_LOG = _SC_TRACE_LOG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_LOG); }))) {
            mixin(enumMixinStr__SC_TRACE_LOG);
        }
    }




    static if(!is(typeof(_SC_TRACE_INHERIT))) {
        private enum enumMixinStr__SC_TRACE_INHERIT = `enum _SC_TRACE_INHERIT = _SC_TRACE_INHERIT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_INHERIT); }))) {
            mixin(enumMixinStr__SC_TRACE_INHERIT);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IF_IFCONF))) {
        private enum enumMixinStr___UAPI_DEF_IF_IFCONF = `enum __UAPI_DEF_IF_IFCONF = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IF_IFCONF); }))) {
            mixin(enumMixinStr___UAPI_DEF_IF_IFCONF);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IF_IFMAP))) {
        private enum enumMixinStr___UAPI_DEF_IF_IFMAP = `enum __UAPI_DEF_IF_IFMAP = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IF_IFMAP); }))) {
            mixin(enumMixinStr___UAPI_DEF_IF_IFMAP);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IF_IFNAMSIZ))) {
        private enum enumMixinStr___UAPI_DEF_IF_IFNAMSIZ = `enum __UAPI_DEF_IF_IFNAMSIZ = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IF_IFNAMSIZ); }))) {
            mixin(enumMixinStr___UAPI_DEF_IF_IFNAMSIZ);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IF_IFREQ))) {
        private enum enumMixinStr___UAPI_DEF_IF_IFREQ = `enum __UAPI_DEF_IF_IFREQ = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IF_IFREQ); }))) {
            mixin(enumMixinStr___UAPI_DEF_IF_IFREQ);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IF_NET_DEVICE_FLAGS))) {
        private enum enumMixinStr___UAPI_DEF_IF_NET_DEVICE_FLAGS = `enum __UAPI_DEF_IF_NET_DEVICE_FLAGS = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IF_NET_DEVICE_FLAGS); }))) {
            mixin(enumMixinStr___UAPI_DEF_IF_NET_DEVICE_FLAGS);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO))) {
        private enum enumMixinStr___UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO = `enum __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO); }))) {
            mixin(enumMixinStr___UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IN_ADDR))) {
        private enum enumMixinStr___UAPI_DEF_IN_ADDR = `enum __UAPI_DEF_IN_ADDR = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IN_ADDR); }))) {
            mixin(enumMixinStr___UAPI_DEF_IN_ADDR);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IN_IPPROTO))) {
        private enum enumMixinStr___UAPI_DEF_IN_IPPROTO = `enum __UAPI_DEF_IN_IPPROTO = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IN_IPPROTO); }))) {
            mixin(enumMixinStr___UAPI_DEF_IN_IPPROTO);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IN_PKTINFO))) {
        private enum enumMixinStr___UAPI_DEF_IN_PKTINFO = `enum __UAPI_DEF_IN_PKTINFO = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IN_PKTINFO); }))) {
            mixin(enumMixinStr___UAPI_DEF_IN_PKTINFO);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IP_MREQ))) {
        private enum enumMixinStr___UAPI_DEF_IP_MREQ = `enum __UAPI_DEF_IP_MREQ = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IP_MREQ); }))) {
            mixin(enumMixinStr___UAPI_DEF_IP_MREQ);
        }
    }




    static if(!is(typeof(__UAPI_DEF_SOCKADDR_IN))) {
        private enum enumMixinStr___UAPI_DEF_SOCKADDR_IN = `enum __UAPI_DEF_SOCKADDR_IN = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_SOCKADDR_IN); }))) {
            mixin(enumMixinStr___UAPI_DEF_SOCKADDR_IN);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IN_CLASS))) {
        private enum enumMixinStr___UAPI_DEF_IN_CLASS = `enum __UAPI_DEF_IN_CLASS = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IN_CLASS); }))) {
            mixin(enumMixinStr___UAPI_DEF_IN_CLASS);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IN6_ADDR))) {
        private enum enumMixinStr___UAPI_DEF_IN6_ADDR = `enum __UAPI_DEF_IN6_ADDR = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IN6_ADDR); }))) {
            mixin(enumMixinStr___UAPI_DEF_IN6_ADDR);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IN6_ADDR_ALT))) {
        private enum enumMixinStr___UAPI_DEF_IN6_ADDR_ALT = `enum __UAPI_DEF_IN6_ADDR_ALT = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IN6_ADDR_ALT); }))) {
            mixin(enumMixinStr___UAPI_DEF_IN6_ADDR_ALT);
        }
    }




    static if(!is(typeof(__UAPI_DEF_SOCKADDR_IN6))) {
        private enum enumMixinStr___UAPI_DEF_SOCKADDR_IN6 = `enum __UAPI_DEF_SOCKADDR_IN6 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_SOCKADDR_IN6); }))) {
            mixin(enumMixinStr___UAPI_DEF_SOCKADDR_IN6);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IPV6_MREQ))) {
        private enum enumMixinStr___UAPI_DEF_IPV6_MREQ = `enum __UAPI_DEF_IPV6_MREQ = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IPV6_MREQ); }))) {
            mixin(enumMixinStr___UAPI_DEF_IPV6_MREQ);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IPPROTO_V6))) {
        private enum enumMixinStr___UAPI_DEF_IPPROTO_V6 = `enum __UAPI_DEF_IPPROTO_V6 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IPPROTO_V6); }))) {
            mixin(enumMixinStr___UAPI_DEF_IPPROTO_V6);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IPV6_OPTIONS))) {
        private enum enumMixinStr___UAPI_DEF_IPV6_OPTIONS = `enum __UAPI_DEF_IPV6_OPTIONS = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IPV6_OPTIONS); }))) {
            mixin(enumMixinStr___UAPI_DEF_IPV6_OPTIONS);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IN6_PKTINFO))) {
        private enum enumMixinStr___UAPI_DEF_IN6_PKTINFO = `enum __UAPI_DEF_IN6_PKTINFO = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IN6_PKTINFO); }))) {
            mixin(enumMixinStr___UAPI_DEF_IN6_PKTINFO);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IP6_MTUINFO))) {
        private enum enumMixinStr___UAPI_DEF_IP6_MTUINFO = `enum __UAPI_DEF_IP6_MTUINFO = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IP6_MTUINFO); }))) {
            mixin(enumMixinStr___UAPI_DEF_IP6_MTUINFO);
        }
    }




    static if(!is(typeof(__UAPI_DEF_SOCKADDR_IPX))) {
        private enum enumMixinStr___UAPI_DEF_SOCKADDR_IPX = `enum __UAPI_DEF_SOCKADDR_IPX = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_SOCKADDR_IPX); }))) {
            mixin(enumMixinStr___UAPI_DEF_SOCKADDR_IPX);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IPX_ROUTE_DEFINITION))) {
        private enum enumMixinStr___UAPI_DEF_IPX_ROUTE_DEFINITION = `enum __UAPI_DEF_IPX_ROUTE_DEFINITION = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IPX_ROUTE_DEFINITION); }))) {
            mixin(enumMixinStr___UAPI_DEF_IPX_ROUTE_DEFINITION);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IPX_INTERFACE_DEFINITION))) {
        private enum enumMixinStr___UAPI_DEF_IPX_INTERFACE_DEFINITION = `enum __UAPI_DEF_IPX_INTERFACE_DEFINITION = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IPX_INTERFACE_DEFINITION); }))) {
            mixin(enumMixinStr___UAPI_DEF_IPX_INTERFACE_DEFINITION);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IPX_CONFIG_DATA))) {
        private enum enumMixinStr___UAPI_DEF_IPX_CONFIG_DATA = `enum __UAPI_DEF_IPX_CONFIG_DATA = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IPX_CONFIG_DATA); }))) {
            mixin(enumMixinStr___UAPI_DEF_IPX_CONFIG_DATA);
        }
    }




    static if(!is(typeof(__UAPI_DEF_IPX_ROUTE_DEF))) {
        private enum enumMixinStr___UAPI_DEF_IPX_ROUTE_DEF = `enum __UAPI_DEF_IPX_ROUTE_DEF = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_IPX_ROUTE_DEF); }))) {
            mixin(enumMixinStr___UAPI_DEF_IPX_ROUTE_DEF);
        }
    }




    static if(!is(typeof(__UAPI_DEF_XATTR))) {
        private enum enumMixinStr___UAPI_DEF_XATTR = `enum __UAPI_DEF_XATTR = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___UAPI_DEF_XATTR); }))) {
            mixin(enumMixinStr___UAPI_DEF_XATTR);
        }
    }






    static if(!is(typeof(_SC_TRACE_EVENT_FILTER))) {
        private enum enumMixinStr__SC_TRACE_EVENT_FILTER = `enum _SC_TRACE_EVENT_FILTER = _SC_TRACE_EVENT_FILTER;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_EVENT_FILTER); }))) {
            mixin(enumMixinStr__SC_TRACE_EVENT_FILTER);
        }
    }




    static if(!is(typeof(_SC_TRACE))) {
        private enum enumMixinStr__SC_TRACE = `enum _SC_TRACE = _SC_TRACE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE); }))) {
            mixin(enumMixinStr__SC_TRACE);
        }
    }




    static if(!is(typeof(_SC_HOST_NAME_MAX))) {
        private enum enumMixinStr__SC_HOST_NAME_MAX = `enum _SC_HOST_NAME_MAX = _SC_HOST_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_HOST_NAME_MAX); }))) {
            mixin(enumMixinStr__SC_HOST_NAME_MAX);
        }
    }




    static if(!is(typeof(_SC_V6_LPBIG_OFFBIG))) {
        private enum enumMixinStr__SC_V6_LPBIG_OFFBIG = `enum _SC_V6_LPBIG_OFFBIG = _SC_V6_LPBIG_OFFBIG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V6_LPBIG_OFFBIG); }))) {
            mixin(enumMixinStr__SC_V6_LPBIG_OFFBIG);
        }
    }




    static if(!is(typeof(_SC_V6_LP64_OFF64))) {
        private enum enumMixinStr__SC_V6_LP64_OFF64 = `enum _SC_V6_LP64_OFF64 = _SC_V6_LP64_OFF64;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V6_LP64_OFF64); }))) {
            mixin(enumMixinStr__SC_V6_LP64_OFF64);
        }
    }




    static if(!is(typeof(_SC_V6_ILP32_OFFBIG))) {
        private enum enumMixinStr__SC_V6_ILP32_OFFBIG = `enum _SC_V6_ILP32_OFFBIG = _SC_V6_ILP32_OFFBIG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V6_ILP32_OFFBIG); }))) {
            mixin(enumMixinStr__SC_V6_ILP32_OFFBIG);
        }
    }




    static if(!is(typeof(_SC_V6_ILP32_OFF32))) {
        private enum enumMixinStr__SC_V6_ILP32_OFF32 = `enum _SC_V6_ILP32_OFF32 = _SC_V6_ILP32_OFF32;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V6_ILP32_OFF32); }))) {
            mixin(enumMixinStr__SC_V6_ILP32_OFF32);
        }
    }




    static if(!is(typeof(_SC_2_PBS_CHECKPOINT))) {
        private enum enumMixinStr__SC_2_PBS_CHECKPOINT = `enum _SC_2_PBS_CHECKPOINT = _SC_2_PBS_CHECKPOINT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_PBS_CHECKPOINT); }))) {
            mixin(enumMixinStr__SC_2_PBS_CHECKPOINT);
        }
    }






    static if(!is(typeof(_K_SS_MAXSIZE))) {
        private enum enumMixinStr__K_SS_MAXSIZE = `enum _K_SS_MAXSIZE = 128;`;
        static if(is(typeof({ mixin(enumMixinStr__K_SS_MAXSIZE); }))) {
            mixin(enumMixinStr__K_SS_MAXSIZE);
        }
    }




    static if(!is(typeof(_SC_STREAMS))) {
        private enum enumMixinStr__SC_STREAMS = `enum _SC_STREAMS = _SC_STREAMS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_STREAMS); }))) {
            mixin(enumMixinStr__SC_STREAMS);
        }
    }




    static if(!is(typeof(_SC_SYMLOOP_MAX))) {
        private enum enumMixinStr__SC_SYMLOOP_MAX = `enum _SC_SYMLOOP_MAX = _SC_SYMLOOP_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SYMLOOP_MAX); }))) {
            mixin(enumMixinStr__SC_SYMLOOP_MAX);
        }
    }




    static if(!is(typeof(_SC_2_PBS_TRACK))) {
        private enum enumMixinStr__SC_2_PBS_TRACK = `enum _SC_2_PBS_TRACK = _SC_2_PBS_TRACK;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_PBS_TRACK); }))) {
            mixin(enumMixinStr__SC_2_PBS_TRACK);
        }
    }




    static if(!is(typeof(SOCK_SNDBUF_LOCK))) {
        private enum enumMixinStr_SOCK_SNDBUF_LOCK = `enum SOCK_SNDBUF_LOCK = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_SOCK_SNDBUF_LOCK); }))) {
            mixin(enumMixinStr_SOCK_SNDBUF_LOCK);
        }
    }




    static if(!is(typeof(SOCK_RCVBUF_LOCK))) {
        private enum enumMixinStr_SOCK_RCVBUF_LOCK = `enum SOCK_RCVBUF_LOCK = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_SOCK_RCVBUF_LOCK); }))) {
            mixin(enumMixinStr_SOCK_RCVBUF_LOCK);
        }
    }




    static if(!is(typeof(SOCK_BUF_LOCK_MASK))) {
        private enum enumMixinStr_SOCK_BUF_LOCK_MASK = `enum SOCK_BUF_LOCK_MASK = ( 1 | 2 );`;
        static if(is(typeof({ mixin(enumMixinStr_SOCK_BUF_LOCK_MASK); }))) {
            mixin(enumMixinStr_SOCK_BUF_LOCK_MASK);
        }
    }






    static if(!is(typeof(_SC_2_PBS_MESSAGE))) {
        private enum enumMixinStr__SC_2_PBS_MESSAGE = `enum _SC_2_PBS_MESSAGE = _SC_2_PBS_MESSAGE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_PBS_MESSAGE); }))) {
            mixin(enumMixinStr__SC_2_PBS_MESSAGE);
        }
    }
    static if(!is(typeof(_SC_2_PBS_LOCATE))) {
        private enum enumMixinStr__SC_2_PBS_LOCATE = `enum _SC_2_PBS_LOCATE = _SC_2_PBS_LOCATE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_PBS_LOCATE); }))) {
            mixin(enumMixinStr__SC_2_PBS_LOCATE);
        }
    }




    static if(!is(typeof(_SC_2_PBS_ACCOUNTING))) {
        private enum enumMixinStr__SC_2_PBS_ACCOUNTING = `enum _SC_2_PBS_ACCOUNTING = _SC_2_PBS_ACCOUNTING;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_PBS_ACCOUNTING); }))) {
            mixin(enumMixinStr__SC_2_PBS_ACCOUNTING);
        }
    }






    static if(!is(typeof(__bitwise))) {
        private enum enumMixinStr___bitwise = `enum __bitwise = ;`;
        static if(is(typeof({ mixin(enumMixinStr___bitwise); }))) {
            mixin(enumMixinStr___bitwise);
        }
    }




    static if(!is(typeof(_SC_2_PBS))) {
        private enum enumMixinStr__SC_2_PBS = `enum _SC_2_PBS = _SC_2_PBS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_PBS); }))) {
            mixin(enumMixinStr__SC_2_PBS);
        }
    }




    static if(!is(typeof(_SC_USER_GROUPS_R))) {
        private enum enumMixinStr__SC_USER_GROUPS_R = `enum _SC_USER_GROUPS_R = _SC_USER_GROUPS_R;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_USER_GROUPS_R); }))) {
            mixin(enumMixinStr__SC_USER_GROUPS_R);
        }
    }




    static if(!is(typeof(_SC_USER_GROUPS))) {
        private enum enumMixinStr__SC_USER_GROUPS = `enum _SC_USER_GROUPS = _SC_USER_GROUPS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_USER_GROUPS); }))) {
            mixin(enumMixinStr__SC_USER_GROUPS);
        }
    }




    static if(!is(typeof(_SC_TYPED_MEMORY_OBJECTS))) {
        private enum enumMixinStr__SC_TYPED_MEMORY_OBJECTS = `enum _SC_TYPED_MEMORY_OBJECTS = _SC_TYPED_MEMORY_OBJECTS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TYPED_MEMORY_OBJECTS); }))) {
            mixin(enumMixinStr__SC_TYPED_MEMORY_OBJECTS);
        }
    }




    static if(!is(typeof(_SC_TIMEOUTS))) {
        private enum enumMixinStr__SC_TIMEOUTS = `enum _SC_TIMEOUTS = _SC_TIMEOUTS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TIMEOUTS); }))) {
            mixin(enumMixinStr__SC_TIMEOUTS);
        }
    }




    static if(!is(typeof(_SC_SYSTEM_DATABASE_R))) {
        private enum enumMixinStr__SC_SYSTEM_DATABASE_R = `enum _SC_SYSTEM_DATABASE_R = _SC_SYSTEM_DATABASE_R;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SYSTEM_DATABASE_R); }))) {
            mixin(enumMixinStr__SC_SYSTEM_DATABASE_R);
        }
    }




    static if(!is(typeof(_SC_SYSTEM_DATABASE))) {
        private enum enumMixinStr__SC_SYSTEM_DATABASE = `enum _SC_SYSTEM_DATABASE = _SC_SYSTEM_DATABASE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SYSTEM_DATABASE); }))) {
            mixin(enumMixinStr__SC_SYSTEM_DATABASE);
        }
    }




    static if(!is(typeof(_SC_THREAD_SPORADIC_SERVER))) {
        private enum enumMixinStr__SC_THREAD_SPORADIC_SERVER = `enum _SC_THREAD_SPORADIC_SERVER = _SC_THREAD_SPORADIC_SERVER;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_SPORADIC_SERVER); }))) {
            mixin(enumMixinStr__SC_THREAD_SPORADIC_SERVER);
        }
    }




    static if(!is(typeof(_SC_SPORADIC_SERVER))) {
        private enum enumMixinStr__SC_SPORADIC_SERVER = `enum _SC_SPORADIC_SERVER = _SC_SPORADIC_SERVER;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SPORADIC_SERVER); }))) {
            mixin(enumMixinStr__SC_SPORADIC_SERVER);
        }
    }




    static if(!is(typeof(_SC_SPAWN))) {
        private enum enumMixinStr__SC_SPAWN = `enum _SC_SPAWN = _SC_SPAWN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SPAWN); }))) {
            mixin(enumMixinStr__SC_SPAWN);
        }
    }




    static if(!is(typeof(_SC_SIGNALS))) {
        private enum enumMixinStr__SC_SIGNALS = `enum _SC_SIGNALS = _SC_SIGNALS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SIGNALS); }))) {
            mixin(enumMixinStr__SC_SIGNALS);
        }
    }




    static if(!is(typeof(_SC_SHELL))) {
        private enum enumMixinStr__SC_SHELL = `enum _SC_SHELL = _SC_SHELL;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SHELL); }))) {
            mixin(enumMixinStr__SC_SHELL);
        }
    }




    static if(!is(typeof(_SC_REGEX_VERSION))) {
        private enum enumMixinStr__SC_REGEX_VERSION = `enum _SC_REGEX_VERSION = _SC_REGEX_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_REGEX_VERSION); }))) {
            mixin(enumMixinStr__SC_REGEX_VERSION);
        }
    }




    static if(!is(typeof(_SC_REGEXP))) {
        private enum enumMixinStr__SC_REGEXP = `enum _SC_REGEXP = _SC_REGEXP;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_REGEXP); }))) {
            mixin(enumMixinStr__SC_REGEXP);
        }
    }




    static if(!is(typeof(_SC_SPIN_LOCKS))) {
        private enum enumMixinStr__SC_SPIN_LOCKS = `enum _SC_SPIN_LOCKS = _SC_SPIN_LOCKS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SPIN_LOCKS); }))) {
            mixin(enumMixinStr__SC_SPIN_LOCKS);
        }
    }




    static if(!is(typeof(_SC_READER_WRITER_LOCKS))) {
        private enum enumMixinStr__SC_READER_WRITER_LOCKS = `enum _SC_READER_WRITER_LOCKS = _SC_READER_WRITER_LOCKS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_READER_WRITER_LOCKS); }))) {
            mixin(enumMixinStr__SC_READER_WRITER_LOCKS);
        }
    }




    static if(!is(typeof(__aligned_u64))) {
        private enum enumMixinStr___aligned_u64 = `enum __aligned_u64 = __u64 __attribute__ ( ( aligned ( 8 ) ) );`;
        static if(is(typeof({ mixin(enumMixinStr___aligned_u64); }))) {
            mixin(enumMixinStr___aligned_u64);
        }
    }




    static if(!is(typeof(__aligned_be64))) {
        private enum enumMixinStr___aligned_be64 = `enum __aligned_be64 = __be64 __attribute__ ( ( aligned ( 8 ) ) );`;
        static if(is(typeof({ mixin(enumMixinStr___aligned_be64); }))) {
            mixin(enumMixinStr___aligned_be64);
        }
    }




    static if(!is(typeof(__aligned_le64))) {
        private enum enumMixinStr___aligned_le64 = `enum __aligned_le64 = __le64 __attribute__ ( ( aligned ( 8 ) ) );`;
        static if(is(typeof({ mixin(enumMixinStr___aligned_le64); }))) {
            mixin(enumMixinStr___aligned_le64);
        }
    }




    static if(!is(typeof(_SC_NETWORKING))) {
        private enum enumMixinStr__SC_NETWORKING = `enum _SC_NETWORKING = _SC_NETWORKING;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NETWORKING); }))) {
            mixin(enumMixinStr__SC_NETWORKING);
        }
    }




    static if(!is(typeof(_SC_SINGLE_PROCESS))) {
        private enum enumMixinStr__SC_SINGLE_PROCESS = `enum _SC_SINGLE_PROCESS = _SC_SINGLE_PROCESS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SINGLE_PROCESS); }))) {
            mixin(enumMixinStr__SC_SINGLE_PROCESS);
        }
    }




    static if(!is(typeof(_STDC_PREDEF_H))) {
        private enum enumMixinStr__STDC_PREDEF_H = `enum _STDC_PREDEF_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__STDC_PREDEF_H); }))) {
            mixin(enumMixinStr__STDC_PREDEF_H);
        }
    }




    static if(!is(typeof(_STDIO_H))) {
        private enum enumMixinStr__STDIO_H = `enum _STDIO_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__STDIO_H); }))) {
            mixin(enumMixinStr__STDIO_H);
        }
    }






    static if(!is(typeof(_SC_MULTI_PROCESS))) {
        private enum enumMixinStr__SC_MULTI_PROCESS = `enum _SC_MULTI_PROCESS = _SC_MULTI_PROCESS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MULTI_PROCESS); }))) {
            mixin(enumMixinStr__SC_MULTI_PROCESS);
        }
    }




    static if(!is(typeof(_SC_MONOTONIC_CLOCK))) {
        private enum enumMixinStr__SC_MONOTONIC_CLOCK = `enum _SC_MONOTONIC_CLOCK = _SC_MONOTONIC_CLOCK;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MONOTONIC_CLOCK); }))) {
            mixin(enumMixinStr__SC_MONOTONIC_CLOCK);
        }
    }






    static if(!is(typeof(_SC_FILE_SYSTEM))) {
        private enum enumMixinStr__SC_FILE_SYSTEM = `enum _SC_FILE_SYSTEM = _SC_FILE_SYSTEM;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_FILE_SYSTEM); }))) {
            mixin(enumMixinStr__SC_FILE_SYSTEM);
        }
    }






    static if(!is(typeof(_SC_FILE_LOCKING))) {
        private enum enumMixinStr__SC_FILE_LOCKING = `enum _SC_FILE_LOCKING = _SC_FILE_LOCKING;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_FILE_LOCKING); }))) {
            mixin(enumMixinStr__SC_FILE_LOCKING);
        }
    }




    static if(!is(typeof(_SC_FILE_ATTRIBUTES))) {
        private enum enumMixinStr__SC_FILE_ATTRIBUTES = `enum _SC_FILE_ATTRIBUTES = _SC_FILE_ATTRIBUTES;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_FILE_ATTRIBUTES); }))) {
            mixin(enumMixinStr__SC_FILE_ATTRIBUTES);
        }
    }




    static if(!is(typeof(_SC_PIPE))) {
        private enum enumMixinStr__SC_PIPE = `enum _SC_PIPE = _SC_PIPE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PIPE); }))) {
            mixin(enumMixinStr__SC_PIPE);
        }
    }




    static if(!is(typeof(_SC_FIFO))) {
        private enum enumMixinStr__SC_FIFO = `enum _SC_FIFO = _SC_FIFO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_FIFO); }))) {
            mixin(enumMixinStr__SC_FIFO);
        }
    }




    static if(!is(typeof(_SC_FD_MGMT))) {
        private enum enumMixinStr__SC_FD_MGMT = `enum _SC_FD_MGMT = _SC_FD_MGMT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_FD_MGMT); }))) {
            mixin(enumMixinStr__SC_FD_MGMT);
        }
    }




    static if(!is(typeof(_SC_DEVICE_SPECIFIC_R))) {
        private enum enumMixinStr__SC_DEVICE_SPECIFIC_R = `enum _SC_DEVICE_SPECIFIC_R = _SC_DEVICE_SPECIFIC_R;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_DEVICE_SPECIFIC_R); }))) {
            mixin(enumMixinStr__SC_DEVICE_SPECIFIC_R);
        }
    }




    static if(!is(typeof(_SC_DEVICE_SPECIFIC))) {
        private enum enumMixinStr__SC_DEVICE_SPECIFIC = `enum _SC_DEVICE_SPECIFIC = _SC_DEVICE_SPECIFIC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_DEVICE_SPECIFIC); }))) {
            mixin(enumMixinStr__SC_DEVICE_SPECIFIC);
        }
    }




    static if(!is(typeof(_SC_DEVICE_IO))) {
        private enum enumMixinStr__SC_DEVICE_IO = `enum _SC_DEVICE_IO = _SC_DEVICE_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_DEVICE_IO); }))) {
            mixin(enumMixinStr__SC_DEVICE_IO);
        }
    }




    static if(!is(typeof(_SC_THREAD_CPUTIME))) {
        private enum enumMixinStr__SC_THREAD_CPUTIME = `enum _SC_THREAD_CPUTIME = _SC_THREAD_CPUTIME;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_CPUTIME); }))) {
            mixin(enumMixinStr__SC_THREAD_CPUTIME);
        }
    }






    static if(!is(typeof(_SC_CPUTIME))) {
        private enum enumMixinStr__SC_CPUTIME = `enum _SC_CPUTIME = _SC_CPUTIME;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CPUTIME); }))) {
            mixin(enumMixinStr__SC_CPUTIME);
        }
    }




    static if(!is(typeof(_SC_CLOCK_SELECTION))) {
        private enum enumMixinStr__SC_CLOCK_SELECTION = `enum _SC_CLOCK_SELECTION = _SC_CLOCK_SELECTION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CLOCK_SELECTION); }))) {
            mixin(enumMixinStr__SC_CLOCK_SELECTION);
        }
    }




    static if(!is(typeof(_SC_C_LANG_SUPPORT_R))) {
        private enum enumMixinStr__SC_C_LANG_SUPPORT_R = `enum _SC_C_LANG_SUPPORT_R = _SC_C_LANG_SUPPORT_R;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_C_LANG_SUPPORT_R); }))) {
            mixin(enumMixinStr__SC_C_LANG_SUPPORT_R);
        }
    }




    static if(!is(typeof(_SC_C_LANG_SUPPORT))) {
        private enum enumMixinStr__SC_C_LANG_SUPPORT = `enum _SC_C_LANG_SUPPORT = _SC_C_LANG_SUPPORT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_C_LANG_SUPPORT); }))) {
            mixin(enumMixinStr__SC_C_LANG_SUPPORT);
        }
    }




    static if(!is(typeof(_SC_BASE))) {
        private enum enumMixinStr__SC_BASE = `enum _SC_BASE = _SC_BASE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_BASE); }))) {
            mixin(enumMixinStr__SC_BASE);
        }
    }




    static if(!is(typeof(_IOFBF))) {
        private enum enumMixinStr__IOFBF = `enum _IOFBF = 0;`;
        static if(is(typeof({ mixin(enumMixinStr__IOFBF); }))) {
            mixin(enumMixinStr__IOFBF);
        }
    }




    static if(!is(typeof(_IOLBF))) {
        private enum enumMixinStr__IOLBF = `enum _IOLBF = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__IOLBF); }))) {
            mixin(enumMixinStr__IOLBF);
        }
    }




    static if(!is(typeof(_IONBF))) {
        private enum enumMixinStr__IONBF = `enum _IONBF = 2;`;
        static if(is(typeof({ mixin(enumMixinStr__IONBF); }))) {
            mixin(enumMixinStr__IONBF);
        }
    }




    static if(!is(typeof(BUFSIZ))) {
        private enum enumMixinStr_BUFSIZ = `enum BUFSIZ = 8192;`;
        static if(is(typeof({ mixin(enumMixinStr_BUFSIZ); }))) {
            mixin(enumMixinStr_BUFSIZ);
        }
    }




    static if(!is(typeof(EOF))) {
        private enum enumMixinStr_EOF = `enum EOF = ( - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_EOF); }))) {
            mixin(enumMixinStr_EOF);
        }
    }




    static if(!is(typeof(_SC_BARRIERS))) {
        private enum enumMixinStr__SC_BARRIERS = `enum _SC_BARRIERS = _SC_BARRIERS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_BARRIERS); }))) {
            mixin(enumMixinStr__SC_BARRIERS);
        }
    }




    static if(!is(typeof(P_tmpdir))) {
        private enum enumMixinStr_P_tmpdir = `enum P_tmpdir = "/tmp";`;
        static if(is(typeof({ mixin(enumMixinStr_P_tmpdir); }))) {
            mixin(enumMixinStr_P_tmpdir);
        }
    }




    static if(!is(typeof(_SC_ADVISORY_INFO))) {
        private enum enumMixinStr__SC_ADVISORY_INFO = `enum _SC_ADVISORY_INFO = _SC_ADVISORY_INFO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_ADVISORY_INFO); }))) {
            mixin(enumMixinStr__SC_ADVISORY_INFO);
        }
    }




    static if(!is(typeof(_SC_XOPEN_REALTIME_THREADS))) {
        private enum enumMixinStr__SC_XOPEN_REALTIME_THREADS = `enum _SC_XOPEN_REALTIME_THREADS = _SC_XOPEN_REALTIME_THREADS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_REALTIME_THREADS); }))) {
            mixin(enumMixinStr__SC_XOPEN_REALTIME_THREADS);
        }
    }




    static if(!is(typeof(_SC_XOPEN_REALTIME))) {
        private enum enumMixinStr__SC_XOPEN_REALTIME = `enum _SC_XOPEN_REALTIME = _SC_XOPEN_REALTIME;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_REALTIME); }))) {
            mixin(enumMixinStr__SC_XOPEN_REALTIME);
        }
    }




    static if(!is(typeof(_SC_XOPEN_LEGACY))) {
        private enum enumMixinStr__SC_XOPEN_LEGACY = `enum _SC_XOPEN_LEGACY = _SC_XOPEN_LEGACY;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_LEGACY); }))) {
            mixin(enumMixinStr__SC_XOPEN_LEGACY);
        }
    }




    static if(!is(typeof(_SC_XBS5_LPBIG_OFFBIG))) {
        private enum enumMixinStr__SC_XBS5_LPBIG_OFFBIG = `enum _SC_XBS5_LPBIG_OFFBIG = _SC_XBS5_LPBIG_OFFBIG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XBS5_LPBIG_OFFBIG); }))) {
            mixin(enumMixinStr__SC_XBS5_LPBIG_OFFBIG);
        }
    }




    static if(!is(typeof(stdin))) {
        private enum enumMixinStr_stdin = `enum stdin = stdin;`;
        static if(is(typeof({ mixin(enumMixinStr_stdin); }))) {
            mixin(enumMixinStr_stdin);
        }
    }




    static if(!is(typeof(stdout))) {
        private enum enumMixinStr_stdout = `enum stdout = stdout;`;
        static if(is(typeof({ mixin(enumMixinStr_stdout); }))) {
            mixin(enumMixinStr_stdout);
        }
    }




    static if(!is(typeof(stderr))) {
        private enum enumMixinStr_stderr = `enum stderr = stderr;`;
        static if(is(typeof({ mixin(enumMixinStr_stderr); }))) {
            mixin(enumMixinStr_stderr);
        }
    }




    static if(!is(typeof(_SC_XBS5_LP64_OFF64))) {
        private enum enumMixinStr__SC_XBS5_LP64_OFF64 = `enum _SC_XBS5_LP64_OFF64 = _SC_XBS5_LP64_OFF64;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XBS5_LP64_OFF64); }))) {
            mixin(enumMixinStr__SC_XBS5_LP64_OFF64);
        }
    }




    static if(!is(typeof(_SC_XBS5_ILP32_OFFBIG))) {
        private enum enumMixinStr__SC_XBS5_ILP32_OFFBIG = `enum _SC_XBS5_ILP32_OFFBIG = _SC_XBS5_ILP32_OFFBIG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XBS5_ILP32_OFFBIG); }))) {
            mixin(enumMixinStr__SC_XBS5_ILP32_OFFBIG);
        }
    }




    static if(!is(typeof(_SC_XBS5_ILP32_OFF32))) {
        private enum enumMixinStr__SC_XBS5_ILP32_OFF32 = `enum _SC_XBS5_ILP32_OFF32 = _SC_XBS5_ILP32_OFF32;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XBS5_ILP32_OFF32); }))) {
            mixin(enumMixinStr__SC_XBS5_ILP32_OFF32);
        }
    }




    static if(!is(typeof(_SC_NL_TEXTMAX))) {
        private enum enumMixinStr__SC_NL_TEXTMAX = `enum _SC_NL_TEXTMAX = _SC_NL_TEXTMAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NL_TEXTMAX); }))) {
            mixin(enumMixinStr__SC_NL_TEXTMAX);
        }
    }




    static if(!is(typeof(_SC_NL_SETMAX))) {
        private enum enumMixinStr__SC_NL_SETMAX = `enum _SC_NL_SETMAX = _SC_NL_SETMAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NL_SETMAX); }))) {
            mixin(enumMixinStr__SC_NL_SETMAX);
        }
    }




    static if(!is(typeof(_SC_NL_NMAX))) {
        private enum enumMixinStr__SC_NL_NMAX = `enum _SC_NL_NMAX = _SC_NL_NMAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NL_NMAX); }))) {
            mixin(enumMixinStr__SC_NL_NMAX);
        }
    }




    static if(!is(typeof(_SC_NL_MSGMAX))) {
        private enum enumMixinStr__SC_NL_MSGMAX = `enum _SC_NL_MSGMAX = _SC_NL_MSGMAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NL_MSGMAX); }))) {
            mixin(enumMixinStr__SC_NL_MSGMAX);
        }
    }




    static if(!is(typeof(_SC_NL_LANGMAX))) {
        private enum enumMixinStr__SC_NL_LANGMAX = `enum _SC_NL_LANGMAX = _SC_NL_LANGMAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NL_LANGMAX); }))) {
            mixin(enumMixinStr__SC_NL_LANGMAX);
        }
    }




    static if(!is(typeof(__attr_dealloc_fclose))) {
        private enum enumMixinStr___attr_dealloc_fclose = `enum __attr_dealloc_fclose = __attr_dealloc ( fclose , 1 );`;
        static if(is(typeof({ mixin(enumMixinStr___attr_dealloc_fclose); }))) {
            mixin(enumMixinStr___attr_dealloc_fclose);
        }
    }




    static if(!is(typeof(_SC_NL_ARGMAX))) {
        private enum enumMixinStr__SC_NL_ARGMAX = `enum _SC_NL_ARGMAX = _SC_NL_ARGMAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NL_ARGMAX); }))) {
            mixin(enumMixinStr__SC_NL_ARGMAX);
        }
    }




    static if(!is(typeof(_SC_USHRT_MAX))) {
        private enum enumMixinStr__SC_USHRT_MAX = `enum _SC_USHRT_MAX = _SC_USHRT_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_USHRT_MAX); }))) {
            mixin(enumMixinStr__SC_USHRT_MAX);
        }
    }




    static if(!is(typeof(_SC_ULONG_MAX))) {
        private enum enumMixinStr__SC_ULONG_MAX = `enum _SC_ULONG_MAX = _SC_ULONG_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_ULONG_MAX); }))) {
            mixin(enumMixinStr__SC_ULONG_MAX);
        }
    }




    static if(!is(typeof(_SC_UINT_MAX))) {
        private enum enumMixinStr__SC_UINT_MAX = `enum _SC_UINT_MAX = _SC_UINT_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_UINT_MAX); }))) {
            mixin(enumMixinStr__SC_UINT_MAX);
        }
    }




    static if(!is(typeof(_SC_UCHAR_MAX))) {
        private enum enumMixinStr__SC_UCHAR_MAX = `enum _SC_UCHAR_MAX = _SC_UCHAR_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_UCHAR_MAX); }))) {
            mixin(enumMixinStr__SC_UCHAR_MAX);
        }
    }




    static if(!is(typeof(_SC_SHRT_MIN))) {
        private enum enumMixinStr__SC_SHRT_MIN = `enum _SC_SHRT_MIN = _SC_SHRT_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SHRT_MIN); }))) {
            mixin(enumMixinStr__SC_SHRT_MIN);
        }
    }




    static if(!is(typeof(_SC_SHRT_MAX))) {
        private enum enumMixinStr__SC_SHRT_MAX = `enum _SC_SHRT_MAX = _SC_SHRT_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SHRT_MAX); }))) {
            mixin(enumMixinStr__SC_SHRT_MAX);
        }
    }




    static if(!is(typeof(_SC_SCHAR_MIN))) {
        private enum enumMixinStr__SC_SCHAR_MIN = `enum _SC_SCHAR_MIN = _SC_SCHAR_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SCHAR_MIN); }))) {
            mixin(enumMixinStr__SC_SCHAR_MIN);
        }
    }




    static if(!is(typeof(_SC_SCHAR_MAX))) {
        private enum enumMixinStr__SC_SCHAR_MAX = `enum _SC_SCHAR_MAX = _SC_SCHAR_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SCHAR_MAX); }))) {
            mixin(enumMixinStr__SC_SCHAR_MAX);
        }
    }




    static if(!is(typeof(_SC_SSIZE_MAX))) {
        private enum enumMixinStr__SC_SSIZE_MAX = `enum _SC_SSIZE_MAX = _SC_SSIZE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SSIZE_MAX); }))) {
            mixin(enumMixinStr__SC_SSIZE_MAX);
        }
    }




    static if(!is(typeof(_SC_NZERO))) {
        private enum enumMixinStr__SC_NZERO = `enum _SC_NZERO = _SC_NZERO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NZERO); }))) {
            mixin(enumMixinStr__SC_NZERO);
        }
    }




    static if(!is(typeof(_SC_MB_LEN_MAX))) {
        private enum enumMixinStr__SC_MB_LEN_MAX = `enum _SC_MB_LEN_MAX = _SC_MB_LEN_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MB_LEN_MAX); }))) {
            mixin(enumMixinStr__SC_MB_LEN_MAX);
        }
    }




    static if(!is(typeof(_SC_WORD_BIT))) {
        private enum enumMixinStr__SC_WORD_BIT = `enum _SC_WORD_BIT = _SC_WORD_BIT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_WORD_BIT); }))) {
            mixin(enumMixinStr__SC_WORD_BIT);
        }
    }




    static if(!is(typeof(_SC_LONG_BIT))) {
        private enum enumMixinStr__SC_LONG_BIT = `enum _SC_LONG_BIT = _SC_LONG_BIT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LONG_BIT); }))) {
            mixin(enumMixinStr__SC_LONG_BIT);
        }
    }




    static if(!is(typeof(_SC_INT_MIN))) {
        private enum enumMixinStr__SC_INT_MIN = `enum _SC_INT_MIN = _SC_INT_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_INT_MIN); }))) {
            mixin(enumMixinStr__SC_INT_MIN);
        }
    }




    static if(!is(typeof(_SC_INT_MAX))) {
        private enum enumMixinStr__SC_INT_MAX = `enum _SC_INT_MAX = _SC_INT_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_INT_MAX); }))) {
            mixin(enumMixinStr__SC_INT_MAX);
        }
    }




    static if(!is(typeof(_SC_CHAR_MIN))) {
        private enum enumMixinStr__SC_CHAR_MIN = `enum _SC_CHAR_MIN = _SC_CHAR_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CHAR_MIN); }))) {
            mixin(enumMixinStr__SC_CHAR_MIN);
        }
    }




    static if(!is(typeof(_SC_CHAR_MAX))) {
        private enum enumMixinStr__SC_CHAR_MAX = `enum _SC_CHAR_MAX = _SC_CHAR_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CHAR_MAX); }))) {
            mixin(enumMixinStr__SC_CHAR_MAX);
        }
    }




    static if(!is(typeof(_SC_CHAR_BIT))) {
        private enum enumMixinStr__SC_CHAR_BIT = `enum _SC_CHAR_BIT = _SC_CHAR_BIT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CHAR_BIT); }))) {
            mixin(enumMixinStr__SC_CHAR_BIT);
        }
    }




    static if(!is(typeof(_SC_XOPEN_XPG4))) {
        private enum enumMixinStr__SC_XOPEN_XPG4 = `enum _SC_XOPEN_XPG4 = _SC_XOPEN_XPG4;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_XPG4); }))) {
            mixin(enumMixinStr__SC_XOPEN_XPG4);
        }
    }




    static if(!is(typeof(_SC_XOPEN_XPG3))) {
        private enum enumMixinStr__SC_XOPEN_XPG3 = `enum _SC_XOPEN_XPG3 = _SC_XOPEN_XPG3;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_XPG3); }))) {
            mixin(enumMixinStr__SC_XOPEN_XPG3);
        }
    }




    static if(!is(typeof(_SC_XOPEN_XPG2))) {
        private enum enumMixinStr__SC_XOPEN_XPG2 = `enum _SC_XOPEN_XPG2 = _SC_XOPEN_XPG2;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_XPG2); }))) {
            mixin(enumMixinStr__SC_XOPEN_XPG2);
        }
    }




    static if(!is(typeof(_SC_2_UPE))) {
        private enum enumMixinStr__SC_2_UPE = `enum _SC_2_UPE = _SC_2_UPE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_UPE); }))) {
            mixin(enumMixinStr__SC_2_UPE);
        }
    }




    static if(!is(typeof(_SC_2_C_VERSION))) {
        private enum enumMixinStr__SC_2_C_VERSION = `enum _SC_2_C_VERSION = _SC_2_C_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_C_VERSION); }))) {
            mixin(enumMixinStr__SC_2_C_VERSION);
        }
    }




    static if(!is(typeof(_SC_2_CHAR_TERM))) {
        private enum enumMixinStr__SC_2_CHAR_TERM = `enum _SC_2_CHAR_TERM = _SC_2_CHAR_TERM;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_CHAR_TERM); }))) {
            mixin(enumMixinStr__SC_2_CHAR_TERM);
        }
    }




    static if(!is(typeof(_SC_XOPEN_SHM))) {
        private enum enumMixinStr__SC_XOPEN_SHM = `enum _SC_XOPEN_SHM = _SC_XOPEN_SHM;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_SHM); }))) {
            mixin(enumMixinStr__SC_XOPEN_SHM);
        }
    }




    static if(!is(typeof(_SC_XOPEN_ENH_I18N))) {
        private enum enumMixinStr__SC_XOPEN_ENH_I18N = `enum _SC_XOPEN_ENH_I18N = _SC_XOPEN_ENH_I18N;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_ENH_I18N); }))) {
            mixin(enumMixinStr__SC_XOPEN_ENH_I18N);
        }
    }




    static if(!is(typeof(_SC_XOPEN_CRYPT))) {
        private enum enumMixinStr__SC_XOPEN_CRYPT = `enum _SC_XOPEN_CRYPT = _SC_XOPEN_CRYPT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_CRYPT); }))) {
            mixin(enumMixinStr__SC_XOPEN_CRYPT);
        }
    }




    static if(!is(typeof(_SC_XOPEN_UNIX))) {
        private enum enumMixinStr__SC_XOPEN_UNIX = `enum _SC_XOPEN_UNIX = _SC_XOPEN_UNIX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_UNIX); }))) {
            mixin(enumMixinStr__SC_XOPEN_UNIX);
        }
    }




    static if(!is(typeof(_SC_XOPEN_XCU_VERSION))) {
        private enum enumMixinStr__SC_XOPEN_XCU_VERSION = `enum _SC_XOPEN_XCU_VERSION = _SC_XOPEN_XCU_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_XCU_VERSION); }))) {
            mixin(enumMixinStr__SC_XOPEN_XCU_VERSION);
        }
    }




    static if(!is(typeof(_SC_XOPEN_VERSION))) {
        private enum enumMixinStr__SC_XOPEN_VERSION = `enum _SC_XOPEN_VERSION = _SC_XOPEN_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_VERSION); }))) {
            mixin(enumMixinStr__SC_XOPEN_VERSION);
        }
    }




    static if(!is(typeof(_SC_PASS_MAX))) {
        private enum enumMixinStr__SC_PASS_MAX = `enum _SC_PASS_MAX = _SC_PASS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PASS_MAX); }))) {
            mixin(enumMixinStr__SC_PASS_MAX);
        }
    }




    static if(!is(typeof(_SC_ATEXIT_MAX))) {
        private enum enumMixinStr__SC_ATEXIT_MAX = `enum _SC_ATEXIT_MAX = _SC_ATEXIT_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_ATEXIT_MAX); }))) {
            mixin(enumMixinStr__SC_ATEXIT_MAX);
        }
    }




    static if(!is(typeof(_SC_AVPHYS_PAGES))) {
        private enum enumMixinStr__SC_AVPHYS_PAGES = `enum _SC_AVPHYS_PAGES = _SC_AVPHYS_PAGES;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_AVPHYS_PAGES); }))) {
            mixin(enumMixinStr__SC_AVPHYS_PAGES);
        }
    }




    static if(!is(typeof(_SC_PHYS_PAGES))) {
        private enum enumMixinStr__SC_PHYS_PAGES = `enum _SC_PHYS_PAGES = _SC_PHYS_PAGES;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PHYS_PAGES); }))) {
            mixin(enumMixinStr__SC_PHYS_PAGES);
        }
    }




    static if(!is(typeof(_SC_NPROCESSORS_ONLN))) {
        private enum enumMixinStr__SC_NPROCESSORS_ONLN = `enum _SC_NPROCESSORS_ONLN = _SC_NPROCESSORS_ONLN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NPROCESSORS_ONLN); }))) {
            mixin(enumMixinStr__SC_NPROCESSORS_ONLN);
        }
    }




    static if(!is(typeof(_SC_NPROCESSORS_CONF))) {
        private enum enumMixinStr__SC_NPROCESSORS_CONF = `enum _SC_NPROCESSORS_CONF = _SC_NPROCESSORS_CONF;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NPROCESSORS_CONF); }))) {
            mixin(enumMixinStr__SC_NPROCESSORS_CONF);
        }
    }




    static if(!is(typeof(_SC_THREAD_PROCESS_SHARED))) {
        private enum enumMixinStr__SC_THREAD_PROCESS_SHARED = `enum _SC_THREAD_PROCESS_SHARED = _SC_THREAD_PROCESS_SHARED;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_PROCESS_SHARED); }))) {
            mixin(enumMixinStr__SC_THREAD_PROCESS_SHARED);
        }
    }




    static if(!is(typeof(_SC_THREAD_PRIO_PROTECT))) {
        private enum enumMixinStr__SC_THREAD_PRIO_PROTECT = `enum _SC_THREAD_PRIO_PROTECT = _SC_THREAD_PRIO_PROTECT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_PRIO_PROTECT); }))) {
            mixin(enumMixinStr__SC_THREAD_PRIO_PROTECT);
        }
    }




    static if(!is(typeof(_SC_THREAD_PRIO_INHERIT))) {
        private enum enumMixinStr__SC_THREAD_PRIO_INHERIT = `enum _SC_THREAD_PRIO_INHERIT = _SC_THREAD_PRIO_INHERIT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_PRIO_INHERIT); }))) {
            mixin(enumMixinStr__SC_THREAD_PRIO_INHERIT);
        }
    }




    static if(!is(typeof(_SC_THREAD_PRIORITY_SCHEDULING))) {
        private enum enumMixinStr__SC_THREAD_PRIORITY_SCHEDULING = `enum _SC_THREAD_PRIORITY_SCHEDULING = _SC_THREAD_PRIORITY_SCHEDULING;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_PRIORITY_SCHEDULING); }))) {
            mixin(enumMixinStr__SC_THREAD_PRIORITY_SCHEDULING);
        }
    }




    static if(!is(typeof(_SC_THREAD_ATTR_STACKSIZE))) {
        private enum enumMixinStr__SC_THREAD_ATTR_STACKSIZE = `enum _SC_THREAD_ATTR_STACKSIZE = _SC_THREAD_ATTR_STACKSIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_ATTR_STACKSIZE); }))) {
            mixin(enumMixinStr__SC_THREAD_ATTR_STACKSIZE);
        }
    }




    static if(!is(typeof(_SC_THREAD_ATTR_STACKADDR))) {
        private enum enumMixinStr__SC_THREAD_ATTR_STACKADDR = `enum _SC_THREAD_ATTR_STACKADDR = _SC_THREAD_ATTR_STACKADDR;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_ATTR_STACKADDR); }))) {
            mixin(enumMixinStr__SC_THREAD_ATTR_STACKADDR);
        }
    }




    static if(!is(typeof(_SC_THREAD_THREADS_MAX))) {
        private enum enumMixinStr__SC_THREAD_THREADS_MAX = `enum _SC_THREAD_THREADS_MAX = _SC_THREAD_THREADS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_THREADS_MAX); }))) {
            mixin(enumMixinStr__SC_THREAD_THREADS_MAX);
        }
    }




    static if(!is(typeof(_SC_THREAD_STACK_MIN))) {
        private enum enumMixinStr__SC_THREAD_STACK_MIN = `enum _SC_THREAD_STACK_MIN = _SC_THREAD_STACK_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_STACK_MIN); }))) {
            mixin(enumMixinStr__SC_THREAD_STACK_MIN);
        }
    }




    static if(!is(typeof(_SC_THREAD_KEYS_MAX))) {
        private enum enumMixinStr__SC_THREAD_KEYS_MAX = `enum _SC_THREAD_KEYS_MAX = _SC_THREAD_KEYS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_KEYS_MAX); }))) {
            mixin(enumMixinStr__SC_THREAD_KEYS_MAX);
        }
    }




    static if(!is(typeof(_SC_THREAD_DESTRUCTOR_ITERATIONS))) {
        private enum enumMixinStr__SC_THREAD_DESTRUCTOR_ITERATIONS = `enum _SC_THREAD_DESTRUCTOR_ITERATIONS = _SC_THREAD_DESTRUCTOR_ITERATIONS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_DESTRUCTOR_ITERATIONS); }))) {
            mixin(enumMixinStr__SC_THREAD_DESTRUCTOR_ITERATIONS);
        }
    }




    static if(!is(typeof(_SC_TTY_NAME_MAX))) {
        private enum enumMixinStr__SC_TTY_NAME_MAX = `enum _SC_TTY_NAME_MAX = _SC_TTY_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TTY_NAME_MAX); }))) {
            mixin(enumMixinStr__SC_TTY_NAME_MAX);
        }
    }




    static if(!is(typeof(_SC_LOGIN_NAME_MAX))) {
        private enum enumMixinStr__SC_LOGIN_NAME_MAX = `enum _SC_LOGIN_NAME_MAX = _SC_LOGIN_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LOGIN_NAME_MAX); }))) {
            mixin(enumMixinStr__SC_LOGIN_NAME_MAX);
        }
    }




    static if(!is(typeof(_SC_GETPW_R_SIZE_MAX))) {
        private enum enumMixinStr__SC_GETPW_R_SIZE_MAX = `enum _SC_GETPW_R_SIZE_MAX = _SC_GETPW_R_SIZE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_GETPW_R_SIZE_MAX); }))) {
            mixin(enumMixinStr__SC_GETPW_R_SIZE_MAX);
        }
    }




    static if(!is(typeof(_SC_GETGR_R_SIZE_MAX))) {
        private enum enumMixinStr__SC_GETGR_R_SIZE_MAX = `enum _SC_GETGR_R_SIZE_MAX = _SC_GETGR_R_SIZE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_GETGR_R_SIZE_MAX); }))) {
            mixin(enumMixinStr__SC_GETGR_R_SIZE_MAX);
        }
    }




    static if(!is(typeof(_SC_THREAD_SAFE_FUNCTIONS))) {
        private enum enumMixinStr__SC_THREAD_SAFE_FUNCTIONS = `enum _SC_THREAD_SAFE_FUNCTIONS = _SC_THREAD_SAFE_FUNCTIONS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_SAFE_FUNCTIONS); }))) {
            mixin(enumMixinStr__SC_THREAD_SAFE_FUNCTIONS);
        }
    }




    static if(!is(typeof(_SC_THREADS))) {
        private enum enumMixinStr__SC_THREADS = `enum _SC_THREADS = _SC_THREADS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREADS); }))) {
            mixin(enumMixinStr__SC_THREADS);
        }
    }




    static if(!is(typeof(_SC_T_IOV_MAX))) {
        private enum enumMixinStr__SC_T_IOV_MAX = `enum _SC_T_IOV_MAX = _SC_T_IOV_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_T_IOV_MAX); }))) {
            mixin(enumMixinStr__SC_T_IOV_MAX);
        }
    }




    static if(!is(typeof(_SC_PII_OSI_M))) {
        private enum enumMixinStr__SC_PII_OSI_M = `enum _SC_PII_OSI_M = _SC_PII_OSI_M;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_OSI_M); }))) {
            mixin(enumMixinStr__SC_PII_OSI_M);
        }
    }




    static if(!is(typeof(_SC_PII_OSI_CLTS))) {
        private enum enumMixinStr__SC_PII_OSI_CLTS = `enum _SC_PII_OSI_CLTS = _SC_PII_OSI_CLTS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_OSI_CLTS); }))) {
            mixin(enumMixinStr__SC_PII_OSI_CLTS);
        }
    }




    static if(!is(typeof(_SC_PII_OSI_COTS))) {
        private enum enumMixinStr__SC_PII_OSI_COTS = `enum _SC_PII_OSI_COTS = _SC_PII_OSI_COTS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_OSI_COTS); }))) {
            mixin(enumMixinStr__SC_PII_OSI_COTS);
        }
    }




    static if(!is(typeof(_SC_PII_INTERNET_DGRAM))) {
        private enum enumMixinStr__SC_PII_INTERNET_DGRAM = `enum _SC_PII_INTERNET_DGRAM = _SC_PII_INTERNET_DGRAM;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_INTERNET_DGRAM); }))) {
            mixin(enumMixinStr__SC_PII_INTERNET_DGRAM);
        }
    }




    static if(!is(typeof(_SC_PII_INTERNET_STREAM))) {
        private enum enumMixinStr__SC_PII_INTERNET_STREAM = `enum _SC_PII_INTERNET_STREAM = _SC_PII_INTERNET_STREAM;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_INTERNET_STREAM); }))) {
            mixin(enumMixinStr__SC_PII_INTERNET_STREAM);
        }
    }




    static if(!is(typeof(_SC_IOV_MAX))) {
        private enum enumMixinStr__SC_IOV_MAX = `enum _SC_IOV_MAX = _SC_IOV_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_IOV_MAX); }))) {
            mixin(enumMixinStr__SC_IOV_MAX);
        }
    }




    static if(!is(typeof(_SC_UIO_MAXIOV))) {
        private enum enumMixinStr__SC_UIO_MAXIOV = `enum _SC_UIO_MAXIOV = _SC_UIO_MAXIOV;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_UIO_MAXIOV); }))) {
            mixin(enumMixinStr__SC_UIO_MAXIOV);
        }
    }




    static if(!is(typeof(_SC_SELECT))) {
        private enum enumMixinStr__SC_SELECT = `enum _SC_SELECT = _SC_SELECT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SELECT); }))) {
            mixin(enumMixinStr__SC_SELECT);
        }
    }




    static if(!is(typeof(_SC_POLL))) {
        private enum enumMixinStr__SC_POLL = `enum _SC_POLL = _SC_POLL;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_POLL); }))) {
            mixin(enumMixinStr__SC_POLL);
        }
    }




    static if(!is(typeof(_SC_PII_OSI))) {
        private enum enumMixinStr__SC_PII_OSI = `enum _SC_PII_OSI = _SC_PII_OSI;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_OSI); }))) {
            mixin(enumMixinStr__SC_PII_OSI);
        }
    }




    static if(!is(typeof(_SC_PII_INTERNET))) {
        private enum enumMixinStr__SC_PII_INTERNET = `enum _SC_PII_INTERNET = _SC_PII_INTERNET;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_INTERNET); }))) {
            mixin(enumMixinStr__SC_PII_INTERNET);
        }
    }




    static if(!is(typeof(_SC_PII_SOCKET))) {
        private enum enumMixinStr__SC_PII_SOCKET = `enum _SC_PII_SOCKET = _SC_PII_SOCKET;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_SOCKET); }))) {
            mixin(enumMixinStr__SC_PII_SOCKET);
        }
    }




    static if(!is(typeof(_SC_PII_XTI))) {
        private enum enumMixinStr__SC_PII_XTI = `enum _SC_PII_XTI = _SC_PII_XTI;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_XTI); }))) {
            mixin(enumMixinStr__SC_PII_XTI);
        }
    }




    static if(!is(typeof(_SC_PII))) {
        private enum enumMixinStr__SC_PII = `enum _SC_PII = _SC_PII;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII); }))) {
            mixin(enumMixinStr__SC_PII);
        }
    }




    static if(!is(typeof(_SC_2_LOCALEDEF))) {
        private enum enumMixinStr__SC_2_LOCALEDEF = `enum _SC_2_LOCALEDEF = _SC_2_LOCALEDEF;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_LOCALEDEF); }))) {
            mixin(enumMixinStr__SC_2_LOCALEDEF);
        }
    }




    static if(!is(typeof(_SC_2_SW_DEV))) {
        private enum enumMixinStr__SC_2_SW_DEV = `enum _SC_2_SW_DEV = _SC_2_SW_DEV;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_SW_DEV); }))) {
            mixin(enumMixinStr__SC_2_SW_DEV);
        }
    }




    static if(!is(typeof(_SC_2_FORT_RUN))) {
        private enum enumMixinStr__SC_2_FORT_RUN = `enum _SC_2_FORT_RUN = _SC_2_FORT_RUN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_FORT_RUN); }))) {
            mixin(enumMixinStr__SC_2_FORT_RUN);
        }
    }




    static if(!is(typeof(_SC_2_FORT_DEV))) {
        private enum enumMixinStr__SC_2_FORT_DEV = `enum _SC_2_FORT_DEV = _SC_2_FORT_DEV;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_FORT_DEV); }))) {
            mixin(enumMixinStr__SC_2_FORT_DEV);
        }
    }




    static if(!is(typeof(_SC_2_C_DEV))) {
        private enum enumMixinStr__SC_2_C_DEV = `enum _SC_2_C_DEV = _SC_2_C_DEV;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_C_DEV); }))) {
            mixin(enumMixinStr__SC_2_C_DEV);
        }
    }




    static if(!is(typeof(_SC_2_C_BIND))) {
        private enum enumMixinStr__SC_2_C_BIND = `enum _SC_2_C_BIND = _SC_2_C_BIND;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_C_BIND); }))) {
            mixin(enumMixinStr__SC_2_C_BIND);
        }
    }




    static if(!is(typeof(_SC_2_VERSION))) {
        private enum enumMixinStr__SC_2_VERSION = `enum _SC_2_VERSION = _SC_2_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_VERSION); }))) {
            mixin(enumMixinStr__SC_2_VERSION);
        }
    }




    static if(!is(typeof(_SC_CHARCLASS_NAME_MAX))) {
        private enum enumMixinStr__SC_CHARCLASS_NAME_MAX = `enum _SC_CHARCLASS_NAME_MAX = _SC_CHARCLASS_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CHARCLASS_NAME_MAX); }))) {
            mixin(enumMixinStr__SC_CHARCLASS_NAME_MAX);
        }
    }




    static if(!is(typeof(_SC_RE_DUP_MAX))) {
        private enum enumMixinStr__SC_RE_DUP_MAX = `enum _SC_RE_DUP_MAX = _SC_RE_DUP_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_RE_DUP_MAX); }))) {
            mixin(enumMixinStr__SC_RE_DUP_MAX);
        }
    }




    static if(!is(typeof(_SC_LINE_MAX))) {
        private enum enumMixinStr__SC_LINE_MAX = `enum _SC_LINE_MAX = _SC_LINE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LINE_MAX); }))) {
            mixin(enumMixinStr__SC_LINE_MAX);
        }
    }




    static if(!is(typeof(_SC_EXPR_NEST_MAX))) {
        private enum enumMixinStr__SC_EXPR_NEST_MAX = `enum _SC_EXPR_NEST_MAX = _SC_EXPR_NEST_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_EXPR_NEST_MAX); }))) {
            mixin(enumMixinStr__SC_EXPR_NEST_MAX);
        }
    }




    static if(!is(typeof(_SC_EQUIV_CLASS_MAX))) {
        private enum enumMixinStr__SC_EQUIV_CLASS_MAX = `enum _SC_EQUIV_CLASS_MAX = _SC_EQUIV_CLASS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_EQUIV_CLASS_MAX); }))) {
            mixin(enumMixinStr__SC_EQUIV_CLASS_MAX);
        }
    }




    static if(!is(typeof(_SC_COLL_WEIGHTS_MAX))) {
        private enum enumMixinStr__SC_COLL_WEIGHTS_MAX = `enum _SC_COLL_WEIGHTS_MAX = _SC_COLL_WEIGHTS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_COLL_WEIGHTS_MAX); }))) {
            mixin(enumMixinStr__SC_COLL_WEIGHTS_MAX);
        }
    }




    static if(!is(typeof(_SC_BC_STRING_MAX))) {
        private enum enumMixinStr__SC_BC_STRING_MAX = `enum _SC_BC_STRING_MAX = _SC_BC_STRING_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_BC_STRING_MAX); }))) {
            mixin(enumMixinStr__SC_BC_STRING_MAX);
        }
    }




    static if(!is(typeof(_SC_BC_SCALE_MAX))) {
        private enum enumMixinStr__SC_BC_SCALE_MAX = `enum _SC_BC_SCALE_MAX = _SC_BC_SCALE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_BC_SCALE_MAX); }))) {
            mixin(enumMixinStr__SC_BC_SCALE_MAX);
        }
    }




    static if(!is(typeof(_SC_BC_DIM_MAX))) {
        private enum enumMixinStr__SC_BC_DIM_MAX = `enum _SC_BC_DIM_MAX = _SC_BC_DIM_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_BC_DIM_MAX); }))) {
            mixin(enumMixinStr__SC_BC_DIM_MAX);
        }
    }




    static if(!is(typeof(_SC_BC_BASE_MAX))) {
        private enum enumMixinStr__SC_BC_BASE_MAX = `enum _SC_BC_BASE_MAX = _SC_BC_BASE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_BC_BASE_MAX); }))) {
            mixin(enumMixinStr__SC_BC_BASE_MAX);
        }
    }




    static if(!is(typeof(_SC_TIMER_MAX))) {
        private enum enumMixinStr__SC_TIMER_MAX = `enum _SC_TIMER_MAX = _SC_TIMER_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TIMER_MAX); }))) {
            mixin(enumMixinStr__SC_TIMER_MAX);
        }
    }




    static if(!is(typeof(_SC_SIGQUEUE_MAX))) {
        private enum enumMixinStr__SC_SIGQUEUE_MAX = `enum _SC_SIGQUEUE_MAX = _SC_SIGQUEUE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SIGQUEUE_MAX); }))) {
            mixin(enumMixinStr__SC_SIGQUEUE_MAX);
        }
    }




    static if(!is(typeof(_SC_SEM_VALUE_MAX))) {
        private enum enumMixinStr__SC_SEM_VALUE_MAX = `enum _SC_SEM_VALUE_MAX = _SC_SEM_VALUE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SEM_VALUE_MAX); }))) {
            mixin(enumMixinStr__SC_SEM_VALUE_MAX);
        }
    }




    static if(!is(typeof(_SC_SEM_NSEMS_MAX))) {
        private enum enumMixinStr__SC_SEM_NSEMS_MAX = `enum _SC_SEM_NSEMS_MAX = _SC_SEM_NSEMS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SEM_NSEMS_MAX); }))) {
            mixin(enumMixinStr__SC_SEM_NSEMS_MAX);
        }
    }




    static if(!is(typeof(_SC_RTSIG_MAX))) {
        private enum enumMixinStr__SC_RTSIG_MAX = `enum _SC_RTSIG_MAX = _SC_RTSIG_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_RTSIG_MAX); }))) {
            mixin(enumMixinStr__SC_RTSIG_MAX);
        }
    }




    static if(!is(typeof(_SC_PAGE_SIZE))) {
        private enum enumMixinStr__SC_PAGE_SIZE = `enum _SC_PAGE_SIZE = _SC_PAGESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PAGE_SIZE); }))) {
            mixin(enumMixinStr__SC_PAGE_SIZE);
        }
    }




    static if(!is(typeof(_SC_PAGESIZE))) {
        private enum enumMixinStr__SC_PAGESIZE = `enum _SC_PAGESIZE = _SC_PAGESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PAGESIZE); }))) {
            mixin(enumMixinStr__SC_PAGESIZE);
        }
    }




    static if(!is(typeof(_SC_VERSION))) {
        private enum enumMixinStr__SC_VERSION = `enum _SC_VERSION = _SC_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_VERSION); }))) {
            mixin(enumMixinStr__SC_VERSION);
        }
    }




    static if(!is(typeof(_SC_MQ_PRIO_MAX))) {
        private enum enumMixinStr__SC_MQ_PRIO_MAX = `enum _SC_MQ_PRIO_MAX = _SC_MQ_PRIO_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MQ_PRIO_MAX); }))) {
            mixin(enumMixinStr__SC_MQ_PRIO_MAX);
        }
    }




    static if(!is(typeof(_SC_MQ_OPEN_MAX))) {
        private enum enumMixinStr__SC_MQ_OPEN_MAX = `enum _SC_MQ_OPEN_MAX = _SC_MQ_OPEN_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MQ_OPEN_MAX); }))) {
            mixin(enumMixinStr__SC_MQ_OPEN_MAX);
        }
    }




    static if(!is(typeof(_SC_DELAYTIMER_MAX))) {
        private enum enumMixinStr__SC_DELAYTIMER_MAX = `enum _SC_DELAYTIMER_MAX = _SC_DELAYTIMER_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_DELAYTIMER_MAX); }))) {
            mixin(enumMixinStr__SC_DELAYTIMER_MAX);
        }
    }




    static if(!is(typeof(_SC_AIO_PRIO_DELTA_MAX))) {
        private enum enumMixinStr__SC_AIO_PRIO_DELTA_MAX = `enum _SC_AIO_PRIO_DELTA_MAX = _SC_AIO_PRIO_DELTA_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_AIO_PRIO_DELTA_MAX); }))) {
            mixin(enumMixinStr__SC_AIO_PRIO_DELTA_MAX);
        }
    }




    static if(!is(typeof(_SC_AIO_MAX))) {
        private enum enumMixinStr__SC_AIO_MAX = `enum _SC_AIO_MAX = _SC_AIO_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_AIO_MAX); }))) {
            mixin(enumMixinStr__SC_AIO_MAX);
        }
    }




    static if(!is(typeof(_SC_AIO_LISTIO_MAX))) {
        private enum enumMixinStr__SC_AIO_LISTIO_MAX = `enum _SC_AIO_LISTIO_MAX = _SC_AIO_LISTIO_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_AIO_LISTIO_MAX); }))) {
            mixin(enumMixinStr__SC_AIO_LISTIO_MAX);
        }
    }




    static if(!is(typeof(_SC_SHARED_MEMORY_OBJECTS))) {
        private enum enumMixinStr__SC_SHARED_MEMORY_OBJECTS = `enum _SC_SHARED_MEMORY_OBJECTS = _SC_SHARED_MEMORY_OBJECTS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SHARED_MEMORY_OBJECTS); }))) {
            mixin(enumMixinStr__SC_SHARED_MEMORY_OBJECTS);
        }
    }




    static if(!is(typeof(_SC_SEMAPHORES))) {
        private enum enumMixinStr__SC_SEMAPHORES = `enum _SC_SEMAPHORES = _SC_SEMAPHORES;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SEMAPHORES); }))) {
            mixin(enumMixinStr__SC_SEMAPHORES);
        }
    }




    static if(!is(typeof(_SC_MESSAGE_PASSING))) {
        private enum enumMixinStr__SC_MESSAGE_PASSING = `enum _SC_MESSAGE_PASSING = _SC_MESSAGE_PASSING;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MESSAGE_PASSING); }))) {
            mixin(enumMixinStr__SC_MESSAGE_PASSING);
        }
    }




    static if(!is(typeof(_SC_MEMORY_PROTECTION))) {
        private enum enumMixinStr__SC_MEMORY_PROTECTION = `enum _SC_MEMORY_PROTECTION = _SC_MEMORY_PROTECTION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MEMORY_PROTECTION); }))) {
            mixin(enumMixinStr__SC_MEMORY_PROTECTION);
        }
    }




    static if(!is(typeof(_SC_MEMLOCK_RANGE))) {
        private enum enumMixinStr__SC_MEMLOCK_RANGE = `enum _SC_MEMLOCK_RANGE = _SC_MEMLOCK_RANGE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MEMLOCK_RANGE); }))) {
            mixin(enumMixinStr__SC_MEMLOCK_RANGE);
        }
    }




    static if(!is(typeof(_SC_MEMLOCK))) {
        private enum enumMixinStr__SC_MEMLOCK = `enum _SC_MEMLOCK = _SC_MEMLOCK;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MEMLOCK); }))) {
            mixin(enumMixinStr__SC_MEMLOCK);
        }
    }




    static if(!is(typeof(_SC_MAPPED_FILES))) {
        private enum enumMixinStr__SC_MAPPED_FILES = `enum _SC_MAPPED_FILES = _SC_MAPPED_FILES;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MAPPED_FILES); }))) {
            mixin(enumMixinStr__SC_MAPPED_FILES);
        }
    }




    static if(!is(typeof(_SC_FSYNC))) {
        private enum enumMixinStr__SC_FSYNC = `enum _SC_FSYNC = _SC_FSYNC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_FSYNC); }))) {
            mixin(enumMixinStr__SC_FSYNC);
        }
    }




    static if(!is(typeof(_SC_SYNCHRONIZED_IO))) {
        private enum enumMixinStr__SC_SYNCHRONIZED_IO = `enum _SC_SYNCHRONIZED_IO = _SC_SYNCHRONIZED_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SYNCHRONIZED_IO); }))) {
            mixin(enumMixinStr__SC_SYNCHRONIZED_IO);
        }
    }




    static if(!is(typeof(_SC_PRIORITIZED_IO))) {
        private enum enumMixinStr__SC_PRIORITIZED_IO = `enum _SC_PRIORITIZED_IO = _SC_PRIORITIZED_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PRIORITIZED_IO); }))) {
            mixin(enumMixinStr__SC_PRIORITIZED_IO);
        }
    }




    static if(!is(typeof(_SC_ASYNCHRONOUS_IO))) {
        private enum enumMixinStr__SC_ASYNCHRONOUS_IO = `enum _SC_ASYNCHRONOUS_IO = _SC_ASYNCHRONOUS_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_ASYNCHRONOUS_IO); }))) {
            mixin(enumMixinStr__SC_ASYNCHRONOUS_IO);
        }
    }




    static if(!is(typeof(_SC_TIMERS))) {
        private enum enumMixinStr__SC_TIMERS = `enum _SC_TIMERS = _SC_TIMERS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TIMERS); }))) {
            mixin(enumMixinStr__SC_TIMERS);
        }
    }




    static if(!is(typeof(_SC_PRIORITY_SCHEDULING))) {
        private enum enumMixinStr__SC_PRIORITY_SCHEDULING = `enum _SC_PRIORITY_SCHEDULING = _SC_PRIORITY_SCHEDULING;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PRIORITY_SCHEDULING); }))) {
            mixin(enumMixinStr__SC_PRIORITY_SCHEDULING);
        }
    }




    static if(!is(typeof(_SC_REALTIME_SIGNALS))) {
        private enum enumMixinStr__SC_REALTIME_SIGNALS = `enum _SC_REALTIME_SIGNALS = _SC_REALTIME_SIGNALS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_REALTIME_SIGNALS); }))) {
            mixin(enumMixinStr__SC_REALTIME_SIGNALS);
        }
    }




    static if(!is(typeof(_SC_SAVED_IDS))) {
        private enum enumMixinStr__SC_SAVED_IDS = `enum _SC_SAVED_IDS = _SC_SAVED_IDS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SAVED_IDS); }))) {
            mixin(enumMixinStr__SC_SAVED_IDS);
        }
    }




    static if(!is(typeof(_SC_JOB_CONTROL))) {
        private enum enumMixinStr__SC_JOB_CONTROL = `enum _SC_JOB_CONTROL = _SC_JOB_CONTROL;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_JOB_CONTROL); }))) {
            mixin(enumMixinStr__SC_JOB_CONTROL);
        }
    }




    static if(!is(typeof(_SC_TZNAME_MAX))) {
        private enum enumMixinStr__SC_TZNAME_MAX = `enum _SC_TZNAME_MAX = _SC_TZNAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TZNAME_MAX); }))) {
            mixin(enumMixinStr__SC_TZNAME_MAX);
        }
    }




    static if(!is(typeof(_SC_STREAM_MAX))) {
        private enum enumMixinStr__SC_STREAM_MAX = `enum _SC_STREAM_MAX = _SC_STREAM_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_STREAM_MAX); }))) {
            mixin(enumMixinStr__SC_STREAM_MAX);
        }
    }




    static if(!is(typeof(_SC_OPEN_MAX))) {
        private enum enumMixinStr__SC_OPEN_MAX = `enum _SC_OPEN_MAX = _SC_OPEN_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_OPEN_MAX); }))) {
            mixin(enumMixinStr__SC_OPEN_MAX);
        }
    }




    static if(!is(typeof(_SC_NGROUPS_MAX))) {
        private enum enumMixinStr__SC_NGROUPS_MAX = `enum _SC_NGROUPS_MAX = _SC_NGROUPS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NGROUPS_MAX); }))) {
            mixin(enumMixinStr__SC_NGROUPS_MAX);
        }
    }




    static if(!is(typeof(_SC_CLK_TCK))) {
        private enum enumMixinStr__SC_CLK_TCK = `enum _SC_CLK_TCK = _SC_CLK_TCK;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CLK_TCK); }))) {
            mixin(enumMixinStr__SC_CLK_TCK);
        }
    }




    static if(!is(typeof(_SC_CHILD_MAX))) {
        private enum enumMixinStr__SC_CHILD_MAX = `enum _SC_CHILD_MAX = _SC_CHILD_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CHILD_MAX); }))) {
            mixin(enumMixinStr__SC_CHILD_MAX);
        }
    }




    static if(!is(typeof(_SC_ARG_MAX))) {
        private enum enumMixinStr__SC_ARG_MAX = `enum _SC_ARG_MAX = _SC_ARG_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_ARG_MAX); }))) {
            mixin(enumMixinStr__SC_ARG_MAX);
        }
    }




    static if(!is(typeof(_PC_2_SYMLINKS))) {
        private enum enumMixinStr__PC_2_SYMLINKS = `enum _PC_2_SYMLINKS = _PC_2_SYMLINKS;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_2_SYMLINKS); }))) {
            mixin(enumMixinStr__PC_2_SYMLINKS);
        }
    }




    static if(!is(typeof(_PC_SYMLINK_MAX))) {
        private enum enumMixinStr__PC_SYMLINK_MAX = `enum _PC_SYMLINK_MAX = _PC_SYMLINK_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_SYMLINK_MAX); }))) {
            mixin(enumMixinStr__PC_SYMLINK_MAX);
        }
    }




    static if(!is(typeof(_PC_ALLOC_SIZE_MIN))) {
        private enum enumMixinStr__PC_ALLOC_SIZE_MIN = `enum _PC_ALLOC_SIZE_MIN = _PC_ALLOC_SIZE_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_ALLOC_SIZE_MIN); }))) {
            mixin(enumMixinStr__PC_ALLOC_SIZE_MIN);
        }
    }




    static if(!is(typeof(_PC_REC_XFER_ALIGN))) {
        private enum enumMixinStr__PC_REC_XFER_ALIGN = `enum _PC_REC_XFER_ALIGN = _PC_REC_XFER_ALIGN;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_REC_XFER_ALIGN); }))) {
            mixin(enumMixinStr__PC_REC_XFER_ALIGN);
        }
    }




    static if(!is(typeof(_PC_REC_MIN_XFER_SIZE))) {
        private enum enumMixinStr__PC_REC_MIN_XFER_SIZE = `enum _PC_REC_MIN_XFER_SIZE = _PC_REC_MIN_XFER_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_REC_MIN_XFER_SIZE); }))) {
            mixin(enumMixinStr__PC_REC_MIN_XFER_SIZE);
        }
    }




    static if(!is(typeof(_PC_REC_MAX_XFER_SIZE))) {
        private enum enumMixinStr__PC_REC_MAX_XFER_SIZE = `enum _PC_REC_MAX_XFER_SIZE = _PC_REC_MAX_XFER_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_REC_MAX_XFER_SIZE); }))) {
            mixin(enumMixinStr__PC_REC_MAX_XFER_SIZE);
        }
    }




    static if(!is(typeof(_PC_REC_INCR_XFER_SIZE))) {
        private enum enumMixinStr__PC_REC_INCR_XFER_SIZE = `enum _PC_REC_INCR_XFER_SIZE = _PC_REC_INCR_XFER_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_REC_INCR_XFER_SIZE); }))) {
            mixin(enumMixinStr__PC_REC_INCR_XFER_SIZE);
        }
    }




    static if(!is(typeof(_PC_FILESIZEBITS))) {
        private enum enumMixinStr__PC_FILESIZEBITS = `enum _PC_FILESIZEBITS = _PC_FILESIZEBITS;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_FILESIZEBITS); }))) {
            mixin(enumMixinStr__PC_FILESIZEBITS);
        }
    }




    static if(!is(typeof(_PC_SOCK_MAXBUF))) {
        private enum enumMixinStr__PC_SOCK_MAXBUF = `enum _PC_SOCK_MAXBUF = _PC_SOCK_MAXBUF;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_SOCK_MAXBUF); }))) {
            mixin(enumMixinStr__PC_SOCK_MAXBUF);
        }
    }




    static if(!is(typeof(_PC_PRIO_IO))) {
        private enum enumMixinStr__PC_PRIO_IO = `enum _PC_PRIO_IO = _PC_PRIO_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_PRIO_IO); }))) {
            mixin(enumMixinStr__PC_PRIO_IO);
        }
    }




    static if(!is(typeof(_PC_ASYNC_IO))) {
        private enum enumMixinStr__PC_ASYNC_IO = `enum _PC_ASYNC_IO = _PC_ASYNC_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_ASYNC_IO); }))) {
            mixin(enumMixinStr__PC_ASYNC_IO);
        }
    }




    static if(!is(typeof(_PC_SYNC_IO))) {
        private enum enumMixinStr__PC_SYNC_IO = `enum _PC_SYNC_IO = _PC_SYNC_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_SYNC_IO); }))) {
            mixin(enumMixinStr__PC_SYNC_IO);
        }
    }




    static if(!is(typeof(_PC_VDISABLE))) {
        private enum enumMixinStr__PC_VDISABLE = `enum _PC_VDISABLE = _PC_VDISABLE;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_VDISABLE); }))) {
            mixin(enumMixinStr__PC_VDISABLE);
        }
    }




    static if(!is(typeof(_PC_NO_TRUNC))) {
        private enum enumMixinStr__PC_NO_TRUNC = `enum _PC_NO_TRUNC = _PC_NO_TRUNC;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_NO_TRUNC); }))) {
            mixin(enumMixinStr__PC_NO_TRUNC);
        }
    }




    static if(!is(typeof(_PC_CHOWN_RESTRICTED))) {
        private enum enumMixinStr__PC_CHOWN_RESTRICTED = `enum _PC_CHOWN_RESTRICTED = _PC_CHOWN_RESTRICTED;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_CHOWN_RESTRICTED); }))) {
            mixin(enumMixinStr__PC_CHOWN_RESTRICTED);
        }
    }




    static if(!is(typeof(_PC_PIPE_BUF))) {
        private enum enumMixinStr__PC_PIPE_BUF = `enum _PC_PIPE_BUF = _PC_PIPE_BUF;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_PIPE_BUF); }))) {
            mixin(enumMixinStr__PC_PIPE_BUF);
        }
    }




    static if(!is(typeof(_PC_PATH_MAX))) {
        private enum enumMixinStr__PC_PATH_MAX = `enum _PC_PATH_MAX = _PC_PATH_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_PATH_MAX); }))) {
            mixin(enumMixinStr__PC_PATH_MAX);
        }
    }




    static if(!is(typeof(_PC_NAME_MAX))) {
        private enum enumMixinStr__PC_NAME_MAX = `enum _PC_NAME_MAX = _PC_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_NAME_MAX); }))) {
            mixin(enumMixinStr__PC_NAME_MAX);
        }
    }




    static if(!is(typeof(_PC_MAX_INPUT))) {
        private enum enumMixinStr__PC_MAX_INPUT = `enum _PC_MAX_INPUT = _PC_MAX_INPUT;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_MAX_INPUT); }))) {
            mixin(enumMixinStr__PC_MAX_INPUT);
        }
    }




    static if(!is(typeof(_PC_MAX_CANON))) {
        private enum enumMixinStr__PC_MAX_CANON = `enum _PC_MAX_CANON = _PC_MAX_CANON;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_MAX_CANON); }))) {
            mixin(enumMixinStr__PC_MAX_CANON);
        }
    }




    static if(!is(typeof(_PC_LINK_MAX))) {
        private enum enumMixinStr__PC_LINK_MAX = `enum _PC_LINK_MAX = _PC_LINK_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_LINK_MAX); }))) {
            mixin(enumMixinStr__PC_LINK_MAX);
        }
    }
    static if(!is(typeof(_BITS_BYTESWAP_H))) {
        private enum enumMixinStr__BITS_BYTESWAP_H = `enum _BITS_BYTESWAP_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_BYTESWAP_H); }))) {
            mixin(enumMixinStr__BITS_BYTESWAP_H);
        }
    }






    static if(!is(typeof(__kernel_old_dev_t))) {
        private enum enumMixinStr___kernel_old_dev_t = `enum __kernel_old_dev_t = __kernel_old_dev_t;`;
        static if(is(typeof({ mixin(enumMixinStr___kernel_old_dev_t); }))) {
            mixin(enumMixinStr___kernel_old_dev_t);
        }
    }




    static if(!is(typeof(__kernel_old_uid_t))) {
        private enum enumMixinStr___kernel_old_uid_t = `enum __kernel_old_uid_t = __kernel_old_uid_t;`;
        static if(is(typeof({ mixin(enumMixinStr___kernel_old_uid_t); }))) {
            mixin(enumMixinStr___kernel_old_uid_t);
        }
    }






    static if(!is(typeof(__BITS_PER_LONG))) {
        private enum enumMixinStr___BITS_PER_LONG = `enum __BITS_PER_LONG = 64;`;
        static if(is(typeof({ mixin(enumMixinStr___BITS_PER_LONG); }))) {
            mixin(enumMixinStr___BITS_PER_LONG);
        }
    }
    static if(!is(typeof(SIOCGSTAMPNS_OLD))) {
        private enum enumMixinStr_SIOCGSTAMPNS_OLD = `enum SIOCGSTAMPNS_OLD = 0x8907;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGSTAMPNS_OLD); }))) {
            mixin(enumMixinStr_SIOCGSTAMPNS_OLD);
        }
    }




    static if(!is(typeof(SIOCGSTAMP_OLD))) {
        private enum enumMixinStr_SIOCGSTAMP_OLD = `enum SIOCGSTAMP_OLD = 0x8906;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGSTAMP_OLD); }))) {
            mixin(enumMixinStr_SIOCGSTAMP_OLD);
        }
    }




    static if(!is(typeof(SIOCATMARK))) {
        private enum enumMixinStr_SIOCATMARK = `enum SIOCATMARK = 0x8905;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCATMARK); }))) {
            mixin(enumMixinStr_SIOCATMARK);
        }
    }




    static if(!is(typeof(SIOCGPGRP))) {
        private enum enumMixinStr_SIOCGPGRP = `enum SIOCGPGRP = 0x8904;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCGPGRP); }))) {
            mixin(enumMixinStr_SIOCGPGRP);
        }
    }




    static if(!is(typeof(FIOGETOWN))) {
        private enum enumMixinStr_FIOGETOWN = `enum FIOGETOWN = 0x8903;`;
        static if(is(typeof({ mixin(enumMixinStr_FIOGETOWN); }))) {
            mixin(enumMixinStr_FIOGETOWN);
        }
    }




    static if(!is(typeof(SIOCSPGRP))) {
        private enum enumMixinStr_SIOCSPGRP = `enum SIOCSPGRP = 0x8902;`;
        static if(is(typeof({ mixin(enumMixinStr_SIOCSPGRP); }))) {
            mixin(enumMixinStr_SIOCSPGRP);
        }
    }




    static if(!is(typeof(FIOSETOWN))) {
        private enum enumMixinStr_FIOSETOWN = `enum FIOSETOWN = 0x8901;`;
        static if(is(typeof({ mixin(enumMixinStr_FIOSETOWN); }))) {
            mixin(enumMixinStr_FIOSETOWN);
        }
    }






    static if(!is(typeof(SCM_TIMESTAMPING))) {
        private enum enumMixinStr_SCM_TIMESTAMPING = `enum SCM_TIMESTAMPING = SO_TIMESTAMPING;`;
        static if(is(typeof({ mixin(enumMixinStr_SCM_TIMESTAMPING); }))) {
            mixin(enumMixinStr_SCM_TIMESTAMPING);
        }
    }




    static if(!is(typeof(SCM_TIMESTAMPNS))) {
        private enum enumMixinStr_SCM_TIMESTAMPNS = `enum SCM_TIMESTAMPNS = SO_TIMESTAMPNS;`;
        static if(is(typeof({ mixin(enumMixinStr_SCM_TIMESTAMPNS); }))) {
            mixin(enumMixinStr_SCM_TIMESTAMPNS);
        }
    }




    static if(!is(typeof(SCM_TIMESTAMP))) {
        private enum enumMixinStr_SCM_TIMESTAMP = `enum SCM_TIMESTAMP = SO_TIMESTAMP;`;
        static if(is(typeof({ mixin(enumMixinStr_SCM_TIMESTAMP); }))) {
            mixin(enumMixinStr_SCM_TIMESTAMP);
        }
    }




    static if(!is(typeof(SO_SNDTIMEO))) {
        private enum enumMixinStr_SO_SNDTIMEO = `enum SO_SNDTIMEO = SO_SNDTIMEO_OLD;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_SNDTIMEO); }))) {
            mixin(enumMixinStr_SO_SNDTIMEO);
        }
    }




    static if(!is(typeof(SO_RCVTIMEO))) {
        private enum enumMixinStr_SO_RCVTIMEO = `enum SO_RCVTIMEO = SO_RCVTIMEO_OLD;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_RCVTIMEO); }))) {
            mixin(enumMixinStr_SO_RCVTIMEO);
        }
    }




    static if(!is(typeof(SO_TIMESTAMPING))) {
        private enum enumMixinStr_SO_TIMESTAMPING = `enum SO_TIMESTAMPING = SO_TIMESTAMPING_OLD;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_TIMESTAMPING); }))) {
            mixin(enumMixinStr_SO_TIMESTAMPING);
        }
    }




    static if(!is(typeof(SO_TIMESTAMPNS))) {
        private enum enumMixinStr_SO_TIMESTAMPNS = `enum SO_TIMESTAMPNS = SO_TIMESTAMPNS_OLD;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_TIMESTAMPNS); }))) {
            mixin(enumMixinStr_SO_TIMESTAMPNS);
        }
    }




    static if(!is(typeof(SO_TIMESTAMP))) {
        private enum enumMixinStr_SO_TIMESTAMP = `enum SO_TIMESTAMP = SO_TIMESTAMP_OLD;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_TIMESTAMP); }))) {
            mixin(enumMixinStr_SO_TIMESTAMP);
        }
    }




    static if(!is(typeof(SO_RESERVE_MEM))) {
        private enum enumMixinStr_SO_RESERVE_MEM = `enum SO_RESERVE_MEM = 73;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_RESERVE_MEM); }))) {
            mixin(enumMixinStr_SO_RESERVE_MEM);
        }
    }




    static if(!is(typeof(SO_BUF_LOCK))) {
        private enum enumMixinStr_SO_BUF_LOCK = `enum SO_BUF_LOCK = 72;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_BUF_LOCK); }))) {
            mixin(enumMixinStr_SO_BUF_LOCK);
        }
    }




    static if(!is(typeof(SO_NETNS_COOKIE))) {
        private enum enumMixinStr_SO_NETNS_COOKIE = `enum SO_NETNS_COOKIE = 71;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_NETNS_COOKIE); }))) {
            mixin(enumMixinStr_SO_NETNS_COOKIE);
        }
    }




    static if(!is(typeof(SO_BUSY_POLL_BUDGET))) {
        private enum enumMixinStr_SO_BUSY_POLL_BUDGET = `enum SO_BUSY_POLL_BUDGET = 70;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_BUSY_POLL_BUDGET); }))) {
            mixin(enumMixinStr_SO_BUSY_POLL_BUDGET);
        }
    }




    static if(!is(typeof(SO_PREFER_BUSY_POLL))) {
        private enum enumMixinStr_SO_PREFER_BUSY_POLL = `enum SO_PREFER_BUSY_POLL = 69;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_PREFER_BUSY_POLL); }))) {
            mixin(enumMixinStr_SO_PREFER_BUSY_POLL);
        }
    }




    static if(!is(typeof(SO_DETACH_REUSEPORT_BPF))) {
        private enum enumMixinStr_SO_DETACH_REUSEPORT_BPF = `enum SO_DETACH_REUSEPORT_BPF = 68;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_DETACH_REUSEPORT_BPF); }))) {
            mixin(enumMixinStr_SO_DETACH_REUSEPORT_BPF);
        }
    }




    static if(!is(typeof(SO_SNDTIMEO_NEW))) {
        private enum enumMixinStr_SO_SNDTIMEO_NEW = `enum SO_SNDTIMEO_NEW = 67;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_SNDTIMEO_NEW); }))) {
            mixin(enumMixinStr_SO_SNDTIMEO_NEW);
        }
    }




    static if(!is(typeof(SO_RCVTIMEO_NEW))) {
        private enum enumMixinStr_SO_RCVTIMEO_NEW = `enum SO_RCVTIMEO_NEW = 66;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_RCVTIMEO_NEW); }))) {
            mixin(enumMixinStr_SO_RCVTIMEO_NEW);
        }
    }




    static if(!is(typeof(SO_TIMESTAMPING_NEW))) {
        private enum enumMixinStr_SO_TIMESTAMPING_NEW = `enum SO_TIMESTAMPING_NEW = 65;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_TIMESTAMPING_NEW); }))) {
            mixin(enumMixinStr_SO_TIMESTAMPING_NEW);
        }
    }




    static if(!is(typeof(SO_TIMESTAMPNS_NEW))) {
        private enum enumMixinStr_SO_TIMESTAMPNS_NEW = `enum SO_TIMESTAMPNS_NEW = 64;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_TIMESTAMPNS_NEW); }))) {
            mixin(enumMixinStr_SO_TIMESTAMPNS_NEW);
        }
    }




    static if(!is(typeof(SO_TIMESTAMP_NEW))) {
        private enum enumMixinStr_SO_TIMESTAMP_NEW = `enum SO_TIMESTAMP_NEW = 63;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_TIMESTAMP_NEW); }))) {
            mixin(enumMixinStr_SO_TIMESTAMP_NEW);
        }
    }




    static if(!is(typeof(SO_TIMESTAMPING_OLD))) {
        private enum enumMixinStr_SO_TIMESTAMPING_OLD = `enum SO_TIMESTAMPING_OLD = 37;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_TIMESTAMPING_OLD); }))) {
            mixin(enumMixinStr_SO_TIMESTAMPING_OLD);
        }
    }




    static if(!is(typeof(SO_TIMESTAMPNS_OLD))) {
        private enum enumMixinStr_SO_TIMESTAMPNS_OLD = `enum SO_TIMESTAMPNS_OLD = 35;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_TIMESTAMPNS_OLD); }))) {
            mixin(enumMixinStr_SO_TIMESTAMPNS_OLD);
        }
    }




    static if(!is(typeof(SO_TIMESTAMP_OLD))) {
        private enum enumMixinStr_SO_TIMESTAMP_OLD = `enum SO_TIMESTAMP_OLD = 29;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_TIMESTAMP_OLD); }))) {
            mixin(enumMixinStr_SO_TIMESTAMP_OLD);
        }
    }




    static if(!is(typeof(SO_BINDTOIFINDEX))) {
        private enum enumMixinStr_SO_BINDTOIFINDEX = `enum SO_BINDTOIFINDEX = 62;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_BINDTOIFINDEX); }))) {
            mixin(enumMixinStr_SO_BINDTOIFINDEX);
        }
    }




    static if(!is(typeof(SCM_TXTIME))) {
        private enum enumMixinStr_SCM_TXTIME = `enum SCM_TXTIME = SO_TXTIME;`;
        static if(is(typeof({ mixin(enumMixinStr_SCM_TXTIME); }))) {
            mixin(enumMixinStr_SCM_TXTIME);
        }
    }




    static if(!is(typeof(SO_TXTIME))) {
        private enum enumMixinStr_SO_TXTIME = `enum SO_TXTIME = 61;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_TXTIME); }))) {
            mixin(enumMixinStr_SO_TXTIME);
        }
    }




    static if(!is(typeof(SO_ZEROCOPY))) {
        private enum enumMixinStr_SO_ZEROCOPY = `enum SO_ZEROCOPY = 60;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_ZEROCOPY); }))) {
            mixin(enumMixinStr_SO_ZEROCOPY);
        }
    }




    static if(!is(typeof(SO_PEERGROUPS))) {
        private enum enumMixinStr_SO_PEERGROUPS = `enum SO_PEERGROUPS = 59;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_PEERGROUPS); }))) {
            mixin(enumMixinStr_SO_PEERGROUPS);
        }
    }




    static if(!is(typeof(SCM_TIMESTAMPING_PKTINFO))) {
        private enum enumMixinStr_SCM_TIMESTAMPING_PKTINFO = `enum SCM_TIMESTAMPING_PKTINFO = 58;`;
        static if(is(typeof({ mixin(enumMixinStr_SCM_TIMESTAMPING_PKTINFO); }))) {
            mixin(enumMixinStr_SCM_TIMESTAMPING_PKTINFO);
        }
    }




    static if(!is(typeof(SO_COOKIE))) {
        private enum enumMixinStr_SO_COOKIE = `enum SO_COOKIE = 57;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_COOKIE); }))) {
            mixin(enumMixinStr_SO_COOKIE);
        }
    }




    static if(!is(typeof(SO_INCOMING_NAPI_ID))) {
        private enum enumMixinStr_SO_INCOMING_NAPI_ID = `enum SO_INCOMING_NAPI_ID = 56;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_INCOMING_NAPI_ID); }))) {
            mixin(enumMixinStr_SO_INCOMING_NAPI_ID);
        }
    }




    static if(!is(typeof(SO_MEMINFO))) {
        private enum enumMixinStr_SO_MEMINFO = `enum SO_MEMINFO = 55;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_MEMINFO); }))) {
            mixin(enumMixinStr_SO_MEMINFO);
        }
    }




    static if(!is(typeof(SCM_TIMESTAMPING_OPT_STATS))) {
        private enum enumMixinStr_SCM_TIMESTAMPING_OPT_STATS = `enum SCM_TIMESTAMPING_OPT_STATS = 54;`;
        static if(is(typeof({ mixin(enumMixinStr_SCM_TIMESTAMPING_OPT_STATS); }))) {
            mixin(enumMixinStr_SCM_TIMESTAMPING_OPT_STATS);
        }
    }




    static if(!is(typeof(SO_CNX_ADVICE))) {
        private enum enumMixinStr_SO_CNX_ADVICE = `enum SO_CNX_ADVICE = 53;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_CNX_ADVICE); }))) {
            mixin(enumMixinStr_SO_CNX_ADVICE);
        }
    }




    static if(!is(typeof(SO_ATTACH_REUSEPORT_EBPF))) {
        private enum enumMixinStr_SO_ATTACH_REUSEPORT_EBPF = `enum SO_ATTACH_REUSEPORT_EBPF = 52;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_ATTACH_REUSEPORT_EBPF); }))) {
            mixin(enumMixinStr_SO_ATTACH_REUSEPORT_EBPF);
        }
    }




    static if(!is(typeof(SO_ATTACH_REUSEPORT_CBPF))) {
        private enum enumMixinStr_SO_ATTACH_REUSEPORT_CBPF = `enum SO_ATTACH_REUSEPORT_CBPF = 51;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_ATTACH_REUSEPORT_CBPF); }))) {
            mixin(enumMixinStr_SO_ATTACH_REUSEPORT_CBPF);
        }
    }




    static if(!is(typeof(SO_DETACH_BPF))) {
        private enum enumMixinStr_SO_DETACH_BPF = `enum SO_DETACH_BPF = SO_DETACH_FILTER;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_DETACH_BPF); }))) {
            mixin(enumMixinStr_SO_DETACH_BPF);
        }
    }




    static if(!is(typeof(SO_ATTACH_BPF))) {
        private enum enumMixinStr_SO_ATTACH_BPF = `enum SO_ATTACH_BPF = 50;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_ATTACH_BPF); }))) {
            mixin(enumMixinStr_SO_ATTACH_BPF);
        }
    }




    static if(!is(typeof(SO_INCOMING_CPU))) {
        private enum enumMixinStr_SO_INCOMING_CPU = `enum SO_INCOMING_CPU = 49;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_INCOMING_CPU); }))) {
            mixin(enumMixinStr_SO_INCOMING_CPU);
        }
    }




    static if(!is(typeof(SO_BPF_EXTENSIONS))) {
        private enum enumMixinStr_SO_BPF_EXTENSIONS = `enum SO_BPF_EXTENSIONS = 48;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_BPF_EXTENSIONS); }))) {
            mixin(enumMixinStr_SO_BPF_EXTENSIONS);
        }
    }




    static if(!is(typeof(SO_MAX_PACING_RATE))) {
        private enum enumMixinStr_SO_MAX_PACING_RATE = `enum SO_MAX_PACING_RATE = 47;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_MAX_PACING_RATE); }))) {
            mixin(enumMixinStr_SO_MAX_PACING_RATE);
        }
    }




    static if(!is(typeof(SO_BUSY_POLL))) {
        private enum enumMixinStr_SO_BUSY_POLL = `enum SO_BUSY_POLL = 46;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_BUSY_POLL); }))) {
            mixin(enumMixinStr_SO_BUSY_POLL);
        }
    }




    static if(!is(typeof(SO_SELECT_ERR_QUEUE))) {
        private enum enumMixinStr_SO_SELECT_ERR_QUEUE = `enum SO_SELECT_ERR_QUEUE = 45;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_SELECT_ERR_QUEUE); }))) {
            mixin(enumMixinStr_SO_SELECT_ERR_QUEUE);
        }
    }




    static if(!is(typeof(SO_LOCK_FILTER))) {
        private enum enumMixinStr_SO_LOCK_FILTER = `enum SO_LOCK_FILTER = 44;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_LOCK_FILTER); }))) {
            mixin(enumMixinStr_SO_LOCK_FILTER);
        }
    }




    static if(!is(typeof(SO_NOFCS))) {
        private enum enumMixinStr_SO_NOFCS = `enum SO_NOFCS = 43;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_NOFCS); }))) {
            mixin(enumMixinStr_SO_NOFCS);
        }
    }




    static if(!is(typeof(SO_PEEK_OFF))) {
        private enum enumMixinStr_SO_PEEK_OFF = `enum SO_PEEK_OFF = 42;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_PEEK_OFF); }))) {
            mixin(enumMixinStr_SO_PEEK_OFF);
        }
    }




    static if(!is(typeof(_SYS_CDEFS_H))) {
        private enum enumMixinStr__SYS_CDEFS_H = `enum _SYS_CDEFS_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__SYS_CDEFS_H); }))) {
            mixin(enumMixinStr__SYS_CDEFS_H);
        }
    }




    static if(!is(typeof(SCM_WIFI_STATUS))) {
        private enum enumMixinStr_SCM_WIFI_STATUS = `enum SCM_WIFI_STATUS = SO_WIFI_STATUS;`;
        static if(is(typeof({ mixin(enumMixinStr_SCM_WIFI_STATUS); }))) {
            mixin(enumMixinStr_SCM_WIFI_STATUS);
        }
    }




    static if(!is(typeof(SO_WIFI_STATUS))) {
        private enum enumMixinStr_SO_WIFI_STATUS = `enum SO_WIFI_STATUS = 41;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_WIFI_STATUS); }))) {
            mixin(enumMixinStr_SO_WIFI_STATUS);
        }
    }




    static if(!is(typeof(SO_RXQ_OVFL))) {
        private enum enumMixinStr_SO_RXQ_OVFL = `enum SO_RXQ_OVFL = 40;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_RXQ_OVFL); }))) {
            mixin(enumMixinStr_SO_RXQ_OVFL);
        }
    }




    static if(!is(typeof(SO_DOMAIN))) {
        private enum enumMixinStr_SO_DOMAIN = `enum SO_DOMAIN = 39;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_DOMAIN); }))) {
            mixin(enumMixinStr_SO_DOMAIN);
        }
    }




    static if(!is(typeof(SO_PROTOCOL))) {
        private enum enumMixinStr_SO_PROTOCOL = `enum SO_PROTOCOL = 38;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_PROTOCOL); }))) {
            mixin(enumMixinStr_SO_PROTOCOL);
        }
    }




    static if(!is(typeof(SO_MARK))) {
        private enum enumMixinStr_SO_MARK = `enum SO_MARK = 36;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_MARK); }))) {
            mixin(enumMixinStr_SO_MARK);
        }
    }




    static if(!is(typeof(SO_PASSSEC))) {
        private enum enumMixinStr_SO_PASSSEC = `enum SO_PASSSEC = 34;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_PASSSEC); }))) {
            mixin(enumMixinStr_SO_PASSSEC);
        }
    }






    static if(!is(typeof(SO_PEERSEC))) {
        private enum enumMixinStr_SO_PEERSEC = `enum SO_PEERSEC = 31;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_PEERSEC); }))) {
            mixin(enumMixinStr_SO_PEERSEC);
        }
    }






    static if(!is(typeof(SO_ACCEPTCONN))) {
        private enum enumMixinStr_SO_ACCEPTCONN = `enum SO_ACCEPTCONN = 30;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_ACCEPTCONN); }))) {
            mixin(enumMixinStr_SO_ACCEPTCONN);
        }
    }






    static if(!is(typeof(SO_PEERNAME))) {
        private enum enumMixinStr_SO_PEERNAME = `enum SO_PEERNAME = 28;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_PEERNAME); }))) {
            mixin(enumMixinStr_SO_PEERNAME);
        }
    }




    static if(!is(typeof(SO_GET_FILTER))) {
        private enum enumMixinStr_SO_GET_FILTER = `enum SO_GET_FILTER = SO_ATTACH_FILTER;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_GET_FILTER); }))) {
            mixin(enumMixinStr_SO_GET_FILTER);
        }
    }




    static if(!is(typeof(SO_DETACH_FILTER))) {
        private enum enumMixinStr_SO_DETACH_FILTER = `enum SO_DETACH_FILTER = 27;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_DETACH_FILTER); }))) {
            mixin(enumMixinStr_SO_DETACH_FILTER);
        }
    }
    static if(!is(typeof(SO_ATTACH_FILTER))) {
        private enum enumMixinStr_SO_ATTACH_FILTER = `enum SO_ATTACH_FILTER = 26;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_ATTACH_FILTER); }))) {
            mixin(enumMixinStr_SO_ATTACH_FILTER);
        }
    }




    static if(!is(typeof(SO_BINDTODEVICE))) {
        private enum enumMixinStr_SO_BINDTODEVICE = `enum SO_BINDTODEVICE = 25;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_BINDTODEVICE); }))) {
            mixin(enumMixinStr_SO_BINDTODEVICE);
        }
    }




    static if(!is(typeof(__THROW))) {
        private enum enumMixinStr___THROW = `enum __THROW = __attribute__ ( ( __nothrow__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___THROW); }))) {
            mixin(enumMixinStr___THROW);
        }
    }




    static if(!is(typeof(__THROWNL))) {
        private enum enumMixinStr___THROWNL = `enum __THROWNL = __attribute__ ( ( __nothrow__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___THROWNL); }))) {
            mixin(enumMixinStr___THROWNL);
        }
    }
    static if(!is(typeof(__ptr_t))) {
        private enum enumMixinStr___ptr_t = `enum __ptr_t = void *;`;
        static if(is(typeof({ mixin(enumMixinStr___ptr_t); }))) {
            mixin(enumMixinStr___ptr_t);
        }
    }
    static if(!is(typeof(SO_SECURITY_ENCRYPTION_NETWORK))) {
        private enum enumMixinStr_SO_SECURITY_ENCRYPTION_NETWORK = `enum SO_SECURITY_ENCRYPTION_NETWORK = 24;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_SECURITY_ENCRYPTION_NETWORK); }))) {
            mixin(enumMixinStr_SO_SECURITY_ENCRYPTION_NETWORK);
        }
    }




    static if(!is(typeof(SO_SECURITY_ENCRYPTION_TRANSPORT))) {
        private enum enumMixinStr_SO_SECURITY_ENCRYPTION_TRANSPORT = `enum SO_SECURITY_ENCRYPTION_TRANSPORT = 23;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_SECURITY_ENCRYPTION_TRANSPORT); }))) {
            mixin(enumMixinStr_SO_SECURITY_ENCRYPTION_TRANSPORT);
        }
    }




    static if(!is(typeof(SO_SECURITY_AUTHENTICATION))) {
        private enum enumMixinStr_SO_SECURITY_AUTHENTICATION = `enum SO_SECURITY_AUTHENTICATION = 22;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_SECURITY_AUTHENTICATION); }))) {
            mixin(enumMixinStr_SO_SECURITY_AUTHENTICATION);
        }
    }
    static if(!is(typeof(SO_SNDTIMEO_OLD))) {
        private enum enumMixinStr_SO_SNDTIMEO_OLD = `enum SO_SNDTIMEO_OLD = 21;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_SNDTIMEO_OLD); }))) {
            mixin(enumMixinStr_SO_SNDTIMEO_OLD);
        }
    }
    static if(!is(typeof(SO_RCVTIMEO_OLD))) {
        private enum enumMixinStr_SO_RCVTIMEO_OLD = `enum SO_RCVTIMEO_OLD = 20;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_RCVTIMEO_OLD); }))) {
            mixin(enumMixinStr_SO_RCVTIMEO_OLD);
        }
    }




    static if(!is(typeof(SO_SNDLOWAT))) {
        private enum enumMixinStr_SO_SNDLOWAT = `enum SO_SNDLOWAT = 19;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_SNDLOWAT); }))) {
            mixin(enumMixinStr_SO_SNDLOWAT);
        }
    }




    static if(!is(typeof(__flexarr))) {
        private enum enumMixinStr___flexarr = `enum __flexarr = [ ];`;
        static if(is(typeof({ mixin(enumMixinStr___flexarr); }))) {
            mixin(enumMixinStr___flexarr);
        }
    }




    static if(!is(typeof(__glibc_c99_flexarr_available))) {
        private enum enumMixinStr___glibc_c99_flexarr_available = `enum __glibc_c99_flexarr_available = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___glibc_c99_flexarr_available); }))) {
            mixin(enumMixinStr___glibc_c99_flexarr_available);
        }
    }




    static if(!is(typeof(SO_RCVLOWAT))) {
        private enum enumMixinStr_SO_RCVLOWAT = `enum SO_RCVLOWAT = 18;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_RCVLOWAT); }))) {
            mixin(enumMixinStr_SO_RCVLOWAT);
        }
    }




    static if(!is(typeof(SO_PEERCRED))) {
        private enum enumMixinStr_SO_PEERCRED = `enum SO_PEERCRED = 17;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_PEERCRED); }))) {
            mixin(enumMixinStr_SO_PEERCRED);
        }
    }




    static if(!is(typeof(SO_PASSCRED))) {
        private enum enumMixinStr_SO_PASSCRED = `enum SO_PASSCRED = 16;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_PASSCRED); }))) {
            mixin(enumMixinStr_SO_PASSCRED);
        }
    }
    static if(!is(typeof(SO_REUSEPORT))) {
        private enum enumMixinStr_SO_REUSEPORT = `enum SO_REUSEPORT = 15;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_REUSEPORT); }))) {
            mixin(enumMixinStr_SO_REUSEPORT);
        }
    }




    static if(!is(typeof(SO_BSDCOMPAT))) {
        private enum enumMixinStr_SO_BSDCOMPAT = `enum SO_BSDCOMPAT = 14;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_BSDCOMPAT); }))) {
            mixin(enumMixinStr_SO_BSDCOMPAT);
        }
    }




    static if(!is(typeof(SO_LINGER))) {
        private enum enumMixinStr_SO_LINGER = `enum SO_LINGER = 13;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_LINGER); }))) {
            mixin(enumMixinStr_SO_LINGER);
        }
    }




    static if(!is(typeof(SO_PRIORITY))) {
        private enum enumMixinStr_SO_PRIORITY = `enum SO_PRIORITY = 12;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_PRIORITY); }))) {
            mixin(enumMixinStr_SO_PRIORITY);
        }
    }




    static if(!is(typeof(__attribute_malloc__))) {
        private enum enumMixinStr___attribute_malloc__ = `enum __attribute_malloc__ = __attribute__ ( ( __malloc__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_malloc__); }))) {
            mixin(enumMixinStr___attribute_malloc__);
        }
    }




    static if(!is(typeof(SO_NO_CHECK))) {
        private enum enumMixinStr_SO_NO_CHECK = `enum SO_NO_CHECK = 11;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_NO_CHECK); }))) {
            mixin(enumMixinStr_SO_NO_CHECK);
        }
    }






    static if(!is(typeof(SO_OOBINLINE))) {
        private enum enumMixinStr_SO_OOBINLINE = `enum SO_OOBINLINE = 10;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_OOBINLINE); }))) {
            mixin(enumMixinStr_SO_OOBINLINE);
        }
    }




    static if(!is(typeof(SO_KEEPALIVE))) {
        private enum enumMixinStr_SO_KEEPALIVE = `enum SO_KEEPALIVE = 9;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_KEEPALIVE); }))) {
            mixin(enumMixinStr_SO_KEEPALIVE);
        }
    }






    static if(!is(typeof(SO_RCVBUFFORCE))) {
        private enum enumMixinStr_SO_RCVBUFFORCE = `enum SO_RCVBUFFORCE = 33;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_RCVBUFFORCE); }))) {
            mixin(enumMixinStr_SO_RCVBUFFORCE);
        }
    }




    static if(!is(typeof(SO_SNDBUFFORCE))) {
        private enum enumMixinStr_SO_SNDBUFFORCE = `enum SO_SNDBUFFORCE = 32;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_SNDBUFFORCE); }))) {
            mixin(enumMixinStr_SO_SNDBUFFORCE);
        }
    }




    static if(!is(typeof(__attribute_pure__))) {
        private enum enumMixinStr___attribute_pure__ = `enum __attribute_pure__ = __attribute__ ( ( __pure__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_pure__); }))) {
            mixin(enumMixinStr___attribute_pure__);
        }
    }




    static if(!is(typeof(SO_RCVBUF))) {
        private enum enumMixinStr_SO_RCVBUF = `enum SO_RCVBUF = 8;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_RCVBUF); }))) {
            mixin(enumMixinStr_SO_RCVBUF);
        }
    }




    static if(!is(typeof(SO_SNDBUF))) {
        private enum enumMixinStr_SO_SNDBUF = `enum SO_SNDBUF = 7;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_SNDBUF); }))) {
            mixin(enumMixinStr_SO_SNDBUF);
        }
    }




    static if(!is(typeof(__attribute_const__))) {
        private enum enumMixinStr___attribute_const__ = `enum __attribute_const__ = __attribute__ ( cast( __const__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_const__); }))) {
            mixin(enumMixinStr___attribute_const__);
        }
    }




    static if(!is(typeof(SO_BROADCAST))) {
        private enum enumMixinStr_SO_BROADCAST = `enum SO_BROADCAST = 6;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_BROADCAST); }))) {
            mixin(enumMixinStr_SO_BROADCAST);
        }
    }




    static if(!is(typeof(SO_DONTROUTE))) {
        private enum enumMixinStr_SO_DONTROUTE = `enum SO_DONTROUTE = 5;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_DONTROUTE); }))) {
            mixin(enumMixinStr_SO_DONTROUTE);
        }
    }




    static if(!is(typeof(__attribute_maybe_unused__))) {
        private enum enumMixinStr___attribute_maybe_unused__ = `enum __attribute_maybe_unused__ = __attribute__ ( ( __unused__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_maybe_unused__); }))) {
            mixin(enumMixinStr___attribute_maybe_unused__);
        }
    }




    static if(!is(typeof(SO_ERROR))) {
        private enum enumMixinStr_SO_ERROR = `enum SO_ERROR = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_ERROR); }))) {
            mixin(enumMixinStr_SO_ERROR);
        }
    }




    static if(!is(typeof(SO_TYPE))) {
        private enum enumMixinStr_SO_TYPE = `enum SO_TYPE = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_TYPE); }))) {
            mixin(enumMixinStr_SO_TYPE);
        }
    }




    static if(!is(typeof(__attribute_used__))) {
        private enum enumMixinStr___attribute_used__ = `enum __attribute_used__ = __attribute__ ( ( __used__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_used__); }))) {
            mixin(enumMixinStr___attribute_used__);
        }
    }




    static if(!is(typeof(__attribute_noinline__))) {
        private enum enumMixinStr___attribute_noinline__ = `enum __attribute_noinline__ = __attribute__ ( ( __noinline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_noinline__); }))) {
            mixin(enumMixinStr___attribute_noinline__);
        }
    }




    static if(!is(typeof(SO_REUSEADDR))) {
        private enum enumMixinStr_SO_REUSEADDR = `enum SO_REUSEADDR = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_REUSEADDR); }))) {
            mixin(enumMixinStr_SO_REUSEADDR);
        }
    }




    static if(!is(typeof(SO_DEBUG))) {
        private enum enumMixinStr_SO_DEBUG = `enum SO_DEBUG = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_SO_DEBUG); }))) {
            mixin(enumMixinStr_SO_DEBUG);
        }
    }




    static if(!is(typeof(__attribute_deprecated__))) {
        private enum enumMixinStr___attribute_deprecated__ = `enum __attribute_deprecated__ = __attribute__ ( ( __deprecated__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_deprecated__); }))) {
            mixin(enumMixinStr___attribute_deprecated__);
        }
    }




    static if(!is(typeof(SOL_SOCKET))) {
        private enum enumMixinStr_SOL_SOCKET = `enum SOL_SOCKET = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_SOL_SOCKET); }))) {
            mixin(enumMixinStr_SOL_SOCKET);
        }
    }
    static if(!is(typeof(TIOCSER_TEMT))) {
        private enum enumMixinStr_TIOCSER_TEMT = `enum TIOCSER_TEMT = 0x01;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSER_TEMT); }))) {
            mixin(enumMixinStr_TIOCSER_TEMT);
        }
    }






    static if(!is(typeof(TIOCPKT_IOCTL))) {
        private enum enumMixinStr_TIOCPKT_IOCTL = `enum TIOCPKT_IOCTL = 64;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCPKT_IOCTL); }))) {
            mixin(enumMixinStr_TIOCPKT_IOCTL);
        }
    }




    static if(!is(typeof(TIOCPKT_DOSTOP))) {
        private enum enumMixinStr_TIOCPKT_DOSTOP = `enum TIOCPKT_DOSTOP = 32;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCPKT_DOSTOP); }))) {
            mixin(enumMixinStr_TIOCPKT_DOSTOP);
        }
    }






    static if(!is(typeof(TIOCPKT_NOSTOP))) {
        private enum enumMixinStr_TIOCPKT_NOSTOP = `enum TIOCPKT_NOSTOP = 16;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCPKT_NOSTOP); }))) {
            mixin(enumMixinStr_TIOCPKT_NOSTOP);
        }
    }




    static if(!is(typeof(TIOCPKT_START))) {
        private enum enumMixinStr_TIOCPKT_START = `enum TIOCPKT_START = 8;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCPKT_START); }))) {
            mixin(enumMixinStr_TIOCPKT_START);
        }
    }
    static if(!is(typeof(TIOCPKT_STOP))) {
        private enum enumMixinStr_TIOCPKT_STOP = `enum TIOCPKT_STOP = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCPKT_STOP); }))) {
            mixin(enumMixinStr_TIOCPKT_STOP);
        }
    }




    static if(!is(typeof(TIOCPKT_FLUSHWRITE))) {
        private enum enumMixinStr_TIOCPKT_FLUSHWRITE = `enum TIOCPKT_FLUSHWRITE = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCPKT_FLUSHWRITE); }))) {
            mixin(enumMixinStr_TIOCPKT_FLUSHWRITE);
        }
    }




    static if(!is(typeof(__returns_nonnull))) {
        private enum enumMixinStr___returns_nonnull = `enum __returns_nonnull = __attribute__ ( ( __returns_nonnull__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___returns_nonnull); }))) {
            mixin(enumMixinStr___returns_nonnull);
        }
    }




    static if(!is(typeof(TIOCPKT_FLUSHREAD))) {
        private enum enumMixinStr_TIOCPKT_FLUSHREAD = `enum TIOCPKT_FLUSHREAD = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCPKT_FLUSHREAD); }))) {
            mixin(enumMixinStr_TIOCPKT_FLUSHREAD);
        }
    }




    static if(!is(typeof(TIOCPKT_DATA))) {
        private enum enumMixinStr_TIOCPKT_DATA = `enum TIOCPKT_DATA = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCPKT_DATA); }))) {
            mixin(enumMixinStr_TIOCPKT_DATA);
        }
    }




    static if(!is(typeof(__attribute_warn_unused_result__))) {
        private enum enumMixinStr___attribute_warn_unused_result__ = `enum __attribute_warn_unused_result__ = __attribute__ ( ( __warn_unused_result__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_warn_unused_result__); }))) {
            mixin(enumMixinStr___attribute_warn_unused_result__);
        }
    }




    static if(!is(typeof(FIOQSIZE))) {
        private enum enumMixinStr_FIOQSIZE = `enum FIOQSIZE = 0x5460;`;
        static if(is(typeof({ mixin(enumMixinStr_FIOQSIZE); }))) {
            mixin(enumMixinStr_FIOQSIZE);
        }
    }




    static if(!is(typeof(TIOCGICOUNT))) {
        private enum enumMixinStr_TIOCGICOUNT = `enum TIOCGICOUNT = 0x545D;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGICOUNT); }))) {
            mixin(enumMixinStr_TIOCGICOUNT);
        }
    }






    static if(!is(typeof(TIOCMIWAIT))) {
        private enum enumMixinStr_TIOCMIWAIT = `enum TIOCMIWAIT = 0x545C;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCMIWAIT); }))) {
            mixin(enumMixinStr_TIOCMIWAIT);
        }
    }




    static if(!is(typeof(TIOCSERSETMULTI))) {
        private enum enumMixinStr_TIOCSERSETMULTI = `enum TIOCSERSETMULTI = 0x545B;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSERSETMULTI); }))) {
            mixin(enumMixinStr_TIOCSERSETMULTI);
        }
    }




    static if(!is(typeof(__always_inline))) {
        private enum enumMixinStr___always_inline = `enum __always_inline = __inline __attribute__ ( ( __always_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___always_inline); }))) {
            mixin(enumMixinStr___always_inline);
        }
    }




    static if(!is(typeof(TIOCSERGETMULTI))) {
        private enum enumMixinStr_TIOCSERGETMULTI = `enum TIOCSERGETMULTI = 0x545A;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSERGETMULTI); }))) {
            mixin(enumMixinStr_TIOCSERGETMULTI);
        }
    }




    static if(!is(typeof(TIOCSERGETLSR))) {
        private enum enumMixinStr_TIOCSERGETLSR = `enum TIOCSERGETLSR = 0x5459;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSERGETLSR); }))) {
            mixin(enumMixinStr_TIOCSERGETLSR);
        }
    }




    static if(!is(typeof(__attribute_artificial__))) {
        private enum enumMixinStr___attribute_artificial__ = `enum __attribute_artificial__ = __attribute__ ( ( __artificial__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_artificial__); }))) {
            mixin(enumMixinStr___attribute_artificial__);
        }
    }




    static if(!is(typeof(TIOCSERGSTRUCT))) {
        private enum enumMixinStr_TIOCSERGSTRUCT = `enum TIOCSERGSTRUCT = 0x5458;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSERGSTRUCT); }))) {
            mixin(enumMixinStr_TIOCSERGSTRUCT);
        }
    }




    static if(!is(typeof(TIOCSLCKTRMIOS))) {
        private enum enumMixinStr_TIOCSLCKTRMIOS = `enum TIOCSLCKTRMIOS = 0x5457;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSLCKTRMIOS); }))) {
            mixin(enumMixinStr_TIOCSLCKTRMIOS);
        }
    }




    static if(!is(typeof(TIOCGLCKTRMIOS))) {
        private enum enumMixinStr_TIOCGLCKTRMIOS = `enum TIOCGLCKTRMIOS = 0x5456;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGLCKTRMIOS); }))) {
            mixin(enumMixinStr_TIOCGLCKTRMIOS);
        }
    }




    static if(!is(typeof(TIOCSERSWILD))) {
        private enum enumMixinStr_TIOCSERSWILD = `enum TIOCSERSWILD = 0x5455;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSERSWILD); }))) {
            mixin(enumMixinStr_TIOCSERSWILD);
        }
    }




    static if(!is(typeof(__extern_inline))) {
        private enum enumMixinStr___extern_inline = `enum __extern_inline = extern __inline __attribute__ ( ( __gnu_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___extern_inline); }))) {
            mixin(enumMixinStr___extern_inline);
        }
    }




    static if(!is(typeof(__extern_always_inline))) {
        private enum enumMixinStr___extern_always_inline = `enum __extern_always_inline = extern __inline __attribute__ ( ( __always_inline__ ) ) __attribute__ ( ( __gnu_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___extern_always_inline); }))) {
            mixin(enumMixinStr___extern_always_inline);
        }
    }




    static if(!is(typeof(TIOCSERGWILD))) {
        private enum enumMixinStr_TIOCSERGWILD = `enum TIOCSERGWILD = 0x5454;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSERGWILD); }))) {
            mixin(enumMixinStr_TIOCSERGWILD);
        }
    }




    static if(!is(typeof(__fortify_function))) {
        private enum enumMixinStr___fortify_function = `enum __fortify_function = extern __inline __attribute__ ( ( __always_inline__ ) ) __attribute__ ( ( __gnu_inline__ ) ) __attribute__ ( ( __artificial__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___fortify_function); }))) {
            mixin(enumMixinStr___fortify_function);
        }
    }




    static if(!is(typeof(TIOCSERCONFIG))) {
        private enum enumMixinStr_TIOCSERCONFIG = `enum TIOCSERCONFIG = 0x5453;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSERCONFIG); }))) {
            mixin(enumMixinStr_TIOCSERCONFIG);
        }
    }




    static if(!is(typeof(FIOASYNC))) {
        private enum enumMixinStr_FIOASYNC = `enum FIOASYNC = 0x5452;`;
        static if(is(typeof({ mixin(enumMixinStr_FIOASYNC); }))) {
            mixin(enumMixinStr_FIOASYNC);
        }
    }




    static if(!is(typeof(FIOCLEX))) {
        private enum enumMixinStr_FIOCLEX = `enum FIOCLEX = 0x5451;`;
        static if(is(typeof({ mixin(enumMixinStr_FIOCLEX); }))) {
            mixin(enumMixinStr_FIOCLEX);
        }
    }




    static if(!is(typeof(FIONCLEX))) {
        private enum enumMixinStr_FIONCLEX = `enum FIONCLEX = 0x5450;`;
        static if(is(typeof({ mixin(enumMixinStr_FIONCLEX); }))) {
            mixin(enumMixinStr_FIONCLEX);
        }
    }




    static if(!is(typeof(TIOCSISO7816))) {
        private enum enumMixinStr_TIOCSISO7816 = `enum TIOCSISO7816 = _IOWR ( 'T' , 0x43 , serial_iso7816 );`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSISO7816); }))) {
            mixin(enumMixinStr_TIOCSISO7816);
        }
    }




    static if(!is(typeof(TIOCGISO7816))) {
        private enum enumMixinStr_TIOCGISO7816 = `enum TIOCGISO7816 = _IOR ( 'T' , 0x42 , serial_iso7816 );`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGISO7816); }))) {
            mixin(enumMixinStr_TIOCGISO7816);
        }
    }




    static if(!is(typeof(TIOCGPTPEER))) {
        private enum enumMixinStr_TIOCGPTPEER = `enum TIOCGPTPEER = _IO ( 'T' , 0x41 );`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGPTPEER); }))) {
            mixin(enumMixinStr_TIOCGPTPEER);
        }
    }




    static if(!is(typeof(__restrict_arr))) {
        private enum enumMixinStr___restrict_arr = `enum __restrict_arr = __restrict;`;
        static if(is(typeof({ mixin(enumMixinStr___restrict_arr); }))) {
            mixin(enumMixinStr___restrict_arr);
        }
    }




    static if(!is(typeof(TIOCGEXCL))) {
        private enum enumMixinStr_TIOCGEXCL = `enum TIOCGEXCL = _IOR ( 'T' , 0x40 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGEXCL); }))) {
            mixin(enumMixinStr_TIOCGEXCL);
        }
    }




    static if(!is(typeof(TIOCGPTLCK))) {
        private enum enumMixinStr_TIOCGPTLCK = `enum TIOCGPTLCK = _IOR ( 'T' , 0x39 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGPTLCK); }))) {
            mixin(enumMixinStr_TIOCGPTLCK);
        }
    }
    static if(!is(typeof(TIOCGPKT))) {
        private enum enumMixinStr_TIOCGPKT = `enum TIOCGPKT = _IOR ( 'T' , 0x38 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGPKT); }))) {
            mixin(enumMixinStr_TIOCGPKT);
        }
    }




    static if(!is(typeof(TIOCVHANGUP))) {
        private enum enumMixinStr_TIOCVHANGUP = `enum TIOCVHANGUP = 0x5437;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCVHANGUP); }))) {
            mixin(enumMixinStr_TIOCVHANGUP);
        }
    }




    static if(!is(typeof(TIOCSIG))) {
        private enum enumMixinStr_TIOCSIG = `enum TIOCSIG = _IOW ( 'T' , 0x36 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSIG); }))) {
            mixin(enumMixinStr_TIOCSIG);
        }
    }




    static if(!is(typeof(TCSETXW))) {
        private enum enumMixinStr_TCSETXW = `enum TCSETXW = 0x5435;`;
        static if(is(typeof({ mixin(enumMixinStr_TCSETXW); }))) {
            mixin(enumMixinStr_TCSETXW);
        }
    }




    static if(!is(typeof(TCSETXF))) {
        private enum enumMixinStr_TCSETXF = `enum TCSETXF = 0x5434;`;
        static if(is(typeof({ mixin(enumMixinStr_TCSETXF); }))) {
            mixin(enumMixinStr_TCSETXF);
        }
    }




    static if(!is(typeof(TCSETX))) {
        private enum enumMixinStr_TCSETX = `enum TCSETX = 0x5433;`;
        static if(is(typeof({ mixin(enumMixinStr_TCSETX); }))) {
            mixin(enumMixinStr_TCSETX);
        }
    }






    static if(!is(typeof(TCGETX))) {
        private enum enumMixinStr_TCGETX = `enum TCGETX = 0x5432;`;
        static if(is(typeof({ mixin(enumMixinStr_TCGETX); }))) {
            mixin(enumMixinStr_TCGETX);
        }
    }






    static if(!is(typeof(TIOCGDEV))) {
        private enum enumMixinStr_TIOCGDEV = `enum TIOCGDEV = _IOR ( 'T' , 0x32 , unsigned int );`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGDEV); }))) {
            mixin(enumMixinStr_TIOCGDEV);
        }
    }




    static if(!is(typeof(TIOCSPTLCK))) {
        private enum enumMixinStr_TIOCSPTLCK = `enum TIOCSPTLCK = _IOW ( 'T' , 0x31 , int );`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSPTLCK); }))) {
            mixin(enumMixinStr_TIOCSPTLCK);
        }
    }




    static if(!is(typeof(TIOCGPTN))) {
        private enum enumMixinStr_TIOCGPTN = `enum TIOCGPTN = _IOR ( 'T' , 0x30 , unsigned int );`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGPTN); }))) {
            mixin(enumMixinStr_TIOCGPTN);
        }
    }




    static if(!is(typeof(TIOCSRS485))) {
        private enum enumMixinStr_TIOCSRS485 = `enum TIOCSRS485 = 0x542F;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSRS485); }))) {
            mixin(enumMixinStr_TIOCSRS485);
        }
    }




    static if(!is(typeof(TIOCGRS485))) {
        private enum enumMixinStr_TIOCGRS485 = `enum TIOCGRS485 = 0x542E;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGRS485); }))) {
            mixin(enumMixinStr_TIOCGRS485);
        }
    }




    static if(!is(typeof(TCSETSF2))) {
        private enum enumMixinStr_TCSETSF2 = `enum TCSETSF2 = _IOW ( 'T' , 0x2D , termios2 );`;
        static if(is(typeof({ mixin(enumMixinStr_TCSETSF2); }))) {
            mixin(enumMixinStr_TCSETSF2);
        }
    }




    static if(!is(typeof(TCSETSW2))) {
        private enum enumMixinStr_TCSETSW2 = `enum TCSETSW2 = _IOW ( 'T' , 0x2C , termios2 );`;
        static if(is(typeof({ mixin(enumMixinStr_TCSETSW2); }))) {
            mixin(enumMixinStr_TCSETSW2);
        }
    }




    static if(!is(typeof(TCSETS2))) {
        private enum enumMixinStr_TCSETS2 = `enum TCSETS2 = _IOW ( 'T' , 0x2B , termios2 );`;
        static if(is(typeof({ mixin(enumMixinStr_TCSETS2); }))) {
            mixin(enumMixinStr_TCSETS2);
        }
    }




    static if(!is(typeof(TCGETS2))) {
        private enum enumMixinStr_TCGETS2 = `enum TCGETS2 = _IOR ( 'T' , 0x2A , termios2 );`;
        static if(is(typeof({ mixin(enumMixinStr_TCGETS2); }))) {
            mixin(enumMixinStr_TCGETS2);
        }
    }
    static if(!is(typeof(TIOCGSID))) {
        private enum enumMixinStr_TIOCGSID = `enum TIOCGSID = 0x5429;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGSID); }))) {
            mixin(enumMixinStr_TIOCGSID);
        }
    }
    static if(!is(typeof(TIOCCBRK))) {
        private enum enumMixinStr_TIOCCBRK = `enum TIOCCBRK = 0x5428;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCCBRK); }))) {
            mixin(enumMixinStr_TIOCCBRK);
        }
    }




    static if(!is(typeof(TIOCSBRK))) {
        private enum enumMixinStr_TIOCSBRK = `enum TIOCSBRK = 0x5427;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSBRK); }))) {
            mixin(enumMixinStr_TIOCSBRK);
        }
    }
    static if(!is(typeof(TCSBRKP))) {
        private enum enumMixinStr_TCSBRKP = `enum TCSBRKP = 0x5425;`;
        static if(is(typeof({ mixin(enumMixinStr_TCSBRKP); }))) {
            mixin(enumMixinStr_TCSBRKP);
        }
    }




    static if(!is(typeof(TIOCGETD))) {
        private enum enumMixinStr_TIOCGETD = `enum TIOCGETD = 0x5424;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGETD); }))) {
            mixin(enumMixinStr_TIOCGETD);
        }
    }




    static if(!is(typeof(TIOCSETD))) {
        private enum enumMixinStr_TIOCSETD = `enum TIOCSETD = 0x5423;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSETD); }))) {
            mixin(enumMixinStr_TIOCSETD);
        }
    }




    static if(!is(typeof(TIOCNOTTY))) {
        private enum enumMixinStr_TIOCNOTTY = `enum TIOCNOTTY = 0x5422;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCNOTTY); }))) {
            mixin(enumMixinStr_TIOCNOTTY);
        }
    }




    static if(!is(typeof(FIONBIO))) {
        private enum enumMixinStr_FIONBIO = `enum FIONBIO = 0x5421;`;
        static if(is(typeof({ mixin(enumMixinStr_FIONBIO); }))) {
            mixin(enumMixinStr_FIONBIO);
        }
    }




    static if(!is(typeof(__HAVE_GENERIC_SELECTION))) {
        private enum enumMixinStr___HAVE_GENERIC_SELECTION = `enum __HAVE_GENERIC_SELECTION = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_GENERIC_SELECTION); }))) {
            mixin(enumMixinStr___HAVE_GENERIC_SELECTION);
        }
    }




    static if(!is(typeof(TIOCPKT))) {
        private enum enumMixinStr_TIOCPKT = `enum TIOCPKT = 0x5420;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCPKT); }))) {
            mixin(enumMixinStr_TIOCPKT);
        }
    }
    static if(!is(typeof(TIOCSSERIAL))) {
        private enum enumMixinStr_TIOCSSERIAL = `enum TIOCSSERIAL = 0x541F;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSSERIAL); }))) {
            mixin(enumMixinStr_TIOCSSERIAL);
        }
    }
    static if(!is(typeof(TIOCGSERIAL))) {
        private enum enumMixinStr_TIOCGSERIAL = `enum TIOCGSERIAL = 0x541E;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGSERIAL); }))) {
            mixin(enumMixinStr_TIOCGSERIAL);
        }
    }




    static if(!is(typeof(__attribute_returns_twice__))) {
        private enum enumMixinStr___attribute_returns_twice__ = `enum __attribute_returns_twice__ = __attribute__ ( ( __returns_twice__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_returns_twice__); }))) {
            mixin(enumMixinStr___attribute_returns_twice__);
        }
    }




    static if(!is(typeof(_SYS_IOCTL_H))) {
        private enum enumMixinStr__SYS_IOCTL_H = `enum _SYS_IOCTL_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__SYS_IOCTL_H); }))) {
            mixin(enumMixinStr__SYS_IOCTL_H);
        }
    }




    static if(!is(typeof(TIOCCONS))) {
        private enum enumMixinStr_TIOCCONS = `enum TIOCCONS = 0x541D;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCCONS); }))) {
            mixin(enumMixinStr_TIOCCONS);
        }
    }




    static if(!is(typeof(TIOCLINUX))) {
        private enum enumMixinStr_TIOCLINUX = `enum TIOCLINUX = 0x541C;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCLINUX); }))) {
            mixin(enumMixinStr_TIOCLINUX);
        }
    }




    static if(!is(typeof(TIOCINQ))) {
        private enum enumMixinStr_TIOCINQ = `enum TIOCINQ = FIONREAD;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCINQ); }))) {
            mixin(enumMixinStr_TIOCINQ);
        }
    }




    static if(!is(typeof(FIONREAD))) {
        private enum enumMixinStr_FIONREAD = `enum FIONREAD = 0x541B;`;
        static if(is(typeof({ mixin(enumMixinStr_FIONREAD); }))) {
            mixin(enumMixinStr_FIONREAD);
        }
    }




    static if(!is(typeof(TIOCSSOFTCAR))) {
        private enum enumMixinStr_TIOCSSOFTCAR = `enum TIOCSSOFTCAR = 0x541A;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSSOFTCAR); }))) {
            mixin(enumMixinStr_TIOCSSOFTCAR);
        }
    }




    static if(!is(typeof(TIOCGSOFTCAR))) {
        private enum enumMixinStr_TIOCGSOFTCAR = `enum TIOCGSOFTCAR = 0x5419;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGSOFTCAR); }))) {
            mixin(enumMixinStr_TIOCGSOFTCAR);
        }
    }




    static if(!is(typeof(TIOCMSET))) {
        private enum enumMixinStr_TIOCMSET = `enum TIOCMSET = 0x5418;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCMSET); }))) {
            mixin(enumMixinStr_TIOCMSET);
        }
    }




    static if(!is(typeof(TIOCMBIC))) {
        private enum enumMixinStr_TIOCMBIC = `enum TIOCMBIC = 0x5417;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCMBIC); }))) {
            mixin(enumMixinStr_TIOCMBIC);
        }
    }




    static if(!is(typeof(_SYS_SELECT_H))) {
        private enum enumMixinStr__SYS_SELECT_H = `enum _SYS_SELECT_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__SYS_SELECT_H); }))) {
            mixin(enumMixinStr__SYS_SELECT_H);
        }
    }




    static if(!is(typeof(TIOCMBIS))) {
        private enum enumMixinStr_TIOCMBIS = `enum TIOCMBIS = 0x5416;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCMBIS); }))) {
            mixin(enumMixinStr_TIOCMBIS);
        }
    }




    static if(!is(typeof(TIOCMGET))) {
        private enum enumMixinStr_TIOCMGET = `enum TIOCMGET = 0x5415;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCMGET); }))) {
            mixin(enumMixinStr_TIOCMGET);
        }
    }




    static if(!is(typeof(TIOCSWINSZ))) {
        private enum enumMixinStr_TIOCSWINSZ = `enum TIOCSWINSZ = 0x5414;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSWINSZ); }))) {
            mixin(enumMixinStr_TIOCSWINSZ);
        }
    }




    static if(!is(typeof(TIOCGWINSZ))) {
        private enum enumMixinStr_TIOCGWINSZ = `enum TIOCGWINSZ = 0x5413;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGWINSZ); }))) {
            mixin(enumMixinStr_TIOCGWINSZ);
        }
    }




    static if(!is(typeof(TIOCSTI))) {
        private enum enumMixinStr_TIOCSTI = `enum TIOCSTI = 0x5412;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSTI); }))) {
            mixin(enumMixinStr_TIOCSTI);
        }
    }




    static if(!is(typeof(TIOCOUTQ))) {
        private enum enumMixinStr_TIOCOUTQ = `enum TIOCOUTQ = 0x5411;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCOUTQ); }))) {
            mixin(enumMixinStr_TIOCOUTQ);
        }
    }




    static if(!is(typeof(TIOCSPGRP))) {
        private enum enumMixinStr_TIOCSPGRP = `enum TIOCSPGRP = 0x5410;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSPGRP); }))) {
            mixin(enumMixinStr_TIOCSPGRP);
        }
    }




    static if(!is(typeof(TIOCGPGRP))) {
        private enum enumMixinStr_TIOCGPGRP = `enum TIOCGPGRP = 0x540F;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCGPGRP); }))) {
            mixin(enumMixinStr_TIOCGPGRP);
        }
    }




    static if(!is(typeof(TIOCSCTTY))) {
        private enum enumMixinStr_TIOCSCTTY = `enum TIOCSCTTY = 0x540E;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCSCTTY); }))) {
            mixin(enumMixinStr_TIOCSCTTY);
        }
    }






    static if(!is(typeof(TIOCNXCL))) {
        private enum enumMixinStr_TIOCNXCL = `enum TIOCNXCL = 0x540D;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCNXCL); }))) {
            mixin(enumMixinStr_TIOCNXCL);
        }
    }




    static if(!is(typeof(__NFDBITS))) {
        private enum enumMixinStr___NFDBITS = `enum __NFDBITS = ( 8 * cast( int ) ( __fd_mask ) .sizeof );`;
        static if(is(typeof({ mixin(enumMixinStr___NFDBITS); }))) {
            mixin(enumMixinStr___NFDBITS);
        }
    }
    static if(!is(typeof(TIOCEXCL))) {
        private enum enumMixinStr_TIOCEXCL = `enum TIOCEXCL = 0x540C;`;
        static if(is(typeof({ mixin(enumMixinStr_TIOCEXCL); }))) {
            mixin(enumMixinStr_TIOCEXCL);
        }
    }




    static if(!is(typeof(TCFLSH))) {
        private enum enumMixinStr_TCFLSH = `enum TCFLSH = 0x540B;`;
        static if(is(typeof({ mixin(enumMixinStr_TCFLSH); }))) {
            mixin(enumMixinStr_TCFLSH);
        }
    }




    static if(!is(typeof(TCXONC))) {
        private enum enumMixinStr_TCXONC = `enum TCXONC = 0x540A;`;
        static if(is(typeof({ mixin(enumMixinStr_TCXONC); }))) {
            mixin(enumMixinStr_TCXONC);
        }
    }




    static if(!is(typeof(TCSBRK))) {
        private enum enumMixinStr_TCSBRK = `enum TCSBRK = 0x5409;`;
        static if(is(typeof({ mixin(enumMixinStr_TCSBRK); }))) {
            mixin(enumMixinStr_TCSBRK);
        }
    }






    static if(!is(typeof(FD_SETSIZE))) {
        private enum enumMixinStr_FD_SETSIZE = `enum FD_SETSIZE = 1024;`;
        static if(is(typeof({ mixin(enumMixinStr_FD_SETSIZE); }))) {
            mixin(enumMixinStr_FD_SETSIZE);
        }
    }




    static if(!is(typeof(TCSETAF))) {
        private enum enumMixinStr_TCSETAF = `enum TCSETAF = 0x5408;`;
        static if(is(typeof({ mixin(enumMixinStr_TCSETAF); }))) {
            mixin(enumMixinStr_TCSETAF);
        }
    }




    static if(!is(typeof(TCSETAW))) {
        private enum enumMixinStr_TCSETAW = `enum TCSETAW = 0x5407;`;
        static if(is(typeof({ mixin(enumMixinStr_TCSETAW); }))) {
            mixin(enumMixinStr_TCSETAW);
        }
    }




    static if(!is(typeof(NFDBITS))) {
        private enum enumMixinStr_NFDBITS = `enum NFDBITS = ( 8 * cast( int ) ( __fd_mask ) .sizeof );`;
        static if(is(typeof({ mixin(enumMixinStr_NFDBITS); }))) {
            mixin(enumMixinStr_NFDBITS);
        }
    }
    static if(!is(typeof(TCSETA))) {
        private enum enumMixinStr_TCSETA = `enum TCSETA = 0x5406;`;
        static if(is(typeof({ mixin(enumMixinStr_TCSETA); }))) {
            mixin(enumMixinStr_TCSETA);
        }
    }




    static if(!is(typeof(TCGETA))) {
        private enum enumMixinStr_TCGETA = `enum TCGETA = 0x5405;`;
        static if(is(typeof({ mixin(enumMixinStr_TCGETA); }))) {
            mixin(enumMixinStr_TCGETA);
        }
    }




    static if(!is(typeof(TCSETSF))) {
        private enum enumMixinStr_TCSETSF = `enum TCSETSF = 0x5404;`;
        static if(is(typeof({ mixin(enumMixinStr_TCSETSF); }))) {
            mixin(enumMixinStr_TCSETSF);
        }
    }




    static if(!is(typeof(TCSETSW))) {
        private enum enumMixinStr_TCSETSW = `enum TCSETSW = 0x5403;`;
        static if(is(typeof({ mixin(enumMixinStr_TCSETSW); }))) {
            mixin(enumMixinStr_TCSETSW);
        }
    }




    static if(!is(typeof(TCSETS))) {
        private enum enumMixinStr_TCSETS = `enum TCSETS = 0x5402;`;
        static if(is(typeof({ mixin(enumMixinStr_TCSETS); }))) {
            mixin(enumMixinStr_TCSETS);
        }
    }




    static if(!is(typeof(TCGETS))) {
        private enum enumMixinStr_TCGETS = `enum TCGETS = 0x5401;`;
        static if(is(typeof({ mixin(enumMixinStr_TCGETS); }))) {
            mixin(enumMixinStr_TCGETS);
        }
    }






    static if(!is(typeof(_SYS_SOCKET_H))) {
        private enum enumMixinStr__SYS_SOCKET_H = `enum _SYS_SOCKET_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__SYS_SOCKET_H); }))) {
            mixin(enumMixinStr__SYS_SOCKET_H);
        }
    }




    static if(!is(typeof(IOCSIZE_SHIFT))) {
        private enum enumMixinStr_IOCSIZE_SHIFT = `enum IOCSIZE_SHIFT = ( _IOC_SIZESHIFT );`;
        static if(is(typeof({ mixin(enumMixinStr_IOCSIZE_SHIFT); }))) {
            mixin(enumMixinStr_IOCSIZE_SHIFT);
        }
    }




    static if(!is(typeof(IOCSIZE_MASK))) {
        private enum enumMixinStr_IOCSIZE_MASK = `enum IOCSIZE_MASK = ( _IOC_SIZEMASK << _IOC_SIZESHIFT );`;
        static if(is(typeof({ mixin(enumMixinStr_IOCSIZE_MASK); }))) {
            mixin(enumMixinStr_IOCSIZE_MASK);
        }
    }




    static if(!is(typeof(IOC_INOUT))) {
        private enum enumMixinStr_IOC_INOUT = `enum IOC_INOUT = ( ( _IOC_WRITE | _IOC_READ ) << _IOC_DIRSHIFT );`;
        static if(is(typeof({ mixin(enumMixinStr_IOC_INOUT); }))) {
            mixin(enumMixinStr_IOC_INOUT);
        }
    }




    static if(!is(typeof(IOC_OUT))) {
        private enum enumMixinStr_IOC_OUT = `enum IOC_OUT = ( _IOC_READ << _IOC_DIRSHIFT );`;
        static if(is(typeof({ mixin(enumMixinStr_IOC_OUT); }))) {
            mixin(enumMixinStr_IOC_OUT);
        }
    }




    static if(!is(typeof(IOC_IN))) {
        private enum enumMixinStr_IOC_IN = `enum IOC_IN = ( _IOC_WRITE << _IOC_DIRSHIFT );`;
        static if(is(typeof({ mixin(enumMixinStr_IOC_IN); }))) {
            mixin(enumMixinStr_IOC_IN);
        }
    }
    static if(!is(typeof(SHUT_RD))) {
        private enum enumMixinStr_SHUT_RD = `enum SHUT_RD = SHUT_RD;`;
        static if(is(typeof({ mixin(enumMixinStr_SHUT_RD); }))) {
            mixin(enumMixinStr_SHUT_RD);
        }
    }




    static if(!is(typeof(SHUT_WR))) {
        private enum enumMixinStr_SHUT_WR = `enum SHUT_WR = SHUT_WR;`;
        static if(is(typeof({ mixin(enumMixinStr_SHUT_WR); }))) {
            mixin(enumMixinStr_SHUT_WR);
        }
    }




    static if(!is(typeof(SHUT_RDWR))) {
        private enum enumMixinStr_SHUT_RDWR = `enum SHUT_RDWR = SHUT_RDWR;`;
        static if(is(typeof({ mixin(enumMixinStr_SHUT_RDWR); }))) {
            mixin(enumMixinStr_SHUT_RDWR);
        }
    }






    static if(!is(typeof(__SOCKADDR_ARG))) {
        private enum enumMixinStr___SOCKADDR_ARG = `enum __SOCKADDR_ARG = sockaddr * __restrict;`;
        static if(is(typeof({ mixin(enumMixinStr___SOCKADDR_ARG); }))) {
            mixin(enumMixinStr___SOCKADDR_ARG);
        }
    }




    static if(!is(typeof(__CONST_SOCKADDR_ARG))) {
        private enum enumMixinStr___CONST_SOCKADDR_ARG = `enum __CONST_SOCKADDR_ARG = const sockaddr *;`;
        static if(is(typeof({ mixin(enumMixinStr___CONST_SOCKADDR_ARG); }))) {
            mixin(enumMixinStr___CONST_SOCKADDR_ARG);
        }
    }
    static if(!is(typeof(_IOC_READ))) {
        private enum enumMixinStr__IOC_READ = `enum _IOC_READ = 2U;`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_READ); }))) {
            mixin(enumMixinStr__IOC_READ);
        }
    }




    static if(!is(typeof(_IOC_WRITE))) {
        private enum enumMixinStr__IOC_WRITE = `enum _IOC_WRITE = 1U;`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_WRITE); }))) {
            mixin(enumMixinStr__IOC_WRITE);
        }
    }




    static if(!is(typeof(_IOC_NONE))) {
        private enum enumMixinStr__IOC_NONE = `enum _IOC_NONE = 0U;`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_NONE); }))) {
            mixin(enumMixinStr__IOC_NONE);
        }
    }




    static if(!is(typeof(_IOC_DIRSHIFT))) {
        private enum enumMixinStr__IOC_DIRSHIFT = `enum _IOC_DIRSHIFT = ( _IOC_SIZESHIFT + _IOC_SIZEBITS );`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_DIRSHIFT); }))) {
            mixin(enumMixinStr__IOC_DIRSHIFT);
        }
    }




    static if(!is(typeof(_IOC_SIZESHIFT))) {
        private enum enumMixinStr__IOC_SIZESHIFT = `enum _IOC_SIZESHIFT = ( _IOC_TYPESHIFT + _IOC_TYPEBITS );`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_SIZESHIFT); }))) {
            mixin(enumMixinStr__IOC_SIZESHIFT);
        }
    }




    static if(!is(typeof(_IOC_TYPESHIFT))) {
        private enum enumMixinStr__IOC_TYPESHIFT = `enum _IOC_TYPESHIFT = ( _IOC_NRSHIFT + _IOC_NRBITS );`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_TYPESHIFT); }))) {
            mixin(enumMixinStr__IOC_TYPESHIFT);
        }
    }




    static if(!is(typeof(_IOC_NRSHIFT))) {
        private enum enumMixinStr__IOC_NRSHIFT = `enum _IOC_NRSHIFT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_NRSHIFT); }))) {
            mixin(enumMixinStr__IOC_NRSHIFT);
        }
    }




    static if(!is(typeof(_IOC_DIRMASK))) {
        private enum enumMixinStr__IOC_DIRMASK = `enum _IOC_DIRMASK = ( ( 1 << _IOC_DIRBITS ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_DIRMASK); }))) {
            mixin(enumMixinStr__IOC_DIRMASK);
        }
    }




    static if(!is(typeof(_IOC_SIZEMASK))) {
        private enum enumMixinStr__IOC_SIZEMASK = `enum _IOC_SIZEMASK = ( ( 1 << _IOC_SIZEBITS ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_SIZEMASK); }))) {
            mixin(enumMixinStr__IOC_SIZEMASK);
        }
    }




    static if(!is(typeof(_IOC_TYPEMASK))) {
        private enum enumMixinStr__IOC_TYPEMASK = `enum _IOC_TYPEMASK = ( ( 1 << _IOC_TYPEBITS ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_TYPEMASK); }))) {
            mixin(enumMixinStr__IOC_TYPEMASK);
        }
    }




    static if(!is(typeof(_IOC_NRMASK))) {
        private enum enumMixinStr__IOC_NRMASK = `enum _IOC_NRMASK = ( ( 1 << _IOC_NRBITS ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_NRMASK); }))) {
            mixin(enumMixinStr__IOC_NRMASK);
        }
    }




    static if(!is(typeof(_IOC_DIRBITS))) {
        private enum enumMixinStr__IOC_DIRBITS = `enum _IOC_DIRBITS = 2;`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_DIRBITS); }))) {
            mixin(enumMixinStr__IOC_DIRBITS);
        }
    }




    static if(!is(typeof(_IOC_SIZEBITS))) {
        private enum enumMixinStr__IOC_SIZEBITS = `enum _IOC_SIZEBITS = 14;`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_SIZEBITS); }))) {
            mixin(enumMixinStr__IOC_SIZEBITS);
        }
    }




    static if(!is(typeof(_IOC_TYPEBITS))) {
        private enum enumMixinStr__IOC_TYPEBITS = `enum _IOC_TYPEBITS = 8;`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_TYPEBITS); }))) {
            mixin(enumMixinStr__IOC_TYPEBITS);
        }
    }




    static if(!is(typeof(_IOC_NRBITS))) {
        private enum enumMixinStr__IOC_NRBITS = `enum _IOC_NRBITS = 8;`;
        static if(is(typeof({ mixin(enumMixinStr__IOC_NRBITS); }))) {
            mixin(enumMixinStr__IOC_NRBITS);
        }
    }
    static if(!is(typeof(EHWPOISON))) {
        private enum enumMixinStr_EHWPOISON = `enum EHWPOISON = 133;`;
        static if(is(typeof({ mixin(enumMixinStr_EHWPOISON); }))) {
            mixin(enumMixinStr_EHWPOISON);
        }
    }




    static if(!is(typeof(ERFKILL))) {
        private enum enumMixinStr_ERFKILL = `enum ERFKILL = 132;`;
        static if(is(typeof({ mixin(enumMixinStr_ERFKILL); }))) {
            mixin(enumMixinStr_ERFKILL);
        }
    }




    static if(!is(typeof(ENOTRECOVERABLE))) {
        private enum enumMixinStr_ENOTRECOVERABLE = `enum ENOTRECOVERABLE = 131;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOTRECOVERABLE); }))) {
            mixin(enumMixinStr_ENOTRECOVERABLE);
        }
    }




    static if(!is(typeof(EOWNERDEAD))) {
        private enum enumMixinStr_EOWNERDEAD = `enum EOWNERDEAD = 130;`;
        static if(is(typeof({ mixin(enumMixinStr_EOWNERDEAD); }))) {
            mixin(enumMixinStr_EOWNERDEAD);
        }
    }




    static if(!is(typeof(EKEYREJECTED))) {
        private enum enumMixinStr_EKEYREJECTED = `enum EKEYREJECTED = 129;`;
        static if(is(typeof({ mixin(enumMixinStr_EKEYREJECTED); }))) {
            mixin(enumMixinStr_EKEYREJECTED);
        }
    }




    static if(!is(typeof(EKEYREVOKED))) {
        private enum enumMixinStr_EKEYREVOKED = `enum EKEYREVOKED = 128;`;
        static if(is(typeof({ mixin(enumMixinStr_EKEYREVOKED); }))) {
            mixin(enumMixinStr_EKEYREVOKED);
        }
    }




    static if(!is(typeof(EKEYEXPIRED))) {
        private enum enumMixinStr_EKEYEXPIRED = `enum EKEYEXPIRED = 127;`;
        static if(is(typeof({ mixin(enumMixinStr_EKEYEXPIRED); }))) {
            mixin(enumMixinStr_EKEYEXPIRED);
        }
    }




    static if(!is(typeof(ENOKEY))) {
        private enum enumMixinStr_ENOKEY = `enum ENOKEY = 126;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOKEY); }))) {
            mixin(enumMixinStr_ENOKEY);
        }
    }




    static if(!is(typeof(ECANCELED))) {
        private enum enumMixinStr_ECANCELED = `enum ECANCELED = 125;`;
        static if(is(typeof({ mixin(enumMixinStr_ECANCELED); }))) {
            mixin(enumMixinStr_ECANCELED);
        }
    }




    static if(!is(typeof(EMEDIUMTYPE))) {
        private enum enumMixinStr_EMEDIUMTYPE = `enum EMEDIUMTYPE = 124;`;
        static if(is(typeof({ mixin(enumMixinStr_EMEDIUMTYPE); }))) {
            mixin(enumMixinStr_EMEDIUMTYPE);
        }
    }




    static if(!is(typeof(ENOMEDIUM))) {
        private enum enumMixinStr_ENOMEDIUM = `enum ENOMEDIUM = 123;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOMEDIUM); }))) {
            mixin(enumMixinStr_ENOMEDIUM);
        }
    }




    static if(!is(typeof(EDQUOT))) {
        private enum enumMixinStr_EDQUOT = `enum EDQUOT = 122;`;
        static if(is(typeof({ mixin(enumMixinStr_EDQUOT); }))) {
            mixin(enumMixinStr_EDQUOT);
        }
    }




    static if(!is(typeof(EREMOTEIO))) {
        private enum enumMixinStr_EREMOTEIO = `enum EREMOTEIO = 121;`;
        static if(is(typeof({ mixin(enumMixinStr_EREMOTEIO); }))) {
            mixin(enumMixinStr_EREMOTEIO);
        }
    }




    static if(!is(typeof(EISNAM))) {
        private enum enumMixinStr_EISNAM = `enum EISNAM = 120;`;
        static if(is(typeof({ mixin(enumMixinStr_EISNAM); }))) {
            mixin(enumMixinStr_EISNAM);
        }
    }




    static if(!is(typeof(ENAVAIL))) {
        private enum enumMixinStr_ENAVAIL = `enum ENAVAIL = 119;`;
        static if(is(typeof({ mixin(enumMixinStr_ENAVAIL); }))) {
            mixin(enumMixinStr_ENAVAIL);
        }
    }




    static if(!is(typeof(ENOTNAM))) {
        private enum enumMixinStr_ENOTNAM = `enum ENOTNAM = 118;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOTNAM); }))) {
            mixin(enumMixinStr_ENOTNAM);
        }
    }






    static if(!is(typeof(TTYDEF_IFLAG))) {
        private enum enumMixinStr_TTYDEF_IFLAG = `enum TTYDEF_IFLAG = ( BRKINT | ISTRIP | ICRNL | IMAXBEL | IXON | IXANY );`;
        static if(is(typeof({ mixin(enumMixinStr_TTYDEF_IFLAG); }))) {
            mixin(enumMixinStr_TTYDEF_IFLAG);
        }
    }




    static if(!is(typeof(TTYDEF_OFLAG))) {
        private enum enumMixinStr_TTYDEF_OFLAG = `enum TTYDEF_OFLAG = ( OPOST | ONLCR | XTABS );`;
        static if(is(typeof({ mixin(enumMixinStr_TTYDEF_OFLAG); }))) {
            mixin(enumMixinStr_TTYDEF_OFLAG);
        }
    }




    static if(!is(typeof(TTYDEF_LFLAG))) {
        private enum enumMixinStr_TTYDEF_LFLAG = `enum TTYDEF_LFLAG = ( ECHO | ICANON | ISIG | IEXTEN | ECHOE | ECHOKE | ECHOCTL );`;
        static if(is(typeof({ mixin(enumMixinStr_TTYDEF_LFLAG); }))) {
            mixin(enumMixinStr_TTYDEF_LFLAG);
        }
    }




    static if(!is(typeof(TTYDEF_CFLAG))) {
        private enum enumMixinStr_TTYDEF_CFLAG = `enum TTYDEF_CFLAG = ( CREAD | CS7 | PARENB | HUPCL );`;
        static if(is(typeof({ mixin(enumMixinStr_TTYDEF_CFLAG); }))) {
            mixin(enumMixinStr_TTYDEF_CFLAG);
        }
    }




    static if(!is(typeof(TTYDEF_SPEED))) {
        private enum enumMixinStr_TTYDEF_SPEED = `enum TTYDEF_SPEED = ( B9600 );`;
        static if(is(typeof({ mixin(enumMixinStr_TTYDEF_SPEED); }))) {
            mixin(enumMixinStr_TTYDEF_SPEED);
        }
    }






    static if(!is(typeof(CEOF))) {
        private enum enumMixinStr_CEOF = `enum CEOF = ( 'd' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CEOF); }))) {
            mixin(enumMixinStr_CEOF);
        }
    }




    static if(!is(typeof(CEOL))) {
        private enum enumMixinStr_CEOL = `enum CEOL = '\0';`;
        static if(is(typeof({ mixin(enumMixinStr_CEOL); }))) {
            mixin(enumMixinStr_CEOL);
        }
    }




    static if(!is(typeof(CERASE))) {
        private enum enumMixinStr_CERASE = `enum CERASE = /+converted from octal '177'+/ 127;`;
        static if(is(typeof({ mixin(enumMixinStr_CERASE); }))) {
            mixin(enumMixinStr_CERASE);
        }
    }




    static if(!is(typeof(CINTR))) {
        private enum enumMixinStr_CINTR = `enum CINTR = ( 'c' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CINTR); }))) {
            mixin(enumMixinStr_CINTR);
        }
    }




    static if(!is(typeof(CSTATUS))) {
        private enum enumMixinStr_CSTATUS = `enum CSTATUS = '\0';`;
        static if(is(typeof({ mixin(enumMixinStr_CSTATUS); }))) {
            mixin(enumMixinStr_CSTATUS);
        }
    }




    static if(!is(typeof(CKILL))) {
        private enum enumMixinStr_CKILL = `enum CKILL = ( 'u' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CKILL); }))) {
            mixin(enumMixinStr_CKILL);
        }
    }




    static if(!is(typeof(CMIN))) {
        private enum enumMixinStr_CMIN = `enum CMIN = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_CMIN); }))) {
            mixin(enumMixinStr_CMIN);
        }
    }




    static if(!is(typeof(CQUIT))) {
        private enum enumMixinStr_CQUIT = `enum CQUIT = /+converted from octal '34'+/ 28;`;
        static if(is(typeof({ mixin(enumMixinStr_CQUIT); }))) {
            mixin(enumMixinStr_CQUIT);
        }
    }




    static if(!is(typeof(CSUSP))) {
        private enum enumMixinStr_CSUSP = `enum CSUSP = ( 'z' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CSUSP); }))) {
            mixin(enumMixinStr_CSUSP);
        }
    }




    static if(!is(typeof(CTIME))) {
        private enum enumMixinStr_CTIME = `enum CTIME = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_CTIME); }))) {
            mixin(enumMixinStr_CTIME);
        }
    }




    static if(!is(typeof(CDSUSP))) {
        private enum enumMixinStr_CDSUSP = `enum CDSUSP = ( 'y' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CDSUSP); }))) {
            mixin(enumMixinStr_CDSUSP);
        }
    }




    static if(!is(typeof(CSTART))) {
        private enum enumMixinStr_CSTART = `enum CSTART = ( 'q' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CSTART); }))) {
            mixin(enumMixinStr_CSTART);
        }
    }




    static if(!is(typeof(CSTOP))) {
        private enum enumMixinStr_CSTOP = `enum CSTOP = ( 's' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CSTOP); }))) {
            mixin(enumMixinStr_CSTOP);
        }
    }




    static if(!is(typeof(CLNEXT))) {
        private enum enumMixinStr_CLNEXT = `enum CLNEXT = ( 'v' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CLNEXT); }))) {
            mixin(enumMixinStr_CLNEXT);
        }
    }




    static if(!is(typeof(CDISCARD))) {
        private enum enumMixinStr_CDISCARD = `enum CDISCARD = ( 'o' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CDISCARD); }))) {
            mixin(enumMixinStr_CDISCARD);
        }
    }




    static if(!is(typeof(CWERASE))) {
        private enum enumMixinStr_CWERASE = `enum CWERASE = ( 'w' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CWERASE); }))) {
            mixin(enumMixinStr_CWERASE);
        }
    }




    static if(!is(typeof(CREPRINT))) {
        private enum enumMixinStr_CREPRINT = `enum CREPRINT = ( 'r' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CREPRINT); }))) {
            mixin(enumMixinStr_CREPRINT);
        }
    }




    static if(!is(typeof(CEOT))) {
        private enum enumMixinStr_CEOT = `enum CEOT = ( 'd' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CEOT); }))) {
            mixin(enumMixinStr_CEOT);
        }
    }




    static if(!is(typeof(CBRK))) {
        private enum enumMixinStr_CBRK = `enum CBRK = '\0';`;
        static if(is(typeof({ mixin(enumMixinStr_CBRK); }))) {
            mixin(enumMixinStr_CBRK);
        }
    }




    static if(!is(typeof(CRPRNT))) {
        private enum enumMixinStr_CRPRNT = `enum CRPRNT = ( 'r' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CRPRNT); }))) {
            mixin(enumMixinStr_CRPRNT);
        }
    }




    static if(!is(typeof(CFLUSH))) {
        private enum enumMixinStr_CFLUSH = `enum CFLUSH = ( 'o' & /+converted from octal '37'+/ 31 );`;
        static if(is(typeof({ mixin(enumMixinStr_CFLUSH); }))) {
            mixin(enumMixinStr_CFLUSH);
        }
    }




    static if(!is(typeof(_SYS_TYPES_H))) {
        private enum enumMixinStr__SYS_TYPES_H = `enum _SYS_TYPES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__SYS_TYPES_H); }))) {
            mixin(enumMixinStr__SYS_TYPES_H);
        }
    }




    static if(!is(typeof(EUCLEAN))) {
        private enum enumMixinStr_EUCLEAN = `enum EUCLEAN = 117;`;
        static if(is(typeof({ mixin(enumMixinStr_EUCLEAN); }))) {
            mixin(enumMixinStr_EUCLEAN);
        }
    }




    static if(!is(typeof(ESTALE))) {
        private enum enumMixinStr_ESTALE = `enum ESTALE = 116;`;
        static if(is(typeof({ mixin(enumMixinStr_ESTALE); }))) {
            mixin(enumMixinStr_ESTALE);
        }
    }




    static if(!is(typeof(EINPROGRESS))) {
        private enum enumMixinStr_EINPROGRESS = `enum EINPROGRESS = 115;`;
        static if(is(typeof({ mixin(enumMixinStr_EINPROGRESS); }))) {
            mixin(enumMixinStr_EINPROGRESS);
        }
    }




    static if(!is(typeof(EALREADY))) {
        private enum enumMixinStr_EALREADY = `enum EALREADY = 114;`;
        static if(is(typeof({ mixin(enumMixinStr_EALREADY); }))) {
            mixin(enumMixinStr_EALREADY);
        }
    }




    static if(!is(typeof(EHOSTUNREACH))) {
        private enum enumMixinStr_EHOSTUNREACH = `enum EHOSTUNREACH = 113;`;
        static if(is(typeof({ mixin(enumMixinStr_EHOSTUNREACH); }))) {
            mixin(enumMixinStr_EHOSTUNREACH);
        }
    }




    static if(!is(typeof(EHOSTDOWN))) {
        private enum enumMixinStr_EHOSTDOWN = `enum EHOSTDOWN = 112;`;
        static if(is(typeof({ mixin(enumMixinStr_EHOSTDOWN); }))) {
            mixin(enumMixinStr_EHOSTDOWN);
        }
    }




    static if(!is(typeof(ECONNREFUSED))) {
        private enum enumMixinStr_ECONNREFUSED = `enum ECONNREFUSED = 111;`;
        static if(is(typeof({ mixin(enumMixinStr_ECONNREFUSED); }))) {
            mixin(enumMixinStr_ECONNREFUSED);
        }
    }




    static if(!is(typeof(ETIMEDOUT))) {
        private enum enumMixinStr_ETIMEDOUT = `enum ETIMEDOUT = 110;`;
        static if(is(typeof({ mixin(enumMixinStr_ETIMEDOUT); }))) {
            mixin(enumMixinStr_ETIMEDOUT);
        }
    }




    static if(!is(typeof(ETOOMANYREFS))) {
        private enum enumMixinStr_ETOOMANYREFS = `enum ETOOMANYREFS = 109;`;
        static if(is(typeof({ mixin(enumMixinStr_ETOOMANYREFS); }))) {
            mixin(enumMixinStr_ETOOMANYREFS);
        }
    }




    static if(!is(typeof(ESHUTDOWN))) {
        private enum enumMixinStr_ESHUTDOWN = `enum ESHUTDOWN = 108;`;
        static if(is(typeof({ mixin(enumMixinStr_ESHUTDOWN); }))) {
            mixin(enumMixinStr_ESHUTDOWN);
        }
    }




    static if(!is(typeof(ENOTCONN))) {
        private enum enumMixinStr_ENOTCONN = `enum ENOTCONN = 107;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOTCONN); }))) {
            mixin(enumMixinStr_ENOTCONN);
        }
    }






    static if(!is(typeof(EISCONN))) {
        private enum enumMixinStr_EISCONN = `enum EISCONN = 106;`;
        static if(is(typeof({ mixin(enumMixinStr_EISCONN); }))) {
            mixin(enumMixinStr_EISCONN);
        }
    }




    static if(!is(typeof(ENOBUFS))) {
        private enum enumMixinStr_ENOBUFS = `enum ENOBUFS = 105;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOBUFS); }))) {
            mixin(enumMixinStr_ENOBUFS);
        }
    }






    static if(!is(typeof(ECONNRESET))) {
        private enum enumMixinStr_ECONNRESET = `enum ECONNRESET = 104;`;
        static if(is(typeof({ mixin(enumMixinStr_ECONNRESET); }))) {
            mixin(enumMixinStr_ECONNRESET);
        }
    }






    static if(!is(typeof(ECONNABORTED))) {
        private enum enumMixinStr_ECONNABORTED = `enum ECONNABORTED = 103;`;
        static if(is(typeof({ mixin(enumMixinStr_ECONNABORTED); }))) {
            mixin(enumMixinStr_ECONNABORTED);
        }
    }






    static if(!is(typeof(ENETRESET))) {
        private enum enumMixinStr_ENETRESET = `enum ENETRESET = 102;`;
        static if(is(typeof({ mixin(enumMixinStr_ENETRESET); }))) {
            mixin(enumMixinStr_ENETRESET);
        }
    }






    static if(!is(typeof(ENETUNREACH))) {
        private enum enumMixinStr_ENETUNREACH = `enum ENETUNREACH = 101;`;
        static if(is(typeof({ mixin(enumMixinStr_ENETUNREACH); }))) {
            mixin(enumMixinStr_ENETUNREACH);
        }
    }






    static if(!is(typeof(ENETDOWN))) {
        private enum enumMixinStr_ENETDOWN = `enum ENETDOWN = 100;`;
        static if(is(typeof({ mixin(enumMixinStr_ENETDOWN); }))) {
            mixin(enumMixinStr_ENETDOWN);
        }
    }






    static if(!is(typeof(EADDRNOTAVAIL))) {
        private enum enumMixinStr_EADDRNOTAVAIL = `enum EADDRNOTAVAIL = 99;`;
        static if(is(typeof({ mixin(enumMixinStr_EADDRNOTAVAIL); }))) {
            mixin(enumMixinStr_EADDRNOTAVAIL);
        }
    }






    static if(!is(typeof(EADDRINUSE))) {
        private enum enumMixinStr_EADDRINUSE = `enum EADDRINUSE = 98;`;
        static if(is(typeof({ mixin(enumMixinStr_EADDRINUSE); }))) {
            mixin(enumMixinStr_EADDRINUSE);
        }
    }






    static if(!is(typeof(EAFNOSUPPORT))) {
        private enum enumMixinStr_EAFNOSUPPORT = `enum EAFNOSUPPORT = 97;`;
        static if(is(typeof({ mixin(enumMixinStr_EAFNOSUPPORT); }))) {
            mixin(enumMixinStr_EAFNOSUPPORT);
        }
    }




    static if(!is(typeof(EPFNOSUPPORT))) {
        private enum enumMixinStr_EPFNOSUPPORT = `enum EPFNOSUPPORT = 96;`;
        static if(is(typeof({ mixin(enumMixinStr_EPFNOSUPPORT); }))) {
            mixin(enumMixinStr_EPFNOSUPPORT);
        }
    }






    static if(!is(typeof(EOPNOTSUPP))) {
        private enum enumMixinStr_EOPNOTSUPP = `enum EOPNOTSUPP = 95;`;
        static if(is(typeof({ mixin(enumMixinStr_EOPNOTSUPP); }))) {
            mixin(enumMixinStr_EOPNOTSUPP);
        }
    }






    static if(!is(typeof(ESOCKTNOSUPPORT))) {
        private enum enumMixinStr_ESOCKTNOSUPPORT = `enum ESOCKTNOSUPPORT = 94;`;
        static if(is(typeof({ mixin(enumMixinStr_ESOCKTNOSUPPORT); }))) {
            mixin(enumMixinStr_ESOCKTNOSUPPORT);
        }
    }




    static if(!is(typeof(EPROTONOSUPPORT))) {
        private enum enumMixinStr_EPROTONOSUPPORT = `enum EPROTONOSUPPORT = 93;`;
        static if(is(typeof({ mixin(enumMixinStr_EPROTONOSUPPORT); }))) {
            mixin(enumMixinStr_EPROTONOSUPPORT);
        }
    }




    static if(!is(typeof(ENOPROTOOPT))) {
        private enum enumMixinStr_ENOPROTOOPT = `enum ENOPROTOOPT = 92;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOPROTOOPT); }))) {
            mixin(enumMixinStr_ENOPROTOOPT);
        }
    }






    static if(!is(typeof(EPROTOTYPE))) {
        private enum enumMixinStr_EPROTOTYPE = `enum EPROTOTYPE = 91;`;
        static if(is(typeof({ mixin(enumMixinStr_EPROTOTYPE); }))) {
            mixin(enumMixinStr_EPROTOTYPE);
        }
    }




    static if(!is(typeof(EMSGSIZE))) {
        private enum enumMixinStr_EMSGSIZE = `enum EMSGSIZE = 90;`;
        static if(is(typeof({ mixin(enumMixinStr_EMSGSIZE); }))) {
            mixin(enumMixinStr_EMSGSIZE);
        }
    }






    static if(!is(typeof(EDESTADDRREQ))) {
        private enum enumMixinStr_EDESTADDRREQ = `enum EDESTADDRREQ = 89;`;
        static if(is(typeof({ mixin(enumMixinStr_EDESTADDRREQ); }))) {
            mixin(enumMixinStr_EDESTADDRREQ);
        }
    }




    static if(!is(typeof(ENOTSOCK))) {
        private enum enumMixinStr_ENOTSOCK = `enum ENOTSOCK = 88;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOTSOCK); }))) {
            mixin(enumMixinStr_ENOTSOCK);
        }
    }




    static if(!is(typeof(EUSERS))) {
        private enum enumMixinStr_EUSERS = `enum EUSERS = 87;`;
        static if(is(typeof({ mixin(enumMixinStr_EUSERS); }))) {
            mixin(enumMixinStr_EUSERS);
        }
    }




    static if(!is(typeof(ESTRPIPE))) {
        private enum enumMixinStr_ESTRPIPE = `enum ESTRPIPE = 86;`;
        static if(is(typeof({ mixin(enumMixinStr_ESTRPIPE); }))) {
            mixin(enumMixinStr_ESTRPIPE);
        }
    }




    static if(!is(typeof(ERESTART))) {
        private enum enumMixinStr_ERESTART = `enum ERESTART = 85;`;
        static if(is(typeof({ mixin(enumMixinStr_ERESTART); }))) {
            mixin(enumMixinStr_ERESTART);
        }
    }




    static if(!is(typeof(EILSEQ))) {
        private enum enumMixinStr_EILSEQ = `enum EILSEQ = 84;`;
        static if(is(typeof({ mixin(enumMixinStr_EILSEQ); }))) {
            mixin(enumMixinStr_EILSEQ);
        }
    }




    static if(!is(typeof(ELIBEXEC))) {
        private enum enumMixinStr_ELIBEXEC = `enum ELIBEXEC = 83;`;
        static if(is(typeof({ mixin(enumMixinStr_ELIBEXEC); }))) {
            mixin(enumMixinStr_ELIBEXEC);
        }
    }




    static if(!is(typeof(ELIBMAX))) {
        private enum enumMixinStr_ELIBMAX = `enum ELIBMAX = 82;`;
        static if(is(typeof({ mixin(enumMixinStr_ELIBMAX); }))) {
            mixin(enumMixinStr_ELIBMAX);
        }
    }




    static if(!is(typeof(ELIBSCN))) {
        private enum enumMixinStr_ELIBSCN = `enum ELIBSCN = 81;`;
        static if(is(typeof({ mixin(enumMixinStr_ELIBSCN); }))) {
            mixin(enumMixinStr_ELIBSCN);
        }
    }




    static if(!is(typeof(ELIBBAD))) {
        private enum enumMixinStr_ELIBBAD = `enum ELIBBAD = 80;`;
        static if(is(typeof({ mixin(enumMixinStr_ELIBBAD); }))) {
            mixin(enumMixinStr_ELIBBAD);
        }
    }




    static if(!is(typeof(ELIBACC))) {
        private enum enumMixinStr_ELIBACC = `enum ELIBACC = 79;`;
        static if(is(typeof({ mixin(enumMixinStr_ELIBACC); }))) {
            mixin(enumMixinStr_ELIBACC);
        }
    }




    static if(!is(typeof(EREMCHG))) {
        private enum enumMixinStr_EREMCHG = `enum EREMCHG = 78;`;
        static if(is(typeof({ mixin(enumMixinStr_EREMCHG); }))) {
            mixin(enumMixinStr_EREMCHG);
        }
    }




    static if(!is(typeof(EBADFD))) {
        private enum enumMixinStr_EBADFD = `enum EBADFD = 77;`;
        static if(is(typeof({ mixin(enumMixinStr_EBADFD); }))) {
            mixin(enumMixinStr_EBADFD);
        }
    }




    static if(!is(typeof(ENOTUNIQ))) {
        private enum enumMixinStr_ENOTUNIQ = `enum ENOTUNIQ = 76;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOTUNIQ); }))) {
            mixin(enumMixinStr_ENOTUNIQ);
        }
    }




    static if(!is(typeof(EOVERFLOW))) {
        private enum enumMixinStr_EOVERFLOW = `enum EOVERFLOW = 75;`;
        static if(is(typeof({ mixin(enumMixinStr_EOVERFLOW); }))) {
            mixin(enumMixinStr_EOVERFLOW);
        }
    }




    static if(!is(typeof(EBADMSG))) {
        private enum enumMixinStr_EBADMSG = `enum EBADMSG = 74;`;
        static if(is(typeof({ mixin(enumMixinStr_EBADMSG); }))) {
            mixin(enumMixinStr_EBADMSG);
        }
    }




    static if(!is(typeof(EDOTDOT))) {
        private enum enumMixinStr_EDOTDOT = `enum EDOTDOT = 73;`;
        static if(is(typeof({ mixin(enumMixinStr_EDOTDOT); }))) {
            mixin(enumMixinStr_EDOTDOT);
        }
    }




    static if(!is(typeof(__BIT_TYPES_DEFINED__))) {
        private enum enumMixinStr___BIT_TYPES_DEFINED__ = `enum __BIT_TYPES_DEFINED__ = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___BIT_TYPES_DEFINED__); }))) {
            mixin(enumMixinStr___BIT_TYPES_DEFINED__);
        }
    }




    static if(!is(typeof(EMULTIHOP))) {
        private enum enumMixinStr_EMULTIHOP = `enum EMULTIHOP = 72;`;
        static if(is(typeof({ mixin(enumMixinStr_EMULTIHOP); }))) {
            mixin(enumMixinStr_EMULTIHOP);
        }
    }




    static if(!is(typeof(EPROTO))) {
        private enum enumMixinStr_EPROTO = `enum EPROTO = 71;`;
        static if(is(typeof({ mixin(enumMixinStr_EPROTO); }))) {
            mixin(enumMixinStr_EPROTO);
        }
    }




    static if(!is(typeof(ECOMM))) {
        private enum enumMixinStr_ECOMM = `enum ECOMM = 70;`;
        static if(is(typeof({ mixin(enumMixinStr_ECOMM); }))) {
            mixin(enumMixinStr_ECOMM);
        }
    }




    static if(!is(typeof(ESRMNT))) {
        private enum enumMixinStr_ESRMNT = `enum ESRMNT = 69;`;
        static if(is(typeof({ mixin(enumMixinStr_ESRMNT); }))) {
            mixin(enumMixinStr_ESRMNT);
        }
    }




    static if(!is(typeof(EADV))) {
        private enum enumMixinStr_EADV = `enum EADV = 68;`;
        static if(is(typeof({ mixin(enumMixinStr_EADV); }))) {
            mixin(enumMixinStr_EADV);
        }
    }






    static if(!is(typeof(ENOLINK))) {
        private enum enumMixinStr_ENOLINK = `enum ENOLINK = 67;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOLINK); }))) {
            mixin(enumMixinStr_ENOLINK);
        }
    }






    static if(!is(typeof(EREMOTE))) {
        private enum enumMixinStr_EREMOTE = `enum EREMOTE = 66;`;
        static if(is(typeof({ mixin(enumMixinStr_EREMOTE); }))) {
            mixin(enumMixinStr_EREMOTE);
        }
    }






    static if(!is(typeof(ENOPKG))) {
        private enum enumMixinStr_ENOPKG = `enum ENOPKG = 65;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOPKG); }))) {
            mixin(enumMixinStr_ENOPKG);
        }
    }






    static if(!is(typeof(ENONET))) {
        private enum enumMixinStr_ENONET = `enum ENONET = 64;`;
        static if(is(typeof({ mixin(enumMixinStr_ENONET); }))) {
            mixin(enumMixinStr_ENONET);
        }
    }




    static if(!is(typeof(ENOSR))) {
        private enum enumMixinStr_ENOSR = `enum ENOSR = 63;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOSR); }))) {
            mixin(enumMixinStr_ENOSR);
        }
    }




    static if(!is(typeof(ETIME))) {
        private enum enumMixinStr_ETIME = `enum ETIME = 62;`;
        static if(is(typeof({ mixin(enumMixinStr_ETIME); }))) {
            mixin(enumMixinStr_ETIME);
        }
    }




    static if(!is(typeof(_UNISTD_H))) {
        private enum enumMixinStr__UNISTD_H = `enum _UNISTD_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__UNISTD_H); }))) {
            mixin(enumMixinStr__UNISTD_H);
        }
    }




    static if(!is(typeof(ENODATA))) {
        private enum enumMixinStr_ENODATA = `enum ENODATA = 61;`;
        static if(is(typeof({ mixin(enumMixinStr_ENODATA); }))) {
            mixin(enumMixinStr_ENODATA);
        }
    }




    static if(!is(typeof(ENOSTR))) {
        private enum enumMixinStr_ENOSTR = `enum ENOSTR = 60;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOSTR); }))) {
            mixin(enumMixinStr_ENOSTR);
        }
    }




    static if(!is(typeof(EBFONT))) {
        private enum enumMixinStr_EBFONT = `enum EBFONT = 59;`;
        static if(is(typeof({ mixin(enumMixinStr_EBFONT); }))) {
            mixin(enumMixinStr_EBFONT);
        }
    }




    static if(!is(typeof(_POSIX_VERSION))) {
        private enum enumMixinStr__POSIX_VERSION = `enum _POSIX_VERSION = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_VERSION); }))) {
            mixin(enumMixinStr__POSIX_VERSION);
        }
    }




    static if(!is(typeof(EDEADLOCK))) {
        private enum enumMixinStr_EDEADLOCK = `enum EDEADLOCK = EDEADLK;`;
        static if(is(typeof({ mixin(enumMixinStr_EDEADLOCK); }))) {
            mixin(enumMixinStr_EDEADLOCK);
        }
    }




    static if(!is(typeof(__POSIX2_THIS_VERSION))) {
        private enum enumMixinStr___POSIX2_THIS_VERSION = `enum __POSIX2_THIS_VERSION = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr___POSIX2_THIS_VERSION); }))) {
            mixin(enumMixinStr___POSIX2_THIS_VERSION);
        }
    }




    static if(!is(typeof(_POSIX2_VERSION))) {
        private enum enumMixinStr__POSIX2_VERSION = `enum _POSIX2_VERSION = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_VERSION); }))) {
            mixin(enumMixinStr__POSIX2_VERSION);
        }
    }




    static if(!is(typeof(_POSIX2_C_VERSION))) {
        private enum enumMixinStr__POSIX2_C_VERSION = `enum _POSIX2_C_VERSION = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_C_VERSION); }))) {
            mixin(enumMixinStr__POSIX2_C_VERSION);
        }
    }




    static if(!is(typeof(_POSIX2_C_BIND))) {
        private enum enumMixinStr__POSIX2_C_BIND = `enum _POSIX2_C_BIND = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_C_BIND); }))) {
            mixin(enumMixinStr__POSIX2_C_BIND);
        }
    }




    static if(!is(typeof(_POSIX2_C_DEV))) {
        private enum enumMixinStr__POSIX2_C_DEV = `enum _POSIX2_C_DEV = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_C_DEV); }))) {
            mixin(enumMixinStr__POSIX2_C_DEV);
        }
    }




    static if(!is(typeof(_POSIX2_SW_DEV))) {
        private enum enumMixinStr__POSIX2_SW_DEV = `enum _POSIX2_SW_DEV = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_SW_DEV); }))) {
            mixin(enumMixinStr__POSIX2_SW_DEV);
        }
    }




    static if(!is(typeof(_POSIX2_LOCALEDEF))) {
        private enum enumMixinStr__POSIX2_LOCALEDEF = `enum _POSIX2_LOCALEDEF = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_LOCALEDEF); }))) {
            mixin(enumMixinStr__POSIX2_LOCALEDEF);
        }
    }




    static if(!is(typeof(EBADSLT))) {
        private enum enumMixinStr_EBADSLT = `enum EBADSLT = 57;`;
        static if(is(typeof({ mixin(enumMixinStr_EBADSLT); }))) {
            mixin(enumMixinStr_EBADSLT);
        }
    }




    static if(!is(typeof(_XOPEN_VERSION))) {
        private enum enumMixinStr__XOPEN_VERSION = `enum _XOPEN_VERSION = 700;`;
        static if(is(typeof({ mixin(enumMixinStr__XOPEN_VERSION); }))) {
            mixin(enumMixinStr__XOPEN_VERSION);
        }
    }




    static if(!is(typeof(_XOPEN_XCU_VERSION))) {
        private enum enumMixinStr__XOPEN_XCU_VERSION = `enum _XOPEN_XCU_VERSION = 4;`;
        static if(is(typeof({ mixin(enumMixinStr__XOPEN_XCU_VERSION); }))) {
            mixin(enumMixinStr__XOPEN_XCU_VERSION);
        }
    }




    static if(!is(typeof(_XOPEN_XPG2))) {
        private enum enumMixinStr__XOPEN_XPG2 = `enum _XOPEN_XPG2 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__XOPEN_XPG2); }))) {
            mixin(enumMixinStr__XOPEN_XPG2);
        }
    }




    static if(!is(typeof(_XOPEN_XPG3))) {
        private enum enumMixinStr__XOPEN_XPG3 = `enum _XOPEN_XPG3 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__XOPEN_XPG3); }))) {
            mixin(enumMixinStr__XOPEN_XPG3);
        }
    }




    static if(!is(typeof(_XOPEN_XPG4))) {
        private enum enumMixinStr__XOPEN_XPG4 = `enum _XOPEN_XPG4 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__XOPEN_XPG4); }))) {
            mixin(enumMixinStr__XOPEN_XPG4);
        }
    }




    static if(!is(typeof(_XOPEN_UNIX))) {
        private enum enumMixinStr__XOPEN_UNIX = `enum _XOPEN_UNIX = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__XOPEN_UNIX); }))) {
            mixin(enumMixinStr__XOPEN_UNIX);
        }
    }




    static if(!is(typeof(_XOPEN_ENH_I18N))) {
        private enum enumMixinStr__XOPEN_ENH_I18N = `enum _XOPEN_ENH_I18N = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__XOPEN_ENH_I18N); }))) {
            mixin(enumMixinStr__XOPEN_ENH_I18N);
        }
    }




    static if(!is(typeof(_XOPEN_LEGACY))) {
        private enum enumMixinStr__XOPEN_LEGACY = `enum _XOPEN_LEGACY = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__XOPEN_LEGACY); }))) {
            mixin(enumMixinStr__XOPEN_LEGACY);
        }
    }




    static if(!is(typeof(EBADRQC))) {
        private enum enumMixinStr_EBADRQC = `enum EBADRQC = 56;`;
        static if(is(typeof({ mixin(enumMixinStr_EBADRQC); }))) {
            mixin(enumMixinStr_EBADRQC);
        }
    }




    static if(!is(typeof(ENOANO))) {
        private enum enumMixinStr_ENOANO = `enum ENOANO = 55;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOANO); }))) {
            mixin(enumMixinStr_ENOANO);
        }
    }




    static if(!is(typeof(EXFULL))) {
        private enum enumMixinStr_EXFULL = `enum EXFULL = 54;`;
        static if(is(typeof({ mixin(enumMixinStr_EXFULL); }))) {
            mixin(enumMixinStr_EXFULL);
        }
    }




    static if(!is(typeof(STDIN_FILENO))) {
        private enum enumMixinStr_STDIN_FILENO = `enum STDIN_FILENO = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_STDIN_FILENO); }))) {
            mixin(enumMixinStr_STDIN_FILENO);
        }
    }




    static if(!is(typeof(STDOUT_FILENO))) {
        private enum enumMixinStr_STDOUT_FILENO = `enum STDOUT_FILENO = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_STDOUT_FILENO); }))) {
            mixin(enumMixinStr_STDOUT_FILENO);
        }
    }




    static if(!is(typeof(STDERR_FILENO))) {
        private enum enumMixinStr_STDERR_FILENO = `enum STDERR_FILENO = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_STDERR_FILENO); }))) {
            mixin(enumMixinStr_STDERR_FILENO);
        }
    }




    static if(!is(typeof(EBADR))) {
        private enum enumMixinStr_EBADR = `enum EBADR = 53;`;
        static if(is(typeof({ mixin(enumMixinStr_EBADR); }))) {
            mixin(enumMixinStr_EBADR);
        }
    }




    static if(!is(typeof(EBADE))) {
        private enum enumMixinStr_EBADE = `enum EBADE = 52;`;
        static if(is(typeof({ mixin(enumMixinStr_EBADE); }))) {
            mixin(enumMixinStr_EBADE);
        }
    }




    static if(!is(typeof(EL2HLT))) {
        private enum enumMixinStr_EL2HLT = `enum EL2HLT = 51;`;
        static if(is(typeof({ mixin(enumMixinStr_EL2HLT); }))) {
            mixin(enumMixinStr_EL2HLT);
        }
    }




    static if(!is(typeof(ENOCSI))) {
        private enum enumMixinStr_ENOCSI = `enum ENOCSI = 50;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOCSI); }))) {
            mixin(enumMixinStr_ENOCSI);
        }
    }




    static if(!is(typeof(EUNATCH))) {
        private enum enumMixinStr_EUNATCH = `enum EUNATCH = 49;`;
        static if(is(typeof({ mixin(enumMixinStr_EUNATCH); }))) {
            mixin(enumMixinStr_EUNATCH);
        }
    }




    static if(!is(typeof(ELNRNG))) {
        private enum enumMixinStr_ELNRNG = `enum ELNRNG = 48;`;
        static if(is(typeof({ mixin(enumMixinStr_ELNRNG); }))) {
            mixin(enumMixinStr_ELNRNG);
        }
    }




    static if(!is(typeof(EL3RST))) {
        private enum enumMixinStr_EL3RST = `enum EL3RST = 47;`;
        static if(is(typeof({ mixin(enumMixinStr_EL3RST); }))) {
            mixin(enumMixinStr_EL3RST);
        }
    }




    static if(!is(typeof(EL3HLT))) {
        private enum enumMixinStr_EL3HLT = `enum EL3HLT = 46;`;
        static if(is(typeof({ mixin(enumMixinStr_EL3HLT); }))) {
            mixin(enumMixinStr_EL3HLT);
        }
    }






    static if(!is(typeof(EL2NSYNC))) {
        private enum enumMixinStr_EL2NSYNC = `enum EL2NSYNC = 45;`;
        static if(is(typeof({ mixin(enumMixinStr_EL2NSYNC); }))) {
            mixin(enumMixinStr_EL2NSYNC);
        }
    }




    static if(!is(typeof(ECHRNG))) {
        private enum enumMixinStr_ECHRNG = `enum ECHRNG = 44;`;
        static if(is(typeof({ mixin(enumMixinStr_ECHRNG); }))) {
            mixin(enumMixinStr_ECHRNG);
        }
    }




    static if(!is(typeof(EIDRM))) {
        private enum enumMixinStr_EIDRM = `enum EIDRM = 43;`;
        static if(is(typeof({ mixin(enumMixinStr_EIDRM); }))) {
            mixin(enumMixinStr_EIDRM);
        }
    }






    static if(!is(typeof(ENOMSG))) {
        private enum enumMixinStr_ENOMSG = `enum ENOMSG = 42;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOMSG); }))) {
            mixin(enumMixinStr_ENOMSG);
        }
    }




    static if(!is(typeof(EWOULDBLOCK))) {
        private enum enumMixinStr_EWOULDBLOCK = `enum EWOULDBLOCK = EAGAIN;`;
        static if(is(typeof({ mixin(enumMixinStr_EWOULDBLOCK); }))) {
            mixin(enumMixinStr_EWOULDBLOCK);
        }
    }




    static if(!is(typeof(ELOOP))) {
        private enum enumMixinStr_ELOOP = `enum ELOOP = 40;`;
        static if(is(typeof({ mixin(enumMixinStr_ELOOP); }))) {
            mixin(enumMixinStr_ELOOP);
        }
    }




    static if(!is(typeof(ENOTEMPTY))) {
        private enum enumMixinStr_ENOTEMPTY = `enum ENOTEMPTY = 39;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOTEMPTY); }))) {
            mixin(enumMixinStr_ENOTEMPTY);
        }
    }




    static if(!is(typeof(ENOSYS))) {
        private enum enumMixinStr_ENOSYS = `enum ENOSYS = 38;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOSYS); }))) {
            mixin(enumMixinStr_ENOSYS);
        }
    }




    static if(!is(typeof(ENOLCK))) {
        private enum enumMixinStr_ENOLCK = `enum ENOLCK = 37;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOLCK); }))) {
            mixin(enumMixinStr_ENOLCK);
        }
    }




    static if(!is(typeof(ENAMETOOLONG))) {
        private enum enumMixinStr_ENAMETOOLONG = `enum ENAMETOOLONG = 36;`;
        static if(is(typeof({ mixin(enumMixinStr_ENAMETOOLONG); }))) {
            mixin(enumMixinStr_ENAMETOOLONG);
        }
    }




    static if(!is(typeof(EDEADLK))) {
        private enum enumMixinStr_EDEADLK = `enum EDEADLK = 35;`;
        static if(is(typeof({ mixin(enumMixinStr_EDEADLK); }))) {
            mixin(enumMixinStr_EDEADLK);
        }
    }






    static if(!is(typeof(ERANGE))) {
        private enum enumMixinStr_ERANGE = `enum ERANGE = 34;`;
        static if(is(typeof({ mixin(enumMixinStr_ERANGE); }))) {
            mixin(enumMixinStr_ERANGE);
        }
    }




    static if(!is(typeof(EDOM))) {
        private enum enumMixinStr_EDOM = `enum EDOM = 33;`;
        static if(is(typeof({ mixin(enumMixinStr_EDOM); }))) {
            mixin(enumMixinStr_EDOM);
        }
    }




    static if(!is(typeof(EPIPE))) {
        private enum enumMixinStr_EPIPE = `enum EPIPE = 32;`;
        static if(is(typeof({ mixin(enumMixinStr_EPIPE); }))) {
            mixin(enumMixinStr_EPIPE);
        }
    }




    static if(!is(typeof(L_SET))) {
        private enum enumMixinStr_L_SET = `enum L_SET = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_L_SET); }))) {
            mixin(enumMixinStr_L_SET);
        }
    }




    static if(!is(typeof(L_INCR))) {
        private enum enumMixinStr_L_INCR = `enum L_INCR = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_L_INCR); }))) {
            mixin(enumMixinStr_L_INCR);
        }
    }




    static if(!is(typeof(L_XTND))) {
        private enum enumMixinStr_L_XTND = `enum L_XTND = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_L_XTND); }))) {
            mixin(enumMixinStr_L_XTND);
        }
    }




    static if(!is(typeof(EMLINK))) {
        private enum enumMixinStr_EMLINK = `enum EMLINK = 31;`;
        static if(is(typeof({ mixin(enumMixinStr_EMLINK); }))) {
            mixin(enumMixinStr_EMLINK);
        }
    }




    static if(!is(typeof(EROFS))) {
        private enum enumMixinStr_EROFS = `enum EROFS = 30;`;
        static if(is(typeof({ mixin(enumMixinStr_EROFS); }))) {
            mixin(enumMixinStr_EROFS);
        }
    }




    static if(!is(typeof(ESPIPE))) {
        private enum enumMixinStr_ESPIPE = `enum ESPIPE = 29;`;
        static if(is(typeof({ mixin(enumMixinStr_ESPIPE); }))) {
            mixin(enumMixinStr_ESPIPE);
        }
    }




    static if(!is(typeof(ENOSPC))) {
        private enum enumMixinStr_ENOSPC = `enum ENOSPC = 28;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOSPC); }))) {
            mixin(enumMixinStr_ENOSPC);
        }
    }




    static if(!is(typeof(EFBIG))) {
        private enum enumMixinStr_EFBIG = `enum EFBIG = 27;`;
        static if(is(typeof({ mixin(enumMixinStr_EFBIG); }))) {
            mixin(enumMixinStr_EFBIG);
        }
    }




    static if(!is(typeof(ETXTBSY))) {
        private enum enumMixinStr_ETXTBSY = `enum ETXTBSY = 26;`;
        static if(is(typeof({ mixin(enumMixinStr_ETXTBSY); }))) {
            mixin(enumMixinStr_ETXTBSY);
        }
    }




    static if(!is(typeof(ENOTTY))) {
        private enum enumMixinStr_ENOTTY = `enum ENOTTY = 25;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOTTY); }))) {
            mixin(enumMixinStr_ENOTTY);
        }
    }




    static if(!is(typeof(EMFILE))) {
        private enum enumMixinStr_EMFILE = `enum EMFILE = 24;`;
        static if(is(typeof({ mixin(enumMixinStr_EMFILE); }))) {
            mixin(enumMixinStr_EMFILE);
        }
    }




    static if(!is(typeof(ENFILE))) {
        private enum enumMixinStr_ENFILE = `enum ENFILE = 23;`;
        static if(is(typeof({ mixin(enumMixinStr_ENFILE); }))) {
            mixin(enumMixinStr_ENFILE);
        }
    }




    static if(!is(typeof(EINVAL))) {
        private enum enumMixinStr_EINVAL = `enum EINVAL = 22;`;
        static if(is(typeof({ mixin(enumMixinStr_EINVAL); }))) {
            mixin(enumMixinStr_EINVAL);
        }
    }




    static if(!is(typeof(EISDIR))) {
        private enum enumMixinStr_EISDIR = `enum EISDIR = 21;`;
        static if(is(typeof({ mixin(enumMixinStr_EISDIR); }))) {
            mixin(enumMixinStr_EISDIR);
        }
    }




    static if(!is(typeof(ENOTDIR))) {
        private enum enumMixinStr_ENOTDIR = `enum ENOTDIR = 20;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOTDIR); }))) {
            mixin(enumMixinStr_ENOTDIR);
        }
    }




    static if(!is(typeof(ENODEV))) {
        private enum enumMixinStr_ENODEV = `enum ENODEV = 19;`;
        static if(is(typeof({ mixin(enumMixinStr_ENODEV); }))) {
            mixin(enumMixinStr_ENODEV);
        }
    }




    static if(!is(typeof(EXDEV))) {
        private enum enumMixinStr_EXDEV = `enum EXDEV = 18;`;
        static if(is(typeof({ mixin(enumMixinStr_EXDEV); }))) {
            mixin(enumMixinStr_EXDEV);
        }
    }




    static if(!is(typeof(EEXIST))) {
        private enum enumMixinStr_EEXIST = `enum EEXIST = 17;`;
        static if(is(typeof({ mixin(enumMixinStr_EEXIST); }))) {
            mixin(enumMixinStr_EEXIST);
        }
    }




    static if(!is(typeof(EBUSY))) {
        private enum enumMixinStr_EBUSY = `enum EBUSY = 16;`;
        static if(is(typeof({ mixin(enumMixinStr_EBUSY); }))) {
            mixin(enumMixinStr_EBUSY);
        }
    }




    static if(!is(typeof(ENOTBLK))) {
        private enum enumMixinStr_ENOTBLK = `enum ENOTBLK = 15;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOTBLK); }))) {
            mixin(enumMixinStr_ENOTBLK);
        }
    }




    static if(!is(typeof(EFAULT))) {
        private enum enumMixinStr_EFAULT = `enum EFAULT = 14;`;
        static if(is(typeof({ mixin(enumMixinStr_EFAULT); }))) {
            mixin(enumMixinStr_EFAULT);
        }
    }




    static if(!is(typeof(EACCES))) {
        private enum enumMixinStr_EACCES = `enum EACCES = 13;`;
        static if(is(typeof({ mixin(enumMixinStr_EACCES); }))) {
            mixin(enumMixinStr_EACCES);
        }
    }




    static if(!is(typeof(ENOMEM))) {
        private enum enumMixinStr_ENOMEM = `enum ENOMEM = 12;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOMEM); }))) {
            mixin(enumMixinStr_ENOMEM);
        }
    }




    static if(!is(typeof(EAGAIN))) {
        private enum enumMixinStr_EAGAIN = `enum EAGAIN = 11;`;
        static if(is(typeof({ mixin(enumMixinStr_EAGAIN); }))) {
            mixin(enumMixinStr_EAGAIN);
        }
    }




    static if(!is(typeof(ECHILD))) {
        private enum enumMixinStr_ECHILD = `enum ECHILD = 10;`;
        static if(is(typeof({ mixin(enumMixinStr_ECHILD); }))) {
            mixin(enumMixinStr_ECHILD);
        }
    }




    static if(!is(typeof(EBADF))) {
        private enum enumMixinStr_EBADF = `enum EBADF = 9;`;
        static if(is(typeof({ mixin(enumMixinStr_EBADF); }))) {
            mixin(enumMixinStr_EBADF);
        }
    }




    static if(!is(typeof(ENOEXEC))) {
        private enum enumMixinStr_ENOEXEC = `enum ENOEXEC = 8;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOEXEC); }))) {
            mixin(enumMixinStr_ENOEXEC);
        }
    }




    static if(!is(typeof(E2BIG))) {
        private enum enumMixinStr_E2BIG = `enum E2BIG = 7;`;
        static if(is(typeof({ mixin(enumMixinStr_E2BIG); }))) {
            mixin(enumMixinStr_E2BIG);
        }
    }




    static if(!is(typeof(ENXIO))) {
        private enum enumMixinStr_ENXIO = `enum ENXIO = 6;`;
        static if(is(typeof({ mixin(enumMixinStr_ENXIO); }))) {
            mixin(enumMixinStr_ENXIO);
        }
    }




    static if(!is(typeof(EIO))) {
        private enum enumMixinStr_EIO = `enum EIO = 5;`;
        static if(is(typeof({ mixin(enumMixinStr_EIO); }))) {
            mixin(enumMixinStr_EIO);
        }
    }




    static if(!is(typeof(EINTR))) {
        private enum enumMixinStr_EINTR = `enum EINTR = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_EINTR); }))) {
            mixin(enumMixinStr_EINTR);
        }
    }




    static if(!is(typeof(ESRCH))) {
        private enum enumMixinStr_ESRCH = `enum ESRCH = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_ESRCH); }))) {
            mixin(enumMixinStr_ESRCH);
        }
    }




    static if(!is(typeof(ENOENT))) {
        private enum enumMixinStr_ENOENT = `enum ENOENT = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOENT); }))) {
            mixin(enumMixinStr_ENOENT);
        }
    }




    static if(!is(typeof(EPERM))) {
        private enum enumMixinStr_EPERM = `enum EPERM = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_EPERM); }))) {
            mixin(enumMixinStr_EPERM);
        }
    }
    static if(!is(typeof(__GNUC_VA_LIST))) {
        private enum enumMixinStr___GNUC_VA_LIST = `enum __GNUC_VA_LIST = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___GNUC_VA_LIST); }))) {
            mixin(enumMixinStr___GNUC_VA_LIST);
        }
    }






    static if(!is(typeof(NULL))) {
        private enum enumMixinStr_NULL = `enum NULL = ( cast( void * ) 0 );`;
        static if(is(typeof({ mixin(enumMixinStr_NULL); }))) {
            mixin(enumMixinStr_NULL);
        }
    }

}


struct __va_list_tag;


private enum DPP_TUNSETIFF = ( ( ( 1U ) << ( ( ( 0 + 8 ) + 8 ) + 14 ) ) | ( ( ( 'T' ) ) << ( 0 + 8 ) ) | ( ( ( 202 ) ) << 0 ) | ( ( ( ( ( int ) .sizeof ) ) ) << ( ( 0 + 8 ) + 8 ) ) );
mixin("enum TUNSETIFF = DPP_TUNSETIFF;");

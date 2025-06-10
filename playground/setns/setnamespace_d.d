import std.stdio, std.process;

extern(C) int setns(int fd, int nstype);

int main(string[] args)
{
    if (args.length < 3)
    {
        if (args.length > 0)
            writeln("Usage: " ~ args[0] ~ " [pid] [executable] [arguments]");
        return 1;
    }

    auto nsfile = File("/proc/" ~ args[1] ~ "/ns/net", "r");
    int result = setns(nsfile.fileno, 0);
    writeln("nsset returned ", result);
    nsfile.close;

    execvp(args[2], args[2 .. $]);
    throw new Exception("Unreachable code / execv failed");
}

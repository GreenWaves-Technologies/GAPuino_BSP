====================
Network Logging Tool
====================

--------
Overview
--------

The network logging tool is a simple tool that runs on a host machine, monitors
for incoming TCP connections on a certain port, and writes the data received
into a log file. The tool allows multiple simultaneous incoming connections on
any of the network interfaces on the host machine. The log file is automatically
closed once the network connection has been disconnected explicitly.

-----
Usage
-----

See 'network_logger -h' for details.

-----
Build
-----

Use the 'make' command to build the binaries for the build environment. The
default target is to build for the architecture of the build environment, i.e.,
if building in a Linux 64-bit environment, then the Linux 64-bit version of the
tool will be built. However, architecture can be overridden by specifying the
build targets '32' or '64'.

Currently only building in Linux and Cygwin environments is supported.

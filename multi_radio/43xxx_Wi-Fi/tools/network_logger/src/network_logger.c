/*
 * Copyright 2017, Cypress Semiconductor Corporation or a subsidiary of 
 * Cypress Semiconductor Corporation. All Rights Reserved.
 * 
 * This software, associated documentation and materials ("Software"),
 * is owned by Cypress Semiconductor Corporation
 * or one of its subsidiaries ("Cypress") and is protected by and subject to
 * worldwide patent protection (United States and foreign),
 * United States copyright laws and international treaty provisions.
 * Therefore, you may use this Software only as provided in the license
 * agreement accompanying the software package from which you
 * obtained this Software ("EULA").
 * If no EULA applies, Cypress hereby grants you a personal, non-exclusive,
 * non-transferable license to copy, modify, and compile the Software
 * source code solely for use in connection with Cypress's
 * integrated circuit products. Any reproduction, modification, translation,
 * compilation, or representation of this Software except as specified
 * above is prohibited without the express written permission of Cypress.
 *
 * Disclaimer: THIS SOFTWARE IS PROVIDED AS-IS, WITH NO WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, NONINFRINGEMENT, IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. Cypress
 * reserves the right to make changes to the Software without notice. Cypress
 * does not assume any liability arising out of the application or use of the
 * Software or any product or circuit described in the Software. Cypress does
 * not authorize its products for use in any products where a malfunction or
 * failure of the Cypress product may reasonably be expected to result in
 * significant property damage, injury or death ("High Risk Product"). By
 * including Cypress's product in a High Risk Product, the manufacturer
 * of such system or application assumes all risk of such use and in doing
 * so agrees to indemnify Cypress against all liability.
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <getopt.h>
#include <errno.h>
#include <unistd.h>
#include <time.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <fcntl.h>
#include <ifaddrs.h>
#include <limits.h>
#include <semaphore.h>
#include <signal.h>

/*******************************************************************************
* Types and definitions
*/

/*
 * Logging macros
 */

#define LOGE(fmt, ...)  fprintf(stderr, "*** " fmt "\n", ##__VA_ARGS__)
#define LOGI(fmt, ...)  fprintf(stdout, fmt "\n", ##__VA_ARGS__)
//#define ENABLE_DEBUG_LOG
#ifdef ENABLE_DEBUG_LOG
#define LOGD(fmt, ...)  fprintf(stdout, fmt "\n", ##__VA_ARGS__)
#else
#define LOGD(fmt, ...)  do {} while (0);
#endif

#define IPSTR(c)        inet_ntoa(c->addr.sin_addr)

/*
 * Default values
 */

#define SERVER_DEFAULT_PORT     (19702)
#define SERVER_LISTEN_BACKLOG   (10)

#define LOG_DEFAULT_EXTENSION   "txt"
#define LOG_TRACEX_EXTENSION    "trx"
#define LOG_DEFAULT_PREFIX      "log"
#define LOG_FILE_PERM           (S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IRGRP|S_IWGRP)

#define LOG_READ_BUF_SIZE       (2048)

typedef struct conn_s {
    struct conn_s       *next;              /* Next in linked list */
    struct sockaddr_in  addr;               /* Client address */
    int                 sd;                 /* Socket descriptor */
    int                 fd;                 /* Log file descriptor */
    char                filename[PATH_MAX]; /* Log filename */
    unsigned int        file_size;          /* Log file size (bytes) */
} conn_t;

typedef struct server_s {
    int     quit;                   /* Flag to indicate server should quit */
    int     port;                   /* Server TCP port */
    int     listen_sd;              /* Socket descriptor for listen */
    char    log_dir[PATH_MAX];      /* Directory for logfiles */
    char    log_prefix[NAME_MAX];   /* Logfile prefix */
    char    log_ext[NAME_MAX];      /* Logfile extension */
} server_t;

typedef struct fds_s {
    fd_set  active;     /* Active file descriptor set */
    fd_set  read;       /* File descriptor set that for reading */
    int     max_fd;     /* Maximum file descriptor + 1 */
} fds_t;

/*******************************************************************************
* Function prototypes
*/

/*******************************************************************************
* Globals
*/

/*******************************************************************************
* Locals
*/

static server_t server = {
    .listen_sd = -1
};

/*******************************************************************************
* Function definitions
*/


/**
 * Print out the program usage and exit.
 */

static void print_usage(void)
{
    LOGI("\nCypress (c) 2016");
    LOGI("-------------------------------------------");
    LOGI("Usage: network_logger [OPTIONS]");
    LOGI("Options:");
    LOGI("   -d <dirname>     : Directory for logfiles");
    LOGI("   -e <extension>   : Filename extension for logfiles (default: %s)",
         LOG_DEFAULT_EXTENSION);
    LOGI("   -f <prefix>      : Filename prefix for logfiles (default: %s)",
         LOG_DEFAULT_PREFIX);
    LOGI("   -p <port>        : Port number to use (default: %d)",
         SERVER_DEFAULT_PORT);
    LOGI("   -t               : Use TraceX extension (.trx) for logfiles (equivalent to -e trx)");

    exit(EXIT_FAILURE);
}


/**
 * Parse the command line options.
 *
 * @param argc  Number or command line arguments
 * @param argv  Pointers to command line arguments
 *
 * @return 0 if successful
 */

static int parse_options(int argc, char *argv[])
{
    int opt;
    int option_index;
    int port;
    static struct option long_options[] = {
        {"help",      no_argument,       0,  0 },
        {"port",      required_argument, 0, 'p'},
        {0,           0,                 0,  0 }
    };

    server.port = SERVER_DEFAULT_PORT;
    strncpy(server.log_ext, LOG_DEFAULT_EXTENSION, sizeof(server.log_ext));
    strncpy(server.log_prefix, LOG_DEFAULT_PREFIX, sizeof(server.log_prefix));

    opterr = 0; /* No automatic error messages from getopt */
    option_index = 0;
    while (1)
    {
        opt = getopt_long(argc, argv, ":p:d:e:f:t", long_options, &option_index);

        if (opt == -1)
            break;

        switch (opt)
        {
            case 0:
                print_usage();
                break;

            case 'd':
                /*
                 * Get the log directory.
                 */

                strncpy(server.log_dir, optarg, sizeof(server.log_dir));
                if (server.log_dir[strlen(server.log_dir) - 1] != '/')
                {
                    strcat(server.log_dir, "/");
                }
                break;

            case 'e':
                /*
                 * Get the log filename extension.
                 */

                strncpy(server.log_ext, optarg, sizeof(server.log_ext));
                break;

            case 'f':
                /*
                 * Get the log filename prefix.
                 */

                strncpy(server.log_prefix, optarg, sizeof(server.log_prefix));
                break;

            case 'p':
                /*
                 * Grab the new port number.
                 */

                port = strtol(optarg, (char **)NULL, 10);
                if (port != 0)
                {
                    LOGI("Server using TCP port %d", port);
                    server.port = port;
                }
                break;

            case 't':
                /*
                 * Use the TraceX extension.
                 */

                strncpy(server.log_ext, LOG_TRACEX_EXTENSION, sizeof(server.log_ext));
                break;

            default:    /* ? */
                if (opt == ':')
                {
                    LOGE("Missing argument for option: %c", optopt);
                }
                else
                {
                    LOGE("Unrecognized option: %c", optopt);
                }
                print_usage();
                break;
        }
    }

    /*
     * Do we have a command on the command line?
     */

    if (optind > 0 && argv[optind] != NULL)
    {
        /*
         * We don't support commands (at least not yet).
         */

        LOGE("Unrecognized command: %s", argv[optind]);
        print_usage();
    }

    return 0;
}


/**
 * Initialize the server TCP socket.
 *
 * @return 0 if successful
 */

static int init_server_tcp_socket(void)
{
    struct sockaddr_in sin;
    int option = 1;

    server.listen_sd = socket(AF_INET, SOCK_STREAM, 0);
    if (server.listen_sd == -1)
    {
        LOGE("Error opening socket (%m)");
        goto err_out;
    }

    if (setsockopt(server.listen_sd, SOL_SOCKET, SO_REUSEADDR, (char *)&option,
                   sizeof(option)) < 0)
    {
        LOGE("Error setting SO_REUSEADDR (%m)");
        goto err_out;
    }

    memset(&sin, 0, sizeof(sin));
    sin.sin_port        = htons(server.port);
    sin.sin_addr.s_addr = INADDR_ANY;
    sin.sin_family      = AF_INET;

    if (bind(server.listen_sd, (struct sockaddr *)&sin,
             sizeof(struct sockaddr_in)) == -1)
    {
        LOGE("Error binding socket (%m)");
        goto err_out;
    }

    if (listen(server.listen_sd, SERVER_LISTEN_BACKLOG) < 0)
    {
        LOGE("Error listening on socket (%m)");
        goto err_out;
    }

    return 0;

err_out:
    if (server.listen_sd != -1)
    {
        close(server.listen_sd);
        server.listen_sd = -1;
    }

    return -1;
}


/**
 * Calculate maximum file descriptor (+ 1) value for select().
 *
 * @param conn_list Pointer to connection list
 * @param max_fd    Pointer maximum file descriptor variable
 *
 * @return 0 if successful
 */

static int calc_max_fd(conn_t **conn_list, int *max_fd)
{
    conn_t *conn;

    if ((conn_list == NULL) || (max_fd == NULL))
    {
        return -1;
    }

    *max_fd = server.listen_sd;

    for (conn = *conn_list; conn != NULL; conn = conn->next)
    {
        if (conn->sd > *max_fd)
        {
            *max_fd = conn->sd;
        }
    }

    *max_fd += 1;

    return 0;
}


/**
 * Add a connection to the connection list.
 *
 * @param conn_list     Pointer to connection list
 * @param entry         Pointer to connection to be added
 * @param fds           Pointer to file descriptor sets
 *
 * @return 0 if successful
 */

static int add_to_conn_list(conn_t **conn_list, conn_t *entry, fds_t *fds)
{
    conn_t *ptr;

    if ((conn_list == NULL) || (entry == NULL ))
    {
        return -1;
    }

    if (*conn_list == NULL)
    {
        *conn_list = entry;
    }
    else
    {
        ptr = *conn_list;
        while (1)
        {
            if (ptr->next == NULL)
            {
                ptr->next = entry;
                break;
            }
            ptr = ptr->next;
        }
    }

    entry->next = NULL;

    if (fds != NULL)
    {
        FD_SET(entry->sd, &fds->active);
        calc_max_fd(conn_list, &fds->max_fd);
    }

    return 0;
}


/**
 * Delete a connection fron the connection list.
 *
 * @param conn_list     Pointer to connection list
 * @param entry         Pointer to connection to be deleted
 * @param fds           Pointer to file descriptor sets
 *
 * @return 0 if successful
 */

static int del_from_conn_list(conn_t **conn_list, conn_t *entry, fds_t *fds)
{
    conn_t *ptr;

    if ((conn_list == NULL) || (*conn_list == NULL) || (entry == NULL))
    {
        return -1;
    }

    if (fds != NULL)
    {
        FD_CLR(entry->sd, &fds->active);
    }

    if (*conn_list == entry)
    {
        *conn_list = entry->next;
    }
    else
    {
        ptr = *conn_list;
        while (1)
        {
            if (ptr->next == entry)
            {
                ptr->next = entry->next;
                break;
            }
            ptr = ptr->next;
        }
    }

    if (fds != NULL)
    {
        calc_max_fd(conn_list, &fds->max_fd);
    }

    return 0;
}


/**
 * Signal handler
 *
 * @param sig   Signal (unused)
 */

static void sig_handler(int sig)
{
    server.quit = 1;
}


/**
 * Set O_NONBLOCK flag on a file descriptor
 *
 * @param fd    File descriptor
 *
 * @return 0 if successful
 */

static int set_nonblock(int fd)
{
    int flags;

    flags = fcntl(fd, F_GETFL, 0);
    if (flags < 0)
    {
        LOGE("Failed to set O_NONBLOCK for file descriptor %d", fd);
        return -1;
    }

    return fcntl(fd, F_SETFL, flags | O_NONBLOCK) ? -1 : 0;
}


/**
 * Open a new incoming connection
 *
 * @param conn_list Pointer to connection list
 * @param fds       Pointer to file descriptor sets
 *
 * @return 0 if successful
 */

static int open_connection(conn_t **conn_list, fds_t *fds)
{
    conn_t *conn = NULL;
    int len;
    struct timeval tv;
    struct tm *tm;
    time_t now;

    if ((conn_list == NULL) || (fds == NULL))
    {
        return -1;
    }

    conn = (conn_t *)calloc(1, sizeof(conn_t));
    if (conn == NULL)
    {
        LOGE("Failed to allocate memory for new connection");
        goto err_out;
    }

    len = sizeof(conn->addr);
    conn->sd = accept(server.listen_sd, (struct sockaddr *)&conn->addr,
                      (socklen_t *)&len);
    if (conn->sd == -1)
    {
        if (errno != EINTR)
        {
            LOGE("Error returned from accept (%m)");
        }
        goto err_out;
    }

    set_nonblock(server.listen_sd);

    /*
     * Create a file for the received data; use the format:
     *      <filename_prefix>_<YYMMDD>-<HHMMSS.mS>_<src_ip>.<filename_extension>
     */

    gettimeofday(&tv, NULL);
    now = tv.tv_sec;
    tm = localtime(&now);
    sprintf(conn->filename, "%s%s_%d%02d%02d-%02d%02d%02d.%03u_%s.%s", server.log_dir,
            server.log_prefix, tm->tm_year + 1900, tm->tm_mon, tm->tm_mday,
            tm->tm_hour, tm->tm_min, tm->tm_sec, tv.tv_usec / 1000, IPSTR(conn),
            server.log_ext);
    conn->fd = creat(conn->filename, LOG_FILE_PERM);
    if (conn->fd == -1)
    {
        LOGE("[%s] Unable to create new logfile '%s' (errno=%d)", IPSTR(conn),
             conn->filename, errno);
        goto err_out;
    }

    set_nonblock(conn->fd);

    add_to_conn_list(conn_list, conn, fds);

    LOGI("    [%s] Logfile '%s' started", IPSTR(conn), conn->filename);

    return 0;

err_out:
    if (conn != NULL)
    {
        if (conn->sd != -1)
        {
            close(conn->sd);
        }
        free(conn);
    }

    return -1;
}



/**
 * Close an incoming connection.
 *
 * @param conn_list Pointer to connection list
 * @param conn_list Pointer to connection to be closed
 * @param fds       Pointer to file descriptor sets
 * @param partial   Logfile is incomplete
 *
 * @return 0 if successful
 */
static int close_connection(conn_t **conn_list, conn_t *conn, fds_t *fds, int partial)
{
    if ((conn_list == NULL) || (*conn_list == NULL) || (conn == NULL))
    {
        return -1;
    }

    del_from_conn_list(conn_list, conn, fds);

    if (conn->fd != -1)
    {
        LOGI("    [%s] Logfile '%s' %scompleted (%u bytes)", IPSTR(conn),
             conn->filename, partial ? "partially " : "", conn->file_size);
        close(conn->fd);
    }

    if (conn->sd != -1)
    {
        LOGD("[%s] Closing connection", IPSTR(conn));
        close(conn->sd);
    }

    free(conn);
}


/**
 * Close all incoming connections.
 *
 * @param conn_list     Pointer to connection list
 *
 * @return 0 if successful
 */

static int close_all_connections(conn_t **conn_list)
{
    conn_t *conn;

    if (conn_list == NULL)
    {
        return -1;
    }

    for (conn = *conn_list; conn != NULL; conn = *conn_list)
    {
        close_connection(conn_list, conn, NULL, 1);
    }
}


/**
 * Process any incoming data
 *
 * @param conn_list Pointer to connection list
 * @param fds       Pointer to file descriptor sets
 *
 * @return 0 if successful
 */

static int process_incoming_data(conn_t **conn_list, fds_t *fds)
{
    conn_t *conn;
    char buf[LOG_READ_BUF_SIZE];

    for (conn = *conn_list; conn != NULL;)
    {
        int len;
        conn_t *cur = conn;

        conn = conn->next;

        if (!FD_ISSET(cur->sd, &fds->read))
        {
            continue;
        }

        len = read(cur->sd, buf, sizeof(buf));
        if (len <= 0)
        {
            close_connection(conn_list, cur, fds, 0);
            continue;
        }

        if (write(cur->fd, buf, len) < 0)
        {
            LOGE("[%s] Error writing to logfile '%s' (%m)", IPSTR(cur),
                 cur->filename);

            close_connection(conn_list, cur, fds, 0);
            continue;
        }

        cur->file_size += len;
    }

    return 0;
}


/**
 * Monitor server TCP socket for activity.
 *
 * @return 0 if server quits without errors
 */

static int monitor_socket(void)
{
    fds_t fds;
    conn_t *conn_list = NULL;

    /*
     * Initialize the set of active sockets.
     */

    FD_ZERO(&fds.active);
    FD_SET(server.listen_sd, &fds.active);
    fds.max_fd = server.listen_sd + 1;

    LOGI("Waiting for incoming connections...");

    while (!server.quit)
    {
        fds.read = fds.active;

        if (select(fds.max_fd, &fds.read, NULL, NULL, NULL) < 0)
        {
            continue;
        }

        if (FD_ISSET(server.listen_sd, &fds.read))
        {
            open_connection(&conn_list, &fds);
        }

        process_incoming_data(&conn_list, &fds);
    }

    LOGI("\nClosing all open connections");
    close_all_connections(&conn_list);

    return 0;
}


/**
 * Main application.
 *
 * @param argc  Number or command line arguments
 * @param argv  Pointers to command line arguments
 *
 * @return 0 if successful
 */

int main(int argc, char *argv[])
{
    int ret = 0;
    struct sigaction act;

    /*
     * Parse options.
     */

    if (parse_options(argc, argv))
    {
        ret = -1;
        goto out;
    }

    /*
     * Initialize our listening socket.
     */

    if (init_server_tcp_socket())
    {
        ret = -1;
        goto out;
    }

    /*
     * Set up a signal handler to exit cleanly.
     */

    memset(&act, 0, sizeof(act));
    act.sa_handler = sig_handler;
    sigaction(SIGINT, &act, 0);

    /*
     * Monitor socket for activity.
     */

    ret = monitor_socket();

out:
    /*
     * Clean up.
     */

    if (server.listen_sd != -1)
    {
        close(server.listen_sd);
    }

    return ret;
}

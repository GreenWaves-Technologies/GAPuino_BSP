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

/** @file
 * HMAC SHA256 Sign/Verify input file
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <errno.h>
#include <sha2.h>

#define SHA256_DIGEST_LENGTH    (32)
#define BCM_KEY_SIZE            (32)

int readfile( const char *infile, char *buf, int maxlen )
{
    FILE *infp;
    int filelen = 0;

    infp = fopen( infile, "rb" );
    if ( infp == NULL )
    {
        printf( "* Failed to open input file '%s' - %s\n", infile, strerror( errno ) );
        return -1;
    }

    filelen = fread( buf, 1, maxlen, infp );
    if ( filelen < 0 )
    {
        printf( "* Failed to read data from file '%s'\n", infile );
    }

    fclose( infp );

    return filelen;
}

int hmactest( void )
{
    return 0;
}

int hmacsign( const char *keyfile, const char *infile, const char *outfile, unsigned int blocksize, unsigned int no_padding, int signature_only )
{
    unsigned char key[ BCM_KEY_SIZE ] =
    { '\0' };
    unsigned char hash[ SHA256_DIGEST_LENGTH ];
    unsigned char *filebuffer = NULL;
    unsigned int filesize, padded_filesize;
    unsigned int keysize;
    unsigned int digest_len;
    FILE *infp = NULL;
    FILE *outfp = NULL;
    int remaining;
    unsigned int padding;
    int success = 1;
    char zero_char = '0';

    keysize = readfile( keyfile, key, sizeof( key ) );

    if ( keysize > BCM_KEY_SIZE )
    {
        success = 0;
        printf( "keysize = %d > BCM_KEY_SIZE = %d Exit\n", keysize, BCM_KEY_SIZE );
        goto finalize;
    }

    infp = fopen( infile, "rb" );
    if ( !infp )
    {
        printf( "* Failed to open input file '%s' - %s\n", infile, strerror( errno ) );
        success = 0;
        goto finalize;
    }

    fseek( infp, 0L, SEEK_END );
    filesize = ftell( infp );
    fseek( infp, 0L, SEEK_SET );
    fclose( infp );

    /* If file has to be signed block by block, make sure that
     * the size of file is aligned to blocksize by padding it
     */
    if ( blocksize != 0 )
    {
        blocksize = blocksize - SHA256_DIGEST_LENGTH;
        if ( ( no_padding == 1 ) || ( ( filesize % blocksize ) == 0 ) )
            padding = 0;
        else
            padding = blocksize - ( filesize % blocksize );

    }
    else
    {
        if ( signature_only )
            padded_filesize = filesize;
        else
            padded_filesize = ( ( ( filesize - 1 ) >> 4 ) + 1 ) << 4;

        padding = padded_filesize - filesize;
    }

    if ( padding != 0 )
    {
        printf( "[sha256_hmac] : Padding file %s [%d -> %d bytes] \n", infile, filesize, filesize + padding );

        infp = fopen( infile, "ab" );
        if ( !infp )
        {
            printf( "* Failed to open input file '%s' - %s\n", infile, strerror( errno ) );
            success = 0;
            goto finalize;
        }

        while ( padding != 0 )
        {
            fwrite( &zero_char, sizeof(char), 1, infp );
            padding-- ;
        }

        fclose( infp );

    }

    infp = fopen( infile, "rb" );
    if ( !infp )
    {
        printf( "* Failed to open input file '%s' - %s\n", infile, strerror( errno ) );
        success = 0;
        goto finalize;
    }

    fseek( infp, 0L, SEEK_END );
    padded_filesize = ftell( infp );
    fseek( infp, 0L, SEEK_SET );

    remaining = padded_filesize;
    if ( blocksize == 0 )
        blocksize = padded_filesize;

    filebuffer = malloc( blocksize );
    if ( filebuffer == NULL )
    {
        printf( "* Failed to allocation filebuffer of file '%s'\n", infile );
        success = 0;
        goto finalize;
    }
    memset( filebuffer, 0, blocksize );
    outfp = fopen( outfile, "wb" );

    if ( !infp )
    {
        printf( "* Failed to open output file '%s' - %s\n", outfile, strerror( errno ) );
        fclose( infp );
        success = 0;
        goto finalize;
    }

    while ( remaining >= blocksize )
    {

        if ( fread( filebuffer, 1, blocksize, infp ) != blocksize )
        {
            printf( "* File '%s' read error\n", infile );
            success = 0;
            goto finalize;
        }

        sha2_hmac( key, keysize, filebuffer, blocksize, hash, 0 );

        if ( !signature_only )
            fwrite( filebuffer, 1, blocksize, outfp );

        fwrite( hash, 1, SHA256_DIGEST_LENGTH, outfp );

        remaining -= blocksize;
    }

    finalize:

    if ( infp != NULL )
        fclose( infp );
    if ( outfp != NULL )
        fclose( outfp );
    if ( filebuffer != NULL )
        free( filebuffer );
    if ( !success )
        remove( outfile );
    return success;
}

int hmacverify( const char *keyfile, const char *infile, const char *signaturefile, unsigned int blocksize )
{
    unsigned char key[ BCM_KEY_SIZE ] =
    { '\0' };
    unsigned char hash[ SHA256_DIGEST_LENGTH ];
    unsigned char signature[ SHA256_DIGEST_LENGTH ];
    unsigned char *filebuffer = NULL;
    unsigned int filesize;
    unsigned int keysize;
    unsigned int digest_len;
    FILE *infp = NULL;
    int success = 1;
    unsigned int remaining;

    keysize = readfile( keyfile, key, sizeof( key ) );

    if ( keysize > BCM_KEY_SIZE )
    {
        printf( "keysize > %d, Exit \n", BCM_KEY_SIZE );
        success = 0;
        goto finalize;
    }

    infp = fopen( infile, "rb" );
    if ( !infp )
    {
        printf( "* Failed to open input file '%s' - %s\n", infile, strerror( errno ) );
        success = 0;
        goto finalize;
    }

    fseek( infp, 0L, SEEK_END );
    filesize = ftell( infp );
    fseek( infp, 0L, SEEK_SET );

    if ( blocksize == 0 )
        blocksize = filesize;

    if ( filesize > 0 )
    {
        filebuffer = malloc( blocksize );
        if ( filebuffer == NULL )
        {
            printf( "* Failed to allocation filebuffer of file '%s'\n", infile );
            success = 0;
            goto finalize;
        }
    }
    else
    {
        printf( "* File '%s' is not valid\n", infile );
        success = 0;
        goto finalize;
    }

    remaining = filesize;

    while ( remaining != 0 )
    {
        if ( fread( filebuffer, 1, blocksize, infp ) != blocksize )
        {
            printf( "* File '%s' read error\n", infile );
            success = 0;
            goto finalize;
        }

        if ( signaturefile )
        {
            if ( readfile( signaturefile, signature, SHA256_DIGEST_LENGTH ) != SHA256_DIGEST_LENGTH )
            {
                printf( "* Failed to read signature file\n" );
                success = 0;
                goto finalize;
            }
        }
        else
        {
            memcpy( signature, filebuffer + blocksize - SHA256_DIGEST_LENGTH, SHA256_DIGEST_LENGTH );
        }

        sha2_hmac( key, keysize, filebuffer, blocksize - SHA256_DIGEST_LENGTH, hash, 0 );

        if ( memcmp( hash, signature, SHA256_DIGEST_LENGTH ) == 0 )
        {
            printf( "Hash matches - signature verified\n" );
        }
        else
        {
            printf( "* Hash doesn't match\n" );
            success = 0;
        }

        remaining -= blocksize;
    }

    finalize: if ( infp )
        fclose( infp );
    if ( filebuffer )
        free( filebuffer );

    return success;
}

void usage( void )
{
    printf( "Usage: hmac_sha256 <mode>\n"
        "  where <mode> is one of:\n"
        "  sign <keyfile> <infile> <signedfile> [blocksize] [padding]\n"
        "                                                     Sign the supplied file\n"
        "                                                     blocksize : Divide file into blocks of\n"
        "                                                     (blocksize - SHA256_DIGEST_LEN) and sign\n"
        "                                                     each block individually\n"
        "                                                     padding : 0 [Default] Pad file to SHA256 input alignment (448 mod 512)\n"
        "                                                     padding : 1 Do not pad the input file\n"
        "  sig <keyfile> <infile> <signature>                 Generate the signature for <infile>\n"
        "  vrfy <keyfile> <signedfile> [blocksize]            Verify the signature in <signedfile>\n"
        "                                                     blocksize : Divide file into blocks of\n"
        "                                                     (blocksize) and verify each block\n"
        "  test                                               Run the self test\n"
        "  vsig <keyfile> <infile> <signature>                Verify <signature> against <infile>\n" );
    exit( 0 );
}

int main( int argc, const char **argv )
{
    int argn;
    const char *mode;

    for ( argn = 1; argn < argc; argn++ )
    {
        const char *arg = argv[ argn ];
        if ( arg[ 0 ] != '-' )
            break;

        printf( "* Unknown option '%s'\n", arg );
        usage( );
    }

    if ( argn == argc )
        usage( );

    mode = argv[ argn++ ];

    if ( strcmp( mode, "test" ) == 0 )
    {
        return hmactest( );
    }
    else if ( strcmp( mode, "sig" ) == 0 )
    {
        if ( ( argn + 3 ) != argc )
        {
            printf( "* Incorrect parameters for sign\n" );
            usage( );
        }

        if ( hmacsign( argv[ argn ], argv[ argn + 1 ], argv[ argn + 2 ], 0, 0, 1 ) == 0 )
        {
            return -1;
        }
    }
    else if ( strcmp( mode, "sign" ) == 0 )
    {
        unsigned int blocksize;
        unsigned int no_padding;
        if ( ( argn + 3 ) == argc )
        {
            blocksize = 0;
        }
        else if ( ( argn + 5 ) == argc )
        {
            blocksize = atoi( argv[ argn + 3 ] );
            no_padding = atoi( argv [argn + 4 ] );
        }
        else
        {
            printf( "* Incorrect parameters for sig\n" );
            usage( );
        }
        if ( hmacsign( argv[ argn ], argv[ argn + 1 ], argv[ argn + 2 ], blocksize, no_padding, 0 ) == 0 )
        {
            return -1;
        }
    }
    else if ( strcmp( mode, "vrfy" ) == 0 )
    {
        unsigned int blocksize = 0;

        if ( ( argn + 2 ) == argc )
        {
            blocksize = 0;
        }
        else if ( ( argn + 3 ) == argc )
        {
            blocksize = atoi( argv[ argn + 2 ] );
        }
        else
        {
            printf( "* Incorrect parameters for vrfy\n" );
            usage( );
        }

        if ( hmacverify( argv[ argn ], argv[ argn + 1 ], NULL, blocksize ) == 0 )
        {
            return -1;
        }
    }
    else if ( strcmp( mode, "vsig" ) == 0 )
    {
        if ( ( argn + 3 ) != argc )
        {
            printf( "* Incorrect parameters for vsig\n" );
            usage( );
        }
        if ( hmacverify( argv[ argn ], argv[ argn + 1 ], argv[ argn + 2 ], 0 ) == 0 )
        {
            return -1;
        }
    }
    else
    {
        printf( "* Unknown mode '%s'\n", mode );
        usage( );
    }

    return 0;
}

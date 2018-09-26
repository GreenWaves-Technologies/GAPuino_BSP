#!/usr/bin/python
#
# Copyright 2017, Cypress Semiconductor Corporation or a subsidiary of 
 # Cypress Semiconductor Corporation. All Rights Reserved.
 # This software, including source code, documentation and related
 # materials ("Software"), is owned by Cypress Semiconductor Corporation
 # or one of its subsidiaries ("Cypress") and is protected by and subject to
 # worldwide patent protection (United States and foreign),
 # United States copyright laws and international treaty provisions.
 # Therefore, you may use this Software only as provided in the license
 # agreement accompanying the software package from which you
 # obtained this Software ("EULA").
 # If no EULA applies, Cypress hereby grants you a personal, non-exclusive,
 # non-transferable license to copy, modify, and compile the Software
 # source code solely for use in connection with Cypress's
 # integrated circuit products. Any reproduction, modification, translation,
 # compilation, or representation of this Software except as specified
 # above is prohibited without the express written permission of Cypress.
 #
 # Disclaimer: THIS SOFTWARE IS PROVIDED AS-IS, WITH NO WARRANTY OF ANY KIND,
 # EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, NONINFRINGEMENT, IMPLIED
 # WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. Cypress
 # reserves the right to make changes to the Software without notice. Cypress
 # does not assume any liability arising out of the application or use of the
 # Software or any product or circuit described in the Software. Cypress does
 # not authorize its products for use in any products where a malfunction or
 # failure of the Cypress product may reasonably be expected to result in
 # significant property damage, injury or death ("High Risk Product"). By
 # including Cypress's product in a High Risk Product, the manufacturer
 # of such system or application assumes all risk of such use and in doing
 # so agrees to indemnify Cypress against all liability.
#
# Needs : openssl, ssh-keygen
# Generate rsa key pair and hash of rsa public exponent

import os, sys, base64, struct

try:
    total = len(sys.argv)

    if total < 1:
        print 'Usage: ' + sys.argv[0] + ' <rsa key name>'
        sys.exit()

    # generate RSA key with e=65537
    os.system('openssl genrsa -f4 -out ' + sys.argv[1] + ' 2048')
    # make key secure
    os.system('chmod 600 ' + sys.argv[1])
    # extract RSA public key
    os.system('openssl rsa -in ' + sys.argv[1] + ' -pubout -out ' + sys.argv[1] + '.pub.rsa')
    # make ssh-rsa key
    os.system('ssh-keygen -y -f ' + sys.argv[1] + ' > ' + sys.argv[1] + '.pub')

    # extract public modulus n
    keydata = base64.b64decode(open(sys.argv[1] + '.pub').read().split(None)[1])
    parts = []
    while keydata :
        # read the length of the data
        dlen = struct.unpack('>I', keydata[:4])[0]
        # read in <length> bytes
        data, keydata = keydata[4:dlen+4], keydata[4+dlen:]
        parts.append(data)

    if len(parts[2]) > 256 :
        parts[2] = parts[2][len(parts[2])-256:]

    open(sys.argv[1] + '.n', 'wb').write(parts[2])

    os.system('openssl dgst -sha256 -binary -out ' + sys.argv[1] + '.n.hash ' + sys.argv[1] + '.n')

except IOError:
    print ("Error!")
    sys.exit()

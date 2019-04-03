#!/bin/bash

echo "# Exim filter - auto-generated by cPanel.
#
# Do not manually edit this file; instead, use cPanel APIs to manipulate
# email filters. MANUAL CHANGES TO THIS FILE WILL BE OVERWRITTEN.
#

headers charset \"UTF-8\"

if not first_delivery and error_message then finish endif

#Spoofing
if
 $message_body contains \"bitcoin\"
 or $header_from: contains \"hacked\"
then
 save \"/dev/null\" 660
endif

#Spam
if
 $header_subject: contains \"oferta\"
 or $header_subject: contains \"cupom\"
 or $header_subject: contains \"desconto\"
 or $header_subject: contains \"milenar\"
 or $header_subject: contains \"estimulante\"
 or $header_subject: contains \"sexual\"
then
 save \"/dev/null\" 660
endif

#Generated Apache SpamAssassin™ Discard Rule
if
 $h_X-Spam-Bar: contains \"+++++\"
then
 save \"/dev/null\" 660
endif"

APRS device identification database
======================================

This is a machine-readable index of APRS device and software identification
strings.  For easy manual editing and validation, the master file is in YAML
format.  A conversion tool and pre-converted versions in XML and JSON are
also provided for environments where those are more convenient to parse.

This list is maintained by Hessu, OH7LZB, for the device identification
feature of the aprs.fi service.  The list is published here in a
machine-readable format so that it would be easier for others to implement
such functionality.  If you choose to use the database, and update from here
regularly, your APRS app should be relatively well in sync with aprs.fi.


Licensing
------------

The database is licensed under the CC BY-SA 2.0 license, so you're free to
use it in any of your applications, commercial, free or open source.  For
free.  Just mention the source somewhere in the small print.

http://creativecommons.org/licenses/by-sa/2.0/


Adding new devices
---------------------

If you want me to add a new device in the database, please file an issue
ticket in github (https://github.com/hessu/aprs-deviceid/issues) - I'll be
notified by email.

Please include all the relevant fields (vendor, model, class, os, messaging
capability).


Contents
----------

Tocall index (tocalls):

* tocall: The APRS destination callsign allocated for an application
* vendor: Vendor / author string identifying either the person or organisation
  producing the device or application.
* model: Device or software model
* class: A device class identifier, referring to the class index
* os: Operating system identifier
* features: Feature flags indicating optional features implemented on this device
   * messaging: a flag (1) identifying that the device is messaging capable

Mic-E device identifier index (mice):

This index contains the new-style two-character comment suffix part, which
is assigned to new Mic-E devices.  The first comment prefix character
indicates whether the device is messaging capable (` for messaging capable,
' for a non-messaging capable dumb tracker).

* suffix: The 2-character device
* vendor, model, class, os: same as in Tocall index

Mic-E legacy device identifier index (micelegacy):

This index contains the old-style prefix + suffix parts for Kenwood devices.
Messaging capability is listed in this index. A device may be identified by
only a 1-character prefix (the old devices), or both a 1-character prefix
and a 1-character suffix.

* prefix: The 1-character comment prefix
* suffix: The 1-character comment suffix
* vendor, model, class, os, features: same as in Tocall index

Device class index (classes):

* class: A device class identifier
* shown: An english shown string for the identifier
* description: An english description string


Lookup algorithm for destination callsigns
---------------------------------------------

1. Try an exact match against those tocalls in the index which have no
   wildcards (?, lower-case n, *). The quickest way to do this is to
   preload those tocalls from the database to a hash table or binary
   tree of some sort.
2. Go for the wildcarded entries next. Look for an entry having the
   longest match: APXYZ? should match before APXY??.

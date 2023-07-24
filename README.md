
APRS device identification database
======================================

Beginning from 2022-02-19, this is the master database for APRS device
identifier allocations.  Previously APRS device identifiers were allocated
by Bob Bruninga in http://aprs.org/aprs11/tocalls.txt and
http://www.aprs.org/aprs12/mic-e-types.txt and any new allocations had to be
made by Bob Bruninga in one of those files, before being added to this
database.  As Bob is sadly no longer with us, new allocations are now being
done directly to this database.

This may change in the future, if and when a new organization for APRS
standards and documentation is formed, as I can then pass on the allocations
responsibility to them.  I hope the new organisation will retain this
machine-readable format and continue the work directly from this git
repository.

This is a machine-readable index of APRS device and software identification
strings.  For easy manual editing and validation, the master file is in YAML
format.  A generator tool, provided in this repository, converts the
database to XML and JSON, which are also provided in the
`generated` directory for environments where those are more convenient to
parse.  The tool also checks the correct formatting of the database.

This database is maintained by Hessu, OH7LZB, and a soon-to-be-named team of
volunteers.

The database is published in a machine-readable format so that it would be
easy for developers to implement automatic identification of APRS devices
and software.  If you choose to use the database, and update from here
regularly, your APRS app will automatically detect new devices added in the
future.


Licensing
------------

The database is licensed under the CC BY-SA 2.0 license, so you're free to
use it in any of your applications, commercial, free or open source.  For
free.  Just mention the source somewhere in the small print.

http://creativecommons.org/licenses/by-sa/2.0/


Adding new devices
---------------------

If you have created a new APRS device, or written a new APRS app, and would
like to add it in the database, please read through the
[ALLOCATING](ALLOCATING.md) policy document, and then file an issue ticket
in Github (https://github.com/aprsorg/aprs-deviceid/issues) - we'll be
notified by email.

Please include all the relevant fields (vendor, model, class, os, contact).
The master file is tocalls.yaml, and all the other files are generated from
that file, so please use that format.

Do not submit new devices on others behalf, let the author of the device or
application to request addition directly. Thank you!

Thank you!


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
   * messaging: The device is messaging capable
   * item-in-msg: The device is capable of receiving APRS items in text messages 

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


Libraries and applications directly using this database
----------------------------------------------------------

* Ham::APRS::DeviceID for Perl, available at CPAN and
  https://github.com/hessu/perl-aprs-deviceid
* aprs_tocall module for Python:
  https://github.com/xssfox/aprs_tocall
  https://pypi.org/project/aprs-tocall/
* aprs.fi, using Ham::APRS::DeviceID

Others? Let me know.


Lookup algorithm for destination callsigns
---------------------------------------------

1. Try an exact match against those tocalls in the index which have no
   wildcards (?, lower-case n, *). The quickest way to do this is to
   preload those tocalls from the database to a hash table or binary
   tree of some sort.
2. Go for the wildcarded entries next. Look for an entry having the
   longest match: APXYZ? should match before APXY??.


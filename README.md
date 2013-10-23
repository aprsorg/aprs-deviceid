
APRS device identification database
======================================

This is a machine-readable index of APRS device and software identification
strings.  For easy manual editing and validation, the master file is in YAML
format, but conversions to other formats (XML, JSON, CSV) are
easy and will be provided a bit later.

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


Contents
----------

Tocall index:

* tocall: The APRS destination callsign allocated for an application
* vendor: Vendor / author string identifying either the person or organisation
  producing the device or application.
* model: Device or software model
* class: A device class identifier, referring to the class index

Mic-E device identifier index:

* TODO

Device class index:

* class: A device class identifier
* shown: An english shown string for the identifier
* description: An english description string


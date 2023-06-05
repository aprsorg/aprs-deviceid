
APRS device identifier allocation process
=============================================

This document describes how APRS device identifiers (destination calls, i.e.
tocalls, and Mic-E type codes) are allocated.


Background: Why device identifiers are allocated
---------------------------------------------------

APRS transmitter manufacturers and models are identified by the AX.25
destination callsign (tocall).  For devices using Mic-E encoding, which uses
the destination callsign field to encode data, Mic-E type codes are used.

Using model-specific identifiers allows APRS applications and web sites to
identify and display the make and model of each APRS station.  This allows
us to:

* Provide information to the users about what APRS functionality each
  station can be expected to have
  (for example: two-way messaging, display, just a tracker)
* Provide visibility to manufacturers and developers
* Generate statistics on device popularity
* Attribute erratic behaviour on the APRS network to a specific model
  and help manufacturers fix bugs


Who does what, and when
--------------------------

* A developer or manufacturer of an APRS device or application requests an
  identifier, preferably well in advance before the release of the
  application to customers or users.  A new identifer is not necessary to
  begin development or transmit data during development.
* Note that the request should come from the manufacturer or developer.
  It is not be the responsibility of the users of the devices to request or
  configure identifiers, and it would be good if all developers and
  manufacturers establish a contact with people maintaining the APRS
  documents and infrastructure, so that they can be reached in case there
  are interoperability issues.
* The maintainers of the allocation table allocate an identifier. They may
  need to ask clarifying questions if the request does not contain all the
  necessary information, there are typografical issues to confirm, or if the
  request somehow does not meet the criteria below.  Maintainers will try to
  respond within a week normally, but since it's an unpaid volunteer job,
  please file a request well in advance before your release date, just in
  case it would take longer for some reason.


Development phase
--------------------

A unique identifier is not required for development.  Rather, a random
unallocated identifier in the experimental "APZ???" range can be used.

Note that some specific identifiers in the experimental range have been
allocated to specific devices in the history, even though it has been
defined as experimental - one of those should not be used for development.
Check that your chosen random prefix is unallocated before using it.
(TODO: Add link to APZ allocations)

Alternatively, the generic "APRS" destination callsign can be used.


How
------

Requests for new identifiers are made by creating an issue ticket on the
master Gibhub repository where this database is maintained
(https://github.com/aprsorg/aprs-deviceid/issues).  This requires a free
Github user account.

If it is impossible for the applicant to create one, an email can be sent to
allocations@aprs.org (NOT YET FUNCTIONAL).  The maintainers will then create
the ticket before processing the request - email message contents will be
posted as ticket contents.  Email addresses can be kept secret, but the
emails sent to the address will be archived by the maintainers.  Direct
emails to maintainers are not processed - all requests must come in as a
ticket or via the email alias, and the email alias should only be used if it
is impossible to create a ticket.

These issue tickets are public, and the discussion, any clarifying questions
are and their answers are public as well.  This way everyone can see how the
requests are processed.  This makes the process open and accountable.


Allocation criteria
----------------------

Device identifiers are allocated to anyone who is distributing, or planning
to distribute, an APRS software application, or an APRS device, to others.

Device identifiers are also allocated to APRS service implementations which
transmit APRS packets on behalf of APRS users, such as protocol converters
(DMR, D-Star, and similar), and web services.

Manufacturers and developers distributing multiple models or variations can
also be allocated a 4- or 5-letter prefix, allowing the last 1 or 2
characters to identify models.

To reduce maintenance workload and database size, new identifiers are not
allocated to unique experimental applications which are only used by the
developer, and not published for others to use.  They can be conveniently
described in the comment text of a position packet, or a separate status
packet, without requiring a lengthy process.  The comment and status text
are shown immediately by all APRS displays, while the device identifier
database may take a long time to be updated and distributed.  Most APRS
displays currently do not automatically fetch and use the device
identification database.


Prefix allocations
---------------------

The normal length of a device identifier is six ASCII characters.
Manufacturers and developers distributing multiple models or variations can
also be allocated a 4- or 5-letter prefix, allowing the last 1 or 2
characters to identify models.  As there are only 676 4-letter prefixes,
specific 5-letter prefixes are primarily allocated for new devices.

It is a good practice to use letters for the prefix and numbers for the last
characters, to allow for a fast visual distinction between the manufacturer
and the model number.


Data attached to the allocation
----------------------------------

The allocation consists of the allocated TOCALL, or a prefix with glob-style
wildcards, the name of the `vendor`, the name of the device `model`, and
optionally a classification identifier `class` and the name of the operating
system `os` the software runs on.  An optional technical `contact` email
address may be supplied.

     - tocall: APACMx
       vendor: ACME APRS Solutions Ltd
       model: MegaTracker
       class: tracker
       os: embedded
       contact: developers@example.com

     - tocall: APFOOx
       vendor: Firstname Lastname, N0CALL
       model: First and Last APRS
       class: software
       os: Windows
       contact: first.lastname@example.com
       features:
          - messaging

The amount of information attached to the record is intentionally quite
limited.  Large descriptions and deep model-specific URLs would likely
change often, and cause additional database updates.

The `class` identifier is a not a free-form text field - it is an identifier
referring to an entry in a list of predefined classes.  The list of classes
is also defined in the allocation database - new classes can be added if
necessary, but as applications using the database may choose to translate
the displayed names of classes to different languages, new classes should be
added sparingly.

The Operating System identifier `os` is only for identifying the supported
operating systems, if there is one - not for specific operating system
versions. A list of operating system field values can be found below.

The `class` and `os` fields can be omitted, if they are not relevant, or if
a suitable class is not available.

The `features` field is for signaling that the application supports one or
more of the following features. APRS applications may use these hints to
adapt to capabilities of other stations.

  * `messaging`: APRS text messages
  * `item-in-msg`: APRS items embedded in text messages


Application/device classes
-----------------------------

A class primarily identifies the physical or virtual form factor of the APRS
device.

Each device identifier can only be attached to one class.  Pick the one that
best describes your device or application.  The class attribute is not
mandatory - if a suitable class is not available, it can be omitted.

 * tracker: Small APRS tracker device
   - Typically devices with a GNSS receiver (GPS), primarily reporting a
     moving position.
 * gadget: Small APRS non-tracker device
   - Portable or fixed devices
   - Typically embedded devices without a GNSS receiver, reporting telemetry
     or otherwise not fitting the tracker category.
 * rig: APRS mobile or desktop radio
 * ht: Hand-held APRS radio
 * app: Mobile phone or tablet app
 * software: Desktop computer software with user interface
 * daemon: Computer software without user interface
   - Software which is installed on a computer, connecting to the APRS
     network (on RF or the Internet), running as a background service
     without user interaction.  Typically iGate and digipeater software.
 * network: APRS network appliance
   - A hardware appliance with self-contained APRS networking features:
     iGates and digipeaters, TNCs with APRS firmware.
 * service: APRS network service: web services, APRS message bots
   - Software not typically installed by users, primarily available as
     a service for users on the APRS network, or on the web for
     accessing APRS.
 * wx: Weather station
   - A dedicated weather station.
 * satellite: Satellite-based station
   - APRS software running on the satellite itself.


Operating systems
--------------------

Each device identifier may be associated with one of these operating
systems.  If an application can be run on multiple platforms (as in the case
of Java applications), the "Multiple" option is suitable.  If a native
mobile application is separately written for Android (in Java or Kotlin) and
iOS (in Objective-C and Swift), and they are technically two different
applications, two different tocalls may be allocated.

 - Android
 - Browser
 - Embedded
 - iOS
 - Linux/Unix
 - macOS
 - Multiple
 - Other
 - Windows


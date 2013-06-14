v1 cartridge scripts
=======

These scripts drove creation and testing for v1 and are now obsolete.

* __mkhosts__

  Create entries in /etc/hosts for the gears.

* __create__

  Create 15k gears directly on the node without using the broker or
  DNS.

* __create-impl__

  Called by create to do its work.

* __check__

  Start, test and stop the first and last 20 gears.

* __check-impl__

  Called by check to do its work.

c9tests
=======

C9 15k Gear Tests

These tests are intended to minimally validate C9 configurations and
may take a long time to run.

A subset of the functionality to create 15k applications is being
handled by the user story under test.  You should also conduct normal
validation on a normal configuration to ensure the code works
properly.

An m1.xlarge or larger is required to run these tests.

This only smoke tests 15000 gear with the things we expect to work at
that scale.  That does not currently include the broker or mcollective
so they are turned off.  After prep.sh is run; the instance can no
longer run other kinds of tests.

Example: Do the following and observe that no errors show up.
prep
mkhosts
create
check


* __prep__

  Prepare an EC2 m1.xlarge instance for 15k gear tests.  This
  procedure will render the node unusable for other types of testing.

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

* __mkapp.sh__

  Make a test app for demo.

* __noapp.sh__

  Delete the test app for demo.

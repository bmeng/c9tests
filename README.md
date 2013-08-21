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

* __create.sh__

  Create 100 gears directly on the node (bypass broker and mcollective)

* __delete.sh__

  Delete all the gears on the node (bypass broker and mcollective).

* __restart.sh__

  Start and stop the middle 100 gears on the node.

* __start.sh__

  Start the middle 100 gears on the node.

* __stop.sh__

  Stop the middle 100 gears on the node.

* __control.sh__

  Call commands on the control script.

* __doit.sh__

  Run 40 batches of creating 100 apps, then restarting the middle 100
  apps on the node.  Then delete them all.

* __control-impl__

  Driver script for above commands.  Do not call directly.

* __v1_cart__

  V1 Cartridge API scripts.  Deprecated.


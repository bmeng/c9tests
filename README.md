c9tests
=======

C9 15k Gear Tests

These tests are intended to minimally validate C9 configurations and
may take a long time to run.

The node may not be usable for other classes of testing after the prep
script is run.

An m1.xlarge is recommended for creating thousands of gears.  Up to
4000 may be done on an m1.large.

Due to the long run times, it is recommended to run these scripts in a
screen session.

Ex:

./prep

./create.sh 4000

./restart



* __prep__

  Prepare an EC2 m1.xlarge instance for 15k gear tests.  This
  procedure will render the node unusable for other types of testing.

* __create.sh__

  Create gears directly on the node (bypass broker and mcollective).
  Specify number of gears to create on the command line (default:
  100).

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

* __control-impl__

  Driver script for above commands.  Do not call directly.

* __queue.rb__

  Queuing library for efficient task parallelization.

* __v1_cart__

  V1 Cartridge API scripts.  Deprecated.


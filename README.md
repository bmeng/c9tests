c9tests
=======

C9 15k Gear Tests

These tests are intended to validate US3050 and take a long time to
run.

A subset of the functionality to create 15k applications is being
handled by US3050.  Tests require some node modifications to work and
will bypass the broker and mcollective entirely.


* __prep.sh__

  Prepare an EC2 m1.large or m1.xlarge instance for 15k gear tests.
  This procedure will render the node unusable for other types of
  testing.

* __create.sh__

  Create 15k gears directly on the node without using the broker or
  DNS.

* __check.sh__

  Start, test and stop the first and last 20 gears.

* __samelabel.sh__

  Ensure that no pair of gears has the same MCS label or IP address.

* __net.sh__

  Verify that the IPTables and SELinux restrictions work properly for
  every gear.  Also test polyinstantiation.

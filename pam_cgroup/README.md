pam_cgroup test
=======

These scripts create 100 gears at a time up to 4000 and benchmark
creation speed.

Between every 100 creates, the middle 100 gears on the node will be
started and stopped.

* __doit.sh__

  Run the test.

* __create.sh__
* __create-impl__

  Create 100 gears directly on the system (bypass broker and mcollective)

* __delete.sh__
* __delete-impl__

  Delete all the gears on the node (bypass broker and mcollective).

* __restart.sh__
* __restart-impl__

  Start and stop the middle 100 gears on the node.




echotcp
=====

TCP echo service, uses the socket API.

Purpose of this repository is to show a way to package erlang releases for
RHEL(-derivate) and FreeBSD systems.

content of `pkg/common` and `rpm/common` is generic, release specific values are
set in (in the environment of) `pkg/create.sh` and `rpm/create.sh`.

Create RHEL(-derivate) rpm
-----

    $ ./rpm/create.sh

The RPM package includes:

  - echotcp application
  - erlang runtime
  - service file
  - firewalld service configuration file
  - selinux policy


Create FreeBSD pkg
-----

    $ ./pkg/create.sh

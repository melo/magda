Magda
=====

Magda is a Perl-based experimental deployment tool.

I'm just exploring some ideas, most likelly I'll find a tool that
already does what I want, but sometimes writting at least parts of the
system I want allows me to clarify my requirements.


Goals
-----

The system must:

 * allow for live deployments and restart without downtime;
 * rollback without downtime;
 * database schema upgrades;
 * manage multiple projects simultaneously;
 * multi-server;
 * test-driven pre-deployment validation;
 * manage dependencies with cpanm or preferably Cartoon.


Some notes about my environment
-------------------------------

I don't have a big network with thousands of servers. Its a very small
shop, but because its a small shop, the deployment must be as automatic
as possible.

I have multiple projects running on the same servers. My production
servers don't use any type of virtualization, instead I use different
user id's per project.

All services of a single project run under that user_id, and all
resources for each project is located inside the home directory
of the user.

I use mainly Perl, and each project has his own perlbrew-manager perl
setup. Each project used to have all his deps installed directly into
the perlbrew-manager perl site_perl, but given that we want to have
multiple instances of the same app running, I'm moving to per-instance
local::lib-based setups.

My supervisor is [daemontools][daemontools]. The user can control his own daemons.

All projects share a frontend proxy, nginx powered.


 [daemontools]: http://cr.yp.to/daemontools.html

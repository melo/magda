## Configuration for your project is wrapped in a class
## a singleton of this class will be created by the Magda runtime
package My::Project;

## This enables strict, warnings, autodie, utf8 and all the feature the
## current perl has, and setups this class to extend Magda::Project
use Magda::Describe::Project;

## I like this, makes the code cleaner, personal preference only, not
## required for Magda
use Method::Signatures;

### Top-level definition of this project
project {
  ## For humans - description
  descr 'My super duper project';

  ## Shared secret, to authz communication between Magda agents
  ## Eventually moving to SSL certificates with private CAs
  key '...';
  ## ... or ...
  key_from '~/.magda/project_key';

  ## Code executed at several places: starting up services, etc.
  ## See below for a more complete example of what you can do here
  setup {...};
};


## Each project can have many instances: staging, production_live,
## production_next, production_last_good, etc
## Actions will target one or more of this instances
instance {
  ## the name of the instance, unique, used to build a directory, so \w only
  name 'staging';

  ## For humans - description
  descr 'long description for humans';

  ## Declare the setup code, runs when we turn on any service on a
  ## instance
  setup {
    ## Configuration pairs key => value. If value is a scalar, will be
    ## exported via ENV as MAGDA_CFG_key => value
    ## More complex values will not be exported for now
    configs
      ## Constant value for var
      E5_ENV => 'staging',

      ## Will be called at runtime to determine the value, undef means don't set
      CATALYST_DEBUG => sub {...},
      ;

    ## Paths that must exist
    paths
      ### use pairs key => value, key will be exported to ENV as MAGDA_PATH_key => $value
      ## a constant path: relative to instance home
      some_dir => 'some_dir/',

      ## project_base helper: project base is usually the home directory
      ## of the user_id for this project. All helpers accept a list of
      ## directories. Scalar wills be used as is, scalar refs will use
      ## config($$scalar_ref). coderefs will be called and the return
      ## value will be used as is
      logs => project_base('scratch_for', \'E5_ENV'),

      ## other helpers:
      ##  * project_workdir: shared workspace between all instances
      ##  * instance_workdir: per instance workspace
      ##  * log_dir: per instance directory for log files, or multilog log directories
      ;
  };
};


### Services, which long term process we will have running, per instance
service {
  ## the name of the service, unique, used to build a directory, so \w only
  name 'app_server';

  ## For humans - description
  descr 'app server';

  ## The type of this service, in this case a web app using Starman
  type 'Starman';

  ## Args are passed on through to the Starman plugin
  ## Listen - where do we bind ourselfs to listen for requests. TCP
  ## Host/Port? UNIX socket? You don't specify a constant here, but
  ## the name of a config var that will be used as the value. If no
  ## config var is found, and no default or is_optional exists,
  ## setup dies.
  ## The *_ prefix (see backlog) is special: the * will be replaced
  ## with the name of the service (easier to type)
  arg listen       => 'app_server_listen';
  arg workers      => (cfg => 'app_server_workers', default => 1);
  arg max_requests => (cfg => '*_max_requests', is_optional => 1);

  ## Configuration files that will be generated, placed on a specific dir and have their path exported to ENV
  template {
    ## Unique
    name 'nginx_config';
    descr => 'app server nginx cfg',

      ## Optional: defaults to a simple template system that will do basic find/replace
      ## but more complex plugins that provide actions or sane defaults can be used
      type => 'NginxFrontendProxy',
      ;
  };
};


## TODO: document std Actions - deploy, restart, rotate (on instance
## types that support it)

## TODO: document standard phases: cleanup old, sync, enable (setup,
## start, check, accept tests)

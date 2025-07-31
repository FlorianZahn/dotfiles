# dotfiles

## Nix

### Folder Structure

#### hosts

This folder contains configurations for all my machines.

A machine folder contains:

- **bundle.nix** - bundles the other 3 locations
- **configuration.nix** - system configuration using core system configuration and optional settings.
- **hardware-configuration.nix**
- **user folder** - Users are declared here. Each user is configured using their core configuration and optional settings for this machine.

The configuration file brings together my core system configuration, host specific configuration, and host specific user configurations.
The host specific configuration is built using the optional system modules.
The user configuration is assembled using the core user configuration and host specific configurations.

#### modules

##### system

This folder contains the core configuration and optional modules.

##### home

This folder contains optional home configurations.

##### users

This folder contains core user configurations.

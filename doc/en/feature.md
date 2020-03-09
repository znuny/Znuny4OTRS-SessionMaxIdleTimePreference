# Functionality

## User based session idle time

The OTRS setting 'SessionMaxIdleTime' defines the wait time until a session expires when no further user action occurs. This configuration affects all agents and can not be set individually for each agent in the personal settings. This extension contains the functionality to set the waiting time of each agent. The possible waiting times between which an agent can choose can be defined via the new SysConfig 'Znuny4OTRSSessionMaxIdleTimePreference::IdleTimeOptions'.

In addition, there is a new option in the personal settings, which allows you to display a banner that displays the expiration time of the session.
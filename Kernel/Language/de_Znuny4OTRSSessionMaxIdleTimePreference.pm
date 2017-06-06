# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_Znuny4OTRSSessionMaxIdleTimePreference;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'This configuration defines the custom session idle times from which the agent can choose in the preferences. The key defines the seconds until the session gets revoked as invalid and the value is the selectable text shown in the agent preferences box.'} = 'Diese Konfiguration definiert die eigenen Session Idle Zeiten, die in den persönlichen Einstellungen angezeigt werden. Der Schlüssel definiert die Sekunden, bis eine ungenutzte Session ungültig wird. Der Wert entspricht dem angezeigten Text, der in den persönlichen Einstellungen ausgewählt werden kann.';

    $Self->{Translation}->{'The time that has to pass without an action in the system unil the account gets logged out automatically.'} = 'Die zu vergehende Zeit, ohne dass eine Aktion im System durchgeführt wird, bis eine automatische Abmeldung erfolgt.';
    $Self->{Translation}->{'Session Time'} = 'Automatische Abmeldezeit';
    $Self->{Translation}->{'Show banner'} = 'Zeige Benachrichtigung';

    $Self->{Translation}->{'1 minute'}   = 'Eine Minute';
    $Self->{Translation}->{'5 minutes'}  = '5 Minuten';
    $Self->{Translation}->{'10 minutes'} = '10 Minuten';
    $Self->{Translation}->{'15 minutes'} = '15 Minuten';
    $Self->{Translation}->{'30 minutes'} = '30 Minuten';
    $Self->{Translation}->{'1 hour'}     = 'Eine Stunde';

    $Self->{Translation}->{'Your will get logged out automatically at %s if no action will get performed.'} = 'Der automatische Abmeldevorgang erfolgt um %s Uhr, wenn keine weiteren Aktionen durchgeführt werden.';

    return 1;
}

1;

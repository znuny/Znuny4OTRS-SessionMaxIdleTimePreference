# --
# Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Notification::Znuny4OTRSSessionMaxIdleTimePreference;

use strict;
use warnings;
use utf8;

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Time',
    'Kernel::System::User',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');
    my $UserObject     = $Kernel::OM->Get('Kernel::System::User');
    my $TimeObject     = $Kernel::OM->Get('Kernel::System::Time');

    # check if the current user has configured
    # to show the notification banner
    my %Preferences = $UserObject->GetPreferences(
        UserID => $LayoutObject->{UserID},
    );
    return '' if !$Preferences{UserSessionMaxIdleTimeBanner};

    # return if no custom idle time is configured
    return '' if !$Preferences{UserSessionMaxIdleTime};

    # calculate the TimeStamp when the account will get logged out
    my $IdleLogoutTimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $LayoutObject->{UserLastRequest} + $Preferences{UserSessionMaxIdleTime},
        Type       => 'Short',
    );

    # translate and show the notification text
    my $IdleLogoutText = $LanguageObject->Translate(
        'Your will get logged out automatically at %s if no action will get performed.',
        $IdleLogoutTimeStamp
    );
    return $LayoutObject->Notify(
        Data     => $IdleLogoutText,
        Priority => 'Info',
    );
}

1;

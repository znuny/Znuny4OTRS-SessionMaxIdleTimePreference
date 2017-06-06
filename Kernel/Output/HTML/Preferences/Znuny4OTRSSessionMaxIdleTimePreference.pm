# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Preferences::Znuny4OTRSSessionMaxIdleTimePreference;

use strict;
use warnings;

use base qw( Kernel::Output::HTML::Preferences::Skin );

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::Web::Request',
);

sub Param {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject    = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    # get the selected idle time from
    # the web request or the stored one
    # from the UserData of the current user
    my $SelectedIdleTime = $ParamObject->GetParam( Param => $Self->{ConfigItem}->{PrefKey} );
    $SelectedIdleTime ||= $Param{UserData}->{ $Self->{ConfigItem}->{PrefKey} };

    # get the possible idle times from the SysConfig
    my $IdleTimeOptions = $ConfigObject->Get('Znuny4OTRSSessionMaxIdleTimePreference::IdleTimeOptions') || {};

    # translate the configured idle times
    my %IdleTimeOptionsTranslated;
    for my $Seconds ( sort keys %{$IdleTimeOptions} ) {
        $IdleTimeOptionsTranslated{$Seconds} = $LanguageObject->Translate( $IdleTimeOptions->{$Seconds} );
    }

    # get the selected banner configuration or default to disabled
    my $SelectedIdleTimeBanner = $ParamObject->GetParam( Param => $Self->{ConfigItem}->{PrefKey} . 'Banner' );
    $SelectedIdleTimeBanner ||= $Param{UserData}->{ $Self->{ConfigItem}->{PrefKey} . 'Banner' };
    $SelectedIdleTimeBanner ||= 0;

    return (
        {
            %Param,
            Name         => $Self->{ConfigItem}->{PrefKey},
            Data         => \%IdleTimeOptionsTranslated,
            HTMLQuote    => 0,
            PossibleNone => 1,
            Sort         => 'NumericKey',
            SelectedID   => $SelectedIdleTime,
            Block        => 'Option',
        },
        {
            %Param,
            Name => $Self->{ConfigItem}->{PrefKey} . 'Banner',
            Data => {
                1 => 'Yes',
                0 => 'No',
            },
            Translation => 1,
            HTMLQuote   => 0,
            SelectedID  => $SelectedIdleTimeBanner,
            Key         => 'Show banner',
            Block       => 'Option',
        },
    );
}

1;

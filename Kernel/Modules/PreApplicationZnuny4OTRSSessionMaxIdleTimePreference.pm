# --
# Copyright (C) 2012-2018 Znuny GmbH, http://znuny.com/
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# $origin: otrs - bdfbf5a6a26938e59ef29101255c159ce696c0a1 - Kernel/System/Web/InterfaceAgent.pm
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::PreApplicationZnuny4OTRSSessionMaxIdleTimePreference;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Auth',
    'Kernel::System::AuthSession',
    'Kernel::System::Time',
    'Kernel::System::User',
);

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $UserObject    = $Kernel::OM->Get('Kernel::System::User');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $AuthObject    = $Kernel::OM->Get('Kernel::System::Auth');
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TimeObject    = $Kernel::OM->Get('Kernel::System::Time');

    # check if the current user has configured a custom SessionMaxIdleTime
    my %Preferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );
    return if !$Preferences{UserSessionMaxIdleTime};

    # if so, overwrite the Config for the current request
    $ConfigObject->Set(
        Key   => 'SessionMaxIdleTime',
        Value => $Preferences{UserSessionMaxIdleTime},
    );

    # this is a workaround since the SystemTime of the current request
    # gets stored in the previous session check so we have to reset it
    # and set the current SystemTime again later
    $SessionObject->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'UserLastRequest',
        Value     => $Self->{UserLastRequest},
    );

    # check if the current session is still valid or
    # our SessionMaxIdleTime has caused an invalid session
    my $SessionOK = $SessionObject->CheckSessionID(
        SessionID => $Self->{SessionID},
    );

    if ($SessionOK) {
        # here we are setting the current SystemTime again
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserLastRequest',
            Value     => $TimeObject->SystemTime(),
        );

        # session is ok, the request can get performed regularly
        return;
    }

    # keep currently requested URL by using the same functionality as the framework:
    # https://github.com/OTRS/otrs/blob/bdfbf5a6a26938e59ef29101255c159ce696c0a1/Kernel/System/Web/InterfaceAgent.pm#L117
    # drop old session id (if exists)
    $Param{RequestedURL} = $ENV{QUERY_STRING} || '';
    $Param{RequestedURL} =~ s/(\?|&|;|)$Self->{SessionName}(=&|=;|=.+?&|=.+?$)/;/g;

    # the session has been canceled so we have to perform the
    # "invalid session" procedure regualarly handled by the framework:
    # taken from https://github.com/OTRS/otrs/blob/bdfbf5a6a26938e59ef29101255c159ce696c0a1/Kernel/System/Web/InterfaceAgent.pm#L840
    if ( $AuthObject->GetOption( What => 'PreAuth' ) ) {

        # automatic re-login
        $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
        return $LayoutObject->Redirect(
            OP => "?Action=PreLogin&RequestedURL=$Param{RequestedURL}",
        );
    }
    elsif ( $ConfigObject->Get('LoginURL') ) {

        # redirect to alternate login
        $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
        return $LayoutObject->Redirect(
            ExtURL => $ConfigObject->Get('LoginURL')
                . "?Reason=InvalidSessionID&RequestedURL=$Param{RequestedURL}",
        );
    }

    # show login
    return $LayoutObject->Print(
        Output => \$LayoutObject->Login(
            Title => 'Login',
            Message =>
                $LayoutObject->{LanguageObject}->Translate( $SessionObject->SessionIDErrorMessage() ),
            MessageType => 'Error',
            %Param,
        ),
    );
}

1;

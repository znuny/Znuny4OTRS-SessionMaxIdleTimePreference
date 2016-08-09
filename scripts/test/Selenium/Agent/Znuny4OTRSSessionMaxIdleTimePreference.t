# --
# Copyright (C) 2012-2016 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreSystemConfiguration => 1,
    },
);

# get the Znuny4OTRS Selenium object
my $SeleniumObject = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

# store test function in variable so the Selenium object can handle errors/exceptions/dies etc.
my $SeleniumTest = sub {

    # initialize Znuny4OTRS Helpers and other needed objects
    my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
    my $TimeObject        = $Kernel::OM->Get('Kernel::System::Time');

    my %LoaderConfig = (
        AgentPreferences => [
            'Core.Form.Znuny4OTRSInput.js',
        ],
    );

    $ZnunyHelperObject->_LoaderAdd(%LoaderConfig);

    # create test user and login
    my %TestUser = $SeleniumObject->AgentLogin(
        Groups   => [ 'admin', 'users' ],
        Language => 'de',
    );

    $SeleniumObject->AgentInterface(
        Action      => 'AgentPreferences',
        WaitForAJAX => 0,
    );

    $SeleniumObject->InputFieldIDMapping(
        Action  => 'AgentPreferences',
        Mapping => {
            UserSessionMaxIdleTime       => 'UserSessionMaxIdleTime',
            UserSessionMaxIdleTimeBanner => 'UserSessionMaxIdleTimeBanner',
        },
    );

    $SeleniumObject->InputSet(
        Attribute   => 'UserSessionMaxIdleTime',
        Content     => '60',
        WaitForAJAX => 0,
    );
    $SeleniumObject->InputSet(
        Attribute   => 'UserSessionMaxIdleTimeBanner',
        Content     => '1',
        WaitForAJAX => 0,
    );

    $SeleniumObject->find_element( '#UserSessionMaxIdleTime', 'css' )->VerifiedSubmit();

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime() - 1,
    );

    $Min++;

    $SeleniumObject->PageContains(
        String => "Der automatische Abmeldevorgang erfolgt um $Hour:$Min:",
    );

    # wait till the session will be invalid
    sleep 61;

    $SeleniumObject->refresh();

    $SeleniumObject->PageContains(
        String => 'Session abgelaufen. Bitte neu anmelden.',
    );
};

# finally run the test(s) in the browser
$SeleniumObject->RunTest($SeleniumTest);

1;

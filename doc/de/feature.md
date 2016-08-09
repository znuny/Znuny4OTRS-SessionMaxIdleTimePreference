# Benutzerbasierte Session Wartezeit

Im OTRS Standard definiert die SysConfig 'SessionMaxIdleTime' die Wartezeit, bis eine Session abläuft, wenn keine weitere Benutzeraktion erfolgt. Diese Konfiguration betrifft alle Agenten und lässt sich nicht individuell pro Agent in den persönlichen Einstellungen festlegen. Diese Erweiterung enthält die Funktionalität um die Wartezeit von jedem Agenten selbst festlegen zu können. Die möglichen Wartezeiten, zwischen denen ein Agent wählen kann, können über die neue SysConfig 'Znuny4OTRSSessionMaxIdleTimePreference::IdleTimeOptions' festgelegt werden.

Außerdem gib es eine neue Option in den persönlichen Einstellungen, die es erlaubt einen Banner einzublenden, der den Ablaufzeitpunkt der Session ausgibt.

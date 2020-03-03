CLEARSCREEN.

SET EMPTY_LINE TO "                                             ".

FROM { local countdown is 3. } UNTIL countdown = 0 STEP { SET countdown to countdown - 1. } DO {
    PRINT "..." + countdown.
    WAIT 1. // Pauses the script here for 1 second
}

// TODO: If target is selected, launch to altitude of target
// SET TARGET_APOAPSIS TO TARGET:ALTITUDE - (TARGET:SOIRADIUS * 0.1). // m

SET TARGET_APOAPSIS TO BODY:ATM:HEIGHT. // m

if TARGET_APOAPSIS = 0 {
    SET TARGET_APOAPSIS TO BODY:RADIUS.
}

SET TARGET_APOAPSIS TO TARGET_APOAPSIS * 1.2.

SET STEER TO HEADING(90, 90).
LOCK STEERING TO STEER. // Enable change steering by just assigning a new value to STEER

LOCK THROTTLE TO 1.0.

PRINT "Target apoapsis is " + ROUND(TARGET_APOAPSIS) + " m" AT (0, 14).

WHEN MAXTHRUST = 0 THEN {
    PRINT "Staging".
    STAGE.
    PRESERVE. // Keeps the trigger active even after it has been triggered
}

SET PITCH TO 90.

UNTIL APOAPSIS > TARGET_APOAPSIS {

    IF SHIP:VELOCITY:SURFACE:MAG > 100 {
        SET PITCH TO 80.
        SET STEER TO HEADING(90, PITCH).
    }

    PRINT EMPTY_LINE AT (0, 15).
    PRINT EMPTY_LINE AT (0, 16).
    PRINT EMPTY_LINE AT (0, 17).

    PRINT "Pitching to " + ROUND(PITCH) + " degrees" AT (0, 15).
    PRINT "Altitude is " + ROUND(ALTITUDE) + " m" AT (0, 16).
    PRINT "Apoapsis is " + ROUND(APOAPSIS) + " m" AT (0, 17).

    WAIT 0.1.
}

HUDTEXT("Target apoapsis reached", 8, 1, 18, rgb(1,1,1), true).

LOCK THROTTLE TO 0.
UNLOCK ALL.

// This sets the user's throttle setting to zero to prevent the throttle
// from returning to the position it was at before the script was run.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

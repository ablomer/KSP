CLEARSCREEN.

SET EMPTY_LINE TO "                                             ".

FROM { local countdown is 3. } UNTIL countdown = 0 STEP { SET countdown to countdown - 1. } DO {
    PRINT "..." + countdown.
    WAIT 1. // Pauses the script here for 1 second
}

HUDTEXT("Establishing orbit", 8, 1, 18, rgb(1,1,1), true).

IF OBT:ECCENTRICITY >= 1 {
    SAS ON.
    WAIT 1.
    SET SASMODE TO "RETROGRADE".

} ELSE {
    SAS ON.
    WAIT 1.
    SET SASMODE TO "PROGRADE".
}

UNTIL OBT:ECCENTRICITY < 0.2 {
    LOCK THROTTLE TO MIN(OBT:ECCENTRICITY, 1.0).
    PRINT EMPTY_LINE AT (0, 13).
    PRINT "Eccentricity: " + ROUND(OBT:ECCENTRICITY, 2) AT (0, 13).
    WAIT 0.1.
}

// TODO: Adjust pitch to control apoap and periap altitude change

HUDTEXT("Orbit established", 8, 1, 18, rgb(1,1,1), true).

SAS OFF.
LOCK THROTTLE TO 0.0.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.0.
UNLOCK ALL.

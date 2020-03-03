CLEARSCREEN.

SET EMPTY_LINE TO "                                             ".

FROM { local countdown is 3. } UNTIL countdown = 0 STEP { SET countdown to countdown - 1. } DO {
    PRINT "..." + countdown.
    WAIT 1. // Pauses the script here for 1 second
}

HUDTEXT("Landing", 8, 1, 18, rgb(1,1,1), true).

SET ALTITUDE_OFFSET TO 5.
SET GRAVITY TO constant:g * body:mass / body:radius ^ 2. // m/s²

LOCK TERRAIN_HEIGHT TO SHIP:GEOPOSITION:TERRAINHEIGHT.
LOCK TRUE_ALTITUDE TO SHIP:ALTITUDE - MAX(0, TERRAIN_HEIGHT) - ALTITUDE_OFFSET.
LOCK TRUE_SPEED TO ORBIT:VELOCITY:ORBIT:MAG. // TODO: Move to global file

LOCK MAX_ACCELERATION TO (ship:availablethrust / ship:mass) - GRAVITY.	// Maximum deceleration possible (m/s²)
LOCK STOP_DISTANCE TO TRUE_SPEED ^ 2 / (2 * MAX_ACCELERATION).		    // The distance the burn will require
LOCK IDEAL_THROTTLE TO STOP_DISTANCE / TRUE_ALTITUDE.			        // Throttle required for perfect hoverslam
LOCK ETA_IMPACT TO TRUE_ALTITUDE / abs(TRUE_SPEED).

// Start descent
WAIT UNTIL VERTICALSPEED < -1.

BRAKES ON.
SAS ON.
WAIT 1.
SET SASMODE TO "RETROGRADE".

WHEN ETA_IMPACT < 3 THEN {
    GEAR ON.
}

// Start burn
UNTIL TRUE_ALTITUDE < STOP_DISTANCE {

    PRINT EMPTY_LINE AT (0, 15).
    PRINT EMPTY_LINE AT (0, 16).

    PRINT "trueRadar = " + ROUND(TRUE_ALTITUDE) + " m" AT (0, 15). // TODO: Have a countdown instead
    PRINT "stopDist = " + ROUND(STOP_DISTANCE) + " m" AT (0, 16). // TODO: Make printAt function in global file

	WAIT 0.1.
}

LOCK THROTTLE TO IDEAL_THROTTLE.

// Touchdown
WAIT UNTIL STATUS = "LANDED".

HUDTEXT("Touchdown", 8, 1, 18, rgb(1,1,1), true).

BRAKES OFF.
LOCK THROTTLE TO 0.0.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.0.
UNLOCK ALL.

// TODO: Break into functions (onStart, onStop, ...)
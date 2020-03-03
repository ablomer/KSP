SET H TO 90. // Direction of body rotation
SET TARGET_ALTITUDE TO ALTITUDE + 1000.
SET STEER TO HEADING(H, 90).
LOCK STEERING TO STEER.

SAS OFF.
SET THROT TO 0.0.
LOCK THROTTLE TO THROT.

UNTIL APOAPSIS > TARGET_ALTITUDE {
    SET THROT TO (ALTITUDE / TARGET_ALTITUDE) - 0.25.
    SET PITCH TO 90 - (ALTITUDE / TARGET_ALTITUDE) * 90.
    SET STEER TO HEADING(H, PITCH).
}

GEAR OFF.
LOCK THROTTLE TO 1.0.

UNTIL PERIAPSIS > 0 {
    SET STEER TO HEADING(H, 0).
}

LOCK THROTTLE TO 0.0.

WHEN ETA:APOAPSIS < 5 THEN {

    LOCK THROTTLE TO 1.0.

    UNTIL APOAPSIS > BODY("MUN"):SOIRADIUS - 200000 {
        SET STEER TO HEADING(H, 45).
    }

    LOCK THROTTLE TO 0.0.
    UNLOCK ALL.
}

UNTIL FALSE.
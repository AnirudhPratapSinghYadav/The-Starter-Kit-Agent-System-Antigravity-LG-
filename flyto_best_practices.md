---
name: FlyTo Implementation Guide
description: Rules for implementing cinematic camera movements in LG apps.
---

# FlyTo Best Practices

## "Zero-Gap" Rules
For high-end visualizations, avoid the "floating in space" look.
1.  **Coordinates**: Do NOT round Lat/Lon. Use full precision.
2.  **Altitude**: Use `relativeToGround` to respect terrain.

## Cinematic Angles
-   **Standard**: Tilt 45, Range 5000.
-   **Action/Close-up**: Tilt 60-75, Range 1000-1500.
-   **Overhead**: Tilt 0, Range 10000+.

## Implementation (Dart)
```dart
String flyToKML(double lat, double lon, double range, double tilt, double heading) {
  return '''
    <gx:FlyTo>
      <gx:duration>3</gx:duration>
      <gx:flyToMode>smooth</gx:flyToMode>
      <LookAt>
        <longitude>$lon</longitude>
        <latitude>$lat</latitude>
        <altitude>0</altitude>
        <heading>$heading</heading>
        <tilt>$tilt</tilt>
        <range>$range</range>
        <gx:altitudeMode>relativeToGround</gx:altitudeMode>
      </LookAt>
    </gx:FlyTo>
  ''';
}
```

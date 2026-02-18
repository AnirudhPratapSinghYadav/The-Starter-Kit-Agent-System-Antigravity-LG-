---
name: Liquid Galaxy Balloon Skill
description: Creating HTML/CSS overlays for tactical data display on slave screens.
---

# KML Balloon & Overlay Skill

## Purpose
Display rich UI (HUDs, Info Panels) on specific Liquid Galaxy screens (Slaves).

## Methods
1.  **ScreenOverlay**: Fixed 2D image/overlay on the screen. Good for Logos.
2.  **Balloon (Placemark)**: HTML content rendered in a bubble. Good for Text/Data.

## Tactical HUD Pattern
To create a "Sci-Fi" or "Tactical" look on a Slave screen:
1.  **Targeting**: Send the KML to the specific slave (e.g., `slave_2.kml`).
2.  **KML Structure**:
    ```xml
    <Placemark>
      <name>HUD</name>
      <description><![CDATA[
        <!-- HTML/CSS HERE -->
        <div style="background: black; border: 2px solid cyan; color: white; padding: 20px;">
          <h1>DATA</h1>
          <p>Value: 100%</p>
        </div>
      ]]></description>
      <gx:balloonVisibility>1</gx:balloonVisibility> <!-- Forces display -->
      <Point><coordinates>0,0,0</coordinates></Point> <!-- Hidden point -->
    </Placemark>
    ```
3.  **Positioning**: CSS absolute positioning inside the balloon can control layout, but balloons are generally centered or anchored.

## CSS Tips
-   Use `rgba(0,0,0,0.8)` for backgrounds to ensure contrast against the map.
-   Use bright borders (`cyan`, `neon-green`) for "Tactical" aesthetics.
-   Large fonts are required (reading distance is > 2 meters).

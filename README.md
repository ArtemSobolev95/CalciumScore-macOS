# CalciumScore for IsiX and Horos (macOS)

Coronary artery calcium scoring (Agatston score, volume and mass per artery, PDF report) in
**IsiX DICOM Viewer**, ported from the Horos
[CalciumScore](https://github.com/horosproject/horosplugins/tree/master/CalciumScore) plugin.

## Download

Current version: **1.0.0**. Click the package for your viewer:

| Viewer | Download | macOS | Mac |
|---|---|---|---|
| IsiX DICOM Viewer 6.0+ (GitHub build) | [**CalciumScore-IsiX-1.0.0.zip**](https://github.com/ArtemSobolev95/CalciumScore-macOS/raw/main/downloads/CalciumScore-IsiX-1.0.0.zip) | 15 or later | Apple silicon and Intel |
| Horos 4.0.1 | [**CalciumScore-Horos-1.0.0.zip**](https://github.com/ArtemSobolev95/CalciumScore-macOS/raw/main/downloads/CalciumScore-Horos-1.0.0.zip) | 11 or later | Apple silicon and Intel |

Each package works on both kinds of Mac. The App Store version of IsiX loads no plugins; use the
[GitHub build of IsiX](https://github.com/ThalesMMS/IsiX-DICOM-Viewer-macOS/releases).

### Install

1. Quit the viewer.
2. Unzip the package and double-click **Install CalciumScore.command**.
   If macOS says the developer cannot be verified: System Settings › Privacy & Security ›
   *Open Anyway*, then double-click it again.
3. Open the viewer. *Plugins › Plugins Manager* should list CalciumScore as loaded.

## Use

1. Open the non-contrast, ECG-gated cardiac CT series in a 2D viewer.
2. *Plugins › Image Filters › Calcium Scoring*, or the toolbar button (right-click the toolbar ›
   *Customize Toolbar…* › drag **Calcium Scoring** onto it).
3. Choose the artery (left main, LAD, circumflex, RCA), then click each calcified lesion of that
   artery in the viewer. The lesion is grown in 3D above the threshold and becomes an ROI named
   after the artery.
4. The table gives score, volume and mass per artery and in total. *Print* / *Save* makes the PDF.

If the series is not CT the plugin asks before opening the window.

## How it works

As in Horos, the original plugin is a stub: the scoring code lives in the viewer, and the plugin
only calls `-[ViewerController calciumScoring:]`. IsiX kept that code (rewritten in Swift:
`CalciumScoringWindowController`, `CalciumScoring.swift`) but has no menu item that opens it, so
this plugin is the way in. The port adds the checks above, a toolbar icon, and a universal
(arm64 + x86_64) build with the scripts used by the other plugins.

## Build

Needs the Xcode command line tools (`xcode-select --install`). The plugin SDK headers are in
[`third_party/`](third_party).

```sh
./build.sh install                   # IsiX build, installs into IsiX
TARGET=horos ./build.sh install      # Horos build, installs into Horos
TARGET=isix ./package.sh; TARGET=horos ./package.sh   # zips in dist/
```

Or double-click **Build IsiX version.command** / **Build Horos version.command** /
**Build release.command**.

## Threshold and method — read this

The window offers two thresholds, with the labels inherited from OsiriX/Horos:
*Multislice (Threshold: 90HU)* and *Electron Beam (Threshold: 130HU)*. The standard Agatston
threshold is **130 HU, for multi-slice CT as well**, so the plugin selects the 130 HU option the
first time it runs (despite its "Electron Beam" label). Your later choice is remembered.

The inherited code also differs from the textbook Agatston method in two details, so expect
small differences from the scanner vendor's software:

- the density weighting factor (1–4) comes from whether **more than two pixels** of the lesion
  exceed 200 / 300 / 400 HU, not from the single peak pixel;
- there is no minimum lesion area (usually 1 mm²): only what you click is counted.

Overlapping reconstructions are corrected (score × slice interval / slice thickness).

## Caveat

The score depends on slice thickness (Agatston: 3 mm), reconstruction kernel and on clicking only
coronary calcium. For research and second reading; not a certified medical device.

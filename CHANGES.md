# Changes

## 1.0.0 — first release

- Port of the Horos CalciumScore plugin to IsiX DICOM Viewer (GitHub build, macOS 15+), universal
  (Apple silicon and Intel). Horos 4 build (macOS 11+) from the same source.
- Plugins › Image Filters › Calcium Scoring and a toolbar button open the viewer's own calcium
  scoring window (Agatston score, volume, mass for LM, LAD, LCx, RCA; PDF report).
- Checks before opening: a viewer is open, the viewer has the scoring window, and the series is
  CT (other modalities ask first).
- Selects the standard 130 HU Agatston threshold the first time (the viewer defaults to 90 HU).

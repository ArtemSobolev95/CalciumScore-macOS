CalciumScore @VERSION@ — coronary artery calcium scoring
=========================================================

Opens the viewer's calcium scoring window for the current CT series: click a calcified plaque in
each coronary artery and the plugin grows the lesion above the threshold and gives the Agatston
score, volume and mass per artery and in total, with a printable / PDF report. A port of the Horos "CalciumScore" plugin.

INSTALL
  Quit the viewer, double-click "Install CalciumScore.command", open the viewer.
  If macOS says the developer cannot be verified: System Settings > Privacy & Security > Open Anyway.

USE
  1. Open the non-contrast, ECG-gated cardiac CT series (usually 3 mm) in a 2D viewer.
  2. Plugins > Image Filters > Calcium Scoring (or the toolbar button: right-click the toolbar >
     Customize Toolbar… and drag "Calcium Scoring" onto it).
  3. In the window: keep the 130 HU threshold (the standard Agatston threshold; in the window it
     is labelled "Electron Beam (Threshold: 130HU)", which the plugin selects the first time),
     choose the artery (LM, LAD, LCx, RCA), then click each calcified lesion of that artery in
     the viewer, once: the lesion is grown in 3D across the slices.
  4. The table shows score, volume and mass per artery and the total. Print or Save as PDF.

  The density factor (1-4) is taken from whether more than two pixels exceed 200/300/400 HU, not
  from the peak pixel, and there is no minimum lesion area: small differences from the scanner's
  software are expected.
  Check the result: the score depends on slice thickness, reconstruction kernel and on clicking
  only coronary calcium (not the aortic wall, valves or mitral annulus). For research and
  second-reading use; it is not a certified medical device.

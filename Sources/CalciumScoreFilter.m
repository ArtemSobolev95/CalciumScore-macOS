//
//  CalciumScoreFilter.m — plugin entry point.
//
//  Port of the Horos "CalciumScore" plugin (horosproject/horosplugins). As in Horos, the scoring
//  itself (region growing from a click in each coronary artery, Agatston score, volume, mass,
//  PDF report) is part of the viewer: IsiX keeps it in CalciumScoringWindowController, which
//  -[ViewerController calciumScoring:] opens. Nothing in the IsiX menus opens that window, so
//  this plugin is the way in. It adds checks before opening it.
//

#import "CalciumScoreFilter.h"

@implementation CalciumScoreFilter

- (void)initPlugin
{
}

static void CSAlert(NSString *title, NSString *text)
{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    alert.messageText = title;
    alert.informativeText = text;
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

- (long)filterImage:(NSString *)menuName
{
    ViewerController *viewer = viewerController;
    if (viewer == nil) {
        CSAlert(@"Calcium Scoring", @"Open the non-contrast cardiac CT series in a 2D viewer first.");
        return 0;
    }

    SEL openSelector = @selector(calciumScoring:);
    if (![viewer respondsToSelector:openSelector]) {
        CSAlert(@"Calcium Scoring is not available",
                @"This version of the viewer has no built-in calcium scoring window. "
                @"Use IsiX DICOM Viewer 6.0 or later (GitHub build).");
        return 0;
    }

    NSString *modality = [viewer modality];
    if (modality.length > 0 && ![modality isEqualToString:@"CT"]) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.alertStyle = NSAlertStyleWarning;
        alert.messageText = @"This series is not CT";
        alert.informativeText = [NSString stringWithFormat:
            @"The modality is %@. Calcium scoring uses Hounsfield units and is meant for a "
            @"non-contrast cardiac CT (usually 3 mm slices). Open it anyway?", modality];
        [alert addButtonWithTitle:@"Cancel"];
        [alert addButtonWithTitle:@"Open Anyway"];
        if ([alert runModal] != NSAlertSecondButtonReturn) return 0;
    }

    // The window's CT type is remembered in the viewer's preferences (CalciumScoreCTType):
    // 0 = "Multislice (Threshold: 90HU)", the viewer's default; 1 = "... 130HU". The standard
    // Agatston threshold is 130 HU, also for multi-slice CT, so the first time the plugin runs it
    // selects 130 HU. Whatever is chosen in the window afterwards is kept.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *doneKey = @"CalciumScorePluginSelected130HU";
    if (![defaults boolForKey:doneKey]) {
        [defaults setInteger:1 forKey:@"CalciumScoreCTType"];
        [defaults setBool:YES forKey:doneKey];
    }

    // The viewer opens the window only if it is not open already, and the window releases itself
    // when it closes.
    [viewer calciumScoring:self];
    return 0;
}

@end

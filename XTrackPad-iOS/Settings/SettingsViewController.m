//
//  SettingsViewController.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import "SettingsViewController.h"
#import "Settings.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISlider *cursorSpeedSlider;
@property (weak, nonatomic) IBOutlet UISwitch *keepAwakeSwitch;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cursorSpeedSlider.minimumValue = [Settings minCursorSpeed];
    self.cursorSpeedSlider.maximumValue = [Settings maxCursorSpeed];
    self.cursorSpeedSlider.value = [Settings cursorSpeed];

    self.keepAwakeSwitch.on = [Settings keepAwake];
}

- (IBAction)cursorSpeedChanged:(UISlider *)sender {
    [Settings setCursorSpeed:sender.value];
}
- (IBAction)keepAwakeValueChanged:(UISwitch *)sender {
    [Settings setKeepAwake:sender.isOn];
}

@end

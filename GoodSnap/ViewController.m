//
//  ViewController.m
//  GoodSnap
//
//  Created by William Zhang on 2/7/15.
//  Copyright (c) 2015 Ruying Chen. All rights reserved.
//
#import "ViewController.h"
#import "GoodSnap-Swift.h"
#import <UIKit/UIKit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIView *resultsView;
@property (weak, nonatomic) IBOutlet UILabel *barcodeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *barcodeStringLabel;
@property (weak, nonatomic) IBOutlet UILabel *noCameraLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.barcodeTypes = TFBarcodeTypeEAN8 | TFBarcodeTypeEAN13 | TFBarcodeTypeUPCA | TFBarcodeTypeUPCE | TFBarcodeTypeQRCODE;
    self.resultsView.alpha = 0.0f;
    self.overlayView.alpha = 0.0f;
    self.noCameraLabel.hidden = self.hasCamera;
    self.tabBarController.tabBar.selectedImageTintColor = [UIColor whiteColor];
    //self.noCameraLabel.hidden = 1;
    //NSLog(@"%hhd", self.noCameraLabel.hidden);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - TFBarcodeScannerViewController

- (void)barcodePreviewWillShowWithDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.overlayView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.activityIndicator stopAnimating];
    }];
}

- (void)barcodePreviewWillHideWithDuration:(CGFloat)duration
{
    
}

- (void)barcodeWasScanned:(NSSet *)barcodes
{
    [self stop];
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    TFBarcode* barcode = [barcodes anyObject];
    self.resultsView.hidden = NO;
    self.barcodeTypeLabel.text = [self stringFromBarcodeType:barcode.type];
    self.barcodeStringLabel.text = barcode.string;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.resultsView.alpha = 1.0f;
    }];
}

- (IBAction)newButtonWasTapped
{
//    [super viewDidLoad];
//    TypeSearchViewController *temp = [[TypeSearchViewController alloc] init];
//    UIAlertController *tempControl = [temp showAddGoodsDialogBar];
//    [self presentViewController:tempControl animated:true completion:nil];
//    
//    NSArray *tempArray = temp.array;
//    [self addGoods:tempArray[0] newBrand:tempArray[1] newType:tempArray[2] newBarCode: self.barcodeStringLabel.text];
//  
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"add new item"
                                          message:@"xx"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   UITextField *name = alertController.textFields[0];
                                   UITextField *brand = alertController.textFields[1];
                                   UITextField *type = alertController.textFields[2];
                                [self addGoods:name.text newBrand:brand.text newType:type.text
                                    newBarCode: self.barcodeStringLabel.text];

                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"NamePlaceholder", @"Name");
     }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"BrandPlaceholder", @"Brand");
     }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"TypePlaceholder", @"Type");
     }];
    [self presentViewController:alertController animated:YES completion:nil];
}



-(void) addGoods : (NSString *) name
         newBrand:(NSString *) brand
          newType:(NSString *) type
       newBarCode: (NSString *) code{
    [super viewDidLoad];
    TypeSearchViewController *temp = [[TypeSearchViewController alloc] init];
    [temp saveName:name brand:brand type:type barcode:code];
}

- (IBAction)scanAgainButtonWasTapped
{
    [self start];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.resultsView.alpha = 0.0f;
    }];
}


#pragma mark - Private

- (NSString *)stringFromBarcodeType:(TFBarcodeType)barcodeType
{
    static NSDictionary *typeMap;
    
    if (!typeMap) {
        typeMap = @{
                    @(TFBarcodeTypeEAN8):         @"EAN8",
                    @(TFBarcodeTypeEAN13):        @"EAN13",
                    @(TFBarcodeTypeUPCA):         @"UPCA",
                    @(TFBarcodeTypeUPCE):         @"UPCE",
                    @(TFBarcodeTypeQRCODE):       @"QRCODE",
                    @(TFBarcodeTypeCODE128):      @"CODE128",
                    @(TFBarcodeTypeCODE39):       @"CODE39",
                    @(TFBarcodeTypeCODE39Mod43):  @"CODE39Mod43",
                    @(TFBarcodeTypeCODE93):       @"CODE93",
                    @(TFBarcodeTypePDF417):       @"PDF417",
                    @(TFBarcodeTypeAztec):        @"Aztec"
                    };
    }
    
    return typeMap[@(barcodeType)];
}

@end
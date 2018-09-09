//
//  specificationVC.m
//  RealtyDaddy
//
//  Created by Nirav Zalavadia on 20/04/18.
//  Copyright © 2018 CNSoftNetIndiaPvtLTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DLRadioButton/DLRadioButton.h>

@interface specificationVC : UIViewController <UITextFieldDelegate>



//ALL MainVw
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVw;
@property (weak, nonatomic) IBOutlet UIView *unitInformationVw;
@property (weak, nonatomic) IBOutlet UIView *floorsVw;
@property (weak, nonatomic) IBOutlet UIView *statusVw;
@property (weak, nonatomic) IBOutlet UIView *yearVw;
@property (weak, nonatomic) IBOutlet UIView *furnishVw;
@property (weak, nonatomic) IBOutlet UIView *sellingVw;
@property (weak, nonatomic) IBOutlet UIView *areaVw;
@property (weak, nonatomic) IBOutlet UIView *facingDirectionVw;
@property (weak, nonatomic) IBOutlet UIView *gardenVw;
@property (weak, nonatomic) IBOutlet UIView *ownerShipVw;
@property (weak, nonatomic) IBOutlet UIView *bankVw;
@property (weak, nonatomic) IBOutlet UIView *plotAreaVw;


@property (weak, nonatomic) IBOutlet UIView *mediaVw;

//Innerview
@property (weak, nonatomic) IBOutlet UIView *totalFloorVw;
@property (weak, nonatomic) IBOutlet UIView *propertyFloorVw;
@property (weak, nonatomic) IBOutlet UIView *washRoomVw;
@property (weak, nonatomic) IBOutlet UIView *pantryVw;
@property (weak, nonatomic) IBOutlet UIView *meetingRoomVw;
@property (weak, nonatomic) IBOutlet UIView *cabinVw;
@property (weak, nonatomic) IBOutlet UIView *corerVw;

//stackViews
@property (weak, nonatomic) IBOutlet UIStackView *mainStackVw;

@property (weak, nonatomic) IBOutlet UIStackView *washRoomRowStack;
@property (weak, nonatomic) IBOutlet UIStackView *meetingRoomStack;

//Year built up/possesion

@property (weak, nonatomic) IBOutlet UILabel *yearTitleLbl;
@property (weak, nonatomic) IBOutlet UITextField *yearTxt;

@property (weak, nonatomic) IBOutlet UICollectionView *directionCollectionVw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *directionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facingDirectionViewHeightconstraint;

//controls

@property (weak, nonatomic) IBOutlet UITextField *bedTxt;
@property (weak, nonatomic) IBOutlet UITextField *bathsTxt;
@property (weak, nonatomic) IBOutlet UITextField *balconyTxt;
@property (weak, nonatomic) IBOutlet UITextField *totalFloorTxt;
@property (weak, nonatomic) IBOutlet UITextField *preferredFloorTxt;

@property (weak, nonatomic) IBOutlet DLRadioButton *readyToMoveRBtn;
@property (weak, nonatomic) IBOutlet DLRadioButton *underConstructionRBtn;

@property (weak, nonatomic) IBOutlet UITextField *builtYearTxt;


@property (weak, nonatomic) IBOutlet DLRadioButton *fullyFurnishedRBtn;
@property (weak, nonatomic) IBOutlet DLRadioButton *semiFurnishedRBtn;
@property (weak, nonatomic) IBOutlet DLRadioButton *notFurnishedRBtn;

@property (weak, nonatomic) IBOutlet UITextField *pricedBasedOnTxt;

@property (weak, nonatomic) IBOutlet UITextField *corerTxt;
@property (weak, nonatomic) IBOutlet UITextField *lakhTxt;
@property (weak, nonatomic) IBOutlet UITextField *thosandTxt;

@property (weak, nonatomic) IBOutlet DLRadioButton *hidePriceChkBtn;

@property (weak, nonatomic) IBOutlet UITextField *carpetAreaTxt;
@property (weak, nonatomic) IBOutlet UITextField *builtUpAreaTxt;
@property (weak, nonatomic) IBOutlet UITextField *superBuiltUpAreaTxt;

@property (weak, nonatomic) IBOutlet UISegmentedControl *measurementUnitSegment;

@property (weak, nonatomic) IBOutlet UISegmentedControl *gardenSegment;



@property (weak, nonatomic) IBOutlet DLRadioButton *freeHoldRBtn;
@property (weak, nonatomic) IBOutlet DLRadioButton *foreClosureRBtn;

@property (weak, nonatomic) IBOutlet UITextField *bankTxt;
@property (weak, nonatomic) IBOutlet UITextField *washTxt;
@property (weak, nonatomic) IBOutlet UITextField *pantryTxt;
@property (weak, nonatomic) IBOutlet UITextField *meetingRoomTxt;
@property (weak, nonatomic) IBOutlet UITextField *cabinTxt;

@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *yearPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerVw;
@property (weak, nonatomic) IBOutlet UIToolbar *yearToolbar;

@property (nonatomic,retain) NSIndexPath *selectedIndexPath;

- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)doneBtnAction:(id)sender;

- (IBAction)stutusChanged:(id)sender;
- (IBAction)ownershipChanged:(id)sender;
@end


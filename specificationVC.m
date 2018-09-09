//
//  specificationVC.m
//  RealtyDaddy
//
//  Created by Nirav Zalavadia on 20/04/18.
//  Copyright © 2018 CNSoftNetIndiaPvtLTD. All rights reserved.
//

#import "specificationVC.h"
#import "buttonCell.h"
#import "postPropertyFilter.h"
#import "MediaImageVc.h"
#import "postPropertyFilter.h"
#import "locationVC.h"
#import "VideoVC.h"


@interface specificationVC ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *years;
    NSMutableArray *zeroToTenArr,*zeroToNineNineArr;
    BOOL isTotalFloor,isFloor,isWash,isPantry,isMetting,isCabin,isPrice,isCorer,isLakh,isThousand;
    
    NSMutableURLRequest *request;
    NSData *videoData;
    NSDate *theDate;
    NSString *type,*subType,*purpose;
    
    BOOL isYearPicker,isDatePicker,isCorerHidden,disableOtherComponents,isBed,isBath,isBalcony,isBank;
    NSArray *crArr,*lakhsArr,*thousandArr,*directionArr,*pricedBasedOnArr,*bankArr;
     UITapGestureRecognizer *tapGesture;
    UIBarButtonItem *nextBtn;
    
     BOOL isReadyToMove,isUnderConstruction,isFullyFurnish,isSemiFurnish,isNotFurnish,isHidePrice,isCarpetArea,isBuiltUpArea,isSuperBuiltUpArea,isFreehold,isForeclosure,isGarden;
    
    
//    postPropertyFilter *objPostProperty;
    
    
    NSString *selectedBeds,*selectedBaths,*selectedBalcony,*selectedTotalFloors,*selectedFloorNo,*selectedBuiltYear,*selectedCr,*selectedLakh,*selectedThousand,*selectedCarpetArea,*selectedBuiltUp,*selectedSuperBuilt,*selectedUnit,*selectedPossessionTimeFrame,*selectedWash,*selectedPantry,*selectedCabin,*selectedMeetingRoom,*selectedFacingDirection;

}

@end

@implementation specificationVC

@synthesize selectedIndexPath;

typedef NS_ENUM(NSInteger, ErrorCodePostProperty) {
    FillUpUnitInformation = 1,
    FillUpPriceInformation = 2,
    FillUpAreaInformation = 3,
    SelectCoverPhoto = 4,
    EnterCarpetArea=6,
    EnterBuiltUpArea=7,
    EnterSuperBuiltUpArea=8,
    FloorLessTotalFloor=9
};


- (void)viewDidLoad {
    [super viewDidLoad];
////    type=@"Residential";
//    type=@"Commercial";
////    subType=@"Plot";
////    subType=@"House Villa";
//    subType=@"Office Space";
//    purpose=@"Rent";
    [self setDefaultValues];
    [self setupViews];
}

-(void)setDefaultValues
{
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [_scrollVw addGestureRecognizer:tapGesture];
    
    zeroToTenArr=[NSMutableArray new];
    zeroToNineNineArr=[NSMutableArray new];
    
    isCorerHidden=isDatePicker=disableOtherComponents=false;
    isBed=isBath=isBalcony=isTotalFloor=isFloor=isPrice=false;
    isWash=isPantry=isMetting=isCabin=false;
    isCorer=isLakh=isThousand=false;
    isBank=false;
    
//    objPostProperty=[postPropertyFilter sharedPostProperty];
    
    _pricedBasedOnTxt.text=@"Carpet Area";
    directionArr=[NSArray arrayWithObjects:@"N",@"S",@"E",@"W",@"NE",@"NW",@"SE",@"SW",nil];
    pricedBasedOnArr=[NSArray arrayWithObjects:@"Carpet Area",@"Built-Up Area",@"Super Built up Area",nil];
    bankArr =[NSArray arrayWithObjects:@"Select Bank",@"HDFC Bank",@"SBI Bank", nil];
    _corerTxt.text=@"0";
    _lakhTxt.text=@"0";
    _thosandTxt.text=@"0";
    
    NSMutableArray *tempArr=[NSMutableArray new];
    
    for (int i =0 ; i<=99; i++)
    {
       
        [zeroToNineNineArr addObject:[NSString stringWithFormat:@"%d",i]];
        [tempArr addObject:[NSString stringWithFormat:@"%d thousand.",i]];
        if(i>=0 && i<=9)
            [zeroToTenArr addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    thousandArr=[NSArray arrayWithArray:[tempArr copy]];
    
    tempArr=[NSMutableArray new];
    for (int i =0 ; i<=99; i++)
    {
        [tempArr addObject:[NSString stringWithFormat:@"%d lakh.",i]];
    }
    lakhsArr=[NSArray arrayWithArray:[tempArr copy]];
    
    tempArr=[NSMutableArray new];
    for (int i =0 ; i<=20; i++)
    {
        [tempArr addObject:[NSString stringWithFormat:@"%d cr.",i]];
    }
    crArr=[NSArray arrayWithArray:[tempArr copy]];
    
    isYearPicker=false;
    nextBtn=[[UIBarButtonItem alloc] initWithTitle:@"Next >" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnAction:)];
    self.navigationItem.rightBarButtonItem=nextBtn;
}

-(void)restoreFields
{
    if(![objPostProperty isEqual:[NSNull null]])
    {
        
        _bedTxt.text=[NSString stringWithFormat:@"%d",objPostProperty.count_bedroom];
        _bathsTxt.text=[NSString stringWithFormat:@"%d",objPostProperty.count_bathroom];
        _balconyTxt.text=[NSString stringWithFormat:@"%d",objPostProperty.count_balcony];
        _totalFloorTxt.text=[NSString stringWithFormat:@"%d",objPostProperty.totalFloors];
        _preferredFloorTxt.text=objPostProperty.floor_no;
        _yearTxt.text=objPostProperty.possession;
        _builtYearTxt.text=[NSString stringWithFormat:@"%d",objPostProperty.yearbuilt];
        
        _washTxt.text=[NSString stringWithFormat:@"%d",objPostProperty.count_washrooms];
        _pantryTxt.text=[NSString stringWithFormat:@"%d",objPostProperty.count_pantry];
        _meetingRoomTxt.text=[NSString stringWithFormat:@"%d",objPostProperty.count_meeting_rooms];
        _cabinTxt.text=[NSString stringWithFormat:@"%d",objPostProperty.count_cabins];
        
        //price
        
        _hidePriceChkBtn.selected=objPostProperty.price_on_call==true?true:false;
        _corerTxt.text=objPostProperty.corer;
        _lakhTxt.text=objPostProperty.lakh;
        _thosandTxt.text=objPostProperty.thousand;
        
        _carpetAreaTxt.text=objPostProperty.carpetArea;
        _builtUpAreaTxt.text=objPostProperty.built_up;
        _superBuiltUpAreaTxt.text=objPostProperty.super_built_up;
        
        
        
        //        _bedStpperVw.cntTxt.text=[objPostProperty.beds length]==0 ? @"0" : objPostProperty.beds;
        //        _bathsSteptterVw.cntTxt.text=[objPostProperty.baths length]==0 ? @"0" : objPostProperty.baths;
        //        _balconyStepperVw.cntTxt.text=[objPostProperty.balcony length]==0 ? @"0" : objPostProperty.balcony;
        //        _totalFloorsStepperVw.cntTxt.text=[NSString stringWithFormat:@"%d",objPostProperty.totalFloors];
        //        _floorNoStepperVw.cntTxt.text=[objPostProperty.noFloor length]==0 ? @"0" : objPostProperty.noFloor;
        //        _possessionTxt.text=objPostProperty.possesionTimeframe;
        //        _builtYearTxt.text=objPostProperty.yearBuilt;
        //
        //        _corerTxt.text=[objPostProperty.corer length]==0 ? @"0" : objPostProperty.corer;
        //        _lakhTxt.text=[objPostProperty.lakh length]==0 ? @"0" : objPostProperty.lakh;
        //        _thosandTxt.text=[objPostProperty.thousand length]==0 ? @"0" : objPostProperty.thousand;
        //        _carpetAreaTxt.text=[objPostProperty.carpetArea length]==0 ? @"0" : objPostProperty.carpetArea;
        //        _builtUpAreaTxt.text=[objPostProperty.builtUpArea length]==0 ? @"0" : objPostProperty.builtUpArea;
        //        _superBuiltUpAreaTxt.text=[objPostProperty.superBuiltUp length]==0 ? @"0" : objPostProperty.superBuiltUp;
        
        if(objPostProperty.hasGarden==true)
        {
            gardentSegment.selectedSegmentIndex=0;
        }
        else
        {
            gardentSegment.selectedSegmentIndex=1;
        }
        
        if(objPostProperty.facingDirection!=0)
        {
            NSString *title=[[obj_enum facingDirection:@"" :objPostProperty.facingDirection] objectForKey:@"facingAbbrivation"];
            for (int i=0; i<[directionArr count]; i++)
            {
                if([[directionArr objectAtIndex:i] isEqualToString:title])
                {
                    NSIndexPath *ind=[NSIndexPath indexPathForRow:(i+1) inSection:0];
                    selectedIndexPath=ind;
                }
            }
        }
        
        
        NSString *unitName=[[obj_enum areaUnit:@"" :objPostProperty.unitOfMeasurement] objectForKey:@"areaUnitStr"];
        if([unitName isEqualToString:@"SqYd"])
        {
            _measurementUnitSegment.selectedSegmentIndex=2;
        }
        else if ([unitName isEqualToString:@"SqMt"])
        {
            _measurementUnitSegment.selectedSegmentIndex=1;
        }
        else
        {
            _measurementUnitSegment.selectedSegmentIndex=0;
        }
        
        NSString *stausName=[[obj_enum propertySalesType:@"" :objPostProperty.status_id] objectForKey:@"salesTypeStr"];
        
        if([self.type isEqualToString:@"Commercial"] && [self.purpose isEqualToString:@"Sale"])
        {
            // We need below on Commercial and sale
            if([stausName isEqualToString:@"UnderConstruction"])
            {
                
                _underConstructionRBtn.selected=true;
                _underConstructionRBtn.iconColor=[UIColor blackColor];
                _underConstructionRBtn.indicatorColor=[UIColor blackColor];
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   _yearBuiltLbl.hidden=true;
                                   _builtYearTxt.hidden=true;
                                   _possessionLbl.hidden=false;
                                   _possessionTxt.hidden=false;
                               });
                
            }
            else
            {
                
                _readyToMoveRBtn.selected=true;
                _readyToMoveRBtn.iconColor=[UIColor blackColor];
                _readyToMoveRBtn.indicatorColor=[UIColor blackColor];
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   _yearBuiltLbl.hidden=false;
                                   _builtYearTxt.hidden=false;
                                   _possessionLbl.hidden=true;
                                   _possessionTxt.hidden=true;
                               });
                
            }
        }
        
        NSString *furnishStaus=[[obj_enum propertyFurnishStauts:@"" :objPostProperty.furnished_status_id] objectForKey:@"furnishStr"];
        
        
        if([furnishStaus isEqualToString:@"Semi Furnished"])
        {
            _semiFurnishedRBtn.selected=true;
            _semiFurnishedRBtn.iconColor=[UIColor blackColor];
            _semiFurnishedRBtn.indicatorColor=[UIColor blackColor];
        }
        else if([furnishStaus isEqualToString:@"Non Furnished"])
        {
            _notFurnishedRBtn.selected=true;
            _notFurnishedRBtn.iconColor=[UIColor blackColor];
            _notFurnishedRBtn.indicatorColor=[UIColor blackColor];
        }
        else
        {
            _fullyFurnishedRBtn.selected=true;
            _fullyFurnishedRBtn.iconColor=[UIColor blackColor];
            _fullyFurnishedRBtn.indicatorColor=[UIColor blackColor];
        }
        
        NSString *priceCat=[[obj_enum priceAreaCategory:@"" :objPostProperty.price_area_category] objectForKey:@"areaCategory"];
        
        if([priceCat isEqualToString:@"Super Built-up Area"])
        {
            _pricedBasedOnTxt.text=@"Super Built-up Area";
//            _superBuiltUpAreaBtn.selected=true;
//            _superBuiltUpAreaBtn.iconColor=[UIColor blackColor];
//            _superBuiltUpAreaBtn.indicatorColor=[UIColor blackColor];
        }
        else if([priceCat isEqualToString:@"Built-up Area"])
        {
            _pricedBasedOnTxt.text=@"Built-Up Area";
//            _builtUpAreaRBtn.selected=true;
//            _builtUpAreaRBtn.iconColor=[UIColor blackColor];
//            _builtUpAreaRBtn.indicatorColor=[UIColor blackColor];
        }
        else
        {
             _pricedBasedOnTxt.text=@"Carpet Area";
//            _carpetAreaRBtn.selected=true;
//            _carpetAreaRBtn.iconColor=[UIColor blackColor];
//            _carpetAreaRBtn.indicatorColor=[UIColor blackColor];
        }
        
        NSString *ownerShip=[[obj_enum propertyOwnership:@"" :objPostProperty.ownership] objectForKey:@"ownershipStr"];
        
        if([ownerShip isEqualToString:@"Foreclosure"])
        {
            _foreClosureRBtn.selected=true;
            _foreClosureRBtn.iconColor=[UIColor blackColor];
            _foreClosureRBtn.indicatorColor=[UIColor blackColor];
            _bankTxt.text=objPostProperty.bankId;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_bankVw setHidden:false];
                [_mainStackVw reloadInputViews];
            });
        
        }
        else
        {
            _freeHoldRBtn.selected=true;
            _freeHoldRBtn.iconColor=[UIColor blackColor];
            _freeHoldRBtn.indicatorColor=[UIColor blackColor];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_bankVw setHidden:true];
                [_mainStackVw reloadInputViews];
            });
        
        }
        
        /*
         if(objPostProperty.readyToMove==false && objPostProperty.underConstruction==false && objPostProperty.fullyFurnished==false && objPostProperty.semiFurnished==false && objPostProperty.norFurnished==false && objPostProperty.isCarpetArea==false && objPostProperty.builtUpArea==false && objPostProperty.isSuperBuiltUp==false &&objPostProperty.freeHold==false && objPostProperty.foreClosure==false)
         {
         _readyToMoveRBtn.selected=true;
         _readyToMoveRBtn.iconColor=[UIColor blackColor];
         _readyToMoveRBtn.indicatorColor=[UIColor blackColor];
         
         _fullyFurnishedRBtn.selected=true;
         _fullyFurnishedRBtn.iconColor=[UIColor blackColor];
         _fullyFurnishedRBtn.indicatorColor=[UIColor blackColor];
         
         _carpetAreaRBtn.selected=true;
         _carpetAreaRBtn.iconColor=[UIColor blackColor];
         _carpetAreaRBtn.indicatorColor=[UIColor blackColor];
         
         _freeHoldRBtn.selected=true;
         _freeHoldRBtn.iconColor=[UIColor blackColor];
         _freeHoldRBtn.indicatorColor=[UIColor blackColor];
         }
         else
         {
         _readyToMoveRBtn.selected=objPostProperty.readyToMove;
         _underConstructionRBtn.selected=objPostProperty.underConstruction;
         _fullyFurnishedRBtn.selected=objPostProperty.fullyFurnished;
         _semiFurnishedRBtn.selected=objPostProperty.semiFurnished;
         _notFurnishedRBtn.selected=objPostProperty.hidePrice;
         _hideListingChkBtn.selected=objPostProperty.hidePrice;
         _carpetAreaRBtn.selected=objPostProperty.isCarpetArea;
         _superBuiltUpAreaBtn.selected=objPostProperty.isSuperBuiltUp;
         _builtUpAreaRBtn.selected=objPostProperty.isBuiltUp;
         _freeHoldRBtn.selected=objPostProperty.freeHold;
         _foreClosureRBtn.selected=objPostProperty.foreClosure;
         }
         */
    }
}


-(void)nextBtnAction:(id)sender
{
    int bed=[_bedTxt.text intValue];
    int bath=[_bathsTxt.text intValue];
    int balcony=[_balconyTxt.text intValue];
    int floorNo=[_preferredFloorTxt.text intValue];
    int totalFloor=[_totalFloorTxt.text intValue];
    int cr=[_corerTxt.text intValue];
    int lakh=[_lakhTxt.text intValue];
    int thousand=[_thosandTxt.text intValue];
    int carpetArea=[_carpetAreaTxt.text intValue];
    int builtUpArea=[_builtUpAreaTxt.text intValue];
    int superBuiltUpArea=[_superBuiltUpAreaTxt.text intValue];
    
    BOOL isCoverPhoto=true;
    NSInteger specificationError=0;
    
    if([self.purpose isEqualToString:@"Sale"])
    {
        if([self.type isEqualToString:@"Residential"])
        {
            if([self.subType isEqualToString:@"Apartment"] || [self.subType isEqualToString:@"House Villa"]||[self.subType isEqualToString:@"Row House"])
            {
                //bed,bath,balcony,cr,lakh,thousand,carpetarea<builtup<superbuiltup,cover photo
                
                if(bed==0||bath==0||balcony==0)
                {
                    specificationError=(NSInteger)1;
                }
                else if(cr==0 && lakh==0 && thousand==0)
                {
                    specificationError=(NSInteger)2;
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Carpet Area"])
                {
                    if(carpetArea!=0)
                    {
                         specificationError=(NSInteger)6;
                    }
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Built-Up Area"])
                {
                    if(builtUpArea!=0)
                    {
                        specificationError=(NSInteger)7;
                    }
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Super Built up Area"])
                {
                    if(superBuiltUpArea!=0)
                    {
                         specificationError=(NSInteger)8;
                    }
                }
//                else if (_carpetAreaTxt.isSelected==true)
//                {
//                    if(builtUpArea!=0 && superBuiltUpArea!=0)
//                    {
//                        if (!((superBuiltUpArea>=builtUpArea) && (builtUpArea>=carpetArea) && (carpetArea<=superBuiltUpArea)))
//                            specificationError=(NSInteger)5;
//                    }
//                    if(builtUpArea!=0)
//                    {
//                        if(!(builtUpArea>=carpetArea))
//                            specificationError=(NSInteger)5;
//                    }
//                    if(superBuiltUpArea!=0)
//                    {
//                        if(!(superBuiltUpArea>=carpetArea))
//                            specificationError=(NSInteger)5;
//                    }
//                }
//                else if (_builtUpAreaBtn.isSelected==true)
//                {
//                    if(carpetArea!=0 && superBuiltUpArea!=0)
//                    {
//                        if (!((superBuiltUpArea>=builtUpArea) && (builtUpArea>=carpetArea) && (carpetArea<=superBuiltUpArea)))
//                            specificationError=(NSInteger)5;
//                    }
//                    if(carpetArea!=0)
//                    {
//                        if(!(builtUpArea>=carpetArea))
//                            specificationError=(NSInteger)5;
//                    }
//                    if(superBuiltUpArea!=0)
//                    {
//                        if(!(superBuiltUpArea>=builtUpArea))
//                            specificationError=(NSInteger)5;
//                    }
//                }
//                else if (_superBuiltUpAreaBtn.isSelected==true)
//                {
//                    if(carpetArea!=0 && builtUpArea!=0)
//                    {
//                        if (!((superBuiltUpArea>=builtUpArea) && (builtUpArea>=carpetArea) && (carpetArea<=superBuiltUpArea)))
//                            specificationError=(NSInteger)5;
//                    }
//                    if(carpetArea!=0)
//                    {
//                        if(!(superBuiltUpArea>=carpetArea))
//                            specificationError=(NSInteger)5;
//                    }
//                    if(builtUpArea!=0)
//                    {
//                        if(!(superBuiltUpArea>=builtUpArea))
//                            specificationError=(NSInteger)5;
//                    }
//                }
                
                else if(isCoverPhoto==false)
                {
                    specificationError=(NSInteger)4;
                }
            }
            else if([self.subType isEqualToString:@"Plot"])
            {
                //cr,lakh,thousand,carpetarea<builtup<superbuiltup,cover photo
                if(cr==0 && lakh==0 && thousand==0)
                {
                    specificationError=(NSInteger)2;
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Carpet Area"])
                {
                    if(carpetArea!=0)
                    {
                        specificationError=(NSInteger)6;
                    }
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Built-Up Area"])
                {
                    if(builtUpArea!=0)
                    {
                        specificationError=(NSInteger)7;
                    }
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Super Built up Area"])
                {
                    if(superBuiltUpArea!=0)
                    {
                        specificationError=(NSInteger)8;
                    }
                }
                
                else if(isCoverPhoto==false)
                {
                    specificationError=(NSInteger)4;
                }
            }
        }
        else
        {
            if([self.subType isEqualToString:@"Office Space"] || [self.subType isEqualToString:@"Showroom"]||[self.subType isEqualToString:@"Shop"]||[self.subType isEqualToString:@"Plot"])
            {
                //cr,lakh,thousand,carpetarea<builtup<superbuiltup,cover photo
                if(cr==0 && lakh==0 && thousand==0)
                {
                    specificationError=(NSInteger)2;
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Carpet Area"])
                {
                    if(carpetArea!=0)
                    {
                        specificationError=(NSInteger)6;
                    }
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Built-Up Area"])
                {
                    if(builtUpArea!=0)
                    {
                        specificationError=(NSInteger)7;
                    }
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Super Built up Area"])
                {
                    if(superBuiltUpArea!=0)
                    {
                        specificationError=(NSInteger)8;
                    }
                }
                
                else if(isCoverPhoto==false)
                {
                    specificationError=(NSInteger)4;
                }
            }
        }
    }
    if([self.purpose isEqualToString:@"Rent"])
    {
        if([self.type isEqualToString:@"Residential"])
        {
            if([self.subType isEqualToString:@"Apartment"] || [self.subType isEqualToString:@"House Villa"]||[self.subType isEqualToString:@"Row House"])
            {
                //bed,bath,balcony,cr,lakh,thousand,carpetarea<builtup<superbuiltup,cover photo
                if(bed==0||bath==0||balcony==0)
                {
                    specificationError=(NSInteger)1;
                }
                else if(cr==0 && lakh==0 && thousand==0)
                {
                    specificationError=(NSInteger)2;
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Carpet Area"])
                {
                    if(carpetArea!=0)
                    {
                        specificationError=(NSInteger)6;
                    }
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Built-Up Area"])
                {
                    if(builtUpArea!=0)
                    {
                        specificationError=(NSInteger)7;
                    }
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Super Built up Area"])
                {
                    if(superBuiltUpArea!=0)
                    {
                        specificationError=(NSInteger)8;
                    }
                }
                else if(isCoverPhoto==false)
                {
                    specificationError=(NSInteger)4;
                }
            }
        }
        else
        {
            if([self.subType isEqualToString:@"Office Space"] || [self.subType isEqualToString:@"Showroom"]||[self.subType isEqualToString:@"Shop"])
            {
                //cr,lakh,thousand,carpetarea<builtup<superbuiltup,cover photo
                if(cr==0 && lakh==0 && thousand==0)
                {
                    specificationError=(NSInteger)2;
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Carpet Area"])
                {
                    if(carpetArea!=0)
                    {
                        specificationError=(NSInteger)6;
                    }
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Built-Up Area"])
                {
                    if(builtUpArea!=0)
                    {
                        specificationError=(NSInteger)7;
                    }
                }
                else if ([_pricedBasedOnTxt.text isEqualToString:@"Super Built up Area"])
                {
                    if(superBuiltUpArea!=0)
                    {
                        specificationError=(NSInteger)8;
                    }
                }
                else if(isCoverPhoto==false)
                {
                    specificationError=(NSInteger)4;
                }
            }
        }
    }
    
    if(_floorNoStepperVw.isHidden==false && _totalFloorsStepperVw.isHidden==false)
    {
        if((floorNo>totalFloor))
        {
            specificationError=(NSInteger)9;
        }
    }
    
    switch (specificationError) {
        case FloorLessTotalFloor:
        {
            [obj_app showAlertController:@"Floors Information" DETAILMSG:@"Floor No. is less than or equal to Total Floor"];
            break;
        }
        case FillUpUnitInformation:
        {
            [obj_app showAlertController:@"Unit Information" DETAILMSG:@"Please Fill Up Unit Information"];
            break;
        }
        case FillUpPriceInformation:
        {
            [obj_app showAlertController:@"Price Information" DETAILMSG:@"Please Fill Up Price Information"];
            break;
        }
        case FillUpAreaInformation:
        {
            [obj_app showAlertController:@"Area Information" DETAILMSG:@"Please Fill Up Area Information"];
            break;
        }
        case SelectCoverPhoto:
        {
            [obj_app showAlertController:@"Cover Photo" DETAILMSG:@"Please select Cover photo"];
            break;
        }
        case ValidAreaInformation:
        {
            [obj_app showAlertController:@"Invalid Area information" DETAILMSG:@"Area should be carpetarea < builtup < superbuiltup"];
            break;
        }
        case EnterCarpetArea:
        {
            [obj_app showAlertController:@"FillUp Area information" DETAILMSG:@"Please enter Carpet Area"];
            break;
        }
        case EnterBuiltUpArea:
        {
            [obj_app showAlertController:@"FillUp Area information" DETAILMSG:@"Please enter Built-Up Area"];
            break;
        }
        case EnterSuperBuiltUpArea:
        {
            [obj_app showAlertController:@"FillUp Area information" DETAILMSG:@"Please enter Super Built-Up Area"];
            break;
        }
    }
    if(specificationError==0)
    {
        //perform next action
        [self hideKeyboard];
        locationVC *objLocation=[self.storyboard instantiateViewControllerWithIdentifier:@"locationVCID"];
        [self.navigationController pushViewController:objLocation animated:YES];
    }
    
}



-(int)convertPrice:(NSString *)corer LAKH:(NSString *)lakh THOUSAND:(NSString *)thousand
{
    int corerNo=[corer intValue]*10000000;
    int lakhNo=[lakh intValue]*100000;
    int thousandNo=[thousand intValue]*1000;
    return (corerNo+lakhNo+thousandNo);
}

- (void)hideKeyboard
{
    [_bedTxt resignFirstResponder];
    [_cabinTxt resignFirstResponder];
    [_bathsTxt resignFirstResponder];
    [_totalFloorTxt resignFirstResponder];
    [_preferredFloorTxt resignFirstResponder];
    [_washTxt resignFirstResponder];
    [_cabinTxt resignFirstResponder];
    [_pantryTxt resignFirstResponder];
    [_balconyTxt resignFirstResponder];
    [_meetingRoomTxt resignFirstResponder];
    
    [_yearTxt resignFirstResponder];
    [_builtYearTxt resignFirstResponder];
    [_corerTxt resignFirstResponder];
    [_lakhTxt resignFirstResponder];
    [_thosandTxt resignFirstResponder];
    [_carpetAreaTxt resignFirstResponder];
    [_builtYearTxt resignFirstResponder];
    [_builtUpAreaTxt resignFirstResponder];
    [_superBuiltUpAreaTxt resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==_carpetAreaTxt)
    {
        _carpetAreaTxt.text=@"";
    }
    if(textField==_yearTxt)
    {
        _yearTxt.text=@"";
    }
    if(textField==_builtUpAreaTxt)
    {
        _builtUpAreaTxt.text=@"";
    }
    if(textField==_superBuiltUpAreaTxt)
    {
        _superBuiltUpAreaTxt.text=@"";
    }
    if(textField==_bankTxt)
    {
        isBank=true;
        [self.view endEditing:YES];
        _yearPicker.hidden=false;
        _yearToolbar.hidden=false;
        isYearPicker=false;
    }
    
    if(textField==_bedTxt || textField==_bathsTxt || textField==_balconyTxt || textField==_washTxt || textField==_pantryTxt ||textField ==_meetingRoomTxt || textField==_cabinTxt)
    {
        isBed=(textField==_bedTxt)?true:false;
        isBath=(textField==_bathsTxt)?true:false;
        isBalcony=(textField==_balconyTxt)?true:false;
        
        isWash=(textField==_washTxt)?true:false;
        isPantry=(textField==_pantryTxt)?true:false;
        isMetting=(textField==_meetingRoomTxt)?true:false;
        isCabin=(textField==_cabinTxt)?true:false;
    
        [self.view endEditing:YES];
        _yearPicker.hidden=false;
        _yearToolbar.hidden=false;
        isYearPicker=false;
    }
    if(textField==_totalFloorTxt || textField==_preferredFloorTxt)
    {
        isTotalFloor=(textField==_totalFloorTxt)?true:false;
        isFloor=(textField==_preferredFloorTxt)?true:false;
        
        [self.view endEditing:YES];
        _yearPicker.hidden=false;
        _yearToolbar.hidden=false;
        isYearPicker=false;
    }
    if(textField==_corerTxt||textField==_lakhTxt||textField==_thosandTxt||textField==_pricedBasedOnTxt)
    {
        isCorer=(textField==_corerTxt)?true:false;
        isLakh=(textField==_lakhTxt)?true:false;
        isThousand=(textField==_thosandTxt)?true:false;
        isPrice=(textField==_pricedBasedOnTxt)?true:false;
        
        [self.view endEditing:YES];
        _yearPicker.hidden=false;
        _yearToolbar.hidden=false;
        isYearPicker=false;
    }
    
    if(textField==_yearTxt && ([_yearTitleLbl.text isEqualToString:@"Year Builtup"]))
    {
        [self.view endEditing:YES];
        _yearPicker.hidden=false;
        _yearToolbar.hidden=false;
        isYearPicker=true;
    }
    else if(textField==_yearTxt && ([_yearTitleLbl.text isEqualToString:@"Possesion Timeframe"]))
    {
        [self.view endEditing:YES];
        _yearToolbar.hidden=false;
        _datePickerVw.hidden=false;
        isDatePicker=true;
    }
    
    [_yearPicker reloadAllComponents];
    
}

#pragma mark - UIPicker Mehtod

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView {
    if(isYearPicker==true)
        return 1;
    else if(isCorer||isThousand||isLakh)
        return 3;
    else
        return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    if(isYearPicker==true)
    {
        if([years count]==0)
        {
            [self refillYears];
            return [years count];
        }
        else
        {
            return [years count];
        }
    }
    else{
        if(isBed||isBath||isBalcony||isWash||isPantry||isMetting||isCabin)
        {
            return [zeroToTenArr count];
        }
        else if(isBank)
        {
            return [bankArr count];
        }
        else if(isTotalFloor||isFloor)
        {
            return [zeroToNineNineArr count];
        }
        else if (isPrice)
        {
            return [pricedBasedOnArr count];
        }
        else if(isCorer||isLakh||isThousand)
        {
            if(isCorerHidden==false)
            {
                if(component==0)
                    return [crArr count];
                if(component==1)
                    return [lakhsArr count];
                if(component==2)
                    return [thousandArr count];
            }
            else
            {
                if(component==0)
                    return [lakhsArr count];
                if(component==1)
                    return [thousandArr count];
            }
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  
    if(isYearPicker==true)
        return [years objectAtIndex:row];
    else if(isBed||isBath||isBalcony||isWash||isPantry||isMetting||isCabin)
    {
        return [zeroToTenArr objectAtIndex:row];
    }
    else if(isTotalFloor||isFloor)
    {
        return [zeroToNineNineArr objectAtIndex:row];
    }
    else if(isPrice==true)
    {
        return [pricedBasedOnArr objectAtIndex:row];
    }
    else if(isBank==true)
    {
        return [bankArr objectAtIndex:row];
    }
    else if(isCorer||isLakh||isThousand)
    {
        if(isCorerHidden==false)
        {
                if(component==0)
                    return [crArr objectAtIndex:row];
                if(component==1)
                    return [lakhsArr objectAtIndex:row];
                if(component==2)
                    return [thousandArr objectAtIndex:row];
        }
        else
        {
            if(component==0)
                return [lakhsArr objectAtIndex:row];
            if(component==1)
                return [thousandArr objectAtIndex:row];
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(isYearPicker==true)
    {
        _yearTxt.text=[NSString stringWithFormat:@"%@",[years objectAtIndex:[pickerView selectedRowInComponent:0]]];
        selectedBuiltYear=_builtYearTxt.text;
    }
    else if(isBath==true)
    {
        _bathsTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
    }
    else if(isBed==true)
    {
        _bedTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
    }
    else if(isBalcony==true)
    {
        _balconyTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
    }
    else if(isWash==true)
    {
        _washTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
    }
    else if(isPantry==true)
    {
        _pantryTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
    }
    else if(isMetting==true)
    {
        _meetingRoomTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
    }
    else if(isCabin==true)
    {
        _cabinTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
    }
    else if(isTotalFloor==true)
    {
        _totalFloorTxt.text=[NSString stringWithFormat:@"%@",[zeroToNineNineArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
    }
    else if (isFloor==true)
    {
        _preferredFloorTxt.text=[NSString stringWithFormat:@"%@",[zeroToNineNineArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
    }
    else if(isPrice==true)
    {
        _pricedBasedOnTxt.text=[NSString stringWithFormat:@"%@",[pricedBasedOnArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
    }
    else if(isBank==true)
    {
        _bankTxt.text=[NSString stringWithFormat:@"%@",[bankArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
    }
    else if(isLakh||isCorer||isThousand)
    {
        if(isCorerHidden==false)
        {
            //            BOOL disableOtherComponents=false;
            if(component==0 && row==([crArr count]-1))
            {
                //                if(row==([crArr count]-1))
                //                {
                
                disableOtherComponents=true;
                [pickerView selectRow:0 inComponent:1 animated:YES];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                
                _lakhTxt.text=@"0";
                _thosandTxt.text=@"0";
                _lakhTxt.enabled=false;
                _thosandTxt.enabled=false;
                
            }
            else if(component==0 && row!=([crArr count]-1))
            {
                disableOtherComponents=false;
            }
            if((component==1 || component==2) && disableOtherComponents==true )
            {
                [pickerView selectRow:0 inComponent:1 animated:YES];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                
                _lakhTxt.text=@"0";
                _thosandTxt.text=@"0";
                _lakhTxt.enabled=false;
                _thosandTxt.enabled=false;
            }
            else
            {
                if(component==1)
                {
                    NSString *str=[NSString stringWithFormat:@"%@",[lakhsArr objectAtIndex:[pickerView selectedRowInComponent:1]]];
                    NSArray *arr=[str componentsSeparatedByString:@" "];
                    _lakhTxt.text=[arr objectAtIndex:0];
                }
                if(component==2)
                {
                    NSString *str=[NSString stringWithFormat:@"%@",[thousandArr objectAtIndex:[pickerView selectedRowInComponent:2]]];
                    NSArray *arr=[str componentsSeparatedByString:@" "];
                    _thosandTxt.text=[arr objectAtIndex:0];
                }
            }
            
            NSString *str=[NSString stringWithFormat:@"%@",[crArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
            NSArray *arr=[str componentsSeparatedByString:@" "];
            _corerTxt.text=[arr objectAtIndex:0];
        }
        else
        {
            if(component==0)
            {
                NSString *str=[NSString stringWithFormat:@"%@",[lakhsArr objectAtIndex:[pickerView selectedRowInComponent:0]]];
                NSArray *arr=[str componentsSeparatedByString:@" "];
                _lakhTxt.text=[arr objectAtIndex:0];
                
            }
            if(component==1)
            {
                NSString *str=[NSString stringWithFormat:@"%@",[thousandArr objectAtIndex:[pickerView selectedRowInComponent:1]]];
                NSArray *arr=[str componentsSeparatedByString:@" "];
                _thosandTxt.text=[arr objectAtIndex:0];
            }
        }
        
    }
}

- (IBAction)doneBtnAction:(id)sender
{
    if(isYearPicker==true)
    {
        //built up
        _yearTxt.text=[NSString stringWithFormat:@"%@",[years objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
    }
    else if(isDatePicker==true)
    {
        //posession
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateStyle:NSDateFormatterMediumStyle];
        _yearTxt.text=[format stringFromDate:_datePickerVw.date];
        _datePickerVw.hidden=true;
        isDatePicker=false;
    }
    else
    {
        if(isPrice==true)
        {
            _pricedBasedOnTxt.text=[NSString stringWithFormat:@"%@",[pricedBasedOnArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
            isPrice=false;
        }
        else if(isBank==true)
        {
            _bankTxt.text=[NSString stringWithFormat:@"%@",[bankArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
            isPrice=false;
        }
        else if (isCorer||isLakh||isThousand)
        {
            if(isCorerHidden==false)
            {
                NSString *str=[NSString stringWithFormat:@"%@",[crArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
                NSArray *arr=[str componentsSeparatedByString:@" "];
                _corerTxt.text=[arr objectAtIndex:0];
                
                str=[NSString stringWithFormat:@"%@",[lakhsArr objectAtIndex:[_yearPicker selectedRowInComponent:1]]];
                arr=[str componentsSeparatedByString:@" "];
                _lakhTxt.text=[arr objectAtIndex:0];
                
                str=[NSString stringWithFormat:@"%@",[thousandArr objectAtIndex:[_yearPicker selectedRowInComponent:2]]];
                arr=[str componentsSeparatedByString:@" "];
                _thosandTxt.text=[arr objectAtIndex:0];
                isCorer=isLakh=isThousand=false;
            }
            else
            {
                
                NSString *str=[NSString stringWithFormat:@"%@",[lakhsArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
                NSArray *arr=[str componentsSeparatedByString:@" "];
                _lakhTxt.text=[arr objectAtIndex:0];
                
                str=[NSString stringWithFormat:@"%@",[thousandArr objectAtIndex:[_yearPicker selectedRowInComponent:1]]];
                arr=[str componentsSeparatedByString:@" "];
                _thosandTxt.text=[arr objectAtIndex:0];
                isLakh=isThousand=false;
            }
        }
        else
        {
            if(isBath==true)
            {
                _bathsTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
                isBath=false;
            }
            else if(isBed==true)
            {
                _bedTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
                isBed=false;
            }
            else if(isBalcony==true)
            {
                _balconyTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
                isBalcony=false;
            }
            else if(isWash==true)
            {
                _washTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
                isWash=false;
            }
            else if(isPantry==true)
            {
                _pantryTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
                isPantry=false;
            }
            else if(isMetting==true)
            {
                _meetingRoomTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
                isMetting=false;
            }
            else if(isCabin==true)
            {
                _cabinTxt.text=[NSString stringWithFormat:@"%@",[zeroToTenArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
                isCabin=false;
            }
            else if(isTotalFloor==true)
            {
                _totalFloorTxt.text=[NSString stringWithFormat:@"%@",[zeroToNineNineArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
                isTotalFloor=false;
            }
            else if (isFloor==true)
            {
                _preferredFloorTxt.text=[NSString stringWithFormat:@"%@",[zeroToNineNineArr objectAtIndex:[_yearPicker selectedRowInComponent:0]]];
                isFloor=false;
            }
        }
    }
    _yearPicker.hidden=true;
    _yearToolbar.hidden=true;
    
}

- (IBAction)stutusChanged:(id)sender {
    if(_readyToMoveRBtn.selected)
    {
        _yearTitleLbl.text=@"Year Built";
    }
    else
    {
        _yearTitleLbl.text=@"Possesion Timeframe";
    }
}

- (IBAction)ownershipChanged:(id)sender {
    if(_freeHoldRBtn.selected)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_bankVw setHidden:true];
            [_mainStackVw reloadInputViews];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_bankVw setHidden:false];
            [_mainStackVw reloadInputViews];
        });
    }
}

- (IBAction)cancelBtnAction:(id)sender
{
    _yearPicker.hidden=true;
    _yearToolbar.hidden=true;
    _datePickerVw.hidden=true;
    
    
    isCorerHidden=isDatePicker=disableOtherComponents=false;
    isBed=isBath=isBalcony=isTotalFloor=isFloor=isPrice=false;
    isWash=isPantry=isMetting=isCabin=false;
    isCorer=isLakh=isThousand=false;
    isBank=false;
    
}

-(void)refillYears
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int currentYear  = [[formatter stringFromDate:[NSDate date]] intValue];
    
    years = [[NSMutableArray alloc] init];
    for (int i=currentYear; i>=1960; i--) {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
}




-(void)setupViews
{
    _hidePriceChkBtn.multipleSelectionEnabled=true;
    
        if([type isEqualToString:@"Residential"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [_gardenVw removeFromSuperview];
            [_mainStackVw removeArrangedSubview:_gardenVw];
            
            [_plotAreaVw removeFromSuperview];

            [_mainStackVw removeArrangedSubview:_plotAreaVw];
            
            if([subType isEqualToString:@"House Villa"]||[subType isEqualToString:@"Row House"])
            {
                [_propertyFloorVw removeFromSuperview];
                [_mainStackVw removeArrangedSubview:_propertyFloorVw];
            }
            if([subType isEqualToString:@"Plot"])
            {
                [_unitInformationVw removeFromSuperview];
                [_floorsVw removeFromSuperview];
                [_statusVw removeFromSuperview];
                [_furnishVw removeFromSuperview];
                
                [_mainStackVw removeArrangedSubview:_unitInformationVw];
                [_mainStackVw removeArrangedSubview:_floorsVw];
                [_mainStackVw removeArrangedSubview:_statusVw];
                [_mainStackVw removeArrangedSubview:_furnishVw];
                
                _yearTitleLbl.text=@"Possesion Timeframe";
                //open DatePicker
            }
        
        });
       
    }
    if([type isEqualToString:@"Commercial"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_unitInformationVw removeFromSuperview];
            [_mainStackVw removeArrangedSubview:_unitInformationVw];
        
        
            if([subType isEqualToString:@"Showroom"]||[subType isEqualToString:@"Shops"])
            {
     
                [_gardenVw removeFromSuperview];
                [_mainStackVw removeArrangedSubview:_gardenVw];
           
            }
            if([subType isEqualToString:@"Shops"])
            {
    
                [_pantryVw removeFromSuperview];
                [_mainStackVw removeArrangedSubview:_pantryVw];
                [_meetingRoomStack removeFromSuperview];
                [_mainStackVw removeArrangedSubview:_meetingRoomStack];
       
            }
            if([subType isEqualToString:@"Plot"])
            {
            
                [_unitInformationVw removeFromSuperview];
                [_floorsVw removeFromSuperview];
                [_statusVw removeFromSuperview];
                [_furnishVw removeFromSuperview];
                
                [_mainStackVw removeArrangedSubview:_unitInformationVw];
                [_mainStackVw removeArrangedSubview:_floorsVw];
                [_mainStackVw removeArrangedSubview:_statusVw];
                [_mainStackVw removeArrangedSubview:_furnishVw];
                
                _yearTitleLbl.text=@"Possesion Timeframe";
                //open DatePicker
            
            }
        
        });
    }
    if([purpose isEqualToString:@"Rent"])
    {
        [_corerVw removeFromSuperview];
        [_mainStackVw removeArrangedSubview:_corerVw];
        [_statusVw removeFromSuperview];
        [_mainStackVw removeArrangedSubview:_statusVw];
        [_gardenVw removeFromSuperview];
        [_mainStackVw removeArrangedSubview:_gardenVw];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _freeHoldRBtn.selected=true;
        _readyToMoveRBtn.selected=true;
        _fullyFurnishedRBtn.selected=true;
        
        [_bankVw setHidden:true];
        [_mainStackVw reloadInputViews];
    });
    
    [self restoreFields];

}

#pragma mark - pickerview

#pragma mark - collectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [directionArr count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    buttonCell *cell=(buttonCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"buttonCellID" forIndexPath:indexPath];
    
    cell.btn.backgroundColor=[UIColor whiteColor];
    cell.contentView.layer.borderColor=[UIColor blackColor].CGColor;
    cell.contentView.layer.borderWidth=1.0;
    cell.contentView.layer.cornerRadius=2.0;
    [cell.layer setMasksToBounds:YES];
    [cell.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cell.btn setTitle:[NSString stringWithFormat:@"%@",[directionArr objectAtIndex:indexPath.item]] forState:UIControlStateNormal];
    
    if(selectedIndexPath.row!=0)
    {
        if((selectedIndexPath.row-1)==indexPath.row)
        {
            [cell.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.btn.backgroundColor=[UIColor blueColor];
        }
    }
    _directionHeightConstraint.constant=_directionCollectionVw.contentSize.height;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    buttonCell *selectedcell=(buttonCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self maintainSelectionPropertyType:indexPath PropertyCell:selectedcell];
}

-(void)maintainSelectionPropertyType:(NSIndexPath *)cellIndexPath PropertyCell:(UICollectionViewCell *)cell
{
    buttonCell *selectedCell=(buttonCell *)cell;
    [selectedCell.btn setTitle:[NSString stringWithFormat:@"%@",[directionArr objectAtIndex:cellIndexPath.row]] forState:UIControlStateNormal];
    
    selectedCell.btn.backgroundColor=[UIColor blueColor];
    [selectedCell.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSIndexPath *modifyIndPath=[NSIndexPath indexPathForRow:(cellIndexPath.row+1) inSection:cellIndexPath.section];
    selectedIndexPath=modifyIndPath;
    
    [_directionCollectionVw reloadData];
    //    [_directionCollectionVw reloadItemsAtIndexPaths:[NSArray arrayWithObjects:cellIndexPath, nil]];
}

#pragma mark view will disappear

-(void)viewWillDisappear:(BOOL)animated
{
//    selectedBeds=_bedStpperVw.cntTxt.text;
//    selectedBaths=_bathsSteptterVw.cntTxt.text;
//    selectedBalcony=_balconyStepperVw.cntTxt.text;
//    selectedTotalFloors=_totalFloorsStepperVw.cntTxt.text;
//    selectedFloorNo=_floorNoStepperVw.cntTxt.text;
    selectedBuiltYear=_builtUpAreaTxt.text;
    
    if(isCorerHidden==false)
        selectedCr=_corerTxt.text;
    else
        selectedCr=0;
    
    if([_yearTitleLbl.text isEqualToString:@"Year Built"])
    {
        selectedPossessionTimeFrame=@"";
    }
    else
    {
        selectedPossessionTimeFrame=_yearTxt.text;
    }
    
    selectedLakh=_lakhTxt.text;
    selectedThousand=_thosandTxt.text;
    selectedCarpetArea=_carpetAreaTxt.text;
    selectedBuiltUp=_builtUpAreaTxt.text;
    selectedSuperBuilt=_superBuiltUpAreaTxt.text;
    selectedUnit=[_measurementUnitSegment titleForSegmentAtIndex:_measurementUnitSegment.selectedSegmentIndex];
    
    selectedWash=_washTxt.text;
    selectedPantry=_pantryTxt.text;
    selectedCabin=_cabinTxt.text;
    selectedMeetingRoom=_meetingRoomTxt.text;
    int directionId=0;
    if(selectedIndexPath!=nil)
    {
        NSString *title=[directionArr objectAtIndex:(selectedIndexPath.row-1)];
        directionId=[[[obj_enum facingDirection:title :999] objectForKey:@"facingDirectionId"] intValue];
    }
    
    isReadyToMove=_readyToMoveRBtn.isSelected;
    isUnderConstruction=_underConstructionRBtn.isSelected;
    isFullyFurnish=_fullyFurnishedRBtn.isSelected;
    isSemiFurnish=_semiFurnishedRBtn.isSelected;
    isNotFurnish=_notFurnishedRBtn.isSelected;
    isHidePrice=_hidePriceChkBtn.isSelected;
    isCarpetArea=_carpetAreaTxt.isSelected;
    isBuiltUpArea=_builtUpAreaTxt.isSelected;
    isSuperBuiltUpArea=_superBuiltUpAreaTxt.isSelected;
    isFreehold=_freeHoldRBtn.isSelected;
    isForeclosure=_foreClosureRBtn.isSelected;
    
    if(isReadyToMove==true)
    {
        selectedPossessionTimeFrame=@"";
        selectedBuiltYear=_builtYearTxt.text;
    }
    else
    {
        selectedPossessionTimeFrame=_yearTxt.text;
        selectedBuiltYear=@"";
    }
    
    if(_gardenSegment.selectedSegmentIndex == 0)
        isGarden=true;
    else
        isGarden=false;
    
    int price=[self convertPrice:_corerTxt.text LAKH:_lakhTxt.text THOUSAND:_thosandTxt.text];
    
    int priceCat;
    if([_pricedBasedOnTxt.text isEqualToString:@"Carpet Area"])
    {
        priceCat=[[[obj_enum priceAreaCategory:@"Carpet Area" :999] objectForKey:@"categoryId"] intValue] ;
    }
    else if ([_pricedBasedOnTxt.text isEqualToString:@"Built-Up Area"])
    {
        priceCat=[[[obj_enum priceAreaCategory:@"Built-up Area" :999] objectForKey:@"categoryId"] intValue];
    }
    else
    {
        priceCat=[[[obj_enum priceAreaCategory:@"Super Built-up Are" :999] objectForKey:@"categoryId"] intValue];
    }
    NSString *unitName;
    
    if([_measurementUnitSegment selectedSegmentIndex]==0)
    {
        unitName=@"SqFt";
    }
    else if([_measurementUnitSegment selectedSegmentIndex]==1)
    {
        unitName=@"SqMt";
    }
    else
    {
        unitName=@"SqYd";
    }
    int measurementUnit=[[[obj_enum areaUnit:unitName :999] objectForKey:@"areaUnitId"] intValue];
    
    int statusId;
    if(_readyToMoveRBtn.isSelected==true)
    {
        statusId=[[[obj_enum propertySalesType:_readyToMoveRBtn.titleLabel.text :999] objectForKey:@"salesTypeId"] intValue];
    }
    else
    {
        statusId=[[[obj_enum propertySalesType:_underConstructionRBtn.titleLabel.text :999] objectForKey:@"salesTypeId"] intValue];
    }
    
    int furnishStatusId;
    if(_fullyFurnishedRBtn.isSelected==true)
    {
        furnishStatusId=[[[obj_enum propertyFurnishStauts:_fullyFurnishedRBtn.titleLabel.text :999] objectForKey:@"furnishId"] intValue];
    }
    else if (_semiFurnishedRBtn.isSelected==true)
    {
        furnishStatusId=[[[obj_enum propertyFurnishStauts:_semiFurnishedRBtn.titleLabel.text :999] objectForKey:@"furnishId"] intValue];
    }
    else
    {
        furnishStatusId=[[[obj_enum propertyFurnishStauts:_notFurnishedRBtn.titleLabel.text :999] objectForKey:@"furnishId"] intValue];
    }
    
    int ownerShip;
    if(_freeHoldRBtn.isSelected==true)
    {
        ownerShip=[[[obj_enum propertyOwnership:_freeHoldRBtn.titleLabel.text :999] objectForKey:@"ownershipId"] intValue];
    }
    else
    {
        ownerShip=[[[obj_enum propertyOwnership:_foreClosureRBtn.titleLabel.text :999] objectForKey:@"ownershipId"] intValue];
    }
    
    bool hasGarden;
    if(gardentSegment.selectedSegmentIndex==0)
    {
        hasGarden=true;
    }
    else
    {
        hasGarden=false;
    }
    
    objPostProperty=[objPostProperty initWithSpecification:[_bedTxt.text intValue] BATHS:[_bathsTxt.text intValue] BALCONY:[_balconyTxt.text intValue] TOTALFLOOR:[_totalFloorTxt.text intValue] NOFLOOR:_preferredFloorTxt.text YEAR:[_yearTxt.text intValue] PRICE:price CORER:_corerTxt.text LAKH:_lakhTxt.text THOSAND:_thosandTxt.text PRICE_CATEGORY:priceCat ISCARPET:nil ISBUILTUP:nil ISSUPERBUILTUP:nil CARPET:_carpetAreaTxt.text BUILTUP:_builtUpAreaTxt.text SUPER:_superBuiltUpAreaTxt.text MEASUREMENTUNIT:measurementUnit UNIT:nil TIMEFRAME:_possessionTxt.text WASH:[_washroomStepperVw.cntTxt.text intValue] PANTRY:[_pantryTxt.text intValue] MEETINGROOM:[_meetingRoomTxt.text intValue] CABIN:[_cabinTxt.text intValue] STATUSID:statusId ISREADY:nil UNDERCONSTRUCTION:nil HIDEPRICE:_hideListingChkBtn.isSelected FURNISHEDSTATUSID:furnishStatusId FULLY:nil SEMI:nil NONFURNISHED:nil OWNERSHIP:ownerShip FREEHOLD:nil FORECLOSURE:nil GARDEN:hasGarden DIRECTION:directionId];
    
    /*
     count_bedroom,count_bathroom,count_balcony,
     totalFloors,
     count_cabins,
     count_garden,
     count_meeting_rooms,
     count_pantry,
     count_parking,
     count_rooms,
     count_washrooms,
     status_id,
     yearbuilt,
     furnished_status_id,
     price,
     price_area_category,
     unitOfMeasurement,
     facingDirection,
     ownership
     
     BOOL price_on_call;
     NSString *floor_no,*carpetArea,*built_up,*super_built_up;
     */
    
    //    objPostProperty=[objPostProperty initWithSpecification:selectedBeds BATHS:selectedBaths BALCONY:selectedBalcony TOTALFLOOR:[selectedTotalFloors intValue] NOFLOOR:selectedFloorNo YEAR:selectedBuiltYear CORER:selectedCr LAKH:selectedLakh THOSAND:selectedThousand ISCARPET:isCarpetArea ISBUILTUP:isBuiltUpArea ISSUPERBUILTUP:isSuperBuiltUpArea CARPET:selectedCarpetArea BUILTUP:selectedBuiltYear SUPER:selectedSuperBuilt UNIT:selectedUnit TIMEFRAME:selectedPossessionTimeFrame WASH:selectedWash PANTRY:selectedPantry MEETINGROOM:selectedMeetingRoom CABIN:selectedCabin ISREADY:isReadyToMove UNDERCONSTRUCTION:isUnderConstruction HIDEPRICE:isHidePrice FULLY:isFullyFurnish SEMI:isSemiFurnish NONFURNISHED:isNotFurnish FREEHOLD:isFreehold FORECLOSURE:isForeclosure GARDEN:isGarden DIRECTION:directionId];
    
}

- (IBAction)mediaPhotoClicked:(id)sender
{
    UIStoryboard *st=[UIStoryboard storyboardWithName:@"PostProperty" bundle:nil];
    objMediaVC=[st instantiateViewControllerWithIdentifier:@"MediaImageVCID"];
    [self.navigationController pushViewController:objMediaVC animated:YES];
}

- (IBAction)mediaVideoClicked:(id)sender
{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"UploadVideoStory" bundle:[NSBundle mainBundle]];
    VideoVC *objVideo=[story instantiateViewControllerWithIdentifier:@"UploadVideoVC"];
    
    //please check below url
    //    objVideo.videoUrlStr=objPropertyModel.video_media;
    
    [self.navigationController pushViewController:objVideo animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

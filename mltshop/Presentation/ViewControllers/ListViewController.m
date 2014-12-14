//
//  ListViewController.m
//  merchant
//
//  Created by mactive.meng on 13/6/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "ListViewController.h"
#import "AppRequestManager.h"
#import "SGActionView.h"
#import "ColorNavigationController.h"

@interface ListViewController ()<UITableViewDataSource, UITableViewDelegate, PullListViewDelegate, PassValueDelegate>

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commonListDelegate = self;
    self.dataSourceType = ListDataSourceTwoInLine;

    [self initDataSource];
    
}

- (void)initDataSource
{
    [super initDataSource];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////
#pragma mark - Network Actions
////////////////////////////////////////////////////////////

/**
 *  初始化文章 two goods one line
 */
- (void)setupDataSource {
    
    self.start = 0;
    
    [[AppRequestManager sharedManager]searchWithKeywords:self.search.keywords
                                                  cateId:self.search.catId
                                                 brandId:self.search.brandId
                                                    page:self.start
                                                    size:20
                                                andBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            NSMutableArray *goodsArray = [[NSMutableArray alloc]init];
            double countDouble = ceil([responseObject count]/2);
            NSUInteger count = [[NSNumber numberWithDouble:countDouble] integerValue];
            for (int i = 0 ; i < count; i++) {
                NSDictionary *oneDict = @{@"left":[[GoodsModel alloc]initWithDict:responseObject[i]],
                                          @"right":[[GoodsModel alloc]initWithDict:responseObject[i+1]]
                                          };
                [goodsArray addObject:oneDict];
            }
            NSLog(@"Online setupDataSource ======== ");
            [self showSetupDataSource:goodsArray andError:nil];
            self.start = self.start + 1;
            NSLog(@"start %ld",(long)self.start);
        }
        if (error != nil) {
            [DataTrans showWariningTitle:T(@"获取商品列表有误") andCheatsheet:ICON_TIMES andDuration:1.5f];
        }

    }];
}

/**
 *  one goods one line
 */
//- (void)setupDataSource {
//    
//    self.start = 0;
//    
//    [[AppRequestManager sharedManager]searchWithKeywords:self.search.keywords
//                                                  cateId:self.search.catId
//                                                 brandId:self.search.brandId
//                                                    page:self.start
//                                                    size:20
//                                                andBlock:^(id responseObject, NSError *error) {
//                                                    if (responseObject != nil) {
//                                                        // 集中处理所有的数据
//                                                        NSMutableArray *goodsArray = [[NSMutableArray alloc]init];
//                                                        
//                                                        for (id jsonData in responseObject) {
//                                                            GoodsModel *cellData = [[GoodsModel alloc]initWithDict:jsonData];
//                                                            //                Vehicle * cellData = [DataTrans vehilceFromDict:jsonData];
//                                                            [goodsArray addObject:cellData];
//                                                        }
//                                                        NSLog(@"Online setupDataSource ======== ");
//                                                        [self showSetupDataSource:goodsArray andError:nil];
//                                                        self.start = self.start + 1;
//                                                        NSLog(@"start %d",self.start);
//                                                    }
//                                                    if (error != nil) {
//                                                        [DataTrans showWariningTitle:T(@"获取商品列表有误") andCheatsheet:ICON_TIMES andDuration:1.5f];
//                                                    }
//                                                    
//                                                }];
//}

/**
 *  推荐新的文章
 */
- (void)recomendNewItems
{
    [self setupDataSource];
}


/**
 *  推荐旧的文章
 */
- (void)recomendOldItems
{
    NSLog(@"start %d",self.start);
}


- (void)passSignalValue:(NSString *)value andData:(id)data
{
    GoodsModel *theOne = data;
    
    NSLog(@"%@", theOne);
    if ([value isEqualToString:SIGNAL_TAP_VEHICLE]) {
//        VehicleDetailViewController *vc = [[VehicleDetailViewController alloc]initWithNibName:nil bundle:nil];
//        vc.passDelegate = self;
//        [vc setVehicleData:data];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
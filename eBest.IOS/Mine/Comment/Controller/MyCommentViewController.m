//
//  MyCommentViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/8/17.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MyCommetCell.h"
#import "MyCommentModel.h"
@interface MyCommentViewController ()<UITableViewDelegate,UITableViewDataSource,RatingBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIImagePickerController *_pickerController;
    NSInteger sheetIndex;
    UIImage *image;
    UIImage *photoImage;
}
@property (nonatomic,strong) UITableView * tv;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableArray * imageArr;
@property (nonatomic,strong) NSMutableArray * imageStrArr;
@property (nonatomic,strong) MyCommentModel * comModel;
@end

@implementation MyCommentViewController

-(void)viewWillAppear:(BOOL)animated{

    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createTV];
    [self crataCommitBtn];
    [self loadData];
    //选择图片观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectPhoto) name:@"DidPhoto" object:nil];
    //评价星级观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(starOb:) name:@"starValue" object:nil];
    //原图数组与图片字符数组
    _imageArr = [NSMutableArray array];
    _imageStrArr = [NSMutableArray array];
}
-(void)starOb:(NSNotification *)text{

    NSInteger i = [text.userInfo[@"index"] integerValue];
    MyCommentModel * model = _dataArr[i];
    [model setValue:text.userInfo[@"description_evaluate"] forKey:@"description_evaluate"];
    
}
-(void)crataCommitBtn{
    
    UIButton * buyButton = [FactoryUI createButtonWithFrame:CGRectMake(0, SH-112, SW, 48) title:@"提交评价" titleColor:RGB(255, 255, 255, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(submitComment)];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    buyButton.backgroundColor = RGB(32, 179, 169, 1);
    [self.view addSubview:buyButton];

}

//提交评价
-(void)submitComment{
    
    NSDictionary * ditt = @{
                            @"ges":[self createArr],
                            @"of_id":_orderId,
                            @"ship_evaluate":_wuliuScore,
                            @"service_evaluate":_serviceScore,
                            };
    //上传数据
    [RequestTools posJsonWithURL:@"/order_evaluation_save.mob" params:ditt success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict[@"return_info"][@"message"]);
    } failure:^(NSError *error) {

    }];

}

//创建评价数组
-(NSMutableArray *)createArr{
    
    NSMutableArray * arr = [NSMutableArray array];
    for ( int i=0; i<_dataArr.count; i++) {
        MyCommentModel * model = _dataArr[i];
        NSMutableDictionary * upDic = [[NSMutableDictionary alloc]init];
        [upDic setValue:model.gc_id forKey:@"gc_id"];
        [upDic setValue:model.description_evaluate forKey:@"description_evaluate"];
        [upDic setValue:model.evaluate_info forKey:@"evaluate_info"];
        if (_imageStrArr.count==0) {
            
            [upDic setValue:@"" forKey:@"evaluate_img"];
            [upDic setValue:@"" forKey:@"evaluate_img_name"];
            [upDic setValue:@"" forKey:@"evaluate_img_size"];

        }else{
            
        [upDic setValue:_imageStrArr[i] forKey:@"evaluate_img"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [upDic setValue:fileName forKey:@"evaluate_img_name"];
         NSNumber * num = [NSNumber numberWithInt:0.5];
        [upDic setValue:num forKey:@"evaluate_img_size"];
            
        }
        [arr addObject:upDic];
    }
    return arr;
}

//请求数据
-(void)loadData{

    NSDictionary * dic = @{@"of_id":_orderId};
    [RequestTools posUserWithURL:@"/order_evaluation_edit.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict[@"return_info"][@"message"]);
        NSArray * array = [NSArray array];
        _dataArr = [NSMutableArray array];
        array = [Dict[@"order"][@"gcs"]mutableCopy];
        for (NSDictionary * dict in array) {
            NSDictionary * goodsDic = dict[@"goods"];
            MyCommentModel * commentModel = [[MyCommentModel alloc]init];
            [commentModel setValuesForKeysWithDictionary:goodsDic];
            [commentModel setValue:dict[@"id"] forKey:@"gc_id"];
            [_dataArr addObject:commentModel];
        }
        [self.tv reloadData];
    } failure:^(NSError *error) {

    }];
}

//调用相册
-(void)selectPhoto{

    //弹出ActionSheet
    sheetIndex = 1;
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照上传" otherButtonTitles:@"本地上传", nil];
    //显示
    [sheet showInView:self.view];

}

#pragma mark UIActionsheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (sheetIndex == 1) {
        if (buttonIndex == 0) {
            //调用照相机功能
            _pickerController=[[UIImagePickerController alloc]init];
            _pickerController.delegate=self;
            //设置拍照后的图片允许编辑
            _pickerController.allowsEditing=YES;
            //设置_pickerController的数据来源为Camera
            _pickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_pickerController animated:YES completion:^{
                
            }];
        }else if (buttonIndex == 1){
            //本地相册
            _pickerController = [[UIImagePickerController alloc]init];
            _pickerController.delegate = self;
            _pickerController.allowsEditing = YES;
            _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_pickerController animated:YES completion:^{
                
            }];
        }
    }
}
//当选中相册中得图片时，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    NSLog(@"选中相册");
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //获得选中图片的对象
        image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //退出相册
        [_pickerController dismissViewControllerAnimated:YES completion:^{
            
        }];
        //将拍照后的图片保存到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }else{

        photoImage = [self scaleImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] toScale:0.5];
        [_pickerController dismissViewControllerAnimated:YES completion:^{
            NSData *imageData=[[NSData alloc]init];
            imageData= UIImageJPEGRepresentation(photoImage,0.5f);
            NSString * encodedImageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [_imageStrArr addObject:encodedImageStr];
            
        }];
        [_imageArr addObject:photoImage];
        
    }
    [self.tv reloadData];
}

//压缩图片
-(UIImage *)scaleImage:(UIImage *)image1 toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image1.size.width*scaleSize,image1.size.height*scaleSize));
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width * scaleSize, image1.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-64-48) style:UITableViewStyleGrouped];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [self.tv registerClass:[MyCommetCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tv];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[_dataArr[indexPath.row] showPic]isEqualToString:@"yes"]) {
        return 298+135;
    }
    return 298;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView  = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * orderLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, 15, 90, 15) text:@"店铺评分" textColor:RGB(71, 71, 71, 1) font:SYS_FONT(15)];
    [footerView addSubview:orderLabel];
    UILabel * serviceLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, 45, 90, 13) text:@"物流服务" textColor:RGB(71, 71, 71, 1) font:SYS_FONT(13)];
    [footerView addSubview:serviceLabel];
    UILabel * fahuoLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, 75, 90, 13) text:@"发货速度" textColor:RGB(71, 71, 71, 1) font:SYS_FONT(13)];
    [footerView addSubview:fahuoLabel];
    
    
    UILabel * scoreLabel1 = [FactoryUI createLabelWithFrame:CGRectMake(SW-13-21, 45, 21, 13) text:@"4分" textColor:RGB(71, 71, 71, 1) font:SYS_FONT(13)];
    [footerView addSubview:scoreLabel1];
    UILabel * scoreLabel2 = [FactoryUI createLabelWithFrame:CGRectMake(SW-13-21, 75, 21, 13) text:@"5分" textColor:RGB(71, 71, 71, 1) font:SYS_FONT(13)];
    [footerView addSubview:scoreLabel2];
    
    _ratingBar1 = [[RatingBar alloc] init];
    _ratingBar1.frame = CGRectMake(SW-45-90, 45, 175, 18);
    _ratingBar1.tag = 10;
    [footerView addSubview:_ratingBar1];
    
    [_ratingBar1 setImageDeselected:@"Star 19 Copy 16" halfSelected:nil fullSelected:@"Star 19 Copy 14" andDelegate:self];
    
    
    _ratingBar2 = [[RatingBar alloc] init];
    _ratingBar2.frame = CGRectMake(SW-45-90, 75, 175, 18);
    _ratingBar2.tag = 20;
    [footerView addSubview:_ratingBar2];
    
    [_ratingBar2 setImageDeselected:@"Star 19 Copy 16" halfSelected:nil fullSelected:@"Star 19 Copy 14" andDelegate:self];
    
    return footerView;
}

//✨代理
-(void)giveCellWithDict:(NSDictionary *)dict{
    
}
//✨代理获取值
-(void)ratingChanged:(float)newRating andView:(UIView *)baseView{
    if (baseView.tag == 10) {
        self.serviceScore = [NSNumber numberWithFloat:newRating];
        NSLog(@"%@",self.serviceScore);
    }else if (baseView.tag == 20){
        self.wuliuScore = [NSNumber numberWithFloat:newRating];
        NSLog(@"%@",self.wuliuScore);
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCommetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    MyCommentModel * model = _dataArr[indexPath.row];
    if (indexPath.row >= _imageArr.count) {
        [model setValue:[UIImage imageNamed:@""] forKey:@"img_path"];
        model.showPic = @"no";
    }else{
    
        [model setValue:_imageArr[indexPath.row] forKey:@"img_path"];
        model.showPic = @"yes";
        if (!model.img_path) {
            cell.selectView.hidden = YES;
        }else{
            cell.selectView.hidden = NO;
            cell.selectImageV.image = model.img_path;
        }

    }
    
    [model setValue:cell.ptview.text forKey:@"evaluate_info"];
    NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,model.goods_main_photo_path];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@""]];
    cell.goodsName.text = model.goods_name;
    cell.btn.tag = indexPath.row;
    cell.ratingBar1.tag = indexPath.row;
    
    return cell;
    
}

//创建导航栏
-(void)createNav{
    
    self.title = @"商品评价";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton * moreBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_more" backgroundImageName:@"" target:self selector:@selector(moreClick:)];
    UIBarButtonItem * moreItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,moreItem, nil];

}

-(void)backClick{

    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

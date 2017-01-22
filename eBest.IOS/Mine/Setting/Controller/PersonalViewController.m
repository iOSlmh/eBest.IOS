 //
//  PersonalViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/20.
//  Copyright © 2016年 shijiboao. All rights reserved.
//
#define currentMonth [currentMonthString integerValue]

#import "PersonalViewController.h"
#import "PersonalModel.h"
#import "MineCell.h"
#import "NicknameViewController.h"
#import "TiePhoneViewController.h"
#import "ThirdLockViewController.h"
#import "MailLockViewController.h"
#import "CheckIDViewController.h"
#import "PhoneMessageViewController.h"

@interface PersonalViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,NicknameViewControllerDelegate,TiePhoneViewControllerDelegate>
{

    PersonalModel * DATA;
    UIImagePickerController *_pickerController;
    UIImageView *face;
    UIImage *image;
    NSInteger sheetIndex;
    NSString *str1;
    UITableViewCell *nickNameCell;
    NSMutableArray * _dataArr;
    NSDictionary * _dict;
    PersonalModel * _model;
    //属性变量性别
    NSString * _sexText;

    //picker
    UIView * lowerView;
    UIPickerView * picker;
    NSString * birdsDate;
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *monthMutableArray;
    NSMutableArray *DaysMutableArray;
    NSMutableArray *DaysArray;
    NSString *currentMonthString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
    
    NSInteger m ;
    int year;
    int month;
    int day;
}

@property(nonatomic,strong) UITableView * tv;
@property(nonatomic,strong) UIView * grayView;
@property(nonatomic,copy) NSString * dayStr;
@property(nonatomic,copy) NSString * monthStr;

@end

@implementation PersonalViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
//    [self testPic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNav];
    [self createTV];
    [self loadData];
    [self createGraview];
    [self createPickerView];

}
-(void)loadData{

    [RequestTools getUserWithURL:@"/user_info.mob" params:nil success:^(NSDictionary *Dict) {
        
        _dict = [[NSDictionary alloc]init];
        _dict = Dict[@"user_info"];
        _model = [[PersonalModel alloc]init];
        [_model setValuesForKeysWithDictionary:_dict];
        [self.tv reloadData];
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH)];
    self.tv.backgroundColor = RGB(236, 235, 235, 1);
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [self.view addSubview:self.tv];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 75;
        }
    }
    return 50;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:  return 4;
        case 1:  return 2;
        case 2:  return 1;
        default: return 0;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }

    if (indexPath.section==0) {
        
        cell.textLabel.text = @[@"头像", @"用户名",@"性别",@"生日"][indexPath.row];
        cell.detailTextLabel.textColor = RGB(175, 175, 175, 1);
        
        if (indexPath.row==2) {
            nickNameCell=cell;
        }
        if (indexPath.row==0) {
            
            face=[[UIImageView alloc]initWithFrame:CGRectMake(self.tv.frame.size.width-75,15,45,45)];
            face.backgroundColor = [UIColor yellowColor];
            //设置头像为圆角
            [face.layer setCornerRadius:22.5];
            face.layer.masksToBounds = YES;
            if (_model.photo && _model.photo !=nil && ![_model.photo isKindOfClass:[NSNull class]]) {
                NSString * str = _model.photo[@"path"];
                NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
                [face sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"默认头像"]options:SDWebImageRefreshCached];
            }
            [cell.contentView addSubview:face];
        }else if(indexPath.row>0){
            
            if (_model==nil) {
                cell.detailTextLabel.text=@[@"",@"",@"",@""][indexPath.row];
            }else{
                
                if ([_model.sex isEqualToString:@"0"]) {
                    _sexText = @"保密";
                }else if ([_model.sex isEqualToString:@"1"]){
                    _sexText = @"男";
                }else{
                    _sexText = @"女";
                }
                if ([_model.birthday isEqualToString:@""]) {
                    _model.birthday=@"设置生日";
                }
                
                cell.detailTextLabel.font=[UIFont systemFontOfSize:15];
                cell.detailTextLabel.text=@[@"",_model.mobile,_sexText,_model.birthday][indexPath.row];
            }
        }
    }else if(indexPath.section==1){
        
        if (_model==nil) {
            cell.detailTextLabel.text=@[@"",@"立即绑定"][indexPath.row];
        }else{
            if (indexPath.row==0) {
                cell.detailTextLabel.text = _model.mobile;
            }
            if (indexPath.row==1) {
                cell.detailTextLabel.text = @"立即绑定";
                cell.detailTextLabel.textColor = RGB(32, 179, 169, 1);
            }

        }

        cell.textLabel.text = @[@"绑定手机号",@"第三方账号绑定"][indexPath.row];
        
    }else if(indexPath.section==2){
        cell.textLabel.text = @"密码";
        cell.detailTextLabel.text = @"立即修改";
        cell.detailTextLabel.textColor = RGB(32, 179, 169, 1);
    }
//设置整体样式
    cell.textLabel.textColor = RGB(71, 71, 71, 1);
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    return cell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * sectionView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 10)];
    return sectionView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //弹出ActionSheet
            sheetIndex = 1;
            
//            UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//            
//            
//            [alertSheet addAction:[UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                NSLog(@"点击确认");
//                
//            }]];
//            [alertSheet addAction:[UIAlertAction actionWithTitle:@"本地上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                NSLog(@"点击确认");
//                
//            }]];
//            [alertSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                NSLog(@"点击确认");
//                
//            }]];
//            
//            [self presentViewController:alertSheet animated:YES completion:nil];

            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照上传" otherButtonTitles:@"本地上传", nil];
            //显示
            [sheet showInView:self.view];
        }if (indexPath.row == 2) {
            //弹出ActionSheet
            sheetIndex = 3;
            UIActionSheet *sheet1=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保密" otherButtonTitles:@"男",@"女", nil];
            //显示
            [sheet1 showInView:self.view];

//            //昵称
//            NicknameViewController *nickController = [[NicknameViewController alloc]init];
//            nickController.delegate=self;
//            [self.navigationController pushViewController:nickController animated:YES];
        }
        if (indexPath.row == 3) {
            
             self.grayView.hidden = NO;
            lowerView.hidden = NO;

        }
//        if(indexPath.row == 4){
//
////            
////            NSDate *data =  [NSDate date];
////            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
////            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
////            
////            _pickerview = [[YCSPickView alloc]initDatePickWithDate:data datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
////            
////            _pickerview.delegate = self;
////            [_pickerview show];
////        }
//    }
    }if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            if (kIsEmptyString(_model.mobile)) {
                
                TiePhoneViewController * tiephoneVC = [[TiePhoneViewController alloc]init];
                [self.navigationController pushViewController:tiephoneVC animated:YES];
                
            }else{
            
                PhoneMessageViewController * phoneMessage = [[PhoneMessageViewController alloc]init];
                phoneMessage.phoneNum = _model.mobile;
                [self.navigationController pushViewController:phoneMessage animated:YES];
            }
            
        }
        //绑定邮箱已去掉
//        if (indexPath.row == 1) {
//            MailLockViewController * mailLockVC = [[MailLockViewController alloc]init];
//            mailLockVC.mailStr = _model.email;
//            [self.navigationController pushViewController:mailLockVC animated:YES];
//            
//        }
        if (indexPath.row == 1) {
            ThirdLockViewController * thirdLockVC = [[ThirdLockViewController alloc]init];
            [self.navigationController pushViewController: thirdLockVC animated:YES];
        }
    }if (indexPath.section == 2) {
            CheckIDViewController * checkIDVC = [[CheckIDViewController alloc]init];
            checkIDVC.mobile = _model.mobile;

            [self.navigationController pushViewController:checkIDVC animated:YES];
            
        }
}

#pragma mark UIActionsheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (sheetIndex == 1) {
        if (buttonIndex == 0) {
//            //调用照相机功能
//            _pickerController=[[UIImagePickerController alloc]init];
//            _pickerController.delegate=self;
//            //设置拍照后的图片允许编辑
//            _pickerController.allowsEditing=YES;
//            //设置_pickerController的数据来源为Camera
//            _pickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
//            [self presentViewController:_pickerController animated:YES completion:^{
//            
//            }];
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                _pickerController = [[UIImagePickerController alloc]init];
                _pickerController.delegate = self;//需要加两个代理
                _pickerController.allowsEditing = YES;
                _pickerController.sourceType = sourceType;
                _pickerController.view.tag=1000;
                [self presentViewController:_pickerController animated:YES completion:nil];
            }else{
                NSLog(@"模拟器中无法打开照相机，请在真机中使用");
            }

        }else if (buttonIndex == 1){
            //本地相册
            _pickerController = [[UIImagePickerController alloc]init];
            _pickerController.delegate = self;
            _pickerController.allowsEditing = YES;
            _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_pickerController animated:YES completion:^{
                
            }];
        }
//        sheetIndex = 0 ;
    }
    if (sheetIndex == 3){

        if (buttonIndex == 0) {
            _model.sex=@"0";
        }if (buttonIndex == 1) {
            _model.sex=@"1";
            NSLog(@"%@",_model);
        }else if (buttonIndex == 2){
            _model.sex=@"2";
        }
        NSDictionary * dic = @{@"attr":@"sex",@"value":_model.sex};
        [RequestTools posUserWithURL:@"/user_info_update.mob" params:dic success:^(NSDictionary *Dict) {
            NSLog(@"----------------%@",Dict);
            NSLog(@"----------------%@",Dict[@"return_info"][@"message"]);
            if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
                
                [MyHUD showAllTextDialogWith:@"保存成功" showView:self.view];
            }else{
                
                [MyHUD showAllTextDialogWith:@"保存失败" showView:self.view];
            }
            [self.tv reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
    [self.tv reloadData];
}

#pragma mark ----------------------上传图片
//当选中相册中得图片时，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //获得选中图片的对象
        image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //退出相册
        [_pickerController dismissViewControllerAnimated:YES completion:^{
            
        }];
        //将拍照后的图片保存到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }else{
        
//        UIImage *photoImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        face.image=photoImage;
        [_pickerController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
    
    //图片
    UIImage *photoImage = [self scaleImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] toScale:0.5];
    NSData *imageData=[[NSData alloc]init];
    imageData= UIImageJPEGRepresentation(photoImage,0.5f);
    NSString *_encodedImageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    //AF上传
    //请求字典
    NSNumber * num = [NSNumber numberWithInt:0.5];
    NSDictionary *dic =@{@"user_photo_name":fileName,@"user_photo_size":num,@"user_photo":_encodedImageStr};
    //json请求
    [RequestTools posJsonWithURL:@"/user_photo_update.mob" params:dic success:^(NSDictionary *Dict) {
        NSLog(@"%@",Dict);
        NSLog(@"%@",Dict[@"return_info"][@"message"]);
        face.image = photoImage;
    } failure:^(NSError *error) {
        
    }];
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

//******************************************************************
-(void)getName:(NSString *)name
{
    
    nickNameCell.detailTextLabel.text=name;
    
//    DATA.name = name;
//    [self upLoadDataURL];
    
    [self.delegate getmainNicheng:name];
    
    
}
-(void)getPhone:(NSString *)phoneNum{
    
}
//调出规格窗口并创建灰色遮布
-(void)createGraview{
    self.grayView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, SH)];
    self.grayView.backgroundColor = [UIColor grayColor];
    self.grayView.alpha = 0.6;
    self.grayView.userInteractionEnabled = YES;
    self.grayView.hidden = YES;
    UITapGestureRecognizer * tapMiss = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMissClickc)];
    [self.grayView addGestureRecognizer:tapMiss];
    [self.view addSubview:self.grayView];
}
//遮布点击事件
-(void)tapMissClickc{
    
    self.grayView.hidden = YES;
    lowerView.hidden = YES;
}
#pragma mark ----------------------创建生日选择picker
-(void)createPickerView{
    
    lowerView = [FactoryUI createViewWithFrame:CGRectMake(0, SH-270, SW, 270)];
    lowerView.backgroundColor = [UIColor whiteColor];
    lowerView.hidden = YES;
    UIButton * pickCancelBtn = [FactoryUI createButtonWithFrame:CGRectMake(20, 10, 30, 20) title:@"取消" titleColor:RGB(71, 71, 71, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(cancelBtnClick)];
    pickCancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    UIButton * pickConfirmBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-50, 10, 30, 20) title:@"确认" titleColor:RGB(71, 71, 71, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(confirmBtnClick)];
    pickConfirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [lowerView addSubview:pickConfirmBtn];
    [lowerView addSubview:pickCancelBtn];
    
    picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 30, SW, 230)];
    picker.dataSource = self;
    picker.delegate = self;
    [picker selectRow:4 inComponent:0 animated:NO];
    [lowerView addSubview: picker];
    [self.view addSubview:lowerView];
    
    m=10;
    firstTimeLoad = YES;
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    year =[currentyearString intValue];
    
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    month=[currentMonthString intValue];
    
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    day =[currentDateString intValue];
    
    yearArray = [[NSMutableArray alloc]init];
    monthMutableArray = [[NSMutableArray alloc]init];
    DaysMutableArray= [[NSMutableArray alloc]init];
    for (int i = 1970; i <= year ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    // PickerView -  Months data
    monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    for (int i=1; i<month+1; i++) {
        [monthMutableArray addObject:[NSString stringWithFormat:@"%d月",i]];
    }
    DaysArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    for (int i = 1; i <day+1; i++)
    {
        [DaysMutableArray addObject:[NSString stringWithFormat:@"%d日",i]];
        
    }
}

-(void)cancelBtnClick{

    self.grayView.hidden = YES;
    lowerView.hidden = YES;
}
-(void)confirmBtnClick{

    self.grayView.hidden = YES;
    lowerView.hidden = YES;
    //补0转换
    if ([[monthArray objectAtIndex:[picker selectedRowInComponent:1]] integerValue]<10) {
        
        _monthStr = [NSString stringWithFormat:@"0%@",[monthArray objectAtIndex:[picker selectedRowInComponent:1]]];
    }else{
    
        _monthStr = [NSString stringWithFormat:@"%@",[monthArray objectAtIndex:[picker selectedRowInComponent:1]]];
    }
    if ([[DaysArray objectAtIndex:[picker selectedRowInComponent:2]] integerValue]<10) {
        
        _dayStr = [NSString stringWithFormat:@"0%@",[DaysArray objectAtIndex:[picker selectedRowInComponent:2]]];
    }else{
    
        _dayStr = [NSString stringWithFormat:@"%@",[DaysArray objectAtIndex:[picker selectedRowInComponent:2]]];
    }
    
    birdsDate = [NSString stringWithFormat:@"%@-%@-%@ ",[yearArray objectAtIndex:[picker selectedRowInComponent:0]],_monthStr,_dayStr];
    //转时间戳
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone * timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [inputFormatter setTimeZone:timeZone];
    [inputFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:birdsDate];
    NSLog(@"date = %@", inputDate);
    _model.birthday = birdsDate;
    //更新后台时间
    NSDictionary * dic = @{@"attr":@"birthday",@"value":inputDate};
    [RequestTools posUserWithURL:@"/user_info_update.mob" params:dic success:^(NSDictionary *Dict) {
        NSLog(@"----------------%@",Dict);
        NSLog(@"----------------%@",Dict[@"return_info"][@"message"]);
        if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
            [MyHUD showAllTextDialogWith:@"保存成功" showView:self.view];
        }else{
            
            [MyHUD showAllTextDialogWith:@"保存失败" showView:self.view];
        }
        [self.tv reloadData];
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark ----------------------picker代理方法
#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    m=row;
    
    if (component == 0)
    {
        selectedYearRow = row;
        [picker reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [picker reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        [picker reloadAllComponents];
    }
    
}

#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    if (component == 0)
    {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
        
    }
    
    return pickerLabel;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 3;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [yearArray count];
        
    }
    else if (component == 1)
    {
        NSInteger selectRow =  [pickerView selectedRowInComponent:0];
        int n;
        n= year-1970;
        if (selectRow==n) {
            return [monthMutableArray count];
        }else
        {
            return [monthArray count];
            
        }
    }
    else
    {
        NSInteger selectRow1 =  [pickerView selectedRowInComponent:0];
        int n;
        n= year-1970;
        NSInteger selectRow =  [pickerView selectedRowInComponent:1];
        
        if (selectRow==month-1 &selectRow1==n) {
            
            return day;
            
        }else{
            
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }else{
                    return 28; // or return 29
                }
                
            }
            else
            {
                return 30;
            }
        }
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         picker.hidden = NO;
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    picker.hidden = NO;
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return  YES;
    
}



#pragma mark ----------------------创建导航栏
-(void)createNav{
    
    self.title = @"个人信息设置";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
   
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];

}
- (void)backClick{
    
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

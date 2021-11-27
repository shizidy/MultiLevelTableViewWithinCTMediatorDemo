//
//  MultiLevelCell.m
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/26.
//

#import "MultiLevelCell.h"
#import "MultiLevelModel.h"

@interface MultiLevelCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@end

@implementation MultiLevelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubviews];
        [self setSubviewsConstraints];
    }
    return self;
}

#pragma mark - setSubviews
- (void)setSubviews {
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = [UIColor blackColor];
    
    self.arrowImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.arrowImgView];
    self.arrowImgView.image = [UIImage imageNamed:@"right_arrow"];
}

#pragma mark - setSubviewsConstraints
- (void)setSubviewsConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setCellWithViewModel:(MultiLevelViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    MultiLevelModel *model = viewModel.placesArray[indexPath.row];
    self.arrowImgView.hidden = !model.children.count;
    self.titleLabel.text = model.name;
    
    if (model.level == 0) {
        self.titleLabel.textColor = UIColor.redColor;
    } else if (model.level == 1) {
        self.titleLabel.textColor = UIColor.orangeColor;
    } else {
        self.titleLabel.textColor = UIColor.blueColor;
    }
    
    if (model.isExpanded) {
        _arrowImgView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    } else {
        _arrowImgView.transform = CGAffineTransformIdentity;
    }
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10 + model.level * 10);
    }];
}

#pragma mark - 箭头旋转动画
- (void)makeArrowImgViewRotation:(CGFloat)rotation {
    //执行箭头旋转动画
    [UIView animateWithDuration:0.3 animations:^{
        self->_arrowImgView.transform = CGAffineTransformMakeRotation(rotation);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

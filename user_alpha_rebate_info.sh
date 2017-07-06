#!/bin/bash

user=""
password=""
host=""
port=""
help_msg()
{
    echo "usage $0 -u{username} -p{password} -h{host} -P{port}"
}
while getopts "u:p:h:P:" opt; do
    case $opt in
        u)
            echo "user:$OPTARG"
            user=$OPTARG
            ;;
        p)
            echo "password:$OPTARG"
            password=$OPTARG
            ;;
        h)
            echo "host:$OPTARG"
            host=$OPTARG
            ;;
        P)
            echo "port:$OPTARG"
            port=$OPTARG
            ;;
        \?)
            echo "invalid arg -$OPTARG"
            ;;        
    esac
done

if [ -z "$user" ] || [ -z "$password" ] || [ -z "host" ] || [ -z "$port" ]; then
    help_msg
    exit 1
fi
#alter table user_alpha_rebate_info add primary key(`outer_id`,`account_plat`);
#mysql -ufish3d -p123456 -h192.168.0.58 -P3308 << EOF
echo "$user $password $host $port"
:<<!
!
mysql -u"$user" -p"$password" -h"$host" -P"$port" --force <<EOF
use db_fish3d_game;
drop table user_alpha_rebate_info;
create table user_alpha_rebate_info select * from (SELECT bi.outer_id, 'lk' as account_plat, bi.openid, ifnull(udi.diamond, 0) as diamond , ifnull(udi.save_amt,0) as save_amt, ifnull(udi.gen_diamond, 0) as gen_diamond,ifnull(uni.noble_point_pay,0) as noble_point_pay, ifnull(uni.noble_point_exp,0) as noble_point_exp, ifnull(uni.noble_point_level, 0) as noble_point_level, ifnull(uni.noble_privilege_bit,0) as noble_privilege_bit, 0 as status  FROM outer_bind_lk bi left join user_diamond_info udi on bi.openid=udi.uid left join user_noble_info uni on bi.openid=uni.uid union SELECT bi.outer_id, 'qq' as account_plat, bi.openid, ifnull(udi.diamond, 0) as diamond , ifnull(udi.save_amt,0) as save_amt, ifnull(udi.gen_diamond, 0) as gen_diamond,ifnull(uni.noble_point_pay,0) as noble_point_pay, ifnull(uni.noble_point_exp,0) as noble_point_exp, ifnull(uni.noble_point_level, 0) as noble_point_level, ifnull(uni.noble_privilege_bit,0) as noble_privilege_bit, 0 as status  FROM outer_bind_qq bi left join user_diamond_info udi on bi.openid=udi.uid left join user_noble_info uni on bi.openid=uni.uid union SELECT bi.outer_id, 'wc' as account_plat, bi.openid, ifnull(udi.diamond, 0) as diamond , ifnull(udi.save_amt,0) as save_amt, ifnull(udi.gen_diamond, 0) as gen_diamond,ifnull(uni.noble_point_pay,0) as noble_point_pay, ifnull(uni.noble_point_exp,0) as noble_point_exp, ifnull(uni.noble_point_level, 0) as noble_point_level, ifnull(uni.noble_privilege_bit,0) as noble_privilege_bit, 0 as status  FROM outer_bind_wc bi left join user_diamond_info udi on bi.openid=udi.uid left join user_noble_info uni on bi.openid=uni.uid union SELECT bi.phone as outer_id, 'phone' as account_plat, bi.openid, ifnull(udi.diamond, 0) as diamond , ifnull(udi.save_amt,0) as save_amt, ifnull(udi.gen_diamond, 0) as gen_diamond,ifnull(uni.noble_point_pay,0) as noble_point_pay, ifnull(uni.noble_point_exp,0) as noble_point_exp, ifnull(uni.noble_point_level, 0) as noble_point_level, ifnull(uni.noble_privilege_bit,0) as noble_privilege_bit, 0 as status  FROM account_bind_info bi left join user_diamond_info udi on bi.openid=udi.uid left join user_noble_info uni on bi.openid=uni.uid) as t;
alter table user_alpha_rebate_info add primary key(outer_id,account_plat);
EOF
# dump table and data to file
mysqldump -u"$user" -p"$password" -h"$host" -P"$port" db_fish3d_game user_alpha_rebate_info > user_alpha_rebate_info_data.sql
echo "executing state:$?"


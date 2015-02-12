# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all

User.create(:name=>'Jie Yang', :email=>'jie.yang@careerbuilder.com', :status=>'work', :joined_date=>'2009-7-1')
User.create(:name=>'Ke Bing Hou', :email=>'kebing.hou@careerbuilder.com', :status=>'work', :joined_date=>'2010-5-16')
User.create(:name=>'Lin Chen', :email=>'lin.chen@careerbuilder.com', :status=>'work', :joined_date=>'2010-9-20')
User.create(:name=>'Ken Wang', :email=>'xiaohui.wang@careerbuilder.com', :status=>'work', :joined_date=>'2011-2-1')
User.create(:name=>'Yong Zhu', :email=>'yong.zhu@careerbuilder.com', :status=>'work', :joined_date=>'2011-12-1')
User.create(:name=>'Jing Li', :email=>'jing.li@careerbuilder.com', :status=>'work', :joined_date=>'2012-1-16')
User.create(:name=>'Shenghua Lian', :email=>'shenghua.lian@careerbuilder.com', :status=>'work', :joined_date=>'2012-2-16')
User.create(:name=>'Chunmei Ma', :email=>'chunmei.ma@careerbuilder.com', :status=>'work', :joined_date=>'2012-7-1')
User.create(:name=>'Longwen Zhao ', :email=>'longwen.zhao@careerbuilder.com', :status=>'work', :joined_date=>'2012-8-13')
User.create(:name=>'Nickolas Ni', :email=>'nickolas.ni@careerbuilder.com', :status=>'work', :joined_date=>'2013-12-16')
User.create(:name=>'Matt Yan', :email=>'matt.yan@careerbuilder.com', :status=>'work', :joined_date=>'2013-12-16')
User.create(:name=>'Martin Chen', :email=>'martin.chen@careerbuilder.com', :status=>'work', :joined_date=>'2014-2-16')
User.create(:name=>'Xinhai Zeng', :email=>'xinhai.zeng@careerbuilder.com', :status=>'work', :joined_date=>'2014-5-14')
User.create(:name=>'Rui Fang', :email=>'rui.fang@careerbuilder.com', :status=>'work', :joined_date=>'2014-8-18')
User.create(:name=>'Wei Luo', :email=>'wei.luo@careerbuilder.com', :status=>'work', :joined_date=>'2014-9-1')
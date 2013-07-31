##数据结构

###NEWS

- 课程新增字段：is_completed, Boolean 	2013-7-23
- 原Schedule中的Scopes移到Course中		2013-7-31


###DOMUCENT

使用 [Mongoid](http://mongoid.org/en/mongoid/)

###用户

`Class name: User`

	Field				Type

	username			String
	email				String
	name				String
	identity_number		String
	role				String, default: :student

	Relation			Type

	courses				has_and_belongs_to_many, update_validation: role is "teacher"


	Scopes
	teachers, students
	

* 学生

	`identity_number` 为学号

	`role = :student`

	

* 教师

	`identity_number` 为教师号
	
	`role = :teacher`

###课程

`Class name: Course`

	Field				Type

	name				String
	is_completed		Boolean
	

	Relation			Type

	lecturers			has_and_belongs_to_many, inverse_of: :teacher
	students			has_and_belongs_to_many, inverse_of: :student
	schedual			has_many
	
	Scopes:
	lectures, tests, examinations ... 每一个日程类型都有一个scope，复数形式
	overdue, soon, future

###日程

`Class name: schedule`

	Field				Type

	when				datetime
	where				String
	what				one of [:lecture, :test, :examination, :practise, :experiment] 可能增加

	Relation			Type

	course				belongs_to



##简单说明

* Field的用法：

	比如有一个`User`的实例`student_a`，那么可以这样来获得他的用户名

		student_a.username
		 => "Student A"
	Email也同样

		student_a.email
		 => "student_a@school.edu"

* 什么是Relation：

	如果要获取english课程的所有学生，可以这样做：

		english = Course.where(name: "english")
		english.students
		 => <User: name: "Student A", ……………………

	如果要为一个教师新建一个课程，可以这样做：

		teacher_a = User.teachers.first
		pchm = teacher_a.courses.build name: "polymer chemistry"
		pchm.save!

	以上是have/has开头的Relation的用法，以下是belongs_to：

		sch_a = Schedule.first
		 => <Schedule when: "2013-12-10 13:30" ………………

		sch_a.course
		 => <Course name: "polymer chemistry" ………………

* 什么是Scope：

	简单的讲，就是封装了的数据库查询和筛选条件。
	
	比如Schedule的一个scope可以这样定义

		class Schedule

		  ...

		  scope :overdue do
			where(:when < Time.now)
		  end

		  ...

		end

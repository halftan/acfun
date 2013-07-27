##数据结构


使用 [Mongoid](http://mongoid.org/en/mongoid/)

###Version 0.1

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
	

	Relation			Type

	lecturers			has_and_belongs_to_many, inverse_of: :teacher
	students			has_and_belongs_to_many, inverse_of: :student
	schedual			has_many

###日程

`Class name: schedule`

	Field				Type

	when				datetime
	where				String
	what				one of [:lecture, :test, :examination, :practise] 可能增加

	Relation			Type

	course				belongs_to

	
	Scopes:
	lecture, test, examination, practise
	overdue, soon, future


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


###Version 0.12

####新增：课程中的字段

`Class name: Course`

	Field				Type

	is_completed		Boolean
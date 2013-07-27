##api手册


说明：每个`path`都有对应的`HTTP Verb/Method`，就算`path`相同，`HTTP Verb/Method`不一样的话，调用的api是不同的

以下`Path`均以 `http://#{acfun_server}`为根路径(`Base Path`)

	Method		Path					Arguments/Payload			Description

	GET			/(index)				None						登陆页面
	POST		/user/sign_in			email & password			用户登录
	POST		/user/sign_up			email & password			用户注册
	GET			/user/sign_out			None						用户登出
	GET			/dashboard				None						应用的主页面

注意：以上返回的是html页面，非json Api

**所有`Timestamp`均采用`ISO8601`格式**

以下`Path`均以 `http://#{acfun_server}/api`为根路径(`Base Path`)

###Version 0.1

	Method		Path					Arguments/Payload			Description

	GET			/user(/:id)				id=xxx或者identity=xxx		返回该用户信息；
																	若无则返回404

	GET			/user/:id/courses		filter=(learning|			返回用户的课程列表。
											done|all)				可选择返回 正在修习，已完成
																	或全部 的课程

	GET			/courses				query(name,...)				查看所有课程列表，
																	或按query所描述的条件筛选

	GET			/course/:id				None						查看id/name对应的
																	课程的详细信息。
																	返回对象内嵌Schedule数组

	POST		(/user/:id)/courses		json:{"name":"xx",...}		新建一个course模型；
																	user必须为teacher，否则返回401.
																	失败则返回400.
																	若要内嵌Schedule，则需：
										{
											"name":"xx",
											"schedule_attributes":{
												"0": {
													"when": "#{timestamp}",
													"where": "classroom", ... }
												"1": {....}
												}
										}

	DELETE		(/user/:id)				None						删除一个Course
					/course/:id										无权限返回401
																	找不到此课程返回404

	PUT			同上						json:{"name":"xx",...}		修改一个course
																	不接受Schedule

	GET			(/user/:id)/course		type=(overdue				返回该课程的所有时间表
					/:id/schedules			|soon|future)			参数说明：
											&day=#{int}				overdue：逾期
																	soon：近期（可加参数day=?）
																	future：未来

	POST		同上						json:{"when":....			为制定Course增加一个时间表
											"conditions":{			以下是url中conditions的说明:
												"every":... ,		目前conditions只能够为every/(monday|tuesday...)
												"from":... ,		此时必须在payload的json中添加两个字段from和until
												"until":... }		即从from到until这段时间中每个every的when都有课
												}					from和until都以timestamp来表示，只取到日为止
																	且计算时包含from和until

	DELETE		(/user/:id/course/		None						删除一个Schedule，无权限返回401
					:id)/schedule/:id								找不到返回404

	PUT			同上						json:{"when":...)			修改Schedule信息
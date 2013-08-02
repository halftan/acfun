function TeacherCtrl($scope) {
  $scope.teacher_Ctrl = '教学管理';
  $scope.teacher_Arra = '教学安排';
  $scope.role = 'teacher';
  $scope.teacher_func = [
    {text:'上传作业'},
    {text:'成绩登入'},
    {text:'待定'},
    {text:'待定'},
    ];
  $scope.teacher_arr = [
    {text:'考试安排'},
    {text:'教学大纲'},
    {text:'待定'},
    {text:'待定'},
    ];
  $scope.teacher_info = [
  	{text:'姓名:'},
  	{text:'工号:'},
  	{text:'院系:'},
    ];

  $scope.student_Ctrl = '作业管理';
  $scope.student_Arra = '教学信息';
  $scope.student_func = [
    {text:'作业提交'},
    {text:'成绩查看'},
    {text:'待定'},
    {text:'待定'},
    ];
  $scope.student_arr = [
    {text:'课程表'},
    {text:'线上交流'},
    {text:'教学资源'},
    {text:'待定'},
    ];
  $scope.student_info = [
    {text:'姓名:'},
    {text:'学号:'},
    {text:'院系:'},
    ];
  $scope.value = 1;
  
  $scope.addrole = function(){
    var x=5;
    if(x>4){
      $scope.value = x;
    }
    else{
      $scope.value = x-1;
    }
  };

}




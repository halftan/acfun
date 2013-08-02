function showpwd(){
 if(document.getElementById("pwd").type=="password"){
   var pass = document.getElementById("pwd").value;
   document.getElementById("pwdinput").innerHTML='<input type="text" id="pwd" value="'+pass+'" style = "width: 398px; height: 41px"/ >';
  }
 else{
   var pass = document.getElementById("pwd").value;
   document.getElementById("pwdinput").innerHTML='<input type="password" id="pwd" value="'+pass+'" style = "width: 398px; height: 41px"/>';
   }
 }
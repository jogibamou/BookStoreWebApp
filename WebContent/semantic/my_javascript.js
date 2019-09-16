function addBookToCart(id_book){
	var cookie_name = getCookie("b_"+id_book);
	if(cookie_name == "")
		document.cookie = "b_"+id_book+"="+id_book+";";
	else
		alert("This item is already in your cart.");
	console.log(id_book);
}

function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}

function validateRegistrationForm(){
	var success = true;
	var strongRegex = /^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$/;
	var regex_name = /^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$/;
	var regex_username = /^[^<>%$]*$/;
	
	var password_value = document.forms["reg_form"]["password"].value;
	var conf_password = document.forms["reg_form"]["re_password"].value;
	var compare_result = password_value.localeCompare(conf_password);
	
	var name_value = document.forms["reg_form"]["name"].value;
	var username_value = document.forms["reg_form"]["username"].value;
	
	var div_error = document.getElementById("error_block");
	
	//empty element of the div tag
	while (div_error.firstChild) {
		div_error.removeChild(div_error.firstChild);
	}
	
	if(!regex_username.test(username_value)){
		var list = document.createElement("ul");
		var element_list_1 = document.createElement("li");
		var node_1 = document.createTextNode("username cannot contains <, >, %, $");
		element_list_1.appendChild(node_1);
		list.appendChild(element_list_1);
		div_error.appendChild(list);
		success = false;
	}
	
	if(!regex_name.test(name_value)){
		var list = document.createElement("ul");
		var element_list_1 = document.createElement("li");
		var node_1 = document.createTextNode("Name can only be made of uppercase, lowercase, space, ('),(.) and (-)");
		element_list_1.appendChild(node_1);
		list.appendChild(element_list_1);
		div_error.appendChild(list);
		success = false;
	}
	
	if(!strongRegex.test(password_value)){
		var list = document.createElement("ul");
		var element_list_1 = document.createElement("li");
		var element_list_2 = document.createElement("li");
		var element_list_3 = document.createElement("li");
		var node_1 = document.createTextNode("Password must contains a lowercase character ");
		var node_2 = document.createTextNode("Password must contains a uppercase character ");
		var node_3 = document.createTextNode("Password must contains a digit");
		element_list_1.appendChild(node_1);
		element_list_2.appendChild(node_2);
		element_list_3.appendChild(node_3);
		list.appendChild(element_list_1);
		list.appendChild(element_list_2);
		list.appendChild(element_list_3);
		div_error.appendChild(list);
		success = false;
	}
	
	if(compare_result!=0){
		var list = document.createElement("ul");
		var element_list_1 = document.createElement("li");
		var node_1 = document.createTextNode("Password and Confirmation Password should be similar");
		element_list_1.appendChild(node_1);
		list.appendChild(element_list_1);
		div_error.appendChild(list);
		success = false;
	}
	return success;
}



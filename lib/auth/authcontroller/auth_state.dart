class AuthState{
  String email;
  String password;
  String username;
  String fullname;
  String address;


  AuthState({this.email= '', this.password = '',this.username = '', this.fullname = '', this.address ='',});

  AuthState copyWith({String?email, String?password, String?username, String? fullname, String?address,  }){
    return AuthState(
        email: email?? this.email,
        password:  password?? this.password,
        username: username?? this.username,
        fullname:  fullname?? this.fullname,
        address: address ?? this.address,
    );
  }
}

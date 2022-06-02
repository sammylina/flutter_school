import 'package:firebase_auth/firebase_auth.dart';
import 'package:school/model/user.dart';

class AuthService {

	final FirebaseAuth _auth = FirebaseAuth.instance;
	
	User _user_from_firebase(FirebaseUser user) {
		if (user != null) {
			return User(uid: user.uid);	
		}
	}

}

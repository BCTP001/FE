import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../component/graphql_client.dart';

// Auth Provider to manage authentication state
class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  
  bool get isLoggedIn => _isLoggedIn;
  
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }
  
  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

// Welcome Screen (First screen)
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABF4D0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              // Book icon
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/book.png',
                    fit: BoxFit.contain,
                    width: 225,
                    height: 284,
                  ),
                  Positioned(
                    child: Text(
                      '오늘의 책',
                      style: GoogleFonts.nanumBrushScript(
                        fontSize: 40,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Korean text
              Text(
                "당신만의 책을\n찾아보세요",
                textAlign: TextAlign.center,
                style: GoogleFonts.nanumBrushScript(
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              // Login button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD0C38F),
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("로그인"),
              ),
              SizedBox(height: 12),
              // Registration button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/setup1');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3E2723), // Dark brown
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("회원가입"),
              ),
              SizedBox(height: 20),
              // Small text at the bottom
              Text(
                "아이디/비밀번호 찾기",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Login Screen
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABF4D0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              // Book icon
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/book.png',
                    fit: BoxFit.contain,
                    width: 225,
                    height: 284,
                  ),
                  Positioned(
                    child: Text(
                      '오늘의 책',
                      style: GoogleFonts.nanumBrushScript(
                        fontSize: 40,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              // Korean text
              Text(
                "오늘의 책에\n로그인하기",
                textAlign: TextAlign.center,
                style: GoogleFonts.nanumBrushScript(
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              // ID field
              Text(
                "아이디",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD0C38F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Password field
              Text(
                "비밀번호",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD0C38F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Login button
              ElevatedButton(
                onPressed: () {
                  // Trigger login and navigate to main app
                  Provider.of<AuthProvider>(context, listen: false).login();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3E2723), // Dark brown
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("로그인"),
              ),
              SizedBox(height: 8),
              // Small text at the bottom
              Text(
                "아이디/비밀번호 찾기",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Registration screens (Setup 1-5)
class SetupScreen1 extends StatelessWidget {
  final TextEditingController _loginNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABF4D0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "계정 생성",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Text(
                "이름을 적어주세요",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD0C38F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _loginNameController,
                  decoration: InputDecoration(
                    hintText: "example",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    String enteredLoginName = _loginNameController.text.trim();
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => SetupScreen2(
                          loginName: enteredLoginName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF8E6C8),
                    foregroundColor: Colors.black,
                    minimumSize: Size(100, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("다음"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupScreen2 extends StatelessWidget {
  final String loginName;
  final TextEditingController _passwordController = TextEditingController();

  SetupScreen2({Key? key, required this.loginName}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABF4D0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "계정 생성",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Text(
                "비밀번호를 적어주세요",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD0C38F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "example",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    String enteredPassword = _passwordController.text.trim();
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => SetupScreen3(
                          loginName: loginName,
                          password: enteredPassword,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF8E6C8),
                    foregroundColor: Colors.black,
                    minimumSize: Size(100, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("다음"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupScreen3 extends StatelessWidget {
  final String loginName;
  final String password;
  final TextEditingController _nicknameController = TextEditingController();

  SetupScreen3({Key? key, required this.loginName, required this.password}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABF4D0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "계정 생성",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Text(
                "닉네임을 적어주세요",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD0C38F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    hintText: "활동할 닉네임",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    String enteredNickname = _nicknameController.text.trim();
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => SetupScreen4(
                          loginName: loginName,
                          password: password,
                          nickname: enteredNickname,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF8E6C8),
                    foregroundColor: Colors.black,
                    minimumSize: Size(100, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("다음"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupScreen4 extends StatelessWidget {
  final String loginName;
  final String password;
  final String nickname;

  const SetupScreen4({Key? key, required this.loginName, required this.password, required this.nickname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABF4D0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "계정 생성",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "원하는 장르를 골라주세요",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    if (index == 8) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFDBAD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                      );
                    }
                    
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFDBAD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "책이름",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "저자", 
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "2/3 페이지 보여주는 중",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => SetupScreen5(
                          loginName: loginName,
                          password: password,
                          nickname: nickname,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF8E6C8),
                    foregroundColor: Colors.black,
                    minimumSize: Size(100, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("다음"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupScreen5 extends StatefulWidget {
  final String loginName;    // username from SetupScreen1
  final String password;     // password from SetupScreen2
  final String nickname;     // name from SetupScreen3

  const SetupScreen5({
    Key? key,
    required this.loginName,
    required this.password,
    required this.nickname,
  }) : super(key: key);

  @override
  State<SetupScreen5> createState() => _SetupScreen5State();
}

class _SetupScreen5State extends State<SetupScreen5> {
  bool _isLoading = false;
  bool _isSignupComplete = false;

  @override
  void initState() {
    super.initState();
    // Automatically trigger signup when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleSignUp();
    });
  }

  Future<void> _handleSignUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the GraphQL signup API with the collected data
      final result = await GraphQLService.signUp(
        widget.nickname,    // name parameter
        widget.loginName,   // username parameter
        widget.password,    // password parameter
      );

      if (result != null && result['signUp'] != null) {
        // Success - handle the response
        final userData = result['signUp'];
        
        if (mounted) {
          setState(() {
            _isSignupComplete = true;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome ${userData['name']}! Account created successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Failed - show error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Signup failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _retrySignup() {
    setState(() {
      _isSignupComplete = false;
    });
    _handleSignUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABF4D0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                "회원가입 완료!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "축하합니다!\n이제 당신을 위한\n도서를 찾아보세요",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  // After registration, log the user in
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF8E6C8),
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("시작하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
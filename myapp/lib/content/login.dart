import 'package:flutter/material.dart';
import '../component/graphql_client.dart';
import '../component/util.dart';

// Welcome Screen
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppDimensions.largeSpacing),
              CommonWidgets.buildBookLogo(),
              const SizedBox(
                  height:
                      AppDimensions.mediumSpacing + AppDimensions.smallSpacing),
              Text(
                "당신만의 책을\n찾아보세요",
                textAlign: TextAlign.center,
                style: AppStyles.titleStyle,
              ),
              const Spacer(),
              CommonWidgets.buildSecondaryButton(
                text: "로그인",
                onPressed: () => Navigator.pushNamed(context, '/login'),
              ),
              const SizedBox(height: AppDimensions.smallSpacing + 4),
              CommonWidgets.buildPrimaryButton(
                text: "회원가입",
                onPressed: () => Navigator.pushNamed(context, '/setup1'),
              ),
              const SizedBox(
                  height:
                      AppDimensions.mediumSpacing + AppDimensions.smallSpacing),
              Text(
                "아이디/비밀번호 찾기",
                style: AppStyles.captionStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _loginnameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    final loginname = _loginnameController.text.trim();
    final password = _passwordController.text.trim();

    if (!_validateInput(loginname, password)) return;

    setState(() => _isLoading = true);

    try {
      final result = await GraphQLService.signIn(loginname, password);

      if (result?['signIn'] != null) {
        final userData = result!['signIn']['signedInAs'];

        if (mounted) {
          CommonWidgets.showSnackBar(context, '환영합니다, ${userData['name']}님!');
          Navigator.pushReplacementNamed(context, '/main');
        }
      } else {
        if (mounted) {
          CommonWidgets.showSnackBar(
            context,
            '로그인에 실패했습니다. 아이디와 비밀번호를 확인해주세요.',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CommonWidgets.showSnackBar(
          context,
          '오류가 발생했습니다: ${e.toString()}',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _validateInput(String loginname, String password) {
    if (loginname.isEmpty || password.isEmpty) {
      CommonWidgets.showSnackBar(
        context,
        '아이디와 비밀번호를 입력해주세요.',
        isError: true,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryGreen,
        appBar: CommonWidgets.buildAppBar(
          onBackPressed: () => Navigator.pop(context),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: AppDimensions.largeSpacing),
                  CommonWidgets.buildBookLogo(),
                  const SizedBox(height: AppDimensions.largeSpacing),
                  CommonWidgets.buildInputField(
                    label: "아이디",
                    controller: _loginnameController,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: AppDimensions.mediumSpacing),
                  CommonWidgets.buildInputField(
                    label: "비밀번호",
                    controller: _passwordController,
                    isPassword: true,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: AppDimensions.defaultPadding),
                  CommonWidgets.buildPrimaryButton(
                    text: "로그인",
                    onPressed: _isLoading ? null : _handleSignIn,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: AppDimensions.mediumSpacing),
                  Text(
                    "아이디/비밀번호 찾기",
                    style: AppStyles.captionStyle,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

// Base Setup Screen
abstract class BaseSetupScreen extends StatelessWidget {
  final String title;
  final String inputLabel;
  final String inputHint;
  final bool isPassword;

  const BaseSetupScreen({
    super.key,
    required this.title,
    required this.inputLabel,
    required this.inputHint,
    this.isPassword = false,
  });

  Widget buildBody(BuildContext context, TextEditingController controller);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: CommonWidgets.buildAppBar(
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.defaultPadding),
          child: buildBody(context, controller),
        ),
      ),
    );
  }
}

// Setup Screen 1 - Name Input
class SetupScreen1 extends BaseSetupScreen {
  const SetupScreen1({Key? key})
      : super(
          key: key,
          title: "계정 생성",
          inputLabel: "이름을 적어주세요",
          inputHint: "example",
        );

  @override
  Widget buildBody(BuildContext context, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AppStyles.headerStyle),
        const SizedBox(height: AppDimensions.largeSpacing),
        Text(inputLabel, style: AppStyles.subHeaderStyle),
        const SizedBox(height: AppDimensions.mediumSpacing),
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightBrown,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: inputHint,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.mediumSpacing,
                vertical: 12,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        const Spacer(),
        CommonWidgets.buildNextButton(
          onPressed: () {
            final loginName = controller.text.trim();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SetupScreen2(loginName: loginName),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Setup Screen 2 - Password Input
class SetupScreen2 extends StatelessWidget {
  final String loginName;

  const SetupScreen2({super.key, required this.loginName});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: CommonWidgets.buildAppBar(
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("계정 생성", style: AppStyles.headerStyle),
              const SizedBox(height: AppDimensions.largeSpacing),
              Text("비밀번호를 적어주세요", style: AppStyles.subHeaderStyle),
              const SizedBox(height: AppDimensions.mediumSpacing),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBrown,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "example",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.mediumSpacing,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Spacer(),
              CommonWidgets.buildNextButton(
                onPressed: () {
                  final password = passwordController.text.trim();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetupScreen3(
                        loginName: loginName,
                        password: password,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Setup Screen 3 - Nickname Input
class SetupScreen3 extends StatelessWidget {
  final String loginName;
  final String password;

  const SetupScreen3({
    super.key,
    required this.loginName,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final nicknameController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: CommonWidgets.buildAppBar(
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("계정 생성", style: AppStyles.headerStyle),
              const SizedBox(height: AppDimensions.largeSpacing),
              Text("닉네임을 적어주세요", style: AppStyles.subHeaderStyle),
              const SizedBox(height: AppDimensions.mediumSpacing),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBrown,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: TextField(
                  controller: nicknameController,
                  decoration: const InputDecoration(
                    hintText: "활동할 닉네임",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.mediumSpacing,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Spacer(),
              CommonWidgets.buildNextButton(
                onPressed: () {
                  final nickname = nicknameController.text.trim();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetupScreen4(
                        loginName: loginName,
                        password: password,
                        nickname: nickname,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Setup Screen 5 - Registration Complete
class SetupScreen4 extends StatefulWidget {
  final String loginName;
  final String password;
  final String nickname;

  const SetupScreen4({
    super.key,
    required this.loginName,
    required this.password,
    required this.nickname,
  });

  @override
  State<SetupScreen4> createState() => _SetupScreen4State();
}

class _SetupScreen4State extends State<SetupScreen4> {
  bool _isLoading = false;
  bool _isSignupComplete = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleSignUp());
  }

  Future<void> _handleSignUp() async {
    setState(() => _isLoading = true);

    try {
      final result = await GraphQLService.signUp(
        widget.nickname,
        widget.loginName,
        widget.password,
      );

      if (result?['signUp'] != null) {
        final userData = result!['signUp'];
        final userId = userData['id'];
        await GraphQLService.createShelf('default', userId);

        if (mounted) {
          setState(() => _isSignupComplete = true);
          CommonWidgets.showSnackBar(
            context,
            'Welcome ${userData['name']}! Account created successfully.',
          );
        }
      } else {
        if (mounted) {
          CommonWidgets.showSnackBar(
            context,
            'Signup failed. Please try again.',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CommonWidgets.showSnackBar(
          context,
          'Error: ${e.toString()}',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: CommonWidgets.buildAppBar(
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppDimensions.largeSpacing),
              Text(
                "회원가입 완료!",
                textAlign: TextAlign.center,
                style: AppStyles.headerStyle,
              ),
              const SizedBox(height: 20),
              Text(
                "축하합니다!\n이제 당신을 위한\n도서를 찾아보세요",
                textAlign: TextAlign.center,
                style: AppStyles.bodyStyle,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightCream,
                  foregroundColor: Colors.black,
                  minimumSize:
                      const Size(double.infinity, AppDimensions.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.borderRadius),
                  ),
                ),
                child: const Text("시작하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

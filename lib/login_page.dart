import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:horizon_vendor/Controllers/auth_controller.dart';
import 'package:horizon_vendor/Controllers/auth_controller1.dart';
import 'package:horizon_vendor/constants.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading=true;
  final authController = Get.put(AuthController1());
  TextEditingController phonenoController=TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(children: [
        Obx(() => authController.isOtpSent.value
            ? _buildVerifyOtpForm()
            : _buildGetOtpForm())
      ]),
    );
  }

  Widget _buildGetOtpForm() {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  'assets/images/beach.jpg',
                ),
                SizedBox(
                  height: 70,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),

                  ),
                  child: Obx(() => Column(
                    children: [
                      TextFormField(
                        autofillHints: [AutofillHints.telephoneNumberDevice],
                        controller: phonenoController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (val) {
                          authController.phoneNo.value = val;
                          authController.showPrefix.value = val.length > 0;
                        },
                        onSaved: (val) => authController.phoneNo.value = val!,
                        validator: (val) => (val!.isEmpty || val!.length < 10)
                            ? "Enter valid number"
                            : null,
                        decoration: InputDecoration(
                          hintText: "Mobile Number",
                          labelText: "Mobile Number",
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          prefix: authController.showPrefix.value
                              ? Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '(+91)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                              : null,
                          suffixIcon: _buildSuffixIcon(),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final form = _formKey.currentState;
                            if(authController.isLoading.value==false){
                              if (form!.validate()) {
                                form.save();
                                TextInput.finishAutofillContext();
                                authController.getOtp();
                              }
                              setState(() {
                                authController.isLoading.value=true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: authController.isLoading.value==true?Center(child: CircularProgressIndicator(color: Colors.white,),): Text(
                              'Login',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyOtpForm() {

    List<TextEditingController> otpFieldsControler = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController()
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            setState(() {
              authController.isOtpSent.value = false;
            });


          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        title: Text("Sign In",style: TextStyle(
            color: Colors.black
        ),),

      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 10,
              ),
              Center(
                child: Image(
                    height: 150,
                    image: AssetImage('assets/images/beach.jpg')),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Please enter the code",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _textFieldOTP(
                            first: true,
                            last: false,
                            controller: otpFieldsControler[0]),
                        _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpFieldsControler[1]),
                        _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpFieldsControler[2]),
                        _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpFieldsControler[3]),
                        _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpFieldsControler[4]),
                        _textFieldOTP(
                            first: false,
                            last: true,
                            controller: otpFieldsControler[5]),
                      ],
                    ),
                    Text(
                      authController.statusMessage.value,
                      style: TextStyle(
                          color: authController.statusMessageColor.value,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if(authController.isLoading.value==false){
                            setState(() {
                              authController.isLoading.value=true;
                            });
                            authController.otp.value = "";
                            otpFieldsControler.forEach((controller) {
                              authController.otp.value += controller.text;
                            });
                            authController.verifyOTP();
                          }




                        },
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                           backgroundColor:
                               MaterialStateProperty.all<Color>(buttonColor),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                            child: authController.isLoading.value==true?Center(child: CircularProgressIndicator(color: Colors.white,),) :Text(
                            'Verify',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Having Problem?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  Obx(
                        () => TextButton(
                      onPressed: () => authController.resendOTP.value
                          ? authController.resendOtp()
                          : null,
                      child: Text(
                        authController.resendOTP.value
                            ? "Resend New Code"
                            : "Wait ${authController.resendAfter} seconds",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: buttonColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuffixIcon() {
    return AnimatedOpacity(
        opacity: authController.phoneNo?.value.length == 10 ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Icon(Icons.check_circle, color: buttonColor, size: 32));
  }

  Widget _textFieldOTP({bool first = true, last, controller}) {
    var height = (Get.width - 82) / 6;
    return Container(
      height: height,
      child: AspectRatio(
        aspectRatio: 1,
        child: TextField(
          autofocus: true,
          controller: controller,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              Get.focusScope?.nextFocus();
            }
            if (value.length == 0 && first == false) {
              Get.focusScope?.previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: height / 2, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: buttonColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
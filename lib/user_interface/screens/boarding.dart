//@dart = 2.9
import 'package:flutter/material.dart';
import 'package:mmucord/constants.dart';
import 'package:mmucord/states_management/boarding/boarding_cubit.dart';
import 'package:mmucord/states_management/boarding/boarding_state.dart';
import 'package:mmucord/states_management/boarding/profile_image_cubit.dart';
import 'package:mmucord/user_interface/widgets/boarding/logo.dart';

import 'package:mmucord/user_interface/widgets/boarding/profile_upload.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmucord/user_interface/widgets/common/custom_text_field.dart';

import 'boarding_router.dart';

class Boarding extends StatefulWidget {
  final IOnboardingRouter router;
  const Boarding(this.router);

  @override
  _BoardingState createState() => _BoardingState();
}

class _BoardingState extends State<Boarding> {
  String _username = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _logo(context),
            Spacer(),
            ProfileUpload(),
            Spacer(flex: 1),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: CustomTextField(
                placeholder: "MMU ID",
                height: 45.0,
                onchanged: (val) {
                  _username = val;
                },
                inputAction: TextInputAction.done,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: ElevatedButton(
                  onPressed: () async {
                    final error = _checkInputs();
                    if (error.isNotEmpty) {
                      final snackBar = SnackBar(
                        content: Text(
                          error,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    await _connectSession();
                  },
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    child: Text(
                      "Start chatting",
                      style: Theme.of(context).textTheme.button.copyWith(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: kPrimary,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0)))),
            ),
            Spacer(
              flex: 2,
            ),
            BlocConsumer<boardingCubit, boardingState>(
              builder: (context, state) => state is Loading
                  ? Center(child: CircularProgressIndicator())
                  : Container(),
              listener: (_, state) {
                if (state is boardingSuccess)
                  widget.router.onSessionSuccess(context, state.user);
              },
            ),
            Spacer(
              flex: 1,
            )
          ],
        ),
      )),
    );
  }

  _logo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'MMU',
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 8.0,
        ),
        Logo(),
        SizedBox(
          width: 8.0,
        ),
        Text(
          'Cord',
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _checkInputs() {
    var error = '';
    if (_username.isEmpty) error = 'Enter MMU ID';
    if (context.read<ProfileImageCubit>().state == null)
      error = error + '\n' + 'Upload an Image';

    return error;
  }

  _connectSession() async {
    final profileImage = context.read<ProfileImageCubit>().state;
    await context.read<boardingCubit>().connect(_username, profileImage);
  }
}

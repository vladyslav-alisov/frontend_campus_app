import 'dart:io';

import 'package:campus_app/models/notice_board/NoticeBoard.dart';
import 'package:campus_app/models/notice_board/NoticeToSend.dart';
import 'package:campus_app/providers/notice_board_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/CampusTextInputField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum Condition { Edit, Create }

class EditNoticeScreen extends StatefulWidget {
  EditNoticeScreen({this.existingNotice});
  final Notice existingNotice;
  @override
  _EditNoticeScreenState createState() => _EditNoticeScreenState();
}

class _EditNoticeScreenState extends State<EditNoticeScreen> {
  TextEditingController noticeTitleController;
  TextEditingController noticeDescriptionController;
  TextEditingController phoneNumberController;
  TextEditingController emailController;
  Condition condition;
  var picker = ImagePicker();
  File image;
  bool isMutationLoading = false;
  bool isLoading = false;
  bool isImageLoading = false;


  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){

    var userData = Provider.of<AuthProvider>(context, listen: false).authData;
    if (widget.existingNotice != null) {
      noticeTitleController = TextEditingController(text: widget.existingNotice.title);
      noticeDescriptionController = TextEditingController(text: widget.existingNotice.description);
      phoneNumberController = TextEditingController(text: widget.existingNotice.phone);
      emailController = TextEditingController(text: widget.existingNotice.email);
      condition = Condition.Edit;
    } else {
      phoneNumberController = TextEditingController(text: userData.login.phone.toString());
      noticeTitleController = TextEditingController(text: "");
      noticeDescriptionController = TextEditingController(text: "");
      emailController = TextEditingController(text: userData.login.email);
      condition = Condition.Create;
    }
    super.initState();
  }

  void showUploadImage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(AppLocalizations.of(context).translate(str_uploadImageWarn)),
      ),
    );
  }

  void setIsLoading(bool state) {
    setState(() {
      isMutationLoading = state;
    });
  }

  NoticeToSend sendNotice(BuildContext context) {
    NoticeToSend notice = new NoticeToSend(
      title: noticeTitleController.text,
      description: noticeDescriptionController.text,
      image: image,
      phone: phoneNumberController.text,
      email: emailController.text,
    );

    return notice;
  }

  void showImagePicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(AppLocalizations.of(context).translate(str_photoLibrary)),
                    onTap: () {
                      getAndUpdateImage(false);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(AppLocalizations.of(context).translate(str_camera)),
                  onTap: () {
                    getAndUpdateImage(true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getAndUpdateImage(bool choice) async {
    setState(() {
      isImageLoading = true;
    });
    var pickedFile;
    if (choice) {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, maxWidth: 600, maxHeight: 800).catchError((e) => print(e));
          setState(() {
            isImageLoading = false;
          });
      if (pickedFile == null) {
        return;
      }
    } else if (!choice) {
      pickedFile =
          await picker.getImage(source: ImageSource.gallery, maxWidth: 600, maxHeight: 800).catchError((e) => print(e));
      setState(() {
        isImageLoading = false;
      });
      if (pickedFile == null) {
        return;
      }
    }
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var noticeProvider = Provider.of<NoticeBoardProvider>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CampusAppBar(title: condition == Condition.Create ? "Create Post" : "Edit Post"),
      ),
      body: isLoading?Center(child: CircularProgressIndicator(),):Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Text("Post Details"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CampusTextInputField(
                    controller: noticeTitleController,
                    hintText: "Post Title",
                    labelText: "Post Title",
                    rightIcon: IconButton(icon: Icon(Icons.drive_file_rename_outline)),
                    validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CampusTextInputField(
                    controller: noticeDescriptionController,
                    hintText: "Provide information about your post",
                    labelText: "Description",
                    maxLines: 8,
                    validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        border: Border.all(color: Color(0xffE1E1E1))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Text(
                            "${AppLocalizations.of(context).translate(str_chooseAnImage)}:",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          )),
                          isImageLoading?Flexible(child: Center(child: CircularProgressIndicator(),)):Flexible(
                            fit: FlexFit.tight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: GestureDetector(
                                onTap: () => showImagePicker(context),
                                child: image == null && widget.existingNotice == null
                                    ? Image.asset(ConstAssetsPath.img_placeholderImage)
                                    : widget.existingNotice?.imageUrl == null || image != null
                                        ? Image.file(image)
                                        : Image.network(widget.existingNotice?.imageUrl),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Text("Contact Info"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CampusTextInputField(
                    controller: phoneNumberController,
                    hintText: "Enter contact mobile number",
                    labelText: "Phone Number",
                    validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CampusTextInputField(
                    controller: emailController,
                    hintText: "Enter contact email",
                    labelText: "Email",
                    validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isMutationLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setIsLoading(true);
                              if (widget.existingNotice != null) {
                                await CommonController.mutationFuture(
                                    noticeProvider
                                        .editNotice(
                                            noticeID: widget.existingNotice.noticeID, notice: sendNotice(context))
                                        .then((_) {
                                      Navigator.pop(context);
                                    }),
                                    "Post successfully updated",
                                    context);
                              } else {
                                if (image == null) {
                                  showUploadImage(context);
                                } else {
                                  await CommonController.mutationFuture(
                                          noticeProvider.createNotice(sendNotice(context)).then((_) {
                                            Navigator.pop(context);
                                          }),
                                          "Post created successfully",
                                          context)
                                      .catchError((e) => print(e));
                                }
                              }
                              setIsLoading(false);
                            }
                          },
                          child: Text(describeEnum(condition)),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

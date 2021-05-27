import 'package:campus_app/models/social_clubs/SocialClubList.dart';
import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/social_club_screen_controllers/social_club_manage_screen_controller.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/CampusTextInputField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatelessWidget {

  AddPostScreen(this.socialClub);

  final SocialClub socialClub;
  @override
  Widget build(BuildContext context) {
    var socialClubProvider = Provider.of<SocialClubProvider>(context);
    var screenController = Provider.of<SocialClubManageScreenController>(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            AppBar().preferredSize.height + 20,
          ),
          child: CampusAppBar(
            title: "Add a Photo",
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CampusTextInputField(
                controller: screenController.descriptionController,
                hintText: AppLocalizations.of(context).translate(str_enterDescription),
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
                      Flexible(
                        fit: FlexFit.tight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: GestureDetector(
                              onTap: () => screenController.showImagePicker(context),
                              child: screenController.image == null
                                  ? Image.asset(ConstAssetsPath.img_placeHolder)
                                  : Image.file(screenController.image)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: screenController.isLoading
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
                          screenController.setIsLoading(true);
                          if (screenController.image == null) {
                            screenController.showUploadImage(context);
                          } else {
                            await CommonController.mutationFuture(
                                    socialClubProvider
                                        .uploadPost(socialClub.scID, socialClub.scoID, screenController.image,
                                            screenController.descriptionController.text)
                                        .then((_) {
                                      Navigator.pop(context);
                                    }),
                                   "Photo has been successfully added",
                                    context)
                                .catchError((e) => print(e));
                          }

                          screenController.setIsLoading(false);
                      },
                      child: Text("Dwd"),
                    ),
            ),
          ],
        ));
  }
}

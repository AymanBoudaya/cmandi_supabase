import 'package:caferesto/common/widgets/images/circular_image.dart';
import 'package:caferesto/common/widgets/texts/section_heading.dart';
import 'package:caferesto/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/user_controller.dart';
import 'widgets/change_name.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
        appBar: TAppBar(
          showBackArrow: true,
          title: Text('Mon Profil'),
        ),

        /// Body
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(AppSizes.defaultSpace),
                child: Column(
                  children: [
                    /// Profile Picture
                    SizedBox(
                      width: double.infinity,
                      child: Column(children: [
                        const CircularImage(
                          image: TImages.user,
                          width: 80,
                          height: 80,
                        ),
                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Modifier la photo de profil',
                            ))
                      ]),
                    ),

                    /// Détails
                    const SizedBox(height: AppSizes.spaceBtwItems / 2),
                    const Divider(),
                    const SizedBox(height: AppSizes.spaceBtwItems),
                    const TSectionHeading(
                        title: 'Informations du profil',
                        showActionButton: false),
                    const SizedBox(height: AppSizes.spaceBtwItems),

                    TProfileMenu(
                        title: "Nom",
                        value: controller.user.value.fullName,
                        onPressed: () => Get.to(() => ChangeName())),
                    TProfileMenu(
                        title: "Nom d'utilisateur",
                        value: controller.user.value.username,
                        onPressed: () {}),

                    const SizedBox(height: AppSizes.spaceBtwItems),
                    const Divider(),
                    const SizedBox(height: AppSizes.spaceBtwItems),

                    /// Heading Personal Info
                    const TSectionHeading(
                        title: 'Infos personnelles', showActionButton: false),
                    const SizedBox(height: AppSizes.spaceBtwItems),

                    TProfileMenu(
                        title: "ID utilisateur",
                        value: controller.user.value.id,
                        icon: Iconsax.copy,
                        onPressed: () {}),
                    TProfileMenu(
                        title: "E-mail",
                        value: controller.user.value.email,
                        onPressed: () {}),
                    TProfileMenu(
                        title: "Téléphone",
                        value: controller.user.value.phoneNumber,
                        onPressed: () {}),
                    TProfileMenu(
                        title: "Sexe", value: "Male", onPressed: () {}),
                    TProfileMenu(
                        title: "Date de naissance",
                        value: "10 Oct 1988",
                        onPressed: () {}),
                    const Divider(),
                    const SizedBox(height: AppSizes.spaceBtwItems),

                    Center(
                      child: TextButton(
                          onPressed: () => {}
                          //controller.deleteAccountWarningPopup()
                          ,
                          child: const Text(
                            'Fermer le compte',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )),
                    )
                  ],
                ))));
  }
}

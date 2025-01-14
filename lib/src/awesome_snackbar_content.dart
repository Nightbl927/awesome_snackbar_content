import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:awesome_snackbar_content/src/assets_path.dart';
import 'package:awesome_snackbar_content/src/content_type.dart';

class AwesomeSnackbarContent extends StatelessWidget {
  /// `IMPORTANT NOTE` for SnackBar properties before putting this in `content`
  /// backgroundColor: Colors.transparent
  /// behavior: SnackBarBehavior.floating
  /// elevation: 0.0

  /// /// `IMPORTANT NOTE` for MaterialBanner properties before putting this in `content`
  /// backgroundColor: Colors.transparent
  /// forceActionsBelow: true,
  /// elevation: 0.0
  /// [inMaterialBanner = true]

  /// title is the header String that will show on top
  final String title;

  /// message String is the body message which shows only 2 lines at max
  final String message;

  /// `optional` color of the SnackBar/MaterialBanner body
  final Color? color;

  /// contentType will reflect the overall theme of SnackBar/MaterialBanner: failure, success, help, warning
  final ContentType contentType;

  /// if you want to use this in materialBanner
  final bool inMaterialBanner;

  // if you have an action
  final void Function()? action;

  // action label
  final String actionLabel;

  const AwesomeSnackbarContent({
    Key? key,
    this.color,
    required this.title,
    required this.message,
    required this.contentType,
    this.inMaterialBanner = false,
    this.action,
    this.actionLabel = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // screen dimensions
    bool isMobile = size.width <= 768;
    bool isTablet = size.width > 768 && size.width <= 992;
    bool isDesktop = size.width >= 992;

    /// For reflecting different color shades in the SnackBar
    final hsl = HSLColor.fromColor(color ?? contentType.color!);
    final hslDark = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));

    return Row(
      children: [
        isMobile ? SizedBox(
          width: size.width * 0.0,
        ) : isTablet ? SizedBox(
          width: size.width * 0.05,
        ) : SizedBox(
          width: size.width * 0.10,
        ),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              /// SnackBar Body
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: !isMobile ? size.height * 0.03 : size.height * 0.025,
                ),
                decoration: BoxDecoration(
                  color: color ?? contentType.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(size.height * 0.08, 0.0, 16.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// `title` parameter
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: isTablet || isDesktop
                                          ? 20.0
                                          : 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                InkWell(
                                  onTap: () {
                                    if (inMaterialBanner) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentMaterialBanner();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    AssetsPath.failure,
                                    height: size.height * 0.022,
                                    package: 'awesome_snackbar_content',
                                  ),
                                ),
                              ],
                            ),

                            /// `message` body text parameter
                            /// Trung updated to add more space between title and message
                            actionLabel == "" || action == null ? Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                message,
                                style: TextStyle(
                                  fontSize: size.height * 0.016,
                                  color: Colors.white,
                                ),
                              ),
                            ) : Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message,
                                    style: TextStyle(
                                      fontSize: size.height * 0.016,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: StadiumBorder(),
                                        side: BorderSide(
                                          width: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: action != null ? action! : () {print('no action provided');},
                                      child: Text(
                                        actionLabel,
                                        style: TextStyle(
                                          fontSize: size.height * 0.016,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// other SVGs in body
              Positioned(
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                  child: SvgPicture.asset(
                    AssetsPath.bubbles,
                    height: size.height * 0.06,
                    width: size.width * 0.05,
                    color: hslDark.toColor(),
                    package: 'awesome_snackbar_content',
                  ),
                ),
              ),

              Positioned(
                top: -size.height * 0.02,
                left: size.width * 0.02,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      AssetsPath.back,
                      height: size.height * 0.06,
                      color: hslDark.toColor(),
                      package: 'awesome_snackbar_content',
                    ),
                    Positioned(
                      top: size.height * 0.015,
                      child: SvgPicture.asset(
                        assetSVG(contentType),
                        height: size.height * 0.022,
                        package: 'awesome_snackbar_content',
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        isMobile ? SizedBox(
          width: size.width * 0.0,
        ) : isTablet ? SizedBox(
          width: size.width * 0.05,
        ) : SizedBox(
          width: size.width * 0.10,
        ),
      ],
    );
  }

  /// Reflecting proper icon based on the contentType
  String assetSVG(ContentType contentType) {
    if (contentType == ContentType.failure) {
      /// failure will show `CROSS`
      return AssetsPath.failure;
    } else if (contentType == ContentType.success) {
      /// success will show `CHECK`
      return AssetsPath.success;
    } else if (contentType == ContentType.warning) {
      /// warning will show `EXCLAMATION`
      return AssetsPath.warning;
    } else if (contentType == ContentType.help) {
      /// help will show `QUESTION MARK`
      return AssetsPath.help;
    } else {
      return AssetsPath.failure;
    }
  }
}

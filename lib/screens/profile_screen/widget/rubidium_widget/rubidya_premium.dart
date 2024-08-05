import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/premium_inner_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../navigation/bottom_navigation.dart';
import '../../../../services/profile_service.dart';
import '../../../../support/logger.dart';

class premiumpage extends StatefulWidget {
  const premiumpage({super.key});

  @override
  State<premiumpage> createState() => _premiumpageState();
}

class _premiumpageState extends State<premiumpage> {
  var userid;

  String? uniqueId;
  String? amount;
  String? currency;
  String? payId;

  var packages;

  var profiledetails;
  bool isLoading = false;
  bool _isLoading = true;

  String deductedAmount = '';
  String deductedmsg = '';
  late Map<String, dynamic> profileDetails;

  Future _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profileDetails = response['user'];
    });
  }

  Future peremiumapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getpackage();
    log.i('packages show....... $response');
    setState(() {
      packages = response;
    });
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _profiledetailsapi(),
        peremiumapi(),

        // deductbalance()
      ],
    );
    _isLoading = false;
  }

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: bluetext,
        title: Text(
          "Rubidya Premium",
          style: TextStyle(fontSize: 14, color: white),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 6.0,
                valueColor: AlwaysStoppedAnimation(yellow),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Added this line
                children: [
                  Text(
                    "Get premium today",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: white),
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  Container(
                    height: 46,
                    width: 157,
                    decoration: BoxDecoration(
                        color: gradnew,
                        border: Border.all(color: white, width: .3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/whitelogorubidia.svg',
                          fit: BoxFit.scaleDown,
                        ),
                        SvgPicture.asset(
                          'assets/svg/logoyellowrubidia.svg',
                          fit: BoxFit.scaleDown,
                        ),
                        SvgPicture.asset(
                          'assets/svg/logogoldrubidia.svg',
                          fit: BoxFit.scaleDown,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    "Rubideum Premium Account Activation",
                    style: TextStyle(fontSize: 16, color: white),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "If you debit coins from Rubideum account after verified you\nwill be credited back within 48 hours.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Other widgets...
                  packages != null && packages['packages'] != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: packages['packages'].length,
                          itemBuilder: (BuildContext context, int index) {
                            final packageName =
                                packages['packages'][index]['packageName'];
                            final amount = packages['packages'][index]['amount']
                                .toString();
                            final List<String> benefits = List<String>.from(
                                packages['packages'][index]['benefits']);
                            final slug =
                                packages['packages'][index]['packageSlug'];

                            return PremiumListing(
                              id: packages['packages'][index]['_id'],
                              amount: amount,
                              packageName: packageName,
                              benefits: benefits,
                              slug: slug,
                              profileDetails: profileDetails,
                            );
                          },
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
  }
}

class PremiumListing extends StatelessWidget {
  final String id;
  final String amount;
  final String packageName;
  final List<String> benefits;
  final String slug;
  final Map<String, dynamic> profileDetails;

  PremiumListing({
    required this.id,
    required this.amount,
    required this.packageName,
    required this.benefits,
    required this.slug,
    required this.profileDetails,
  });

  @override
  Widget build(BuildContext context) {
    bool hasSlug = profileDetails['packageName'].contains(slug);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: IgnorePointer(
        ignoring: hasSlug,
        child: InkWell(
          onTap: !hasSlug
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => premiuminnerpage(
                              id: id,
                              packageName: packageName,
                              amount: amount,
                            )),
                  );
                }
              : null,
          child: Stack(
            children: [
              Container(
                height: 445,
                width: 354,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _getContainerGradientColor(slug),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                packageName,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: _getMembershipColor(packageName),
                                ),
                              ),
                              Text(
                                amount,
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              benefits.join('\n\n'),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(
                    //   height: 10,
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Container(
                        height: 35,
                        width: 400,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [g1button, g2button],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            "Choose Your Plan",
                            style: TextStyle(color: white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/svg/whiteshape.svg',
                  fit: BoxFit.scaleDown,
                ),
              ),
              Positioned(
                top: 40,
                right: 0,
                child: Image.asset(
                  'assets/image/wave.png',
                  height: 370,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getContainerGradientColor(String slug) {
    if (profileDetails['packageName'].contains(slug)) {
      return [white1, greybg]; // Gradient for premium package
    } else {
      return [premiumcard1, premiumcard2]; // Default gradient
    }
  }

  Color _getMembershipColor(String packageName) {
    // Map membership types to colors
    Map<String, Color> membershipColors = {
      'ROYAL MEMBERSHIP': Colors.white,
      'PRIME MEMBERSHIP': golden,
      'GOLDEN MEMBERSHIP': yellow,
    };

    // Return color based on membership type
    return membershipColors.containsKey(packageName)
        ? membershipColors[packageName]!
        : Colors.white; // Default color if membership type is not found
  }
}

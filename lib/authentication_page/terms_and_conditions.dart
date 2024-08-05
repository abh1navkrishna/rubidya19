import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          centerTitle: true,
          title: const Text(
            textAlign: TextAlign.justify,
            'Terms and Conditions',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(30, 49, 103, 1)),
          ),

        ),
        body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35,),
                  Text(
                      textAlign: TextAlign.justify,'1. Introduction',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      'Welcome to Rubidya, a crypto integrated social media platform owned and operated by Hyberbole Marketing Pvt Ltd ("Hyberbole Marketing", "we", "our", or "us"). By accessing or using Rubidya, you ("user", "you", "your") agree to comply with and be bound by these Terms and Conditions ("Terms"), along with our Privacy Policy and Community Guidelines. These documents govern your use of our platform and constitute a legally binding agreement between you and Hyberbole Marketing Pvt Ltd. If you do not agree with any part of these Terms, you must not use Rubidya. Rubidya aims to provide a unique and engaging social media experience by integrating cryptocurrency elements, allowing users to interact, share content, and potentially earn through their engagement on the platform. By joining Rubidya, you become part of a global community, and your adherence to these Terms ensures a safe and respectful environment for everyone.',
                      style: TextStyle(

                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'2. User Accounts',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      '  2.1 Registration: To access the features and services offered by Rubidya, you must create a user account. During the registration process, you will be required to provide accurate, complete, and up-to-date information. This includes, but is not limited to, your name, email address, date of birth, and any other information deemed necessary by Rubidya. 2.2 Account Security: You are responsible for maintaining the confidentiality of your account credentials, including your password. You must immediately notify Rubidya of any unauthorized use of your account or any other breach of security. Rubidya will not be liable for any loss or damage arising from your failure to protect your account information. It is recommended to use a strong and unique password and to change your password periodically. 2.3 Accurate Information: You agree to provide true, accurate, and current information during registration and to update your information as necessary to keep it accurate. Providing false information or impersonating another person or entity may result in the suspension or termination of your account and could lead to legal action. 2.4 Multiple Accounts: Users are allowed to create only one account. Creating multiple accounts to manipulate the platform\'s features or for any other deceptive purpose is strictly prohibited and will result in the termination of all associated accounts. 2.5 Age Restriction: By registering for an account, you affirm that you are at least 13 years of age. If you are under 18, you must have your parent or guardian\'s permission to use the platform and agree to be supervised by them in your activities on Rubidya.',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),


                  Text(
                      textAlign: TextAlign.justify,'3. Content',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' 3.1 Ownership: As a user, you retain ownership of the content you create and post on Rubidya. However, by posting content, you grant Rubidya a worldwide, non-exclusive, royalty-free, transferable, sublicensable license to use, display, distribute, and modify your content as necessary for the operation of the platform. This license allows Rubidya to show your content to other users and promote it through various channels. 3.2 Prohibited Content: You agree not to post content that is illegal, harmful, offensive, or violates the rights of others. This includes, but is not limited to, content that is defamatory, obscene, pornographic, violent, hateful, discriminatory, or that promotes illegal activities. Content that includes threats, harassment, or personal attacks is also prohibited. 3.3 Content Moderation: Rubidya reserves the right to remove or modify any content that violates these Terms or is deemed inappropriate at its sole discretion. Users can report content that they believe violates these Terms, and Rubidya will review such reports promptly. Repeated violations may result in the suspension or termination of the offending user\'s account. 3.4 User Responsibility: You are solely responsible for the content you post on Rubidya. You agree that any content you upload, share, or otherwise make available through the platform does not infringe on any third party\'s rights, including intellectual property rights, privacy rights, or any other proprietary rights. 3.5 Content Backup: While Rubidya strives to provide reliable and secure services, we do not guarantee that your content will always be available. Users are responsible for backing up their content. Rubidya will not be liable for any loss of data.'
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'4. Privacy',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' 4.1 Data Collection: Rubidya collects and uses personal data in accordance with its Privacy Policy. By using Rubidya, you consent to the collection, use, and sharing of your information as described in the Privacy Policy. This may include information you provide during registration, content you post, and your interactions on the platform. 4.2 Privacy Settings: Users have control over the visibility of their information through privacy settings available on their account. You can adjust these settings to determine what information is shared with other users and the public. Options may include controlling who can view your profile, posts, and contact you. 4.3 Third-Party Access: Rubidya may share user data with third-party service providers to enhance the platform\'s functionality and user experience. These third parties are bound by confidentiality agreements and are prohibited from using your data for any other purpose. Rubidya will not sell your personal information to third parties without your consent. 4.4 Data Security: Rubidya implements reasonable security measures to protect your data from unauthorized access, alteration, disclosure, or destruction. However, no internet-based platform can be completely secure, and Rubidya cannot guarantee the absolute security of your data. Users are encouraged to take steps to protect their information, such as using strong passwords and enabling two-factor authentication. ',style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'5. Intellectual Propert',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' 5.1 Respect for IP: Rubidya respects intellectual property rights and expects users to do the same. You must not post content that infringes upon the copyrights, trademarks, or other intellectual property rights of others. If you do, you may be held legally responsible for such actions. 5.2 User Responsibility: If you believe your intellectual property rights have been infringed upon, you may contact Rubidya\'s support team with a detailed description of the alleged infringement. Rubidya will take appropriate action to address any verified infringement claims, which may include removing the infringing content and taking action against the offending user. 5.3 Rubidya\'s IP: All elements of the Rubidya platform, including but not limited to its design, features, functionality, software, text, graphics, logos, and trademarks, are the property of Hyberbole Marketing Pvt Ltd and are protected by copyright, trademark, and other intellectual property laws. Unauthorized use of Rubidya \'s intellectual property is strictly prohibited. 5.4 User Contributions: By submitting any feedback, suggestions, or ideas to Rubidya regarding the platform, you agree that Rubidya may use such contributions for any purpose without any obligation to compensate you. Rubidya reserves the right to incorporate such feedback into the platform and to benefit from it commercially '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'6. Community Guidelines',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' 6.1 Conduct: Users are expected to engage in respectful and constructive interactions on Rubidya. Harassment, bullying, and abusive behavior are strictly prohibited. You agree to abide by the Community Guidelines, which outline acceptable behavior and content standards. Violations of these guidelines may result in disciplinary action, including suspension or termination of your account. 6.2 Reporting: Users are encouraged to report any abusive or inappropriate behavior they encounter on the platform. Rubidya is committed to maintaining a safe and welcoming environment and will take necessary action against violators. Reports will be reviewed promptly, and appropriate action will be taken based on the severity of the violation. 6.3 Enforcement: Rubidya reserves the right to suspend or terminate the accounts of users who violate the Community Guidelines. Repeated violations or severe misconduct may result in permanent bans from the platform. Rubidya may also take legal action against users who engage in illegal activities or severe violations. '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'7. Liability',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' 7.1 User Content: Rubidya and Hyberbole Marketing Pvt Ltd are not responsible for usergenerated content. You acknowledge that all content posted on the platform is the sole responsibility of the user who posted it. Rubidya does not endorse, support, represent, or guarantee the completeness, truthfulness, accuracy, or reliability of any content posted by users. 7.2 Indemnity: You agree to indemnify and hold harmless Rubidya and Hyberbole Marketing Pvt Ltd, along with their officers, directors, employees, and agents, from any claims, damages, or expenses (including legal fees) arising from your use of the platform, your violation of these Terms, or your infringement of any rights of another. 7.3 Limitation of Liability: To the fullest extent permitted by law, Rubidya and Hyberbole Marketing Pvt Ltd shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses, resulting from (a) your use or inability to use the platform; (b) any unauthorized access to or use of our servers and/or any personal information stored therein; (c) any interruption or cessation of transmission to or from the platform; (d) any bugs, viruses, trojan horses, or the like that may be transmitted to or through our platform by any third party; (e) any errors or omissions in any content or for any loss or damage incurred as a result of the use of any content posted, emailed, transmitted, or otherwise made available through the platform; and/or (f) the defamatory, offensive, or illegal conduct of any third party. In no event shall Rubidya\'s aggregate liability for all claims related to the platform exceed the greater of one hundred US dollars (US\$100.00) or the amount you paid Rubidya, if any, in the past twelve months for the services giving rise to the claim. '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'8. Termination',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' 8.1 Rubidya\'s Right to Terminate: Rubidya reserves the right to terminate or suspend your account at any time, with or without notice, for any reason, including but not limited to a violation of these Terms or if Rubidya believes that your actions may cause harm or liability to other users or to Rubidya. Termination of your account will result in the deactivation or deletion of your account and the forfeiture of all content associated with your account. 8.2 User\'s Right to Terminate: You may terminate your account at any time by following the instructions on the platform. Upon termination, you must cease all use of the platform and delete any copies of Rubidya-related content in your possession. 8.3 Effect of Termination: Upon termination of your account, the license granted to Rubidya regarding your content will continue to the extent necessary for Rubidya to enforce its rights and comply with legal obligations. Termination of your account does not relieve you of any obligations to pay any accrued fees or charges. '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),


                  Text(
                      textAlign: TextAlign.justify,'9. Changes to Terms',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' 9.1 Notification: Rubidya may modify these Terms at any time by posting the updated Terms on the platform. Rubidya will notify users of significant changes through the platform or via email. Your continued use of the platform after such modifications have been posted constitutes your acceptance of the revised Terms. 9.2 Review: You are encouraged to review these Terms periodically to stay informed about any changes. If you do not agree with the updated Terms, you must discontinue using the platform. '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'10. Governing Law',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' 10.1 Jurisdiction: These Terms and your use of the Rubidya platform are governed by and construed in accordance with the laws of India. Any disputes arising under or in connection with these Terms shall be subject to the exclusive jurisdiction of the courts located in India. 10.2 Dispute Resolution: In the event of any dispute, claim, or controversy arising out of or relating to these Terms or the use of the platform, the parties agree to first attempt to resolve the matter through good faith negotiations. If the dispute cannot be resolved through negotiations, it shall be resolved by binding arbitration in accordance with the Arbitration and Conciliation Act, 1996, of India. The arbitration shall be conducted in English, and the place of arbitration shall be in India. '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'11. Revenue Sharing',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' 11.1 Revenue Sources: Rubidya may generate revenue through advertisements, subscriptions, and other means. As part of our commitment to providing value to our users, we share a portion of this revenue with users who contribute to the platform\'s growth and engagement. 11.2 Eligibility: To participate in Rubidya\'s revenue-sharing program, you must comply with user conduct guidelines, maintain an active account in good standing, and meet any additional eligibility criteria specified by Rubidya. Ineligible users will not receive revenue shares, and Rubidya reserves the right to withhold or revoke payouts in cases of suspected fraud or violation of these Terms. 11.3 Payouts: Revenue shares will be distributed to eligible users in the form of cryptocurrency. The specific cryptocurrency and payout schedule will be determined at Rubidya\'s discretion. Users are responsible for providing accurate wallet addresses and ensuring they comply with any legal requirements related to receiving cryptocurrency payments. 11.4 Taxes: Users are responsible for reporting and paying any taxes associated with their earnings from Rubidya. Rubidya is not responsible for withholding any taxes or providing tax advice. Users should consult with a tax professional to understand their tax obligations. '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'12. Miscellaneous',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' 12.1 Entire Agreement: These Terms, along with the Privacy Policy and Community Guidelines, constitute the entire agreement between you and Rubidya regarding your use of the platform and supersede any prior agreements or understandings, whether written or oral. 12.2 Severability: If any provision of these Terms is found to be invalid or unenforceable, that provision shall be enforced to the maximum extent possible, and the remaining provisions shall remain in full force and effect. 12.3 Waiver: No waiver of any term or condition shall be deemed a further or continuing waiver of such term or condition or any other term or condition, and Rubidya\'s failure to assert any right or provision under these Terms shall not constitute a waiver of such right or provision. 12.4 Assignment: You may not assign or transfer these Terms or your rights and obligations hereunder, in whole or in part, without Rubidya\'s written consent. Rubidya may assign or transfer these Terms at any time without restriction. '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'13. Contact Information',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' For any inquiries, concerns, or assistance, you can contact Rubidya\'s support team through the contact information provided on the platform. Rubidya is committed to addressing user concerns promptly and effectively. '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),


                  Text(
                      textAlign: TextAlign.justify,'14. Consent to Electronic Communications',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' By using the Rubidya platform, you consent to receiving electronic communications from Rubidya. These communications may include notices about your account, updates to these Terms, and other information related to your use of the platform. You agree that any notices, agreements, disclosures, or other communications that Rubidya sends to you electronically will satisfy any legal communication requirements, including that such communications be in writing. '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'15. User Feedback',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' Rubidya values user feedback and welcomes suggestions for improvements to the platform. By submitting feedback, you grant Rubidya the right to use and incorporate your suggestions without any obligation to compensate you. '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'16. Force Majeure',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' Rubidya shall not be liable for any failure to perform its obligations under these Terms due to circumstances beyond its reasonable control, including but not limited to acts of God, natural disasters, war, terrorism, labor disputes, and governmental actions. '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),


                  Text(
                      textAlign: TextAlign.justify,'17. Third-Party Links and Services',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' The Rubidya platform may contain links to third-party websites or services that are not owned or controlled by Rubidya. Rubidya is not responsible for the content, privacy policies, or practices of any third-party websites or services. You acknowledge and agree that Rubidya shall not be liable for any damages or losses arising from your use of any third-party websites or services. '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'18. Advertisements',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' Rubidya may display advertisements on the platform. These advertisements may be targeted based on user activity, interests, and other information. By using the platform, you agree to the display of advertisements and the collection and use of data for ad targeting purposes as described in the Privacy Policy '
                      ,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'19. Mobile Application',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' If you access Rubidya through a mobile application, you agree that all the Terms and Conditions herein apply to your use of the mobile application. Additionally, you agree to comply with any applicable terms of service of the app store or platform from which you downloaded the Rubidya mobile application. ',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),


                  Text(
                      textAlign: TextAlign.justify,'20. Data Retention',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' Rubidya will retain your data for as long as necessary to provide you with the services and as required to comply with legal obligations, resolve disputes, and enforce agreements. The specific retention period may vary based on the type of data and the purposes for which it is collected. ',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  Text(
                      textAlign: TextAlign.justify,'21. Prohibited Uses',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 49, 103, 1))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      textAlign: TextAlign.justify,
                      ' In addition to other prohibitions as set forth in these Terms, you are prohibited from using the platform or its content for any of the following purposes: 1. Unlawful Activities: Engaging in any activities that are illegal or unlawful. This includes, but is not limited to, activities such as fraud, money laundering, drug trafficking, or any other activity that is prohibited by law. 2. Solicitation of Unlawful Acts: Encouraging, soliciting, or coercing others to perform or participate in any illegal or unlawful activities. This includes attempts to involve others in fraudulent schemes, illegal trade, or any other criminal activities. 3. Violation of Regulations: Breaching any international, federal, provincial, or state regulations, rules, laws, or local ordinances. This includes non-compliance with industry regulations, governmental laws, and ordinances that govern your conduct online and offline. 4. Intellectual Property Infringement: Infringing upon or violating our intellectual property rights or the intellectual property rights of others. This includes unauthorized use, reproduction, distribution, or display of content that is protected by copyright, trademark, patent, or trade secret laws. 5. Harassment and Discrimination: Harassing, abusing, insulting, harming, defaming, slandering, disparaging, intimidating, or discriminating against others based on gender, sexual orientation, religion, ethnicity, race, age, national origin, or disability. This includes any form of bullying, stalking, hate speech, or harmful conduct that targets individuals or groups. 6. False Information: Submitting false or misleading information. This includes creating fake profiles, impersonating others, or providing inaccurate data with the intent to deceive or mislead other users. 7. Malicious Code: Uploading or transmitting viruses, worms, Trojans, or any other type of malicious code that will or may be used in a way that affects the functionality or operation of the platform, any related website, other websites, or the Internet. This includes any software designed to disrupt, damage, or gain unauthorized access to systems, data, or other information. 8. Personal Information Misuse: Collecting or tracking the personal information of others without their consent. This includes activities such as data mining, unauthorized data collection, or surveillance of users without their knowledge and agreement.\n'
                          '9. Spam and Deceptive Practices: Engaging in spamming, phishing, pharming, pretexting, spidering, crawling, or scraping activities. This includes sending unsolicited messages, creating fake websites or communications to deceive users, and automated processes to extract information from the platform. 10. Obscene or Immoral Purposes: Using the platform for any obscene, lewd, or immoral purposes. This includes sharing or distributing pornography, explicit content, or any material that is offensive or inappropriate. 11. Security Interference: Interfering with or circumventing the security features of the platform, any related website, other websites, or the Internet. This includes attempting to breach security measures, hacking into systems, or exploiting security vulnerabilities to gain unauthorized access. We reserve the right to terminate your use of the platform if you violate any of these prohibited uses. Violations of these terms can result in immediate termination of your account and potential legal action. By using Rubidya, you acknowledge and agree to these comprehensive Terms and Conditions. Your adherence to these guidelines ensures a positive and rewarding experience for all members of the Rubidya community ',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(30, 30, 30, 1))),
                  SizedBox(height: 8,),

                  SizedBox(height: 35,)


                ],
              ),
            )));
  }
}
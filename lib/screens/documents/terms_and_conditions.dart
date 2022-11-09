import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Terms and Conditions",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildArticle(
                "Welcome to Let's Park!\n\nThese terms and conditions outline the rules and regulations for the use of Let's Park!'s Website, located at https://letspark.vercel.app/.\n\nBy accessing this website, we assume you accept these terms and conditions. Do not continue to use Let's Park! if you do not agree to take all of the terms and conditions stated on this page.",
              ),
              const SizedBox(height: 20),
              const Text(
                "License:",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              buildArticle(
                "Unless otherwise stated, Let's Park! and/or its licensors own the intellectual property rights for all material on Let's Park!. All intellectual property rights are reserved. You may access this from Let's Park! for your own personal use subjected to restrictions set in these terms and conditions.\n\nYou must not:",
              ),
              const SizedBox(height: 10),
              buildArticle(
                "• Copy or republish material from Let's Park!\n• Sell, rent, or sub-license material from Let's Park!\n• Reproduce, duplicate or copy material from Let's Park!\n• Redistribute content from Let's Park!",
              ),
              const SizedBox(height: 10),
              buildArticle(
                "This Agreement shall begin on the date hereof.\n\nParts of this website offer users an opportunity to post and exchange opinions and information in certain areas of the website. Let's Park! does not filter, edit, publish or review Comments before their presence on the website. Comments do not reflect the views and opinions of Let's Park!, its agents, and/or affiliates. Comments reflect the views and opinions of the person who posts their views and opinions. To the extent permitted by applicable laws, Let's Park! shall not be liable for the Comments or any liability, damages, or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.",
              ),
              const SizedBox(height: 10),
              buildArticle(
                "Let's Park! reserves the right to monitor all Comments and remove any Comments that can be considered inappropriate, offensive, or causes breach of these Terms and Conditions.\n\nYou warrant and represent that:",
              ),
              const SizedBox(height: 10),
              buildArticle(
                "• You are entitled to post the Comments on our website and have all necessary licenses and consents to do so;\n• The Comments do not invade any intellectual property right, including without limitation copyright, patent, or trademark of any third party;\n• The Comments do not contain any defamatory, libelous, offensive, indecent, or otherwise unlawful material, which is an invasion of privacy.\n• The Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity.",
              ),
              const SizedBox(height: 10),
              buildArticle(
                "You hereby grant Let's Park! a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats, or media",
              ),
              const SizedBox(height: 20),
              const Text(
                "Hyperlinking to our Content:",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              buildArticle(
                "The following organizations may link to our Website without prior written approval:\n\n• Government agencies;\n• Search engines;\n• News organizations;\n• Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses; and\n• System-wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.",
              ),
              const SizedBox(height: 10),
              buildArticle(
                "These organizations may link to our home page, to publications, or to other Website information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement, or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party's site.\n\nWe may consider and approve other link requests from the following types of organizations:",
              ),
              const SizedBox(height: 10),
              buildArticle(
                "• commonly-known consumer and/or business information sources;\n• dot.com community sites;\n• associations or other groups representing charities;\n• online directory distributors;\n• internet portals;\n• accounting, law, and consulting firms; and\n• educational institutions and trade associations.",
              ),
              const SizedBox(height: 10),
              buildArticle(
                "We will approve link requests from these organizations if we decide that: (a) the link would not make us look unfavorably to ourselves or to our accredited businesses; (b) the organization does not have any negative records with us; (c) the benefit to us from the visibility of the hyperlink compensates the absence of Let's Park!; and (d) the link is in the context of general resource information.\n\nThese organizations may link to our home page so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement, or approval of the linking party and its products or services; and (c) fits within the context of the linking party's site.\n\nIf you are one of the organizations listed in paragraph 2 above and are interested in linking to our website, you must inform us by sending an e-mail to Let's Park!. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our Website, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response.\n\nApproved organizations may hyperlink to our Website as follows:",
              ),
              const SizedBox(height: 10),
              buildArticle(
                "• By use of our corporate name; or\n• By use of the uniform resource locator being linked to; or\n• Using any other description of our Website being linked to that makes sense within the context and format of content on the linking party's site.\n\nNo use of Let's Park!'s logo or other artwork will be allowed for linking absent a trademark license agreement.",
              ),
              const SizedBox(height: 20),
              const Text(
                "Content Liability:",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              buildArticle(
                "We shall not be held responsible for any content that appears on your Website. You agree to protect and defend us against all claims that are raised on your Website. No link(s) should appear on any Website that may be interpreted as libelous, obscene, or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.",
              ),
              const SizedBox(height: 20),
              const Text(
                "Reservation of Rights:",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              buildArticle(
                "We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amend these terms and conditions and its linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions.",
              ),
              const SizedBox(height: 20),
              const Text(
                "Reservation of Rights:",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              buildArticle(
                "If you find any link on our Website that is offensive for any reason, you are free to contact and inform us at any moment. We will consider requests to remove links, but we are not obligated to or so or to respond to you directly.\n\nWe do not ensure that the information on this website is correct. We do not warrant its completeness or accuracy, nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.",
              ),
              const SizedBox(height: 20),
              const Text(
                "Disclaimer:",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              buildArticle(
                "To the maximum extent permitted by applicable law, we exclude all representations, warranties, and conditions relating to our website and the use of this website. Nothing in this disclaimer will:\n\n• limit or exclude our or your liability for death or personal injury;\n• limit or exclude our or your liability for fraud or fraudulent misrepresentation;\n• limit any of our or your liabilities in any way that is not permitted under applicable law; or\n• exclude any of our or your liabilities that may not be excluded under applicable law.\n\n\nThe limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort, and for breach of statutory duty.\n\nAs long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildArticle(String article) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            article,
          ),
        ),
      ],
    );
  }

  Widget buildRichTextArticle(
    String articleNumber,
    String articleName,
    String article,
  ) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: articleNumber,
              style: const TextStyle(
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: articleName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: article,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSubRichTextArticle(
    String articleNumber,
    String articleName,
    String article,
  ) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: articleNumber,
              style: const TextStyle(
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: articleName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: article,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSubSubRichTextArticle(
    String articleNumber,
    String articleName,
    String article,
  ) {
    return Row(
      children: [
        const SizedBox(width: 30),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: articleNumber,
              style: const TextStyle(
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: articleName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: article,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

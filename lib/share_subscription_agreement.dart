import 'package:flutter/material.dart';

import 'package:signaturepad/pdf_editor_service.dart';
import 'package:signaturepad/widget/ec_textfield_widget.dart';

import 'widget/share_subscription_form.dart';

class ShareSubscriptionAgreement extends StatefulWidget {
  @override
  State<ShareSubscriptionAgreement> createState() =>
      _ShareSubscriptionAgreementState();
}

class _ShareSubscriptionAgreementState
    extends State<ShareSubscriptionAgreement> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShareSubscriptionForm(),
      ],
    );
  }
}

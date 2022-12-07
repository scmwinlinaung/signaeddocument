import 'package:flutter/material.dart';

import 'package:signaturepad/pdf_editor_service.dart';
import 'package:signaturepad/widget/ec_textfield_widget.dart';
import 'package:signaturepad/widget/share_transfer_agreement_form.dart';

import 'widget/share_subscription_form.dart';

class ShareTransferAgreement extends StatefulWidget {
  @override
  State<ShareTransferAgreement> createState() => _ShareTransferAgreementState();
}

class _ShareTransferAgreementState extends State<ShareTransferAgreement> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShareTransferAgreementForm(),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_checkout_sdk/core_ui/dimensions.dart';
import 'package:unified_checkout_sdk/core_ui/hubtel_colors.dart';
import 'package:unified_checkout_sdk/core_ui/text_style.dart';
import 'package:unified_checkout_sdk/custom_components/custom_indicator.dart';
import 'package:unified_checkout_sdk/resources/checkout_strings.dart';
import 'package:unified_checkout_sdk/utils/currency_formatter.dart';
import 'package:unified_checkout_sdk/utils/custom_expansion_widget.dart'
    as customExpansion;

class HubtelWalletExpansionTile extends StatefulWidget {
  HubtelWalletExpansionTile(
      {Key? key,
      required this.controller,
      required this.onExpansionChanged,
      required this.isSelected,
      required this.value})
      : super(key: key);

  final customExpansion.ExpansionTileController controller;
  final void Function(bool)? onExpansionChanged;
  final bool isSelected;
  final double value;

  @override
  State<HubtelWalletExpansionTile> createState() =>
      _HubtelWalletExpansionTileState();
}

class _HubtelWalletExpansionTileState extends State<HubtelWalletExpansionTile> {
  List<String> bankCardTypeTabNames = [
    CheckoutStrings.useNewCard,
    CheckoutStrings.useSavedCard
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   autoSelectFirstWallet();
  // }

  @override
  Widget build(BuildContext context) {
    return customExpansion.ExpansionTile(
      controller: widget.controller,
      headerBackgroundColor: widget.isSelected
          ? Theme.of(context).primaryColor.withOpacity(0.3)
          : Colors.transparent,
      onExpansionChanged: widget.onExpansionChanged,
      maintainState: true,
      title: Text(
        CheckoutStrings.hubtelBalance,
        style: AppTextStyle.body2(),
      ),
      expandedAlignment: Alignment.topLeft,
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: Dimens.paddingDefault,
        vertical: Dimens.paddingDefault,
      ),
      trailing: Text(
        widget.value.formatMoney(includeDecimals: true),
        style: AppTextStyle.body2().copyWith(
          color: HubtelColors.neutral.shade900,
        ),
      ),
      leading: CustomRadioIndicator(
        isSelected: widget.isSelected,
      ),
      leadingWidth: Dimens.iconMedium,
      titleAlignment: ListTileTitleAlignment.center,
      children: [
        Text(CheckoutStrings.hubtelBalanceInfo),
      ],
    );
  }
}

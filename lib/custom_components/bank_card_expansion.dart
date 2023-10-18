import 'package:flutter/material.dart';
import 'package:unified_checkout_sdk/core_ui/app_image_widget.dart';
import 'package:unified_checkout_sdk/custom_components/bank_card_type_tab.dart';
import 'package:unified_checkout_sdk/custom_components/custom_indicator.dart';
import 'package:unified_checkout_sdk/custom_components/new_bank_card_form.dart';
import 'package:unified_checkout_sdk/custom_components/saved_bank_card_form.dart';
import 'package:unified_checkout_sdk/utils/bank_card_helper.dart';
import 'package:unified_checkout_sdk/utils/custom_expansion_widget.dart'
    as customExpansion;
import 'package:flutter/scheduler.dart';
import 'package:unified_checkout_sdk/core_ui/dimensions.dart';
import 'package:unified_checkout_sdk/core_ui/text_style.dart';
import 'package:unified_checkout_sdk/platform/models/card_data.dart';
import 'package:unified_checkout_sdk/resources/checkout_strings.dart';

// import 'app_image_asset.dart';

class BankCardExpansionTile extends StatefulWidget {
  BankCardExpansionTile({
    Key? key,
    required this.controller,
    required this.onExpansionChanged,
    required this.isSelected,
    required this.onCardSaveChecked,
    required this.savedCardNumberFieldController,
    required this.onNewCardNumberChanged,
    required this.onNewCardDateChanged,
    required this.onNewCardCvvChanged,
    required this.onUseNewCardSelected,
    required this.newCardFormKey,
    required this.savedCards,
    required this.onSavedCardSelected,
    required this.onSavedCardCvvChanged,
    required this.savedCardFormKey,
    required this.cardNumberInputController,
    required this.cardDateInputController,
    required this.cardCvvInputController,
  }) : super(key: key);

  final customExpansion.ExpansionTileController controller;
  final void Function(bool)? onExpansionChanged;
  final bool isSelected;
  final void Function(bool?) onCardSaveChecked;
  final TextEditingController savedCardNumberFieldController;

  final void Function(String)? onNewCardNumberChanged;
  final void Function(String)? onNewCardDateChanged;
  final void Function(String)? onNewCardCvvChanged;

  final List<CardData> savedCards;
  final GlobalKey<FormState> savedCardFormKey;
  final void Function(CardData) onSavedCardSelected;
  final void Function(String)? onSavedCardCvvChanged;
  final GlobalKey<FormState> newCardFormKey;

  final void Function(bool?) onUseNewCardSelected;

  final TextEditingController cardNumberInputController;
  final TextEditingController cardDateInputController;
  final TextEditingController cardCvvInputController;

  @override
  State<BankCardExpansionTile> createState() => _BankCardExpansionTileState();
}

class _BankCardExpansionTileState extends State<BankCardExpansionTile> {
  List<String> bankCardTypeTabNames = [
    CheckoutStrings.useNewCard,
    CheckoutStrings.useSavedCard
  ];

  int selectedTabIndex = 0;

  bool autoSelectionDone = false;

  // @override
  // void initState() {
  //   super.initState();
  //   autoSelectFirstWallet();
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelected) {
      autoSelectFirstWallet();
    }
    return customExpansion.ExpansionTile(
      controller: widget.controller,
      headerBackgroundColor: widget.isSelected
          ? Theme.of(context).primaryColor.withOpacity(0.3)
          : Colors.transparent,
      onExpansionChanged: widget.onExpansionChanged,
      maintainState: true,
      title: Text(
        CheckoutStrings.bankCard,
        style: AppTextStyle.body2(),
      ),
      expandedAlignment: Alignment.topLeft,
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: Dimens.paddingDefault,
        vertical: Dimens.paddingDefault,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImageWidget.local(
            image: const AssetImage(""),
            width: Dimens.iconNormal2,
            height: Dimens.iconSmall,
            boxFit: BoxFit.contain,
            borderRadius: 0,
          ),
          const SizedBox(width: Dimens.paddingDefaultSmall),
          AppImageWidget.local(
            image: const AssetImage(""),
            width: Dimens.iconMedium,
            height: Dimens.iconSmall,
            boxFit: BoxFit.contain,
            borderRadius: 0,
          ),
        ],
      ),
      leading: CustomRadioIndicator(
        isSelected: widget.isSelected,
      ),
      leadingWidth: Dimens.iconMedium,
      titleAlignment: ListTileTitleAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bankCardTypeTabNames
              .asMap()
              .entries
              .map(
                (e) => BankCardTypeTab(
                  tabText: e.value,
                  isSelected: e.key == selectedTabIndex,
                  onTap: () {
                    setState(() {
                      selectedTabIndex = e.key;
                      widget.onUseNewCardSelected(e.key == 0);
                    });
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: Dimens.paddingDefault),
        selectedTabIndex == 0
            ? NewBankCardForm(
                onCardSaveChecked: widget.onCardSaveChecked,
                onNewCardNumberChanged: widget.onNewCardNumberChanged,
                onNewCardDateChanged: widget.onNewCardDateChanged,
                onNewCardCvvChanged: widget.onNewCardCvvChanged,
                formKey: widget.newCardFormKey,
                cardNumberInputController: widget.cardNumberInputController,
                cardDateInputController: widget.cardDateInputController,
                cardCvvInputController: widget.cardCvvInputController,
              )
            : SavedBankCardForm(
                cardNumberFieldController:
                    widget.savedCardNumberFieldController,
                cards: widget.savedCards,
                onCardSelected: widget.onSavedCardSelected,
                onCvvChanged: widget.onSavedCardCvvChanged,
                formKey: widget.savedCardFormKey,
              ),
      ],
    );
  }

  void autoSelectFirstWallet() {
    if (autoSelectionDone) return;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      var firstCard = widget.savedCards.firstOrNull;

      if (firstCard != null) {
        selectedTabIndex = 1;
        widget.onUseNewCardSelected(false);

        widget.savedCardNumberFieldController.text =
            BankCardHelper.formatCardNumber(firstCard.cardNumber ?? "");
        widget.onSavedCardSelected.call(firstCard);
      } else {
        selectedTabIndex = 0;
        widget.onUseNewCardSelected(true);
      }
      autoSelectionDone = true;
    });
  }
}

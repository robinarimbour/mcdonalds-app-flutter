import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mcdonalds_app/models/cart.dart';
import 'package:mcdonalds_app/models/checkout_form.dart';
import 'package:mcdonalds_app/models/transaction.dart';
import 'package:mcdonalds_app/services/cart.dart';
import 'package:mcdonalds_app/widgets/confirm_order.dart';
import 'package:mcdonalds_app/widgets/order_complete.dart';
import 'package:mcdonalds_app/widgets/space_between_text_row.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class Checkout extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalPrice;

  const Checkout(
      {super.key, required this.cartItems, required this.totalPrice});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late double tax;

  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? address;
  String? countryName;
  String? postalCode;
  String? phoneNumber;
  String? creditCardNumber;
  String? securityCode;
  String? expirationDate;

  String? selectedCountryCode;
  final TextEditingController _countryCodeController = TextEditingController();
  String? formattedValue;
  final TextEditingController _creditCardController = TextEditingController();
  String? selectedExpirationDate;
  final TextEditingController _expirationDateController =
      TextEditingController();
  bool _securityCodeVisible = false;

  void _formatCreditCardInput(String value) {
    // Remove all non-digit characters
    String digits = value.replaceAll(RegExp(r'\D'), '');

    // Group digits into XXXX-XXXX-XXXX-XXXX format
    String formatted = '';
    for (int i = 0; i < digits.length; i += 4) {
      if (i + 4 <= digits.length) {
        formatted += '${digits.substring(i, i + 4)}-';
      } else {
        formatted += digits.substring(i);
      }
    }

    // Remove the trailing hyphen if present
    formatted = formatted.endsWith('-')
        ? formatted.substring(0, formatted.length - 1)
        : formatted;

    // Update the TextField value and formatted value
    setState(() {
      _creditCardController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      formattedValue = formatted;
    });
  }

  @override
  void initState() {
    super.initState();
    tax = getTax(widget.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.0,
              children: [
                Text('1. Personal Information',
                    style: TextTheme.of(context)
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      labelText: 'First Name *', hintText: 'John'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }

                    final regex = RegExp(r'^[A-Za-z\s]*$');
                    if (!regex.hasMatch(value)) {
                      return 'Must be alphabets';
                    }

                    return null;
                  },
                  onSaved: (String? value) {
                    firstName = value;
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      labelText: 'Last Name *', hintText: 'Doe'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }

                    final regex = RegExp(r'^[A-Za-z\s]*$');
                    if (!regex.hasMatch(value)) {
                      return 'Must be alphabets';
                    }

                    return null;
                  },
                  onSaved: (String? value) {
                    lastName = value;
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      labelText: 'Address *',
                      hintText: '55 AI Henderson Drive, Virginia Beach, VA'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }

                    return null;
                  },
                  onSaved: (String? value) {
                    address = value;
                  },
                ),
                TextFormField(
                  controller: _countryCodeController,
                  readOnly: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: 'Choose Country *',
                      suffixIcon: Icon(Icons.expand_more)),
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      countryFilter: ['AU', 'GY', 'US'],
                      onSelect: (Country country) {
                        setState(() {
                          selectedCountryCode =
                              '${country.flagEmoji} ${country.name}';
                          _countryCodeController.text = selectedCountryCode!;
                          countryName = country.name;
                        });
                      },
                    );
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      labelText: 'Postal Code *', hintText: '32929'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }

                    final regex = RegExp(r'^\d+$');
                    if (!regex.hasMatch(value)) {
                      return 'Must be digits';
                    }

                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'\d')),
                  ],
                  onSaved: (String? value) {
                    postalCode = value;
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      labelText: 'Phone Number *', hintText: '2123456789'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }

                    final regex = RegExp(r'^\d+$');
                    if (!regex.hasMatch(value)) {
                      return 'Must be digits';
                    }

                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'\d')),
                  ],
                  onSaved: (String? value) {
                    phoneNumber = value;
                  },
                ),
                SizedBox(height: 8.0),
                Text('2. Payment Details',
                    style: TextTheme.of(context)
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _creditCardController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 19,
                  decoration: const InputDecoration(
                      labelText: 'Credit Card Number *',
                      hintText: 'XXXX-XXXX-XXXX-XXXX'),
                  onChanged: _formatCreditCardInput,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }

                    // final regex = RegExp(r'^\d{4}-\d{4}-\d{4}-\d{4}$');
                    // if (!regex.hasMatch(value)) {
                    //   return 'Invalid format';
                    // }

                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[\d\-]')),
                  ],
                  onSaved: (String? value) {
                    creditCardNumber = value;
                  },
                ),
                TextFormField(
                  obscureText: !_securityCodeVisible,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 3,
                  decoration: InputDecoration(
                      labelText: 'Security Code *',
                      hintText: '123',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _securityCodeVisible = !_securityCodeVisible;
                          });
                        },
                        icon: (_securityCodeVisible)
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent),
                      )),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }

                    final regex = RegExp(r'^\d{3}$');
                    if (!regex.hasMatch(value)) {
                      return 'Must be 3 digits';
                    }

                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'\d')),
                  ],
                  onSaved: (String? value) {
                    securityCode = value;
                  },
                ),
                TextFormField(
                  controller: _expirationDateController,
                  readOnly: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: 'Expiration Date *',
                      suffixIcon: Icon(Icons.calendar_month)),
                  onTap: () {
                    showMonthPicker(
                            context: context,
                            initialDate: DateTime.now(),
                            selectableMonthPredicate: (DateTime val) => val
                                .isAfter(DateTime.now().subtract(
                                    Duration(days: 30))),
                            monthPickerDialogSettings:
                                MonthPickerDialogSettings(
                                    dialogSettings:
                                        PickerDialogSettings(
                                            dialogRoundedCornersRadius: 10.0),
                                    dateButtonsSettings:
                                        PickerDateButtonsSettings(
                                            selectedMonthBackgroundColor:
                                                Theme.of(context)
                                                    .primaryColor)))
                        .then((date) {
                      if (date != null) {
                        setState(() {
                          selectedExpirationDate =
                              DateFormat('MM/yy').format(date);
                          _expirationDateController.text =
                              selectedExpirationDate!;
                          expirationDate = selectedExpirationDate;
                        });
                      }
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }

                    final regex = RegExp(r'^\d{2}/\d{2}$');
                    if (!regex.hasMatch(value)) {
                      return 'Invalid Format';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                Text('Your Order',
                    style: TextTheme.of(context)
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                Column(
                    children: List.generate(
                        widget.cartItems.length,
                        (index) => SpaceBetweenTextRow(
                            label:
                                '${widget.cartItems[index].product.name!} (${widget.cartItems[index].quantity})',
                            value:
                                '\$ ${getSubTotal(widget.cartItems[index].product.price!, widget.cartItems[index].quantity).toStringAsFixed(2)}'))),
                ListBody(
                  children: [
                    SpaceBetweenTextRow(
                        label: 'Total Purchase',
                        value:
                            '\$ ${(widget.totalPrice).toDouble().toStringAsFixed(2)}'),
                    SpaceBetweenTextRow(
                        label: 'Estimated Tax',
                        value: '\$ ${tax.toStringAsFixed(2)}'),
                  ],
                ),
                SpaceBetweenTextRow(
                    label: 'Total',
                    value:
                        '\$ ${getTotal(widget.totalPrice).toStringAsFixed(2)}'),
                ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      CheckoutForm checkoutForm = CheckoutForm(
                          firstName: firstName!,
                          lastName: lastName!,
                          address: address!,
                          country: countryName!,
                          postalCode: postalCode!,
                          phone: phoneNumber!,
                          creditCard: creditCardNumber!,
                          code: securityCode!,
                          expiry: expirationDate!);
                      final result = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmOrder(
                                cartItems: widget.cartItems,
                                totalPrice: widget.totalPrice,
                                tax: tax,
                                checkoutForm: checkoutForm);
                          });

                      if (!context.mounted) {
                        return;
                      }

                      if (result == true) {
                        Transaction transaction = Transaction(
                            cartItems: widget.cartItems,
                            tax: tax,
                            totalPrice: widget.totalPrice,
                            checkoutForm: checkoutForm);
                        showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) => PopScope(
                                  canPop: false,
                                  child: OrderComplete(
                                    transaction: transaction,
                                    onApiCallComplete: (bool success) {
                                      if (success) {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                                'Transaction complete. Have a happy meal.'),
                                            duration: Duration(seconds: 5),
                                          ),
                                        );
                                      } else {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                'Transaction failed. Please try again.'),
                                            duration: Duration(seconds: 5),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ));
                      }
                    }
                  },
                  child: const Text('Confirm Order'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

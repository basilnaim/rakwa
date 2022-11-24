import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/coupon.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/screens/coupon/create/components/date%20picker.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/listing_spinner.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/my_text_field_normal.dart';

class CreateCouponScreen extends StatefulWidget {
  Coupon coupon;

  CreateCouponScreen({Key? key, required this.coupon}) : super(key: key);

  @override
  State<CreateCouponScreen> createState() => _CreateCouponScreenState();
}

class _CreateCouponScreenState extends State<CreateCouponScreen> {
  GlobalKey<ProgressingButtonState> progressingButton =
      GlobalKey<ProgressingButtonState>();

  static ValueNotifier<List<Listing>> myListings =
      ValueNotifier<List<Listing>>([]);

  bool progressing = true;

  final GlobalKey<FormFieldState> _titleFieldForm = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _codeFieldForm = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _descriptionFieldForm =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _discountFieldForm =
      GlobalKey<FormFieldState>();

  final GlobalKey<DatePickerScreenState> _startFieldForm = GlobalKey();
  final GlobalKey<DatePickerScreenState> _endFieldForm = GlobalKey();

  loading(progress) {
    if (progressing != progress) {
      setState(() {
        progressing = progress;
      });
    }
  }

  @override
  initState() {
    super.initState();
    loadListing();
  }

  loadListing() {
    loading(true);
    MyApp.listingRepo
        .myListings(MyApp.token)
        .then((WebServiceResult<List<Listing>> value) {
      loading(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          myListings.value = value.data ?? [];

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'fetch listing failed',
              message: value.message, onPressed: () {
            loadListing();
          }, status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  requiredText(String? value) {
    if (value?.isEmpty ?? false) {
      return MyApp.resources.strings.mandatoryField;
    }
    return null;
  }

  submitForm() {
    if (!checkFields([
      _titleFieldForm,
      _codeFieldForm,
      _discountFieldForm,
    ])) {
      return;
    }

    if (widget.coupon.couponStart == null) {
      _startFieldForm.currentState?.setErrot("choose a start date!");
      return;
    }
    if (widget.coupon.couponEnd == null) {
      _endFieldForm.currentState?.setErrot("choose an end date!");
      return;
    }

    if (!checkFields([_descriptionFieldForm])) {
      return;
    }

    progressingButton.currentState?.showProgress(true);

    Future<WebServiceResult<String>> query;

    String titleDialog = 'Create Coupon';
    bool create = true;
    if (widget.coupon.id != 0) {
      create = false;
      query = MyApp.appRepo.updateCoupon(widget.coupon);
      titleDialog = 'Edit Coupon';
    } else {
      query = MyApp.appRepo.createCoupon(widget.coupon);
    }

    query.then((value) {
      progressingButton.currentState?.showProgress(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          if (create) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateCouponScreen(coupon: Coupon())),
            );
          }

          mySnackBar(context,
              title: titleDialog,
              message: value.data ?? '',
              status: SnackBarStatus.success);

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: titleDialog,
              message: value.data ?? '',
              status: SnackBarStatus.error);
          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: progressing
          ? const Center(
              child: MyProgressIndicator(
              color: Colors.orange,
            ))
          : SafeArea(
              child: Stack(
                children: [
                  Positioned(
                      top: 25,
                      left: 16,
                      right: 16,
                      child: HeaderWithBackScren(title: "Create Coupon")),
                  Positioned(
                    top: 90,
                    left: 0,
                    right: 0,
                    bottom: 80,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: myListings,
                                builder: (BuildContext context,
                                    List<Listing> listings, Widget? child) {
                                  if (listings.isNotEmpty &&
                                      (widget.coupon.listingId ?? 0) == 0) {
                                    widget.coupon.listingId = listings.first.id;
                                  }
                                  return ListingSpinnerWidget(
                                    myListings: listings,
                                    selectedListingID: widget.coupon.listingId,
                                    onListingChanged: (Listing listing) {
                                      widget.coupon.listingId = listing.id;
                                    },
                                  );
                                }),
                            const SizedBox(height: 14),
                            MyNormalTextField(
                                initial: widget.coupon.couponTitle,
                                textInputType: TextInputType.text,
                                formFieldeKey: _titleFieldForm,
                                validator: requiredText,
                                hint: "Coupon Title",
                                onSave: (String? text) {
                                  if (text != null) {
                                    widget.coupon.couponTitle = text;
                                  }
                                },
                                textInputAction: TextInputAction.next),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: MyNormalTextField(
                                        initial: widget.coupon.couponCode,
                                        textInputType: TextInputType.text,
                                        validator: requiredText,
                                        formFieldeKey: _codeFieldForm,
                                        hint: "Coupon Code",
                                        onSave: (String? text) {
                                          if (text != null) {
                                            widget.coupon.couponCode = text;
                                          }
                                        },
                                        textInputAction: TextInputAction.next)),
                                SizedBox(
                                  width: 24,
                                ),
                                Expanded(
                                    child: MyNormalTextField(
                                        initial: widget.coupon.discountValue
                                            .toString(),
                                        suffixWidget: Text(
                                          "%",
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              ?.copyWith(
                                                  color: MyApp
                                                      .resources.color.grey2
                                                      .withOpacity(0.7)),
                                        ),
                                        textInputType: TextInputType.number,
                                        formFieldeKey: _discountFieldForm,
                                        validator: requiredText,
                                        hint: "Code discount",
                                        onSave: (String? text) {
                                          if (text != null) {
                                            widget.coupon.discountValue =
                                                double.parse(text);
                                          }
                                        },
                                        textInputAction: TextInputAction.next)),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: DatePickerScreen(
                                  coupon: widget.coupon,
                                  key: _startFieldForm,
                                  title: "Coupon Start",
                                )),
                                const SizedBox(
                                  width: 24,
                                ),
                                Expanded(
                                    child: DatePickerScreen(
                                  type: 1,
                                  key: _endFieldForm,
                                  coupon: widget.coupon,
                                  title: "Coupon End",
                                )),
                              ],
                            ),
                            const SizedBox(height: 14),
                            MyNormalTextField(
                                initial: widget.coupon.couponDescription,
                                textInputType: TextInputType.multiline,
                                formFieldeKey: _descriptionFieldForm,
                                hint: "Coupon Description",
                                maxLines: 6,
                                minLines: 5,
                                validator: requiredText,
                                onSave: (String? text) {
                                  if (text != null) {
                                    widget.coupon.couponDescription = text;
                                  }
                                },
                                textInputAction: TextInputAction.newline),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      height: 80,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: BottomButtons(
                          progressingButton: progressingButton,
                          neutralButtonText: "Back",
                          submitButtonText: "Save",
                          neutralButtonClick: () {
                            Navigator.pop(context);
                          },
                          submitButtonClick: () => submitForm()),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

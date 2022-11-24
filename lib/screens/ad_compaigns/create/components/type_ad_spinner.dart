import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/ads.dart';
import 'package:rakwa/model/createAds.dart';
import 'package:rakwa/screens/ad_compaigns/create/components/step1.dart';
import 'package:rakwa/views/spinner_container.dart';

class AdTypeSpinner extends StatefulWidget {
  AdCampaigns ads;
  AdTypeSpinner({Key? key, required this.ads}) : super(key: key);

  @override
  State<AdTypeSpinner> createState() => _AdTypeSpinnerState();
}

class _AdTypeSpinnerState extends State<AdTypeSpinner> {


  @override
  Widget build(BuildContext context) {
    return DropDownContainer(
        context: context,
        title: "Select type of ad",
        dropdownButton: DropdownButtonHideUnderline(
          child: DropdownButton<AdsType>(
            value: widget.ads.type,
            icon: const Icon(Icons.keyboard_arrow_down),
            onChanged: (AdsType? newValue) {
              if (newValue != null) {
                CreateAdStep1State.adsType.value = newValue;
                widget.ads.type = newValue;
              }
              setState(() {});
            },
            items: AdsType.values
                .map<DropdownMenuItem<AdsType>>((AdsType adsType) {
              return DropdownMenuItem<AdsType>(
                value: adsType,
                child: Text(
                  adsType.adName(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: MyApp.resources.color.colorText),
                ),
              );
            }).toList(),
          ),
        ));
  }
}

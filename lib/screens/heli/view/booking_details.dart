import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/heli/booking_mobel.dart';
import 'package:rideon/widgets/confirm_text_widget.dart';

class BookingDetailsPage extends StatefulWidget {
  final HelicopterBookingModel helicopterBookingModel;
  BookingDetailsPage(this.helicopterBookingModel);
  @override
  _BookingDetailsPageState createState() =>
      _BookingDetailsPageState(this.helicopterBookingModel);
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  HelicopterBookingModel _helicopterBookingModel;
  _BookingDetailsPageState(this._helicopterBookingModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConfirmTextWidget('Starting place',
                  _helicopterBookingModel.fromAddress.formattedAddress ?? ''),
              ConfirmTextWidget('Ending place',
                  _helicopterBookingModel.toAddress.formattedAddress),
              ConfirmTextWidget(
                  "Plan Type",
                  _helicopterBookingModel.type == HeliType.Charter
                      ? 'Charter'
                      : 'Heli Tour'),
              ConfirmTextWidget('Name', _helicopterBookingModel.name),
              ConfirmTextWidget(
                  'Contact Number', _helicopterBookingModel.phone),
              ConfirmTextWidget('Email', _helicopterBookingModel.email),
              if (_helicopterBookingModel.type == HeliType.Charter &&
                  _helicopterBookingModel.noOfAdults != null)
                ConfirmTextWidget(
                    'No of Adults', _helicopterBookingModel.noOfAdults),
              if (_helicopterBookingModel.type == HeliType.Charter &&
                  _helicopterBookingModel.noOfChild != null)
                ConfirmTextWidget(
                    'No of Child', _helicopterBookingModel.noOfChild),
              if (_helicopterBookingModel.type == HeliType.Tour &&
                  _helicopterBookingModel.tourPlane != null)
                ConfirmTextWidget(
                    "Tour Plan", _helicopterBookingModel.tourPlane),
              if (_helicopterBookingModel.details != null)
                ConfirmTextWidget(
                    "Extra Details", _helicopterBookingModel.details),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      child: Padding(
                        padding: bottonPadding,
                        child: Text('Reuest to book', style: bottonStyle),
                      ),
                      onPressed: () {}),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

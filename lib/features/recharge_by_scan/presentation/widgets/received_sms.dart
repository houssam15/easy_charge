import 'package:flutter/material.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/domain/entities/sms.dart';

class ReceivedSms extends StatefulWidget {
  final SmsEntity sms;

  const ReceivedSms({super.key, required this.sms});

  @override
  State<ReceivedSms> createState() => _ReceivedSmsState();
}

class _ReceivedSmsState extends State<ReceivedSms> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.blue.shade50,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sender information
              Text(
                "From: ${widget.sms.sender}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),

              // SMS body
              Text(
                widget.sms.body,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 8.0),

              // Received date
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "Received at: ${widget.sms.receivedAt}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

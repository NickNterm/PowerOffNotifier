import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Πληροφορίες"),
      ),
      body: Html(data: """
<p>Καλωσορίσατε στο <i><b>Power Off Notifier</b></i></p>
<p>Στην αρχική οθονη της εφαρμογή επιλέξτε το νομό της επιλογής σας για να ενημερώνεστε για τις σχετικές διακοπές ρεύματος.</p>
<p>Επειτα θα σας αποστέλνονται ειδοποίσεις ειδικά για τον νομό σας</p>
<p>Τα δεδομένα της εφαρμογής περισυλλέγονται απο το σαιτ <a>https://siteapps.deddie.gr/Outages2Public</a></p>
"""),
    );
  }
}

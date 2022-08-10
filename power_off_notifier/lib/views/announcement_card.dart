import 'package:flutter/material.dart';
import 'package:power_off_notifier/constants/colors.dart';
import 'package:power_off_notifier/constants/values.dart';

import '../models/announcement.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    Key? key,
    required this.announcement,
  }) : super(key: key);

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(kAnnouncementCardPadding),
          margin: const EdgeInsets.all(kAnnouncementCardMargin),
          decoration: BoxDecoration(
            color: kElevatedColor,
            boxShadow: [
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-5, -5),
                blurRadius: 5,
              ),
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                offset: const Offset(5, 5),
                blurRadius: 5,
              )
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(kAnnouncementCardPrimaryBorderRadius),
              topRight: Radius.circular(kAnnouncementCardPrimaryBorderRadius),
              bottomLeft: Radius.circular(kAnnouncementCardPrimaryBorderRadius),
              bottomRight: Radius.circular(kAnnouncementCardSmallBorderRadius),
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const BoldText(text: "Νομος "),
                Text(announcement.department),
                const Spacer(),
                const BoldText(text: "Δήμος "),
                Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.4),
                    child: Text(
                      announcement.municipality,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ))
              ],
            ),
            const SizedBox(height: kAnnouncementCardTextHeigthSpace),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BoldText(
                  text: "Περιγραφή",
                ),
                Text(announcement.description)
              ],
            ),
            const SizedBox(height: kAnnouncementCardTextHeigthSpace),
            Row(children: [
              const BoldText(text: "Από "),
              Text(announcement.startDate)
            ]),
            Row(children: [
              const BoldText(text: "Έως "),
              Text(announcement.endDate)
            ]),
          ]),
        ),
        Positioned(
          bottom: 15,
          right: 18,
          child: Row(
            children: [
              Text(
                announcement.type,
                style: const TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 12),
              ),
              const SizedBox(width: 5),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: announcement.color,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class BoldText extends StatelessWidget {
  const BoldText({
    required this.text,
    Key? key,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

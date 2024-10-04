import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String imgUrl;
  final String commonName;
  final String officialName; 
  final String currencyName;

  const CardWidget({
    super.key,
    required this.imgUrl,
    required this.commonName,
    required this.officialName,
    required this.currencyName,
  });

  @override
  Widget build(BuildContext context) {

    TextStyle labelStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );


    TextStyle contentStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Color.fromARGB(255, 91, 91, 91),
    );

    return SizedBox(
      height: 130,
      width: double.infinity,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: Image.network(
                    imgUrl,
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, color: Colors.red);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
            Expanded(
    
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      truncateText(commonName, 19),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Official Name: ', style: labelStyle),
                        Expanded(
                          child: Text(
                            truncateText(officialName, 23),
                            style: contentStyle,
                            softWrap: true, // Allow text to wrap
                            overflow: TextOverflow
                                .visible, // Ensure text flows correctly
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('Currency: ', style: labelStyle),
                        Expanded(
                          child: Text(
                            truncateText(currencyName, 30),
                            style: contentStyle,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }
}

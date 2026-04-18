import 'dart:io';

void main() {
  final file = File(r'c:\Users\Acer\Downloads\flomart-pemmob\flomart_pemmob\lib\pages\blog.dart');
  var content = file.readAsStringSync();
  
  // Normalisasi baris ganti untuk mempermudah replacement
  final normalized = content.replaceAll('\r\n', '\n');
  
  final target = '''            GestureDetector(
              onTap: () => _openArticleDetail(BlogPage._heroArticle),
              child: const Text(
                'Baca Lebih Lanjut',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: BlogPage.primaryGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );''';
    
  final replacement = '''            const Text(
              'Baca Lebih Lanjut',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: BlogPage.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    ));''';

  final newContent = normalized.replaceFirst(target, replacement);
  
  file.writeAsStringSync(newContent);
}

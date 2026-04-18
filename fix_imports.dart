import 'dart:io';

void main() {
  final directories = ['auth', 'blog', 'toko', 'jualan', 'info', 'beranda'];
  final basePath = r'c:\Users\Acer\Downloads\flomart-pemmob\flomart_pemmob\lib\pages';
  
  final fileMap = {
    'login.dart': 'auth',
    'registrasi.dart': 'auth',
    'blog.dart': 'blog',
    'blog_detail.dart': 'blog',
    'toko.dart': 'toko',
    'profil_seller.dart': 'toko',
    'mulai_jualan.dart': 'jualan',
    'tentang_kami.dart': 'info',
    'beranda.dart': 'beranda',
  };
  
  for (final dirName in directories) {
    final dir = Directory('$basePath\\$dirName');
    if (!dir.existsSync()) continue;
    
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        var content = entity.readAsStringSync();
        
        // Fix relative imports up one level
        content = content.replaceAll("import '../widgets/", "import '../../widgets/");
        content = content.replaceAll("import '../app_routes.dart'", "import '../../app_routes.dart'");
        
        // Fix previously hardcoded beranda fix
        content = content.replaceAll("import 'beranda/beranda.dart'", "import '../beranda/beranda.dart'");
        
        fileMap.forEach((fileName, targetDir) {
          final replacement = targetDir == dirName ? fileName : '../$targetDir/$fileName';
          content = content.replaceAll("import '$fileName';", "import '$replacement';");
        });
        
        // Special case for detail_produk.dart since there are two of them
        // If we are in toko, we want the one in toko
        // In other places, they might want the beranda one or toko one.
        // Actually, in the old structure, everyone imported detail_produk.dart from lib/pages/
        // which is now in toko/
        final detailReplacement = 'toko' == dirName ? 'detail_produk.dart' : '../toko/detail_produk.dart';
        content = content.replaceAll("import 'detail_produk.dart';", "import '$detailReplacement';");
        
        entity.writeAsStringSync(content);
      }
    }
  }
  
  // Fix imports in lib/widgets if any
  final widgetsDir = Directory(r'c:\Users\Acer\Downloads\flomart-pemmob\flomart_pemmob\lib\widgets');
  if (widgetsDir.existsSync()) {
    for (final entity in widgetsDir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        var content = entity.readAsStringSync();
        fileMap.forEach((fileName, targetDir) {
          content = content.replaceAll("import '../pages/$fileName';", "import '../pages/$targetDir/$fileName';");
        });
        content = content.replaceAll("import '../pages/detail_produk.dart';", "import '../pages/toko/detail_produk.dart';");
        entity.writeAsStringSync(content);
      }
    }
  }
}
